// =============================================================================
// KONFRM Customer Application — Batch C Corrected Automated Verification Suite
//
// Target Hardware Profile: Samsung Galaxy A56 5G (Android 16 API 36)
// Scope: Behavioral and layout verification for Screens 18, 19
// Directives:
//   - Physical RTL Back Arrow Law: Must point physically to RIGHT [➔]
//   - Pure-Black (#000000) Theme Invariant
//   - Purge Visible Development Strings: No «بيانات تجريبية» or mock labels
//   - Zero-Tolerance 200% Accessibility Font Scale Reflow
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/batch_c_corrected_runner.dart';

void main() {
  group('Batch C — Physical Right Back Arrow Tests', () {
    testWidgets('Screen 18 has physical right back button pointing right [➔]', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen18View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen18_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      expect(find.byKey(const Key('screen18_save_button')), findsOneWidget);
    });

    testWidgets('Screen 19 has physical right back button pointing right [➔] and purged test copy', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen19View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen19_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      // Verify purged development copy
      expect(find.textContaining('بيانات تجريبية'), findsNothing);
      expect(find.textContaining('تجريبي'), findsNothing);
    });

    testWidgets('Batch C screens render without overflow under 200% accessibility scaling', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final screenWidget in const [
        CorrectedScreen18View(),
        CorrectedScreen19View(),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2.0),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: child!,
                ),
              );
            },
            home: Scaffold(
              body: screenWidget,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Screen $screenWidget should not throw any overflow under 200% scaling');
      }
    });
  });
}
