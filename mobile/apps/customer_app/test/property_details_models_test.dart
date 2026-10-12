import 'package:customer_app/features/property_details/data/property_details_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PublicPropertyDetail Model Tests', () {
    Map<String, dynamic> validJson() => {
          'id': 'prop-101',
          'title': 'شاليه فاخر على البحر',
          'unitType': 'CHALET',
          'propertyType': 'CHALET',
          'address': 'الكيلو 120، طريق الإسكندرية مطروح',
          'region': 'الساحل الشمالي',
          'resortName': 'مراسي',
          'bedrooms': 3,
          'bathrooms': 2,
          'maxGuests': 6,
          'basePricePerNight': 4500.0,
          'currency': 'EGP',
          'images': [
            'https://cdn.example.com/images/chalet_1.jpg',
            'https://cdn.example.com/images/chalet_2.jpg',
          ],
          'bedsCount': 4,
          'areaSqM': 160.0,
          'description': 'إطلالة مباشرة على اللاجون وحمام سباحة خاص.',
          'amenities': ['WIFI', 'POOL', 'AIR_CONDITIONING'],
          'houseRules': {'petsAllowed': false, 'smokingAllowed': false},
        };

    test('parses full valid JSON payload correctly', () {
      final json = validJson();
      final detail = PublicPropertyDetail.fromJson(json);

      expect(detail.id, 'prop-101');
      expect(detail.title, 'شاليه فاخر على البحر');
      expect(detail.unitType, 'CHALET');
      expect(detail.propertyType, 'CHALET');
      expect(detail.address, 'الكيلو 120، طريق الإسكندرية مطروح');
      expect(detail.region, 'الساحل الشمالي');
      expect(detail.resortName, 'مراسي');
      expect(detail.bedrooms, 3);
      expect(detail.bathrooms, 2);
      expect(detail.maxGuests, 6);
      expect(detail.basePricePerNight, 4500.0);
      expect(detail.currency, 'EGP');
      expect(detail.images.length, 2);
      expect(detail.images.first.toString(), 'https://cdn.example.com/images/chalet_1.jpg');
      expect(detail.bedsCount, 4);
      expect(detail.areaSqM, 160.0);
      expect(detail.description, 'إطلالة مباشرة على اللاجون وحمام سباحة خاص.');
      expect(detail.amenities, ['WIFI', 'POOL', 'AIR_CONDITIONING']);
      expect(detail.houseRules['petsAllowed'], false);
    });

    test('parses minimal valid JSON with optional fields omitted or null', () {
      final json = <String, dynamic>{
        'id': 'prop-min',
        'title': 'استوديو هادئ',
        'unitType': 'STUDIO',
        'address': 'وسط البلد',
        'bedrooms': 1,
        'bathrooms': 1,
        'maxGuests': 2,
        'basePricePerNight': 1200.0,
        'currency': 'EGP',
        'images': <String>[],
      };

      final detail = PublicPropertyDetail.fromJson(json);
      expect(detail.id, 'prop-min');
      expect(detail.propertyType, isNull);
      expect(detail.region, isNull);
      expect(detail.resortName, isNull);
      expect(detail.bedsCount, isNull);
      expect(detail.areaSqM, isNull);
      expect(detail.description, isNull);
      expect(detail.amenities, isEmpty);
      expect(detail.images, isEmpty);
      expect(detail.houseRules, isEmpty);
    });

    test('fails closed when required string is missing, empty, or whitespace', () {
      final emptyId = validJson()..['id'] = '   ';
      expect(() => PublicPropertyDetail.fromJson(emptyId), throwsFormatException);

      final missingTitle = validJson()..remove('title');
      expect(() => PublicPropertyDetail.fromJson(missingTitle), throwsFormatException);

      final emptyUnitType = validJson()..['unitType'] = '';
      expect(() => PublicPropertyDetail.fromJson(emptyUnitType), throwsFormatException);
    });

    test('fails closed when address is missing or not a string', () {
      final noAddress = validJson()..remove('address');
      expect(() => PublicPropertyDetail.fromJson(noAddress), throwsFormatException);

      final numericAddress = validJson()..['address'] = 12345;
      expect(() => PublicPropertyDetail.fromJson(numericAddress), throwsFormatException);
    });

    test('fails closed when maxGuests is zero or negative', () {
      final zeroGuests = validJson()..['maxGuests'] = 0;
      expect(() => PublicPropertyDetail.fromJson(zeroGuests), throwsFormatException);

      final negGuests = validJson()..['maxGuests'] = -2;
      expect(() => PublicPropertyDetail.fromJson(negGuests), throwsFormatException);
    });

    test('fails closed when price is zero, negative, or currency is unsupported', () {
      final zeroPrice = validJson()..['basePricePerNight'] = 0;
      expect(() => PublicPropertyDetail.fromJson(zeroPrice), throwsFormatException);

      final negPrice = validJson()..['basePricePerNight'] = -100;
      expect(() => PublicPropertyDetail.fromJson(negPrice), throwsFormatException);

      final foreignCurr = validJson()..['currency'] = 'USD';
      expect(() => PublicPropertyDetail.fromJson(foreignCurr), throwsFormatException);
    });

    test('fails closed on non-https image URL or malformed URI', () {
      final httpImage = validJson()
        ..['images'] = ['http://cdn.example.com/insecure.jpg'];
      expect(() => PublicPropertyDetail.fromJson(httpImage), throwsFormatException);

      final malformedUri = validJson()
        ..['images'] = ['https://user:pass@evil.com/path'];
      expect(() => PublicPropertyDetail.fromJson(malformedUri), throwsFormatException);
    });
  });

  group('UnavailableDateRange Model Tests', () {
    test('parses valid checkIn and checkOut dates', () {
      final range = UnavailableDateRange.fromJson({
        'checkIn': '2026-07-01',
        'checkOut': '2026-07-05',
      });
      expect(range.checkIn, DateTime(2026, 7, 1));
      expect(range.checkOut, DateTime(2026, 7, 5));
    });

    test('throws when checkOut is before checkIn', () {
      expect(
        () => UnavailableDateRange.fromJson({
          'checkIn': '2026-07-10',
          'checkOut': '2026-07-05',
        }),
        throwsFormatException,
      );
    });

    test('verifies standard vacation stay overlap logic', () {
      // Blocked stay: July 5 to July 10 (nights 5, 6, 7, 8, 9).
      final blocked = UnavailableDateRange(
        checkIn: DateTime(2026, 7, 5),
        checkOut: DateTime(2026, 7, 10),
      );

      // Overlapping query ranges:
      expect(blocked.overlaps(DateTime(2026, 7, 4), DateTime(2026, 7, 7)), isTrue);
      expect(blocked.overlaps(DateTime(2026, 7, 6), DateTime(2026, 7, 8)), isTrue);
      expect(blocked.overlaps(DateTime(2026, 7, 8), DateTime(2026, 7, 12)), isTrue);
      expect(blocked.overlaps(DateTime(2026, 7, 2), DateTime(2026, 7, 15)), isTrue);

      // Boundary touch: guest checks out on July 5 (before blocked guest arrives) -> NO overlap
      expect(blocked.overlaps(DateTime(2026, 7, 1), DateTime(2026, 7, 5)), isFalse);

      // Boundary touch: guest arrives on July 10 (when blocked guest checks out) -> NO overlap
      expect(blocked.overlaps(DateTime(2026, 7, 10), DateTime(2026, 7, 14)), isFalse);

      // Completely disjoint:
      expect(blocked.overlaps(DateTime(2026, 7, 12), DateTime(2026, 7, 15)), isFalse);
    });

    test('verifies containsDate logic', () {
      final blocked = UnavailableDateRange(
        checkIn: DateTime(2026, 7, 5),
        checkOut: DateTime(2026, 7, 10),
      );

      expect(blocked.containsDate(DateTime(2026, 7, 5)), isTrue);
      expect(blocked.containsDate(DateTime(2026, 7, 8)), isTrue);
      // Check-out date is not a stay night
      expect(blocked.containsDate(DateTime(2026, 7, 10)), isFalse);
      expect(blocked.containsDate(DateTime(2026, 7, 4)), isFalse);
    });
  });

  group('PropertyAvailability Model Tests', () {
    test('parses availability with ranges and stay constraints', () {
      final availability = PropertyAvailability.fromJson({
        'propertyId': 'prop-101',
        'unavailableRanges': [
          {'checkIn': '2026-08-01', 'checkOut': '2026-08-05'},
          {'checkIn': '2026-08-10', 'checkOut': '2026-08-15'},
        ],
        'minStay': 3,
        'maxStay': 14,
      });

      expect(availability.propertyId, 'prop-101');
      expect(availability.unavailableRanges.length, 2);
      expect(availability.minStay, 3);
      expect(availability.maxStay, 14);
    });

    test('isDateBlocked blocks past dates and booked dates', () {
      final availability = PropertyAvailability(
        propertyId: 'prop-101',
        unavailableRanges: [
          UnavailableDateRange(
            checkIn: DateTime(2026, 8, 10),
            checkOut: DateTime(2026, 8, 15),
          ),
        ],
      );

      final fixedNow = DateTime(2026, 8, 5);

      // Past date:
      expect(availability.isDateBlocked(DateTime(2026, 8, 3), now: fixedNow), isTrue);
      // Today:
      expect(availability.isDateBlocked(DateTime(2026, 8, 5), now: fixedNow), isFalse);
      // Blocked booked night:
      expect(availability.isDateBlocked(DateTime(2026, 8, 12), now: fixedNow), isTrue);
      // Available night:
      expect(availability.isDateBlocked(DateTime(2026, 8, 7), now: fixedNow), isFalse);
    });

    test('hasConflict returns true if any unavailable range overlaps', () {
      final availability = PropertyAvailability(
        propertyId: 'prop-101',
        unavailableRanges: [
          UnavailableDateRange(
            checkIn: DateTime(2026, 8, 10),
            checkOut: DateTime(2026, 8, 15),
          ),
        ],
      );

      expect(
        availability.hasConflict(DateTime(2026, 8, 9), DateTime(2026, 8, 12)),
        isTrue,
      );
      expect(
        availability.hasConflict(DateTime(2026, 8, 15), DateTime(2026, 8, 18)),
        isFalse,
      );
    });
  });

  group('BookingQuote Model Tests', () {
    Map<String, dynamic> validQuoteJson() => {
          'propertyId': 'prop-101',
          'checkIn': '2026-08-10',
          'checkOut': '2026-08-15',
          'nights': 5,
          'guests': 4,
          'pricePerNight': 3000.0,
          'totalStay': 15000.0,
          'depositAmount': 3750.0,
          'remainingAmount': 11250.0,
          'currency': 'EGP',
          'quoteFingerprint': 'fp-quote-abc-123456',
        };

    test('parses valid BookingQuote correctly', () {
      final quote = BookingQuote.fromJson(validQuoteJson());

      expect(quote.propertyId, 'prop-101');
      expect(quote.checkIn, DateTime(2026, 8, 10));
      expect(quote.checkOut, DateTime(2026, 8, 15));
      expect(quote.nights, 5);
      expect(quote.guests, 4);
      expect(quote.pricePerNight, 3000.0);
      expect(quote.totalStay, 15000.0);
      expect(quote.depositAmount, 3750.0);
      expect(quote.remainingAmount, 11250.0);
      expect(quote.currency, 'EGP');
      expect(quote.quoteFingerprint, 'fp-quote-abc-123456');
    });

    test('fails closed on foreign currency or missing quote fingerprint', () {
      final usdQuote = validQuoteJson()..['currency'] = 'SAR';
      expect(() => BookingQuote.fromJson(usdQuote), throwsFormatException);

      final emptyFp = validQuoteJson()..['quoteFingerprint'] = '   ';
      expect(() => BookingQuote.fromJson(emptyFp), throwsFormatException);

      final zeroDeposit = validQuoteJson()..['depositAmount'] = 0;
      expect(() => BookingQuote.fromJson(zeroDeposit), throwsFormatException);
    });
  });
}
