import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/search_intent_controller.dart';
import '../data/search_intent_models.dart';
import 'widgets/guest_stepper_field.dart';
import 'widgets/price_ceiling_slider.dart';
import 'widgets/region_multiselect_sheet.dart';
import 'widgets/stay_dates_intent_picker.dart';
import 'widgets/unit_type_selector.dart';

/// Screen 04: Search & Refine (`SearchRefineView`).
///
/// Dedicated full-page route (`FULL_PAGE_NESTED`) for comprehensive
/// search parameter configuration across destinations, dates, guests,
/// unit types, and price ceilings.
class SearchRefineView extends ConsumerStatefulWidget {
  const SearchRefineView({super.key, this.initialIntent, this.onApplySearch});

  /// Optional initial intent to populate draft state.
  final SearchIntent? initialIntent;

  /// Optional callback when search is applied.
  final ValueChanged<SearchIntent>? onApplySearch;

  /// Static helper to navigate to Screen 04 as a full-page route.
  static Future<SearchIntent?> push(
    BuildContext context, {
    SearchIntent? initialIntent,
  }) {
    return Navigator.of(context).push<SearchIntent>(
      MaterialPageRoute(
        builder: (context) => SearchRefineView(initialIntent: initialIntent),
      ),
    );
  }

  @override
  ConsumerState<SearchRefineView> createState() => _SearchRefineViewState();
}

class _SearchRefineViewState extends ConsumerState<SearchRefineView> {
  late SearchIntent _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialIntent ?? ref.read(searchIntentControllerProvider);
  }

  void _resetDraft() {
    setState(() {
      _draft = SearchIntent.empty;
    });
  }

  Future<void> _openRegionSelector() async {
    final metadata = ref.read(filterMetadataProvider);
    final selected = await RegionMultiSelectSheet.show(
      context: context,
      initialSelected: _draft.selectedRegions,
      availableDestinations: metadata.availableDestinations,
    );

    if (selected != null) {
      setState(() {
        _draft = _draft.copyWith(selectedRegions: selected);
      });
    }
  }

  void _applyAndClose() {
    // Save draft intent to Riverpod provider
    ref.read(searchIntentControllerProvider.notifier).updateIntent(_draft);
    if (widget.onApplySearch != null) {
      widget.onApplySearch!(_draft);
    }
    Navigator.of(context).pop(_draft);
  }

  @override
  Widget build(BuildContext context) {
    final metadata = ref.watch(filterMetadataProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            key: const Key('search-refine-back-button'),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF0F172A),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'ابحث عن إقامتك',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          centerTitle: false,
          actions: [
            if (_draft.hasActiveFilters)
              TextButton(
                key: const Key('search-refine-reset-button'),
                onPressed: _resetDraft,
                child: const Text(
                  'إعادة ضبط',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            const SizedBox(width: 8),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // 1. Destination Section
            const Text(
              'وجهة السفر',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              button: true,
              label: 'تحديد وجهة السفر: ${_draft.destinationSummaryText}',
              child: InkWell(
                key: const Key('search-refine-destination-trigger'),
                onTap: _openRegionSelector,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _draft.selectedRegions.isNotEmpty
                          ? const Color(0xFF000000)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 22,
                        color: Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _draft.destinationSummaryText,
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: _draft.selectedRegions.isNotEmpty
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: _draft.selectedRegions.isNotEmpty
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_left_rounded,
                        size: 22,
                        color: Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Stay Dates Intent Section
            StayDatesIntentPicker(
              checkInDate: _draft.checkInDate,
              checkOutDate: _draft.checkOutDate,
              onDatesChanged: (inDate, outDate) {
                setState(() {
                  _draft = _draft.copyWith(
                    checkInDate: inDate,
                    checkOutDate: outDate,
                  );
                });
              },
              onClearDates: () {
                setState(() {
                  _draft = _draft.copyWith(
                    clearCheckIn: true,
                    clearCheckOut: true,
                  );
                });
              },
            ),
            const SizedBox(height: 24),

            // 3. Guest Stepper Section
            GuestStepperField(
              guestCount: _draft.guestCount,
              onChanged: (count) {
                setState(() {
                  _draft = _draft.copyWith(guestCount: count);
                });
              },
            ),
            const SizedBox(height: 24),

            // 4. Unit Types Chips Section
            UnitTypeSelector(
              selectedUnitTypes: _draft.selectedUnitTypes,
              onToggle: (type) {
                setState(() {
                  final current = List<String>.from(_draft.selectedUnitTypes);
                  if (current.contains(type)) {
                    current.remove(type);
                  } else {
                    current.add(type);
                  }
                  _draft = _draft.copyWith(selectedUnitTypes: current);
                });
              },
              onClearAll: () {
                setState(() {
                  _draft = _draft.copyWith(selectedUnitTypes: const []);
                });
              },
            ),
            const SizedBox(height: 24),

            // 5. Price Ceiling Slider Section
            PriceCeilingSlider(
              maxPrice: _draft.maxPricePerNight,
              maxInventoryPrice: metadata.priceCeiling,
              onChanged: (val) {
                setState(() {
                  _draft = _draft.copyWith(
                    maxPricePerNight: val,
                    clearMaxPrice: val == null,
                  );
                });
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                key: const Key('search-refine-apply-button'),
                onPressed: _applyAndClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'عرض النتائج',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
