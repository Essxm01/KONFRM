import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../data/property_details_models.dart';

class PropertyStickyBar extends StatelessWidget {
  const PropertyStickyBar({
    super.key,
    required this.basePricePerNight,
    required this.hasCheckIn,
    required this.hasCheckOut,
    required this.isCalculating,
    required this.hasQuoteError,
    required this.quote,
    required this.onTapCta,
  });

  final double basePricePerNight;
  final bool hasCheckIn;
  final bool hasCheckOut;
  final bool isCalculating;
  final bool hasQuoteError;
  final BookingQuote? quote;
  final VoidCallback onTapCta;

  static final _currencyFormat = NumberFormat('#,##0.##', 'en');

  @override
  Widget build(BuildContext context) {
    // 1. Determine Sticky Label & Value
    final String label;
    final String value;

    if (quote != null) {
      label = 'إجمالي الإقامة';
      value = '${_currencyFormat.format(quote!.totalStay)} ج.م';
    } else if (hasCheckIn && hasCheckOut && (isCalculating || hasQuoteError)) {
      label = 'إجمالي الإقامة';
      value = '—';
    } else {
      label = 'السعر الأساسي لليلة';
      value = '${_currencyFormat.format(basePricePerNight)} ج.م';
    }

    // 2. Determine CTA Button Label & Enabled State
    final String ctaText;
    final bool isEnabled;

    if (!hasCheckIn) {
      ctaText = 'اختيار التواريخ';
      isEnabled = true;
    } else if (!hasCheckOut) {
      ctaText = 'اختيار تاريخ المغادرة';
      isEnabled = true;
    } else if (isCalculating) {
      ctaText = 'جاري حساب السعر...';
      isEnabled = false;
    } else if (hasQuoteError) {
      ctaText = 'إعادة حساب السعر';
      isEnabled = true;
    } else {
      ctaText = 'مراجعة طلب الحجز';
      isEnabled = true;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEDF0F5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1D34).withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              // Price Copy
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF7F8A9A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          value,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF101721),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Action CTA Button
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxWidth: 160,
                ),
                child: ElevatedButton(
                  onPressed: isEnabled ? onTapCta : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101721),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF101721).withValues(alpha: 0.6),
                    disabledForegroundColor: Colors.white70,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      ctaText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
