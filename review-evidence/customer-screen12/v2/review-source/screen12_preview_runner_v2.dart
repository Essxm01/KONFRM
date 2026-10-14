import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Self-test fixture math assertions prior to launching UI
  final fixtures = Screen12SampleFixtures.getSampleBookings();
  Screen12SampleFixtures.assertFixtureIntegrity(fixtures);
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

/// Near-Zero-Blue Restrained Presentation Model (Founder Directive)
BookingPresentation getBookingPresentation(CanonicalBookingStatus status) {
  switch (status) {
    case CanonicalBookingStatus.approvedPendingPayment:
      // High-contrast, authoritative dark neutral badge (near-zero-blue)
      return const BookingPresentation(
        customerLabel: 'العربون مطلوب',
        supportingCopy:
            'وافق المالك على طلب الحجز. يمكنك الآن مراجعة التفاصيل وسداد العربون لتأكيد إقامتك.',
        actionCue: 'العربون مطلوب لتأكيد الحجز',
        section: BookingSection.actionRequired,
        icon: Icons.assignment_turned_in_outlined,
        isActionRequired: true,
        badgeBgColor: Color(0xFF111827), // Solid dark slate / black
        badgeBorderColor: Color(0xFF111827),
        badgeTextColor: Colors.white,
      );
    case CanonicalBookingStatus.pendingOwnerApproval:
      return const BookingPresentation(
        customerLabel: 'قيد مراجعة المالك',
        supportingCopy:
            'طلبك وصل إلى المالك وهو قيد المراجعة. لا يوجد أي دفع مطلوب الآن.',
        section: BookingSection.current,
        icon: Icons.schedule_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF374151),
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
        badgeBgColor: Color(0xFFFEF2F2),
        badgeBorderColor: Color(0xFFFECDD3),
        badgeTextColor: Color(0xFF991B1B),
      );
    case CanonicalBookingStatus.cancelledByGuest:
      return const BookingPresentation(
        customerLabel: 'ملغي من جانبك',
        section: BookingSection.history,
        icon: Icons.block_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF9FAFB),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF6B7280),
      );
    case CanonicalBookingStatus.cancelledByOwner:
      return const BookingPresentation(
        customerLabel: 'ملغي من جانب المالك',
        section: BookingSection.history,
        icon: Icons.block_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF9FAFB),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF6B7280),
      );
    case CanonicalBookingStatus.expired:
      return const BookingPresentation(
        customerLabel: 'انتهت صلاحية الطلب',
        section: BookingSection.history,
        icon: Icons.hourglass_empty_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF9FAFB),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF6B7280),
      );
    case CanonicalBookingStatus.completed:
      return const BookingPresentation(
        customerLabel: 'إقامة مكتملة',
        section: BookingSection.history,
        icon: Icons.done_all_outlined,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF9FAFB),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF4B5563),
      );
    case CanonicalBookingStatus.unknown:
      return const BookingPresentation(
        customerLabel: 'حالة غير محددة',
        supportingCopy:
            'حالة هذا الحجز قيد التحديث في النظام. يمكنك مراجعة تفاصيل الطلب.',
        section: BookingSection.other,
        icon: Icons.help_outline,
        isActionRequired: false,
        badgeBgColor: Color(0xFFF3F4F6),
        badgeBorderColor: Color(0xFFE5E7EB),
        badgeTextColor: Color(0xFF4B5563),
      );
  }
}

// -----------------------------------------------------------------------------
// Typed Domain Booking Record & Strict Flat-Rate Math Verification
// -----------------------------------------------------------------------------

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
    required this.nightlyPrice,
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
  final double nightlyPrice;
  final double totalStay;
  final double depositAmount;
}

