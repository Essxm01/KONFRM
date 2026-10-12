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
      isScrollControlled: true,
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D7E2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'جميع المرافق',
                style: KonfrmTypography.sectionTitle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF101723),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
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
                ),
              ),
              const SizedBox(height: 20),
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
      ),
    );
  }

  static IconData amenityIcon(String key) => switch (key.toUpperCase().trim()) {
        'SEA_VIEW' || 'إطلالة بحرية' || 'إطلالة مباشرة على البحر' => Icons.waves,
        'BEACH_FRONT' || 'BEACH_ACCESS' || 'شاطئ خاص' || 'مباشر على الشاطئ' => Icons.beach_access,
        'POOL' || 'مسبح' || 'حمام سباحة' => Icons.pool,
        'PRIVATE_POOL' || 'مسبح خاص' || 'حمام سباحة خاص مغطى' => Icons.pool,
        'WIFI' || 'واي فاي' || 'إنترنت واي فاي سريعة' => Icons.wifi,
        'AIR_CONDITIONING' || 'CENTRAL_AC' || 'AC' || 'تكييف' || 'تكييف مركزي بالكامل' => Icons.ac_unit,
        'PARKING' || 'GARAGE' || 'موقف سيارات' || 'جراج مغطى للسيارات' => Icons.local_parking,
        'KITCHEN' || 'مطبخ' || 'مطبخ مجهز' || 'مطبخ مجهز بالكامل' => Icons.kitchen,
        'GARDEN' || 'حديقة' || 'حديقة خاصة' || 'حديقة خاصة وتراس' => Icons.yard,
        'SECURITY' || 'حراسة' || 'أمن وحراسة' || 'أمن وحراسة 24/7' => Icons.security,
        'BALCONY' || 'شرفة' || 'بلكونة' => Icons.balcony,
        'TERRACE' || 'تراس' => Icons.deck,
        'SMART_TV' || 'TV' || 'شاشة ذكية' || 'شاشة سمارت وساتلايت' => Icons.tv,
        'BBQ' || 'منطقة شواء' || 'منطقة شواء وتجهيزات BBQ' => Icons.outdoor_grill,
        'ELEVATOR' || 'مصعد' => Icons.elevator,
        'GYM' || 'جيم' || 'نادي صحي' => Icons.fitness_center,
        'HOT_TUB' || 'JACUZZI' || 'جاكوزي' => Icons.hot_tub,
        'WASHER' || 'WASHING_MACHINE' || 'غسالة ملابس' => Icons.local_laundry_service,
        'DISHWASHER' || 'غسالة أطباق' => Icons.countertops,
        'IRON' || 'مكواة' => Icons.iron,
        'HEATING' || 'تدفئة' => Icons.heat_pump,
        _ => Icons.check_circle_outline,
      };

  static String amenityLabel(String key) => switch (key.toUpperCase().trim()) {
        'SEA_VIEW' => 'إطلالة بحرية',
        'BEACH_FRONT' || 'BEACH_ACCESS' => 'مباشر على الشاطئ',
        'POOL' => 'مسبح',
        'PRIVATE_POOL' => 'مسبح خاص',
        'WIFI' => 'واي فاي',
        'AIR_CONDITIONING' || 'CENTRAL_AC' || 'AC' => 'تكييف',
        'PARKING' || 'GARAGE' => 'موقف سيارات',
        'KITCHEN' => 'مطبخ مجهز',
        'GARDEN' => 'حديقة خاصة',
        'SECURITY' => 'حراسة وأمن',
        'BALCONY' => 'شرفة',
        'TERRACE' => 'تراس',
        'SMART_TV' || 'TV' => 'شاشة ذكية',
        'BBQ' => 'منطقة شواء',
        'ELEVATOR' => 'مصعد',
        'GYM' => 'نادي صحي',
        'HOT_TUB' || 'JACUZZI' => 'جاكوزي',
        'WASHER' || 'WASHING_MACHINE' => 'غسالة ملابس',
        'DISHWASHER' => 'غسالة أطباق',
        'IRON' => 'مكواة',
        'HEATING' => 'تدفئة',
        _ => key,
      };
}

