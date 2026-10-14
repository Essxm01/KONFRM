import 'dart:math' as math;

import 'package:customer_app/features/booking_review/data/booking_review_models.dart';
import 'package:customer_app/features/booking_review/presentation/widgets/konfrm_price_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen11PreviewApp());
}

enum Screen11Scenario {
  mainSuccess('01. النجاح الأساسي (Fold 1)'),
  bottomActions('02. أسفل الشاشة والإجراءات'),
  longTitle('03. عنوان طويل ورقم مطول'),
  compactViewport('04. شاشة مدمجة 360dp'),
  accessibility200('05. إمكانية الوصول 200%'),
  safeStateMinimal('06. حالة بيانات دنيا');

  const Screen11Scenario(this.label);
  final String label;
}

class Screen11PreviewApp extends StatefulWidget {
  const Screen11PreviewApp({super.key});

  @override
  State<Screen11PreviewApp> createState() => _Screen11PreviewAppState();
}

class _Screen11PreviewAppState extends State<Screen11PreviewApp> {
  Screen11Scenario _scenario = Screen11Scenario.mainSuccess;
  bool _showQaBar = false;
  final FocusNode _focusNode = FocusNode();

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
    super.dispose();
  }

  void setScenario(Screen11Scenario scenario) {
    setState(() {
      _scenario = scenario;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double textScale =
        _scenario == Screen11Scenario.accessibility200 ? 2.0 : 1.0;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.digit1 ||
              event.logicalKey == LogicalKeyboardKey.numpad1) {
            setScenario(Screen11Scenario.mainSuccess);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit2 ||
              event.logicalKey == LogicalKeyboardKey.numpad2) {
            setScenario(Screen11Scenario.bottomActions);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.numpad3) {
            setScenario(Screen11Scenario.longTitle);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.numpad4) {
            setScenario(Screen11Scenario.compactViewport);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit5 ||
              event.logicalKey == LogicalKeyboardKey.numpad5) {
            setScenario(Screen11Scenario.accessibility200);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.digit6 ||
              event.logicalKey == LogicalKeyboardKey.numpad6) {
            setScenario(Screen11Scenario.safeStateMinimal);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: KonfrmTypography.fontFamily,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black,
            surface: Colors.white,
          ),
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
          );
        },
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _scenario == Screen11Scenario.compactViewport
                        ? 360.0
                        : double.infinity,
                  ),
                  child: Screen11DesignCandidate(
                    key: ValueKey(_scenario),
                    scenario: _scenario,
                    onToggleQa: () => setState(() => _showQaBar = !_showQaBar),
                  ),
                ),
              ),
              if (_showQaBar)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 8,
                    color: const Color(0xFF111827),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'محدد سيناريوهات المراجعة (Screen 11 V2)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      setState(() => _showQaBar = false),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              alignment: WrapAlignment.center,
                              children: Screen11Scenario.values.map((s) {
                                final isSelected = s == _scenario;
                                return ChoiceChip(
                                  label: Text(s.label),
                                  selected: isSelected,
                                  selectedColor: Colors.white,
                                  backgroundColor: const Color(0xFF1F2937),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white70,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 11,
                                  ),
                                  onSelected: (_) {
                                    setState(() {
                                      _scenario = s;
                                      _showQaBar = false;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
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
}

class Screen11DesignCandidate extends StatefulWidget {
  const Screen11DesignCandidate({
    super.key,
    required this.scenario,
    required this.onToggleQa,
  });

  final Screen11Scenario scenario;
  final VoidCallback onToggleQa;

  @override
  State<Screen11DesignCandidate> createState() =>
      _Screen11DesignCandidateState();
}

class _Screen11DesignCandidateState extends State<Screen11DesignCandidate> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.scenario == Screen11Scenario.bottomActions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_scrollController.hasClients &&
              _scrollController.position.maxScrollExtent > 0) {
            _scrollController.animateTo(
              math.min(140.0, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            );
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Model attributes according to scenario
    final String? propertyTitle;
    final String bookingNumber;
    final String checkInText;
    final String checkOutText;
    final int nightsCount;
    final int guestsCount;
    final num? totalStay;
    final num? depositAmount;

    switch (widget.scenario) {
      case Screen11Scenario.mainSuccess:
      case Screen11Scenario.bottomActions:
      case Screen11Scenario.compactViewport:
      case Screen11Scenario.accessibility200:
        propertyTitle = 'فيلا فاخرة بإطلالة مباشرة على البحر - مراسي';
        bookingNumber = 'BK-892415';
        checkInText = '20 أكتوبر';
        checkOutText = '25 أكتوبر 2026';
        nightsCount = 5;
        guestsCount = 3;
        totalStay = 13500;
        depositAmount = 3375;
        break;

      case Screen11Scenario.longTitle:
        propertyTitle =
            'شاليه دوبلكس مفروش بالكامل مع حديقة خاصة ومسبح بإطلالة بانورامية ساحرة على بحيرة مارينا - العلمين الجديدة';
        bookingNumber = 'BK-20261014-EG-ALX-98412';
        checkInText = '20 أكتوبر';
        checkOutText = '25 أكتوبر 2026';
        nightsCount = 5;
        guestsCount = 6;
        totalStay = 28400;
        depositAmount = 7100;
        break;

      case Screen11Scenario.safeStateMinimal:
        propertyTitle = null;
        bookingNumber = 'BK-741029';
        checkInText = '20 أكتوبر';
        checkOutText = '22 أكتوبر 2026';
        nightsCount = 2;
        guestsCount = 2;
        totalStay = null;
        depositAmount = null;
        break;
    }

    return Column(
      children: [
        // FIX A: Solitary centered black brand symbol in 52dp app bar, NO English wordmark, NO back arrow
        SafeArea(
          bottom: false,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onToggleQa,
              child: const KonfrmBrandSymbol(size: 26),
            ),
          ),
        ),

        // 2. Primary Scrollable Canvas with optimized vertical budget (FIX C)
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Send / Check Acknowledgment Icon (Restrained neutral monochrome)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scaleX: -1.0,
                      child: Transform.rotate(
                        angle: -math.pi / 6,
                        child: const Icon(
                          Icons.send_rounded,
                          color: Color(0xFF18181B),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Primary Title
                Text(
                  'تم إرسال طلب الحجز',
                  style: KonfrmTypography.pageTitle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111827),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),

                // Subtitle with isolated trailing period
                Text(
                  'وصل طلبك إلى المالك للمراجعة.\u200F',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),

                // Current Status Badge (Neutral monochrome)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: Color(0xFF4B5563),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'قيد مراجعة المالك',
                          style: KonfrmTypography.bodyStrong.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Payment Reassurance Box (Truthful zero-payment)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 17,
                        color: Color(0xFF374151),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'لا يوجد أي مبلغ مطلوب الآن.\u200F',
                          style: KonfrmTypography.bodyStrong.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Next Steps Section
                Text(
                  'ما الخطوة التالية؟',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  'إذا وافق المالك، يصبح دفع العربون هو الخطوة التالية. وبعد نجاح الدفع يصبح الحجز مؤكدًا.\u200F',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                    height: 1.35,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),

                // Booking Summary Card
                Text(
                  'تفاصيل الطلب',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: [
                      if (propertyTitle != null) ...[
                        _SummaryRow(
                          label: 'الوحدة',
                          child: Text(
                            propertyTitle,
                            style: KonfrmTypography.bodyStrong.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                              height: 1.35,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Divider(
                          height: 12,
                          thickness: 1,
                          color: Color(0xFFF3F4F6),
                        ),
                      ],
                      _SummaryRow(
                        label: 'رقم الطلب',
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: SelectableText(
                            bookingNumber,
                            style: KonfrmTypography.bodyStrong.copyWith(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 12,
                        thickness: 1,
                        color: Color(0xFFF3F4F6),
                      ),
                      // FIX B: Chronology arrow pointing strictly LEFT (start date on right -> end date on left)
                      _SummaryRow(
                        label: 'التواريخ',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              checkInText,
                              style: KonfrmTypography.bodyStrong.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            Text(
                              checkOutText,
                              style: KonfrmTypography.bodyStrong.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 12,
                        thickness: 1,
                        color: Color(0xFFF3F4F6),
                      ),
                      _SummaryRow(
                        label: 'المدة والضيوف',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatArabicNights(nightsCount),
                              style: KonfrmTypography.bodyStrong.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '·',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                            Text(
                              formatArabicGuests(guestsCount),
                              style: KonfrmTypography.bodyStrong.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (totalStay != null) ...[
                        const Divider(
                          height: 12,
                          thickness: 1,
                          color: Color(0xFFF3F4F6),
                        ),
                        _SummaryRow(
                          label: 'إجمالي الإقامة',
                          child: KonfrmPriceText(
                            amount: totalStay,
                            amountStyle: KonfrmTypography.bodyStrong.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF111827),
                            ),
                            currencyStyle: KonfrmTypography.body.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                      if (depositAmount != null) ...[
                        const Divider(
                          height: 12,
                          thickness: 1,
                          color: Color(0xFFF3F4F6),
                        ),
                        _SummaryRow(
                          label: 'العربون بعد موافقة المالك',
                          child: KonfrmPriceText(
                            amount: depositAmount,
                            amountStyle: KonfrmTypography.bodyStrong.copyWith(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                            ),
                            currencyStyle: KonfrmTypography.body.copyWith(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // FIX C: Primary action FULLY visible on first fold
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'متابعة الطلب في حجوزاتي',
                            style: KonfrmTypography.bodyStrong.copyWith(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4B5563),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'العودة إلى الاستكشاف',
                        style: KonfrmTypography.body.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 160),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: KonfrmTypography.body.copyWith(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ],
    );
  }
}
