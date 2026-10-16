// =============================================================================
// KONFRM Customer Screen 19 — Settings («الإعدادات»)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Design Authority: Cairo Typography, RTL First, Pure Monochrome & Neutrals
// Navigation Context: Nested Customer Destination (Canonical NESTED_CUSTOMER)
// Bottom Navigation: HIDDEN (Per canonical DESIGN_SYSTEM/COMPONENTS/navigation.md)
// Governing Issues:
//   - Issue #177 (Screen 19 Settings Founder Execution Contract)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository Audit)
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
  runApp(const Screen19PreviewApp());
}

// =============================================================================
// Domain Models & Synthetic State
// =============================================================================

class CustomerSettingsState {
  final bool isAuthenticated;
  final String verifiedPhoneMasked;
  final String verifiedEmailMasked;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final bool isAppleLinked;
  final bool isGoogleLinked;
  final bool osNotificationPermissionGranted;
  final bool bookingUpdatesEnabled;
  final bool hostMessagesEnabled;
  final bool priceAlertsEnabled;
  final String appLanguage;
  final String pricingCurrency;
  final bool reduceMotion;
  final String appearanceTheme;

  const CustomerSettingsState({
    this.isAuthenticated = true,
    this.verifiedPhoneMasked = '\u202A+20 10 •••• 5678\u202C',
    this.verifiedEmailMasked = 'a•••••@gmail.com',
    this.isPhoneVerified = true,
    this.isEmailVerified = true,
    this.isAppleLinked = false,
    this.isGoogleLinked = false,
    this.osNotificationPermissionGranted = true,
    this.bookingUpdatesEnabled = true,
    this.hostMessagesEnabled = true,
    this.priceAlertsEnabled = false,
    this.appLanguage = 'العربية (الافتراضية)',
    this.pricingCurrency = 'الجنيه المصري (EGP)',
    this.reduceMotion = false,
    this.appearanceTheme = 'الوضع الفاتح المعتمد',
  });

  CustomerSettingsState copyWith({
    bool? isAuthenticated,
    String? verifiedPhoneMasked,
    String? verifiedEmailMasked,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    bool? isAppleLinked,
    bool? isGoogleLinked,
    bool? osNotificationPermissionGranted,
    bool? bookingUpdatesEnabled,
    bool? hostMessagesEnabled,
    bool? priceAlertsEnabled,
    String? appLanguage,
    String? pricingCurrency,
    bool? reduceMotion,
    String? appearanceTheme,
  }) {
    return CustomerSettingsState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      verifiedPhoneMasked: verifiedPhoneMasked ?? this.verifiedPhoneMasked,
      verifiedEmailMasked: verifiedEmailMasked ?? this.verifiedEmailMasked,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isAppleLinked: isAppleLinked ?? this.isAppleLinked,
      isGoogleLinked: isGoogleLinked ?? this.isGoogleLinked,
      osNotificationPermissionGranted:
          osNotificationPermissionGranted ?? this.osNotificationPermissionGranted,
      bookingUpdatesEnabled:
          bookingUpdatesEnabled ?? this.bookingUpdatesEnabled,
      hostMessagesEnabled: hostMessagesEnabled ?? this.hostMessagesEnabled,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      appLanguage: appLanguage ?? this.appLanguage,
      pricingCurrency: pricingCurrency ?? this.pricingCurrency,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      appearanceTheme: appearanceTheme ?? this.appearanceTheme,
    );
  }
}

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen19Scenario {
  mainSettingsTop,
  mainSettingsScrolled,
  notificationsPermissionDenied,
  signOutConfirmationDialog,
  unauthenticatedGuestState,
  accountDeletionInfoSheet,
  accessibility200Top,
  accessibility200Scrolled,
}

