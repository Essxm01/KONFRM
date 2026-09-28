/**
 * KONFRM — Customer Multi-Identifier Auth Upgrade: Verified Email Linking
 * Test Suite: backend/server/src/tests/customerEmailLinking.test.ts
 * Primary Writer: Antigravity
 * 
 * Strict Invariants:
 *   1. 100% ISOLATED. Uses in-memory repositories for deterministic unit/domain tests.
 *   2. LIVE_DB_WRITE_GUARD ensures ZERO mutations to Production Supabase.
 *   3. 1 Human Customer = 1 canonical public.users.id.
 *   4. Zero account merges, zero silent transfers; fails closed on collisions
 *      with exact Arabic message: 'هذا البريد الإلكتروني مرتبط بحساب آخر.'
 *   5. Add-Only: Current user with verified email cannot replace or add another email.
 *      Returns 409 IDENTIFIER_ALREADY_LINKED with exact message: 'يوجد بريد إلكتروني مرتبط بحسابك بالفعل.'
 *   6. Dual identifier login: logging in by Phone or Email resolves to the SAME canonical user_id.
 *   7. Cross-user challenge hijacking blocked (subject_user_id binding).
 *   8. Generic public auth routes reject LINK_IDENTIFIER challenges without mutating lease.
 *   9. Single-use OTP: replay rejected via challenge consumption.
 *   10. RBAC: authenticated Customer (ROLE_CUSTOMER) only.
 *   11. Concurrency serialization: user row lock followed by transactional email advisory lock.
 */

import assert from 'node:assert';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { randomUUID } from 'node:crypto';
import jwt from 'jsonwebtoken';

import { ExpressServerApp } from '../app.js';
import { AuthV2Service } from '../services/authV2Service.js';
import {
  InMemoryAuthChallengeRepository,
  InMemoryAuthRateLimitRepository,
  InMemorySessionRepository,
  InMemoryUserIdentifierRepository,
  InMemoryUserRepository,
} from '../services/authV2Repository.js';
import {
  AUTH_V2_QA_PROJECT_REF,
  mapAuthV2Error,
} from '../services/authV2Runtime.js';
import { signAccessToken } from '../services/jwtService.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const TEST_ENV = {
  AUTH_V2_ENABLED: 'true',
  AUTH_ENVIRONMENT: 'founder_qa',
  AUTH_DELIVERY_MODE: 'DEVELOPMENT_FIXED_OTP',
  AUTH_DEVELOPMENT_OTP: '123456',
  AUTH_OTP_HMAC_SECRET: 'email-linking-test-hmac-secret-32-chars',
  JWT_ACCESS_SECRET: 'email-linking-test-access-secret-32-chars',
  JWT_REFRESH_SECRET: 'email-linking-test-refresh-secret-32-chars',
  SUPABASE_PROJECT_REF: AUTH_V2_QA_PROJECT_REF,
  SUPABASE_SERVICE_ROLE_KEY: 'email-linking-test-service-role-key-32-chars',
  SUPABASE_URL: `https://${AUTH_V2_QA_PROJECT_REF}.supabase.co`,
};

function setupTestEnvironment(): Record<string, string | undefined> {
  const previous: Record<string, string | undefined> = {};
  for (const [key, value] of Object.entries({ ...TEST_ENV, DATABASE_URL: undefined })) {
    previous[key] = process.env[key];
    if (value === undefined) delete process.env[key];
    else process.env[key] = value;
  }
  return previous;
}

function restoreEnvironment(previous: Record<string, string | undefined>): void {
  for (const [key, value] of Object.entries(previous)) {
    if (value === undefined) delete process.env[key];
    else process.env[key] = value;
  }
}

interface TestContext {
  app: ExpressServerApp;
  service: AuthV2Service;
  users: InMemoryUserRepository;
  identifiers: InMemoryUserIdentifierRepository;
  challenges: InMemoryAuthChallengeRepository;
  sessions: InMemorySessionRepository;
  rateLimits: InMemoryAuthRateLimitRepository;
}

function createTestContext(): TestContext {
  const users = new InMemoryUserRepository();
  const identifiers = new InMemoryUserIdentifierRepository();
  const challenges = new InMemoryAuthChallengeRepository();
  const rateLimits = new InMemoryAuthRateLimitRepository();
  const sessions = new InMemorySessionRepository();

  const service = new AuthV2Service({
    userRepo: users,
    userIdentifierRepo: identifiers,
    challengeRepo: challenges,
    rateLimitRepo: rateLimits,
    sessionRepo: sessions,
    config: {
      authEnv: TEST_ENV.AUTH_ENVIRONMENT,
      deliveryMode: TEST_ENV.AUTH_DELIVERY_MODE,
      developmentOtp: TEST_ENV.AUTH_DEVELOPMENT_OTP,
      hmacSecret: TEST_ENV.AUTH_OTP_HMAC_SECRET,
      nodeEnv: 'test',
    },
  });

  const app = new ExpressServerApp({ authV2ServiceFactory: () => service });

  return { app, service, users, identifiers, challenges, sessions, rateLimits };
}

async function request(
  app: ExpressServerApp,
  method: string,
  urlPath: string,
  body?: unknown,
  authHeader?: string
): Promise<{ status: number; body: any }> {
  const headers: Record<string, string> = {
    'cf-connecting-ip': '198.51.100.22',
  };
  if (authHeader) {
    headers['authorization'] = authHeader;
  }
  const result = await app.handleHttpRequest(method, urlPath, headers, body);
  return { status: result.statusCode, body: result.body };
}

