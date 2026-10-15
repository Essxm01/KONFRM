import 'dart:math';

// =============================================================================
// KONFRM Customer Screen 14 Deposit Payment Focused V2 Behavioral Tests
// =============================================================================

enum Screen14PaymentState {
  initialLoading,
  ready,
  initiating,
  checkingStatus,
  paymentPending,
  networkReconciliationRequired,
  failed,
  transactionExpired,
  amountChanged,
  providerUnavailable,
  success,
  alreadyConfirmed,
  stateChanged,
  unauthorized,
  forbidden,
  notFound,
  error,
}

enum Screen14AllowedAction {
  initiatePayment,
  checkStatus,
  requestFreshAttempt,
  acknowledgeAmount,
  returnToBooking,
  returnToBookings,
  reauthenticate,
  retryRevalidation,
  none,
}

enum MockAuthoritativeResponse {
  confirmed,
  stillPending,
  failed,
  unknownTimeout,
  unauthorized,
  amountChanged,
}

class CustomerBookingRecord {
  const CustomerBookingRecord({
    required this.id,
    required this.bookingNumber,
    required this.propertyId,
    required this.propertyTitle,
    required this.checkInIso,
    required this.checkOutIso,
    required this.nights,
    required this.guestsCount,
    required this.nightlyPrice,
    required this.totalStay,
    required this.depositAmount,
    required this.remainingAmount,
    required this.currency,
    required this.status,
  });

  final String id;
  final String bookingNumber;
  final String propertyId;
  final String propertyTitle;
  final String checkInIso;
  final String checkOutIso;
  final int nights;
  final int guestsCount;
  final int nightlyPrice;
  final int totalStay;
  final int depositAmount;
  final int remainingAmount;
  final String currency;
  final String status;
}

class Screen14V2StateController {
  Screen14V2StateController({
    required this.state,
    this.booking,
    this.currentEpoch = 1,
    this.initiationCount = 0,
    this.lastTransactionId,
  });

  Screen14PaymentState state;
  CustomerBookingRecord? booking;
  int currentEpoch;
  int initiationCount;
  String? lastTransactionId;

  // 1. Guarded Initiation from READY
  bool initiatePayment() {
    if (state != Screen14PaymentState.ready || booking == null) {
      return false;
    }
    initiationCount++;
    state = Screen14PaymentState.initiating;
    lastTransactionId = 'txn_mock_${DateTime.now().millisecondsSinceEpoch}';
    return true;
  }

  // 2. Transition from PENDING / RECONCILIATION to CHECKING_STATUS (NEVER direct to SUCCESS!)
  bool tapCheckStatus() {
    if (state != Screen14PaymentState.paymentPending &&
        state != Screen14PaymentState.networkReconciliationRequired) {
      return false;
    }
    // Strictly enters checkingStatus, NEVER confirmed/success!
    state = Screen14PaymentState.checkingStatus;
    return true;
  }

  // 3. Process Authoritative Mock Response
  void applyMockAuthoritativeResponse(MockAuthoritativeResponse response) {
    if (state != Screen14PaymentState.checkingStatus) {
      throw StateError('Cannot apply authoritative response when not in checkingStatus');
    }
    switch (response) {
      case MockAuthoritativeResponse.confirmed:
        state = Screen14PaymentState.success;
        break;
      case MockAuthoritativeResponse.stillPending:
        state = Screen14PaymentState.paymentPending;
        break;
      case MockAuthoritativeResponse.failed:
        state = Screen14PaymentState.failed;
        break;
      case MockAuthoritativeResponse.unknownTimeout:
        state = Screen14PaymentState.networkReconciliationRequired;
        break;
      case MockAuthoritativeResponse.unauthorized:
        handle401Unauthorized();
        break;
      case MockAuthoritativeResponse.amountChanged:
        state = Screen14PaymentState.amountChanged;
        break;
    }
  }

  // 4. In-memory sensitive state clearance upon 401
  void handle401Unauthorized() {
    currentEpoch++;
    state = Screen14PaymentState.unauthorized;
    // Wipe sensitive customer booking payload from memory
    booking = null;
    lastTransactionId = null;
  }

  // 5. Epoch-guarded asynchronous callback
  bool handleAsyncCompletion({required int dispatchEpoch, required Screen14PaymentState targetState}) {
    // If epoch changed (e.g. 401 occurred while async call was in flight), fail-closed and reject
    if (dispatchEpoch != currentEpoch) {
      return false;
    }
    state = targetState;
    return true;
  }
}

// -----------------------------------------------------------------------------
// Pure Domain Mappers & Invariant Checkers
// -----------------------------------------------------------------------------

