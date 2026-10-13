import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../data/search_intent_models.dart';

/// Horizontally scrollable RTL row of active filter chips for Screen 05 (Search Results).
///
/// Features:
/// - Distinct dual-zone interaction on each chip:
///   1. Tap chip content -> Reopens editing interface preserving existing selections.
///   2. Tap explicit [×] -> Removes ONLY that specific filter/parameter and refreshes.
/// - 12dp corner radius, restrained neutral styling (`#F8FAFC` surface, `#E2E8F0` border).
/// - Strict Arabic RTL geometry: chip label on right, [×] icon on left.
/// - Minimum 44dp hit targets for accessible touch interaction.
class ActiveFilterChipsRow extends StatelessWidget {
  const ActiveFilterChipsRow({
    super.key,
    required this.intent,
    required this.onEditDestination,
    required this.onRemoveDestination,
    required this.onEditDates,
    required this.onRemoveDates,
    required this.onEditGuests,
    required this.onRemoveGuests,
    required this.onEditUnitTypes,
    required this.onRemoveUnitType,
    required this.onEditPrice,
    required this.onRemovePrice,
  });

  final SearchIntent intent;
  final VoidCallback onEditDestination;
  final ValueChanged<String> onRemoveDestination;
  final VoidCallback onEditDates;
  final VoidCallback onRemoveDates;
  final VoidCallback onEditGuests;
  final VoidCallback onRemoveGuests;
  final VoidCallback onEditUnitTypes;
  final ValueChanged<String> onRemoveUnitType;
  final VoidCallback onEditPrice;
  final VoidCallback onRemovePrice;

  static String _formatPrice(double price) {
    return NumberFormat('#,###', 'ar').format(price.round());
  }

  static String _unitTypeArabicLabel(String type) {
    final upper = type.trim().toUpperCase();
    switch (upper) {
      case 'CHALET':
        return 'شاليه';
      case 'VILLA':
        return 'فيلا';
      case 'APARTMENT':
        return 'شقة';
      case 'STUDIO':
        return 'استوديو';
      default:
        return type;
    }
  }

  static String _guestsLabel(int guests) {
    if (guests == 2) return 'ضيفان';
    if (guests >= 3 && guests <= 10) return '$guests ضيوف';
    return '$guests ضيف';
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    // 1. Destination chips (one per selected region)
    for (final region in intent.selectedRegions) {
      chips.add(
        _FilterChip(
          key: Key('active-filter-region-$region'),
          contentKey: Key('active-filter-content-region-$region'),
          removeKey: Key('active-filter-remove-region-$region'),
          label: region,
          accessibilityLabel: 'الوجهة: $region',
          onTapContent: onEditDestination,
          onTapRemove: () => onRemoveDestination(region),
        ),
      );
    }

    // 2. Dates chip
    if (intent.checkInDate != null || intent.checkOutDate != null) {
      chips.add(
        _FilterChip(
          key: const Key('active-filter-dates'),
          contentKey: const Key('active-filter-content-dates'),
          removeKey: const Key('active-filter-remove-dates'),
          label: intent.formattedDateRange ?? 'التواريخ',
          accessibilityLabel: 'تواريخ الإقامة: ${intent.formattedDateRange}',
          onTapContent: onEditDates,
          onTapRemove: onRemoveDates,
        ),
      );
    }

    // 3. Guest count chip
    if (intent.guestCount > 1) {
      chips.add(
        _FilterChip(
          key: const Key('active-filter-guests'),
          contentKey: const Key('active-filter-content-guests'),
          removeKey: const Key('active-filter-remove-guests'),
          label: _guestsLabel(intent.guestCount),
          accessibilityLabel: 'عدد الضيوف: ${_guestsLabel(intent.guestCount)}',
          onTapContent: onEditGuests,
          onTapRemove: onRemoveGuests,
        ),
      );
    }

    // 4. Unit type chips (one per selected type)
    for (final unitType in intent.selectedUnitTypes) {
      final label = _unitTypeArabicLabel(unitType);
      chips.add(
        _FilterChip(
          key: Key('active-filter-unit-type-$unitType'),
          contentKey: Key('active-filter-content-unit-$unitType'),
          removeKey: Key('active-filter-remove-unit-$unitType'),
          label: label,
          accessibilityLabel: 'نوع الوحدة: $label',
          onTapContent: onEditUnitTypes,
          onTapRemove: () => onRemoveUnitType(unitType),
        ),
      );
    }

    // 5. Price ceiling chip
    if (intent.maxPricePerNight != null) {
      chips.add(
        _FilterChip(
          key: const Key('active-filter-price'),
          contentKey: const Key('active-filter-content-price'),
          removeKey: const Key('active-filter-remove-price'),
          label: 'حتى ${_formatPrice(intent.maxPricePerNight!)} ج.م',
          accessibilityLabel:
              'أقصى سعر: حتى ${_formatPrice(intent.maxPricePerNight!)} جنيه مصري',
          onTapContent: onEditPrice,
          onTapRemove: onRemovePrice,
        ),
      );
    }

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 44,
      child: SingleChildScrollView(
        key: const Key('active-filters-scroll-view'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < chips.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              chips[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.contentKey,
    required this.removeKey,
    required this.label,
    required this.accessibilityLabel,
    required this.onTapContent,
    required this.onTapRemove,
  });

  final Key contentKey;
  final Key removeKey;
  final String label;
  final String accessibilityLabel;
  final VoidCallback onTapContent;
  final VoidCallback onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Chip Content (tap opens relevant editor)
          Semantics(
            button: true,
            label: 'تعديل $accessibilityLabel',
            child: InkWell(
              key: contentKey,
              onTap: onTapContent,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 6, 8),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),

          // 2. Explicit Remove Button (tap removes this parameter only)
          Semantics(
            button: true,
            label: 'إزالة $accessibilityLabel',
            child: InkWell(
              key: removeKey,
              onTap: onTapRemove,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 8, 10, 8),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
