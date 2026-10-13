import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Price ceiling slider for Screen 04 (Search & Refine).
///
/// Implements Founder-approved truthful, dynamic budget with rounding rule:
/// - minBudget = floor(realMinNightlyPrice / 1000) * 1000
/// - maxBudget = ceil(realMaxNightlyPrice / 1000) * 1000
/// - Upper tick snaps to "بدون حد أقصى" (unbounded, null maxPrice).
class PriceCeilingSlider extends StatelessWidget {
  const PriceCeilingSlider({
    super.key,
    required this.maxPrice,
    this.minBudget = 1000,
    this.maxBudget = 50000,
    this.maxInventoryPrice,
    required this.onChanged,
  });

  /// The active max price per night, or null if unbounded.
  final double? maxPrice;

  /// Lower rounded boundary from real inventory.
  final double minBudget;

  /// Upper rounded boundary from real inventory.
  final double maxBudget;

  /// Optional fallback ceiling parameter for backward compatibility.
  final double? maxInventoryPrice;

  /// Callback when price ceiling changes. Null represents unbounded.
  final ValueChanged<double?> onChanged;

  static final _currencyFormat = NumberFormat('#,##0', 'en');

  double get _effectiveMin => minBudget > 0 ? minBudget : 1000.0;

  double get _effectiveMax {
    if (maxBudget > _effectiveMin) return maxBudget;
    if (maxInventoryPrice != null && maxInventoryPrice! > _effectiveMin) {
      return maxInventoryPrice!;
    }
    return 50000.0;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMin = _effectiveMin;
    final effectiveMax = _effectiveMax;
    final sliderMax = effectiveMax + 1000;
    final currentSliderValue = maxPrice == null
        ? sliderMax
        : maxPrice!.clamp(effectiveMin, effectiveMax);

    final isUnbounded = maxPrice == null || currentSliderValue >= sliderMax;
    final divisions = ((sliderMax - effectiveMin) / 1000).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & State Readout Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'أقصى سعر لليلة (اختياري)',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Formatted price display with directionality isolation
            Directionality(
              textDirection: TextDirection.rtl,
              child: isUnbounded
                  ? const Text(
                      'بدون حد أقصى',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    )
                  : Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'حتى ',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          TextSpan(
                            text: _currencyFormat.format(maxPrice),
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const TextSpan(
                            text: ' ج.م',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Slider Control: muted grey when unbounded, black when active ceiling
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: isUnbounded
                ? const Color(0xFF94A3B8)
                : const Color(0xFF000000),
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: isUnbounded
                ? const Color(0xFF94A3B8)
                : const Color(0xFF000000),
            overlayColor: isUnbounded
                ? const Color(0x1F94A3B8)
                : const Color(0x1F000000),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            key: const Key('price-ceiling-slider'),
            value: currentSliderValue,
            min: effectiveMin,
            max: sliderMax,
            divisions: divisions > 0 ? divisions : 1,
            onChanged: (val) {
              if (val >= sliderMax) {
                onChanged(null); // Unbounded
              } else {
                onChanged(val);
              }
            },
          ),
        ),

        // Boundary labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currencyFormat.format(effectiveMin)} ج.م',
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const Text(
                'بدون حد أقصى',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
