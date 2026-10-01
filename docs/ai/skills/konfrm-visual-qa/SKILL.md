---
name: konfrm-visual-qa
description: "Visual Quality Assurance and multi-device verification standards for KONFRM. Enforces testing across 360x800, 390x844, and 430x932 viewports, complete state verification (Default, Pressed, Focused, Disabled, Loading, Error, Empty), RTL visual alignment, contrast verification, and mandates that green CI does not equal visual QA pass."
---

# KONFRM Visual Quality Assurance (QA) Standards

Authoritative visual verification guidelines for validating mobile and web user interfaces before PR submission or Founder review.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

> [!CAUTION]
> ### CORE TENET: CI GREEN != VISUAL QA PASSED
> Unit tests and compiler checks verify syntax and logical flow; they do NOT verify optical alignment, Arabic text truncation, chevron mirroring, contrast readability, or mobile viewport clipping. Every UI change requires explicit visual verification.

---

## 1. Multi-Viewport Mobile Matrix

Every mobile screen or component must be verified against three standard viewport classes:

| Viewport Category | Dimensions | Target Representative Device | Critical Edge Cases to Inspect |
|-------------------|------------|------------------------------|--------------------------------|
| **Compact Android** | `360 × 800` | Samsung Galaxy A-series, Xiaomi | Horizontal button clipping, text wrap in chips, bottom bar overlap with software nav bar. |
| **Standard iPhone** | `390 × 844` | iPhone 13, 14, 15 | Dynamic island / notch safe area, home indicator bottom inset, standard Cairo line height. |
| **Large Flagship** | `430 × 932` | iPhone 15 Pro Max, Galaxy S24 Ultra | Excessive whitespace stretching, maximum container width constraints, tablet drift. |

### Web Admin Viewports
- **Standard Desktop:** `1440 × 900` (Primary Admin operational view).
- **Compact Laptop:** `1280 × 800` (Verify multi-column table horizontal scrolling and sidebar collapse).

---

## 2. Complete State Matrix Verification

Never sign off on a component or screen having verified only its default happy path. Test all 8 mandatory states:

1. **Default (Resting):** Neutral surface, verified contrast against `#FFFFFF` / `#F8FAFC`.
2. **Pressed / Active:** Visual depression (e.g. `transform: scale(0.98)` or dark overlay `Colors.black12`), instant feedback.
3. **Hover (Web Admin):** Subtle elevation or background tint (`hover:bg-slate-100`).
4. **Focused:** High-contrast focus ring for keyboard accessibility (`ring-2 ring-[#0059FF]`).
5. **Disabled:** Visual attenuation (`opacity-50`, `#94A3B8`), cursor not-allowed, zero pointer event triggers.
6. **Loading:** Monochromatic spinner or pulse skeleton matching layout dimensions; user action button disabled to prevent duplicate submission.
7. **Error State:** Distinct red border/accent (`#DC2626`), clear localized Arabic explanation beneath the field.
8. **Empty State:** Friendly, polite Arabic explanation with icon and primary recovery action.

---

## 3. RTL Optical Verification Checklist

Verify each of the following optical RTL rules during visual inspection:
- [ ] Back button chevron points RIGHT (→).
- [ ] Forward / drill-down chevrons point LEFT (←).
- [ ] Leading icons (magnifying glass, user avatar, checkmark) sit on the RIGHT of text.
- [ ] Trailing status badges, disclosures, and timestamps sit on the LEFT.
- [ ] Arabic text glyphs do not have clipped diacritics or descenders.
- [ ] Currency amounts render as `1,600 ج.م` with Western Arabic numerals (`0-9`).
- [ ] Phone numbers and booking reference IDs maintain LTR flow inside the RTL container.

---

## 4. Visual QA Verification Report Template

When submitting UI work, include the Visual QA section in the final report:

```markdown
#### Visual QA Verification Summary
- **Viewports Inspected:**
  - [x] 360x800 (Compact Android) — Verified no horizontal overflow.
  - [x] 390x844 (Standard iPhone) — Safe areas and bottom bar verified.
  - [x] 430x932 (Large iPhone) — Card density and max-width verified.
- **States Verified:** Default, Pressed, Disabled, Loading, Error, Empty.
- **RTL Integrity:** Directional chevrons mirrored, Western Arabic numerals confirmed.
- **Contrast Check:** Text contrast exceeds 4.5:1 on all surfaces.
```
