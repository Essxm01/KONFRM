import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  runApp(const KonfrmValidationApp());
}

/// Root application widget for Phase 4I Native Design System Validation.
class KonfrmValidationApp extends StatelessWidget {
  const KonfrmValidationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'كونفرم — فحص النظام التصميمي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const ValidationRootScreen(),
    );
  }
}

/// Stable root screen for Phase 4I native component validation.
class ValidationRootScreen extends StatelessWidget {
  const ValidationRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'كونفرم / KONFRM',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: const [
            _ValidationHeaderCard(),
            SizedBox(height: 16),
            _LabNoticeCard(),
            SizedBox(height: 20),
            _ScenariosPlaceholderSection(),
          ],
        ),
      ),
    );
  }
}

/// Header describing Phase 4I Native Validation scope and baseline.
class _ValidationHeaderCard extends StatelessWidget {
  const _ValidationHeaderCard();

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'بيئة الفحص الأصيل (Phase 4I)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  kKonfrmDesignSystemFoundation,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'منصة اختبار وتدقيق المكونات الأصلية (Native Flutter) وفق عقود المرحلة 4H المعتمدة.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Explicit disclosure that all rendered content is LAB_SCENARIO_DATA.
class _LabNoticeCard extends StatelessWidget {
  const _LabNoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Color(0xFF6B7280)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'بيانات تجريبية (LAB_SCENARIO_DATA) — مخصصة حصرياً لفحص السلوك وتدقيق التصميم ولا تمثل بيانات إنتاجية.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder slot reserved for Codex to mount Phase 4I component scenarios.
class _ScenariosPlaceholderSection extends StatelessWidget {
  const _ScenariosPlaceholderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مسار مكونات Codex (Mission B)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'المساحة المخصصة لعرض وفحص المكونات الأصلية:\n'
            '• الأزرار وحقول الإدخال والبحث\n'
            '• شارات وحالات النظام (8 عائلات)\n'
            '• اختبارات التكبير (200% Text Scaling)\n'
            '• اتجاه الواجهة واللغة العربية (RTL & Bidi)',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