abstract final class Screen12SampleFixtures {
  static List<CustomerBookingRecord> getSampleBookings({
    bool includeUnknown = false,
  }) {
    return [
      // 1. Action Required: APPROVED_PENDING_PAYMENT
      // 5 nights * 2,700 EGP = 13,500 EGP; deposit (first night) = 2,700 EGP. (VALID)
      const CustomerBookingRecord(
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
        nightlyPrice: 2700.0,
        totalStay: 13500.0,
        depositAmount: 2700.0,
      ),

      // 2. Current Stay: PENDING_OWNER_APPROVAL
      // 3 nights * 6,000 EGP = 18,000 EGP; deposit (first night) = 6,000 EGP. (FIXED from 3,600)
      const CustomerBookingRecord(
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
        nightlyPrice: 6000.0,
        totalStay: 18000.0,
        depositAmount: 6000.0,
      ),

      // 3. Current Stay: CONFIRMED
      // 3 nights * 2,500 EGP = 7,500 EGP; deposit (first night) = 2,500 EGP. (FIXED from 1,500)
      const CustomerBookingRecord(
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
        nightlyPrice: 2500.0,
        totalStay: 7500.0,
        depositAmount: 2500.0,
      ),

      // 4. Past Stay: REJECTED
      // 4 nights * 4,000 EGP = 16,000 EGP; deposit (first night) = 4,000 EGP. (FIXED from 3,200)
      const CustomerBookingRecord(
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
        nightlyPrice: 4000.0,
        totalStay: 16000.0,
        depositAmount: 4000.0,
      ),

      // 5. Past Stay: COMPLETED
      // 5 nights * 4,500 EGP = 22,500 EGP; deposit (first night) = 4,500 EGP. (VALID)
      const CustomerBookingRecord(
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
        nightlyPrice: 4500.0,
        totalStay: 22500.0,
        depositAmount: 4500.0,
      ),

      if (includeUnknown)
        // 6. Unknown Status: UNKNOWN (FIX E requirement)
        // 2 nights * 3,000 EGP = 6,000 EGP; deposit (first night) = 3,000 EGP. (VALID)
        const CustomerBookingRecord(
          id: 'bk-06-unknown',
          bookingNumber: 'BK-9910',
          propertyId: 'prop-almaza-06',
          propertyTitle: 'فيلا مطلة على البحيرة - ألماظة باي',
          locationName: 'ألماظة باي، مرسى مطروح',
          checkInText: '20 ديسمبر',
          checkOutText: '22 ديسمبر 2026',
          nights: 2,
          guestsCount: 3,
          status: CanonicalBookingStatus.unknown,
          nightlyPrice: 3000.0,
          totalStay: 6000.0,
          depositAmount: 3000.0,
        ),
    ];
  }

