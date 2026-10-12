import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

class AmenitiesBottomSheet extends StatelessWidget {
  const AmenitiesBottomSheet({
    super.key,
    required this.amenities,
  });

  final List<String> amenities;

  static void show(BuildContext context, List<String> amenities) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => AmenitiesBottomSheet(amenities: amenities),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'جميع المرافق',
              style: KonfrmTypography.sectionTitle.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101723),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: amenities.map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8EDF2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        amenityIcon(amenity),
                        size: 18,
                        color: const Color(0xFF64768B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        amenityLabel(amenity),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF37455A),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111723),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData amenityIcon(String key) => switch (key.toUpperCase()) {
        'SEA_VIEW' || 'إطلالة بحرية' => Icons.waves,
        'POOL' || 'مسبح' => Icons.pool,
        'WIFI' || 'واي فاي' => Icons.wifi,
        'AIR_CONDITIONING' || 'تكييف' => Icons.ac_unit,
        'PARKING' || 'موقف سيارات' => Icons.local_parking,
        'KITCHEN' || 'مطبخ' => Icons.kitchen,
        'GARDEN' || 'حديقة' => Icons.yard,
        'SECURITY' || 'حراسة' => Icons.security,
        _ => Icons.check_circle_outline,
      };

  static String amenityLabel(String key) => switch (key.toUpperCase()) {
        'SEA_VIEW' => 'إطلالة بحرية',
        'POOL' => 'مسبح',
        'WIFI' => 'واي فاي',
        'AIR_CONDITIONING' => 'تكييف',
        'PARKING' => 'موقف سيارات',
        'KITCHEN' => 'مطبخ مجهز',
        'GARDEN' => 'حديقة خاصة',
        'SECURITY' => 'حراسة وأمن',
        _ => key,
      };
}
