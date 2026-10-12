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
  const PropertyDetailsException(this.kind, [this.message]);

  final PropertyDetailsFailureKind kind;
  final String? message;

  @override
  String toString() => 'PropertyDetailsException($kind, $message)';
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
      throw const PropertyDetailsException(PropertyDetailsFailureKind.configuration);
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
        'معرف الوحدة غير صالح',
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
    } on TimeoutException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.timeout);
    } on SocketException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    } on http.ClientException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    } catch (_) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    }

    if (response.statusCode == 404) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
      );
    }

    if (response.statusCode == 403) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.unpublished,
        'هذه الوحدة غير معروضة للنشر حالياً',
      );
    }

    if (response.statusCode >= 500) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.server);
    }

    if (response.statusCode != 200) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        'HTTP ${response.statusCode}',
      );
    }

    final dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.invalidResponse);
    }

    if (body is! Map<String, dynamic> || body['success'] != true || body['data'] is! Map<String, dynamic>) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.invalidResponse);
    }

    try {
      return PublicPropertyDetail.fromJson(body['data'] as Map<String, dynamic>);
    } catch (e) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        e.toString(),
      );
    }
  }

  /// Fetches canonical availability from GET /api/v1/customer/properties/:id/availability
  Future<PropertyAvailability> getAvailability(String propertyId) async {
    final cleanId = propertyId.trim();
    if (cleanId.isEmpty) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'معرف الوحدة غير صالح',
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
    } on TimeoutException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.timeout);
    } on SocketException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    } on http.ClientException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    } catch (_) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    }

    if (response.statusCode == 404) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
      );
    }

    if (response.statusCode == 403) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.unpublished,
        'هذه الوحدة غير معروضة للنشر حالياً',
      );
    }

    if (response.statusCode >= 500) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.server);
    }

    if (response.statusCode != 200) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        'HTTP ${response.statusCode}',
      );
    }

    final dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.invalidResponse);
    }

    if (body is! Map<String, dynamic> || body['success'] != true || body['data'] is! Map<String, dynamic>) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.invalidResponse);
    }

    try {
      final availability = PropertyAvailability.fromJson(body['data'] as Map<String, dynamic>);
      if (availability.propertyId != cleanId) {
        throw const PropertyDetailsException(
          PropertyDetailsFailureKind.invalidResponse,
          'تعذر التحقق من هوية العقار في استجابة التوفر.',
        );
      }
      return availability;
    } catch (e) {
      if (e is PropertyDetailsException) rethrow;
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        e.toString(),
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
    } on TimeoutException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.timeout);
    } on SocketException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    } on http.ClientException {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    } catch (_) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.network);
    }

    final dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.invalidResponse);
    }

    if (response.statusCode == 409) {
      final msg = body is Map<String, dynamic> && body['error'] is Map
          ? body['error']['message'] as String?
          : null;
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.dateOverlap,
        msg ?? 'التواريخ المطلوبة محجوزة مسبقاً',
      );
    }

    if (response.statusCode == 400) {
      final err = body is Map<String, dynamic> && body['error'] is Map
          ? body['error']
          : null;
      final code = err?['code'] as String?;
      final msg = err?['message'] as String?;

      if (code == 'MIN_STAY_NOT_MET') {
        throw PropertyDetailsException(
          PropertyDetailsFailureKind.minStayNotMet,
          msg ?? 'الحد الأدنى للإقامة ليلتان',
        );
      }
      if (code == 'MAX_STAY_EXCEEDED') {
        throw PropertyDetailsException(
          PropertyDetailsFailureKind.maxStayExceeded,
          msg ?? 'الحد الأقصى للإقامة 30 ليلة',
        );
      }
      if (code == 'MAX_GUESTS_EXCEEDED') {
        throw PropertyDetailsException(
          PropertyDetailsFailureKind.maxGuestsExceeded,
          msg ?? 'عدد الضيوف يتجاوز السعة المحددة',
        );
      }
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        msg ?? 'بيانات الحجز غير صالحة',
      );
    }

    if (response.statusCode == 404) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.notFound,
        'الوحدة غير موجودة',
      );
    }

    if (response.statusCode == 403) {
      throw const PropertyDetailsException(
        PropertyDetailsFailureKind.unpublished,
        'لا يمكن حساب سعر لوحدة غير منشورة',
      );
    }

    if (response.statusCode >= 500) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.server);
    }

    if (response.statusCode != 200) {
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.server,
        'HTTP ${response.statusCode}',
      );
    }

    if (body is! Map<String, dynamic> || body['success'] != true || body['data'] is! Map<String, dynamic>) {
      throw const PropertyDetailsException(PropertyDetailsFailureKind.invalidResponse);
    }

    try {
      final quote = BookingQuote.fromJson(body['data'] as Map<String, dynamic>);
      if (quote.propertyId != cleanId) {
        throw const PropertyDetailsException(
          PropertyDetailsFailureKind.invalidResponse,
          'تعذر التحقق من هوية العقار في استجابة السعر.',
        );
      }
      return quote;
    } catch (e) {
      if (e is PropertyDetailsException) rethrow;
      throw PropertyDetailsException(
        PropertyDetailsFailureKind.invalidResponse,
        e.toString(),
      );
    }
  }
}
