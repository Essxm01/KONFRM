import 'dart:async';
import 'dart:convert';

import 'package:customer_app/app/app.dart';
import 'package:customer_app/features/discovery/data/public_property_search_repository.dart';
import 'package:customer_app/features/discovery/presentation/widgets/explore_header.dart';
import 'package:customer_app/features/discovery/presentation/widgets/explore_search_trigger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, Object?> _property({List<Object?> images = const []}) => {
  'id': 'public-1',
  'title': 'شاليه للاختبار',
  'unitType': 'CHALET',
  'propertyType': 'CHALET',
  'address': 'الساحل الشمالي',
  'region': 'مطروح',
  'resortName': null,
  'bedrooms': 2,
  'bathrooms': 1,
  'maxGuests': 4,
  'basePricePerNight': 2800,
  'currency': 'EGP',
  'images': images,
};

http.Response _response(List<Object?> properties, {int status = 200}) =>
    http.Response(
      jsonEncode({
        'success': true,
        'timestamp': '2026-10-09T00:00:00Z',
        'data': properties,
      }),
      status,
      headers: {'content-type': 'application/json'},
    );

Widget _app(PublicPropertySearchRepository repository) => ProviderScope(
  overrides: [
    publicPropertySearchRepositoryProvider.overrideWithValue(repository),
  ],
  child: const KonfrmCustomerApp(),
);

