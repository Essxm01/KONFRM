// =============================================================================
// KONFRM Customer Screen 16 — Notification Center (مركز الإشعارات)
// Native Flutter Visual Preview Runner & Behavioral Harness
//
// Device Target: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Design Authority: Cairo Typography, RTL First, Monochrome Neutral Palette
// Navigation Context: Opened from Account (CustomerBottomNavigation Tab 3 active)
//
// Scope: Isolated visual preview with synthetic fixtures. No production mutations.
// =============================================================================

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen16PreviewApp());
}

// =============================================================================
// Domain Models & Synthetic Fixtures
// =============================================================================

enum CustomerNotificationEventType {
  bookingApprovedPendingPayment,
  bookingRejected,
  bookingCancelled,
  securityAlert,
}

class CustomerNotificationItem {
  final String notificationId;
  final CustomerNotificationEventType eventType;
  final String title;
  final String body;
  final String? propertyTitle;
  final String? bookingId;
  final String createdAtText;
  final bool isRead;
  final bool actionRequired;
  final bool isTargetAvailable;

  const CustomerNotificationItem({
    required this.notificationId,
    required this.eventType,
    required this.title,
    required this.body,
    this.propertyTitle,
    this.bookingId,
    required this.createdAtText,
    this.isRead = false,
    this.actionRequired = false,
    this.isTargetAvailable = true,
  });

  CustomerNotificationItem copyWith({
    bool? isRead,
    bool? isTargetAvailable,
  }) {
    return CustomerNotificationItem(
      notificationId: notificationId,
      eventType: eventType,
      title: title,
      body: body,
      propertyTitle: propertyTitle,
      bookingId: bookingId,
      createdAtText: createdAtText,
      isRead: isRead ?? this.isRead,
      actionRequired: actionRequired,
      isTargetAvailable: isTargetAvailable ?? this.isTargetAvailable,
    );
  }
}

final List<CustomerNotificationItem> kSyntheticNotifications = [
  const CustomerNotificationItem(
    notificationId: 'notif_001',
    eventType: CustomerNotificationEventType.bookingApprovedPendingPayment,
    title: 'وافق المالك على طلب الحجز',
    body: 'شاليه فاخر بإطلالة مباشرة على لاجون مراسي · أصبح دفع العربون الخطوة التالية لتأكيد الحجز.',
    propertyTitle: 'شاليه فاخر بإطلالة مباشرة على لاجون مراسي',
    bookingId: 'bk_marassi_001',
    createdAtText: 'منذ 15 دقيقة',
    isRead: false,
    actionRequired: true,
    isTargetAvailable: true,
  ),
  const CustomerNotificationItem(
    notificationId: 'notif_002',
    eventType: CustomerNotificationEventType.bookingRejected,
    title: 'لم يوافق المالك على طلب الحجز',
    body: 'فيلا مستقلة مع مسبح خاص وحديقة واسعة · المواعيد المطلوبة غير متوفرة حالياً لدى المالك.',
    propertyTitle: 'فيلا مستقلة مع مسبح خاص وحديقة واسعة',
    bookingId: 'bk_gouna_002',
    createdAtText: 'منذ ساعتين',
    isRead: false,
    actionRequired: false,
    isTargetAvailable: true,
  ),
  const CustomerNotificationItem(
    notificationId: 'notif_003',
    eventType: CustomerNotificationEventType.bookingCancelled,
    title: 'تم إلغاء طلب الحجز',
    body: 'شقة عصرية راقية بالقرب من مجمع ووترواي · تم تحديث حالة طلب الحجز إلى ملغى.',
    propertyTitle: 'شقة عصرية راقية بالقرب من مجمع ووترواي',
    bookingId: 'bk_waterway_003',
    createdAtText: 'أمس، 04:30 م',
    isRead: true,
    actionRequired: false,
    isTargetAvailable: true,
  ),
  const CustomerNotificationItem(
    notificationId: 'notif_004',
    eventType: CustomerNotificationEventType.bookingApprovedPendingPayment,
    title: 'تحديث على طلب الحجز',
    body: 'إقامة هادئة في الساحل الشمالي · الوجهة المرتبطة بالطلب لم تعد متاحة.',
    propertyTitle: 'إقامة هادئة في الساحل الشمالي',
    bookingId: 'bk_expired_004',
    createdAtText: 'منذ 3 أيام',
    isRead: true,
    actionRequired: false,
    isTargetAvailable: false, // Triggers missing target notice
  ),
];

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen16Scenario {
  readyListTop,
  readyListScrolled,
  emptyNoNotifications,
  initialLoading,
  staleRefreshError,
  networkErrorInitial,
  sessionExpired401,
  actionRequiredDetail,
  missingDestinationDialog,
  singleCardFocus,
  rejectionCardFocus,
  readUnreadToggled,
  accessibility200Top,
  accessibility200Scrolled,
}