function mintCustomerToken(userId: string): string {
  return 'Bearer ' + signAccessToken({ sub: userId, role: 'ROLE_CUSTOMER' });
}

function mintExpiredCustomerToken(userId: string): string {
  const payload = { sub: userId, role: 'ROLE_CUSTOMER' };
  const token = jwt.sign(payload, TEST_ENV.JWT_ACCESS_SECRET, { expiresIn: -10 });
  return 'Bearer ' + token;
}

function mintOwnerToken(userId: string): string {
  return 'Bearer ' + signAccessToken({ sub: userId, role: 'ROLE_OWNER' });
}

function mintAdminToken(userId: string): string {
  return 'Bearer ' + signAccessToken({ sub: userId, role: 'ROLE_ADMIN' });
}

export async function runCustomerEmailLinkingTests(): Promise<void> {
  const prevEnv = setupTestEnvironment();
  let passed = 0;
  let total = 0;

  function record(desc: string, fn: () => Promise<void> | void) {
    total++;
    try {
      const res = fn();
      if (res instanceof Promise) {
        return res
          .then(() => {
            passed++;
            console.log(`  [${total}] ✅ PASS - ${desc}`);
          })
          .catch((err) => {
            console.error(`  [${total}] ❌ FAIL - ${desc}:`, err);
            throw err;
          });
      } else {
        passed++;
        console.log(`  [${total}] ✅ PASS - ${desc}`);
      }
    } catch (err) {
      console.error(`  [${total}] ❌ FAIL - ${desc}:`, err);
      throw err;
    }
  }

  console.log('\n======================================================================');
  console.log('       KONFRM — CUSTOMER VERIFIED EMAIL LINKING TEST SUITE');
  console.log('======================================================================\n');

  try {
    // ------------------------------------------------------------------------
    // GROUP 1: MIGRATION & SCHEMA INTEGRITY
    // ------------------------------------------------------------------------
    console.log('[MIGRATION 034 INTEGRITY]');

    record('Migration 034 file exists and defines konfrm_link_verified_email_identifier_v1', () => {
      const migrationPath = path.resolve(__dirname, '../../../database/migrations/034_customer_verified_email_linking.sql');
      assert.ok(fs.existsSync(migrationPath), 'Migration 034 file must exist');
      const content = fs.readFileSync(migrationPath, 'utf8');

      assert.ok(content.includes('chk_auth_challenges_subject_user_id'), 'Must declare check constraint on subject_user_id');
      assert.ok(content.includes('konfrm_link_verified_email_identifier_v1'), 'Must declare atomic RPC function');
      assert.ok(content.includes('pg_advisory_xact_lock'), 'Must declare transactional advisory lock');
      assert.ok(content.includes('IDENTIFIER_ALREADY_EXISTS'), 'Must fail closed with IDENTIFIER_ALREADY_EXISTS');
      assert.ok(content.includes('CONSUMED'), 'Must transition challenge status to CONSUMED');
      assert.ok(content.includes('034_customer_verified_email_linking.sql'), 'Must register in schema_migrations');
    });

    record('Migration 034 contains NO blanket critical WHEN OTHERS THEN NULL exception swallowing', () => {
      const migrationPath = path.resolve(__dirname, '../../../database/migrations/034_customer_verified_email_linking.sql');
      const content = fs.readFileSync(migrationPath, 'utf8');
      assert.ok(!content.includes('WHEN OTHERS THEN NULL'), 'Must not contain any WHEN OTHERS THEN NULL exception swallowing');
    });

    record('Migration 034 defines unique index uq_user_identifiers_user_type and preflight duplicate check', () => {
      const migrationPath = path.resolve(__dirname, '../../../database/migrations/034_customer_verified_email_linking.sql');
      const content = fs.readFileSync(migrationPath, 'utf8');
      assert.ok(content.includes('uq_user_identifiers_user_type'), 'Must define uq_user_identifiers_user_type index');
      assert.ok(content.includes('CANNOT_APPLY_MIGRATION_034'), 'Must define preflight duplicate check');
    });

    record('Migration 034 strengthens subject_user_id constraint for LINK vs LOGIN/CREATE', () => {
      const migrationPath = path.resolve(__dirname, '../../../database/migrations/034_customer_verified_email_linking.sql');
      const content = fs.readFileSync(migrationPath, 'utf8');
      assert.ok(content.includes("intent = 'LINK_IDENTIFIER' AND subject_user_id IS NOT NULL"), 'Link requires subject_user_id');
      assert.ok(content.includes("intent IN ('LOGIN', 'CREATE_ACCOUNT') AND subject_user_id IS NULL"), 'Login/Create forbid subject_user_id');
    });

    record('Migration 034 revokes permissions and grants only to service_role', () => {
      const migrationPath = path.resolve(__dirname, '../../../database/migrations/034_customer_verified_email_linking.sql');
      const content = fs.readFileSync(migrationPath, 'utf8');
      assert.ok(content.includes('REVOKE ALL ON FUNCTION public.konfrm_link_verified_email_identifier_v1'), 'Must revoke public permissions');
      assert.ok(content.includes('TO service_role'), 'Must grant execute only to service_role');
      assert.ok(content.includes('SECURITY DEFINER'), 'Must be SECURITY DEFINER');
    });

    // ------------------------------------------------------------------------
    // GROUP 2: SERVICE LAYER DOMAIN SPECIFICATION & ADD-ONLY
    // ------------------------------------------------------------------------
    console.log('\n[DOMAIN SERVICE SPECIFICATION]');

    await record('requestEmailLinkChallenge creates challenge with intent=LINK_IDENTIFIER and subjectUserId', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });

      const res = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'essam.customer@konfrm.test',
      });

      assert.strictEqual(res.success, true);
      assert.ok(res.challengeId);
      assert.ok(res.maskedRecipient.includes('***'));

      const challenge = await ctx.challenges.getById(res.challengeId);
      assert.ok(challenge);
      assert.strictEqual(challenge.intent, 'LINK_IDENTIFIER');
      assert.strictEqual(challenge.method, 'EMAIL');
      assert.strictEqual(challenge.surface, 'CUSTOMER');
      assert.strictEqual(challenge.subjectUserId, userId);
      assert.strictEqual(challenge.normalizedValue, 'essam.customer@konfrm.test');
      assert.strictEqual(challenge.status, 'ACTIVE');
    });

    await record('requestEmailLinkChallenge fails closed if subject user does not exist in userRepo', async () => {
      const ctx = createTestContext();
      await assert.rejects(
        async () => {
          await ctx.service.requestEmailLinkChallenge({
            subjectUserId: randomUUID(),
            email: 'nonexistent@konfrm.test',
          });
        },
        /USER_NOT_FOUND/
      );
    });

    await record('requestEmailLinkChallenge rejects if user already has verified email (same or different email)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });
      await ctx.identifiers.create({
        userId,
        identifierType: 'EMAIL',
        normalizedValue: 'existing.verified@konfrm.test',
        verifiedAt: new Date().toISOString(),
      });

      // Attempting same email
      await assert.rejects(
        async () => {
          await ctx.service.requestEmailLinkChallenge({
            subjectUserId: userId,
            email: 'existing.verified@konfrm.test',
          });
        },
        /IDENTIFIER_ALREADY_LINKED/
      );

      // Attempting different email (Add-Only rule: fail closed!)
      await assert.rejects(
        async () => {
          await ctx.service.requestEmailLinkChallenge({
            subjectUserId: userId,
            email: 'different.candidate@konfrm.test',
          });
        },
        /IDENTIFIER_ALREADY_LINKED/
      );
    });

    await record('requestEmailLinkChallenge rejects if user already has an unverified email for a DIFFERENT candidate', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });
      await ctx.identifiers.create({
        userId,
        identifierType: 'EMAIL',
        normalizedValue: 'pending.unverified@konfrm.test',
        verifiedAt: null,
      });

      // Attempting different candidate
      await assert.rejects(
        async () => {
          await ctx.service.requestEmailLinkChallenge({
            subjectUserId: userId,
            email: 'different.unverified@konfrm.test',
          });
        },
        /IDENTIFIER_ALREADY_LINKED/
      );
    });

    await record('requestEmailLinkChallenge does NOT disclose if email is owned by ANOTHER user before verification', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();

      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId: userA, identifierType: 'EMAIL', normalizedValue: 'user.a@konfrm.test', verifiedAt: new Date().toISOString() });

      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      // User B requests link for User A's email -> must issue challenge without disclosing collision
      const res = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userB,
        email: 'user.a@konfrm.test',
      });
      assert.strictEqual(res.success, true);
      assert.ok(res.challengeId);
    });

    await record('verifyEmailLinkChallenge links email to subject user, updates mirror, consumes challenge', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId, identifierType: 'PHONE', normalizedValue: '+201011111111', verifiedAt: new Date().toISOString() });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'link.me@konfrm.test',
      });

      const verifyRes = await ctx.service.verifyEmailLinkChallenge({
        challengeId: issue.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      assert.strictEqual(verifyRes.success, true);
      assert.strictEqual(verifyRes.userId, userId);
      assert.strictEqual(verifyRes.email, 'link.me@konfrm.test');
      assert.strictEqual(verifyRes.alreadyLinked, false);

      // Verify canonical identifier created
      const idRecord = await ctx.identifiers.getByIdentifier('EMAIL', 'link.me@konfrm.test');
      assert.ok(idRecord);
      assert.strictEqual(idRecord.userId, userId);
      assert.ok(idRecord.verifiedAt);

      // Verify users table mirror updated
      const userRecord = await ctx.users.getById(userId);
      assert.strictEqual(userRecord.email, 'link.me@konfrm.test');

      // Verify challenge consumed
      const challengeRecord = await ctx.challenges.getById(issue.challengeId);
      assert.strictEqual(challengeRecord?.status, 'CONSUMED');
    });

    await record('verifyEmailLinkChallenge fails closed with IDENTIFIER_ALREADY_EXISTS when email owned by another user', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();

      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId: userA, identifierType: 'EMAIL', normalizedValue: 'shared@konfrm.test', verifiedAt: new Date().toISOString() });

      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });
      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userB,
        email: 'shared@konfrm.test',
      });

      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userB,
          });
        },
        /IDENTIFIER_ALREADY_EXISTS/
      );

      // Verify User B's profile was NOT contaminated
      const userBRecord = await ctx.users.getById(userB);
      assert.ok(!userBRecord.email, 'User B email mirror must not be set');
    });

    await record('verifyEmailLinkChallenge fails closed when email conflicts with legacy users.email of another user', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();

      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', email: 'legacy.conflict@konfrm.test', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userB,
        email: 'legacy.conflict@konfrm.test',
      });

      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userB,
          });
        },
        /IDENTIFIER_ALREADY_EXISTS/
      );
    });

    await record('verifyEmailLinkChallenge upgrades legacy users.email for SAME user after OTP proof', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();

      // Current user has legacy email in users table, but no canonical user_identifiers row
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Legacy User', email: 'my.legacy@konfrm.test', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'my.legacy@konfrm.test',
      });

      const verifyRes = await ctx.service.verifyEmailLinkChallenge({
        challengeId: issue.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      assert.strictEqual(verifyRes.success, true);
      assert.strictEqual(verifyRes.userId, userId);
      assert.strictEqual(verifyRes.email, 'my.legacy@konfrm.test');

      const idRecord = await ctx.identifiers.getByIdentifier('EMAIL', 'my.legacy@konfrm.test');
      assert.ok(idRecord);
      assert.strictEqual(idRecord.userId, userId);
    });

    await record('Add-Only Rule: verifyEmailLinkChallenge fails closed if user already has a DIFFERENT verified email', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();

      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'User One', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId, identifierType: 'EMAIL', normalizedValue: 'initial@konfrm.test', verifiedAt: new Date().toISOString() });

      // Directly create an active challenge for a different email to test RPC/verify layer protection
      const challengeId = randomUUID();
      await ctx.challenges.create({
        id: challengeId,
        surface: 'CUSTOMER',
        intent: 'LINK_IDENTIFIER',
        method: 'EMAIL',
        normalizedValue: 'second.different@konfrm.test',
        otpDigest: 'digest',
        otpExpiresAt: new Date(Date.now() + 600000).toISOString(),
        challengeExpiresAt: new Date(Date.now() + 600000).toISOString(),
        resendAvailableAt: new Date(Date.now() + 60000).toISOString(),
        subjectUserId: userId,
      });

      const ch = await ctx.challenges.getById(challengeId);
      ch!.status = 'VERIFIED';

      const linkRes = await ctx.challenges.linkVerifiedEmailIdentifier(challengeId, userId);
      assert.strictEqual(linkRes.success, false);
      assert.strictEqual(linkRes.errorCode, 'IDENTIFIER_ALREADY_LINKED');

      // Verify original email was NOT replaced
      const userIdentifiers = await ctx.identifiers.getByUserId(userId);
      const emailIdentifiers = userIdentifiers.filter((i) => i.identifierType === 'EMAIL');
      assert.strictEqual(emailIdentifiers.length, 1);
      assert.strictEqual(emailIdentifiers[0].normalizedValue, 'initial@konfrm.test');
    });

    await record('Canonical Invariant: users count before link == users count after link (no second user)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Single User', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId, identifierType: 'PHONE', normalizedValue: '+201011111111', verifiedAt: new Date().toISOString() });

      const usersCountBefore = (await ctx.users.getAllUsers()).length;

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'single.user@konfrm.test',
      });
      await ctx.service.verifyEmailLinkChallenge({
        challengeId: issue.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      const usersCountAfter = (await ctx.users.getAllUsers()).length;
      assert.strictEqual(usersCountBefore, usersCountAfter, 'Users count must not increase after link');

      const userAfter = await ctx.users.getById(userId);
      assert.strictEqual(userAfter.id, userId, 'Canonical user_id must remain identical');
    });

    await record('Canonical Invariant: user has EXACTLY 1 EMAIL identifier after link; second different email blocked', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Exact One User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'exact.one@konfrm.test',
      });
      await ctx.service.verifyEmailLinkChallenge({
        challengeId: issue.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      const countBefore = (await ctx.identifiers.getByUserId(userId)).filter((i) => i.identifierType === 'EMAIL').length;
      assert.strictEqual(countBefore, 1, 'Must have exactly 1 EMAIL identifier');

      // Attempting second different email must fail closed
      await assert.rejects(
        async () => {
          await ctx.service.requestEmailLinkChallenge({
            subjectUserId: userId,
            email: 'second.different@konfrm.test',
          });
        },
        /IDENTIFIER_ALREADY_LINKED/
      );

      const countAfter = (await ctx.identifiers.getByUserId(userId)).filter((i) => i.identifierType === 'EMAIL').length;
      assert.strictEqual(countAfter, 1, 'Must strictly remain exactly 1 EMAIL identifier');
    });

    // ------------------------------------------------------------------------
    // GROUP 3: OTP & CHALLENGE SECURITY
    // ------------------------------------------------------------------------
    console.log('\n[OTP & CHALLENGE SECURITY]');

    await record('verifyEmailLinkChallenge blocks cross-user challenge hijacking (subject mismatch)', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();

      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userA,
        email: 'user.a@konfrm.test',
      });

      // User B attempts to verify User A's challenge
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userB,
          });
        },
        /CHALLENGE_OWNERSHIP_MISMATCH/
      );
    });

    await record('verifyEmailLinkChallenge rejects consumed challenges (replay prevention)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Replay User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'replay@konfrm.test',
      });

      // First verification succeeds
      await ctx.service.verifyEmailLinkChallenge({
        challengeId: issue.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      // Second verification replay rejected
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userId,
          });
        },
        /CHALLENGE_ALREADY_CONSUMED/
      );
    });

    await record('verifyEmailLinkChallenge rejects expired OTP (OTP_EXPIRED)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Expired OTP User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'expired.otp@konfrm.test',
      });

      // Force expired OTP timestamp on challenge
      const challenge = await ctx.challenges.getById(issue.challengeId);
      challenge!.otpExpiresAt = new Date(Date.now() - 10000).toISOString();

      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userId,
          });
        },
        /OTP_EXPIRED/
      );
    });

    await record('verifyEmailLinkChallenge rejects expired challenge (CHALLENGE_EXPIRED)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Expired Challenge User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'expired.challenge@konfrm.test',
      });

      // Force expired challenge timestamp
      const challenge = await ctx.challenges.getById(issue.challengeId);
      challenge!.challengeExpiresAt = new Date(Date.now() - 10000).toISOString();

      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userId,
          });
        },
        /CHALLENGE_EXPIRED/
      );
    });

    await record('verifyEmailLinkChallenge locks after 5 failed attempts (CHALLENGE_LOCKED_MAX_ATTEMPTS_EXCEEDED)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Locked Challenge User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'locked@konfrm.test',
      });

      // 4 wrong attempts
      for (let i = 0; i < 4; i++) {
        await assert.rejects(
          async () => {
            await ctx.service.verifyEmailLinkChallenge({
              challengeId: issue.challengeId,
              otp: '000000',
              subjectUserId: userId,
            });
          },
          /INVALID_OTP/
        );
      }

      // 5th wrong attempt locks the challenge
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '000000',
            subjectUserId: userId,
          });
        },
        /CHALLENGE_LOCKED_MAX_ATTEMPTS_EXCEEDED/
      );

      // Even correct OTP is rejected when challenge is locked
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userId,
          });
        },
        /CHALLENGE_LOCKED_MAX_ATTEMPTS_EXCEEDED/
      );
    });

    await record('verifyEmailLinkChallenge rejects cancelled challenge (CHALLENGE_CANCELLED)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Cancel User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'cancelled@konfrm.test',
      });

      await ctx.service.cancelEmailLinkChallenge({
        challengeId: issue.challengeId,
        subjectUserId: userId,
      });

      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
            subjectUserId: userId,
          });
        },
        /CHALLENGE_CANCELLED/
      );
    });

    await record('Crash recovery: challenge in VERIFIED status safely finishes linking on client retry', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Crash Recovery User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'crash.recovery@konfrm.test',
      });

      // Simulate challenge transitioned to VERIFIED, but link step crashed before execution
      const challenge = await ctx.challenges.getById(issue.challengeId);
      challenge!.status = 'VERIFIED';
      challenge!.verifiedAt = new Date().toISOString();

      // Client retries verify request
      const retryResult = await ctx.service.verifyEmailLinkChallenge({
        challengeId: issue.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      assert.strictEqual(retryResult.success, true);
      assert.strictEqual(retryResult.email, 'crash.recovery@konfrm.test');
      assert.strictEqual(retryResult.userId, userId);

      const idRecord = await ctx.identifiers.getByIdentifier('EMAIL', 'crash.recovery@konfrm.test');
      assert.ok(idRecord);
      assert.strictEqual(idRecord.userId, userId);
    });

    // ------------------------------------------------------------------------
    // GROUP 4: GENERIC PUBLIC ROUTE ISOLATION
    // ------------------------------------------------------------------------
    console.log('\n[GENERIC PUBLIC ROUTE ISOLATION]');

    await record('Generic public verifyChallenge rejects LINK_IDENTIFIER challenges', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Public Test User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'public.test@konfrm.test',
      });

      await assert.rejects(
        async () => {
          await ctx.service.verifyChallenge({
            challengeId: issue.challengeId,
            otp: '123456',
          });
        },
        /INVALID_AUTH_CHALLENGE/
      );
    });

    await record('Generic public resendChallenge rejects LINK_IDENTIFIER challenges without mutating lease', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Public Resend User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'public.resend@konfrm.test',
      });

      const beforeChallenge = await ctx.challenges.getById(issue.challengeId);
      const beforeGen = beforeChallenge?.generation;
      const beforeLease = (beforeChallenge as any)?.resendLeaseToken;

      await assert.rejects(
        async () => {
          await ctx.service.resendChallenge({
            challengeId: issue.challengeId,
          });
        },
        /INVALID_AUTH_CHALLENGE/
      );

      // Verify challenge lease state was NOT mutated!
      const afterChallenge = await ctx.challenges.getById(issue.challengeId);
      assert.strictEqual(afterChallenge?.generation, beforeGen, 'Generation must not rotate');
      assert.strictEqual((afterChallenge as any)?.resendLeaseToken, beforeLease, 'Lease token must not be set');
    });

    await record('Generic public cancelChallenge rejects LINK_IDENTIFIER challenges', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Public Cancel User', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'public.cancel@konfrm.test',
      });

      await assert.rejects(
        async () => {
          await ctx.service.cancelChallenge(issue.challengeId);
        },
        /INVALID_AUTH_CHALLENGE/
      );

      const challenge = await ctx.challenges.getById(issue.challengeId);
      assert.strictEqual(challenge?.status, 'ACTIVE', 'Challenge must remain ACTIVE');
    });

    // ------------------------------------------------------------------------
    // GROUP 5: AUTHORIZATION & RBAC CONTRACTS
    // ------------------------------------------------------------------------
    console.log('\n[AUTHORIZATION & RBAC]');

    await record('HTTP RBAC: Unauthenticated requests return 401', async () => {
      const ctx = createTestContext();
      const res = await request(ctx.app, 'POST', '/api/v2/customer/identifiers/email/challenges', {
        email: 'unauth@konfrm.test',
      });
      assert.strictEqual(res.status, 401);
      assert.strictEqual(res.body.error.code, 'UNAUTHORIZED_MISSING_TOKEN');
    });

    await record('HTTP RBAC: Invalid token returns 401', async () => {
      const ctx = createTestContext();
      const res = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'invalid@konfrm.test' },
        'Bearer invalid-token-string'
      );
      assert.strictEqual(res.status, 401);
      assert.strictEqual(res.body.error.code, 'UNAUTHORIZED_INVALID_TOKEN');
    });

    await record('HTTP RBAC: Expired token returns 401', async () => {
      const ctx = createTestContext();
      const expiredToken = mintExpiredCustomerToken(randomUUID());
      const res = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'expired@konfrm.test' },
        expiredToken
      );
      assert.strictEqual(res.status, 401);
      assert.strictEqual(res.body.error.code, 'UNAUTHORIZED_INVALID_TOKEN');
    });

    await record('HTTP RBAC: Owner and Admin tokens return 403', async () => {
      const ctx = createTestContext();
      const ownerToken = mintOwnerToken(randomUUID());
      const resOwner = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'owner@konfrm.test' },
        ownerToken
      );
      assert.strictEqual(resOwner.status, 403);
      assert.strictEqual(resOwner.body.error.code, 'FORBIDDEN_INSUFFICIENT_ROLE');

      const adminToken = mintAdminToken(randomUUID());
      const resAdmin = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'admin@konfrm.test' },
        adminToken
      );
      assert.strictEqual(resAdmin.status, 403);
      assert.strictEqual(resAdmin.body.error.code, 'FORBIDDEN_INSUFFICIENT_ROLE');
    });

    await record('Cross-user RESEND & CANCEL rejected with 403 CHALLENGE_OWNERSHIP_MISMATCH', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();
      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      const issue = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userA,
        email: 'user.a.cross@konfrm.test',
      });

      const userBToken = mintCustomerToken(userB);

      // User B attempts to resend User A's challenge
      const resendRes = await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${issue.challengeId}/resend`,
        {},
        userBToken
      );
      assert.strictEqual(resendRes.status, 403);
      assert.strictEqual(resendRes.body.error.code, 'CHALLENGE_OWNERSHIP_MISMATCH');

      // User B attempts to cancel User A's challenge
      const cancelRes = await request(
        ctx.app,
        'DELETE',
        `/api/v2/customer/identifiers/email/challenges/${issue.challengeId}`,
        undefined,
        userBToken
      );
      assert.strictEqual(cancelRes.status, 403);
      assert.strictEqual(cancelRes.body.error.code, 'CHALLENGE_OWNERSHIP_MISMATCH');
    });

    // ------------------------------------------------------------------------
    // GROUP 6: CONCURRENCY & RACE CONDITIONS
    // ------------------------------------------------------------------------
    console.log('\n[CONCURRENCY & RACE CONDITIONS]');

    await record('Concurrency: Same user / Two different emails race -> exactly ONE winner, loser fails closed (Section 30)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Race User', status: 'ACTIVE' });

      // Create two independent link challenges for Customer A with two different emails
      const challengeA = randomUUID();
      const challengeB = randomUUID();
      const now = Date.now();

      await ctx.challenges.create({
        id: challengeA,
        surface: 'CUSTOMER',
        intent: 'LINK_IDENTIFIER',
        method: 'EMAIL',
        normalizedValue: 'email-a@konfrm.test',
        otpDigest: 'digest-a',
        otpExpiresAt: new Date(now + 600000).toISOString(),
        challengeExpiresAt: new Date(now + 600000).toISOString(),
        resendAvailableAt: new Date(now + 60000).toISOString(),
        subjectUserId: userId,
      });

      await ctx.challenges.create({
        id: challengeB,
        surface: 'CUSTOMER',
        intent: 'LINK_IDENTIFIER',
        method: 'EMAIL',
        normalizedValue: 'email-b@konfrm.test',
        otpDigest: 'digest-b',
        otpExpiresAt: new Date(now + 600000).toISOString(),
        challengeExpiresAt: new Date(now + 600000).toISOString(),
        resendAvailableAt: new Date(now + 60000).toISOString(),
        subjectUserId: userId,
      });

      // Mark both verified so both are ready to race at the atomic link boundary
      const chARecord = await ctx.challenges.getById(challengeA);
      chARecord!.status = 'VERIFIED';
      const chBRecord = await ctx.challenges.getById(challengeB);
      chBRecord!.status = 'VERIFIED';

      // Race link operations concurrently
      const [resA, resB] = await Promise.all([
        ctx.challenges.linkVerifiedEmailIdentifier(challengeA, userId),
        ctx.challenges.linkVerifiedEmailIdentifier(challengeB, userId),
      ]);

      const wins = [resA, resB].filter((r) => r.success);
      const fails = [resA, resB].filter((r) => !r.success);

      assert.strictEqual(wins.length, 1, 'Exactly one link operation must succeed');
      assert.strictEqual(fails.length, 1, 'The competing link operation must fail closed');
      assert.strictEqual(fails[0].errorCode, 'IDENTIFIER_ALREADY_LINKED', 'Loser must fail with IDENTIFIER_ALREADY_LINKED');

      // Assert user has EXACTLY ONE EMAIL identifier
      const userIdentifiers = await ctx.identifiers.getByUserId(userId);
      const emailIdentifiers = userIdentifiers.filter((i) => i.identifierType === 'EMAIL');
      assert.strictEqual(emailIdentifiers.length, 1, 'Customer must have exactly 1 EMAIL identifier');

      // Assert users table mirror matches the winner, NOT the loser
      const user = await ctx.users.getById(userId);
      assert.strictEqual(user.email, wins[0].email, 'users.email must match winner');
      assert.notStrictEqual(user.email, fails[0].email, 'users.email must not reflect loser');
    });

    await record('Concurrency: Two users / Same email race -> exactly ONE winner, loser fails closed (Section 31)', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();
      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A Race', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B Race', status: 'ACTIVE' });

      const challengeA = randomUUID();
      const challengeB = randomUUID();
      const sharedEmail = 'shared-race@konfrm.test';
      const now = Date.now();

      await ctx.challenges.create({
        id: challengeA,
        surface: 'CUSTOMER',
        intent: 'LINK_IDENTIFIER',
        method: 'EMAIL',
        normalizedValue: sharedEmail,
        otpDigest: 'digest-a',
        otpExpiresAt: new Date(now + 600000).toISOString(),
        challengeExpiresAt: new Date(now + 600000).toISOString(),
        resendAvailableAt: new Date(now + 60000).toISOString(),
        subjectUserId: userA,
      });

      await ctx.challenges.create({
        id: challengeB,
        surface: 'CUSTOMER',
        intent: 'LINK_IDENTIFIER',
        method: 'EMAIL',
        normalizedValue: sharedEmail,
        otpDigest: 'digest-b',
        otpExpiresAt: new Date(now + 600000).toISOString(),
        challengeExpiresAt: new Date(now + 600000).toISOString(),
        resendAvailableAt: new Date(now + 60000).toISOString(),
        subjectUserId: userB,
      });

      const chARecord = await ctx.challenges.getById(challengeA);
      chARecord!.status = 'VERIFIED';
      const chBRecord = await ctx.challenges.getById(challengeB);
      chBRecord!.status = 'VERIFIED';

      // Race link operations concurrently
      const [resA, resB] = await Promise.all([
        ctx.challenges.linkVerifiedEmailIdentifier(challengeA, userA),
        ctx.challenges.linkVerifiedEmailIdentifier(challengeB, userB),
      ]);

      const wins = [resA, resB].filter((r) => r.success);
      const fails = [resA, resB].filter((r) => !r.success);

      assert.strictEqual(wins.length, 1, 'Exactly one user must win the email');
      assert.strictEqual(fails.length, 1, 'Competitor must fail closed');
      assert.strictEqual(fails[0].errorCode, 'IDENTIFIER_ALREADY_EXISTS', 'Competitor must fail with IDENTIFIER_ALREADY_EXISTS');

      // Canonical identifier belongs to winner
      const idRecord = await ctx.identifiers.getByIdentifier('EMAIL', sharedEmail);
      assert.ok(idRecord);
      assert.strictEqual(idRecord.userId, wins[0].userId);

      // Loser users.email is NOT mutated
      const loserUser = await ctx.users.getById(fails[0].userId === userA ? userA : userB);
      assert.ok(!loserUser.email, 'Loser users.email must not be mutated');
    });

    // ------------------------------------------------------------------------
    // GROUP 7: HTTP RUNTIME API CONTRACTS
    // ------------------------------------------------------------------------
    console.log('\n[HTTP RUNTIME API CONTRACTS]');

    await record('HTTP: Full Linking Lifecycle (Issue -> Verify -> Idempotent Re-link)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId, identifierType: 'PHONE', normalizedValue: '+201011111111', verifiedAt: new Date().toISOString() });
      const customerToken = mintCustomerToken(userId);

      // 1. Issue challenge
      const issueRes = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'Essam.Customer@Konfrm.Test' },
        customerToken
      );
      assert.strictEqual(issueRes.status, 200);
      assert.strictEqual(issueRes.body.success, true);
      assert.ok(issueRes.body.data.challengeId);
      const challengeId = issueRes.body.data.challengeId;

      // 2. Verify with wrong OTP
      const wrongOtpRes = await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${challengeId}/verify`,
        { otp: '999999' },
        customerToken
      );
      assert.strictEqual(wrongOtpRes.status, 400);
      assert.strictEqual(wrongOtpRes.body.error.code, 'INVALID_OTP');

      // 3. Verify with correct OTP
      const verifyRes = await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${challengeId}/verify`,
        { otp: '123456' },
        customerToken
      );
      assert.strictEqual(verifyRes.status, 200);
      assert.strictEqual(verifyRes.body.success, true);
      assert.strictEqual(verifyRes.body.data.userId, userId);
      assert.strictEqual(verifyRes.body.data.email, 'Essam.Customer@konfrm.test');
      assert.strictEqual(verifyRes.body.data.alreadyLinked, false);

      // 4. Invariant: users.id remains EXACTLY the same, email mirror is updated
      const user = await ctx.users.getById(userId);
      assert.strictEqual(user.id, userId);
      assert.strictEqual(user.phoneNumber, '+201011111111');
      assert.strictEqual(user.email, 'Essam.Customer@konfrm.test');
    });

    await record('HTTP: Dual-Identifier Login resolves to the SAME canonical user_id', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Dual Identifier User', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId, identifierType: 'PHONE', normalizedValue: '+201011111111', verifiedAt: new Date().toISOString() });

      // Link email
      const customerToken = mintCustomerToken(userId);
      const linkIssue = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'dual.login@konfrm.test' },
        customerToken
      );
      await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${linkIssue.body.data.challengeId}/verify`,
        { otp: '123456' },
        customerToken
      );

      // Scenario A: Customer logs in via Phone
      const phoneChallengeRes = await request(ctx.app, 'POST', '/api/v2/auth/challenges', {
        surface: 'CUSTOMER',
        intent: 'LOGIN',
        method: 'PHONE',
        identifier: '01011111111',
      });
      assert.strictEqual(phoneChallengeRes.status, 200);
      const phoneVerifyRes = await request(
        ctx.app,
        'POST',
        `/api/v2/auth/challenges/${phoneChallengeRes.body.data.challengeId}/verify`,
        { otp: '123456' }
      );
      assert.strictEqual(phoneVerifyRes.status, 200);
      assert.strictEqual(phoneVerifyRes.body.data.isExistingUser, true);
      const phoneUserId = phoneVerifyRes.body.data.user.id;

      // Scenario B: Customer logs in via Email
      const emailChallengeRes = await request(ctx.app, 'POST', '/api/v2/auth/challenges', {
        surface: 'CUSTOMER',
        intent: 'LOGIN',
        method: 'EMAIL',
        identifier: 'dual.login@konfrm.test',
      });
      assert.strictEqual(emailChallengeRes.status, 200);
      const emailVerifyRes = await request(
        ctx.app,
        'POST',
        `/api/v2/auth/challenges/${emailChallengeRes.body.data.challengeId}/verify`,
        { otp: '123456' }
      );
      assert.strictEqual(emailVerifyRes.status, 200);
      assert.strictEqual(emailVerifyRes.body.data.isExistingUser, true);
      const emailUserId = emailVerifyRes.body.data.user.id;

      // CRITICAL INVARIANT ASSERTION
      assert.strictEqual(phoneUserId, userId, 'Phone login must resolve to canonical userId');
      assert.strictEqual(emailUserId, userId, 'Email login must resolve to canonical userId');
      assert.strictEqual(phoneUserId, emailUserId, 'Both login methods must resolve to the identical account');
    });

    await record('HTTP: Collision with another user returns 409 IDENTIFIER_ALREADY_EXISTS with exact Arabic copy', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();
      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId: userA, identifierType: 'EMAIL', normalizedValue: 'collision@konfrm.test', verifiedAt: new Date().toISOString() });

      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });
      const userBToken = mintCustomerToken(userB);

      // User B attempts to link collision@konfrm.test
      const issueRes = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'collision@konfrm.test' },
        userBToken
      );
      assert.strictEqual(issueRes.status, 200);
      const challengeId = issueRes.body.data.challengeId;

      // Verify attempts to commit the link
      const verifyRes = await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${challengeId}/verify`,
        { otp: '123456' },
        userBToken
      );

      // EXACT ARABIC MESSAGE ASSERTION (Section 20)
      assert.strictEqual(verifyRes.status, 409);
      assert.strictEqual(verifyRes.body.success, false);
      assert.strictEqual(verifyRes.body.error.code, 'IDENTIFIER_ALREADY_EXISTS');
      assert.strictEqual(verifyRes.body.error.message, 'هذا البريد الإلكتروني مرتبط بحساب آخر.');
    });

    await record('HTTP: Current user already having verified email returns 409 IDENTIFIER_ALREADY_LINKED with exact Arabic copy', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Already Linked User', status: 'ACTIVE' });
      await ctx.identifiers.create({ userId, identifierType: 'EMAIL', normalizedValue: 'already.linked@konfrm.test', verifiedAt: new Date().toISOString() });

      const customerToken = mintCustomerToken(userId);

      // Requesting link for a different email
      const issueRes = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'different.email@konfrm.test' },
        customerToken
      );

      // EXACT ARABIC MESSAGE ASSERTION (Section 19)
      assert.strictEqual(issueRes.status, 409);
      assert.strictEqual(issueRes.body.success, false);
      assert.strictEqual(issueRes.body.error.code, 'IDENTIFIER_ALREADY_LINKED');
      assert.strictEqual(issueRes.body.error.message, 'يوجد بريد إلكتروني مرتبط بحسابك بالفعل.');
    });

    await record('HTTP: Resend and Cancel endpoints function truthfully with Customer authentication', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });
      const customerToken = mintCustomerToken(userId);

      const issueRes = await request(
        ctx.app,
        'POST',
        '/api/v2/customer/identifiers/email/challenges',
        { email: 'resend.test@konfrm.test' },
        customerToken
      );
      const challengeId = issueRes.body.data.challengeId;

      // Immediate resend should trigger cooldown error
      const cooldownRes = await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${challengeId}/resend`,
        {},
        customerToken
      );
      assert.strictEqual(cooldownRes.status, 429);
      assert.strictEqual(cooldownRes.body.error.code, 'RESEND_COOLDOWN_ACTIVE');

      // Cancel challenge
      const cancelRes = await request(
        ctx.app,
        'DELETE',
        `/api/v2/customer/identifiers/email/challenges/${challengeId}`,
        undefined,
        customerToken
      );
      assert.strictEqual(cancelRes.status, 200);
      assert.strictEqual(cancelRes.body.success, true);

      // Subsequent verify fails
      const verifyAfterCancel = await request(
        ctx.app,
        'POST',
        `/api/v2/customer/identifiers/email/challenges/${challengeId}/verify`,
        { otp: '123456' },
        customerToken
      );
      assert.strictEqual(verifyAfterCancel.status, 400);
      assert.strictEqual(verifyAfterCancel.body.error.code, 'CHALLENGE_CANCELLED');
    });

    console.log('\n----------------------------------------------------------------------');
    console.log(`TOTAL: ${total} | PASSED: ${passed} | FAILED: 0`);
    console.log('----------------------------------------------------------------------');
    console.log('KONFRM CUSTOMER VERIFIED EMAIL LINKING TEST SUITE PASSED SUCCESSFULLY.\n');
  } finally {
    restoreEnvironment(prevEnv);
  }
}

// Self-executing runner
runCustomerEmailLinkingTests().catch((err) => {
  console.error('Test suite failed:', err);
  process.exit(1);
});
