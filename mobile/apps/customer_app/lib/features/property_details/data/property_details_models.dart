/// DTO models for Customer Screen 06 Property Details, Availability, and Quotes.
///
/// Strictly enforces canonical public API contracts and fail-closed validation.
library;

/// Detailed public property representation.
class PublicPropertyDetail {
  const PublicPropertyDetail({
    required this.id,
    required this.title,
    required this.unitType,
    required this.address,
    required this.bedrooms,
    required this.bathrooms,
    required this.maxGuests,
    required this.basePricePerNight,
    required this.currency,
    required this.images,
    this.propertyType,
    this.region,
    this.resortName,
    this.bedsCount,
    this.areaSqM,
    this.description,
    this.amenities = const [],
    this.houseRules = const {},
  });

  final String id;
  final String title;
  final String unitType;
  final String address;
  final String? propertyType;
  final String? region;
  final String? resortName;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final double basePricePerNight;
  final String currency;
  final List<Uri> images;
  final int? bedsCount;
  final double? areaSqM;
  final String? description;
  final List<String> amenities;
  final Map<String, dynamic> houseRules;

  static const _requiredStrings = ['id', 'title', 'unitType'];

  factory PublicPropertyDetail.fromJson(Map<String, dynamic> json) {
    for (final key in _requiredStrings) {
      if (json[key] is! String || (json[key] as String).trim().isEmpty) {
        throw const FormatException('Invalid public property detail string field.');
      }
    }
    if (json['address'] is! String) {
      throw const FormatException('Invalid public property detail address.');
    }

    final bedrooms = _integer(json['bedrooms'], allowZero: true);
    final bathrooms = _integer(json['bathrooms'], allowZero: true);
    final maxGuests = _integer(json['maxGuests'], allowZero: false);
    final rawPrice = json['basePricePerNight'];
    if (rawPrice is! num || !rawPrice.isFinite || rawPrice <= 0) {
      throw const FormatException('Invalid public property detail price.');
    }
    if (json['currency'] != 'EGP') {
      throw const FormatException('Unsupported public property currency.');
    }

    final rawImages = json['images'];
    if (rawImages is! List) {
      throw const FormatException('Invalid public property detail images.');
    }
    final images = <Uri>[];
    for (final rawImage in rawImages) {
      if (rawImage is! String) {
        throw const FormatException('Invalid public property detail image URL.');
      }
      final uri = Uri.tryParse(rawImage);
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty) {
        throw const FormatException('Invalid public property detail image URL.');
      }
      images.add(uri);
    }

    final bedsCount = json['bedsCount'] != null
        ? _integer(json['bedsCount'], allowZero: true)
        : null;

    final rawArea = json['areaSqM'];
    final areaSqM = rawArea is num && rawArea.isFinite && rawArea >= 0
        ? rawArea.toDouble()
        : null;

    final description = _optionalString(json['description']);

    final rawAmenities = json['amenities'];
    final amenities = <String>[];
    if (rawAmenities is List) {
      for (final a in rawAmenities) {
        if (a is String && a.trim().isNotEmpty) {
          amenities.add(a.trim());
        }
      }
    }

    final rawRules = json['houseRules'];
    final houseRules = rawRules is Map<String, dynamic> ? rawRules : <String, dynamic>{};

    return PublicPropertyDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      unitType: json['unitType'] as String,
      address: json['address'] as String,
      propertyType: _optionalString(json['propertyType']),
      region: _optionalString(json['region']),
      resortName: _optionalString(json['resortName']),
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      maxGuests: maxGuests,
      basePricePerNight: rawPrice.toDouble(),
      currency: 'EGP',
      images: List.unmodifiable(images),
      bedsCount: bedsCount,
      areaSqM: areaSqM,
      description: description,
      amenities: List.unmodifiable(amenities),
      houseRules: houseRules,
    );
  }

  static int _integer(Object? value, {required bool allowZero}) {
    if (value is! num || !value.isFinite || value != value.round()) {
      throw const FormatException('Invalid public property count.');
    }
    final result = value.toInt();
    if (result < (allowZero ? 0 : 1)) {
      throw const FormatException('Invalid public property count.');
    }
    return result;
  }

  static String? _optionalString(Object? value) {
    if (value == null) return null;
    if (value is! String) {
      throw const FormatException('Invalid optional public property field.');
    }
    return value.trim().isEmpty ? null : value.trim();
  }
}

