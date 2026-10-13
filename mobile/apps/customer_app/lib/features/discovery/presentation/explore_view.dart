import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/public_discovery_controller.dart';
import '../application/search_intent_controller.dart';
import '../data/search_intent_models.dart';

import 'search_refine_view.dart';
import 'search_results_view.dart';
import 'widgets/avatar_candidates.dart';
import 'widgets/explore_header.dart';
import 'widgets/explore_search_trigger.dart';
import 'widgets/public_property_card.dart';
import 'widgets/region_multiselect_sheet.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({
    super.key,
    this.userName,
    this.avatarUrl,
    this.location,
    this.onAccountTap,
    this.onNotificationTap,
    this.showNotification = false,
    this.avatarStyle = AvatarCandidateStyle.branded,
  });

  final String? userName;
  final String? avatarUrl;
  final String? location;
  final VoidCallback? onAccountTap;
  final VoidCallback? onNotificationTap;
  final bool showNotification;
  final AvatarCandidateStyle avatarStyle;

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  SearchIntent get _intent => ref.watch(searchIntentControllerProvider);

  List<String> get _selectedRegions => _intent.selectedRegions;

  void _searchNow() {
    final intent = ref.read(searchIntentControllerProvider);
    ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(intent.toSearchFilters());
  }

  Future<void> _refresh() async {
    final intent = ref.read(searchIntentControllerProvider);
    await ref
        .read(publicDiscoveryControllerProvider.notifier)
        .load(intent.toSearchFilters());
  }

  Future<void> _openSearchAndRefine({bool focusOnRefine = false}) async {
    final currentIntent = ref.read(searchIntentControllerProvider);
    final metadata = ref.read(filterMetadataProvider);
    final discoveryState = ref.read(publicDiscoveryControllerProvider);

    if (focusOnRefine) {
      final applied = await SearchRefineView.push(
        context,
        initialIntent: currentIntent,
      );
      if (applied != null && mounted) {
        ref.read(searchIntentControllerProvider.notifier).updateIntent(applied);
        ref
            .read(publicDiscoveryControllerProvider.notifier)
            .load(applied.toSearchFilters());
        await SearchResultsView.push(context, intent: applied);
      }
    } else {
      final selectedRegions = await RegionMultiSelectSheet.show(
        context: context,
        initialSelected: currentIntent.selectedRegions,
        availableDestinations: metadata.availableDestinations,
        isLoading: discoveryState.isLoading,
        hasError: discoveryState.canRetry,
      );
      if (selectedRegions != null && mounted) {
        final draftIntent = currentIntent.copyWith(
          selectedRegions: selectedRegions,
        );

        if (selectedRegions.isNotEmpty) {
          // Advance to Screen 04 Search & Refine (Option A approved flow)
          final applied = await SearchRefineView.push(
            context,
            initialIntent: draftIntent,
          );
          if (applied != null && mounted) {
            ref
                .read(searchIntentControllerProvider.notifier)
                .updateIntent(applied);
            ref
                .read(publicDiscoveryControllerProvider.notifier)
                .load(applied.toSearchFilters());
            await SearchResultsView.push(context, intent: applied);
          }
        } else {
          ref
              .read(searchIntentControllerProvider.notifier)
              .updateIntent(draftIntent);
          ref
              .read(publicDiscoveryControllerProvider.notifier)
              .load(draftIntent.toSearchFilters());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicDiscoveryControllerProvider);
    final intent = _intent;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        key: const Key('explore-scroll-view'),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
        children: [
          // Personalized Header (Founder-directed candidate)
          ExploreHeader(
            key: const Key('explore-header'),
            userName: widget.userName,
            avatarUrl: widget.avatarUrl,
            location: widget.location,
            onProfileTap: widget.onAccountTap,
            onNotificationTap: widget.onNotificationTap,
            showNotification: widget.showNotification,
            avatarStyle: widget.avatarStyle,
          ),
          const SizedBox(height: 16),

          // Pill-style Search Trigger
          ExploreSearchTrigger(
            key: const Key('explore-search-trigger'),
            selectedRegions: _selectedRegions,
            subtitle: intent.formattedDateRange,
            onTap: () => _openSearchAndRefine(focusOnRefine: false),
            onTuneTap: () => _openSearchAndRefine(focusOnRefine: true),
          ),
          const SizedBox(height: 20),

          // Results Feed
          _DiscoveryResults(state: state, intent: intent, onRetry: _searchNow),
        ],
      ),
    );
  }
}

class _DiscoveryResults extends StatelessWidget {
  const _DiscoveryResults({
    required this.state,
    this.intent,
    required this.onRetry,
  });

  final PublicDiscoveryState state;
  final SearchIntent? intent;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.status == PublicDiscoveryStatus.results) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('أماكن الإقامة', style: KonfrmTypography.sectionTitle),
          const SizedBox(height: 12),
          for (final property in state.properties) ...[
            PublicPropertyCard(property: property, intent: intent),
            const SizedBox(height: 16),
          ],
        ],
      );
    }
    if (state.status == PublicDiscoveryStatus.empty) {
      return const StructuralContainer(
        child: StateView(
          kind: StateKind.empty,
          heading: 'لا توجد نتائج حالياً',
          explanation: 'جرّب تغيير الوجهة أو تخفيف معايير البحث.',
        ),
      );
    }
    final (kind, heading, explanation) = switch (state.status) {
      PublicDiscoveryStatus.loading => (
        StateKind.loading,
        'جارٍ البحث',
        'يتم تحميل النتائج من خدمة البحث العامة.',
      ),
      PublicDiscoveryStatus.networkError => (
        StateKind.offline,
        'تعذر الاتصال',
        'تحقق من اتصال الإنترنت ثم أعد المحاولة.',
      ),
      PublicDiscoveryStatus.timeout => (
        StateKind.error,
        'استغرق البحث وقتاً أطول من المتوقع',
        'يمكنك إعادة المحاولة.',
      ),
      PublicDiscoveryStatus.serverError => (
        StateKind.error,
        'خدمة البحث غير متاحة حالياً',
        'يمكنك إعادة المحاولة لاحقاً.',
      ),
      PublicDiscoveryStatus.unauthorized => (
        StateKind.unauthorized,
        'تعذر الوصول إلى البحث العام',
        'لم يتم تحميل نتائج. حاول لاحقاً أو تواصل مع الدعم.',
      ),
      PublicDiscoveryStatus.requestRejected => (
        StateKind.error,
        'تعذر تنفيذ البحث بهذه المعايير',
        'راجع القيم وأعد المحاولة.',
      ),
      PublicDiscoveryStatus.invalidFilters => (
        StateKind.error,
        'راجع معايير البحث',
        'أدخل عدداً موجباً للضيوف وسعراً موجباً.',
      ),
      PublicDiscoveryStatus.configurationError => (
        StateKind.error,
        'البحث غير مهيأ في هذا الإصدار',
        'لا يمكن الاتصال بخدمة البحث حالياً.',
      ),
      PublicDiscoveryStatus.invalidResponse => (
        StateKind.error,
        'تعذر قراءة نتائج البحث',
        'لم يتم عرض بيانات غير مكتملة. حاول لاحقاً.',
      ),
      PublicDiscoveryStatus.results => (StateKind.empty, '', ''),
      PublicDiscoveryStatus.empty => (StateKind.empty, '', ''),
    };
    return StructuralContainer(
      child: StateView(
        kind: kind,
        heading: heading,
        explanation: explanation,
        recoveryLabel: state.canRetry ? 'إعادة المحاولة' : null,
        onRecovery: state.canRetry ? onRetry : null,
      ),
    );
  }
}