  /// Automated assertion for uniform flat-rate quote integrity
  static void assertFixtureIntegrity(List<CustomerBookingRecord> fixtures) {
    for (final b in fixtures) {
      final double computedTotal = b.nightlyPrice * b.nights;
      if ((computedTotal - b.totalStay).abs() > 0.01) {
        throw StateError(
          'Fixture math mismatch for ${b.id}: ${b.nightlyPrice} * ${b.nights} != ${b.totalStay}',
        );
      }
      if ((b.depositAmount - b.nightlyPrice).abs() > 0.01) {
        throw StateError(
          'Fixture deposit mismatch for ${b.id}: deposit ${b.depositAmount} != nightly ${b.nightlyPrice}',
        );
      }
    }
  }
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
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
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
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Preview Scenarios Enumeration (10 Distinct States)
// -----------------------------------------------------------------------------

enum Screen12Scenario {
  loadedActionRequired('01. محمل - إجراء مطلوب (First Fold)'),
  loadedCurrentAndHistory('02. محمل - الحالية والسابقة (Scrolled)'),
  guestUnauthorized('03. جلسة زائر - غير مسجل'),
  sessionExpired('04. انتهت الجلسة - استعادة الدخول'),
  trueEmpty('05. قائمة فارغة حقيقية'),
  errorNoCache('06. تعذر التحميل - إعادة المحاولة'),
  staleRefreshError('07. تنبيه بيانات محفوظة محايد'),
  initialLoading('08. جاري التحميل الأولي (الهيكل)'),
  unknownStatus('09. حالة غير محددة (حجوزات أخرى)'),
  accessibility200('10. إمكانية الوصول 200% والتفاف الأسطر');

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
  bool _showQaBar = false; // Hidden by default for clean physical framebuffer captures
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
    // Scroll management for specific evaluation folds
    if (scenario == Screen12Scenario.loadedCurrentAndHistory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            340.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else if (scenario == Screen12Scenario.accessibility200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            140.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else if (scenario == Screen12Scenario.unknownStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 350),
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

    // Themed with near-zero-blue Customer styling:
    // NavigationBar uses neutral indicator and black active text/icon
    final previewTheme = konfrmLightTheme().copyWith(
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: const Color(0xFFF3F4F6), // Neutral soft grey indicator pill
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF000000));
          }
          return const IconThemeData(color: Color(0xFF6B7280));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            );
          }
          return const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          );
        }),
      ),
    );

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
            _setScenario(Screen12Scenario.initialLoading);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit9 ||
              event.logicalKey == LogicalKeyboardKey.numpad9) {
            _setScenario(Screen12Scenario.unknownStatus);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
            _setScenario(Screen12Scenario.accessibility200);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: previewTheme,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          );
        },
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // QA Scenario Bar (toggled via 0 or tap on header title)
                if (_showQaBar) _buildQaBar(),

                // Primary Screen Content
                Expanded(child: _buildScenarioContent()),
              ],
            ),
          ),
          // Canonical Root Bottom Navigation (Index 2 = Bookings)
          bottomNavigationBar: CustomerBottomNavigation(
            selectedIndex: 2, // 'حجوزاتي'
            onSelected: (index) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'معاينة: الانتقال إلى الوجهة (${customerDestinations[index]})',
                  ),
                  duration: const Duration(milliseconds: 700),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating QA Scenario Switcher (for device testing)
  // ---------------------------------------------------------------------------
  Widget _buildQaBar() {
    return Container(
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'لوحة اختبار Screen 12 V2 (A56)',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showQaBar = false;
                  });
                },
                icon: const Icon(Icons.close, size: 16, color: Colors.white70),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Screen12Scenario.values.map((s) {
                final isSelected = _scenario == s;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text(
                      s.label,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    backgroundColor: const Color(0xFF1F2937),
                    onSelected: (_) => _setScenario(s),
                  ),
                );
              }).toList(),
            ),
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
        return _buildLoadedState(showStaleNotice: false, includeUnknown: false);

      case Screen12Scenario.staleRefreshError:
        return _buildLoadedState(showStaleNotice: true, includeUnknown: false);

      case Screen12Scenario.unknownStatus:
        return _buildLoadedState(showStaleNotice: false, includeUnknown: true);

      case Screen12Scenario.initialLoading:
        return _buildInitialLoadingState();

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
      padding: const EdgeInsets.only(bottom: 20, top: 4),
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
                      color: const Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تابع طلباتك وإقاماتك من مكان واحد.',
                    style: KonfrmTypography.body.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
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
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: Color(0xFF374151),
                ),
                tooltip: 'تحديث الحجوزات',
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // State A: Loaded State (Action Required + Current + History + Optional Other)
  // ---------------------------------------------------------------------------
  Widget _buildLoadedState({
    required bool showStaleNotice,
    required bool includeUnknown,
  }) {
    final fixtures =
        Screen12SampleFixtures.getSampleBookings(includeUnknown: includeUnknown);

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Top Root Tab Header
        _buildHeader(showRefresh: true),

        // Stale Refresh Error Notice (Near-Zero-Blue: neutral grey strip, zero blue/yellow)
        if (showStaleNotice) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xFF4B5563),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تعذر تحديث الحجوزات حالياً. البيانات المحفوظة معروضة أدناه.',
                    style: KonfrmTypography.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('جاري إعادة المحاولة...'),
                        duration: Duration(milliseconds: 700),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(40, 32),
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
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
          const SizedBox(height: 12),
          ...actionRequiredList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 24),
        ],

        // Section 2: الحالية (Pending Owner Approval & Confirmed)
        if (currentList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.current.title,
            hasAccentDot: false,
          ),
          const SizedBox(height: 12),
          ...currentList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 24),
        ],

        // Section 3: السابقة (History)
        if (historyList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.history.title,
            hasAccentDot: false,
          ),
          const SizedBox(height: 12),
          ...historyList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 24),
        ],

        // Section 4: حجوزات أخرى (Safe fallback for unknown statuses)
        if (otherList.isNotEmpty) ...[
          _buildSectionHeader(
            title: BookingSection.other.title,
            hasAccentDot: false,
          ),
          const SizedBox(height: 12),
          ...otherList.map((b) => _buildBookingCard(context, b)),
          const SizedBox(height: 24),
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
            color: const Color(0xFF111827),
          ),
        ),
        if (hasAccentDot) ...[
          const SizedBox(width: 8),
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF111827), // Crisp black dot (zero blue)
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
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // High-contrast dark neutral for action-required; subtle grey for standard
          color: isActionRequired
              ? const Color(0xFF111827)
              : const Color(0xFFE5E7EB),
          width: isActionRequired ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
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

                // Supporting Context Note (Neutral, Zero-Blue)
                if (presentation.supportingCopy != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      presentation.supportingCopy!,
                      style: KonfrmTypography.body.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),

                // Bottom Lifecycle Financial Summary & Actions
                if (isActionRequired) ...[
                  // Action Required Card has a prominent, high-contrast CTA button
                  _buildActionRequiredBottomSection(booking, presentation),
                ] else ...[
                  // Standard Card Financial Row & Detail Affordance
                  _buildStandardBottomSection(booking, presentation),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionRequiredBottomSection(
    CustomerBookingRecord booking,
    BookingPresentation presentation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العربون المطلوب:',
                  style: KonfrmTypography.supporting.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                DirectionalPriceText(
                  amount: booking.depositAmount,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'إجمالي الإقامة:',
                  style: KonfrmTypography.supporting.copyWith(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                DirectionalPriceText(
                  amount: booking.totalStay,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Primary Black CTA Button (flexible height, min 48dp, 8px radius)
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'معاينة فقط: تفاصيل الحجز وسداد العربون لطلب ${booking.bookingNumber} (لا سداد حقيقي في النموذج)',
                    ),
                    duration: const Duration(milliseconds: 1000),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                backgroundColor: const Color(0xFF000000),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // 8px provisional radius
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'تفاصيل الحجز والسداد',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '←',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStandardBottomSection(
    CustomerBookingRecord booking,
    BookingPresentation presentation,
  ) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        // Financial / Lifecycle Status Info
        _buildCardFinancialSummary(booking, presentation),

        // Detail Link (Monochrome Black / Neutral, strictly LEFT arrow ←)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'عرض التفاصيل',
              style: KonfrmTypography.button.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827), // Neutral black (zero blue)
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '←',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ],
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
              color: const Color(0xFF111827),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 14,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking.locationName,
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
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
              color: const Color(0xFF6B7280),
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
                        color: const Color(0xFF111827),
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
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.locationName,
                      style: KonfrmTypography.body.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
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
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Property Thumbnail Placeholder without unverified 'موثق' badge (FIX D)
  Widget _buildPropertyThumbnail(String propertyId) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Center(
        child: Icon(
          Icons.apartment_outlined,
          size: 30,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BookingPresentation presentation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              fontFamily: KonfrmTypography.fontFamily,
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
            color: const Color(0xFF111827),
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
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Text(
          booking.checkOutText,
          style: KonfrmTypography.numeric.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildCardFinancialSummary(
    CustomerBookingRecord booking,
    BookingPresentation presentation,
  ) {
    if (booking.status == CanonicalBookingStatus.pendingOwnerApproval) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'إجمالي الإقامة: ',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
          DirectionalPriceText(
            amount: booking.totalStay,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
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

    if (booking.status == CanonicalBookingStatus.unknown) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'قيمة الطلب: ',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
          DirectionalPriceText(
            amount: booking.totalStay,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      );
    }

    // Default History fallback
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'رقم الطلب: ',
          style: KonfrmTypography.supporting.copyWith(
            fontSize: 11,
            color: const Color(0xFF6B7280),
          ),
        ),
        Text(
          booking.bookingNumber,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State B: Guest / Unauthorized Session (Comfortable Spacing, Zero Blue)
  // ---------------------------------------------------------------------------
  Widget _buildGuestState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _buildHeader(showRefresh: false),
        const SizedBox(height: 32),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 32,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'سجّل الدخول لعرض حجوزاتك',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'ستجد هنا طلبات الحجز والإقامات المرتبطة بحسابك فور تسجيل الدخول.',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('معاينة: الانتقال إلى شاشة الدخول Screen 08'),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 8px provisional
                      ),
                    ),
                    child: Text(
                      'تسجيل الدخول / إنشاء حساب',
                      style: KonfrmTypography.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('معاينة: الانتقال إلى شاشة الاستكشاف Screen 03'),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                  },
                  child: Text(
                    'استكشف الإقامات كزائر',
                    style: KonfrmTypography.button.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151), // Neutral dark (zero blue)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State C: Session Expired (Comfortable Spacing, Zero Blue)
  // ---------------------------------------------------------------------------
  Widget _buildSessionExpiredState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _buildHeader(showRefresh: false),
        const SizedBox(height: 32),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: const Icon(
                    Icons.lock_clock_outlined,
                    size: 32,
                    color: Color(0xFFB91C1C),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'انتهت جلسة تسجيل الدخول',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'لحماية بياناتك، انتهت صلاحية الجلسة السابقة. يرجى تسجيل الدخول مجددًا لمتابعة طلباتك.',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('معاينة: إعادة تسجيل الدخول'),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 8px provisional
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State D: True Empty State (Corrected Truthful Copy, Zero Blue)
  // ---------------------------------------------------------------------------
  Widget _buildTrueEmptyState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _buildHeader(showRefresh: true),
        const SizedBox(height: 36),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    size: 32,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'لا توجد حجوزات حالية',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'ستظهر هنا طلباتك وإقاماتك لتتابع حالة حجزك وموافقة المالك أولاً بأول.',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('معاينة: الانتقال إلى شاشة الاستكشاف Screen 03'),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 8px provisional
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State E: Network Error Without Cache (Zero Blue)
  // ---------------------------------------------------------------------------
  Widget _buildErrorState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _buildHeader(showRefresh: true),
        const SizedBox(height: 36),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: const Icon(
                    Icons.wifi_off_outlined,
                    size: 32,
                    color: Color(0xFFB91C1C),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'تعذر تحميل حجوزاتك',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'تحقق من الاتصال بالإنترنت وحاول مرة أخرى لتحديث قائمة الحجوزات.',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('جاري إعادة المحاولة...'),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 8px provisional
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // State F: Initial Loading Skeleton (FIX E requirement)
  // ---------------------------------------------------------------------------
  Widget _buildInitialLoadingState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _buildHeader(showRefresh: false),
        const SizedBox(height: 8),

        // Calm loading text indicator
        Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'جاري تحميل الحجوزات...',
              style: KonfrmTypography.body.copyWith(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Skeleton Card 1
        _buildSkeletonCard(),
        const SizedBox(height: 14),

        // Skeleton Card 2
        _buildSkeletonCard(),
        const SizedBox(height: 14),

        // Skeleton Card 3
        _buildSkeletonCard(),
      ],
    );
  }

  Widget _buildSkeletonCard() {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 140,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 90,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 70,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
