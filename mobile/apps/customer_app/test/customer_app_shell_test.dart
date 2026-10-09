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
        expect(
          find.byKey(const Key('explore-search-affordance')),
          findsOneWidget,
        );
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
      expect(
        find.byKey(const Key('favorites-unauthorized-card')),
        findsOneWidget,
      );

      // Tap Tab 2: Bookings
      await tester.tap(find.byKey(const Key('customer-destination-2')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('bookings-unauthorized-card')),
        findsOneWidget,
      );

      // Tap Tab 3: Account
      await tester.tap(find.byKey(const Key('customer-destination-3')));
      await tester.pumpAndSettle();
      expect(find.text('جلسة زائر (غير مسجل)'), findsOneWidget);
      expect(
        find.byKey(const Key('account-auth-deferred-alert')),
        findsOneWidget,
      );

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
        expect(
          find.byKey(const Key('favorites-unauthorized-card')),
          findsOneWidget,
        );

        // Trigger Android system back
        final bool handledFromTab1 = await tester.binding.handlePopRoute();
        expect(handledFromTab1, isTrue);
        await tester.pumpAndSettle();

        // Must be returned to Tab 0 (Explore)
        expect(find.text('كونفرم | استكشف'), findsOneWidget);

        // Navigate to Tab 2 (Bookings)
        await tester.tap(find.byKey(const Key('customer-destination-2')));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('bookings-unauthorized-card')),
          findsOneWidget,
        );

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
      'UNAUTHORIZED != EMPTY: Guest Favorites and Bookings show unauthorized state and never claim zero records',
      (WidgetTester tester) async {
        await tester.pumpWidget(const KonfrmCustomerApp());
        await tester.pumpAndSettle();

        // 1. Check Favorites Tab
        await tester.tap(find.byKey(const Key('customer-destination-1')));
        await tester.pumpAndSettle();

        // Negative check: Must NOT claim list is empty when unauthenticated
        expect(find.text('قائمتك المفضلة فارغة'), findsNothing);
        expect(find.text('المفضلة فارغة'), findsNothing);

        // Positive check: Must clearly state authentication is required
        expect(find.text('تسجيل الدخول مطلوب'), findsOneWidget);
        expect(
          find.textContaining('يتطلب حفظ العقارات المفضلة'),
          findsOneWidget,
        );

        // 2. Check Bookings Tab
        await tester.tap(find.byKey(const Key('customer-destination-2')));
        await tester.pumpAndSettle();

        // Negative check: Must NOT claim zero records when no account is loaded
        expect(find.text('لا توجد حجوزات نشطة'), findsNothing);
        expect(find.text('لا توجد حجوزات بعد'), findsNothing);
        expect(find.text('CONF-'), findsNothing);
        expect(find.text('BK-'), findsNothing);

        // Positive check: Must clearly state authentication is required
        expect(find.text('تسجيل الدخول مطلوب'), findsOneWidget);
        expect(
          find.textContaining('يتطلب استعراض الحجوزات السابقة'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Functional recovery: Favorites and Bookings recovery buttons navigate to Explore',
      (WidgetTester tester) async {
        await tester.pumpWidget(const KonfrmCustomerApp());
        await tester.pumpAndSettle();

        // Test Favorites recovery -> Explore
        await tester.tap(find.byKey(const Key('customer-destination-1')));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('favorites-unauthorized-card')),
          findsOneWidget,
        );

        // Tap recovery button "استكشف العقارات"
        await tester.tap(find.text('استكشف العقارات'));
        await tester.pumpAndSettle();
        expect(find.text('كونفرم | استكشف'), findsOneWidget);

        // Test Bookings recovery -> Explore
        await tester.tap(find.byKey(const Key('customer-destination-2')));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('bookings-unauthorized-card')),
          findsOneWidget,
        );

        // Tap recovery button "استكشف الآن"
        await tester.tap(find.text('استكشف الآن'));
        await tester.pumpAndSettle();
        expect(find.text('كونفرم | استكشف'), findsOneWidget);
      },
    );

    testWidgets('Zero dead controls: No enabled actions without behavior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const KonfrmCustomerApp());
      await tester.pumpAndSettle();

      // 1. Explore Tab: No dead recovery button or fake search submit
      expect(find.text('تحديث النتائج'), findsNothing);
      expect(find.byType(TextField), findsNothing);

      // 2. Account Tab: No dead login button
      await tester.tap(find.byKey(const Key('customer-destination-3')));
      await tester.pumpAndSettle();
      expect(find.text('تسجيل الدخول / إنشاء حساب'), findsNothing);
      expect(find.byType(PrimaryButton), findsNothing);
      expect(
        find.byKey(const Key('account-auth-deferred-alert')),
        findsOneWidget,
      );
    });

    testWidgets('Zero fabricated customer, booking or financial data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const KonfrmCustomerApp());
      await tester.pumpAndSettle();

      // Zero fake prices or currency tokens
      expect(find.text('SAR'), findsNothing);
      expect(find.text('ر.س'), findsNothing);
      expect(find.text('\$'), findsNothing);

      // Zero fake IDs across all tabs
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byKey(Key('customer-destination-$i')));
        await tester.pumpAndSettle();
        expect(find.text('CONF-'), findsNothing);
        expect(find.text('BK-'), findsNothing);
        expect(find.text('USR-'), findsNothing);
      }
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

          // Explore
          expect(tester.takeException(), isNull);

          // Favorites
          await tester.tap(find.byKey(const Key('customer-destination-1')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          // Bookings
          await tester.tap(find.byKey(const Key('customer-destination-2')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          // Account
          await tester.tap(find.byKey(const Key('customer-destination-3')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }

    for (final width in [360.0, 390.0, 430.0]) {
      testWidgets(
        'renders all 4 tabs on narrow logical viewport width ${width}dp without overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = Size(width * 2.0, 800 * 2.0);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(size: Size(width, 800)),
              child: const KonfrmCustomerApp(),
            ),
          );
          await tester.pumpAndSettle();

          // Explore
          expect(tester.takeException(), isNull);

          // Favorites
          await tester.tap(find.byKey(const Key('customer-destination-1')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          // Bookings
          await tester.tap(find.byKey(const Key('customer-destination-2')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          // Account
          await tester.tap(find.byKey(const Key('customer-destination-3')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}
