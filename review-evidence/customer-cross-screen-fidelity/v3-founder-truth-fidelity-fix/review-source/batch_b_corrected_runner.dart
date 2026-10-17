// =============================================================================
// KONFRM Customer Application — Batch B Corrected Design Previews (Screens 12–16)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Physical Device: [REDACTED_A56_ID]
// Design Authority: Cairo Typography, RTL First, Pure Monochrome (#000000)
// Scope: Isolated visual preview runner with verified RTL Back Arrow [➔]
//        and canon-harmonized financial breakdown for Screens 13, 14, 16.
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
  runApp(const BatchBCorrectedPreviewApp());
}

enum BatchBScreen {
  screen13BookingDetails,
  screen14DepositPayment,
  screen16NotificationCenter,
}

class BatchBController extends ChangeNotifier {
  BatchBScreen _currentScreen = BatchBScreen.screen13BookingDetails;
  bool _isA11y200 = false;
  bool _showDevTools = false;

  BatchBScreen get currentScreen => _currentScreen;
  bool get isA11y200 => _isA11y200;
  bool get showDevTools => _showDevTools;

  void selectScreen(BatchBScreen screen) {
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

class BatchBCorrectedPreviewApp extends StatefulWidget {
  const BatchBCorrectedPreviewApp({super.key});

  @override
  State<BatchBCorrectedPreviewApp> createState() => _BatchBCorrectedPreviewAppState();
}

class _BatchBCorrectedPreviewAppState extends State<BatchBCorrectedPreviewApp> {
  final BatchBController _controller = BatchBController();

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
          home: BatchBMainView(controller: _controller),
        );
      },
    );
  }
}

class BatchBMainView extends StatelessWidget {
  final BatchBController controller;

  const BatchBMainView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.numpad3) {
            controller.selectScreen(BatchBScreen.screen13BookingDetails);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            controller.selectScreen(BatchBScreen.screen14DepositPayment);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit6 ||
              event.logicalKey == LogicalKeyboardKey.numpad6) {
            controller.selectScreen(BatchBScreen.screen16NotificationCenter);
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
            _buildTabPill('13 تفاصيل الحجز', BatchBScreen.screen13BookingDetails),
            const SizedBox(width: 8),
            _buildTabPill('14 سداد العربون', BatchBScreen.screen14DepositPayment),
            const SizedBox(width: 8),
            _buildTabPill('16 مركز الإشعارات', BatchBScreen.screen16NotificationCenter),
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

  Widget _buildTabPill(String title, BatchBScreen screen) {
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
      case BatchBScreen.screen13BookingDetails:
        return const CorrectedScreen13View();
      case BatchBScreen.screen14DepositPayment:
        return const CorrectedScreen14View();
      case BatchBScreen.screen16NotificationCenter:
        return const CorrectedScreen16View();
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
// Screen 13: Booking Details / Stay Hub (Corrected)
// =============================================================================

class CorrectedScreen13View extends StatelessWidget {
  const CorrectedScreen13View({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Decluttered Header with Canonical Right Back Arrow [➔]
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const CanonicalPhysicalBackArrow(buttonKey: Key('screen13_back_button')),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'تفاصيل الحجز',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'رقم الحجز 310482',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
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
              // Status Card (Calm Near-Zero-Blue)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.schedule_rounded, size: 20, color: Color(0xFF374151)),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'الطلب قيد مراجعة المالك',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'طلبك قيد المراجعة حالياً من المالك، ولا يلزم أي دفع في هذه المرحلة.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Property Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.villa_rounded, color: Color(0xFF9CA3AF), size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'شاليه لاجون مراسي',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الساحل الشمالي، مصر',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stay Dates & Check-in / out
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildResponsiveRow('تواريخ الإقامة', '14 – 18 يوليو 2026 (4 ليالٍ)'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Price Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المبالغ المالية',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildResponsiveRow('إجمالي مدة الإقامة', '18,000 ج.م'),
                    const Divider(height: 20, color: Color(0xFFF3F4F6)),
                    _buildResponsiveRow('عربون الليلة الأولى (مطلوب عند الموافقة)', '4,500 ج.م', isBold: true),
                    const Divider(height: 20, color: Color(0xFFF3F4F6)),
                    _buildResponsiveRow('المبلغ المتبقي', '13,500 ج.م'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Deep Link Action Buttons
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF000000)),
                label: const Text(
                  'تواصل مع المضيف',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.help_outline_rounded, size: 18, color: Color(0xFF4B5563)),
                label: const Text(
                  'المساعدة والدعم بخصوص هذا الحجز',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveRow(String label, String value, {bool isBold = false}) {
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
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF000000) : const Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Screen 14: Deposit Payment (Corrected)
// =============================================================================

class CorrectedScreen14View extends StatelessWidget {
  const CorrectedScreen14View({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar with Canonical Right Back Arrow [➔]
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const CanonicalPhysicalBackArrow(buttonKey: Key('screen14_back_button')),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'سداد العربون',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'رقم الحجز 829104',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
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
              // Notice banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF374151)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'وافق المالك على طلبك بنجاح. يُرجى سداد عربون الليلة الأولى لتأكيد حجز التواريخ بشكل نهائي.',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Deposit Calculation Card (Strict Neutral Canon)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تفاصيل دفعة العربون',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildRow('مدة الإقامة الإجمالية (4 ليالٍ)', '18,000 ج.م'),
                    const Divider(height: 20, color: Color(0xFFF3F4F6)),
                    // Canonical Line Item: عربون الليلة الأولى
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: const [
                              Text(
                                'عربون الليلة الأولى المستحق الآن',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Text(
                                '4,500 ج.م',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'المبلغ المطلوب سداده الآن لتأكيد التواريخ لدى المالك.',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 20, color: Color(0xFFF3F4F6)),
                    _buildRow('المبلغ المتبقي من الإقامة', '13,500 ج.م'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Payment Methods Brief
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'طريقة الدفع',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.payment_rounded, size: 22, color: Color(0xFF374151)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'سداد آمن عبر بوابة الدفع الإلكتروني',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        // Sticky Payment CTA
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
              key: const Key('screen14_pay_button'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000), // Pure Black #000000
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'سداد العربون (4,500 ج.م)',
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

  Widget _buildRow(String label, String value) {
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
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Screen 16: Notification Center (Corrected)
// =============================================================================

class CorrectedScreen16View extends StatelessWidget {
  const CorrectedScreen16View({super.key});

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
              CanonicalPhysicalBackArrow(buttonKey: Key('screen16_back_button')),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'مركز الإشعارات',
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
              _buildNotificationItem(
                title: 'وافق المالك على طلب الحجز',
                body: 'وافق مالك «شاليه لاجون مراسي» على طلبك. يُرجى سداد العربون لتأكيد الحجز.',
                timestamp: 'منذ 15 دقيقة',
                icon: Icons.check_circle_outline_rounded,
                isUnread: true,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                title: 'تم إرسال طلب الحجز بنجاح',
                body: 'تم استلام طلبك لحجز «فيلا لؤلؤة البحر» وهو قيد مراجعة المالك حالياً.',
                timestamp: 'منذ ساعتين',
                icon: Icons.send_rounded,
                isUnread: false,
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                title: 'رسالة جديدة من المضيف',
                body: 'أرسل أحمد رسالة جديدة بخصوص تفاصيل وتنسيق الحجز.',
                timestamp: 'أمس',
                icon: Icons.chat_bubble_outline_rounded,
                isUnread: false,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String body,
    required String timestamp,
    required IconData icon,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF9FAFB) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
          width: isUnread ? 1.2 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUnread ? const Color(0xFF000000) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isUnread ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
