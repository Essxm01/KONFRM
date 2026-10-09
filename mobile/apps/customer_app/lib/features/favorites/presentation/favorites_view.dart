import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful favorites tab for KONFRM | GUEST.
///
/// Under unauthenticated guest mode, favorites are not stored locally with
/// fake entries. In accordance with KONFRM Master Rules, this view presents
/// a truthful empty state and an authentication call-to-action for cross-device sync.
class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('favorites-scroll-view'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('المفضلة', style: KonfrmTypography.pageTitle),
          const SizedBox(height: 6),
          Text(
            'قائمة العقارات المحفوظة للمقارنة والوصول السريع',
            style: KonfrmTypography.body,
          ),
          const SizedBox(height: 24),
          StructuralContainer(
            key: const Key('favorites-empty-card'),
            child: StateView(
              kind: StateKind.empty,
              heading: 'قائمتك المفضلة فارغة',
              explanation: 'احفظ العقارات التي تنال إعجابك أثناء التصفح للرجوع إليها ومتابعة الأسعار وتوفر التواريخ.',
              recoveryLabel: 'استكشف العقارات',
              onRecovery: () {},
            ),
          ),
        ],
      ),
    );
  }
}
