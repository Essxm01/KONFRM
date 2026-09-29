/**
 * Suite 19: AUTH-03 Renter Real Account + Auth & Profile UX
 * Master Source of Truth: AUTH-03 Specification
 */

import { ExpressServerApp } from '../app.js';
import { AuthService } from '../services/authService.js';
import { signAccessToken } from '../services/jwtService.js';
import { userDb, propertyDb } from '../services/dbRepository.js';

export async function runAuth03Tests(): Promise<{ name: string; passed: boolean; error?: string }[]> {
  process.env.JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET || 'test_jwt_access_secret_for_unit_tests_only_32char';
  process.env.JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || 'test_jwt_refresh_secret_for_unit_tests_only_32char';

  const results: { name: string; passed: boolean; error?: string }[] = [];
  const app = new ExpressServerApp();

  // Test 1: GET /api/v1/customer/profile with valid ROLE_CUSTOMER returns profile
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: '+201012345678',
      phoneVerifiedAt: '2026-09-01T00:00:00.000Z',
      fullName: 'أحمد محمود',
      email: null,
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-01T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: { value: '+201012345678', verifiedAt: '2026-09-01T00:00:00.000Z' },
      email: null,
    });

    try {
      const response = await app.handleHttpRequest(
        'GET',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        {}
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      if (!response.body.success || response.body.data?.id !== testUserId) {
        throw new Error(`Expected profile for ${testUserId}, got ${JSON.stringify(response.body)}`);
      }

      results.push({ name: '[19.1] Customer Profile GET Returns Real Identity', passed: true });
    } finally {
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.1] Customer Profile GET Returns Real Identity', passed: false, error: err.message });
  }

  // Test 2: PATCH /api/v1/customer/profile updates full_name
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const newName = 'أحمد محمود القاضي';
    const origUpdateProfile = userDb.updateProfile;
    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    (userDb as any).updateProfile = async (id: string, payload: any) => null;
    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: '+201012345678',
      phoneVerifiedAt: '2026-09-01T00:00:00.000Z',
      fullName: newName,
      email: null,
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-02T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: { value: '+201012345678', verifiedAt: '2026-09-01T00:00:00.000Z' },
      email: null,
    });

    try {
      const response = await app.handleHttpRequest(
        'PATCH',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        { fullName: newName }
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      if (response.body.data?.fullName !== newName) {
        throw new Error(`Expected fullName to be "${newName}", got "${response.body.data?.fullName}"`);
      }

      results.push({ name: '[19.2] Customer Profile PATCH Updates Full Name in users', passed: true });
    } finally {
      (userDb as any).updateProfile = origUpdateProfile;
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.2] Customer Profile PATCH Updates Full Name in users', passed: false, error: err.message });
  }

  // Test 3: PATCH /api/v1/customer/profile rejects invalid name (<2 chars)
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const response = await app.handleHttpRequest(
      'PATCH',
      '/api/v1/customer/profile',
      { authorization: `Bearer ${customerToken}` },
      { fullName: 'أ' }
    );

    if (response.statusCode !== 400 || response.body.error?.code !== 'INVALID_FULL_NAME') {
      throw new Error(`Expected 400 INVALID_FULL_NAME, got ${response.statusCode} (${response.body.error?.code})`);
    }

    results.push({ name: '[19.3] Customer Profile PATCH Rejects Invalid Short Name (400)', passed: true });
  } catch (err: any) {
    results.push({ name: '[19.3] Customer Profile PATCH Rejects Invalid Short Name (400)', passed: false, error: err.message });
  }

  // Test 4: Role Isolation: ROLE_OWNER cannot access /api/v1/customer/profile
  try {
    const ownerToken = signAccessToken({
      sub: '00000000-0000-4000-8000-201012345678',
      role: 'ROLE_OWNER',
      phone: '+201012345678',
    });

    const response = await app.handleHttpRequest(
      'GET',
      '/api/v1/customer/profile',
      { authorization: `Bearer ${ownerToken}` },
      {}
    );

    if (response.statusCode !== 403) {
      throw new Error(`Expected status 403 Forbidden for ROLE_OWNER on customer route, got ${response.statusCode}`);
    }

    results.push({ name: '[19.4] Role Isolation: OWNER Token Forbidden on Customer Profile (403)', passed: true });
  } catch (err: any) {
    results.push({ name: '[19.4] Role Isolation: OWNER Token Forbidden on Customer Profile (403)', passed: false, error: err.message });
  }

  // Test 5: Public Search Route is accessible without auth
  try {
    const origSearch = propertyDb.searchPublic;
    (propertyDb as any).searchPublic = async () => [];
    try {
      const response = await app.handleHttpRequest(
        'GET',
        '/api/v1/customer/properties/search',
        {},
        {}
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200 for public search, got ${response.statusCode}`);
      }

      results.push({ name: '[19.5] Public Search Route Accessible Unauthenticated (200)', passed: true });
    } finally {
      (propertyDb as any).searchPublic = origSearch;
    }
  } catch (err: any) {
    results.push({ name: '[19.5] Public Search Route Accessible Unauthenticated (200)', passed: false, error: err.message });
  }

  // Test 6: Unauthenticated Profile Request is Rejected (401)
  try {
    const response = await app.handleHttpRequest(
      'GET',
      '/api/v1/customer/profile',
      {},
      {}
    );

    if (response.statusCode !== 401) {
      throw new Error(`Expected status 401 for unauthenticated profile request, got ${response.statusCode}`);
    }

    results.push({ name: '[19.6] Protected Profile Requires Valid Authentication (401)', passed: true });
  } catch (err: any) {
    results.push({ name: '[19.6] Protected Profile Requires Valid Authentication (401)', passed: false, error: err.message });
  }

  // Test 7: PATCH /api/v1/customer/profile rejects direct email mutation
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const response = await app.handleHttpRequest(
      'PATCH',
      '/api/v1/customer/profile',
      { authorization: `Bearer ${customerToken}` },
      { email: 'new.email@example.com' }
    );

    if (
      response.statusCode !== 400 ||
      response.body.error?.code !== 'PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION' ||
      response.body.error?.message !== 'تغيير البريد الإلكتروني أو الهاتف يتطلب تأكيد الرمز'
    ) {
      throw new Error(`Expected 400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION, got ${response.statusCode} (${response.body.error?.code})`);
    }

    results.push({ name: '[19.7] Customer Profile PATCH Rejects Direct Email Mutation (400)', passed: true });
  } catch (err: any) {
    results.push({ name: '[19.7] Customer Profile PATCH Rejects Direct Email Mutation (400)', passed: false, error: err.message });
  }

  // Test 8: PATCH /api/v1/customer/profile rejects direct phone mutation
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const response = await app.handleHttpRequest(
      'PATCH',
      '/api/v1/customer/profile',
      { authorization: `Bearer ${customerToken}` },
      { phoneNumber: '+201099998888' }
    );

    if (
      response.statusCode !== 400 ||
      response.body.error?.code !== 'PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION'
    ) {
      throw new Error(`Expected 400 PROFILE_IDENTIFIER_CHANGE_REQUIRES_VERIFICATION, got ${response.statusCode} (${response.body.error?.code})`);
    }

    results.push({ name: '[19.8] Customer Profile PATCH Rejects Direct Phone Mutation (400)', passed: true });
  } catch (err: any) {
    results.push({ name: '[19.8] Customer Profile PATCH Rejects Direct Phone Mutation (400)', passed: false, error: err.message });
  }

  // Test 9: GET /api/v1/customer/profile returns canonical verified PHONE identity
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: '+201012345678',
      phoneVerifiedAt: '2026-09-01T00:00:00.000Z',
      fullName: 'أحمد محمود',
      email: null,
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-01T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: { value: '+201012345678', verifiedAt: '2026-09-01T00:00:00.000Z' },
      email: null,
    });

    try {
      const response = await app.handleHttpRequest(
        'GET',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        {}
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      const data = response.body.data;
      if (!data?.verifiedIdentifiers?.phone || data.verifiedIdentifiers.phone.value !== '+201012345678') {
        throw new Error(`Expected verified phone, got ${JSON.stringify(data?.verifiedIdentifiers)}`);
      }
      if (data?.verifiedIdentifiers?.email !== null) {
        throw new Error(`Expected verified email to be null, got ${JSON.stringify(data?.verifiedIdentifiers?.email)}`);
      }

      results.push({ name: '[19.9] Customer Profile GET Returns Verified Phone Identity', passed: true });
    } finally {
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.9] Customer Profile GET Returns Verified Phone Identity', passed: false, error: err.message });
  }

  // Test 10: GET /api/v1/customer/profile returns verified EMAIL for Email-First (phoneNumber null)
  try {
    const testUserId = '00000000-0000-4000-8000-000000000002';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
    });

    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: null,
      phoneVerifiedAt: null,
      fullName: 'عميل بريد',
      email: 'customer@konfrm.eg',
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-01T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: null,
      email: { value: 'customer@konfrm.eg', verifiedAt: '2026-09-01T00:00:00.000Z' },
    });

    try {
      const response = await app.handleHttpRequest(
        'GET',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        {}
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      const data = response.body.data;
      if (data.phoneNumber !== null) {
        throw new Error(`Expected phoneNumber to be null for Email-First, got ${data.phoneNumber}`);
      }
      if (!data?.verifiedIdentifiers?.email || data.verifiedIdentifiers.email.value !== 'customer@konfrm.eg') {
        throw new Error(`Expected verified email, got ${JSON.stringify(data?.verifiedIdentifiers)}`);
      }
      if (data?.verifiedIdentifiers?.phone !== null) {
        throw new Error(`Expected verified phone to be null, got ${JSON.stringify(data?.verifiedIdentifiers?.phone)}`);
      }

      results.push({ name: '[19.10] Email-First Customer Returns Verified Email with Null Phone', passed: true });
    } finally {
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.10] Email-First Customer Returns Verified Email with Null Phone', passed: false, error: err.message });
  }

  // Test 11: Dual identifier Customer returns both canonical verified identifiers
  try {
    const testUserId = '00000000-0000-4000-8000-000000000003';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: '+201012345678',
      phoneVerifiedAt: '2026-09-01T00:00:00.000Z',
      fullName: 'عميل مزدوج',
      email: 'dual@konfrm.eg',
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-01T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: { value: '+201012345678', verifiedAt: '2026-09-01T00:00:00.000Z' },
      email: { value: 'dual@konfrm.eg', verifiedAt: '2026-09-01T00:00:00.000Z' },
    });

    try {
      const response = await app.handleHttpRequest(
        'GET',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        {}
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      const data = response.body.data;
      if (!data?.verifiedIdentifiers?.phone || data.verifiedIdentifiers.phone.value !== '+201012345678') {
        throw new Error(`Expected verified phone, got ${JSON.stringify(data?.verifiedIdentifiers)}`);
      }
      if (!data?.verifiedIdentifiers?.email || data.verifiedIdentifiers.email.value !== 'dual@konfrm.eg') {
        throw new Error(`Expected verified email, got ${JSON.stringify(data?.verifiedIdentifiers)}`);
      }

      results.push({ name: '[19.11] Dual Identifier Customer Returns Both Verified Identifiers', passed: true });
    } finally {
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.11] Dual Identifier Customer Returns Both Verified Identifiers', passed: false, error: err.message });
  }

  // Test 12: Legacy users.email alone without verified record in user_identifiers is NOT verified
  try {
    const testUserId = '00000000-0000-4000-8000-000000000004';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: '+201012345678',
      phoneVerifiedAt: '2026-09-01T00:00:00.000Z',
      fullName: 'عميل قديم',
      email: 'legacy.unverified@example.com',
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-01T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: { value: '+201012345678', verifiedAt: '2026-09-01T00:00:00.000Z' },
      email: null, // No verified email in user_identifiers
    });

    try {
      const response = await app.handleHttpRequest(
        'GET',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        {}
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      const data = response.body.data;
      if (data.email !== 'legacy.unverified@example.com') {
        throw new Error(`Expected legacy email preserved, got ${data.email}`);
      }
      if (data?.verifiedIdentifiers?.email !== null) {
        throw new Error(`Expected unverified legacy email NOT to be in verifiedIdentifiers, got ${JSON.stringify(data?.verifiedIdentifiers?.email)}`);
      }

      results.push({ name: '[19.12] Unverified Legacy users.email is NOT Represented as Verified Identity', passed: true });
    } finally {
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.12] Unverified Legacy users.email is NOT Represented as Verified Identity', passed: false, error: err.message });
  }

  // Test 13: PATCH /customer/profile updates fullName without modifying user_identifiers
  try {
    const testUserId = '00000000-0000-4000-8000-201012345678';
    const customerToken = signAccessToken({
      sub: testUserId,
      role: 'ROLE_CUSTOMER',
      phone: '+201012345678',
    });

    const origUpdateProfile = userDb.updateProfile;
    const origGetById = userDb.getById;
    const origGetVerified = userDb.getVerifiedIdentifiers;

    let updatePayload: any = null;
    (userDb as any).updateProfile = async (id: string, payload: any) => {
      updatePayload = payload;
      return null;
    };
    (userDb as any).getById = async () => ({
      id: testUserId,
      phoneNumber: '+201012345678',
      phoneVerifiedAt: '2026-09-01T00:00:00.000Z',
      fullName: 'مستأجر محدث',
      email: 'existing@konfrm.eg',
      avatarUrl: null,
      status: 'ACTIVE',
      createdAt: '2026-09-01T00:00:00.000Z',
      updatedAt: '2026-09-02T00:00:00.000Z',
    });
    (userDb as any).getVerifiedIdentifiers = async () => ({
      phone: { value: '+201012345678', verifiedAt: '2026-09-01T00:00:00.000Z' },
      email: null,
    });

    try {
      const response = await app.handleHttpRequest(
        'PATCH',
        '/api/v1/customer/profile',
        { authorization: `Bearer ${customerToken}` },
        { fullName: 'مستأجر محدث' }
      );

      if (response.statusCode !== 200) {
        throw new Error(`Expected status 200, got ${response.statusCode}`);
      }
      if (updatePayload?.email !== undefined) {
        throw new Error(`updateProfile must not receive email in payload, got ${JSON.stringify(updatePayload)}`);
      }
      if (updatePayload?.fullName !== 'مستأجر محدث') {
        throw new Error(`Expected fullName update, got ${updatePayload?.fullName}`);
      }

      results.push({ name: '[19.13] Profile PATCH Updates Full Name Without Mutating Identifiers', passed: true });
    } finally {
      (userDb as any).updateProfile = origUpdateProfile;
      (userDb as any).getById = origGetById;
      (userDb as any).getVerifiedIdentifiers = origGetVerified;
    }
  } catch (err: any) {
    results.push({ name: '[19.13] Profile PATCH Updates Full Name Without Mutating Identifiers', passed: false, error: err.message });
  }

  return results;
}

if (process.argv[1]?.includes('auth03CustomerProfile')) {
  runAuth03Tests().then((res) => {
    console.log(JSON.stringify(res, null, 2));
    const failed = res.filter((r) => !r.passed);
    if (failed.length > 0) {
      console.error(`${failed.length} tests failed!`);
      process.exit(1);
    }
    console.log(`All ${res.length} auth03 tests passed!`);
  });
}
