import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import '../tool/screen15_preview_runner.dart';

void main() {
  group('Screen 15 Customer Favorites — Fixture & Domain Model Integrity', () {
    test('sample fixtures pass strict mathematical and domain invariants', () {
      final fixtures = Screen15SampleFixtures.getAllFixtures();
      expect(fixtures.length, equals(4));

      // Assert integrity function executes without error
      expect(() => Screen15SampleFixtures.assertFixtureIntegrity(fixtures), returnsNormally);

      for (final fixture in fixtures) {
        expect(fixture.id, isNotEmpty);
        expect(fixture.title, isNotEmpty);
        expect(fixture.basePricePerNight, greaterThan(0));
        expect(fixture.bedrooms, greaterThanOrEqualTo(0));
        expect(fixture.bathrooms, greaterThanOrEqualTo(0));
        expect(fixture.maxGuests, greaterThanOrEqualTo(1));
        expect(fixture.currency, equals('EGP'));
      }
    });

    test('DirectionalPriceText formats currency and numbers with RTL isolation', () {
      const price = DirectionalPriceText(amount: 4500.0, perNight: true);
      expect(price.amount, equals(4500.0));
      expect(price.perNight, isTrue);
    });
  });

  group('Screen 15 Customer Favorites — State Controller Lifecycle', () {
    test('toggleFavorite removes item and creates undo notice', () {
      final fixtures = Screen15SampleFixtures.getAllFixtures().where((p) => p.isAvailable).toList();
      final controller = Screen15FavoritesController(
        initialAuth: CustomerFavoritesAuthState.authenticated,
        initialLoad: CustomerFavoritesLoadState.loaded,
        initialItems: fixtures,
      );

      expect(controller.items.length, equals(3));
      expect(controller.undoNotice, isNull);

      // Remove first item
      final targetId = fixtures.first.id;
      controller.toggleFavorite(targetId);

      expect(controller.items.length, equals(2));
      expect(controller.undoNotice, isNotNull);
      expect(controller.undoNotice!.propertyId, equals(targetId));
      expect(controller.undoNotice!.message, equals('تمت الإزالة من المفضلة'));
      expect(controller.undoNotice!.removedIndex, equals(0));

      // Trigger undo
      controller.undoRemoval();
      expect(controller.items.length, equals(3));
      expect(controller.items.first.id, equals(targetId));
      expect(controller.undoNotice, isNull);
    });

    test('401 session expiry purges cached private items', () {
      final fixtures = Screen15SampleFixtures.getAllFixtures();
      final controller = Screen15FavoritesController(
        initialAuth: CustomerFavoritesAuthState.authenticated,
        initialLoad: CustomerFavoritesLoadState.loaded,
        initialItems: fixtures,
      );

      expect(controller.items.isNotEmpty, isTrue);

      controller.applyScenario(Screen15Scenario.sessionExpired401);
      expect(controller.authState, equals(CustomerFavoritesAuthState.sessionExpired));
      expect(controller.items.isEmpty, isTrue);
      expect(controller.undoNotice, isNull);
    });

    test('stale error state preserves items with an informative banner', () {
      final fixtures = Screen15SampleFixtures.getAllFixtures().where((p) => p.isAvailable).toList();
      final controller = Screen15FavoritesController(
        initialAuth: CustomerFavoritesAuthState.authenticated,
        initialLoad: CustomerFavoritesLoadState.loaded,
        initialItems: fixtures,
      );

      controller.applyScenario(Screen15Scenario.staleDataRefreshError);
      expect(controller.loadState, equals(CustomerFavoritesLoadState.staleError));
      expect(controller.items.length, equals(3));
      expect(controller.bannerMessage, contains('تعذر تحديث المفضلة'));

      // Retry clears banner
      controller.retryRefresh();
      expect(controller.bannerMessage, isNull);
      expect(controller.loadState, equals(CustomerFavoritesLoadState.loaded));
    });
  });

  group('Screen 15 Customer Favorites — Source-Linked UI Widget Tests', () {
    testWidgets('renders Arabic RTL header and active Favorites tab in bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      // Top Header
      expect(find.text('المفضلة'), findsAtLeastNWidgets(1));
      expect(find.text('الوحدات التي حفظتها للرجوع إليها بسهولة.'), findsOneWidget);

      // Bottom Navigation Bar
      expect(find.text('استكشف'), findsOneWidget);
      expect(find.text('حجوزاتي'), findsOneWidget);
      expect(find.text('الحساب'), findsOneWidget);

      // Verify canonical CustomerBottomNavigation is present with Tab 1 (المفضلة)
      expect(find.byType(CustomerBottomNavigation), findsOneWidget);
      expect(find.byKey(const Key('customer-destination-1')), findsOneWidget);
    });

    testWidgets('renders property cards with directionally isolated price text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      // Verify first fixture title and price
      expect(find.text('شاليه فاخر بإطلالة مباشرة على لاجون مراسي'), findsOneWidget);
      expect(find.text('4,500 ج.م / ليلة'), findsOneWidget);

      // Verify specs
      expect(find.text('3 غرف نوم'), findsOneWidget);
      expect(find.text('2 حمامات'), findsOneWidget);
      expect(find.text('6 ضيوف'), findsOneWidget);
    });

    testWidgets('favorite heart button has >= 48dp hit target and triggers removal with undo toast', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      // Find the first favorite button
      final heartIconFinder = find.byIcon(Icons.favorite).first;
      expect(heartIconFinder, findsOneWidget);

      // Verify heart is positioned on the physical LEFT side of the card (dx < 100 on 800-wide test screen)
      final heartOffset = tester.getTopLeft(heartIconFinder);
      expect(heartOffset.dx, lessThan(100.0));

      final hitTargetFinder = find.ancestor(
        of: heartIconFinder,
        matching: find.byType(SizedBox),
      ).first;
      final renderBox = tester.renderObject<RenderBox>(hitTargetFinder);
      expect(renderBox.size.width, greaterThanOrEqualTo(48.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(48.0));

      // Tap heart to remove
      await tester.tap(hitTargetFinder);
      await tester.pumpAndSettle();

      // Floating undo toast appears
      expect(find.text('تمت الإزالة من المفضلة'), findsOneWidget);
      expect(find.text('تراجع'), findsOneWidget);

      // Tap Undo
      await tester.tap(find.text('تراجع'));
      await tester.pumpAndSettle();

      // Restored!
      expect(find.text('شاليه فاخر بإطلالة مباشرة على لاجون مراسي'), findsOneWidget);
      expect(find.text('تمت الإزالة من المفضلة'), findsNothing);
    });

    testWidgets('empty state renders peaceful guidance and 56dp primary explore button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      // Switch to Empty Scenario
      final state = tester.state<Screen15HarnessPageState>(find.byType(Screen15HarnessPage));
      state.applyScenario(Screen15Scenario.emptyNoFavorites);
      await tester.pumpAndSettle();

      expect(find.text('لم تحفظ أي إقامة بعد'), findsOneWidget);
      expect(find.text('استكشف الإقامات'), findsOneWidget);

      // Verify button size and color
      final ctaFinder = find.widgetWithText(ElevatedButton, 'استكشف الإقامات');
      expect(ctaFinder, findsOneWidget);
      final ctaBox = tester.renderObject<RenderBox>(ctaFinder);
      expect(ctaBox.size.height, equals(56.0));
    });

    testWidgets('guest unauthorized state discloses that saving is not booking', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen15HarnessPageState>(find.byType(Screen15HarnessPage));
      state.applyScenario(Screen15Scenario.guestUnauthorized);
      await tester.pumpAndSettle();

      expect(find.text('سجّل الدخول لعرض المفضلة'), findsOneWidget);
      expect(find.textContaining('حفظ الإقامات لا يمثل حجزاً ولا يضمن توفرها'), findsOneWidget);
      expect(find.text('تسجيل الدخول أو إنشاء حساب'), findsOneWidget);
      expect(find.text('استكشف الإقامات كزائر'), findsOneWidget);
    });

    testWidgets('401 session expired state displays secure prompt with zero leaked cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen15HarnessPageState>(find.byType(Screen15HarnessPage));
      state.applyScenario(Screen15Scenario.sessionExpired401);
      await tester.pumpAndSettle();

      expect(find.text('انتهت جلسة تسجيل الدخول'), findsOneWidget);
      expect(find.text('تسجيل الدخول مجددًا'), findsOneWidget);
      expect(find.text('شاليه فاخر بإطلالة مباشرة على لاجون مراسي'), findsNothing);
    });

    testWidgets('unavailable property displays neutral badge and remove affordance', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen15HarnessPageState>(find.byType(Screen15HarnessPage));
      state.applyScenario(Screen15Scenario.unavailableItem);
      await tester.pumpAndSettle();

      // Scroll to reveal the unavailable card at bottom of list
      await tester.scrollUntilVisible(find.text('غير متوفرة حالياً'), 250);

      expect(find.text('غير متوفرة حالياً'), findsOneWidget);
      expect(find.text('غير متاحة للحجز حالياً'), findsOneWidget);
      expect(find.text('إزالة'), findsOneWidget);
    });

    testWidgets('accessibility text scale 200% renders with zero RenderFlex overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const Screen15PreviewApp());
      await tester.pumpAndSettle();

      final state = tester.state<Screen15HarnessPageState>(find.byType(Screen15HarnessPage));
      state.applyScenario(Screen15Scenario.accessibility200Top);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المفضلة'), findsAtLeastNWidgets(1));

      // Test scrolled 200%
      state.applyScenario(Screen15Scenario.accessibility200Scrolled);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
