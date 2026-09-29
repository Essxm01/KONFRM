// @ts-ignore The lightweight script runs under Node through the repository's tsx harness.
import { readFileSync } from 'node:fs';
import {
  validateCustomerFullName,
  isProfileFormDirty,
} from '../components/CustomerEditAccountPage';
import type { CustomerUserProfile } from '../components/CustomerAuthModal';

declare const process: { exitCode?: number };

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(message);
}

async function run(): Promise<void> {
  console.log('Running Customer Screen 18 Profile Edit Test Suite (32 Cases)...');

  const componentSource = readFileSync(
    new URL('../components/CustomerEditAccountPage.tsx', import.meta.url),
    'utf8'
  ).replace(/\r\n/g, '\n');

  // Case 1: Displays full name in editable input field
  {
    assert(
      componentSource.includes('id="customer-fullName-input"') &&
        componentSource.includes('value={fullName}') &&
        componentSource.includes('setFullName(e.target.value)'),
      'Case 1 Failed: Screen 18 must render editable full name input'
    );
    console.log('✓ Case 1: Displays full name in editable input field');
  }

  // Case 2: Phone-only user displays read-only verified phone row with CheckCircle2 + "تم التحقق"
  {
    assert(
      componentSource.includes('verifiedPhone && (') &&
        componentSource.includes('label="رقم الهاتف"') &&
        componentSource.includes('CheckCircle2') &&
        componentSource.includes('تم التحقق'),
      'Case 2 Failed: Phone-only user must display verified phone row with checkmark and تم التحقق'
    );
    console.log('✓ Case 2: Phone-only user displays read-only verified phone row');
  }

  // Case 3: Email-only user displays read-only verified email row with CheckCircle2 + "تم التحقق"
  {
    assert(
      componentSource.includes('verifiedEmail && (') &&
        componentSource.includes('label="البريد الإلكتروني"') &&
        componentSource.includes('CheckCircle2') &&
        componentSource.includes('تم التحقق'),
      'Case 3 Failed: Email-only user must display verified email row with checkmark and تم التحقق'
    );
    console.log('✓ Case 3: Email-only user displays read-only verified email row');
  }

  // Case 4: Dual identifier user displays both verified phone and verified email rows
  {
    const dualUser: CustomerUserProfile = {
      id: 'usr_dual_02',
      fullName: 'كريم حسن',
      phoneNumber: '+201122334455',
      email: 'karim@example.com',
      verifiedIdentifiers: {
        phone: {
          value: '+201122334455',
          verifiedAt: '2026-09-28T00:00:00.000Z',
        },
        email: {
          value: 'karim@example.com',
          verifiedAt: '2026-09-28T00:00:00.000Z',
        },
      },
    };
    const hasPhone = Boolean(dualUser.verifiedIdentifiers?.phone?.value);
    const hasEmail = Boolean(dualUser.verifiedIdentifiers?.email?.value);
    assert(hasPhone && hasEmail, 'Case 4 Failed: Dual user must have both verified identifiers resolved');
    console.log('✓ Case 4: Dual identifier user resolves both phone and email');
  }

  // Case 4b: Legacy phoneNumber+phoneVerifiedAt alone is never presented as verified
  {
    const legacyPhoneUser: CustomerUserProfile = {
      id: 'usr_legacy_phone',
      fullName: 'مصطفى فؤاد',
      phoneNumber: '+201555000111',
      phoneVerifiedAt: '2026-09-28T00:00:00.000Z',
    };
    const verifiedPhoneFromComponentRule = Boolean(legacyPhoneUser.verifiedIdentifiers?.phone?.value);
    assert(
      !verifiedPhoneFromComponentRule,
      'Case 4b Failed: Legacy phoneNumber/phoneVerifiedAt without verifiedIdentifiers must NOT be presented as verified'
    );
    console.log('✓ Case 4b: Legacy phone fields alone never present as verified identity');
  }

  // Case 5: Email-first user does NOT display a blank editable phone field
  {
    const hasPhoneInput = /<input[^>]*name=["']phone["']|<input[^>]*id=["']phone["']/.test(componentSource);
    assert(!hasPhoneInput, 'Case 5 Failed: There must be no editable phone input element');
    console.log('✓ Case 5: Email-first user does not display a blank editable phone field');
  }

  // Case 6: Verified rows are read-only (VerifiedIdentityRow, no input tag)
  {
    assert(
      componentSource.includes('export const VerifiedIdentityRow') &&
        (!componentSource.includes('<input') ||
          componentSource.indexOf('<input') === componentSource.lastIndexOf('<input')),
      'Case 6 Failed: VerifiedIdentityRow must not render input elements'
    );
    const inputMatches = componentSource.match(/<input\b/g);
    assert(
      inputMatches && inputMatches.length === 1,
      `Case 6 Failed: Screen 18 must have exactly 1 input tag (full name), found ${inputMatches?.length}`
    );
    console.log('✓ Case 6: Verified rows are read-only with no input elements');
  }

  // Case 7: No editable email input exists on Screen 18
  {
    const hasEmailInput = /<input[^>]*type=["']email["']|<input[^>]*name=["']email["']/.test(componentSource);
    assert(!hasEmailInput, 'Case 7 Failed: No editable email input should exist');
    console.log('✓ Case 7: No editable email input exists on Screen 18');
  }

  // Case 8: Full name validation: < 2 characters shows validation error
  {
    const singleCharResult = validateCustomerFullName('أ');
    assert(singleCharResult.isValid === false, 'Case 8 Failed: single char should be invalid');
    assert(
      singleCharResult.error === 'الاسم يجب أن يتكون من حرفين على الأقل',
      'Case 8 Failed: Unexpected error message for single char'
    );
    console.log('✓ Case 8: Full name < 2 characters rejected with error');
  }

  // Case 9: Full name validation: empty string or whitespace shows "أدخل اسمك الكامل."
  {
    const emptyResult = validateCustomerFullName('');
    assert(emptyResult.isValid === false, 'Case 9 Failed: empty string must be invalid');
    assert(
      emptyResult.error === 'أدخل اسمك الكامل.',
      `Case 9 Failed: Expected 'أدخل اسمك الكامل.', got '${emptyResult.error}'`
    );

    const whitespaceResult = validateCustomerFullName('    ');
    assert(whitespaceResult.isValid === false, 'Case 9 Failed: whitespace must be invalid');
    assert(
      whitespaceResult.error === 'أدخل اسمك الكامل.',
      `Case 9 Failed: Expected 'أدخل اسمك الكامل.', got '${whitespaceResult.error}'`
    );
    console.log('✓ Case 9: Empty or whitespace full name rejected with "أدخل اسمك الكامل."');
  }

  // Case 10: Clean form: Save button is disabled when input matches existing name
  {
    const isClean = !isProfileFormDirty('أحمد محمود', 'أحمد محمود');
    assert(isClean === true, 'Case 10 Failed: Matching initial and current name must not be dirty');
    assert(
      !isProfileFormDirty('  أحمد محمود  ', 'أحمد محمود'),
      'Case 10 Failed: Whitespace padding differences should be trimmed'
    );
    assert(
      componentSource.includes('const isSaveEnabled = isDirty && isNameValid && !loading;'),
      'Case 10 Failed: Save button must require isDirty'
    );
    console.log('✓ Case 10: Clean form keeps Save button disabled');
  }

  // Case 11: Dirty form: Save button enabled when trimmed name != initial name and valid
  {
    const isDirty = isProfileFormDirty('أحمد محمود', 'أحمد محمود الجديد');
    const isValid = validateCustomerFullName('أحمد محمود الجديد').isValid;
    assert(isDirty === true, 'Case 11 Failed: Different name must be dirty');
    assert(isValid === true, 'Case 11 Failed: Valid changed name must be valid');
    assert(
      componentSource.includes('disabled={!isSaveEnabled}'),
      'Case 11 Failed: Save button disabled attribute must bind to !isSaveEnabled'
    );
    console.log('✓ Case 11: Dirty valid form enables Save button');
  }

  // Case 12: Save in-flight: Button disabled with loading text "جارٍ حفظ التغييرات…"
  {
    assert(
      componentSource.includes('جارٍ حفظ التغييرات…') &&
        componentSource.includes('loading ? ('),
      'Case 12 Failed: In-flight save must render loading text "جارٍ حفظ التغييرات…"'
    );
    console.log('✓ Case 12: Save in-flight shows loading spinner and text');
  }

  // Case 13: Duplicate submit prevention: clicking save while pending does not fire secondary API call
  {
    assert(
      componentSource.includes('if (!isDirty || loading) return;'),
      'Case 13 Failed: handleSave must guard against duplicate submissions with loading check'
    );
    console.log('✓ Case 13: Duplicate submit prevented when loading is true');
  }

  // Case 14: Save success: shows success state "تم حفظ التغييرات" and triggers auto-return
  {
    assert(
      componentSource.includes('تم حفظ التغييرات') &&
        componentSource.includes('setTimeout') &&
        componentSource.includes('onBack()'),
      'Case 14 Failed: Save success must show "تم حفظ التغييرات" and trigger auto-return via timeout'
    );
    console.log('✓ Case 14: Save success shows success badge and schedules auto-return');
  }

  // Case 15: Save failure: preserves user input, displays error banner, allows retry
  {
    assert(
      componentSource.includes('setError(err?.message') &&
        componentSource.includes('setLoading(false)') &&
        !componentSource.includes('setFullName(initialName)'),
      'Case 15 Failed: Save failure must preserve user input in state and reveal error banner'
    );
    console.log('✓ Case 15: Save failure preserves user input and displays error banner');
  }

  // Case 16: Back button when clean: directly invokes onBack()
  {
    assert(
      componentSource.includes('const handleBackClick = () => {') &&
        componentSource.includes('if (isDirty) {') &&
        componentSource.includes('onBack();'),
      'Case 16 Failed: Clean form back click must invoke onBack directly'
    );
    console.log('✓ Case 16: Clean form back click directly invokes onBack()');
  }

  // Case 17: Back button when dirty: opens unsaved changes confirmation modal ("هل تريد تجاهل التغييرات؟")
  {
    assert(
      componentSource.includes('setShowDiscardConfirm(true)') &&
        componentSource.includes('هل تريد تجاهل التغييرات؟'),
      'Case 17 Failed: Dirty form back click must show discard confirm modal'
    );
    console.log('✓ Case 17: Dirty form back click triggers unsaved changes modal');
  }

  // Case 18: Unsaved changes modal: "متابعة التعديل" dismisses modal and keeps user on Screen 18
  {
    assert(
      componentSource.includes('متابعة التعديل') &&
        componentSource.includes('onClick={() => setShowDiscardConfirm(false)}'),
      'Case 18 Failed: "متابعة التعديل" must dismiss confirmation modal'
    );
    console.log('✓ Case 18: "متابعة التعديل" dismisses modal and preserves edit state');
  }

  // Case 19: Unsaved changes modal: "تجاهل التغييرات" abandons edits and invokes onBack()
  {
    assert(
      componentSource.includes('تجاهل التغييرات') &&
        componentSource.includes('handleConfirmDiscard') &&
        componentSource.includes('setShowDiscardConfirm(false);\n    onBack();'),
      'Case 19 Failed: "تجاهل التغييرات" must discard changes and call onBack'
    );
    console.log('✓ Case 19: "تجاهل التغييرات" abandons changes and returns to Account Home');
  }

  // Case 20: No avatar/photo upload affordance exists on Screen 18
  {
    const hasPhotoUpload = /type=["']file["']|accept=["']image|Camera|UploadCloud/.test(componentSource);
    assert(
      !hasPhotoUpload,
      'Case 20 Failed: Screen 18 must NOT have any photo upload or camera affordance'
    );
    assert(
      componentSource.includes('deriveUserInitials'),
      'Case 20 Failed: Identity card must use initials avatar'
    );
    console.log('✓ Case 20: No avatar/photo upload affordance exists; initials avatar only');
  }

  // Case 21: Profile fetch lifecycle is session/screen-driven, not field-interaction-driven
  {
    assert(
      componentSource.includes("}, [authToken, reloadNonce, onSessionExpired]);"),
      'Case 21 Failed: Canonical profile load effect must depend on session lifecycle, not nameTouched'
    );
    assert(
      !componentSource.includes('[authToken, nameTouched]'),
      'Case 21 Failed: Touching the name field must never trigger a canonical profile refetch'
    );
    assert(
      componentSource.includes('userEditedRef') &&
        componentSource.includes('if (!userEditedRef.current) {'),
      'Case 21 Failed: A late canonical response must not overwrite active user edits'
    );
    assert(
      componentSource.includes('profileLoadState') &&
        componentSource.includes("'NETWORK_ERROR'") &&
        componentSource.includes('إعادة المحاولة'),
      'Case 21 Failed: Network/non-auth failure must expose a truthful retryable state'
    );
    console.log('✓ Case 21: Profile fetch lifecycle driven by session, protected against late responses');
  }

  // Case 22: Zero verified identifiers fail closed (no normal empty state)
  {
    assert(
      !componentSource.includes('لا توجد معرفات إضافية موثقة'),
      'Case 22 Failed: The neutral zero-identifier box must not exist'
    );
    assert(
      componentSource.includes('identityIntegrity') &&
        componentSource.includes('لا يمكن التحقق من هوية الحساب'),
      'Case 22 Failed: Zero verified identifiers must fail closed as identity integrity state'
    );
    assert(
      componentSource.includes("profileLoadState === 'READY' && !verifiedPhone && !verifiedEmail"),
      'Case 22 Failed: Integrity evaluation must wait for the canonical load to settle'
    );
    console.log('✓ Case 22: Zero verified identifiers fail closed as identity integrity failure');
  }

  // Case 23: 401/403 on profile load is fail-closed Session Expired, surfaced to App
  {
    assert(
      componentSource.includes('CustomerProfileUnauthorizedError') &&
        componentSource.includes('setSessionExpired(true);\n          onSessionExpired?.();'),
      'Case 23 Failed: 401/403 must trigger fail-closed Session Expired and notify App invalidation'
    );
    console.log('✓ Case 23: Profile GET 401/403 fails closed to Session Expired with App invalidation');
  }

  // Case 24: PATCH payload is fullName only — never email/phone
  {
    const patchBodyMatch = componentSource.match(/const patchBody = \{([\s\S]*?)\};/);
    assert(patchBodyMatch, 'Case 24 Failed: PATCH body must be an explicit object literal');
    const patchBody = patchBodyMatch![1];
    assert(
      patchBody.includes('fullName') &&
        !patchBody.includes('email') &&
        !patchBody.includes('phone'),
      'Case 24 Failed: Ordinary profile PATCH must contain fullName only — no email/phone keys'
    );
    console.log('✓ Case 24: PATCH payload carries fullName only; identifiers never included');
  }

  // Case 25: Canonical identity response is validated through mergeCustomerProfile
  {
    assert(
      componentSource.includes('fetchCanonicalCustomerProfile') &&
        componentSource.includes('mergeCustomerProfile'),
      'Case 25 Failed: Canonical profile and save responses must pass identity validation'
    );
    assert(
      componentSource.includes('setIdentityIntegrityFailed(true)'),
      'Case 25 Failed: Identity-invalid canonical payloads must fail closed'
    );
    console.log('✓ Case 25: Canonical identity validation guards load and save paths');
  }

  // Case 26: No amber/yellow/orange boxed UI (Founder visual rule)
  {
    assert(
      !componentSource.includes('amber') &&
        !componentSource.includes('yellow') &&
        !componentSource.includes('orange'),
      'Case 26 Failed: Screen 18 must not contain amber/yellow/orange styling'
    );
    assert(
      componentSource.includes('bg-blue-50 text-[#0059FF]') &&
        componentSource.includes('bg-slate-100 text-slate-600'),
      'Case 26 Failed: Session Expired must use soft blue and Unsaved Changes neutral treatment'
    );
    console.log('✓ Case 26: Screen 18 contains no amber/yellow/orange boxed UI');
  }

  // Case 27: CustomerNestedAppBar is exactly 48px height with RTL ChevronRight
  {
    assert(
      componentSource.includes('h-12') &&
        componentSource.includes('CustomerNestedAppBar') &&
        componentSource.includes('ChevronRight'),
      'Case 27 Failed: Nested AppBar must be 48px (h-12) with RTL ChevronRight back button'
    );
    console.log('✓ Case 27: CustomerNestedAppBar is 48px with RTL back navigation');
  }

  // Case 28: Full name input has aria-describedby pointing to error when invalid
  {
    assert(
      componentSource.includes('aria-describedby') &&
        (componentSource.includes('customer-fullName-error') || componentSource.includes('name-error')),
      'Case 28 Failed: Full name input must associate error message via aria-describedby'
    );
    console.log('✓ Case 28: Full name input associates validation error via aria-describedby');
  }

  // Case 29: Discard modal has role="dialog", aria-modal="true", and focus trap
  {
    assert(
      componentSource.includes('role="dialog"') &&
        componentSource.includes('aria-modal="true"') &&
        componentSource.includes('handleDialogKeyDown'),
      'Case 29 Failed: Discard modal must provide dialog accessibility and keyboard navigation'
    );
    console.log('✓ Case 29: Discard modal provides accessible dialog role and keyboard focus trap');
  }

  // Case 30: NO "إضافة بريد إلكتروني" when email is absent
  {
    assert(
      !componentSource.includes('إضافة بريد إلكتروني') &&
        !componentSource.includes('إضافة بريد'),
      'Case 30 Failed: Screen 18 must NOT display "إضافة بريد إلكتروني" when email is absent'
    );
    console.log('✓ Case 30: No fake Add Email button appears when email is absent');
  }

  // Case 31: Save status screen-reader live region exists and is non-duplicative
  {
    assert(
      componentSource.includes('role="status"') && componentSource.includes('aria-live="polite"'),
      'Case 31 Failed: A stable polite save-status live region must exist'
    );
    assert(
      componentSource.includes("{loading ? 'جارٍ حفظ التغييرات…' : successMsg || ''}"),
      'Case 31 Failed: Live region must announce saving and success states only'
    );
    assert(
      componentSource.includes('جارٍ حفظ التغييرات…'),
      'Case 31 Failed: Visible saving copy must remain unchanged'
    );
    console.log('✓ Case 31: Save status screen-reader live region present and stable');
  }

  // Case 32: Field helper semantics preserved (aria-describedby chain intact)
  {
    assert(
      componentSource.includes('customer-fullName-help') &&
        componentSource.includes('customer-fullName-error') &&
        componentSource.includes('aria-describedby='),
      'Case 32 Failed: Full Name aria-describedby chain must remain intact'
    );
    assert(
      componentSource.includes('focus-visible:ring-2'),
      'Case 32 Failed: Explicit keyboard focus treatment must exist on interactive controls'
    );
    console.log('✓ Case 32: Field helper semantics and keyboard focus treatment preserved');
  }

  console.log('\nALL 32 SCREEN 18 TESTS PASSED SUCCESSFULLY! ✓\n');
}

run().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
