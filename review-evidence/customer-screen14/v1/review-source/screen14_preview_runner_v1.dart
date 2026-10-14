import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Self-test fixture math assertions prior to launching UI
  final fixtures = Screen14SampleFixtures.getAllFixtures();
  Screen14SampleFixtures.assertFixtureIntegrity(fixtures);
  runApp(const Screen14PreviewApp());
}

// -----------------------------------------------------------------------------
// Canonical Booking & Payment Domain Types for Screen 14 V1
// -----------------------------------------------------------------------------

enum Screen14PaymentState {
  initialLoading,
  ready,
  amountChanged,
  initiating,
  externalHandoffReady,
  providerUnavailable,
  checkingStatus,
  paymentPending,
  failed,
  transactionExpired,
  success,
  alreadyConfirmed,
  stateChanged,
  networkReconciliationRequired,
  unauthorized,
  forbidden,
  notFound,
  error,
}

enum Screen14Scenario {
  readyTopFold('01. جاهز للدفع — الطي الأول (مبلغ العربون والزر)'),
  readyScrolledFinancials('02. جاهز للدفع — التمرير (تفاصيل الإقامة والمبلغ)'),
  initiatingState('03. جارٍ بدء الدفع (تعطيل الإجراء ومنع التكرار)'),
  paymentPending('04. الدفع قيد التحقق (التحقق من الحالة دون تكرار)'),
  networkReconciliationRequired('05. انقطاع الشبكة (مراجعة آمنة دون خصم مكرر)'),
  failedAttempt('06. تعذر إتمام الدفع (محاولة جديدة بعد التحقق)'),
  transactionExpired('07. انتهاء محاولة الدفع (جلسة الدفع فقط منتهية)'),
  amountChangedConflict('08. تغيّر مبلغ العربون (مراجعة المبلغ والموافقة)'),
  providerUnavailable('09. بوابة الدفع غير متاحة (حدود نزيهة دون تزييف)'),
  confirmedSyntheticSuccess('10. تم الدفع وتأكيد الحجز (محاكاة خادم صادقة)'),
  alreadyConfirmed('11. الحجز مؤكد مسبقًا (لا عربون مطلوب)'),
  stateChangedIneligible('12. حالة الحجز تغيرت (الدفع غير متاح)'),
  unauthorizedSessionExpired('13. انتهت الجلسة 401 (حجب تام لبيانات الحجز)'),
  accessibility200Top('14. إمكانية الوصول 200% — الطي الأول'),
  accessibility200Scrolled('15. إمكانية الوصول 200% — بعد التمرير والزر');

  const Screen14Scenario(this.label);
  final String label;
}

// -----------------------------------------------------------------------------
// Synthetic Booking Model & Validated Fixtures for Screen 14
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

  DateTime get checkInDateTime => DateTime.parse(checkInIso);
  DateTime get checkOutDateTime => DateTime.parse(checkOutIso);

  String get checkInFormatted {
    final d = checkInDateTime;
    const weekdays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد'
    ];
    const months = [
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
      'ديسمبر'
    ];
    final w = weekdays[d.weekday - 1];
    final m = months[d.month - 1];
    return '$w، ${d.day} $m ${d.year}';
  }

  String get checkOutFormatted {
    final d = checkOutDateTime;
    const weekdays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد'
    ];
    const months = [
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
      'ديسمبر'
    ];
    final w = weekdays[d.weekday - 1];
    final m = months[d.month - 1];
    return '$w، ${d.day} $m ${d.year}';
  }
}

