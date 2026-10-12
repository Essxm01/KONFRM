import 'dart:math';

import '../../property_details/data/property_details_models.dart';

export '../../property_details/data/property_details_models.dart' show BookingQuote;

/// Standard Arabic month names for date formatting.
const List<String> kArabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

/// Formats a DateTime into concise Arabic date: `12 أكتوبر`
String formatArabicDateShort(DateTime date) {
  final monthName = kArabicMonths[date.month - 1];
  return '${date.day} $monthName';
}

/// Formats a DateTime into full Arabic date with year: `15 أكتوبر 2026`
String formatArabicDate(DateTime date) {
  final monthName = kArabicMonths[date.month - 1];
  return '${date.day} $monthName ${date.year}';
}

/// Formats a stay date range in Arabic: `12 أكتوبر ← 15 أكتوبر 2026`
String formatArabicStayRange(DateTime checkIn, DateTime checkOut) {
  if (checkIn.year == checkOut.year) {
    return '${formatArabicDateShort(checkIn)} ← ${formatArabicDate(checkOut)}';
  }
  return '${formatArabicDate(checkIn)} ← ${formatArabicDate(checkOut)}';
}

/// Formats nights count adhering to Arabic grammatical pluralization:
/// - 1: `ليلة واحدة`
/// - 2: `ليلتان`
/// - 3..10: `X ليالٍ`
/// - 11..30: `X ليلة`
String formatArabicNights(int count) {
  if (count <= 0) return '0 ليلة';
  if (count == 1) return 'ليلة واحدة';
  if (count == 2) return 'ليلتان';
  if (count >= 3 && count <= 10) return '$count ليالٍ';
  return '$count ليلة';
}

/// Formats guests count adhering to Arabic grammatical pluralization:
/// - 1: `ضيف واحد`
/// - 2: `ضيفان`
/// - 3..10: `X ضيوف`
/// - 11+: `X ضيف`
String formatArabicGuests(int count) {
  if (count <= 0) return '0 ضيف';
  if (count == 1) return 'ضيف واحد';
  if (count == 2) return 'ضيفان';
  if (count >= 3 && count <= 10) return '$count ضيوف';
  return '$count ضيف';
}

/// Generates a standard RFC-4122 v4 UUID string for client request idempotency.
String generateClientRequestId() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(256));
  // Set version to 4
  values[6] = (values[6] & 0x0f) | 0x40;
  // Set variant to 10xx
  values[8] = (values[8] & 0x3f) | 0x80;
  final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();
  return '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-${hex.sublist(10, 16).join()}';
}

/// Single authoritative booking review context passed from Screen 06 to Screen 07.
class BookingReviewContext {
  BookingReviewContext({
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyLocation,
    this.propertyImage,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.initialQuote,
    String? requestId,
    this.authToken,
    this.startRevalidating = false,
  })  : requestId = (requestId != null && requestId.trim().isNotEmpty)
            ? requestId.trim()
            : generateClientRequestId(),
        assert(propertyId.trim().isNotEmpty, 'propertyId must not be empty'),
        assert(guests >= 1, 'guests must be at least 1'),
        assert(checkOut.isAfter(checkIn), 'checkOut must be after checkIn') {
    final nightsCount = checkOut.difference(checkIn).inDays;
    assert(nightsCount >= 2 && nightsCount <= 30, 'Stay must be between 2 and 30 nights');
  }

  final String propertyId;
  final String propertyTitle;
  final String propertyLocation;
  final String? propertyImage;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final BookingQuote initialQuote;
  final String requestId;
  final String? authToken;
  final bool startRevalidating;

  int get nights => checkOut.difference(checkIn).inDays;
  String get formattedStayDates => formatArabicStayRange(checkIn, checkOut);
  String get formattedNights => formatArabicNights(nights);
  String get formattedGuests => formatArabicGuests(guests);

  /// True if stay parameters strictly satisfy canonical stay invariants.
  bool get isValidStay =>
      propertyId.trim().isNotEmpty &&
      guests >= 1 &&
      checkOut.isAfter(checkIn) &&
      nights >= 2 &&
      nights <= 30;

  /// Validates that an incoming quote matches the review context exactly.
  bool matchesQuote(BookingQuote quote) {
    final qIn = DateTime.utc(quote.checkIn.year, quote.checkIn.month, quote.checkIn.day);
    final qOut = DateTime.utc(quote.checkOut.year, quote.checkOut.month, quote.checkOut.day);
    final cIn = DateTime.utc(checkIn.year, checkIn.month, checkIn.day);
    final cOut = DateTime.utc(checkOut.year, checkOut.month, checkOut.day);
    return quote.propertyId == propertyId &&
        quote.guests == guests &&
        quote.nights == nights &&
        qIn.isAtSameMomentAs(cIn) &&
        qOut.isAtSameMomentAs(cOut);
  }

