import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

/// Directionality-isolated monetary display component for KONFRM.
///
/// Guarantees that currency is always displayed AFTER the number (e.g. '13,500 ج.م'),
/// preventing the Unicode Bidirectional Algorithm (UBA) from reversing the pair
/// when rendered inside an Arabic (RTL) context.
class KonfrmPriceText extends StatelessWidget {
  const KonfrmPriceText({
    super.key,
    required this.amount,
    this.currency = 'ج.م',
    this.style,
    this.amountStyle,
    this.currencyStyle,
    this.spacing = 4.0,
    this.isStrikethrough = false,
  });

  final num amount;
  final String currency;
  final TextStyle? style;
  final TextStyle? amountStyle;
  final TextStyle? currencyStyle;
  final double spacing;
  final bool isStrikethrough;

  static final _numberFormat = NumberFormat('#,##0.##', 'en');

  /// Formats an amount into an isolated RTL string: `13,500 ج.م`
  /// with numeric amount on the RIGHT and currency on the LEFT.
  static String formatString(num amount, {String currency = 'ج.م'}) {
    final formatted = _numberFormat.format(amount);
    return '\u2067\u2066$formatted\u2069\u00A0$currency\u2069';
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _numberFormat.format(amount);
    final effectiveAmountStyle = (amountStyle ?? style)?.copyWith(
      decoration: isStrikethrough ? TextDecoration.lineThrough : null,
    );
    final effectiveCurrencyStyle = (currencyStyle ?? style)?.copyWith(
      decoration: isStrikethrough ? TextDecoration.lineThrough : null,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // Amount placed on the RIGHT (start of RTL row) with isolated LTR numeric digits
          Text(
            formatted,
            style: effectiveAmountStyle,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(width: spacing),
          // Currency symbol placed to the LEFT of the number
          Text(
            currency,
            style: effectiveCurrencyStyle,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