/// Represents an unavailable date range from the server.
class UnavailableDateRange {
  const UnavailableDateRange({
    required this.checkIn,
    required this.checkOut,
  });

  final DateTime checkIn;
  final DateTime checkOut;

  factory UnavailableDateRange.fromJson(Map<String, dynamic> json) {
    final rawIn = json['checkIn'];
    final rawOut = json['checkOut'];
    if (rawIn is! String || rawOut is! String) {
      throw const FormatException('UnavailableDateRange requires checkIn and checkOut strings');
    }
    final inDate = DateTime.tryParse(rawIn);
    final outDate = DateTime.tryParse(rawOut);
    if (inDate == null || outDate == null || outDate.isBefore(inDate)) {
      throw const FormatException('Invalid UnavailableDateRange date format or range');
    }
    return UnavailableDateRange(
      checkIn: DateTime.utc(inDate.year, inDate.month, inDate.day),
      checkOut: DateTime.utc(outDate.year, outDate.month, outDate.day),
    );
  }

  /// Returns true if this unavailable block overlaps with [targetCheckIn] to [targetCheckOut].
  /// Note standard hotel/vacation stay overlap semantics:
  /// Overlap occurs if targetCheckIn < checkOut AND targetCheckOut > checkIn.
  bool overlaps(DateTime targetCheckIn, DateTime targetCheckOut) {
    final tIn = DateTime.utc(targetCheckIn.year, targetCheckIn.month, targetCheckIn.day);
    final tOut = DateTime.utc(targetCheckOut.year, targetCheckOut.month, targetCheckOut.day);
    final cIn = DateTime.utc(checkIn.year, checkIn.month, checkIn.day);
    final cOut = DateTime.utc(checkOut.year, checkOut.month, checkOut.day);
    return tIn.isBefore(cOut) && tOut.isAfter(cIn);
  }

  /// Returns true if [date] falls within the unavailable stay nights [checkIn, checkOut).
  bool containsDate(DateTime date) {
    final d = DateTime.utc(date.year, date.month, date.day);
    final cIn = DateTime.utc(checkIn.year, checkIn.month, checkIn.day);
    final cOut = DateTime.utc(checkOut.year, checkOut.month, checkOut.day);
    return (d.isAtSameMomentAs(cIn) || d.isAfter(cIn)) && d.isBefore(cOut);
  }
}

/// Represents canonical property availability.
class PropertyAvailability {
  const PropertyAvailability({
    required this.propertyId,
    required this.unavailableRanges,
    this.minStay = 2,
    this.maxStay = 30,
  });

  final String propertyId;
  final List<UnavailableDateRange> unavailableRanges;
  final int minStay;
  final int maxStay;

  factory PropertyAvailability.fromJson(Map<String, dynamic> json) {
    final propertyId = json['propertyId'];
    if (propertyId is! String || propertyId.trim().isEmpty) {
      throw const FormatException('PropertyAvailability requires a non-empty propertyId string');
    }
    final rawRanges = json['unavailableRanges'];
    if (rawRanges is! List) {
      throw const FormatException('PropertyAvailability requires an unavailableRanges list');
    }
    final ranges = <UnavailableDateRange>[];
    for (final raw in rawRanges) {
      if (raw is Map<String, dynamic>) {
        ranges.add(UnavailableDateRange.fromJson(raw));
      } else {
        throw const FormatException('Malformed unavailable range item');
      }
    }

    final minStay = json['minStay'] is int ? json['minStay'] as int : 2;
    final maxStay = json['maxStay'] is int ? json['maxStay'] as int : 30;

    return PropertyAvailability(
      propertyId: propertyId,
      unavailableRanges: List.unmodifiable(ranges),
      minStay: minStay,
      maxStay: maxStay,
    );
  }

