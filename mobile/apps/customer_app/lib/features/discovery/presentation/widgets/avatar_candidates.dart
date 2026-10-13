import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Available avatar presentation styles for the KONFRM profile fallback.
enum AvatarCandidateStyle {
  /// Baseline neutral outline silhouette.
  silhouette,

  /// Candidate 1: Refined Minimalist Illustrated Avatar (Editorial line/flat).
  minimalist,

  /// Candidate 2: Refined Soft 3D Illustrated Avatar (Dimensional soft clay/lighting) — Primary Classic.
  soft3d,

  /// Candidate 2 Variant B: Refined Soft 3D with Textured Dimensional Waves.
  soft3dWaves,

  /// Candidate 2 Variant C: Refined Soft 3D with Architectural Studio Lighting.
  soft3dAmbient,

  /// Candidate 3: Premium Branded Avatar Illustration (Monochrome luxury concierge).
  branded,
}

/// Standalone, resolution-independent vector avatar illustration widget.
///
/// Implements original vector artwork rendered via Flutter CustomPainter,
/// ensuring zero network latency, zero pixelation on high-density displays,
/// and complete visual fidelity across all viewports.
class KonfrmAvatarIllustration extends StatelessWidget {
  const KonfrmAvatarIllustration({
    super.key,
    this.style = AvatarCandidateStyle.soft3d,
    this.size = 44.0,
  });

  final AvatarCandidateStyle style;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: switch (style) {
            AvatarCandidateStyle.silhouette => _SilhouettePainter(),
            AvatarCandidateStyle.minimalist => _MinimalistPainter(),
            AvatarCandidateStyle.soft3d => const _Soft3DPainter(variant: 0),
            AvatarCandidateStyle.soft3dWaves => const _Soft3DPainter(variant: 1),
            AvatarCandidateStyle.soft3dAmbient => const _Soft3DPainter(variant: 2),
            AvatarCandidateStyle.branded => _BrandedPainter(),
          },
        ),
      ),
    );
  }
}

