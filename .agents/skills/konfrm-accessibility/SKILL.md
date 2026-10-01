---
name: konfrm-accessibility
description: "Non-waivable accessibility engineering standards for KONFRM. Enforces WCAG 2.2 AA contrast ratios, platform-appropriate touch target scaling (48dp primary, 36-40dp secondary), Arabic screen reader semantics, dynamic type scaling resilience (up to 130%), visible focus indicators, and reduced-motion compliance."
---

# KONFRM Accessibility Engineering Standards (WCAG 2.2 AA)

Authoritative, non-waivable accessibility specifications across Flutter Mobile and Web applications.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Contrast Ratios (WCAG 2.2 AA)

Every text element and essential user interface component must satisfy minimum luminance contrast ratios:

- **Body & Normal Text (< 18pt / 24px regular):** Minimum **4.5:1** contrast ratio.
  - On White (`#FFFFFF`): Dark slate/black text (`#0F172A` / `#000000`) provides 15:1+ contrast.
  - Secondary text (`#64748B` / `#475569`): must be verified to exceed 4.5:1 on light backgrounds. Never use `#94A3B8` for readable text on white.
- **Large Text (>= 18pt / 24px regular or >= 14pt / 18.5px bold):** Minimum **3.0:1** contrast ratio.
- **Essential UI Components & Interactive Borders:** Minimum **3.0:1** contrast ratio against adjacent background for inputs, checkboxes, toggles, and active button boundaries.

---

## 2. Touch Targets & Platform Ergonomics

KONFRM adapts touch target sizing according to task hierarchy and operational density:

- **Primary Interactive Targets:** Minimum **48×48dp** (e.g. "احجز الآن", "تأكيد الدفع", navigation tabs, main back button).
- **Secondary & Dense Controls:** **36–40dp touch target** with minimum 8dp clear spacing between interactive bounds is approved for high-density tables, chips, and secondary steppers.
- **Visual vs Tap Area:** Use transparent padding around compact visual elements (e.g. `IconButton` with `visualDensity: VisualDensity.compact` but retaining a 44–48dp gesture hit test).

---

## 3. Screen Reader Semantics (Arabic Native)

Both Mobile (TalkBack / VoiceOver) and Web (NVDA / VoiceOver) must receive informative Arabic semantic labels:

### Mobile (Flutter)
- Wrap interactive custom widgets in `Semantics`:
  ```dart
  Semantics(
    button: true,
    label: 'احجز الآن بسعر 1,600 ج.م لليلة',
    hint: 'انقر مرتين للانتقال إلى شاشة الدفع',
    child: KonfrmPrimaryButton(...),
  )
  ```
- Exclude decorative artwork, background svgs, and divider lines with `ExcludeSemantics(child: ...)`.

### Web (React)
- Interactive buttons must use native `<button>` or include `role="button"` and `tabIndex={0}`.
- Provide descriptive `aria-label` attributes in Arabic for icon-only buttons:
  ```tsx
  <button aria-label="إغلاق النافذة" onClick={onClose}>
    <X className="w-5 h-5" aria-hidden="true" />
  </button>
  ```

---

## 4. Dynamic Type & Text Scaling (130% Target)

Mobile screens must remain completely functional and legible when users increase system font size:
- Layouts must be tested at **1.3x (130%)** text scale.
- **Avoid Fixed Container Heights:** Never hardcode fixed pixel heights (e.g. `height: 48`) on containers holding dynamic text. Use `minHeight` or padding-based sizing with flexible wrapping (`Wrap`, `Flex`).
- **Ellipsis Rules:** Truncate secondary metadata with `TextOverflow.ellipsis`, but NEVER truncate primary financial prices, booking reference numbers, or legal consent checkboxes.

---

## 5. Focus Indicators & Keyboard Navigation

- **Web (Admin App):**
  - All interactive elements must show a distinct, high-contrast focus ring when focused via keyboard:
    `focus-visible:ring-2 focus-visible:ring-[#0059FF] focus-visible:outline-none focus-visible:ring-offset-2`.
  - Never remove focus outlines (`outline: none` without `ring` replacement is strictly forbidden).
- **Tab Order:** Logical DOM tab order following visual RTL flow (top-right to bottom-left).

---

## 6. Reduced Motion Compliance

Users with vestibular disorders or motion sensitivity must have motion suppressed:
- **Mobile (Flutter):**
  - Check `MediaQuery.of(context).disableAnimations`.
  - When true, transitions must be instantaneous (`Duration.zero`) or simple opacity cross-fades without translate/bounce spring curves.
- **Web (React/Tailwind):**
  - Respect `@media (prefers-reduced-motion: reduce)`.
  - Use `motion-reduce:transition-none` or `motion-reduce:animate-none`.
