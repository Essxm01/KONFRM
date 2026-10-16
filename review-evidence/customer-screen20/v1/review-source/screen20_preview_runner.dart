// =============================================================================
// KONFRM Customer Screen 20 — Payment History («سجل المدفوعات»)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Design Authority: Cairo Typography, RTL First, Pure Monochrome & Neutrals
// Navigation Context: Nested Customer Destination (Canonical NESTED_CUSTOMER)
// Bottom Navigation: HIDDEN (Per canonical DESIGN_SYSTEM/COMPONENTS/navigation.md §3.3)
// Governing Issues:
//   - Issue #179 (Screen 20 Payment History Founder Execution Contract)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository Audit)
//   - Issue #174 (Notifications Navigation Routing Proposal vs Architecture)
//   - Issue #173 (Financial Model Meaning & Booking Lifecycle Boundaries)
//   - Issue #172 (Identity, Avatar, QR & Connected Profiles Boundaries)
//   - Issue #171 (Deferred Technical/QA Backlog for Screen 17 - Prelive Gate)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
//
// Scope: Isolated visual preview with synthetic scenarios. Zero production mutations.
// =============================================================================

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen20PreviewApp());
}

// =============================================================================
// Domain Models & Synthetic State
// =============================================================================

enum PaymentStatus {
  paid,
  pending,
  failed,
  reconciling,
  refunded,
}

extension PaymentStatusDetails on PaymentStatus {
  String get labelArabic {
    switch (this) {
      case PaymentStatus.paid:
        return 'مكتمل';
      case PaymentStatus.pending:
        return 'قيد المعالجة';
      case PaymentStatus.failed:
        return 'غير ناجح';
      case PaymentStatus.reconciling:
        return 'قيد المطابقة';
      case PaymentStatus.refunded:
        return 'مسترد';
    }
  }

  IconData get iconData {
    switch (this) {
      case PaymentStatus.paid:
        return Icons.check_circle_outline_rounded;
      case PaymentStatus.pending:
        return Icons.access_time_rounded;
      case PaymentStatus.failed:
        return Icons.highlight_off_rounded;
      case PaymentStatus.reconciling:
        return Icons.sync_rounded;
      case PaymentStatus.refunded:
        return Icons.replay_rounded;
    }
  }

  Color get textColor {
    switch (this) {
      case PaymentStatus.paid:
        return const Color(0xFF065F46); // Emerald 800
      case PaymentStatus.pending:
        return const Color(0xFF92400E); // Amber 800
      case PaymentStatus.failed:
        return const Color(0xFF991B1B); // Red 800
      case PaymentStatus.reconciling:
        return const Color(0xFF1E40AF); // Blue 800
      case PaymentStatus.refunded:
        return const Color(0xFF3730A3); // Indigo 800
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PaymentStatus.paid:
        return const Color(0xFFECFDF5); // Emerald 50
      case PaymentStatus.pending:
        return const Color(0xFFFEF3C7); // Amber 50
      case PaymentStatus.failed:
        return const Color(0xFFFEE2E2); // Red 50
      case PaymentStatus.reconciling:
        return const Color(0xFFEFF6FF); // Blue 50
      case PaymentStatus.refunded:
        return const Color(0xFFEEF2FF); // Indigo 50
    }
  }

  Color get borderColor {
    switch (this) {
      case PaymentStatus.paid:
        return const Color(0xFFA7F3D0); // Emerald 200
      case PaymentStatus.pending:
        return const Color(0xFFFDE68A); // Amber 200
      case PaymentStatus.failed:
        return const Color(0xFFFECACA); // Red 200
      case PaymentStatus.reconciling:
        return const Color(0xFFBFDBFE); // Blue 200
      case PaymentStatus.refunded:
        return const Color(0xFFC7D2FE); // Indigo 200
    }
  }
}

class PaymentTransactionItem {
  final String id;
  final String bookingReference;
  final String propertyTitle;
  final String typeLabel;
  final String dateFormatted;
  final String monthGroup;
  final double amountEgp;
  final PaymentStatus status;
  final String paymentMethodLabel;
  final String providerReference;
  final String statusExplanation;
  final bool isSynthetic;

