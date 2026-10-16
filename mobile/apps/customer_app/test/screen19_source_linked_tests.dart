// =============================================================================
// KONFRM Customer Screen 19 — Source-Linked Behavioral Test Suite
//
// Target: Customer Screen 19 — Settings («الإعدادات»)
// Authority: Cairo Typography, RTL First, Pure Black #000000, Canonical NESTED_CUSTOMER
// Bottom Navigation: Prohibited on nested screens per DESIGN_SYSTEM/COMPONENTS/navigation.md
// Governing Issues: #177, #175, #172, #171, #166, #155, #145
// =============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/screen19_preview_runner.dart';

void main() {
  group('Screen 19 — Domain Models & Synthetic State', () {
    test('CustomerSettingsState default values are secure, pristine and verified', () {
      const state = CustomerSettingsState();

      expect(state.isAuthenticated, isTrue);
      expect(state.verifiedPhoneMasked, contains('••••'));
      expect(state.verifiedEmailMasked, contains('•••••'));
      expect(state.isPhoneVerified, isTrue);
      expect(state.isEmailVerified, isTrue);
      expect(state.isAppleLinked, isFalse);
      expect(state.isGoogleLinked, isFalse);
      expect(state.osNotificationPermissionGranted, isTrue);
      expect(state.bookingUpdatesEnabled, isTrue);
      expect(state.hostMessagesEnabled, isTrue);
      expect(state.priceAlertsEnabled, isFalse);
      expect(state.appLanguage, 'العربية (الافتراضية)');
      expect(state.pricingCurrency, 'الجنيه المصري (EGP)');
      expect(state.reduceMotion, isFalse);
      expect(state.appearanceTheme, 'الوضع الفاتح المعتمد');
    });

    test('CustomerSettingsState copyWith behaves predictably and immutably', () {
      const state = CustomerSettingsState();
      final updated = state.copyWith(
        isAuthenticated: false,
        bookingUpdatesEnabled: false,
        priceAlertsEnabled: true,
        osNotificationPermissionGranted: false,
      );

      expect(updated.isAuthenticated, isFalse);
      expect(updated.bookingUpdatesEnabled, isFalse);
      expect(updated.priceAlertsEnabled, isTrue);
      expect(updated.osNotificationPermissionGranted, isFalse);
      // original unchanged
      expect(state.isAuthenticated, isTrue);
      expect(state.bookingUpdatesEnabled, isTrue);
    });
  });

  group('Screen 19 — State Controller Lifecycle & Interactions', () {
    late CustomerSettingsController controller;

    setUp(() {
      controller = CustomerSettingsController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('toggle notifications updates local state and emits feedback notice', () {
      expect(controller.state.priceAlertsEnabled, isFalse);

      controller.togglePriceAlerts(true);
      expect(controller.state.priceAlertsEnabled, isTrue);
      expect(controller.snackBarNotice, contains('تم تفعيل'));

      controller.toggleBookingUpdates(false);
      expect(controller.state.bookingUpdatesEnabled, isFalse);
      expect(controller.snackBarNotice, contains('تم إيقاف'));
    });

    test('sign-out dialog flow is guarded and non-destructive in prototype', () {
      expect(controller.showSignOutDialog, isFalse);

      controller.openSignOutDialog();
      expect(controller.showSignOutDialog, isTrue);

      controller.confirmSignOutDemo();
      expect(controller.showSignOutDialog, isFalse);
      expect(controller.snackBarNotice, contains('معاينة تجريبية'));
      // State remains safe
      expect(controller.state.isAuthenticated, isTrue);
    });

    test('permission denied sheet opens and closes cleanly', () {
      expect(controller.showPermissionDeniedSheet, isFalse);

      controller.openPermissionDeniedSheet();
      expect(controller.showPermissionDeniedSheet, isTrue);

      controller.closePermissionDeniedSheet();
      expect(controller.showPermissionDeniedSheet, isFalse);
    });

    test('account deletion policy sheet opens and closes cleanly', () {
      expect(controller.showAccountDeletionSheet, isFalse);

      controller.openAccountDeletionSheet();
      expect(controller.showAccountDeletionSheet, isTrue);

      controller.closeAccountDeletionSheet();
      expect(controller.showAccountDeletionSheet, isFalse);
    });

    test('planned feature sheet sets title and closes cleanly', () {
      expect(controller.plannedFeatureSheetTitle, isNull);

      controller.openPlannedFeatureSheet('ربط حساب Apple');
      expect(controller.plannedFeatureSheetTitle, 'ربط حساب Apple');

      controller.closePlannedFeatureSheet();
      expect(controller.plannedFeatureSheetTitle, isNull);
    });

    test('setScenario configures expected state for each scenario', () {
      controller.setScenario(Screen19Scenario.notificationsPermissionDenied);
      expect(controller.state.osNotificationPermissionGranted, isFalse);
      expect(controller.showPermissionDeniedSheet, isTrue);

      controller.setScenario(Screen19Scenario.signOutConfirmationDialog);
      expect(controller.showSignOutDialog, isTrue);

      controller.setScenario(Screen19Scenario.unauthenticatedGuestState);
      expect(controller.state.isAuthenticated, isFalse);

      controller.setScenario(Screen19Scenario.accountDeletionInfoSheet);
      expect(controller.showAccountDeletionSheet, isTrue);
    });
  });

  group('Screen 19 — Pure Black #000000 Compliance (Issue #175)', () {
    test('screen19_preview_runner.dart source file contains zero forbidden charcoal or navy colors', () {
      final file = File('tool/screen19_preview_runner.dart');
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();

      const forbiddenColors = [
        '0xFF111827',
        '0xFF0F172A',
        '0xFF18181B',
        '0xFF09090B',
        '0xFF1F2937',
        '#111827',
        '#0f172a',
        '#18181b',
        '#09090b',
        '#1f2937',
      ];

      for (final color in forbiddenColors) {
        expect(
          content.contains(color),
          isFalse,
          reason: 'Forbidden near-black color $color found in screen19_preview_runner.dart. Must use exact #000000.',
        );
      }
    });
  });

  group('Screen 19 — Behavioral Widget Tests', () {
    testWidgets('renders canonical NESTED_CUSTOMER header with physical right return arrow and NO bottom navigation', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      // Title «الإعدادات»
      expect(find.text('الإعدادات'), findsOneWidget);

      // Back button
      final backButton = find.byKey(const Key('settings_back_button'));
      expect(backButton, findsOneWidget);

      // Verify NO bottom navigation bar exists on screen (canonical nested screen contract)
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.text('استكشف'), findsNothing);
      expect(find.text('المفضلة'), findsNothing);
      expect(find.text('حجوزاتي'), findsNothing);
    });

    testWidgets('renders Section 1 (الأمان وطرق الدخول) with masked identifiers and planned entry rows', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('الأمان وطرق الدخول'), findsOneWidget);
      expect(find.text('رقم الهاتف الأساسي'), findsOneWidget);
      expect(find.text('البريد الإلكتروني الأساسي'), findsOneWidget);
      expect(find.text('مؤكّد'), findsNWidgets(2)); // Green verified badges for phone & email

      // Planned feature entry rows
      expect(find.byKey(const Key('row_add_alternate_phone')), findsOneWidget);
      expect(find.byKey(const Key('row_add_alternate_email')), findsOneWidget);
      expect(find.byKey(const Key('row_link_apple')), findsOneWidget);
      expect(find.byKey(const Key('row_link_google')), findsOneWidget);

      expect(find.text('قريباً'), findsNWidgets(2));
      expect(find.text('غير متاح حالياً'), findsNWidgets(2));
    });

    testWidgets('renders Section 2 (الإشعارات والتنبيهات) with OS permission state and channel toggles', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('الإشعارات والتنبيهات'), findsOneWidget);
      expect(find.text('إذن إشعارات النظام (الجهاز)'), findsOneWidget);
      expect(find.text('مفعّل'), findsOneWidget);

      expect(find.byKey(const Key('toggle_booking_updates')), findsOneWidget);
      expect(find.byKey(const Key('toggle_host_messages')), findsOneWidget);
      expect(find.byKey(const Key('toggle_price_alerts')), findsOneWidget);

      // Toggle price alerts
      await tester.scrollUntilVisible(find.byKey(const Key('toggle_price_alerts')), 100);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle_price_alerts')));
      await tester.pumpAndSettle();

      expect(find.textContaining('تم تفعيل تنبيهات الأسعار'), findsOneWidget);
    });

    testWidgets('renders Section 3 (تفضيلات التطبيق) and Section 4 (الخصوصية والحساب)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      // Scroll down to reveal bottom sections
      await tester.scrollUntilVisible(find.byKey(const Key('row_sign_out')), 100);
      await tester.pumpAndSettle();

      // Preferences
      expect(find.text('تفضيلات التطبيق'), findsOneWidget);
      expect(find.text('لغة التطبيق'), findsOneWidget);
      expect(find.text('عملة التسعير والمدفوعات'), findsOneWidget);
      expect(find.text('الجنيه المصري (EGP)'), findsOneWidget);

      // Privacy
      expect(find.text('الخصوصية وإدارة الحساب'), findsOneWidget);
      expect(find.byKey(const Key('row_privacy_policy')), findsOneWidget);
      expect(find.byKey(const Key('row_terms_of_service')), findsOneWidget);
      expect(find.byKey(const Key('row_account_deletion')), findsOneWidget);
      expect(find.byKey(const Key('row_sign_out')), findsOneWidget);
    });

    testWidgets('tapping sign-out action displays confirmation dialog with cancel and confirm', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byKey(const Key('row_sign_out')), 100);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('row_sign_out')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sign_out_cancel_button')), findsOneWidget);
      expect(find.byKey(const Key('sign_out_confirm_button')), findsOneWidget);
      expect(find.textContaining('هل أنت متأكد من رغبتك في تسجيل الخروج'), findsOneWidget);

      // Cancel dismisses dialog
      await tester.tap(find.byKey(const Key('sign_out_cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sign_out_cancel_button')), findsNothing);
    });

    testWidgets('tapping account deletion tile opens informative policy sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.byKey(const Key('row_account_deletion')), 100);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('row_account_deletion')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('account_deletion_sheet_dismiss')), findsOneWidget);
      expect(find.textContaining('وفقاً لسياسة حوكمة الحسابات والخصوصية'), findsOneWidget);

      await tester.tap(find.byKey(const Key('account_deletion_sheet_dismiss')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('account_deletion_sheet_dismiss')), findsNothing);
    });

    testWidgets('permission denied scenario renders warning and opens recovery sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen19PreviewViewState>(find.byType(Screen19PreviewView));
      state.applyScenario(Screen19Scenario.notificationsPermissionDenied);
      await tester.pumpAndSettle();

      expect(find.text('متوقف بالنظام'), findsOneWidget);
      expect(find.byKey(const Key('permission_sheet_dismiss_button')), findsOneWidget);
      expect(find.text('إذن الإشعارات متوقف على جهازك'), findsOneWidget);

      await tester.tap(find.byKey(const Key('permission_sheet_dismiss_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('permission_sheet_dismiss_button')), findsNothing);
    });

    testWidgets('unauthenticated scenario protects security rows and displays login prompt', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen19PreviewViewState>(find.byType(Screen19PreviewView));
      state.applyScenario(Screen19Scenario.unauthenticatedGuestState);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('guest_sign_in_button')), findsOneWidget);
      expect(find.text('تسجيل الدخول / إنشاء حساب'), findsOneWidget);
      expect(find.text('رقم الهاتف الأساسي'), findsNothing);
      expect(find.byKey(const Key('row_sign_out')), findsNothing);
    });

    testWidgets('renders cleanly under 200% text scale without overflow or label clipping', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen19PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen19PreviewViewState>(find.byType(Screen19PreviewView));
      state.applyScenario(Screen19Scenario.accessibility200Top);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الإعدادات'), findsOneWidget);
      expect(find.text('الأمان وطرق الدخول'), findsOneWidget);

      state.applyScenario(Screen19Scenario.accessibility200Scrolled);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
