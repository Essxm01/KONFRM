import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/booking_review_models.dart';
import '../data/booking_review_repository.dart';

/// Active UI state of Screen 07 Booking Request Review.
enum BookingReviewUiState {
  reviewReady,
  revalidating,
  priceChanged,
  dateConflict,
  networkError,
  authRequired,
  submitting,
  requestSent,
}

class BookingReviewState {
  const BookingReviewState({
    required this.uiState,
    required this.context,
    required this.currentQuote,
    this.previousQuote,
    this.errorMessage,
    this.bookingResult,
    this.authToken,
  });

  final BookingReviewUiState uiState;
  final BookingReviewContext context;
  final BookingQuote currentQuote;
  final BookingQuote? previousQuote;
  final String? errorMessage;
  final BookingRequestResult? bookingResult;
  final String? authToken;

  /// Returns true if the server price actually changed (total or deposit).
  bool get hasPriceShift {
    if (previousQuote == null) return false;
    return currentQuote.totalStay != previousQuote!.totalStay ||
        currentQuote.depositAmount != previousQuote!.depositAmount ||
        currentQuote.pricePerNight != previousQuote!.pricePerNight;
  }

  /// Returns true if fingerprint changed without monetary price changing.
  bool get hasFingerprintShiftOnly {
    if (previousQuote == null) return false;
    return !hasPriceShift && currentQuote.quoteFingerprint != previousQuote!.quoteFingerprint;
  }

  BookingReviewState copyWith({
    BookingReviewUiState? uiState,
    BookingReviewContext? context,
    BookingQuote? currentQuote,
    BookingQuote? previousQuote,
    bool clearPreviousQuote = false,
    String? errorMessage,
    bool clearError = false,
    BookingRequestResult? bookingResult,
    String? authToken,
  }) {
    return BookingReviewState(
      uiState: uiState ?? this.uiState,
      context: context ?? this.context,
      currentQuote: currentQuote ?? this.currentQuote,
      previousQuote: clearPreviousQuote ? null : (previousQuote ?? this.previousQuote),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      bookingResult: bookingResult ?? this.bookingResult,
      authToken: authToken ?? this.authToken,
    );
  }
}

final bookingReviewControllerProvider = StateNotifierProvider.autoDispose
    .family<BookingReviewController, BookingReviewState, BookingReviewContext>((ref, initialContext) {
  final repository = ref.watch(bookingReviewRepositoryProvider);
  return BookingReviewController(
    initialContext: initialContext,
    repository: repository,
    authToken: initialContext.authToken,
  );
});

class BookingReviewController extends StateNotifier<BookingReviewState> {
  BookingReviewController({
    required BookingReviewContext initialContext,
    required this.repository,
    String? authToken,
    bool startRevalidating = false,
  })  : _dateFormat = DateFormat('yyyy-MM-dd'),
        super(BookingReviewState(
          uiState: startRevalidating ? BookingReviewUiState.revalidating : BookingReviewUiState.reviewReady,
          context: initialContext,
          currentQuote: initialContext.initialQuote,
          authToken: authToken,
        )) {
    if (startRevalidating) {
      revalidateQuote();
    }
  }

  final BookingReviewRepository repository;
  final DateFormat _dateFormat;

