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
  int get stayNights {
    if (!hasValidDates) return 0;
    final inCivil = DateTime.utc(selectedCheckIn!.year, selectedCheckIn!.month, selectedCheckIn!.day);
    final outCivil = DateTime.utc(selectedCheckOut!.year, selectedCheckOut!.month, selectedCheckOut!.day);
    return outCivil.difference(inCivil).inDays;
  }

  PropertyDetailsState copyWith({
    String? propertyId,
    PublicPropertyDetail? property,
    bool clearProperty = false,
    PropertyAvailability? availability,
    bool clearAvailability = false,
    bool? isLoadingProperty,
    bool? isLoadingAvailability,
    String? propertyError,
    bool clearPropertyError = false,
    String? availabilityError,
    bool clearAvailabilityError = false,
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
      property: clearProperty ? null : (property ?? this.property),
      availability: clearAvailability ? null : (availability ?? this.availability),
      isLoadingProperty: isLoadingProperty ?? this.isLoadingProperty,
      isLoadingAvailability: isLoadingAvailability ?? this.isLoadingAvailability,
      propertyError: clearPropertyError ? null : (propertyError ?? this.propertyError),
      availabilityError: clearAvailabilityError ? null : (availabilityError ?? this.availabilityError),
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
          currentMonth: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
        ));

  final PropertyDetailsRepository repository;
  static final _dateFormat = DateFormat('yyyy-MM-dd');
  int _quoteGeneration = 0;

  Future<void> load({
    PublicPropertyDetail? initialProperty,
    DateTime? initialCheckIn,
    DateTime? initialCheckOut,
    int? initialGuests,
  }) async {
    _quoteGeneration++;
    final cleanIn = initialCheckIn != null
        ? DateTime.utc(
            initialCheckIn.year,
            initialCheckIn.month,
            initialCheckIn.day,
          )
        : null;
    final cleanOut = initialCheckOut != null
        ? DateTime.utc(
            initialCheckOut.year,
            initialCheckOut.month,
            initialCheckOut.day,
          )
        : null;
    final int guests = initialGuests != null && initialGuests > 0
        ? initialGuests
        : state.selectedGuests;

    state = state.copyWith(
      property: initialProperty,
      clearProperty: initialProperty == null,
      isLoadingProperty: true,
      isLoadingAvailability: true,
      isCalculatingQuote: false,
      selectedCheckIn: cleanIn,
      selectedCheckOut: cleanOut,
      clearCheckIn: cleanIn == null,
      clearCheckOut: cleanOut == null,
      selectedGuests: guests,
      clearPropertyError: true,
      clearAvailabilityError: true,
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
        clearPropertyError: true,
        selectedGuests: state.selectedGuests > prop.maxGuests
            ? prop.maxGuests
            : (state.selectedGuests < 1 ? 1 : state.selectedGuests),
      );
    } catch (e) {
      final String message;
      if (e is PropertyDetailsException) {
        message = _isCustomerSafeArabic(e.userMessage)
            ? e.userMessage!
            : _mapPropertyError(e.kind);
      } else {
        message = 'تعذر تحميل بيانات الإقامة';
      }
      state = state.copyWith(
        isLoadingProperty: false,
        propertyError: message,
      );
    }

    try {
      final avail = await availabilityFuture;
      if (avail.propertyId != state.propertyId) {
        state = state.copyWith(
          isLoadingAvailability: false,
          clearAvailability: true,
          availabilityError: 'تعذر التحقق من هوية العقار في استجابة التوفر.',
        );
      } else {
        state = state.copyWith(
          availability: avail,
          isLoadingAvailability: false,
          clearAvailabilityError: true,
        );
        if (state.hasValidDates) {
          final conflict = avail.hasConflict(
            state.selectedCheckIn!,
            state.selectedCheckOut!,
          );
          if (!conflict) {
            calculateQuote();
          } else {
            state = state.copyWith(
              calendarError: 'التواريخ المختارة غير متاحة للحجز.',
            );
          }
        }
      }
    } catch (e) {
      final String message;
      if (e is PropertyDetailsException) {
        message = _isCustomerSafeArabic(e.userMessage)
            ? e.userMessage!
            : _mapAvailabilityError(e.kind);
      } else {
        message = 'تعذر جلب بيانات التوفر';
      }
      state = state.copyWith(
        isLoadingAvailability: false,
        clearAvailability: true,
        availabilityError: message,
      );
    }
  }

  void selectDate(DateTime date) {
    final cleanDate = DateTime.utc(date.year, date.month, date.day);
    _quoteGeneration++;

    // If no start date, or both start and end dates are already set:
    if (state.selectedCheckIn == null || state.selectedCheckOut != null) {
      state = state.copyWith(
        selectedCheckIn: cleanDate,
        clearCheckOut: true,
        isCalculatingQuote: false,
        clearQuote: true,
        clearQuoteError: true,
        clearCalendarError: true,
      );
      return;
    }

    // Start date is already set, now picking end date:
    final start = DateTime.utc(
      state.selectedCheckIn!.year,
      state.selectedCheckIn!.month,
      state.selectedCheckIn!.day,
    );
    if (cleanDate.isBefore(start) || cleanDate.isAtSameMomentAs(start)) {
      // Picked date on or before start: restart selection with this new date as check-in
      state = state.copyWith(
        selectedCheckIn: cleanDate,
        clearCheckOut: true,
        isCalculatingQuote: false,
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
        isCalculatingQuote: false,
        clearQuote: true,
        clearQuoteError: true,
      );
      return;
    }

    if (nights > state.maxStay) {
      state = state.copyWith(
        calendarError: 'الحد الأقصى للإقامة ${state.maxStay} ليلة.',
        clearCheckOut: true,
        isCalculatingQuote: false,
        clearQuote: true,
        clearQuoteError: true,
      );
      return;
    }

    if (state.availability != null && state.availability!.hasConflict(start, cleanDate)) {
      state = state.copyWith(
        calendarError: 'الفترة تشمل يومًا غير متاح في هذا المثال. اختار فترة أخرى.',
        clearCheckOut: true,
        isCalculatingQuote: false,
        clearQuote: true,
        clearQuoteError: true,
      );
      return;
    }

    // Range is valid!
    state = state.copyWith(
      selectedCheckOut: cleanDate,
      clearCalendarError: true,
      clearQuote: true,
      clearQuoteError: true,
    );

    // Server-authoritative quote calculation triggered immediately
    calculateQuote();
  }

  void incrementGuests() {
    final max = state.maxGuests;
    if (state.selectedGuests < max) {
      _quoteGeneration++;
      state = state.copyWith(
        selectedGuests: state.selectedGuests + 1,
        clearQuote: true,
        clearQuoteError: true,
      );
      if (state.hasValidDates) {
        calculateQuote();
      }
    }
  }

  void decrementGuests() {
    if (state.selectedGuests > 1) {
      _quoteGeneration++;
      state = state.copyWith(
        selectedGuests: state.selectedGuests - 1,
        clearQuote: true,
        clearQuoteError: true,
      );
      if (state.hasValidDates) {
        calculateQuote();
      }
    }
  }

  Future<void> calculateQuote() async {
    if (!state.hasValidDates) return;

    final generation = ++_quoteGeneration;
    final reqPropertyId = state.propertyId;
    final reqIn = DateTime.utc(
      state.selectedCheckIn!.year,
      state.selectedCheckIn!.month,
      state.selectedCheckIn!.day,
    );
    final reqOut = DateTime.utc(
      state.selectedCheckOut!.year,
      state.selectedCheckOut!.month,
      state.selectedCheckOut!.day,
    );
    final reqGuests = state.selectedGuests;

    state = state.copyWith(
      isCalculatingQuote: true,
      clearQuote: true,
      clearQuoteError: true,
    );

    try {
      final quote = await repository.calculateQuote(
        propertyId: reqPropertyId,
        checkIn: _dateFormat.format(reqIn),
        checkOut: _dateFormat.format(reqOut),
        guests: reqGuests,
      );

      // Latest-request-wins protection: discard if superseded
      if (generation != _quoteGeneration || !mounted) return;

      // Identity protection: reject if quote does not match active selection
      if (quote.propertyId != state.propertyId ||
          quote.guests != state.selectedGuests ||
          !state.hasValidDates ||
          quote.checkIn != DateTime.utc(state.selectedCheckIn!.year, state.selectedCheckIn!.month, state.selectedCheckIn!.day) ||
          quote.checkOut != DateTime.utc(state.selectedCheckOut!.year, state.selectedCheckOut!.month, state.selectedCheckOut!.day)) {
        state = state.copyWith(
          isCalculatingQuote: false,
          clearQuote: true,
          quoteError: 'استجابة السعر غير مطابقة للطلب الحالي. يرجى إعادة المحاولة.',
        );
        return;
      }

      state = state.copyWith(
        quote: quote,
        isCalculatingQuote: false,
      );
    } catch (e) {
      if (generation != _quoteGeneration || !mounted) return;
      final String message;
      if (e is PropertyDetailsException) {
        message = _isCustomerSafeArabic(e.userMessage)
            ? e.userMessage!
            : _mapQuoteError(e.kind);
      } else {
        message = 'تعذر احتساب السعر حالياً. يرجى إعادة المحاولة.';
      }
      state = state.copyWith(
        isCalculatingQuote: false,
        quoteError: message,
      );
    }
  }

  void nextMonth() {
    final cur = state.currentMonth;
    final next = DateTime.utc(cur.year, cur.month + 1, 1);
    state = state.copyWith(currentMonth: next);
  }

  void previousMonth() {
    final cur = state.currentMonth;
    final prev = DateTime.utc(cur.year, cur.month - 1, 1);
    // Don't allow scrolling past the current calendar month
    final now = DateTime.now();
    final firstOfCurrent = DateTime.utc(now.year, now.month, 1);
    if (prev.isBefore(firstOfCurrent)) return;

    state = state.copyWith(currentMonth: prev);
  }

  void toggleFavorite() {
    // Guest favorites are unauthenticated; state remains false.
  }

  static bool _isCustomerSafeArabic(String? text) {
    if (text == null || text.trim().isEmpty) return false;
    final trimmed = text.trim();
    // Reject any technical keywords or tokens:
    if (trimmed.contains('FormatException') ||
        trimmed.contains('Exception') ||
        trimmed.contains('Error') ||
        trimmed.contains('error') ||
        trimmed.startsWith('HTTP') ||
        trimmed.contains('http:') ||
        trimmed.contains('https:') ||
        trimmed.contains('status code') ||
        trimmed.contains('JSON') ||
        trimmed.contains('json') ||
        trimmed.contains('null') ||
        trimmed.contains('{') ||
        trimmed.contains('}')) {
      return false;
    }
    // Must contain Arabic characters
    return RegExp(r'[\u0600-\u06FF]').hasMatch(trimmed);
  }

  static String _mapPropertyError(PropertyDetailsFailureKind kind) => switch (kind) {
        PropertyDetailsFailureKind.configuration => 'خدمة تفاصيل الإقامة غير متاحة حالياً.',
        PropertyDetailsFailureKind.network => 'تعذر الاتصال بالشبكة. تحقق من اتصالك.',
        PropertyDetailsFailureKind.timeout => 'انتهت مهلة الطلب. يرجى إعادة المحاولة.',
        PropertyDetailsFailureKind.notFound => 'الوحدة غير موجودة',
        PropertyDetailsFailureKind.unpublished => 'هذه الوحدة غير معروضة للنشر حالياً',
        PropertyDetailsFailureKind.server => 'تعذر تحميل بيانات الإقامة حالياً. يرجى إعادة المحاولة.',
        PropertyDetailsFailureKind.invalidResponse => 'تعذر قراءة بيانات الإقامة.',
        _ => 'تعذر تحميل بيانات الإقامة',
      };

  static String _mapAvailabilityError(PropertyDetailsFailureKind kind) => switch (kind) {
        PropertyDetailsFailureKind.configuration => 'خدمة التوفر غير متاحة حالياً.',
        PropertyDetailsFailureKind.network => 'تعذر الاتصال بالشبكة. تحقق من اتصالك.',
        PropertyDetailsFailureKind.timeout => 'انتهت مهلة الطلب. يرجى إعادة المحاولة.',
        PropertyDetailsFailureKind.notFound => 'الوحدة غير موجودة',
        PropertyDetailsFailureKind.unpublished => 'هذه الوحدة غير معروضة للنشر حالياً',
        PropertyDetailsFailureKind.server => 'تعذر جلب بيانات التوفر حالياً. يرجى إعادة المحاولة.',
        PropertyDetailsFailureKind.invalidResponse => 'تعذر قراءة بيانات التوفر.',
        _ => 'تعذر جلب بيانات التوفر',
      };

  static String _mapQuoteError(PropertyDetailsFailureKind kind) => switch (kind) {
        PropertyDetailsFailureKind.configuration => 'خدمة الأسعار غير مهيأة',
        PropertyDetailsFailureKind.network => 'تعذر الاتصال بالشبكة. تحقق من اتصالك.',
        PropertyDetailsFailureKind.timeout => 'انتهت مهلة الطلب. أعد المحاولة.',
        PropertyDetailsFailureKind.notFound => 'الوحدة غير موجودة',
        PropertyDetailsFailureKind.unpublished => 'لا يمكن حساب سعر لوحدة غير منشورة',
        PropertyDetailsFailureKind.dateOverlap => 'التواريخ المطلوبة محجوزة مسبقاً',
        PropertyDetailsFailureKind.minStayNotMet => 'الحد الأدنى للإقامة ليلتان',
        PropertyDetailsFailureKind.maxStayExceeded => 'الحد الأقصى للإقامة 30 ليلة',
        PropertyDetailsFailureKind.maxGuestsExceeded => 'عدد الضيوف يتجاوز السعة المحددة',
        PropertyDetailsFailureKind.server => 'تعذر احتساب السعر حالياً. يرجى إعادة المحاولة.',
        PropertyDetailsFailureKind.invalidResponse => 'تعذر قراءة تفاصيل السعر. يرجى إعادة المحاولة.',
      };
}
