import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';

class SectionAlert extends StatelessWidget {
  const SectionAlert({
    super.key,
    required this.message,
    this.recoveryLabel,
    this.onRecovery,
    this.isError = false,
  });
  final String message;
  final String? recoveryLabel;
  final VoidCallback? onRecovery;
  final bool isError;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: isError,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(
            width: 3,
            color: isError
                ? ValidationReferenceOnly.danger
                : ValidationReferenceOnly.info,
          ),
        ),
        color: ValidationReferenceOnly.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: KonfrmTypography.body),
          if (recoveryLabel != null && onRecovery != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: onRecovery,
                child: Text(recoveryLabel!),
              ),
            ),
        ],
      ),
    ),
  );
}
