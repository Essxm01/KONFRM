import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/public_discovery_controller.dart';
import '../application/search_intent_controller.dart';
import '../data/search_intent_models.dart';
import 'search_refine_view.dart';
import 'widgets/active_filter_chips_row.dart';
import 'widgets/property_card_skeleton.dart';
import 'widgets/public_property_card.dart';
import 'widgets/region_multiselect_sheet.dart';
import 'widgets/search_results_summary_bar.dart';

/// Screen 05: Search Results (`SearchResultsView`).
///
/// Dedicated full-screen search results view in the Customer journey.
///
/// Architecture & Governance Invariants:
/// - Compact white header with Arabic title «نتائج البحث» and RTL back navigation.
/// - Concise Search Summary Bar with low vertical footprint (~52dp).
/// - Horizontally scrollable row of active filter chips with dual-zone interaction:
///   * Tap content -> opens relevant filter editor preserving existing selections.
///   * Tap explicit [×] -> removes ONLY that individual parameter without clearing others.
/// - Authentic property cards reusing the approved compact card design (1.45 photo ratio, unboxed facts).
/// - Calm geometric skeleton loading, truthful empty, and offline error states.
/// - Search dates are customer intent ONLY and never sent to public search API (MR-11 & P5/C2).
class SearchResultsView extends ConsumerStatefulWidget {
  const SearchResultsView({super.key, this.initialIntent});

  /// Optional initial intent to initialize or update provider with.
  final SearchIntent? initialIntent;

