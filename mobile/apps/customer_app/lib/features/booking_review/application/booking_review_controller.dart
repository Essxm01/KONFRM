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

/// Operation kind that was being executed when an error occurred, used to disambiguate retries.
enum BookingReviewOperation {
  quoteRevalidation,
  bookingSubmission,
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
    this.lastFailedOperation,
  });

  final BookingReviewUiState uiState;
  final BookingReviewContext context;
  final BookingQuote currentQuote;
  final BookingQuote? previousQuote;
  final String? errorMessage;
  final BookingRequestResult? bookingResult;
  final String? authToken;
  final BookingReviewOperation? lastFailedOperation;

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
    BookingReviewOperation? lastFailedOperation,
    bool clearLastFailedOperation = false,
  }) {
    return BookingReviewState(
      uiState: uiState ?? this.uiState,
      context: context ?? this.context,
      currentQuote: currentQuote ?? this.currentQuote,
      previousQuote: clearPreviousQuote ? null : (previousQuote ?? this.previousQuote),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      bookingResult: bookingResult ?? this.bookingResult,
      authToken: authToken ?? this.authToken,
      lastFailedOperation: clearLastFailedOperation
          ? null
          : (lastFailedOperation ?? this.lastFailedOperation),
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
    startRevalidating: initialContext.startRevalidating,
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
  int _revalidationEpoch = 0;

  /// Revalidates the quote with the server to protect against stale pricing or date conflicts.
  Future<void> revalidateQuote() async {
    final int epoch = ++_revalidationEpoch;

    state = state.copyWith(
      uiState: BookingReviewUiState.revalidating,
      clearError: true,
      clearLastFailedOperation: true,
    );

    try {
      final freshQuote = await repository.calculateQuote(
        propertyId: state.context.propertyId,
        checkIn: _dateFormat.format(state.context.checkIn),
        checkOut: _dateFormat.format(state.context.checkOut),
        guests: state.context.guests,
        authToken: state.authToken,
      );

      // Check if this response is still the latest epoch
      if (epoch != _revalidationEpoch || !mounted) return;

      // Identity protection: verify response parameters match active context
      if (!state.context.matchesQuote(freshQuote)) {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: 'استجابة السعر غير مطابقة للطلب الحالي. يرجى إعادة المحاولة.',
          lastFailedOperation: BookingReviewOperation.quoteRevalidation,
        );
        return;
      }

      final prev = state.currentQuote;
      final isPriceSame = freshQuote.totalStay == prev.totalStay &&
          freshQuote.depositAmount == prev.depositAmount &&
          freshQuote.pricePerNight == prev.pricePerNight;
      final isFingerprintSame = freshQuote.quoteFingerprint == prev.quoteFingerprint;

      if (!isPriceSame || !isFingerprintSame) {
        // Price or fingerprint shifted: require separate customer review and acceptance
        state = state.copyWith(
          uiState: BookingReviewUiState.priceChanged,
          previousQuote: prev,
          currentQuote: freshQuote,
          clearError: true,
          clearLastFailedOperation: true,
        );
      } else {
        // Exact match
        state = state.copyWith(
          uiState: BookingReviewUiState.reviewReady,
          currentQuote: freshQuote,
          clearPreviousQuote: true,
          clearError: true,
          clearLastFailedOperation: true,
        );
      }
    } on BookingReviewException catch (e) {
      if (epoch != _revalidationEpoch || !mounted) return;
      if (e.kind == BookingReviewFailureKind.dateOverlap) {
        state = state.copyWith(
          uiState: BookingReviewUiState.dateConflict,
          errorMessage: e.userMessage ?? 'التواريخ المختارة لم تعد متاحة.',
          clearLastFailedOperation: true,
        );
      } else {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: e.userMessage ?? 'تعذر التحقق من السعر حالياً. يرجى إعادة المحاولة.',
          lastFailedOperation: BookingReviewOperation.quoteRevalidation,
        );
      }
    } catch (_) {
      if (epoch != _revalidationEpoch || !mounted) return;
      state = state.copyWith(
        uiState: BookingReviewUiState.networkError,
        errorMessage: 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
        lastFailedOperation: BookingReviewOperation.quoteRevalidation,
      );
    }
  }

  /// Explicit customer confirmation of the new price or refreshed quote details.
  /// Strictly returns state to reviewReady without automatic submission.
  void acceptNewPrice() {
    if (state.uiState == BookingReviewUiState.priceChanged) {
      state = state.copyWith(
        uiState: BookingReviewUiState.reviewReady,
        clearPreviousQuote: true,
        clearError: true,
        clearLastFailedOperation: true,
      );
    }
  }

  /// Handles submit action for the booking request.
  /// Guarded: Submission can ONLY be initiated from reviewReady state.
  Future<void> submitBookingRequest() async {
    // 1. Strict state guard: MUST be in reviewReady state.
    // Zero submissions allowed from priceChanged, dateConflict, networkError,
    // authRequired, revalidating, submitting, or requestSent.
    if (state.uiState != BookingReviewUiState.reviewReady) {
      return;
    }

    // 2. Validate booking context invariants (2-30 nights, valid property, guests >= 1)
    if (!state.context.isValidStay) {
      return;
    }

    // 3. Verify currentQuote strictly matches active review context
    if (!state.context.matchesQuote(state.currentQuote)) {
      return;
    }

    // 4. Intercept unauthenticated users attempting protected action from reviewReady
    if (state.authToken == null || state.authToken!.trim().isEmpty) {
      state = state.copyWith(
        uiState: BookingReviewUiState.authRequired,
        errorMessage: 'تسجيل الدخول مطلوب لإرسال طلب الحجز للمالك.',
      );
      return;
    }

    // 5. Proceed to protected submission
    state = state.copyWith(
      uiState: BookingReviewUiState.submitting,
      clearError: true,
    );

    await _executeBookingSubmission();
  }

  Future<void> _executeBookingSubmission() async {
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

      // Validate returned status and identity
      if (result.status != 'PENDING_OWNER_APPROVAL' ||
          (result.propertyId.isNotEmpty && result.propertyId != state.context.propertyId)) {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: 'استجابة الحجز غير صالحة. يرجى إعادة المحاولة.',
          lastFailedOperation: BookingReviewOperation.bookingSubmission,
        );
        return;
      }

      state = state.copyWith(
        uiState: BookingReviewUiState.requestSent,
        bookingResult: result,
        clearError: true,
        clearLastFailedOperation: true,
      );
    } on BookingReviewException catch (e) {
      if (e.kind == BookingReviewFailureKind.unauthorized) {
        state = state.copyWith(
          uiState: BookingReviewUiState.authRequired,
          errorMessage: e.userMessage ?? 'انتهت جلسة تسجيل الدخول. يرجى تسجيل الدخول مجدداً.',
          lastFailedOperation: BookingReviewOperation.bookingSubmission,
        );
      } else if (e.kind == BookingReviewFailureKind.quoteChanged) {
        // Validate any new quote received from 409 against active property, dates, guests
        if (e.freshQuote != null && state.context.matchesQuote(e.freshQuote!)) {
          state = state.copyWith(
            uiState: BookingReviewUiState.priceChanged,
            previousQuote: state.currentQuote,
            currentQuote: e.freshQuote,
            errorMessage: e.userMessage,
            clearLastFailedOperation: true,
          );
        } else {
          // If quote is missing or mismatched, trigger full revalidation
          await revalidateQuote();
        }
      } else if (e.kind == BookingReviewFailureKind.dateOverlap) {
        state = state.copyWith(
          uiState: BookingReviewUiState.dateConflict,
          errorMessage: e.userMessage ?? 'التواريخ المختارة لم تعد متاحة.',
          clearLastFailedOperation: true,
        );
      } else if (e.kind == BookingReviewFailureKind.idempotencyConflict) {
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: e.userMessage ?? 'تعذر التحقق من هذا الطلب بأمان. ارجع لتفاصيل الإقامة وحاول مرة أخرى.',
          lastFailedOperation: BookingReviewOperation.bookingSubmission,
        );
      } else {
        // Network / Timeout / Server failure: preserve requestId and fingerprint for idempotent retry
        state = state.copyWith(
          uiState: BookingReviewUiState.networkError,
          errorMessage: e.userMessage ?? 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
          lastFailedOperation: BookingReviewOperation.bookingSubmission,
        );
      }
    } catch (_) {
      state = state.copyWith(
        uiState: BookingReviewUiState.networkError,
        errorMessage: 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
        lastFailedOperation: BookingReviewOperation.bookingSubmission,
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

  /// Dismisses the Auth Required notice to return to reviewReady state.
  void dismissAuthRequired() {
    if (state.uiState == BookingReviewUiState.authRequired) {
      state = state.copyWith(
        uiState: BookingReviewUiState.reviewReady,
        clearError: true,
      );
    }
  }

  /// Retries the current failed operation based on lastFailedOperation.
  Future<void> retry() async {
    if (state.uiState != BookingReviewUiState.networkError) return;

    if (state.lastFailedOperation == BookingReviewOperation.bookingSubmission) {
      if (state.authToken != null && state.authToken!.trim().isNotEmpty) {
        state = state.copyWith(
          uiState: BookingReviewUiState.submitting,
          clearError: true,
        );
        await _executeBookingSubmission();
      } else {
        state = state.copyWith(
          uiState: BookingReviewUiState.authRequired,
          errorMessage: 'تسجيل الدخول مطلوب لإرسال طلب الحجز للمالك.',
        );
      }
    } else {
      // Default to quote calculation / revalidation
      await revalidateQuote();
    }
  }
}
