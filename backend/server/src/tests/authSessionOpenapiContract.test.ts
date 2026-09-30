import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import Ajv, { type ValidateFunction } from 'ajv';
import addFormats from 'ajv-formats';
import { parse } from 'yaml';

const syntheticEnvironment: Record<string, string> = {
  NODE_ENV: 'test',
  AUTH_V2_ENABLED: 'true',
  AUTH_ENVIRONMENT: 'test',
  AUTH_DELIVERY_MODE: 'DEVELOPMENT_FIXED_OTP',
  AUTH_DEVELOPMENT_OTP: '123456',
  AUTH_OTP_HMAC_SECRET: 'openapi-contract-test-hmac-secret-32-chars',
  JWT_ACCESS_SECRET: 'openapi-contract-test-access-secret-32-chars',
  JWT_REFRESH_SECRET: 'openapi-contract-test-refresh-secret-32-chars',
  SUPABASE_PROJECT_REF: 'konfrm-openapi-contract-test',
  SUPABASE_URL: 'http://127.0.0.1:54321',
  SUPABASE_SERVICE_ROLE_KEY: 'synthetic-openapi-contract-test-key',
  OBJECT_STORAGE_PROVIDER: 'supabase',
};
const previousEnvironment = new Map<string, string | undefined>();
for (const [key, value] of Object.entries(syntheticEnvironment)) {
  previousEnvironment.set(key, process.env[key]);
  process.env[key] = value;
}
previousEnvironment.set('DATABASE_URL', process.env.DATABASE_URL);
delete process.env.DATABASE_URL;

const specificationPath = resolve(process.cwd(), '../docs/api/openapi.yaml');
const specification = parse(readFileSync(specificationPath, 'utf8')) as any;
const ajv = new Ajv({ allErrors: true, strict: false, validateFormats: true });
addFormats(ajv);
const validators = new Map<string, ValidateFunction>();

function resolveSchemaReferences(value: any): any {
  if (Array.isArray(value)) return value.map(resolveSchemaReferences);
  if (!value || typeof value !== 'object') return value;
  if (typeof value.$ref === 'string') {
    assert(value.$ref.startsWith('#/'), `Only local OpenAPI refs are allowed in this single-file contract: ${value.$ref}`);
    const target = value.$ref.slice(2).split('/').map((part: string) => part.replace(/~1/g, '/').replace(/~0/g, '~'))
      .reduce((current: any, key: string) => current?.[key], specification);
    assert(target, `Unresolved OpenAPI schema reference: ${value.$ref}`);
    return resolveSchemaReferences(target);
  }
  return Object.fromEntries(Object.entries(value).map(([key, child]) => [key, resolveSchemaReferences(child)]));
}

function validateResponseSchema(path: string, method: string, status: number, body: unknown): void {
  const operation = specification.paths?.[path]?.[method.toLowerCase()];
  assert(operation, `Missing OpenAPI operation ${method} ${path}`);
  const response = operation.responses?.[String(status)];
  assert(response, `Undocumented wire response ${status} for ${method} ${path}`);
  const schema = response.content?.['application/json']?.schema;
  assert(schema, `Missing JSON response schema for ${status} ${method} ${path}`);
  const cacheKey = `${method}:${path}:${status}`;
  let validator = validators.get(cacheKey);
  if (!validator) {
    validator = ajv.compile(resolveSchemaReferences(schema));
    validators.set(cacheKey, validator);
  }
  assert(validator(body), `${method} ${path} ${status} response did not match OpenAPI schema: ${ajv.errorsText(validator.errors)}`);
}

function assertErrorCode(result: any, statusCode: number, code: string): void {
  assert.equal(result.statusCode, statusCode);
  assert.equal(result.body.success, false);
  assert.equal(result.body.error.code, code);
}

