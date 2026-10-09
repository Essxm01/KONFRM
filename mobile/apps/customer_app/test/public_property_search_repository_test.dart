import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:customer_app/features/discovery/data/public_property.dart';
import 'package:customer_app/features/discovery/data/public_property_search_repository.dart';
import 'package:customer_app/features/discovery/application/public_discovery_controller.dart';

void main() {
  const baseUrl = 'https://api.example.test';

  Map<String, Object?> propertyJson({Map<String, Object?> extra = const {}}) =>
      {
        'id': 'property-1',
        'title': 'بيت على البحر',
        'unitType': 'CHALET',
        'propertyType': 'CHALET',
        'address': 'الساحل الشمالي',
        'region': 'مطروح',
        'resortName': 'قرية الساحل',
        'bedrooms': 2,
        'bathrooms': 1,
        'maxGuests': 4,
        'basePricePerNight': 2500,
        'currency': 'EGP',
        'images': ['https://images.example.test/property.jpg'],
        ...extra,
      };

  http.Response response(Object body, {int status = 200}) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );

  test('serializes the public filters and excludes ALL', () async {
    late Uri requestedUri;
    final repository = PublicPropertySearchRepository(
      baseUrl: baseUrl,
      client: MockClient((request) async {
        requestedUri = request.url;
        expect(request.method, 'GET');
        expect(request.headers['Accept'], 'application/json');
        expect(request.headers.containsKey('Authorization'), isFalse);
        expect(request.followRedirects, isFalse);
        return response({'success': true, 'timestamp': 'now', 'data': []});
      }),
    );

    await repository.search(
      const PublicPropertySearchFilters(
        destination: '  الساحل الشمالي ',
        unitType: 'chalet',
        guests: 4,
        maxPrice: 3000,
      ),
    );
    expect(requestedUri.path, '/api/v1/customer/properties/search');
    expect(requestedUri.queryParameters, {
      'destination': 'الساحل الشمالي',
      'unitType': 'CHALET',
      'guests': '4',
      'maxPrice': '3000.0',
    });
    expect(
      const PublicPropertySearchFilters(unitType: 'ALL').toQueryParameters(),
      isEmpty,
    );
  });

  test('parses public fields and discards unknown private fields', () async {
    final repository = PublicPropertySearchRepository(
      baseUrl: baseUrl,
      client: MockClient(
        (_) async => response({
          'success': true,
          'timestamp': 'now',
          'data': [
            propertyJson(
              extra: {
                'ownerId': 'must-not-be-retained',
                'verificationStatus': 'PRIVATE',
              },
            ),
          ],
        }),
      ),
    );
    final result = await repository.search(const PublicPropertySearchFilters());
    expect(result, hasLength(1));
    final PublicProperty property = result.single;
    expect(property.title, 'بيت على البحر');
    expect(property.basePricePerNight, 2500);
    expect(property.currency, 'EGP');
    expect(property.images.single.scheme, 'https');
  });

  test('valid empty response stays empty', () async {
    final repository = PublicPropertySearchRepository(
      baseUrl: baseUrl,
      client: MockClient(
        (_) async =>
            response({'success': true, 'timestamp': 'now', 'data': []}),
      ),
    );
    expect(
      await repository.search(const PublicPropertySearchFilters()),
      isEmpty,
    );
  });

  test('rejects invalid public DTOs and image URLs', () async {
    for (final invalid in [
      propertyJson()..remove('title'),
      propertyJson()..['currency'] = 'USD',
      propertyJson()..['basePricePerNight'] = -1,
      propertyJson()..['images'] = 'unexpected',
      propertyJson()..['images'] = [42],
      propertyJson()..['images'] = ['http://images.example.test/x.jpg'],
    ]) {
      final repository = PublicPropertySearchRepository(
        baseUrl: baseUrl,
        client: MockClient(
          (_) async => response({
            'success': true,
            'timestamp': 'now',
            'data': [invalid],
          }),
        ),
      );
      await expectLater(
        repository.search(const PublicPropertySearchFilters()),
        throwsA(
          isA<PublicSearchException>().having(
            (error) => error.kind,
            'kind',
            PublicSearchFailureKind.invalidResponse,
          ),
        ),
      );
    }
  });

  test('maps HTTP and response failures without returning fake data', () async {
    for (final (status, expected) in [
      (401, PublicSearchFailureKind.unauthorized),
      (422, PublicSearchFailureKind.requestRejected),
      (503, PublicSearchFailureKind.server),
    ]) {
      final repository = PublicPropertySearchRepository(
        baseUrl: baseUrl,
        client: MockClient((_) async => http.Response('', status)),
      );
      await expectLater(
        repository.search(const PublicPropertySearchFilters()),
        throwsA(
          isA<PublicSearchException>().having(
            (error) => error.kind,
            'kind',
            expected,
          ),
        ),
      );
    }
  });

  test('maps connection failures and malformed JSON', () async {
    final connectionFailure = PublicPropertySearchRepository(
      baseUrl: baseUrl,
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    await expectLater(
      connectionFailure.search(const PublicPropertySearchFilters()),
      throwsA(
        isA<PublicSearchException>().having(
          (error) => error.kind,
          'kind',
          PublicSearchFailureKind.network,
        ),
      ),
    );

    final malformed = PublicPropertySearchRepository(
      baseUrl: baseUrl,
      client: MockClient((_) async => http.Response('<not-json', 200)),
    );
    await expectLater(
      malformed.search(const PublicPropertySearchFilters()),
      throwsA(
        isA<PublicSearchException>().having(
          (error) => error.kind,
          'kind',
          PublicSearchFailureKind.invalidResponse,
        ),
      ),
    );
  });

  test('times out without manufacturing a result', () async {
    final pending = Completer<http.Response>();
    final repository = PublicPropertySearchRepository(
      baseUrl: baseUrl,
      client: MockClient((_) => pending.future),
      timeout: const Duration(milliseconds: 1),
    );
    await expectLater(
      repository.search(const PublicPropertySearchFilters()),
      throwsA(
        isA<PublicSearchException>().having(
          (error) => error.kind,
          'kind',
          PublicSearchFailureKind.timeout,
        ),
      ),
    );
    pending.complete(
      response({'success': true, 'timestamp': 'late', 'data': []}),
    );
  });

  test(
    'a late stale response cannot overwrite a newer filter result',
    () async {
      final firstResponse = Completer<http.Response>();
      var requestNumber = 0;
      final repository = PublicPropertySearchRepository(
        baseUrl: baseUrl,
        client: MockClient((_) {
          requestNumber++;
          if (requestNumber == 1) return firstResponse.future;
          return Future.value(
            response({
              'success': true,
              'timestamp': 'new',
              'data': [propertyJson()..['title'] = 'نتيجة أحدث'],
            }),
          );
        }),
      );
      final controller = PublicDiscoveryController(repository);
      final olderRequest = controller.load(
        const PublicPropertySearchFilters(destination: 'قديم'),
      );
      final newerRequest = controller.load(
        const PublicPropertySearchFilters(destination: 'جديد'),
      );
      await newerRequest;
      expect(controller.state.properties.single.title, 'نتيجة أحدث');
      firstResponse.complete(
        response({
          'success': true,
          'timestamp': 'old',
          'data': [propertyJson()..['title'] = 'نتيجة أقدم'],
        }),
      );
      await olderRequest;
      expect(controller.state.properties.single.title, 'نتيجة أحدث');
      expect(controller.state.filters.destination, 'جديد');
      controller.dispose();
    },
  );

  test('requires explicit valid API origin configuration', () async {
    for (final invalidOrigin in [
      '',
      'http://api.example.test',
      'https://api.example.test/path',
    ]) {
      final repository = PublicPropertySearchRepository(
        baseUrl: invalidOrigin,
        client: MockClient((_) async => fail('must not issue request')),
      );
      await expectLater(
        repository.search(const PublicPropertySearchFilters()),
        throwsA(
          isA<PublicSearchException>().having(
            (error) => error.kind,
            'kind',
            PublicSearchFailureKind.configuration,
          ),
        ),
      );
    }
  });
}
