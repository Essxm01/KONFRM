import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/features/booking_review/data/booking_review_models.dart';

void main() {
  group('BookingReviewContext Invariants & Pluralization', () {
    final sampleQuote = BookingQuote(
      propertyId: 'prop_001',
      checkIn: DateTime.utc(2026, 10, 15),
      checkOut: DateTime.utc(2026, 10, 18),
      nights: 3,
      guests: 2,
      pricePerNight: 4500,
      totalStay: 13500,
      depositAmount: 4500,
      remainingAmount: 9000,
      currency: 'EGP',
      quoteFingerprint: 'fp_sample_123',
    );

    test('valid context initializes cleanly with generated UUID requestId', () {
      final context = BookingReviewContext(
        propertyId: 'prop_001',
        propertyTitle: 'شاليه شاطئي فاخر برأس الحكمة',
        propertyLocation: 'رأس الحكمة، الساحل الشمالي',
        propertyImage: 'https://images.unsplash.com/photo-1512917774080',
        checkIn: DateTime.utc(2026, 10, 15),
        checkOut: DateTime.utc(2026, 10, 18),
        guests: 2,
        initialQuote: sampleQuote,
      );

      expect(context.propertyId, 'prop_001');
      expect(context.nights, 3);
      expect(context.requestId, isNotEmpty);
      expect(
        RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
            .hasMatch(context.requestId),
        isTrue,
      );
    });

    test('preserves explicitly supplied requestId for idempotency across retries', () {
      const explicitId = 'test-idempotent-uuid-001';
      final context = BookingReviewContext(
        propertyId: 'prop_001',
        propertyTitle: 'شاليه شاطئي',
        propertyLocation: 'رأس الحكمة',
        checkIn: DateTime.utc(2026, 10, 15),
        checkOut: DateTime.utc(2026, 10, 18),
        guests: 2,
        initialQuote: sampleQuote,
        requestId: explicitId,
      );

      expect(context.requestId, explicitId);
    });

    test('enforces stay duration invariants: min 2 nights and max 30 nights', () {
      // 1 night -> assertion failure
      expect(
        () => BookingReviewContext(
          propertyId: 'prop_001',
          propertyTitle: 'شاليه',
          propertyLocation: 'رأس الحكمة',
          checkIn: DateTime.utc(2026, 10, 15),
          checkOut: DateTime.utc(2026, 10, 16),
          guests: 2,
          initialQuote: sampleQuote,
        ),
        throwsA(isA<AssertionError>()),
      );

      // 31 nights -> assertion failure
      expect(
        () => BookingReviewContext(
          propertyId: 'prop_001',
          propertyTitle: 'شاليه',
          propertyLocation: 'رأس الحكمة',
          checkIn: DateTime.utc(2026, 10, 1),
          checkOut: DateTime.utc(2026, 11, 1), // 31 nights
          guests: 2,
          initialQuote: sampleQuote,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('enforces guests invariant: guests >= 1', () {
      expect(
        () => BookingReviewContext(
          propertyId: 'prop_001',
          propertyTitle: 'شاليه',
          propertyLocation: 'رأس الحكمة',
          checkIn: DateTime.utc(2026, 10, 15),
          checkOut: DateTime.utc(2026, 10, 18),
          guests: 0,
          initialQuote: sampleQuote,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('matchesQuote verifies date, guest, and property identity strictly', () {
      final context = BookingReviewContext(
        propertyId: 'prop_001',
        propertyTitle: 'شاليه',
        propertyLocation: 'رأس الحكمة',
        checkIn: DateTime.utc(2026, 10, 15),
        checkOut: DateTime.utc(2026, 10, 18),
        guests: 2,
        initialQuote: sampleQuote,
      );

      expect(context.matchesQuote(sampleQuote), isTrue);

      final differentDatesQuote = BookingQuote(
        propertyId: 'prop_001',
        checkIn: DateTime.utc(2026, 10, 16),
        checkOut: DateTime.utc(2026, 10, 19),
        nights: 3,
        guests: 2,
        pricePerNight: 4500,
        totalStay: 13500,
        depositAmount: 4500,
        remainingAmount: 9000,
        currency: 'EGP',
        quoteFingerprint: 'fp_diff_dates',
      );
      expect(context.matchesQuote(differentDatesQuote), isFalse);

      final differentGuestsQuote = BookingQuote(
        propertyId: 'prop_001',
        checkIn: DateTime.utc(2026, 10, 15),
        checkOut: DateTime.utc(2026, 10, 18),
        nights: 3,
        guests: 3,
        pricePerNight: 4500,
        totalStay: 13500,
        depositAmount: 4500,
        remainingAmount: 9000,
        currency: 'EGP',
        quoteFingerprint: 'fp_diff_guests',
      );
      expect(context.matchesQuote(differentGuestsQuote), isFalse);
    });

    test('Arabic nights pluralization conforms to Arabic grammatical rules', () {
      expect(formatArabicNights(1), 'ليلة واحدة');
      expect(formatArabicNights(2), 'ليلتان');
      expect(formatArabicNights(3), '3 ليالٍ');
      expect(formatArabicNights(5), '5 ليالٍ');
      expect(formatArabicNights(10), '10 ليالٍ');
      expect(formatArabicNights(11), '11 ليلة');
      expect(formatArabicNights(14), '14 ليلة');
      expect(formatArabicNights(30), '30 ليلة');
    });

    test('Arabic guests pluralization conforms to Arabic grammatical rules', () {
      expect(formatArabicGuests(1), 'ضيف واحد');
      expect(formatArabicGuests(2), 'ضيفان');
      expect(formatArabicGuests(3), '3 ضيوف');
      expect(formatArabicGuests(6), '6 ضيوف');
      expect(formatArabicGuests(10), '10 ضيوف');
      expect(formatArabicGuests(11), '11 ضيف');
      expect(formatArabicGuests(16), '16 ضيف');
    });

    test('Arabic stay range formatting outputs correct arrows and dates', () {
      final inDate = DateTime.utc(2026, 10, 12);
      final outDate = DateTime.utc(2026, 10, 15);
      final formatted = formatArabicStayRange(inDate, outDate);
      expect(formatted, '12 أكتوبر ← 15 أكتوبر 2026');
    });
  });

  group('CreateBookingRequest Serialization & Backend Contract', () {
    test('serializes correctly matching backend POST /api/v1/customer/bookings', () {
      const req = CreateBookingRequest(
        propertyId: 'prop_999',
        checkIn: '2026-10-15',
        checkOut: '2026-10-18',
        guests: 4,
        reviewedQuoteFingerprint: 'fp_abc_789',
        requestId: 'c3d5e7f1-1234-4567-89ab-cdef01234567',
      );

      final json = req.toJson();
      expect(json['propertyId'], 'prop_999');
      expect(json['checkIn'], '2026-10-15');
      expect(json['checkOut'], '2026-10-18');
      expect(json['guests'], 4);
      expect(json['reviewedQuoteFingerprint'], 'fp_abc_789');
      expect(json['requestId'], 'c3d5e7f1-1234-4567-89ab-cdef01234567');
    });
  });

  group('BookingRequestResult Parsing', () {
    test('parses 201 response payload correctly', () {
      final raw = {
        'id': 'book_live_001',
        'bookingNumber': 'BK-100234',
        'status': 'PENDING_OWNER_APPROVAL',
        'propertyId': 'prop_999',
        'checkIn': '2026-10-15',
        'checkOut': '2026-10-18',
        'createdAt': '2026-10-12T18:00:00Z',
      };

      final result = BookingRequestResult.fromJson(raw);
      expect(result.id, 'book_live_001');
      expect(result.bookingNumber, 'BK-100234');
      expect(result.propertyId, 'prop_999');
      expect(result.status, 'PENDING_OWNER_APPROVAL');
    });

    test('throws FormatException on missing or invalid id', () {
      expect(
        () => BookingRequestResult.fromJson({'status': 'PENDING_OWNER_APPROVAL'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException on missing status or status other than PENDING_OWNER_APPROVAL', () {
      // Missing status
      expect(
        () => BookingRequestResult.fromJson({'id': 'book_123'}),
        throwsA(isA<FormatException>()),
      );

      // Status is CONFIRMED (not initial creation status)
      expect(
        () => BookingRequestResult.fromJson({
          'id': 'book_123',
          'status': 'CONFIRMED',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException on propertyId mismatch when expectedPropertyId provided', () {
      expect(
        () => BookingRequestResult.fromJson(
          {
            'id': 'book_123',
            'status': 'PENDING_OWNER_APPROVAL',
            'propertyId': 'wrong_prop_456',
          },
          expectedPropertyId: 'expected_prop_123',
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('BookingReviewException Diagnostics Isolation', () {
    test('customer-facing message is clean Arabic while diagnostics are quarantined', () {
      const ex = BookingReviewException(
        BookingReviewFailureKind.network,
        'تعذر الاتصال بالخدمة حالياً. يرجى التحقق من اتصالك والمحاولة مجدداً.',
        'SocketException: OS Error: Connection refused, errno = 111',
      );

      expect(ex.userMessage, contains('تعذر الاتصال بالخدمة'));
      expect(ex.technicalDetails, contains('Connection refused'));
      expect(ex.toString(), contains('BookingReviewException'));
    });
  });
}