  const PaymentTransactionItem({
    required this.id,
    required this.bookingReference,
    required this.propertyTitle,
    required this.typeLabel,
    required this.dateFormatted,
    required this.monthGroup,
    required this.amountEgp,
    required this.status,
    required this.paymentMethodLabel,
    required this.providerReference,
    required this.statusExplanation,
    this.isSynthetic = true,
  });
}

enum PaymentHistoryFilter {
  all,
  paid,
  pending,
  other,
}

extension PaymentHistoryFilterMetadata on PaymentHistoryFilter {
  String get labelArabic {
    switch (this) {
      case PaymentHistoryFilter.all:
        return 'الكل';
      case PaymentHistoryFilter.paid:
        return 'مكتمل';
      case PaymentHistoryFilter.pending:
        return 'قيد المعالجة';
      case PaymentHistoryFilter.other:
        return 'المطابقة والمسترد';
    }
  }
}

class CustomerPaymentHistoryState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool hasNetworkError;
  final List<PaymentTransactionItem> transactions;
  final PaymentHistoryFilter selectedFilter;
  final PaymentTransactionItem? selectedTransactionForSheet;

  const CustomerPaymentHistoryState({
    this.isAuthenticated = true,
    this.isLoading = false,
    this.hasNetworkError = false,
    this.transactions = const [],
    this.selectedFilter = PaymentHistoryFilter.all,
    this.selectedTransactionForSheet,
  });

  CustomerPaymentHistoryState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? hasNetworkError,
    List<PaymentTransactionItem>? transactions,
    PaymentHistoryFilter? selectedFilter,
    PaymentTransactionItem? Function()? selectedTransactionForSheet,
  }) {
    return CustomerPaymentHistoryState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      hasNetworkError: hasNetworkError ?? this.hasNetworkError,
      transactions: transactions ?? this.transactions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedTransactionForSheet: selectedTransactionForSheet != null
          ? selectedTransactionForSheet()
          : this.selectedTransactionForSheet,
    );
  }

  List<PaymentTransactionItem> get filteredTransactions {
    switch (selectedFilter) {
      case PaymentHistoryFilter.all:
        return transactions;
      case PaymentHistoryFilter.paid:
        return transactions.where((t) => t.status == PaymentStatus.paid).toList();
      case PaymentHistoryFilter.pending:
        return transactions.where((t) => t.status == PaymentStatus.pending).toList();
      case PaymentHistoryFilter.other:
        return transactions
            .where((t) =>
                t.status == PaymentStatus.reconciling ||
                t.status == PaymentStatus.refunded ||
                t.status == PaymentStatus.failed)
            .toList();
    }
  }

  Map<String, List<PaymentTransactionItem>> get groupedTransactions {
    final map = <String, List<PaymentTransactionItem>>{};
    for (final item in filteredTransactions) {
      map.putIfAbsent(item.monthGroup, () => []).add(item);
    }
    return map;
  }
}

// =============================================================================
// Synthetic Fixtures (MR-13 Compliant First-Night Deposit)
// =============================================================================