Screen14PaymentState? resolveScreen14HttpErrorState(int status) {
  if (status == 401) return Screen14PaymentState.unauthorized;
  if (status == 403) return Screen14PaymentState.forbidden;
  if (status == 404) return Screen14PaymentState.notFound;
  if (status >= 500 && status <= 599) return Screen14PaymentState.error;
  return null;
}

Screen14AllowedAction getAllowedScreen14Action(Screen14PaymentState state, CustomerBookingRecord? booking) {
  switch (state) {
    case Screen14PaymentState.ready:
      return booking != null ? Screen14AllowedAction.initiatePayment : Screen14AllowedAction.none;
    case Screen14PaymentState.initiating:
    case Screen14PaymentState.checkingStatus:
    case Screen14PaymentState.initialLoading:
      return Screen14AllowedAction.none;
    case Screen14PaymentState.paymentPending:
    case Screen14PaymentState.networkReconciliationRequired:
      return Screen14AllowedAction.checkStatus;
    case Screen14PaymentState.failed:
    case Screen14PaymentState.transactionExpired:
      return Screen14AllowedAction.requestFreshAttempt;
    case Screen14PaymentState.amountChanged:
      return Screen14AllowedAction.acknowledgeAmount;
    case Screen14PaymentState.providerUnavailable:
      return Screen14AllowedAction.returnToBooking;
    case Screen14PaymentState.success:
    case Screen14PaymentState.alreadyConfirmed:
    case Screen14PaymentState.stateChanged:
      return Screen14AllowedAction.returnToBooking;
    case Screen14PaymentState.unauthorized:
      return Screen14AllowedAction.reauthenticate;
    case Screen14PaymentState.forbidden:
    case Screen14PaymentState.notFound:
      return Screen14AllowedAction.returnToBookings;
    case Screen14PaymentState.error:
      return Screen14AllowedAction.retryRevalidation;
  }
}

bool canStartFreshScreen14Attempt(Screen14PaymentState state, CustomerBookingRecord? booking) {
  if (booking == null) return false;
  if (booking.status != 'APPROVED_PENDING_PAYMENT') return false;
  return state == Screen14PaymentState.failed || state == Screen14PaymentState.transactionExpired;
}

bool evaluateResumedAmountAuthority({required int expectedDeposit, required int authoritativeDeposit}) {
  return expectedDeposit == authoritativeDeposit;
}

// =============================================================================
// Test Runner
// =============================================================================

