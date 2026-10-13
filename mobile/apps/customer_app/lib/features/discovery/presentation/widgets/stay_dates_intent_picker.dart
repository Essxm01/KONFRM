import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Interactive stay dates intent picker for Screen 04 (Search & Refine).
///
/// Features a horizontal month paging calendar modal, KONFRM Blue selection accents,
/// soft light-blue range fill, RTL arrow geometry (< on right, > on left),
/// and strict 2–30 nights validation in Cairo local calendar time.
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
    final result = await showModalBottomSheet<Map<String, DateTime?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HorizontalDateRangePickerSheet(
        initialCheckIn: checkInDate,
        initialCheckOut: checkOutDate,
      ),
    );

    if (result != null) {
      final inDate = result['checkIn'];
      final outDate = result['checkOut'];
      if (inDate == null && outDate == null) {
        onClearDates();
      } else if (inDate != null && outDate != null) {
        onDatesChanged(inDate, outDate);
      }
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

        // Two-column date display cards with subtle blue active border
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
                      width: hasDates ? 1.5 : 1.0,
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
                      width: hasDates ? 1.5 : 1.0,
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
                color: Color(0xFF0F172A),
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

/// Dedicated Horizontal Date Range Picker Modal Sheet.
///
/// Features:
/// - Horizontal month paging via swipe or arrow taps
/// - Founder-specified RTL arrows: "<" on the physical RIGHT, ">" on the physical LEFT
/// - Approved KONFRM Blue selection accents & soft light-blue range fill
/// - Zero green/teal highlights
/// - Strict 2 to 30 nights validation
class HorizontalDateRangePickerSheet extends StatefulWidget {
  const HorizontalDateRangePickerSheet({
    super.key,
    this.initialCheckIn,
    this.initialCheckOut,
  });

  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;

  @override
  State<HorizontalDateRangePickerSheet> createState() =>
      _HorizontalDateRangePickerSheetState();
}

class _HorizontalDateRangePickerSheetState
    extends State<HorizontalDateRangePickerSheet> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  String? _errorMessage;
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<String> _monthNames = [
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
    'ديسمبر',
  ];

  static const List<String> _weekDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  void initState() {
    super.initState();
    _checkIn = widget.initialCheckIn;
    _checkOut = widget.initialCheckOut;

    // Calculate initial page based on checkIn month
    int initialPage = 0;
    if (_checkIn != null) {
      final now = DateTime.now();
      final diffMonths =
          (_checkIn!.year - now.year) * 12 + (_checkIn!.month - now.month);
      if (diffMonths > 0 && diffMonths < 12) {
        initialPage = diffMonths;
      }
    }
    _currentPage = initialPage;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getMonthForPage(int index) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + index, 1);
  }

  int get _nights {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_checkIn == null || (_checkIn != null && _checkOut != null)) {
        _checkIn = date;
        _checkOut = null;
        _errorMessage = null;
      } else if (_checkIn != null && _checkOut == null) {
        if (date.isBefore(_checkIn!)) {
          _checkIn = date;
          _errorMessage = null;
        } else if (date.year == _checkIn!.year &&
            date.month == _checkIn!.month &&
            date.day == _checkIn!.day) {
          // Tapped same day
          _errorMessage = 'الحد الأدنى للإقامة ليلتان';
        } else {
          final diff = date.difference(_checkIn!).inDays;
          if (diff < 2) {
            _errorMessage = 'الحد الأدنى للإقامة ليلتان';
          } else if (diff > 30) {
            _errorMessage = 'الحد الأقصى للإقامة 30 ليلة';
          } else {
            _checkOut = date;
            _errorMessage = null;
          }
        }
      }
    });
  }

  void _clearDates() {
    setState(() {
      _checkIn = null;
      _checkOut = null;
      _errorMessage = null;
    });
  }

  String _formatSummaryDate(DateTime? date) {
    if (date == null) return 'اختر التاريخ';
    return DateFormat('d MMM', 'ar').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final displayedMonth = _getMonthForPage(_currentPage);
    final monthTitle =
        '${_monthNames[displayedMonth.month - 1]} ${displayedMonth.year}';
    final hasCompleteDates = _checkIn != null && _checkOut != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: mediaQuery.size.height * 0.82,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // 1. Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // 2. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تواريخ الإقامة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    key: const Key('calendar-sheet-close-button'),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF64748B),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 3. Selection Summary Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          _formatSummaryDate(_checkIn),
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _checkIn != null
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          _formatSummaryDate(_checkOut),
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _checkOut != null
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasCompleteDates)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_nights ليالٍ',
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 4. Month Navigation Bar with Founder-Mandated Physical Arrow Direction:
            // ">" on physical RIGHT (returns to previous month in RTL)
            // "<" on physical LEFT (advances to next month in RTL)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Physical RIGHT: ">" arrow points to previous month
                  Semantics(
                    button: true,
                    label: 'الشهر السابق',
                    child: InkWell(
                      key: const Key('calendar-prev-month-button'),
                      borderRadius: BorderRadius.circular(8),
                      onTap: _currentPage > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 22,
                          color: _currentPage > 0
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFCBD5E1),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),

                  // Physical CENTER: Month Title
                  Text(
                    monthTitle,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  // Physical LEFT: "<" arrow points to next month
                  Semantics(
                    button: true,
                    label: 'الشهر التالي',
                    child: InkWell(
                      key: const Key('calendar-next-month-button'),
                      borderRadius: BorderRadius.circular(8),
                      onTap: _currentPage < 11
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 22,
                          color: _currentPage < 11
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFCBD5E1),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Weekdays Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  for (final day in _weekDays)
                    Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // 6. Horizontal Month Paging Grid
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 12,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  final monthDate = _getMonthForPage(index);
                  return _buildMonthGrid(monthDate);
                },
              ),
            ),

            // 7. Validation / Error Notice
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDC2626),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // 8. Sticky Action CTA
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: [
                    if (_checkIn != null)
                      TextButton(
                        onPressed: _clearDates,
                        child: const Text(
                          'مسح',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('calendar-sheet-confirm-button'),
                          onPressed: hasCompleteDates
                              ? () {
                                  Navigator.of(context).pop({
                                    'checkIn': _checkIn,
                                    'checkOut': _checkOut,
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000000),
                            disabledBackgroundColor: const Color(0xFFCBD5E1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            hasCompleteDates
                                ? 'تأكيد التواريخ ($_nights ليالٍ)'
                                : 'اختر تاريخ المغادرة',
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthGrid(DateTime monthDate) {
    final year = monthDate.year;
    final month = monthDate.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final firstWeekdaySundayBased = firstDayOfMonth.weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final totalCells = firstWeekdaySundayBased + daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: List.generate(totalRows, (row) {
            return Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                final dayNumber = cellIndex - firstWeekdaySundayBased + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 42));
                }

                final cellDate = DateTime(year, month, dayNumber);
                final isPast = cellDate.isBefore(today);

                final isStart = _checkIn != null &&
                    _checkIn!.year == cellDate.year &&
                    _checkIn!.month == cellDate.month &&
                    _checkIn!.day == cellDate.day;

                final isEnd = _checkOut != null &&
                    _checkOut!.year == cellDate.year &&
                    _checkOut!.month == cellDate.month &&
                    _checkOut!.day == cellDate.day;

                final isInRange = _checkIn != null &&
                    _checkOut != null &&
                    cellDate.isAfter(_checkIn!) &&
                    cellDate.isBefore(_checkOut!);

                return Expanded(
                  child: _CalendarDayCell(
                    day: dayNumber,
                    isPast: isPast,
                    isStart: isStart,
                    isEnd: isEnd,
                    isInRange: isInRange,
                    onTap: isPast ? null : () => _onDateTap(cellDate),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.isPast,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.onTap,
  });

  final int day;
  final bool isPast;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = const Color(0xFF0F172A);
    BorderRadius? borderRadius;

    if (isStart || isEnd) {
      bgColor = const Color(0xFF000000); // Black endpoints
      textColor = Colors.white;
      borderRadius = BorderRadius.circular(12);
    } else if (isInRange) {
      bgColor = const Color(0xFFF1F5F9); // Subtle neutral range fill
      textColor = const Color(0xFF0F172A);
      borderRadius = BorderRadius.zero;
    } else if (isPast) {
      textColor = const Color(0xFFCBD5E1);
    }

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('calendar-day-$day'),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: (isStart || isEnd)
                    ? FontWeight.w800
                    : (isInRange ? FontWeight.w700 : FontWeight.w600),
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
