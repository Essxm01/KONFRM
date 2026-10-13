import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../data/search_intent_models.dart';

/// Modal bottom sheet for Egyptian coastal multi-region selection.
///
/// Follows governing DF2 tokens:
/// - 16px top border radius
/// - Arabic RTL physical alignment (checkbox at physical right)
/// - Cairo Profile B typography
/// - 54dp sticky primary CTA with 12dp button radius
class RegionMultiSelectSheet extends StatefulWidget {
  const RegionMultiSelectSheet({
    super.key,
    required this.initialSelected,
    this.availableDestinations = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    required this.onConfirm,
  });

  /// The list of initially selected regions.
  final List<String> initialSelected;

  /// Authentic destinations available in published inventory.
  final List<String> availableDestinations;

  /// Whether published inventory is currently being loaded.
  final bool isLoading;

  /// Whether published inventory failed to load.
  final bool hasError;

  /// Optional error message on inventory load failure.
  final String? errorMessage;

  /// Callback when user confirms selection.
  final ValueChanged<List<String>> onConfirm;

  /// Static helper to display this sheet using the canonical 16px radius modal.
  static Future<List<String>?> show({
    required BuildContext context,
    required List<String> initialSelected,
    List<String> availableDestinations = const [],
    bool isLoading = false,
    bool hasError = false,
    String? errorMessage,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return RegionMultiSelectSheet(
          initialSelected: initialSelected,
          availableDestinations: availableDestinations,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          onConfirm: (selected) => Navigator.of(context).pop(selected),
        );
      },
    );
  }

  @override
  State<RegionMultiSelectSheet> createState() => _RegionMultiSelectSheetState();
}

class _RegionMultiSelectSheetState extends State<RegionMultiSelectSheet> {
  late final Set<String> _selected;
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelected);
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query != _filterQuery) {
        setState(() => _filterQuery = query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Selectable destinations originate strictly from actual published inventory metadata.
  /// Zero synthetic or hardcoded resort lists are fabricated.
  List<String> get _allDestinations => widget.availableDestinations;

  void _toggleRegion(String region) {
    setState(() {
      if (_selected.contains(region)) {
        _selected.remove(region);
      } else {
        _selected.add(region);
      }
    });
  }

  void _clearAll() {
    setState(() {
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = mediaQuery.size.height * 0.85;

    final allDestinations = _allDestinations;
    final filteredDestinations = _filterQuery.isEmpty
        ? allDestinations
        : allDestinations
              .where(
                (d) =>
                    d.toLowerCase().contains(_filterQuery.toLowerCase()) ||
                    _filterQuery.toLowerCase().contains(d.toLowerCase()),
              )
              .toList();

    final categorized = CoastalRegionGroup.categorize(filteredDestinations);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: sheetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // 1. Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // 2. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تحديد الوجهات',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    key: const Key('region-sheet-close-button'),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF64748B),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 3. Search Filter Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        key: const Key('region-search-input'),
                        controller: _searchController,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'ابحث عن قرية أو منطقة...',
                          hintStyle: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_filterQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 4. Compact Selected Summary Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selected.isEmpty ? 'المحدد (0)' : 'المحدد (${_selected.length})',
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (_selected.isNotEmpty)
                    InkWell(
                      key: const Key('region-clear-all-button'),
                      onTap: _clearAll,
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          'مسح الكل',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // 5. Categorized Destination Flowing Chips (Wrap)
            Expanded(
              child: widget.isLoading && allDestinations.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF000000),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'جارٍ تحميل الوجهات المتاحة...',
                              style: TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : widget.hasError && allDestinations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 36,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.errorMessage ??
                                  'تعذر تحميل الوجهات من الخادم حالياً.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : categorized.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_filterQuery.isEmpty) ...[
                              const Icon(
                                Icons.location_off_rounded,
                                size: 36,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'لا توجد وجهات متاحة حالياً',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'لم يتم العثور على أماكن إقامة منشورة في الوقت الحالي.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ] else
                              Text(
                                'لا توجد وجهات مطابقة لـ "$_filterQuery"',
                                style: const TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      children: [
                        for (final groupEntry in categorized.entries) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 8),
                            child: Text(
                              groupEntry.key,
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final resort in groupEntry.value)
                                _buildDestinationChip(resort),
                            ],
                          ),
                        ],
                      ],
                    ),
            ),

            // 6. Sticky Bottom Action CTA
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    key: const Key('search-sheet-dismiss-button'),
                    onPressed: () {
                      widget.onConfirm(_selected.toList(growable: false));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selected.isEmpty
                          ? 'تأكيد الوجهات (الكل)'
                          : 'تأكيد الوجهات (${_selected.length})',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationChip(String resort) {
    final isSelected = _selected.contains(resort);

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'وجهة $resort',
      child: Material(
        color: isSelected ? const Color(0xFF000000) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          key: Key('region-chip-$resort'),
          onTap: () => _toggleRegion(resort),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            key: Key('region-row-$resort'),
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF000000)
                    : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Center(
              widthFactor: 1.0,
              child: Text(
                resort,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