void main() {
  print('======================================================================');
  print('Running KONFRM Screen 14 Focused V2 Comprehensive Behavioral Tests');
  print('======================================================================');

  int passed = 0;
  int failed = 0;

  void test(String name, void Function() fn) {
    try {
      fn();
      print('  ✓ PASS: $name');
      passed++;
    } catch (e, st) {
      print('  ✗ FAIL: $name\n    Error: $e\n$st');
      failed++;
    }
  }

  final fixtureA = CustomerBookingRecord(
    id: 'bkg_marassi_001',
    bookingNumber: 'BK-892415',
    propertyId: 'prop_marassi_villa',
    propertyTitle: 'فيلا شاطئية بمراسي',
    checkInIso: '2026-07-10',
    checkOutIso: '2026-07-15',
    nights: 5,
    guestsCount: 4,
    nightlyPrice: 2700,
    totalStay: 13500,
    depositAmount: 2700,
    remainingAmount: 10800,
    currency: 'EGP',
    status: 'APPROVED_PENDING_PAYMENT',
  );

  final fixtureB = CustomerBookingRecord(
    id: 'bkg_marassi_002',
    bookingNumber: 'BK-941820',
    propertyId: 'prop_lagoon_chalet',
    propertyTitle: 'شاليه بانورامي فاخر بإطلالة مباشرة على اللاجون والبحيرة الكريستالية',
    checkInIso: '2026-08-01',
    checkOutIso: '2026-08-05',
    nights: 4,
    guestsCount: 3,
    nightlyPrice: 3500,
    totalStay: 14000,
    depositAmount: 3500,
    remainingAmount: 10500,
    currency: 'EGP',
    status: 'APPROVED_PENDING_PAYMENT',
  );

  // ---------------------------------------------------------------------------
  // Test 1: Financial & Synthetic Invariants
  // ---------------------------------------------------------------------------
  test('Financial integrity: nights * nightlyPrice == totalStay, deposit == nightlyPrice', () {
    for (final f in [fixtureA, fixtureB]) {
      assert(f.nights * f.nightlyPrice == f.totalStay, 'Total stay mismatch');
      assert(f.depositAmount == f.nightlyPrice, 'Deposit must be first night');
      assert(f.totalStay - f.depositAmount == f.remainingAmount, 'Remaining mismatch');
      assert(f.nights >= 2 && f.nights <= 30, 'Nights out of range');
    }
  });

  // ---------------------------------------------------------------------------
  // Test 2: P0 Correction A — Pressing Check Status NEVER Directly Confirms Payment
  // ---------------------------------------------------------------------------
  test('P0 Correction A: tapCheckStatus transitions to checkingStatus, NEVER to success', () {
    final ctrl = Screen14V2StateController(
      state: Screen14PaymentState.paymentPending,
      booking: fixtureA,
    );

    // Pressing Check Status
    final transitioned = ctrl.tapCheckStatus();
    assert(transitioned == true, 'Must accept tap in paymentPending');
    assert(ctrl.state == Screen14PaymentState.checkingStatus, 'Must be checkingStatus');
    assert(ctrl.state != Screen14PaymentState.success, 'FORBIDDEN: Must not confirm directly!');

    // In checkingStatus, permitted action is none (busy)
    assert(getAllowedScreen14Action(ctrl.state, ctrl.booking) == Screen14AllowedAction.none);
  });

  // ---------------------------------------------------------------------------
  // Test 3: P0 Correction A — Controlled Mock Response Injection Routes
  // ---------------------------------------------------------------------------
  test('P0 Correction A: Explicit authoritative responses route accurately', () {
    // 3a. CONFIRMED response routes to SUCCESS
    final ctrlConfirmed = Screen14V2StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: fixtureA,
    );
    ctrlConfirmed.applyMockAuthoritativeResponse(MockAuthoritativeResponse.confirmed);
    assert(ctrlConfirmed.state == Screen14PaymentState.success, 'Must route to success');

    // 3b. STILL_PENDING response routes to PAYMENT_PENDING
    final ctrlPending = Screen14V2StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: fixtureA,
    );
    ctrlPending.applyMockAuthoritativeResponse(MockAuthoritativeResponse.stillPending);
    assert(ctrlPending.state == Screen14PaymentState.paymentPending, 'Must route to pending');

    // 3c. FAILED response routes to FAILED
    final ctrlFailed = Screen14V2StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: fixtureA,
    );
    ctrlFailed.applyMockAuthoritativeResponse(MockAuthoritativeResponse.failed);
    assert(ctrlFailed.state == Screen14PaymentState.failed, 'Must route to failed');

    // 3d. UNKNOWN / TIMEOUT response routes to NETWORK_RECONCILIATION_REQUIRED
    final ctrlTimeout = Screen14V2StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: fixtureA,
    );
    ctrlTimeout.applyMockAuthoritativeResponse(MockAuthoritativeResponse.unknownTimeout);
    assert(ctrlTimeout.state == Screen14PaymentState.networkReconciliationRequired, 'Must route to reconciliation');
  });

  // ---------------------------------------------------------------------------
  // Test 4: Single Initiation Guard & Rapid Double Tap Protection
  // ---------------------------------------------------------------------------
  test('Single initiation guard: rapid taps result in exactly ONE attempt count', () {
    final ctrl = Screen14V2StateController(
      state: Screen14PaymentState.ready,
      booking: fixtureA,
    );

    final firstTap = ctrl.initiatePayment();
    assert(firstTap == true, 'First tap must succeed');
    assert(ctrl.initiationCount == 1, 'Initiation count must be 1');
    assert(ctrl.state == Screen14PaymentState.initiating, 'State must be initiating');

    // Rapid second tap while in initiating
    final secondTap = ctrl.initiatePayment();
    assert(secondTap == false, 'Second tap must be rejected synchronously');
    assert(ctrl.initiationCount == 1, 'Initiation count must remain 1');

    // CTA must be disabled in initiating
    assert(getAllowedScreen14Action(ctrl.state, ctrl.booking) == Screen14AllowedAction.none);
  });

  // ---------------------------------------------------------------------------
  // Test 5: Monotonic Epoch Guard — 401 Cancels Stale Async Completion
  // ---------------------------------------------------------------------------
  test('Monotonic epoch guard: 401 clears in-memory booking and discards stale callbacks', () {
    final ctrl = Screen14V2StateController(
      state: Screen14PaymentState.ready,
      booking: fixtureA,
      currentEpoch: 10,
    );

    final dispatchEpoch = ctrl.currentEpoch; // 10
    ctrl.initiatePayment(); // state is initiating

    // Simulated 401 session expiry occurs before async return
    ctrl.handle401Unauthorized();
    assert(ctrl.state == Screen14PaymentState.unauthorized, 'State must be unauthorized');
    assert(ctrl.booking == null, 'Sensitive booking record must be purged from memory');
    assert(ctrl.currentEpoch == 11, 'Epoch must increment to invalidate pending listeners');

    // Stale delayed timer returns from epoch 10 trying to set success
    final accepted = ctrl.handleAsyncCompletion(
      dispatchEpoch: dispatchEpoch,
      targetState: Screen14PaymentState.success,
    );
    assert(accepted == false, 'Stale callback must be rejected');
    assert(ctrl.state == Screen14PaymentState.unauthorized, 'State must remain unauthorized');
    assert(ctrl.booking == null, 'Booking must remain null');
  });

  // ---------------------------------------------------------------------------
  // Test 6: Network Reconciliation Strictly Disallows NEW ATTEMPT
  // ---------------------------------------------------------------------------
  test('Network reconciliation allows only checkStatus, forbids fresh initiate', () {
    final ctrl = Screen14V2StateController(
      state: Screen14PaymentState.networkReconciliationRequired,
      booking: fixtureA,
    );

    assert(getAllowedScreen14Action(ctrl.state, ctrl.booking) == Screen14AllowedAction.checkStatus);
    assert(canStartFreshScreen14Attempt(ctrl.state, ctrl.booking) == false, 'No fresh attempt allowed');

    // Tapping initiate fails
    assert(ctrl.initiatePayment() == false, 'Cannot initiate during network reconciliation');
  });

  // ---------------------------------------------------------------------------
  // Test 7: Amount Changed Conflict Freezes Initiation
  // ---------------------------------------------------------------------------
  test('Amount changed evaluation detects mismatch and freezes initiation', () {
    assert(evaluateResumedAmountAuthority(expectedDeposit: 2500, authoritativeDeposit: 2700) == false);
    assert(evaluateResumedAmountAuthority(expectedDeposit: 2700, authoritativeDeposit: 2700) == true);

    final ctrl = Screen14V2StateController(
      state: Screen14PaymentState.amountChanged,
      booking: fixtureA,
    );

    assert(getAllowedScreen14Action(ctrl.state, ctrl.booking) == Screen14AllowedAction.acknowledgeAmount);
    assert(ctrl.initiatePayment() == false, 'Cannot initiate payment while amount is in conflict');
    assert(canStartFreshScreen14Attempt(ctrl.state, ctrl.booking) == false);
  });

  // ---------------------------------------------------------------------------
  // Test 8: Complete HTTP Error State Resolution (401, 403, 404, 500)
  // ---------------------------------------------------------------------------
  test('HTTP status resolution maps accurately to fail-closed error states', () {
    assert(resolveScreen14HttpErrorState(401) == Screen14PaymentState.unauthorized);
    assert(resolveScreen14HttpErrorState(403) == Screen14PaymentState.forbidden);
    assert(resolveScreen14HttpErrorState(404) == Screen14PaymentState.notFound);
    assert(resolveScreen14HttpErrorState(500) == Screen14PaymentState.error);
    assert(resolveScreen14HttpErrorState(502) == Screen14PaymentState.error);
    assert(resolveScreen14HttpErrorState(503) == Screen14PaymentState.error);
    assert(resolveScreen14HttpErrorState(200) == null);

    // Verify allowed action on 403/404
    assert(getAllowedScreen14Action(Screen14PaymentState.forbidden, null) == Screen14AllowedAction.returnToBookings);
    assert(getAllowedScreen14Action(Screen14PaymentState.notFound, null) == Screen14AllowedAction.returnToBookings);
    assert(getAllowedScreen14Action(Screen14PaymentState.error, null) == Screen14AllowedAction.retryRevalidation);
  });

  // ---------------------------------------------------------------------------
  // Test 9: Terminal State Pay Actions are Strictly Forbidden
  // ---------------------------------------------------------------------------
  test('Terminal & ineligible states have no payable CTA', () {
    final terminalStates = [
      Screen14PaymentState.success,
      Screen14PaymentState.alreadyConfirmed,
      Screen14PaymentState.stateChanged,
      Screen14PaymentState.unauthorized,
      Screen14PaymentState.forbidden,
      Screen14PaymentState.notFound,
    ];

    for (final st in terminalStates) {
      final action = getAllowedScreen14Action(st, fixtureA);
      assert(action != Screen14AllowedAction.initiatePayment, '$st must not allow initiatePayment');
      assert(action != Screen14AllowedAction.checkStatus, '$st must not allow checkStatus');
    }
  });

  print('\n----------------------------------------------------------------------');
  print('Behavioral Tests Result: $passed passed, $failed failed');
  print('======================================================================');

  if (failed > 0) {
    throw Exception('Some behavioral tests failed');
  }
}
