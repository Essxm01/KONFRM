import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:customer_app/app/app.dart';
import 'package:customer_app/features/booking_review/presentation/widgets/konfrm_price_text.dart';
import 'package:customer_app/features/discovery/data/public_property_search_repository.dart';
import 'package:customer_app/features/discovery/presentation/widgets/avatar_candidates.dart';
import 'package:customer_app/features/discovery/presentation/widgets/explore_header.dart';
import 'package:customer_app/features/discovery/presentation/widgets/explore_search_trigger.dart';

Map<String, Object?> _sampleProperty() => {
      'id': 'prop-polish-1',
      'title': 'فيلا تجريبية فاخرة',
      'unitType': 'VILLA',
      'propertyType': 'VILLA',
      'address': 'مراسي، الساحل الشمالي',
      'region': 'الساحل الشمالي',
      'resortName': 'مراسي',
      'bedrooms': 4,
      'bathrooms': 3,
      'maxGuests': 8,
      'basePricePerNight': 12500,
      'currency': 'EGP',
      'images': <String>[],
    };

http.Response _mockResponse(List<Object?> properties) => http.Response(
      jsonEncode({
        'success': true,
        'timestamp': '2026-10-13T00:00:00Z',
        'data': properties,
      }),
      200,
      headers: {'content-type': 'application/json'},
    );

