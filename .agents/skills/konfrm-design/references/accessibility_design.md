# Accessibility Design Intent & Ergonomic Standards

```yaml
MODULE: accessibility_design.md
BRAIN: konfrm-design
AUTHORITY: DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md §21 + DESIGN_SYSTEM/GUIDELINES/accessibility.md
```

This reference defines the accessibility design requirements, touch target ergonomics, Arabic screen reader semantic contracts, and text-scaling resilience for KONFRM surfaces.

---

## 1. Contrast Ratios & Visual Legibility

Accessibility standards must be evaluated by surface reality and display physics:

### A. Web Applications (`admin-app/` Desktop Workspace):
- **Baseline:** WCAG 2.2 AA is the project baseline where applicable.
- **Normal Text (< 18pt / 24px CSS):** Minimum **4.5:1** contrast ratio against adjacent surface.
- **Large Text (>= 18pt / 24px CSS or >= 14pt / 18.5px bold):** Minimum **3.0:1** contrast ratio.
- **Essential Graphical Components & Active Borders:** Minimum **3.0:1** contrast.

### B. Native Mobile Applications (iOS / Android):
- **No Conflation:** Do not mechanically transpose Web CSS pixel formulas into native mobile device dp.
- **Sunlight Readability:** Real-world mobile screens encounter bright sunlight in Egypt (North Coast, Red Sea). Ensure critical text (prices, addresses, dates) maintains high perceptual contrast on light backgrounds.
- **Non-Color-Only Rule:** Status must NEVER be communicated by color alone. Every colored status badge (green, amber, red) must be accompanied by an explicit text label or unambiguous semantic icon.

---

## 2. Touch Target Ergonomics & Platform Conventions

To maintain disciplined ergonomics without artificial constraints, distinguish between platform guidance tiers:
1. **Legal & Conformance Requirements:** Binding statutory standards.
2. **Platform Recommendations:** Vendor guidelines (Apple HIG recommends ~44×44pt; Google Material Design 3 recommends ~48×48dp). These are authoritative recommendations, not universal cross-platform laws.
3. **Platform Conventions:** Muscle-memory expectations (e.g. edge swipe gestures).
4. **Implementation Evidence:** Empirical ergonomic measurements on real physical hardware.

### Hit Regions vs. Visual Geometry:
- **High-Density Controls:** In dense operational layouts (Owner calendar date cells, compact Admin filter chips), visual graphics may be compact (e.g. 32px height) provided transparent touch hit delegation maintains a comfortable target region.
- **Primary Buttons:** Mobile primary action controls must provide comfortable tap targets spanning full width or minimum 48dp height.

---

## 3. Screen Reader Semantic Contracts (Arabic-Native)

Assistive technologies (TalkBack on Android, VoiceOver on iOS) must receive complete, honest semantic descriptions:

### A. Action Button vs. Toggle Semantics (Crucial Invariant):
- **Ordinary Action Buttons:** For non-toggle action controls (e.g. "طلب حجز", "إغلاق", "رجوع"), the selected-state capability must be **COMPLETELY ABSENT** (`hasSelectedState = false`). It is NEVER acceptable to announce `isSelected == false` on an ordinary button.
- **Genuine Toggles:** Selected-state capability is reserved strictly for elements that retain an active/inactive toggle state (e.g. favorite bookmark, filter checkbox, selection radio). Only these elements declare `hasSelectedState = true` with `isSelected: true | false`.

### B. Meaningful Arabic Accessibility Labels:
- Icon-only buttons (search, filter, share, clear) must declare clear Arabic semantic labels (e.g. "بحث", "تصفية النتائج", "مشاركة العقار").
- **No Trait Redundancy:** Do not include component traits inside the label string (e.g. say "طلب حجز", do not say "زر طلب حجز").

### C. Decorative Elements:
- Purely decorative dividers, ambient background graphics, and non-actionable icons must be hidden from screen readers.

---

## 4. Text Scaling & Dynamic Type Resilience

KONFRM interfaces must gracefully support full platform dynamic text scaling:
1. **No Fixed Pixel Containers:** Never place text inside containers with rigid, unyielding height constraints that cause text truncation or vertical clipping when scaled.
2. **Zero Truncation on Critical Data:** Financial numbers (prices, deposits, balances), booking dates, reservation codes, and confirmation buttons must NEVER truncate (ellipsis) under standard accessibility scaling.
3. **Fluid Wrapping:** Allow labels to wrap to multiple lines naturally as user text scaling increases.

---

## 5. Focus & Reduced Motion

- **Keyboard Focus Rings:** Desktop Web Admin interactive controls must display visible, high-contrast focus rings when navigated via keyboard.
- **Reduced Motion Intent:** Respect user system preferences (`prefers-reduced-motion` in Web; `disableAnimations` in mobile). When enabled, suppress non-essential spatial transitions and replace with instantaneous cuts or subtle opacity fades.
