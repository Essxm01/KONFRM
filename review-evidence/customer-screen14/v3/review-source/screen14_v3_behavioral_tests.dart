import 'dart:io';

// =============================================================================
// KONFRM Customer Screen 14 Deposit Payment V3 Behavioral Test Suite
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

enum MockAuthoritativeResponse {
  confirmed,
  stillPending,
  failed,
  unknownTimeout,
  unauthorized,
}

class CivilArabicDateFormatter {
  static const List<String> _arabicWeekdays = [
    '',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static const List<String> _arabicMonths = [
    '',
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static String formatCivilDate(DateTime dt) {
    final weekday = _arabicWeekdays[dt.weekday];
    final month = _arabicMonths[dt.month];
    return '$weekday، ${dt.day} $month ${dt.year}';
  }

  static String formatRange(DateTime checkIn, DateTime checkOut) {
    return '${formatCivilDate(checkIn)} ← ${formatCivilDate(checkOut)}';
  }
}

class BookingPropertyRecord {
  const BookingPropertyRecord({
    required this.id,
    required this.title,
    required this.locationName,
    required this.unitType,
  });

  final String id;
  final String title;
  final String locationName;
  final String unitType;
}

class CustomerBookingRecord {
  const CustomerBookingRecord({
    required this.id,
    required this.bookingNumber,
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.guestsCount,
    required this.nightlyPrice,
    required this.totalStay,
    required this.depositAmount,
    required this.remainingAmount,
    required this.currency,
    required this.property,
    required this.status,
  });

  final String id;
  final String bookingNumber;
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final int guestsCount;
  final int nightlyPrice;
  final int totalStay;
  final int depositAmount;
  final int remainingAmount;
  final String currency;
  final BookingPropertyRecord property;
  final String status;

  String get formattedDates =>
      CivilArabicDateFormatter.formatRange(checkIn, checkOut);
}

class Screen14StateController {
  Screen14StateController({
    required this.state,
    this.booking,
    this.authEpoch = 1,
  });

  Screen14PaymentState state;
  CustomerBookingRecord? booking;
  int authEpoch;
  int initiationAttempts = 0;

  bool initiatePayment() {
    if (state != Screen14PaymentState.ready || booking == null) {
      return false;
    }
    state = Screen14PaymentState.initiating;
    initiationAttempts++;
    return true;
  }

  bool checkStatus() {
    if (state != Screen14PaymentState.paymentPending &&
        state != Screen14PaymentState.networkReconciliationRequired) {
      return false;
    }
    // Strictly transitions to checkingStatus, NEVER automatic success!
    state = Screen14PaymentState.checkingStatus;
    return true;
  }

  bool handleMockResponse({
    required MockAuthoritativeResponse response,
    required int callerEpoch,
  }) {
    if (callerEpoch != authEpoch) {
      // Stale callback dropped!
      return false;
    }
    if (state != Screen14PaymentState.checkingStatus) {
      return false;
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
        trigger401SessionPurge();
        break;
    }
    return true;
  }

  void trigger401SessionPurge() {
    state = Screen14PaymentState.unauthorized;
    booking = null; // Memory wipe!
    authEpoch++; // Invalidate any in-flight callbacks
  }

  bool requestFreshAttempt() {
    if (booking == null) return false;
    if (state != Screen14PaymentState.failed &&
        state != Screen14PaymentState.transactionExpired) {
      return false;
    }
    state = Screen14PaymentState.ready;
    return true;
  }

  bool acknowledgeAmountChange() {
    if (state != Screen14PaymentState.amountChanged) return false;
    state = Screen14PaymentState.ready;
    return true;
  }
}

// =============================================================================
// Test Runner & Assertions
// =============================================================================

void main() {
  print('======================================================================');
  print('KONFRM Customer Screen 14 V3 Behavioral & Safety Test Suite');
  print('======================================================================');

  int passed = 0;
  int total = 0;

  void test(String name, void Function() body) {
    total++;
    try {
      body();
      passed++;
      print('  ✓ PASS: $name');
    } catch (e, st) {
      print('  ✗ FAIL: $name\n    $e\n$st');
    }
  }

  final sampleBooking = CustomerBookingRecord(
    id: 'BK-001',
    bookingNumber: 'BK-829104',
    propertyId: 'PROP-01',
    checkIn: DateTime(2026, 10, 20),
    checkOut: DateTime(2026, 10, 25),
    nights: 5,
    guestsCount: 4,
    nightlyPrice: 2700,
    totalStay: 13500,
    depositAmount: 2700,
    remainingAmount: 10800,
    currency: 'ج.م',
    status: 'APPROVED_PENDING_PAYMENT',
    property: const BookingPropertyRecord(
      id: 'PROP-01',
      title: 'فيلا مارينا الساحل الشمالي',
      locationName: 'مارينا 5، الساحل الشمالي',
      unitType: 'فيلا كاملة',
    ),
  );

  test('01. Fixture Integrity: 5 nights x 2,700 = 13,500; First night deposit = 2,700; Remainder = 10,800', () {
    assert(sampleBooking.nights >= 2 && sampleBooking.nights <= 30);
    assert(sampleBooking.checkOut.difference(sampleBooking.checkIn).inDays == sampleBooking.nights);
    assert(sampleBooking.totalStay == sampleBooking.nights * sampleBooking.nightlyPrice);
    assert(sampleBooking.depositAmount == sampleBooking.nightlyPrice);
    assert(sampleBooking.remainingAmount == sampleBooking.totalStay - sampleBooking.depositAmount);
  });

  test('02. Civil Arabic Date Formatting: Matches Tuesday 20 Oct to Sunday 25 Oct 2026 with Western Digits', () {
    final formatted = sampleBooking.formattedDates;
    assert(formatted == 'الثلاثاء، 20 أكتوبر 2026 ← الأحد، 25 أكتوبر 2026',
        'Expected civil date range, got: $formatted');
    assert(formatted.contains('2026'));
    assert(formatted.contains('20'));
    assert(formatted.contains('25'));
    assert(formatted.contains('←'));
  });

  test('03. Single Initiation Lock: READY -> INITIATING; Rapid double-tap rejected', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.ready,
      booking: sampleBooking,
    );

    final tap1 = ctrl.initiatePayment();
    assert(tap1 == true);
    assert(ctrl.state == Screen14PaymentState.initiating);
    assert(ctrl.initiationAttempts == 1);

    // Second tap while initiating must be rejected!
    final tap2 = ctrl.initiatePayment();
    assert(tap2 == false);
    assert(ctrl.state == Screen14PaymentState.initiating);
    assert(ctrl.initiationAttempts == 1);
  });

