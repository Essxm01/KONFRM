import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class TypographyScenario extends StatelessWidget {
  const TypographyScenario({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'العربية الواضحة تبدأ من التسلسل الهرمي',
        style: KonfrmTypography.display,
      ),
      SizedBox(height: 12),
      Text('عنوان الصفحة', style: KonfrmTypography.pageTitle),
      SizedBox(height: 8),
      Text('عنوان القسم', style: KonfrmTypography.sectionTitle),
      SizedBox(height: 8),
      Text('عنوان مجموعة', style: KonfrmTypography.cardTitle),
      SizedBox(height: 8),
      Text(
        'نص توضيحي لاختبار قراءة العربية والتفاف المحتوى عند التكبير.',
        style: KonfrmTypography.body,
      ),
      SizedBox(height: 8),
      Text(
        '1,600 ج.م — أرقام المثال هنا ليست بيانات فعلية',
        style: KonfrmTypography.numeric,
      ),
    ],
  );
}

class ActionsScenario extends StatelessWidget {
  const ActionsScenario({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PrimaryButton(label: 'متابعة', onPressed: _noop),
      SizedBox(height: 12),
      SecondaryButton(label: 'إلغاء', onPressed: _noop),
      SizedBox(height: 12),
      PrimaryButton(
        label: 'جارٍ الإرسال',
        onPressed: _noop,
        phase: ActionPhase.submitting,
      ),
      SizedBox(height: 12),
      PrimaryButton(label: 'غير متاح', onPressed: null),
      SizedBox(height: 12),
      IconActionButton(
        icon: Icons.arrow_back,
        semanticLabel: 'رجوع',
        onPressed: _noop,
        directional: true,
      ),
      SizedBox(height: 12),
      IconActionButton(
        icon: Icons.close,
        semanticLabel: 'إغلاق',
        onPressed: _noop,
      ),
    ],
  );
}

void _noop() {}