final List<PaymentTransactionItem> kSyntheticPaymentTransactions = [
  const PaymentTransactionItem(
    id: 'TXN-2026-881249',
    bookingReference: 'BK-183223',
    propertyTitle: 'فيلا لؤلؤة البحر — مراسي',
    typeLabel: 'عربون الليلة الأولى (MR-13)',
    dateFormatted: '14 أكتوبر 2026 • 03:45 م',
    monthGroup: 'أكتوبر 2026',
    amountEgp: 1450.0,
    status: PaymentStatus.paid,
    paymentMethodLabel: 'بطاقة ائتمانية •••• 4242',
    providerReference: 'PAYMOB-EGY-TEST-90112',
    statusExplanation: 'تم تحصيل عربون الليلة الأولى بنجاح عقب موافقة المالك.',
  ),
  const PaymentTransactionItem(
    id: 'TXN-2026-881104',
    bookingReference: 'BK-908747',
    propertyTitle: 'شقة شاطئية أنيقة — مارينا 5',
    typeLabel: 'عربون الليلة الأولى (MR-13)',
    dateFormatted: '12 أكتوبر 2026 • 11:15 ص',
    monthGroup: 'أكتوبر 2026',
    amountEgp: 850.0,
    status: PaymentStatus.reconciling,
    paymentMethodLabel: 'بطاقة ائتمانية •••• 1088',
    providerReference: 'PAYMOB-EGY-TEST-88741',
    statusExplanation: 'قيد المطابقة مع مزود الدفع — جاري التحقق من التأكيد النهائي للعملية دون افتراض النجاح أو الفشل.',
  ),
  const PaymentTransactionItem(
    id: 'TXN-2026-879412',
    bookingReference: 'BK-774102',
    propertyTitle: 'بنتهاوس فاخر مع مسبح خاص — الجونة',
    typeLabel: 'عربون الليلة الأولى (MR-13)',
    dateFormatted: '08 أكتوبر 2026 • 07:20 م',
    monthGroup: 'أكتوبر 2026',
    amountEgp: 2200.0,
    status: PaymentStatus.pending,
    paymentMethodLabel: 'محفظة إلكترونية (تجريبية)',
    providerReference: 'WALLET-TEST-77192',
    statusExplanation: 'الطلب قيد المعالجة لدى مزود الدفع، بانتظار استجابة الشبكة.',
  ),
  const PaymentTransactionItem(
    id: 'TXN-2026-764019',
    bookingReference: 'BK-651900',
    propertyTitle: 'شاليه عائلي حديقة خاصة — الساحل الشمالي',
    typeLabel: 'عربون الليلة الأولى (MR-13)',
    dateFormatted: '22 سبتمبر 2026 • 01:10 م',
    monthGroup: 'سبتمبر 2026',
    amountEgp: 1100.0,
    status: PaymentStatus.paid,
    paymentMethodLabel: 'بطاقة ميزة •••• 9920',
    providerReference: 'MEEZA-EGY-TEST-44102',
    statusExplanation: 'تم استلام عربون الحجز وتأكيد موافقة المالك.',
  ),
  const PaymentTransactionItem(
    id: 'TXN-2026-749821',
    bookingReference: 'BK-510344',
    propertyTitle: 'استوديو هادئ بإطلالة بحرية — رأس الحكمة',
    typeLabel: 'عربون مسترد (إلغاء معتمد)',
    dateFormatted: '15 سبتمبر 2026 • 09:30 ص',
    monthGroup: 'سبتمبر 2026',
    amountEgp: 750.0,
    status: PaymentStatus.refunded,
    paymentMethodLabel: 'بطاقة ائتمانية •••• 4242',
    providerReference: 'REFUND-TEST-12004',
    statusExplanation: 'معاينة تجريبية: تمت إعادة مبلغ العربون إلى البطاقة الأصلية وفق سياسة الإلغاء المعتمدة.',
  ),
];

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen20Scenario {
  normalTransactionsTop,
  normalTransactionsScrolled,
  transactionDetailSheet,
  emptyState,
  reconciliationUnknownState,
  networkErrorRetryState,
  unauthenticatedGuestState,
  accessibility200Top,
  accessibility200Scrolled,
}

extension Screen20ScenarioMetadata on Screen20Scenario {
  String get title {
    switch (this) {
      case Screen20Scenario.normalTransactionsTop:
        return '01 Normal Transactions (Top Fold + Disclaimer)';
      case Screen20Scenario.normalTransactionsScrolled:
        return '02 Normal Transactions (Scrolled Fold)';
      case Screen20Scenario.transactionDetailSheet:
        return '03 Transaction Detail & Receipt Preview Sheet';
      case Screen20Scenario.emptyState:
        return '04 Honest Empty State (No Transactions)';
      case Screen20Scenario.reconciliationUnknownState:
        return '05 Reconciliation / Pending State (No False Success)';
      case Screen20Scenario.networkErrorRetryState:
        return '06 Network Error & Recovery Retry State';
      case Screen20Scenario.unauthenticatedGuestState:
        return '07 Unauthenticated Guest State (Private Data Shield)';
      case Screen20Scenario.accessibility200Top:
        return '08 Accessibility 200% Font Scale (Top Fold Reflow)';
      case Screen20Scenario.accessibility200Scrolled:
        return '09 Accessibility 200% Font Scale (Scrolled Reflow)';
    }
  }

