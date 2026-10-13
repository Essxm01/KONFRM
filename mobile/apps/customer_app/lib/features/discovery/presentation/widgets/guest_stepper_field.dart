import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Guest count stepper for Screen 04 (Search & Refine).
///
/// Features 44×44dp touch targets, polite live-region announcements,
/// and min/max boundaries (1 to 20 guests).
class GuestStepperField extends StatelessWidget {
  const GuestStepperField({
    super.key,
    required this.guestCount,
    required this.onChanged,
  });

  final int guestCount;
  final ValueChanged<int> onChanged;

  String get _guestLabel {
    if (guestCount == 1) return 'فرد واحد';
    if (guestCount == 2) return 'فردان';
    if (guestCount >= 3 && guestCount <= 10) return '$guestCount أفراد';
    return '$guestCount فردًا';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'عدد الضيوف',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label on physical right (RTL Start)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'أفراد العائلة أو الأصدقاء',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      guestCount == 1
                          ? 'يشمل البالغين والأطفال'
                          : 'تم تحديد $_guestLabel',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Stepper controls on physical left (RTL End)
              Semantics(
                liveRegion: true,
                label: 'عدد الضيوف: $_guestLabel',
                child: Row(
                  children: [
                    // Decrement Button
                    _buildStepperButton(
                      key: const Key('guest-stepper-decrement'),
                      icon: Icons.remove_rounded,
                      enabled: guestCount > 1,
                      onPressed: () {
                        if (guestCount > 1) onChanged(guestCount - 1);
                      },
                      semanticLabel: 'تقليل عدد الضيوف',
                    ),
                    const SizedBox(width: 12),

                    // Number display
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 32),
                      child: Center(
                        child: Text(
                          '$guestCount',
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Increment Button
                    _buildStepperButton(
                      key: const Key('guest-stepper-increment'),
                      icon: Icons.add_rounded,
                      enabled: guestCount < 20,
                      onPressed: () {
                        if (guestCount < 20) onChanged(guestCount + 1);
                      },
                      semanticLabel: 'زيادة عدد الضيوف',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required Key key,
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
    required String semanticLabel,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: Material(
        color: enabled ? Colors.white : const Color(0xFFF1F5F9),
        shape: CircleBorder(
          side: BorderSide(
            color: enabled ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
          ),
        ),
        child: InkWell(
          key: key,
          customBorder: const CircleBorder(),
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: enabled
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
