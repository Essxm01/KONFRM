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

  BatchCScreen get currentScreen => _currentScreen;
  bool get isA11y200 => _isA11y200;
  bool get showDevTools => _showDevTools;

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
          if (event.logicalKey == LogicalKeyboardKey.digit8 ||
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
        return const CorrectedScreen19View();
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

class CorrectedScreen19View extends StatelessWidget {
  const CorrectedScreen19View({super.key});

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
            padding: const EdgeInsets.all(16),
            children: [
              // Notification preferences
              _buildSectionCard(
                title: 'تفضيلات الإشعارات',
                children: const [
                  InteractiveToggleRow(label: 'تحديثات الحجوزات', initialValue: true, key: Key('toggle_booking_updates')),
                  Divider(height: 16, color: Color(0xFFF3F4F6)),
                  InteractiveToggleRow(label: 'رسائل المضيفين', initialValue: true, key: Key('toggle_host_messages')),
                  Divider(height: 16, color: Color(0xFFF3F4F6)),
                  InteractiveToggleRow(label: 'العروض والتنبيهات', initialValue: false, key: Key('toggle_offers')),
                ],
              ),
              const SizedBox(height: 16),
              // Security preferences
              _buildSectionCard(
                title: 'الأمان والدخول',
                children: const [
                  InteractiveToggleRow(label: 'الدخول بالبصمة / التعرف على الوجه', initialValue: true, key: Key('toggle_biometric')),
                ],
              ),
              const SizedBox(height: 16),
              // App preferences (Strict Arabic First)
              _buildSectionCard(
                title: 'تفضيلات التطبيق',
                children: [
                  _buildInfoRow('لغة التطبيق', 'العربية'),
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
                  _buildInfoRow('عملة العرض', 'الجنيه المصري (EGP)'),
                ],
              ),
              const SizedBox(height: 16),
              // Legal & About
              _buildSectionCard(
                title: 'عن التطبيق',
                children: [
                  _buildInfoRow('شروط الخدمة وسياسة الخصوصية', 'عرض'),
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
                  _buildInfoRow('إصدار التطبيق', '1.0.0'),
                ],
              ),
              const SizedBox(height: 24),
              // Logout Action
              OutlinedButton(
                key: const Key('screen19_logout_button'),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 13,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          child: const Text(
                            'تأكيد الخروج',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
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
  final bool initialValue;

  const InteractiveToggleRow({
    super.key,
    required this.label,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ),
        Switch(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
          },
          activeThumbColor: const Color(0xFF000000), // Pure Black #000000
        ),
      ],
    );
  }
}