  double? get textScaleOverride {
    switch (this) {
      case Screen20Scenario.accessibility200Top:
      case Screen20Scenario.accessibility200Scrolled:
        return 2.0;
      default:
        return null;
    }
  }

  double get scrollOffset {
    switch (this) {
      case Screen20Scenario.normalTransactionsScrolled:
        return 540.0;
      case Screen20Scenario.accessibility200Scrolled:
        return 880.0;
      default:
        return 0.0;
    }
  }
}

// =============================================================================
// State Controller
// =============================================================================

class CustomerPaymentHistoryController extends ChangeNotifier {
  CustomerPaymentHistoryState _state = CustomerPaymentHistoryState(
    transactions: kSyntheticPaymentTransactions,
  );
  String? _snackBarNotice;

  CustomerPaymentHistoryState get state => _state;
  String? get snackBarNotice => _snackBarNotice;

  void showNotice(String message) {
    _snackBarNotice = message;
    notifyListeners();
  }

  void clearNotice() {
    _snackBarNotice = null;
    notifyListeners();
  }

  void setFilter(PaymentHistoryFilter filter) {
    _state = _state.copyWith(selectedFilter: filter);
    notifyListeners();
  }

  void openTransactionDetail(PaymentTransactionItem item) {
    _state = _state.copyWith(
      selectedTransactionForSheet: () => item,
    );
    notifyListeners();
  }

  void closeTransactionDetail() {
    _state = _state.copyWith(
      selectedTransactionForSheet: () => null,
    );
    notifyListeners();
  }

  void retryLoading() {
    _state = _state.copyWith(
      isLoading: true,
      hasNetworkError: false,
    );
    notifyListeners();

    // Instant local resolve for deterministic test/preview
    _state = _state.copyWith(
      isLoading: false,
      hasNetworkError: false,
      transactions: kSyntheticPaymentTransactions,
    );
    showNotice('تم تحديث سجل المدفوعات بنجاح');
    notifyListeners();
  }

  void setScenario(Screen20Scenario scenario) {
    clearNotice();
    switch (scenario) {
      case Screen20Scenario.normalTransactionsTop:
      case Screen20Scenario.normalTransactionsScrolled:
      case Screen20Scenario.accessibility200Top:
      case Screen20Scenario.accessibility200Scrolled:
        _state = CustomerPaymentHistoryState(
          isAuthenticated: true,
          transactions: kSyntheticPaymentTransactions,
          selectedFilter: PaymentHistoryFilter.all,
          selectedTransactionForSheet: null,
        );
        break;
      case Screen20Scenario.transactionDetailSheet:
        _state = CustomerPaymentHistoryState(
          isAuthenticated: true,
          transactions: kSyntheticPaymentTransactions,
          selectedFilter: PaymentHistoryFilter.all,
          selectedTransactionForSheet: kSyntheticPaymentTransactions.first,
        );
        break;
      case Screen20Scenario.emptyState:
        _state = const CustomerPaymentHistoryState(
          isAuthenticated: true,
          transactions: [],
          selectedFilter: PaymentHistoryFilter.all,
          selectedTransactionForSheet: null,
        );
        break;
      case Screen20Scenario.reconciliationUnknownState:
        _state = CustomerPaymentHistoryState(
          isAuthenticated: true,
          transactions: [
            kSyntheticPaymentTransactions[1], // BK-908747 reconciling
            kSyntheticPaymentTransactions[2], // BK-774102 pending
          ],
          selectedFilter: PaymentHistoryFilter.all,
          selectedTransactionForSheet: null,
        );
        break;
      case Screen20Scenario.networkErrorRetryState:
        _state = const CustomerPaymentHistoryState(
          isAuthenticated: true,
          hasNetworkError: true,
          transactions: [],
          selectedFilter: PaymentHistoryFilter.all,
          selectedTransactionForSheet: null,
        );
        break;
      case Screen20Scenario.unauthenticatedGuestState:
        _state = const CustomerPaymentHistoryState(
          isAuthenticated: false,
          transactions: [],
          selectedFilter: PaymentHistoryFilter.all,
          selectedTransactionForSheet: null,
        );
        break;
    }
    notifyListeners();
  }
}

