import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../data/property_details_models.dart';

class InlineAvailabilityCalendar extends StatelessWidget {
  const InlineAvailabilityCalendar({
    super.key,
    required this.currentMonth,
    required this.availability,
    required this.isLoadingAvailability,
    required this.availabilityError,
    required this.selectedCheckIn,
    required this.selectedCheckOut,
    required this.calendarError,
    required this.onSelectDate,
    required this.onNextMonth,
    required this.onPreviousMonth,
    required this.onRetryAvailability,
  });

  final DateTime currentMonth;
  final PropertyAvailability? availability;
  final bool isLoadingAvailability;
  final String? availabilityError;
  final DateTime? selectedCheckIn;
  final DateTime? selectedCheckOut;
  final String? calendarError;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onNextMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onRetryAvailability;

  static const _monthNames = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];

  static const _weekDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت'
  ];

  String _formatDateValue(DateTime? date) {
    if (date == null) return 'اختار التاريخ';
    final monthName = _monthNames[date.month - 1];
    return '${date.day} $monthName';
  }

  @override
  Widget build(BuildContext context) {
    final year = currentMonth.year;
    final month = currentMonth.month;
    final monthTitle = '${_monthNames[month - 1]} $year';

    // Calculate calendar days
    final firstDayOfMonth = DateTime(year, month, 1);
    // In DateTime: 1 = Mon, 7 = Sun. For Arabic Sunday-first week:
    // Sunday = 0, Monday = 1, ..., Saturday = 6
    final firstWeekdaySundayBased = firstDayOfMonth.weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final now = DateTime.now();
    final firstOfCurrentMonth = DateTime(now.year, now.month, 1);
    final canGoBack = currentMonth.isAfter(firstOfCurrentMonth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Dates Summary Box (Arrival / Departure)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE4E9EF), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الوصول',
                      style: KonfrmTypography.supporting.copyWith(
                        color: const Color(0xFF77849A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateValue(selectedCheckIn),
                      style: KonfrmTypography.bodyStrong.copyWith(
                        color: const Color(0xFF101723),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 38,
                color: const Color(0xFFE4E9EF),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المغادرة',
                      style: KonfrmTypography.supporting.copyWith(
                        color: const Color(0xFF77849A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateValue(selectedCheckOut),
                      style: KonfrmTypography.bodyStrong.copyWith(
                        color: const Color(0xFF101723),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 2. Always-Inline Calendar Box
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E9EF), width: 1),
          ),
          padding: const EdgeInsets.fromLTRB(11, 13, 11, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Calendar Header with month title and navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Next Month Button ("<" arrow on physical RIGHT side in RTL)
                  _CalNavButton(
                    icon: Icons.chevron_left,
                    label: 'الشهر التالي',
                    onPressed: onNextMonth,
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          monthTitle,
                          style: KonfrmTypography.cardTitle.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF101723),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Previous Month Button (">" arrow on physical LEFT side in RTL)
                  _CalNavButton(
                    icon: Icons.chevron_right,
                    label: 'الشهر السابق',
                    onPressed: canGoBack ? onPreviousMonth : null,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Weekdays Header Row
              Row(
                children: _weekDays
                    .map(
                      (d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF77859A),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 8),

              // Calendar Days Grid
              if (isLoadingAvailability)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (availabilityError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Text(
                        availabilityError!,
                        style: const TextStyle(color: Color(0xFFB42318), fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: onRetryAvailability,
                        child: const Text('إعادة تحميل التوفر'),
                      ),
                    ],
                  ),
                )
              else
                _buildDaysGrid(
                  context,
                  year,
                  month,
                  firstWeekdaySundayBased,
                  daysInMonth,
                ),

              const SizedBox(height: 10),

              // Calendar Legend Note
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFBFC6D1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'التاريخ غير المتاح يظهر بشكل معطّل',
                      style: KonfrmTypography.supporting.copyWith(
                        color: const Color(0xFF7D899B),
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),

              // Inline Selection Error
              if (calendarError != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F6),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    calendarError!,
                    style: const TextStyle(
                      color: Color(0xFFBD3B45),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaysGrid(
    BuildContext context,
    int year,
    int month,
    int firstWeekdaySundayBased,
    int daysInMonth,
  ) {
    final totalCells = firstWeekdaySundayBased + daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(totalRows, (row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.5),
          child: Row(
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final dayNumber = cellIndex - firstWeekdaySundayBased + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 44));
              }

              final cellDate = DateTime(year, month, dayNumber);
              final bool isBlocked;
              if (selectedCheckIn != null && selectedCheckOut == null && cellDate.isAfter(selectedCheckIn!)) {
                // Picking departure: blocked only if stay overlaps an occupied night
                isBlocked = availability?.hasConflict(selectedCheckIn!, cellDate) ?? false;
              } else {
                // Picking arrival (or restarting): blocked if in past or inside an occupied night
                isBlocked = availability?.isDateBlocked(cellDate) ?? false;
              }

              final isStart = selectedCheckIn != null &&
                  _isSameDay(selectedCheckIn!, cellDate);
              final isEnd = selectedCheckOut != null &&
                  _isSameDay(selectedCheckOut!, cellDate);

              final isInRange = selectedCheckIn != null &&
                  selectedCheckOut != null &&
                  cellDate.isAfter(selectedCheckIn!) &&
                  cellDate.isBefore(selectedCheckOut!);

              return Expanded(
                child: _DayCell(
                  day: dayNumber,
                  isBlocked: isBlocked,
                  isSelected: isStart || isEnd,
                  isInRange: isInRange,
                  onTap: isBlocked ? null : () => onSelectDate(cellDate),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isBlocked,
    required this.isSelected,
    required this.isInRange,
    required this.onTap,
  });

  final int day;
  final bool isBlocked;
  final bool isSelected;
  final bool isInRange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = const Color(0xFF101723);
    BorderRadius? borderRadius;

    if (isSelected) {
      bgColor = const Color(0xFF276EF1);
      textColor = Colors.white;
      borderRadius = BorderRadius.circular(12);
    } else if (isInRange) {
      bgColor = const Color(0xFFEAF2FF);
      textColor = const Color(0xFF155ACE);
      borderRadius = BorderRadius.zero;
    } else if (isBlocked) {
      textColor = const Color(0xFFBFC6CE);
    }

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: textColor,
                decoration: isBlocked ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFFBFC6CE),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalNavButton extends StatelessWidget {
  const _CalNavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22,
              color: onPressed != null ? const Color(0xFF101723) : const Color(0xFFCBD5E1),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}
