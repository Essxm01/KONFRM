import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen12PreviewApp());
}

// -----------------------------------------------------------------------------
// Canonical Booking Domain Types & Status Model
// -----------------------------------------------------------------------------

enum CanonicalBookingStatus {
  approvedPendingPayment('APPROVED_PENDING_PAYMENT'),
  pendingOwnerApproval('PENDING_OWNER_APPROVAL'),
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

enum BookingSection {
  actionRequired('يحتاج إجراء منك'),
  current('الحالية'),
  history('السابقة'),
  other('حجوزات أخرى');

  const BookingSection(this.title);
  final String title;
}

class BookingPresentation {
  const BookingPresentation({
    required this.customerLabel,
    this.supportingCopy,
    this.actionCue,
    required this.section,
    required this.icon,
    required this.isActionRequired,
    required this.badgeBgColor,
    required this.badgeBorderColor,
    required this.badgeTextColor,
  });

  final String customerLabel;
  final String? supportingCopy;
  final String? actionCue;
  final BookingSection section;
  final IconData icon;
  final bool isActionRequired;
  final Color badgeBgColor;
  final Color badgeBorderColor;
  final Color badgeTextColor;
}

BookingPresentation getBookingPresentation(CanonicalBookingStatus status) {
  switch (status) {
    case CanonicalBookingStatus.approvedPendingPayment:
      return const BookingPresentation(
        customerLabel: 'العربون مطلوب',
        supportingCopy: 'وافق المالك على الطلب. يمكنك الآن سداد العربون لتأكيد الحجز.',
        actionCue: 'مطلوب منك: دفع العربون',
        section: BookingSection.actionRequired,
        icon: Icons.credit_card_outlined,
        isActionRequired: true,
        badgeBgColor: Color(0xFFEFF6FF),
        badgeBorderColor: Color(0xFFBFDBFE),
        badgeTextColor: Color(0xFF1D4ED8),
      );
    case CanonicalBookingStatus.pendingOwnerApproval:
      return const BookingPresentation(
        customerLabel: 'قيد مراجعة المالك',
        supportingCopy: 'طلبك وصل إلى المالك وهو قيد المراجعة. لا يوجد دفع مطلوب الآن.',
        section: BookingSection.current,
        icon: Icons.schedule_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF1F5F9),
        badgeBorderColor: Color(0xFFE2E8F0),
        badgeTextColor: Color(0xFF334155),
      );
    case CanonicalBookingStatus.confirmed:
      return const BookingPresentation(
        customerLabel: 'الحجز مؤكد',
        supportingCopy: 'تم سداد العربون وتأكيد الحجز بنجاح.',
        section: BookingSection.current,
        icon: Icons.check_circle_outline,
        isActionRequired: false,
        badgeBgColor: Color(0xFFECFDF5),
        badgeBorderColor: Color(0xFFA7F3D0),
        badgeTextColor: Color(0xFF065F46),
      );
    case CanonicalBookingStatus.rejected:
      return const BookingPresentation(
        customerLabel: 'لم يوافق المالك',
        supportingCopy: 'نعتذر، لم يتمكن المالك من قبول هذا الطلب.',
        section: BookingSection.history,
        icon: Icons.cancel_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFFFF1F2),
        badgeBorderColor: Color(0xFFFECDD3),
        badgeTextColor: Color(0xFF9F1239),
      );
    case CanonicalBookingStatus.cancelledByGuest:
      return const BookingPresentation(
        customerLabel: 'ملغي من جانبك',
        section: BookingSection.history,
        icon: Icons.block_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF8FAFC),
        badgeBorderColor: Color(0xFFE2E8F0),
        badgeTextColor: Color(0xFF64748B),
      );
    case CanonicalBookingStatus.cancelledByOwner:
      return const BookingPresentation(
        customerLabel: 'ملغي من جانب المالك',
        section: BookingSection.history,
        icon: Icons.block_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF8FAFC),
        badgeBorderColor: Color(0xFFE2E8F0),
        badgeTextColor: Color(0xFF64748B),
      );
    case CanonicalBookingStatus.expired:
      return const BookingPresentation(
        customerLabel: 'انتهت صلاحية الطلب',
        section: BookingSection.history,
        icon: Icons.hourglass_empty_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF8FAFC),
        badgeBorderColor: Color(0xFFE2E8F0),
        badgeTextColor: Color(0xFF64748B),
      );
    case CanonicalBookingStatus.completed:
      return const BookingPresentation(
        customerLabel: 'إقامة مكتملة',
        section: BookingSection.history,
        icon: Icons.done_all_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF8FAFC),
        badgeBorderColor: Color(0xFFE2E8F0),
        badgeTextColor: Color(0xFF475569),
      );
    case CanonicalBookingStatus.unknown:
      return const BookingPresentation(
        customerLabel: 'حالة الحجز',
        section: BookingSection.other,
        icon: Icons.help_outline,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF8FAFC),
        badgeBorderColor: Color(0xFFE2E8F0),
        badgeTextColor: Color(0xFF64748B),
      );
  }
}

