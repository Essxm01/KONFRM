import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/property_details_models.dart';
import '../data/property_details_repository.dart';

class PropertyDetailsState {
  const PropertyDetailsState({
    required this.propertyId,
    this.property,
    this.availability,
    this.isLoadingProperty = true,
    this.isLoadingAvailability = true,
    this.propertyError,
    this.availabilityError,
    this.selectedCheckIn,
    this.selectedCheckOut,
    this.selectedGuests = 1,
    this.isCalculatingQuote = false,
    this.quote,
    this.quoteError,
    this.calendarError,
    required this.currentMonth,
    this.isFavorite = false,
  });

  final String propertyId;
  final PublicPropertyDetail? property;
  final PropertyAvailability? availability;
  final bool isLoadingProperty;
  final bool isLoadingAvailability;
  final String? propertyError;
  final String? availabilityError;
  final DateTime? selectedCheckIn;
  final DateTime? selectedCheckOut;
  final int selectedGuests;
  final bool isCalculatingQuote;
  final BookingQuote? quote;
  final String? quoteError;
  final String? calendarError;
  final DateTime currentMonth;
  final bool isFavorite;

  int get maxGuests => property?.maxGuests ?? 6;
  int get minStay => availability?.minStay ?? 2;
  int get maxStay => availability?.maxStay ?? 30;

  bool get hasValidDates => selectedCheckIn != null && selectedCheckOut != null;
  int get stayNights => hasValidDates
      ? selectedCheckOut!.difference(selectedCheckIn!).inDays
      : 0;

