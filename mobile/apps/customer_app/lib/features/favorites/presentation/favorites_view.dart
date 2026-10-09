import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful favorites tab for KONFRM | GUEST.
///
/// In accordance with KONFRM Master Rules, UNAUTHORIZED != EMPTY.
/// An unauthenticated guest does not possess a loaded account; therefore,
/// this screen truthfully presents an unauthorized session state explaining
/// that authentication is required for personal favorites.
/// The recovery affordance is wired directly to the Explore tab.
class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key, this.onExplore});

  final VoidCallback? onExplore;

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
            key: const Key('favorites-unauthorized-card'),
            child: StateView(
              kind: StateKind.unauthorized,
              heading: 'تسجيل الدخول مطلوب',
              explanation: 'يتطلب حفظ العقارات المفضلة واستعراضها تسجيل الدخول إلى حسابك. يمكنك استكشاف أماكن الإقامة المتاحة كزائر.',
              recoveryLabel: 'استكشف العقارات',
              onRecovery: onExplore,
            ),
          ),
        ],
      ),
    );
  }
}
