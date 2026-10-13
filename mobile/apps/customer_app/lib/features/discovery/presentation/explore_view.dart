import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/public_discovery_controller.dart';
import '../data/public_property.dart';
import '../data/public_property_search_repository.dart';
import '../../property_details/presentation/property_details_view.dart';

import 'widgets/explore_header.dart';
import 'widgets/explore_search_trigger.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({
    super.key,
    this.userName,
    this.avatarUrl,
    this.location,
    this.onAccountTap,
    this.onNotificationTap,
    this.showNotification = false,
  });

  final String? userName;
  final String? avatarUrl;
  final String? location;
  final VoidCallback? onAccountTap;
  final VoidCallback? onNotificationTap;
  final bool showNotification;

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final PublicPropertySearchFilters _filters =
      const PublicPropertySearchFilters();

  List<String> get _selectedRegions => _filters.destinations.isNotEmpty
      ? _filters.destinations
      : (_filters.destination.trim().isNotEmpty
          ? [_filters.destination.trim()]
          : const []);

  void _searchNow() {
    ref.read(publicDiscoveryControllerProvider.notifier).load(_filters);
  }

  Future<void> _refresh() async {
    await ref.read(publicDiscoveryControllerProvider.notifier).load(_filters);
  }

  void _openSearchAndRefine({bool focusOnRefine = false}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    focusOnRefine ? 'خيارات التصفية' : 'البحث وتحديد الوجهة',
                    style: KonfrmTypography.sectionTitle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'شاشة البحث والتصفية (Screen 04) ومحدد المناطق المتعددة قيد الإعداد لمراجعة التصميم المخصصة مع المؤسس.',
                style: KonfrmTypography.body.copyWith(
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  key: const Key('search-sheet-dismiss-button'),
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'فهمت',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicDiscoveryControllerProvider);
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
          ),
          const SizedBox(height: 16),

          // Pill-style Search Trigger
          ExploreSearchTrigger(
            key: const Key('explore-search-trigger'),
            selectedRegions: _selectedRegions,
            onTap: () => _openSearchAndRefine(focusOnRefine: false),
            onTuneTap: () => _openSearchAndRefine(focusOnRefine: true),
          ),
          const SizedBox(height: 20),

          // Results Feed
          _DiscoveryResults(state: state, onRetry: _searchNow),
        ],
      ),
    );
  }
}

class _DiscoveryResults extends StatelessWidget {
  const _DiscoveryResults({required this.state, required this.onRetry});

  final PublicDiscoveryState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.status == PublicDiscoveryStatus.results) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('نتائج البحث', style: KonfrmTypography.sectionTitle),
          const SizedBox(height: 12),
          for (final property in state.properties) ...[
            _PublicPropertyCard(property: property),
            const SizedBox(height: 12),
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
  const _PublicPropertyCard({required this.property});

  final PublicProperty property;

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
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: property.images.isEmpty
                      ? const _PropertyImagePlaceholder()
                      : Image.network(
                          property.images.first.toString(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const _PropertyImagePlaceholder(),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(property.title, style: KonfrmTypography.sectionTitle),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(location, style: KonfrmTypography.supporting),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 14,
                      runSpacing: 6,
                      children: [
                        _PropertyFact(
                          icon: Icons.home_outlined,
                          label: _unitTypeLabel(property.unitType),
                        ),
                        _PropertyFact(
                          icon: Icons.bed_outlined,
                          label: '${property.bedrooms} غرف نوم',
                        ),
                        _PropertyFact(
                          icon: Icons.bathtub_outlined,
                          label: '${property.bathrooms} حمامات',
                        ),
                        _PropertyFact(
                          icon: Icons.people_outline,
                          label: '${property.maxGuests} ضيوف',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${NumberFormat('#,##0.##', 'en').format(property.basePricePerNight)} ج.م / ليلة',
                      textDirection: ui.TextDirection.rtl,
                      style: KonfrmTypography.sectionTitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

  String _unitTypeLabel(String unitType) => switch (unitType.toUpperCase()) {
    'CHALET' => 'شاليه',
    'VILLA' => 'فيلا',
    'APARTMENT' => 'شقة',
    'STUDIO' => 'استوديو',
    'CABIN' => 'كوخ',
    _ => 'مكان للإقامة',
  };
}

class _PropertyFact extends StatelessWidget {
  const _PropertyFact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: KonfrmColors.primary),
      const SizedBox(width: 4),
      Text(label, style: KonfrmTypography.supporting),
    ],
  );
}

class _PropertyImagePlaceholder extends StatelessWidget {
  const _PropertyImagePlaceholder();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Color(0xFFF1F5F9),
    child: Center(
      child: Icon(Icons.image_outlined, size: 36, color: Color(0xFF64748B)),
    ),
  );
}