extension Screen19ScenarioMetadata on Screen19Scenario {
  String get title {
    switch (this) {
      case Screen19Scenario.mainSettingsTop:
        return '01 Main Settings (Top Fold)';
      case Screen19Scenario.mainSettingsScrolled:
        return '02 Main Settings (Scrolled Fold)';
      case Screen19Scenario.notificationsPermissionDenied:
        return '03 OS Notification Permission Denied + Recovery Sheet';
      case Screen19Scenario.signOutConfirmationDialog:
        return '04 Sign Out Confirmation Dialog';
      case Screen19Scenario.unauthenticatedGuestState:
        return '05 Unauthenticated / Guest State (Protected Security)';
      case Screen19Scenario.accountDeletionInfoSheet:
        return '06 Account Deletion & Data Portability Policy Sheet';
      case Screen19Scenario.accessibility200Top:
        return '07 Accessibility 200% Font Scale (Top Fold)';
      case Screen19Scenario.accessibility200Scrolled:
        return '08 Accessibility 200% Font Scale (Scrolled)';
    }
  }

  double? get textScaleOverride {
    switch (this) {
      case Screen19Scenario.accessibility200Top:
      case Screen19Scenario.accessibility200Scrolled:
        return 2.0;
      default:
        return null;
    }
  }

  double get scrollOffset {
    switch (this) {
      case Screen19Scenario.mainSettingsScrolled:
        return 520.0;
      case Screen19Scenario.accessibility200Scrolled:
        return 880.0;
      default:
        return 0.0;
    }
  }
}

// =============================================================================
// State Controller
// =============================================================================

class CustomerSettingsController extends ChangeNotifier {
  CustomerSettingsState _state = const CustomerSettingsState();
  bool _showSignOutDialog = false;
  bool _showPermissionDeniedSheet = false;
  bool _showAccountDeletionSheet = false;
  String? _plannedFeatureSheetTitle;
  String? _snackBarNotice;

  CustomerSettingsState get state => _state;
  bool get showSignOutDialog => _showSignOutDialog;
  bool get showPermissionDeniedSheet => _showPermissionDeniedSheet;
  bool get showAccountDeletionSheet => _showAccountDeletionSheet;
  String? get plannedFeatureSheetTitle => _plannedFeatureSheetTitle;
  String? get snackBarNotice => _snackBarNotice;

  void toggleBookingUpdates(bool val) {
    if (!_state.isAuthenticated) {
      showNotice('يتطلب تفعيل هذا الخيار تسجيل الدخول إلى حسابك');
      return;
    }
    _state = _state.copyWith(bookingUpdatesEnabled: val);
    showNotice(val
        ? 'تم تفعيل إشعارات الحجوزات محلياً'
        : 'تم إيقاف إشعارات الحجوزات محلياً');
    notifyListeners();
  }

  void toggleHostMessages(bool val) {
    if (!_state.isAuthenticated) {
      showNotice('يتطلب تفعيل هذا الخيار تسجيل الدخول إلى حسابك');
      return;
    }
    _state = _state.copyWith(hostMessagesEnabled: val);
    showNotice(val
        ? 'تم تفعيل إشعارات رسائل المضيف محلياً'
        : 'تم إيقاف إشعارات رسائل المضيف محلياً');
    notifyListeners();
  }

  void togglePriceAlerts(bool val) {
    _state = _state.copyWith(priceAlertsEnabled: val);
    showNotice(val
        ? 'تم تفعيل تنبيهات الأسعار والعروض محلياً'
        : 'تم إيقاف تنبيهات الأسعار والعروض محلياً');
    notifyListeners();
  }

  void openSignOutDialog() {
    _showSignOutDialog = true;
    notifyListeners();
  }

  void closeSignOutDialog() {
    _showSignOutDialog = false;
    notifyListeners();
  }

  void confirmSignOutDemo() {
    _showSignOutDialog = false;
    showNotice('معاينة تجريبية: تم تأكيد تسجيل الخروج محلياً دون مسح بيانات الاعتماد الحقيقية');
    notifyListeners();
  }

  void openPermissionDeniedSheet() {
    _showPermissionDeniedSheet = true;
    notifyListeners();
  }

  void closePermissionDeniedSheet() {
    _showPermissionDeniedSheet = false;
    notifyListeners();
  }

  void openAccountDeletionSheet() {
    _showAccountDeletionSheet = true;
    notifyListeners();
  }

  void closeAccountDeletionSheet() {
    _showAccountDeletionSheet = false;
    notifyListeners();
  }

  void openPlannedFeatureSheet(String title) {
    _plannedFeatureSheetTitle = title;
    notifyListeners();
  }

