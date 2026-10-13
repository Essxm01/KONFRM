import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import 'package:customer_app/app/app.dart';
import 'package:customer_app/features/discovery/data/public_property_search_repository.dart';

void main() {
  group('Screen 03 Property Card — Compactness & Unboxed Facts Architecture', () {
    http.Response mockResponse() => http.Response(
      jsonEncode({
        'success': true,
        'timestamp': '2026-10-13T00:00:00Z',
        'data': [
          {
            'id': 'prop-measure-1',
            'title': 'ايمان',
            'unitType': 'شقة',
            'propertyType': 'APARTMENT',
            'address': '',
            'region': 'الساحل الشمالي',
            'resortName': 'الزمردة',
            'bedrooms': 2,
            'bathrooms': 1,
            'maxGuests': 4,
            'basePricePerNight': 2000,
            'currency': 'EGP',
            'images': ['https://images.example.test/chalet1.jpg'],
          }
        ],
      }),
      200,
      headers: {'content-type': 'application/json'},
    );

    testWidgets('proves material card height reduction and single-line facts at 100% font scale', (
      tester,
    ) async {
      final repository = PublicPropertySearchRepository(
        baseUrl: 'https://api.example.test',
        client: MockClient((_) async => mockResponse()),
      );

      // Samsung A56 viewport: 384 x 832 dp (1080x2340 @ 2.8125 DPR)
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.8125;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            publicPropertySearchRepositoryProvider.overrideWithValue(repository),
          ],
          child: const KonfrmCustomerApp(),
        ),
      );
      await tester.pumpAndSettle();

      final cardFinder = find.byType(StructuralContainer).last;
      expect(cardFinder, findsOneWidget);

      final cardSize = tester.getSize(cardFinder);
      final imageFinder = find.byType(AspectRatio);
      final imageSize = tester.getSize(imageFinder);
      final infoSectionHeight = cardSize.height - imageSize.height;

      // Card must be <= 390dp total height (down from 452.18dp BEFORE, a >70dp reduction)
      expect(cardSize.height, lessThanOrEqualTo(390.0));
      // Info section height must be <= 145dp (down from 210.8dp BEFORE, a >65dp reduction)
      expect(infoSectionHeight, lessThanOrEqualTo(145.0));

      // Facts are unboxed: informative unit type 'شقة' is recognized, no generic 'مكان للإقامة'
      expect(find.text('شقة'), findsOneWidget);
      expect(find.text('مكان للإقامة'), findsNothing);
      expect(find.text('2 غرف نوم'), findsOneWidget);
      expect(find.text('1 حمام'), findsOneWidget);
      expect(find.text('4 ضيوف'), findsOneWidget);

      // Outline icons present
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.bed_outlined), findsOneWidget);
      expect(find.byIcon(Icons.bathtub_outlined), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);

      // Favorite touch target meets 48dp requirement
      final heartFinder = find.byKey(const Key('property-favorite-heart-prop-measure-1'));
      expect(heartFinder, findsOneWidget);
      final heartSize = tester.getSize(heartFinder);
      expect(heartSize.width, greaterThanOrEqualTo(48.0));
      expect(heartSize.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('handles 130% and 200% dynamic font scaling without RenderFlex overflow', (
      tester,
    ) async {
      final repository = PublicPropertySearchRepository(
        baseUrl: 'https://api.example.test',
        client: MockClient((_) async => mockResponse()),
      );

      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.8125;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 130% text scale
      tester.platformDispatcher.textScaleFactorTestValue = 1.30;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            publicPropertySearchRepositoryProvider.overrideWithValue(repository),
          ],
          child: const KonfrmCustomerApp(),
        ),
      );
      await tester.pumpAndSettle();

      var cardFinder = find.byType(StructuralContainer).last;
      var cardSize = tester.getSize(cardFinder);
      expect(cardSize.height, lessThanOrEqualTo(420.0));
      expect(tester.takeException(), isNull);

      // 200% text scale
      tester.platformDispatcher.textScaleFactorTestValue = 2.00;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            publicPropertySearchRepositoryProvider.overrideWithValue(repository),
          ],
          child: const KonfrmCustomerApp(),
        ),
      );
      await tester.pumpAndSettle();

      cardFinder = find.byType(StructuralContainer).last;
      cardSize = tester.getSize(cardFinder);
      expect(cardSize.height, lessThanOrEqualTo(580.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('omits unit type when uninformative/unknown without showing generic fallback', (
      tester,
    ) async {
      final repository = PublicPropertySearchRepository(
        baseUrl: 'https://api.example.test',
        client: MockClient((_) async => http.Response(
          jsonEncode({
            'success': true,
            'timestamp': '2026-10-13T00:00:00Z',
            'data': [
              {
                'id': 'prop-unknown-type',
                'title': 'مكان مجهول النوع',
                'unitType': 'UNKNOWN_TYPE_123',
                'propertyType': null,
                'address': 'الساحل الشمالي',
                'bedrooms': 3,
                'bathrooms': 2,
                'maxGuests': 6,
                'basePricePerNight': 3500,
                'currency': 'EGP',
                'images': ['https://images.example.test/chalet2.jpg'],
              }
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        )),
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

      expect(find.text('مكان للإقامة'), findsNothing);
      expect(find.byIcon(Icons.home_outlined), findsNothing);
      expect(find.text('3 غرف نوم'), findsOneWidget);
      expect(find.text('2 حمام'), findsOneWidget);
      expect(find.text('6 ضيوف'), findsOneWidget);
    });

    for (final width in [360.0, 390.0, 430.0]) {
      testWidgets('fits viewport width ${width}dp without horizontal overflow', (
        tester,
      ) async {
        final repository = PublicPropertySearchRepository(
          baseUrl: 'https://api.example.test',
          client: MockClient((_) async => mockResponse()),
        );

        tester.view.physicalSize = Size(width * 2.8125, 800 * 2.8125);
        tester.view.devicePixelRatio = 2.8125;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              publicPropertySearchRepositoryProvider.overrideWithValue(repository),
            ],
            child: const KonfrmCustomerApp(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('ايمان'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
