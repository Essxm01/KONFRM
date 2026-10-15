import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final fixtures = Screen14SampleFixtures.getAllFixtures();
  Screen14SampleFixtures.assertFixtureIntegrity(fixtures);
  runApp(const Screen14PreviewApp());
}

// -----------------------------------------------------------------------------
// Canonical Booking & Payment Domain Types for Screen 14 V2
// -----------------------------------------------------------------------------

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
}

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
    label: '06. جارٍ التحقق من الخادم (دون نجاح تلقائي + محاكي الرد)',
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

Screen14AllowedAction getAllowedScreen14Action(
  Screen14PaymentState state,
  CustomerBookingRecord? booking,
) {
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

bool canStartFreshScreen14Attempt(
  Screen14PaymentState state,
  CustomerBookingRecord? booking,
) {
  if (booking == null) return false;
  if (booking.status != 'APPROVED_PENDING_PAYMENT') return false;
  return state == Screen14PaymentState.failed || state == Screen14PaymentState.transactionExpired;
}

bool evaluateResumedAmountAuthority({
  required int expectedDeposit,
  required int authoritativeDeposit,
}) {
  return expectedDeposit == authoritativeDeposit;
}

// -----------------------------------------------------------------------------
// Synthetic Booking Model & Validated Fixtures for Screen 14 V2
// -----------------------------------------------------------------------------

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
    required this.checkInIso,
    required this.checkOutIso,
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
  final String checkInIso;
  final String checkOutIso;
  final int nights;
  final int guestsCount;
  final int nightlyPrice;
  final int totalStay;
  final int depositAmount;
  final int remainingAmount;
  final String currency;
  final BookingPropertyRecord property;
  final String status;
}

class Screen14SampleFixtures {
  static List<CustomerBookingRecord> getAllFixtures() {
    return const [
      // Fixture 0: Canonical Marassi Beachfront Villa (5 nights x 2,700 = 13,500; deposit 2,700; remaining 10,800)
      CustomerBookingRecord(
        id: 'bkg_marassi_001',
        bookingNumber: 'BK-892415',
        propertyId: 'prop_marassi_villa',
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
        property: BookingPropertyRecord(
          id: 'prop_marassi_villa',
          title: 'فيلا شاطئية بمراسي',
          locationName: 'الساحل الشمالي • سيدي عبد الرحمن',
          unitType: 'فيلا مستقلة',
        ),
      ),
      // Fixture 1: Separate Long-Title Luxury Chalet (4 nights x 3,500 = 14,000; deposit 3,500; remaining 10,500)
      CustomerBookingRecord(
        id: 'bkg_marassi_002',
        bookingNumber: 'BK-941820',
        propertyId: 'prop_lagoon_chalet',
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
        property: BookingPropertyRecord(
          id: 'prop_lagoon_chalet',
          title: 'شاليه بانورامي فاخر بإطلالة مباشرة على اللاجون والبحيرة الكريستالية',
          locationName: 'الساحل الشمالي • العلمين الجديدة',
          unitType: 'شاليه فاخر',
        ),
      ),
    ];
  }

  static void assertFixtureIntegrity(List<CustomerBookingRecord> fixtures) {
    for (final f in fixtures) {
      if (f.nights < 2 || f.nights > 30) {
        throw StateError('Fixture invariant violation: nights must be 2..30 (${f.nights})');
      }
      if (f.nights * f.nightlyPrice != f.totalStay) {
        throw StateError('Fixture math violation: totalStay != nights * nightlyPrice');
      }
      if (f.depositAmount != f.nightlyPrice) {
        throw StateError('Fixture deposit violation: deposit must equal first night amount');
      }
      if (f.totalStay - f.depositAmount != f.remainingAmount) {
        throw StateError('Fixture balance violation: remaining != totalStay - deposit');
      }
    }
  }
}

// -----------------------------------------------------------------------------
// Root Application
// -----------------------------------------------------------------------------

