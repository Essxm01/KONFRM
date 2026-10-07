import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';

class StructuralContainer extends StatelessWidget {
  const StructuralContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: ValidationReferenceOnly.surface,
      border: Border.all(color: ValidationReferenceOnly.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}
