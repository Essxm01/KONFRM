import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/booking_review_controller.dart';
import '../data/booking_review_models.dart';
import 'widgets/konfrm_price_text.dart';

/// Screen 07 — Booking Request Review (Concept A V2)
///
/// Dedicated full-screen transactional review screen.
/// - Arabic-first RTL editorial presentation
/// - Compact canonical property summary
/// - Inset stay details with Arabic pluralization and `تعديل` return affordance
/// - Authoritative price breakdown with number-first currency formatting (`13,500 ج.م`)
/// - Transparent single payment disclosure: `لا يتم الدفع عند إرسال الطلب؛ العربون بعد موافقة المالك.`
/// - Safe-area-aware sticky black primary action: `إرسال طلب الحجز للمالك`
/// - Clearly visible clarification: `إرسال الطلب لا يعني تأكيد الحجز`
/// - Complete state machine: REVIEW_READY, REVALIDATING, PRICE_CHANGED, DATE_CONFLICT, NETWORK_ERROR, AUTH_REQUIRED, SUBMITTING, REQUEST_SENT
class BookingRequestReviewView extends ConsumerWidget {
  const BookingRequestReviewView({
    super.key,
    required this.reviewContext,
    required this.onEditDetails,
    this.authToken,
    this.startRevalidating = false,
  });

