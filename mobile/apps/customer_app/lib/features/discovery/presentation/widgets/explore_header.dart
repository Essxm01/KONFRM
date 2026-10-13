import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

/// Premium, minimal, personalized header candidate for Customer Screen 03 (Explore).
///
/// Follows Arabic RTL hierarchy:
/// - PHYSICAL RIGHT: Circular profile image or avatar.
/// - Text column immediately to its left:
///   - Primary greeting (Cairo ~17sp, Bold/SemiBold, dark foreground).
///   - Contextual secondary line (Cairo ~13sp, Regular, muted gray).
/// - PHYSICAL LEFT: Optional contextual action / notification affordance
///   (rendered only when backed by genuine functional infrastructure).
class ExploreHeader extends StatelessWidget {
  const ExploreHeader({
    super.key,
    this.userName,
    this.avatarUrl,
    this.location,
    this.greeting,
    this.subtitle,
    this.onProfileTap,
    this.onNotificationTap,
    this.showNotification = false,
  });

  /// Authenticated user name if available (read from canonical profile only).
  /// When null, operates strictly in truthful Guest mode.
  final String? userName;

  /// Optional canonical avatar URL.
  final String? avatarUrl;

  /// Optional approved general location (city/area name).
  final String? location;

  /// Explicit custom greeting override if provided.
  final String? greeting;

  /// Explicit custom subtitle/tagline override if provided.
  final String? subtitle;

  /// Tap callback for profile/avatar area (connects to Account).
  final VoidCallback? onProfileTap;

  /// Tap callback for notification affordance (when enabled).
  final VoidCallback? onNotificationTap;

  /// Whether to show the notification affordance.
  /// Omitted in production guest mode to avoid dead buttons without a backing inbox.
  final bool showNotification;

  /// Computes the effective primary greeting.
  String get effectiveGreeting {
    if (greeting != null && greeting!.trim().isNotEmpty) {
      return greeting!.trim();
    }
    final trimmedName = userName?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      final hour = DateTime.now().hour;
      if (hour >= 5 && hour < 12) {
        return 'صباح الخير، $trimmedName';
      } else if (hour >= 12 && hour < 23) {
        return 'مساء الخير، $trimmedName';
      }
      return 'أهلًا بك، $trimmedName';
    }
    return 'أهلًا بك';
  }

  /// Computes the effective secondary tagline/location.
  String get effectiveSubtitle {
    if (subtitle != null && subtitle!.trim().isNotEmpty) {
      return subtitle!.trim();
    }
    final trimmedLocation = location?.trim();
    if (trimmedLocation != null && trimmedLocation.isNotEmpty) {
      return trimmedLocation;
    }
    return 'اكتشف وجهتك القادمة';
  }

  /// Extract up to 2 initials from user name if available.
  String? get _initials {
    final trimmed = userName?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    final parts =
        trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    if (parts.length == 1) {
      return parts.first.characters.take(1).toString();
    }
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}';
  }

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 44.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PHYSICAL RIGHT: Circular profile avatar
          Semantics(
            button: true,
            label: 'الملف الشخصي والحساب',
            child: Material(
              color: const Color(0xFFF3F4F6),
              shape: const CircleBorder(
                side: BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1.0,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: const Key('explore-profile-avatar'),
                onTap: onProfileTap,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: avatarSize,
                  height: avatarSize,
                  child: _buildAvatarContent(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

            // Text Column: Greeting + Contextual Subtitle
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    effectiveGreeting,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    effectiveSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            // PHYSICAL LEFT: Optional notification affordance
            if (showNotification) ...[
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: 'الإشعارات',
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: IconButton(
                    key: const Key('explore-notification-bell'),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 24,
                      color: Color(0xFF111827),
                    ),
                    tooltip: 'الإشعارات',
                    onPressed: onNotificationTap,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
  }

  Widget _buildAvatarContent() {
    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return Image.network(
        avatarUrl!.trim(),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackContent(),
      );
    }
    return _buildFallbackContent();
  }

  Widget _buildFallbackContent() {
    final initials = _initials;
    if (initials != null) {
      return Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      );
    }
    return const Center(
      child: Icon(
        Icons.person_outline_rounded,
        size: 22,
        color: Color(0xFF4B5563),
      ),
    );
  }
}
