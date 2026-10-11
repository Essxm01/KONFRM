/// Allowlisted representation of the public property search DTO.
///
/// Fields that are not part of the public API contract are deliberately not
/// retained, even if a server response accidentally includes them.
class PublicProperty {
  const PublicProperty({
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

  static const _requiredStrings = ['id', 'title', 'unitType'];

  factory PublicProperty.fromJson(Map<String, dynamic> json) {
    for (final key in _requiredStrings) {
      if (json[key] is! String || (json[key] as String).trim().isEmpty) {
        throw const FormatException('Invalid public property string field.');
      }
    }
    if (json['address'] is! String) {
      throw const FormatException('Invalid public property address.');
    }

    final bedrooms = _integer(json['bedrooms'], allowZero: true);
    final bathrooms = _integer(json['bathrooms'], allowZero: true);
    final maxGuests = _integer(json['maxGuests'], allowZero: false);
    final rawPrice = json['basePricePerNight'];
    if (rawPrice is! num || !rawPrice.isFinite || rawPrice <= 0) {
      throw const FormatException('Invalid public property price.');
    }
    if (json['currency'] != 'EGP') {
      throw const FormatException('Unsupported public property currency.');
    }

    final rawImages = json['images'];
    if (rawImages is! List) {
      throw const FormatException('Invalid public property images.');
    }
    final images = <Uri>[];
    for (final rawImage in rawImages) {
      if (rawImage is! String) {
        throw const FormatException('Invalid public property image URL.');
      }
      final uri = Uri.tryParse(rawImage);
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty) {
        throw const FormatException('Invalid public property image URL.');
      }
      images.add(uri);
    }

    return PublicProperty(
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
    return value.trim().isEmpty ? null : value;
  }
}
