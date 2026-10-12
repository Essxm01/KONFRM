import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../discovery/data/public_property_search_repository.dart';
import 'booking_review_models.dart';

final bookingReviewRepositoryProvider = Provider<BookingReviewRepository>((ref) {
  final baseUrl = ref.watch(publicApiBaseUrlProvider);
  return BookingReviewRepository(baseUrl: baseUrl);
});

class BookingReviewRepository {
  BookingReviewRepository({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  static const _timeout = Duration(seconds: 10);

  Uri _buildUri(String path) {
    final cleanBase = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath');
  }

  /// Calculates a fresh server-authoritative quote for revalidation.
  Future<BookingQuote> calculateQuote({
    required String propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
    String? authToken,
  }) async {
    final uri = _buildUri('/api/v1/customer/bookings/calculate');
    final headers = <String, String>{
      'content-type': 'application/json',
      if (authToken != null && authToken.trim().isNotEmpty)
        'authorization': 'Bearer ${authToken.trim()}',
    };

    final body = jsonEncode({
      'propertyId': propertyId,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guests,
    });

    try {
      final response = await _client.post(uri, headers: headers, body: body).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json;
        try {
          json = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw BookingReviewException(
            BookingReviewFailureKind.invalidResponse,
            'استجابة غير صالحة من خدمة حساب السعر.',
            'JSON decode failed: $e',
          );
        }

        final data = json['data'];
        if (data is! Map<String, dynamic>) {
          throw const BookingReviewException(
            BookingReviewFailureKind.invalidResponse,
            'استجابة غير صالحة من خدمة حساب السعر.',
            'Payload missing data map',
          );
        }

        try {
          return BookingQuote.fromJson(data);
        } catch (e) {
          throw BookingReviewException(
            BookingReviewFailureKind.invalidResponse,
            'استجابة غير صالحة من خدمة حساب السعر.',
            'BookingQuote.fromJson failed: $e',
          );
        }
      }

      // Handle Non-200 responses
      Map<String, dynamic>? errorJson;
      try {
        errorJson = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        errorJson = null;
      }

      final errorCode = errorJson?['error']?['code']?.toString() ?? '';
      final rawErrorMsg = errorJson?['error']?['message']?.toString() ?? 'HTTP ${response.statusCode}';

      if (response.statusCode == 409 || errorCode == 'DATE_OVERLAP') {
        throw BookingReviewException(
          BookingReviewFailureKind.dateOverlap,
          'التواريخ المطلوبة محجوزة مسبقاً أو لم تعد متاحة.',
          'HTTP ${response.statusCode}: $rawErrorMsg',
        );
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw BookingReviewException(
          BookingReviewFailureKind.unauthorized,
          'تسجيل الدخول مطلوب لإجراء هذه العملية.',
          'HTTP ${response.statusCode}: $rawErrorMsg',
        );
      }

      throw BookingReviewException(
        BookingReviewFailureKind.server,
        'تعذر التحقق من السعر حالياً. يرجى إعادة المحاولة.',
        'HTTP ${response.statusCode}: $rawErrorMsg',
      );
    } on BookingReviewException {
      rethrow;
    } on SocketException catch (e) {
      throw BookingReviewException(
        BookingReviewFailureKind.network,
        'تعذر الاتصال بالخادم. تحقق من اتصال الإنترنت وأعد المحاولة.',
        e.toString(),
      );
    } on TimeoutException catch (e) {
      throw BookingReviewException(
        BookingReviewFailureKind.timeout,
        'استغرق التحقق وقتاً طويلاً. يرجى إعادة المحاولة.',
        e.toString(),
      );
    } catch (e) {
      throw BookingReviewException(
        BookingReviewFailureKind.network,
        'حدث خطأ غير متوقع في الاتصال. يرجى إعادة المحاولة.',
        e.toString(),
      );
    }
  }

  /// Submits the booking request via protected POST /api/v1/customer/bookings
  Future<BookingRequestResult> submitBookingRequest({
    required CreateBookingRequest request,
    String? authToken,
  }) async {
    final uri = _buildUri('/api/v1/customer/bookings');
    final headers = <String, String>{
      'content-type': 'application/json',
      if (authToken != null && authToken.trim().isNotEmpty)
        'authorization': 'Bearer ${authToken.trim()}',
    };

    final body = jsonEncode(request.toJson());

    try {
      final response = await _client.post(uri, headers: headers, body: body).timeout(_timeout);

      // 1. Success (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json;
        try {
          json = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw BookingReviewException(
            BookingReviewFailureKind.invalidResponse,
            'استجابة غير صالحة من خدمة إرسال طلب الحجز.',
            'JSON decode failed: $e',
          );
        }

        final data = json['data'];
        if (data is! Map<String, dynamic>) {
          throw const BookingReviewException(
            BookingReviewFailureKind.invalidResponse,
            'استجابة غير صالحة من خدمة إرسال طلب الحجز.',
            'Payload missing data map',
          );
        }

        try {
          return BookingRequestResult.fromJson(
            data,
            expectedPropertyId: request.propertyId,
          );
        } catch (e) {
          throw BookingReviewException(
            BookingReviewFailureKind.invalidResponse,
            'استجابة غير صالحة من خدمة إرسال طلب الحجز.',
            'BookingRequestResult.fromJson failed: $e',
          );
        }
      }

      // Handle Non-2xx responses
      Map<String, dynamic>? errorJson;
      try {
        errorJson = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        errorJson = null;
      }

      final errorCode = errorJson?['error']?['code']?.toString() ?? '';
      final rawErrorMsg = errorJson?['error']?['message']?.toString() ?? 'HTTP ${response.statusCode}';

      // 2. 401 / 403 Unauthorized / Session Expired
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw BookingReviewException(
          BookingReviewFailureKind.unauthorized,
          'تسجيل الدخول مطلوب لإرسال طلب الحجز.',
          'HTTP ${response.statusCode}: $rawErrorMsg',
        );
      }

      // 3. 409 QUOTE_CHANGED: Server price or fingerprint shifted
      if (response.statusCode == 409 && errorCode == 'QUOTE_CHANGED') {
        BookingQuote? freshQuote;
        final rawCurrent = errorJson?['data']?['currentQuote'];
        if (rawCurrent is Map<String, dynamic>) {
          try {
            freshQuote = BookingQuote.fromJson(rawCurrent);
          } catch (_) {
            freshQuote = null;
          }
        }
        throw BookingReviewException(
          BookingReviewFailureKind.quoteChanged,
          'تم تحديث السعر. يرجى مراجعة المبلغ الجديد قبل إرسال الطلب.',
          'QUOTE_CHANGED: $rawErrorMsg',
          freshQuote,
        );
      }

      // 4. 409 DATE_OVERLAP / DATE_CONFLICT: Dates no longer available
      if (response.statusCode == 409 &&
          (errorCode == 'DATE_OVERLAP' || errorCode == 'DATE_CONFLICT')) {
        throw BookingReviewException(
          BookingReviewFailureKind.dateOverlap,
          'التواريخ المختارة لم تعد متاحة حالياً.',
          'DATE_CONFLICT: $rawErrorMsg',
        );
      }

      // 5. 409 IDEMPOTENCY_CONFLICT: Request conflict
      if (response.statusCode == 409 && errorCode == 'IDEMPOTENCY_CONFLICT') {
        throw BookingReviewException(
          BookingReviewFailureKind.idempotencyConflict,
          'تعذر التحقق من هذا الطلب بأمان. ارجع لتفاصيل الإقامة وحاول مرة أخرى.',
          'IDEMPOTENCY_CONFLICT: $rawErrorMsg',
        );
      }

      // 6. Generic / Server Error
      throw BookingReviewException(
        BookingReviewFailureKind.server,
        'تعذر إرسال الطلب حالياً. يرجى إعادة المحاولة.',
        'HTTP ${response.statusCode}: $rawErrorMsg',
      );
    } on BookingReviewException {
      rethrow;
    } on SocketException catch (e) {
      throw BookingReviewException(
        BookingReviewFailureKind.network,
        'تفاصيل طلبك ما زالت معروضة في هذه الشاشة. تحقق من الاتصال وحاول مرة أخرى.',
        e.toString(),
      );
    } on TimeoutException catch (e) {
      throw BookingReviewException(
        BookingReviewFailureKind.timeout,
        'استغرق إرسال الطلب وقتاً طويلاً. يرجى إعادة المحاولة.',
        e.toString(),
      );
    } catch (e) {
      throw BookingReviewException(
        BookingReviewFailureKind.network,
        'تفاصيل طلبك ما زالت معروضة في هذه الشاشة. تحقق من الاتصال وحاول مرة أخرى.',
        e.toString(),
      );
    }
  }
}