  final BookingReviewContext reviewContext;
  final VoidCallback onEditDetails;
  final String? authToken;
  final bool startRevalidating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveContext = reviewContext.copyWith(
      authToken: authToken ?? reviewContext.authToken,
      startRevalidating: startRevalidating,
    );
    final state = ref.watch(bookingReviewControllerProvider(effectiveContext));
    final controller = ref.read(bookingReviewControllerProvider(effectiveContext).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'مراجعة طلب الحجز',
          style: KonfrmTypography.sectionTitle.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: const Color(0xFF101723),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF101723), size: 22),
          tooltip: 'الرجوع لتفاصيل الإقامة',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  // 1. Contextual State Banners (when applicable)
                  if (state.uiState == BookingReviewUiState.revalidating) ...[
                    _RevalidatingBanner(),
                    const SizedBox(height: 16),
                  ] else if (state.uiState == BookingReviewUiState.priceChanged) ...[
                    _PriceChangedBanner(
                      previousQuote: state.previousQuote,
                      currentQuote: state.currentQuote,
                      hasPriceShift: state.hasPriceShift,
                    ),
                    const SizedBox(height: 16),
                  ] else if (state.uiState == BookingReviewUiState.dateConflict) ...[
                    _DateConflictBanner(onEdit: onEditDetails),
                    const SizedBox(height: 16),
                  ] else if (state.uiState == BookingReviewUiState.networkError) ...[
                    _NetworkErrorBanner(
                      message: state.errorMessage,
                      onRetry: controller.retry,
                    ),
                    const SizedBox(height: 16),
                  ] else if (state.uiState == BookingReviewUiState.authRequired) ...[
                    _AuthRequiredBanner(onDismiss: controller.dismissAuthRequired),
                    const SizedBox(height: 16),
                  ] else if (state.uiState == BookingReviewUiState.requestSent) ...[
                    _RequestSentCard(result: state.bookingResult),
                    const SizedBox(height: 16),
                  ],

                  // If request is sent, hide the review form to present the confirmed outcome
                  if (state.uiState != BookingReviewUiState.requestSent) ...[
                    // 3. Compact Property Summary
                    _PropertySummaryCard(
                      title: reviewContext.propertyTitle,
                      location: reviewContext.propertyLocation,
                      imageUrl: reviewContext.propertyImage,
                    ),
                    const SizedBox(height: 16),

                    // 4. Stay Details (تفاصيل الإقامة)
                    _StayDetailsCard(
                      context: reviewContext,
                      onEdit: onEditDetails,
                    ),
                    const SizedBox(height: 16),

                    // 5. Price Breakdown (تفاصيل السعر)
                    _PriceBreakdownCard(
                      quote: state.currentQuote,
                      nightsLabel: reviewContext.formattedNights,
                    ),
                    const SizedBox(height: 16),

                    // 6. Concise Financial Disclosure
                    _FinancialDisclosure(),
                  ],
                ],
              ),
            ),

            // 7. Safe-Area Aware Sticky Primary Action Bar
            _ReviewStickyBar(
              uiState: state.uiState,
              onSubmit: controller.submitBookingRequest,
              onAcceptNewPrice: controller.acceptNewPrice,
              onEditDates: onEditDetails,
              onRetry: controller.retry,
              onDone: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact Property Summary card with thumbnail, title, and public location.
class _PropertySummaryCard extends StatelessWidget {
  const _PropertySummaryCard({
    required this.title,
    required this.location,
    this.imageUrl,
  });

  final String title;
  final String location;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 72,
              height: 72,
              child: imageUrl != null && imageUrl!.trim().isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
                    )
                  : const _ImagePlaceholder(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: KonfrmTypography.cardTitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: const Color(0xFF101723),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (location.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location,
                          style: KonfrmTypography.supporting.copyWith(
                            color: const Color(0xFF64748B),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Text(
          'لا توجد صورة',
          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Inset Stay Details container with dates, nights, guests, and `تعديل`.
class _StayDetailsCard extends StatelessWidget {
  const _StayDetailsCard({
    required this.context,
    required this.onEdit,
  });

  final BookingReviewContext context;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'تفاصيل الإقامة',
                  style: KonfrmTypography.sectionTitle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: const Color(0xFF101723),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: const Size(44, 44),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'تعديل',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0059FF),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFE2E8F0)),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF0059FF)),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'التواريخ (${this.context.formattedNights}):',
                        style: KonfrmTypography.body.copyWith(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        this.context.formattedStayDates,
                        style: KonfrmTypography.bodyStrong.copyWith(
                          fontSize: 13,
                          color: const Color(0xFF101723),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.people_outline, size: 16, color: Color(0xFF0059FF)),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'عدد الضيوف:',
                        style: KonfrmTypography.body.copyWith(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      this.context.formattedGuests,
                      style: KonfrmTypography.bodyStrong.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF101723),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Price Breakdown section with prominent total stay and directionality-isolated currency.
class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard({
    required this.quote,
    required this.nightsLabel,
  });

  final BookingQuote quote;
  final String nightsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تفاصيل السعر',
            style: KonfrmTypography.sectionTitle.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: const Color(0xFF101723),
            ),
          ),
          const SizedBox(height: 12),

          // 1. Strongest Financial Anchor: إجمالي الإقامة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'إجمالي الإقامة ($nightsLabel):',
                  style: KonfrmTypography.bodyStrong.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101723),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: KonfrmPriceText(
                    amount: quote.totalStay,
                    amountStyle: KonfrmTypography.pageTitle.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF101723),
                    ),
                    currencyStyle: KonfrmTypography.pageTitle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101723),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // 2. Deposit Amount Highlight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'العربون بعد موافقة المالك:',
                        style: KonfrmTypography.bodyStrong.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                      Text(
                        '(ليلة واحدة فقط)',
                        style: KonfrmTypography.supporting.copyWith(
                          fontSize: 11,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: KonfrmPriceText(
                      amount: quote.depositAmount,
                      amountStyle: KonfrmTypography.bodyStrong.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0284C7),
                      ),
                      currencyStyle: KonfrmTypography.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Remaining Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'المبلغ المتبقي:',
                  style: KonfrmTypography.body.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: KonfrmPriceText(
                    amount: quote.remainingAmount,
                    amountStyle: KonfrmTypography.bodyStrong.copyWith(
                      fontSize: 13.5,
                      color: const Color(0xFF334155),
                    ),
                    currencyStyle: KonfrmTypography.body.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single concise financial disclosure required by Founder contract.
class _FinancialDisclosure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF0059FF)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'لا يتم الدفع عند إرسال الطلب؛ العربون بعد موافقة المالك.',
              style: KonfrmTypography.bodyStrong.copyWith(
                fontSize: 12.5,
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Revalidating State Banner
class _RevalidatingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0059FF)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'نتأكد من التوفر والسعر قبل الإرسال.',
              style: KonfrmTypography.body.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Price Changed State Banner with comparison
class _PriceChangedBanner extends StatelessWidget {
  const _PriceChangedBanner({
    required this.previousQuote,
    required this.currentQuote,
    required this.hasPriceShift,
  });

  final BookingQuote? previousQuote;
  final BookingQuote currentQuote;
  final bool hasPriceShift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Color(0xFF0059FF)),
              const SizedBox(width: 8),
              Text(
                hasPriceShift ? 'تم تحديث تفاصيل السعر' : 'تم تحديث تفاصيل الحجز',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hasPriceShift
                ? 'السعر الحالي مختلف عن السعر الذي راجعته آخر مرة. يرجى مراجعة المبلغ الجديد والموافقة عليه قبل إرسال الطلب.'
                : 'تم تحديث بيانات العرض من الخادم دون تغيير في السعر الإجمالي. يرجى تأكيد المراجعة للمتابعة.',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12.5,
              color: const Color(0xFF1E40AF),
            ),
          ),
          if (hasPriceShift && previousQuote != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السعر السابق', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                      KonfrmPriceText(
                        amount: previousQuote!.totalStay,
                        isStrikethrough: true,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('السعر الجديد', style: TextStyle(fontSize: 11, color: Color(0xFF0059FF), fontWeight: FontWeight.bold)),
                      KonfrmPriceText(
                        amount: currentQuote.totalStay,
                        style: const TextStyle(fontSize: 15, color: Color(0xFF1E3A8A), fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Date Conflict State Banner
class _DateConflictBanner extends StatelessWidget {
  const _DateConflictBanner({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, size: 18, color: Color(0xFFE11D48)),
              const SizedBox(width: 8),
              Text(
                'التواريخ لم تعد متاحة',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF881337),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'التواريخ المطلوبة محجوزة مسبقاً أو لم تعد متاحة. يمكنك اختيار تواريخ جديدة لتحديث السعر ومتابعة الحجز.',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12.5,
              color: const Color(0xFF9F1239),
            ),
          ),
        ],
      ),
    );
  }
}