void main() {
  testWidgets('renders real public search results without fake actions', (
    tester,
  ) async {
    late Uri requestUri;
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        requestUri = request.url;
        return _response([_property()]);
      }),
    );
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('شاليه للاختبار'), findsOneWidget);
    expect(find.textContaining('2,800 ج.م / ليلة'), findsOneWidget);
    expect(find.text('مطروح، الساحل الشمالي'), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.text('احجز'), findsNothing);
    expect(find.text('أضف للمفضلة'), findsNothing);
    expect(requestUri.path, '/api/v1/customer/properties/search');
  });

  testWidgets('exposes the property content as readable semantics', (
    tester,
  ) async {
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient((_) async => _response([_property()])),
    );
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    expect(find.text('أهلًا بك'), findsOneWidget);
    expect(find.text('اكتشف وجهتك القادمة'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'البحث عن أماكن الإقامة: إلى أين؟، اختيار منطقة أو أكثر',
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('خيارات التصفية والتعديل'), findsOneWidget);
    expect(find.bySemanticsLabel('شاليه للاختبار'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('keeps a successful empty result distinct from failure', (
    tester,
  ) async {
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient((_) async => _response([])),
    );
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    expect(find.text('لا توجد نتائج حالياً'), findsOneWidget);
    expect(find.text('تعذر الاتصال'), findsNothing);
  });

  testWidgets('uses the placeholder after an HTTPS image fetch fails', (
    tester,
  ) async {
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient(
        (_) async => _response([
          _property(images: ['https://images.example.test/unavailable.jpg']),
        ]),
      ),
    );
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    expect(find.text('شاليه للاختبار'), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects an invalid image URL instead of rendering a card', (
    tester,
  ) async {
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient(
        (_) async => _response([
          _property(images: ['http://images.example.test/not-allowed.jpg']),
        ]),
      ),
    );
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    expect(find.text('تعذر قراءة نتائج البحث'), findsOneWidget);
    expect(find.text('شاليه للاختبار'), findsNothing);
    expect(find.byIcon(Icons.image_outlined), findsNothing);
  });

  testWidgets('announces initial loading while the public request is pending', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient((_) => pending.future),
    );
    await tester.pumpWidget(_app(repository));
    await tester.pump();
    expect(find.text('جارٍ البحث'), findsOneWidget);
    expect(
      find.text('يتم تحميل النتائج من خدمة البحث العامة.'),
      findsOneWidget,
    );
    pending.complete(_response([]));
    await tester.pumpAndSettle();
    expect(find.text('لا توجد نتائج حالياً'), findsOneWidget);
  });

  testWidgets(
    'shows an honest endpoint failure and retries only after action',
    (tester) async {
      var requests = 0;
      final repository = PublicPropertySearchRepository(
        baseUrl: 'https://api.example.test',
        client: MockClient((_) async {
          requests++;
          return http.Response('', 503);
        }),
      );
      await tester.pumpWidget(_app(repository));
      await tester.pumpAndSettle();
      expect(find.text('خدمة البحث غير متاحة حالياً'), findsOneWidget);
      expect(requests, 1);
      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pumpAndSettle();
      expect(requests, 2);
      expect(find.text('لا توجد نتائج حالياً'), findsNothing);
    },
  );

  testWidgets(
    'pill search trigger opens Screen 04 bottom sheet and preserves tab state',
    (tester) async {
      final repository = PublicPropertySearchRepository(
        baseUrl: 'https://api.example.test',
        client: MockClient((_) async => _response([])),
      );
      await tester.pumpWidget(_app(repository));
      await tester.pumpAndSettle();

      // Verify search trigger is rendered with default state
      expect(find.byKey(const Key('explore-search-trigger')), findsOneWidget);
      expect(find.text('إلى أين؟'), findsOneWidget);
      expect(find.text('اختيار منطقة أو أكثر'), findsOneWidget);
      expect(find.text('اختار المنطقة'), findsNothing);

      // Tap search trigger opens Screen 04 bottom sheet
      await tester.tap(find.byKey(const Key('explore-search-trigger')));
      await tester.pumpAndSettle();
      expect(find.text('البحث وتحديد الوجهة'), findsOneWidget);
      expect(
        find.byKey(const Key('search-sheet-dismiss-button')),
        findsOneWidget,
      );

      // Dismiss bottom sheet
      await tester.tap(find.byKey(const Key('search-sheet-dismiss-button')));
      await tester.pumpAndSettle();
      expect(find.text('البحث وتحديد الوجهة'), findsNothing);

      // Preserve tab state across navigation
      await tester.tap(find.byKey(const Key('customer-destination-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('customer-destination-0')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('explore-search-trigger')), findsOneWidget);
      expect(find.text('إلى أين؟'), findsOneWidget);
    },
  );

  group('ExploreSearchTrigger state behavior', () {
    testWidgets('renders default empty state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ExploreSearchTrigger(),
            ),
          ),
        ),
      );
      expect(find.text('إلى أين؟'), findsOneWidget);
      expect(find.text('اختيار منطقة أو أكثر'), findsOneWidget);
      expect(find.text('اختار المنطقة'), findsNothing);
    });

    testWidgets('renders single selected region', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ExploreSearchTrigger(
                selectedRegions: ['مراسي'],
              ),
            ),
          ),
        ),
      );
      expect(find.text('مراسي'), findsOneWidget);
      expect(find.textContaining('انقر للتعديل'), findsOneWidget);
    });

    testWidgets('renders two selected regions clearly separated', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ExploreSearchTrigger(
                selectedRegions: ['مراسي', 'سيدي عبد الرحمن'],
              ),
            ),
          ),
        ),
      );
      expect(find.text('مراسي، سيدي عبد الرحمن'), findsOneWidget);
    });

    testWidgets('renders more than two regions as first + count summary', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ExploreSearchTrigger(
                selectedRegions: ['مراسي', 'سيدي عبد الرحمن', 'رأس الحكمة'],
              ),
            ),
          ),
        ),
      );
      expect(find.text('مراسي + 2 مناطق'), findsOneWidget);
    });

    testWidgets(
      'satisfies RTL visual ordering (search icon right, tune icon left)',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ExploreSearchTrigger(),
              ),
            ),
          ),
        );
        final searchPos = tester.getTopRight(find.byIcon(Icons.search_rounded));
        final tunePos = tester.getTopLeft(find.byIcon(Icons.tune_rounded));
        // In RTL: search icon is on the RIGHT (higher X), tune icon is on the LEFT (lower X)
        expect(searchPos.dx, greaterThan(tunePos.dx));
      },
    );
  });

  group('ExploreHeader state behavior', () {
    testWidgets(
      'renders default guest state with generic avatar and neutral discovery copy',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ExploreHeader(),
              ),
            ),
          ),
        );
        expect(find.text('أهلًا بك'), findsOneWidget);
        expect(find.text('اكتشف وجهتك القادمة'), findsOneWidget);
        expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
        expect(find.byKey(const Key('explore-notification-bell')), findsNothing);
      },
    );

    testWidgets(
      'renders authenticated state with user initials and contextual greeting',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ExploreHeader(
                  userName: 'عمر شريف',
                ),
              ),
            ),
          ),
        );
        expect(find.text('عش'), findsOneWidget);
        expect(find.textContaining('عمر شريف'), findsOneWidget);
        expect(find.text('اكتشف وجهتك القادمة'), findsOneWidget);
      },
    );

    testWidgets(
      'renders custom greeting override and location subtitle',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ExploreHeader(
                  greeting: 'مرحبًا بك في كونفرم',
                  location: 'الساحل الشمالي، مصر',
                ),
              ),
            ),
          ),
        );
        expect(find.text('مرحبًا بك في كونفرم'), findsOneWidget);
        expect(find.text('الساحل الشمالي، مصر'), findsOneWidget);
      },
    );

    testWidgets(
      'satisfies RTL visual ordering (avatar on the RIGHT, notification on the LEFT)',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ExploreHeader(
                  showNotification: true,
                ),
              ),
            ),
          ),
        );
        final avatarPos = tester.getTopRight(find.byType(Material).at(1));
        final bellPos = tester.getTopLeft(find.byKey(const Key('explore-notification-bell')));
        // In RTL: avatar is on the RIGHT (higher X), bell icon is on the LEFT (lower X)
        expect(avatarPos.dx, greaterThan(bellPos.dx));
      },
    );

    testWidgets('tapping avatar invokes onProfileTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ExploreHeader(
                onProfileTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('explore-profile-avatar')));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets(
      'tapping notification bell invokes onNotificationTap callback',
      (tester) async {
        var notified = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ExploreHeader(
                  showNotification: true,
                  onNotificationTap: () => notified = true,
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(const Key('explore-notification-bell')));
        await tester.pumpAndSettle();
        expect(notified, isTrue);
      },
    );

    testWidgets('avatar container satisfies >= 44dp touch target', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ExploreHeader(),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(InkWell).first);
      expect(size.width, greaterThanOrEqualTo(44.0));
      expect(size.height, greaterThanOrEqualTo(44.0));
    });
  });

  for (final width in [360.0, 390.0, 430.0]) {
    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets('discovery layout fits ${width}dp at ${scale * 100}% text', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width * 2, 800 * 2);
        tester.view.devicePixelRatio = 2;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final repository = PublicPropertySearchRepository(
          baseUrl: 'https://api.example.test',
          client: MockClient((_) async => _response([_property()])),
        );
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(
              size: Size(width, 800),
              textScaler: TextScaler.linear(scale),
            ),
            child: _app(repository),
          ),
        );
        await tester.pumpAndSettle();
        final layoutError = tester.takeException();
        expect(layoutError, isNull, reason: '$layoutError');
        await tester.drag(
          find.byKey(const Key('explore-scroll-view')),
          const Offset(0, -1200),
        );
        await tester.pumpAndSettle();
        expect(find.text('شاليه للاختبار'), findsOneWidget);
      });
    }
  }
}