// =============================================================================
// CANDIDATE 0: BASELINE SILHOUETTE PAINTER
// =============================================================================
class _SilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background fill
    final bgPaint = Paint()..color = const Color(0xFFF3F4F6);
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2, bgPaint);

    final strokePaint = Paint()
      ..color = const Color(0xFF4B5563)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round;

    // Head circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.17, strokePaint);

    // Torso arc
    final torsoPath = Path()
      ..moveTo(w * 0.22, h * 0.82)
      ..quadraticBezierTo(w * 0.26, h * 0.62, w * 0.5, h * 0.62)
      ..quadraticBezierTo(w * 0.74, h * 0.62, w * 0.78, h * 0.82);
    canvas.drawPath(torsoPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// CANDIDATE 1: REFINED MINIMALIST ILLUSTRATED AVATAR PAINTER
// Warm editorial linen tones, elegant abstract contours, quiet luxury feel.
// =============================================================================
class _MinimalistPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Background: Warm linen stone fill
    final bgPaint = Paint()..color = const Color(0xFFF6F3EC);
    canvas.drawCircle(center, w / 2, bgPaint);

    // 2. Subtle ambient halo ring
    final haloPaint = Paint()
      ..color = const Color(0xFFECE6D8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03;
    canvas.drawCircle(center, w * 0.46, haloPaint);

    // 3. Shoulders / Torso: Soft warm slate coat
    final torsoPaint = Paint()..color = const Color(0xFF333D4B);
    final torsoPath = Path()
      ..moveTo(w * 0.14, h * 1.0)
      ..cubicTo(w * 0.16, h * 0.66, w * 0.32, h * 0.64, w * 0.50, h * 0.68)
      ..cubicTo(w * 0.68, h * 0.64, w * 0.84, h * 0.66, w * 0.86, h * 1.0)
      ..close();
    canvas.drawPath(torsoPath, torsoPaint);

    // 4. Collar / Neck: Porcelain ivory
    final neckPaint = Paint()..color = const Color(0xFFEBDBC7);
    final neckPath = Path()
      ..moveTo(w * 0.42, h * 0.56)
      ..lineTo(w * 0.42, h * 0.70)
      ..lineTo(w * 0.58, h * 0.70)
      ..lineTo(w * 0.58, h * 0.56)
      ..close();
    canvas.drawPath(neckPath, neckPaint);

    // Collar V-notch in shirt
    final collarPaint = Paint()..color = const Color(0xFFFFFFFF);
    final collarPath = Path()
      ..moveTo(w * 0.45, h * 0.66)
      ..lineTo(w * 0.50, h * 0.74)
      ..lineTo(w * 0.55, h * 0.66)
      ..close();
    canvas.drawPath(collarPath, collarPaint);

    // 5. Head / Face: Stylized warm ivory ovoid
    final facePaint = Paint()..color = const Color(0xFFF7ECDF);
    final faceRect = Rect.fromCenter(
      center: Offset(w * 0.50, h * 0.43),
      width: w * 0.34,
      height: h * 0.40,
    );
    canvas.drawOval(faceRect, facePaint);

    // 6. Hair / Coiffure: Modern architectural sweep in deep charcoal
    final hairPaint = Paint()..color = const Color(0xFF1E242B);
    final hairPath = Path()
      ..moveTo(w * 0.32, h * 0.42)
      ..cubicTo(w * 0.30, h * 0.22, w * 0.46, h * 0.16, w * 0.56, h * 0.18)
      ..cubicTo(w * 0.72, h * 0.20, w * 0.70, h * 0.36, w * 0.68, h * 0.44)
      ..cubicTo(w * 0.60, h * 0.30, w * 0.48, h * 0.28, w * 0.38, h * 0.36)
      ..close();
    canvas.drawPath(hairPath, hairPaint);

    // 7. Minimalist ear accent
    final earPaint = Paint()..color = const Color(0xFFE8D3BD);
    canvas.drawCircle(Offset(w * 0.32, h * 0.44), w * 0.04, earPaint);

    // 8. Outer delicate perimeter ring
    final borderPaint = Paint()
      ..color = const Color(0xFFDFD7C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, (w / 2) - 0.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// CANDIDATE 2: REFINED SOFT 3D ILLUSTRATED AVATAR PAINTER
// Smooth ambient occlusion, volumetric gradients, soft studio lighting,
// expressive friendly facial features, and cohesive neutral variants.
// =============================================================================
class _Soft3DPainter extends CustomPainter {
  const _Soft3DPainter({this.variant = 0});

  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Palette sets tailored per variant
    final (bgColors, torsoColors, skinColors, hairColors) = switch (variant) {
      1 => (
          // Variant 1: Soft Waves (warm amber studio)
          const [Color(0xFFFDF8F0), Color(0xFFF1E6D5)],
          const [Color(0xFF334155), Color(0xFF1E293B)],
          const [Color(0xFFFFE8D6), Color(0xFFF7C8A9), Color(0xFFD49774)],
          const [Color(0xFF5A4A42), Color(0xFF2E241E), Color(0xFF19130F)],
        ),
      2 => (
          // Variant 2: Architectural Ambient (cool platinum studio)
          const [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          const [Color(0xFF27272A), Color(0xFF09090B)],
          const [Color(0xFFFFEDE1), Color(0xFFF5CFB6), Color(0xFFD6997B)],
          const [Color(0xFF64748B), Color(0xFF334155), Color(0xFF0F172A)],
        ),
      _ => (
          // Variant 0: Classic Soft 3D (warm porcelain luxury)
          const [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          const [Color(0xFF3B485A), Color(0xFF1E293B)],
          const [Color(0xFFFFE3D1), Color(0xFFF3C4A5), Color(0xFFD09673)],
          const [Color(0xFF475569), Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
    };

    final bgShader = RadialGradient(
      center: const Alignment(-0.2, -0.3),
      radius: 0.85,
      colors: bgColors,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    final bgPaint = Paint()..shader = bgShader;
    canvas.drawCircle(center, w / 2, bgPaint);

    // 2. Torso drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0x180F172A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.96),
        width: w * 0.76,
        height: h * 0.16,
      ),
      shadowPaint,
    );

    // 3. Volumetric Torso / Shoulders with vertical studio gradient
    final torsoShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: torsoColors,
    ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));
    final torsoPaint = Paint()..shader = torsoShader;

    final torsoPath = Path()
      ..moveTo(w * 0.12, h * 1.0)
      ..cubicTo(w * 0.15, h * 0.65, w * 0.32, h * 0.62, w * 0.50, h * 0.66)
      ..cubicTo(w * 0.68, h * 0.62, w * 0.85, h * 0.65, w * 0.88, h * 1.0)
      ..close();
    canvas.drawPath(torsoPath, torsoPaint);

    // Torso specular rim highlight
    final rimPaint = Paint()
      ..color = const Color(0x2EFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, w * 0.025);
    final rimPath = Path()
      ..moveTo(w * 0.20, h * 0.76)
      ..cubicTo(w * 0.32, h * 0.65, w * 0.68, h * 0.65, w * 0.80, h * 0.76);
    canvas.drawPath(rimPath, rimPaint);

    // 4. Volumetric Neck with warm depth
    final neckShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [skinColors[1], skinColors[2]],
    ).createShader(Rect.fromLTWH(w * 0.4, h * 0.5, w * 0.2, h * 0.2));
    final neckPaint = Paint()..shader = neckShader;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.54, w * 0.16, h * 0.16),
        Radius.circular(w * 0.08),
      ),
      neckPaint,
    );

    // 5. Volumetric Head: Spherical form with key lighting from top-left
    final headShader = RadialGradient(
      center: const Alignment(-0.35, -0.40),
      radius: 0.85,
      colors: skinColors,
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromCircle(
      center: Offset(w * 0.50, h * 0.42),
      radius: w * 0.22,
    ));
    final headPaint = Paint()..shader = headShader;
    canvas.drawCircle(Offset(w * 0.50, h * 0.42), w * 0.20, headPaint);

    // 6. Volumetric Coiffure / Hair with top specular highlight
    final hairShader = RadialGradient(
      center: const Alignment(-0.25, -0.6),
      radius: 0.9,
      colors: hairColors,
    ).createShader(Rect.fromCircle(
      center: Offset(w * 0.50, h * 0.32),
      radius: w * 0.22,
    ));
    final hairPaint = Paint()..shader = hairShader;

    if (variant == 1) {
      // Variant 1: Textured dimensional wave volume
      final wavePath = Path()
        ..moveTo(w * 0.28, h * 0.43)
        ..cubicTo(w * 0.24, h * 0.28, w * 0.35, h * 0.13, w * 0.50, h * 0.14)
        ..cubicTo(w * 0.65, h * 0.13, w * 0.76, h * 0.28, w * 0.72, h * 0.43)
        ..cubicTo(w * 0.66, h * 0.34, w * 0.58, h * 0.32, w * 0.50, h * 0.35)
        ..cubicTo(w * 0.42, h * 0.32, w * 0.34, h * 0.34, w * 0.28, h * 0.43)
        ..close();
      canvas.drawPath(wavePath, hairPaint);

      // Soft side volume curls
      canvas.drawCircle(Offset(w * 0.30, h * 0.38), w * 0.05, hairPaint);
      canvas.drawCircle(Offset(w * 0.70, h * 0.38), w * 0.05, hairPaint);
    } else if (variant == 2) {
      // Variant 2: Clean architectural sweep
      final sweepPath = Path()
        ..moveTo(w * 0.32, h * 0.41)
        ..cubicTo(w * 0.30, h * 0.20, w * 0.46, h * 0.15, w * 0.56, h * 0.17)
        ..cubicTo(w * 0.72, h * 0.19, w * 0.70, h * 0.33, w * 0.68, h * 0.41)
        ..cubicTo(w * 0.60, h * 0.30, w * 0.48, h * 0.28, w * 0.38, h * 0.34)
        ..close();
      canvas.drawPath(sweepPath, hairPaint);
    } else {
      // Variant 0: Classic modern sweep
      final hairPath = Path()
        ..moveTo(w * 0.30, h * 0.42)
        ..cubicTo(w * 0.28, h * 0.18, w * 0.46, h * 0.14, w * 0.58, h * 0.16)
        ..cubicTo(w * 0.74, h * 0.18, w * 0.72, h * 0.34, w * 0.70, h * 0.42)
        ..cubicTo(w * 0.62, h * 0.28, w * 0.48, h * 0.26, w * 0.36, h * 0.34)
        ..close();
      canvas.drawPath(hairPath, hairPaint);
    }

    // 7. Facial Definition (Sharp, friendly, and legible at 44dp)
    // 7a. Delicate Eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, w * 0.024)
      ..strokeCap = StrokeCap.round;

    final leftBrow = Path()
      ..moveTo(w * 0.39, h * 0.38)
      ..quadraticBezierTo(w * 0.435, h * 0.365, w * 0.47, h * 0.385);
    final rightBrow = Path()
      ..moveTo(w * 0.53, h * 0.385)
      ..quadraticBezierTo(w * 0.565, h * 0.365, w * 0.61, h * 0.38);
    canvas.drawPath(leftBrow, browPaint);
    canvas.drawPath(rightBrow, browPaint);

    // 7b. Friendly Smiling Eyes (curved arc with soft dark slate)
    final eyePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.3, w * 0.038)
      ..strokeCap = StrokeCap.round;

    final leftEye = Path()
      ..moveTo(w * 0.395, h * 0.435)
      ..quadraticBezierTo(w * 0.435, h * 0.412, w * 0.475, h * 0.435);
    final rightEye = Path()
      ..moveTo(w * 0.525, h * 0.435)
      ..quadraticBezierTo(w * 0.565, h * 0.412, w * 0.605, h * 0.435);
    canvas.drawPath(leftEye, eyePaint);
    canvas.drawPath(rightEye, eyePaint);

    // 7c. Soft Cheek Warmth (Blush / Ambient Depth)
    final blushPaint = Paint()
      ..color = const Color(0x26E07A5F)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawCircle(Offset(w * 0.365, h * 0.47), w * 0.046, blushPaint);
    canvas.drawCircle(Offset(w * 0.635, h * 0.47), w * 0.046, blushPaint);

    // 7d. Subtle Nose Contour
    final nosePaint = Paint()
      ..color = const Color(0x3DB57D4F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.9, w * 0.022)
      ..strokeCap = StrokeCap.round;
    final nosePath = Path()
      ..moveTo(w * 0.485, h * 0.465)
      ..quadraticBezierTo(w * 0.50, h * 0.474, w * 0.515, h * 0.465);
    canvas.drawPath(nosePath, nosePaint);

    // 7e. Warm Friendly Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.3, w * 0.034)
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(w * 0.445, h * 0.512)
      ..quadraticBezierTo(w * 0.50, h * 0.542, w * 0.555, h * 0.512);
    canvas.drawPath(smilePath, smilePaint);

    // 7f. Specular Forehead & Cheek Light Points (Soft Clay 3D feel)
    final specPaint = Paint()..color = const Color(0x38FFFFFF);
    canvas.drawCircle(Offset(w * 0.44, h * 0.35), w * 0.035, specPaint);

    // 8. Outer polished perimeter ring
    final borderPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, (w / 2) - 0.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _Soft3DPainter oldDelegate) =>
      oldDelegate.variant != variant;
}

