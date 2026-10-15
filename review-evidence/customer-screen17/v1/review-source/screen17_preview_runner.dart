// =============================================================================
// KONFRM Customer Screen 17 — Account Home (الحساب) Preview Runner
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Design Authority: Cairo Typography, RTL First, Pure Monochrome Palette
// Navigation Context: Account Root (CustomerBottomNavigation Tab 3 active)
// Governing Issues: #170 (Design Contract), #166 (Design First), #171 (Deferred)
//
// Scope: Isolated visual preview with synthetic scenarios. Zero production mutations.
// =============================================================================

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen17PreviewApp());
}

// =============================================================================
// Domain Models & Synthetic Helpers
// =============================================================================

/// Egyptian standard phone masking helper.
/// +201012345678 -> +20 10••••5678.
/// Fails safely to masked representation.
String maskDisplayPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) return '+•• •••• ••••';
  final clean = phone.trim().replaceAll(RegExp(r'\s+'), '');

  // Egyptian standard: +20 followed by 10/11/12/15 and 8 digits
  final egMatch = RegExp(r'^\+20(1[0125])(\d{4})(\d{4})$').firstMatch(clean);
  if (egMatch != null) {
    final operator = egMatch.group(1);
    final last4 = egMatch.group(3);
    return '+20 $operator••••$last4';
  }

  // Egyptian with leading 0 (010..., 011...)
  final egLocalMatch = RegExp(r'^0(1[0125])(\d{4})(\d{4})$').firstMatch(clean);
  if (egLocalMatch != null) {
    final operator = egLocalMatch.group(1);
    final last4 = egLocalMatch.group(3);
    return '+20 $operator••••$last4';
  }

  // Generic international
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
/// 'سارة' -> 'سا'
/// null/empty -> 'م' (مستأجر)
String deriveUserInitials(String? name) {
  if (name == null || name.trim().isEmpty) return 'م';
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.length == 1) {
    return parts[0].length >= 2 ? parts[0].substring(0, 2) : parts[0];
  }
  return '${parts[0][0]}.${parts[1][0]}';
}

/// Represents a customer profile for Screen 17.
class CustomerProfileData {
  final String userId;
  final String? fullName;
  final String? avatarUrl;
  final String? verifiedPhone;
  final String? verifiedEmail;

  const CustomerProfileData({
    required this.userId,
    this.fullName,
    this.avatarUrl,
    this.verifiedPhone,
    this.verifiedEmail,
  });

  bool get isIncomplete => fullName == null || fullName!.trim().isEmpty;
  String get displayName => fullName?.trim().isNotEmpty == true ? fullName!.trim() : 'مستأجر';
  String get initials => deriveUserInitials(fullName);

  String? get displayIdentifier {
    if (verifiedPhone != null && verifiedPhone!.isNotEmpty) {
      return maskDisplayPhone(verifiedPhone);
    }
    if (verifiedEmail != null && verifiedEmail!.isNotEmpty) {
      return verifiedEmail;
    }
    return null;
  }
}

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen17Scenario {
  authenticatedCompleteTop,
  authenticatedCompleteScrolled,
  authenticatedIncompleteProfile,
  guestUnauthenticated,
  initialLoadingSkeleton,
  networkErrorInitial,
  staleRefreshError,
  sessionExpired401,
  identityIntegrityFailure,
  logoutConfirmationDialog,
  navigationInteractionFeedback,
  verifiedEmailVariant,
  accessibility200Top,
  accessibility200Scrolled,
}

extension Screen17ScenarioMetadata on Screen17Scenario {
  String get title {
    switch (this) {
      case Screen17Scenario.authenticatedCompleteTop:
        return '01 Authenticated Complete (Top Fold)';
      case Screen17Scenario.authenticatedCompleteScrolled:
        return '02 Authenticated Complete (Scrolled)';
      case Screen17Scenario.authenticatedIncompleteProfile:
        return '03 Incomplete Profile Prompt';
      case Screen17Scenario.guestUnauthenticated:
        return '04 Guest / Unauthenticated';
      case Screen17Scenario.initialLoadingSkeleton:
        return '05 Initial Loading (Skeleton)';
      case Screen17Scenario.networkErrorInitial:
        return '06 Network Error (Honest Failure)';
      case Screen17Scenario.staleRefreshError:
        return '07 Stale Refresh Notice';
      case Screen17Scenario.sessionExpired401:
        return '08 Session Expired (401)';
      case Screen17Scenario.identityIntegrityFailure:
        return '09 Identity Integrity Failure';
      case Screen17Scenario.logoutConfirmationDialog:
        return '10 Logout Confirmation Dialog';
      case Screen17Scenario.navigationInteractionFeedback:
        return '11 Navigation Row Feedback';
      case Screen17Scenario.verifiedEmailVariant:
        return '12 Verified Email Identity';
      case Screen17Scenario.accessibility200Top:
        return '13 Accessibility 200% (Top Fold)';
      case Screen17Scenario.accessibility200Scrolled:
        return '14 Accessibility 200% (Scrolled)';
    }
  }

