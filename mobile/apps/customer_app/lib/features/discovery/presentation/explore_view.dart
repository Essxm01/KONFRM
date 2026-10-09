import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful discovery tab for KONFRM | GUEST.
///
/// Provides the public exploration header, search input field, and truthful
/// ready-for-integration status. Fabricated listings, mock prices, and fake
/// properties are strictly prohibited by KONFRM Master Rules.
class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('explore-scroll-view'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('كونفرم | استكشف', style: KonfrmTypography.display),
          const SizedBox(height: 6),
          Text(
            'ابحث عن بيوت العطلات والشاليهات الموثقة',
            style: KonfrmTypography.body,
          ),
          const SizedBox(height: 20),
          SearchField(
            key: const Key('explore-search-field'),
            label: 'وجهتك القادمة',
            placeholder: 'ابحث بالمدينة، الحي، أو اسم العقار...',
            onSubmitted: (value) {},
          ),
          const SizedBox(height: 24),
          const SectionAlert(
            key: Key('explore-readiness-alert'),
            message: 'محرك البحث واستعراض العقارات قيد التجهيز للربط مع واجهة البيانات المعتمدة في المرحلة القادمة.',
          ),
          const SizedBox(height: 20),
          StructuralContainer(
            key: const Key('explore-status-card'),
            child: StateView(
              kind: StateKind.empty,
              heading: 'استكشاف أماكن الإقامة',
              explanation: 'لا توجد عقارات محملة حالياً. سيتم عرض القوائم الموثقة عند ربط واجهة البحث العام.',
              recoveryLabel: 'تحديث النتائج',
              onRecovery: () {},
            ),
          ),
        ],
      ),
    );
  }
}
