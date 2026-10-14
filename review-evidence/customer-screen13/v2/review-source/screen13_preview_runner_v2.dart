import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Self-test fixture math assertions prior to launching UI
  final fixtures = Screen13SampleFixtures.getAllFixtures();
  Screen13SampleFixtures.assertFixtureIntegrity(fixtures);
  runApp(const Screen13PreviewApp());
}

// -----------------------------------------------------------------------------
// Canonical Booking Domain Types & Status Model for Screen 13 V2
// -----------------------------------------------------------------------------

enum CanonicalBookingStatus {
  pendingOwnerApproval('PENDING_OWNER_APPROVAL'),
  approvedPendingPayment('APPROVED_PENDING_PAYMENT'),
  confirmed('CONFIRMED'),
  rejected('REJECTED'),
  cancelledByGuest('CANCELLED_BY_GUEST'),
  cancelledByOwner('CANCELLED_BY_OWNER'),
  expired('EXPIRED'),
  completed('COMPLETED'),
  unknown('UNKNOWN');

  const CanonicalBookingStatus(this.code);
  final String code;
}

enum Screen13LoadState {
  initialLoading,
  loaded,
  refreshing,
  staleError,
  error,
  unauthorized,
  forbidden,
  notFound,
}

class Screen13StatusPresentation {
  const Screen13StatusPresentation({
    required this.customerLabel,
    required this.headline,
    required this.supportingCopy,
    required this.icon,
    required this.hasPaymentCta,
    required this.badgeBgColor,
    required this.badgeBorderColor,
    required this.badgeTextColor,
  });

  final String customerLabel;
  final String headline;
  final String supportingCopy;
  final IconData icon;
  final bool hasPaymentCta;
  final Color badgeBgColor;
  final Color badgeBorderColor;
  final Color badgeTextColor;
}

/// Near-Zero-Blue Status Presentation Model (Founder Directive & V2 Refinements)
Screen13StatusPresentation getScreen13StatusPresentation(
    CanonicalBookingStatus status) {
  switch (status) {
    case CanonicalBookingStatus.pendingOwnerApproval:
      return const Screen13StatusPresentation(
        customerLabel: 'قيد مراجعة المالك',
        headline: 'الطلب قيد مراجعة المالك',
        supportingCopy:
            'طلبك وصل إلى المالك وهو قيد المراجعة حاليًا.\nلا يوجد أي مبلغ مطلوب دفعه الآن، وسيتم تحديث حالة الطلب فور اتخاذ المالك القرار.',
        icon: Icons.schedule_outlined,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF374151),
      );
    case CanonicalBookingStatus.approvedPendingPayment:
      return const Screen13StatusPresentation(
        customerLabel: 'العربون مطلوب',
        headline: 'وافق المالك على طلب الحجز!',
        supportingCopy:
            'وافق المالك على طلبك بنجاح. يُرجى سداد مبلغ العربون لتأكيد الحجز بشكل نهائي.',
        icon: Icons.credit_card_outlined,
        hasPaymentCta: true,
        badgeBgColor: Color(0xFFFEF2F2),
        badgeBorderColor: Color(0xFFFCA5A5),
        badgeTextColor: Color(0xFF991B1B),
      );
    case CanonicalBookingStatus.confirmed:
      return const Screen13StatusPresentation(
        customerLabel: 'الحجز مؤكد',
        headline: 'حجزك مؤكد وجاهز لإقامتك',
        supportingCopy:
            'تم تأكيد حجزك بنجاح وسداد مبلغ العربون.\nنتمنى لك إقامة ممتعة ومريحة في هذه الوحدة!',
        icon: Icons.check_circle_outline,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF0FDF4),
        badgeBorderColor: Color(0xFFBBF7D0),
        badgeTextColor: Color(0xFF166534),
      );
    case CanonicalBookingStatus.rejected:
      return const Screen13StatusPresentation(
        customerLabel: 'لم يوافق المالك',
        headline: 'اعتذر المالك عن قبول الطلب',
        supportingCopy:
            'نعتذر، لم يتمكن المالك من قبول طلب الحجز لهذه التواريخ.\nلم يتم خصم أي مبالغ، ويمكنك استكشاف وحدات أخرى متاحة في نفس المنطقة.',
        icon: Icons.cancel_outlined,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF4B5563),
      );
    case CanonicalBookingStatus.cancelledByGuest:
      return const Screen13StatusPresentation(
        customerLabel: 'ملغي من جانبك',
        headline: 'تم إلغاء هذا الطلب من جانبك',
        supportingCopy:
            'تم تسجيل إلغاء طلب الحجز بناءً على رغبتك.',
        icon: Icons.block_outlined,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF6B7280),
      );
    case CanonicalBookingStatus.cancelledByOwner:
      return const Screen13StatusPresentation(
        customerLabel: 'ملغي من جانب المالك',
        headline: 'تم إلغاء الطلب من جانب المالك',
        supportingCopy:
            'قام المالك بإلغاء هذا الطلب. نعتذر عن أي إزعاج.',
        icon: Icons.block_outlined,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF6B7280),
      );
    case CanonicalBookingStatus.expired:
      return const Screen13StatusPresentation(
        customerLabel: 'انتهت صلاحية الطلب',
        headline: 'انتهت صلاحية هذا الطلب',
        supportingCopy:
            'انتهت صلاحية هذا الطلب دون اكتمال الحجز. يمكنك تقديم طلب حجز جديد بتواريخ مناسبة.',
        icon: Icons.hourglass_empty_outlined,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF6B7280),
      );
    case CanonicalBookingStatus.completed:
      return const Screen13StatusPresentation(
        customerLabel: 'إقامة مكتملة',
        headline: 'اكتملت الإقامة بنجاح',
        supportingCopy:
            'نأمل أن تكون إقامتك كانت ممتعة ومميزة. نشكرك على اختيار منصة كونفرم!',
        icon: Icons.done_all_outlined,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF0FDF4),
        badgeBorderColor: Color(0xFFBBF7D0),
        badgeTextColor: Color(0xFF166534),
      );
    case CanonicalBookingStatus.unknown:
      return const Screen13StatusPresentation(
        customerLabel: 'حالة الحجز غير متاحة حاليًا',
        headline: 'حالة الحجز غير متاحة حاليًا',
        supportingCopy:
            'لا تتوفر تفاصيل دقيقة عن حالة هذا الحجز حاليًا. يمكنك محاولة تحديث الصفحة.',
        icon: Icons.help_outline,
        hasPaymentCta: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF4B5563),
      );
  }
}

