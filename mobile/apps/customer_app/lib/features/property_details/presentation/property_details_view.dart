import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../discovery/data/public_property.dart';
import '../application/property_details_controller.dart';
import '../data/property_details_models.dart';
import 'widgets/amenities_bottom_sheet.dart';
import 'widgets/guest_stepper.dart';
import 'widgets/inline_availability_calendar.dart';
import 'widgets/property_facts_bar.dart';
import 'widgets/property_gallery.dart';
import 'widgets/property_sticky_bar.dart';
import 'widgets/quote_breakdown_card.dart';
import '../../booking_review/data/booking_review_models.dart';
import '../../booking_review/presentation/booking_review_view.dart';

class PropertyDetailsView extends ConsumerStatefulWidget {
  const PropertyDetailsView({
    super.key,
    required this.propertyId,
    this.initialProperty,
  });

  final String propertyId;
  final PublicProperty? initialProperty;

  @override
  ConsumerState<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends ConsumerState<PropertyDetailsView> {
  final _scrollController = ScrollController();
  final _calendarKey = GlobalKey();
  bool _isDescriptionExpanded = false;

  static final _currencyFormat = NumberFormat('#,##0.##', 'en');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final initialDetail = widget.initialProperty != null
          ? _convertInitialProperty(widget.initialProperty!)
          : null;
      ref
          .read(propertyDetailsControllerProvider(widget.propertyId).notifier)
          .load(initialProperty: initialDetail);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static PublicPropertyDetail _convertInitialProperty(PublicProperty p) {
    return PublicPropertyDetail(
      id: p.id,
      title: p.title,
      unitType: p.unitType,
      propertyType: p.propertyType,
      address: p.address,
      region: p.region,
      resortName: p.resortName,
      bedrooms: p.bedrooms,
      bathrooms: p.bathrooms,
      maxGuests: p.maxGuests,
      basePricePerNight: p.basePricePerNight,
      currency: p.currency,
      images: p.images,
    );
  }

  void _scrollToCalendar() {
    final targetContext = _calendarKey.currentContext;
    if (targetContext != null && _scrollController.hasClients) {
      final box = targetContext.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = _scrollController.position;
        final viewport = RenderAbstractViewport.of(box);
        final reveal = viewport.getOffsetToReveal(box, 0.0);
        final topInset = MediaQuery.paddingOf(context).top + 16.0;
        final targetOffset = (reveal.offset - topInset).clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        );
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        return;
      }
    }
  }

  void _onReviewBooking() {
    final state = ref.read(propertyDetailsControllerProvider(widget.propertyId));
    final prop = state.property;
    final quote = state.quote;
    final checkIn = state.selectedCheckIn;
    final checkOut = state.selectedCheckOut;
    final guests = state.selectedGuests;

    if (prop == null || quote == null || checkIn == null || checkOut == null) {
      return;
    }

    final nights = checkOut.difference(checkIn).inDays;
    if (nights < 2 || nights > 30) {
      return;
    }

    final reviewContext = BookingReviewContext(
      propertyId: prop.id,
      propertyTitle: prop.title,
      propertyLocation: prop.resortName ?? prop.region ?? prop.address,
      propertyImage: prop.images.isNotEmpty ? prop.images.first.toString() : null,
      initialQuote: quote,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BookingRequestReviewView(
          reviewContext: reviewContext,
          onEditDetails: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyDetailsControllerProvider(widget.propertyId));
    final controller = ref.read(propertyDetailsControllerProvider(widget.propertyId).notifier);

    // If loading initial property without cache
    if (state.property == null && state.propertyError == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF101723)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If property query failed
    if (state.propertyError != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF101723)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StateView(
              kind: StateKind.error,
              heading: 'تعذر تحميل بيانات الإقامة',
              explanation: state.propertyError!,
              recoveryLabel: 'إعادة المحاولة',
              onRecovery: () => controller.load(),
            ),
          ),
        ),
      );
    }

    final prop = state.property!;

    // Location formatting
    final location = [prop.resortName, prop.region]
        .whereType<String>()
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .join(' · ');

    final displayLocation = location.isNotEmpty ? location : prop.address;

    final topPadding = MediaQuery.paddingOf(context).top;

    return PopScope(
      canPop: true,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final scrollOffset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          final progress = ((scrollOffset - 60) / 100).clamp(0.0, 1.0);
          final isScrolled = progress >= 0.7;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isScrolled ? Brightness.dark : Brightness.light,
              statusBarBrightness:
                  isScrolled ? Brightness.light : Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [
            // 1. Hero Gallery
            PropertyGallery(
              images: prop.images,
              isFavorite: false,
              onToggleFavorite: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'يرجى تسجيل الدخول لحفظ هذا العقار في قائمتك المفضلة.',
                      textDirection: TextDirection.rtl,
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              onBack: () => Navigator.of(context).pop(),
            ),

            // 2. Main Body Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title & Subtitle/Price Section (Calm editorial hierarchy)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prop.title,
                        style: KonfrmTypography.pageTitle.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF101723),
                          height: 1.48,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 280 ||
                              MediaQuery.textScalerOf(context).scale(1) > 1.3;
                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: Color(0xFF69788D),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        displayLocation,
                                        style: KonfrmTypography.supporting.copyWith(
                                          color: const Color(0xFF69788D),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '${_currencyFormat.format(prop.basePricePerNight)} ج.م',
                                        textDirection: TextDirection.rtl,
                                        style: KonfrmTypography.sectionTitle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF101723),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'لليلة',
                                        style: KonfrmTypography.supporting.copyWith(
                                          color: const Color(0xFF718095),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Location
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: Color(0xFF69788D),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        displayLocation,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: KonfrmTypography.supporting.copyWith(
                                          color: const Color(0xFF69788D),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Nightly Base Price
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${_currencyFormat.format(prop.basePricePerNight)} ج.م',
                                      textDirection: TextDirection.rtl,
                                      style: KonfrmTypography.sectionTitle.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF101723),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'لليلة',
                                      style: KonfrmTypography.supporting.copyWith(
                                        color: const Color(0xFF718095),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),


                  // Facts Bar
                  PropertyFactsBar(
                    maxGuests: prop.maxGuests,
                    bedrooms: prop.bedrooms,
                    bathrooms: prop.bathrooms,
                  ),

                  // Description Section (Omitted if null/empty)
                  if (prop.description != null && prop.description!.isNotEmpty) ...[
                    Text(
                      'عن الإقامة',
                      style: KonfrmTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101723),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prop.description!,
                      maxLines: _isDescriptionExpanded ? null : 3,
                      overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: KonfrmTypography.body.copyWith(
                        color: const Color(0xFF526276),
                        fontSize: 12.6,
                        height: 2.0,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: const Color(0xFF276EF1),
                        ),
                        onPressed: () {
                          setState(() {
                            _isDescriptionExpanded = !_isDescriptionExpanded;
                          });
                        },
                        icon: Icon(
                          _isDescriptionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 16,
                        ),
                        label: Text(
                          _isDescriptionExpanded ? 'عرض أقل' : 'عرض المزيد',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Key Amenities Preview (Omitted if empty)
                  if (prop.amenities.isNotEmpty) ...[
                    Text(
                      'أبرز المرافق',
                      style: KonfrmTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101723),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AmenitiesGrid(amenities: prop.amenities.take(4).toList()),
                    if (prop.amenities.length > 4) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: const Color(0xFF276EF1),
                          ),
                          onPressed: () => AmenitiesBottomSheet.show(context, prop.amenities),
                          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                          label: const Text(
                            'عرض جميع المرافق',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],

                  // Hairline Divider
                  const Divider(color: Color(0xFFE7EBEF), height: 1),
                  const SizedBox(height: 22),

                  // Booking Decision Section ("اختار إقامتك")
                  Container(
                    key: _calendarKey,
                    child: Text(
                      'اختار إقامتك',
                      style: KonfrmTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101723),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Always-Inline Calendar
                  InlineAvailabilityCalendar(
                    currentMonth: state.currentMonth,
                    availability: state.availability,
                    isLoadingAvailability: state.isLoadingAvailability,
                    availabilityError: state.availabilityError,
                    selectedCheckIn: state.selectedCheckIn,
                    selectedCheckOut: state.selectedCheckOut,
                    calendarError: state.calendarError,
                    onSelectDate: controller.selectDate,
                    onNextMonth: controller.nextMonth,
                    onPreviousMonth: controller.previousMonth,
                    onRetryAvailability: () => controller.load(initialProperty: prop),
                  ),

                  // Guest Stepper
                  GuestStepper(
                    guests: state.selectedGuests,
                    maxGuests: state.maxGuests,
                    onIncrement: controller.incrementGuests,
                    onDecrement: controller.decrementGuests,
                  ),

                  const SizedBox(height: 24),

                  // Quote Breakdown Card
                  QuoteBreakdownCard(
                    selectedCheckIn: state.selectedCheckIn,
                    selectedCheckOut: state.selectedCheckOut,
                    isCalculating: state.isCalculatingQuote,
                    quote: state.quote,
                    quoteError: state.quoteError,
                    onRetryQuote: controller.calculateQuote,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Unobtrusive Top Status-Bar Scrim when body scrolls beneath status bar
        if (topPadding > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPadding,
            child: IgnorePointer(
              child: Container(
                color: Colors.white.withValues(alpha: progress),
              ),
            ),
          ),
      ],
    ),

    // Pinned Sticky Decision Bar
    bottomNavigationBar: PropertyStickyBar(
      basePricePerNight: prop.basePricePerNight,
      hasCheckIn: state.selectedCheckIn != null,
      hasCheckOut: state.selectedCheckOut != null,
      isCalculating: state.isCalculatingQuote,
      hasQuoteError: state.quoteError != null,
      quote: state.quote,
      onTapCta: () {
        if (state.selectedCheckIn == null || state.selectedCheckOut == null) {
          _scrollToCalendar();
        } else if (state.quoteError != null || state.quote == null) {
          controller.calculateQuote();
        } else if (state.quote != null) {
          _onReviewBooking();
        }
      },
    ),
  ),
);
},
),
);
}
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    final items = AmenitiesBottomSheet.normalizeAndDeduplicate(amenities);
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 18) / 2;
        return Wrap(
          spacing: 18,
          runSpacing: 14,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 17,
                    color: const Color(0xFF64768B),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF37455A),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
