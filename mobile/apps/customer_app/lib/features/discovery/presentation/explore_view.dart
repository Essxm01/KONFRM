import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful discovery tab for KONFRM | GUEST.
///
/// In accordance with KONFRM Master Rules, no mock listings or fake property
/// data are fabricated. Public search and property browsing are deliberately
/// deferred to the search integration slice. No dead interactive controls are exposed.
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
          // Truthful noninteractive search affordance — deferred to API integration
          StructuralContainer(
            key: const Key('explore-search-affordance'),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF6B7280), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'البحث بالمدينة أو اسم العقار (يتوفر مع ربط الخدمة)',
                    style: KonfrmTypography.supporting,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionAlert(
            key: Key('explore-readiness-alert'),
            message: 'محرك البحث واستعراض العقارات قيد التجهيز للربط مع واجهة البيانات المعتمدة في المرحلة القادمة.',
          ),
          const SizedBox(height: 20),
          const StructuralContainer(
            key: Key('explore-status-card'),
            child: StateView(
              kind: StateKind.empty,
              heading: 'استكشاف أماكن الإقامة',
              explanation: 'لا توجد عقارات محملة حالياً. سيتم عرض القوائم الموثقة عند ربط واجهة البحث العام في المرحلة القادمة.',
            ),
          ),
        ],
      ),
    );
  }
}
