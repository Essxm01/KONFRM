/**
 * KONFRM Auth V2 QA bootstrap contract.
 *
 * Runs only against a disposable local PostgreSQL database. It creates no
 * Supabase project and never connects to a remote/Supabase production target.
 */

import assert from 'node:assert';
import { randomUUID } from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import pg from 'pg';
import { AuthService } from '../services/authService.js';
import {
  PostgresAuthChallengeRepository,
  PostgresAuthRateLimitRepository,
  PostgresUserIdentifierRepository,
  hashRefreshToken,
} from '../services/authV2Repository.js';
import { AuthV2Service } from '../services/authV2Service.js';
import { computeChallengeOtpDigest } from '../services/otpSecurity.js';
import { sessionDb, userDb } from '../services/dbRepository.js';
import { assertSafeTestDatabaseUrl, isProductionDatabase } from '../utils/testDbGuard.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ISOLATED_PG_URL = process.env.ISOLATED_PG_URL || 'postgresql://postgres:postgres@127.0.0.1:54329/sola_auth_v2_qa_test';
const QA_ACCESS_SECRET = 'qa-bootstrap-access-secret-not-a-production-secret-32';
const QA_REFRESH_SECRET = 'qa-bootstrap-refresh-secret-not-a-production-secret-32';
const QA_HMAC_SECRET = 'qa-bootstrap-hmac-secret-not-a-production-secret-32';
const QA_FIXED_OTP = '123456';

type Result = { name: string; passed: boolean; error?: string };

function readRepoFile(relativePath: string): string {
  return fs.readFileSync(path.resolve(__dirname, relativePath), 'utf8');
}

async function expectRejected(action: () => Promise<unknown>, message: string): Promise<void> {
  await assert.rejects(action, undefined, message);
}

async function createLocalRoles(client: pg.PoolClient): Promise<void> {
  await client.query(`
    DO $$
    BEGIN
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN CREATE ROLE anon NOLOGIN; END IF;
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN CREATE ROLE authenticated NOLOGIN; END IF;
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN CREATE ROLE service_role NOLOGIN BYPASSRLS; END IF;
    END
    $$;
    ALTER ROLE service_role BYPASSRLS;
  `);
}

async function assertOrdinaryRoleDenied(client: pg.PoolClient, role: 'anon' | 'authenticated'): Promise<void> {
  await client.query(`SET ROLE ${role}`);
  try {
    await expectRejected(
      () => client.query('SELECT id FROM public.auth_challenges LIMIT 1'),
      `${role} must not read Auth V2 tables`,
    );
    await expectRejected(
      () => client.query(`INSERT INTO public.auth_rate_limits (bucket_key, window_start) VALUES ('forbidden', NOW())`),
      `${role} must not write Auth V2 tables`,
    );
    await expectRejected(
      () => client.query('SELECT * FROM public.konfrm_check_rate_limit_v2($1, $2, $3)', ['forbidden', 60, 1]),
      `${role} must not execute restricted Auth V2 RPCs`,
    );
  } finally {
    await client.query('RESET ROLE');
  }
}