// -----------------------------------------------------------------------------
// Financial Presentation Rules for Screen 13 V2
// -----------------------------------------------------------------------------

class Screen13FinancePresentation {
  const Screen13FinancePresentation({
    required this.showDeposit,
    required this.depositLabel,
    required this.showRemaining,
    required this.remainingLabel,
    required this.showPendingNotice,
    required this.historicalOnly,
  });

  final bool showDeposit;
  final String? depositLabel;
  final bool showRemaining;
  final String? remainingLabel;
  final bool showPendingNotice;
  final bool historicalOnly;
}

Screen13FinancePresentation getScreen13FinancePresentation(
    CanonicalBookingStatus status) {
  switch (status) {
    case CanonicalBookingStatus.pendingOwnerApproval:
      return const Screen13FinancePresentation(
        showDeposit: true,
        depositLabel: 'العربون بعد موافقة المالك',
        showRemaining: true,
        remainingLabel: 'المتبقي بعد العربون',
        showPendingNotice: true,
        historicalOnly: false,
      );
    case CanonicalBookingStatus.approvedPendingPayment:
      return const Screen13FinancePresentation(
        showDeposit: true,
        depositLabel: 'العربون المطلوب للتأكيد',
        showRemaining: true,
        remainingLabel: 'المتبقي من قيمة الإقامة',
        showPendingNotice: false,
        historicalOnly: false,
      );
    case CanonicalBookingStatus.confirmed:
      return const Screen13FinancePresentation(
        showDeposit: true,
        depositLabel: 'العربون المدفوع',
        showRemaining: true,
        remainingLabel: 'المتبقي من قيمة الإقامة',
        showPendingNotice: false,
        historicalOnly: false,
      );
    case CanonicalBookingStatus.rejected:
    case CanonicalBookingStatus.cancelledByGuest:
    case CanonicalBookingStatus.cancelledByOwner:
    case CanonicalBookingStatus.expired:
      return const Screen13FinancePresentation(
        showDeposit: false,
        depositLabel: null,
        showRemaining: false,
        remainingLabel: null,
        showPendingNotice: false,
        historicalOnly: true,
      );
    case CanonicalBookingStatus.completed:
      return const Screen13FinancePresentation(
        showDeposit: true,
        depositLabel: 'العربون المسدد',
        showRemaining: true,
        remainingLabel: 'المبلغ المسدد بالكامل',
        showPendingNotice: false,
        historicalOnly: true,
      );
    case CanonicalBookingStatus.unknown:
      return const Screen13FinancePresentation(
        showDeposit: false,
        depositLabel: null,
        showRemaining: false,
        remainingLabel: null,
        showPendingNotice: false,
        historicalOnly: true,
      );
  }
}

// -----------------------------------------------------------------------------
// Civil Date Localization Engine (Accurate Gregorian Weekdays & Western Digits)
// -----------------------------------------------------------------------------

class CivilDateFormatter {
  static const List<String> arabicWeekdays = [
    'الاثنين', // 1: Monday
    'الثلاثاء', // 2: Tuesday
    'الأربعاء', // 3: Wednesday
    'الخميس', // 4: Thursday
    'الجمعة', // 5: Friday
    'السبت', // 6: Saturday
    'الأحد', // 7: Sunday
  ];

  static const List<String> arabicMonths = [
    'يناير', // 1
    'فبراير', // 2
    'مارس', // 3
    'أبريل', // 4
    'مايو', // 5
    'يونيو', // 6
    'يوليو', // 7
    'أغسطس', // 8
    'سبتمبر', // 9
    'أكتوبر', // 10
    'نوفمبر', // 11
    'ديسمبر', // 12
  ];

  static String formatCivilDateArabic(DateTime date) {
    final weekdayName = arabicWeekdays[date.weekday - 1];
    final monthName = arabicMonths[date.month - 1];
    final dayStr = date.day.toString();
    final yearStr = date.year.toString();
    return '$weekdayName، $dayStr $monthName $yearStr';
  }
}

// -----------------------------------------------------------------------------
// Domain Records for Screen 13 V2
// -----------------------------------------------------------------------------

