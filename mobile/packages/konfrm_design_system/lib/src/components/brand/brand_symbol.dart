import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The official KONFRM architectural geometric brand symbol.
///
/// Implements the Founder-approved geometric replacement mark preserving exact
/// vector geometry (viewBox 0 0 2577 2236, stroke-width 151.55, round-join).
class KonfrmBrandSymbol extends StatelessWidget {
  const KonfrmBrandSymbol({
    super.key,
    this.size = 32,
    this.color = Colors.black,
    this.isDecorative = true,
    this.semanticLabel = 'شعار كونفرم',
  });

  /// The target width or height (the symbol preserves its ~1.15 aspect ratio).
  final double size;

  /// The foreground fill and stroke color.
  final Color color;

  /// If true, the symbol is excluded from the accessibility tree.
  final bool isDecorative;

  /// Semantics label announced if [isDecorative] is false.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    const double nativeWidth = 2577.0;
    const double nativeHeight = 2236.0;
    const double aspectRatio = nativeWidth / nativeHeight;

    final double width = size;
    final double height = size / aspectRatio;

    Widget symbol = SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _KonfrmSymbolPainter(color: color),
      ),
    );

    if (isDecorative) {
      return ExcludeSemantics(child: symbol);
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: symbol,
    );
  }
}

class _KonfrmSymbolPainter extends CustomPainter {
  const _KonfrmSymbolPainter({required this.color});

  final Color color;

  static final Path _path1 = Path()
    ..moveTo(75.7754, 75.7754)
    ..lineTo(947.188, 75.7754)
    ..lineTo(947.188, 1098.74)
    ..lineTo(151.55, 2140.64)
    ..lineTo(75.7754, 75.7754)
    ..close();

  static final Path _path2 = Path()
    ..moveTo(1723.88, 75.7754)
    ..lineTo(2500.58, 75.7754)
    ..lineTo(2064.87, 1098.74)
    ..lineTo(2500.58, 2159.59)
    ..lineTo(1723.88, 2159.59)
    ..lineTo(1174.51, 1117.68)
    ..lineTo(1723.88, 75.7754)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    const double nativeWidth = 2577.0;
    const double nativeHeight = 2236.0;

    final double scaleX = size.width / nativeWidth;
    final double scaleY = size.height / nativeHeight;
    final double scale = math.min(scaleX, scaleY);

    final double offsetX = (size.width - nativeWidth * scale) / 2;
    final double offsetY = (size.height - nativeHeight * scale) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);

    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 151.55
      ..strokeJoin = StrokeJoin.round;

    // Draw left glyph
    canvas.drawPath(_path1, fillPaint);
    canvas.drawPath(_path1, strokePaint);

    // Draw right glyph
    canvas.drawPath(_path2, fillPaint);
    canvas.drawPath(_path2, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KonfrmSymbolPainter oldDelegate) =>
      color != oldDelegate.color;
}
