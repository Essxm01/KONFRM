import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Price ceiling slider for Screen 04 (Search & Refine).
///
/// Implements Option A approved behavior:
/// The upper tick snaps to "بدون حد أقصى" (unbounded, null maxPrice).
class PriceCeilingSlider extends StatelessWidget {
  const PriceCeilingSlider({
    super.key,
    required this.maxPrice,
    this.maxInventoryPrice,
    required this.onChanged,
  });

  /// The active max price per night, or null if unbounded.
  final double? maxPrice;

  /// Dynamic ceiling from inventory, defaulting to 50,000 EGP.
  final double? maxInventoryPrice;

  /// Callback when price ceiling changes. Null represents unbounded.
  final ValueChanged<double?> onChanged;

  static final _currencyFormat = NumberFormat('#,##0', 'en');

  double get _effectiveCeiling {
    if (maxInventoryPrice != null && maxInventoryPrice! > 5000) {
      return maxInventoryPrice!;
    }
    return 50000;
  }

  @override
  Widget build(BuildContext context) {
    final ceiling = _effectiveCeiling;
    // Map slider value: min is 1000, max is ceiling + 1000 (representing unbounded)
    final sliderMax = ceiling + 1000;
    final currentSliderValue = maxPrice == null
        ? sliderMax
        : maxPrice!.clamp(1000.0, ceiling);

    final isUnbounded = maxPrice == null || currentSliderValue >= sliderMax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ميزانية الليلة',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            // Formatted price display with directionality isolation
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text.rich(
                TextSpan(
                  children: isUnbounded
                      ? const [
                          TextSpan(
                            text: 'بدون حد أقصى',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ]
                      : [
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
                          const TextSpan(
                            text: ' / ليلة',
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Slider Control
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF000000),
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: const Color(0xFF000000),
            overlayColor: const Color(0x1F000000),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            key: const Key('price-ceiling-slider'),
            value: currentSliderValue,
            min: 1000,
            max: sliderMax,
            divisions: (sliderMax - 1000) ~/ 1000,
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1,000 ج.م',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
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