  double get scrollOffset {
    switch (this) {
      case Screen17Scenario.authenticatedCompleteScrolled:
      case Screen17Scenario.accessibility200Scrolled:
        return 420.0;
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
  bool _isStaleError = false;
  bool _isHardError = false;
  bool _is401Expired = false;
  bool _identityIntegrityFailed = false;
  int _unreadNotificationCount = 2;
  CustomerProfileData? _profile;
  String? _dialogNotice;
  bool _showLogoutDialog = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isStaleError => _isStaleError;
  bool get isHardError => _isHardError;
  bool get is401Expired => _is401Expired;
  bool get identityIntegrityFailed => _identityIntegrityFailed;
  int get unreadNotificationCount => _unreadNotificationCount;
  CustomerProfileData? get profile => _profile;
  String? get dialogNotice => _dialogNotice;
  bool get showLogoutDialog => _showLogoutDialog;

  Screen17AccountController() {
    _loadDefaultState();
  }

  void _loadDefaultState() {
    _isAuthenticated = true;
    _isLoading = false;
    _isStaleError = false;
    _isHardError = false;
    _is401Expired = false;
    _identityIntegrityFailed = false;
    _unreadNotificationCount = 2;
    _dialogNotice = null;
    _showLogoutDialog = false;
    _profile = const CustomerProfileData(
      userId: 'usr_cst_001',
      fullName: 'أحمد مصطفى',
      verifiedPhone: '+201012345678',
      verifiedEmail: 'ahmed.mostafa@example.com',
    );
  }

  void setScenario(Screen17Scenario scenario) {
    _showLogoutDialog = false;
    _dialogNotice = null;

    switch (scenario) {
      case Screen17Scenario.authenticatedCompleteTop:
      case Screen17Scenario.authenticatedCompleteScrolled:
      case Screen17Scenario.accessibility200Top:
      case Screen17Scenario.accessibility200Scrolled:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 2;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          verifiedPhone: '+201012345678',
          verifiedEmail: 'ahmed.mostafa@example.com',
        );
        break;

      case Screen17Scenario.authenticatedIncompleteProfile:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 1;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_002',
          fullName: null, // Incomplete fullName
          verifiedPhone: '+201098765432',
        );
        break;

      case Screen17Scenario.guestUnauthenticated:
        _isAuthenticated = false;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 0;
        _profile = null;
        break;

      case Screen17Scenario.initialLoadingSkeleton:
        _isAuthenticated = true;
        _isLoading = true;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 0;
        _profile = null;
        break;

      case Screen17Scenario.networkErrorInitial:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = true;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 0;
        _profile = null;
        break;

      case Screen17Scenario.staleRefreshError:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = true;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 2;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          verifiedPhone: '+201012345678',
        );
        break;

      case Screen17Scenario.sessionExpired401:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = true;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 0;
        _profile = null; // Private profile purged on 401
        break;

      case Screen17Scenario.identityIntegrityFailure:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = true;
        _unreadNotificationCount = 0;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_unverified',
          fullName: 'مستخدم غير موثق',
          verifiedPhone: null,
          verifiedEmail: null,
        );
        break;

      case Screen17Scenario.logoutConfirmationDialog:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 2;
        _showLogoutDialog = true;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          verifiedPhone: '+201012345678',
        );
        break;

      case Screen17Scenario.navigationInteractionFeedback:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 2;
        _dialogNotice = 'معاينة المسار: تم اختيار قسم المدفوعات (شاشة 20)';
        _profile = const CustomerProfileData(
          userId: 'usr_cst_001',
          fullName: 'أحمد مصطفى',
          verifiedPhone: '+201012345678',
        );
        break;

      case Screen17Scenario.verifiedEmailVariant:
        _isAuthenticated = true;
        _isLoading = false;
        _isStaleError = false;
        _isHardError = false;
        _is401Expired = false;
        _identityIntegrityFailed = false;
        _unreadNotificationCount = 0;
        _profile = const CustomerProfileData(
          userId: 'usr_cst_003',
          fullName: 'سارة عبد الرحمن',
          verifiedPhone: null,
          verifiedEmail: 'sara.abdelrahman@example.com',
        );
        break;
    }
    notifyListeners();
  }

  void triggerLogoutDialog() {
    _showLogoutDialog = true;
    notifyListeners();
  }

  void dismissLogoutDialog() {
    _showLogoutDialog = false;
    notifyListeners();
  }

  void dismissDialogNotice() {
    _dialogNotice = null;
    notifyListeners();
  }

  void showNotice(String notice) {
    _dialogNotice = notice;
    notifyListeners();
  }
}

