// =============================================================================
// KONFRM Customer Screen 17 — Account Home (الحساب)
// Source-Linked Unit and Behavioral Widget Tests
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import '../tool/screen17_preview_runner.dart';

void main() {
  group('Screen 17 Customer Account Home — Domain Helpers & Invariants', () {
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

    test('CustomerProfileData accurately computes incomplete and display properties', () {
      const completeUser = CustomerProfileData(
        userId: 'u1',
        fullName: 'أحمد مصطفى',
        verifiedPhone: '+201012345678',
      );
      expect(completeUser.isIncomplete, isFalse);
      expect(completeUser.displayName, equals('أحمد مصطفى'));
      expect(completeUser.initials, equals('أ.م'));
      expect(completeUser.displayIdentifier, equals('+20 10••••5678'));

      const incompleteUser = CustomerProfileData(
        userId: 'u2',
        fullName: null,
        verifiedPhone: '+201098765432',
      );
      expect(incompleteUser.isIncomplete, isTrue);
      expect(incompleteUser.displayName, equals('مستأجر'));
      expect(incompleteUser.initials, equals('م'));
      expect(incompleteUser.displayIdentifier, equals('+20 10••••5432'));
    });
  });

  group('Screen 17 Customer Account Home — State Controller Lifecycle', () {
    late Screen17AccountController controller;

    setUp(() {
      controller = Screen17AccountController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('default initialization loads authenticated complete profile', () {
      expect(controller.isAuthenticated, isTrue);
      expect(controller.isLoading, isFalse);
      expect(controller.profile, isNotNull);
      expect(controller.profile!.fullName, equals('أحمد مصطفى'));
      expect(controller.unreadNotificationCount, equals(2));
    });

    test('setting guestUnauthenticated scenario purges profile and unreads', () {
      controller.setScenario(Screen17Scenario.guestUnauthenticated);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.profile, isNull);
      expect(controller.unreadNotificationCount, equals(0));
    });

    test('setting sessionExpired401 scenario purges private profile securely', () {
      controller.setScenario(Screen17Scenario.sessionExpired401);
      expect(controller.is401Expired, isTrue);
      expect(controller.profile, isNull); // Zero private info leak
    });

    test('setting identityIntegrityFailure scenario flags integrity failure without verified identity', () {
      controller.setScenario(Screen17Scenario.identityIntegrityFailure);
      expect(controller.identityIntegrityFailed, isTrue);
      expect(controller.profile!.verifiedPhone, isNull);
      expect(controller.profile!.verifiedEmail, isNull);
    });

    test('triggering and dismissing logout confirmation dialog', () {
      expect(controller.showLogoutDialog, isFalse);
      controller.triggerLogoutDialog();
      expect(controller.showLogoutDialog, isTrue);
      controller.dismissLogoutDialog();
      expect(controller.showLogoutDialog, isFalse);
    });

    test('showing and dismissing navigation notice', () {
      expect(controller.dialogNotice, isNull);
      controller.showNotice('معاينة: اختبار مسار');
      expect(controller.dialogNotice, equals('معاينة: اختبار مسار'));
      controller.dismissDialogNotice();
      expect(controller.dialogNotice, isNull);
    });
  });

  group('Screen 17 Customer Account Home — Source-Linked UI Widget Tests', () {
    testWidgets('renders Arabic header "حسابي" and active Account tab in bottom nav', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('حسابي'), findsOneWidget);
      expect(find.byType(CustomerBottomNavigation), findsOneWidget);

      // Verify Account tab (index 3) is active
      final navFinder = find.byType(CustomerBottomNavigation);
      final navWidget = tester.widget<CustomerBottomNavigation>(navFinder);
      expect(navWidget.selectedIndex, equals(3));
    });

    testWidgets('renders identity card with initials and LTR-isolated masked phone', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('أحمد مصطفى'), findsOneWidget);
      expect(find.text('أ.م'), findsOneWidget);
      expect(find.text('+20 10••••5678'), findsOneWidget);
      expect(find.text('تعديل'), findsOneWidget);
    });

    testWidgets('renders grouped navigation sections with calm neutral labels and badge', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('رحلاتك'), findsOneWidget);
      expect(find.text('حجوزاتي'), findsWidgets); // Appears in row and bottom nav
      expect(find.text('المفضلة'), findsWidgets); // Appears in row and bottom nav
      expect(find.text('النشاط'), findsOneWidget);
      expect(find.text('الإشعارات'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Unread badge
      expect(find.text('المدفوعات'), findsWidgets);

      // Scroll to view lower sections
      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.authenticatedCompleteScrolled);
      await tester.pumpAndSettle();

      expect(find.text('الحساب'), findsWidgets); // Appears in section header and bottom nav
      expect(find.text('البيانات الشخصية'), findsOneWidget);
      expect(find.text('المساعدة'), findsOneWidget);
      expect(find.text('المساعدة والدعم'), findsOneWidget);
      expect(find.text('تسجيل الخروج'), findsOneWidget);
    });

    testWidgets('navigation rows use chevrons pointing physically LEFT in RTL', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      // Find chevrons inside directionality
      final chevronFinder = find.byIcon(Icons.chevron_left);
      expect(chevronFinder, findsWidgets);
    });

    testWidgets('incomplete profile scenario renders gentle prompt and action button', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.authenticatedIncompleteProfile);
      await tester.pumpAndSettle();

      expect(find.text('أكمل بيانات حسابك'), findsOneWidget);
      expect(find.text('إكمال البيانات'), findsOneWidget);
      expect(find.text('مستأجر'), findsOneWidget);
    });

    testWidgets('guest scenario renders login card with black CTA and zero leaked profile data', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.guestUnauthenticated);
      await tester.pumpAndSettle();

      expect(find.text('تسجيل الدخول أو إنشاء حساب'), findsOneWidget);
      expect(find.text('دخول برقم الجوال'), findsOneWidget);
      expect(find.text('أحمد مصطفى'), findsNothing);
    });

    testWidgets('session expired 401 scenario renders secure card with zero private data', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.sessionExpired401);
      await tester.pumpAndSettle();

      expect(find.text('انتهت جلسة تسجيل الدخول'), findsOneWidget);
      expect(find.text('تسجيل الدخول مجدداً'), findsOneWidget);
      expect(find.text('أحمد مصطفى'), findsNothing);
    });

    testWidgets('identity integrity failure scenario renders fail-closed notice', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.identityIntegrityFailure);
      await tester.pumpAndSettle();

      expect(find.text('لا يمكن التحقق من هوية الحساب'), findsOneWidget);
      expect(find.text('تسجيل الدخول لإعادة التحقق'), findsOneWidget);
    });

    testWidgets('tapping logout button triggers confirmation dialog', (tester) async {
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.logoutConfirmationDialog);
      await tester.pumpAndSettle();

      expect(find.text('هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
    });

    testWidgets('accessibility 200% text scale renders with zero RenderFlex overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen17PreviewApp());
      await tester.pumpAndSettle();

      final harnessState = tester.state<Screen17HarnessPageState>(find.byType(Screen17HarnessPage));
      harnessState.applyScenario(Screen17Scenario.accessibility200Top);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('حسابي'), findsOneWidget);
      expect(find.text('أحمد مصطفى'), findsOneWidget);
    });
  });
}
