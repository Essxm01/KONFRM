import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Unit type chip selector for Screen 04 (Search & Refine).
///
/// Follows 8px field/control token radius, with Stable Black `#000000` active state.
class UnitTypeSelector extends StatelessWidget {
  const UnitTypeSelector({
    super.key,
    required this.selectedUnitTypes,
    required this.onToggle,
    required this.onClearAll,
  });

  final List<String> selectedUnitTypes;
  final ValueChanged<String> onToggle;
  final VoidCallback onClearAll;

  static const List<MapEntry<String, String>> unitTypeOptions = [
    MapEntry('CHALET', 'شاليه'),
    MapEntry('VILLA', 'فيلا'),
    MapEntry('APARTMENT', 'شقة'),
    MapEntry('STUDIO', 'استوديو'),
  ];

  @override
  Widget build(BuildContext context) {
    final isAllSelected = selectedUnitTypes.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع الوحدة',
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // "الكل" Chip
              _buildChip(
                key: const Key('unit-type-chip-ALL'),
                label: 'الكل',
                isSelected: isAllSelected,
                onTap: onClearAll,
              ),
              const SizedBox(width: 8),

              // Individual types
              for (final entry in unitTypeOptions) ...[
                _buildChip(
                  key: Key('unit-type-chip-${entry.key}'),
                  label: entry.value,
                  isSelected: selectedUnitTypes.contains(entry.key),
                  onTap: () => onToggle(entry.key),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required Key key,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'نوع $label',
      child: Material(
        color: isSelected ? const Color(0xFF000000) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: key,
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minHeight: 40, minWidth: 54),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF000000)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
