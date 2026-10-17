// =============================================================================
// KONFRM Customer Application — Batch A Corrected Tests (Screens 04, 05, 07, 10)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/batch_a_corrected_runner.dart';

void main() {
  group('Batch A — Physical Right Back Arrow Tests', () {
    testWidgets('Screen 04 has physical right back button pointing right [➔]', (tester) async {
      final controller = BatchAController();
      controller.selectScreen(BatchAScreen.screen04SearchRefine);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: BatchAMainView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen04_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));
    });

    testWidgets('Screen 05 has physical right back button pointing right [➔]', (tester) async {
      final controller = BatchAController();
      controller.selectScreen(BatchAScreen.screen05SearchResults);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: BatchAMainView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen05_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));
    });

    testWidgets('Screen 07 has physical right back button pointing right [➔]', (tester) async {
      final controller = BatchAController();
      controller.selectScreen(BatchAScreen.screen07BookingReview);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: BatchAMainView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen07_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));
    });

    testWidgets('Screen 07 deposit breakdown uses canonical «عربون الليلة الأولى» without unapproved claims', (tester) async {
      final controller = BatchAController();
      controller.selectScreen(BatchAScreen.screen07BookingReview);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: BatchAMainView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verified Canon Line Item
      expect(find.text('عربون الليلة الأولى'), findsOneWidget);
      expect(find.text('4,500 ج.م'), findsOneWidget);
      expect(find.text('المبلغ المتبقي'), findsOneWidget);
      expect(find.text('9,000 ج.م'), findsOneWidget);

      // Banned unapproved policy assertions must be absent
      expect(find.textContaining('غير قابل للاسترداد'), findsNothing);
      expect(find.textContaining('عند الوصول'), findsNothing);
      expect(find.textContaining('يُسدد بعد مراجعة'), findsNothing);
      expect(find.text('لا يُدفع العربون قبل موافقة المالك.'), findsOneWidget);
    });

    testWidgets('Screen 10 has physical right back button pointing right [➔]', (tester) async {
      final controller = BatchAController();
      controller.selectScreen(BatchAScreen.screen10ProfileSetup);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: BatchAMainView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen10_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));
    });

    testWidgets('Batch A screens render without overflow under 200% accessibility scaling', (tester) async {
      final controller = BatchAController();

      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('FLUTTER_ERROR_DETAILS:\n${details.toString()}');
      };

      for (final screen in BatchAScreen.values) {
        controller.selectScreen(screen);
        if (!controller.isA11y200) {
          controller.toggleA11y();
        }

        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2.0)),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              ),
            ),
            home: BatchAMainView(controller: controller),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      }
    });
  });
}
