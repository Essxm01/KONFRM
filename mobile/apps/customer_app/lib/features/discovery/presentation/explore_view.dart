import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/public_discovery_controller.dart';
import '../application/search_intent_controller.dart';
import '../data/public_property.dart';
import '../data/search_intent_models.dart';
import '../../booking_review/presentation/widgets/konfrm_price_text.dart';
import '../../property_details/presentation/property_details_view.dart';

import 'search_refine_view.dart';
import 'widgets/avatar_candidates.dart';
import 'widgets/explore_header.dart';
import 'widgets/explore_search_trigger.dart';
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
          _DiscoveryResults(
            state: state,
            intent: intent,
            onRetry: _searchNow,
          ),
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
            _PublicPropertyCard(property: property, intent: intent),
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

class _PublicPropertyCard extends StatelessWidget {
  const _PublicPropertyCard({required this.property, this.intent});

  final PublicProperty property;
  final SearchIntent? intent;

  @override
  Widget build(BuildContext context) {
    final location = [property.resortName, property.region, property.address]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toSet()
        .join('، ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: StructuralContainer(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          excludeFromSemantics: true,
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PropertyDetailsView(
                  propertyId: property.id,
                  initialProperty: property,
                  initialCheckIn: intent?.checkInDate,
                  initialCheckOut: intent?.checkOutDate,
                  initialGuests:
                      (intent != null && intent!.guestCount > 1)
                          ? intent!.guestCount
                          : null,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image + Vignette Scrim + Favorite Action
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.45,
                      child: property.images.isEmpty
                          ? const _PropertyImagePlaceholder()
                          : Image.network(
                              property.images.first.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _PropertyImagePlaceholder(),
                            ),
                    ),
                    // Subtle vignette gradient for upper controls
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.22),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Favorite Heart Action (48dp touch target, top-left in RTL)
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: _FavoriteHeartButton(
                        propertyId: property.id,
                        propertyTitle: property.title,
                      ),
                    ),
                  ],
                ),
              ),
              // Compact Content Block
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Property Name / Title
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Secondary Location Line
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Compact Unboxed Property Facts Row
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_informativeUnitType(
                              property.unitType,
                              property.propertyType,
                            ) !=
                            null)
                          _PropertyFactItem(
                            icon: Icons.home_outlined,
                            label: _informativeUnitType(
                              property.unitType,
                              property.propertyType,
                            )!,
                          ),
                        _PropertyFactItem(
                          icon: Icons.bed_outlined,
                          label: '${property.bedrooms} غرف نوم',
                        ),
                        _PropertyFactItem(
                          icon: Icons.bathtub_outlined,
                          label: '${property.bathrooms} حمام',
                        ),
                        _PropertyFactItem(
                          icon: Icons.people_outline,
                          label: '${property.maxGuests} ضيوف',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Prominent Nightly Price Anchor
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      textDirection: ui.TextDirection.rtl,
                      children: [
                        KonfrmPriceText(
                          amount: property.basePricePerNight,
                          amountStyle: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                          currencyStyle: const TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                        ),
                        const Text(
                          '/ ليلة',
                          textDirection: ui.TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _informativeUnitType(String unitType, String? propertyType) {
    final candidates = [unitType, propertyType ?? ''];
    for (final raw in candidates) {
      final normalized = raw.trim().toUpperCase();
      if (normalized.isEmpty) continue;
      switch (normalized) {
        case 'CHALET':
        case 'شاليه':
          return 'شاليه';
        case 'VILLA':
        case 'فيلا':
          return 'فيلا';
        case 'APARTMENT':
        case 'شقة':
          return 'شقة';
        case 'STUDIO':
        case 'استوديو':
          return 'استوديو';
        case 'CABIN':
        case 'كوخ':
          return 'كوخ';
        case 'TOWNHOUSE':
        case 'تاون هاوس':
          return 'تاون هاوس';
        case 'PENTHOUSE':
        case 'بنتهاوس':
          return 'بنتهاوس';
        case 'TWINHOUSE':
        case 'توين هاوس':
          return 'توين هاوس';
        case 'DUPLEX':
        case 'دوبلكس':
          return 'دوبلكس';
      }
    }
    return null;
  }
}

class _FavoriteHeartButton extends StatefulWidget {
  const _FavoriteHeartButton({
    required this.propertyId,
    required this.propertyTitle,
  });

  final String propertyId;
  final String propertyTitle;

  @override
  State<_FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<_FavoriteHeartButton> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'تمت إضافة "${widget.propertyTitle}" إلى المفضلة (جلسة حالية).'
              : 'تمت إزالة "${widget.propertyTitle}" من المفضلة.',
          textDirection: ui.TextDirection.rtl,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
      child: GestureDetector(
        key: Key('property-favorite-heart-${widget.propertyId}'),
        behavior: HitTestBehavior.opaque,
        onTap: _toggleFavorite,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.92),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 20,
                  color: _isFavorite
                      ? const Color(0xFFE34154)
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PropertyFactItem extends StatelessWidget {
  const _PropertyFactItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _PropertyImagePlaceholder extends StatelessWidget {
  const _PropertyImagePlaceholder();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Color(0xFFF1F5F9),
    child: Center(
      child: Icon(Icons.image_rounded, size: 36, color: Color(0xFF64748B)),
    ),
  );
}
