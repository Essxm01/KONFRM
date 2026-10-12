import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class PropertyFactsBar extends StatelessWidget {
  const PropertyFactsBar({
    super.key,
    required this.maxGuests,
    required this.bedrooms,
    required this.bathrooms,
  });

  final int maxGuests;
  final int bedrooms;
  final int bathrooms;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xFFE4E9EF), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _FactItem(
              icon: Icons.people_outline,
              label: '$maxGuests ضيوف',
            ),
          ),
          Expanded(
            child: _FactItem(
              icon: Icons.bed_outlined,
              label: '$bedrooms غرف نوم',
            ),
          ),
          Expanded(
            child: _FactItem(
              icon: Icons.bathtub_outlined,
              label: '$bathrooms حمامات',
            ),
          ),
        ],
      ),
    );
  }
}

class _FactItem extends StatelessWidget {
  const _FactItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 19, color: const Color(0xFF64768B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: KonfrmTypography.supporting.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101723),
            ),
          ),
        ],
      ),
    );
  }
}