  PropertyDetailsState copyWith({
    String? propertyId,
    PublicPropertyDetail? property,
    PropertyAvailability? availability,
    bool? isLoadingProperty,
    bool? isLoadingAvailability,
    String? propertyError,
    String? availabilityError,
    DateTime? selectedCheckIn,
    DateTime? selectedCheckOut,
    bool clearCheckIn = false,
    bool clearCheckOut = false,
    int? selectedGuests,
    bool? isCalculatingQuote,
    BookingQuote? quote,
    bool clearQuote = false,
    String? quoteError,
    bool clearQuoteError = false,
    String? calendarError,
    bool clearCalendarError = false,
    DateTime? currentMonth,
    bool? isFavorite,
  }) {
    return PropertyDetailsState(
      propertyId: propertyId ?? this.propertyId,
      property: property ?? this.property,
      availability: availability ?? this.availability,
      isLoadingProperty: isLoadingProperty ?? this.isLoadingProperty,
      isLoadingAvailability: isLoadingAvailability ?? this.isLoadingAvailability,
      propertyError: propertyError ?? this.propertyError,
      availabilityError: availabilityError ?? this.availabilityError,
      selectedCheckIn: clearCheckIn ? null : (selectedCheckIn ?? this.selectedCheckIn),
      selectedCheckOut: clearCheckOut ? null : (selectedCheckOut ?? this.selectedCheckOut),
      selectedGuests: selectedGuests ?? this.selectedGuests,
      isCalculatingQuote: isCalculatingQuote ?? this.isCalculatingQuote,
      quote: clearQuote ? null : (quote ?? this.quote),
      quoteError: clearQuoteError ? null : (quoteError ?? this.quoteError),
      calendarError: clearCalendarError ? null : (calendarError ?? this.calendarError),
      currentMonth: currentMonth ?? this.currentMonth,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final propertyDetailsControllerProvider = StateNotifierProvider.autoDispose
    .family<PropertyDetailsController, PropertyDetailsState, String>((ref, propertyId) {
  final repository = ref.watch(propertyDetailsRepositoryProvider);
  return PropertyDetailsController(
    propertyId: propertyId,
    repository: repository,
  );
});

class PropertyDetailsController extends StateNotifier<PropertyDetailsState> {
  PropertyDetailsController({
    required String propertyId,
    required this.repository,
  }) : super(PropertyDetailsState(
          propertyId: propertyId,
          currentMonth: DateTime(DateTime.now().year, DateTime.now().month, 1),
        ));

  final PropertyDetailsRepository repository;
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> load({PublicPropertyDetail? initialProperty}) async {
    state = state.copyWith(
      property: initialProperty,
      isLoadingProperty: initialProperty == null,
      isLoadingAvailability: true,
      propertyError: null,
      availabilityError: null,
      clearQuote: true,
      clearQuoteError: true,
      clearCalendarError: true,
    );

    // Load property details and availability in parallel
    final detailsFuture = repository.getPropertyDetails(state.propertyId);
    final availabilityFuture = repository.getAvailability(state.propertyId);

    try {
      final prop = await detailsFuture;
      state = state.copyWith(
        property: prop,
        isLoadingProperty: false,
        selectedGuests: state.selectedGuests > prop.maxGuests
            ? prop.maxGuests
            : (state.selectedGuests < 1 ? 1 : state.selectedGuests),
      );
    } catch (e) {
      final message = e is PropertyDetailsException
          ? e.message ?? _mapError(e.kind)
          : 'تعذر تحميل بيانات الإقامة';
      state = state.copyWith(
        isLoadingProperty: false,
        propertyError: message,
      );
    }

    try {
      final avail = await availabilityFuture;
      state = state.copyWith(
        availability: avail,
        isLoadingAvailability: false,
      );
    } catch (e) {
      final message = e is PropertyDetailsException
          ? e.message ?? _mapError(e.kind)
          : 'تعذر جلب بيانات التوفر';
      state = state.copyWith(
        isLoadingAvailability: false,
        availabilityError: message,
      );
    }
  }

  void selectDate(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);

    // If no start date, or both start and end dates are already set:
    if (state.selectedCheckIn == null || state.selectedCheckOut != null) {
      state = state.copyWith(
        selectedCheckIn: cleanDate,
        clearCheckOut: true,
        clearQuote: true,
        clearQuoteError: true,
        clearCalendarError: true,
      );
      return;
    }

    // Start date is already set, now picking end date:
    final start = state.selectedCheckIn!;
    if (cleanDate.isBefore(start) || cleanDate.isAtSameMomentAs(start)) {
      // Picked date on or before start: restart selection with this new date as check-in
      state = state.copyWith(
        selectedCheckIn: cleanDate,
        clearCheckOut: true,
        clearQuote: true,
        clearQuoteError: true,
        clearCalendarError: true,
      );
      return;
    }

    // Attempting to complete the stay range [start, cleanDate]:
    final nights = cleanDate.difference(start).inDays;

    if (nights < state.minStay) {
      state = state.copyWith(
        calendarError: 'مدة الإقامة المعتمدة من ${state.minStay} ليلتين إلى ${state.maxStay} ليلة.',
        clearCheckOut: true,
        clearQuote: true,
      );
      return;
    }

    if (nights > state.maxStay) {
      state = state.copyWith(
        calendarError: 'الحد الأقصى للإقامة ${state.maxStay} ليلة.',
        clearCheckOut: true,
        clearQuote: true,
      );
      return;
    }

    if (state.availability != null && state.availability!.hasConflict(start, cleanDate)) {
      state = state.copyWith(
        calendarError: 'الفترة تشمل يومًا غير متاح في هذا المثال. اختار فترة أخرى.',
        clearCheckOut: true,
        clearQuote: true,
      );
      return;
    }

    // Range is valid!
    state = state.copyWith(
      selectedCheckOut: cleanDate,
      clearCalendarError: true,
    );

    // Server-authoritative quote calculation triggered immediately
    calculateQuote();
  }

  void incrementGuests() {
    final max = state.maxGuests;
    if (state.selectedGuests < max) {
      state = state.copyWith(selectedGuests: state.selectedGuests + 1);
      if (state.hasValidDates) {
        calculateQuote();
      }
    }
  }

  void decrementGuests() {
    if (state.selectedGuests > 1) {
      state = state.copyWith(selectedGuests: state.selectedGuests - 1);
      if (state.hasValidDates) {
        calculateQuote();
      }
    }
  }

  Future<void> calculateQuote() async {
    if (!state.hasValidDates) return;

    state = state.copyWith(
      isCalculatingQuote: true,
      clearQuote: true,
      clearQuoteError: true,
    );

    try {
      final quote = await repository.calculateQuote(
        propertyId: state.propertyId,
        checkIn: _dateFormat.format(state.selectedCheckIn!),
        checkOut: _dateFormat.format(state.selectedCheckOut!),
        guests: state.selectedGuests,
      );
      state = state.copyWith(
        quote: quote,
        isCalculatingQuote: false,
      );
    } catch (e) {
      final message = e is PropertyDetailsException
          ? e.message ?? _mapError(e.kind)
          : 'تعذّر حساب السعر';
      state = state.copyWith(
        isCalculatingQuote: false,
        quoteError: message,
      );
    }
  }

  void nextMonth() {
    final cur = state.currentMonth;
    final next = DateTime(cur.year, cur.month + 1, 1);
    state = state.copyWith(currentMonth: next);
  }

  void previousMonth() {
    final cur = state.currentMonth;
    final prev = DateTime(cur.year, cur.month - 1, 1);
    // Don't allow scrolling past the current calendar month
    final now = DateTime.now();
    final firstOfCurrent = DateTime(now.year, now.month, 1);
    if (prev.isBefore(firstOfCurrent)) return;

    state = state.copyWith(currentMonth: prev);
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  static String _mapError(PropertyDetailsFailureKind kind) => switch (kind) {
        PropertyDetailsFailureKind.configuration => 'خدمة الأسعار غير مهيأة',
        PropertyDetailsFailureKind.network => 'تعذر الاتصال بالخادم. تحقق من الشبكة.',
        PropertyDetailsFailureKind.timeout => 'انتهت مهلة الطلب. أعد المحاولة.',
        PropertyDetailsFailureKind.notFound => 'الوحدة غير موجودة',
        PropertyDetailsFailureKind.unpublished => 'هذه الوحدة غير معروضة للنشر حالياً',
        PropertyDetailsFailureKind.dateOverlap => 'التواريخ المطلوبة محجوزة مسبقاً',
        PropertyDetailsFailureKind.minStayNotMet => 'الحد الأدنى للإقامة ليلتان',
        PropertyDetailsFailureKind.maxStayExceeded => 'الحد الأقصى للإقامة 30 ليلة',
        PropertyDetailsFailureKind.maxGuestsExceeded => 'عدد الضيوف يتجاوز السعة المحددة',
        PropertyDetailsFailureKind.server => 'خطأ في معالجة الطلب بالخادم',
        PropertyDetailsFailureKind.invalidResponse => 'تعذر قراءة بيانات السعر',
      };
}
