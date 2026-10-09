import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/app/app.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  group('KONFRM | GUEST — CustomerAppShell Foundation & Navigation', () {
    testWidgets(
      'renders Arabic-first RTL, Cairo theme, and initial Explore tab',
      (WidgetTester tester) async {
        await tester.pumpWidget(const KonfrmCustomerApp());
        await tester.pumpAndSettle();

        // Verify Directionality is RTL
        final BuildContext context = tester.element(
          find.byType(CustomerBottomNavigation),
        );
        expect(Directionality.of(context), equals(TextDirection.rtl));

        // Verify initial tab is Explore (Index 0)
        expect(find.text('كونفرم | استكشف'), findsOneWidget);
        expect(
          find.text('ابحث عن بيوت العطلات والشاليهات الموثقة'),
          findsOneWidget,
        );
        expect(find.byKey(const Key('explore-search-field')), findsOneWidget);
        expect(find.byKey(const Key('explore-status-card')), findsOneWidget);

        // Verify CustomerBottomNavigation has 4 destinations
        expect(find.byKey(const Key('customer-destination-0')), findsOneWidget);
        expect(find.byKey(const Key('customer-destination-1')), findsOneWidget);
        expect(find.byKey(const Key('customer-destination-2')), findsOneWidget);
        expect(find.byKey(const Key('customer-destination-3')), findsOneWidget);

        // Verify Arabic navigation labels
        expect(find.text('استكشف'), findsAtLeastNWidgets(1));
        expect(find.text('المفضلة'), findsOneWidget);
        expect(find.text('حجوزاتي'), findsOneWidget);
        expect(find.text('الحساب'), findsOneWidget);
      },
    );

    testWidgets('switches between all 4 root tabs cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const KonfrmCustomerApp());
      await tester.pumpAndSettle();

      // Tab 0 -> Explore is active
      expect(find.text('كونفرم | استكشف'), findsOneWidget);

      // Tap Tab 1: Favorites
      await tester.tap(find.byKey(const Key('customer-destination-1')));
      await tester.pumpAndSettle();
      expect(find.text('قائمتك المفضلة فارغة'), findsOneWidget);
      expect(find.byKey(const Key('favorites-empty-card')), findsOneWidget);

      // Tap Tab 2: Bookings
      await tester.tap(find.byKey(const Key('customer-destination-2')));
      await tester.pumpAndSettle();
      expect(find.text('لا توجد حجوزات نشطة'), findsOneWidget);
      expect(find.byKey(const Key('bookings-empty-card')), findsOneWidget);

      // Tap Tab 3: Account
      await tester.tap(find.byKey(const Key('customer-destination-3')));
      await tester.pumpAndSettle();
      expect(find.text('جلسة زائر (غير مسجل)'), findsOneWidget);
      expect(find.byKey(const Key('account-login-button')), findsOneWidget);

      // Tap Tab 0: Explore again
      await tester.tap(find.byKey(const Key('customer-destination-0')));
      await tester.pumpAndSettle();
      expect(find.text('كونفرم | استكشف'), findsOneWidget);
    });

    testWidgets(
      'Android back navigation returns to tab 0 from tabs 1, 2, and 3',
      (WidgetTester tester) async {
        await tester.pumpWidget(const KonfrmCustomerApp());
        await tester.pumpAndSettle();

        // Navigate to Tab 1 (Favorites)
        await tester.tap(find.byKey(const Key('customer-destination-1')));
        await tester.pumpAndSettle();
        expect(find.text('قائمتك المفضلة فارغة'), findsOneWidget);

        // Trigger Android system back
        final bool handledFromTab1 = await tester.binding.handlePopRoute();
        expect(handledFromTab1, isTrue);
        await tester.pumpAndSettle();

        // Must be returned to Tab 0 (Explore)
        expect(find.text('كونفرم | استكشف'), findsOneWidget);

        // Navigate to Tab 2 (Bookings)
        await tester.tap(find.byKey(const Key('customer-destination-2')));
        await tester.pumpAndSettle();
        expect(find.text('لا توجد حجوزات نشطة'), findsOneWidget);

        // Trigger Android system back
        final bool handledFromTab2 = await tester.binding.handlePopRoute();
        expect(handledFromTab2, isTrue);
        await tester.pumpAndSettle();

        // Must be returned to Tab 0 (Explore)
        expect(find.text('كونفرم | استكشف'), findsOneWidget);

        // Navigate to Tab 3 (Account)
        await tester.tap(find.byKey(const Key('customer-destination-3')));
        await tester.pumpAndSettle();
        expect(find.text('جلسة زائر (غير مسجل)'), findsOneWidget);

        // Trigger Android system back
        final bool handledFromTab3 = await tester.binding.handlePopRoute();
        expect(handledFromTab3, isTrue);
        await tester.pumpAndSettle();

        // Must be returned to Tab 0 (Explore)
        expect(find.text('كونفرم | استكشف'), findsOneWidget);

        // On Tab 0, system back allows pop
        final bool handledFromTab0 = await tester.binding.handlePopRoute();
        // On root route, canPop is true, so PopScope allows pop
        expect(handledFromTab0, isFalse);
      },
    );

    testWidgets(
      'Bookings empty state recovery action switches to Explore tab',
      (WidgetTester tester) async {
        await tester.pumpWidget(const KonfrmCustomerApp());
        await tester.pumpAndSettle();

        // Go to Bookings
        await tester.tap(find.byKey(const Key('customer-destination-2')));
        await tester.pumpAndSettle();
        expect(find.text('لا توجد حجوزات نشطة'), findsOneWidget);

        // Tap recovery button "استكشف الآن"
        await tester.tap(find.text('استكشف الآن'));
        await tester.pumpAndSettle();

        // Should now be on Explore tab
        expect(find.text('كونفرم | استكشف'), findsOneWidget);
      },
    );

    testWidgets('unauthenticated guest session honesty across all views', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const KonfrmCustomerApp());
      await tester.pumpAndSettle();

      // Zero fabricated property cards on Explore
      expect(find.text('SAR'), findsNothing);
      expect(find.text('ر.س'), findsNothing);

      // Switch to Favorites
      await tester.tap(find.byKey(const Key('customer-destination-1')));
      await tester.pumpAndSettle();
      // Zero mock favorites
      expect(find.text('قائمتك المفضلة فارغة'), findsOneWidget);

      // Switch to Bookings
      await tester.tap(find.byKey(const Key('customer-destination-2')));
      await tester.pumpAndSettle();
      // Zero mock bookings or fake confirmation codes
      expect(find.text('لا توجد حجوزات نشطة'), findsOneWidget);
      expect(find.text('CONF-'), findsNothing);

      // Switch to Account
      await tester.tap(find.byKey(const Key('customer-destination-3')));
      await tester.pumpAndSettle();
      // Truthful guest persona
      expect(find.text('جلسة زائر (غير مسجل)'), findsOneWidget);
      expect(find.text('تسجيل الدخول / إنشاء حساب'), findsOneWidget);
    });

    for (final textScale in [1.0, 1.5, 2.0]) {
      testWidgets(
        'renders all 4 tabs at ${textScale * 100}% text scale without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(textScale),
                size: const Size(540, 1200),
              ),
              child: const KonfrmCustomerApp(),
            ),
          );
          await tester.pumpAndSettle();

          // Check Explore
          expect(tester.takeException(), isNull);

          // Check Favorites
          await tester.tap(find.byKey(const Key('customer-destination-1')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          // Check Bookings
          await tester.tap(find.byKey(const Key('customer-destination-2')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          // Check Account
          await tester.tap(find.byKey(const Key('customer-destination-3')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}
