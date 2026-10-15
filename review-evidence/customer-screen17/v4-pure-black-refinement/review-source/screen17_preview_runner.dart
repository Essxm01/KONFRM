// =============================================================================
// KONFRM Customer Screen 17 V2 — "Personal Passport" / مساحتي في كونفرم
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Design Authority: Cairo Typography, RTL First, Pure Monochrome & Neutrals
// Navigation Context: Account Root (CustomerBottomNavigation Tab 3 active)
// Governing Issues:
//   - Issue #170 (Founder V2 Redesign Authorization & Flagship Identity Direction)
//   - Issue #172 (Identity, Avatar, QR, Linked Account, Profile Contracts Deferred)
//   - Issue #173 (Proposed Customer Wallet Financial Governance Deferred)
//   - Issue #166 (Design-First, Anti-Blue, RTL Physical Left Chevrons)
//   - Issue #155 (Historical Evidence Preservation - V1 Retained Unchanged)
//   - Issue #145 (Device Serial Redaction)
//
// Scope: Isolated visual preview with synthetic scenarios. Zero production mutations.
// =============================================================================

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import 'screen17_demo_portrait_bytes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen17PreviewApp());
}

// =============================================================================
// Domain Models & Synthetic Helpers
// =============================================================================

/// Egyptian standard phone masking helper (used in private profile/security).
String maskDisplayPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) return '+•• •••• ••••';
  final clean = phone.trim().replaceAll(RegExp(r'\s+'), '');

  final egMatch = RegExp(r'^\+20(1[0125])(\d{4})(\d{4})$').firstMatch(clean);
  if (egMatch != null) {
    final operator = egMatch.group(1);
    final last4 = egMatch.group(3);
    return '+20 $operator••••$last4';
  }

  final egLocalMatch = RegExp(r'^0(1[0125])(\d{4})(\d{4})$').firstMatch(clean);
  if (egLocalMatch != null) {
    final operator = egLocalMatch.group(1);
    final last4 = egLocalMatch.group(3);
    return '+20 $operator••••$last4';
  }

  final intlMatch = RegExp(r'^(\+\d{1,3})(\d{2,3})\d{3,}(\d{4})$').firstMatch(clean);
  if (intlMatch != null) {
    final country = intlMatch.group(1);
    final opCode = intlMatch.group(2);
    final last4 = intlMatch.group(3);
    return '$country $opCode••••$last4';
  }

  return '+•• •••• ••••';
}

/// Derives user initials in Arabic.
/// 'أحمد مصطفى' -> 'أ.م'
String deriveUserInitials(String? name) {
  if (name == null || name.trim().isEmpty) return 'م';
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.length == 1) {
    return parts[0].length >= 2 ? parts[0].substring(0, 2) : parts[0];
  }
  return '${parts[0][0]}.${parts[1][0]}';
}

/// Customer profile data model for Screen 17 V2 Passport.
class CustomerProfileData {
  final String userId;
  final String? fullName;
  final String? proposedUsername;
  final Uint8List? portraitBytes;
  final String? verifiedPhone;
  final String? verifiedEmail;
  final bool hasUpcomingStay;
  final int upcomingNights;
  final String upcomingStayTitle;
  final String upcomingStayDates;

  const CustomerProfileData({
    required this.userId,
    this.fullName,
    this.proposedUsername,
    this.portraitBytes,
    this.verifiedPhone,
    this.verifiedEmail,
    this.hasUpcomingStay = false,
    this.upcomingNights = 5,
    this.upcomingStayTitle = 'فيلا فاخرة بإطلالة مباشرة على البحر — مراسي',
    this.upcomingStayDates = '20 أكتوبر — 25 أكتوبر 2026',
  });

  bool get isIncomplete => fullName == null || fullName!.trim().isEmpty;
  bool get hasPortrait => portraitBytes != null && portraitBytes!.isNotEmpty;
  String get displayName => fullName?.trim().isNotEmpty == true ? fullName!.trim() : 'مستأجر';
  String get initials => deriveUserInitials(fullName);
}

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen17Scenario {
  authenticatedFlagshipTop,
  authenticatedFlagshipScrolled,
  authenticatedNoPhotoFallback,
  authenticatedIncompleteProfile,
  guestUnauthenticated,
  initialLoadingSkeleton,
  networkErrorInitial,
  sessionExpired401,
  qrModalMyCode,
  qrModalScan,
  walletModalConcept,
  logoutConfirmationDialog,
  compactHeroVariant,
  accessibility200Top,
  accessibility200Scrolled,
}

