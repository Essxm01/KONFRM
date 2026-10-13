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

  group('Screen 03 Visual Polish — Feed Heading & Price Hierarchy Truth', () {
    testWidgets('displays أماكن الإقامة as default feed heading and verifies KonfrmPriceText RTL physical order', (
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

      // Heading must be أماكن الإقامة, NOT نتائج البحث
      expect(find.text('أماكن الإقامة'), findsOneWidget);
      expect(find.text('نتائج البحث'), findsNothing);

      // Card must render KonfrmPriceText
      expect(find.byType(KonfrmPriceText), findsOneWidget);
      final amountFinder = find.text('12,500');
      final currencyFinder = find.text('ج.م');
      final suffixFinder = find.text('/ ليلة');

      expect(amountFinder, findsOneWidget);
      expect(currencyFinder, findsOneWidget);
      expect(suffixFinder, findsOneWidget);

      // In physical RTL on screen:
      // Amount (12,500) is on the physical RIGHT
      // Currency (ج.م) is to its LEFT
      // Suffix (/ ليلة) is to the LEFT of currency
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
    });
  });
}
