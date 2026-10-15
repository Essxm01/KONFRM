// =============================================================================
// KONFRM Customer Screen 17 V2 — "Personal Passport"
// Source-Linked Unit and Behavioral Widget Tests
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import '../tool/screen17_preview_runner.dart';

void main() {
  group('Screen 17 V2 Passport — Domain Helpers & Invariants', () {
    test('maskDisplayPhone masks standard Egyptian mobile numbers safely', () {
      expect(maskDisplayPhone('+201012345678'), equals('+20 10••••5678'));
      expect(maskDisplayPhone('+201198765432'), equals('+20 11••••5432'));
      expect(maskDisplayPhone('01012345678'), equals('+20 10••••5678'));
    });

    test('maskDisplayPhone fails safely on empty or invalid phone values', () {
      expect(maskDisplayPhone(null), equals('+•• •••• ••••'));
      expect(maskDisplayPhone(''), equals('+•• •••• ••••'));
      expect(maskDisplayPhone('   '), equals('+•• •••• ••••'));
    });

    test('deriveUserInitials extracts correct initials for Arabic names', () {
      expect(deriveUserInitials('أحمد مصطفى'), equals('أ.م'));
      expect(deriveUserInitials('سارة'), equals('سا'));
      expect(deriveUserInitials(''), equals('م'));
      expect(deriveUserInitials(null), equals('م'));
    });

    test('CustomerProfileData accurately computes display and portrait properties', () {
      const completeUser = CustomerProfileData(
        userId: 'u1',
        fullName: 'أحمد مصطفى',
        proposedUsername: 'ahmed_mostafa',
        verifiedPhone: '+201012345678',
        hasUpcomingStay: true,
      );
      expect(completeUser.isIncomplete, isFalse);
      expect(completeUser.hasPortrait, isFalse);
      expect(completeUser.displayName, equals('أحمد مصطفى'));
      expect(completeUser.initials, equals('أ.م'));
      expect(completeUser.hasUpcomingStay, isTrue);

      const incompleteUser = CustomerProfileData(
        userId: 'u2',
        fullName: null,
      );
      expect(incompleteUser.isIncomplete, isTrue);
      expect(incompleteUser.displayName, equals('مستأجر'));
      expect(incompleteUser.initials, equals('م'));
    });
  });

  group('Screen 17 V2 Passport — State Controller Lifecycle', () {
    late Screen17AccountController controller;

    setUp(() {
      controller = Screen17AccountController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('default initialization loads authenticated flagship profile with portrait and compact hero', () {
      expect(controller.isAuthenticated, isTrue);
      expect(controller.isLoading, isFalse);
      expect(controller.isCompactHero, isTrue);
      expect(controller.profile, isNotNull);
      expect(controller.profile!.fullName, equals('أحمد مصطفى'));
      expect(controller.profile!.proposedUsername, equals('ahmed_mostafa'));
      expect(controller.profile!.hasPortrait, isTrue);
      expect(controller.unreadNotificationCount, equals(2));
      expect(controller.savedFavoritesCount, equals(4));
      expect(controller.activeBookingsCount, equals(1));
    });

    test('setting guestUnauthenticated scenario purges profile securely', () {
      controller.setScenario(Screen17Scenario.guestUnauthenticated);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.profile, isNull);
    });

    test('setting sessionExpired401 scenario flags 401 and purges private profile', () {
      controller.setScenario(Screen17Scenario.sessionExpired401);
      expect(controller.is401Expired, isTrue);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.profile, isNull);
    });

    test('setting qrModal scenarios manages sheet visibility and tab index', () {
      controller.setScenario(Screen17Scenario.qrModalMyCode);
      expect(controller.showQrSheet, isTrue);
      expect(controller.qrTab, equals(0));

      controller.setQrTab(1);
      expect(controller.qrTab, equals(1));

      controller.closeQrSheet();
      expect(controller.showQrSheet, isFalse);
    });

    test('setting walletModalConcept opens wallet concept sheet', () {
      controller.setScenario(Screen17Scenario.walletModalConcept);
      expect(controller.showWalletSheet, isTrue);

      controller.closeWalletSheet();
      expect(controller.showWalletSheet, isFalse);
    });

    test('triggering, cancelling, and confirming logout', () {
      expect(controller.showLogoutDialog, isFalse);
      controller.requestLogout();
      expect(controller.showLogoutDialog, isTrue);

      controller.cancelLogout();
      expect(controller.showLogoutDialog, isFalse);

      controller.requestLogout();
      controller.confirmLogout();
      expect(controller.showLogoutDialog, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.profile, isNull);
    });

    test('showing and clearing feedback notice', () {
      expect(controller.dialogNotice, isNull);
      controller.showNotice('معاينة مسار تجريبي');
      expect(controller.dialogNotice, equals('معاينة مسار تجريبي'));
      controller.clearNotice();
      expect(controller.dialogNotice, isNull);
    });
  });

  group('Screen 17 V2 Passport — Source-Linked UI Widget Tests', () {
    testWidgets('renders Arabic root header "حسابي", QR action button, and active Account bottom tab', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('حسابي'), findsOneWidget);
      expect(find.byKey(const Key('header_qr_button')), findsOneWidget);
      expect(find.byType(CustomerBottomNavigation), findsOneWidget);

      // Verify Account tab (index 3) is active
      final navFinder = find.byType(CustomerBottomNavigation);
      final navWidget = tester.widget<CustomerBottomNavigation>(navFinder);
      expect(navWidget.selectedIndex, equals(3));
    });

    testWidgets('renders flagship identity hero with portrait, camera badge, and NO phone number in hero fold', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('أحمد مصطفى'), findsOneWidget);
      expect(find.text('@ahmed_mostafa'), findsOneWidget);
      expect(find.byKey(const Key('avatar_tap_area')), findsOneWidget);
      expect(find.byKey(const Key('camera_edit_badge')), findsOneWidget);
      expect(find.byKey(const Key('hero_edit_profile_button')), findsOneWidget);

      // Crucial Founder Invariant: Telephone number must NOT be displayed in the hero fold
      expect(find.text('+20 10••••5678'), findsNothing);
    });

    testWidgets('verifies removal of the 3 shortcut tiles per Founder UX Recomposition', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('quick_action_bookings')), findsNothing);
      expect(find.byKey(const Key('quick_action_favorites')), findsNothing);
      expect(find.byKey(const Key('quick_action_notifications')), findsNothing);
    });

    testWidgets('renders upcoming stay card when active reservation exists', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('upcoming_stay_card')), findsOneWidget);
      expect(find.text('إقامتك القادمة'), findsOneWidget);
      expect(find.text('حجز مؤكد'), findsOneWidget);
    });

    testWidgets('renders grouped navigation sections with calm neutral labels and left-pointing chevrons', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('الحساب والملف الشخصي'), findsOneWidget);
      expect(find.byKey(const Key('nav_profile_edit')), findsOneWidget);
      expect(find.byKey(const Key('nav_privacy_security')), findsOneWidget);
      expect(find.byKey(const Key('nav_linked_accounts')), findsOneWidget);

      expect(find.text('المالية والمدفوعات'), findsOneWidget);
      expect(find.byKey(const Key('nav_payment_history')), findsOneWidget);
      expect(find.byKey(const Key('nav_wallet_concept')), findsOneWidget);

      expect(find.text('المساعدة والخدمات'), findsOneWidget);
      expect(find.byKey(const Key('nav_help_support')), findsOneWidget);
      expect(find.byKey(const Key('nav_share_konfrm')), findsOneWidget);

      // Verify physical LEFT chevrons for RTL navigation
      final chevronFinder = find.byIcon(Icons.chevron_left);
      expect(chevronFinder, findsWidgets);
    });

    testWidgets('renders Share KONFRM integrated row and reachable logout button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('nav_share_konfrm')), findsOneWidget);
      expect(find.text('شارك كونفرم مع معارفك'), findsOneWidget);
      expect(find.byKey(const Key('account_logout_button')), findsOneWidget);
    });

    testWidgets('tapping QR header button opens Personal QR modal with My Code tab', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('header_qr_button')));
      await tester.pumpAndSettle();

      expect(find.text('بطاقة الحساب الشخصية (QR)'), findsOneWidget);
      expect(find.text('رمزي'), findsOneWidget);
      expect(find.text('مسح رمز'), findsOneWidget);
      expect(find.text('مشاركة الرمز'), findsOneWidget);

      // Close QR sheet
      await tester.tap(find.byKey(const Key('qr_close_button')));
      await tester.pumpAndSettle();
      expect(find.text('بطاقة الحساب الشخصية (QR)'), findsNothing);
    });

    testWidgets('tapping wallet navigation row opens proposed Wallet Concept modal (#173) with truthful zero claim', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_wallet_concept')));
      await tester.pumpAndSettle();

      expect(find.text('محفظة كونفرم'), findsWidgets);
      expect(find.text('المحفظة قيد التجهيز'), findsOneWidget);
      expect(find.text('0.00'), findsNothing);
      expect(find.textContaining('#173'), findsWidgets);
      expect(find.textContaining('1,200'), findsNothing);

      // Close wallet sheet
      await tester.tap(find.byKey(const Key('wallet_close_button')));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping logout button triggers confirmation dialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('account_logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('تسجيل الخروج من الحساب'), findsOneWidget);
      expect(find.byKey(const Key('dialog_cancel_logout')), findsOneWidget);
      expect(find.byKey(const Key('dialog_confirm_logout')), findsOneWidget);

      await tester.tap(find.byKey(const Key('dialog_cancel_logout')));
      await tester.pumpAndSettle();
      expect(find.text('تسجيل الخروج من الحساب'), findsNothing);
    });

    testWidgets('accessibility 200% text scale renders with zero RenderFlex overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      // Trigger accessibility scenario
      final viewState = tester.state<Screen17PreviewViewState>(find.byType(Screen17PreviewView));
      viewState.applyScenario(Screen17Scenario.accessibility200Top);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('حسابي'), findsOneWidget);
      expect(find.text('أحمد مصطفى'), findsOneWidget);
    });
  });
}
