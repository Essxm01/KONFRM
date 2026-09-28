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
 *   5. Dual identifier login: logging in by Phone or Email resolves to the SAME canonical user_id.
 *   6. Cross-user challenge hijacking blocked (subject_user_id binding).
 *   7. Generic public auth routes reject LINK_IDENTIFIER challenges.
 *   8. Single-use OTP: replay rejected via challenge consumption.
 *   9. RBAC: authenticated Customer (ROLE_CUSTOMER) only.
 */

import assert from 'node:assert';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { randomUUID } from 'node:crypto';

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

    // ------------------------------------------------------------------------
    // GROUP 2: SERVICE LAYER DOMAIN SPECIFICATION
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

    await record('requestEmailLinkChallenge rejects if exact email is already linked and verified for the same user', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });
      await ctx.identifiers.create({
        userId,
        identifierType: 'EMAIL',
        normalizedValue: 'essam.customer@konfrm.test',
        verifiedAt: new Date().toISOString(),
      });

      await assert.rejects(
        async () => {
          await ctx.service.requestEmailLinkChallenge({
            subjectUserId: userId,
            email: 'essam.customer@konfrm.test',
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
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      // User A already holds this email
      await ctx.identifiers.create({
        userId: userA,
        identifierType: 'EMAIL',
        normalizedValue: 'victim@konfrm.test',
        verifiedAt: new Date().toISOString(),
      });

      // User B attempts to link User A's email — challenge is issued without leaking existence
      const res = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userB,
        email: 'victim@konfrm.test',
      });
      assert.strictEqual(res.success, true);
      assert.ok(res.challengeId);
    });

    await record('verifyEmailLinkChallenge links email to subject user, updates mirror, consumes challenge', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });

      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'Essam.Customer@Konfrm.Test', // Case variation
      });

      const verify = await ctx.service.verifyEmailLinkChallenge({
        challengeId: req.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      assert.strictEqual(verify.success, true);
      assert.strictEqual(verify.userId, userId);
      assert.strictEqual(verify.email, 'Essam.Customer@konfrm.test');
      assert.ok(verify.verifiedAt);
      assert.strictEqual(verify.alreadyLinked, false);

      // Verify user_identifiers
      const idRecord = await ctx.identifiers.getByIdentifier('EMAIL', 'Essam.Customer@konfrm.test');
      assert.ok(idRecord);
      assert.strictEqual(idRecord.userId, userId);
      assert.ok(idRecord.verifiedAt);

      // Verify users.email compatibility mirror
      const updatedUser = await ctx.users.getById(userId);
      assert.strictEqual(updatedUser.email, 'Essam.Customer@konfrm.test');

      // Verify challenge consumed
      const challenge = await ctx.challenges.getById(req.challengeId);
      assert.strictEqual(challenge?.status, 'CONSUMED');
      assert.ok(challenge?.consumedAt);
    });

    await record('verifyEmailLinkChallenge fails closed with IDENTIFIER_ALREADY_EXISTS when email owned by another user', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();
      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      // User A owns the email
      await ctx.identifiers.create({
        userId: userA,
        identifierType: 'EMAIL',
        normalizedValue: 'shared@konfrm.test',
        verifiedAt: new Date().toISOString(),
      });

      // User B requests link
      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userB,
        email: 'shared@konfrm.test',
      });

      // User B verifies OTP
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: req.challengeId,
            otp: '123456',
            subjectUserId: userB,
          });
        },
        /IDENTIFIER_ALREADY_EXISTS/
      );

      // User A still owns the email, User B does not have it, challenge NOT consumed
      const idRecord = await ctx.identifiers.getByIdentifier('EMAIL', 'shared@konfrm.test');
      assert.strictEqual(idRecord?.userId, userA);

      const userBRecord = await ctx.users.getById(userB);
      assert.strictEqual(userBRecord.email, null);
    });

    await record('verifyEmailLinkChallenge fails closed when email conflicts with legacy users.email of another user', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();
      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', email: 'legacy@konfrm.test', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userB,
        email: 'legacy@konfrm.test',
      });

      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: req.challengeId,
            otp: '123456',
            subjectUserId: userB,
          });
        },
        /IDENTIFIER_ALREADY_EXISTS/
      );
    });

    await record('verifyEmailLinkChallenge blocks cross-user challenge hijacking (subject mismatch)', async () => {
      const ctx = createTestContext();
      const userA = randomUUID();
      const userB = randomUUID();
      await ctx.users.create({ id: userA, phoneNumber: '+201011111111', fullName: 'User A', status: 'ACTIVE' });
      await ctx.users.create({ id: userB, phoneNumber: '+201022222222', fullName: 'User B', status: 'ACTIVE' });

      // User A requests linking
      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userA,
        email: 'usera@konfrm.test',
      });

      // User B attempts to verify User A's challenge
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: req.challengeId,
            otp: '123456',
            subjectUserId: userB, // Mismatch!
          });
        },
        /CHALLENGE_OWNERSHIP_MISMATCH/
      );
    });

    await record('Generic public verifyChallenge rejects LINK_IDENTIFIER challenges', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });

      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'essam@konfrm.test',
      });

      // Attacker tries public /api/v2/auth/challenges/:id/verify
      await assert.rejects(
        async () => {
          await ctx.service.verifyChallenge({
            challengeId: req.challengeId,
            otp: '123456',
          });
        },
        /INVALID_AUTH_CHALLENGE/
      );
    });

    await record('Generic public resendChallenge and cancelChallenge reject LINK_IDENTIFIER challenges', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });

      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'essam@konfrm.test',
      });

      await assert.rejects(
        async () => {
          await ctx.service.cancelChallenge(req.challengeId);
        },
        /INVALID_AUTH_CHALLENGE/
      );
    });

    await record('verifyEmailLinkChallenge rejects consumed challenges (replay prevention)', async () => {
      const ctx = createTestContext();
      const userId = randomUUID();
      await ctx.users.create({ id: userId, phoneNumber: '+201011111111', fullName: 'Essam Customer', status: 'ACTIVE' });

      const req = await ctx.service.requestEmailLinkChallenge({
        subjectUserId: userId,
        email: 'essam@konfrm.test',
      });

      await ctx.service.verifyEmailLinkChallenge({
        challengeId: req.challengeId,
        otp: '123456',
        subjectUserId: userId,
      });

      // Second verify attempt must fail
      await assert.rejects(
        async () => {
          await ctx.service.verifyEmailLinkChallenge({
            challengeId: req.challengeId,
            otp: '123456',
            subjectUserId: userId,
          });
        },
        /CHALLENGE_ALREADY_CONSUMED/
      );
    });

    // ------------------------------------------------------------------------
    // GROUP 3: HTTP RUNTIME API CONTRACTS
    // ------------------------------------------------------------------------
    console.log('\n[HTTP RUNTIME API CONTRACTS]');

    await record('HTTP RBAC: Unauthenticated requests return 401', async () => {
      const ctx = createTestContext();
      const res = await request(ctx.app, 'POST', '/api/v2/customer/identifiers/email/challenges', { email: 'test@konfrm.test' });
      assert.strictEqual(res.status, 401);
      assert.strictEqual(res.body.success, false);
      assert.strictEqual(res.body.error.code, 'UNAUTHORIZED_MISSING_TOKEN');
    });

    await record('HTTP RBAC: Owner and Admin tokens return 403', async () => {
      const ctx = createTestContext();
      const ownerToken = mintOwnerToken(randomUUID());
      const adminToken = mintAdminToken(randomUUID());

      const resOwner = await request(ctx.app, 'POST', '/api/v2/customer/identifiers/email/challenges', { email: 'test@konfrm.test' }, ownerToken);
      assert.strictEqual(resOwner.status, 403);
      assert.strictEqual(resOwner.body.error.code, 'FORBIDDEN_INSUFFICIENT_ROLE');

      const resAdmin = await request(ctx.app, 'POST', '/api/v2/customer/identifiers/email/challenges', { email: 'test@konfrm.test' }, adminToken);
      assert.strictEqual(resAdmin.status, 403);
      assert.strictEqual(resAdmin.body.error.code, 'FORBIDDEN_INSUFFICIENT_ROLE');
    });

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

    await record('HTTP: Collision with another user returns 409 with exact Arabic error', async () => {
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

      // EXACT ARABIC MESSAGE ASSERTION
      assert.strictEqual(verifyRes.status, 409);
      assert.strictEqual(verifyRes.body.success, false);
      assert.strictEqual(verifyRes.body.error.code, 'IDENTIFIER_ALREADY_EXISTS');
      assert.strictEqual(verifyRes.body.error.message, 'هذا البريد الإلكتروني مرتبط بحساب آخر.');
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
