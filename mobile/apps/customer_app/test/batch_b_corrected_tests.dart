// =============================================================================
// KONFRM Customer Application — Batch B Corrected Automated Verification Suite
//
// Target Hardware Profile: Samsung Galaxy A56 5G (Android 16 API 36)
// Scope: Behavioral and layout verification for Screens 13, 14, 16
// Directives:
//   - Physical RTL Back Arrow Law: Must point physically to RIGHT [➔]
//   - Pure-Black (#000000) Theme Invariant
//   - Epistemic Canon Invariant: Neutral «عربون الليلة الأولى» without claims
//   - Sanitized Reference Invariant: «رقم الحجز 310482» / «رقم الحجز 829104» (no BK-)
//   - Zero-Tolerance 200% Accessibility Font Scale Reflow
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/batch_b_corrected_runner.dart';

void main() {
  group('Batch B — Physical Right Back Arrow Tests', () {
    testWidgets('Screen 13 has physical right back button pointing right [➔]', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen13View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen13_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      // Verify sanitized booking ID (no BK-)
      expect(find.text('رقم الحجز 310482'), findsOneWidget);
      expect(find.textContaining('BK-'), findsNothing);

      // Verify absence of unapproved check-in / check-out hours
      expect(find.textContaining('03:00'), findsNothing);
      expect(find.textContaining('11:00'), findsNothing);
      expect(find.text('طلبك قيد المراجعة حالياً من المالك، ولا يلزم أي دفع في هذه المرحلة.'), findsOneWidget);
    });

    testWidgets('Screen 14 has physical right back button pointing right [➔]', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen14View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen14_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      // Verify sanitized booking ID (no BK-)
      expect(find.text('رقم الحجز 829104'), findsOneWidget);
      expect(find.textContaining('BK-'), findsNothing);

      // Verify neutral electronic payment line without brand claims
      expect(find.text('سداد آمن عبر بوابة الدفع الإلكتروني'), findsOneWidget);
      expect(find.textContaining('Visa'), findsNothing);
      expect(find.textContaining('Mastercard'), findsNothing);
      expect(find.textContaining('Meeza'), findsNothing);
    });

    testWidgets('Screen 14 deposit breakdown uses canonical «عربون الليلة الأولى» without unapproved claims', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen14View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عربون الليلة الأولى المستحق الآن'), findsOneWidget);
      expect(find.textContaining('غير قابل للاسترداد'), findsNothing);
      expect(find.textContaining('عند الوصول'), findsNothing);
      expect(find.byKey(const Key('screen14_pay_button')), findsOneWidget);
    });

    testWidgets('Screen 16 has physical right back button pointing right [➔]', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen16View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen16_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      // Verify notification copy without key handover claim
      expect(find.text('أرسل أحمد رسالة جديدة بخصوص تفاصيل وتنسيق الحجز.'), findsOneWidget);
      expect(find.textContaining('استلام المفاتيح'), findsNothing);
    });

    testWidgets('Batch B screens render without overflow under 200% accessibility scaling', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final screenWidget in const [
        CorrectedScreen13View(),
        CorrectedScreen14View(),
        CorrectedScreen16View(),
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
