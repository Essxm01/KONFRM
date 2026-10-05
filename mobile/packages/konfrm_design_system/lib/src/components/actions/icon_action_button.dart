import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';
import '../touch_target.dart';

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.selected = false,
    this.directional = false,
  });
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool selected;
  final bool directional;

  @override
  Widget build(BuildContext context) {
    assert(semanticLabel.trim().isNotEmpty);
    final targetExtent = mobileTouchTargetExtent(context);
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: onPressed != null,
      selected: selected,
      child: Tooltip(
        message: semanticLabel,
        child: SizedBox(
          key: const Key('konfrm-icon-action-target'),
          width: targetExtent,
          height: targetExtent,
          child: Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(
                  icon,
                  textDirection: directional
                      ? Directionality.of(context)
                      : TextDirection.ltr,
                  color: selected
                      ? ValidationReferenceOnly.interaction
                      : ValidationReferenceOnly.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
