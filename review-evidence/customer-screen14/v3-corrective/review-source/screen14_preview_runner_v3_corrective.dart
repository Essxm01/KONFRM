import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final fixtures = Screen14SampleFixtures.getAllFixtures();
  Screen14SampleFixtures.assertFixtureIntegrity(fixtures);
  runApp(const Screen14PreviewApp());
}

// =============================================================================
// Canonical Booking & Payment Domain Types for Screen 14 V3
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
  revalidatingAmount,
  amountRevalidated,
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
  startAmountRevalidation,
  consentToRevalidatedAmount,
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
}

// =============================================================================
// 21 Canonical Scenarios Matching V2 Baseline Exactly
// =============================================================================

enum Screen14Scenario {
  readyTopFold(
    id: '01',
    label: '01. جاهز للدفع — الطي الأول (مبلغ العربون 2,700 ج.م والزر)',
    state: Screen14PaymentState.ready,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  readyScrolledSameBooking(
    id: '02',
    label: '02. جاهز للدفع — بعد التمرير (نفس الحجز 2,700 ج.م والتفاصيل المالية)',
    state: Screen14PaymentState.ready,
    fixtureIndex: 0,
    textScale: 1.0,
    autoScrollToEnd: true,
  ),
  readyLongTitleFixture(
    id: '03',
    label: '03. جاهز للدفع — عنوان عقار طويل (حجز مستقل 3,500 ج.م)',
    state: Screen14PaymentState.ready,
    fixtureIndex: 1,
    textScale: 1.0,
  ),
  initiatingState(
    id: '04',
    label: '04. جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار)',
    state: Screen14PaymentState.initiating,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  paymentPending(
    id: '05',
    label: '05. الدفع قيد المعالجة (استعلام الحالة دون تكرار الخصم)',
    state: Screen14PaymentState.paymentPending,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  checkingStatus(
    id: '06',
    label: '06. جارٍ التحقق من الخادم (واجهة عميل نقية دون نجاح تلقائي)',
    state: Screen14PaymentState.checkingStatus,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  networkReconciliationRequired(
    id: '07',
    label: '07. انقطاع الاتصال (مراجعة آمنة دون خصم مكرر)',
    state: Screen14PaymentState.networkReconciliationRequired,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  failedAttempt(
    id: '08',
    label: '08. تعذر إتمام الدفع (محاولة جديدة بعد التحقق)',
    state: Screen14PaymentState.failed,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  transactionExpired(
    id: '09',
    label: '09. انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا)',
    state: Screen14PaymentState.transactionExpired,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  amountChangedConflict(
    id: '10',
    label: '10. تغيّر مبلغ العربون (مراجعة المبلغ والموافقة الصريحة)',
    state: Screen14PaymentState.amountChanged,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  revalidatingAmountState(
    id: '10B',
    label: '10ب. جارٍ التحقق المعتمد من السعر الجديد (تعطيل الدفع)',
    state: Screen14PaymentState.revalidatingAmount,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  amountRevalidatedConsent(
    id: '10C',
    label: '10ج. تم اعتماد السعر الجديد — طلب الموافقة الصريحة للمتابعة',
    state: Screen14PaymentState.amountRevalidated,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  providerUnavailable(
    id: '11',
    label: '11. بوابة الدفع غير متاحة (حدود نزيهة دون تزييف صيانة)',
    state: Screen14PaymentState.providerUnavailable,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  mockConfirmedSuccess(
    id: '12',
    label: '12. تأكيد الدفع الصريح (محاكاة خادم صادقة بعد رد CONFIRMED)',
    state: Screen14PaymentState.success,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  alreadyConfirmed(
    id: '13',
    label: '13. الحجز مؤكد مسبقًا (لا عربون مطلوب)',
    state: Screen14PaymentState.alreadyConfirmed,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  stateChangedIneligible(
    id: '14',
    label: '14. تغيرت حالة الحجز (الدفع غير متاح / ملغى)',
    state: Screen14PaymentState.stateChanged,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  unauthorized401(
    id: '15',
    label: '15. انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة)',
    state: Screen14PaymentState.unauthorized,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  forbidden403(
    id: '16',
    label: '16. غير مصرح بالوصول 403 (حساب مستأجر مختلف)',
    state: Screen14PaymentState.forbidden,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  notFound404(
    id: '17',
    label: '17. الحجز غير موجود 404 (معرف غير صالح)',
    state: Screen14PaymentState.notFound,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  initialLoading(
    id: '18',
    label: '18. جارٍ التحقق الأولي (هيكل تحميل دون تسريب بيانات)',
    state: Screen14PaymentState.initialLoading,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  firstLoadError(
    id: '19',
    label: '19. خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون)',
    state: Screen14PaymentState.error,
    fixtureIndex: 0,
    textScale: 1.0,
  ),
  accessibility200Top(
    id: '20',
    label: '20. إمكانية الوصول 200% — الطي الأول (نفس الحجز 2,700 ج.م)',
    state: Screen14PaymentState.ready,
    fixtureIndex: 0,
    textScale: 2.0,
  ),
  accessibility200Scrolled(
    id: '21',
    label: '21. إمكانية الوصول 200% — بعد التمرير والزر (نفس الحجز)',
    state: Screen14PaymentState.ready,
    fixtureIndex: 0,
    textScale: 2.0,
    autoScrollToEnd: true,
  );

  const Screen14Scenario({
    required this.id,
    required this.label,
    required this.state,
    required this.fixtureIndex,
    required this.textScale,
    this.autoScrollToEnd = false,
  });

  final String id;
  final String label;
  final Screen14PaymentState state;
  final int fixtureIndex;
  final double textScale;
  final bool autoScrollToEnd;
}

// =============================================================================
// Civil Arabic Date Formatting (Western Digits 0–9 & Arabic Calendar Names)
// =============================================================================

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

// =============================================================================
// Synthetic Booking Model & Validated Fixtures Matching Screen 13 V2
// =============================================================================

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

  String get formattedCheckIn =>
      CivilArabicDateFormatter.formatCivilDate(checkIn);
  String get formattedCheckOut =>
      CivilArabicDateFormatter.formatCivilDate(checkOut);
  String get formattedDates =>
      CivilArabicDateFormatter.formatRange(checkIn, checkOut);

  CustomerBookingRecord copyWith({
    String? id,
    String? bookingNumber,
    String? propertyId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? nights,
    int? guestsCount,
    int? nightlyPrice,
    int? totalStay,
    int? depositAmount,
    int? remainingAmount,
    String? currency,
    BookingPropertyRecord? property,
    String? status,
  }) {
    return CustomerBookingRecord(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      propertyId: propertyId ?? this.propertyId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      nights: nights ?? this.nights,
      guestsCount: guestsCount ?? this.guestsCount,
      nightlyPrice: nightlyPrice ?? this.nightlyPrice,
      totalStay: totalStay ?? this.totalStay,
      depositAmount: depositAmount ?? this.depositAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      currency: currency ?? this.currency,
      property: property ?? this.property,
      status: status ?? this.status,
    );
  }
}

class Screen14SampleFixtures {
  static List<CustomerBookingRecord> getAllFixtures() {
    return [
      // Fixture 0: Canonical Marassi Beachfront Villa (Continuation of Screen 13 V2 approved fixture)
      // 5 nights x 2,700 = 13,500 EGP; First-night deposit 2,700 EGP; Remainder 10,800 EGP; 4 guests.
      CustomerBookingRecord(
        id: 'BK-001',
        bookingNumber: 'BK-829104',
        propertyId: 'PROP-01',
        checkIn: DateTime(2026, 10, 20), // الثلاثاء، 20 أكتوبر 2026
        checkOut: DateTime(2026, 10, 25), // الأحد، 25 أكتوبر 2026
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
      ),
      // Fixture 1: Separate Long-Title Luxury Chalet for stress-testing text overflow
      // 4 nights x 3,500 = 14,000 EGP; First-night deposit 3,500 EGP; Remainder 10,500 EGP; 6 guests.
      CustomerBookingRecord(
        id: 'BK-002',
        bookingNumber: 'BK-941820',
        propertyId: 'PROP-02',
        checkIn: DateTime(2026, 11, 12), // الخميس، 12 نوفمبر 2026
        checkOut: DateTime(2026, 11, 16), // الإثنين، 16 نوفمبر 2026
        nights: 4,
        guestsCount: 6,
        nightlyPrice: 3500,
        totalStay: 14000,
        depositAmount: 3500,
        remainingAmount: 10500,
        currency: 'ج.م',
        status: 'APPROVED_PENDING_PAYMENT',
        property: const BookingPropertyRecord(
          id: 'PROP-02',
          title: 'فيلا رويال الفاخرة بإطلالة مباشرة على بحيرات مارينا الكريستالية والشاطئ الخاص',
          locationName: 'مارينا 5 • الساحل الشمالي',
          unitType: 'فيلا مستقلة فاخرة',
        ),
      ),
    ];
  }

  static void assertFixtureIntegrity(List<CustomerBookingRecord> fixtures) {
    for (final b in fixtures) {
      assert(b.nights >= 2 && b.nights <= 30, 'Stay length must be 2..30 nights');
      assert(b.checkOut.difference(b.checkIn).inDays == b.nights,
          'Nights count must equal civil date difference');
      assert(b.totalStay == b.nights * b.nightlyPrice,
          'Total stay must equal nights * nightlyPrice');
      assert(b.depositAmount == b.nightlyPrice,
          'Deposit amount must equal first-night price');
      assert(b.remainingAmount == b.totalStay - b.depositAmount,
          'Remaining amount must equal total - deposit');
    }
  }
}

// =============================================================================
// Standalone Testable State Controller (Preserves All V2 Safety Invariants)
// =============================================================================

class Screen14StateController {
  Screen14StateController({
    required this.state,
    this.booking,
    this.authEpoch = 1,
    this.pendingAuthoritativeDeposit,
  });

  Screen14PaymentState state;
  CustomerBookingRecord? booking;
  int authEpoch;
  int initiationAttempts = 0;
  int? pendingAuthoritativeDeposit;

  bool initiatePayment() {
    // Strictly prevent initiation from amountChanged, revalidatingAmount, amountRevalidated, or any non-ready state
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
    String? bookingId,
    String? transactionId,
  }) {
    if (callerEpoch != authEpoch) {
      // Stale callback dropped!
      return false;
    }
    if (state != Screen14PaymentState.checkingStatus || booking == null) {
      return false;
    }
    // Booking identity check
    if (bookingId != null && bookingId != booking!.id) {
      return false;
    }
    // Transaction identity check
    if (transactionId != null && transactionId.isEmpty) {
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

  // --- P0 AMOUNT_CHANGED Safeguard Workflow ---

  bool startAmountRevalidation() {
    if (state != Screen14PaymentState.amountChanged || booking == null) {
      return false;
    }
    state = Screen14PaymentState.revalidatingAmount;
    return true;
  }

  bool completeAuthoritativeAmountValidation({
    required String bookingId,
    required int newNightlyPrice,
    required int newDepositAmount,
    required int newTotalStay,
    required int newRemainingAmount,
  }) {
    if (state != Screen14PaymentState.revalidatingAmount || booking == null) {
      return false;
    }
    if (bookingId != booking!.id) {
      return false;
    }
    assert(newDepositAmount == newNightlyPrice, 'MR-13: Deposit must equal first night');
    assert(newTotalStay == booking!.nights * newNightlyPrice, 'Total must equal nights * nightly');
    assert(newRemainingAmount == newTotalStay - newDepositAmount, 'Remainder must equal total - deposit');

    booking = booking!.copyWith(
      nightlyPrice: newNightlyPrice,
      depositAmount: newDepositAmount,
      totalStay: newTotalStay,
      remainingAmount: newRemainingAmount,
    );
    pendingAuthoritativeDeposit = newDepositAmount;
    state = Screen14PaymentState.amountRevalidated;
    return true;
  }

  bool consentToRevalidatedAmount() {
    if (state != Screen14PaymentState.amountRevalidated || booking == null) {
      return false;
    }
    state = Screen14PaymentState.ready;
    return true;
  }

  void trigger401SessionPurge() {
    state = Screen14PaymentState.unauthorized;
    booking = null; // Memory wipe!
    authEpoch++; // Invalidate any in-flight callbacks
  }

  bool handleDelayedCallback({
    required int callbackEpoch,
    required void Function() onValid,
  }) {
    if (callbackEpoch != authEpoch) {
      return false;
    }
    onValid();
    return true;
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
}

// =============================================================================
// Preview App Shell
// =============================================================================

class Screen14PreviewApp extends StatelessWidget {
  const Screen14PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KONFRM — Screen 14 V3 (دفع العربون)',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: KonfrmTypography.fontFamily,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF000000), // Solid True Black #000000
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF111827),
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Canonical Arabic RTL
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const Screen14HarnessPage(),
    );
  }
}

// =============================================================================
// Harness Page with Customer Mode Default & Detached Dev Overlay
// =============================================================================

class Screen14HarnessPage extends StatefulWidget {
  const Screen14HarnessPage({super.key});

  @override
  State<Screen14HarnessPage> createState() => _Screen14HarnessPageState();
}

class _Screen14HarnessPageState extends State<Screen14HarnessPage> {
  final FocusNode _focusNode = FocusNode();
  Screen14Scenario _currentScenario = Screen14Scenario.readyTopFold;
  late final List<CustomerBookingRecord> _fixtures;
  late Screen14StateController _controller;
  bool _isDevOverlayOpen = false;

  @override
  void initState() {
    super.initState();
    _fixtures = Screen14SampleFixtures.getAllFixtures();
    _initControllerForScenario(_currentScenario);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _initControllerForScenario(Screen14Scenario scenario) {
    final booking = (scenario.state == Screen14PaymentState.unauthorized ||
            scenario.state == Screen14PaymentState.forbidden ||
            scenario.state == Screen14PaymentState.notFound ||
            scenario.state == Screen14PaymentState.initialLoading ||
            scenario.state == Screen14PaymentState.error)
        ? null
        : _fixtures[scenario.fixtureIndex];

    if (scenario == Screen14Scenario.amountRevalidatedConsent) {
      _controller = Screen14StateController(
        state: Screen14PaymentState.revalidatingAmount,
        booking: booking,
      );
      _controller.completeAuthoritativeAmountValidation(
        bookingId: booking?.id ?? 'BK-001',
        newNightlyPrice: 3000,
        newDepositAmount: 3000,
        newTotalStay: 15000,
        newRemainingAmount: 12000,
      );
    } else {
      _controller = Screen14StateController(
        state: scenario.state,
        booking: booking,
      );
    }
  }

  void _setScenario(Screen14Scenario sc) {
    setState(() {
      _currentScenario = sc;
      _initControllerForScenario(sc);
    });
  }

  void _handleInitiatePayment() {
    setState(() {
      _controller.initiatePayment();
    });
  }

  void _handleRequestRevalidation() {
    setState(() {
      _controller.startAmountRevalidation();
    });
    _showFeedback('محاكاة: جارٍ الاستعلام عن السعر المعتمد لدى الخادم...');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _controller.state == Screen14PaymentState.revalidatingAmount) {
        setState(() {
          _controller.completeAuthoritativeAmountValidation(
            bookingId: _controller.booking?.id ?? 'BK-001',
            newNightlyPrice: 3000,
            newDepositAmount: 3000,
            newTotalStay: 15000,
            newRemainingAmount: 12000,
          );
        });
        _showFeedback('تم اعتماد التسعير المحدث (3,000 ج.م). يلزم تأكيد موافقتك للمتابعة.');
      }
    });
  }

  void _handleConsentRevalidatedAmount() {
    setState(() {
      _controller.consentToRevalidatedAmount();
    });
    _showFeedback('تم تأكيد الموافقة على السعر المعتمد. الحجز جاهز لسداد العربون.');
  }

  void _handleCheckStatus() {
    setState(() {
      _controller.checkStatus();
    });
  }

  void _handleMockResponse(MockAuthoritativeResponse resp) {
    setState(() {
      _controller.handleMockResponse(
        response: resp,
        callerEpoch: _controller.authEpoch,
      );
    });
  }

  void _trigger401Purge() {
    setState(() {
      _controller.trigger401SessionPurge();
    });
  }

  // Keyboard shortcut listener for ADB injection
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.digit1) {
        _setScenario(Screen14Scenario.readyTopFold);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        _setScenario(Screen14Scenario.readyScrolledSameBooking);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        _setScenario(Screen14Scenario.readyLongTitleFixture);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        _setScenario(Screen14Scenario.initiatingState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        _setScenario(Screen14Scenario.paymentPending);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        _setScenario(Screen14Scenario.checkingStatus);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        _setScenario(Screen14Scenario.networkReconciliationRequired);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        _setScenario(Screen14Scenario.failedAttempt);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        _setScenario(Screen14Scenario.transactionExpired);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyA) {
        _setScenario(Screen14Scenario.amountChangedConflict);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyR) {
        _setScenario(Screen14Scenario.revalidatingAmountState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyS) {
        _setScenario(Screen14Scenario.amountRevalidatedConsent);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyB) {
        _setScenario(Screen14Scenario.providerUnavailable);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyC) {
        _setScenario(Screen14Scenario.mockConfirmedSuccess);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyD) {
        _setScenario(Screen14Scenario.alreadyConfirmed);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyE) {
        _setScenario(Screen14Scenario.stateChangedIneligible);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyF) {
        _setScenario(Screen14Scenario.unauthorized401);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyG) {
        _setScenario(Screen14Scenario.forbidden403);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyH) {
        _setScenario(Screen14Scenario.notFound404);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyI) {
        _setScenario(Screen14Scenario.initialLoading);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyJ) {
        _setScenario(Screen14Scenario.firstLoadError);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyK) {
        _setScenario(Screen14Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyL) {
        _setScenario(Screen14Scenario.accessibility200Scrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyQ) {
        // Toggle detached Dev overlay
        setState(() {
          _isDevOverlayOpen = !_isDevOverlayOpen;
        });
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyM) {
        // Inject mock CONFIRMED response
        _handleMockResponse(MockAuthoritativeResponse.confirmed);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyP) {
        // Inject mock STILL PENDING response
        _handleMockResponse(MockAuthoritativeResponse.stillPending);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyO) {
        // Inject mock FAILED response
        _handleMockResponse(MockAuthoritativeResponse.failed);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyT) {
        // Inject mock TIMEOUT response
        _handleMockResponse(MockAuthoritativeResponse.unknownTimeout);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyU) {
        // Inject mock UNAUTHORIZED 401 response
        _trigger401Purge();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _showFeedback(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontFamily: KonfrmTypography.fontFamily),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: const Color(0xFF111827),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_currentScenario.textScale),
        ),
        child: Stack(
          children: [
            // 1. Pure Customer View (Customer Presentation Mode)
            _buildCurrentCustomerView(),

            // 2. Detached Dev-Only Audit Overlay (Visible only when explicitly opened)
            if (_isDevOverlayOpen) _buildDevAuditOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCustomerView() {
    final state = _controller.state;
    final booking = _controller.booking;

    switch (state) {
      case Screen14PaymentState.unauthorized:
        return Screen14UnauthorizedView(
          onReauth: () => _showFeedback('إعادة التوجيه إلى تسجيل الدخول'),
          onBack: () => _showFeedback('العودة إلى شاشة تسجيل الدخول'),
        );
      case Screen14PaymentState.forbidden:
        return Screen14ForbiddenView(
          onBack: () => _showFeedback('العودة إلى قائمة حجوزاتي (Screen 12)'),
        );
      case Screen14PaymentState.notFound:
        return Screen14NotFoundView(
          onBack: () => _showFeedback('العودة إلى قائمة حجوزاتي (Screen 12)'),
        );
      case Screen14PaymentState.initialLoading:
        return Screen14InitialLoadingView(
          onBack: () => _showFeedback('العودة إلى تفاصيل الحجز'),
        );
      case Screen14PaymentState.error:
        return Screen14FirstLoadErrorView(
          onRetry: () => _setScenario(Screen14Scenario.readyTopFold),
          onBack: () => _showFeedback('العودة إلى تفاصيل الحجز'),
        );
      case Screen14PaymentState.alreadyConfirmed:
        return Screen14AlreadyConfirmedView(
          onBack: () => _showFeedback('العودة إلى تفاصيل الحجز المؤكد'),
        );
      case Screen14PaymentState.stateChanged:
        return Screen14StateChangedView(
          onBack: () => _showFeedback('العودة إلى تفاصيل الحجز'),
        );
      case Screen14PaymentState.success:
        return Screen14SuccessView(
          booking: booking ?? _fixtures[0],
          onDone: () => _showFeedback('الانتقال إلى تفاصيل الحجز المؤكد (Screen 13)'),
          onBack: () => _showFeedback('الانتقال إلى تفاصيل الحجز المؤكد (Screen 13)'),
        );
      default:
        // Main payment flow: ready, initiating, checkingStatus, paymentPending,
        // networkReconciliationRequired, failed, transactionExpired,
        // amountChanged, providerUnavailable
        return Screen14MainPaymentView(
          booking: booking ?? _fixtures[0],
          state: state,
          autoScrollToEnd: _currentScenario.autoScrollToEnd,
          onInitiatePayment: _handleInitiatePayment,
          onCheckStatus: _handleCheckStatus,
          onFreshAttempt: () => setState(() => _controller.requestFreshAttempt()),
          onRequestRevalidation: _handleRequestRevalidation,
          onConsentRevalidatedAmount: _handleConsentRevalidatedAmount,
          onBack: () => _showFeedback('محاكاة الرجوع: العودة إلى تفاصيل الحجز (Screen 13)'),
          onOpenDevOverlay: () => setState(() => _isDevOverlayOpen = true),
        );
    }
  }

  Widget _buildDevAuditOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.developer_mode, size: 20, color: Color(0xFF111827)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'لوحة التحكم والاختبار المعزولة (Dev Audit)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _isDevOverlayOpen = false),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    const Text(
                      'اختر السيناريو (أو استخدم أزرار لوحة المفاتيح 1-9 و A-L عبر ADB):',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Screen14Scenario>(
                          value: _currentScenario,
                          isExpanded: true,
                          items: Screen14Scenario.values.map((sc) {
                            return DropdownMenuItem<Screen14Scenario>(
                              value: sc,
                              child: Text(
                                sc.label,
                                style: const TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (sc) {
                            if (sc != null) {
                              _setScenario(sc);
                              setState(() => _isDevOverlayOpen = false);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'حقن نتيجة استعلام الخادم المستقلة (أثناء checkingStatus):',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildDevChip(
                          label: 'طلب تحقق السعر (REVALIDATE)',
                          onTap: () {
                            _handleRequestRevalidation();
                            setState(() => _isDevOverlayOpen = false);
                          },
                        ),
                        _buildDevChip(
                          label: 'موافقة السعر المعتمد (CONSENT)',
                          onTap: () {
                            _handleConsentRevalidatedAmount();
                            setState(() => _isDevOverlayOpen = false);
                          },
                        ),
                        _buildDevChip(
                          label: 'تأكيد الحجز (CONFIRMED)',
                          onTap: () {
                            _handleMockResponse(MockAuthoritativeResponse.confirmed);
                            setState(() => _isDevOverlayOpen = false);
                          },
                          isPrimary: true,
                        ),
                        _buildDevChip(
                          label: 'ما زالت قيد المعالجة (PENDING)',
                          onTap: () {
                            _handleMockResponse(MockAuthoritativeResponse.stillPending);
                            setState(() => _isDevOverlayOpen = false);
                          },
                        ),
                        _buildDevChip(
                          label: 'فشل العملية (FAILED)',
                          onTap: () {
                            _handleMockResponse(MockAuthoritativeResponse.failed);
                            setState(() => _isDevOverlayOpen = false);
                          },
                        ),
                        _buildDevChip(
                          label: 'انقطاع الاتصال (TIMEOUT)',
                          onTap: () {
                            _handleMockResponse(MockAuthoritativeResponse.unknownTimeout);
                            setState(() => _isDevOverlayOpen = false);
                          },
                        ),
                        _buildDevChip(
                          label: 'انتهاء الجلسة (401 Purge)',
                          onTap: () {
                            _trigger401Purge();
                            setState(() => _isDevOverlayOpen = false);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => setState(() => _isDevOverlayOpen = false),
                        child: const Text('إغلاق لوحة الاختبار والعودة لواجهة العميل'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDevChip({
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF000000) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isPrimary ? const Color(0xFF000000) : const Color(0xFFD1D5DB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Main Customer Payment View (Clean Customer-First Hierarchy & Solid Black CTA)
// =============================================================================

class Screen14MainPaymentView extends StatefulWidget {
  const Screen14MainPaymentView({
    super.key,
    required this.booking,
    required this.state,
    required this.autoScrollToEnd,
    required this.onInitiatePayment,
    required this.onCheckStatus,
    required this.onFreshAttempt,
    required this.onRequestRevalidation,
    required this.onConsentRevalidatedAmount,
    required this.onBack,
    required this.onOpenDevOverlay,
  });

  final CustomerBookingRecord booking;
  final Screen14PaymentState state;
  final bool autoScrollToEnd;
  final VoidCallback onInitiatePayment;
  final VoidCallback onCheckStatus;
  final VoidCallback onFreshAttempt;
  final VoidCallback onRequestRevalidation;
  final VoidCallback onConsentRevalidatedAmount;
  final VoidCallback onBack;
  final VoidCallback onOpenDevOverlay;

  @override
  State<Screen14MainPaymentView> createState() => _Screen14MainPaymentViewState();
}

class _Screen14MainPaymentViewState extends State<Screen14MainPaymentView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.autoScrollToEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void didUpdateWidget(Screen14MainPaymentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoScrollToEnd && !oldWidget.autoScrollToEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regExp, (match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    final isA11yScale = MediaQuery.textScalerOf(context).scale(1.0) > 1.3;

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Clean Native White AppBar immediately under status bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // RTL Back button: In RTL layout, Icons.arrow_back mirrors to point RIGHT (→)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: widget.onBack,
          tooltip: 'الرجوع',
        ),
        title: GestureDetector(
          onLongPress: widget.onOpenDevOverlay, // Hidden shortcut to Dev Audit
          child: const Text(
            'دفع العربون',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2. Calm Context Status Notice
            _buildStatusNoticeCard(context),
            const SizedBox(height: 12),

            // 3. Concise Property Recognition Row
            _buildPropertySummaryRow(context),
            const SizedBox(height: 12),

            // 4. White First-Night Deposit Amount Panel
            _buildDepositAmountPanel(context),
            const SizedBox(height: 14),

            // 5. Solid True Black #000000 Primary CTA (Visible on first fold!)
            _buildPrimaryActionCta(context),
            const SizedBox(height: 16),

            // 6. Integrated Stay Details & Financial Breakdown (Editorial Layout matching Screen 13 V2)
            _buildStayAndFinancialDetailsCard(context, isA11yScale),
            const SizedBox(height: 12),

            // 7. Informational Trust Note
            _buildInformationalTrustNote(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Calm Context Status Notice
  // ---------------------------------------------------------------------------

  Widget _buildStatusNoticeCard(BuildContext context) {
    switch (widget.state) {
      case Screen14PaymentState.ready:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF374151)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'وافق المالك على طلبك. يتطلب تأكيد الحجز سداد العربون.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.initiating:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF374151)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'جارٍ تهيئة جلسة الدفع الآمنة... يُرجى الانتظار.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.paymentPending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              Icon(Icons.hourglass_top, size: 16, color: Color(0xFF374151)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'العملية قيد المعالجة لدى مزود الدفع. يُرجى التحقق من الحالة.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.checkingStatus:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF374151)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'جارٍ الاستعلام عن حالة العملية لدى مزود الدفع... لن يتم بدء أي معاملة جديدة.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.networkReconciliationRequired:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Row(
            children: [
              Icon(Icons.wifi_off, size: 16, color: Color(0xFF92400E)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'حدث انقطاع في الاتصال أثناء معالجة العملية. يُرجى التحقق من حالة السداد لدى الخادم قبل أي محاولة جديدة.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.failed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFCA5A5)),
          ),
          child: const Row(
            children: [
              Icon(Icons.error_outline, size: 16, color: Color(0xFF991B1B)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تعذّر إكمال محاولة الدفع. يُرجى مراجعة حالة العملية والتحقق قبل أي محاولة جديدة.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.transactionExpired:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              Icon(Icons.timer_off_outlined, size: 16, color: Color(0xFF4B5563)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'انتهت صلاحية جلسة محاولة الدفع الحالية. يمكنك طلب محاولة جديدة طالما كان الحجز متاحًا للسداد.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.amountChanged:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.price_change_outlined, size: 16, color: Color(0xFF92400E)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تغيّر مبلغ الإقامة لدى الخادم قبل بدء الدفع.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'تم رصد اختلاف بين السعر المبدئي والتسعير المعتمد حاليًا. يلزم إجراء إعادة تحقق موثقة وموافقتك الصريحة قبل السماح بالسداد.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF78350F),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'العربون السابق: 2,700 ج.م',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      'السعر الجديد يتطلب تحقق الخادم',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.revalidatingAmount:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'جارٍ الاستعلام عن التسعير المعتمد وتحديث بيانات الحجز من الخادم... الدفع معطّل لحين اكتمال التحقق.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.amountRevalidated:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF166534)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تم اعتماد التسعير المحدث وتطابق بيانات الحجز بنجاح.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'مبلغ العربون المعتمد لليلة الأولى أصبح ${_formatAmount(widget.booking.depositAmount)} ج.م (الإجمالي: ${_formatAmount(widget.booking.totalStay)} ج.م). يلزم تأكيد موافقتك للمتابعة.',
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF14532D),
                ),
              ),
            ],
          ),
        );
      case Screen14PaymentState.providerUnavailable:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              Icon(Icons.cloud_off, size: 16, color: Color(0xFF4B5563)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'خدمة سداد العربون غير متاحة حاليًا لهذه المحاولة. يمكنك العودة لتفاصيل الحجز والتحقق لاحقًا.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Concise Property Recognition Row
  // ---------------------------------------------------------------------------

  Widget _buildPropertySummaryRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.property.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.booking.property.locationName,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.booking.bookingNumber,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. White First-Night Deposit Amount Panel (No Dark Charcoal Slab!)
  // ---------------------------------------------------------------------------

  Widget _buildDepositAmountPanel(BuildContext context) {
    final depositStr = _formatAmount(widget.booking.depositAmount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white, // Clean White Panel!
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مبلغ العربون المطلوب لتأكيد الحجز',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                depositStr,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'ج.م',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'قيمة الليلة الأولى من إجمالي الإقامة • يُخصم من الإجمالي النهائي',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Solid True Black #000000 Primary CTA
  // ---------------------------------------------------------------------------

  Widget _buildPrimaryActionCta(BuildContext context) {
    // A. Pending or Reconciliation: Check Status Button
    if (widget.state == Screen14PaymentState.paymentPending ||
        widget.state == Screen14PaymentState.networkReconciliationRequired) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: widget.onCheckStatus,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text(
            'التحقق من حالة الدفع',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000), // Solid True Black #000000
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Primary 6px radius
            ),
          ),
        ),
      );
    }

    // B. Checking Status: Busy Read-Only Spinner (Disabled, Zero Mock Chips in Customer View!)
    if (widget.state == Screen14PaymentState.checkingStatus) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE5E7EB),
            disabledBackgroundColor: const Color(0xFFE5E7EB),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6B7280)),
              ),
              SizedBox(width: 10),
              Text(
                'جارٍ الاستعلام عن حالة العملية...',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // C. Initiating: Busy Spinner (Disabled)
    if (widget.state == Screen14PaymentState.initiating) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE5E7EB),
            disabledBackgroundColor: const Color(0xFFE5E7EB),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6B7280)),
              ),
              SizedBox(width: 10),
              Text(
                'جارٍ تجهيز الدفع...',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // D. Failed or Transaction Expired: Fresh Attempt CTA
    if (widget.state == Screen14PaymentState.failed ||
        widget.state == Screen14PaymentState.transactionExpired) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: widget.onFreshAttempt,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000), // Solid True Black #000000
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'بدء محاولة دفع جديدة',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // E1. Amount Changed: Request Authoritative Revalidation CTA
    if (widget.state == Screen14PaymentState.amountChanged) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: widget.onRequestRevalidation,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000), // Solid True Black #000000
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'طلب التحقق من السعر الجديد وتحديث الحجز',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.refresh, size: 18),
            ],
          ),
        ),
      );
    }

    // E2. Revalidating Amount: In-Flight Busy State (Payment Strictly Disabled!)
    if (widget.state == Screen14PaymentState.revalidatingAmount) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE5E7EB),
            disabledBackgroundColor: const Color(0xFFE5E7EB),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6B7280)),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  'جارٍ التحقق من السعر الجديد لدى الخادم...',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // E3. Amount Revalidated: Explicit Customer Consent Required before Ready
    if (widget.state == Screen14PaymentState.amountRevalidated) {
      final depositStr = _formatAmount(widget.booking.depositAmount);
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: widget.onConsentRevalidatedAmount,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000), // Solid True Black #000000
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'الموافقة على العربون ($depositStr ج.م) والمتابعة',
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      );
    }

    // F. Provider Unavailable: Return to Booking CTA
    if (widget.state == Screen14PaymentState.providerUnavailable) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: widget.onBack,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF111827),
            side: const BorderSide(color: Color(0xFF111827)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'العودة إلى تفاصيل الحجز',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // G. READY State (Standard Main Solid True Black #000000 CTA)
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: widget.onInitiatePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF000000), // Solid True Black #000000
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Primary 6px radius
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'دفع العربون',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            // Forward progression in RTL: Icons.arrow_forward mirrors to point LEFT (←)
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Integrated Stay Details & Financial Breakdown (Editorial Layout)
  // ---------------------------------------------------------------------------

  Widget _buildStayAndFinancialDetailsCard(
      BuildContext context, bool isA11yScale) {
    final totalStr = _formatAmount(widget.booking.totalStay);
    final depositStr = _formatAmount(widget.booking.depositAmount);
    final remainingStr = _formatAmount(widget.booking.remainingAmount);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل الإقامة',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),

          // Date Blocks (Clean soft fill matching Screen 13 V2)
          if (!isA11yScale)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 12, color: Color(0xFF6B7280)),
                            SizedBox(width: 4),
                            Text(
                              'الوصول',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.booking.formattedCheckIn,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 12, color: Color(0xFF6B7280)),
                            SizedBox(width: 4),
                            Text(
                              'المغادرة',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.booking.formattedCheckOut,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14, color: Color(0xFF6B7280)),
                      SizedBox(width: 6),
                      Text(
                        'الوصول',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.booking.formattedCheckIn,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14, color: Color(0xFF6B7280)),
                      SizedBox(width: 6),
                      Text(
                        'المغادرة',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.booking.formattedCheckOut,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),
          _buildDetailRow(
            icon: Icons.night_shelter_outlined,
            label: 'المدة',
            value: '${widget.booking.nights} ليالٍ',
            isA11y: isA11yScale,
          ),
          const Divider(height: 14, thickness: 1, color: Color(0xFFF3F4F6)),
          _buildDetailRow(
            icon: Icons.people_outline,
            label: 'النزلاء',
            value: '${widget.booking.guestsCount} ضيوف',
            isA11y: isA11yScale,
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 14),
          const Text(
            'البيانات المالية',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          _buildFinanceRow(
            label: 'إجمالي الإقامة (${widget.booking.nights} ليالٍ)',
            amount: totalStr,
            isBold: false,
            isA11y: isA11yScale,
          ),
          const SizedBox(height: 8),
          _buildFinanceRow(
            label: 'العربون المطلوب (الليلة الأولى)',
            amount: depositStr,
            isBold: true,
            textColor: const Color(0xFF111827),
            isA11y: isA11yScale,
          ),
          const SizedBox(height: 8),
          _buildFinanceRow(
            label: 'المتبقي بعد العربون',
            amount: remainingStr,
            isBold: false,
            supporting: 'يُسدد لاحقاً وفق سياسة الوحدة',
            isA11y: isA11yScale,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isA11y = false,
  }) {
    if (isA11y) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12.5,
            color: Color(0xFF6B7280),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceRow({
    required String label,
    required String amount,
    required bool isBold,
    Color? textColor,
    String? supporting,
    bool isA11y = false,
  }) {
    if (isA11y) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: textColor ?? const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: isBold ? 15 : 13.5,
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                  color: textColor ?? const Color(0xFF111827),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'ج.م',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                  color: textColor ?? const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          if (supporting != null) ...[
            const SizedBox(height: 2),
            Text(
              supporting,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                  color: textColor ?? const Color(0xFF374151),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: isBold ? 14.5 : 13,
                    fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                    color: textColor ?? const Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'ج.م',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11.5,
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                    color: textColor ?? const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (supporting != null) ...[
          const SizedBox(height: 2),
          Text(
            supporting,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Informational Trust Note
  // ---------------------------------------------------------------------------

  Widget _buildInformationalTrustNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 15, color: Color(0xFF6B7280)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'العربون يمثل قيمة الليلة الأولى ويُحسم من إجمالي الإقامة • تأكيد الحجز مشروط باعتماد سداد العربون بنجاح',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Component: Mock Confirmed Success View (Scenario 12)
// =============================================================================

class Screen14SuccessView extends StatelessWidget {
  const Screen14SuccessView({
    super.key,
    required this.booking,
    required this.onDone,
    required this.onBack,
  });

  final CustomerBookingRecord booking;
  final VoidCallback onDone;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'تأكيد الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF166534),
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'تم تأكيد حجزك بنجاح!',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'تم استلام سداد العربون وتأكيد الحجز نهائيًا.\nنتمنى لك إقامة ممتعة ومريحة!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'رقم الحجز',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12.5,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          booking.bookingNumber,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'العربون المسدد',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12.5,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          '${booking.depositAmount} ج.م',
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'عرض تفاصيل الحجز المؤكد',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Component: Already Confirmed View (Scenario 13)
// =============================================================================

class Screen14AlreadyConfirmedView extends StatelessWidget {
  const Screen14AlreadyConfirmedView({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.done_all, color: Color(0xFF111827), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'هذا الحجز مؤكد مسبقًا',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'تم سداد العربون وتأكيد هذا الحجز بالفعل. لا يلزم سداد أي مبالغ إضافية الآن.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'عرض تفاصيل الحجز المؤكد',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Component: State Changed / Ineligible View (Scenario 14)
// =============================================================================

class Screen14StateChangedView extends StatelessWidget {
  const Screen14StateChangedView({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline, color: Color(0xFF4B5563), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'تغيرت حالة هذا الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'لم يعد هذا الحجز متاحًا لسداد العربون (قد تم إلغاؤه أو تغييره). يُرجى الرجوع لتفاصيل الحجز.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى تفاصيل الحجز',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Component: Unauthorized 401 Session Purged View (Scenario 15)
// =============================================================================

class Screen14UnauthorizedView extends StatelessWidget {
  const Screen14UnauthorizedView({
    super.key,
    required this.onReauth,
    required this.onBack,
  });

  final VoidCallback onReauth;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_clock_outlined, color: Color(0xFF111827), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'انتهت جلسة تسجيل الدخول',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'تم إنهاء الجلسة لحماية بياناتك. يُرجى تسجيل الدخول مجددًا لمتابعة سداد العربون.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onReauth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول مجددًا',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Component: Forbidden 403 View (Scenario 16)
// =============================================================================

class Screen14ForbiddenView extends StatelessWidget {
  const Screen14ForbiddenView({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.block, color: Color(0xFF4B5563), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'غير مصرح بالوصول إلى هذا الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'هذا الحجز مرتبط بحساب مستأجر آخر. لا يمكن استعراض تفاصيل الدفع من هذا الحساب.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى قائمة حجوزاتي',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Component: Not Found 404 View (Scenario 17)
// =============================================================================

class Screen14NotFoundView extends StatelessWidget {
  const Screen14NotFoundView({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off, color: Color(0xFF4B5563), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'الحجز غير موجود',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'تعذّر العثور على الحجز المطلوب. يُرجى مراجعة قائمة حجوزاتك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى قائمة حجوزاتي',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Component: Initial Loading Skeleton View (Scenario 18)
// =============================================================================

class Screen14InitialLoadingView extends StatelessWidget {
  const Screen14InitialLoadingView({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF9CA3AF)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Component: First Load Error View (Scenario 19)
// =============================================================================

class Screen14FirstLoadErrorView extends StatelessWidget {
  const Screen14FirstLoadErrorView({
    super.key,
    required this.onRetry,
    required this.onBack,
  });

  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع',
        ),
        title: const Text(
          'دفع العربون',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off, color: Color(0xFF4B5563), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'تعذّر تحميل بيانات الدفع',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'حدث خطأ أثناء استرجاع تفاصيل الحجز من الخادم. يمكنك المحاولة مجددًا.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Solid True Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