/// Network or Server Error Banner
class _NetworkErrorBanner extends StatelessWidget {
  const _NetworkErrorBanner({this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wifi_off_outlined, size: 18, color: Color(0xFFE11D48)),
              const SizedBox(width: 8),
              Text(
                'تعذر إتمام العملية',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF881337),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message ?? 'تفاصيل طلبك ما زالت محفوظة. تحقق من الاتصال وحاول مرة أخرى.',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12.5,
              color: const Color(0xFF9F1239),
            ),
          ),
        ],
      ),
    );
  }
}

/// Truthful Auth Required Banner / Notice
class _AuthRequiredBanner extends StatelessWidget {
  const _AuthRequiredBanner({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 18, color: Color(0xFF0059FF)),
              const SizedBox(width: 8),
              Text(
                'تسجيل الدخول مطلوب لإرسال الطلب',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'خدمة تسجيل الدخول قيد التجهيز في مرحلة التوثيق القادمة. يلزم حساب عميل موثق لإرسال طلب الحجز للمالك.',
            style: KonfrmTypography.body.copyWith(
              fontSize: 12.5,
              color: const Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onDismiss,
              child: const Text('العودة للمراجعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Request Sent Success Card
class _RequestSentCard extends StatelessWidget {
  const _RequestSentCard({this.result});

  final BookingRequestResult? result;

  @override
  Widget build(BuildContext context) {
    final bookingNumber = result?.bookingNumber ?? '';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 48, color: Color(0xFF16A34A)),
          const SizedBox(height: 12),
          Text(
            'تم إرسال طلبك للمالك',
            style: KonfrmTypography.pageTitle.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 19,
              color: const Color(0xFF14532D),
            ),
            textAlign: TextAlign.center,
          ),
          if (bookingNumber.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Text(
                'رقم الطلب: $bookingNumber',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF166534)),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'طلبك قيد مراجعة المالك حالياً (الحالة: قيد مراجعة المالك).\nفي حال الموافقة، سيتاح لك دفع العربون لتأكيد الحجز.',
            style: KonfrmTypography.body.copyWith(
              fontSize: 13,
              color: const Color(0xFF166534),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Safe-Area Aware Sticky Primary Action Bar
class _ReviewStickyBar extends StatelessWidget {
  const _ReviewStickyBar({
    required this.uiState,
    required this.onSubmit,
    required this.onAcceptNewPrice,
    required this.onEditDates,
    required this.onRetry,
    required this.onDone,
  });

  final BookingReviewUiState uiState;
  final VoidCallback onSubmit;
  final VoidCallback onAcceptNewPrice;
  final VoidCallback onEditDates;
  final VoidCallback onRetry;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(context),
          if (uiState == BookingReviewUiState.reviewReady ||
              uiState == BookingReviewUiState.priceChanged) ...[
            const SizedBox(height: 8),
            Text(
              'إرسال الطلب لا يعني تأكيد الحجز',
              style: KonfrmTypography.supporting.copyWith(
                fontSize: 11.5,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    switch (uiState) {
      case BookingReviewUiState.revalidating:
        return _DisabledActionButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF94A3B8)),
              ),
              SizedBox(width: 8),
              Text('نتأكد من التوفر والسعر...'),
            ],
          ),
        );

      case BookingReviewUiState.submitting:
        return const _DisabledActionButton(
          backgroundColor: Color(0xFF000000),
          textColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 8),
              Text('جاري إرسال الطلب...'),
            ],
          ),
        );

      case BookingReviewUiState.priceChanged:
        return _PrimaryActionButton(
          label: 'قبول السعر الجديد ومتابعة المراجعة',
          onPressed: onAcceptNewPrice,
          backgroundColor: const Color(0xFF000000),
        );

      case BookingReviewUiState.dateConflict:
        return _PrimaryActionButton(
          label: 'اختيار تواريخ جديدة',
          onPressed: onEditDates,
          backgroundColor: const Color(0xFF0059FF),
        );

      case BookingReviewUiState.networkError:
        return _PrimaryActionButton(
          label: 'إعادة المحاولة',
          onPressed: onRetry,
          backgroundColor: const Color(0xFF0059FF),
        );

      case BookingReviewUiState.authRequired:
        return _PrimaryActionButton(
          label: 'تسجيل الدخول (قيد التجهيز)',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تسجيل الدخول غير متاح حالياً في هذه النسخة التجريبية. يلزم حساب عميل لإرسال طلب الحجز.',
                ),
              ),
            );
          },
          backgroundColor: const Color(0xFF000000),
        );

      case BookingReviewUiState.requestSent:
        return _PrimaryActionButton(
          label: 'العودة للاستكشاف',
          onPressed: onDone,
          backgroundColor: const Color(0xFF000000),
        );

      case BookingReviewUiState.reviewReady:
        return _PrimaryActionButton(
          label: 'إرسال طلب الحجز للمالك',
          onPressed: onSubmit,
          backgroundColor: const Color(0xFF000000),
        );
    }
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // 6px Primary Button radius per Phase 4C / Master Rules
          ),
          textStyle: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label),
        ),
      ),
    );
  }
}

class _DisabledActionButton extends StatelessWidget {
  const _DisabledActionButton({
    required this.child,
    this.backgroundColor = const Color(0xFFE2E8F0),
    this.textColor = const Color(0xFF64748B),
  });

  final Widget child;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: child,
        ),
      ),
    );
  }
}
