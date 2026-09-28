// @ts-ignore The lightweight script runs under Node through the repository's tsx harness.
import { readFileSync } from 'node:fs';
import {
  deriveUserInitials,
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
  console.log('Running Customer Screen 17 Account Home Test Suite (25 Cases)...');

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

  // Case 3: Phone-first user displays verified phone number in identity block
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
    const displayId = resolveDisplayIdentifier(phoneUser);
    assert(
      displayId === '+201001234567',
      `Case 3 Failed: Expected verified phone '+201001234567', got '${displayId}'`
    );
    console.log('✓ Case 3: Phone-first user displays verified phone number');
  }

  // Case 4: Email-first user displays verified email address in identity block
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
      `Case 4 Failed: Expected verified email 'sara@example.com', got '${displayId}'`
    );
    console.log('✓ Case 4: Email-first user displays verified email address');
  }

  // Case 5: Dual identifier user displays primary identifier (phone prioritized)
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
    const displayId = resolveDisplayIdentifier(dualUser);
    assert(
      displayId === '+201099887766',
      `Case 5 Failed: Expected phone priority for dual user, got '${displayId}'`
    );
    console.log('✓ Case 5: Dual identifier user prioritizes phone identifier');
  }

  // Case 6: Legacy unverified email alone NEVER renders as the login identity
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
      `Case 6 Failed: Legacy users.email without a verified identifier must NOT be presented (got '${displayId}')`
    );
    console.log('✓ Case 6: Legacy unverified email alone never renders as login identity');
  }

  // Case 7: Profile incomplete notice shown when fullName is empty
  {
    assert(isCustomerProfileIncomplete(undefined) === true, 'Case 7 Failed: undefined name');
    assert(isCustomerProfileIncomplete(null) === true, 'Case 7 Failed: null name');
    assert(isCustomerProfileIncomplete('') === true, 'Case 7 Failed: empty string');
    assert(isCustomerProfileIncomplete('   ') === true, 'Case 7 Failed: whitespace only');
    assert(
      componentSource.includes('isProfileIncomplete') &&
        componentSource.includes('أكمل بيانات حسابك'),
      'Case 7 Failed: Incomplete notice must be conditioned on isProfileIncomplete'
    );
    console.log('✓ Case 7: Profile incomplete notice shown when fullName is empty');
  }

  // Case 8: Profile incomplete notice hidden when fullName is populated
  {
    assert(isCustomerProfileIncomplete('أحمد محمود') === false, 'Case 8 Failed: valid name');
    assert(isCustomerProfileIncomplete('  علي  ') === false, 'Case 8 Failed: valid name with whitespace');
    assert(
      componentSource.includes('const isProfileIncomplete = isCustomerProfileIncomplete('),
      'Case 8 Failed: Incomplete notice logic must use isCustomerProfileIncomplete'
    );
    console.log('✓ Case 8: Profile incomplete notice hidden when fullName is populated');
  }

  // Case 9: Stat grid (confirmedBookingsCount, upcomingStaysCount, favoritesCount) is 100% absent
  {
    assert(
      !componentSource.includes('confirmedBookingsCount'),
      'Case 9 Failed: confirmedBookingsCount must not exist in CustomerAccountHomeScreen'
    );
    assert(
      !componentSource.includes('upcomingStaysCount'),
      'Case 9 Failed: upcomingStaysCount must not exist in CustomerAccountHomeScreen'
    );
    assert(
      !componentSource.includes('الحجوزات المؤكدة'),
      'Case 9 Failed: Old KPI metric الحجوزات المؤكدة must not exist in CustomerAccountHomeScreen'
    );
    assert(
      !componentSource.includes('الإقامة القادمة'),
      'Case 9 Failed: Old KPI metric الإقامة القادمة must not exist in CustomerAccountHomeScreen'
    );
    console.log('✓ Case 9: Stat dashboard grid is 100% removed from Screen 17');
  }

  // Case 10: AccountNavigationRow min height is >= 56px and touch target >= 44px
  {
    assert(
      componentSource.includes('min-h-[56px]'),
      'Case 10 Failed: Navigation rows must enforce min-h-[56px]'
    );
    assert(
      componentSource.includes('min-h-[44px]') && componentSource.includes('min-w-[44px]'),
      'Case 10 Failed: Touch targets must enforce min 44x44px'
    );
    console.log('✓ Case 10: AccountNavigationRow enforces min 56px row height and 44px touch target');
  }

  // Case 11: Group رحلاتك navigation to Bookings and Favorites
  {
    assert(
      componentSource.includes('حجوزاتي') &&
        componentSource.includes('المفضلة') &&
        componentSource.includes('onOpenBookings') &&
        componentSource.includes('onOpenFavorites'),
      'Case 11 Failed: رحلاتك group must route to Bookings and Favorites'
    );
    console.log('✓ Case 11: Group رحلاتك routes to Bookings and Favorites');
  }

  // Case 12: Favorites row has NO numeric count badge
  {
    // Search for favorites navigation row in componentSource and ensure no numeric badge is passed
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
      componentSource.includes('العربون والمدفوعات والمبالغ المتعلقة بحجوزاتك') ||
        componentSource.includes('العربون والمدفوعات وسجل المعاملات'),
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

  // Case 20: No dead links (Settings Screen 19 and Legal are omitted/unlinked)
  {
    assert(
      !componentSource.includes('الإعدادات') &&
        !componentSource.includes('الشروط والأحكام') &&
        !componentSource.includes('سياسة الخصوصية'),
      'Case 20 Failed: Screen 17 must not contain dead unlinked settings or legal placeholders'
    );
    console.log('✓ Case 20: No dead placeholder links present');
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
      componentSource.indexOf('identityIntegrityFailed)') < componentSource.indexOf('4. Guest'),
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

  console.log('\nALL 25 SCREEN 17 TESTS PASSED SUCCESSFULLY! ✓\n');
}

run().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