  /// Revalidates the quote with the server to protect against stale pricing or date conflicts.
  Future<void> revalidateQuote() async {
    state = state.copyWith(
      uiState: BookingReviewUiState.revalidating,
      clearError: true,
    );

    try {
      final freshQuote = await repository.calculateQuote(
        propertyId: state.context.propertyId,
        checkIn: _dateFormat.format(state.context.checkIn),
        checkOut: _dateFormat.format(state.context.checkOut),
        guests: state.context.guests,
        authToken: state.authToken,
      );

      // Identity protection: verify response parameters
      if (!state.context.matchesQuote(freshQuote)) {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: 'استجابة السعر غير مطابقة للطلب الحالي. يرجى إعادة المحاولة.',
        );
        return;
      }

      final prev = state.currentQuote;
      final isPriceSame = freshQuote.totalStay == prev.totalStay &&
          freshQuote.depositAmount == prev.depositAmount &&
          freshQuote.pricePerNight == prev.pricePerNight;
      final isFingerprintSame = freshQuote.quoteFingerprint == prev.quoteFingerprint;

      if (!isPriceSame || !isFingerprintSame) {
        // Price or fingerprint shifted
        state = state.copyWith(
          uiState: BookingReviewUiState.priceChanged,
          previousQuote: prev,
          currentQuote: freshQuote,
          clearError: true,
        );
      } else {
        // Exact match
        state = state.copyWith(
          uiState: BookingReviewUiState.reviewReady,
          currentQuote: freshQuote,
          clearPreviousQuote: true,
          clearError: true,
        );
      }
    } on BookingReviewException catch (e) {
      if (e.kind == BookingReviewFailureKind.dateOverlap) {
        state = state.copyWith(
          uiState: BookingReviewUiState.dateConflict,
          errorMessage: e.userMessage ?? 'التواريخ المختارة لم تعد متاحة.',
        );
      } else {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: e.userMessage ?? 'تعذر التحقق من السعر حالياً. يرجى إعادة المحاولة.',
        );
      }
    } catch (_) {
      state = state.copyWith(
        uiState: BookingReviewUiState.networkError,
        errorMessage: 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
      );
    }
  }

  /// Explicit customer confirmation of the new price.
  void acceptNewPrice() {
    if (state.uiState == BookingReviewUiState.priceChanged) {
      state = state.copyWith(
        uiState: BookingReviewUiState.reviewReady,
        clearPreviousQuote: true,
        clearError: true,
      );
    }
  }

  /// Handles submit action for the booking request.
  Future<void> submitBookingRequest() async {
    // 1. Unauthenticated check (Flow A): Customer reviewing as guest
    if (state.authToken == null || state.authToken!.trim().isEmpty) {
      state = state.copyWith(
        uiState: BookingReviewUiState.authRequired,
        errorMessage: 'تسجيل الدخول مطلوب لإرسال طلب الحجز للمالك.',
      );
      return;
    }

    // 2. Prevent repeated clicks or submission in non-ready states
    if (state.uiState == BookingReviewUiState.submitting ||
        state.uiState == BookingReviewUiState.revalidating) {
      return;
    }

    state = state.copyWith(
      uiState: BookingReviewUiState.submitting,
      clearError: true,
    );

    final request = CreateBookingRequest(
      propertyId: state.context.propertyId,
      checkIn: _dateFormat.format(state.context.checkIn),
      checkOut: _dateFormat.format(state.context.checkOut),
      guests: state.context.guests,
      reviewedQuoteFingerprint: state.currentQuote.quoteFingerprint,
      requestId: state.context.requestId,
    );

    try {
      final result = await repository.submitBookingRequest(
        request: request,
        authToken: state.authToken,
      );

      state = state.copyWith(
        uiState: BookingReviewUiState.requestSent,
        bookingResult: result,
        clearError: true,
      );
    } on BookingReviewException catch (e) {
      if (e.kind == BookingReviewFailureKind.unauthorized) {
        state = state.copyWith(
          uiState: BookingReviewUiState.authRequired,
          errorMessage: e.userMessage ?? 'انتهت جلسة تسجيل الدخول. يرجى تسجيل الدخول مجدداً.',
        );
      } else if (e.kind == BookingReviewFailureKind.quoteChanged) {
        if (e.freshQuote != null) {
          state = state.copyWith(
            uiState: BookingReviewUiState.priceChanged,
            previousQuote: state.currentQuote,
            currentQuote: e.freshQuote,
            errorMessage: e.userMessage,
          );
        } else {
          await revalidateQuote();
        }
      } else if (e.kind == BookingReviewFailureKind.dateOverlap) {
        state = state.copyWith(
          uiState: BookingReviewUiState.dateConflict,
          errorMessage: e.userMessage ?? 'التواريخ المختارة لم تعد متاحة.',
        );
      } else if (e.kind == BookingReviewFailureKind.idempotencyConflict) {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: e.userMessage ?? 'تعذر التحقق من هذا الطلب بأمان. ارجع لتفاصيل الإقامة وحاول مرة أخرى.',
        );
      } else {
        // Network / Server failure: preserve requestId for idempotent retry
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: e.userMessage ?? 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
        );
      }
    } catch (_) {
      state = state.copyWith(
        uiState: BookingReviewUiState.networkError,
        errorMessage: 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
      );
    }
  }

  /// Sets an authenticated session token (e.g. on return from Auth) and triggers revalidation.
  void setAuthToken(String token) {
    state = state.copyWith(
      authToken: token,
      uiState: BookingReviewUiState.revalidating,
      clearError: true,
    );
    revalidateQuote();
  }

  /// Dismisses the Auth Required modal/banner to return to reviewReady state.
  void dismissAuthRequired() {
    if (state.uiState == BookingReviewUiState.authRequired) {
      state = state.copyWith(
        uiState: BookingReviewUiState.reviewReady,
        clearError: true,
      );
    }
  }

  /// Retries the current failed operation.
  void retry() {
    if (state.uiState == BookingReviewUiState.networkError) {
      if (state.authToken != null && state.authToken!.trim().isNotEmpty) {
        submitBookingRequest();
      } else {
        revalidateQuote();
      }
    }
  }
}
