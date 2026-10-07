import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';
import 'action_phase.dart';
import '../touch_target.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.phase = ActionPhase.idle,
  });
  final String label;
  final VoidCallback? onPressed;
  final ActionPhase phase;

  @override
  Widget build(BuildContext context) {
    final busy = phase == ActionPhase.submitting;
    return Semantics(
      button: true,
      label: label,
      enabled: !busy && onPressed != null,
      value: busy ? 'جارٍ التنفيذ' : null,
      onTap: busy ? null : onPressed,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: mobileTouchTargetExtent(context),
        ),
        child: Opacity(
          opacity: onPressed == null && !busy
              ? ValidationReferenceOnly.disabledOpacity
              : 1,
          child: Material(
            color: KonfrmColors.primary,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: busy ? null : onPressed,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Center(
                  heightFactor: 1,
                  child: busy
                      ? SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            value: MediaQuery.disableAnimationsOf(context)
                                ? 0.5
                                : null,
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          style: KonfrmTypography.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