  void closePlannedFeatureSheet() {
    _plannedFeatureSheetTitle = null;
    notifyListeners();
  }

  void showNotice(String msg) {
    _snackBarNotice = msg;
    notifyListeners();
  }

  void clearNotice() {
    _snackBarNotice = null;
    notifyListeners();
  }

  void setScenario(Screen19Scenario scenario) {
    _showSignOutDialog = false;
    _showPermissionDeniedSheet = false;
    _showAccountDeletionSheet = false;
    _plannedFeatureSheetTitle = null;
    _snackBarNotice = null;

    switch (scenario) {
      case Screen19Scenario.mainSettingsTop:
      case Screen19Scenario.mainSettingsScrolled:
      case Screen19Scenario.accessibility200Top:
      case Screen19Scenario.accessibility200Scrolled:
        _state = const CustomerSettingsState();
        break;
      case Screen19Scenario.notificationsPermissionDenied:
        _state = const CustomerSettingsState(
          osNotificationPermissionGranted: false,
        );
        _showPermissionDeniedSheet = true;
        break;
      case Screen19Scenario.signOutConfirmationDialog:
        _state = const CustomerSettingsState();
        _showSignOutDialog = true;
        break;
      case Screen19Scenario.unauthenticatedGuestState:
        _state = const CustomerSettingsState(
          isAuthenticated: false,
          bookingUpdatesEnabled: false,
          hostMessagesEnabled: false,
        );
        break;
      case Screen19Scenario.accountDeletionInfoSheet:
        _state = const CustomerSettingsState();
        _showAccountDeletionSheet = true;
        break;
    }
    notifyListeners();
  }
}

// =============================================================================
// App Root Widget
// =============================================================================

class Screen19PreviewApp extends StatelessWidget {
  const Screen19PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Screen 19 — Settings',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: KonfrmTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF000000),
          primary: const Color(0xFF000000),
          surface: Colors.white,
        ),
      ),
      home: const Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Screen19PreviewView(),
      ),
    );
  }
}

// =============================================================================
// Main Preview View
// =============================================================================

class Screen19PreviewView extends StatefulWidget {
  const Screen19PreviewView({super.key});

  @override
  State<Screen19PreviewView> createState() => Screen19PreviewViewState();
}

class Screen19PreviewViewState extends State<Screen19PreviewView> {
  late final CustomerSettingsController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Screen19Scenario _scenario = Screen19Scenario.mainSettingsTop;
  bool _showDevTools = false;