extension Screen17ScenarioMetadata on Screen17Scenario {
  String get title {
    switch (this) {
      case Screen17Scenario.authenticatedFlagshipTop:
        return '01 Flagship Hero (Top Fold)';
      case Screen17Scenario.authenticatedFlagshipScrolled:
        return '02 Flagship Hero (Scrolled)';
      case Screen17Scenario.authenticatedNoPhotoFallback:
        return '03 No-Photo Initials Fallback';
      case Screen17Scenario.authenticatedIncompleteProfile:
        return '04 Incomplete Profile Prompt';
      case Screen17Scenario.guestUnauthenticated:
        return '05 Guest / Unauthenticated';
      case Screen17Scenario.initialLoadingSkeleton:
        return '06 Initial Loading (Skeleton)';
      case Screen17Scenario.networkErrorInitial:
        return '07 Network Error (Honest Failure)';
      case Screen17Scenario.sessionExpired401:
        return '08 Session Expired (401)';
      case Screen17Scenario.qrModalMyCode:
        return '09 Personal QR Code (رمزي)';
      case Screen17Scenario.qrModalScan:
        return '10 Personal QR Scanner (مسح رمز)';
      case Screen17Scenario.walletModalConcept:
        return '11 Wallet Modal Concept (#173)';
      case Screen17Scenario.logoutConfirmationDialog:
        return '12 Logout Confirmation Dialog';
      case Screen17Scenario.compactHeroVariant:
        return '13 Compact Hero Composition';
      case Screen17Scenario.accessibility200Top:
        return '14 Accessibility 200% (Top Fold)';
      case Screen17Scenario.accessibility200Scrolled:
        return '15 Accessibility 200% (Scrolled)';
    }
  }

  double get scrollOffset {
    switch (this) {
      case Screen17Scenario.authenticatedFlagshipScrolled:
      case Screen17Scenario.accessibility200Scrolled:
        return 480.0;
      default:
        return 0.0;
    }
  }

  double get textScale {
    switch (this) {
      case Screen17Scenario.accessibility200Top:
      case Screen17Scenario.accessibility200Scrolled:
        return 2.0;
      default:
        return 1.0;
    }
  }
}

// =============================================================================
// State Controller
// =============================================================================

class Screen17AccountController extends ChangeNotifier {
  bool _isAuthenticated = true;
  bool _isLoading = false;
  bool _isHardError = false;
  bool _is401Expired = false;
  int _unreadNotificationCount = 2;
  int _savedFavoritesCount = 4;
  int _activeBookingsCount = 1;
  CustomerProfileData? _profile;
  String? _dialogNotice;
  bool _showLogoutDialog = false;
  bool _showQrSheet = false;
  int _qrTab = 0; // 0: My QR, 1: Scan QR
  bool _showWalletSheet = false;
  bool _isCompactHero = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isHardError => _isHardError;
  bool get is401Expired => _is401Expired;
  int get unreadNotificationCount => _unreadNotificationCount;
  int get savedFavoritesCount => _savedFavoritesCount;
  int get activeBookingsCount => _activeBookingsCount;
  CustomerProfileData? get profile => _profile;
  String? get dialogNotice => _dialogNotice;
  bool get showLogoutDialog => _showLogoutDialog;
  bool get showQrSheet => _showQrSheet;
  int get qrTab => _qrTab;
  bool get showWalletSheet => _showWalletSheet;
  bool get isCompactHero => _isCompactHero;

  Screen17AccountController() {
    _loadDefaultFlagshipState();
  }

  void _loadDefaultFlagshipState() {
    _isAuthenticated = true;
    _isLoading = false;
    _isHardError = false;
    _is401Expired = false;
    _unreadNotificationCount = 2;
    _savedFavoritesCount = 4;
    _activeBookingsCount = 1;
    _dialogNotice = null;
    _showLogoutDialog = false;
    _showQrSheet = false;
    _qrTab = 0;
    _showWalletSheet = false;
    _isCompactHero = true;
    _profile = CustomerProfileData(
      userId: 'usr_cst_001',
      fullName: 'أحمد مصطفى',
      proposedUsername: 'ahmed_mostafa',
      portraitBytes: kScreen17DemoPortraitBytes,
      verifiedPhone: '+201012345678',
      verifiedEmail: 'ahmed.mostafa@example.com',
      hasUpcomingStay: true,
      upcomingNights: 5,
      upcomingStayTitle: 'فيلا فاخرة بإطلالة مباشرة على البحر — مراسي',
      upcomingStayDates: '20 أكتوبر — 25 أكتوبر 2026',
    );
  }

