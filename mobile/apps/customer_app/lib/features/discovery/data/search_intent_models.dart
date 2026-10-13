import 'package:intl/intl.dart';

import 'public_property.dart';
import 'public_property_search_repository.dart';

/// Models the customer's search intent across destinations, stay dates,
/// guest count, unit types, and price ceilings.
///
/// Invariant (MR-11 & P5/C2): Stay dates represent CUSTOMER INTENT ONLY.
/// They are never sent as query parameters to `/api/v1/customer/properties/search`.
class SearchIntent {
  const SearchIntent({
    this.selectedRegions = const [],
    this.checkInDate,
    this.checkOutDate,
    this.guestCount = 1,
    this.selectedUnitTypes = const [],
    this.maxPricePerNight,
  });

  /// The list of selected destination/resort names.
  final List<String> selectedRegions;

  /// Customer's intended check-in date (local Cairo calendar date).
  final DateTime? checkInDate;

  /// Customer's intended check-out date (local Cairo calendar date).
  final DateTime? checkOutDate;

  /// Intended number of guests (minimum 1).
  final int guestCount;

  /// List of selected unit types (e.g. 'CHALET', 'VILLA', 'APARTMENT', 'STUDIO').
  /// Empty list means all unit types are acceptable.
  final List<String> selectedUnitTypes;

  /// Maximum budget per night in EGP. Null means unbounded ("بدون حد أقصى").
  final double? maxPricePerNight;

  /// Default clean search intent.
  static const empty = SearchIntent();

  /// Whether any filter parameter deviates from defaults.
  bool get hasActiveFilters =>
      selectedRegions.isNotEmpty ||
      checkInDate != null ||
      checkOutDate != null ||
      guestCount > 1 ||
      selectedUnitTypes.isNotEmpty ||
      maxPricePerNight != null;

  /// Whether both check-in and check-out are specified and valid.
  bool get hasValidDates {
    if (checkInDate == null || checkOutDate == null) return false;
    final inCivil = DateTime.utc(
      checkInDate!.year,
      checkInDate!.month,
      checkInDate!.day,
    );
    final outCivil = DateTime.utc(
      checkOutDate!.year,
      checkOutDate!.month,
      checkOutDate!.day,
    );
    final nights = outCivil.difference(inCivil).inDays;
    return nights >= 2 && nights <= 30;
  }

