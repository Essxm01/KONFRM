---
name: konfrm-accessibility
description: "Non-waivable accessibility engineering standards for KONFRM. Enforces platform-appropriate native target sizing, applicable contrast ratios, Arabic screen reader semantics, native text scaling support, and reduced-motion compliance without inventing unapproved numeric thresholds."
---

# KONFRM Accessibility Engineering Standards

Authoritative accessibility specifications across KONFRM Web and Mobile surfaces.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Contrast Ratios & Legibility

Applicable accessibility requirements constrain implementation and cannot be waived by aesthetic or brand preference (DF2 §2):

- **Web Applications (WCAG 2.2 AA in CSS Pixels):**
  - Normal text (< 18pt / 24px CSS): minimum **4.5:1** contrast ratio against adjacent background.
  - Large text (>= 18pt / 24px CSS or >= 14pt / 18.5px bold CSS): minimum **3.0:1** contrast ratio.
  - User interface components and graphical controls: minimum **3.0:1** contrast against adjacent surfaces.
- **Native Mobile Applications:**
  - Distinguish Web CSS-pixel criteria from native platform sizing; do not literally reinterpret WCAG CSS px rules as Flutter dp.
  - Ensure high perceptual contrast between text, essential borders, and surface backgrounds on real mobile displays under diverse lighting conditions.
  - Status must never be conveyed by color alone; pair color with unambiguous text labels or semantic icons.

---

## 2. Touch Target Sizing & Platform Ergonomics

- **Platform-Appropriate Sizing:**
  - Follow native platform conventions (Apple HIG recommends ~44×44pt; Android Material 3 recommends ~48×48dp).
  - High-density operational surfaces (e.g. Owner calendars, dense data tables) require validating compact controls on real devices to ensure operability without accidental taps.
  - Exact mobile control target dimensions remain subject to Primitive and Component validation work (§29).
- **Hit Test vs. Visual Bounds:**
  - When visual density requires compact icons or chips, ensure gesture hit areas provide platform-appropriate touch clearance using transparent insets or touch delegation.

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
