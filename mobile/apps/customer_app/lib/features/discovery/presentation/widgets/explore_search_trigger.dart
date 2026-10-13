import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Premium pill-style search trigger for Customer Screen 03 (Explore).
///
/// Follows Arabic RTL layout:
/// - Right side: search icon
/// - Center / main content: two-line text block
/// - Left side: small circular tune/filter button
class ExploreSearchTrigger extends StatelessWidget {
  const ExploreSearchTrigger({
    super.key,
    this.selectedRegions = const [],
    this.subtitle,
    this.onTap,
    this.onTuneTap,
  });

  /// The list of currently selected region names.
  final List<String> selectedRegions;

  /// Optional custom subtitle/secondary line text.
  final String? subtitle;

  /// Triggered when anywhere on the search bar is tapped.
  final VoidCallback? onTap;

  /// Triggered when the circular tune/filter button is tapped.
  final VoidCallback? onTuneTap;

  /// Primary line display text based on selected regions count.
  String get primaryText {
    if (selectedRegions.isEmpty) {
      return 'إلى أين؟';
    }
    if (selectedRegions.length == 1) {
      return selectedRegions.first;
    }
    if (selectedRegions.length == 2) {
      return '${selectedRegions[0]}، ${selectedRegions[1]}';
    }
    final remaining = selectedRegions.length - 1;
    return '${selectedRegions.first} + $remaining مناطق';
  }

  /// Secondary line display text.
  String get secondaryText {
    if (subtitle != null && subtitle!.isNotEmpty) {
      return subtitle!;
    }
    if (selectedRegions.isEmpty) {
      return 'اختيار منطقة أو أكثر';
    }
    if (selectedRegions.length == 1) {
      return 'الوجهة المحددة · انقر للتعديل';
    }
    return '${selectedRegions.length} مناطق مختارة · انقر للتعديل';
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(26.0);

    return Semantics(
      button: true,
      label: 'البحث عن أماكن الإقامة: $primaryText، $secondaryText',
      child: Container(
        constraints: const BoxConstraints(minHeight: 70.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 10, 8),
              child: Row(
                children: [
                  // Right side (RTL Start): Search icon
                  const Icon(
                    Icons.search_rounded,
                    size: 24,
                    color: Color(0xFF111827),
                  ),
                  const SizedBox(width: 14),

                  // Center / main content: Two-line text block
                  Expanded(
                    child: ExcludeSemantics(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            primaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            secondaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Left side (RTL End): Small circular tune/filter button
                  Semantics(
                    button: true,
                    label: 'خيارات التصفية والتعديل',
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onTuneTap ?? onTap,
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Icon(
                              Icons.tune_rounded,
                              size: 19,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
