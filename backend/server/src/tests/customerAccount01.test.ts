/**
 * Sola / Konfrm Vacation Rentals — CUSTOMER ACCOUNT-01: Professional Renter Account Hub Test Suite
 * Location: server/src/tests/customerAccount01.test.ts
 */

import { ExpressServerApp } from '../app.js';
import { AuthService, dbUsersStore, dbOwnersStore } from '../services/authService.js';
import { userDb, bookingDb } from '../services/dbRepository.js';
import { signAccessToken } from '../services/jwtService.js';
import type { TestResult } from './authSecurity.test.js';

export async function runCustomerAccount01Suite(): Promise<{ total: number; passed: number; failed: number; results: TestResult[] }> {
  const results: TestResult[] = [];
  const app = new ExpressServerApp();
  const authService = new AuthService();

  const randSuffix = Math.floor(100000 + Math.random() * 900000).toString();
  // Test Customer Identity
  const customerPhone = `+2010${randSuffix}01`;
  const customerId = crypto.randomUUID();

  dbUsersStore.set(customerPhone, {
    id: customerId,
    phoneNumber: customerPhone,
    phoneVerifiedAt: new Date().toISOString(),
    fullName: 'يوسف أحمد القاضي',
    email: 'youssef@example.eg',
    avatarUrl: null,
    status: 'ACTIVE',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  });

  const customerToken = signAccessToken({
    sub: customerId,
    role: 'ROLE_CUSTOMER',
    phone: customerPhone,
  });

  // --------------------------------------------------------------------------
  // TEST 1: GET /api/v1/customer/account/summary returns real metrics (200 OK)
  // --------------------------------------------------------------------------
  try {
    const res = await app.handleHttpRequest('GET', '/api/v1/customer/account/summary', {
      authorization: `Bearer ${customerToken}`,
    });

    const is200 = res.statusCode === 200;
    const body = res.body;
    const hasMetrics =
      body.success === true &&
      typeof body.data.confirmedBookingsCount === 'number' &&
      typeof body.data.upcomingStaysCount === 'number' &&
      typeof body.data.totalBookingsCount === 'number' &&
      typeof body.data.totalDepositsPaidEgp === 'number';

    results.push({
      name: '[20.1] Customer Account Summary GET Returns Real Financial/Stay Metrics (200 OK)',
      passed: is200 && hasMetrics,
      error: is200 && hasMetrics ? undefined : `Expected 200 with metric counts, got ${res.statusCode} body: ${JSON.stringify(body)}`,
    });
  } catch (err: any) {
    results.push({ name: '[20.1] Customer Account Summary GET', passed: false, error: err.message });
  }

  // --------------------------------------------------------------------------
  // TEST 2: GET /api/v1/customer/payments returns real ledger & hides owner financial data
  // --------------------------------------------------------------------------
  try {
    const res = await app.handleHttpRequest('GET', '/api/v1/customer/payments', {
      authorization: `Bearer ${customerToken}`,
    });

    const is200 = res.statusCode === 200;
    const body = res.body;
    const isArray = body.success === true && Array.isArray(body.data);

    // Verify zero leakage of owner commission or owner net
    const bodyString = JSON.stringify(body);
    const noOwnerNetLeak = !bodyString.includes('ownerNet') && !bodyString.includes('solaCommission');

    results.push({
      name: '[20.2] Customer Payments Endpoint Returns Real Ledger & Strictly Hides Owner Net/Commission',
      passed: is200 && isArray && noOwnerNetLeak,
      error: is200 && isArray && noOwnerNetLeak ? undefined : `Leak check failed or invalid status: ${res.statusCode}`,
    });
  } catch (err: any) {
    results.push({ name: '[20.2] Customer Payments Ledger', passed: false, error: err.message });
  }

  // --------------------------------------------------------------------------
  // TEST 3: Unauthenticated Access to /customer/account/summary & /customer/payments (401)
  // --------------------------------------------------------------------------
  try {
    const resSummary = await app.handleHttpRequest('GET', '/api/v1/customer/account/summary');
    const resPayments = await app.handleHttpRequest('GET', '/api/v1/customer/payments');

    const blocked = resSummary.statusCode === 401 && resPayments.statusCode === 401;

    results.push({
      name: '[20.3] Unauthenticated Access to Account Summary & Payments Returns 401 Unauthorized',
      passed: blocked,
      error: blocked ? undefined : `Expected 401/401, got ${resSummary.statusCode}/${resPayments.statusCode}`,
    });
  } catch (err: any) {
    results.push({ name: '[20.3] Unauthenticated Account Access', passed: false, error: err.message });
  }

  // --------------------------------------------------------------------------
  // TEST 4: Role Isolation: OWNER Token Forbidden on Customer Account Routes (403)
  // --------------------------------------------------------------------------
  try {
    const ownerPhone = `+2010${randSuffix}02`;
    const ownerId = crypto.randomUUID();
    dbUsersStore.set(ownerPhone, { id: ownerId, phoneNumber: ownerPhone, status: 'ACTIVE', createdAt: new Date().toISOString(), updatedAt: new Date().toISOString() });
    dbOwnersStore.set(ownerId, { id: ownerId, phoneNumber: ownerPhone, fullName: 'مالك منفصل', status: 'ACTIVE', verificationStatus: 'VERIFIED', createdAt: new Date().toISOString(), updatedAt: new Date().toISOString() });

    const ownerToken = signAccessToken({
      sub: ownerId,
      role: 'ROLE_OWNER',
      phone: ownerPhone,
    });

    const resSummary = await app.handleHttpRequest('GET', '/api/v1/customer/account/summary', {
      authorization: `Bearer ${ownerToken}`,
    });

    const is403 = resSummary.statusCode === 403;

    results.push({
      name: '[20.4] Role Isolation: OWNER Token Forbidden on Customer Account Hub (403 Forbidden)',
      passed: is403,
      error: is403 ? undefined : `Expected 403, got ${resSummary.statusCode}`,
    });
  } catch (err: any) {
    results.push({ name: '[20.4] Role Isolation on Account Hub', passed: false, error: err.message });
  }

  // --------------------------------------------------------------------------
  // TEST 5: Customer Profile Update Does NOT Overwrite Independent Owner Profile
  // --------------------------------------------------------------------------
  try {
    const dualPhone = `+2010${randSuffix}03`;
    const dualId = crypto.randomUUID();

    // Seed canonical user and independent owner business profile
    dbUsersStore.set(dualPhone, {
      id: dualId,
      phoneNumber: dualPhone,
      fullName: 'مستأجر أصلي',
      status: 'ACTIVE',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    });
    dbOwnersStore.set(dualId, {
      id: dualId,
      phoneNumber: dualPhone,
      fullName: 'شركة الساحل للاستثمار العقاري',
      status: 'ACTIVE',
      verificationStatus: 'VERIFIED',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    });

    const custToken = signAccessToken({
      sub: dualId,
      role: 'ROLE_CUSTOMER',
      phone: dualPhone,
    });

    const origUpdateProfile = userDb.updateProfile;
    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;
    (userDb as any).updateProfile = async (id: string, data: any) => {
      const u = dbUsersStore.get(dualPhone);
      if (u) {
        if (data.fullName) u.fullName = data.fullName;
        dbUsersStore.set(dualPhone, u);
      }
      return u;
    };
    (userDb as any).getById = async (id: string) => {
      return dbUsersStore.get(dualPhone) || null;
    };
    (userDb as any).getVerifiedIdentifiers = async () => {
      return { phone: null, email: null };
    };

    try {
      // Customer updates their personal name
      const patchRes = await app.handleHttpRequest(
        'PATCH',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${custToken}` },
        { fullName: 'كريم محمود المنشاوي' }
      );

      const isPatchOk = patchRes.statusCode === 200;
      const updatedUser = dbUsersStore.get(dualPhone);
      const unchangedOwner = dbOwnersStore.get(dualId);

      const userUpdated = updatedUser?.fullName === 'كريم محمود المنشاوي';
      const ownerPreserved = unchangedOwner?.fullName === 'شركة الساحل للاستثمار العقاري';

      results.push({
        name: '[20.5] Data Integrity: Customer Profile Update Does NOT Mirror into or Overwrite Independent Owner Profile',
        passed: isPatchOk && userUpdated && ownerPreserved,
        error: isPatchOk && userUpdated && ownerPreserved ? undefined : `Integrity failed: patchOk=${isPatchOk} (status=${patchRes.statusCode}, body=${JSON.stringify(patchRes.body)}), userUpdated=${userUpdated}, ownerPreserved=${ownerPreserved}`,
      });
    } finally {
      (userDb as any).updateProfile = origUpdateProfile;
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[20.5] Profile Integrity & Decoupling', passed: false, error: err.message });
  }

  // --------------------------------------------------------------------------
  // TEST 6: Customer Profile Optional Email Update & Persistence (200 OK)
  // --------------------------------------------------------------------------
  try {
    const emailPhone = `+2010${randSuffix}04`;
    const emailUserId = crypto.randomUUID();

    dbUsersStore.set(emailPhone, {
      id: emailUserId,
      phoneNumber: emailPhone,
      fullName: 'مستأجر بريد',
      email: null,
      status: 'ACTIVE',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    });

    const emailAccessToken = signAccessToken({
      sub: emailUserId,
      role: 'ROLE_CUSTOMER',
      phone: emailPhone,
    });

    // 1. Attempt to update profile with email through PATCH /customer/profile must be rejected (Auth V2 protected identity)
    const patchAttempt = await app.handleHttpRequest(
      'PATCH',
      '/api/v1/customer/profile',
      { authorization: `Bearer ${emailAccessToken}` },
      { email: 'renter.test@konfrm.eg' }
    );

    const is400 = patchAttempt.statusCode === 400 &&
      patchAttempt.body.error?.code === 'PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION' &&
      patchAttempt.body.error?.message === 'تغيير البريد الإلكتروني أو الهاتف يتطلب تأكيد الرمز';

    results.push({
      name: '[20.6] Customer Profile PATCH Rejects Direct Email Mutation (400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION)',
      passed: is400,
      error: is400 ? undefined : `Expected 400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION, got ${patchAttempt.statusCode} (${patchAttempt.body?.error?.code})`,
    });
  } catch (err: any) {
    results.push({ name: '[20.6] Customer Profile Rejects Direct Email Mutation', passed: false, error: err.message });
  }

  // --------------------------------------------------------------------------
  // TEST 7: Customer Profile Rejects Direct Phone Mutation (400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION)
  // --------------------------------------------------------------------------
  try {
    const invPhone = `+2010${randSuffix}05`;
    const invUserId = crypto.randomUUID();

    dbUsersStore.set(invPhone, {
      id: invUserId,
      phoneNumber: invPhone,
      fullName: 'فحص الهاتف',
      email: null,
      status: 'ACTIVE',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    });

    const invAccessToken = signAccessToken({
      sub: invUserId,
      role: 'ROLE_CUSTOMER',
      phone: invPhone,
    });

    const badPatch = await app.handleHttpRequest(
      'PATCH',
      '/api/v1/customer/profile',
      { authorization: `Bearer ${invAccessToken}` },
      { phoneNumber: '+201099999999' }
    );

    const isPhoneRejected = badPatch.statusCode === 400 &&
      badPatch.body.error?.code === 'PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION' &&
      badPatch.body.error?.message === 'تغيير البريد الإلكتروني أو الهاتف يتطلب تأكيد الرمز';

    results.push({
      name: '[20.7] Customer Profile Rejects Direct Phone Mutation (400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION)',
      passed: isPhoneRejected,
      error: isPhoneRejected ? undefined : `Expected 400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION, got ${badPatch.statusCode}`,
    });
  } catch (err: any) {
    results.push({ name: '[20.7] Customer Profile Rejects Direct Phone Mutation', passed: false, error: err.message });
  }

  const passed = results.filter((r) => r.passed).length;
  const failed = results.filter((r) => !r.passed).length;
  return { total: results.length, passed, failed, results };
}

if (process.argv[1]?.includes('customerAccount01')) {
  runCustomerAccount01Suite().then((res) => {
    console.log(JSON.stringify(res, null, 2));
    if (res.failed > 0) {
      console.error(`${res.failed} tests failed!`);
      process.exit(1);
    }
    console.log(`All ${res.total} customerAccount01 tests passed!`);
  });
}