  /// Total number of nights for the selected date range.
  int get stayNights {
    if (checkInDate == null || checkOutDate == null) return 0;
    final inCivil = DateTime.utc(
      checkInDate!.year,
      checkInDate!.month,
      checkInDate!.day,
    );
    final outCivil = DateTime.utc(
      checkOutDate!.year,
      checkOutDate!.month,
      checkOutDate!.day,
    );
    final diff = outCivil.difference(inCivil).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Dynamic primary summary text for destinations.
  String get destinationSummaryText {
    if (selectedRegions.isEmpty) {
      return 'إلى أين؟';
    }
    if (selectedRegions.length == 1) {
      return selectedRegions.first;
    }
    if (selectedRegions.length == 2) {
      return '${selectedRegions[0]}، ${selectedRegions[1]}';
    }
    final remaining = selectedRegions.length - 1;
    return '${selectedRegions.first} + $remaining مناطق';
  }

  /// Formatted Arabic date range display string.
  String? get formattedDateRange {
    if (checkInDate == null && checkOutDate == null) return null;
    final format = DateFormat('d MMM', 'ar');
    if (checkInDate != null && checkOutDate != null) {
      return '${format.format(checkInDate!)} - ${format.format(checkOutDate!)} ($stayNights ليالٍ)';
    }
    if (checkInDate != null) {
      return 'من ${format.format(checkInDate!)}';
    }
    return null;
  }

  /// Converts this search intent into query filters for the public search endpoint.
  /// Note: Dates are deliberately excluded per MR-11.
  PublicPropertySearchFilters toSearchFilters() {
    return PublicPropertySearchFilters(
      destinations: selectedRegions,
      unitType: selectedUnitTypes.length == 1 ? selectedUnitTypes.first : '',
      guests: guestCount > 1 ? guestCount : null,
      maxPrice: maxPricePerNight,
    );
  }

  SearchIntent copyWith({
    List<String>? selectedRegions,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    bool clearCheckIn = false,
    bool clearCheckOut = false,
    int? guestCount,
    List<String>? selectedUnitTypes,
    double? maxPricePerNight,
    bool clearMaxPrice = false,
  }) {
    return SearchIntent(
      selectedRegions: selectedRegions ?? this.selectedRegions,
      checkInDate: clearCheckIn ? null : (checkInDate ?? this.checkInDate),
      checkOutDate: clearCheckOut ? null : (checkOutDate ?? this.checkOutDate),
      guestCount: guestCount ?? this.guestCount,
      selectedUnitTypes: selectedUnitTypes ?? this.selectedUnitTypes,
      maxPricePerNight: clearMaxPrice
          ? null
          : (maxPricePerNight ?? this.maxPricePerNight),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchIntent) return false;
    if (selectedRegions.length != other.selectedRegions.length) return false;
    for (var i = 0; i < selectedRegions.length; i++) {
      if (selectedRegions[i] != other.selectedRegions[i]) return false;
    }
    if (selectedUnitTypes.length != other.selectedUnitTypes.length) {
      return false;
    }
    for (var i = 0; i < selectedUnitTypes.length; i++) {
      if (selectedUnitTypes[i] != other.selectedUnitTypes[i]) return false;
    }
    return checkInDate == other.checkInDate &&
        checkOutDate == other.checkOutDate &&
        guestCount == other.guestCount &&
        maxPricePerNight == other.maxPricePerNight;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(selectedRegions),
    checkInDate,
    checkOutDate,
    guestCount,
    Object.hashAll(selectedUnitTypes),
    maxPricePerNight,
  );
}

/// Metadata extracted dynamically from authentic published properties feed.
class FilterMetadata {
  const FilterMetadata({
    this.availableDestinations = const [],
    this.availableUnitTypes = const [],
    this.minInventoryPrice = 0,
    this.maxInventoryPrice = 0,
    this.minBudget = 1000,
    this.maxBudget = 50000,
    this.priceCeiling,
  });

  final List<String> availableDestinations;
  final List<String> availableUnitTypes;
  final double minInventoryPrice;
  final double maxInventoryPrice;
  final double minBudget;
  final double maxBudget;
  final double? priceCeiling;

