import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Android Brand Resources & Adaptive Icon Safe-Zone Regression', () {
    test('ic_launcher_foreground.xml maintains Founder geometry and safe-zone margin', () {
      final file = File('android/app/src/main/res/drawable/ic_launcher_foreground.xml');
      expect(file.existsSync(), isTrue, reason: 'ic_launcher_foreground.xml must exist');

      final content = file.readAsStringSync();

      // 1. Canvas and Viewport dimensions
      expect(content, contains('android:width="108dp"'));
      expect(content, contains('android:height="108dp"'));
      expect(content, contains('android:viewportWidth="6320"'));
      expect(content, contains('android:viewportHeight="6320"'));

      // 2. Centered Translation Group
      expect(content, contains('android:translateX="1871.82"'));
      expect(content, contains('android:translateY="2042.32"'));

      // 3. Exact Founder Vector Path Invariants
      expect(
        content,
        contains('android:pathData="M75.7754,75.7754H947.188V1098.74L151.55,2140.64H75.7754V75.7754Z"'),
        reason: 'Path 1 must preserve exact Founder SVG geometry including H75.7754',
      );
      expect(
        content,
        contains('android:pathData="M1723.88,75.7754H2500.58L2064.87,1098.74L2500.58,2159.59H1723.88L1174.51,1117.68L1723.88,75.7754Z"'),
        reason: 'Path 2 must preserve exact Founder SVG geometry',
      );
      expect(content, contains('android:strokeWidth="151.55"'));
      expect(content, contains('android:strokeLineJoin="round"'));

      // 4. Quantitative Safe-Zone Validation
      const viewport = 6320.0;
      const targetCenter = viewport / 2; // 3160.0
      const safeRadius = (66.0 / 108.0) * targetCenter; // 1931.11
      const strokeRadius = 151.55 / 2; // 75.775

      const tx = 1871.82;
      const ty = 2042.32;

      final vertices = [
        // Left glyph
        const [75.7754, 75.7754],
        const [947.188, 75.7754],
        const [947.188, 1098.74],
        const [151.55, 2140.64],
        const [75.7754, 2140.64],
        // Right glyph
        const [1723.88, 75.7754],
        const [2500.58, 75.7754],
        const [2064.87, 1098.74],
        const [2500.58, 2159.59],
        const [1723.88, 2159.59],
        const [1174.51, 1117.68],
      ];

      double maxDistance = 0.0;
      for (final pt in vertices) {
        final x = pt[0] + tx;
        final y = pt[1] + ty;
        final dist = math.sqrt(math.pow(x - targetCenter, 2) + math.pow(y - targetCenter, 2)) + strokeRadius;
        if (dist > maxDistance) {
          maxDistance = dist;
        }
      }

      // Max vertex distance must be strictly within safe zone with >= 10% breathing room
      expect(maxDistance, lessThan(safeRadius));
      final breathingRoom = (safeRadius - maxDistance) / safeRadius;
      expect(breathingRoom, greaterThan(0.10), reason: 'Must have at least 10% breathing room inside 66dp safe circle');
    });

    test('Android 12+ (v31) launch themes enforce Light-first splash surface and icon', () {
      final v31Styles = File('android/app/src/main/res/values-v31/styles.xml');
      expect(v31Styles.existsSync(), isTrue);
      final v31Content = v31Styles.readAsStringSync();
      expect(v31Content, contains('android:windowSplashScreenBackground'));
      expect(v31Content, contains('@android:color/white'));
      expect(v31Content, contains('@drawable/ic_launcher_foreground'));

      final nightV31Styles = File('android/app/src/main/res/values-night-v31/styles.xml');
      expect(nightV31Styles.existsSync(), isTrue);
      final nightV31Content = nightV31Styles.readAsStringSync();
      expect(nightV31Content, contains('android:windowSplashScreenBackground'));
      expect(nightV31Content, contains('@android:color/white'));
      expect(nightV31Content, contains('@drawable/ic_launcher_foreground'));

      final drawableV21 = File('android/app/src/main/res/drawable-v21/launch_background.xml');
      expect(drawableV21.existsSync(), isTrue);
      expect(drawableV21.readAsStringSync(), contains('@android:color/white'));
    });
  });
}