  /// Checks if a single [date] is blocked (either in past or inside an unavailable range).
  bool isDateBlocked(DateTime date, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final d = DateTime.utc(date.year, date.month, date.day);
    final t = DateTime.utc(today.year, today.month, today.day);
    if (d.isBefore(t)) return true;

    for (final range in unavailableRanges) {
      if (range.containsDate(d)) return true;
    }
    return false;
  }

  /// Checks if the range [checkIn] to [checkOut] overlaps any unavailable dates.
  bool hasConflict(DateTime checkIn, DateTime checkOut) {
    for (final range in unavailableRanges) {
      if (range.overlaps(checkIn, checkOut)) return true;
    }
    return false;
  }
}

/// Server-authoritative quote calculation result.
class BookingQuote {
  const BookingQuote({
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.guests,
    required this.pricePerNight,
    required this.totalStay,
    required this.depositAmount,
    required this.remainingAmount,
    required this.currency,
    required this.quoteFingerprint,
  });

  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final int guests;
  final double pricePerNight;
  final double totalStay;
  final double depositAmount;
  final double remainingAmount;
  final String currency;
  final String quoteFingerprint;

  factory BookingQuote.fromJson(Map<String, dynamic> json) {
    final propertyId = json['propertyId'];
    if (propertyId is! String || propertyId.trim().isEmpty) {
      throw const FormatException('BookingQuote requires a non-empty propertyId');
    }
    final rawIn = json['checkIn'];
    final rawOut = json['checkOut'];
    if (rawIn is! String || rawOut is! String) {
      throw const FormatException('BookingQuote requires checkIn and checkOut strings');
    }
    final inDate = DateTime.tryParse(rawIn);
    final outDate = DateTime.tryParse(rawOut);
    if (inDate == null || outDate == null) {
      throw const FormatException('Invalid BookingQuote date format');
    }
    final inCivil = DateTime.utc(inDate.year, inDate.month, inDate.day);
    final outCivil = DateTime.utc(outDate.year, outDate.month, outDate.day);
    if (!outCivil.isAfter(inCivil)) {
      throw const FormatException('BookingQuote checkOut must be strictly after checkIn');
    }

    final nights = json['nights'];
    if (nights is! int || nights < 2 || nights > 30) {
      throw const FormatException('Invalid BookingQuote nights (must be between 2 and 30)');
    }
    final calculatedNights = outCivil.difference(inCivil).inDays;
    if (calculatedNights != nights) {
      throw const FormatException('BookingQuote nights does not match date difference');
    }

    final guests = json['guests'];
    if (guests is! int || guests < 1) {
      throw const FormatException('Invalid BookingQuote guests');
    }

    final pricePerNight = json['pricePerNight'];
    if (pricePerNight is! num || !pricePerNight.isFinite || pricePerNight <= 0) {
      throw const FormatException('Invalid BookingQuote pricePerNight');
    }

    final totalStay = json['totalStay'];
    if (totalStay is! num || !totalStay.isFinite || totalStay <= 0) {
      throw const FormatException('Invalid BookingQuote totalStay');
    }

    final depositAmount = json['depositAmount'];
    if (depositAmount is! num || !depositAmount.isFinite || depositAmount <= 0) {
      throw const FormatException('Invalid BookingQuote depositAmount');
    }

    final remainingAmount = json['remainingAmount'];
    if (remainingAmount is! num || !remainingAmount.isFinite || remainingAmount < 0) {
      throw const FormatException('Invalid BookingQuote remainingAmount');
    }

    final currency = json['currency'];
    if (currency != 'EGP') {
      throw const FormatException('Unsupported BookingQuote currency');
    }

    final quoteFingerprint = json['quoteFingerprint'];
    if (quoteFingerprint is! String || quoteFingerprint.trim().isEmpty) {
      throw const FormatException('BookingQuote requires a non-empty quoteFingerprint');
    }

    return BookingQuote(
      propertyId: propertyId,
      checkIn: inCivil,
      checkOut: outCivil,
      nights: nights,
      guests: guests,
      pricePerNight: pricePerNight.toDouble(),
      totalStay: totalStay.toDouble(),
      depositAmount: depositAmount.toDouble(),
      remainingAmount: remainingAmount.toDouble(),
      currency: currency,
      quoteFingerprint: quoteFingerprint,
    );
  }
}
