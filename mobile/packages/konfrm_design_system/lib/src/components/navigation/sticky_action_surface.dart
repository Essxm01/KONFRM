import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';

class StickyActionSurface extends StatelessWidget {
  const StickyActionSurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
    color: ValidationReferenceOnly.surface,
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: child,
    ),
  );
}
