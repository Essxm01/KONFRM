import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// DIRECT SOURCE-LINKED IMPORT of the actual Flutter preview runner:
import '../tool/screen14_preview_runner_v3_corrective.dart';

void main() {
  group('KONFRM Screen 14 V3 Source-Linked Controller Tests', () {
    late List<CustomerBookingRecord> fixtures;

    setUp(() {
      fixtures = Screen14SampleFixtures.getAllFixtures();
    });

    test('01. Fixture Integrity & MR-13 Invariants', () {
      Screen14SampleFixtures.assertFixtureIntegrity(fixtures);
      final b = fixtures[0];
      expect(b.nights, inInclusiveRange(2, 30));
      expect(b.checkOut.difference(b.checkIn).inDays, equals(b.nights));
      expect(b.totalStay, equals(b.nights * b.nightlyPrice));
      expect(b.depositAmount, equals(b.nightlyPrice), reason: 'MR-13: First night deposit');
      expect(b.remainingAmount, equals(b.totalStay - b.depositAmount));
    });

    test('02. Civil Arabic Date Formatting Uses Arabic Names and Western Digits', () {
      final checkIn = DateTime(2026, 10, 20);
      final checkOut = DateTime(2026, 10, 25);
      final formattedIn = CivilArabicDateFormatter.formatCivilDate(checkIn);
      final formattedOut = CivilArabicDateFormatter.formatCivilDate(checkOut);

      expect(formattedIn, equals('الثلاثاء، 20 أكتوبر 2026'));
      expect(formattedOut, equals('الأحد، 25 أكتوبر 2026'));
      expect(CivilArabicDateFormatter.formatRange(checkIn, checkOut),
          contains('الثلاثاء، 20 أكتوبر 2026 ← الأحد، 25 أكتوبر 2026'));
    });

    test('03. P0 AMOUNT_CHANGED: Payment Initiation Strictly Blocked', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.amountChanged,
        booking: fixtures[0],
      );

      // Initiation must be strictly blocked from amountChanged
      expect(ctrl.initiatePayment(), isFalse);
      expect(ctrl.initiationAttempts, equals(0));
      expect(ctrl.state, equals(Screen14PaymentState.amountChanged));
    });

    test('04. P0 AMOUNT_CHANGED: Revalidation Workflow with Identity Check', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.amountChanged,
        booking: fixtures[0],
      );

      // 1. Customer initiates revalidation
      expect(ctrl.startAmountRevalidation(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.revalidatingAmount));

      // 2. While revalidating, payment initiation remains strictly blocked
      expect(ctrl.initiatePayment(), isFalse);

      // 3. Mismatched booking ID in authoritative validation is strictly rejected
      final mismatchSuccess = ctrl.completeAuthoritativeAmountValidation(
        bookingId: 'MISMATCHED-ID',
        newNightlyPrice: 3000,
        newDepositAmount: 3000,
        newTotalStay: 15000,
        newRemainingAmount: 12000,
      );
      expect(mismatchSuccess, isFalse);
      expect(ctrl.state, equals(Screen14PaymentState.revalidatingAmount));

      // 4. Matching booking ID updates numbers and transitions to amountRevalidated
      final validSuccess = ctrl.completeAuthoritativeAmountValidation(
        bookingId: ctrl.booking!.id,
        newNightlyPrice: 3000,
        newDepositAmount: 3000,
        newTotalStay: 15000,
        newRemainingAmount: 12000,
      );
      expect(validSuccess, isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.amountRevalidated));
      expect(ctrl.booking!.depositAmount, equals(3000));
      expect(ctrl.booking!.totalStay, equals(15000));
    });

    test('05. P0 AMOUNT_CHANGED: Explicit Customer Consent Required before Ready', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.revalidatingAmount,
        booking: fixtures[0],
      );

      ctrl.completeAuthoritativeAmountValidation(
        bookingId: ctrl.booking!.id,
        newNightlyPrice: 3000,
        newDepositAmount: 3000,
        newTotalStay: 15000,
        newRemainingAmount: 12000,
      );
      expect(ctrl.state, equals(Screen14PaymentState.amountRevalidated));

      // Even after server validates, customer has not yet consented -> payment blocked!
      expect(ctrl.initiatePayment(), isFalse);

      // Customer gives explicit consent to the revalidated amount
      expect(ctrl.consentToRevalidatedAmount(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.ready));

      // Now and only now can payment be initiated
      expect(ctrl.initiatePayment(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.initiating));
      expect(ctrl.initiationAttempts, equals(1));
    });

    test('06. P0 STATUS CHECK: Negative Paths & No Automatic Confirmation', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.paymentPending,
        booking: fixtures[0],
      );

      // Status check enters checkingStatus, NEVER automatic success
      expect(ctrl.checkStatus(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.checkingStatus));

      // While checkingStatus, initiatePayment is forbidden
      expect(ctrl.initiatePayment(), isFalse);
    });

    test('07. P0 MOCK RESPONSE: Identity Checks & Explicit Routing', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.checkingStatus,
        booking: fixtures[0],
      );

      // Mismatched booking ID rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: 'WRONG-BOOKING',
          transactionId: 'TX-12345',
        ),
        isFalse,
      );
      expect(ctrl.state, equals(Screen14PaymentState.checkingStatus));

      // Empty transaction ID rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: '',
        ),
        isFalse,
      );

      // STILL_PENDING returns to paymentPending
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.stillPending,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TX-12345',
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.paymentPending));

      // TIMEOUT routes to networkReconciliationRequired
      ctrl.state = Screen14PaymentState.checkingStatus;
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.unknownTimeout,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TX-12345',
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.networkReconciliationRequired));

      // FAILED routes to failed
      ctrl.state = Screen14PaymentState.checkingStatus;
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.failed,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TX-12345',
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.failed));

      // CONFIRMED routes to success
      ctrl.state = Screen14PaymentState.checkingStatus;
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TX-12345',
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.success));
    });

    test('08. P0 MONOTONIC EPOCH & 401 PURGE: Memory Wipe and Stale Callbacks', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.ready,
        booking: fixtures[0],
        authEpoch: 1,
      );

      // Trigger 401 Session Purge
      ctrl.trigger401SessionPurge();
      expect(ctrl.state, equals(Screen14PaymentState.unauthorized));
      expect(ctrl.booking, isNull, reason: 'Memory wipe of sensitive customer records');
      expect(ctrl.authEpoch, equals(2));

      // Delayed callback from epoch 1 is strictly dropped
      bool callbackExecuted = false;
      final callbackHandled = ctrl.handleDelayedCallback(
        callbackEpoch: 1,
        onValid: () => callbackExecuted = true,
      );
      expect(callbackHandled, isFalse);
      expect(callbackExecuted, isFalse);

      // Mock response from epoch 1 is strictly rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: 1,
          bookingId: 'BK-001',
          transactionId: 'TX-999',
        ),
        isFalse,
      );
    });

    test('09. Single Initiation Guard & Counter Lock', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.ready,
        booking: fixtures[0],
      );

      expect(ctrl.initiatePayment(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.initiating));
      expect(ctrl.initiationAttempts, equals(1));

      // Rapid second tap is strictly rejected
      expect(ctrl.initiatePayment(), isFalse);
      expect(ctrl.initiationAttempts, equals(1));
    });

    test('10. Ineligible States Reject Payment Initiation', () {
      final ineligibleStates = [
        Screen14PaymentState.alreadyConfirmed,
        Screen14PaymentState.stateChanged,
        Screen14PaymentState.unauthorized,
        Screen14PaymentState.forbidden,
        Screen14PaymentState.notFound,
        Screen14PaymentState.error,
        Screen14PaymentState.initialLoading,
        Screen14PaymentState.providerUnavailable,
        Screen14PaymentState.networkReconciliationRequired,
        Screen14PaymentState.failed,
        Screen14PaymentState.transactionExpired,
      ];

      for (final s in ineligibleStates) {
        final ctrl = Screen14StateController(state: s, booking: fixtures[0]);
        expect(ctrl.initiatePayment(), isFalse, reason: 'Initiation must fail for state $s');
      }
    });

    test('11. Fresh Attempt Guard', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.failed,
        booking: fixtures[0],
      );
      expect(ctrl.requestFreshAttempt(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.ready));

      // From success, fresh attempt is forbidden
      ctrl.state = Screen14PaymentState.success;
      expect(ctrl.requestFreshAttempt(), isFalse);
    });
  });

  group('KONFRM Screen 14 V3 Widget & UI Invariant Tests', () {
    testWidgets('12. Clean Customer Mode Gate: No QA Banners or Controls', (tester) async {
      await tester.pumpWidget(const Screen14PreviewApp());
      await tester.pumpAndSettle();

      // Top AppBar is clean and centered with title
      expect(find.widgetWithText(AppBar, 'دفع العربون'), findsOneWidget);

      // Zero QA disclaimers or dropdowns in customer viewport
      expect(find.textContaining('معاينة تجريبية'), findsNothing);
      expect(find.textContaining('اختر السيناريو'), findsNothing);
      expect(find.textContaining('اختر نتيجة الخادم'), findsNothing);
    });

    testWidgets('13. Button Height Reconciled to Exactly 56dp', (tester) async {
      await tester.pumpWidget(const Screen14PreviewApp());
      await tester.pumpAndSettle();

      final ctaFinder = find.byType(ElevatedButton);
      expect(ctaFinder, findsOneWidget);

      final buttonSize = tester.getSize(ctaFinder);
      expect(buttonSize.height, equals(56.0), reason: 'Accessible touch height is exactly 56dp');
    });

    testWidgets('14. Truthful Copy Invariant: No Unverified Guarantees', (tester) async {
      await tester.pumpWidget(const Screen14PreviewApp());
      await tester.pumpAndSettle();

      // Truthful trust note is rendered
      expect(find.textContaining('العربون يمثل قيمة الليلة الأولى ويُحسم من إجمالي الإقامة'), findsOneWidget);
      expect(find.textContaining('تأكيد الحجز مشروط باعتماد سداد العربون بنجاح'), findsOneWidget);

      // Forbidden unverified guarantees must NOT exist
      expect(find.textContaining('دون فقدان الحجز'), findsNothing);
      expect(find.textContaining('فور استلام'), findsNothing);
      expect(find.textContaining('لم يتم خصم أي مبالغ من حسابك'), findsNothing);
    });
  });
}