extension Screen16ScenarioMetadata on Screen16Scenario {
  String get title {
    switch (this) {
      case Screen16Scenario.readyListTop:
        return '01 Ready List (Top Fold)';
      case Screen16Scenario.readyListScrolled:
        return '02 Ready List (Scrolled)';
      case Screen16Scenario.emptyNoNotifications:
        return '03 Empty State (No Notifications)';
      case Screen16Scenario.initialLoading:
        return '04 Initial Loading (Skeleton)';
      case Screen16Scenario.staleRefreshError:
        return '05 Stale Refresh Error Banner';
      case Screen16Scenario.networkErrorInitial:
        return '06 Network Error (Retry)';
      case Screen16Scenario.sessionExpired401:
        return '07 Session Expired (401)';
      case Screen16Scenario.actionRequiredDetail:
        return '08 Action Required Detail';
      case Screen16Scenario.missingDestinationDialog:
        return '09 Missing Destination Notice';
      case Screen16Scenario.singleCardFocus:
        return '10 Single Card Deep Dive';
      case Screen16Scenario.rejectionCardFocus:
        return '11 Rejection Card Focus';
      case Screen16Scenario.readUnreadToggled:
        return '12 Read / Unread Toggled';
      case Screen16Scenario.accessibility200Top:
        return '13 A11y 200% Text (Top)';
      case Screen16Scenario.accessibility200Scrolled:
        return '14 A11y 200% Text (Scrolled)';
    }
  }

  double get textScale {
    switch (this) {
      case Screen16Scenario.accessibility200Top:
      case Screen16Scenario.accessibility200Scrolled:
        return 2.0;
      default:
        return 1.0;
    }
  }

  double get scrollOffset {
    switch (this) {
      case Screen16Scenario.readyListScrolled:
      case Screen16Scenario.accessibility200Scrolled:
        return 320.0;
      default:
        return 0.0;
    }
  }
}

// =============================================================================
// State Controller
// =============================================================================

class Screen16NotificationsController extends ChangeNotifier {
  List<CustomerNotificationItem> _items = [];
  bool _isLoading = false;
  bool _isStaleError = false;
  bool _isHardError = false;
  bool _is401Expired = false;
  CustomerNotificationItem? _focusedItem;
  String? _dialogNotice;

  Screen16NotificationsController() {
    _loadInitial();
  }

  List<CustomerNotificationItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isStaleError => _isStaleError;
  bool get isHardError => _isHardError;
  bool get is401Expired => _is401Expired;
  CustomerNotificationItem? get focusedItem => _focusedItem;
  String? get dialogNotice => _dialogNotice;

  int get unreadCount => _items.where((i) => !i.isRead).length;

  void _loadInitial() {
    _items = []; // Truthful default: empty feed on initial customer view
    _isLoading = false;
    _isStaleError = false;
    _isHardError = false;
    _is401Expired = false;
    _focusedItem = null;
    _dialogNotice = null;
    notifyListeners();
  }

