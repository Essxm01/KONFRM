# KONFRM Mobile Foundation & Codex Interface Contract

## 1. Overview

This directory establishes the bounded native Flutter foundation for **Phase 4I (Native Flutter Foundation & Verification)**.

Engineering role split:
- **Antigravity (Mission A):** Environment preflight, minimum `mobile/` repository boundary, validation harness app, package baseline, Android toolchain verification, and stable Codex interfaces.
- **Codex (Mission B):** Cairo typography system, ThemeData, Phase 4I component primitives (Buttons, Inputs, Badges, StateViews, Alerts, Containers), semantics, RTL/Bidi helpers, and widget test suites.
- **Antigravity (Mission C):** Android runtime execution, touch inspection, SafeArea/Back behavior, screenshots, and integration evidence assembly.
- **Bridge (Stage 4):** Final acceptance and Canon decisions.

> [!NOTE]
> Z Code is not used in this repository. All validation tooling is standard Flutter/Dart CLI (`flutter test`, `flutter analyze`).

---

## 2. Directory Structure

```text
mobile/
├── apps/
│   └── design_system_validation/     # Phase 4I Validation Harness App
│       ├── android/                  # Android native project files
│       ├── lib/
│       │   └── main.dart             # Arabic RTL diagnostic scenario catalog
│       ├── test/
│       │   └── widget_test.dart      # Harness widget test
│       └── pubspec.yaml              # Depends on konfrm_design_system
└── packages/
    └── konfrm_design_system/         # Shared Mobile Primitives & Contracts Package
        ├── assets/fonts/             # Pinned Cairo font asset & license
        ├── lib/
        │   ├── konfrm_design_system.dart # Package entrypoint
        │   └── src/                  # Theme, primitives, bidi helpers
        ├── test/
        │   └── konfrm_design_system_test.dart # Package unit tests
        └── pubspec.yaml              # Package configuration
```

---

## 3. Codex Implementation Surfaces (Mission B)

Codex branches directly from the Mission A baseline commit and implements within these reserved paths:

| Surface | Path in `mobile/packages/konfrm_design_system/` | Description |
|---|---|---|
| **Theme & Typography** | `lib/src/theme/konfrm_theme.dart` | Cairo Profile B roles; open colors separately labeled validation-only |
| **Actions** | `lib/src/components/actions/` | Primary (6px), representative Secondary (radius lab-only), IconAction |
| **Inputs** | `lib/src/components/inputs/input_field.dart` | Input/Phone/Search fields |
| **Status and Structure** | `lib/src/components/status/`, `states/`, `feedback/`, `structure/` | StatusBadge with harness-only domain examples, StateView, SectionAlert, StructuralContainer (12px provisional) |
| **Navigation and scenarios** | `lib/src/components/navigation/`, validation app `lib/scenarios/` | Four-destination Customer nav and separate StickyActionSurface / Owner grouping scenario |
| **RTL / Bidi Helpers** | `lib/src/utils/` | Directional alignment helpers, bidi isolation utilities |
| **Semantics** | Within component files | Accessible roles, labels, and traits |
| **Widget Tests** | `test/` | Component widget tests, semantics, and contract tests |

---

## 4. Commands for Codex

### Dependency Resolution
```bash
# Package
cd mobile/packages/konfrm_design_system
flutter pub get

# Validation App
cd mobile/apps/design_system_validation
flutter pub get
```

### Static Analysis
```bash
cd mobile/packages/konfrm_design_system
flutter analyze

cd mobile/apps/design_system_validation
flutter analyze
```

### Formatting Check
```bash
dart format --output=none --set-exit-if-changed mobile/
```

### Run Tests
```bash
# Package Tests
cd mobile/packages/konfrm_design_system
flutter test

# Validation App Tests
cd mobile/apps/design_system_validation
flutter test
```

### Launch Validation App
```bash
cd mobile/apps/design_system_validation
flutter run -d <device-id>
```

---

## 5. Governed Design Boundaries and implementation maturity

- **Typography:** Cairo Profile B (`display 24/700`, `pageTitle 20/700`, `sectionTitle 17/700`, `cardTitle 15/700`, `body 14/500`, `bodyStrong 14/700`, `label 12/600`, `supporting 12/400`, `numeric 16/700`, `button 15/700/1.20`).
- **Primary Color:** Stable Black `#000000`.
- **Primary Button Radius:** `6px` (`PRIMARY_ONLY`).
- **Field Radius:** `8px` (`FIELD_ONLY`, outline-led).
- **Structural Container Radius:** `12px` (semantic grouping).
- **Page Horizontal Inset:** `16px`.
- **Spacing Scale:** `4 / 8 / 12 / 16 / 24 / 32 px`.
- **Dialog Radius:** `12px`.
- **BottomSheet Top Radius:** `16px`.
- **MR-17 Rule:** Zero yellow/amber boxed UI by default.
- **RTL:** Native Arabic-first directionality; Western Arabic digits `0–9`; currency `1,600 ج.م`.

**Maturity boundary:** Cairo Profile B is system-validated provisional. Primary black and the 6px Primary-only radius, 8px field-only radius, and 12px structural radius retain the classifications assigned by Design Canon. Exact blue, neutrals, semantic colors, shadows, secondary radius, native field height/focus, sheet detents, motion curves, and toast duration remain open. Any temporary visual values live under `ValidationReferenceOnly` in the package and are not approved tokens.

The package is the sole owner of the Cairo font binary and OFL license. The app uses the registered package font family `packages/konfrm_design_system/Cairo`; package tests load the actual asset and app tests assert the resolved theme family. Text-scale choices in the catalog are Flutter layout simulations, not native Dynamic Type/fontScale acceptance. Android device runtime remains pending Antigravity Mission C. The 44 logical-unit iOS target branch is `IOS_LAYOUT_PREVIEW_ONLY`; all iOS native acceptance remains pending.

The validation catalog is explicitly `LAB_SCENARIO_DATA`. Its Customer bottom navigation and StickyActionSurface appear in separate scenarios; it does not implement production routes, booking/payment operations, BottomSheet/Dialog runtime, or business state.
