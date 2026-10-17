// =============================================================================
// KONFRM Customer Application — Batch C Corrected Design Previews (Screens 17–21)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Physical Device: [REDACTED_A56_ID]
// Design Authority: Cairo Typography, RTL First, Pure Monochrome (#000000)
// Scope: Isolated visual preview runner with verified RTL Back Arrow [➔]
//        and purged development copy for Screens 18 and 19.
//
// Governing Directives:
//   - Founder Hard Correction Order (2026-10-17)
//   - Issue #192 (22-Screen Design Audit & Physical RTL Back-Arrow Law)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BatchCCorrectedPreviewApp());
}

enum BatchCScreen {
  screen18ProfileEdit,
  screen19Settings,
}

class BatchCController extends ChangeNotifier {
  BatchCScreen _currentScreen = BatchCScreen.screen18ProfileEdit;
  bool _isA11y200 = false;
  bool _showDevTools = false;
  bool _showDeletionSheet = false;
  bool _showSignOutDialog = false;
  double _screen19ScrollOffset = 0.0;

  BatchCScreen get currentScreen => _currentScreen;
  bool get isA11y200 => _isA11y200;
  bool get showDevTools => _showDevTools;
  bool get showDeletionSheet => _showDeletionSheet;
  bool get showSignOutDialog => _showSignOutDialog;
  double get screen19ScrollOffset => _screen19ScrollOffset;

  void selectScreen(BatchCScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void toggleA11y() {
    _isA11y200 = !_isA11y200;
    notifyListeners();
  }

  void toggleDevTools() {
    _showDevTools = !_showDevTools;
    notifyListeners();
  }

  void showScreen19Top() {
    _showDeletionSheet = false;
    _showSignOutDialog = false;
    _screen19ScrollOffset = 0.0;
    notifyListeners();
  }

  void showScreen19Scrolled() {
    _showDeletionSheet = false;
    _showSignOutDialog = false;
    _screen19ScrollOffset = 1200.0;
    notifyListeners();
  }

  void openDeletionSheet() {
    _showDeletionSheet = true;
    _showSignOutDialog = false;
    notifyListeners();
  }

  void closeDeletionSheet() {
    _showDeletionSheet = false;
    notifyListeners();
  }

  void openSignOutDialog() {
    _showSignOutDialog = true;
    _showDeletionSheet = false;
    notifyListeners();
  }

  void closeSignOutDialog() {
    _showSignOutDialog = false;
    notifyListeners();
  }
}

class BatchCCorrectedPreviewApp extends StatefulWidget {
  const BatchCCorrectedPreviewApp({super.key});

  @override
  State<BatchCCorrectedPreviewApp> createState() => _BatchCCorrectedPreviewAppState();
}

class _BatchCCorrectedPreviewAppState extends State<BatchCCorrectedPreviewApp> {
  final BatchCController _controller = BatchCController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final fontScale = _controller.isA11y200 ? 2.0 : 1.0;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            fontFamily: KonfrmTypography.fontFamily,
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(fontScale),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              ),
            );
          },
          home: BatchCMainView(controller: _controller),
        );
      },
    );
  }
}

class BatchCMainView extends StatelessWidget {
  final BatchCController controller;