// =============================================================================
// App Root Widget
// =============================================================================

class Screen20PreviewApp extends StatelessWidget {
  const Screen20PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Screen 20 — Payment History',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: KonfrmTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF000000), // Pure Black #000000
          primary: const Color(0xFF000000),
          surface: Colors.white,
        ),
      ),
      home: const Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Screen20PreviewView(),
      ),
    );
  }
}

// =============================================================================
// Main Preview View
// =============================================================================

class Screen20PreviewView extends StatefulWidget {
  const Screen20PreviewView({super.key});

  @override
  State<Screen20PreviewView> createState() => Screen20PreviewViewState();
}

class Screen20PreviewViewState extends State<Screen20PreviewView> {
  late final CustomerPaymentHistoryController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Screen20Scenario _scenario = Screen20Scenario.normalTransactionsTop;
  bool _showDevTools = false;

  @override
  void initState() {
    super.initState();
    _controller = CustomerPaymentHistoryController();
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  void applyScenario(Screen20Scenario scenario) {
    setState(() {
      _scenario = scenario;
    });
    _controller.setScenario(scenario);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final offset = scenario.scrollOffset;
        if (offset > 0) {
          _scrollController.animateTo(
            offset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        } else {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.digit1) {
        applyScenario(Screen20Scenario.normalTransactionsTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen20Scenario.normalTransactionsScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen20Scenario.transactionDetailSheet);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen20Scenario.emptyState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen20Scenario.reconciliationUnknownState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen20Scenario.networkErrorRetryState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen20Scenario.unauthenticatedGuestState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen20Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        applyScenario(Screen20Scenario.accessibility200Scrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyD) {
        setState(() {
          _showDevTools = !_showDevTools;
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ambientMediaQuery = MediaQuery.of(context);
    final textScaleOverride = _scenario.textScaleOverride;
    final effectiveMediaQuery = textScaleOverride != null
        ? ambientMediaQuery.copyWith(textScaler: TextScaler.linear(textScaleOverride))
        : ambientMediaQuery;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MediaQuery(
        data: effectiveMediaQuery,
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Canonical NESTED_CUSTOMER Header (Physical-Right RTL Back Arrow, No Bottom Nav)
                    _buildAppBar(),

                    // Main Content Area
                    Expanded(
                      child: _buildBodyContent(),
                    ),
                  ],
                ),

                // Contained Transaction Detail / Receipt Preview Bottom Sheet
                if (_controller.state.selectedTransactionForSheet != null)
                  _buildTransactionDetailSheetOverlay(
                    _controller.state.selectedTransactionForSheet!,
                  ),

                // Transient Feedback Toast
                if (_controller.snackBarNotice != null)
                  _buildToast(_controller.snackBarNotice!),

                // DevTools / Scenario Selector Overlay
                if (_showDevTools)
                  _buildDevToolsOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Header / AppBar
  // ===========================================================================

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Physical RIGHT Back Button in RTL (Points ➔ into prior screen)
          Semantics(
            label: 'الرجوع إلى حسابي',
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('payment_history_back_button'),
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  _controller.showNotice('الرجوع إلى صفحة الحساب الشخصي (Screen 17)');
                },
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                  ),
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF000000), // Pure Black #000000
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title: «سجل المدفوعات»
          Expanded(
            child: GestureDetector(
              key: const Key('header_title_tap_area'),
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () {
                setState(() {
                  _showDevTools = !_showDevTools;
                });
              },
              child: const Text(
                'سجل المدفوعات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000), // Pure Black #000000
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Trailing Action: Refresh / Re-query
          Semantics(
            label: 'تحديث سجل المدفوعات',
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('payment_history_refresh_button'),
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  _controller.retryLoading();
                },
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Body Content Router
  // ===========================================================================

  Widget _buildBodyContent() {
    final state = _controller.state;

    // 1. Unauthenticated Guest Shield
    if (!state.isAuthenticated) {
      return _buildGuestStateView();
    }

    // 2. Network Error State
    if (state.hasNetworkError) {
      return _buildNetworkErrorView();
    }

    // 3. True Empty State
    if (state.transactions.isEmpty) {
      return _buildEmptyStateView();
    }

    // 4. Normal / Populated Transactions View
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mandatory First-Fold Synthetic Disclaimer Banner
          _buildFirstFoldDisclaimerBanner(),
          const SizedBox(height: 16),

          // Summary Stats & Model Boundaries Card
          _buildSummaryStatsCard(),
          const SizedBox(height: 16),

          // Special Reconciliation Alert (If applicable scenario)
          if (_scenario == Screen20Scenario.reconciliationUnknownState) ...[
            _buildReconciliationAlertCard(),
            const SizedBox(height: 16),
          ],

          // Filter Segment Bar
          _buildFilterSegmentBar(),
          const SizedBox(height: 16),

          // Chronological Grouped Transactions
          ..._buildGroupedTransactionSections(),
          const SizedBox(height: 24),

          // Legal & Model Footnote Card
          _buildFinancialPolicyFootnoteCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ===========================================================================
  // Mandatory First-Fold Synthetic Disclaimer Banner
  // ===========================================================================

  Widget _buildFirstFoldDisclaimerBanner() {
    return Container(
      key: const Key('first_fold_synthetic_disclaimer'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Amber 50
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.0), // Amber 200
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: Color(0xFFD97706), // Amber 600
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'بيانات تجريبية — ليست معاملات حقيقية',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E), // Amber 800
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'جميع العمليات والمبالغ المعروضة في هذه الشاشة هي بيانات محاكاة مخصصة لاختبار الواجهة، ولا تمثل مدفوعات نقدية فعلية أو تسويات بنكية منتهية.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB45309).withAlpha(230), // Amber 700
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Summary Stats & Boundary Card
  // ===========================================================================

  Widget _buildSummaryStatsCard() {
    final transactions = _controller.state.transactions;
    final paidCount = transactions.where((t) => t.status == PaymentStatus.paid).length;
    final totalCount = transactions.length;

    return Container(
      key: const Key('payment_summary_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 18,
                  color: Color(0xFF000000), // Pure Black #000000
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'ملخص العمليات المسجلة',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$totalCount عمليات',
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatPill('المكتملة بنجاح', '$paidCount', const Color(0xFF059669)),
              _buildStatPill('نوع الدفع المعتمد', 'عربون الليلة الأولى (MR-13)', const Color(0xFF000000)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'ملاحظة: هذا السجل هو مرجع رقمي للحجوزات ولا يمثل محفظة نقدية أو رصيداً قابلاً للشحن أو السحب.',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String title, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 11,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Reconciliation Alert (Scenario 05)
  // ===========================================================================

  Widget _buildReconciliationAlertCard() {
    return Container(
      key: const Key('reconciliation_alert_banner'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Blue 50
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.0), // Blue 200
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.sync_rounded,
            size: 20,
            color: Color(0xFF2563EB), // Blue 600
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'عملية قيد المطابقة مع مزود الدفع',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E40AF), // Blue 800
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'العملية رقم TXN-2026-881104 قيد التدقيق لدى مزود الدفع. لم يتم تأكيد السداد أو الفشل بعد؛ ونلتزم بعدم اختلاق نجاح مالي حتى يرد التأكيد البنكي الرسمي.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1D4ED8),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Filter Segment Bar
  // ===========================================================================

  Widget _buildFilterSegmentBar() {
    final activeFilter = _controller.state.selectedFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: PaymentHistoryFilter.values.map((filter) {
          final isSelected = activeFilter == filter;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: 'تصفية: ${filter.labelArabic}',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: Key('filter_tab_${filter.name}'),
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _controller.setFilter(filter);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF000000) : Colors.white, // Pure Black #000000
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      filter.labelArabic,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF000000), // Pure Black #000000
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================================
  // Grouped Transaction Sections
  // ===========================================================================

  List<Widget> _buildGroupedTransactionSections() {
    final grouped = _controller.state.groupedTransactions;

    if (grouped.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Text(
            'لا توجد عمليات تطابق التصفية المختارة',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ];
    }

    final widgets = <Widget>[];

    grouped.forEach((month, items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              Text(
                month,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000), // Pure Black #000000
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 1,
                  color: const Color(0xFFE5E7EB),
                ),
              ),
            ],
          ),
        ),
      );

      for (final item in items) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTransactionRowCard(item),
          ),
        );
      }
    });

    return widgets;
  }

  // ===========================================================================
  // Individual Transaction Row Card
  // ===========================================================================

  Widget _buildTransactionRowCard(PaymentTransactionItem item) {
    final status = item.status;

    return Semantics(
      button: true,
      label: 'تفاصيل العملية: ${item.propertyTitle}، بمبلغ ${item.amountEgp.toStringAsFixed(0)} ج.م، الحالة: ${status.labelArabic}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('transaction_card_${item.id}'),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _controller.openTransactionDetail(item);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Property & Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.propertyTitle,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000), // Pure Black #000000
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.typeLabel,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Status Badge (Wrapped for a11y 200% reflow safety)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: status.borderColor, width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status.iconData,
                              size: 13,
                              color: status.textColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                status.labelArabic,
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: status.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),

                // Bottom Row: Date/Booking Reference + Amount with LTR Isolation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حجز #${item.bookingReference}',
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000), // Pure Black #000000
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.dateFormatted,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Amount formatted in Egyptian Pounds with strict LTR isolation
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            item.amountEgp.toStringAsFixed(0),
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF000000), // Pure Black #000000
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'ج.م',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000), // Pure Black #000000
                            ),
                          ),
                        ],
                      ),
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