  test('04. Non-Automatic Status Check: Tapping Check Status transitions strictly to CHECKING_STATUS, NEVER SUCCESS', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.paymentPending,
      booking: sampleBooking,
    );

    final ok = ctrl.checkStatus();
    assert(ok == true);
    assert(ctrl.state == Screen14PaymentState.checkingStatus);
    assert(ctrl.state != Screen14PaymentState.success,
        'Tapping checkStatus must NEVER auto-confirm payment without server authority!');
  });

  test('05. Mock Response Injection: CONFIRMED leads to SUCCESS only upon explicit response', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: sampleBooking,
    );

    final ok = ctrl.handleMockResponse(
      response: MockAuthoritativeResponse.confirmed,
      callerEpoch: ctrl.authEpoch,
    );
    assert(ok == true);
    assert(ctrl.state == Screen14PaymentState.success);
  });

  test('06. Mock Response Injection: STILL_PENDING returns to PAYMENT_PENDING', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: sampleBooking,
    );

    final ok = ctrl.handleMockResponse(
      response: MockAuthoritativeResponse.stillPending,
      callerEpoch: ctrl.authEpoch,
    );
    assert(ok == true);
    assert(ctrl.state == Screen14PaymentState.paymentPending);
  });

  test('07. Mock Response Injection: FAILED leads to FAILED attempt', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: sampleBooking,
    );

    final ok = ctrl.handleMockResponse(
      response: MockAuthoritativeResponse.failed,
      callerEpoch: ctrl.authEpoch,
    );
    assert(ok == true);
    assert(ctrl.state == Screen14PaymentState.failed);
  });

  test('08. Mock Response Injection: TIMEOUT leads to NETWORK_RECONCILIATION_REQUIRED', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: sampleBooking,
    );

    final ok = ctrl.handleMockResponse(
      response: MockAuthoritativeResponse.unknownTimeout,
      callerEpoch: ctrl.authEpoch,
    );
    assert(ok == true);
    assert(ctrl.state == Screen14PaymentState.networkReconciliationRequired);
  });

  test('09. 401 Session Purge: Memory wipe of booking and epoch invalidation', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: sampleBooking,
      authEpoch: 1,
    );

    ctrl.trigger401SessionPurge();
    assert(ctrl.state == Screen14PaymentState.unauthorized);
    assert(ctrl.booking == null, 'Booking record must be wiped from memory on 401!');
    assert(ctrl.authEpoch == 2, 'Auth epoch must increment to drop late callbacks!');
  });

  test('10. Stale Callback Drop: Late delayed response with stale epoch is discarded', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.checkingStatus,
      booking: sampleBooking,
      authEpoch: 1,
    );

    final staleEpoch = ctrl.authEpoch;
    // Session expires in the meantime
    ctrl.trigger401SessionPurge();
    assert(ctrl.authEpoch == 2);
    assert(ctrl.state == Screen14PaymentState.unauthorized);

    // Stale delayed response arrives
    final handled = ctrl.handleMockResponse(
      response: MockAuthoritativeResponse.confirmed,
      callerEpoch: staleEpoch,
    );
    assert(handled == false, 'Stale response must be dropped!');
    assert(ctrl.state == Screen14PaymentState.unauthorized,
        'Stale response must not resurrect state!');
    assert(ctrl.booking == null);
  });

  test('11. Fresh Attempt Guard: Allowed only from FAILED or TRANSACTION_EXPIRED', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.failed,
      booking: sampleBooking,
    );

    assert(ctrl.requestFreshAttempt() == true);
    assert(ctrl.state == Screen14PaymentState.ready);

    // From initiating, fresh attempt is prohibited!
    ctrl.state = Screen14PaymentState.initiating;
    assert(ctrl.requestFreshAttempt() == false);
  });

  test('12. Amount Changed Acknowledgment: Allowed only from AMOUNT_CHANGED', () {
    final ctrl = Screen14StateController(
      state: Screen14PaymentState.amountChanged,
      booking: sampleBooking,
    );

    assert(ctrl.acknowledgeAmountChange() == true);
    assert(ctrl.state == Screen14PaymentState.ready);

    // From ready, acknowledge is no-op
    assert(ctrl.acknowledgeAmountChange() == false);
  });

  print('======================================================================');
  print('Result: $passed / $total tests passed (${(passed / total * 100).toStringAsFixed(1)}%)');
  print('======================================================================');

  if (passed != total) {
    exit(1);
  }
}
