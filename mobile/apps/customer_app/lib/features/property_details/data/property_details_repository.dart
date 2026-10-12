import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../discovery/data/public_property_search_repository.dart';
import 'property_details_models.dart';

enum PropertyDetailsFailureKind {
  configuration,
  network,
  timeout,
  notFound,
  unpublished,
  dateOverlap,
  minStayNotMet,
  maxStayExceeded,
  maxGuestsExceeded,
  server,
  invalidResponse,
}

class PropertyDetailsException implements Exception {
  const PropertyDetailsException(
    this.kind, [
    this.userMessage,
    this.technicalDetails,
  ]);

  final PropertyDetailsFailureKind kind;

  /// Optional pre-sanitized customer-facing Arabic message.
  /// Must NEVER contain raw English errors, FormatException, or HTTP status codes.
  final String? userMessage;

  /// Internal technical diagnostics (e.g. FormatException, HTTP status, backend message).
  /// Preserved for internal debugging/logging, never exposed to the customer UI.
  final String? technicalDetails;

  /// Backwards-compatibility getter: returns userMessage if available.
  String? get message => userMessage;

  @override
  String toString() =>
      'PropertyDetailsException($kind, userMessage: $userMessage, technicalDetails: $technicalDetails)';
}

final propertyDetailsRepositoryProvider = Provider<PropertyDetailsRepository>((ref) {
  return PropertyDetailsRepository(
    baseUrl: ref.watch(publicApiBaseUrlProvider),
    client: ref.watch(publicHttpClientProvider),
  );
});

class PropertyDetailsRepository {
  PropertyDetailsRepository({
    required this.baseUrl,
    required this.client,
    this.timeout = const Duration(seconds: 12),
  });

  final String baseUrl;
  final http.Client client;
  final Duration timeout;

