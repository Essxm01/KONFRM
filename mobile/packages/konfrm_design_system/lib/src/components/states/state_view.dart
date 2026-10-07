import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';
import '../actions/secondary_button.dart';

enum StateKind {
  loading,
  empty,
  error,
  offline,
  unauthorized,
  partial,
  stale,
  conflict,
}

class StateView extends StatelessWidget {
  const StateView({
    super.key,
    required this.kind,
    required this.heading,
    required this.explanation,
    this.recoveryLabel,
    this.onRecovery,
  });
  final StateKind kind;
  final String heading;
  final String explanation;
  final String? recoveryLabel;
  final VoidCallback? onRecovery;
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: switch (kind) {
      StateKind.loading ||
      StateKind.error ||
      StateKind.offline ||
      StateKind.unauthorized ||
      StateKind.conflict => true,
      _ => false,
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kind == StateKind.loading &&
            !MediaQuery.disableAnimationsOf(context))
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8),
            child: LinearProgressIndicator(),
          ),
        if (kind == StateKind.loading &&
            MediaQuery.disableAnimationsOf(context))
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8),
            child: Icon(Icons.more_horiz),
          ),
        Text(heading, style: KonfrmTypography.sectionTitle),
        const SizedBox(height: 4),
        Text(explanation, style: KonfrmTypography.body),
        if (recoveryLabel != null && onRecovery != null) ...[
          const SizedBox(height: 12),
          SecondaryButton(label: recoveryLabel!, onPressed: onRecovery),
        ],
      ],
    ),
  );
}