void main() {
  group('Screen 03 Visual Polish — Avatar Candidates Vector Integrity', () {
    testWidgets('renders all four avatar candidate styles without exception', (
      tester,
    ) async {
      for (final style in AvatarCandidateStyle.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: KonfrmAvatarIllustration(
                  style: style,
                  size: 56.0,
                ),
              ),
            ),
          ),
        );
        expect(find.byType(KonfrmAvatarIllustration), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('ExploreHeader respects avatarStyle fallback when unauthenticated', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExploreHeader(
              avatarStyle: AvatarCandidateStyle.branded,
            ),
          ),
        ),
      );
      expect(find.byType(KonfrmAvatarIllustration), findsOneWidget);
    });
  });

  group('Screen 03 Visual Polish — Circular Notification Affordance', () {
    testWidgets('omits notification affordance when showNotification is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExploreHeader(
              showNotification: false,
            ),
          ),
        ),
      );
      expect(find.byKey(const Key('explore-notification-bell')), findsNothing);
    });

    testWidgets('renders circular bordered notification button when showNotification is true', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExploreHeader(
              showNotification: true,
              onNotificationTap: () => tapped = true,
            ),
          ),
        ),
      );
      final bellFinder = find.byKey(const Key('explore-notification-bell'));
      expect(bellFinder, findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(bellFinder);
      expect(renderBox.size.width, greaterThanOrEqualTo(44.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(44.0));

      await tester.tap(bellFinder);
      expect(tapped, isTrue);
    });
  });

  group('Screen 03 Visual Polish — RTL Physical Coordinate Geometry & Layout Truth', () {
    testWidgets('verifies strict RTL physical hierarchy across Header, Search Trigger, Card, and 4-Tab Navigation', (
      tester,
    ) async {
      final repository = PublicPropertySearchRepository(
        baseUrl: 'https://api.example.test',
        client: MockClient((_) async => _mockResponse([_sampleProperty()])),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            publicPropertySearchRepositoryProvider.overrideWithValue(repository),
          ],
          child: const KonfrmCustomerApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Heading must be أماكن الإقامة, NOT نتائج البحث
      expect(find.text('أماكن الإقامة'), findsOneWidget);
      expect(find.text('نتائج البحث'), findsNothing);

      // 2. ExploreHeader RTL physical geometry:
      // Avatar must be on the physical RIGHT
      // Greeting/Subtitle must be immediately to its LEFT
      final avatarFinder = find.byKey(const Key('explore-profile-avatar'));
      final subtitleFinder = find.text('اكتشف وجهتك القادمة');
      expect(avatarFinder, findsOneWidget);
      expect(subtitleFinder, findsOneWidget);

      final avatarDx = tester.getTopLeft(avatarFinder).dx;
      final subtitleDx = tester.getTopLeft(subtitleFinder).dx;
      expect(
        avatarDx,
        greaterThan(subtitleDx),
        reason: 'Profile avatar must be physically on the RIGHT of the subtitle in RTL',
      );

      // 3. ExploreSearchTrigger RTL physical geometry:
      // Search icon on physical RIGHT
      // Destination text in center
      // Filter/Tune circular button on physical LEFT
      final searchIconFinder = find.byIcon(Icons.search_rounded);
      final searchTextFinder = find.text('إلى أين؟');
      final tuneIconFinder = find.byIcon(Icons.tune_rounded);

      expect(searchIconFinder, findsOneWidget);
      expect(searchTextFinder, findsOneWidget);
      expect(tuneIconFinder, findsOneWidget);

      final searchIconDx = tester.getTopLeft(searchIconFinder).dx;
      final searchTextDx = tester.getTopLeft(searchTextFinder).dx;
      final tuneIconDx = tester.getTopLeft(tuneIconFinder).dx;

      expect(
        searchIconDx,
        greaterThan(searchTextDx),
        reason: 'Search icon must be physically to the RIGHT of search text in RTL',
      );
      expect(
        searchTextDx,
        greaterThan(tuneIconDx),
        reason: 'Search text must be physically to the RIGHT of tune/filter button in RTL',
      );

      // 4. Property Card Price RTL physical geometry:
      expect(find.byType(KonfrmPriceText), findsOneWidget);
      final amountFinder = find.text('12,500');
      final currencyFinder = find.text('ج.م');
      final suffixFinder = find.text('/ ليلة');

      expect(amountFinder, findsOneWidget);
      expect(currencyFinder, findsOneWidget);
      expect(suffixFinder, findsOneWidget);

      final amountDx = tester.getTopRight(amountFinder).dx;
      final currencyDx = tester.getTopRight(currencyFinder).dx;
      final suffixDx = tester.getTopRight(suffixFinder).dx;

      expect(
        amountDx,
        greaterThan(currencyDx),
        reason: 'Amount (12,500) must be physically to the right of currency (ج.م) in RTL',
      );
      expect(
        currencyDx,
        greaterThan(suffixDx),
        reason: 'Currency (ج.م) must be physically to the right of suffix (/ ليلة) in RTL',
      );

      // 5. 4-Tab CustomerBottomNavigation RTL physical order:
      // Tab 0 (استكشف) on physical RIGHT
      // Tab 3 (الحساب) on physical LEFT
      final exploreTabFinder = find.text('استكشف');
      final accountTabFinder = find.text('الحساب');
      expect(exploreTabFinder, findsOneWidget);
      expect(accountTabFinder, findsOneWidget);

      final exploreTabDx = tester.getTopLeft(exploreTabFinder).dx;
      final accountTabDx = tester.getTopLeft(accountTabFinder).dx;
      expect(
        exploreTabDx,
        greaterThan(accountTabDx),
        reason: 'Tab 0 (استكشف) must be physically to the RIGHT of Tab 3 (الحساب) in RTL',
      );

      // 6. Search trigger tap opens dependency sheet with 12dp radius Primary CTA
      await tester.tap(find.byType(ExploreSearchTrigger));
      await tester.pumpAndSettle();

      final dismissButtonFinder = find.byKey(const Key('search-sheet-dismiss-button'));
      expect(dismissButtonFinder, findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(dismissButtonFinder);
      final shape = elevatedButton.style?.shape?.resolve({}) as RoundedRectangleBorder?;
      expect(shape, isNotNull);
      expect(
        shape?.borderRadius,
        BorderRadius.circular(12),
        reason: 'Dependency sheet dismiss CTA must use Founder-selected 12dp corner radius candidate',
      );

      // Close sheet
      await tester.tap(dismissButtonFinder);
      await tester.pumpAndSettle();
    });
  });
}