  Uri _validateAndBuildUri(String path, [Map<String, String>? queryParams]) {
    final origin = Uri.tryParse(baseUrl.trim());
    if (origin == null ||
        origin.scheme != 'https' ||
        origin.host.isEmpty ||
        origin.userInfo.isNotEmpty ||
        origin.hasQuery ||
        origin.hasFragment ||
        (origin.path.isNotEmpty && origin.path != '/')) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.configuration,
        null,
        'Invalid baseUrl configuration',
      );
    }
    return Uri(
      scheme: 'https',
      host: origin.host,
      port: origin.hasPort ? origin.port : null,
      path: path,
      queryParameters: queryParams?.isNotEmpty == true ? queryParams : null,
    );
  }

  /// Fetches public property details from GET /api/v1/customer/properties/:id
  Future<PublicPropertyDetail> getPropertyDetails(String propertyId) async {
    final cleanId = propertyId.trim();
    if (cleanId.isEmpty) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
        'Empty propertyId provided',
      );
    }

    final uri = _validateAndBuildUri('/api/v1/customer/properties/$cleanId');

    final http.Response response;
    try {
      response = await client.get(
        uri,
        headers: const {
          'Accept': 'application/json',
          'X-Client-Platform': 'flutter-customer',
        },
      ).timeout(timeout);
    } on TimeoutException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.timeout,
        null,
        e.toString(),
      );
    } on SocketException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    } on http.ClientException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    }

    if (response.statusCode == 404) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
        'HTTP 404',
      );
    }

    if (response.statusCode == 403) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.unpublished,
        'هذه الوحدة غير معروضة للنشر حالياً',
        'HTTP 403',
      );
    }

    if (response.statusCode >= 500) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        null,
        'HTTP ${response.statusCode}',
      );
    }

    if (response.statusCode != 200) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        null,
        'Unexpected HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'jsonDecode error: $e',
      );
    }

    if (body is! Map<String, dynamic> || body['success'] != true || body['data'] is! Map<String, dynamic>) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'Invalid envelope: success is not true or data is not a map',
      );
    }

    try {
      return PublicPropertyDetail.fromJson(body['data'] as Map<String, dynamic>);
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'PublicPropertyDetail.fromJson error: $e',
      );
    }
  }

  /// Fetches canonical availability from GET /api/v1/customer/properties/:id/availability
  Future<PropertyAvailability> getAvailability(String propertyId) async {
    final cleanId = propertyId.trim();
    if (cleanId.isEmpty) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
        'Empty propertyId provided',
      );
    }

    final uri = _validateAndBuildUri('/api/v1/customer/properties/$cleanId/availability');

    final http.Response response;
    try {
      response = await client.get(
        uri,
        headers: const {
          'Accept': 'application/json',
          'X-Client-Platform': 'flutter-customer',
        },
      ).timeout(timeout);
    } on TimeoutException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.timeout,
        null,
        e.toString(),
      );
    } on SocketException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    } on http.ClientException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    }

    if (response.statusCode == 404) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
        'HTTP 404',
      );
    }

    if (response.statusCode == 403) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.unpublished,
        'هذه الوحدة غير معروضة للنشر حالياً',
        'HTTP 403',
      );
    }

    if (response.statusCode >= 500) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        null,
        'HTTP ${response.statusCode}',
      );
    }

    if (response.statusCode != 200) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        null,
        'Unexpected HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'jsonDecode error: $e',
      );
    }

    if (body is! Map<String, dynamic> || body['success'] != true || body['data'] is! Map<String, dynamic>) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'Invalid envelope: success is not true or data is not a map',
      );
    }

    try {
      final availability = PropertyAvailability.fromJson(body['data'] as Map<String, dynamic>);
      if (availability.propertyId != cleanId) {
        throw const PropertyDetailsException(
          PropertyDetailsFailureKind.invalidResponse,
          'تعذر التحقق من هوية العقار في استجابة التوفر.',
          'Mismatched propertyId in availability response',
        );
      }
      return availability;
    } catch (e) {
      if (e is PropertyDetailsException) rethrow;
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'PropertyAvailability.fromJson error: $e',
      );
    }
  }

  /// Calculates authoritative booking quote from POST /api/v1/customer/bookings/calculate
  Future<BookingQuote> calculateQuote({
    required String propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
  }) async {
    final cleanId = propertyId.trim();
    final cleanIn = checkIn.trim();
    final cleanOut = checkOut.trim();

    if (cleanId.isEmpty || cleanIn.isEmpty || cleanOut.isEmpty || guests < 1) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        'بيانات طلب السعر غير مكتملة',
        'Missing required calculateQuote parameters',
      );
    }

    final uri = _validateAndBuildUri('/api/v1/customer/bookings/calculate');

    final http.Response response;
    try {
      response = await client.post(
        uri,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Client-Platform': 'flutter-customer',
        },
        body: jsonEncode({
          'propertyId': cleanId,
          'checkIn': cleanIn,
          'checkOut': cleanOut,
          'guests': guests,
        }),
      ).timeout(timeout);
    } on TimeoutException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.timeout,
        null,
        e.toString(),
      );
    } on SocketException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    } on http.ClientException catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.network,
        null,
        e.toString(),
      );
    }

    final dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'jsonDecode error: $e',
      );
    }

    if (response.statusCode == 409) {
      final rawMsg = body is Map<String, dynamic> && body['error'] is Map
          ? body['error']['message'] as String?
          : null;
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.dateOverlap,
        'التواريخ المطلوبة محجوزة مسبقاً',
        rawMsg ?? '409 Conflict: dates overlap',
      );
    }

    if (response.statusCode == 400) {
      final err = body is Map<String, dynamic> && body['error'] is Map
          ? body['error']
          : null;
      final code = err?['code'] as String?;
      final rawMsg = err?['message'] as String?;

      if (code == 'MIN_STAY_NOT_MET') {
        throw PropertyDetailsException(
          PropertyDetailsFailureKind.minStayNotMet,
          'الحد الأدنى للإقامة ليلتان',
          rawMsg ?? 'MIN_STAY_NOT_MET',
        );
      }
      if (code == 'MAX_STAY_EXCEEDED') {
        throw PropertyDetailsException(
          PropertyDetailsFailureKind.maxStayExceeded,
          'الحد الأقصى للإقامة 30 ليلة',
          rawMsg ?? 'MAX_STAY_EXCEEDED',
        );
      }
      if (code == 'MAX_GUESTS_EXCEEDED') {
        throw PropertyDetailsException(
          PropertyDetailsFailureKind.maxGuestsExceeded,
          'عدد الضيوف يتجاوز السعة المحددة',
          rawMsg ?? 'MAX_GUESTS_EXCEEDED',
        );
      }
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        'بيانات الحجز غير صالحة',
        rawMsg ?? '400 Bad Request: code $code',
      );
    }

    if (response.statusCode == 404) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
        'HTTP 404',
      );
    }

    if (response.statusCode == 403) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.unpublished,
        'لا يمكن حساب سعر لوحدة غير منشورة',
        'HTTP 403',
      );
    }

    if (response.statusCode >= 500) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        null,
        'HTTP ${response.statusCode}',
      );
    }

    if (response.statusCode != 200) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        null,
        'Unexpected HTTP ${response.statusCode}: ${response.body}',
      );
    }

    if (body is! Map<String, dynamic> || body['success'] != true || body['data'] is! Map<String, dynamic>) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'Invalid envelope: success is not true or data is not a map',
      );
    }

    try {
      final quote = BookingQuote.fromJson(body['data'] as Map<String, dynamic>);
      if (quote.propertyId != cleanId) {
        throw const PropertyDetailsException(
          PropertyDetailsFailureKind.invalidResponse,
          'تعذر التحقق من هوية العقار في استجابة السعر.',
          'Mismatched propertyId in quote response',
        );
      }
      return quote;
    } catch (e) {
      if (e is PropertyDetailsException) rethrow;
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        null,
        'BookingQuote.fromJson error: $e',
      );
    }
  }
}