export async function runAuthV2QaBootstrapSuite(): Promise<{ total: number; passed: number; failed: number; results: Result[] }> {
  const results: Result[] = [];
  const record = async (name: string, action: () => Promise<void>): Promise<void> => {
    try {
      await action();
      results.push({ name, passed: true });
    } catch (error: any) {
      results.push({ name, passed: false, error: error?.message || String(error) });
    }
  };

  assertSafeTestDatabaseUrl(ISOLATED_PG_URL, 'AuthV2QaBootstrap');

  const originalEnv = {
    databaseUrl: process.env.DATABASE_URL,
    supabaseUrl: process.env.SUPABASE_URL,
    supabaseSecret: process.env.SUPABASE_SECRET_KEY,
    supabaseService: process.env.SUPABASE_SERVICE_ROLE_KEY,
    nodeEnv: process.env.NODE_ENV,
    accessSecret: process.env.JWT_ACCESS_SECRET,
    refreshSecret: process.env.JWT_REFRESH_SECRET,
  };

  process.env.DATABASE_URL = ISOLATED_PG_URL;
  delete process.env.SUPABASE_URL;
  delete process.env.SUPABASE_SECRET_KEY;
  delete process.env.SUPABASE_SERVICE_ROLE_KEY;
  process.env.NODE_ENV = 'test';
  process.env.JWT_ACCESS_SECRET = QA_ACCESS_SECRET;
  process.env.JWT_REFRESH_SECRET = QA_REFRESH_SECRET;

  if (isProductionDatabase()) {
    throw new Error('REFUSING_TEST_EXECUTION_AGAINST_PRODUCTION_DB');
  }

  const pool = new pg.Pool({ connectionString: ISOLATED_PG_URL, max: 16, connectionTimeoutMillis: 5000 });

  try {
    await record('Fresh empty start: public schema is reset only after the local-target guard passes', async () => {
      const client = await pool.connect();
      try {
        await client.query('DROP SCHEMA public CASCADE; CREATE SCHEMA public;');
        const tables = await client.query(`SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'`);
        assert.strictEqual(tables.rows.length, 0, 'QA database must begin with an empty public schema');
        await createLocalRoles(client);
      } finally {
        client.release();
      }
    });

    await record('QA baseline: applies outside migrations with no fabricated migration history', async () => {
      const baselinePath = path.resolve(__dirname, '../../../database/qa_baseline.sql');
      const baseline = fs.readFileSync(baselinePath, 'utf8');
      assert.match(baseline, /AUTH_QA_MINIMAL_BASELINE/);
      assert.match(baseline, /DO NOT APPLY TO PRODUCTION/);
      assert.ok(!baseline.includes("INSERT INTO public.schema_migrations"), 'QA baseline must not represent fake migration history');
      assert.ok(!baseline.includes('CREATE ROLE anon'), 'Supabase roles must not be created by QA baseline');
      assert.ok(!baseline.includes('CREATE TABLE IF NOT EXISTS public.bookings'), 'QA baseline must exclude unrelated domains');

      const client = await pool.connect();
      try {
        await client.query(baseline);
        const history = await client.query('SELECT version FROM public.schema_migrations');
        assert.strictEqual(history.rows.length, 0, 'baseline must not record historic migration versions');
      } finally {
        client.release();
      }
    });

    await record('Pre-031 structure: AUTH_CRITICAL_STRUCTURAL_EQUIVALENCE with EXPECTED_QA_SECURITY_HARDENING', async () => {
      const client = await pool.connect();
      try {
        const columns = await client.query(`
          SELECT table_name, column_name, data_type, is_nullable, column_default, character_maximum_length
          FROM information_schema.columns
          WHERE table_schema = 'public'
            AND table_name IN ('schema_migrations', 'users', 'owners', 'user_sessions')
        `);
        const column = (table: string, name: string) => columns.rows.find((r) => r.table_name === table && r.column_name === name);
        assert.strictEqual(column('schema_migrations', 'version')?.character_maximum_length, 100);
        assert.strictEqual(column('users', 'id')?.data_type, 'uuid');
        assert.strictEqual(column('users', 'phone_number')?.data_type, 'character varying');
        assert.strictEqual(column('users', 'phone_number')?.is_nullable, 'NO');
        assert.match(String(column('users', 'status')?.column_default), /ACTIVE/);
        assert.strictEqual(column('owners', 'owner_onboarding_completed_at')?.data_type, 'timestamp with time zone');
        assert.match(String(column('owners', 'id')?.column_default), /gen_random_uuid\(\)/i);
        assert.strictEqual(column('user_sessions', 'user_id')?.is_nullable, 'NO');
        assert.strictEqual(column('user_sessions', 'owner_id')?.is_nullable, 'YES');
        assert.strictEqual(column('user_sessions', 'refresh_token_hash')?.is_nullable, 'NO');
        assert.strictEqual(column('user_sessions', 'surface')?.is_nullable, 'NO');
        assert.strictEqual(column('user_sessions', 'role')?.is_nullable, 'NO');
        assert.strictEqual(column('user_sessions', 'updated_at')?.is_nullable, 'NO');

        const constraints = await client.query(`
          SELECT conname, pg_get_constraintdef(c.oid) AS definition
          FROM pg_constraint c
          JOIN pg_namespace n ON n.oid = c.connamespace
          WHERE n.nspname = 'public'
            AND c.conrelid IN ('public.users'::regclass, 'public.owners'::regclass, 'public.user_sessions'::regclass)
        `);
        const definition = (name: string) => String(constraints.rows.find((r) => r.conname === name)?.definition || '');
        assert.match(definition('owners_id_fkey'), /ON DELETE RESTRICT/);
        assert.match(definition('user_sessions_owner_user_same_uuid_check'), /owner_id IS NULL/);
        assert.match(definition('user_sessions_owner_user_same_uuid_check'), /owner_id = user_id/);
        assert.match(definition('user_sessions_owner_role_requires_owner_check'), /ROLE_OWNER/);

        const indexes = await client.query(`SELECT tablename, indexname FROM pg_indexes WHERE schemaname = 'public' AND tablename IN ('users', 'owners', 'user_sessions')`);
        const names = new Set(indexes.rows.map((r) => r.indexname));
        const expectedIndexes = new Set([
          'users_pkey', 'users_phone_number_key', 'idx_users_phone', 'idx_users_status',
          'owners_pkey', 'owners_phone_number_key',
          'user_sessions_pkey', 'uq_user_sessions_refresh_token_hash', 'idx_user_sessions_active_user_surface',
          'idx_user_sessions_owner', 'idx_user_sessions_refresh_token_hash',
        ]);
        assert.deepStrictEqual([...names].sort(), [...expectedIndexes].sort(), 'Auth-critical index set must match the approved equivalence contract');
        assert.ok(!names.has('idx_owners_phone'), 'QA baseline must not invent an owners phone index');

        const rls = await client.query(`SELECT relname, relrowsecurity FROM pg_class WHERE oid IN ('public.schema_migrations'::regclass, 'public.users'::regclass, 'public.owners'::regclass, 'public.user_sessions'::regclass)`);
        assert.ok(rls.rows.every((r) => r.relrowsecurity === true), 'baseline tables must have RLS enabled');

        const grants = await client.query(`
          SELECT grantee, table_name, privilege_type FROM information_schema.role_table_grants
          WHERE table_schema = 'public' AND table_name IN ('users', 'owners', 'user_sessions')
        `);
        assert.ok(grants.rows.some((r) => r.grantee === 'service_role' && r.table_name === 'user_sessions' && r.privilege_type === 'INSERT'));
        // Production ACLs are broader, but the dedicated QA baseline intentionally
        // hardens Auth persistence exposure. This is EXPECTED_QA_SECURITY_HARDENING,
        // not a claim of byte-for-byte production ACL equality.
        assert.ok(!grants.rows.some((r) => (r.grantee === 'anon' || r.grantee === 'authenticated') && r.privilege_type !== ''));

        const ownerUserId = randomUUID();
        const otherUserId = randomUUID();
        await client.query(
          `INSERT INTO public.users (id, phone_number, full_name) VALUES
            ($1, '+201011110010', 'Synthetic Owner'),
            ($2, '+201011110011', 'Synthetic Customer')`,
          [ownerUserId, otherUserId],
        );
        await client.query(
          `INSERT INTO public.owners (id, phone_number, full_name) VALUES ($1, '+201011110010', 'Synthetic Owner')`,
          [ownerUserId],
        );
        await client.query(
          `INSERT INTO public.user_sessions (id, user_id, owner_id, surface, role, refresh_token_hash, expires_at)
          VALUES ($1, $2, $2, 'OWNER', 'ROLE_OWNER', 'qa-unique-refresh-hash', NOW() + interval '1 day')`,
          [randomUUID(), ownerUserId],
        );
        await expectRejected(
          () => client.query(`INSERT INTO public.user_sessions (id, user_id, owner_id, surface, role, refresh_token_hash, expires_at) VALUES ($1, $2, $3, 'OWNER', 'ROLE_OWNER', 'qa-owner-mismatch', NOW() + interval '1 day')`, [randomUUID(), otherUserId, ownerUserId]),
          'ROLE_OWNER session must use the matching Owner capability UUID',
        );
        await expectRejected(
          () => client.query(`INSERT INTO public.user_sessions (id, user_id, owner_id, surface, role, refresh_token_hash, expires_at) VALUES ($1, $2, NULL, 'OWNER', 'ROLE_OWNER', 'qa-owner-missing', NOW() + interval '1 day')`, [randomUUID(), otherUserId]),
          'ROLE_OWNER session must require an Owner capability',
        );
        await expectRejected(
          () => client.query(`INSERT INTO public.user_sessions (id, user_id, surface, role, refresh_token_hash, expires_at) VALUES ($1, $2, 'CUSTOMER', 'ROLE_CUSTOMER', 'qa-unique-refresh-hash', NOW() + interval '1 day')`, [randomUUID(), otherUserId]),
          'refresh token hash must be unique',
        );
      } finally {
        client.release();
      }
    });

    await record('Migration 031: applies unchanged, records only itself, and creates restricted Auth V2 structures', async () => {
      const migrationPath = path.resolve(__dirname, '../../../database/migrations/031_auth_v2_identity_and_challenges.sql');
      const migration = fs.readFileSync(migrationPath, 'utf8');
      assert.match(migration, /031_auth_v2_identity_and_challenges\.sql/);
      const client = await pool.connect();
      try {
        await client.query(migration);
        const history = await client.query('SELECT version FROM public.schema_migrations ORDER BY version');
        assert.deepStrictEqual(history.rows.map((r) => r.version), ['031_auth_v2_identity_and_challenges.sql']);
        const tables = await client.query(`SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('user_identifiers', 'auth_challenges', 'auth_rate_limits')`);
        assert.deepStrictEqual(new Set(tables.rows.map((r) => r.table_name)), new Set(['user_identifiers', 'auth_challenges', 'auth_rate_limits']));
        const functions = await client.query(`SELECT proname FROM pg_proc WHERE pronamespace = 'public'::regnamespace AND proname LIKE 'konfrm_%auth_challenge_v2' OR pronamespace = 'public'::regnamespace AND proname IN ('konfrm_check_rate_limit_v2', 'konfrm_acquire_resend_lease_v2', 'konfrm_commit_resend_v2', 'konfrm_release_resend_lease_v2')`);
        assert.ok(functions.rows.length >= 5, 'required Auth V2 RPCs must exist');
      } finally {
        client.release();
      }
    });

    await record('Auth V2 security: ordinary roles are denied while local service_role can use the restricted path', async () => {
      const client = await pool.connect();
      try {
        await assertOrdinaryRoleDenied(client, 'anon');
        await assertOrdinaryRoleDenied(client, 'authenticated');
        await client.query('SET ROLE service_role');
        try {
          const allowed = await client.query('SELECT * FROM public.konfrm_check_rate_limit_v2($1, $2, $3)', [`qa-service-${randomUUID()}`, 60, 1]);
          assert.strictEqual(allowed.rows[0].allowed, true);
        } finally {
          await client.query('RESET ROLE');
        }
      } finally {
        client.release();
      }
    });

    await record('Current Auth schema: applies Auth-relevant migrations 032 and 034 after verified 031 checkpoint', async () => {
      const client = await pool.connect();
      try {
        // 1. Apply Migration 032 from source-controlled file
        const migration032 = readRepoFile('../../../database/migrations/032_customer_email_first_nullable_phone.sql');
        await client.query(migration032);

        // Verify Migration 032 real effect on PostgreSQL
        const phoneCol = await client.query(`
          SELECT is_nullable FROM information_schema.columns
          WHERE table_schema = 'public' AND table_name = 'users' AND column_name = 'phone_number'
        `);
        assert.strictEqual(phoneCol.rows[0]?.is_nullable, 'YES', 'users.phone_number must be nullable after Migration 032');

        const fn032 = await client.query(`
          SELECT proname FROM pg_proc
          WHERE pronamespace = 'public'::regnamespace AND proname = 'konfrm_create_email_customer_v2'
        `);
        assert.strictEqual(fn032.rows.length, 1, 'konfrm_create_email_customer_v2 function must exist after Migration 032');

        // 2. Apply Migration 034 from source-controlled file
        const migration034 = readRepoFile('../../../database/migrations/034_customer_verified_email_linking.sql');
        await client.query(migration034);

        // Verify truthful migration history (031, 032, 034 applied; 033 omitted because minimal baseline excludes bookings/properties)
        const history = await client.query('SELECT version FROM public.schema_migrations ORDER BY version');
        assert.deepStrictEqual(
          history.rows.map((r) => r.version),
          [
            '031_auth_v2_identity_and_challenges.sql',
            '032_customer_email_first_nullable_phone.sql',
            '034_customer_verified_email_linking.sql',
          ],
          'schema_migrations must contain exactly 031, 032, and 034'
        );
        assert.ok(
          !history.rows.some((r) => r.version.includes('033')),
          'Migration 033 must not be present in minimal Auth QA baseline history'
        );

        // 3. Verify Migration 034 real effect on PostgreSQL
        // A. auth_challenges.subject_user_id exists and is UUID
        const subjectCol = await client.query(`
          SELECT data_type FROM information_schema.columns
          WHERE table_schema = 'public' AND table_name = 'auth_challenges' AND column_name = 'subject_user_id'
        `);
        assert.strictEqual(subjectCol.rows.length, 1, 'auth_challenges.subject_user_id must exist after Migration 034');
        assert.strictEqual(subjectCol.rows[0]?.data_type, 'uuid');

        // B. Intent constraint permits LOGIN, CREATE_ACCOUNT, LINK_IDENTIFIER
        const intentCheck = await client.query(`
          SELECT pg_get_constraintdef(c.oid) AS definition
          FROM pg_constraint c
          JOIN pg_namespace n ON n.oid = c.connamespace
          WHERE n.nspname = 'public' AND c.conrelid = 'public.auth_challenges'::regclass AND c.conname = 'auth_challenges_intent_check'
        `);
        assert.match(intentCheck.rows[0]?.definition || '', /LINK_IDENTIFIER/);

        // C. subject_user_id constraint enforces LINK_IDENTIFIER NOT NULL and LOGIN/CREATE_ACCOUNT NULL
        const subjectCheck = await client.query(`
          SELECT pg_get_constraintdef(c.oid) AS definition
          FROM pg_constraint c
          JOIN pg_namespace n ON n.oid = c.connamespace
          WHERE n.nspname = 'public' AND c.conrelid = 'public.auth_challenges'::regclass AND c.conname = 'chk_auth_challenges_subject_user_id'
        `);
        const subDef = subjectCheck.rows[0]?.definition || '';
        assert.match(subDef, /LINK_IDENTIFIER.*subject_user_id IS NOT NULL/s);
        assert.match(subDef, /subject_user_id IS NULL/s);

        // D. uq_user_identifiers_user_type exists and is unique on (user_id, identifier_type)
        const uqUserType = await client.query(`
          SELECT indexname FROM pg_indexes
          WHERE schemaname = 'public' AND tablename = 'user_identifiers' AND indexname = 'uq_user_identifiers_user_type'
        `);
        assert.strictEqual(uqUserType.rows.length, 1, 'uq_user_identifiers_user_type index must exist');

        // E. Existing canonical unique index remains on (identifier_type, normalized_value)
        const uqTypeValue = await client.query(`
          SELECT indexname FROM pg_indexes
          WHERE schemaname = 'public' AND tablename = 'user_identifiers' AND indexname = 'uq_user_identifiers_type_value'
        `);
        assert.strictEqual(uqTypeValue.rows.length, 1, 'uq_user_identifiers_type_value must remain');

        // F. Function exists: public.konfrm_link_verified_email_identifier_v1(UUID, UUID)
        const fn034 = await client.query(`
          SELECT proname FROM pg_proc
          WHERE pronamespace = 'public'::regnamespace AND proname = 'konfrm_link_verified_email_identifier_v1'
        `);
        assert.strictEqual(fn034.rows.length, 1, 'konfrm_link_verified_email_identifier_v1 must exist');

        // 4. Security privilege validation on konfrm_link_verified_email_identifier_v1 (Section 11)
        await client.query('SET ROLE anon');
        try {
          await expectRejected(
            () => client.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [randomUUID(), randomUUID()]),
            'anon must not execute konfrm_link_verified_email_identifier_v1'
          );
        } finally {
          await client.query('RESET ROLE');
        }

        await client.query('SET ROLE authenticated');
        try {
          await expectRejected(
            () => client.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [randomUUID(), randomUUID()]),
            'authenticated must not execute konfrm_link_verified_email_identifier_v1'
          );
        } finally {
          await client.query('RESET ROLE');
        }

        const svcPerm = await client.query(`
          SELECT has_function_privilege('service_role', 'public.konfrm_link_verified_email_identifier_v1(uuid, uuid)', 'EXECUTE') AS allowed
        `);
        assert.strictEqual(svcPerm.rows[0]?.allowed, true, 'service_role must have EXECUTE on konfrm_link_verified_email_identifier_v1');
      } finally {
        client.release();
      }
    });

    await record('Actual repositories: PHONE/EMAIL lookup, challenge persistence, rate-limit persistence, and no plaintext OTP', async () => {
      const client = await pool.connect();
      const userId = randomUUID();
      try {
        await client.query(`INSERT INTO public.users (id, phone_number, full_name) VALUES ($1, $2, 'Synthetic QA User')`, [userId, '+201011110001']);
      } finally {
        client.release();
      }

      const identifiers = new PostgresUserIdentifierRepository();
      const challenges = new PostgresAuthChallengeRepository();
      const rates = new PostgresAuthRateLimitRepository();
      await identifiers.create({ userId, identifierType: 'PHONE', normalizedValue: '+201011110001', verifiedAt: new Date().toISOString() });
      await identifiers.create({ userId, identifierType: 'EMAIL', normalizedValue: 'qa-user@example.test', verifiedAt: new Date().toISOString() });
      assert.strictEqual((await identifiers.getByIdentifier('PHONE', '+201011110001'))?.userId, userId);
      assert.strictEqual((await identifiers.getByIdentifier('EMAIL', 'qa-user@example.test'))?.userId, userId);

      const challengeId = randomUUID();
      const digest = computeChallengeOtpDigest(QA_HMAC_SECRET, challengeId, 1, '+201011110001', QA_FIXED_OTP);
      await challenges.create({
        id: challengeId, surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', normalizedValue: '+201011110001', otpDigest: digest,
        otpExpiresAt: new Date(Date.now() + 300000).toISOString(), challengeExpiresAt: new Date(Date.now() + 600000).toISOString(), resendAvailableAt: new Date(Date.now() - 1000).toISOString(),
      });
      const savedLogin = await challenges.getById(challengeId);
      assert.strictEqual(savedLogin?.otpDigest, digest);
      assert.strictEqual(savedLogin?.subjectUserId, null, 'LOGIN challenge must persist with null subject_user_id');

      // Test LINK_IDENTIFIER challenge persistence with bound Customer ID (Section 12)
      const linkChallengeId = randomUUID();
      const linkDigest = computeChallengeOtpDigest(QA_HMAC_SECRET, linkChallengeId, 1, 'qa-link-repo@example.test', QA_FIXED_OTP);
      await challenges.create({
        id: linkChallengeId, surface: 'CUSTOMER', intent: 'LINK_IDENTIFIER', method: 'EMAIL', normalizedValue: 'qa-link-repo@example.test', otpDigest: linkDigest,
        otpExpiresAt: new Date(Date.now() + 300000).toISOString(), challengeExpiresAt: new Date(Date.now() + 600000).toISOString(), resendAvailableAt: new Date(Date.now() - 1000).toISOString(),
        subjectUserId: userId,
      });
      const savedLink = await challenges.getById(linkChallengeId);
      assert.strictEqual(savedLink?.otpDigest, linkDigest);
      assert.strictEqual(savedLink?.subjectUserId, userId, 'LINK_IDENTIFIER challenge must persist with bound subject_user_id');

      const rateBucket = `qa-rate-${randomUUID()}`;
      const firstRate = await rates.checkAndIncrement(rateBucket, 60, 1);
      const secondRate = await rates.checkAndIncrement(rateBucket, 60, 1);
      assert.strictEqual(firstRate.allowed, true);
      assert.strictEqual(secondRate.allowed, false, 'same bucket must persist and reject the next request at its limit');
      const noPlaintext = await pool.query('SELECT otp_digest FROM public.auth_challenges WHERE id = $1', [challengeId]);
      assert.notStrictEqual(noPlaintext.rows[0].otp_digest, QA_FIXED_OTP);
      const migration = readRepoFile('../../../database/migrations/031_auth_v2_identity_and_challenges.sql');
      const baseline = readRepoFile('../../../database/qa_baseline.sql');
      assert.ok(!migration.includes(QA_FIXED_OTP), 'Migration schema must not contain a fixed OTP');
      assert.ok(!baseline.includes('zrbmbjgcsowfqklmxbyn') && !migration.includes('zrbmbjgcsowfqklmxbyn'), 'QA artifacts must not contain a production project reference');
    });

    await record('Actual PostgreSQL concurrency: verify, resend lease, and consume have exactly one winner', async () => {
      const challenges = new PostgresAuthChallengeRepository();
      const verifyId = randomUUID();
      const verifyDigest = computeChallengeOtpDigest(QA_HMAC_SECRET, verifyId, 1, '+201011110001', QA_FIXED_OTP);
      await challenges.create({ id: verifyId, surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', normalizedValue: '+201011110001', otpDigest: verifyDigest, otpExpiresAt: new Date(Date.now() + 300000).toISOString(), challengeExpiresAt: new Date(Date.now() + 600000).toISOString(), resendAvailableAt: new Date(Date.now() - 1000).toISOString() });
      const verifyResults = await Promise.all(Array.from({ length: 5 }, () => challenges.atomicVerify(verifyId, verifyDigest)));
      assert.strictEqual(verifyResults.filter((result) => result.success).length, 1, 'verification must have one database winner');

      const consumeResults = await Promise.allSettled(Array.from({ length: 5 }, () => challenges.markConsumed(verifyId)));
      assert.strictEqual(consumeResults.filter((result) => result.status === 'fulfilled').length, 1, 'challenge consumption must have one database winner');
      assert.ok(consumeResults.filter((result) => result.status === 'rejected').every((result) => String((result as PromiseRejectedResult).reason?.message).includes('CONTINUATION_ALREADY_CONSUMED')));

      const resendId = randomUUID();
      await challenges.create({ id: resendId, surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', normalizedValue: '+201011110001', otpDigest: 'digest-before-resend', otpExpiresAt: new Date(Date.now() + 300000).toISOString(), challengeExpiresAt: new Date(Date.now() + 600000).toISOString(), resendAvailableAt: new Date(Date.now() - 1000).toISOString() });
      const leases = await Promise.all(Array.from({ length: 5 }, () => challenges.acquireResendLease(resendId, 30)));
      const winner = leases.filter((lease) => lease.success);
      assert.strictEqual(winner.length, 1, 'resend lease must have one database winner');
      await challenges.releaseResendLease(resendId, winner[0].leaseToken!);
      const secondLease = await challenges.acquireResendLease(resendId, 30);
      assert.strictEqual(secondLease.success, true);
      const committed = await challenges.commitResend(resendId, secondLease.leaseToken!, 'digest-after-resend', 2, 60);
      assert.strictEqual(committed.success, true);
    });

    await record('Actual Auth V2 service and canonical session path: continuation replay rejects; persisted session refreshes then revokes', async () => {
      const identifiers = new PostgresUserIdentifierRepository();
      const challenges = new PostgresAuthChallengeRepository();
      const rates = new PostgresAuthRateLimitRepository();
      const delivery = { name: 'qa-bootstrap', method: 'PHONE' as const, sendOtp: async () => undefined };
      const authV2 = new AuthV2Service({
        userIdentifierRepo: identifiers,
        challengeRepo: challenges,
        rateLimitRepo: rates,
        userRepo: userDb,
        sessionRepo: sessionDb as any,
        smsAdapter: delivery,
        emailAdapter: delivery,
        config: { nodeEnv: 'test', authEnv: 'test', deliveryMode: 'DEVELOPMENT_FIXED_OTP', developmentOtp: QA_FIXED_OTP, hmacSecret: QA_HMAC_SECRET },
      });
      const phone = `010${String(Math.floor(Math.random() * 90000000) + 10000000)}`;
      const issued = await authV2.requestChallenge({ surface: 'CUSTOMER', intent: 'CREATE_ACCOUNT', method: 'PHONE', identifier: phone, ipAddress: '127.0.0.1' });
      const verified = await authV2.verifyChallenge({ challengeId: issued.challengeId, otp: QA_FIXED_OTP, deviceInfo: 'qa-bootstrap', ipAddress: '127.0.0.1' });
      assert.ok(verified.continuationToken, 'new identifier must produce a continuation token');
      const complete = () => authV2.completeAccountCreation({ continuationToken: verified.continuationToken!, fullName: 'Synthetic QA Customer', deviceInfo: 'qa-bootstrap', ipAddress: '127.0.0.1' });
      const completions = await Promise.allSettled([complete(), complete()]);
      const successful = completions.filter((result): result is PromiseFulfilledResult<Awaited<ReturnType<typeof complete>>> => result.status === 'fulfilled');
      assert.strictEqual(successful.length, 1, 'continuation replay must create one user/session only');
      assert.ok(completions.some((result) => result.status === 'rejected' && String((result as PromiseRejectedResult).reason?.message).includes('CONTINUATION_ALREADY_CONSUMED')));

      const tokens = successful[0].value.tokens;
      const stored = await sessionDb.getByRefreshTokenHash(hashRefreshToken(tokens.refreshToken));
      assert.ok(stored && stored.userId === successful[0].value.user.id && stored.surface === 'CUSTOMER' && stored.role === 'ROLE_CUSTOMER');
      const canonicalAuth = new AuthService(undefined, sessionDb, userDb);
      const refreshed = await canonicalAuth.refreshSession(tokens.refreshToken);
      assert.ok(refreshed.accessToken, 'canonical refresh must use the persisted session');
      await canonicalAuth.revokeSession(tokens.refreshToken);
      await expectRejected(() => canonicalAuth.refreshSession(tokens.refreshToken), 'revoked session must not refresh');
    });

    await record('Real PostgreSQL Migration 034: Email link RPC, single link, mirror update, and add-only rejection', async () => {
      const client = await pool.connect();
      try {
        const customerA = randomUUID();
        const phone = '+201099991111';
        const emailA = 'link-a@konfrm.test';
        const emailB = 'link-b@konfrm.test';

        // Customer A: has canonical PHONE identifier, no EMAIL identifier
        await client.query(`INSERT INTO public.users (id, phone_number, full_name, status) VALUES ($1, $2, 'Customer A', 'ACTIVE')`, [customerA, phone]);
        await client.query(
          `INSERT INTO public.user_identifiers (id, user_id, identifier_type, normalized_value, verified_at) VALUES ($1, $2, 'PHONE', $3, NOW())`,
          [randomUUID(), customerA, phone]
        );

        // Count users before link
        const usersBefore = await client.query('SELECT COUNT(*) FROM public.users');

        // Create LINK_IDENTIFIER / EMAIL challenge bound to Customer A
        const challengeA = randomUUID();
        const digestA = computeChallengeOtpDigest(QA_HMAC_SECRET, challengeA, 1, emailA, QA_FIXED_OTP);
        await client.query(
          `INSERT INTO public.auth_challenges (
            id, surface, intent, method, normalized_value, otp_digest, generation,
            issued_at, otp_expires_at, challenge_expires_at, resend_available_at,
            failed_attempts, issue_count, status, verified_at, subject_user_id
          ) VALUES (
            $1, 'CUSTOMER', 'LINK_IDENTIFIER', 'EMAIL', $2, $3, 1,
            NOW(), NOW() + interval '5 min', NOW() + interval '10 min', NOW() + interval '1 min',
            0, 1, 'VERIFIED', NOW(), $4
          )`,
          [challengeA, emailA, digestA, customerA]
        );

        // Call konfrm_link_verified_email_identifier_v1
        const linkRes = await client.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [challengeA, customerA]);
        assert.strictEqual(linkRes.rows.length, 1);
        assert.strictEqual(linkRes.rows[0].success, true);
        assert.strictEqual(linkRes.rows[0].user_id, customerA);

        // Assert exactly one EMAIL identifier exists and belongs to Customer A
        const emailIdents = await client.query(`SELECT * FROM public.user_identifiers WHERE user_id = $1 AND identifier_type = 'EMAIL'`, [customerA]);
        assert.strictEqual(emailIdents.rows.length, 1);
        assert.strictEqual(emailIdents.rows[0].normalized_value, emailA);

        // Assert users.email mirror = link-a@konfrm.test
        const userA = await client.query('SELECT email FROM public.users WHERE id = $1', [customerA]);
        assert.strictEqual(userA.rows[0]?.email, emailA);

        // Assert challenge = CONSUMED
        const chRow = await client.query('SELECT status, consumed_at FROM public.auth_challenges WHERE id = $1', [challengeA]);
        assert.strictEqual(chRow.rows[0]?.status, 'CONSUMED');
        assert.ok(chRow.rows[0]?.consumed_at);

        // Assert users table count did NOT increase
        const usersAfter = await client.query('SELECT COUNT(*) FROM public.users');
        assert.strictEqual(usersAfter.rows[0].count, usersBefore.rows[0].count);

        // ADD-ONLY TEST: attempt second LINK_IDENTIFIER challenge for link-b@konfrm.test for SAME Customer A
        const challengeB = randomUUID();
        const digestB = computeChallengeOtpDigest(QA_HMAC_SECRET, challengeB, 1, emailB, QA_FIXED_OTP);
        await client.query(
          `INSERT INTO public.auth_challenges (
            id, surface, intent, method, normalized_value, otp_digest, generation,
            issued_at, otp_expires_at, challenge_expires_at, resend_available_at,
            failed_attempts, issue_count, status, verified_at, subject_user_id
          ) VALUES (
            $1, 'CUSTOMER', 'LINK_IDENTIFIER', 'EMAIL', $2, $3, 1,
            NOW(), NOW() + interval '5 min', NOW() + interval '10 min', NOW() + interval '1 min',
            0, 1, 'VERIFIED', NOW(), $4
          )`,
          [challengeB, emailB, digestB, customerA]
        );

        // Attempting to link second email must fail closed with IDENTIFIER_ALREADY_LINKED
        const linkRes2 = await client.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [challengeB, customerA]);
        assert.strictEqual(linkRes2.rows[0]?.success, false);
        assert.strictEqual(linkRes2.rows[0]?.error_code, 'IDENTIFIER_ALREADY_LINKED');

        // Original email must remain unchanged
        const emailIdentsAfter = await client.query(`SELECT * FROM public.user_identifiers WHERE user_id = $1 AND identifier_type = 'EMAIL'`, [customerA]);
        assert.strictEqual(emailIdentsAfter.rows.length, 1);
        assert.strictEqual(emailIdentsAfter.rows[0].normalized_value, emailA);

        const userAAfter = await client.query('SELECT email FROM public.users WHERE id = $1', [customerA]);
        assert.strictEqual(userAAfter.rows[0]?.email, emailA, 'users.email must not be replaced');
      } finally {
        client.release();
      }
    });

    await record('Real PostgreSQL same-user / two-email concurrency: FOR UPDATE + unique (user_id, identifier_type) serialize race', async () => {
      const customerC = randomUUID();
      const phoneC = '+201099992222';
      const emailRaceA = 'email-race-a@konfrm.test';
      const emailRaceB = 'email-race-b@konfrm.test';

      const setupClient = await pool.connect();
      try {
        await setupClient.query(`INSERT INTO public.users (id, phone_number, full_name, status) VALUES ($1, $2, 'Customer C', 'ACTIVE')`, [customerC, phoneC]);
        await setupClient.query(
          `INSERT INTO public.user_identifiers (id, user_id, identifier_type, normalized_value, verified_at) VALUES ($1, $2, 'PHONE', $3, NOW())`,
          [randomUUID(), customerC, phoneC]
        );
      } finally {
        setupClient.release();
      }

      const challengeRaceA = randomUUID();
      const challengeRaceB = randomUUID();
      const setupCh = await pool.connect();
      try {
        await setupCh.query(
          `INSERT INTO public.auth_challenges (
            id, surface, intent, method, normalized_value, otp_digest, generation,
            issued_at, otp_expires_at, challenge_expires_at, resend_available_at,
            failed_attempts, issue_count, status, verified_at, subject_user_id
          ) VALUES
            ($1, 'CUSTOMER', 'LINK_IDENTIFIER', 'EMAIL', $2, 'digest-a', 1, NOW(), NOW() + interval '5 min', NOW() + interval '10 min', NOW() + interval '1 min', 0, 1, 'VERIFIED', NOW(), $3),
            ($4, 'CUSTOMER', 'LINK_IDENTIFIER', 'EMAIL', $5, 'digest-b', 1, NOW(), NOW() + interval '5 min', NOW() + interval '10 min', NOW() + interval '1 min', 0, 1, 'VERIFIED', NOW(), $3)`,
          [challengeRaceA, emailRaceA, customerC, challengeRaceB, emailRaceB]
        );
      } finally {
        setupCh.release();
      }

      // Run two independent PostgreSQL clients/transactions concurrently
      const client1 = await pool.connect();
      const client2 = await pool.connect();
      let results: PromiseSettledResult<any>[];
      try {
        results = await Promise.allSettled([
          client1.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [challengeRaceA, customerC]),
          client2.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [challengeRaceB, customerC]),
        ]);
      } finally {
        client1.release();
        client2.release();
      }

      const successes = results.filter((r) => r.status === 'fulfilled' && (r as PromiseFulfilledResult<any>).value.rows[0]?.success === true);
      const failures = results.filter((r) => {
        if (r.status === 'rejected') return true;
        const row = (r as PromiseFulfilledResult<any>).value.rows[0];
        return row && row.success === false && row.error_code === 'IDENTIFIER_ALREADY_LINKED';
      });
      assert.strictEqual(successes.length, 1, 'Exactly one concurrent link must succeed');
      assert.strictEqual(failures.length, 1, 'Exactly one concurrent link must fail with IDENTIFIER_ALREADY_LINKED');

      // Verify Customer C has exactly one email identifier matching winner
      const verClient = await pool.connect();
      try {
        const idents = await verClient.query(`SELECT * FROM public.user_identifiers WHERE user_id = $1 AND identifier_type = 'EMAIL'`, [customerC]);
        assert.strictEqual(idents.rows.length, 1);
        const winningEmail = idents.rows[0].normalized_value;
        assert.ok(winningEmail === emailRaceA || winningEmail === emailRaceB);

        const userRow = await verClient.query('SELECT email FROM public.users WHERE id = $1', [customerC]);
        assert.strictEqual(userRow.rows[0]?.email, winningEmail);
      } finally {
        verClient.release();
      }
    });

    await record('Real PostgreSQL two-users / same-email concurrency: transactional advisory lock + unique (type, value) race', async () => {
      const customerD = randomUUID();
      const customerE = randomUUID();
      const phoneD = '+201099993333';
      const phoneE = '+201099994444';
      const sharedEmail = 'shared-race@konfrm.test';

      const setupClient = await pool.connect();
      try {
        await setupClient.query(
          `INSERT INTO public.users (id, phone_number, full_name, status) VALUES
            ($1, $2, 'Customer D', 'ACTIVE'),
            ($3, $4, 'Customer E', 'ACTIVE')`,
          [customerD, phoneD, customerE, phoneE]
        );
        await setupClient.query(
          `INSERT INTO public.user_identifiers (id, user_id, identifier_type, normalized_value, verified_at) VALUES
            ($1, $2, 'PHONE', $3, NOW()),
            ($4, $5, 'PHONE', $6, NOW())`,
          [randomUUID(), customerD, phoneD, randomUUID(), customerE, phoneE]
        );
      } finally {
        setupClient.release();
      }

      const challengeD = randomUUID();
      const challengeE = randomUUID();
      const setupCh = await pool.connect();
      try {
        await setupCh.query(
          `INSERT INTO public.auth_challenges (
            id, surface, intent, method, normalized_value, otp_digest, generation,
            issued_at, otp_expires_at, challenge_expires_at, resend_available_at,
            failed_attempts, issue_count, status, verified_at, subject_user_id
          ) VALUES
            ($1, 'CUSTOMER', 'LINK_IDENTIFIER', 'EMAIL', $2, 'digest-d', 1, NOW(), NOW() + interval '5 min', NOW() + interval '10 min', NOW() + interval '1 min', 0, 1, 'VERIFIED', NOW(), $3),
            ($4, 'CUSTOMER', 'LINK_IDENTIFIER', 'EMAIL', $2, 'digest-e', 1, NOW(), NOW() + interval '5 min', NOW() + interval '10 min', NOW() + interval '1 min', 0, 1, 'VERIFIED', NOW(), $5)`,
          [challengeD, sharedEmail, customerD, challengeE, customerE]
        );
      } finally {
        setupCh.release();
      }

      // Run final link RPC calls concurrently using two separate DB clients
      const client1 = await pool.connect();
      const client2 = await pool.connect();
      let results: PromiseSettledResult<any>[];
      try {
        results = await Promise.allSettled([
          client1.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [challengeD, customerD]),
          client2.query('SELECT * FROM public.konfrm_link_verified_email_identifier_v1($1, $2)', [challengeE, customerE]),
        ]);
      } finally {
        client1.release();
        client2.release();
      }

      const successes = results.filter((r) => r.status === 'fulfilled' && (r as PromiseFulfilledResult<any>).value.rows[0]?.success === true);
      const failures = results.filter((r) => {
        if (r.status === 'rejected') return true;
        const row = (r as PromiseFulfilledResult<any>).value.rows[0];
        return row && row.success === false && row.error_code === 'IDENTIFIER_ALREADY_EXISTS';
      });
      assert.strictEqual(successes.length, 1, 'Exactly one claimant must win the shared email');
      assert.strictEqual(failures.length, 1, 'Exactly one claimant must fail with IDENTIFIER_ALREADY_EXISTS');

      // Verify only 1 canonical EMAIL identifier exists for shared-race@konfrm.test
      const verClient = await pool.connect();
      try {
        const idents = await verClient.query(`SELECT * FROM public.user_identifiers WHERE normalized_value = $1`, [sharedEmail]);
        assert.strictEqual(idents.rows.length, 1);
        const winningUserId = idents.rows[0].user_id;
        const losingUserId = winningUserId === customerD ? customerE : customerD;

        // Winning user has users.email set
        const winUser = await verClient.query('SELECT email FROM public.users WHERE id = $1', [winningUserId]);
        assert.strictEqual(winUser.rows[0]?.email, sharedEmail);

        // Losing user's email remains null
        const loseUser = await verClient.query('SELECT email FROM public.users WHERE id = $1', [losingUserId]);
        assert.strictEqual(loseUser.rows[0]?.email, null);
      } finally {
        verClient.release();
      }
    });

    await record('Migration runner safety: QA baseline cannot be discovered by production migration directory scan', async () => {
      const migrationsDir = path.resolve(__dirname, '../../../database/migrations');
      const baselinePath = path.resolve(__dirname, '../../../database/qa_baseline.sql');
      const discovered = fs.readdirSync(migrationsDir).filter((name) => /^\d+_.+\.sql$/u.test(name));
      assert.ok(discovered.includes('031_auth_v2_identity_and_challenges.sql'));
      assert.ok(!discovered.includes('qa_baseline.sql'));
      assert.notStrictEqual(path.dirname(baselinePath), migrationsDir);
    });
  } finally {
    await pool.end();
    const restore = (key: string, value: string | undefined) => {
      if (value === undefined) delete process.env[key]; else process.env[key] = value;
    };
    restore('DATABASE_URL', originalEnv.databaseUrl);
    restore('SUPABASE_URL', originalEnv.supabaseUrl);
    restore('SUPABASE_SECRET_KEY', originalEnv.supabaseSecret);
    restore('SUPABASE_SERVICE_ROLE_KEY', originalEnv.supabaseService);
    restore('NODE_ENV', originalEnv.nodeEnv);
    restore('JWT_ACCESS_SECRET', originalEnv.accessSecret);
    restore('JWT_REFRESH_SECRET', originalEnv.refreshSecret);
  }

  return { total: results.length, passed: results.filter((result) => result.passed).length, failed: results.filter((result) => !result.passed).length, results };
}

if (process.argv[1]?.endsWith('authV2QaBootstrap.test.ts')) {
  runAuthV2QaBootstrapSuite().then(({ total, passed, failed, results }) => {
    for (const result of results) console.log(`${result.passed ? 'PASS' : 'FAIL'} ${result.name}${result.error ? ` — ${result.error}` : ''}`);
    console.log(`TOTAL: ${total} | PASSED: ${passed} | FAILED: ${failed}`);
    process.exit(failed === 0 ? 0 : 1);
  }).catch((error) => {
    console.error('Auth V2 QA bootstrap suite error:', error);
    process.exit(1);
  });
}
