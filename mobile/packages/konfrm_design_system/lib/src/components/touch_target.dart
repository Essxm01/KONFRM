import 'package:flutter/material.dart';

/// Android-oriented implementation target. iOS is preview-only here.
double mobileTouchTargetExtent(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.iOS ? 44 : 48;
