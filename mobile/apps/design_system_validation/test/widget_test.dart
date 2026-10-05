import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_system_validation/main.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  testWidgets(
    'catalog opens Arabic-first with explicit lab disclosure and grouped scenarios',
    (tester) async {
      await tester.pumpWidget(const KonfrmValidationApp());
      expect(find.textContaining('LAB_SCENARIO_DATA'), findsOneWidget);
      expect(find.text('مختبر KONFRM'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('200%'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('مختبر KONFRM'))),
        TextDirection.rtl,
      );
      expect(
        Theme.of(tester.element(find.text('مختبر KONFRM')))
            .textTheme
            .bodyMedium!
            .fontFamily,
        'packages/konfrm_design_system/Cairo',
      );
    },
  );

  testWidgets('customer bottom nav and sticky-action scenarios are isolated', (
    tester,
  ) async {
    await tester.pumpWidget(const KonfrmValidationApp());
    await tester.ensureVisible(find.text('تنقل العميل'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تنقل العميل'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerBottomNavigation), findsOneWidget);
    expect(find.byType(StickyActionSurface), findsNothing);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    await tester.ensureVisible(find.text('الإجراء الثابت'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الإجراء الثابت'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerBottomNavigation), findsNothing);
    expect(find.byType(StickyActionSurface), findsOneWidget);
  });

  testWidgets(
    'Owner grouping lab scenario is present without production claims',
    (tester) async {
      await tester.pumpWidget(const KonfrmValidationApp());
      await tester.ensureVisible(find.text('التجميع'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('التجميع'));
      await tester.pumpAndSettle();
      expect(find.text('ما الذي يحتاج مني تصرفًا الآن؟'), findsOneWidget);
      expect(
        find.text(
          'بيانات مختبر فقط — LAB_SCENARIO_DATA. لا تمثل بيانات أو نتائج إنتاجية.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('text scaling can be selected through 200 percent', (
    tester,
  ) async {
    await tester.pumpWidget(const KonfrmValidationApp());
    await tester.tap(find.text('200%'));
    await tester.pumpAndSettle();
    final media = tester.widget<MediaQuery>(find.byType(MediaQuery).at(1));
    expect(media.data.textScaler.scale(10), 20);
    expect(tester.takeException(), isNull);
  });
}
