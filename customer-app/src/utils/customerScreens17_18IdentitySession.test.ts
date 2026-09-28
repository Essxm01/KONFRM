// @ts-ignore The lightweight script runs under Node through the repository's tsx harness.
import { readFileSync } from 'node:fs';
import { resolveDisplayIdentifier } from '../components/CustomerAccountHomeScreen';
import {
  CustomerProfileIdentityIntegrityError,
  CustomerProfileUnauthorizedError,
  canonicalDisplayPhoneFromProfile,
  fetchCanonicalCustomerProfile,
} from './customerProfileSession';
import { mergeCustomerProfile } from './customerFavorites';
import type { CustomerUserProfile } from '../components/CustomerAuthModal';

declare const process: { exitCode?: number };

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(message);
}

function response(status: number, body: unknown): Response {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}

// tsx harness has no Vite env: stub the URL resolver like the Screen 15 suite does.
const passthroughUrl = (path: string): string => path;

const verifiedAt = '2026-09-28T00:00:00.000Z';

function profileWith(overrides: Partial<CustomerUserProfile>): CustomerUserProfile {
  return {
    id: 'usr_behavioral_01',
    fullName: 'أحمد التجريبي',
    ...overrides,
  } as CustomerUserProfile;
}

function canonicalPayload(overrides: Record<string, unknown>): Record<string, unknown> {
  return {
    id: 'usr_behavioral_01',
    phoneNumber: null,
    fullName: 'أحمد التجريبي',
    email: null,
    avatarUrl: null,
    phoneVerifiedAt: null,
    status: 'ACTIVE',
    createdAt: verifiedAt,
    updatedAt: verifiedAt,
    verifiedIdentifiers: { phone: null, email: null },
    ...overrides,
  };
}

async function expectError(
  action: () => Promise<unknown>,
  errorClass: (new (message?: string) => Error),
  label: string
): Promise<void> {
  let caught: unknown = null;
  try {
    await action();
  } catch (error) {
    caught = error;
  }
  assert(
    caught instanceof errorClass,
    `${label} must fail with ${errorClass.name} (got: ${caught instanceof Error ? caught.name : String(caught)})`
  );
}

