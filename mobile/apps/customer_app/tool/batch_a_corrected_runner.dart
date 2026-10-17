// =============================================================================
// KONFRM Customer Application — Batch A Corrected Design Previews (Screens 01–11)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Physical Device: [REDACTED_A56_ID]
// Design Authority: Cairo Typography, RTL First, Pure Monochrome (#000000)
// Scope: Isolated visual preview runner with verified RTL Back Arrow [➔]
//        and canon-harmonized financial breakdown for Screens 04, 05, 07, 10.
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
  runApp(const BatchACorrectedPreviewApp());
}

enum BatchAScreen {
  screen04SearchRefine,
  screen05SearchResults,
  screen07BookingReview,
  screen10ProfileSetup,
}

class BatchAController extends ChangeNotifier {
  BatchAScreen _currentScreen = BatchAScreen.screen04SearchRefine;
  bool _isA11y200 = false;
  bool _showDevTools = false;

  BatchAScreen get currentScreen => _currentScreen;
  bool get isA11y200 => _isA11y200;
  bool get showDevTools => _showDevTools;

  void selectScreen(BatchAScreen screen) {
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

class BatchACorrectedPreviewApp extends StatefulWidget {
  const BatchACorrectedPreviewApp({super.key});

  @override
  State<BatchACorrectedPreviewApp> createState() => _BatchACorrectedPreviewAppState();
}

class _BatchACorrectedPreviewAppState extends State<BatchACorrectedPreviewApp> {
  final BatchAController _controller = BatchAController();

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
          home: BatchAMainView(controller: _controller),
        );
      },
    );
  }
}

class BatchAMainView extends StatelessWidget {
  final BatchAController controller;

  const BatchAMainView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            controller.selectScreen(BatchAScreen.screen04SearchRefine);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit5 ||
              event.logicalKey == LogicalKeyboardKey.numpad5) {
            controller.selectScreen(BatchAScreen.screen05SearchResults);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit7 ||
              event.logicalKey == LogicalKeyboardKey.numpad7) {
            controller.selectScreen(BatchAScreen.screen07BookingReview);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit0 ||
              event.logicalKey == LogicalKeyboardKey.numpad0) {
            controller.selectScreen(BatchAScreen.screen10ProfileSetup);
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
            _buildTabPill('04 فلاتر البحث', BatchAScreen.screen04SearchRefine),
            const SizedBox(width: 8),
            _buildTabPill('05 نتائج البحث', BatchAScreen.screen05SearchResults),
            const SizedBox(width: 8),
            _buildTabPill('07 مراجعة الحجز', BatchAScreen.screen07BookingReview),
            const SizedBox(width: 8),
            _buildTabPill('10 إنشاء الحساب', BatchAScreen.screen10ProfileSetup),
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
                    fontSize: 11,
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

  Widget _buildTabPill(String title, BatchAScreen screen) {
    final isSelected = controller.currentScreen == screen;
    return InkWell(
      key: Key('tab_${screen.name}'),
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
      case BatchAScreen.screen04SearchRefine:
        return const CorrectedScreen04View();
      case BatchAScreen.screen05SearchResults:
        return const CorrectedScreen05View();
      case BatchAScreen.screen07BookingReview:
        return const CorrectedScreen07View();
      case BatchAScreen.screen10ProfileSetup:
        return const CorrectedScreen10View();
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
              color: Color(0xFF000000), // Pure Black #000000 per Issue #175
              size: 24,
            ),
            tooltip: 'الرجوع',
            onPressed: onPressed ?? () {},
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Screen 04: Search & Refine (Corrected)
// =============================================================================

class CorrectedScreen04View extends StatelessWidget {
  const CorrectedScreen04View({super.key});

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
              const CanonicalPhysicalBackArrow(buttonKey: Key('screen04_back_button')),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'تخصيص البحث والفلاتر',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'إعادة ضبط',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
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
              // Search Input Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF000000), size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'الساحل الشمالي، مراسي',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Dates section
              const Text(
                'تواريخ الإقامة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        '14 – 18 يوليو 2026 (4 ليالٍ)',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF6B7280)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Property Types
              const Text(
                'نوع الوحدة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip('الكل', true),
                  _buildFilterChip('فيلا مستقلة', false),
                  _buildFilterChip('شاليه لاجون', false),
                  _buildFilterChip('توين هاوس', false),
                ],
              ),
              const SizedBox(height: 24),
              // Price ceiling
              const Text(
                'الحد الأقصى للسعر لليلة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: const [
                  Text(
                    '1,000 ج.م',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    'حتى 15,000 ج.م / ليلة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        // Sticky Bottom Search CTA
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000), // Pure Black #000000
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'عرض 14 مكان إقامة',
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF000000) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF374151),
        ),
      ),
    );
  }
}