  @override
  void initState() {
    super.initState();
    _controller = CustomerSettingsController();
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

  void applyScenario(Screen19Scenario scenario) {
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
        applyScenario(Screen19Scenario.mainSettingsTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen19Scenario.mainSettingsScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen19Scenario.notificationsPermissionDenied);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen19Scenario.signOutConfirmationDialog);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen19Scenario.unauthenticatedGuestState);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen19Scenario.accountDeletionInfoSheet);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen19Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen19Scenario.accessibility200Scrolled);
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

                    // Main Scrollable Settings Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Account & Security Section («الأمان وطرق الدخول»)
                            _buildAccountSecuritySection(),
                            const SizedBox(height: 20),

                            // 2. Notifications Section («الإشعارات والتنبيهات»)
                            _buildNotificationsSection(),
                            const SizedBox(height: 20),

                            // 3. App Preferences Section («تفضيلات التطبيق»)
                            _buildAppPreferencesSection(),
                            const SizedBox(height: 20),

                            // 4. Privacy & Account Actions Section («الخصوصية والحساب»)
                            _buildPrivacyAccountSection(),
                            const SizedBox(height: 20),

                            // 5. Prototype Disclaimer Footer
                            _buildPrototypeNoticeBanner(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Overlays
                if (_controller.showSignOutDialog) _buildSignOutDialog(),
                if (_controller.showPermissionDeniedSheet) _buildPermissionDeniedSheet(),
                if (_controller.showAccountDeletionSheet) _buildAccountDeletionSheet(),
                if (_controller.plannedFeatureSheetTitle != null) _buildPlannedFeatureSheet(),
                if (_controller.snackBarNotice != null) _buildNoticeSnackbar(),
                if (_showDevTools) _buildDevToolsPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Top App Bar (Canonical NESTED_CUSTOMER)
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
                key: const Key('settings_back_button'),
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

          // Title: «الإعدادات»
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
                'الإعدادات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000), // Pure Black #000000
                  height: 1.3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Left-side symmetric spacer & hidden QA affordance
          GestureDetector(
            key: const Key('header_dev_tools_trigger'),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _showDevTools = !_showDevTools;
              });
            },
            child: const SizedBox(
              width: 44,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Section 1: الأمان وطرق الدخول
  // ===========================================================================

  Widget _buildAccountSecuritySection() {
    final state = _controller.state;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'الأمان وطرق الدخول',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000), // Pure Black #000000
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          if (!state.isAuthenticated)
            // Guest / Unauthenticated State
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_person_outlined,
                          size: 20,
                          color: Color(0xFF000000),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'سجّل الدخول لعرض بيانات الأمان وإدارة وسائل الدخول وتأكيد المعرّفات الموثقة.',
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    key: const Key('guest_sign_in_button'),
                    onPressed: () {
                      _controller.showNotice('الانتقال إلى شاشة تسجيل الدخول (Screen 08)');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول / إنشاء حساب',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            // Verified Phone Row
            _buildVerifiedIdentifierRow(
              icon: Icons.phone_iphone_outlined,
              title: 'رقم الهاتف الأساسي',
              maskedValue: state.verifiedPhoneMasked,
              isPhone: true,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // Verified Email Row
            _buildVerifiedIdentifierRow(
              icon: Icons.mail_outline,
              title: 'البريد الإلكتروني الأساسي',
              maskedValue: state.verifiedEmailMasked,
              isPhone: false,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // Proposed Entry: Add Alternate Phone
            _buildProposedActionRow(
              key: const Key('row_add_alternate_phone'),
              icon: Icons.add_call,
              title: 'إضافة رقم هاتف بديل',
              subtitle: 'يتطلب التحقق عبر رمز OTP عند تفعيله',
              statusBadge: 'قريباً',
              onTap: () {
                _controller.openPlannedFeatureSheet('إضافة رقم هاتف بديل');
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // Proposed Entry: Add Alternate Email
            _buildProposedActionRow(
              key: const Key('row_add_alternate_email'),
              icon: Icons.mark_email_unread_outlined,
              title: 'إضافة بريد إلكتروني بديل',
              subtitle: 'يتطلب تأكيد رابط التحقق عند تفعيله',
              statusBadge: 'قريباً',
              onTap: () {
                _controller.openPlannedFeatureSheet('إضافة بريد إلكتروني بديل');
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // Proposed Entry: Apple Sign-In Linking
            _buildProposedActionRow(
              key: const Key('row_link_apple'),
              icon: Icons.apple,
              title: 'ربط حساب Apple',
              subtitle: 'تسجيل الدخول السريع عبر Apple ID',
              statusBadge: 'غير متاح حالياً',
              onTap: () {
                _controller.openPlannedFeatureSheet('ربط حساب Apple');
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // Proposed Entry: Google Sign-In Linking
            _buildProposedActionRow(
              key: const Key('row_link_google'),
              icon: Icons.g_mobiledata,
              title: 'ربط حساب Google',
              subtitle: 'تسجيل الدخول السريع عبر حساب Google',
              statusBadge: 'غير متاح حالياً',
              onTap: () {
                _controller.openPlannedFeatureSheet('ربط حساب Google');
              },
            ),

            // Security Footnote
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF9FAFB),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 15,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'هذه المعرّفات معروضة كبيانات تجريبية في هذه المعاينة؛ تغيير وسائل الدخول الفعلية يتطلب التحقق من الهوية.',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifiedIdentifierRow({
    required IconData icon,
    required String title,
    required String maskedValue,
    required bool isPhone,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF000000)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 12,
                            color: Color(0xFF059669),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'مؤكّد (بيانات تجريبية)',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Directionality(
                  textDirection: isPhone ? ui.TextDirection.ltr : ui.TextDirection.rtl,
                  child: Text(
                    maskedValue,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000), // Pure Black #000000
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.lock_outline,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  Widget _buildProposedActionRow({
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    required String statusBadge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF000000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000), // Pure Black #000000
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusBadge,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Section 2: الإشعارات والتنبيهات
  // ===========================================================================

  Widget _buildNotificationsSection() {
    final state = _controller.state;
    final osGranted = state.osNotificationPermissionGranted;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_none_outlined,
                    size: 18,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'الإشعارات والتنبيهات',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000), // Pure Black #000000
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // OS-Level Permission State Row
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('row_os_notification_permission'),
              onTap: () {
                if (!osGranted) {
                  _controller.openPermissionDeniedSheet();
                } else {
                  _controller.showNotice('إذن النظام مفعل لاستقبال التنبيهات على هذا الجهاز');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: osGranted ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        osGranted ? Icons.phonelink_ring : Icons.notifications_off_outlined,
                        size: 20,
                        color: osGranted ? const Color(0xFF059669) : const Color(0xFFD97706),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              const Text(
                                'إذن إشعارات النظام (الجهاز)',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: osGranted ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: osGranted ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                                  ),
                                ),
                                child: Text(
                                  osGranted ? 'مفعّل (حالة توضيحية)' : 'متوقف (حالة توضيحية)',
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: osGranted ? const Color(0xFF059669) : const Color(0xFFB45309),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            osGranted
                                ? 'حالة توضيحية — المعاينة لا تقرأ إذن النظام الفعلي بالجهاز'
                                : 'محاكاة لحالة إيقاف الإذن من النظام — المعاينة لا تقرأ إذن النظام الفعلي',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              color: osGranted ? const Color(0xFF6B7280) : const Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Information Disclaimer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF9FAFB),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.info_outline,
                  size: 15,
                  color: Color(0xFF6B7280),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ملاحظة: حالة الإذن المعروضة توضيحية، والتبديل أدناه محاكاة تجريبية محلية فقط لا تؤثر على إشعارات الجهاز الفعلية.',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          if (!state.isAuthenticated) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFFFEF3C7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.lock_outline,
                    size: 15,
                    color: Color(0xFFD97706),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تنبيهات الحجوزات والرسائل تتطلب تسجيل الدخول بحساب مستخدم',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB45309),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          ],

          // Toggle 1: Booking Updates
          _buildNotificationToggleRow(
            key: const Key('toggle_booking_updates'),
            title: 'تحديثات الحجوزات والطلبات',
            subtitle: !state.isAuthenticated
                ? 'يتطلب تسجيل الدخول لربط تنبيهات الحجز بحسابك'
                : 'إشعارات فورية عند قبول المضيف، تأكيد الحجز، أو أي تعديل',
            value: state.bookingUpdatesEnabled,
            isEnabled: osGranted && state.isAuthenticated,
            onChanged: _controller.toggleBookingUpdates,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Toggle 2: Host Messages
          _buildNotificationToggleRow(
            key: const Key('toggle_host_messages'),
            title: 'رسائل المضيف والمحادثات',
            subtitle: !state.isAuthenticated
                ? 'يتطلب تسجيل الدخول لاستلام رسائل المضيفين'
                : 'تنبيهات فورية عند استلام رسائل مباشرة من مضيف وحدتك',
            value: state.hostMessagesEnabled,
            isEnabled: osGranted && state.isAuthenticated,
            onChanged: _controller.toggleHostMessages,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Toggle 3: Price Alerts & Promotions
          _buildNotificationToggleRow(
            key: const Key('toggle_price_alerts'),
            title: 'العروض وتنبيهات الأسعار',
            subtitle: 'إشعارات دورية بالعروض الحصرية والتخفيضات في وحداتك المفضلة',
            value: state.priceAlertsEnabled,
            isEnabled: osGranted,
            onChanged: _controller.togglePriceAlerts,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggleRow({
    Key? key,
    required String title,
    required String subtitle,
    required bool value,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isEnabled ? const Color(0xFF000000) : const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    color: isEnabled ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Custom Accessible Switch
          Semantics(
            toggled: value,
            enabled: isEnabled,
            label: title,
            child: Switch(
              key: key,
              value: value,
              onChanged: isEnabled ? onChanged : null,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF000000), // Pure Black #000000
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Section 3: تفضيلات التطبيق
  // ===========================================================================

  Widget _buildAppPreferencesSection() {
    final state = _controller.state;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune_outlined,
                    size: 18,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تفضيلات التطبيق',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000), // Pure Black #000000
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Language Row
          _buildPreferenceTile(
            key: const Key('row_app_language'),
            icon: Icons.language,
            title: 'لغة التطبيق',
            subtitle: 'اللغة العربية هي اللغة المعتمدة حالياً للواجهة',
            valueBadge: 'العربية (الافتراضية)',
            onTap: () {
              _controller.showNotice('اللغة العربية هي اللغة الرسمية المعتمدة حالياً للتطبيق');
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Currency Row
          _buildPreferenceTile(
            key: const Key('row_pricing_currency'),
            icon: Icons.monetization_on_outlined,
            title: 'عملة التسعير والمدفوعات',
            subtitle: 'العملة الرسمية لجميع الحجوزات والمعاملات',
            valueBadge: state.pricingCurrency,
            onTap: () {
              _controller.showNotice('الجنيه المصري (EGP) هو العملة المعتمدة حصراً لكافة الحجوزات');
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Reduced Motion Row
          _buildPreferenceTile(
            key: const Key('row_reduced_motion'),
            icon: Icons.motion_photos_off_outlined,
            title: 'تقليل الحركة والتأثيرات',
            subtitle: 'يتبع إعدادات إمكانية الوصول الخاصة بنظام جهازك',
            valueBadge: 'تلقائي (حسب النظام)',
            onTap: () {
              _controller.showNotice('التطبيق يتبع إعدادات تقليل الحركة المحددة في نظام جهازك تلقائياً');
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Appearance Theme Row
          _buildPreferenceTile(
            key: const Key('row_appearance_theme'),
            icon: Icons.light_mode_outlined,
            title: 'المظهر والسمة',
            subtitle: 'الوضع الفاتح المعتمد — الوضع الداكن غير متاح حالياً',
            valueBadge: state.appearanceTheme,
            onTap: () {
              _controller.showNotice('الوضع الفاتح هو المعتمد في هوية كونفرم؛ الوضع الداكن قيد الدراسة');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile({
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    required String valueBadge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF000000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            valueBadge,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Section 4: الخصوصية والحساب
  // ===========================================================================

  Widget _buildPrivacyAccountSection() {
    final state = _controller.state;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.privacy_tip_outlined,
                    size: 18,
                    color: Color(0xFF000000), // Pure Black #000000
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'الخصوصية وإدارة الحساب',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000), // Pure Black #000000
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Privacy Policy Link
          _buildLinkRow(
            key: const Key('row_privacy_policy'),
            icon: Icons.policy_outlined,
            title: 'سياسة الخصوصية',
            subtitle: 'تعرّف على كيفية جمع وحماية واستخدام بياناتك في كونفرم',
            onTap: () {
              _controller.showNotice('الانتقال إلى شاشة سياسة الخصوصية');
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Terms of Service Link
          _buildLinkRow(
            key: const Key('row_terms_of_service'),
            icon: Icons.description_outlined,
            title: 'شروط الخدمة والاستخدام',
            subtitle: 'الأحكام المنظمة لتجربة الاستئجار والحجز الموثوق',
            onTap: () {
              _controller.showNotice('الانتقال إلى شاشة شروط الخدمة');
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Account Deletion & Data Export
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('row_account_deletion'),
              onTap: _controller.openAccountDeletionSheet,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Icon(
                        Icons.file_download_outlined,
                        size: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              const Text(
                                'طلب تصدير البيانات أو حذف الحساب',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'قيد الاعتماد',
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'إدارة حقوق الخصوصية والبيانات الشخصية',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (state.isAuthenticated) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // Sign Out Action
            Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('row_sign_out'),
                onTap: _controller.openSignOutDialog,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.logout,
                          size: 20,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تسجيل الخروج',
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'إنهاء الجلسة النشطة على هذا الجهاز فقط',
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
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkRow({
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF000000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Prototype Notice Banner
  // ===========================================================================

  Widget _buildPrototypeNoticeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.developer_mode,
            size: 16,
            color: Color(0xFF000000),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'معاينة تجريبية: يتم حفظ وتعديل البيانات محلياً فقط على هذا الجهاز. لن يتم إرسال أي تعديلات إلى خوادم الإنتاج.',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                color: Color(0xFF4B5563),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Overlays: Dialogs & Bottom Sheets
  // ===========================================================================

  Widget _buildSignOutDialog() {
    return Container(
      color: const Color(0x66000000),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'هل أنت متأكد من رغبتك في تسجيل الخروج من هذا الجهاز؟ ستحتاج إلى إعادة تسجيل الدخول للوصول إلى بيانات حسابك وحجوزاتك.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('sign_out_cancel_button'),
                      onPressed: _controller.closeSignOutDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF000000),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('sign_out_confirm_button'),
                      onPressed: _controller.confirmSignOutDemo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'تأكيد الخروج',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedSheet() {
    return Container(
      color: const Color(0x66000000),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_off_outlined,
                      size: 20,
                      color: Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'إذن الإشعارات في النظام (حالة توضيحية)',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('permission_sheet_close'),
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF000000)),
                    onPressed: _controller.closePermissionDeniedSheet,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                'توضح هذه الشاشة الإرشادات التي ستظهر للمستخدم في حال إيقاف إذن الإشعارات من إعدادات نظام الجهاز، حيث تتطلب متابعة الحجوزات الفورية تفعيل الإذن من إعدادات النظام.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'خطوات تفعيل الإذن من النظام:',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '1. افتح تطبيق «الضبط / الإعدادات» على هاتفك\n2. اختر «التطبيقات» ثم ابحث عن «KONFRM»\n3. اضغط على «الإشعارات» وفعّل خيار السماح بالتنبيهات',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                key: const Key('permission_sheet_dismiss_button'),
                onPressed: _controller.closePermissionDeniedSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDeletionSheet() {
    return Container(
      color: const Color(0x66000000),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.privacy_tip_outlined,
                      size: 20,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'طلب تصدير البيانات أو حذف الحساب',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('account_deletion_sheet_close'),
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF000000)),
                    onPressed: _controller.closeAccountDeletionSheet,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                'إجراءات تصدير البيانات أو حذف الحساب غير متاحة حالياً وهي قيد الإعداد القانوني والتنظيمي. هذه المعاينة توضيحية فقط ولا تقوم بتقديم أي طلب فعلي. ستخضع هذه الإجراءات لسياسات الخصوصية وشروط الاستخدام المعتمدة فور إطلاقها رسمياً.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, size: 16, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'هذه الخدمة قيد الإعداد والدراسة القانونية، ولن يتم تنفيذ أي إجراء حذف أو تصدير من خلال هذه المعاينة.',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                key: const Key('account_deletion_sheet_dismiss'),
                onPressed: _controller.closeAccountDeletionSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlannedFeatureSheet() {
    final title = _controller.plannedFeatureSheetTitle ?? '';

    return Container(
      color: const Color(0x66000000),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.upcoming_outlined,
                      size: 20,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('planned_sheet_close'),
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF000000)),
                    onPressed: _controller.closePlannedFeatureSheet,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                'خاصية «$title» قيد الإعداد ضمن خطة ترقية الأمان ووسائل الدخول الموحدة لمنصة كونفرم. ستتاح هذه الإمكانية فور اعتماد بروتوكول التحقق والتأكيد دون التأثير على حسابك الحالي.',
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                key: const Key('planned_sheet_dismiss'),
                onPressed: _controller.closePlannedFeatureSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeSnackbar() {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF000000), // Pure Black #000000
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _controller.snackBarNotice ?? '',
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                onPressed: _controller.clearNotice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Dev QA Control Drawer / Overlay
  // ===========================================================================

  Widget _buildDevToolsPanel() {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF000000), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'لوحة سيناريوهات المعاينة (QA)',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _showDevTools = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...Screen19Scenario.values.map((s) {
                final isSelected = s == _scenario;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: InkWell(
                    onTap: () {
                      applyScenario(s);
                      setState(() {
                        _showDevTools = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF000000) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s.title,
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