  /// Helper to push Screen 05 as a dedicated route.
  static Future<void> push(BuildContext context, {SearchIntent? intent}) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => SearchResultsView(initialIntent: intent),
      ),
    );
  }

  @override
  ConsumerState<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends ConsumerState<SearchResultsView> {
  @override
  void initState() {
    super.initState();
    if (widget.initialIntent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final current = ref.read(searchIntentControllerProvider);
        if (widget.initialIntent != current) {
          ref
              .read(searchIntentControllerProvider.notifier)
              .updateIntent(widget.initialIntent!);
          ref
              .read(publicDiscoveryControllerProvider.notifier)
              .load(widget.initialIntent!.toSearchFilters());
        }
      });
    }
  }

  Future<void> _refresh() async {
    final intent = ref.read(searchIntentControllerProvider);
    await ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(intent.toSearchFilters());
  }

  Future<void> _openSearchRefine() async {
    final currentIntent = ref.read(searchIntentControllerProvider);
    final applied = await SearchRefineView.push(
      context,
      initialIntent: currentIntent,
    );

    if (applied != null && mounted) {
      ref.read(searchIntentControllerProvider.notifier).updateIntent(applied);
      ref
          .read(publicDiscoveryControllerProvider.notifier)
          .load(applied.toSearchFilters());
    }
  }

  Future<void> _openRegionSelector() async {
    final currentIntent = ref.read(searchIntentControllerProvider);
    final metadata = ref.read(filterMetadataProvider);
    final discoveryState = ref.read(publicDiscoveryControllerProvider);

    final selected = await RegionMultiSelectSheet.show(
      context: context,
      initialSelected: currentIntent.selectedRegions,
      availableDestinations: metadata.availableDestinations,
      isLoading: discoveryState.isLoading,
      hasError: discoveryState.canRetry,
    );

    if (selected != null && mounted) {
      final updated = currentIntent.copyWith(selectedRegions: selected);
      ref.read(searchIntentControllerProvider.notifier).updateIntent(updated);
      ref
          .read(publicDiscoveryControllerProvider.notifier)
          .load(updated.toSearchFilters());
    }
  }

  void _removeDestination(String region) {
    final current = ref.read(searchIntentControllerProvider);
    final updatedRegions = current.selectedRegions
        .where((r) => r != region)
        .toList();
    final updated = current.copyWith(selectedRegions: updatedRegions);
    ref.read(searchIntentControllerProvider.notifier).updateIntent(updated);
    ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(updated.toSearchFilters());
  }

  void _removeDates() {
    final current = ref.read(searchIntentControllerProvider);
    final updated = current.copyWith(clearCheckIn: true, clearCheckOut: true);
    ref.read(searchIntentControllerProvider.notifier).updateIntent(updated);
    ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(updated.toSearchFilters());
  }

  void _removeGuests() {
    final current = ref.read(searchIntentControllerProvider);
    final updated = current.copyWith(guestCount: 1);
    ref.read(searchIntentControllerProvider.notifier).updateIntent(updated);
    ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(updated.toSearchFilters());
  }

  void _removeUnitType(String unitType) {
    final current = ref.read(searchIntentControllerProvider);
    final updatedTypes = current.selectedUnitTypes
        .where((t) => t != unitType)
        .toList();
    final updated = current.copyWith(selectedUnitTypes: updatedTypes);
    ref.read(searchIntentControllerProvider.notifier).updateIntent(updated);
    ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(updated.toSearchFilters());
  }

  void _removePrice() {
    final current = ref.read(searchIntentControllerProvider);
    final updated = current.copyWith(clearMaxPrice: true);
    ref.read(searchIntentControllerProvider.notifier).updateIntent(updated);
    ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(updated.toSearchFilters());
  }

  @override
  Widget build(BuildContext context) {
    final intent = ref.watch(searchIntentControllerProvider);
    final state = ref.watch(publicDiscoveryControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            key: const Key('search-results-back-button'),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF0F172A),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'نتائج البحث',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          centerTitle: false,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: const Color(0xFF000000),
          child: ListView(
            key: const Key('search-results-scroll-view'),
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              // 1. Search Summary Bar
              SearchResultsSummaryBar(intent: intent, onTap: _openSearchRefine),
              const SizedBox(height: 10),

              // 2. Active Filter Chips Row
              ActiveFilterChipsRow(
                intent: intent,
                onEditDestination: _openRegionSelector,
                onRemoveDestination: _removeDestination,
                onEditDates: _openSearchRefine,
                onRemoveDates: _removeDates,
                onEditGuests: _openSearchRefine,
                onRemoveGuests: _removeGuests,
                onEditUnitTypes: _openSearchRefine,
                onRemoveUnitType: _removeUnitType,
                onEditPrice: _openSearchRefine,
                onRemovePrice: _removePrice,
              ),
              if (intent.hasActiveFilters) const SizedBox(height: 12),

              // 3. Section Header (Title + Result Count)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'أماكن الإقامة',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    if (state.status == PublicDiscoveryStatus.results)
                      Flexible(
                        child: Text(
                          '${state.properties.length} مكان للإقامة',
                          key: const Key('search-results-count-text'),
                          style: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. Content Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildResultsContent(state, intent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsContent(PublicDiscoveryState state, SearchIntent intent) {
    // A. Results State
    if (state.status == PublicDiscoveryStatus.results) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final property in state.properties) ...[
            PublicPropertyCard(
              key: Key('search-results-card-${property.id}'),
              property: property,
              intent: intent,
            ),
            const SizedBox(height: 16),
          ],
        ],
      );
    }

    // B. Loading Skeleton State
    if (state.status == PublicDiscoveryStatus.loading) {
      return const Column(
        children: [
          PropertyCardSkeleton(),
          SizedBox(height: 16),
          PropertyCardSkeleton(),
        ],
      );
    }

    // C. Empty State
    if (state.status == PublicDiscoveryStatus.empty) {
      return StructuralContainer(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 16),
              const Text(
                'لا توجد نتائج مطابقة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'جرّب تعديل معايير البحث أو إزالة بعض الفلاتر لعرض خيارات أكثر.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  key: const Key('search-results-empty-refine-button'),
                  onPressed: _openSearchRefine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text(
                    'تعديل معايير البحث',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // D. Error and Offline States
    final (heading, explanation, canRetry) = switch (state.status) {
      PublicDiscoveryStatus.networkError => (
        'تعذر الاتصال بخدمة البحث',
        'تحقق من اتصال الإنترنت ثم أعد المحاولة.',
        true,
      ),
      PublicDiscoveryStatus.timeout => (
        'استغرق البحث وقتاً أطول من المتوقع',
        'يمكنك إعادة المحاولة الآن.',
        true,
      ),
      PublicDiscoveryStatus.serverError => (
        'خدمة البحث غير متاحة حالياً',
        'يمكنك إعادة المحاولة لاحقاً.',
        true,
      ),
      PublicDiscoveryStatus.invalidFilters => (
        'معايير البحث غير صالحة',
        'يرجى مراجعة قيم الفلاتر والمحاولة مجدداً.',
        false,
      ),
      _ => (
        'تعذر إتمام البحث',
        'حدث خطأ غير متوقع. يرجى إعادة المحاولة.',
        state.canRetry,
      ),
    };

    return StructuralContainer(
      child: StateView(
        kind: state.status == PublicDiscoveryStatus.networkError
            ? StateKind.offline
            : StateKind.error,
        heading: heading,
        explanation: explanation,
        recoveryLabel: canRetry ? 'إعادة المحاولة' : 'تعديل البحث',
        onRecovery: canRetry ? _refresh : _openSearchRefine,
      ),
    );
  }
}
