# KONFRM Flutter Design System

Shared Phase 4I native Flutter primitives for validation and later Customer/Owner app consumption. This package implements governed semantics and provisional geometry; it is not final native Canon and does not contain product or business logic.

## Font and typography

The sole Cairo binary and SIL Open Font License are in `assets/fonts/`. The package registers the family `Cairo`; consuming text styles use Flutter's package family name `packages/konfrm_design_system/Cairo`. `KonfrmTypography` exports the ten Cairo Profile B roles, classified **SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY**. The validation harness uses `konfrmLightTheme()` and intentionally does not carry a duplicate font.

## Public API

- `konfrmLightTheme`, `KonfrmTypography`, `KonfrmColors`
- Actions: `PrimaryButton`, `SecondaryButton`, `IconActionButton`, `ActionPhase`
- Inputs: `InputField`, `PhoneField`, `SearchField`
- Presentation: `StatusBadge`, `StatusTone`, `StateView`, `StateKind`, `SectionAlert`, `StructuralContainer`
- Navigation/composition: `CustomerBottomNavigation`, `customerDestinations`, `StickyActionSurface`
- Direction helpers: `isolateLtr`, `ltrText`

Open exact colors and secondary geometry are centralized under the package-internal `ValidationReferenceOnly`; it is intentionally absent from the public barrel. Owner examples and money formatting belong to the validation app, not the shared package. Native field height/focus, iOS behavior, runtime SafeArea/keyboard/back, BottomSheet/Dialog and device acceptance remain integration work.

Interactive hit sizing uses 48 logical units on Android. The platform-selected 44 logical-unit iOS sizing exists only as `IOS_LAYOUT_PREVIEW_ONLY`; it is not iOS native acceptance.

## Validation

Run package commands from this directory: `flutter pub get`, `flutter analyze`, and `flutter test`. The package tests exercise role contracts, package-font asset resolution, semantics, geometry, Android destination touch sizing, RTL direction contracts and representative 200% scaling.