class Screen14PreviewApp extends StatelessWidget {
  const Screen14PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KONFRM Screen 14 V2 Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: KonfrmTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF111827),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF111827),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: Screen14HarnessPage(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Harness Page with Scenario Management & Keyboard Controls
// -----------------------------------------------------------------------------

class Screen14HarnessPage extends StatefulWidget {
  const Screen14HarnessPage({super.key});

  @override
  State<Screen14HarnessPage> createState() => _Screen14HarnessPageState();
}

class _Screen14HarnessPageState extends State<Screen14HarnessPage> {
  Screen14Scenario _currentScenario = Screen14Scenario.readyTopFold;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // Monotonic epoch token to guard async transitions against 401 invalidation
  int _epoch = 1;
  int _initiationAttempts = 0;

  // In-memory nullable booking data (purged on 401)
  CustomerBookingRecord? _activeBooking;

  @override
  void initState() {
    super.initState();
    _loadScenarioData(_currentScenario);
  }

  void _loadScenarioData(Screen14Scenario scenario) {
    final fixtures = Screen14SampleFixtures.getAllFixtures();
    if (scenario.state == Screen14PaymentState.unauthorized) {
      // 401 In-memory wipe
      _activeBooking = null;
    } else {
      _activeBooking = fixtures[scenario.fixtureIndex];
    }
    _epoch++;
  }

  void _setScenario(Screen14Scenario scenario) {
    setState(() {
      _currentScenario = scenario;
      _loadScenarioData(scenario);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (scenario.autoScrollToEnd && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else if (!scenario.autoScrollToEnd && _scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Action Handlers
  // ---------------------------------------------------------------------------

  // Handle Primary CTA Tap on READY
  void _handleInitiatePayment() {
    if (_currentScenario.state != Screen14PaymentState.ready) return;
    final dispatchEpoch = _epoch;
    setState(() {
      _initiationAttempts++;
      _currentScenario = Screen14Scenario.initiatingState;
    });

    // Controlled mock transition to PAYMENT_PENDING after 1.2s
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      // Stale callback guard: reject if epoch changed (e.g. 401 occurred)
      if (_epoch != dispatchEpoch) return;
      setState(() {
        _currentScenario = Screen14Scenario.paymentPending;
      });
    });
  }

  // Handle CTA Tap on PAYMENT_PENDING / NETWORK_RECONCILIATION_REQUIRED
  // P0 Correction: Strictly enters CHECKING_STATUS. NEVER confirmed/success!
  void _handleCheckStatus() {
    setState(() {
      _currentScenario = Screen14Scenario.checkingStatus;
    });
  }

  // Handle Explicit Mock Response Chooser (Only called from QA harness on checkingStatus)
  void _handleMockResponse(MockAuthoritativeResponse response) {
    if (_currentScenario.state != Screen14PaymentState.checkingStatus) return;
    switch (response) {
      case MockAuthoritativeResponse.confirmed:
        _setScenario(Screen14Scenario.mockConfirmedSuccess);
        break;
      case MockAuthoritativeResponse.stillPending:
        _setScenario(Screen14Scenario.paymentPending);
        break;
      case MockAuthoritativeResponse.failed:
        _setScenario(Screen14Scenario.failedAttempt);
        break;
      case MockAuthoritativeResponse.unknownTimeout:
        _setScenario(Screen14Scenario.networkReconciliationRequired);
        break;
      case MockAuthoritativeResponse.unauthorized:
        _setScenario(Screen14Scenario.unauthorized401);
        break;
    }
  }

  // Handle In-Memory 401 Simulation
  void _trigger401SessionPurge() {
    setState(() {
      _epoch++;
      _activeBooking = null; // Purge private booking state from memory
      _currentScenario = Screen14Scenario.unauthorized401;
    });
  }

  // ---------------------------------------------------------------------------
  // Keyboard Events for ADB Automation
  // ---------------------------------------------------------------------------

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      // Numerical Keypad & Row mappings
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
      }
    }
    return KeyEventResult.ignored;
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
        child: Scaffold(
          body: Column(
            children: [
              // 1. Isolated Preview Top Banner
              _buildIsolatedPreviewBanner(),

              // 2. Interactive QA Scenario Selector & Test Controls
              _buildScenarioControlBar(),

              // 3. Screen View Presentation
              Expanded(
                child: _buildCurrentScenarioView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIsolatedPreviewBanner() {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6),
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1.0),
          ),
        ),
        child: const Text(
          'هذه معاينة تجريبية معزولة؛ لا تُنفّذ أي مدفوعات حقيقية.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune, size: 16, color: Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Screen14Scenario>(
                value: _currentScenario,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF111827)),
                items: Screen14Scenario.values.map((sc) {
                  return DropdownMenuItem<Screen14Scenario>(
                    value: sc,
                    child: Text(
                      sc.label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (sc) {
                  if (sc != null) _setScenario(sc);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScenarioView() {
    // Check Standalone Ineligible / Terminal States
    switch (_currentScenario.state) {
      case Screen14PaymentState.success:
        return Screen14SuccessView(
          booking: _activeBooking!,
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.alreadyConfirmed:
        return Screen14AlreadyConfirmedView(
          booking: _activeBooking!,
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.stateChanged:
        return Screen14StateChangedView(
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.unauthorized:
        return Screen14FailClosedUnauthorizedView(
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.forbidden:
        return Screen14ForbiddenView(
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.notFound:
        return Screen14NotFoundView(
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.initialLoading:
        return Screen14InitialLoadingView(
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
      case Screen14PaymentState.error:
        return Screen14FirstLoadErrorView(
          onRetry: () => _setScenario(Screen14Scenario.readyTopFold),
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );

      // Main Form View for READY, INITIATING, PENDING, CHECKING_STATUS, RECONCILIATION, FAILED, EXPIRED, AMOUNT_CHANGED, PROVIDER_UNAVAILABLE
      default:
        return Screen14MainPaymentView(
          scenario: _currentScenario,
          booking: _activeBooking!,
          scrollController: _scrollController,
          initiationAttempts: _initiationAttempts,
          onInitiatePayment: _handleInitiatePayment,
          onCheckStatus: _handleCheckStatus,
          onMockResponse: _handleMockResponse,
          onScenarioChanged: _setScenario,
          onTrigger401: _trigger401SessionPurge,
          onBack: () => _setScenario(Screen14Scenario.readyTopFold),
        );
    }
  }
}

// -----------------------------------------------------------------------------
// Main Payment Screen View
// -----------------------------------------------------------------------------

class Screen14MainPaymentView extends StatelessWidget {
  const Screen14MainPaymentView({
    super.key,
    required this.scenario,
    required this.booking,
    required this.scrollController,
    required this.initiationAttempts,
    required this.onInitiatePayment,
    required this.onCheckStatus,
    required this.onMockResponse,
    required this.onScenarioChanged,
    required this.onTrigger401,
    required this.onBack,
  });

  final Screen14Scenario scenario;
  final CustomerBookingRecord booking;
  final ScrollController scrollController;
  final int initiationAttempts;
  final VoidCallback onInitiatePayment;
  final VoidCallback onCheckStatus;
  final ValueChanged<MockAuthoritativeResponse> onMockResponse;
  final ValueChanged<Screen14Scenario> onScenarioChanged;
  final VoidCallback onTrigger401;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // RTL Arrow Back: in TextDirection.rtl, Icons.arrow_back points RIGHT (Hierarchical back to Screen 13)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: onBack,
          tooltip: 'الرجوع إلى تفاصيل الحجز',
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
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Status Notice Banner (Contextual)
            _buildStatusNoticeCard(context),
            const SizedBox(height: 12),

            // 2. Compact Property Recognition Card
            _buildPropertySummaryCard(context),
            const SizedBox(height: 12),

            // 3. Deposit Amount Hero Card (Top Fold Prominence)
            _buildDepositHeroCard(context),
            const SizedBox(height: 12),

            // 4. Primary Black Action CTA (Directly visible before scroll on A56)
            _buildPrimaryActionCta(context),
            const SizedBox(height: 16),

            // 5. Test-Only Mock Response Chooser (Visible only during checkingStatus)
            if (scenario.state == Screen14PaymentState.checkingStatus) ...[
              _buildCheckingStatusMockChooser(context),
              const SizedBox(height: 16),
            ],

            // 6. Stay Details Section (After initial fold)
            _buildStayDetailsSection(context),
            const SizedBox(height: 12),

            // 7. Authoritative Financial Snapshot Section
            _buildFinancialBreakdownSection(context),
            const SizedBox(height: 12),

            // 8. Truthful Safe Payment Guidance (Correction B: Factual guidance only)
            _buildTruthfulPaymentGuidanceCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Contextual Status Notice Cards
  // ---------------------------------------------------------------------------

  Widget _buildStatusNoticeCard(BuildContext context) {
    switch (scenario.state) {
      case Screen14PaymentState.ready:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF111827)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وافق المالك على طلب الحجز',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'طلبك معتمد وبانتظار سداد العربون لتأكيد الحجز النهائي وتثبيت التواريخ.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11.5,
                        height: 1.35,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.initiating:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF111827)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF111827)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'جارٍ تجهيز محاولة الدفع بأمان... تم قفل الإجراء لمنع التكرار.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.paymentPending:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.hourglass_top_outlined, size: 18, color: Color(0xFF111827)),
                  SizedBox(width: 8),
                  Text(
                    'عملية الدفع قيد المعالجة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'تم إرسال المحاولة. يُرجى التحقق من حالة المعاملة دون بدء محاولة دفع جديدة منعًا للازدواج.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.checkingStatus:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF111827)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF111827)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'جارٍ التحقق من حالة العملية لدى الخادم...',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'يتم الاستعلام عن السجل النهائي للعملية دون إنشاء محاولة خصم جديدة. لن يتم الانتقال للنجاح إلا برد صريح.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.networkReconciliationRequired:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wifi_off_outlined, size: 18, color: Color(0xFF111827)),
                  SizedBox(width: 8),
                  Text(
                    'تعذر تأكيد نتيجة العملية بسبب الشبكة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'انقطع الاتصال أثناء المعالجة. يُرجى التحقق من حالة العملية قبل اتخاذ أي إجراء إضافي.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.failed:
        // Correction B: Truthful copy (removed unverified "لم يتم خصم أي مبالغ")
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFCA5A5)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.highlight_off_outlined, size: 18, color: Color(0xFF991B1B)),
                  SizedBox(width: 8),
                  Text(
                    'تعذر إتمام عملية الدفع في هذه المحاولة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'تعذّر إكمال محاولة الدفع. تأكد من حالة العملية والحجز قبل محاولة جديدة.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF7F1D1D),
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.transactionExpired:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timer_off_outlined, size: 18, color: Color(0xFF4B5563)),
                  SizedBox(width: 8),
                  Text(
                    'انتهت صلاحية جلسة الدفع الحالية فقط',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'تنبيه: انتهت مهلة جلسة الدفع فقط، ولم يُلغَ حجزك. طلبك ما زال معتمدًا لدى المالك بانتظار سداد العربون.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.amountChanged:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF111827)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.sync_problem_outlined, size: 18, color: Color(0xFF111827)),
                  SizedBox(width: 8),
                  Text(
                    'تم تحديث مبلغ العربون المعتمد',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'تغيّر مبلغ العربون على الخادم قبل إتمام الدفع. يُرجى مراجعة المبلغ الجديد والموافقة عليه صراحة قبل المتابعة:',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المبلغ السابق: 2,500 ج.م',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11.5,
                        color: Color(0xFF9CA3AF),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      'المعتمد الآن: 2,700 ج.م',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case Screen14PaymentState.providerUnavailable:
        // Correction B: Truthful copy (removed unverified "صيانة مؤقتة" and "لم يتم خصم أي مبالغ")
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cloud_off_outlined, size: 18, color: Color(0xFF4B5563)),
                  SizedBox(width: 8),
                  Text(
                    'خدمة الدفع غير متاحة حاليًا',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'خدمة الدفع غير متاحة حاليًا لهذه المحاولة. يمكنك العودة إلى تفاصيل الحجز أو إعادة التحقق لاحقًا.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11.5,
                  height: 1.35,
                  color: Color(0xFF4B5563),
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
  // Property Summary Card
  // ---------------------------------------------------------------------------

  Widget _buildPropertySummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(Icons.apartment_rounded, color: Color(0xFF111827), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.property.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.property.locationName,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11.5,
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
              booking.bookingNumber,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Deposit Amount Hero Card
  // ---------------------------------------------------------------------------

  Widget _buildDepositHeroCard(BuildContext context) {
    final depositStr = _formatAmount(booking.depositAmount);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
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
              color: Color(0xFFD1D5DB),
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
                  color: Colors.white,
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
                  color: Color(0xFFE5E7EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'يمثل قيمة الليلة الأولى من إجمالي الإقامة • يُخصم من الإجمالي النهائي',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Primary Action Button (State-Driven)
  // ---------------------------------------------------------------------------

  Widget _buildPrimaryActionCta(BuildContext context) {
    // 1. PAYMENT_PENDING or NETWORK_RECONCILIATION_REQUIRED
    // Tapping enters checkingStatus, strictly no false confirmation!
    if (scenario.state == Screen14PaymentState.paymentPending ||
        scenario.state == Screen14PaymentState.networkReconciliationRequired) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onCheckStatus,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text(
            'التحقق من حالة الدفع',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
    }

    // 2. CHECKING_STATUS (Busy read-only spinner)
    if (scenario.state == Screen14PaymentState.checkingStatus) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: null, // Disabled during checking
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

    // 3. INITIATING (Disabled with Spinner)
    if (scenario.state == Screen14PaymentState.initiating) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: null, // Disabled to prevent duplicate submission
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

    // 4. FAILED or TRANSACTION_EXPIRED (Fresh attempt CTA)
    if (scenario.state == Screen14PaymentState.failed ||
        scenario.state == Screen14PaymentState.transactionExpired) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => onScenarioChanged(Screen14Scenario.readyTopFold),
          icon: const Icon(Icons.replay_outlined, size: 18),
          label: const Text(
            'بدء محاولة دفع جديدة',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
    }

    // 5. AMOUNT_CHANGED (Explicit Acknowledgment CTA)
    if (scenario.state == Screen14PaymentState.amountChanged) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => onScenarioChanged(Screen14Scenario.readyTopFold),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'الموافقة على المبلغ الجديد ومتابعة الدفع',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // 6. PROVIDER_UNAVAILABLE (Return or Retry)
    if (scenario.state == Screen14PaymentState.providerUnavailable) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: onBack,
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // 7. READY State (Standard Main Black Action CTA)
    final depositStr = _formatAmount(booking.depositAmount);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onInitiatePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF000000), // Stable Black #000000
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Primary 6px radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'دفع العربون ($depositStr ج.م)',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            // Forward arrow in RTL points LEFT (Progression)
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Test-Only Mock Response Chooser for CHECKING_STATUS (Correction A)
  // ---------------------------------------------------------------------------

  Widget _buildCheckingStatusMockChooser(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.developer_mode, size: 16, color: Color(0xFF374151)),
              SizedBox(width: 6),
              Text(
                'أداة اختبار مستقلة للمعاينة — اختر نتيجة الخادم:',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMockChoiceChip(
                label: 'تأكيد الحجز (CONFIRMED)',
                onTap: () => onMockResponse(MockAuthoritativeResponse.confirmed),
                isPrimary: true,
              ),
              _buildMockChoiceChip(
                label: 'ما زالت قيد المعالجة (PENDING)',
                onTap: () => onMockResponse(MockAuthoritativeResponse.stillPending),
              ),
              _buildMockChoiceChip(
                label: 'فشل العملية (FAILED)',
                onTap: () => onMockResponse(MockAuthoritativeResponse.failed),
              ),
              _buildMockChoiceChip(
                label: 'انقطاع الاتصال (TIMEOUT)',
                onTap: () => onMockResponse(MockAuthoritativeResponse.unknownTimeout),
              ),
              _buildMockChoiceChip(
                label: 'انتهاء الجلسة (401)',
                onTap: () => onMockResponse(MockAuthoritativeResponse.unauthorized),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMockChoiceChip({
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isPrimary ? const Color(0xFF111827) : const Color(0xFFD1D5DB),
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

  // ---------------------------------------------------------------------------
  // Stay Details Section
  // ---------------------------------------------------------------------------

  Widget _buildStayDetailsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'التواريخ',
            value: '${booking.checkInIso} ← ${booking.checkOutIso}',
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFF3F4F6)),
          _buildDetailRow(
            icon: Icons.night_shelter_outlined,
            label: 'المدة',
            value: '${booking.nights} ليالٍ',
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFF3F4F6)),
          _buildDetailRow(
            icon: Icons.people_outline,
            label: 'النزلاء',
            value: '${booking.guestsCount} ضيوف',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Financial Snapshot Section
  // ---------------------------------------------------------------------------

  Widget _buildFinancialBreakdownSection(BuildContext context) {
    final totalStr = _formatAmount(booking.totalStay);
    final depositStr = _formatAmount(booking.depositAmount);
    final remainingStr = _formatAmount(booking.remainingAmount);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'التفاصيل المالية للحجز',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          _buildMoneyRow(
            label: 'إجمالي مدة الإقامة (${booking.nights} ليالٍ)',
            amount: totalStr,
            isStrong: false,
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFF3F4F6)),
          _buildMoneyRow(
            label: 'العربون المطلوب سداده الآن (الليلة الأولى)',
            amount: depositStr,
            isStrong: true,
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFF3F4F6)),
          _buildMoneyRow(
            label: 'المبلغ المتبقي',
            amount: remainingStr,
            isStrong: false,
            subtitle: 'يُسوّى المبلغ المتبقي لاحقًا وفق اشتراطات الإقامة',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Truthful Safe Payment Guidance Card (Correction B)
  // ---------------------------------------------------------------------------

  Widget _buildTruthfulPaymentGuidanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Color(0xFF374151)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إرشادات الدفع والتحقق',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'إذا كانت نتيجة محاولة الدفع غير واضحة، تحقّق من حالتها قبل بدء محاولة جديدة.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11.5,
                    height: 1.35,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper row widgets
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
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

  Widget _buildMoneyRow({
    required String label,
    required String amount,
    required bool isStrong,
    String? subtitle,
  }) {
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
                  fontSize: isStrong ? 12.5 : 12,
                  fontWeight: isStrong ? FontWeight.w700 : FontWeight.w500,
                  color: isStrong ? const Color(0xFF111827) : const Color(0xFF4B5563),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: isStrong ? 14.5 : 13,
                    fontWeight: isStrong ? FontWeight.w800 : FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'ج.م',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 10.5,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ],
    );
  }

  static String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// -----------------------------------------------------------------------------
// Component: Confirmed / Success View (Explicit Mock-Authoritative CONFIRMED)
// -----------------------------------------------------------------------------

class Screen14SuccessView extends StatelessWidget {
  const Screen14SuccessView({
    super.key,
    required this.booking,
    required this.onBack,
  });

  final CustomerBookingRecord booking;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // RTL Back: points RIGHT
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF111827),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تم سداد العربون وتأكيد الحجز بنجاح',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'تم تسجيل سداد العربون وتثبيت حجزك رسميًا لدى المالك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF4B5563),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildConfirmedItem('رقم الحجز المعتمد', booking.bookingNumber),
                    const Divider(height: 14, thickness: 1, color: Color(0xFFE5E7EB)),
                    _buildConfirmedItem('العقار', booking.property.title),
                    const Divider(height: 14, thickness: 1, color: Color(0xFFE5E7EB)),
                    _buildConfirmedItem('مبلغ العربون المسدد', '${_formatAmount(booking.depositAmount)} ج.م'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'الانتقال إلى تفاصيل الحجز',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى قائمة حجوزاتي',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  Widget _buildConfirmedItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  static String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// -----------------------------------------------------------------------------
// Component: Already Confirmed View
// -----------------------------------------------------------------------------

class Screen14AlreadyConfirmedView extends StatelessWidget {
  const Screen14AlreadyConfirmedView({
    super.key,
    required this.booking,
    required this.onBack,
  });

  final CustomerBookingRecord booking;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // RTL Back: points RIGHT
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
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

// -----------------------------------------------------------------------------
// Component: State Changed / Ineligible View
// -----------------------------------------------------------------------------

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
        centerTitle: true,
        // RTL Back: points RIGHT
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
                child: const Icon(Icons.event_busy_outlined, color: Color(0xFF4B5563), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'تغيرت حالة الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'لم يعد هذا الحجز بانتظار سداد العربون (تم الإلغاء أو انتهاء المهلة). يمكنك استعراض قائمة حجوزاتك.',
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
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

// -----------------------------------------------------------------------------
// Component: Fail-Closed Unauthorized View (401 - In-Memory Redacted)
// -----------------------------------------------------------------------------

class Screen14FailClosedUnauthorizedView extends StatelessWidget {
  const Screen14FailClosedUnauthorizedView({
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
        centerTitle: true,
        // RTL Back: points RIGHT
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
                child: const Icon(Icons.lock_outline, color: Color(0xFF111827), size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'انتهت صلاحية الجلسة (401)',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'تم حجب وتفريغ بيانات الحجز من الذاكرة لحماية الخصوصية. يُرجى تسجيل الدخول مجددًا لمتابعة الحجز.',
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول',
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

// -----------------------------------------------------------------------------
// Component: Forbidden View (403)
// -----------------------------------------------------------------------------

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
        centerTitle: true,
        // RTL Back: points RIGHT
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
                'غير مصرّح بالوصول (403)',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'لا تملك صلاحية الوصول إلى بيانات هذا الحجز. يُرجى التحقق من الحساب المسجّل.',
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى حجوزاتي',
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

// -----------------------------------------------------------------------------
// Component: Not Found View (404)
// -----------------------------------------------------------------------------

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
        centerTitle: true,
        // RTL Back: points RIGHT
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
                'الحجز غير موجود (404)',
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
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

// -----------------------------------------------------------------------------
// Component: Initial Loading Skeleton View
// -----------------------------------------------------------------------------

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
        centerTitle: true,
        // RTL Back: points RIGHT
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
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF9CA3AF)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 50,
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

// -----------------------------------------------------------------------------
// Component: First Load Error View
// -----------------------------------------------------------------------------

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
        centerTitle: true,
        // RTL Back: points RIGHT
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
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