  void setScenario(Screen16Scenario scenario) {
    _dialogNotice = null;
    _focusedItem = null;

    switch (scenario) {
      case Screen16Scenario.readyListTop:
      case Screen16Scenario.readyListScrolled:
      case Screen16Scenario.accessibility200Top:
      case Screen16Scenario.accessibility200Scrolled:
        _items = List.from(kSyntheticNotifications);
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        break;

      case Screen16Scenario.emptyNoNotifications:
        _items = [];
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        break;

      case Screen16Scenario.initialLoading:
        _items = [];
        _isLoading = true;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        break;

      case Screen16Scenario.staleRefreshError:
        _items = List.from(kSyntheticNotifications);
        _isLoading = false;
        _isStaleError = true;
        _isHardError = false;
        _is401Expired = false;
        break;

      case Screen16Scenario.networkErrorInitial:
        _items = [];
        _isLoading = false;
        _isStaleError = false;
        _isHardError = true;
        _is401Expired = false;
        break;

      case Screen16Scenario.sessionExpired401:
        // Pure isolation: clear cached private notifications on 401
        _items = [];
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = true;
        break;

      case Screen16Scenario.actionRequiredDetail:
        _items = List.from(kSyntheticNotifications);
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _focusedItem = _items.firstWhere((i) => i.actionRequired);
        break;

      case Screen16Scenario.missingDestinationDialog:
        _items = List.from(kSyntheticNotifications);
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _dialogNotice = 'الوجهة المرتبطة بهذا الإشعار لم تعد متاحة أو تم إلغاؤها.';
        break;

      case Screen16Scenario.singleCardFocus:
        _items = List.from(kSyntheticNotifications);
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _focusedItem = _items.firstWhere(
          (i) => i.eventType == CustomerNotificationEventType.bookingCancelled,
        );
        break;

      case Screen16Scenario.rejectionCardFocus:
        _items = List.from(kSyntheticNotifications);
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _focusedItem = _items.firstWhere(
          (i) => i.eventType == CustomerNotificationEventType.bookingRejected,
        );
        break;

      case Screen16Scenario.readUnreadToggled:
        _items = kSyntheticNotifications.map((i) {
          if (i.notificationId == 'notif_001') {
            return i.copyWith(isRead: true);
          }
          return i;
        }).toList();
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        break;
    }
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _items.indexWhere((i) => i.notificationId == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _items = _items.map((i) => i.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void selectNotification(CustomerNotificationItem item) {
    if (!item.isTargetAvailable) {
      _dialogNotice = 'الوجهة المرتبطة بهذا الإشعار لم تعد متاحة أو تم إلغاؤها.';
    } else {
      markAsRead(item.notificationId);
      _focusedItem = item;
    }
    notifyListeners();
  }

  void dismissDialog() {
    _dialogNotice = null;
    notifyListeners();
  }

  void dismissFocus() {
    _focusedItem = null;
    notifyListeners();
  }
}

// =============================================================================
// Preview App Shell
// =============================================================================

class Screen16PreviewApp extends StatelessWidget {
  const Screen16PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KONFRM Screen 16 Preview',
      theme: previewTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const Screen16HarnessPage(),
    );
  }
}

// =============================================================================
// Harness Page with Keyboard Shortcuts & Scenario Switching
// =============================================================================

class Screen16HarnessPage extends StatefulWidget {
  const Screen16HarnessPage({super.key});

  @override
  State<Screen16HarnessPage> createState() => Screen16HarnessPageState();
}

class Screen16HarnessPageState extends State<Screen16HarnessPage> {
  final Screen16NotificationsController _controller = Screen16NotificationsController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();

