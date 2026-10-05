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

  testWidgets('Bidi scenario renders actual LTR-isolated lab values', (
    tester,
  ) async {
    await tester.pumpWidget(const KonfrmValidationApp());
    await tester.tap(find.widgetWithText(ChoiceChip, 'RTL وBidi'));
    await tester.pumpAndSettle();

    for (final value in [
      '+20 100 123 4567',
      'user@example.test',
      'BK-183223',
      'PR-0091',
      '1,600 ج.م',
      'KONFRM system',
    ]) {
      final valueFinder = find.text(value);
      expect(valueFinder, findsOneWidget, reason: value);
      expect(
        Directionality.of(tester.element(valueFinder)),
        TextDirection.ltr,
        reason: '$value is isolated in the rendered widget tree',
      );
    }
  });

  testWidgets('eight domain examples remain harness data', (tester) async {
    await tester.pumpWidget(const KonfrmValidationApp());
    await tester.tap(find.widgetWithText(ChoiceChip, 'الحالات'));
    // The selected state scenario intentionally contains an indeterminate
    // loading indicator, so process only the section-change frame.
    await tester.pump();
    expect(find.byType(StatusBadge), findsNWidgets(8));
  });

  testWidgets('200 percent scale persists across every diagnostic section', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const KonfrmValidationApp());
    await tester.tap(find.text('200%'));
    await tester.pump();

    final sections = <(String, Finder)>[
      ('النص', find.text('العربية الواضحة تبدأ من التسلسل الهرمي')),
      ('الإجراءات', find.text('متابعة')),
      ('الحقول', find.text('الاسم')),
      ('RTL وBidi', find.text('اتصل على')),
      ('الحالات', find.text('تعذر تحميل المحتوى')),
      ('التجميع', find.text('ما الذي يحتاج مني تصرفًا الآن؟')),
      ('تنقل العميل', find.byType(CustomerBottomNavigation)),
      ('الإجراء الثابت', find.byType(StickyActionSurface)),
    ];
    final catalogScrollable = find.byType(Scrollable).first;
    final catalogPosition = tester
        .state<ScrollableState>(catalogScrollable)
        .position;
    for (final entry in sections) {
      catalogPosition.jumpTo(catalogPosition.minScrollExtent);
      await tester.pump();
      final sectionChip = find.widgetWithText(ChoiceChip, entry.$1).first;
      await tester.ensureVisible(sectionChip);
      await tester.pump();
      await tester.tap(sectionChip);
      await tester.pump();
      await tester.ensureVisible(entry.$2.first);
      await tester.pump();
      expect(entry.$2, findsWidgets, reason: entry.$1);
      expect(
        MediaQuery.of(tester.element(entry.$2.first)).textScaler.scale(10),
        20,
        reason: 'scale remains selected in ${entry.$1}',
      );
      expect(tester.takeException(), isNull, reason: entry.$1);
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