  /// Harvests filter metadata dynamically from authentic property listings.
  factory FilterMetadata.fromProperties(
    List<PublicProperty> properties, {
    List<String>? selectedDestinations,
  }) {
    final destinationSet = <String>{};
    final unitTypeSet = <String>{};

    for (final p in properties) {
      if (p.resortName != null && p.resortName!.trim().isNotEmpty) {
        destinationSet.add(p.resortName!.trim());
      }
      if (p.region != null && p.region!.trim().isNotEmpty) {
        destinationSet.add(p.region!.trim());
      }
      if (p.unitType.trim().isNotEmpty && p.unitType.toUpperCase() != 'ALL') {
        unitTypeSet.add(p.unitType.trim().toUpperCase());
      }
    }

    final sortedDestinations = destinationSet.toList()
      ..sort((a, b) => a.compareTo(b));
    final sortedTypes = unitTypeSet.toList()..sort();

    // Determine relevant discovery scope for price bounds
    var priceTargetProperties = properties;
    if (selectedDestinations != null && selectedDestinations.isNotEmpty) {
      final filtered = properties.where((p) {
        final resort = p.resortName?.trim().toLowerCase() ?? '';
        final reg = p.region?.trim().toLowerCase() ?? '';
        return selectedDestinations.any((d) {
          final target = d.trim().toLowerCase();
          return resort.contains(target) ||
              reg.contains(target) ||
              target.contains(resort) ||
              target.contains(reg);
        });
      }).toList();
      if (filtered.isNotEmpty) {
        priceTargetProperties = filtered;
      }
    }

    double realMin = 0;
    double realMax = 0;
    bool hasPrice = false;

    for (final p in priceTargetProperties) {
      if (p.basePricePerNight > 0) {
        if (!hasPrice) {
          realMin = p.basePricePerNight;
          realMax = p.basePricePerNight;
          hasPrice = true;
        } else {
          if (p.basePricePerNight < realMin) realMin = p.basePricePerNight;
          if (p.basePricePerNight > realMax) realMax = p.basePricePerNight;
        }
      }
    }

    // Rounding rule:
    // minBudget = floor(realMinNightlyPrice / 1000) * 1000
    // maxBudget = ceil(realMaxNightlyPrice / 1000) * 1000
    double computedMinBudget;
    double computedMaxBudget;

    if (hasPrice) {
      computedMinBudget = (realMin / 1000).floor() * 1000.0;
      if (computedMinBudget < 1000) computedMinBudget = 1000;

      computedMaxBudget = (realMax / 1000).ceil() * 1000.0;
      if (computedMaxBudget <= computedMinBudget) {
        computedMaxBudget = computedMinBudget + 1000;
      }
    } else {
      computedMinBudget = 1000;
      computedMaxBudget = 50000;
    }

    return FilterMetadata(
      availableDestinations: sortedDestinations,
      availableUnitTypes: sortedTypes,
      minInventoryPrice: realMin,
      maxInventoryPrice: realMax,
      minBudget: computedMinBudget,
      maxBudget: computedMaxBudget,
      priceCeiling: computedMaxBudget,
    );
  }
}

/// Coastal Egyptian regional grouping for curated browsing.
class CoastalRegionGroup {
  const CoastalRegionGroup({
    required this.name,
    required this.subtitle,
    required this.knownResorts,
  });

  final String name;
  final String subtitle;
  final List<String> knownResorts;

  static const List<CoastalRegionGroup> canonicalGroups = [
    CoastalRegionGroup(
      name: 'الساحل الشمالي',
      subtitle: 'سيدي عبد الرحمن، رأس الحكمة، والعلمين',
      knownResorts: [
        'مراسي',
        'هاسيندا باي',
        'هاسيندا وايت',
        'هاسيندا ريد',
        'أمواج',
        'سي شيل',
        'فوكا باي',
        'ماونتن فيو',
        'رأس الحكمة',
        'العلمين الجديدة',
        'مارينا',
        'سيدي حنيش',
        'مطروح',
      ],
    ),
    CoastalRegionGroup(
      name: 'العين السخنة',
      subtitle: 'طريق الزعفرانة وجبل الجلالة',
      knownResorts: [
        'تلال',
        'المونت جلالة',
        'أروما',
        'لافيستا',
        'عين باي',
        'بورتو السخنة',
        'السويس',
      ],
    ),
    CoastalRegionGroup(
      name: 'البحر الأحمر',
      subtitle: 'الجونة، سهل حشيش، ومكادي',
      knownResorts: [
        'الجونة',
        'سهل حشيش',
        'مكادي هايتس',
        'سوما باي',
        'الغردقة',
        'شرم الشيخ',
      ],
    ),
  ];

  /// Categorizes a list of authentic destinations into coastal groups.
  static Map<String, List<String>> categorize(List<String> destinations) {
    final result = <String, List<String>>{};
    final remaining = List<String>.from(destinations);

    for (final group in canonicalGroups) {
      final matches = <String>[];
      for (final dest in destinations) {
        final matchesKnown = group.knownResorts.any(
          (known) =>
              dest.contains(known) ||
              known.contains(dest) ||
              dest.toLowerCase().contains(known.toLowerCase()),
        );
        if (matchesKnown && !matches.contains(dest)) {
          matches.add(dest);
          remaining.remove(dest);
        }
      }
      if (matches.isNotEmpty) {
        result[group.name] = matches;
      }
    }

    if (remaining.isNotEmpty) {
      result['وجهات أخرى'] = remaining;
    }

    return result;
  }
}