  const BatchCMainView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit1 ||
              event.logicalKey == LogicalKeyboardKey.numpad1) {
            controller.selectScreen(BatchCScreen.screen19Settings);
            controller.showScreen19Top();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
              event.logicalKey == LogicalKeyboardKey.numpad2) {
            controller.selectScreen(BatchCScreen.screen19Settings);
            controller.showScreen19Scrolled();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.numpad3) {
            controller.selectScreen(BatchCScreen.screen19Settings);
            controller.openDeletionSheet();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            controller.selectScreen(BatchCScreen.screen19Settings);
            controller.openSignOutDialog();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit8 ||
              event.logicalKey == LogicalKeyboardKey.numpad8) {
            controller.selectScreen(BatchCScreen.screen18ProfileEdit);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit9 ||
              event.logicalKey == LogicalKeyboardKey.numpad9) {
            controller.selectScreen(BatchCScreen.screen19Settings);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
            controller.toggleA11y();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
            controller.toggleDevTools();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Column(
            children: [
              if (controller.showDevTools) _buildTopSwitcher(),
              Expanded(
                child: _buildCurrentScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSwitcher() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabPill('18 الملف الشخصي', BatchCScreen.screen18ProfileEdit),
            const SizedBox(width: 8),
            _buildTabPill('19 الإعدادات', BatchCScreen.screen19Settings),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => controller.toggleA11y(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.isA11y200 ? const Color(0xFF000000) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  controller.isA11y200 ? '200% نشط' : '100% عادي',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: controller.isA11y200 ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(String title, BatchCScreen screen) {
    final isSelected = controller.currentScreen == screen;
    return InkWell(
      onTap: () => controller.selectScreen(screen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF000000) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (controller.currentScreen) {
      case BatchCScreen.screen18ProfileEdit:
        return const CorrectedScreen18View();
      case BatchCScreen.screen19Settings:
        return CorrectedScreen19View(controller: controller);
    }
  }
}

// =============================================================================
// Canonical Physical RTL Back Arrow Widget
// =============================================================================

class CanonicalPhysicalBackArrow extends StatelessWidget {
  final VoidCallback? onPressed;
  final Key? buttonKey;

  const CanonicalPhysicalBackArrow({super.key, this.onPressed, this.buttonKey});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'الرجوع',
      button: true,
      child: Directionality(
        // Force LTR on this specific icon to guarantee it physically points RIGHT [➔]
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            key: buttonKey,
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 24,
              color: Color(0xFF000000), // Pure Black #000000
            ),
            onPressed: onPressed ?? () {},
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Screen 18: Profile / Edit Profile (Corrected)
// =============================================================================

class CorrectedScreen18View extends StatelessWidget {
  const CorrectedScreen18View({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar with Canonical Right Back Arrow [➔]
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: const [
              CanonicalPhysicalBackArrow(buttonKey: Key('screen18_back_button')),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تعديل الملف الشخصي',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5E7EB)),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'أ',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Full Name field
              const Text(
                'الاسم بالكامل',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: const Text(
                  'أحمد محمد مصطفى',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone field (Verified)
              const Text(
                'رقم الهاتف المحمول (مؤكد)',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '010 •••• 5678',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF10B981)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Email field (Unverified)
              const Text(
                'البريد الإلكتروني',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ahmed@example.com',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        // Sticky Save Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              key: const Key('screen18_save_button'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000), // Pure Black #000000
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'حفظ التعديلات',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Screen 19: Settings (Corrected — Purged «بيانات تجريبية»)
// =============================================================================

class CorrectedScreen19View extends StatefulWidget {
  final BatchCController? controller;

  const CorrectedScreen19View({super.key, this.controller});

  @override
  State<CorrectedScreen19View> createState() => _CorrectedScreen19ViewState();
}

class _CorrectedScreen19ViewState extends State<CorrectedScreen19View> {
  final ScrollController _scrollController = ScrollController();
  bool _localSignOutDialog = false;
  bool _localDeletionSheet = false;
  String? _plannedFeatureSheetTitle;
  String? _snackBarNotice;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChange);
  }

  @override
  void didUpdateWidget(CorrectedScreen19View oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChange);
      widget.controller?.addListener(_onControllerChange);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChange);
    _scrollController.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (!mounted) return;
    final ctrl = widget.controller;
    if (ctrl != null) {
      if (_scrollController.hasClients) {
        if (ctrl.screen19ScrollOffset > 0) {
          _scrollController.animateTo(
            ctrl.screen19ScrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
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
      setState(() {});
    }
  }

  bool get _showSignOutDialog => (widget.controller?.showSignOutDialog ?? false) || _localSignOutDialog;
  bool get _showAccountDeletionSheet => (widget.controller?.showDeletionSheet ?? false) || _localDeletionSheet;

  void _openSignOutDialog() {
    if (widget.controller != null) {
      widget.controller!.openSignOutDialog();
    } else {
      setState(() {
        _localSignOutDialog = true;
      });
    }
  }

  void _closeSignOutDialog() {
    widget.controller?.closeSignOutDialog();
    setState(() {
      _localSignOutDialog = false;
    });
  }

  void _openAccountDeletionSheet() {
    if (widget.controller != null) {
      widget.controller!.openDeletionSheet();
    } else {
      setState(() {
        _localDeletionSheet = true;
      });
    }
  }

  void _closeAccountDeletionSheet() {
    widget.controller?.closeDeletionSheet();
    setState(() {
      _localDeletionSheet = false;
    });
  }

  void _showNotice(String msg) {
    setState(() {
      _snackBarNotice = msg;
    });
  }

  void _clearNotice() {
    setState(() {
      _snackBarNotice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // App Bar with Canonical Right Back Arrow [➔]
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  CanonicalPhysicalBackArrow(buttonKey: Key('screen19_back_button')),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'الإعدادات',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Expanded(
              child: ListView(
                key: const Key('screen19_scrollable_list'),
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Account & Security Section («الأمان وطرق الدخول»)
                  _buildAccountSecuritySection(),
                  const SizedBox(height: 16),

                  // 2. Notifications Section («الإشعارات والتنبيهات»)
                  _buildNotificationsSection(),
                  const SizedBox(height: 16),

                  // 3. App Preferences Section («تفضيلات التطبيق»)
                  _buildAppPreferencesSection(),
                  const SizedBox(height: 16),

                  // 4. Privacy & Account Actions Section («الخصوصية وإدارة الحساب»)
                  _buildPrivacyAccountSection(),
                  const SizedBox(height: 16),

                  // 5. Prototype Notice Disclaimer
                  _buildPrototypeNoticeBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),

        // Overlays
        if (_showSignOutDialog) _buildSignOutDialog(),
        if (_showAccountDeletionSheet) _buildAccountDeletionSheet(),
        if (_plannedFeatureSheetTitle != null) _buildPlannedFeatureSheet(),
        if (_snackBarNotice != null) _buildNoticeSnackbar(),
      ],
    );
  }

  // ===========================================================================
  // Section 1: Account & Security
  // ===========================================================================

  Widget _buildAccountSecuritySection() {
    return _buildSectionCard(
      icon: Icons.shield_outlined,
      title: 'الأمان وطرق الدخول',
      children: [
        // Verified Phone Row
        _buildVerifiedIdentifierRow(
          icon: Icons.phone_iphone_outlined,
          title: 'رقم الهاتف الأساسي',
          maskedValue: '\u202A+20 10 •••• 5678\u202C',
          isPhone: true,
          statusLabel: 'مؤكّد',
          isVerified: true,
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

        // Email Row
        _buildVerifiedIdentifierRow(
          icon: Icons.mail_outline,
          title: 'البريد الإلكتروني الأساسي',
          maskedValue: 'a•••••@gmail.com',
          isPhone: false,
          statusLabel: 'غير مؤكد',
          isVerified: false,
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
            setState(() {
              _plannedFeatureSheetTitle = 'إضافة رقم هاتف بديل';
            });
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
            setState(() {
              _plannedFeatureSheetTitle = 'إضافة بريد إلكتروني بديل';
            });
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
            setState(() {
              _plannedFeatureSheetTitle = 'ربط حساب Apple';
            });
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
            setState(() {
              _plannedFeatureSheetTitle = 'ربط حساب Google';
            });
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // Section 2: Notifications
  // ===========================================================================

  Widget _buildNotificationsSection() {
    return _buildSectionCard(
      icon: Icons.notifications_none_outlined,
      title: 'الإشعارات والتنبيهات',
      children: const [
        InteractiveToggleRow(
          key: Key('toggle_booking_updates'),
          label: 'تحديثات الحجوزات',
          subtitle: 'إشعارات تأكيد وتعديل وحالة طلبات الحجز',
          initialValue: true,
        ),
        Divider(height: 1, color: Color(0xFFF3F4F6)),
        InteractiveToggleRow(
          key: Key('toggle_host_messages'),
          label: 'رسائل المضيفين',
          subtitle: 'تنبيهات فورية عند وصول رسالة جديدة من المالك',
          initialValue: true,
        ),
        Divider(height: 1, color: Color(0xFFF3F4F6)),
        InteractiveToggleRow(
          key: Key('toggle_offers'),
          label: 'العروض والتنبيهات',
          subtitle: 'تنبيهات انخفاض الأسعار وأحدث الإقامات المتاحة',
          initialValue: false,
        ),
      ],
    );
  }

  // ===========================================================================
  // Section 3: App Preferences
  // ===========================================================================

  Widget _buildAppPreferencesSection() {
    return _buildSectionCard(
      icon: Icons.tune_rounded,
      title: 'تفضيلات التطبيق',
      children: [
        _buildInfoRow('لغة التطبيق', 'العربية (الافتراضية)'),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        _buildInfoRow('عملة العرض', 'الجنيه المصري (EGP)'),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        _buildInfoRow('المظهر', 'الوضع الفاتح المعتمد'),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        _buildInfoRow('تقليل الحركة', 'معطل'),
      ],
    );
  }

  // ===========================================================================
  // Section 4: Privacy & Account Actions
  // ===========================================================================

  Widget _buildPrivacyAccountSection() {
    return _buildSectionCard(
      icon: Icons.privacy_tip_outlined,
      title: 'الخصوصية وإدارة الحساب',
      children: [
        _buildLinkRow(
          key: const Key('row_privacy_policy'),
          icon: Icons.policy_outlined,
          title: 'سياسة الخصوصية',
          subtitle: 'تعرّف على كيفية جمع وحماية واستخدام بياناتك في كونفرم',
          onTap: () {
            _showNotice('الانتقال إلى شاشة سياسة الخصوصية');
          },
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        _buildLinkRow(
          key: const Key('row_terms_of_service'),
          icon: Icons.description_outlined,
          title: 'شروط الخدمة والاستخدام',
          subtitle: 'الأحكام المنظمة لتجربة الاستئجار والحجز الموثوق',
          onTap: () {
            _showNotice('الانتقال إلى شاشة شروط الخدمة');
          },
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        // Account Deletion Row (Issue #189)
        Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('screen19_delete_account_button'),
            onTap: _openAccountDeletionSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
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
                          'إدارة حقوق الخصوصية والبيانات الشخصية وفق الضوابط',
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
                  const Directionality(
                    textDirection: TextDirection.ltr,
                    child: Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        // Logout Row
        Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('screen19_logout_button'),
            onTap: _openSignOutDialog,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Section 5: Prototype Notice Disclaimer
  // ===========================================================================

  Widget _buildPrototypeNoticeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, size: 18, color: Color(0xFF6B7280)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'يتم حفظ التفضيلات محلياً على هذا الجهاز. التغييرات في إعدادات الإشعارات والتطبيق تسري فورياً.',
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
    );
  }

  // ===========================================================================
  // Overlays & Sheets
  // ===========================================================================

  Widget _buildSignOutDialog() {
    return Positioned.fill(
      child: Container(
        color: const Color(0x66000000),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      key: const Key('sign_out_dialog_cancel'),
                      onPressed: _closeSignOutDialog,
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      key: const Key('sign_out_dialog_confirm'),
                      onPressed: () {
                        _closeSignOutDialog();
                        _showNotice('تم تأكيد طلب الخروج بنجاح');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'تأكيد الخروج',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildAccountDeletionSheet() {
    return Positioned.fill(
      child: Container(
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
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('account_deletion_sheet_close'),
                      icon: const Icon(Icons.close, size: 20, color: Color(0xFF000000)),
                      onPressed: _closeAccountDeletionSheet,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'إجراءات تصدير البيانات أو حذف الحساب غير متاحة حالياً وهي قيد الإعداد القانوني والتنظيمي. ستخضع هذه الإجراءات لسياسات الخصوصية وشروط الاستخدام المعتمدة فور إطلاقها رسمياً.',
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
                  onPressed: _closeAccountDeletionSheet,
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
      ),
    );
  }

  Widget _buildPlannedFeatureSheet() {
    final title = _plannedFeatureSheetTitle ?? '';
    return Positioned.fill(
      child: Container(
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
                      onPressed: () {
                        setState(() {
                          _plannedFeatureSheetTitle = null;
                        });
                      },
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
                  onPressed: () {
                    setState(() {
                      _plannedFeatureSheetTitle = null;
                    });
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
        color: const Color(0xFF000000),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _snackBarNotice ?? '',
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
                onPressed: _clearNotice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  Widget _buildVerifiedIdentifierRow({
    required IconData icon,
    required String title,
    required String maskedValue,
    required bool isPhone,
    required String statusLabel,
    required bool isVerified,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
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
                        color: isVerified ? const Color(0xFFECFDF5) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isVerified ? const Color(0xFFA7F3D0) : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isVerified) ...[
                            const Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Color(0xFF059669),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isVerified ? const Color(0xFF059669) : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Directionality(
                  textDirection: isPhone ? TextDirection.ltr : TextDirection.rtl,
                  child: Text(
                    maskedValue,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
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
              const Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
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
              const SizedBox(width: 6),
              const Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
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

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  child: Icon(icon, size: 18, color: const Color(0xFF000000)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Interactive Toggle Row Widget
// =============================================================================

class InteractiveToggleRow extends StatefulWidget {
  final String label;
  final String? subtitle;
  final bool initialValue;

  const InteractiveToggleRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.initialValue,
  });

  @override
  State<InteractiveToggleRow> createState() => _InteractiveToggleRowState();
}

class _InteractiveToggleRowState extends State<InteractiveToggleRow> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: _value,
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF000000), // Pure Black #000000
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }
}