class CustomerBookingRecord {
  const CustomerBookingRecord({
    required this.id,
    required this.bookingNumber,
    required this.propertyId,
    required this.propertyTitle,
    required this.locationName,
    required this.checkInText,
    required this.checkOutText,
    required this.nights,
    required this.guestsCount,
    required this.status,
    required this.totalStay,
    required this.depositAmount,
  });

  final String id;
  final String bookingNumber;
  final String propertyId;
  final String propertyTitle;
  final String locationName;
  final String checkInText;
  final String checkOutText;
  final int nights;
  final int guestsCount;
  final CanonicalBookingStatus status;
  final double totalStay;
  final double depositAmount;
}

// -----------------------------------------------------------------------------
// Directionality-Isolated Monetary Price Display Widget (13,500 ج.م)
// -----------------------------------------------------------------------------

class DirectionalPriceText extends StatelessWidget {
  const DirectionalPriceText({
    super.key,
    required this.amount,
    this.currency = 'ج.م',
    this.style,
  });

  final num amount;
  final String currency;
  final TextStyle? style;

  static final _numberFormat = NumberFormat('#,##0.##', 'en');

  @override
  Widget build(BuildContext context) {
    final formatted = _numberFormat.format(amount);
    final defaultStyle = style ??
        const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            formatted,
            style: defaultStyle,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(width: 4),
          Text(
            currency,
            style: defaultStyle.copyWith(
              fontSize: (defaultStyle.fontSize ?? 14) * 0.9,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Preview Scenarios
// -----------------------------------------------------------------------------

enum Screen12Scenario {
  loadedActionRequired('01. محمل - إجراء مطلوب (Fold 1)'),
  loadedCurrentAndHistory('02. محمل - الحالية والسابقة (Scrolled)'),
  guestUnauthorized('03. جلسة زائر - غير مسجل'),
  sessionExpired('04. انتهت الجلسة - استعادة الدخول'),
  trueEmpty('05. قائمة فارغة حقيقية'),
  errorNoCache('06. تعذر التحميل - إعادة المحاولة'),
  staleRefreshError('07. خطأ تحديث مع بيانات محفوظة'),
  accessibility200('08. إمكانية الوصول 200% والتفاف الأسطر');

  const Screen12Scenario(this.label);
  final String label;
}

// -----------------------------------------------------------------------------
// Main Preview Application Harness
// -----------------------------------------------------------------------------

class Screen12PreviewApp extends StatefulWidget {
  const Screen12PreviewApp({super.key});

  @override
  State<Screen12PreviewApp> createState() => _Screen12PreviewAppState();
}

class _Screen12PreviewAppState extends State<Screen12PreviewApp> {
  Screen12Scenario _scenario = Screen12Scenario.loadedActionRequired;
  bool _showQaBar = false; // Hidden by default for pristine native captures
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

  void _setScenario(Screen12Scenario scenario) {
    setState(() {
      _scenario = scenario;
    });
    // For scrolled view, jump down to demonstrate Current and Past
    if (scenario == Screen12Scenario.loadedCurrentAndHistory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            360.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else if (scenario == Screen12Scenario.accessibility200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            160.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double textScale =
        _scenario == Screen12Scenario.accessibility200 ? 2.0 : 1.0;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit0 ||
              event.logicalKey == LogicalKeyboardKey.numpad0) {
            setState(() {
              _showQaBar = !_showQaBar;
            });
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit1 ||
              event.logicalKey == LogicalKeyboardKey.numpad1) {
            _setScenario(Screen12Scenario.loadedActionRequired);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
              event.logicalKey == LogicalKeyboardKey.numpad2) {
            _setScenario(Screen12Scenario.loadedCurrentAndHistory);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.numpad3) {
            _setScenario(Screen12Scenario.guestUnauthorized);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            _setScenario(Screen12Scenario.sessionExpired);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit5 ||
              event.logicalKey == LogicalKeyboardKey.numpad5) {
            _setScenario(Screen12Scenario.trueEmpty);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit6 ||
              event.logicalKey == LogicalKeyboardKey.numpad6) {
            _setScenario(Screen12Scenario.errorNoCache);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit7 ||
              event.logicalKey == LogicalKeyboardKey.numpad7) {
            _setScenario(Screen12Scenario.staleRefreshError);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit8 ||
              event.logicalKey == LogicalKeyboardKey.numpad8) {
            _setScenario(Screen12Scenario.accessibility200);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: KonfrmTypography.fontFamily,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 3,
            shadowColor: Colors.black12,
            indicatorColor: const Color(0xFFE2E8F0),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return IconThemeData(
                size: 24,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              );
            }),
          ),
        ),
        locale: const Locale('ar'),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textScale),
              ),
              child: child!,
            ),
          );
        },
        home: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Discreet QA Scenario Indicator / Switcher Bar (Toggle with 0 or tap header)
                if (_showQaBar) _buildQaBar(),

                // Screen 12 Scrollable Content
                Expanded(
                  child: _buildScenarioContent(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Discreet QA Switcher Bar
  // ---------------------------------------------------------------------------
  Widget _buildQaBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: Screen12Scenario.values.map((sc) {
            final isSelected = sc == _scenario;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () => _setScenario(sc),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    sc.label.split(' - ').first,
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Persistent 4-Destination Bottom Navigation Bar
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav() {
    final bool hasActionRequired = _scenario == Screen12Scenario.loadedActionRequired ||
        _scenario == Screen12Scenario.staleRefreshError ||
        _scenario == Screen12Scenario.accessibility200;

    return Semantics(
      container: true,
      child: NavigationBar(
        selectedIndex: 2, // 'حجوزاتي' is always selected on Screen 12
        onDestinationSelected: (idx) {
          if (idx == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('معاينة: تم النقر على تبويب استكشف'),
                duration: Duration(milliseconds: 900),
              ),
            );
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'استكشف',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: hasActionRequired
                ? Badge(
                    smallSize: 8,
                    backgroundColor: const Color(0xFF2563EB),
                    child: const Icon(Icons.calendar_month_outlined),
                  )
                : const Icon(Icons.calendar_month_outlined),
            selectedIcon: hasActionRequired
                ? Badge(
                    smallSize: 8,
                    backgroundColor: const Color(0xFF2563EB),
                    child: const Icon(Icons.calendar_month),
                  )
                : const Icon(Icons.calendar_month),
            label: 'حجوزاتي',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Scenario Content Router
  // ---------------------------------------------------------------------------
  Widget _buildScenarioContent() {
    switch (_scenario) {
      case Screen12Scenario.loadedActionRequired:
      case Screen12Scenario.loadedCurrentAndHistory:
      case Screen12Scenario.accessibility200:
        return _buildLoadedState(showStaleNotice: false);

      case Screen12Scenario.staleRefreshError:
        return _buildLoadedState(showStaleNotice: true);

      case Screen12Scenario.guestUnauthorized:
        return _buildGuestState();

      case Screen12Scenario.sessionExpired:
        return _buildSessionExpiredState();

      case Screen12Scenario.trueEmpty:
        return _buildTrueEmptyState();

      case Screen12Scenario.errorNoCache:
        return _buildErrorState();
    }
  }

  // ---------------------------------------------------------------------------
  // Top Header: Title, Subtitle, and Trailing Refresh Action
  // ---------------------------------------------------------------------------
  Widget _buildHeader({bool showRefresh = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showQaBar = !_showQaBar;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حجوزاتي',
                    style: KonfrmTypography.pageTitle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تابع طلباتك وإقاماتك من مكان واحد.',
                    style: KonfrmTypography.body.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showRefresh)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إرسال طلب تحديث الحجوزات'),
                      duration: Duration(milliseconds: 900),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                  color: Color(0xFF334155),
                ),
                tooltip: 'تحديث الحجوزات',
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // State A: Loaded State (Action Required + Current + History)
  // ---------------------------------------------------------------------------
  Widget _buildLoadedState({required bool showStaleNotice}) {
    final fixtures = _getSampleBookings();

    final actionRequiredList = fixtures
        .where((b) => b.status == CanonicalBookingStatus.approvedPendingPayment)
        .toList();

    final currentList = fixtures
        .where((b) =>
            b.status == CanonicalBookingStatus.pendingOwnerApproval ||
            b.status == CanonicalBookingStatus.confirmed)
        .toList();

    final historyList = fixtures
        .where((b) =>
            b.status == CanonicalBookingStatus.rejected ||
            b.status == CanonicalBookingStatus.completed ||
            b.status == CanonicalBookingStatus.cancelledByGuest ||
            b.status == CanonicalBookingStatus.cancelledByOwner ||
            b.status == CanonicalBookingStatus.expired)
        .toList();

    final otherList = fixtures
        .where((b) => b.status == CanonicalBookingStatus.unknown)
        .toList();

    return ListView(
      controller: _scrollController,
      key: const Key('screen12-scroll-view'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Top Root Tab Header
        _buildHeader(showRefresh: true),

        // Stale Refresh Error Notice (MR-17 compliant: soft blue, no yellow)
        if (showStaleNotice) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xFF1D4ED8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تعذر تحديث الحجوزات. آخر بيانات متاحة ما زالت ظاهرة.',
                    style: KonfrmTypography.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(40, 32),
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Section 1: يحتاج إجراء منك (ONLY if approvedPendingPayment exists)
        if (actionRequiredList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.actionRequired.title,
            hasAccentDot: true,
          ),
          const SizedBox(height: 10),
          ...actionRequiredList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 20),
        ],

        // Section 2: الحالية (Pending Owner Approval & Confirmed)
        if (currentList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.current.title,
            hasAccentDot: false,
          ),
          const SizedBox(height: 10),
          ...currentList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 20),
        ],

        // Section 3: السابقة (History)
        if (historyList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.history.title,
            hasAccentDot: false,
          ),
          const SizedBox(height: 10),
          ...historyList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 20),
        ],

        // Section 4: حجوزات أخرى (Safe fallback for unknown statuses)
        if (otherList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.other.title,
            hasAccentDot: false,
          ),
          const SizedBox(height: 10),
          ...otherList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 20),
        ],

        // End of list breathing room
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool hasAccentDot,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: KonfrmTypography.sectionTitle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        if (hasAccentDot) ...[
          const SizedBox(width: 8),
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Booking Card Component (Editorial Native Grammar, 12px Radius)
  // ---------------------------------------------------------------------------
  Widget _buildBookingCard(BuildContext context, CustomerBookingRecord booking) {
    final presentation = getBookingPresentation(booking.status);
    final isActionRequired = presentation.isActionRequired;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActionRequired ? const Color(0xFFFBFDFF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActionRequired
              ? const Color(0xFF93C5FD)
              : const Color(0xFFE2E8F0),
          width: isActionRequired ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'معاينة: فتح تفاصيل الحجز (${booking.bookingNumber})',
                ),
                duration: const Duration(milliseconds: 900),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Details Row (Responsive to accessibility text scale)
                _buildCardHeader(context, booking, presentation),

                // Supporting Context Note (when applicable)
                if (presentation.supportingCopy != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActionRequired
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      presentation.supportingCopy!,
                      style: KonfrmTypography.body.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isActionRequired
                            ? const Color(0xFF1E40AF)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Bottom Lifecycle Financial Row & Detail Affordance
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    // Financial / Lifecycle Status Info
                    _buildCardFinancialSummary(booking, presentation),

                    // Detail Link (Arrow Strictly Points LEFT ← in RTL)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض التفاصيل',
                          style: KonfrmTypography.button.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          '←',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(
    BuildContext context,
    CustomerBookingRecord booking,
    BookingPresentation presentation,
  ) {
    final bool isA11y = _scenario == Screen12Scenario.accessibility200 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.3;

    if (isA11y) {
      // Accessible Vertical Reflow: Prevents squeezing text into narrow columns
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(presentation),
              _buildPropertyThumbnail(booking.propertyId),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            booking.propertyTitle,
            style: KonfrmTypography.cardTitle.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 14,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking.locationName,
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildDateChronologyRow(booking),
          const SizedBox(height: 6),
          Text(
            '${booking.nights} ليالٍ • ${booking.guestsCount} ضيوف',
            style: KonfrmTypography.supporting.copyWith(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      );
    }

    // Standard Scale Layout (Thumbnail on start, details column on end)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertyThumbnail(booking.propertyId),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      booking.propertyTitle,
                      style: KonfrmTypography.cardTitle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(presentation),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.locationName,
                      style: KonfrmTypography.body.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _buildDateChronologyRow(booking),
              const SizedBox(height: 4),
              Text(
                '${booking.nights} ليالٍ • ${booking.guestsCount} ضيوف',
                style: KonfrmTypography.supporting.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyThumbnail(String propertyId) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.villa_outlined,
            size: 32,
            color: Colors.blueGrey.shade300,
          ),
          Positioned(
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'موثق',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BookingPresentation presentation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: presentation.badgeBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: presentation.badgeBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            presentation.icon,
            size: 13,
            color: presentation.badgeTextColor,
          ),
          const SizedBox(width: 4),
          Text(
            presentation.customerLabel,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: presentation.badgeTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChronologyRow(CustomerBookingRecord booking) {
    // Chronology in Arabic flows right-to-left: Start Date → Arrow pointing LEFT ← → End Date
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          booking.checkInText,
          style: KonfrmTypography.numeric.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '←',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Text(
          booking.checkOutText,
          style: KonfrmTypography.numeric.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildCardFinancialSummary(
    CustomerBookingRecord booking,
    BookingPresentation presentation,
  ) {
    if (booking.status == CanonicalBookingStatus.approvedPendingPayment) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            presentation.actionCue ?? 'مطلوب منك: دفع العربون',
            style: KonfrmTypography.body.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(height: 2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'العربون: ',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              DirectionalPriceText(
                amount: booking.depositAmount,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (booking.status == CanonicalBookingStatus.pendingOwnerApproval) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'إجمالي الإقامة: ',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          DirectionalPriceText(
            amount: booking.totalStay,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      );
    }

    if (booking.status == CanonicalBookingStatus.confirmed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check,
            size: 15,
            color: Color(0xFF047857),
          ),
          const SizedBox(width: 4),
          Text(
            'تم تأكيد الحجز وسداد العربون',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF047857),
            ),
          ),
        ],
      );
    }

    // Default History / Other fallback
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'رقم الطلب: ',
          style: KonfrmTypography.supporting.copyWith(
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          booking.bookingNumber,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State B: Guest / Unauthorized Session
  // ---------------------------------------------------------------------------
  Widget _buildGuestState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(showRefresh: false),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 32,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'سجّل الدخول لعرض حجوزاتك',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'ستجد هنا طلبات الحجز والإقامات المرتبطة بحسابك فور تسجيل الدخول.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.5,
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
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // 6px Primary CTA
                    ),
                  ),
                  child: Text(
                    'تسجيل الدخول',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  'استكشف الإقامات كزائر',
                  style: KonfrmTypography.button.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State C: Session Expired (401/403 Recovery)
  // ---------------------------------------------------------------------------
  Widget _buildSessionExpiredState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(showRefresh: false),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: const Icon(
                  Icons.lock_clock_outlined,
                  size: 30,
                  color: Color(0xFFB91C1C),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'انتهت جلسة تسجيل الدخول',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'لحماية بياناتك، انتهت صلاحية الجلسة السابقة. يرجى تسجيل الدخول مجددًا لمتابعة طلباتك.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.5,
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
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // 6px Primary CTA
                    ),
                  ),
                  child: Text(
                    'تسجيل الدخول مجددًا',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State D: True Empty State (Authenticated with 0 Bookings)
  // ---------------------------------------------------------------------------
  Widget _buildTrueEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(showRefresh: true),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 30,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'لا توجد حجوزات بعد',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'بعد إرسال طلب حجز، سيظهر هنا مباشرة لتتابع مراجعة المالك وحالة الحجز أولاً بأول.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.5,
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
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // 6px Primary CTA
                    ),
                  ),
                  child: Text(
                    'استكشف الإقامات المتاحة',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State E: Network Error Without Cache
  // ---------------------------------------------------------------------------
  Widget _buildErrorState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(showRefresh: true),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: const Icon(
                  Icons.wifi_off_outlined,
                  size: 30,
                  color: Color(0xFFB91C1C),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'تعذر تحميل حجوزاتك',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'تحقق من الاتصال بالإنترنت وحاول مرة أخرى لتحديث قائمة الحجوزات.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.5,
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
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // 6px Primary CTA
                    ),
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Deterministic Synthetic Fixture Data
  // ---------------------------------------------------------------------------
  List<CustomerBookingRecord> _getSampleBookings() {
    return const [
      // 1. Action Required: APPROVED_PENDING_PAYMENT
      CustomerBookingRecord(
        id: 'bk-01-approved',
        bookingNumber: 'BK-8921',
        propertyId: 'prop-marassi-01',
        propertyTitle: 'شاليه فاخر برؤية بانورامية للبحر - مراسي',
        locationName: 'مراسي، الساحل الشمالي',
        checkInText: '20 أكتوبر',
        checkOutText: '25 أكتوبر 2026',
        nights: 5,
        guestsCount: 4,
        status: CanonicalBookingStatus.approvedPendingPayment,
        totalStay: 13500.0,
        depositAmount: 2700.0,
      ),

      // 2. Current Stay: PENDING_OWNER_APPROVAL
      CustomerBookingRecord(
        id: 'bk-02-pending',
        bookingNumber: 'BK-8944',
        propertyId: 'prop-marina-02',
        propertyTitle: 'فيلا مستقلة بحمام سباحة خاص - مارينا 5',
        locationName: 'مارينا 5، الساحل الشمالي',
        checkInText: '1 نوفمبر',
        checkOutText: '4 نوفمبر 2026',
        nights: 3,
        guestsCount: 6,
        status: CanonicalBookingStatus.pendingOwnerApproval,
        totalStay: 18000.0,
        depositAmount: 3600.0,
      ),

      // 3. Current Stay: CONFIRMED
      CustomerBookingRecord(
        id: 'bk-03-confirmed',
        bookingNumber: 'BK-7712',
        propertyId: 'prop-amwaj-03',
        propertyTitle: 'شقة شاطئية أنيقة بحديقة خاصة - أمواج',
        locationName: 'أمواج، الساحل الشمالي',
        checkInText: '15 نوفمبر',
        checkOutText: '18 نوفمبر 2026',
        nights: 3,
        guestsCount: 2,
        status: CanonicalBookingStatus.confirmed,
        totalStay: 7500.0,
        depositAmount: 1500.0,
      ),

      // 4. Past Stay: REJECTED
      CustomerBookingRecord(
        id: 'bk-04-rejected',
        bookingNumber: 'BK-6501',
        propertyId: 'prop-seashell-04',
        propertyTitle: 'توين هاوس شاطئي - سيشل',
        locationName: 'سيدي حنيش، الساحل الشمالي',
        checkInText: '10 سبتمبر',
        checkOutText: '14 سبتمبر 2026',
        nights: 4,
        guestsCount: 5,
        status: CanonicalBookingStatus.rejected,
        totalStay: 16000.0,
        depositAmount: 3200.0,
      ),

      // 5. Past Stay: COMPLETED
      CustomerBookingRecord(
        id: 'bk-05-completed',
        bookingNumber: 'BK-5198',
        propertyId: 'prop-hacienda-05',
        propertyTitle: 'بنتهاوس فاخر بإطلالة مائية - هاسيندا باي',
        locationName: 'هاسيندا باي، الساحل الشمالي',
        checkInText: '1 أغسطس',
        checkOutText: '6 أغسطس 2026',
        nights: 5,
        guestsCount: 4,
        status: CanonicalBookingStatus.completed,
        totalStay: 22500.0,
        depositAmount: 4500.0,
      ),
    ];
  }
}
