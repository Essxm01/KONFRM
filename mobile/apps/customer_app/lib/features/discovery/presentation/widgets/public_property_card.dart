import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../../booking_review/presentation/widgets/konfrm_price_text.dart';
import '../../../property_details/presentation/property_details_view.dart';
import '../../data/public_property.dart';
import '../../data/search_intent_models.dart';

/// Shared, Founder-approved compact property card used across Screen 03 (Explore)
/// and Screen 05 (Search Results).
///
/// Features:
/// - 1.45 aspect ratio real property imagery with graceful placeholder fallback
/// - Floating favorite heart action with 48dp touch target
/// - Arabic title (16px bold, max 2 lines)
/// - Location line with pin icon
/// - Compact unboxed facts row (unit type, bedrooms, bathrooms, guests)
/// - Nightly price with strict RTL numeric and currency presentation (`X,XXX ج.م / ليلة`)
/// - Direct navigation to Screen 06 (Property Details) preserving search intent
class PublicPropertyCard extends StatelessWidget {
  const PublicPropertyCard({
    super.key,
    required this.property,
    this.intent,
    this.onTap,
  });

  final PublicProperty property;
  final SearchIntent? intent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final location = [property.resortName, property.region, property.address]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toSet()
        .join('، ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: StructuralContainer(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          excludeFromSemantics: true,
          behavior: HitTestBehavior.opaque,
          onTap:
              onTap ??
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsView(
                      propertyId: property.id,
                      initialProperty: property,
                      initialCheckIn: intent?.checkInDate,
                      initialCheckOut: intent?.checkOutDate,
                      initialGuests: (intent != null && intent!.guestCount > 1)
                          ? intent!.guestCount
                          : null,
                    ),
                  ),
                );
              },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image + Vignette Scrim + Favorite Action
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.45,
                      child: property.images.isEmpty
                          ? const PropertyImagePlaceholder()
                          : Image.network(
                              property.images.first.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const PropertyImagePlaceholder(),
                            ),
                    ),
                    // Subtle vignette gradient for upper controls
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.22),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Favorite Heart Action (48dp touch target, top-left in RTL)
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: FavoriteHeartButton(
                        propertyId: property.id,
                        propertyTitle: property.title,
                      ),
                    ),
                  ],
                ),
              ),
              // Compact Content Block
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Property Name / Title
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Secondary Location Line
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Compact Unboxed Property Facts Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_informativeUnitType(
                              property.unitType,
                              property.propertyType,
                            ) !=
                            null)
                          PropertyFactItem(
                            icon: Icons.home_outlined,
                            label: _informativeUnitType(
                              property.unitType,
                              property.propertyType,
                            )!,
                          ),
                        PropertyFactItem(
                          icon: Icons.bed_outlined,
                          label: '${property.bedrooms} غرف نوم',
                        ),
                        PropertyFactItem(
                          icon: Icons.bathtub_outlined,
                          label: '${property.bathrooms} حمام',
                        ),
                        PropertyFactItem(
                          icon: Icons.people_outline,
                          label: '${property.maxGuests} ضيوف',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Prominent Nightly Price Anchor
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      textDirection: ui.TextDirection.rtl,
                      children: [
                        KonfrmPriceText(
                          amount: property.basePricePerNight,
                          amountStyle: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                          currencyStyle: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                        ),
                        const Text(
                          '/ ليلة',
                          textDirection: ui.TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _informativeUnitType(String unitType, String? propertyType) {
    final candidates = [unitType, propertyType ?? ''];
    for (final raw in candidates) {
      final normalized = raw.trim().toUpperCase();
      if (normalized.isEmpty) continue;
      switch (normalized) {
        case 'CHALET':
        case 'شاليه':
          return 'شاليه';
        case 'VILLA':
        case 'فيلا':
          return 'فيلا';
        case 'APARTMENT':
        case 'شقة':
          return 'شقة';
        case 'STUDIO':
        case 'استوديو':
          return 'استوديو';
        case 'CABIN':
        case 'كوخ':
          return 'كوخ';
        case 'TOWNHOUSE':
        case 'تاون هاوس':
          return 'تاون هاوس';
        case 'PENTHOUSE':
        case 'بنتهاوس':
          return 'بنتهاوس';
        case 'TWINHOUSE':
        case 'توين هاوس':
          return 'توين هاوس';
        case 'DUPLEX':
        case 'دوبلكس':
          return 'دوبلكس';
      }
    }
    return null;
  }
}

class FavoriteHeartButton extends StatefulWidget {
  const FavoriteHeartButton({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
  });

  final String propertyId;
  final String propertyTitle;

  @override
  State<FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<FavoriteHeartButton> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'تمت إضافة "${widget.propertyTitle}" إلى المفضلة (جلسة حالية).'
              : 'تمت إزالة "${widget.propertyTitle}" من المفضلة.',
          textDirection: ui.TextDirection.rtl,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
      child: GestureDetector(
        key: Key('property-favorite-heart-${widget.propertyId}'),
        behavior: HitTestBehavior.opaque,
        onTap: _toggleFavorite,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.92),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 20,
                  color: _isFavorite
                      ? const Color(0xFFE34154)
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PropertyFactItem extends StatelessWidget {
  const PropertyFactItem({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class PropertyImagePlaceholder extends StatelessWidget {
  const PropertyImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Color(0xFFF1F5F9),
    child: Center(
      child: Icon(Icons.image_rounded, size: 36, color: Color(0xFF64748B)),
    ),
  );
}