class Screen14SampleFixtures {
  static List<CustomerBookingRecord> getAllFixtures() {
    return [
      // Standard Verified Booking: 5 nights, 2,700/night -> 13,500 total, 2,700 deposit
      const CustomerBookingRecord(
        id: 'BK-1401',
        bookingNumber: 'BK-20261014-98412',
        propertyId: 'PROP-01',
        checkInIso: '2026-10-15', // الخميس
        checkOutIso: '2026-10-20', // الثلاثاء
        nights: 5,
        guestsCount: 4,
        nightlyPrice: 2700,
        totalStay: 13500, // 5 * 2,700
        depositAmount: 2700, // First night flat-rate
        remainingAmount: 10800, // 13,500 - 2,700
        currency: 'ج.م',
        property: BookingPropertyRecord(
          id: 'PROP-01',
          title: 'فيلا شاطئية مطلة على البحر بمراسي',
          locationName: 'مراسي، خليج سيدي عبد الرحمن، الساحل الشمالي',
          unitType: 'فيلا مستقلة',
        ),
      ),
      // Long Title Edge Case
      const CustomerBookingRecord(
        id: 'BK-1402',
        bookingNumber: 'BK-20261015-EG-HSC-99824-EXTENDED',
        propertyId: 'PROP-02',
        checkInIso: '2026-11-12', // الخميس
        checkOutIso: '2026-11-16', // الاثنين
        nights: 4,
        guestsCount: 6,
        nightlyPrice: 3500,
        totalStay: 14000,
        depositAmount: 3500,
        remainingAmount: 10500,
        currency: 'ج.م',
        property: BookingPropertyRecord(
          id: 'PROP-02',
          title:
              'شاليه عائلي فاخر صف أول على اللاجون مباشرة مع حديقة خاصة بمنتجع هاسيندا باي سيدي عبد الرحمن',
          locationName: 'هاسيندا باي، سيدي عبد الرحمن، الساحل الشمالي',
          unitType: 'شاليه أرضي مع حديقة',
        ),
      ),
    ];
  }

  static void assertFixtureIntegrity(List<CustomerBookingRecord> fixtures) {
    for (final b in fixtures) {
      final expectedTotal = b.nightlyPrice * b.nights;
      assert(
        b.totalStay == expectedTotal,
        'CRITICAL: Total stay mismatch: expected $expectedTotal, got ${b.totalStay}',
      );
      assert(
        b.depositAmount == b.nightlyPrice,
        'CRITICAL: First-night deposit mismatch: expected ${b.nightlyPrice}, got ${b.depositAmount}',
      );
      assert(
        b.remainingAmount == b.totalStay - b.depositAmount,
        'CRITICAL: Remaining amount mismatch: expected ${b.totalStay - b.depositAmount}, got ${b.remainingAmount}',
      );

      final d1 = b.checkInDateTime;
      final d2 = b.checkOutDateTime;
      assert(d2.isAfter(d1), 'Check-out must be after check-in');
      final diff = d2.difference(d1).inDays;
      assert(diff == b.nights, 'Date diff $diff != nights ${b.nights}');
    }

    // Civil day assertion for BK-1401
    final f1 = fixtures[0];
    assert(f1.checkInFormatted.startsWith('الخميس'),
        '2026-10-15 must be الخميس, got ${f1.checkInFormatted}');
    assert(f1.checkOutFormatted.startsWith('الثلاثاء'),
        '2026-10-20 must be الثلاثاء, got ${f1.checkOutFormatted}');
  }
}

// -----------------------------------------------------------------------------
// Screen 14 V1 Preview App Harness
// -----------------------------------------------------------------------------

class Screen14PreviewApp extends StatefulWidget {
  const Screen14PreviewApp({super.key});

  @override
  State<Screen14PreviewApp> createState() => _Screen14PreviewAppState();
}

