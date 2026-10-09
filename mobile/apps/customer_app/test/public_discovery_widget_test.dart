import 'dart:async';
import 'dart:convert';

import 'package:customer_app/app/app.dart';
import 'package:customer_app/features/discovery/data/public_property_search_repository.dart';
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
    expect(find.bySemanticsLabel('الوجهة أو اسم العقار'), findsOneWidget);
    expect(find.bySemanticsLabel('شاليه للاختبار'), findsOneWidget);
    expect(find.bySemanticsLabel('ابحث عن أماكن الإقامة'), findsOneWidget);
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

  testWidgets('search input submits destination and preserves tab state', (
    tester,
  ) async {
    final requestQueries = <Map<String, String>>[];
    final repository = PublicPropertySearchRepository(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        requestQueries.add(request.url.queryParameters);
        return _response([]);
      }),
    );
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'العين السخنة');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(requestQueries.last['destination'], 'العين السخنة');

    final guestsField = find.descendant(
      of: find.byKey(const Key('discovery-guests')),
      matching: find.byType(TextField),
    );
    await tester.enterText(guestsField, '5');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(requestQueries.last['destination'], 'العين السخنة');
    expect(requestQueries.last['guests'], '5');

    await tester.tap(find.byKey(const Key('customer-destination-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('customer-destination-0')));
    await tester.pumpAndSettle();
    expect(find.byType(TextField).first, findsOneWidget);
    expect(
      (find.byType(TextField).first.evaluate().single.widget as TextField)
          .controller!
          .text,
      'العين السخنة',
    );
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
