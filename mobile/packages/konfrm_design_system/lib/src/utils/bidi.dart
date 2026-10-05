import 'package:flutter/widgets.dart';

/// Isolates a left-to-right identifier embedded in Arabic text.
Widget isolateLtr(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

/// A text-level isolate appropriate for phone, email, code and money snippets.
Widget ltrText(String value, {TextStyle? style, TextAlign? textAlign}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: Text(value, style: style, textAlign: textAlign),
    );
