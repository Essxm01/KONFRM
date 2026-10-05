import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';

enum StatusTone { neutral, info, success, warning, danger }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
  });
  final String label;
  final StatusTone tone;
  Color get _color => switch (tone) {
    StatusTone.neutral => ValidationReferenceOnly.pending,
    StatusTone.info => ValidationReferenceOnly.info,
    StatusTone.success => ValidationReferenceOnly.success,
    StatusTone.warning => ValidationReferenceOnly.warning,
    StatusTone.danger => ValidationReferenceOnly.danger,
  };
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            switch (tone) {
              StatusTone.success => Icons.check_circle_outline,
              StatusTone.warning => Icons.info_outline,
              StatusTone.danger => Icons.error_outline,
              StatusTone.info => Icons.info_outline,
              StatusTone.neutral => Icons.more_horiz,
            },
            size: 14,
            color: _color,
          ),
          const SizedBox(width: 4),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              label,
              softWrap: true,
              style: KonfrmTypography.label.copyWith(color: _color),
            ),
          ),
        ],
      ),
    ),
  );
}
