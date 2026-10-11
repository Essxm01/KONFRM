import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../application/public_discovery_controller.dart';
import '../data/public_property.dart';
import '../data/public_property_search_repository.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final _destinationController = TextEditingController();
  final _guestsController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String _unitType = '';
  Timer? _debounce;
  String? _guestsError;
  String? _priceError;

  @override
  void dispose() {
    _debounce?.cancel();
    _destinationController.dispose();
    _guestsController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  PublicPropertySearchFilters get _filters => PublicPropertySearchFilters(
    destination: _destinationController.text,
    unitType: _unitType,
    guests: int.tryParse(_guestsController.text.trim()),
    maxPrice: double.tryParse(_maxPriceController.text.trim()),
  );

  bool _validateFilters() {
    final guestsText = _guestsController.text.trim();
    final priceText = _maxPriceController.text.trim();
    final guests = int.tryParse(guestsText);
    final price = double.tryParse(priceText);
    final guestsError = guestsText.isNotEmpty && (guests == null || guests < 1)
        ? 'أدخل عدداً صحيحاً موجباً'
        : null;
    final priceError =
        priceText.isNotEmpty && (price == null || !price.isFinite || price <= 0)
        ? 'أدخل سعراً موجباً'
        : null;
    if (_guestsError != guestsError || _priceError != priceError) {
      setState(() {
        _guestsError = guestsError;
        _priceError = priceError;
      });
    }
    return guestsError == null && priceError == null;
  }

  void _scheduleSearch() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        _searchNow();
      }
    });
  }

  void _searchNow() {
    _debounce?.cancel();
    if (!_validateFilters()) return;
    ref.read(publicDiscoveryControllerProvider.notifier).load(_filters);
  }

  Future<void> _refresh() async {
    if (!_validateFilters()) return;
    await ref.read(publicDiscoveryControllerProvider.notifier).load(_filters);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicDiscoveryControllerProvider);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        key: const Key('explore-scroll-view'),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 24),
        children: [
          Text('كونفرم | استكشف', style: KonfrmTypography.display),
          const SizedBox(height: 6),
          Text(
            'ابحث عن بيوت العطلات والشاليهات الموثقة',
            style: KonfrmTypography.body,
          ),
          const SizedBox(height: 18),
          SearchField(
            key: const Key('discovery-destination'),
            label: 'الوجهة أو اسم العقار',
            placeholder: 'مثال: الساحل الشمالي',
            controller: _destinationController,
            loading: state.isLoading,
            onChanged: (_) => _scheduleSearch(),
            onSubmitted: (_) => _searchNow(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: const Key('discovery-unit-type'),
            initialValue: _unitType,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'نوع الوحدة',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: '', child: Text('كل الأنواع')),
              DropdownMenuItem(value: 'CHALET', child: Text('شاليه')),
              DropdownMenuItem(value: 'VILLA', child: Text('فيلا')),
              DropdownMenuItem(value: 'APARTMENT', child: Text('شقة')),
              DropdownMenuItem(value: 'STUDIO', child: Text('استوديو')),
            ],
            onChanged: (value) {
              setState(() => _unitType = value ?? '');
              _scheduleSearch();
            },
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InputField(
                  key: const Key('discovery-guests'),
                  label: 'عدد الضيوف',
                  controller: _guestsController,
                  keyboardType: TextInputType.number,
                  textDirection: ui.TextDirection.ltr,
                  error: _guestsError,
                  onChanged: (_) {
                    if (_guestsError != null) {
                      setState(() => _guestsError = null);
                    }
                    _scheduleSearch();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputField(
                  key: const Key('discovery-max-price'),
                  label: 'الحد الأقصى للسعر',
                  controller: _maxPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textDirection: ui.TextDirection.ltr,
                  error: _priceError,
                  onChanged: (_) {
                    if (_priceError != null) setState(() => _priceError = null);
                    _scheduleSearch();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            key: const Key('discovery-submit'),
            label: 'ابحث عن أماكن الإقامة',
            onPressed: state.isLoading ? null : _searchNow,
          ),
          const SizedBox(height: 20),
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