  // ===========================================================================
  // Legal & Financial Policy Footnote
  // ===========================================================================

  Widget _buildFinancialPolicyFootnoteCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.shield_outlined,
                size: 16,
                color: Color(0xFF000000), // Pure Black #000000
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'سياسات الدفع والشفافية المالية',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '• يُسدد عربون الليلة الأولى حصرياً عقب موافقة المالك الرسمية على طلب الحجز (MR-13).\n'
            '• سياسات سداد المتبقي (MR-15) وقواعد الاسترداد العامة قيد التدقيق التشغيلي ولم تُفعل بعد.\n'
            '• هذا السجل محمي ومقتصر على العمليات المصرح بها لهذا الحساب فقط.',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B5563),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Empty State View (Scenario 04)
  // ===========================================================================

  Widget _buildEmptyStateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 32,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'لا توجد مدفوعات مسجلة بعد',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ستظهر هنا تلقائياً سجلات عربون الحجوزات بعد موافقة المالك وإتمام السداد بنجاح.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Primary Button (6px radius per DF2 / Issue #175)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                key: const Key('empty_state_explore_cta'),
                onPressed: () {
                  _controller.showNotice('الرجوع إلى تبويب استكشف الإقامات (Screen 03/04)');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000), // Pure Black #000000
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // 6px Primary Button Radius
                  ),
                ),
                child: const Text(
                  'استكشف الإقامات',
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
    );
  }

  // ===========================================================================
  // Network Error State View (Scenario 06)
  // ===========================================================================

  Widget _buildNetworkErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2), // Red 50
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFECACA), width: 1.0),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 32,
                color: Color(0xFFDC2626), // Red 600
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'تعذر تحميل سجل المدفوعات',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'حدث خطأ في الاتصال بالخادم لجلب تفاصيل معاملاتك. يُرجى التحقق من اتصال الإنترنت والمحاولة مجدداً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Retry Button (6px radius per DF2)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                key: const Key('network_error_retry_cta'),
                onPressed: () {
                  _controller.retryLoading();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000), // Pure Black #000000
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // 6px Primary Button Radius
                  ),
                ),
                child: const Text(
                  'إعادة المحاولة',
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
    );
  }

  // ===========================================================================
  // Unauthenticated Guest State View (Scenario 07)
  // ===========================================================================

  Widget _buildGuestStateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 32,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'سجّل الدخول لعرض مدفوعاتك',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'سجل المعاملات والمدفوعات خاص بالحسابات المسجلة. سجّل الدخول لعرض تفاصيل العربون وإيصالات الحجوزات السابقة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Login Button (6px radius per DF2)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                key: const Key('guest_login_cta'),
                onPressed: () {
                  _controller.showNotice('فتح تدفق تسجيل الدخول (Auth V2 Origin: PAYMENT_HISTORY)');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000), // Pure Black #000000
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // 6px Primary Button Radius
                  ),
                ),
                child: const Text(
                  'تسجيل الدخول',
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
    );
  }

  // ===========================================================================
  // Contained Transaction Detail / Receipt Preview Sheet Overlay (Scenario 03)
  // ===========================================================================

  Widget _buildTransactionDetailSheetOverlay(PaymentTransactionItem item) {
    final status = item.status;

    return Stack(
      children: [
        // Modal Scrim
        GestureDetector(
          key: const Key('transaction_detail_scrim'),
          onTap: () {
            _controller.closeTransactionDetail();
          },
          child: Container(
            color: const Color(0x66000000), // Pure Black #000000 with 40% opacity scrim
          ),
        ),

        // Sheet Content
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            key: const Key('transaction_detail_sheet'),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // 16px sheet radius
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Grab Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sheet Header Row
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'تفاصيل العملية (معاينة تجريبية)',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000), // Pure Black #000000
                            ),
                          ),
                        ),
                        IconButton(
                          key: const Key('close_detail_sheet_button'),
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF000000)),
                          onPressed: () {
                            _controller.closeTransactionDetail();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Disclaimer notice inside sheet
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Text(
                        'إيصال تجريبي — لا يُعد مستنداً بنكياً رسمياً أو إشعار خصم ضريبي ملزم.',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount Highlight Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'المبلغ المسدد',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Directionality(
                            textDirection: ui.TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  item.amountEgp.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF000000), // Pure Black #000000
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'ج.م',
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: status.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: status.borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(status.iconData, size: 14, color: status.textColor),
                                const SizedBox(width: 4),
                                Text(
                                  status.labelArabic,
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: status.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Key-Value Grid
                    _buildDetailItemRow('رقم المعاملة', item.id),
                    _buildDetailItemRow('رقم الحجز', '#${item.bookingReference}'),
                    _buildDetailItemRow('العقار', item.propertyTitle),
                    _buildDetailItemRow('نوع السداد', item.typeLabel),
                    _buildDetailItemRow('تاريخ المعاملة', item.dateFormatted),
                    _buildDetailItemRow('وسيلة الدفع', item.paymentMethodLabel),
                    _buildDetailItemRow('المرجع الفني', item.providerReference),
                    const SizedBox(height: 8),

                    // Explanation note
                    Text(
                      item.statusExplanation,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            key: const Key('copy_transaction_ref_button'),
                            onPressed: () {
                              _controller.showNotice('تم نسخ مرجع العملية: ${item.id}');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF000000),
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'نسخ المرجع',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            key: const Key('close_detail_sheet_cta'),
                            onPressed: () {
                              _controller.closeTransactionDetail();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000), // Pure Black #000000
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'إغلاق',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Transient Toast Notification
  // ===========================================================================

  Widget _buildToast(String message) {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: Container(
        key: const Key('screen20_toast_notification'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF000000), // Pure Black #000000
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _controller.clearNotice();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DevTools / Scenario Selector Overlay
  // ===========================================================================

  Widget _buildDevToolsOverlay() {
    return Positioned(
      top: 60,
      left: 12,
      right: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF000000), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'محدد سيناريوهات الاختبار (Screen 20)',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      setState(() {
                        _showDevTools = false;
                      });
                    },
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...Screen20Scenario.values.map((scenario) {
                final isCurrent = _scenario == scenario;
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    scenario.title,
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? const Color(0xFF000000) : const Color(0xFF4B5563),
                    ),
                  ),
                  trailing: isCurrent ? const Icon(Icons.check, size: 16, color: Color(0xFF000000)) : null,
                  onTap: () {
                    applyScenario(scenario);
                    setState(() {
                      _showDevTools = false;
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
