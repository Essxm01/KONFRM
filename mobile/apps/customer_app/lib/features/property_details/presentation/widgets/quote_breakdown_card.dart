import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../../booking_review/presentation/widgets/konfrm_price_text.dart';
import '../../data/property_details_models.dart';

class QuoteBreakdownCard extends StatelessWidget {
  const QuoteBreakdownCard({
    super.key,
    required this.selectedCheckIn,
    required this.selectedCheckOut,
    required this.isCalculating,
    required this.quote,
    required this.quoteError,
    required this.onRetryQuote,
  });

  final DateTime? selectedCheckIn;
  final DateTime? selectedCheckOut;
  final bool isCalculating;
  final BookingQuote? quote;
  final String? quoteError;
  final VoidCallback onRetryQuote;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading
        Text(
          'تفاصيل السعر',
          style: KonfrmTypography.sectionTitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF101723),
          ),
        ),

        const SizedBox(height: 11),

        // Quote Content Container
        Container(
          constraints: const BoxConstraints(minHeight: 61),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE8EDF2), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          alignment: Alignment.centerRight,
          child: _buildContent(context),
        ),

        const SizedBox(height: 10),

        // Concise Financial Microcopy (Founder Explicit Override)
        Text(
          'لا يتم الدفع عند إرسال الطلب؛ العربون بعد موافقة المالك.',
          style: KonfrmTypography.supporting.copyWith(
            color: const Color(0xFF63728A),
            fontSize: 11.5,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (selectedCheckIn == null) {
      return const Text(
        'حدد التواريخ لعرض إجمالي الإقامة.',
        style: TextStyle(
          color: Color(0xFF65738A),
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (selectedCheckOut == null) {
      return const Text(
        'اختار تاريخ المغادرة.',
        style: TextStyle(
          color: Color(0xFF65738A),
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (isCalculating) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF276EF1)),
            ),
          ),
          SizedBox(width: 9),
          Text(
            'جاري حساب السعر...',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              color: Color(0xFF516178),
            ),
          ),
        ],
      );
    }

    if (quoteError != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تعذّر حساب السعر',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                    color: Color(0xFF253348),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  quoteError!,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF7C899A),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onRetryQuote,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD7EE), width: 1),
                ),
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF165CCC),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (quote != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PriceRow(
            label: 'إجمالي الإقامة (${quote!.nights} ليالٍ)',
            amount: quote!.totalStay,
            isTotal: true,
          ),
          const SizedBox(height: 6),
          _PriceRow(
            label: 'العربون بعد موافقة المالك',
            amount: quote!.depositAmount,
          ),
          const SizedBox(height: 4),
          _PriceRow(
            label: 'المبلغ المتبقي',
            amount: quote!.remainingAmount,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final num amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 12.5 : 11.5,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: isTotal ? const Color(0xFF101723) : const Color(0xFF59697C),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: KonfrmPriceText(
            amount: amount,
            style: TextStyle(
              fontSize: isTotal ? 13 : 12,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
              color: const Color(0xFF101723),
            ),
          ),
        ),
      ],
    );
  }
}
