import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// DIRECT SOURCE-LINKED IMPORT of the actual Flutter preview runner:
import '../tool/screen14_preview_runner_v3_final.dart';

void main() {
  group('KONFRM Screen 14 V3-Final Source-Linked Controller Tests', () {
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

    test('04. P0 AMOUNT_CHANGED: Decoupled Revalidation Workflow & Realistic Waiting State', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.amountChanged,
        booking: fixtures[0],
      );

      // 1. Customer initiates revalidation
      expect(ctrl.startAmountRevalidation(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.revalidatingAmount));
      expect(ctrl.activeRevalidationToken, isNotNull);
      expect(ctrl.activeRevalidationToken, startsWith('REVAL-BK-001'));
      expect(ctrl.revalidationBookingId, equals('BK-001'));
      expect(ctrl.revalidationEpoch, equals(ctrl.authEpoch));

      // 2. While revalidating, payment initiation remains strictly blocked
      expect(ctrl.initiatePayment(), isFalse);
      expect(ctrl.initiationAttempts, equals(0));
    });

    test('05. P0 AMOUNT_CHANGED: Runtime Guards on Authoritative Validation (Replacing Assert)', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.amountChanged,
        booking: fixtures[0],
      );
      ctrl.startAmountRevalidation();
      final validToken = ctrl.activeRevalidationToken!;

      // Guard 1: Wrong booking ID rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: 'MISMATCHED-ID',
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 15000,
          newRemainingAmount: 12000,
        ),
        isFalse,
      );
      expect(ctrl.state, equals(Screen14PaymentState.revalidatingAmount));

      // Guard 2: Wrong / stale revalidation token rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: 'STALE-TOKEN-999',
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 15000,
          newRemainingAmount: 12000,
        ),
        isFalse,
      );

      // Guard 3: Empty revalidation token rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: '',
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 15000,
          newRemainingAmount: 12000,
        ),
        isFalse,
      );

      // Guard 4: Stale epoch rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch + 99,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 15000,
          newRemainingAmount: 12000,
        ),
        isFalse,
      );

      // Guard 5: Non-positive nightly price rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: -100,
          newDepositAmount: -100,
          newTotalStay: -500,
          newRemainingAmount: -400,
        ),
        isFalse,
      );

      // Guard 6: Inconsistent deposit (MR-13: deposit != nightly) rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 2500, // VIOLATION
          newTotalStay: 15000,
          newRemainingAmount: 12500,
        ),
        isFalse,
      );

      // Guard 7: Inconsistent total stay (total != nights * nightly) rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 99999, // VIOLATION
          newRemainingAmount: 96999,
        ),
        isFalse,
      );

      // Guard 8: Inconsistent remainder (remainder != total - deposit) rejected fail-closed
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 15000,
          newRemainingAmount: 5000, // VIOLATION
        ),
        isFalse,
      );

      // Valid response with matching identity & math succeeds
      expect(
        ctrl.completeAuthoritativeAmountValidation(
          bookingId: ctrl.booking!.id,
          revalidationToken: validToken,
          requestEpoch: ctrl.authEpoch,
          newNightlyPrice: 3000,
          newDepositAmount: 3000,
          newTotalStay: 15000,
          newRemainingAmount: 12000,
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.amountRevalidated));
      expect(ctrl.booking!.depositAmount, equals(3000));
      expect(ctrl.booking!.totalStay, equals(15000));
      expect(ctrl.activeRevalidationToken, isNull, reason: 'Token consumed');
    });

    test('06. P0 AMOUNT_CHANGED: Explicit Customer Consent Required before Ready', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.amountChanged,
        booking: fixtures[0],
      );
      ctrl.startAmountRevalidation();
      ctrl.completeAuthoritativeAmountValidation(
        bookingId: ctrl.booking!.id,
        revalidationToken: ctrl.activeRevalidationToken!,
        requestEpoch: ctrl.authEpoch,
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
      expect(ctrl.activeTransactionId, isNotNull);
    });

    test('07. P0 AMOUNT_CHANGED: Cross-Booking Stale Callbacks & 401 Session Purge', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.amountChanged,
        booking: fixtures[0],
      );
      ctrl.startAmountRevalidation();
      final originalToken = ctrl.activeRevalidationToken!;

      // 401 purge during revalidation wipes session
      ctrl.trigger401SessionPurge();
      expect(ctrl.state, equals(Screen14PaymentState.unauthorized));
      expect(ctrl.booking, isNull);
      expect(ctrl.activeRevalidationToken, isNull);

      // Delayed callback for prior booking/token is strictly rejected
      final delayedReval = ctrl.completeAuthoritativeAmountValidation(
        bookingId: 'BK-001',
        revalidationToken: originalToken,
        requestEpoch: 1,
        newNightlyPrice: 3000,
        newDepositAmount: 3000,
        newTotalStay: 15000,
        newRemainingAmount: 12000,
      );
      expect(delayedReval, isFalse);
    });

    test('08. P0 STATUS CHECK: Negative Paths & No Automatic Confirmation', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.paymentPending,
        booking: fixtures[0],
        activeTransactionId: 'TXN-BK001-TEST',
      );

      // Status check enters checkingStatus, NEVER automatic success
      expect(ctrl.checkStatus(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.checkingStatus));

      // While checkingStatus, initiatePayment is forbidden
      expect(ctrl.initiatePayment(), isFalse);
    });

    test('09. P0 MOCK RESPONSE: Strict Identity Binding on Mock Confirmed', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.checkingStatus,
        booking: fixtures[0],
        activeTransactionId: 'TXN-BK001-ACTIVE',
      );

      // 1. Mismatched booking ID rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: 'WRONG-BOOKING',
          transactionId: 'TXN-BK001-ACTIVE',
        ),
        isFalse,
      );
      expect(ctrl.state, equals(Screen14PaymentState.checkingStatus));

      // 2. Empty booking ID rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: '',
          transactionId: 'TXN-BK001-ACTIVE',
        ),
        isFalse,
      );

      // 3. Mismatched transaction ID rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TXN-BK001-WRONG',
        ),
        isFalse,
      );

      // 4. Empty transaction ID rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: '',
        ),
        isFalse,
      );

      // 5. Stale caller epoch rejected
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch + 1,
          bookingId: ctrl.booking!.id,
          transactionId: 'TXN-BK001-ACTIVE',
        ),
        isFalse,
      );

      // 6. Matching booking AND matching transaction ID succeeds
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.confirmed,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TXN-BK001-ACTIVE',
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.success));
    });

    test('10. P0 MOCK RESPONSE: Explicit Routing for Non-Confirmed Responses', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.checkingStatus,
        booking: fixtures[0],
        activeTransactionId: 'TXN-BK001-ACTIVE',
      );

      // STILL_PENDING returns to paymentPending
      expect(
        ctrl.handleMockResponse(
          response: MockAuthoritativeResponse.stillPending,
          callerEpoch: ctrl.authEpoch,
          bookingId: ctrl.booking!.id,
          transactionId: 'TXN-BK001-ACTIVE',
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
          transactionId: 'TXN-BK001-ACTIVE',
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
          transactionId: 'TXN-BK001-ACTIVE',
        ),
        isTrue,
      );
      expect(ctrl.state, equals(Screen14PaymentState.failed));
    });

    test('11. P0 MONOTONIC EPOCH & 401 PURGE: Memory Wipe and Stale Callbacks', () {
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
      expect(ctrl.activeTransactionId, isNull);

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

    test('12. Single Initiation Guard & Counter Lock', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.ready,
        booking: fixtures[0],
      );

      expect(ctrl.initiatePayment(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.initiating));
      expect(ctrl.initiationAttempts, equals(1));
      expect(ctrl.activeTransactionId, startsWith('TXN-BK-001-1-'));

      // Rapid second tap is strictly rejected
      expect(ctrl.initiatePayment(), isFalse);
      expect(ctrl.initiationAttempts, equals(1));
    });

    test('13. Ineligible States Reject Payment Initiation', () {
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
        Screen14PaymentState.amountChanged,
        Screen14PaymentState.revalidatingAmount,
        Screen14PaymentState.amountRevalidated,
      ];

      for (final s in ineligibleStates) {
        final ctrl = Screen14StateController(state: s, booking: fixtures[0]);
        expect(ctrl.initiatePayment(), isFalse, reason: 'Initiation must fail for state $s');
      }
    });

    test('14. Fresh Attempt Guard', () {
      final ctrl = Screen14StateController(
        state: Screen14PaymentState.failed,
        booking: fixtures[0],
        activeTransactionId: 'TXN-FAILED',
      );
      expect(ctrl.requestFreshAttempt(), isTrue);
      expect(ctrl.state, equals(Screen14PaymentState.ready));
      expect(ctrl.activeTransactionId, isNull);

      // From success, fresh attempt is forbidden
      ctrl.state = Screen14PaymentState.success;
      expect(ctrl.requestFreshAttempt(), isFalse);
    });
  });

  group('KONFRM Screen 14 V3-Final Widget & UI Invariant Tests', () {
    testWidgets('15. Clean Customer Mode Gate: No QA Banners or Controls', (tester) async {
      await tester.pumpWidget(const Screen14PreviewApp());
      await tester.pumpAndSettle();

      // Top AppBar is clean and centered with title
      expect(find.widgetWithText(AppBar, 'دفع العربون'), findsOneWidget);

      // Zero QA disclaimers or dropdowns in customer viewport
      expect(find.textContaining('معاينة تجريبية'), findsNothing);
      expect(find.textContaining('اختر السيناريو'), findsNothing);
      expect(find.textContaining('اختر نتيجة الخادم'), findsNothing);
    });

    testWidgets('16. Button Height Reconciled to Exactly 56dp', (tester) async {
      await tester.pumpWidget(const Screen14PreviewApp());
      await tester.pumpAndSettle();

      final ctaFinder = find.byType(ElevatedButton);
      expect(ctaFinder, findsOneWidget);

      final buttonSize = tester.getSize(ctaFinder);
      expect(buttonSize.height, equals(56.0), reason: 'Accessible touch height is exactly 56dp');
    });

    testWidgets('17. Truthful Copy Invariant: No Unverified Guarantees', (tester) async {
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

    testWidgets('18. P1 Financial Copy: Remainder Rendered Numerically Without Policy Assertions', (tester) async {
      await tester.pumpWidget(const Screen14PreviewApp());
      await tester.pumpAndSettle();

      // Remainder label and numerical value rendered
      expect(find.text('المتبقي بعد العربون'), findsOneWidget);
      expect(find.text('10,800'), findsOneWidget);

      // Forbidden unapproved policy text MUST NOT exist anywhere
      expect(find.textContaining('سياسة الوحدة'), findsNothing);
      expect(find.textContaining('يُسدد لاحقاً'), findsNothing);
    });
  });
}
