import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';
import '../touch_target.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    enabled: onPressed != null,
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: mobileTouchTargetExtent(context)),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: ValidationReferenceOnly.secondaryFill,
          foregroundColor: ValidationReferenceOnly.text,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ValidationReferenceOnly.secondaryRadius,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: KonfrmTypography.button,
        ),
      ),
    ),
  );
}