  Screen16Scenario _scenario = Screen16Scenario.emptyNoNotifications;
  bool _showDevTools = false;
  int _bottomNavIndex = 3; // Account tab active by contract

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  void applyScenario(Screen16Scenario scenario) {
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
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.digit1) {
        applyScenario(Screen16Scenario.readyListTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen16Scenario.readyListScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen16Scenario.emptyNoNotifications);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen16Scenario.initialLoading);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen16Scenario.staleRefreshError);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen16Scenario.networkErrorInitial);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen16Scenario.sessionExpired401);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen16Scenario.actionRequiredDetail);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        applyScenario(Screen16Scenario.missingDestinationDialog);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyA) {
        applyScenario(Screen16Scenario.singleCardFocus);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyB) {
        applyScenario(Screen16Scenario.rejectionCardFocus);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyC) {
        applyScenario(Screen16Scenario.readUnreadToggled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyD) {
        applyScenario(Screen16Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyE) {
        applyScenario(Screen16Scenario.accessibility200Scrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyO) {
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
    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_scenario.textScale),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          body: Stack(
            children: [
              // Column: Top Adaptive Header + Scrollable Content
              Column(
                children: [
                  // Adaptive Subview Header (No fixed-height AppBar overflow)
                  _buildTopHeader(),

                  // Scrollable Body Content
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        _controller._loadInitial();
                      },
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          // Stale Error Notice Banner
                          if (_controller.isStaleError)
                            SliverToBoxAdapter(
                              child: _buildStaleErrorBanner(),
                            ),

                          // List action bar (unread summary and mark all as read)
                          if (!_controller.isLoading &&
                              !_controller.is401Expired &&
                              !_controller.isHardError &&
                              _controller.items.isNotEmpty)
                            SliverToBoxAdapter(
                              child: _buildListActionBar(),
                            ),

                          // Content Views depending on state
                          if (_controller.isLoading)
                            SliverToBoxAdapter(
                              child: _buildLoadingSkeleton(),
                            )
                          else if (_controller.is401Expired)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildSessionExpiredView(),
                            )
                          else if (_controller.isHardError)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildNetworkErrorView(),
                            )
                          else if (_controller.items.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildEmptyStateView(),
                            )
                          else
                            _buildNotificationListSliver(),

                          // Bottom clearance padding for bottom navigation
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 100),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Detail Modal Focus (e.g. Action Required)
              if (_controller.focusedItem != null)
                _buildDetailModal(_controller.focusedItem!),

              // Missing Target Dialog
              if (_controller.dialogNotice != null)
                _buildMissingTargetDialog(_controller.dialogNotice!),

              // QA Dev Tools Overlay
              if (_showDevTools)
                _buildQaDevOverlay(),
            ],
          ),
          // Canonical Shared Customer Bottom Navigation (Tab 3: Account active)
          bottomNavigationBar: CustomerBottomNavigation(
            selectedIndex: _bottomNavIndex,
            onSelected: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
              if (index == 3) {
                applyScenario(Screen16Scenario.readyListTop);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'معاينة: الانتقال إلى الوجهة (${customerDestinations[index]})',
                    ),
                    duration: const Duration(milliseconds: 700),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Top Header (Adaptive Subview Header from Account)
  // ===========================================================================

  Widget _buildTopHeader() {
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
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button to Account (In RTL, points to the right)
              Semantics(
                button: true,
                label: 'العودة إلى الحساب',
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('العودة إلى شاشة الحساب الرئيسية'),
                        duration: Duration(milliseconds: 700),
                      ),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title & Subtitle in Flexible column
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        const Text(
                          'الإشعارات',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF000000),
                            height: 1.2,
                          ),
                        ),
                        if (_controller.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF000000),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_controller.unreadCount}',
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'تحديثات مهمة على طلباتك وحجوزاتك.',
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // List Action Bar (Unread Summary & Mark All Read Action)
  // ===========================================================================

  Widget _buildListActionBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _controller.unreadCount > 0
                  ? 'لديك ${_controller.unreadCount} إشعارات غير مقروءة'
                  : 'جميع الإشعارات',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
          if (_controller.unreadCount > 0)
            Semantics(
              button: true,
              label: 'تحديد الكل كمقروء',
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _controller.markAllAsRead(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text(
                    'قراءة الكل',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
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
  // Notification List Slivers
  // ===========================================================================

  Widget _buildNotificationListSliver() {
    final items = _controller.items;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildNotificationCard(item),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(CustomerNotificationItem item) {
    final isUnread = !item.isRead;

    return Semantics(
      button: true,
      label: '${isUnread ? 'إشعار غير مقروء: ' : 'إشعار مقروء: '}${item.title}. ${item.body}',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _controller.selectNotification(item),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1.0,
              ),
              boxShadow: isUnread
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Icon + Title + Unread Indicator + Timestamp
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Event Icon Container
                    _buildEventIconContainer(item.eventType),
                    const SizedBox(width: 10),

                    // Title with Unread Dot Marker
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 14,
                                fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                color: isUnread ? const Color(0xFF111827) : const Color(0xFF4B5563),
                                height: 1.25,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF000000),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Timestamp
                    Text(
                      item.createdAtText,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Body text
                Text(
                  item.body,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isUnread ? const Color(0xFF1F2937) : const Color(0xFF4B5563),
                    height: 1.4,
                  ),
                ),

                // Action Required Badge (Strict: deposit payment required, NOT confirmed)
                if (item.actionRequired) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'مطلوب إجراء: دفع العربون',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Icon(
                            Icons.arrow_back,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventIconContainer(CustomerNotificationEventType type) {
    IconData icon;
    switch (type) {
      case CustomerNotificationEventType.bookingApprovedPendingPayment:
        icon = Icons.check_circle_outline;
        break;
      case CustomerNotificationEventType.bookingRejected:
        icon = Icons.cancel_outlined;
        break;
      case CustomerNotificationEventType.bookingCancelled:
        icon = Icons.event_busy_outlined;
        break;
      case CustomerNotificationEventType.securityAlert:
        icon = Icons.shield_outlined;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 18,
        color: const Color(0xFF000000),
      ),
    );
  }

  // ===========================================================================
  // State Views
  // ===========================================================================

  Widget _buildStaleErrorBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF000000)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'تعذر تحديث الإشعارات. تظهر آخر قائمة تم استرجاعها.',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000),
              ),
            ),
          ),
          TextButton(
            onPressed: () => _controller._loadInitial(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              foregroundColor: const Color(0xFF000000),
            ),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 200,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyStateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 32,
                color: Color(0xFF71717A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'لا توجد إشعارات حتى الآن',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ستظهر هنا التحديثات الخاصة بطلبات الحجز وحالتها فور وصولها من المالكين.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                applyScenario(Screen16Scenario.readyListTop);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'استكشف الإقامات',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionExpiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 32,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'انتهت جلسة تسجيل الدخول',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لحماية خصوصية بياناتك وإشعاراتك، يرجى تسجيل الدخول مجدداً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                _controller._loadInitial();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.wifi_off_outlined,
                size: 32,
                color: Color(0xFF71717A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'تعذر تحميل الإشعارات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى التحقق من اتصالك بالإنترنت ثم إعادة المحاولة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                _controller._loadInitial();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
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
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Modals & Dialogs
  // ===========================================================================

  Widget _buildDetailModal(CustomerNotificationItem item) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildEventIconContainer(item.eventType),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _controller.dismissFocus(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                item.body,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                  height: 1.5,
                ),
              ),
              if (item.actionRequired) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Color(0xFF000000)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تنبيه: لا يعتبر الحجز مؤكداً حتى يتم سداد دفعة العربون المطلوبة.',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.dismissFocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('معاينة: فتح شاشة تفاصيل الحجز وسداد العربون (Screen 13/14)'),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'متابعة إلى دفع العربون',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => _controller.dismissFocus(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF000000),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingTargetDialog(String message) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.link_off,
                  size: 28,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'الوجهة غير متاحة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _controller.dismissDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'فهمت ذلك',
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

  // ===========================================================================
  // QA Dev Tools Overlay
  // ===========================================================================

  Widget _buildQaDevOverlay() {
    return Positioned(
      bottom: 84,
      left: 12,
      right: 12,
      child: Material(
        color: const Color(0xFF18181B).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.developer_mode, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Screen 16 QA Harness — ${_scenario.title}',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        _showDevTools = false;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: Screen16Scenario.values.map((s) {
                  final isCurrent = s == _scenario;
                  return InkWell(
                    onTap: () => applyScenario(s),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.white : Colors.white12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s.name,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                          color: isCurrent ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
