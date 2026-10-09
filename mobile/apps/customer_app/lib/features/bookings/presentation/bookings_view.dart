import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Truthful bookings tab for KONFRM | GUEST.
///
/// In strict accordance with KONFRM booking invariants, UNAUTHORIZED != EMPTY.
/// An unauthenticated guest does not possess a loaded account; therefore,
/// this screen truthfully presents an unauthorized session state explaining
/// that authentication is required to access personal bookings.
/// The recovery affordance is wired directly to the Explore tab.
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
            key: const Key('bookings-unauthorized-card'),
            child: StateView(
              kind: StateKind.unauthorized,
              heading: 'تسجيل الدخول مطلوب',
              explanation: 'يتطلب استعراض الحجوزات السابقة ومتابعة طلبات الحجز تسجيل الدخول. يمكنك استكشاف أماكن الإقامة المتاحة كزائر.',
              recoveryLabel: 'استكشف الآن',
              onRecovery: onExplore,
            ),
          ),
        ],
      ),
    );
  }
}