class _Screen14PreviewAppState extends State<Screen14PreviewApp> {
  Screen14Scenario _scenario = Screen14Scenario.readyTopFold;
  bool _showQaBar = false;
  bool _isPurgedDueToSimulated401 = false;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setScenario(Screen14Scenario scenario) {
    setState(() {
      _scenario = scenario;
      _isPurgedDueToSimulated401 = false;
    });

    // Auto-scroll logic for scrolled scenarios
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (scenario == Screen14Scenario.readyScrolledFinancials ||
          scenario == Screen14Scenario.accessibility200Scrolled) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  void _triggerSimulated401Purge() {
    setState(() {
      _isPurgedDueToSimulated401 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isA11y = _scenario == Screen14Scenario.accessibility200Top ||
        _scenario == Screen14Scenario.accessibility200Scrolled;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Hardware / ADB keyevent routing
          if (event.logicalKey == LogicalKeyboardKey.digit1 ||
              event.logicalKey == LogicalKeyboardKey.numpad1) {
            _setScenario(Screen14Scenario.readyTopFold);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
              event.logicalKey == LogicalKeyboardKey.numpad2) {
            _setScenario(Screen14Scenario.readyScrolledFinancials);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.numpad3) {
            _setScenario(Screen14Scenario.initiatingState);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            _setScenario(Screen14Scenario.paymentPending);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit5 ||
              event.logicalKey == LogicalKeyboardKey.numpad5) {
            _setScenario(Screen14Scenario.networkReconciliationRequired);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit6 ||
              event.logicalKey == LogicalKeyboardKey.numpad6) {
            _setScenario(Screen14Scenario.failedAttempt);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit7 ||
              event.logicalKey == LogicalKeyboardKey.numpad7) {
            _setScenario(Screen14Scenario.transactionExpired);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit8 ||
              event.logicalKey == LogicalKeyboardKey.numpad8) {
            _setScenario(Screen14Scenario.amountChangedConflict);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit9 ||
              event.logicalKey == LogicalKeyboardKey.numpad9) {
            _setScenario(Screen14Scenario.providerUnavailable);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit0 ||
              event.logicalKey == LogicalKeyboardKey.numpad0) {
            _setScenario(Screen14Scenario.confirmedSyntheticSuccess);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
            _setScenario(Screen14Scenario.alreadyConfirmed);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyB) {
            _setScenario(Screen14Scenario.stateChangedIneligible);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
            _setScenario(Screen14Scenario.unauthorizedSessionExpired);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
            _setScenario(Screen14Scenario.accessibility200Top);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
            _setScenario(Screen14Scenario.accessibility200Scrolled);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
            _triggerSimulated401Purge();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyQ) {
            setState(() => _showQaBar = !_showQaBar);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KONFRM Screen 14 V1 Preview',
        theme: ThemeData(
          fontFamily: KonfrmTypography.fontFamily,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF111827),
            primary: const Color(0xFF111827),
          ),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: isA11y
                  ? const TextScaler.linear(2.0)
                  : const TextScaler.linear(1.0),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          );
        },
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Screen14HarnessBody(
                  scenario: _scenario,
                  scrollController: _scrollController,
                  isPurgedDueToSimulated401: _isPurgedDueToSimulated401,
                  onScenarioChanged: _setScenario,
                  onTriggerSimulatedPurge: _triggerSimulated401Purge,
                ),
              ),
              if (_showQaBar)
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xE6000000),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _scenario.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: () => setState(() => _showQaBar = false),
                        ),
                      ],
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
// Screen 14 Body & Visual Presentation Component
// -----------------------------------------------------------------------------

class Screen14HarnessBody extends StatelessWidget {
  const Screen14HarnessBody({
    super.key,
    required this.scenario,
    required this.scrollController,
    required this.isPurgedDueToSimulated401,
    required this.onScenarioChanged,
    required this.onTriggerSimulatedPurge,
  });

  final Screen14Scenario scenario;
  final ScrollController scrollController;
  final bool isPurgedDueToSimulated401;
  final ValueChanged<Screen14Scenario> onScenarioChanged;
  final VoidCallback onTriggerSimulatedPurge;