// =============================================================================
// CANDIDATE 3: PREMIUM BRANDED AVATAR ILLUSTRATION PAINTER
// Monochrome luxury concierge, deep obsidian foundation, platinum geometric lines.
// =============================================================================
class _BrandedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Background: Deep obsidian black
    final bgPaint = Paint()..color = const Color(0xFF0A0B0E);
    canvas.drawCircle(center, w / 2, bgPaint);

    // 2. Subtle architectural concentric rings (KONFRM geometric identity)
    final ringPaint1 = Paint()
      ..color = const Color(0xFF1E2229)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, w * 0.44, ringPaint1);

    final ringPaint2 = Paint()
      ..color = const Color(0xFF15181D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, w * 0.36, ringPaint2);

    // 3. Torso: Structured black luxury tuxedo / blazer
    final torsoPaint = Paint()..color = const Color(0xFF16181D);
    final torsoPath = Path()
      ..moveTo(w * 0.12, h * 1.0)
      ..cubicTo(w * 0.16, h * 0.65, w * 0.34, h * 0.62, w * 0.50, h * 0.67)
      ..cubicTo(w * 0.66, h * 0.62, w * 0.84, h * 0.65, w * 0.88, h * 1.0)
      ..close();
    canvas.drawPath(torsoPath, torsoPaint);

    // Platinum lapel contours (crisp monochrome precision lines)
    final lapelPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.024
      ..strokeCap = StrokeCap.round;

    final lapelLeft = Path()
      ..moveTo(w * 0.38, h * 0.66)
      ..lineTo(w * 0.46, h * 0.86);
    canvas.drawPath(lapelLeft, lapelPaint);

    final lapelRight = Path()
      ..moveTo(w * 0.62, h * 0.66)
      ..lineTo(w * 0.54, h * 0.86);
    canvas.drawPath(lapelRight, lapelPaint);

    // 4. Neck / Collar: Crisp pure white geometric diamond notch
    final shirtPaint = Paint()..color = const Color(0xFFFFFFFF);
    final shirtPath = Path()
      ..moveTo(w * 0.46, h * 0.62)
      ..lineTo(w * 0.50, h * 0.72)
      ..lineTo(w * 0.54, h * 0.62)
      ..close();
    canvas.drawPath(shirtPath, shirtPaint);

    // 5. Stylized Head: Pure white & platinum sculptural silhouette
    final headPaint = Paint()..color = const Color(0xFFFAFAFA);
    canvas.drawCircle(Offset(w * 0.50, h * 0.42), w * 0.18, headPaint);

    // Subtle platinum shadow on head
    final headShadowPaint = Paint()..color = const Color(0xFFE4E4E7);
    final headShadowPath = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(w * 0.50, h * 0.42),
          radius: w * 0.18,
        ),
        math.pi * 0.25,
        math.pi * 0.65,
      );
    headShadowPaint.style = PaintingStyle.stroke;
    headShadowPaint.strokeWidth = w * 0.04;
    canvas.drawPath(headShadowPath, headShadowPaint);

    // 6. Precision Geometric Hair Cap in deep obsidian with platinum rim
    final hairPaint = Paint()..color = const Color(0xFF181A20);
    final hairPath = Path()
      ..moveTo(w * 0.32, h * 0.40)
      ..cubicTo(w * 0.30, h * 0.20, w * 0.46, h * 0.16, w * 0.56, h * 0.17)
      ..cubicTo(w * 0.70, h * 0.19, w * 0.70, h * 0.32, w * 0.68, h * 0.40)
      ..cubicTo(w * 0.60, h * 0.28, w * 0.48, h * 0.26, w * 0.38, h * 0.34)
      ..close();
    canvas.drawPath(hairPath, hairPaint);

    // Platinum fine accent line across hair crown
    final crownAccentPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(hairPath, crownAccentPaint);

    // 7. Outer luxury platinum ring
    final borderPaint = Paint()
      ..color = const Color(0xFF333842)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, (w / 2) - 0.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