  void setScenario(Screen17Scenario scenario) {
    _showLogoutDialog = false;
    _showQrSheet = false;
    _showWalletSheet = false;
    _dialogNotice = null;
    _isCompactHero = true;

    switch (scenario) {
      case Screen17Scenario.authenticatedFlagshipTop:
      case Screen17Scenario.authenticatedFlagshipScrolled:
      case Screen17Scenario.accessibility200Top:
      case Screen17Scenario.accessibility200Scrolled:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _unreadNotificationCount = 2;
        _savedFavoritesCount = 4;
        _activeBookingsCount = 1;
        _profile = CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: kScreen17DemoPortraitBytes,
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;

      case Screen17Scenario.authenticatedNoPhotoFallback:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _unreadNotificationCount = 2;
        _savedFavoritesCount = 4;
        _activeBookingsCount = 1;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: null, // Initials fallback
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;

      case Screen17Scenario.authenticatedIncompleteProfile:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _unreadNotificationCount = 0;
        _savedFavoritesCount = 0;
        _activeBookingsCount = 0;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_002',
          fullName: null, // Incomplete
          proposedUsername: null,
          portraitBytes: null,
          verifiedPhone: '+201012345678',
          verifiedEmail: null,
          hasUpcomingStay: false,
        );
        break;

      case Screen17Scenario.guestUnauthenticated:
        _isAuthenticated = false;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _profile = null;
        break;

      case Screen17Scenario.initialLoadingSkeleton:
        _isAuthenticated = true;
        _isLoading = true;
        _isHardError = false;
        _is401Expired = false;
        _profile = null;
        break;

      case Screen17Scenario.networkErrorInitial:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = true;
        _is401Expired = false;
        _profile = null;
        break;

      case Screen17Scenario.sessionExpired401:
        _isAuthenticated = false;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = true;
        _profile = null;
        break;

      case Screen17Scenario.qrModalMyCode:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _showQrSheet = true;
        _qrTab = 0;
        _profile = CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: kScreen17DemoPortraitBytes,
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;

      case Screen17Scenario.qrModalScan:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _showQrSheet = true;
        _qrTab = 1;
        _profile = CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: kScreen17DemoPortraitBytes,
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;

      case Screen17Scenario.walletModalConcept:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _showWalletSheet = true;
        _profile = CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: kScreen17DemoPortraitBytes,
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;

      case Screen17Scenario.logoutConfirmationDialog:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _showLogoutDialog = true;
        _profile = CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: kScreen17DemoPortraitBytes,
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;

      case Screen17Scenario.compactHeroVariant:
        _isAuthenticated = true;
        _isLoading = false;
        _isHardError = false;
        _is401Expired = false;
        _isCompactHero = true;
        _profile = CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
          portraitBytes: kScreen17DemoPortraitBytes,
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
          hasUpcomingStay: true,
        );
        break;
    }
    notifyListeners();
  }

  void openQrSheet({int tab = 0}) {
    _showQrSheet = true;
    _qrTab = tab;
    notifyListeners();
  }

  void closeQrSheet() {
    _showQrSheet = false;
    notifyListeners();
  }

  void setQrTab(int tab) {
    _qrTab = tab;
    notifyListeners();
  }

  void openWalletSheet() {
    _showWalletSheet = true;
    notifyListeners();
  }

  void closeWalletSheet() {
    _showWalletSheet = false;
    notifyListeners();
  }

  void requestLogout() {
    _showLogoutDialog = true;
    notifyListeners();
  }

  void cancelLogout() {
    _showLogoutDialog = false;
    notifyListeners();
  }

  void confirmLogout() {
    _showLogoutDialog = false;
    _isAuthenticated = false;
    _profile = null;
    notifyListeners();
  }

  void showNotice(String msg) {
    _dialogNotice = msg;
    notifyListeners();
  }

  void clearNotice() {
    _dialogNotice = null;
    notifyListeners();
  }
}

// =============================================================================
// Preview App Shell
// =============================================================================

class Screen17PreviewApp extends StatelessWidget {
  const Screen17PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KONFRM Customer Screen 17 Simplified Premium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: KonfrmTypography.fontFamily,
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
      ),
      home: const Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Screen17PreviewView(),
      ),
    );
  }
}

// =============================================================================
// Preview View (Main Widget)
// =============================================================================

