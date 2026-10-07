import 'package:flutter/material.dart';

/// Cairo Profile B. These roles are system-validated provisional, not final
/// native typography Canon.
abstract final class KonfrmTypography {
  static const String fontFamily = 'packages/konfrm_design_system/Cairo';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.30,
  );
  static const TextStyle pageTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.40,
  );
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.40,
  );
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.50,
  );
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );
  static const TextStyle supporting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.40,
  );
  static const TextStyle numeric = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.30,
  );
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.20,
  );

  static const Map<String, TextStyle> roles = {
    'display': display,
    'pageTitle': pageTitle,
    'sectionTitle': sectionTitle,
    'cardTitle': cardTitle,
    'body': body,
    'bodyStrong': bodyStrong,
    'label': label,
    'supporting': supporting,
    'numeric': numeric,
    'button': button,
  };
}

/// Colors here are lab references only except governed Primary black/white.
abstract final class KonfrmColors {
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
}

/// Centralized lab values. Never use these as final native token authority.
abstract final class ValidationReferenceOnly {
  static const double secondaryRadius = 8;
  static const double disabledOpacity = 0.38;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFF9FAFB);
  static const Color text = Color(0xFF111827);
  static const Color inverseText = Color(0xFFFFFFFF);
  static const Color secondaryFill = Color(0xFFF3F4F6);
  static const Color secondaryContainer = Color(0xFFF3F4F6);
  static const Color tertiaryContainer = Color(0xFFEAF0F8);
  static const Color errorContainer = Color(0xFFFEF3F2);
  static const Color surfaceContainerHighest = Color(0xFFD0D5DD);
  static const Color border = Color(0xFFE5E7EB);
  static const Color muted = Color(0xFF6B7280);
  static const Color transparent = Color(0x00000000);
  static const Color interaction = Color(0xFF276EF1);
  static const Color danger = Color(0xFFB42318);
  static const Color success = Color(0xFF16794B);
  static const Color info = Color(0xFF2457A7);
  static const Color pending = Color(0xFF475467);
  static const Color warning = Color(0xFF667085);
}

ThemeData konfrmLightTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: KonfrmTypography.fontFamily,
  colorScheme: const ColorScheme.light(
    primary: KonfrmColors.primary,
    onPrimary: KonfrmColors.onPrimary,
    primaryContainer: ValidationReferenceOnly.text,
    onPrimaryContainer: ValidationReferenceOnly.inverseText,
    secondary: ValidationReferenceOnly.interaction,
    onSecondary: ValidationReferenceOnly.inverseText,
    secondaryContainer: ValidationReferenceOnly.secondaryContainer,
    onSecondaryContainer: ValidationReferenceOnly.text,
    tertiary: ValidationReferenceOnly.info,
    onTertiary: ValidationReferenceOnly.inverseText,
    tertiaryContainer: ValidationReferenceOnly.tertiaryContainer,
    onTertiaryContainer: ValidationReferenceOnly.text,
    error: ValidationReferenceOnly.danger,
    onError: ValidationReferenceOnly.inverseText,
    errorContainer: ValidationReferenceOnly.errorContainer,
    onErrorContainer: ValidationReferenceOnly.danger,
    surface: ValidationReferenceOnly.surface,
    onSurface: ValidationReferenceOnly.text,
    onSurfaceVariant: ValidationReferenceOnly.muted,
    outline: ValidationReferenceOnly.border,
    outlineVariant: ValidationReferenceOnly.border,
    shadow: ValidationReferenceOnly.transparent,
    scrim: ValidationReferenceOnly.transparent,
    inverseSurface: ValidationReferenceOnly.text,
    onInverseSurface: ValidationReferenceOnly.inverseText,
    inversePrimary: ValidationReferenceOnly.interaction,
    surfaceTint: ValidationReferenceOnly.transparent,
    surfaceDim: ValidationReferenceOnly.canvas,
    surfaceBright: ValidationReferenceOnly.surface,
    surfaceContainerLowest: ValidationReferenceOnly.surface,
    surfaceContainerLow: ValidationReferenceOnly.canvas,
    surfaceContainer: ValidationReferenceOnly.secondaryFill,
    surfaceContainerHigh: ValidationReferenceOnly.border,
    surfaceContainerHighest: ValidationReferenceOnly.surfaceContainerHighest,
  ),
  scaffoldBackgroundColor: ValidationReferenceOnly.canvas,
  textTheme: TextTheme(
    displayLarge: KonfrmTypography.display,
    titleLarge: KonfrmTypography.pageTitle,
    titleMedium: KonfrmTypography.sectionTitle,
    titleSmall: KonfrmTypography.cardTitle,
    bodyLarge: KonfrmTypography.body,
    bodyMedium: KonfrmTypography.body,
    bodySmall: KonfrmTypography.supporting,
    labelLarge: KonfrmTypography.button,
    labelMedium: KonfrmTypography.label,
  ),
);
