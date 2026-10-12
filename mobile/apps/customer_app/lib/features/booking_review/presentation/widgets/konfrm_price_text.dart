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

  /// Formats an amount into an isolated LTR string: `13,500 ج.م`
  static String formatString(num amount, {String currency = 'ج.م'}) {
    final formatted = _numberFormat.format(amount);
    return '\u2066$formatted\u00A0$currency\u2069';
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
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            formatted,
            style: effectiveAmountStyle,
          ),
          SizedBox(width: spacing),
          Text(
            currency,
            style: effectiveCurrencyStyle,
          ),
        ],
      ),
    );
  }
}
