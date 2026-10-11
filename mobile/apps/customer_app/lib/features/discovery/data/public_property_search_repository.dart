import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'public_property.dart';

enum PublicSearchFailureKind {
  configuration,
  network,
  timeout,
  server,
  unauthorized,
  requestRejected,
  invalidResponse,
  invalidFilters,
}

class PublicSearchException implements Exception {
  const PublicSearchException(this.kind);

  final PublicSearchFailureKind kind;
}

class PublicPropertySearchFilters {
  const PublicPropertySearchFilters({
    this.destination = '',
    this.unitType = '',
    this.guests,
    this.maxPrice,
  });

  final String destination;
  final String unitType;
  final int? guests;
  final double? maxPrice;

  Map<String, String> toQueryParameters() {
    if (guests != null && guests! < 1) {
      throw const PublicSearchException(PublicSearchFailureKind.invalidFilters);
    }
    if (maxPrice != null && (!maxPrice!.isFinite || maxPrice! <= 0)) {
      throw const PublicSearchException(PublicSearchFailureKind.invalidFilters);
    }
    final query = <String, String>{};
    final destinationValue = destination.trim();
    if (destinationValue.isNotEmpty) query['destination'] = destinationValue;
    final unitTypeValue = unitType.trim().toUpperCase();
    if (unitTypeValue.isNotEmpty && unitTypeValue != 'ALL') {
      query['unitType'] = unitTypeValue;
    }
    if (guests != null) query['guests'] = '${guests!}';
    if (maxPrice != null) {
      query['maxPrice'] = maxPrice!.toString();
    }
    return query;
  }
}

final publicApiBaseUrlProvider = Provider<String>((ref) => '');

final publicHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final publicPropertySearchRepositoryProvider =
    Provider<PublicPropertySearchRepository>((ref) {
      return PublicPropertySearchRepository(
        baseUrl: ref.watch(publicApiBaseUrlProvider),
        client: ref.watch(publicHttpClientProvider),
      );
    });

class PublicPropertySearchRepository {
  PublicPropertySearchRepository({
    required this.baseUrl,
    required this.client,
    this.timeout = const Duration(seconds: 12),
  });

  final String baseUrl;
  final http.Client client;
  final Duration timeout;

  Future<List<PublicProperty>> search(
    PublicPropertySearchFilters filters,
  ) async {
    final origin = Uri.tryParse(baseUrl.trim());
    if (origin == null ||
        origin.scheme != 'https' ||
        origin.host.isEmpty ||
        origin.userInfo.isNotEmpty ||
        origin.hasQuery ||
        origin.hasFragment ||
        (origin.path.isNotEmpty && origin.path != '/')) {
      throw const PublicSearchException(PublicSearchFailureKind.configuration);
    }

    final queryParameters = filters.toQueryParameters();
    final uri = origin.replace(
      path: '/api/v1/customer/properties/search',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final request = http.Request('GET', uri)
      ..headers['Accept'] = 'application/json'
      ..followRedirects = false;

    late final http.Response response;
    try {
      response = await _sendAndRead(request).timeout(timeout);
    } on TimeoutException {
      throw const PublicSearchException(PublicSearchFailureKind.timeout);
    } on http.ClientException {
      throw const PublicSearchException(PublicSearchFailureKind.network);
    } on FormatException {
      throw const PublicSearchException(
        PublicSearchFailureKind.invalidResponse,
      );
    } catch (_) {
      throw const PublicSearchException(PublicSearchFailureKind.network);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const PublicSearchException(PublicSearchFailureKind.unauthorized);
    }
    if (response.statusCode >= 500) {
      throw const PublicSearchException(PublicSearchFailureKind.server);
    }
    if (response.statusCode != 200) {
      throw const PublicSearchException(
        PublicSearchFailureKind.requestRejected,
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> ||
          decoded['success'] != true ||
          decoded['timestamp'] is! String ||
          (decoded['timestamp'] as String).trim().isEmpty ||
          decoded['data'] is! List) {
        throw const FormatException('Invalid public search envelope.');
      }
      return (decoded['data'] as List)
          .map((entry) {
            if (entry is! Map<String, dynamic>) {
              throw const FormatException('Invalid public property record.');
            }
            return PublicProperty.fromJson(entry);
          })
          .toList(growable: false);
    } on PublicSearchException {
      rethrow;
    } catch (_) {
      throw const PublicSearchException(
        PublicSearchFailureKind.invalidResponse,
      );
    }
  }

  Future<http.Response> _sendAndRead(http.Request request) async {
    final streamedResponse = await client.send(request);
    return http.Response.fromStream(streamedResponse);
  }
}
