import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../data/search_intent_models.dart';

/// Compact Search Summary Bar for Screen 05 (Search Results).
///
/// Features:
/// - Displays concise primary destination and secondary parameter summary.
/// - Unobtrusive vertical footprint (~52dp) preserving maximum early viewport for photography.
/// - Tapping opens Screen 04 (`SearchRefineView`) to modify search filters.
/// - Restrained neutral styling with 12dp border radius.
class SearchResultsSummaryBar extends StatelessWidget {
  const SearchResultsSummaryBar({
    super.key,
    required this.intent,
    required this.onTap,
  });

  final SearchIntent intent;
  final VoidCallback onTap;

  static String _formatPrice(double price) {
    return NumberFormat('#,###', 'ar').format(price.round());
  }

  static String _unitTypeLabel(String type) {
    switch (type.trim().toUpperCase()) {
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

  String _buildSecondarySummary() {
    final parts = <String>[];
    if (intent.formattedDateRange != null) {
      parts.add(intent.formattedDateRange!);
    }
    if (intent.guestCount > 1) {
      parts.add(intent.guestCount == 2 ? 'ضيفان' : '${intent.guestCount} ضيوف');
    }
    if (intent.selectedUnitTypes.isNotEmpty) {
      if (intent.selectedUnitTypes.length == 1) {
        parts.add(_unitTypeLabel(intent.selectedUnitTypes.first));
      } else {
        parts.add('${intent.selectedUnitTypes.length} أنواع وحدات');
      }
    }
    if (intent.maxPricePerNight != null) {
      parts.add('حتى ${_formatPrice(intent.maxPricePerNight!)} ج.م');
    }

    if (parts.isEmpty) {
      return 'انقر لتعديل البحث';
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final primaryTitle = intent.selectedRegions.isNotEmpty
        ? intent.destinationSummaryText
        : 'جميع الوجهات';
    final secondarySummary = _buildSecondarySummary();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        button: true,
        label: 'تعديل معايير البحث: $primaryTitle، $secondarySummary',
        child: InkWell(
          key: const Key('search-results-summary-bar'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Search Icon
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Color(0xFF0F172A),
                ),
                const SizedBox(width: 10),

                // Text Summary Column
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryTitle,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        secondarySummary,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Tune / Edit Indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
