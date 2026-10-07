---
name: konfrm-accessibility
description: "Use for accessibility design-policy interpretation and historical governed guidance. Do not use as the primary skill for Flutter implementation, Flutter semantics debugging, or runtime verification; use konfrm-flutter for implementation and konfrm-quality for verification."
---

# KONFRM Accessibility Engineering Standards

Authoritative accessibility specifications across KONFRM Web and Mobile surfaces. Governed by `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` §21.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.4, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals as default, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Contrast Ratios & Legibility Framework

Accessibility standards constrain implementation and must be evaluated by surface reality rather than through a single flattened formula:

- **Web Applications (`admin-app/`, current web surfaces):**
  - **Baseline:** WCAG 2.2 AA is the project Web accessibility baseline where applicable.
  - Normal text (< 18pt / 24px CSS): minimum **4.5:1** contrast ratio against adjacent background.
  - Large text (>= 18pt / 24px CSS or >= 14pt / 18.5px bold CSS): minimum **3.0:1** contrast ratio.
  - User interface components and essential graphical controls: minimum **3.0:1** contrast against adjacent surfaces.
  - **AAA Criteria:** Higher WCAG AAA thresholds are aspirational or selectively applied where appropriate; do not assert universal AAA conformance across all web UI unless explicitly governed.
- **Native Mobile Applications (Future Mobile Target):**
  - Apply platform-appropriate accessibility standards and guidance.
  - **No CSS-to-dp Conflation:** Do not literally reinterpret Web CSS-pixel thresholds or formulas as native Flutter dp.
  - Ensure strong perceptual contrast between text, essential borders, and surface backgrounds on real mobile displays under varying sunlight conditions.
  - Status must never be conveyed by color alone; pair color with unambiguous text labels or semantic icons.

---

## 2. Touch Targets & Platform Guidance Categories

To ensure disciplined ergonomics, distinguish between different tiers of accessibility and platform guidance:
1. **Legal Requirements & Conformance Criteria:** Non-waivable statutory or contractually binding standards applicable to a given surface.
2. **Platform Recommendations:** Guidance provided by platform vendors (e.g. Apple HIG recommendations regarding interactive regions, Google Material Design 3 component guidelines). These represent authoritative platform guidance, but **must not be mislabeled as legal mandates or cross-platform laws**.
3. **Platform Conventions:** Interaction patterns users expect from platform muscle memory (e.g. swipe gestures, system picker presentations).
4. **Implementation Evidence:** Empirical ergonomic measurements from device testing.

### Touch Target Ergonomics:
- **No Universal Raw Cross-Platform Rule:** There is no universal raw 44px or 48px cross-platform canon. Control dimensions adapt to platform conventions and task density.
- **Platform-Appropriate Sizing:** Respect platform vendor guidance for touch targets, ensuring comfortable hit regions without accidental activation.
- **Visual Bounds vs. Hit Regions:** In dense operational layouts (e.g. Owner calendar grids, Admin data tables), visual indicators may be compact provided transparent touch hit delegation maintains accessible target regions.
- **Validation Requirement:** Exact control dimensions for mobile primitives remain subject to empirical device and component validation (DF2 §29).

---

## 3. Screen Reader Semantics (Arabic Native)

Interfaces must expose complete semantic trees to assistive technologies (VoiceOver on iOS/macOS, TalkBack on Android, NVDA on Windows):

- **Meaningful Arabic Labels:**
  - Interactive elements and icon-only buttons must declare descriptive Arabic accessibility labels.
  - Avoid redundant labels (e.g. do not say "زر احجز الآن زر"; let the platform announce the button trait).
- **Decorative Elements:**
  - Purely decorative dividers, background illustrations, and ambient graphics must be hidden from screen readers.
- **State Feedback:**
  - Announce dynamic updates (e.g. validation error alerts, successful bookings) politely to screen readers.

---

## 4. Text Scaling & Dynamic Type Resilience

- **Platform Text Scaling Support:**
  - Support the platform's full user text-scaling and accessibility font range.
  - Never impose an arbitrary ceiling (e.g. capping scaling at 130%); interfaces must adapt fluidly.
- **Layout Robustness:**
  - Never place text inside containers with rigid, unyielding fixed pixel heights. Allow containers to expand vertically or wrap content gracefully.
  - Decision-critical information (booking prices, dates, confirmation codes, legal terms) must never be truncated or clipped when text scales up.

---

## 5. Focus & Reduced Motion

- **Keyboard Navigation & Focus (Web Admin):**
  - All interactive elements must support visible, high-contrast focus rings when navigated via keyboard.
  - Never remove focus outlines without providing an accessible alternative.
- **Reduced Motion Compliance:**
  - Always respect system reduced-motion preferences (`MediaQuery.of(context).disableAnimations` in Flutter; `@media (prefers-reduced-motion: reduce)` in Web).
  - When reduced motion is enabled, suppress non-essential spatial motion and provide instantaneous transitions or simple opacity cross-fades.