// =============================================================================
// Screen 05: Search Results (Corrected)
// =============================================================================

class CorrectedScreen05View extends StatelessWidget {
  const CorrectedScreen05View({super.key});

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
              const CanonicalPhysicalBackArrow(buttonKey: Key('screen05_back_button')),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'نتائج البحث',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Color(0xFF000000), size: 20),
                onPressed: () {},
                tooltip: 'الفلاتر',
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5E7EB)),
        // Filter pills strip
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'مراسي، الساحل الشمالي',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.close_rounded, size: 14, color: Color(0xFF6B7280)),
                  ],
                ),
              ),
              const Text(
                '1 مكان متاح',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Property Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mock Image Container
                    Container(
                      height: 180,
                      color: const Color(0xFFE5E7EB),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(Icons.villa_rounded, size: 48, color: Color(0xFF9CA3AF)),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_border_rounded,
                                size: 18,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Text(
                                  'فيلا لؤلؤة البحر',
                                  style: TextStyle(
                                    fontFamily: KonfrmTypography.fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '4,500 ج.م / ليلة',
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
                            'مراسي، الساحل الشمالي • إطلالة مباشرة على اللاجون',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            children: const [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bed_rounded, size: 16, color: Color(0xFF6B7280)),
                                  SizedBox(width: 4),
                                  Text(
                                    '3 غرف',
                                    style: TextStyle(
                                      fontFamily: KonfrmTypography.fontFamily,
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bathtub_rounded, size: 16, color: Color(0xFF6B7280)),
                                  SizedBox(width: 4),
                                  Text(
                                    '2 حمام',
                                    style: TextStyle(
                                      fontFamily: KonfrmTypography.fontFamily,
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.people_rounded, size: 16, color: Color(0xFF6B7280)),
                                  SizedBox(width: 4),
                                  Text(
                                    '6 ضيوف',
                                    style: TextStyle(
                                      fontFamily: KonfrmTypography.fontFamily,
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Screen 07: Booking Request Review (Corrected)
// =============================================================================

class CorrectedScreen07View extends StatelessWidget {
  const CorrectedScreen07View({super.key});

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
              CanonicalPhysicalBackArrow(buttonKey: Key('screen07_back_button')),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'مراجعة طلب الحجز',
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
              // Property card brief
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
                            'فيلا لؤلؤة البحر',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'مراسي، الساحل الشمالي',
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
              // Stay details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildMetaRow('تواريخ الإقامة', '14 – 17 أكتوبر 2026 (3 ليالٍ)'),
                    const SizedBox(height: 12),
                    _buildMetaRow('عدد الضيوف', '4 ضيوف'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Financial Breakdown: Strict Canon «عربون الليلة الأولى»
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
                      'تفاصيل السعر',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildPriceRow('إجمالي الإقامة (3 ليالٍ)', '13,500 ج.م', isBold: false),
                    const Divider(height: 24, color: Color(0xFFF3F4F6)),
                    // Explicit Canon Line Item: عربون الليلة الأولى
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: const [
                          Text(
                            'عربون الليلة الأولى',
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceRow('المبلغ المتبقي', '9,000 ج.م', isBold: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Single clear notice banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'لا يُدفع العربون قبل موافقة المالك.',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Submit CTA
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  key: const Key('screen07_submit_button'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000), // Pure Black #000000
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'إرسال طلب الحجز للمالك',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'إرسال الطلب لا يعني تأكيد الحجز فورياً',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow(String label, String value) {
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

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
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
              color: isBold ? const Color(0xFF000000) : const Color(0xFF374151),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isBold ? const Color(0xFF000000) : const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Screen 10: First-time Profile Setup (Corrected)
// =============================================================================

class CorrectedScreen10View extends StatelessWidget {
  const CorrectedScreen10View({super.key});

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
              CanonicalPhysicalBackArrow(buttonKey: Key('screen10_back_button')),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'أكمل إنشاء حسابك',
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
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'الاسم والمعلومات الأساسية',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'يظهر اسمك لمضيفي العقارات للتنسيق عند تأكيد الحجز.',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),
              // Verified Phone Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: const [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 18),
                    Text(
                      'تم التحقق من رقم الهاتف:',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      '010 •••• ••78',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Name Input Field
              const Text(
                'الاسم بالكامل *',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF000000), width: 1.5),
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
              // Email Optional Field
              const Text(
                'البريد الإلكتروني (اختياري)',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Text(
                  'ahmed@example.com',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Primary CTA
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
              key: const Key('screen10_complete_button'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000), // Pure Black #000000
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'إكمال إنشاء الحساب',
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