class Screen17PreviewView extends StatefulWidget {
  const Screen17PreviewView({super.key});

  @override
  State<Screen17PreviewView> createState() => Screen17PreviewViewState();
}

class Screen17PreviewViewState extends State<Screen17PreviewView> {
  late final Screen17AccountController _controller;
  late final ScrollController _scrollController;
  late final FocusNode _keyboardFocusNode;
  Screen17Scenario _scenario = Screen17Scenario.authenticatedFlagshipTop;
  bool _showDevTools = false;

  @override
  void initState() {
    super.initState();
    _controller = Screen17AccountController();
    _scrollController = ScrollController();
    _keyboardFocusNode = FocusNode();
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

  void applyScenario(Screen17Scenario scenario) {
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
        applyScenario(Screen17Scenario.authenticatedFlagshipTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen17Scenario.authenticatedFlagshipScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen17Scenario.authenticatedNoPhotoFallback);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen17Scenario.authenticatedIncompleteProfile);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen17Scenario.guestUnauthenticated);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen17Scenario.initialLoadingSkeleton);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen17Scenario.networkErrorInitial);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen17Scenario.sessionExpired401);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        applyScenario(Screen17Scenario.qrModalMyCode);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyA) {
        applyScenario(Screen17Scenario.qrModalScan);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyB) {
        applyScenario(Screen17Scenario.walletModalConcept);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyC) {
        applyScenario(Screen17Scenario.logoutConfirmationDialog);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyD) {
        applyScenario(Screen17Scenario.compactHeroVariant);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyE) {
        applyScenario(Screen17Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyF) {
        applyScenario(Screen17Scenario.accessibility200Scrolled);
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
          bottomNavigationBar: CustomerBottomNavigation(
            selectedIndex: 3, // Account tab active!
            onSelected: (index) {
              final customerDestinations = ['استكشف', 'المفضلة', 'حجوزاتي', 'الحساب'];
              if (index == 3) {
                applyScenario(Screen17Scenario.authenticatedFlagshipTop);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'معاينة: الانتقال إلى الوجهة (${customerDestinations[index]})',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    duration: const Duration(milliseconds: 700),
                  ),
                );
              }
            },
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Safe Area Top Spacing
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).padding.top,
                  ),

                  // Header Bar (Account Root Hub + QR Action)
                  _buildHeaderBar(),

                  // Main Scrollable Area
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        _controller.setScenario(_scenario);
                      },
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
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
                          else if (!_controller.isAuthenticated)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildGuestAccountView(),
                            )
                          else
                            _buildAuthenticatedAccountSliver(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // QR Code Bottom Sheet Modal
              if (_controller.showQrSheet) _buildQrModalSheet(),

              // Wallet Concept Bottom Sheet Modal
              if (_controller.showWalletSheet) _buildWalletModalSheet(),

              // Logout Confirmation Dialog
              if (_controller.showLogoutDialog) _buildLogoutDialog(),

              // Dev QA Overlay Panel
              if (_showDevTools) _buildDevToolsPanel(),

              // SnackBar/Feedback Overlay
              if (_controller.dialogNotice != null) _buildNoticeSnackbar(),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Header Bar (Account Root Hub + QR Action)
  // ===========================================================================

  Widget _buildHeaderBar() {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Screen Title (Right in RTL)
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
                'حسابي',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Header Actions (Left in RTL): Personal QR Entry + Subtle QA Icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Personal QR Entry Button
              Semantics(
                button: true,
                label: 'رمز التعريف الشخصي QR',
                child: GestureDetector(
                  key: const Key('header_qr_button'),
                  onTap: () {
                    if (_controller.isAuthenticated) {
                      _controller.openQrSheet();
                    } else {
                      _controller.showNotice('يرجى تسجيل الدخول أولاً لعرض رمز حسابك الشخصي');
                    }
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        size: 22,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Authenticated State View (Sliver)
  // ===========================================================================

  Widget _buildAuthenticatedAccountSliver() {
    final profile = _controller.profile!;
    final textScaler = MediaQuery.textScalerOf(context);
    final isLargeText = _scenario.textScale >= 1.5 || textScaler.scale(1.0) >= 1.5;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // 1. Unboxed Identity Hero ("Personal Passport")
          // Compact Horizontal Hero is default; adapts gracefully to vertical hero at >=150% font scale
          if (isLargeText || !_controller.isCompactHero)
            _buildFlagshipIdentityHero(profile)
          else
            _buildCompactIdentityHero(profile),
          const SizedBox(height: 16),

          // 2. Incomplete Profile Prompt (when applicable)
          if (profile.isIncomplete) ...[
            _buildIncompleteProfilePrompt(),
            const SizedBox(height: 16),
          ],

          // Note: Shortcut tiles for Bookings, Favorites, and Notifications
          // have been COMPLETELY REMOVED per Founder UX Decision (Issue #170 / #174).

          // 3. Contextual Upcoming Stay Strip (0/1 - Restrained single summary)
          if (profile.hasUpcomingStay) ...[
            _buildUpcomingStayCard(profile),
            const SizedBox(height: 18),
          ],

          // 4. Single Unified Editorial Navigation List (Replacing 3 separate boxes)
          _buildCardContainer([
            _buildSectionHeader('الحساب والملف الشخصي'),
            _buildNavigationRow(
              key: const Key('nav_profile_edit'),
              icon: Icons.person_outline,
              title: 'الملف الشخصي',
              subtitle: 'تعديل البيانات والصورة والمعرّف',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى مواصفة تعديل الملف (شاشة 18)'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildNavigationRow(
              key: const Key('nav_privacy_security'),
              icon: Icons.shield_outlined,
              title: 'الخصوصية والأمان',
              subtitle: 'إدارة الجلسات وكلمة المرور',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى إعدادات الأمان (شاشة 19)'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildNavigationRow(
              key: const Key('nav_linked_accounts'),
              icon: Icons.link_outlined,
              title: 'الحسابات المرتبطة',
              subtitle: 'وسائل الدخول (Apple / Google)',
              trailingTag: 'مقترح #172',
              onTap: () => _controller.showNotice('معاينة: مواصفة الحسابات المرتبطة الآمنة (مفهوم شاشة 19)'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildSectionHeader('المالية والمدفوعات'),
            _buildNavigationRow(
              key: const Key('nav_payment_history'),
              icon: Icons.receipt_long_outlined,
              title: 'سجل المدفوعات',
              subtitle: 'العربون وسجل المعاملات',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى سجل المدفوعات (شاشة 20)'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildNavigationRow(
              key: const Key('nav_wallet_concept'),
              icon: Icons.account_balance_wallet_outlined,
              title: 'محفظة كونفرم',
              subtitle: 'الرصيد والاستردادات المعتمدة',
              trailingTag: 'مفهوم #173',
              onTap: () => _controller.openWalletSheet(),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildSectionHeader('المساعدة والخدمات'),
            _buildNavigationRow(
              key: const Key('nav_help_support'),
              icon: Icons.help_outline,
              title: 'المساعدة والدعم',
              subtitle: 'الأسئلة الشائعة وإرشادات الحجز',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى الدعم والمساعدة (شاشة 21)'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildNavigationRow(
              key: const Key('nav_share_konfrm'),
              icon: Icons.share_outlined,
              title: 'شارك كونفرم مع معارفك',
              subtitle: 'دعوة الأصدقاء لتجربة استئجار موثوقة',
              onTap: () => _controller.showNotice('معاينة: فتح قائمة مشاركة الرابط الرسمي لتطبيق كونفرم'),
            ),
          ]),
          const SizedBox(height: 20),

          // 5. Sign Out Action Button
          _buildLogoutButton(),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  // ===========================================================================
  // Flagship Identity Hero ("Portrait First" / Unboxed Personal Passport)
  // ===========================================================================

  Widget _buildFlagshipIdentityHero(CustomerProfileData profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar (104x104) with Overlapping Camera Affordance
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main Avatar Circle
                GestureDetector(
                  key: const Key('avatar_tap_area'),
                  onTap: () {
                    _showPhotoActionSheet();
                  },
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profile.hasPortrait
                          ? Image.memory(
                              profile.portraitBytes!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: const Color(0xFF000000),
                              child: Center(
                                child: Text(
                                  profile.initials,
                                  style: const TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                // Overlapping Camera / Edit Affordance (Lower Edge)
                // Founder Directive: BLACK icon inside WHITE circular surface, subtle border, 48dp target.
                Positioned(
                  bottom: -2,
                  left: -2,
                  child: GestureDetector(
                    key: const Key('camera_edit_badge'),
                    onTap: () {
                      _showPhotoActionSheet();
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Customer Display Name (Bold Cairo 22 - Pure Black)
          Text(
            profile.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),

          // Proposed @username (Developer Fixture Only — LTR Isolated)
          if (profile.proposedUsername != null) ...[
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '@${profile.proposedUsername}',
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Notice: Phone number is explicitly NOT shown here in the hero fold per directive!

          // Single Compact Edit Profile CTA Button
          GestureDetector(
            key: const Key('hero_edit_profile_button'),
            onTap: () {
              _controller.showNotice('معاينة: الانتقال إلى تعديل الملف الشخصي (شاشة 18)');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 15,
                    color: Color(0xFF000000),
                  ),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'تعديل الملف',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Alternative Compact Editorial Hero Composition
  // ===========================================================================

  Widget _buildCompactIdentityHero(CustomerProfileData profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar (76x76) on physical right in RTL
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                key: const Key('avatar_tap_area'),
                onTap: _showPhotoActionSheet,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: profile.hasPortrait
                        ? Image.memory(
                            profile.portraitBytes!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: const Color(0xFF000000),
                            child: Center(
                              child: Text(
                                profile.initials,
                                style: const TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                left: -4,
                child: GestureDetector(
                  key: const Key('camera_edit_badge'),
                  onTap: _showPhotoActionSheet,
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Name & Handle in center/middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
                  ),
                ),
                if (profile.proposedUsername != null) ...[
                  const SizedBox(height: 2),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      '@${profile.proposedUsername}',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Edit Action Button on physical left in RTL
          GestureDetector(
            key: const Key('hero_edit_profile_button'),
            onTap: () {
              _controller.showNotice('معاينة: الانتقال إلى تعديل الملف الشخصي (شاشة 18)');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Text(
                'تعديل',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Contextual Strip: Upcoming Stay (0/1)
  // ===========================================================================

  Widget _buildUpcomingStayCard(CustomerProfileData profile) {
    return GestureDetector(
      key: const Key('upcoming_stay_card'),
      onTap: () {
        _controller.showNotice('معاينة: الانتقال إلى تفاصيل الحجز ومركز الإقامة (شاشة 13)');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'إقامتك القادمة',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text(
                    'حجز مؤكد',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              profile.upcomingStayTitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${profile.upcomingStayDates} (${profile.upcomingNights} ليالٍ)',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Physical LEFT Arrow for RTL forward progression
                const Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Incomplete Profile Prompt
  // ===========================================================================

  Widget _buildIncompleteProfilePrompt() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Center(
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFF000000),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أكمل بيانات حسابك',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'إضافة الاسم والصورة لتسهيل التواصل مع الملاك',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _controller.showNotice('معاينة: الانتقال إلى إكمال البيانات (شاشة 18)');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'إكمال',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
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

  // ===========================================================================
  // Grouped Navigation Components
  // ===========================================================================

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildNavigationRow({
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingTag,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      if (trailingTag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            trailingTag,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Physical LEFT chevron pointing for RTL forward navigation
            const Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Icon(
                Icons.chevron_left,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Logout Button
  // ===========================================================================

  Widget _buildLogoutButton() {
    return GestureDetector(
      key: const Key('account_logout_button'),
      onTap: () {
        _controller.requestLogout();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        ),
        child: const Center(
          child: Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFDC2626),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Photo Selection Action Sheet (Screen 18 Preview Vision)
  // ===========================================================================

  void _showPhotoActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'تعديل صورة الحساب',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF000000)),
                    title: const Text(
                      'التقاط صورة بالكاميرا',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _controller.showNotice('معاينة: فتح الكاميرا واقتصاص الصورة 1:1 (مواصفة شاشة 18)');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF000000)),
                    title: const Text(
                      'اختيار من المعرض',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _controller.showNotice('معاينة: فتح معرض الصور بنظام Android Scoped Picker');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
                    title: const Text(
                      'إزالة الصورة الحالية',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _controller.setScenario(Screen17Scenario.authenticatedNoPhotoFallback);
                      _controller.showNotice('تمت استعادة الصورة الرمزية بالحروف الأولى');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // Personal QR Modal Bottom Sheet
  // ===========================================================================

  Widget _buildQrModalSheet() {
    final profile = _controller.profile ??
        const CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          proposedUsername: 'ahmed_mostafa',
        );

    return Container(
      color: const Color(0x66000000),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header with Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'بطاقة الحساب الشخصية (QR)',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        key: const Key('qr_close_button'),
                        onTap: () => _controller.closeQrSheet(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tab Selector: [رمزي] / [مسح رمز]
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            key: const Key('qr_tab_my_code'),
                            onTap: () => _controller.setQrTab(0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _controller.qrTab == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _controller.qrTab == 0
                                    ? const [
                                        BoxShadow(
                                          color: Color(0x0C000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'رمزي',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 13,
                                  fontWeight: _controller.qrTab == 0 ? FontWeight.w800 : FontWeight.w600,
                                  color: _controller.qrTab == 0 ? const Color(0xFF000000) : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            key: const Key('qr_tab_scan'),
                            onTap: () => _controller.setQrTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _controller.qrTab == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _controller.qrTab == 1
                                    ? const [
                                        BoxShadow(
                                          color: Color(0x0C000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'مسح رمز',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 13,
                                  fontWeight: _controller.qrTab == 1 ? FontWeight.w800 : FontWeight.w600,
                                  color: _controller.qrTab == 1 ? const Color(0xFF000000) : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tab 0: My Code View
                  if (_controller.qrTab == 0) ...[
                    // Nonfunctional Prototype Disclaimer Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Text(
                        'معاينة تصميمية غير مفعلة — قيد الاعتماد الفني #172',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // QR Code Card Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // User Header in QR Card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF000000),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: profile.hasPortrait
                                      ? Image.memory(
                                          profile.portraitBytes!,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Text(
                                            profile.initials,
                                            style: const TextStyle(
                                              fontFamily: KonfrmTypography.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.displayName,
                                    style: const TextStyle(
                                      fontFamily: KonfrmTypography.fontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  if (profile.proposedUsername != null)
                                    Directionality(
                                      textDirection: ui.TextDirection.ltr,
                                      child: Text(
                                        '@${profile.proposedUsername}',
                                        style: const TextStyle(
                                          fontFamily: KonfrmTypography.fontFamily,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // QR Code Matrix Simulation
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: CustomPaint(
                              painter: SimulatedQrMatrixPainter(),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Privacy & Security Disclosure
                          const Text(
                            'رمز تعريفي رقمي لمشاركة معرّف الحساب المعتمد — لا يشارك أرقام الهواتف أو وسائل الدفع',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _controller.showNotice('معاينة: مشاركة بطاقة الرمز الرقمية الآمنة');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF000000),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'مشاركة الرمز',
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _controller.showNotice('معاينة: حفظ بطاقة الرمز في ألبوم الصور');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: const Center(
                                child: Text(
                                  'حفظ الصورة',
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Tab 1: Scanner View Simulation
                    Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Scanner Frame
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2.0),
                            ),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.crop_free,
                                size: 48,
                                color: Colors.white70,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'وجّه الكاميرا نحو رمز QR في كونفرم',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'يتم استخدام الماسح للتعرف على الروابط والوحدات المعتمدة داخل كونفرم فقط',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Proposed Wallet Modal Bottom Sheet (Issue #173 Concept)
  // ===========================================================================

  Widget _buildWalletModalSheet() {
    return Container(
      color: const Color(0x66000000),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header with Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Text(
                              'محفظة كونفرم',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '(مفهوم مقترح #173)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        key: const Key('wallet_close_button'),
                        onTap: () => _controller.closeWalletSheet(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Light Redesigned Wallet Concept (NO CHARCOAL SLAB, NO FAKE BALANCES)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'رصيد المحفظة',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: const Text(
                                'المحفظة قيد التجهيز',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 12),
                        const Text(
                          'خدمة المحفظة الرقمية وإدارة الاستردادات قيد الدراسة التشريعية والمالية بموجب القضية #173. لن يتم عرض أو احتساب أي أرصدة مالية تجريبية حتى اعتماد نموذج المحفظة رسمياً.',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Financial Governance Notice
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Text(
                      'تنبيه الحوكمة المالية: المحفظة والاسترداد المالي قيد الدراسة التشريعية والمالية بموجب القضية #173. لا توجد أي تسوية بنكية أو شحن رصيد فعلي في هذا الإصدار التجريبي.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Close CTA (Pure Black #000000)
                  GestureDetector(
                    onTap: () => _controller.closeWalletSheet(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'إغلاق المعاينة',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Logout Confirmation Dialog
  // ===========================================================================

  Widget _buildLogoutDialog() {
    return Container(
      color: const Color(0x66000000),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout,
                    size: 24,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تسجيل الخروج من الحساب',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هل أنت متأكد من رغبتك في تسجيل الخروج؟ ستتم مطالبتك بتسجيل الدخول مجدداً للوصول إلى حجوزاتك ومحفظتك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      key: const Key('dialog_cancel_logout'),
                      onTap: () => _controller.cancelLogout(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Center(
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      key: const Key('dialog_confirm_logout'),
                      onTap: () => _controller.confirmLogout(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
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

  // ===========================================================================
  // Loading Skeleton State
  // ===========================================================================

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Unboxed Skeleton Hero
          Center(
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 140,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Skeleton Stay Card
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
          const SizedBox(height: 18),

          // Skeleton Grouped Card Rows
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Session Expired (401) State
  // ===========================================================================

  Widget _buildSessionExpiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.lock_clock_outlined,
                  size: 28,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'انتهت صلاحية الجلسة',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لحماية بيانات حسابك، يرجى إعادة تسجيل الدخول للوصول إلى معلوماتك وتفاصيل حجوزاتك.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                _controller.setScenario(Screen17Scenario.authenticatedFlagshipTop);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'تسجيل الدخول مجدداً',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
  // Network Error State
  // ===========================================================================

  Widget _buildNetworkErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.wifi_off_outlined,
                  size: 28,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تعذر تحميل بيانات الحساب',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'حدث خطأ في الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                _controller.setScenario(Screen17Scenario.authenticatedFlagshipTop);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
  // Guest Account State
  // ===========================================================================

  Widget _buildGuestAccountView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              child: const Center(
                child: Icon(
                  Icons.person_outline,
                  size: 32,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'تسجيل الدخول إلى كونفرم',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'سجّل دخولك للوصول إلى تفاصيل حجوزاتك، حفظ وحداتك المفضلة، وإدارة إعدادات حسابك بأمان.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                _controller.setScenario(Screen17Scenario.authenticatedFlagshipTop);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'تسجيل الدخول / إنشاء حساب',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
  // Notice Snackbar Overlay
  // ===========================================================================

  Widget _buildNoticeSnackbar() {
    return Positioned(
      bottom: 74,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _controller.dialogNotice!,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _controller.clearNotice(),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Dev Tools Scenario Selector Panel
  // ===========================================================================

  Widget _buildDevToolsPanel() {
    return Positioned(
      top: 60,
      right: 12,
      left: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'لوحة سيناريوهات فحص الشاشة 17 (V2)',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showDevTools = false),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: Screen17Scenario.values.map((sc) {
                  final isSelected = sc == _scenario;
                  return GestureDetector(
                    onTap: () {
                      applyScenario(sc);
                      setState(() => _showDevTools = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF000000) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        sc.title,
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF374151),
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

// =============================================================================
// Simulated QR Matrix Painter (Opaque Clean Procedural Code)
// =============================================================================

class SimulatedQrMatrixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    const int modules = 25;
    final double moduleSize = size.width / modules;

    // Fixed corner position detection patterns
    void drawFinderPattern(double startX, double startY) {
      // 7x7 outer square
      canvas.drawRect(
        Rect.fromLTWH(startX, startY, moduleSize * 7, moduleSize * 7),
        paint,
      );
      // 5x5 inner white
      canvas.drawRect(
        Rect.fromLTWH(startX + moduleSize, startY + moduleSize, moduleSize * 5, moduleSize * 5),
        Paint()..color = Colors.white,
      );
      // 3x3 inner dark
      canvas.drawRect(
        Rect.fromLTWH(startX + moduleSize * 2, startY + moduleSize * 2, moduleSize * 3, moduleSize * 3),
        paint,
      );
    }

    drawFinderPattern(0, 0); // Top-left
    drawFinderPattern(size.width - moduleSize * 7, 0); // Top-right
    drawFinderPattern(0, size.height - moduleSize * 7); // Bottom-left

    // Deterministic pseudo-random matrix data for the remaining area
    final rnd = math.Random(42);
    for (int r = 0; r < modules; r++) {
      for (int c = 0; c < modules; c++) {
        // Skip corner detection patterns
        if (r < 8 && c < 8) continue;
        if (r < 8 && c >= modules - 8) continue;
        if (r >= modules - 8 && c < 8) continue;

        // Skip center logo square (9x9)
        if (r >= 8 && r <= 16 && c >= 8 && c <= 16) continue;

        if (rnd.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(c * moduleSize, r * moduleSize, moduleSize * 0.92, moduleSize * 0.92),
            paint,
          );
        }
      }
    }

    // Center KONFRM Logo Badge
    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: moduleSize * 7,
      height: moduleSize * 7,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(centerRect, const Radius.circular(6)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(centerRect, const Radius.circular(6)),
      Paint()
        ..color = const Color(0xFFE5E7EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // K Glyph Center
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'K',
        style: TextStyle(
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Color(0xFF000000),
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
