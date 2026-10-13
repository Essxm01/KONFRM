import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Interactive stay dates intent picker for Screen 04 (Search & Refine).
///
/// Invariant (MR-11 & P5/C2): Stay dates represent CUSTOMER INTENT ONLY.
/// They are never sent as query parameters to `/api/v1/customer/properties/search`.
class StayDatesIntentPicker extends StatelessWidget {
  const StayDatesIntentPicker({
    super.key,
    this.checkInDate,
    this.checkOutDate,
    required this.onDatesChanged,
    required this.onClearDates,
  });

  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final void Function(DateTime? checkIn, DateTime? checkOut) onDatesChanged;
  final VoidCallback onClearDates;

  int get _nights {
    if (checkInDate == null || checkOutDate == null) return 0;
    final inCivil = DateTime.utc(
      checkInDate!.year,
      checkInDate!.month,
      checkInDate!.day,
    );
    final outCivil = DateTime.utc(
      checkOutDate!.year,
      checkOutDate!.month,
      checkOutDate!.day,
    );
    final diff = outCivil.difference(inCivil).inDays;
    return diff > 0 ? diff : 0;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'تحديد التاريخ';
    return DateFormat('EEE، d MMM', 'ar').format(date);
  }

  Future<void> _pickDates(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = firstDate.add(const Duration(days: 365));

    DateTimeRange? initialRange;
    if (checkInDate != null && checkOutDate != null) {
      initialRange = DateTimeRange(start: checkInDate!, end: checkOutDate!);
    }

    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialRange,
      locale: const Locale('ar'),
      helpText: 'اختر تواريخ إقامتك المبدئية',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      saveText: 'تأكيد',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF000000),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF000000),
                textStyle: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      final nights = picked.end.difference(picked.start).inDays;
      if (nights < 2) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الحد الأدنى للإقامة ليلتان'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      if (nights > 30) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الحد الأقصى للإقامة 30 ليلة'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      onDatesChanged(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDates = checkInDate != null && checkOutDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'تواريخ الإقامة (اختياري)',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            if (hasDates)
              TextButton(
                key: const Key('dates-clear-button'),
                onPressed: onClearDates,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'مسح التواريخ',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Two-column date display cards
        InkWell(
          key: const Key('stay-dates-picker-trigger'),
          onTap: () => _pickDates(context),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              // Check-in card
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 64),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasDates
                          ? const Color(0xFF000000)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'الوصول',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(checkInDate),
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: checkInDate != null
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Check-out card
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 64),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasDates
                          ? const Color(0xFF000000)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'المغادرة',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(checkOutDate),
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: checkOutDate != null
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Stay badge & explanatory caption
        const SizedBox(height: 6),
        if (hasDates)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$_nights ليالٍ · تواريخ بحثك المبدئية',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
          )
        else
          const Text(
            'تواريخ بحث مبدئية — يتم التحقق من الإتاحة الفعلية عند فتح تفاصيل الوحدة.',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
      ],
    );
  }
}
