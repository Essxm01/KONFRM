import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful bookings tab for KONFRM | GUEST.
///
/// In strict accordance with KONFRM booking invariants, this view displays
/// authentic state only. Zero fake booking records, confirmation codes, or
/// phantom financial totals are generated.
class BookingsView extends StatelessWidget {
  const BookingsView({super.key, this.onExplore});

  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('bookings-scroll-view'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('حجوزاتي', style: KonfrmTypography.pageTitle),
          const SizedBox(height: 6),
          Text(
            'متابعة الحجوزات السابقة والطلبات المعلقة',
            style: KonfrmTypography.body,
          ),
          const SizedBox(height: 24),
          StructuralContainer(
            key: const Key('bookings-empty-card'),
            child: StateView(
              kind: StateKind.empty,
              heading: 'لا توجد حجوزات نشطة',
              explanation: 'لا توجد طلبات حجز أو حجوزات مؤكدة في حسابك الحالي. استكشف أماكن الإقامة المتاحة لبدء حجزك الأول.',
              recoveryLabel: 'استكشف الآن',
              onRecovery: onExplore,
            ),
          ),
        ],
      ),
    );
  }
}