class BookingPropertyDetail {
  const BookingPropertyDetail({
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

class CustomerBookingDetailRecord {
  const CustomerBookingDetailRecord({
    required this.id,
    required this.bookingNumber,
    required this.propertyId,
    required this.status,
    required this.checkInIso,
    required this.checkOutIso,
    required this.nights,
    required this.guestsCount,
    required this.nightlyPrice,
    required this.totalStay,
    required this.depositAmount,
    required this.remainingAmount,
    required this.currency,
    required this.createdAt,
    required this.property,
    this.specialRequests,
    this.cancelledAt,
    this.cancellationReason,
  });

  final String id;
  final String bookingNumber;
  final String propertyId;
  final CanonicalBookingStatus status;
  final String checkInIso;
  final String checkOutIso;
  final int nights;
  final int guestsCount;
  final int nightlyPrice;
  final int totalStay;
  final int depositAmount;
  final int remainingAmount;
  final String currency;
  final String createdAt;
  final BookingPropertyDetail property;
  final String? specialRequests;
  final String? cancelledAt;
  final String? cancellationReason;

  DateTime get checkInDateTime => DateTime.parse(checkInIso);
  DateTime get checkOutDateTime => DateTime.parse(checkOutIso);

  String get checkInFormatted =>
      CivilDateFormatter.formatCivilDateArabic(checkInDateTime);
  String get checkOutFormatted =>
      CivilDateFormatter.formatCivilDateArabic(checkOutDateTime);
}

// -----------------------------------------------------------------------------
// Fixture Repository & Programmatic Math Integrity Engine
// -----------------------------------------------------------------------------

class Screen13SampleFixtures {
  static List<CustomerBookingDetailRecord> getAllFixtures() {
    return [
      // 01: Approved Pending Payment (Action Required)
      const CustomerBookingDetailRecord(
        id: 'BK-001',
        bookingNumber: 'BK-829104',
        propertyId: 'PROP-01',
        status: CanonicalBookingStatus.approvedPendingPayment,
        checkInIso: '2026-10-20', // الثلاثاء
        checkOutIso: '2026-10-25', // الأحد
        nights: 5,
        guestsCount: 4,
        nightlyPrice: 2700,
        totalStay: 13500, // 5 * 2,700
        depositAmount: 2700, // First night
        remainingAmount: 10800, // 13,500 - 2,700
        currency: 'ج.م',
        createdAt: '14 أكتوبر 2026',
        property: BookingPropertyDetail(
          id: 'PROP-01',
          title: 'فيلا مارينا الساحل الشمالي',
          locationName: 'مارينا 5، الساحل الشمالي',
          unitType: 'فيلا كاملة',
        ),
        specialRequests:
            'نرجو توفير سرير إضافي للأطفال مع تسجيل وصول مبكر إن أمكن.',
      ),
      // 02: Pending Owner Review
      const CustomerBookingDetailRecord(
        id: 'BK-002',
        bookingNumber: 'BK-310482',
        propertyId: 'PROP-02',
        status: CanonicalBookingStatus.pendingOwnerApproval,
        checkInIso: '2026-11-12', // الخميس
        checkOutIso: '2026-11-15', // الأحد
        nights: 3,
        guestsCount: 6,
        nightlyPrice: 6000,
        totalStay: 18000, // 3 * 6,000
        depositAmount: 6000, // First night
        remainingAmount: 12000, // 18,000 - 6,000
        currency: 'ج.م',
        createdAt: '14 أكتوبر 2026',
        property: BookingPropertyDetail(
          id: 'PROP-02',
          title: 'شقة شاطئية لوران مطلة على البحر',
          locationName: 'لوران، كورنيش الإسكندرية',
          unitType: 'شقة فندقية',
        ),
      ),
      // 03: Confirmed Stay
      const CustomerBookingDetailRecord(
        id: 'BK-003',
        bookingNumber: 'BK-441029',
        propertyId: 'PROP-03',
        status: CanonicalBookingStatus.confirmed,
        checkInIso: '2026-11-18', // الأربعاء
        checkOutIso: '2026-11-22', // الأحد
        nights: 4,
        guestsCount: 2,
        nightlyPrice: 4000,
        totalStay: 16000, // 4 * 4,000
        depositAmount: 4000, // First night
        remainingAmount: 12000, // 16,000 - 4,000
        currency: 'ج.م',
        createdAt: '10 أكتوبر 2026',
        property: BookingPropertyDetail(
          id: 'PROP-03',
          title: 'ستوديو الإسكندرية ستانلي بإطلالة مباشرة',
          locationName: 'ستانلي، الإسكندرية',
          unitType: 'ستوديو خاص',
        ),
        specialRequests: 'الدخول بعد الساعة 2:00 ظهراً.',
      ),
      // 04: Cancelled by Guest
      const CustomerBookingDetailRecord(
        id: 'BK-004',
        bookingNumber: 'BK-108234',
        propertyId: 'PROP-04',
        status: CanonicalBookingStatus.cancelledByGuest,
        checkInIso: '2026-11-27', // الجمعة
        checkOutIso: '2026-11-30', // الاثنين
        nights: 3,
        guestsCount: 5,
        nightlyPrice: 2500,
        totalStay: 7500, // 3 * 2,500
        depositAmount: 2500, // First night
        remainingAmount: 5000, // 7,500 - 2,500
        currency: 'ج.م',
        createdAt: '08 أكتوبر 2026',
        property: BookingPropertyDetail(
          id: 'PROP-04',
          title: 'شاليه أمواج سيدي عبد الرحمن',
          locationName: 'أمواج، الساحل الشمالي',
          unitType: 'شاليه عائلي',
        ),
        cancelledAt: '12 أكتوبر 2026',
        cancellationReason: 'تغيير في مواعيد السفر العائلية.',
      ),
      // 05: Unknown Status Fallback
      const CustomerBookingDetailRecord(
        id: 'BK-005',
        bookingNumber: 'BK-772105',
        propertyId: 'PROP-05',
        status: CanonicalBookingStatus.unknown,
        checkInIso: '2026-12-03', // الخميس
        checkOutIso: '2026-12-05', // السبت
        nights: 2,
        guestsCount: 3,
        nightlyPrice: 3000,
        totalStay: 6000, // 2 * 3,000
        depositAmount: 3000, // First night
        remainingAmount: 3000, // 6,000 - 3,000
        currency: 'ج.م',
        createdAt: '11 أكتوبر 2026',
        property: BookingPropertyDetail(
          id: 'PROP-05',
          title: 'شقة المعمورة الشاطئ المميزة',
          locationName: 'المعمورة الشاطئ، الإسكندرية',
          unitType: 'شقة مصيفية',
        ),
      ),
      // 06: Long Property Title & Long Code Edge Case
      const CustomerBookingDetailRecord(
        id: 'BK-006',
        bookingNumber: 'BK-20261014-EG-ALX-98412-EXTENDED',
        propertyId: 'PROP-06',
        status: CanonicalBookingStatus.approvedPendingPayment,
        checkInIso: '2027-01-10', // الأحد
        checkOutIso: '2027-01-16', // السبت
        nights: 6,
        guestsCount: 8,
        nightlyPrice: 8500,
        totalStay: 51000, // 6 * 8,500
        depositAmount: 8500, // First night
        remainingAmount: 42500, // 51,000 - 8,500
        currency: 'ج.م',
        createdAt: '14 أكتوبر 2026',
        property: BookingPropertyDetail(
          id: 'PROP-06',
          title:
              'فيلا فاخرة صف أول على البحر مباشرة مع مسبح خاص وحديقة واسعة بمنتجع مراسي خليج سيدي عبد الرحمن',
          locationName: 'مراسي، خليج سيدي عبد الرحمن، الساحل الشمالي',
          unitType: 'فيلا شاطئية مستقلة',
        ),
        specialRequests:
            'طلب تجهيز المسبح الخاص، وخدمة تنظيف يومية، ومقاعد شاطئ إضافية للعائلة.',
      ),
    ];
  }

  /// Programmatic math assertion: validates flat-rate pricing & civil date truth
  static void assertFixtureIntegrity(
      List<CustomerBookingDetailRecord> fixtures) {
    for (final b in fixtures) {
      // 1. Math reconciliation
      final expectedTotal = b.nightlyPrice * b.nights;
      assert(
        b.totalStay == expectedTotal,
        'CRITICAL: Total stay math mismatch for ${b.bookingNumber}: expected $expectedTotal, got ${b.totalStay}',
      );
      assert(
        b.depositAmount == b.nightlyPrice,
        'CRITICAL: First-night deposit mismatch for ${b.bookingNumber}: expected ${b.nightlyPrice}, got ${b.depositAmount}',
      );
      assert(
        b.remainingAmount == b.totalStay - b.depositAmount,
        'CRITICAL: Remaining amount mismatch for ${b.bookingNumber}: expected ${b.totalStay - b.depositAmount}, got ${b.remainingAmount}',
      );

      // 2. Civil calendar reconciliation
      final d1 = b.checkInDateTime;
      final d2 = b.checkOutDateTime;
      assert(d2.isAfter(d1),
          'CRITICAL: checkOut must be after checkIn for ${b.bookingNumber}');
      final diff = d2.difference(d1).inDays;
      assert(diff == b.nights,
          'CRITICAL: Date difference $diff != nights ${b.nights} for ${b.bookingNumber}');
    }

    // 3. Explicit weekday assertions for the 4 previously failing examples
    final f1 = fixtures[0]; // 2026-10-20 to 2026-10-25
    assert(f1.checkInFormatted.startsWith('الثلاثاء'),
        'Regression: 2026-10-20 must be الثلاثاء, got ${f1.checkInFormatted}');
    assert(f1.checkOutFormatted.startsWith('الأحد'),
        'Regression: 2026-10-25 must be الأحد, got ${f1.checkOutFormatted}');

    final f6 = fixtures[5]; // 2027-01-10 to 2027-01-16
    assert(f6.checkInFormatted.startsWith('الأحد'),
        'Regression: 2027-01-10 must be الأحد, got ${f6.checkInFormatted}');
    assert(f6.checkOutFormatted.startsWith('السبت'),
        'Regression: 2027-01-16 must be السبت, got ${f6.checkOutFormatted}');
  }
}

// -----------------------------------------------------------------------------
// Scenarios Enumeration (14 Deterministic States + Transition Simulation)
// -----------------------------------------------------------------------------

enum Screen13Scenario {
  pendingOwnerApproval('01. قيد مراجعة المالك (لا دفع الآن)'),
  approvedPendingPayment('02. العربون مطلوب (العربون أعلى الزر بالطي الأول)'),
  confirmedStay('03. الحجز مؤكد (العربون مسدد)'),
  cancelledHistorical('04. حجز ملغي (بيانات تاريخية للقراءة فقط)'),
  unknownStatusFallback('05. حالة مجهولة (معالجة آمنة ودعم العملاء)'),
  longTitleAndCode('06. اسم طويل وكود ممتد (التحقق من الالتفاف)'),
  accessibility200Top('07. إمكانية الوصول 200% (أعلى الصفحة)'),
  accessibility200Scrolled('08. إمكانية الوصول 200% (أسفل الصفحة والزر)'),
  initialLoadingSkeleton('09. هيكل التحميل الصادق (Skeleton)'),
  unauthorizedSessionExpired('10. انتهت الجلسة 401 (حجب تام للبيانات)'),
  staleCacheRefreshNotice('11. تنبيه التحديث الفاشل (تعطيل الدفع الهادئ)'),
  forbiddenAccessDenied('12. غير مصرح 403 (حجب آمن دون كشف ملكية)'),
  notFoundBooking('13. الحجز غير موجود 404 (وجهة محايدة آمنة)'),
  noCacheErrorWithRetry('14. خطأ شبكة دون كاش (إعادة المحاولة النزيهة)');

  const Screen13Scenario(this.label);
  final String label;
}

// -----------------------------------------------------------------------------
// Screen 13 V2 Preview App Harness
// -----------------------------------------------------------------------------

class Screen13PreviewApp extends StatefulWidget {
  const Screen13PreviewApp({super.key});

  @override
  State<Screen13PreviewApp> createState() => _Screen13PreviewAppState();
}

class _Screen13PreviewAppState extends State<Screen13PreviewApp> {
  Screen13Scenario _scenario = Screen13Scenario.pendingOwnerApproval;
  bool _showQaBar = false; // Clean physical captures by default
  bool _isPurgedDueToSimulated401 = false; // Dynamic transition flag
  final FocusNode _focusNode = FocusNode();

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
    super.dispose();
  }

  void _setScenario(Screen13Scenario scenario) {
    setState(() {
      _scenario = scenario;
      _isPurgedDueToSimulated401 = false;
    });
  }

  void _triggerSimulated401Purge() {
    setState(() {
      _isPurgedDueToSimulated401 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isA11y = _scenario == Screen13Scenario.accessibility200Top ||
        _scenario == Screen13Scenario.accessibility200Scrolled;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit1 ||
              event.logicalKey == LogicalKeyboardKey.numpad1) {
            _setScenario(Screen13Scenario.pendingOwnerApproval);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
              event.logicalKey == LogicalKeyboardKey.numpad2) {
            _setScenario(Screen13Scenario.approvedPendingPayment);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.numpad3) {
            _setScenario(Screen13Scenario.confirmedStay);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            _setScenario(Screen13Scenario.cancelledHistorical);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit5 ||
              event.logicalKey == LogicalKeyboardKey.numpad5) {
            _setScenario(Screen13Scenario.unknownStatusFallback);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit6 ||
              event.logicalKey == LogicalKeyboardKey.numpad6) {
            _setScenario(Screen13Scenario.longTitleAndCode);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit7 ||
              event.logicalKey == LogicalKeyboardKey.numpad7) {
            _setScenario(Screen13Scenario.accessibility200Top);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit8 ||
              event.logicalKey == LogicalKeyboardKey.numpad8) {
            _setScenario(Screen13Scenario.accessibility200Scrolled);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit9 ||
              event.logicalKey == LogicalKeyboardKey.numpad9) {
            _setScenario(Screen13Scenario.initialLoadingSkeleton);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit0 ||
              event.logicalKey == LogicalKeyboardKey.numpad0) {
            _setScenario(Screen13Scenario.unauthorizedSessionExpired);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
            _setScenario(Screen13Scenario.staleCacheRefreshNotice);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyB) {
            _setScenario(Screen13Scenario.forbiddenAccessDenied);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
            _setScenario(Screen13Scenario.notFoundBooking);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
            _setScenario(Screen13Scenario.noCacheErrorWithRetry);
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
        title: 'KONFRM Screen 13 V2 Preview',
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
                child: Screen13HarnessBody(
                  scenario: _scenario,
                  isPurgedDueToSimulated401: _isPurgedDueToSimulated401,
                  onScenarioChanged: _setScenario,
                  onTriggerSimulatedPurge: _triggerSimulated401Purge,
                ),
              ),
              // Floating QA Scenario Selector (toggled via Q key or button)
              if (_showQaBar)
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 12,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF111827).withValues(alpha: 0.94),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Row(
                        children: [
                          const Text(
                            'السيناريو:',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Screen13Scenario>(
                                value: _scenario,
                                isExpanded: true,
                                dropdownColor: const Color(0xFF1F2937),
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                items: Screen13Scenario.values.map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                      s.label,
                                      style: const TextStyle(
                                        fontFamily: KonfrmTypography.fontFamily,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newScenario) {
                                  if (newScenario != null) {
                                    _setScenario(newScenario);
                                  }
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white70, size: 18),
                            onPressed: () =>
                                setState(() => _showQaBar = false),
                            tooltip: 'إخفاء شريط الاختبار',
                          ),
                        ],
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
// Harness Body: Resolves Scenario into UI State
// -----------------------------------------------------------------------------

class Screen13HarnessBody extends StatelessWidget {
  const Screen13HarnessBody({
    super.key,
    required this.scenario,
    required this.isPurgedDueToSimulated401,
    required this.onScenarioChanged,
    required this.onTriggerSimulatedPurge,
  });

  final Screen13Scenario scenario;
  final bool isPurgedDueToSimulated401;
  final ValueChanged<Screen13Scenario> onScenarioChanged;
  final VoidCallback onTriggerSimulatedPurge;

  @override
  Widget build(BuildContext context) {
    if (isPurgedDueToSimulated401) {
      // Dynamic test-only transition: sensitive data completely purged!
      return const Screen13UnauthorizedView(
        transitionNote: 'تم مسح وحجب بيانات الحجز بالكامل فور انتهاء الجلسة',
      );
    }

    final fixtures = Screen13SampleFixtures.getAllFixtures();

    switch (scenario) {
      case Screen13Scenario.pendingOwnerApproval:
        return Screen13DetailView(
          booking: fixtures[1], // PENDING_OWNER_APPROVAL
          loadState: Screen13LoadState.loaded,
        );
      case Screen13Scenario.approvedPendingPayment:
        return Screen13DetailView(
          booking: fixtures[0], // APPROVED_PENDING_PAYMENT
          loadState: Screen13LoadState.loaded,
        );
      case Screen13Scenario.confirmedStay:
        return Screen13DetailView(
          booking: fixtures[2], // CONFIRMED
          loadState: Screen13LoadState.loaded,
        );
      case Screen13Scenario.cancelledHistorical:
        return Screen13DetailView(
          booking: fixtures[3], // CANCELLED_BY_GUEST
          loadState: Screen13LoadState.loaded,
        );
      case Screen13Scenario.unknownStatusFallback:
        return Screen13DetailView(
          booking: fixtures[4], // UNKNOWN
          loadState: Screen13LoadState.loaded,
        );
      case Screen13Scenario.longTitleAndCode:
        return Screen13DetailView(
          booking: fixtures[5], // Long title & code
          loadState: Screen13LoadState.loaded,
        );
      case Screen13Scenario.accessibility200Top:
        return Screen13DetailView(
          booking: fixtures[0], // APPROVED_PENDING_PAYMENT
          loadState: Screen13LoadState.loaded,
          initialScrollOffset: 0.0,
        );
      case Screen13Scenario.accessibility200Scrolled:
        return Screen13DetailView(
          booking: fixtures[0], // APPROVED_PENDING_PAYMENT
          loadState: Screen13LoadState.loaded,
          initialScrollOffset: 700.0,
        );
      case Screen13Scenario.initialLoadingSkeleton:
        return const Screen13SkeletonView();
      case Screen13Scenario.unauthorizedSessionExpired:
        return const Screen13UnauthorizedView();
      case Screen13Scenario.staleCacheRefreshNotice:
        return Screen13DetailView(
          booking: fixtures[0],
          loadState: Screen13LoadState.staleError,
        );
      case Screen13Scenario.forbiddenAccessDenied:
        return const Screen13ForbiddenView();
      case Screen13Scenario.notFoundBooking:
        return const Screen13NotFoundView();
      case Screen13Scenario.noCacheErrorWithRetry:
        return const Screen13NoCacheErrorView();
    }
  }
}

// -----------------------------------------------------------------------------
// Canonical Screen 13 Booking Details / Stay Hub View (V2 Refined)
// -----------------------------------------------------------------------------

class Screen13DetailView extends StatefulWidget {
  const Screen13DetailView({
    super.key,
    required this.booking,
    required this.loadState,
    this.initialScrollOffset = 0.0,
  });

  final CustomerBookingDetailRecord booking;
  final Screen13LoadState loadState;
  final double initialScrollOffset;

  @override
  State<Screen13DetailView> createState() => _Screen13DetailViewState();
}

class _Screen13DetailViewState extends State<Screen13DetailView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController(initialScrollOffset: widget.initialScrollOffset);
  }

  @override
  void didUpdateWidget(Screen13DetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialScrollOffset != oldWidget.initialScrollOffset &&
        _scrollController.hasClients) {
      _scrollController.jumpTo(widget.initialScrollOffset);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showDemoFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '[معاينة تجريبية] $message',
          style: const TextStyle(fontFamily: KonfrmTypography.fontFamily),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: const Color(0xFF111827),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regExp, (match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    final statusPres = getScreen13StatusPresentation(widget.booking.status);
    final financePres = getScreen13FinancePresentation(widget.booking.status);
    final textScaler = MediaQuery.textScalerOf(context);
    final isA11yScale = textScaler.scale(1.0) > 1.3;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      // Top App Bar with RTL Back to 'حجوزاتي'
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => _showDemoFeedback(
              context, 'العودة إلى شاشة حجوزاتي (Screen 12)'),
          tooltip: 'الرجوع إلى حجوزاتي',
        ),
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF111827)),
            onPressed: () => _showDemoFeedback(
                context, 'طلب تحديث حالة الحجز من الخادم'),
            tooltip: 'تحديث بيانات الحجز',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Stale Cache Refresh Notice Banner (MR-17 Compliant Neutrality)
              if (widget.loadState == Screen13LoadState.staleError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF4B5563),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تعذر تحديث حالة الحجز. آخر بيانات تم تحميلها ما زالت ظاهرة.',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: isA11yScale ? 13 : 12,
                              color: const Color(0xFF374151),
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _showDemoFeedback(
                              context, 'إعادة محاولة تحديث بيانات الحجز'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF111827),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Status Hero Card (First-Fold Decision & Deposit Clarity)
              _buildStatusHeroCard(
                context,
                statusPres,
                isA11yScale,
                isStale: widget.loadState == Screen13LoadState.staleError,
              ),

              const SizedBox(height: 16),

              // 3. Property Identity Card
              _buildPropertyCard(context, widget.booking.property, isA11yScale),

              const SizedBox(height: 16),

              // 4. Stay Details Card (Anti-Card-Soup: Soft fills, no nested borders)
              _buildStayDetailsCard(context, widget.booking, isA11yScale),

              const SizedBox(height: 16),

              // 5. Financial Summary Card (Calm context, flat-rate pricing)
              _buildFinancialSummaryCard(
                  context, widget.booking, financePres, isA11yScale),

              const SizedBox(height: 16),

              // 6. Booking Reference & Timestamp Card
              _buildBookingReferenceCard(context, widget.booking, isA11yScale),

              // 7. Optional Special Requests Card
              if (widget.booking.specialRequests != null &&
                  widget.booking.specialRequests!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSpecialRequestsCard(
                    context, widget.booking.specialRequests!, isA11yScale),
              ],

              // 8. Optional Read-Only Cancellation Card
              if (widget.booking.cancelledAt != null) ...[
                const SizedBox(height: 16),
                _buildCancellationDetailsCard(context, widget.booking, isA11yScale),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 1: Status Hero Card (Includes Deposit Amount in First Fold)
  // ---------------------------------------------------------------------------
  Widget _buildStatusHeroCard(
    BuildContext context,
    Screen13StatusPresentation pres,
    bool isA11yScale, {
    required bool isStale,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: pres.badgeBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: pres.badgeBorderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pres.customerLabel,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: pres.badgeTextColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(pres.icon, size: 14, color: pres.badgeTextColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status Headline
          Text(
            pres.headline,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: isA11yScale ? 18 : 17,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Status Explanatory Copy
          Text(
            pres.supportingCopy,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: isA11yScale ? 14 : 13,
              color: const Color(0xFF4B5563),
              height: 1.5,
            ),
          ),

          // EXACT REPAIR D: Deposit Amount Prominently Displayed in First Fold Before CTA
          if (pres.hasPaymentCta) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: isA11yScale
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'العربون المطلوب للتأكيد:',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatAmount(widget.booking.depositAmount),
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.booking.currency,
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'العربون المطلوب للتأكيد:',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatAmount(widget.booking.depositAmount),
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.booking.currency,
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),

            // Black Primary CTA (minHeight: 48dp, 8px provisional radius per Issue #139)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: ElevatedButton(
                onPressed: isStale
                    ? () => _showDemoFeedback(context,
                        'زر الدفع معطل مؤقتًا حتى إعادة تحديث حالة الحجز للتأكد من حداثتها.')
                    : () => _showDemoFeedback(context,
                        'الانتقال إلى شاشة الدفع الآمن (Screen 14) — معاينة تجريبية فقط'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStale
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        isStale ? 'بانتظار تحديث الحالة...' : 'دفع العربون',
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isStale ? Icons.lock_outline : Icons.arrow_back,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                '* الحجز لم يُؤكّد بعد — يتطلب تأكيد الحجز سداد مبلغ العربون.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 2: Property Identity Card
  // ---------------------------------------------------------------------------
  Widget _buildPropertyCard(
      BuildContext context, BookingPropertyDetail prop, bool isA11yScale) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Geometric Icon Thumbnail Placeholder (Zero Unverified Trust Badges)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Center(
              child: Icon(
                Icons.apartment_outlined,
                size: 28,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prop.title,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: isA11yScale ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Color(0xFF6B7280)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        prop.locationName,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.home_work_outlined,
                        size: 14, color: Color(0xFF6B7280)),
                    const SizedBox(width: 4),
                    Text(
                      prop.unitType,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 3: Stay Details Card (Anti-Card-Soup: Soft fills, no nested borders)
  // ---------------------------------------------------------------------------
  Widget _buildStayDetailsCard(BuildContext context,
      CustomerBookingDetailRecord booking, bool isA11yScale) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تفاصيل الإقامة',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),

          // Date Blocks (Clean soft fill, NO inner card borders)
          if (!isA11yScale)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
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
                                size: 13, color: Color(0xFF6B7280)),
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
                          booking.checkInFormatted,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
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
                                size: 13, color: Color(0xFF6B7280)),
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
                          booking.checkOutFormatted,
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
            // Staced dates at 200% scaling
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الوصول:',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 2),
                  Text(booking.checkInFormatted,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المغادرة:',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  const SizedBox(height: 2),
                  Text(booking.checkOutFormatted,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827))),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 10),

          // Nights & Guests Occupancy Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.nights_stay_outlined,
                      size: 16, color: Color(0xFF4B5563)),
                  const SizedBox(width: 6),
                  Text(
                    '${booking.nights} ليالٍ',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              Container(width: 1, height: 16, color: const Color(0xFFE5E7EB)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people_outline,
                      size: 16, color: Color(0xFF4B5563)),
                  const SizedBox(width: 6),
                  Text(
                    '${booking.guestsCount} ضيوف',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 4: Financial Summary Card (Transparent & Calibrated)
  // ---------------------------------------------------------------------------
  Widget _buildFinancialSummaryCard(
      BuildContext context,
      CustomerBookingDetailRecord booking,
      Screen13FinancePresentation pres,
      bool isA11yScale) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تفاصيل الدفع',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),

          // Row 1: Total Stay (Flat-rate calculation)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'إجمالي الإقامة (${booking.nights} ليالٍ)',
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatAmount(booking.totalStay),
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    booking.currency,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Row 2: Deposit (When active)
          if (pres.showDeposit && pres.depositLabel != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pres.depositLabel!,
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: booking.status == CanonicalBookingStatus.confirmed
                          ? const Color(0xFF166534)
                          : const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatAmount(booking.depositAmount),
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: booking.status == CanonicalBookingStatus.confirmed
                            ? const Color(0xFF166534)
                            : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.currency,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

          // Row 3: Remaining Amount (No false "due at check-in" promise)
          if (pres.showRemaining && pres.remainingLabel != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pres.remainingLabel!,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatAmount(booking.remainingAmount),
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.currency,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

          // Pending Notice Row (Honest: No payment due now)
          if (pres.showPendingNotice) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'لا يوجد أي مبلغ مطلوب دفعه الآن.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 5: Booking Reference Card
  // ---------------------------------------------------------------------------
  Widget _buildBookingReferenceCard(BuildContext context,
      CustomerBookingDetailRecord booking, bool isA11yScale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.bookingNumber,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تاريخ الطلب:',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                booking.createdAt,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 6: Special Requests Card (Optional)
  // ---------------------------------------------------------------------------
  Widget _buildSpecialRequestsCard(
      BuildContext context, String requests, bool isA11yScale) {
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
            'ملاحظات خاصة:',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            requests,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Component 7: Read-Only Cancellation Card (Optional)
  // ---------------------------------------------------------------------------
  Widget _buildCancellationDetailsCard(BuildContext context,
      CustomerBookingDetailRecord booking, bool isA11yScale) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'بيانات الإلغاء',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          if (booking.cancelledAt != null)
            Text(
              'تاريخ الإلغاء: ${booking.cancelledAt}',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          if (booking.cancellationReason != null) ...[
            const SizedBox(height: 4),
            Text(
              'سبب الإلغاء: ${booking.cancellationReason}',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Component: Initial Loading Skeleton View (Honest, zero fake counts)
// -----------------------------------------------------------------------------

class Screen13SkeletonView extends StatelessWidget {
  const Screen13SkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () {},
          tooltip: 'الرجوع إلى حجوزاتي',
        ),
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
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
          children: [
            _buildSkeletonCard(height: 140),
            const SizedBox(height: 16),
            _buildSkeletonCard(height: 80),
            const SizedBox(height: 16),
            _buildSkeletonCard(height: 120),
            const SizedBox(height: 16),
            _buildSkeletonCard(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Component: Unauthorized 401 Session Expired View (Fail-Closed, zero leak)
// -----------------------------------------------------------------------------

class Screen13UnauthorizedView extends StatelessWidget {
  const Screen13UnauthorizedView({super.key, this.transitionNote});

  final String? transitionNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () {},
        ),
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
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
                  Icons.lock_clock_outlined,
                  size: 32,
                  color: Color(0xFF4B5563),
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
                'سجّل الدخول مرة أخرى لعرض تفاصيل هذا الحجز المحمي.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (transitionNote != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    transitionNote!,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
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

// -----------------------------------------------------------------------------
// Component: Forbidden 403 Access Denied View (Safe, zero data leak)
// -----------------------------------------------------------------------------

class Screen13ForbiddenView extends StatelessWidget {
  const Screen13ForbiddenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () {},
        ),
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
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
                  Icons.shield_outlined,
                  size: 32,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'لا تملك صلاحية عرض هذا الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هذا الحجز غير مرتبط بحسابك الحالي، أو ليس لديك إذن الوصول إليه.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'الرجوع إلى حجوزاتي',
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
// Component: Not Found 404 View (Neutral booking-not-found)
// -----------------------------------------------------------------------------

class Screen13NotFoundView extends StatelessWidget {
  const Screen13NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () {},
        ),
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
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
                  Icons.search_off_outlined,
                  size: 32,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'الحجز غير موجود',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'لم نتمكن من العثور على الحجز المطلوب. يُرجى التأكد من الرابط أو مراجعة قائمة حجوزاتك.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'الرجوع إلى حجوزاتي',
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
// Component: No-Cache Network Error View (Retry affordance, no fake data)
// -----------------------------------------------------------------------------

class Screen13NoCacheErrorView extends StatelessWidget {
  const Screen13NoCacheErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () {},
        ),
        title: const Text(
          'تفاصيل الحجز',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
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
                  Icons.wifi_off_outlined,
                  size: 32,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تعذر تحميل بيانات الحجز',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'حدث خطأ في الاتصال بالشبكة أثناء جلب تفاصيل الحجز. يُرجى التحقق من اتصالك بالإنترنت ثم إعادة المحاولة.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
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
