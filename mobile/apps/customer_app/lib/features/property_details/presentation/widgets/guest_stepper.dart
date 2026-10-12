import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class GuestStepper extends StatelessWidget {
  const GuestStepper({
    super.key,
    required this.guests,
    required this.maxGuests,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int guests;
  final int maxGuests;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عدد الضيوف',
                  style: KonfrmTypography.cardTitle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101723),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'حتى $maxGuests ضيوف',
                  style: KonfrmTypography.supporting.copyWith(
                    color: const Color(0xFF758399),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Stepper Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepperButton(
                iconText: '−',
                label: 'تقليل عدد الضيوف',
                onPressed: guests > 1 ? onDecrement : null,
              ),
              Container(
                width: 36,
                alignment: Alignment.center,
                child: Text(
                  '$guests',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101723),
                  ),
                ),
              ),
              _StepperButton(
                iconText: '+',
                label: 'زيادة عدد الضيوف',
                onPressed: guests < maxGuests ? onIncrement : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.iconText,
    required this.label,
    required this.onPressed,
  });

  final String iconText;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: enabled ? const Color(0xFFDCE3ED) : const Color(0xFFEEF2F6),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              iconText,
              style: TextStyle(
                fontSize: 22,
                height: 1,
                color: enabled ? const Color(0xFF182639) : const Color(0xFFBCC6D4),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
