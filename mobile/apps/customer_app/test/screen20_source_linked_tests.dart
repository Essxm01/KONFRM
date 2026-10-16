// =============================================================================
// KONFRM Customer Screen 20 — Source-Linked Behavioral Test Suite
//
// Target: Customer Screen 20 — Payment History («سجل المدفوعات»)
// Authority: Cairo Typography, RTL First, Pure Black #000000, Canonical NESTED_CUSTOMER
// Bottom Navigation: Prohibited on nested screens per DESIGN_SYSTEM/COMPONENTS/navigation.md §3.3
// Governing Issues: #179, #175, #174, #173, #172, #171, #166, #155, #145
// =============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/screen20_preview_runner.dart';

void main() {
  group('Screen 20 — Domain Models & Synthetic State', () {
    test('CustomerPaymentHistoryState default values are secure and empty', () {
      const state = CustomerPaymentHistoryState();

      expect(state.isAuthenticated, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.hasNetworkError, isFalse);
      expect(state.transactions, isEmpty);
      expect(state.selectedFilter, PaymentHistoryFilter.all);
      expect(state.selectedTransactionForSheet, isNull);
      expect(state.filteredTransactions, isEmpty);
      expect(state.groupedTransactions, isEmpty);
    });

    test('CustomerPaymentHistoryState copyWith behaves predictably and immutably', () {
      final state = CustomerPaymentHistoryState(
        transactions: kSyntheticPaymentTransactions,
      );

      final updated = state.copyWith(
        isAuthenticated: false,
        isLoading: true,
        hasNetworkError: true,
        selectedFilter: PaymentHistoryFilter.paid,
      );

      expect(updated.isAuthenticated, isFalse);
      expect(updated.isLoading, isTrue);
      expect(updated.hasNetworkError, isTrue);
      expect(updated.selectedFilter, PaymentHistoryFilter.paid);
      // Original remains unchanged
      expect(state.isAuthenticated, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.hasNetworkError, isFalse);
      expect(state.selectedFilter, PaymentHistoryFilter.all);
    });

    test('filteredTransactions correctly isolates paid, pending, and other items', () {
      final state = CustomerPaymentHistoryState(
        transactions: kSyntheticPaymentTransactions,
      );

      // All: 5 items
      expect(state.filteredTransactions.length, 5);

      // Paid filter: 2 items
      final paidState = state.copyWith(selectedFilter: PaymentHistoryFilter.paid);
      expect(paidState.filteredTransactions.length, 2);
      expect(paidState.filteredTransactions.every((t) => t.status == PaymentStatus.paid), isTrue);

      // Pending filter: 1 item
      final pendingState = state.copyWith(selectedFilter: PaymentHistoryFilter.pending);
      expect(pendingState.filteredTransactions.length, 1);
      expect(pendingState.filteredTransactions.first.status, PaymentStatus.pending);

      // Other filter (reconciling, refunded, failed): 2 items
      final otherState = state.copyWith(selectedFilter: PaymentHistoryFilter.other);
      expect(otherState.filteredTransactions.length, 2);
    });

    test('groupedTransactions creates chronological month buckets properly', () {
      final state = CustomerPaymentHistoryState(
        transactions: kSyntheticPaymentTransactions,
      );

      final grouped = state.groupedTransactions;
      expect(grouped.keys, containsAll(['أكتوبر 2026', 'سبتمبر 2026']));
      expect(grouped['أكتوبر 2026']!.length, 3);
      expect(grouped['سبتمبر 2026']!.length, 2);
    });
  });

  group('Screen 20 — State Controller Lifecycle & Scenarios', () {
    late CustomerPaymentHistoryController controller;

    setUp(() {
      controller = CustomerPaymentHistoryController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('setFilter updates controller state and emits notification', () {
      expect(controller.state.selectedFilter, PaymentHistoryFilter.all);

      controller.setFilter(PaymentHistoryFilter.paid);
      expect(controller.state.selectedFilter, PaymentHistoryFilter.paid);

      controller.setFilter(PaymentHistoryFilter.pending);
      expect(controller.state.selectedFilter, PaymentHistoryFilter.pending);
    });

    test('open and close transaction detail sheet behaves correctly', () {
      expect(controller.state.selectedTransactionForSheet, isNull);

      final item = kSyntheticPaymentTransactions.first;
      controller.openTransactionDetail(item);
      expect(controller.state.selectedTransactionForSheet, equals(item));

      controller.closeTransactionDetail();
      expect(controller.state.selectedTransactionForSheet, isNull);
    });

    test('retryLoading clears network error and restores transactions', () {
      controller.setScenario(Screen20Scenario.networkErrorRetryState);
      expect(controller.state.hasNetworkError, isTrue);
      expect(controller.state.transactions, isEmpty);

      controller.retryLoading();
      expect(controller.state.hasNetworkError, isFalse);
      expect(controller.state.transactions, isNotEmpty);
      expect(controller.snackBarNotice, contains('تم تحديث'));
    });

    test('scenario transitions set expected states deterministically', () {
      controller.setScenario(Screen20Scenario.emptyState);
      expect(controller.state.transactions, isEmpty);
      expect(controller.state.isAuthenticated, isTrue);

      controller.setScenario(Screen20Scenario.reconciliationUnknownState);
      expect(controller.state.transactions.length, 2);
      expect(controller.state.transactions.any((t) => t.status == PaymentStatus.reconciling), isTrue);

      controller.setScenario(Screen20Scenario.unauthenticatedGuestState);
      expect(controller.state.isAuthenticated, isFalse);

      controller.setScenario(Screen20Scenario.transactionDetailSheet);
      expect(controller.state.selectedTransactionForSheet, isNotNull);
    });
  });

  group('Screen 20 — Issue #175 Pure-Black & Design Compliance', () {
    test('Runner source contains ZERO forbidden charcoal or navy color values', () {
      final runnerFile = File('tool/screen20_preview_runner.dart');
      expect(runnerFile.existsSync(), isTrue);

      final content = runnerFile.readAsStringSync();

      const forbiddenHexCodes = [
        '0xFF111827',
        '0xFF1F2937',
        '0xFF0F172A',
        '0xFF1E293B',
      ];

      for (final hex in forbiddenHexCodes) {
        expect(
          content.contains(hex),
          isFalse,
          reason: 'Source code in tool/screen20_preview_runner.dart must not contain forbidden color $hex',
        );
      }

      // Assert mandatory pure black #000000 is present
      expect(content.contains('0xFF000000'), isTrue);
    });
  });

  group('Screen 20 — Widget & Visual Presentation Tests', () {
    testWidgets('Renders canonical NESTED_CUSTOMER app bar without bottom nav', (tester) async {
      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      // Title
      expect(find.text('سجل المدفوعات'), findsOneWidget);

      // Back button with physical right arrow
      expect(find.byKey(const Key('payment_history_back_button')), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Refresh button
      expect(find.byKey(const Key('payment_history_refresh_button')), findsOneWidget);

      // Absolute absence of bottom navigation
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('Displays prominent first-fold synthetic disclaimer banner', (tester) async {
      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('first_fold_synthetic_disclaimer')), findsOneWidget);
      expect(find.text('بيانات تجريبية — ليست معاملات حقيقية'), findsOneWidget);
      expect(find.textContaining('جميع العمليات والمبالغ المعروضة في هذه الشاشة هي بيانات محاكاة'), findsOneWidget);
    });

    testWidgets('Renders summary card, filter bar, and transaction cards', (tester) async {
      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      // Summary Card
      expect(find.byKey(const Key('payment_summary_card')), findsOneWidget);
      expect(find.text('ملخص العمليات المسجلة'), findsOneWidget);
      expect(find.text('5 عمليات'), findsOneWidget);

      // Filter Bar
      expect(find.byKey(const Key('filter_tab_all')), findsOneWidget);
      expect(find.byKey(const Key('filter_tab_paid')), findsOneWidget);
      expect(find.byKey(const Key('filter_tab_pending')), findsOneWidget);

      // First transaction card
      expect(find.byKey(const Key('transaction_card_TXN-2026-881249')), findsOneWidget);
      expect(find.text('فيلا لؤلؤة البحر — مراسي'), findsOneWidget);
      expect(find.text('1450'), findsOneWidget);
      expect(find.text('ج.م'), findsWidgets);
    });

    testWidgets('Tapping transaction card opens contained detail sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      // Sheet initially closed
      expect(find.byKey(const Key('transaction_detail_sheet')), findsNothing);

      // Scroll to transaction card if needed and tap
      await tester.ensureVisible(find.byKey(const Key('transaction_card_TXN-2026-881249')));
      await tester.tap(find.byKey(const Key('transaction_card_TXN-2026-881249')));
      await tester.pumpAndSettle();

      // Sheet opened
      expect(find.byKey(const Key('transaction_detail_sheet')), findsOneWidget);
      expect(find.text('تفاصيل العملية (معاينة تجريبية)'), findsOneWidget);
      expect(find.text('إيصال تجريبي — لا يُعد مستنداً بنكياً رسمياً أو إشعار خصم ضريبي ملزم.'), findsOneWidget);
      expect(find.text('#BK-183223'), findsOneWidget);

      // Close sheet via top close button
      await tester.tap(find.byKey(const Key('close_detail_sheet_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transaction_detail_sheet')), findsNothing);
    });

    testWidgets('Empty state renders honest message and explore CTA', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen20PreviewViewState>(find.byType(Screen20PreviewView));
      state.applyScenario(Screen20Scenario.emptyState);
      await tester.pumpAndSettle();

      expect(find.text('لا توجد مدفوعات مسجلة بعد'), findsOneWidget);
      expect(find.byKey(const Key('empty_state_explore_cta')), findsOneWidget);
      expect(find.text('استكشف الإقامات'), findsOneWidget);
    });

    testWidgets('Reconciliation state displays transparent provider verification banner', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen20PreviewViewState>(find.byType(Screen20PreviewView));
      state.applyScenario(Screen20Scenario.reconciliationUnknownState);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reconciliation_alert_banner')), findsOneWidget);
      expect(find.text('عملية قيد المطابقة مع مزود الدفع'), findsOneWidget);
    });

    testWidgets('Network error state displays recoverable error and retry button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen20PreviewViewState>(find.byType(Screen20PreviewView));
      state.applyScenario(Screen20Scenario.networkErrorRetryState);
      await tester.pumpAndSettle();

      expect(find.text('تعذر تحميل سجل المدفوعات'), findsOneWidget);
      expect(find.byKey(const Key('network_error_retry_cta')), findsOneWidget);

      // Tapping retry recovers
      await tester.tap(find.byKey(const Key('network_error_retry_cta')));
      await tester.pumpAndSettle();

      expect(find.text('تعذر تحميل سجل المدفوعات'), findsNothing);
      expect(find.text('سجل المدفوعات'), findsOneWidget);
    });

    testWidgets('Unauthenticated guest state shields private financial data', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen20PreviewViewState>(find.byType(Screen20PreviewView));
      state.applyScenario(Screen20Scenario.unauthenticatedGuestState);
      await tester.pumpAndSettle();

      expect(find.text('سجّل الدخول لعرض مدفوعاتك'), findsOneWidget);
      expect(find.byKey(const Key('guest_login_cta')), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
      // No private transaction cards visible
      expect(find.byKey(const Key('transaction_card_TXN-2026-881249')), findsNothing);
    });

    testWidgets('Accessibility 200% font scale reflows without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const Screen20PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen20PreviewViewState>(find.byType(Screen20PreviewView));
      state.applyScenario(Screen20Scenario.accessibility200Top);
      await tester.pumpAndSettle();

      expect(find.text('سجل المدفوعات'), findsOneWidget);
      expect(find.byKey(const Key('first_fold_synthetic_disclaimer')), findsOneWidget);
      expect(tester.takeException(), isNull);

      state.applyScenario(Screen20Scenario.accessibility200Scrolled);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
