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

  /// Canonical geometry constants matching the Founder-supplied source SVG.
  static const double nativeWidth = 2577.0;
  static const double nativeHeight = 2236.0;
  static const double nativeStrokeWidth = 151.55;
  static double get nativeAspectRatio => nativeWidth / nativeHeight;

  /// Exposes the vector paths for regression verification against canonical SVG geometry.
  static Path get path1 => _KonfrmSymbolPainter.path1;
  static Path get path2 => _KonfrmSymbolPainter.path2;

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
    final double width = size;
    final double height = size / nativeAspectRatio;

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

  static final Path path1 = Path()
    ..moveTo(75.7754, 75.7754)
    ..lineTo(947.188, 75.7754)
    ..lineTo(947.188, 1098.74)
    ..lineTo(151.55, 2140.64)
    ..lineTo(75.7754, 2140.64)
    ..lineTo(75.7754, 75.7754)
    ..close();

  static final Path path2 = Path()
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
    final double scaleX = size.width / KonfrmBrandSymbol.nativeWidth;
    final double scaleY = size.height / KonfrmBrandSymbol.nativeHeight;
    final double scale = math.min(scaleX, scaleY);

    final double offsetX = (size.width - KonfrmBrandSymbol.nativeWidth * scale) / 2;
    final double offsetY = (size.height - KonfrmBrandSymbol.nativeHeight * scale) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);

    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = KonfrmBrandSymbol.nativeStrokeWidth
      ..strokeJoin = StrokeJoin.round;

    // Draw left glyph
    canvas.drawPath(path1, fillPaint);
    canvas.drawPath(path1, strokePaint);

    // Draw right glyph
    canvas.drawPath(path2, fillPaint);
    canvas.drawPath(path2, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KonfrmSymbolPainter oldDelegate) =>
      color != oldDelegate.color;
}