  BookingReviewContext copyWith({
    String? propertyId,
    String? propertyTitle,
    String? propertyLocation,
    String? propertyImage,
    DateTime? checkIn,
    DateTime? checkOut,
    int? guests,
    BookingQuote? initialQuote,
    String? requestId,
    String? authToken,
    bool? startRevalidating,
  }) {
    return BookingReviewContext(
      propertyId: propertyId ?? this.propertyId,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyLocation: propertyLocation ?? this.propertyLocation,
      propertyImage: propertyImage ?? this.propertyImage,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      guests: guests ?? this.guests,
      initialQuote: initialQuote ?? this.initialQuote,
      requestId: requestId ?? this.requestId,
      authToken: authToken ?? this.authToken,
      startRevalidating: startRevalidating ?? this.startRevalidating,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingReviewContext &&
          runtimeType == other.runtimeType &&
          propertyId == other.propertyId &&
          checkIn == other.checkIn &&
          checkOut == other.checkOut &&
          guests == other.guests &&
          requestId == other.requestId &&
          authToken == other.authToken &&
          startRevalidating == other.startRevalidating;

  @override
  int get hashCode => Object.hash(
        propertyId,
        checkIn,
        checkOut,
        guests,
        requestId,
        authToken,
        startRevalidating,
      );
}

/// Request DTO for protected POST /api/v1/customer/bookings
class CreateBookingRequest {
  const CreateBookingRequest({
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.reviewedQuoteFingerprint,
    required this.requestId,
  });

  final String propertyId;
  final String checkIn; // YYYY-MM-DD
  final String checkOut; // YYYY-MM-DD
  final int guests;
  final String reviewedQuoteFingerprint;
  final String requestId;

  Map<String, dynamic> toJson() => {
        'propertyId': propertyId,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'guests': guests,
        'reviewedQuoteFingerprint': reviewedQuoteFingerprint,
        'requestId': requestId,
      };
}

/// Successful booking creation result returned by server (status 201).
class BookingRequestResult {
  const BookingRequestResult({
    required this.id,
    required this.bookingNumber,
    required this.status,
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.createdAt,
  });

  final String id;
  final String bookingNumber;
  final String status;
  final String propertyId;
  final String checkIn;
  final String checkOut;
  final String createdAt;

  factory BookingRequestResult.fromJson(
    Map<String, dynamic> json, {
    String? expectedPropertyId,
  }) {
    final id = json['id'];
    final bookingNumber = json['bookingNumber'] ?? json['id'];
    final status = json['status'];
    final propertyId = json['propertyId'] ?? '';
    final checkIn = json['checkIn'] ?? '';
    final checkOut = json['checkOut'] ?? '';
    final createdAt = json['createdAt'] ?? '';

    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('BookingRequestResult requires a non-empty id');
    }

    if (status is! String || status.trim().isEmpty) {
      throw const FormatException('BookingRequestResult requires a non-empty status');
    }

    if (status.trim() != 'PENDING_OWNER_APPROVAL') {
      throw FormatException('Unexpected booking creation status: $status');
    }

    if (expectedPropertyId != null &&
        expectedPropertyId.trim().isNotEmpty &&
        propertyId.toString().trim().isNotEmpty &&
        propertyId.toString().trim() != expectedPropertyId.trim()) {
      throw const FormatException('BookingRequestResult propertyId mismatch');
    }

    return BookingRequestResult(
      id: id.trim(),
      bookingNumber: bookingNumber.toString().trim(),
      status: status.toString().trim(),
      propertyId: propertyId.toString().trim(),
      checkIn: checkIn.toString().trim(),
      checkOut: checkOut.toString().trim(),
      createdAt: createdAt.toString().trim(),
    );
  }
}

/// Failure kinds for booking review and submission operations.
enum BookingReviewFailureKind {
  unauthorized,
  quoteChanged,
  dateOverlap,
  idempotencyConflict,
  invalidResponse,
  network,
  timeout,
  server,
}

/// Exception type for Screen 07 operations.
/// Quarantines internal diagnostic strings while delivering concise Arabic to the customer.
class BookingReviewException implements Exception {
  const BookingReviewException(
    this.kind, [
    this.userMessage,
    this.technicalDetails,
    this.freshQuote,
  ]);

  final BookingReviewFailureKind kind;
  final String? userMessage;
  final String? technicalDetails;
  final BookingQuote? freshQuote;

  String? get message => userMessage;

  @override
  String toString() =>
      'BookingReviewException($kind, userMessage: $userMessage, technicalDetails: $technicalDetails)';
}
