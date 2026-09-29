// @ts-ignore The lightweight script runs under Node through the repository's tsx harness.
import { readFileSync } from 'node:fs';
import {
  deriveUserInitials,
  maskDisplayPhone,
  resolveDisplayIdentifier,
  formatNotificationBadge,
  isCustomerProfileIncomplete,
} from '../components/CustomerAccountHomeScreen';
import type { CustomerUserProfile } from '../components/CustomerAuthModal';

declare const process: { exitCode?: number };

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(message);
}

async function run(): Promise<void> {
  console.log('Running Customer Screen 17 Account Home Test Suite (27 Cases)...');

  const appSource = readFileSync(new URL('../App.tsx', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const componentSource = readFileSync(
    new URL('../components/CustomerAccountHomeScreen.tsx', import.meta.url),
    'utf8'
  ).replace(/\r\n/g, '\n');

  // Verify App.tsx mounts CustomerAccountHomeScreen
  assert(
    appSource.includes('<CustomerAccountHomeScreen'),
    'App must render CustomerAccountHomeScreen component'
  );

  // Case 1: Pure guest state renders login CTA (تسجيل الدخول أو إنشاء حساب)
  {
    assert(
      componentSource.includes('تسجيل الدخول أو إنشاء حساب') &&
        componentSource.includes('!isAuthenticated'),
      'Case 1 Failed: Pure guest state must present تسجيل الدخول أو إنشاء حساب'
    );
    console.log('✓ Case 1: Pure guest state renders login CTA');
  }

  // Case 2: Pure guest state does not render user initials or private data
  {
    assert(
      componentSource.includes('!isAuthenticated') &&
        !componentSource.includes('initials') ||
        componentSource.indexOf('initials') > componentSource.indexOf('isAuthenticated'),
      'Case 2 Failed: Guest state must not display user initials or private identity'
    );
    assert(deriveUserInitials('أحمد محمود') === 'أ.م', 'deriveUserInitials must compute correct initials');
    assert(deriveUserInitials('') === 'م', 'deriveUserInitials must fallback to م');
    console.log('✓ Case 2: Pure guest state does not render initials or private data');
  }

  // Case 3: Phone masking: Egyptian E.164 formats as +20 10••••1234
  {
    const masked = maskDisplayPhone('+201012341234');
    assert(
      masked === '+20 10••••1234',
      `Case 3 Failed: Expected '+20 10••••1234', got '${masked}'`
    );
    const maskedLocal = maskDisplayPhone('01012341234');
    assert(
      maskedLocal === '+20 10••••1234',
      `Case 3 Failed: Local 010... format must mask as '+20 10••••1234', got '${maskedLocal}'`
    );
    console.log('✓ Case 3: Phone masking helper produces deterministic +20 10••••1234 format');
  }

  // Case 4: Phone-first user displays masked phone on Account Home
  {
    const phoneUser: CustomerUserProfile = {
      id: 'usr_phone_01',
      fullName: 'أحمد محمود',
      phoneNumber: '+201001234567',
      verifiedIdentifiers: {
        phone: {
          value: '+201001234567',
          verifiedAt: '2026-09-28T00:00:00.000Z',
        },
        email: null,
      },
    };
    const displayId = resolveDisplayIdentifier(phoneUser, { masked: true });
    assert(
      displayId === '+20 10••••4567',
      `Case 4 Failed: Expected masked phone '+20 10••••4567', got '${displayId}'`
    );
    const unmasked = resolveDisplayIdentifier(phoneUser, { masked: false });
    assert(
      unmasked === '+201001234567',
      `Case 4 Failed: Unmasked request must return full phone '+201001234567', got '${unmasked}'`
    );
    console.log('✓ Case 4: Phone-first user displays masked phone on Screen 17');
  }

  // Case 5: Email-first user displays verified email address without masking
  {
    const emailUser: CustomerUserProfile = {
      id: 'usr_email_01',
      fullName: 'سارة علي',
      email: 'sara@example.com',
      verifiedIdentifiers: {
        phone: null,
        email: {
          value: 'sara@example.com',
          verifiedAt: '2026-09-28T00:00:00.000Z',
        },
      },
    };
    const displayId = resolveDisplayIdentifier(emailUser);
    assert(
      displayId === 'sara@example.com',
      `Case 5 Failed: Expected verified email 'sara@example.com', got '${displayId}'`
    );
    console.log('✓ Case 5: Email-first user displays verified email address');
  }

  // Case 6: Dual identifier user prioritizes phone and masks it on Screen 17
  {
    const dualUser: CustomerUserProfile = {
      id: 'usr_dual_01',
      fullName: 'محمد إبراهيم',
      phoneNumber: '+201099887766',
      email: 'mohamed@example.com',
      verifiedIdentifiers: {
        phone: {
          value: '+201099887766',
          verifiedAt: '2026-09-28T00:00:00.000Z',
        },
        email: {
          value: 'mohamed@example.com',
          verifiedAt: '2026-09-28T00:00:00.000Z',
        },
      },
    };
    const displayId = resolveDisplayIdentifier(dualUser, { masked: true });
    assert(
      displayId === '+20 10••••7766',
      `Case 6 Failed: Expected masked phone for dual user, got '${displayId}'`
    );
    console.log('✓ Case 6: Dual identifier user prioritizes phone and masks on Screen 17');
  }

  // Case 7: Legacy unverified email alone NEVER renders as the login identity
  {
    const emailOnlyUser: CustomerUserProfile = {
      id: 'usr_email_only',
      fullName: 'هدى كريم',
      phoneNumber: null,
      email: 'huda@example.com',
    };
    const displayId = resolveDisplayIdentifier(emailOnlyUser);
    assert(
      displayId === null,
      `Case 7 Failed: Legacy users.email without a verified identifier must NOT be presented (got '${displayId}')`
    );
    console.log('✓ Case 7: Legacy unverified email alone never renders as login identity');
  }

  // Case 8: Profile incomplete notice shown when fullName is empty
  {
    assert(isCustomerProfileIncomplete(undefined) === true, 'Case 8 Failed: undefined name');
    assert(isCustomerProfileIncomplete(null) === true, 'Case 8 Failed: null name');
    assert(isCustomerProfileIncomplete('') === true, 'Case 8 Failed: empty string');
    assert(isCustomerProfileIncomplete('   ') === true, 'Case 8 Failed: whitespace only');
    assert(
      componentSource.includes('isProfileIncomplete') &&
        componentSource.includes('أكمل بيانات حسابك'),
      'Case 8 Failed: Incomplete notice must be conditioned on isProfileIncomplete'
    );
    console.log('✓ Case 8: Incomplete profile notice shown conditionally');
  }

  // Case 9: Visible Edit CTA is exactly "تعديل" with >= 44x44px target
  {
    assert(
      componentSource.includes('>تعديل<') || componentSource.includes('<span>تعديل</span>'),
      'Case 9 Failed: Edit CTA text must be exactly "تعديل"'
    );
    assert(
      componentSource.includes('min-h-[44px]') && componentSource.includes('min-w-[44px]'),
      'Case 9 Failed: Edit CTA touch target must enforce min 44x44px'
    );
    console.log('✓ Case 9: Visible Edit CTA is exactly "تعديل" with min 44x44px target');
  }

  // Case 10: Navigation rows enforce 64-68px rhythm
  {
    assert(
      componentSource.includes('min-h-[64px]'),
      'Case 10 Failed: Navigation rows must enforce min-h-[64px]'
    );
    console.log('✓ Case 10: Navigation rows enforce min-h-[64px] height rhythm');
  }

  // Case 11: Group رحلاتي navigation to Bookings and Favorites
  {
    assert(
      componentSource.includes('حجوزاتي') &&
        componentSource.includes('المفضلة') &&
        componentSource.includes('onOpenBookings') &&
        componentSource.includes('onOpenFavorites'),
      'Case 11 Failed: رحلاتي group must route to Bookings and Favorites'
    );
    console.log('✓ Case 11: Group رحلاتي routes to Bookings and Favorites');
  }

  // Case 12: Favorites row has NO numeric count badge
  {
    const favoritesIndex = componentSource.indexOf('title="المفضلة"');
    assert(favoritesIndex !== -1, 'Favorites row not found in source');
    const favoritesSnippet = componentSource.slice(favoritesIndex, favoritesIndex + 200);
    assert(
      !favoritesSnippet.includes('badge=') && !favoritesSnippet.includes('favorites.length'),
      'Case 12 Failed: Favorites row must NOT display a numeric count badge'
    );
    console.log('✓ Case 12: Favorites row has no numeric badge');
  }

  // Case 13: Notification badge hidden when unread count is 0 or null
  {
    assert(formatNotificationBadge(0) === null, 'Case 13 Failed: Badge must be null for 0');
    assert(formatNotificationBadge(-1) === null, 'Case 13 Failed: Badge must be null for negative');
    assert(formatNotificationBadge(null) === null, 'Case 13 Failed: Badge must be null for null');
    assert(formatNotificationBadge(undefined) === null, 'Case 13 Failed: Badge must be null for undefined');
    console.log('✓ Case 13: Notification badge hidden when unread count is 0 or null');
  }

  // Case 14: Notification badge shows exact number when 1 <= count <= 9
  {
    for (let i = 1; i <= 9; i++) {
      assert(formatNotificationBadge(i) === String(i), `Case 14 Failed for count ${i}`);
    }
    console.log('✓ Case 14: Notification badge shows exact count for 1 through 9');
  }

  // Case 15: Notification badge shows '9+' when count > 9
  {
    assert(formatNotificationBadge(10) === '9+', 'Case 15 Failed: count 10 must return 9+');
    assert(formatNotificationBadge(99) === '9+', 'Case 15 Failed: count 99 must return 9+');
    console.log('✓ Case 15: Notification badge shows 9+ when count > 9');
  }

  // Case 16: Notification badge is blue (#0059FF), not red
  {
    assert(
      componentSource.includes('bg-[#0059FF]') &&
        componentSource.includes('text-white') &&
        !componentSource.includes('bg-red-') &&
        !componentSource.includes('bg-rose-500'),
      'Case 16 Failed: Notification badge must use primary blue #0059FF, not red'
    );
    console.log('✓ Case 16: Notification badge is blue #0059FF, not red');
  }

  // Case 17: Payments label is strictly المدفوعات (no المحفظة)
  {
    assert(
      componentSource.includes('title="المدفوعات"') &&
        !componentSource.includes('المحفظة والمدفوعات'),
      'Case 17 Failed: Screen 17 payments label must be strictly المدفوعات'
    );
    console.log('✓ Case 17: Payments label is strictly المدفوعات');
  }

  // Case 18: Payments subtitle is customer-friendly without internal ledger/commission terms
  {
    assert(
      componentSource.includes('العربون والمدفوعات وسجل المعاملات') ||
        componentSource.includes('العربون والمدفوعات والمبالغ المتعلقة بحجوزاتك'),
      'Case 18 Failed: Payments subtitle must be clear customer-facing copy'
    );
    assert(
      !componentSource.includes('commission') &&
        !componentSource.includes('عمولة') &&
        !componentSource.includes('ledger') &&
        !componentSource.includes('صافي المالك'),
      'Case 18 Failed: Subtitle must not leak internal ledger or commission terms'
    );
    console.log('✓ Case 18: Payments subtitle is customer-friendly without internal terms');
  }

  // Case 19: Account group has البيانات الشخصية navigating to Screen 18
  {
    assert(
      componentSource.includes('البيانات الشخصية') &&
        componentSource.includes('onEditProfile'),
      'Case 19 Failed: Account group must have البيانات الشخصية wired to onEditProfile'
    );
    console.log('✓ Case 19: Account group routes to Screen 18 Profile Edit');
  }

  // Case 20: Section title is strictly المساعدة (not المساعدة والقانون)
  {
    assert(
      componentSource.includes('المساعدة') &&
        !componentSource.includes('المساعدة والقانون'),
      'Case 20 Failed: Section heading must be المساعدة (not المساعدة والقانون)'
    );
    console.log('✓ Case 20: Section title is strictly المساعدة');
  }

  // Case 21: Session expired state renders recovery card and blocks private navigation
  {
    assert(
      componentSource.includes('isSessionExpired') &&
        componentSource.includes('انتهت جلسة تسجيل الدخول') &&
        componentSource.includes('تسجيل الدخول مجددًا'),
      'Case 21 Failed: Session expired state must present recovery card and block private content'
    );
    console.log('✓ Case 21: Session expired state renders recovery card cleanly');
  }

  // Case 22: Destructive logout button is restrained and distinct from content rows
  {
    assert(
      componentSource.includes('تسجيل الخروج') &&
        componentSource.includes('hover:bg-rose-50') &&
        componentSource.includes('hover:text-rose-600'),
      'Case 22 Failed: Logout button must be restrained secondary button with rose hover'
    );
    console.log('✓ Case 22: Logout button is restrained and visually distinct');
  }

  // Case 23: Identity resolution is verified-identifiers only (fail-closed)
  {
    assert(
      !componentSource.includes("'حساب نشط'") && !componentSource.includes('حساب نشط'),
      'Case 23 Failed: Fabricated "حساب نشط" identity placeholder must not exist'
    );
    assert(
      componentSource.includes('displayIdentifier && ('),
      'Case 23 Failed: Identity line must render only when a verified identifier exists'
    );
    assert(
      !componentSource.includes('customerPhone'),
      'Case 23 Failed: Screen 17 must not consume cached customerPhone as identity'
    );
    console.log('✓ Case 23: Identity is verified-identifiers only; no fabricated fallback');
  }

  // Case 24: Zero verified identifiers fail closed as identity integrity state
  {
    assert(
      componentSource.includes('identityIntegrityFailed') &&
        componentSource.includes('لا يمكن التحقق من هوية الحساب'),
      'Case 24 Failed: Screen 17 must fail closed with an identity integrity card'
    );
    assert(
      componentSource.indexOf('identityIntegrity)') < componentSource.indexOf('4. Guest'),
      'Case 24 Failed: Integrity state must block authenticated content before guest/authenticated shells'
    );
    console.log('✓ Case 24: Zero verified identifiers fail closed to integrity card');
  }

  // Case 25: No amber/yellow/orange boxed UI (Founder visual rule)
  {
    assert(
      !componentSource.includes('amber') &&
        !componentSource.includes('yellow') &&
        !componentSource.includes('orange'),
      'Case 25 Failed: Screen 17 must not contain amber/yellow/orange styling'
    );
    console.log('✓ Case 25: Screen 17 contains no amber/yellow/orange UI');
  }

  // Case 26: No fake avatar edit or camera icons
  {
    assert(
      !componentSource.includes('تغيير الصورة') &&
        !componentSource.includes('Camera') &&
        !componentSource.includes('UploadCloud'),
      'Case 26 Failed: Screen 17 must NOT contain avatar upload/edit actions'
    );
    console.log('✓ Case 26: Screen 17 contains no fake avatar editing actions');
  }

  // Case 27: Explicit keyboard focus treatment on interactive controls
  {
    assert(
      componentSource.includes('focus-visible:outline-none') &&
        componentSource.includes('focus-visible:ring-2') &&
        componentSource.includes('focus-visible:ring-[#0059FF]/40'),
      'Case 27 Failed: Interactive controls must expose explicit KONFRM keyboard focus treatment'
    );
    assert(
      componentSource.includes('focus-visible:ring-inset'),
      'Case 27 Failed: Grouped list rows must use inset rings so the card surface does not clip focus'
    );
    console.log('✓ Case 27: Explicit keyboard focus treatment present on Screen 17 controls');
  }

  console.log('\nALL 27 SCREEN 17 TESTS PASSED SUCCESSFULLY! ✓\n');
}

run().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