  @override
  Widget build(BuildContext context) {
    final fixtures = Screen14SampleFixtures.getAllFixtures();
    final booking = (scenario == Screen14Scenario.readyScrolledFinancials)
        ? fixtures[1] // Long title variant for scrolled inspection
        : fixtures[0]; // Standard verified booking

    // Session Expired / Unauthorized 401: Fail-Closed Protection
    if (scenario == Screen14Scenario.unauthorizedSessionExpired ||
        isPurgedDueToSimulated401) {
      return Screen14FailClosedUnauthorizedView(
        onBack: () {},
        onLogin: () {},
      );
    }

    // Already Confirmed State
    if (scenario == Screen14Scenario.alreadyConfirmed) {
      return Screen14AlreadyConfirmedView(
        booking: booking,
        onBack: () {},
      );
    }

    // State Changed Ineligible (e.g. Owner revoked or cancelled)
    if (scenario == Screen14Scenario.stateChangedIneligible) {
      return Screen14StateChangedView(
        booking: booking,
        onBack: () {},
      );
    }

    // Server-Authoritative Confirmed / Success
    if (scenario == Screen14Scenario.confirmedSyntheticSuccess) {
      return Screen14SuccessView(
        booking: booking,
        onBack: () {},
      );
    }

    // Standard Transactional Surface (Ready, Initiating, Pending, Reconcile, Failed, Expired, AmountChanged, Unavailable)
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          tooltip: 'العودة إلى تفاصيل الحجز',
          onPressed: () {},
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
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Status Notice / Caveat (First Fold Priority)
            _buildStatusHeader(context),
            const SizedBox(height: 10),

            // 2. Compact Booking Identity (Property & Code Context)
            _buildCompactBookingIdentity(context, booking),
            const SizedBox(height: 10),

            // 3. Deposit Hero Box (Large Amount before CTA)
            _buildDepositHeroCard(context, booking),
            const SizedBox(height: 10),

            // 4. State-Specific Alert / Interaction Banner (when applicable)
            if (_hasStateBanner) ...[
              _buildStateSpecificBanner(context, booking),
              const SizedBox(height: 10),
            ],

            // 5. Primary Action CTA Button (First Fold Reachable!)
            _buildPrimaryActionCta(context, booking),
            const SizedBox(height: 14),

            // 6. Financial Breakdown Card (Context only)
            _buildFinancialBreakdownCard(context, booking),
            const SizedBox(height: 12),

            // 7. Stay Dates & Details Card
            _buildStayDetailsCard(context, booking),
            const SizedBox(height: 12),

            // 8. Payment Trust & Security Card
            _buildTrustNoticeCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  bool get _hasStateBanner =>
      scenario == Screen14Scenario.initiatingState ||
      scenario == Screen14Scenario.paymentPending ||
      scenario == Screen14Scenario.networkReconciliationRequired ||
      scenario == Screen14Scenario.failedAttempt ||
      scenario == Screen14Scenario.transactionExpired ||
      scenario == Screen14Scenario.amountChangedConflict ||
      scenario == Screen14Scenario.providerUnavailable;

  Widget _buildStatusHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.info_outline,
              size: 18,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
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
                  'الحجز لم يُؤكّد بعد — يتطلب سداد مبلغ العربون المعتمد لتأكيد التواريخ بشكل نهائي.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11.5,
                    height: 1.35,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactBookingIdentity(BuildContext context, CustomerBookingRecord booking) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.property.title,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    booking.bookingNumber,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking.property.locationName,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepositHeroCard(BuildContext context, CustomerBookingRecord booking) {
    final deposit = (scenario == Screen14Scenario.amountChangedConflict)
        ? 2700 // Updated canonical deposit
        : booking.depositAmount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF111827), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'العربون المطلوب للتأكيد الآن',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Directionality-Isolated Cairo Currency Formatting (Number First)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                deposit.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'ج.م',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'قيمة الليلة الأولى كاملة تُسدد كعربون لحجز الوحدة.',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11.5,
              color: Color(0xFF4B5563),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'بيئة معاينة تجريبية — لا يتم خصم مبالغ بنكية حقيقية',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateSpecificBanner(BuildContext context, CustomerBookingRecord booking) {
    switch (scenario) {
      case Screen14Scenario.initiatingState:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF111827)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'جارٍ بدء جلسة الدفع بأمان… يُرجى الانتظار دون إعادة النقر.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        );

      case Screen14Scenario.paymentPending:
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
                  Icon(Icons.hourglass_bottom_outlined, size: 18, color: Color(0xFF111827)),
                  SizedBox(width: 8),
                  Text(
                    'عملية الدفع قيد التحقق لدى مزود الخدمة',
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
                'لم يتم استلام تأكيد الخادم النهائي بعد. لحمايتك من الخصم المكرر، لا يمكنك بدء عملية دفع جديدة أثناء وجود معاملة معلّقة. انقر أدناه للتحقق من الحالة.',
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

      case Screen14Scenario.networkReconciliationRequired:
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
                    'تعذر التأكد من نتيجة المحاولة السابقة',
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
                'حدث انقطاع مؤقت في الاتصال بالشبكة. سنراجع حالة الدفع مع الخادم دون تكرار أي محاولة خصم.',
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

      case Screen14Scenario.failedAttempt:
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
                'لم يتم خصم أي مبالغ من حسابك. يمكنك التحقق من حالة حجزك وبدء محاولة دفع جديدة.',
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

      case Screen14Scenario.transactionExpired:
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

      case Screen14Scenario.amountChangedConflict:
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

      case Screen14Scenario.providerUnavailable:
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
                    'خدمة الدفع الإلكتروني غير متاحة حاليًا',
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
                'بوابة الدفع الإلكتروني تخضع لأعمال صيانة مؤقتة. لم يتم خصم أي مبالغ. يُرجى المحاولة في وقت لاحق.',
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

  Widget _buildPrimaryActionCta(BuildContext context, CustomerBookingRecord booking) {
    // 1. PAYMENT_PENDING or NETWORK_RECONCILIATION_REQUIRED
    if (scenario == Screen14Scenario.paymentPending ||
        scenario == Screen14Scenario.networkReconciliationRequired) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            onScenarioChanged(Screen14Scenario.confirmedSyntheticSuccess);
          },
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
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    // 2. FAILED or TRANSACTION_EXPIRED
    if (scenario == Screen14Scenario.failedAttempt ||
        scenario == Screen14Scenario.transactionExpired) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                onScenarioChanged(Screen14Scenario.readyTopFold);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'بدء محاولة دفع جديدة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'العودة إلى تفاصيل الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 3. AMOUNT_CHANGED
    if (scenario == Screen14Scenario.amountChangedConflict) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            onScenarioChanged(Screen14Scenario.readyTopFold);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'موافق على المبلغ المعتمد والمتابعة',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // 4. PROVIDER_UNAVAILABLE
    if (scenario == Screen14Scenario.providerUnavailable) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                onScenarioChanged(Screen14Scenario.readyTopFold);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'العودة إلى تفاصيل الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 5. INITIATING (In-progress disabled state)
    if (scenario == Screen14Scenario.initiatingState) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: null, // Disabled
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9CA3AF),
            disabledBackgroundColor: const Color(0xFF374151),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'جارٍ بدء عملية الدفع…',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 6. READY (Default Top Fold and Scrolled)
    final formattedDeposit = booking.depositAmount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Tap simulates initiating -> pending transition (QA preview only)
          onScenarioChanged(Screen14Scenario.initiatingState);
          Future.delayed(const Duration(milliseconds: 900), () {
            onScenarioChanged(Screen14Scenario.paymentPending);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111827),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'دفع العربون ($formattedDeposit ج.م)',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialBreakdownCard(BuildContext context, CustomerBookingRecord booking) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل المبلغ المعتمد',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          // Total Stay
          _buildPriceRow(
            label: 'إجمالي قيمة الإقامة (${booking.nights} ليالٍ)',
            amount: booking.totalStay,
            isBold: false,
          ),
          const SizedBox(height: 8),
          // Deposit Row (Highlighted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(7),
            ),
            child: _buildPriceRow(
              label: 'العربون المطلوب للتأكيد الآن',
              amount: booking.depositAmount,
              isBold: true,
              labelColor: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          // Remaining Balance
          _buildPriceRow(
            label: 'المتبقي من قيمة الإقامة',
            amount: booking.remainingAmount,
            isBold: false,
            amountColor: const Color(0xFF4B5563),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF3F4F6), height: 1),
          const SizedBox(height: 8),
          const Text(
            'ملاحظة: المبلغ المتبقي لا يتم سداده في هذه الخطوة (طريقة وموعد السداد لاحقًا غير محددين حاليًا).',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              height: 1.35,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required int amount,
    required bool isBold,
    Color? labelColor,
    Color? amountColor,
  }) {
    final formattedAmount = amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: labelColor ?? const Color(0xFF4B5563),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedAmount,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13.5,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: amountColor ??
                    (isBold ? const Color(0xFF111827) : const Color(0xFF374151)),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'ج.م',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: isBold ? const Color(0xFF111827) : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStayDetailsCard(BuildContext context, CustomerBookingRecord booking) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تواريخ الإقامة والنزلاء',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.date_range_outlined, size: 16, color: Color(0xFF111827)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${booking.checkInFormatted} ← ${booking.checkOutFormatted}',
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.people_outline, size: 16, color: Color(0xFF111827)),
              const SizedBox(width: 8),
              Text(
                '${booking.guestsCount} ضيوف • ${booking.property.unitType}',
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustNoticeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, size: 18, color: Color(0xFF111827)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حماية الدفع وضمان الحجز',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'عملية الدفع مشفرة ومحمية. لن يتم تكرار الخصم، ولا يُسحب أي مبلغ دون تأكيد صريح منك.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    height: 1.35,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Component: Confirmed / Success View (Synthetic Server Finalization Fixture)
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF111827)),
          onPressed: onBack,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: Color(0xFF166534),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تم دفع العربون وتأكيد الحجز بنجاح!',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'تم استلام مبلغ العربون وتأكيد حجزك لدى المالك بشكل نهائي. يمكنك الآن مراجعة تفاصيل الإقامة والتواصل.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'رقم الحجز:',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            booking.bookingNumber,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'رقم العملية:',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            'TXN-8849201',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF166534),
                            ),
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
                height: 50,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى تفاصيل الحجز',
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF111827)),
          onPressed: onBack,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  size: 34,
                  color: Color(0xFF166534),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'تم تأكيد هذا الحجز مسبقًا',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'تم سداد العربون بنجاح ولا يوجد أي مبلغ مستحق الآن لهذا الحجز.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Component: State Changed View (Ineligible for payment)
// -----------------------------------------------------------------------------

class Screen14StateChangedView extends StatelessWidget {
  const Screen14StateChangedView({
    super.key,
    required this.booking,
    required this.onBack,
  });

  final CustomerBookingRecord booking;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF111827)),
          onPressed: onBack,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block_outlined,
                  size: 32,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'الدفع غير متاح لهذا الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'حالة الحجز الحالية لا تسمح بدفع العربون (قد يكون قيد المراجعة أو تم إلغاؤه من جانب المالك).',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Component: Fail-Closed Unauthorized 401 View (Zero Private Data Leak)
// -----------------------------------------------------------------------------

class Screen14FailClosedUnauthorizedView extends StatelessWidget {
  const Screen14FailClosedUnauthorizedView({
    super.key,
    required this.onBack,
    required this.onLogin,
  });

  final VoidCallback onBack;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF111827)),
          onPressed: onBack,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 32,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'انتهت جلسة تسجيل الدخول',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'لحماية بياناتك المالية ومعلومات الحجز، تم حجب التفاصيل الحساسة. يُرجى تسجيل الدخول مجددًا لمتابعة سداد العربون.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول مجددًا',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
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
