import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class NavigationScenario extends StatelessWidget {
  const NavigationScenario({super.key});
  @override
  Widget build(BuildContext context) => const StructuralContainer(
    child: Text(
      'معاينة التنقل السفلي ذات الوجهات الأربع تظهر أسفل الشاشة.',
      style: KonfrmTypography.body,
    ),
  );
}

class StickyScenario extends StatelessWidget {
  const StickyScenario({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'معاينة منفصلة لسطح إجراء ثابت؛ شريط تنقل العميل غير موجود في هذه الحالة.',
        style: KonfrmTypography.body,
      ),
    ],
  );
}

class OwnerGroupingScenario extends StatelessWidget {
  const OwnerGroupingScenario({super.key});

  @override
  Widget build(BuildContext context) => const StructuralContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ما الذي يحتاج مني تصرفًا الآن؟',
          style: KonfrmTypography.sectionTitle,
        ),
        Divider(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('طلب يحتاج إلى مراجعة', style: KonfrmTypography.body),
            StatusBadge(label: 'قيد المراجعة'),
          ],
        ),
        Divider(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('إكمال بيانات الوحدة', style: KonfrmTypography.body),
            StatusBadge(label: 'مسودة'),
          ],
        ),
      ],
    ),
  );
}