// =============================================================================
// Preview App Harness
// =============================================================================

class Screen17PreviewApp extends StatelessWidget {
  const Screen17PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamily: KonfrmTypography.fontFamily,
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    );

    final previewTheme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: const Color(0xFF000000),
        onPrimary: const Color(0xFFFFFFFF),
        surface: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFF111827),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        indicatorColor: const Color(0xFFE5E7EB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
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
      title: 'KONFRM Screen 17 Account Home Preview',
      theme: previewTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const Screen17HarnessPage(),
    );
  }
}

// =============================================================================
// Harness Page with Keyboard Shortcuts & Scenario Switching
// =============================================================================

class Screen17HarnessPage extends StatefulWidget {
  const Screen17HarnessPage({super.key});

  @override
  State<Screen17HarnessPage> createState() => Screen17HarnessPageState();
}

class Screen17HarnessPageState extends State<Screen17HarnessPage> {
  final Screen17AccountController _controller = Screen17AccountController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();

  Screen17Scenario _scenario = Screen17Scenario.authenticatedCompleteTop;
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
        applyScenario(Screen17Scenario.authenticatedCompleteTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen17Scenario.authenticatedCompleteScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen17Scenario.authenticatedIncompleteProfile);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen17Scenario.guestUnauthenticated);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen17Scenario.initialLoadingSkeleton);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen17Scenario.networkErrorInitial);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen17Scenario.staleRefreshError);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen17Scenario.sessionExpired401);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        applyScenario(Screen17Scenario.identityIntegrityFailure);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyA) {
        applyScenario(Screen17Scenario.logoutConfirmationDialog);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyB) {
        applyScenario(Screen17Scenario.navigationInteractionFeedback);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyC) {
        applyScenario(Screen17Scenario.verifiedEmailVariant);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyD) {
        applyScenario(Screen17Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyE) {
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
          body: Stack(
            children: [
              Column(
                children: [
                  // Safe Area Top Spacing
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).padding.top,
                  ),

                  // Header Bar (Account Root Hub)
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
                          // Stale Error Banner
                          if (_controller.isStaleError)
                            SliverToBoxAdapter(
                              child: _buildStaleErrorBanner(),
                            ),

                          // Main Content depending on state
                          if (_controller.isLoading)
                            SliverToBoxAdapter(
                              child: _buildLoadingSkeleton(),
                            )
                          else if (_controller.is401Expired)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildSessionExpiredView(),
                            )
                          else if (_controller.identityIntegrityFailed)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildIdentityIntegrityView(),
                            )
                          else if (_controller.isHardError)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildNetworkErrorView(),
                            )
                          else if (!_controller.isAuthenticated)
                            SliverToBoxAdapter(
                              child: _buildGuestView(),
                            )
                          else
                            _buildAuthenticatedAccountSliver(),

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

              // Logout Confirmation Modal Dialog
              if (_controller.showLogoutDialog)
                _buildLogoutConfirmationDialog(),

              // Navigation Notice Dialog
              if (_controller.dialogNotice != null)
                _buildNoticeDialog(_controller.dialogNotice!),

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
                applyScenario(Screen17Scenario.authenticatedCompleteTop);
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
        ),
      ),
    );
  }

  // ===========================================================================
  // Header Bar (Account Root)
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'حسابي',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Subtle Dev QA Toggle Icon
          GestureDetector(
            onTap: () {
              setState(() {
                _showDevTools = !_showDevTools;
              });
            },
            child: MediaQuery.withNoTextScaling(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Text(
                  'سيناريوهات QA',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B5563),
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
  // Stale Error Notice Banner
  // ===========================================================================

  Widget _buildStaleErrorBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: Color(0xFF4B5563),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'تعذر تحديث بيانات الحساب. يتم عرض أحدث بيانات محفوظة.',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _controller.setScenario(Screen17Scenario.authenticatedCompleteTop);
            },
            child: const Text(
              'تحديث',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                decoration: TextDecoration.underline,
              ),
            ),
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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // 1. Identity Summary Card
          _buildIdentityCard(profile),
          const SizedBox(height: 14),

          // 2. Incomplete Profile Prompt (when applicable)
          if (profile.isIncomplete) ...[
            _buildIncompleteProfilePrompt(),
            const SizedBox(height: 14),
          ],

          // 3. Grouped Navigation Sections
          // Section: رحلاتك
          _buildSectionHeader('رحلاتك'),
          const SizedBox(height: 8),
          _buildCardContainer([
            _buildNavigationRow(
              icon: Icons.calendar_today_outlined,
              title: 'حجوزاتي',
              subtitle: 'تابع حجوزاتك الحالية والسابقة',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى حجوزاتي (شاشة 12)'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            _buildNavigationRow(
              icon: Icons.favorite_border,
              title: 'المفضلة',
              subtitle: 'الوحدات التي حفظتها للرجوع إليها',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى المفضلة (شاشة 15)'),
            ),
          ]),
          const SizedBox(height: 20),

          // Section: النشاط
          _buildSectionHeader('النشاط'),
          const SizedBox(height: 8),
          _buildCardContainer([
            _buildNavigationRow(
              icon: Icons.notifications_none_outlined,
              title: 'الإشعارات',
              subtitle: 'تحديثات مهمة على طلباتك وحجوزاتك',
              badge: _controller.unreadNotificationCount > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _controller.unreadNotificationCount > 9
                            ? '9+'
                            : '${_controller.unreadNotificationCount}',
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى مركز الإشعارات (شاشة 16)'),
            ),
          ]),
          const SizedBox(height: 20),

          // Section: المدفوعات
          _buildSectionHeader('المدفوعات'),
          const SizedBox(height: 8),
          _buildCardContainer([
            _buildNavigationRow(
              icon: Icons.credit_card_outlined,
              title: 'المدفوعات',
              subtitle: 'العربون والمدفوعات والمبالغ المتعلقة بحجوزاتك',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى سجل المدفوعات (شاشة 20)'),
            ),
          ]),
          const SizedBox(height: 20),

          // Section: الحساب
          _buildSectionHeader('الحساب'),
          const SizedBox(height: 8),
          _buildCardContainer([
            _buildNavigationRow(
              icon: Icons.person_outline,
              title: 'البيانات الشخصية',
              subtitle: 'تعديل الاسم وتحديث بيانات الحساب',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى تعديل البيانات (شاشة 18)'),
            ),
          ]),
          const SizedBox(height: 20),

          // Section: المساعدة
          _buildSectionHeader('المساعدة'),
          const SizedBox(height: 8),
          _buildCardContainer([
            _buildNavigationRow(
              icon: Icons.help_outline,
              title: 'المساعدة والدعم',
              subtitle: 'الأسئلة الشائعة وإرشادات الحجز',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى المساعدة والدعم (شاشة 21)'),
            ),
          ]),
          const SizedBox(height: 24),

          // 4. Logout Action Button
          _buildLogoutButton(),
        ]),
      ),
    );
  }

  // ===========================================================================
  // Identity Summary Card
  // ===========================================================================

  Widget _buildIdentityCard(CustomerProfileData profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar Circle (56x56)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                ),
                child: Center(
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name & Identifier
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Masked Identifier with explicit LTR isolation
                    if (profile.displayIdentifier != null)
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          profile.displayIdentifier!,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Edit Action CTA ("تعديل")
              GestureDetector(
                onTap: () {
                  _controller.showNotice('معاينة: الانتقال إلى تعديل البيانات الشخصية (شاشة 18)');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 14, color: Color(0xFF374151)),
                      SizedBox(width: 5),
                      Text(
                        'تعديل',
                        style: TextStyle(
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
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Incomplete Profile Prompt
  // ===========================================================================

  Widget _buildIncompleteProfilePrompt() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, size: 16, color: Color(0xFF111827)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أكمل بيانات حسابك',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'أضف اسمك الكامل لتسهيل التواصل وإتمام طلبات الحجز.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _controller.showNotice('معاينة: إكمال البيانات الشخصية (شاشة 18)');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'إكمال البيانات',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildNavigationRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? badge,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon Container (Neutral 40x40)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF111827)),
            ),
            const SizedBox(width: 14),

            // Title & Subtitle
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
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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

            // Optional Badge
            if (badge != null) ...[
              badge,
              const SizedBox(width: 8),
            ],

            // Navigation Chevron — In RTL Arabic, navigating deeper goes to the LEFT!
            // Enclosing in explicit LTR directionality guarantees it physically points LEFT (<-).
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: const Icon(
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
      onTap: () {
        _controller.triggerLogoutDialog();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 16, color: Color(0xFF4B5563)),
            SizedBox(width: 8),
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Guest / Unauthenticated State View
  // ===========================================================================

  Widget _buildGuestView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                // Neutral User Icon Container
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 32,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'تسجيل الدخول أو إنشاء حساب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'سجّل الدخول لتتمكن من تقديم طلبات الحجز ومتابعة تأكيد المالكين وحفظ شاليهاتك المفضلة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Primary Black CTA Button (6px radius per design system)
                GestureDetector(
                  onTap: () {
                    _controller.showNotice('معاينة: الانتقال إلى تسجيل الدخول (شاشة 08)');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'دخول برقم الجوال',
                      textAlign: TextAlign.center,
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
          const SizedBox(height: 20),

          // Guest Help Link
          _buildSectionHeader('المساعدة'),
          const SizedBox(height: 8),
          _buildCardContainer([
            _buildNavigationRow(
              icon: Icons.help_outline,
              title: 'المساعدة والدعم',
              subtitle: 'الأسئلة الشائعة وإرشادات الحجز',
              onTap: () => _controller.showNotice('معاينة: الانتقال إلى المساعدة والدعم (شاشة 21)'),
            ),
          ]),
        ],
      ),
    );
  }

  // ===========================================================================
  // Loading Skeleton View
  // ===========================================================================

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Skeleton
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
          const SizedBox(height: 20),

          // Section Skeletons
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            width: 70,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Network Error View
  // ===========================================================================

  Widget _buildNetworkErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                  Icons.wifi_off_outlined,
                  size: 28,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تعذر تحميل بيانات الحساب',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'تحقق من اتصال الإنترنت وحاول مجدداً للوصول إلى تفاصيل حسابك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _controller.setScenario(Screen17Scenario.authenticatedCompleteTop);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    textAlign: TextAlign.center,
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
      ),
    );
  }

  // ===========================================================================
  // Session Expired (401) View
  // ===========================================================================

  Widget _buildSessionExpiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                  Icons.lock_outline,
                  size: 28,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'انتهت جلسة تسجيل الدخول',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'لحماية بياناتك، يرجى تسجيل الدخول مجدداً للوصول إلى تفاصيل الحساب.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _controller.showNotice('معاينة: الانتقال إلى تسجيل الدخول مجدداً (شاشة 08)');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'تسجيل الدخول مجدداً',
                    textAlign: TextAlign.center,
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
      ),
    );
  }

  // ===========================================================================
  // Identity Integrity Failure View
  // ===========================================================================

  Widget _buildIdentityIntegrityView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                  Icons.shield_outlined,
                  size: 28,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا يمكن التحقق من هوية الحساب',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'لم نتمكن من التحقق من المعرفات الموثقة لهذا الحساب. يرجى تسجيل الدخول مجدداً لإعادة التحقق.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _controller.showNotice('معاينة: إعادة التحقق من الهوية (شاشة 08)');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'تسجيل الدخول لإعادة التحقق',
                    textAlign: TextAlign.center,
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
      ),
    );
  }

  // ===========================================================================
  // Logout Confirmation Modal Dialog
  // ===========================================================================

  Widget _buildLogoutConfirmationDialog() {
    return Container(
      color: const Color(0x80000000),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _controller.dismissLogoutDialog();
                        _controller.setScenario(Screen17Scenario.guestUnauthenticated);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'تسجيل الخروج',
                          textAlign: TextAlign.center,
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _controller.dismissLogoutDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Text(
                          'إلغاء',
                          textAlign: TextAlign.center,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Navigation Notice Dialog
  // ===========================================================================

  Widget _buildNoticeDialog(String notice) {
    return Container(
      color: const Color(0x66000000),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.touch_app_outlined,
                size: 28,
                color: Color(0xFF111827),
              ),
              const SizedBox(height: 12),
              Text(
                notice,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  _controller.dismissDialogNotice();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'حسناً',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
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
    );
  }

  // ===========================================================================
  // QA Dev Tools Overlay
  // ===========================================================================

  Widget _buildQaDevOverlay() {
    return Positioned(
      bottom: 70,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xF2111827),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'لوحة سيناريوهات QA (Screen 17)',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showDevTools = false;
                    });
                  },
                  child: const Icon(Icons.close, size: 18, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: Screen17Scenario.values.map((sc) {
                final isSelected = _scenario == sc;
                return GestureDetector(
                  onTap: () => applyScenario(sc),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sc.title,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