async function run(): Promise<void> {
  console.log('Running Screens 17/18 Identity & Session Behavioral Suite (A–L)...');

  const appSource = readFileSync(new URL('../App.tsx', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const screen17Source = readFileSync(
    new URL('../components/CustomerAccountHomeScreen.tsx', import.meta.url),
    'utf8'
  ).replace(/\r\n/g, '\n');
  const screen18Source = readFileSync(
    new URL('../components/CustomerEditAccountPage.tsx', import.meta.url),
    'utf8'
  ).replace(/\r\n/g, '\n');

  // A. PHONE-only Customer: verified phone is the displayed login identity
  {
    const phoneOnly = profileWith({
      phoneNumber: '+201001234567',
      verifiedIdentifiers: { phone: { value: '+201001234567', verifiedAt }, email: null },
    });
    assert(
      resolveDisplayIdentifier(phoneOnly) === '+201001234567',
      'A Failed: PHONE-only customer must display the verified phone'
    );
    console.log('✓ A: PHONE-only customer displays verified phone');
  }

  // B. EMAIL-only Customer: verified email is the displayed login identity
  {
    const emailOnly = profileWith({
      email: 'sara@example.com',
      verifiedIdentifiers: { phone: null, email: { value: 'sara@example.com', verifiedAt } },
    });
    assert(
      resolveDisplayIdentifier(emailOnly) === 'sara@example.com',
      'B Failed: EMAIL-only customer must display the verified email'
    );
    console.log('✓ B: EMAIL-only customer displays verified email');
  }

  // C. PHONE + EMAIL Customer: phone is the primary identity; Screen 18 shows both rows
  {
    const dual = profileWith({
      phoneNumber: '+201099887766',
      email: 'mohamed@example.com',
      verifiedIdentifiers: {
        phone: { value: '+201099887766', verifiedAt },
        email: { value: 'mohamed@example.com', verifiedAt },
      },
    });
    assert(
      resolveDisplayIdentifier(dual) === '+201099887766',
      'C Failed: Dual-identifier customer must prioritize phone as primary identity'
    );
    assert(
      screen18Source.includes('label="رقم الهاتف"') && screen18Source.includes('label="البريد الإلكتروني"'),
      'C Failed: Screen 18 must render both verified phone and email rows'
    );
    console.log('✓ C: Dual identifiers prioritize phone; Screen 18 renders both');
  }

  // D. Account A phone → Account B Email-First switch: canonical null clears the legacy phone key
  {
    const accountA = profileWith({
      phoneNumber: '+201001234567',
      verifiedIdentifiers: { phone: { value: '+201001234567', verifiedAt }, email: null },
    });
    const accountBEmailFirst = { ...canonicalPayload({ email: 'b@example.com' }) };
    assert(
      canonicalDisplayPhoneFromProfile(accountA) === '+201001234567',
      'D Failed: Account A canonical phone must seed the display key'
    );
    assert(
      canonicalDisplayPhoneFromProfile(accountBEmailFirst as any) === null,
      'D Failed: Account B Email-First canonical profile must resolve to NO phone'
    );
    assert(
      appSource.includes("else {\n      setCustomerPhone(null);\n      localStorage.removeItem('sola_customer_phone');\n    }"),
      'D Failed: Canonical application must explicitly clear state + storage on phoneNumber === null'
    );
    assert(
      appSource.includes("localStorage.removeItem('sola_customer_phone');\n    setCustomerPhone(null);"),
      'D Failed: Auth V2 session replacement must clear the phone key before the new identity loads'
    );
    assert(
      appSource.includes("} else {\n      localStorage.removeItem('sola_customer_phone');\n      setCustomerPhone(null);\n    }"),
      'D Failed: Legacy login without a phone value must clear the key instead of seeding it'
    );
    console.log('✓ D: Email-First account switch clears the previous account phone');
  }

  // E. Zero stale Account A phone after switch: every identity-replacing path routes through the clear
  {
    assert(
      appSource.includes('applyCanonicalCustomerProfile(mergeCustomerProfile(profileJson.data))'),
      'E Failed: Session restoration must use the single canonical application path'
    );
    assert(
      appSource.includes('onUpdated={(updated, newAccessToken) => {\n              applyCanonicalCustomerProfile(updated);'),
      'E Failed: Profile save updates must apply through the canonical phone-clearing path'
    );
    assert(
      appSource.includes("if (phone) {\n      localStorage.setItem('sola_customer_phone', phone);"),
      'E Failed: Legacy login may seed the phone key only from its own session phone'
    );
    console.log('✓ E: All identity-replacing paths clear stale phone consistently');
  }

  // F. Screen 17 profile GET 401/403: typed unauthorized → centralized fail-closed invalidation
  {
    await expectError(
      () =>
        fetchCanonicalCustomerProfile('token-x', async () =>
          response(401, { success: false, error: { code: 'EXPIRED_ACCESS_TOKEN', message: 'انتهت صلاحية الجلسة' } })
        , passthroughUrl),
      CustomerProfileUnauthorizedError,
      'F: profile GET 401'
    );
    await expectError(
      () =>
        fetchCanonicalCustomerProfile('token-x', async () =>
          response(403, { success: false, error: { code: 'FORBIDDEN', message: 'ممنوع' } })
        , passthroughUrl),
      CustomerProfileUnauthorizedError,
      'F: profile GET 403'
    );
    assert(
      appSource.includes('if (err instanceof CustomerProfileUnauthorizedError) {\n        invalidateCustomerProfileSession();'),
      'F Failed: App must route profile 401/403 through the centralized session invalidation'
    );
    assert(
      appSource.includes('profileSessionExpired ||') &&
        appSource.includes('identityIntegrityFailed={Boolean(authToken && identityIntegrityFailed)}'),
      'F Failed: Screen 17 must expose profile session expiry and identity integrity states'
    );
    assert(
      appSource.includes("setUserProfile(null);\n    localStorage.removeItem('sola_customer_profile');\n    setCustomerPhone(null);\n    localStorage.removeItem('sola_customer_phone');\n  }, [])"),
      'F Failed: Invalidation must drop private profile identity state fail-closed'
    );
    console.log('✓ F: Profile GET 401/403 fails closed through centralized invalidation');
  }

  // G. Screen 18 profile GET 401/403: Session Expired UX + App-level invalidation callback
  {
    await expectError(
      () =>
        fetchCanonicalCustomerProfile('token-x', async () =>
          response(401, { success: false, error: { code: 'INVALID_TOKEN', message: 'رمز غير صالح' } })
        , passthroughUrl),
      CustomerProfileUnauthorizedError,
      'G: Screen 18 profile GET 401'
    );
    assert(
      screen18Source.includes('onSessionExpired?.()'),
      'G Failed: Screen 18 must invoke the App invalidation callback on canonical 401/403'
    );
    assert(
      appSource.includes('onSessionExpired={invalidateCustomerProfileSession}'),
      'G Failed: App must wire Screen 18 session expiry to centralized invalidation'
    );
    console.log('✓ G: Screen 18 401/403 fails closed to Session Expired and invalidates App state');
  }

  // H. Screen 18 dirty Back confirmation remains enforced
  {
    assert(
      screen18Source.includes('const handleBackClick = () => {') &&
        screen18Source.includes('if (isDirty) {') &&
        screen18Source.includes('setShowDiscardConfirm(true)'),
      'H Failed: Dirty back navigation must require explicit confirmation'
    );
    assert(
      screen18Source.includes('تجاهل التغييرات') && screen18Source.includes('متابعة التعديل'),
      'H Failed: Discard confirmation must offer continue/discard actions'
    );
    console.log('✓ H: Dirty Back confirmation intact');
  }

  // I. Successful fullName update: canonical read-after-write with validated payload
  {
    const updated = await fetchCanonicalCustomerProfile('token-x', async () =>
      response(200, {
        success: true,
        data: canonicalPayload({
          fullName: 'الاسم المحدَّث',
          verifiedIdentifiers: { phone: { value: '+201001234567', verifiedAt }, email: null },
          phoneNumber: '+201001234567',
          phoneVerifiedAt: verifiedAt,
        }),
      })
    , passthroughUrl);
    assert(
      (updated as { fullName: string | null }).fullName === 'الاسم المحدَّث',
      'I Failed: Canonical read-after-write must surface the updated fullName'
    );
    assert(
      screen18Source.includes('fetchCanonicalCustomerProfile(currentToken)') &&
        screen18Source.includes('onUpdated(finalCanonical)'),
      'I Failed: Save success must verify canonical state read-after-write before applying'
    );
    console.log('✓ I: Successful fullName update verified read-after-write');
  }

  // J. Ordinary profile PATCH contains no email/phone keys
  {
    const patchBodyMatch = screen18Source.match(/const patchBody = \{([\s\S]*?)\};/);
    assert(patchBodyMatch, 'J Failed: PATCH body must be an explicit literal');
    assert(
      patchBodyMatch![1].includes('fullName') &&
        !patchBodyMatch![1].includes('email') &&
        !patchBodyMatch![1].includes('phone'),
      'J Failed: PATCH payload must never carry email/phone keys'
    );
    assert(
      appSource.includes("applyCanonicalCustomerProfile(updated)") ||
        screen18Source.includes('mergeCustomerProfile(retryJson.data)'),
      'J Failed: Refreshed save path must apply validated canonical payloads'
    );
    console.log('✓ J: Ordinary PATCH carries fullName only');
  }

  // K. Missing verified identifiers fails closed (never a normal state)
  {
    await expectError(
      () =>
        fetchCanonicalCustomerProfile('token-x', async () =>
          response(200, { success: true, data: canonicalPayload({}) })
        , passthroughUrl),
      CustomerProfileIdentityIntegrityError,
      'K: canonical payload with zero verified identifiers'
    );
    let mergeCaught: unknown = null;
    try {
      mergeCustomerProfile(canonicalPayload({}));
    } catch (error) {
      mergeCaught = error;
    }
    assert(
      mergeCaught instanceof Error && /missing verified identifier/.test((mergeCaught as Error).message),
      'K Failed: mergeCustomerProfile must reject profiles with zero verified identifiers'
    );
    assert(
      screen18Source.includes("profileLoadState === 'READY' && !verifiedPhone && !verifiedEmail"),
      'K Failed: Screen 18 must fail closed after load when neither verified identifier exists'
    );
    console.log('✓ K: Zero verified identifiers fail closed at loader, merge, and screen levels');
  }

  // L. Legacy users.email alone is never labeled verified
  {
    const legacyMerged = mergeCustomerProfile({
      ...canonicalPayload({ email: 'legacy@example.com' }),
      verifiedIdentifiers: undefined,
    });
    assert(
      legacyMerged.email === 'legacy@example.com' && legacyMerged.verifiedIdentifiers.email === null,
      'L Failed: Legacy users.email may remain as a compatibility field but must stay unverified'
    );
    assert(
      resolveDisplayIdentifier(legacyMerged as any) === null,
      'L Failed: Legacy users.email alone must never render as verified identity'
    );
    const legacyShapedProfile = profileWith({ email: 'legacy@example.com', phoneNumber: null });
    assert(
      resolveDisplayIdentifier(legacyShapedProfile) === null,
      'L Failed: A legacy-shaped profile must resolve to NO displayed login identity'
    );
    assert(
      screen17Source.includes(
        '(isAuthenticated && Boolean(userProfile) && !hasVerifiedIdentifier)'
      ),
      'L Failed: Screen 17 must fail closed locally on a zero-verified-identifier profile'
    );
    const dtoSource = readFileSync(
      new URL('../../../backend/server/src/contracts/customerRenter.ts', import.meta.url),
      'utf8'
    ).replace(/\r\n/g, '\n');
    const repoSource = readFileSync(
      new URL('../../../backend/server/src/services/dbRepository.ts', import.meta.url),
      'utf8'
    ).replace(/\r\n/g, '\n');
    assert(
      repoSource.includes('FROM public.user_identifiers') && repoSource.includes("type === 'EMAIL' && verifiedAt"),
      'L Failed: Verified email must derive only from verified user_identifiers rows'
    );
    assert(
      dtoSource.includes('verifiedIdentifiers'),
      'L Failed: Profile DTO must carry a distinct verifiedIdentifiers contract'
    );
    console.log('✓ L: Legacy users.email alone is never labeled verified');
  }

  console.log('\nALL SCREENS 17/18 IDENTITY & SESSION BEHAVIORAL TESTS PASSED (A–L)! ✓\n');
}

run().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