async function run(): Promise<void> {
  assert.equal(specification.openapi, '3.0.4');
  const expectedOperations: Record<string, string[]> = {
    '/api/v2/auth/challenges': ['post'],
    '/api/v2/auth/challenges/{challengeId}/verify': ['post'],
    '/api/v2/auth/challenges/{challengeId}/resend': ['post'],
    '/api/v2/auth/challenges/{challengeId}': ['delete'],
    '/api/v2/auth/registration/complete': ['post'],
    '/api/v1/auth/refresh': ['post'],
    '/api/v1/auth/revoke': ['post'],
  };
  assert.deepEqual(Object.keys(specification.paths).sort(), Object.keys(expectedOperations).sort(), 'The initial contract must contain exactly the seven approved paths.');
  for (const [path, methods] of Object.entries(expectedOperations)) {
    assert.deepEqual(Object.keys(specification.paths[path]).sort(), methods, `Unexpected method/domain added at ${path}.`);
  }

  // Dynamic imports happen only after forcing a non-production, localhost-only,
  // credential-free environment. All Auth V2 repositories below are in-memory.
  const [{ ExpressServerApp }, authRepos, { AuthV2Service }] = await Promise.all([
    import('../app.js'),
    import('../services/authV2Repository.js'),
    import('../services/authV2Service.js'),
  ]);
  const { randomUUID } = await import('node:crypto');

  function fixture(): { app: any; challenges: any } {
    const users = new authRepos.InMemoryUserRepository();
    const identifiers = new authRepos.InMemoryUserIdentifierRepository();
    const challenges = new authRepos.InMemoryAuthChallengeRepository();
    const rateLimits = new authRepos.InMemoryAuthRateLimitRepository();
    const sessions = new authRepos.InMemorySessionRepository();
    const service = new AuthV2Service({
      userRepo: users,
      userIdentifierRepo: identifiers,
      challengeRepo: challenges,
      rateLimitRepo: rateLimits,
      sessionRepo: sessions,
      config: {
        nodeEnv: 'test',
        authEnv: 'test',
        deliveryMode: 'DEVELOPMENT_FIXED_OTP',
        developmentOtp: '123456',
        hmacSecret: syntheticEnvironment.AUTH_OTP_HMAC_SECRET,
      },
    });
    return { app: new ExpressServerApp({ authV2ServiceFactory: () => service }), challenges };
  }

  async function request(app: any, method: string, path: string, body?: unknown): Promise<any> {
    const result = await app.handleHttpRequest(method, path, {}, body);
    // createHttpServer serializes each result through JSON.stringify; normalize
    // here as well so undefined optional fields are tested as absent, not null.
    const wireBody = JSON.parse(JSON.stringify(result.body));
    const contractPath = path
      .replace(/^\/api\/v2\/auth\/challenges\/[^/]+\/verify$/, '/api/v2/auth/challenges/{challengeId}/verify')
      .replace(/^\/api\/v2\/auth\/challenges\/[^/]+\/resend$/, '/api/v2/auth/challenges/{challengeId}/resend')
      .replace(/^\/api\/v2\/auth\/challenges\/[^/]+$/, '/api/v2/auth/challenges/{challengeId}');
    validateResponseSchema(contractPath, method, result.statusCode, wireBody);
    return { statusCode: result.statusCode, body: wireBody };
  }

  const phone = (suffix: string) => `+2010${suffix.padStart(8, '0').slice(-8)}`;

  // 1. POST challenge — real AuthV2Service + isolated in-memory repositories.
  const issueFixture = fixture();
  const issue = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'CREATE_ACCOUNT', method: 'PHONE', identifier: phone('2101'),
  });
  assert.equal(issue.statusCode, 200);
  assert.equal(issue.body.data.method, 'PHONE');
  const invalidPhone = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: '+123',
  });
  assertErrorCode(invalidPhone, 400, 'INVALID_EGYPTIAN_MOBILE_NUMBER');
  const invalidEmail = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'EMAIL', identifier: 'new@invalid-domain',
  });
  assertErrorCode(invalidEmail, 400, 'INVALID_EMAIL_DOMAIN');
  let rateLimit: any;
  for (let attempt = 0; attempt < 6; attempt += 1) {
    rateLimit = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges', {
      surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: phone('2101'),
    });
  }
  assertErrorCode(rateLimit, 429, 'RATE_LIMIT_EXCEEDED');
  const badIssue = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'OWNER', intent: 'LOGIN', method: 'PHONE', identifier: phone('2102'),
  });
  assertErrorCode(badIssue, 400, 'INVALID_AUTH_REQUEST');

  // 2. Verify new Customer continuation and complete account creation.
  const verifyPath = `/api/v2/auth/challenges/${issue.body.data.challengeId}/verify`;
  const newPhoneVerify = await request(issueFixture.app, 'POST', verifyPath, { otp: '123456' });
  assert.equal(newPhoneVerify.statusCode, 200);
  assert.equal(newPhoneVerify.body.data.isExistingUser, false);
  assert.equal(newPhoneVerify.body.data.requiresFullName, true);
  assert.equal('requiresSignup' in newPhoneVerify.body.data, false);
  assert.equal('user' in newPhoneVerify.body.data, false);
  assert.equal('tokens' in newPhoneVerify.body.data, false);
  const complete = await request(issueFixture.app, 'POST', '/api/v2/auth/registration/complete', {
    continuationToken: newPhoneVerify.body.data.continuationToken,
    fullName: 'Contract Test Customer',
  });
  assert.equal(complete.statusCode, 201);
  assert.equal(complete.body.data.user.fullName, 'Contract Test Customer');
  assert.equal('phoneNumber' in complete.body.data.user, false);
  const replayedRegistration = await request(issueFixture.app, 'POST', '/api/v2/auth/registration/complete', {
    continuationToken: newPhoneVerify.body.data.continuationToken,
    fullName: 'Contract Test Customer',
  });
  assert.equal(replayedRegistration.statusCode, 409);

  const badVerify = await request(issueFixture.app, 'POST', verifyPath, { otp: '000000' });
  assertErrorCode(badVerify, 409, 'CHALLENGE_ALREADY_VERIFIED');
  const badChallengeId = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges/not-a-uuid/verify', { otp: '123456' });
  assertErrorCode(badChallengeId, 400, 'INVALID_CHALLENGE_ID');
  const missingChallenge = await request(issueFixture.app, 'POST', `/api/v2/auth/challenges/${randomUUID()}/verify`, { otp: '123456' });
  assertErrorCode(missingChallenge, 404, 'CHALLENGE_NOT_FOUND');
  const linkedChallengeId = randomUUID();
  issueFixture.challenges.store.set(linkedChallengeId, { intent: 'LINK_IDENTIFIER' });
  const linkedVerify = await request(issueFixture.app, 'POST', `/api/v2/auth/challenges/${linkedChallengeId}/verify`, { otp: '123456' });
  assertErrorCode(linkedVerify, 400, 'INVALID_AUTH_CHALLENGE');
  const invalidOtpFixture = fixture();
  const issuedForBadOtp = await request(invalidOtpFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: phone('2103'),
  });
  const invalidOtp = await request(invalidOtpFixture.app, 'POST', `/api/v2/auth/challenges/${issuedForBadOtp.body.data.challengeId}/verify`, { otp: '000000' });
  assertErrorCode(invalidOtp, 400, 'INVALID_OTP');

  // Verify the alternative existing-Customer and new-LOGIN outcome shapes.
  const existingId = randomUUID();
  const existingPhone = phone('2104');
  // Seed a distinct in-memory repository set so this exercises the existing-user branch.
  const existingUsers = new authRepos.InMemoryUserRepository();
  const existingIdentifiers = new authRepos.InMemoryUserIdentifierRepository();
  const existingChallenges = new authRepos.InMemoryAuthChallengeRepository();
  const existingSessions = new authRepos.InMemorySessionRepository();
  await existingUsers.create({ id: existingId, phoneNumber: existingPhone, fullName: 'Existing Test Customer', status: 'ACTIVE' });
  await existingIdentifiers.create({ userId: existingId, identifierType: 'PHONE', normalizedValue: existingPhone, verifiedAt: new Date().toISOString() });
  const existingService = new AuthV2Service({
    userRepo: existingUsers, userIdentifierRepo: existingIdentifiers, challengeRepo: existingChallenges,
    rateLimitRepo: new authRepos.InMemoryAuthRateLimitRepository(), sessionRepo: existingSessions,
    config: { nodeEnv: 'test', authEnv: 'test', deliveryMode: 'DEVELOPMENT_FIXED_OTP', developmentOtp: '123456', hmacSecret: syntheticEnvironment.AUTH_OTP_HMAC_SECRET },
  });
  const existingApp = new ExpressServerApp({ authV2ServiceFactory: () => existingService });
  const existingIssue = await request(existingApp, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: existingPhone,
  });
  const existingVerify = await request(existingApp, 'POST', `/api/v2/auth/challenges/${existingIssue.body.data.challengeId}/verify`, { otp: '123456' });
  assert.equal(existingVerify.body.data.isExistingUser, true);
  assert.equal(existingVerify.body.data.user.id, existingId);
  assert.ok(existingVerify.body.data.tokens.accessToken);
  assert.equal('continuationToken' in existingVerify.body.data, false);
  assert.equal('requiresFullName' in existingVerify.body.data, false);
  assert.equal('requiresSignup' in existingVerify.body.data, false);

  const newLoginFixture = fixture();
  const newLoginIssue = await request(newLoginFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'EMAIL', identifier: 'new-login@example.test',
  });
  const newLoginVerify = await request(newLoginFixture.app, 'POST', `/api/v2/auth/challenges/${newLoginIssue.body.data.challengeId}/verify`, { otp: '123456' });
  assert.equal(newLoginVerify.body.data.method, 'EMAIL');
  assert.equal(newLoginVerify.body.data.requiresSignup, true);
  assert.equal('requiresFullName' in newLoginVerify.body.data, false);

  // 3. Resend success and cooldown negative, with only a synthetic in-memory clock adjustment.
  const resendFixture = fixture();
  const resendIssue = await request(resendFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: phone('2105'),
  });
  const storedChallenge = (resendFixture.challenges as any).store.get(resendIssue.body.data.challengeId);
  storedChallenge.resendAvailableAt = new Date(Date.now() - 1_000).toISOString();
  const resendPath = `/api/v2/auth/challenges/${resendIssue.body.data.challengeId}/resend`;
  const resent = await request(resendFixture.app, 'POST', resendPath, {});
  assert.equal(resent.statusCode, 200);
  assert.equal(resent.body.data.challengeId, resendIssue.body.data.challengeId);
  const resendCooldown = await request(resendFixture.app, 'POST', resendPath, {});
  assertErrorCode(resendCooldown, 429, 'RESEND_COOLDOWN_ACTIVE');
  const resendMissing = await request(resendFixture.app, 'POST', `/api/v2/auth/challenges/${randomUUID()}/resend`, {});
  assertErrorCode(resendMissing, 404, 'CHALLENGE_NOT_FOUND');
  const linkedResendId = randomUUID();
  resendFixture.challenges.store.set(linkedResendId, { intent: 'LINK_IDENTIFIER' });
  const linkedResend = await request(resendFixture.app, 'POST', `/api/v2/auth/challenges/${linkedResendId}/resend`, {});
  assertErrorCode(linkedResend, 400, 'INVALID_AUTH_CHALLENGE');

  // 4. DELETE challenge success and malformed path failure.
  const cancelFixture = fixture();
  const cancelIssue = await request(cancelFixture.app, 'POST', '/api/v2/auth/challenges', {
    surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: phone('2106'),
  });
  const cancelled = await request(cancelFixture.app, 'DELETE', `/api/v2/auth/challenges/${cancelIssue.body.data.challengeId}`);
  assert.equal(cancelled.statusCode, 200);
  const malformedCancel = await request(cancelFixture.app, 'DELETE', '/api/v2/auth/challenges/not-a-uuid');
  assertErrorCode(malformedCancel, 400, 'INVALID_CHALLENGE_ID');
  const linkedCancelId = randomUUID();
  cancelFixture.challenges.store.set(linkedCancelId, { intent: 'LINK_IDENTIFIER' });
  const linkedCancel = await request(cancelFixture.app, 'DELETE', `/api/v2/auth/challenges/${linkedCancelId}`);
  assertErrorCode(linkedCancel, 400, 'INVALID_AUTH_CHALLENGE');
  const cancelledUnknown = await request(cancelFixture.app, 'DELETE', `/api/v2/auth/challenges/${randomUUID()}`);
  assert.equal(cancelledUnknown.statusCode, 200, 'Cancelling a valid unknown challenge ID is idempotent success.');

  // Registration negative path is still exercised at the actual HTTP router.
  const invalidRegistration = await request(issueFixture.app, 'POST', '/api/v2/auth/registration/complete', { continuationToken: '', fullName: '' });
  assertErrorCode(invalidRegistration, 400, 'INVALID_FULL_NAME');
  const invalidContinuation = await request(issueFixture.app, 'POST', '/api/v2/auth/registration/complete', {
    continuationToken: 'not-a-signed-continuation-token', fullName: 'Contract Test Customer',
  });
  assertErrorCode(invalidContinuation, 400, 'INVALID_CONTINUATION_TOKEN');

  const previousAuthV2Enabled = process.env.AUTH_V2_ENABLED;
  try {
    process.env.AUTH_V2_ENABLED = 'false';
    const disabledRegistration = await request(issueFixture.app, 'POST', '/api/v2/auth/registration/complete', {
      continuationToken: 'synthetic-continuation-token',
      fullName: 'Contract Test Customer',
    });
    assertErrorCode(disabledRegistration, 404, 'AUTH_V2_UNAVAILABLE');

    const disabled = await request(issueFixture.app, 'POST', '/api/v2/auth/challenges', {
      surface: 'CUSTOMER', intent: 'LOGIN', method: 'PHONE', identifier: phone('2199'),
    });
    assertErrorCode(disabled, 404, 'AUTH_V2_UNAVAILABLE');
  } finally {
    if (previousAuthV2Enabled === undefined) delete process.env.AUTH_V2_ENABLED;
    else process.env.AUTH_V2_ENABLED = previousAuthV2Enabled;
  }

  // 6/7. Existing v1 wire envelopes stay owned by AuthController. Replace only
  // its underlying service methods with deterministic isolated stubs; the real
  // ExpressServerApp route and controller still produce and validate the wire body.
  const v1App = new ExpressServerApp();
  const authController = (v1App as any).authController;
  const originalRefresh = authController.authService.refreshSession;
  const originalRevoke = authController.authService.revokeSession;
  try {
    authController.authService.refreshSession = async (refreshToken: string) => {
      assert.equal(refreshToken, 'synthetic-refresh-token');
      return { accessToken: 'synthetic-access-token', expiresIn: 900 };
    };
    const refresh = await request(v1App, 'POST', '/api/v1/auth/refresh', { refreshToken: 'synthetic-refresh-token' });
    assert.equal(refresh.statusCode, 200);

    authController.authService.refreshSession = async () => { throw new Error('SESSION_REVOKED'); };
    const refreshRejected = await request(v1App, 'POST', '/api/v1/auth/refresh', { refreshToken: 'synthetic-refresh-token' });
    assert.equal(refreshRejected.statusCode, 401);
    assertErrorCode(refreshRejected, 401, 'SESSION_REVOKED');

    authController.authService.revokeSession = async (refreshToken: string | undefined) => ({ success: !refreshToken || typeof refreshToken === 'string' });
    const revoke = await request(v1App, 'POST', '/api/v1/auth/revoke');
    assert.equal(revoke.statusCode, 200);
    assert.equal(revoke.body.data.success, true);

    authController.authService.revokeSession = async () => { throw new Error('synthetic persistence failure'); };
    const revokeError = await request(v1App, 'POST', '/api/v1/auth/revoke', { refreshToken: 'synthetic-refresh-token' });
    assert.equal(revokeError.statusCode, 400);
  } finally {
    authController.authService.refreshSession = originalRefresh;
    authController.authService.revokeSession = originalRevoke;
  }

  console.log('PASS OpenAPI 3.0.4 exact seven-operation scope');
  console.log('PASS 7 real ExpressServerApp routes: status/envelope/schema conformance');
  console.log('PASS V2 existing/new account conditional verify wire branches (PHONE + EMAIL)');
  console.log('PASS malformed challenge/OTP/registration, not-found, conflict, and resend cooldown error bodies');
  console.log('PASS V1 refresh/revoke remain v1-specific response envelopes');
}

run().finally(() => {
  for (const [key, value] of previousEnvironment) {
    if (value === undefined) delete process.env[key];
    else process.env[key] = value;
  }
}).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
