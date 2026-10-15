// =============================================================================
// KONFRM Customer Screen 16 — Notification Center (مركز الإشعارات)
// Source-Linked Unit and Behavioral Widget Tests
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import '../tool/screen16_preview_runner.dart';

void main() {
  group('Screen 16 Customer Notification Center — Fixture & Domain Model Integrity', () {
    test('sample fixtures pass domain invariants', () {
      expect(kSyntheticNotifications.isNotEmpty, isTrue);
      for (final item in kSyntheticNotifications) {
        expect(item.notificationId, isNotEmpty);
        expect(item.title, isNotEmpty);
        expect(item.body, isNotEmpty);
        expect(item.createdAtText, isNotEmpty);
      }
    });

    test('approval notification strictly requires deposit and never claims booking is confirmed', () {
      final approvalItem = kSyntheticNotifications.firstWhere(
        (i) => i.eventType == CustomerNotificationEventType.bookingApprovedPendingPayment,
      );
      expect(approvalItem.actionRequired, isTrue);
      expect(approvalItem.body, contains('أصبح دفع العربون الخطوة التالية'));
      expect(approvalItem.body, isNot(contains('تم تأكيد الحجز')));
    });

    test('rejection notification informs customer without attributing blame', () {
      final rejectionItem = kSyntheticNotifications.firstWhere(
        (i) => i.eventType == CustomerNotificationEventType.bookingRejected,
      );
      expect(rejectionItem.actionRequired, isFalse);
      expect(rejectionItem.title, equals('لم يوافق المالك على طلب الحجز'));
    });
  });

  group('Screen 16 Customer Notification Center — State Controller Lifecycle', () {
    late Screen16NotificationsController controller;

    setUp(() {
      controller = Screen16NotificationsController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial load initializes with truthful empty state and 0 unread count', () {
      expect(controller.items.isEmpty, isTrue);
      expect(controller.unreadCount, equals(0));
      expect(controller.isLoading, isFalse);
      expect(controller.is401Expired, isFalse);
    });

    test('loading QA synthetic scenario populates fixtures and unread count', () {
      controller.setScenario(Screen16Scenario.readyListTop);
      expect(controller.items.length, equals(kSyntheticNotifications.length));
      expect(controller.unreadCount, equals(2)); // notif_001 and notif_002
    });

    test('markAsRead updates item state and decrements unread count', () {
      controller.setScenario(Screen16Scenario.readyListTop);
      controller.markAsRead('notif_001');
      final item = controller.items.firstWhere((i) => i.notificationId == 'notif_001');
      expect(item.isRead, isTrue);
      expect(controller.unreadCount, equals(1));
    });

    test('markAllAsRead marks all notifications as read', () {
      controller.setScenario(Screen16Scenario.readyListTop);
      controller.markAllAsRead();
      expect(controller.unreadCount, equals(0));
      for (final item in controller.items) {
        expect(item.isRead, isTrue);
      }
    });

    test('401 session expiry purges all cached private notifications', () {
      controller.setScenario(Screen16Scenario.sessionExpired401);
      expect(controller.is401Expired, isTrue);
      expect(controller.items.isEmpty, isTrue);
      expect(controller.unreadCount, equals(0));
    });

    test('stale error state preserves loaded items with stale flag active', () {
      controller.setScenario(Screen16Scenario.staleRefreshError);
      expect(controller.isStaleError, isTrue);
      expect(controller.items.isNotEmpty, isTrue);
    });

    test('missing target notification triggers truthful dialog notice', () {
      controller.setScenario(Screen16Scenario.readyListTop);
      final missingItem = controller.items.firstWhere((i) => !i.isTargetAvailable);
      controller.selectNotification(missingItem);
      expect(controller.dialogNotice, isNotNull);
      expect(controller.dialogNotice, contains('لم تعد متاحة'));
    });
  });

  group('Screen 16 Customer Notification Center — Source-Linked UI Widget Tests', () {
    testWidgets('renders Arabic RTL header with back button and active Account tab in bottom nav', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen16PreviewApp());
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('الإشعارات'), findsOneWidget);
      expect(find.text('تحديثات مهمة على طلباتك وحجوزاتك.'), findsOneWidget);
      expect(find.bySemanticsLabel('العودة إلى الحساب'), findsOneWidget);

      // Verify canonical CustomerBottomNavigation with Account tab (index 3) active
      expect(find.byType(CustomerBottomNavigation), findsOneWidget);
      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(3));
      expect(find.byKey(const Key('customer-destination-3')), findsOneWidget);
    });

    testWidgets('renders notification cards with unread badges and deposit action button in QA scenario', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen16PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen16HarnessPageState>(find.byType(Screen16HarnessPage));
      state.applyScenario(Screen16Scenario.readyListTop);
      await tester.pumpAndSettle();

      // Verify unread badge & action-required badge
      expect(find.text('مطلوب إجراء: دفع العربون'), findsOneWidget);
      expect(find.text('وافق المالك على طلب الحجز'), findsOneWidget);
      expect(find.text('لم يوافق المالك على طلب الحجز'), findsOneWidget);
    });

    testWidgets('empty state renders truthful peaceful guidance and explore button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen16PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen16HarnessPageState>(find.byType(Screen16HarnessPage));
      state.applyScenario(Screen16Scenario.emptyNoNotifications);
      await tester.pumpAndSettle();

      expect(find.text('لا توجد إشعارات حتى الآن'), findsOneWidget);
      expect(find.text('استكشف الإقامات'), findsOneWidget);
      expect(find.text('وافق المالك على طلب الحجز'), findsNothing);
    });

    testWidgets('session expired 401 state renders secure prompt with zero leaked cards', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen16PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen16HarnessPageState>(find.byType(Screen16HarnessPage));
      state.applyScenario(Screen16Scenario.sessionExpired401);
      await tester.pumpAndSettle();

      expect(find.text('انتهت جلسة تسجيل الدخول'), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
      // Zero leaked cards
      expect(find.text('وافق المالك على طلب الحجز'), findsNothing);
      expect(find.text('شاليه فاخر بإطلالة مباشرة على لاجون مراسي'), findsNothing);
    });

    testWidgets('missing destination dialog displays truthful message on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen16PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen16HarnessPageState>(find.byType(Screen16HarnessPage));
      state.applyScenario(Screen16Scenario.missingDestinationDialog);
      await tester.pumpAndSettle();

      expect(find.text('الوجهة غير متاحة'), findsOneWidget);
      expect(find.text('الوجهة المرتبطة بهذا الإشعار لم تعد متاحة أو تم إلغاؤها.'), findsOneWidget);
      expect(find.text('فهمت ذلك'), findsOneWidget);

      await tester.tap(find.text('فهمت ذلك'));
      await tester.pumpAndSettle();
      expect(find.text('الوجهة غير متاحة'), findsNothing);
    });

    testWidgets('accessibility 200% text scale renders with zero RenderFlex overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      await tester.pumpWidget(const Screen16PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen16HarnessPageState>(find.byType(Screen16HarnessPage));
      state.applyScenario(Screen16Scenario.accessibility200Top);
      await tester.pumpAndSettle();

      // Zero overflow check: tester.takeException() returns null
      expect(tester.takeException(), isNull);
      expect(find.text('الإشعارات'), findsOneWidget);
      expect(find.byType(CustomerBottomNavigation), findsOneWidget);
    });
  });
}
