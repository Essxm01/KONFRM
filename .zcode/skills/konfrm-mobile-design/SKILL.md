---
name: konfrm-mobile-design
description: "Authoritative mobile design standards for KONFRM Flutter applications. Implements DF2 v1.1 foundations, monochrome-first Black/White core identity, #276EF1 candidate interaction role, platform ergonomics (iOS vs Android), and high-density mobile layouts while subordinating external numeric heuristics."
---

# KONFRM Mobile Design Authority (DF2 v1.1)

Authoritative mobile design guidelines for KONFRM Customer App (`customer-app/`) and Owner App (`owner-app/`) implemented in Flutter / Dart.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Brand Identity & Visual Language

- **Monochrome-First Core:**
  - The canonical brand identity is solid Black and White.
  - Primary canonical symbol: [`konfrm-symbol-black.svg`](file:///C:/Users/Essam/OneDrive/Desktop/KONFRM-SCREEN17-18-REMEDIATION/DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-black.svg) on light/white background.
  - Inverse canonical symbol: [`konfrm-symbol-white.svg`](file:///C:/Users/Essam/OneDrive/Desktop/KONFRM-SCREEN17-18-REMEDIATION/DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-white.svg) on dark surfaces.
  - Yellow is completely REMOVED from the core mobile brand architecture (no yellow logos, badges, or brand subtitles).
- **Candidate Interaction Role (`#276EF1`):**
  - `#276EF1` is an active implementation candidate for interactive accents (focused input borders, active tab indicators, selected radio states, subtle link highlights).
  - Primary action buttons: Solid Black background (`#000000` / `#0F172A`) with White text (`#FFFFFF`) is the canonical high-contrast primary CTA style. Blue is an interaction accent, NEVER the primary brand logo artwork.
- **Light-First Dominant Surfaces:**
  - App backgrounds: pure white (`#FFFFFF`) and light cool neutral (`#F8FAFC` / `#F1F5F9`).
  - Dark navy/slate slabs, high-contrast dark cards, and glassmorphism are NOT normal product surfaces.

---

## 2. Mobile Ergonomics & Platform Adaptation

KONFRM adapts ergonomically to the underlying mobile operating system without compromising brand identity:

### iOS Adaptation
- **Navigation Bar:** Large Title behavior on top-level tabs collapsing to inline title on scroll; standard iOS back gesture (swipe from leading edge, mirrored for RTL).
- **Haptics:** Tactile feedback on key actions (`HapticFeedback.lightImpact()` on toggle/selection, `HapticFeedback.mediumImpact()` on primary action confirmation).
- **Bottom Sheets:** Modal bottom sheets with rounded top corners (16-24dp radius), dragging handle, and safe area insets at bottom for Home Indicator.

### Android Adaptation
- **Navigation:** Back gesture handled gracefully with `PopScope` / `WillPopScope`; predictive back animation support.
- **Elevation & Touch Feedback:** Subtle material elevation (1-2dp) and ink splash ripple effect styled with monochromatic opacity (`Colors.black.withOpacity(0.06)`).
- **System Navigation Bar:** Edge-to-edge transparent navigation bar with dynamic contrast icons.

---

## 3. Subordinating External Numeric Rules

Generic external UI skills often enforce rigid universal numbers. Under KONFRM Canon, these are explicitly overridden:

1. **Touch Target Dimensions:**
   - *External Skill Claim:* "Must be strictly 44×44px" (or "strictly 48×48px").
   - *KONFRM Canon:*
     - Primary action buttons and critical navigation targets: **48×48dp minimum** touch area.
     - Secondary, tertiary, and dense operational controls (table chips, inline action icons, stepper buttons): **36–40dp touch bounds** are fully valid provided there is adequate padding and spacing to avoid accidental taps.
2. **Typography Minimums:**
   - *External Skill Claim:* "Body text must never be smaller than 12px / 16px."
   - *KONFRM Canon:*
     - Primary body: 14–16sp (Cairo Regular / Medium).
     - Secondary captions, badges, unit types, and timestamps: 11–12sp (Cairo Medium / SemiBold) is permitted and standard for dense mobile financial metadata, provided contrast meets WCAG AA (4.5:1).

---

## 4. Mobile Component Contracts

- **Primary Button (`KonfrmPrimaryButton`):**
  - Height: 48–52dp.
  - Background: Black (`#000000`).
  - Text: White (`#FFFFFF`), Cairo Bold, 16sp.
  - Corner Radius: 12–16dp (rounded-xl / rounded-2xl equivalent).
  - State: Disabled = `#E2E8F0` background with `#94A3B8` text; Loading = embedded monochromatic circular indicator.
- **Secondary Button (`KonfrmSecondaryButton`):**
  - Height: 48–52dp.
  - Background: Light neutral (`#F1F5F9` / `#F8FAFC`).
  - Text: Black (`#0F172A`), Cairo SemiBold, 15–16sp.
  - Border: 1dp `#E2E8F0` border.
- **Card (`KonfrmCard`):**
  - Background: White (`#FFFFFF`).
  - Border: 1dp solid `#E2E8F0`.
  - Radius: 16–20dp.
  - Elevation: 0 to 1dp shadow (`rgba(0, 0, 0, 0.04)` blur 4dp).
