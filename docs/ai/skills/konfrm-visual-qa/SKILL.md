---
name: konfrm-visual-qa
description: "Reference only. Consolidated into konfrm-design (references/visual_review.md). Do not use as primary design skill; use konfrm-design for optical checklists and konfrm-quality for verification."
---

# KONFRM Visual Quality Assurance (QA) Standards

Authoritative visual verification guidelines for validating mobile and web user interfaces before PR submission or Founder review.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.4, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

> [!CAUTION]
> ### CORE TENET: CI GREEN != VISUAL QA PASSED
> Unit tests and compiler checks verify syntax and logical flow; they do NOT verify optical alignment, Arabic text truncation, chevron mirroring, contrast readability, or mobile viewport clipping. Every UI change requires explicit visual verification.

---

## 1. Initial QA Reference Matrix (Candidate Coverage Set)

When testing user interface implementations, evaluate layouts against a representative device matrix. These viewports serve as an **INITIAL QA REFERENCE MATRIX / CANDIDATE COVERAGE SET** (DF2 §29.8), not permanent mandatory Canon:

### Mobile Viewport Reference Set
- **Compact Android Baseline (`360 × 800`):** Inspect for horizontal button clipping, text wrap in chips, and bottom bar overlap with software navigation controls.
- **Standard iPhone Baseline (`390 × 844`):** Inspect safe area insets (Dynamic Island / notch, home indicator) and standard reading hierarchy.
- **Large Flagship Baseline (`430 × 932`):** Inspect for excessive whitespace expansion, card stretching, and maximum width constraints.

### Web Admin Viewport Reference Set
- **Desktop Operational (`1440 × 900`):** Primary Admin operational dashboard view.
- **Compact Laptop (`1280 × 800`):** Multi-column table scrollability and navigation collapse.

---

## 2. Applicable State Verification Discipline

State applicability depends directly on the nature of the component or surface. Do not demand irrelevant states (e.g. an Empty state on a button, or Hover on a touchscreen):

- **Action Controls (e.g. Buttons, Links):**
  - Verify every applicable canonical state: Default, Pressed/Active, Focused (keyboard accessibility), Disabled (non-actionable), and Loading (in-flight request).
- **Data & Content Surfaces (e.g. Property Lists, Booking Queues):**
  - Verify every applicable canonical state: Loading (skeletons/indicators), Empty (helpful localized Arabic guidance), Error (actionable recovery message), Stale (server sync in progress), and Success (populated data).
- **Platform-Specific States:**
  - Hover states apply strictly to Web surfaces (`admin-app/`, current web implementations) and do not exist on native touchscreens.

---

## 3. RTL Optical Verification Checklist

Verify each of the following optical RTL rules during visual inspection:
- [ ] Back button chevron points RIGHT (→).
- [ ] Forward / drill-down chevrons point LEFT (←).
- [ ] Leading icons sit at the logical start (RIGHT) of text.
- [ ] Trailing status badges, disclosures, and timestamps sit at the logical end (LEFT).
- [ ] Arabic text glyphs do not exhibit clipped diacritics or descenders.
- [ ] Currency amounts render as `1,600 ج.م` with Western Arabic numerals (`0-9`).
- [ ] Phone numbers and booking reference IDs maintain LTR flow inside the RTL container.

---

## 4. Visual QA Reporting Discipline

- When a real UI implementation or visual artifact is produced, report the actual verified viewports, states, and optical checks.
- When performing routing simulations, architecture analyses, or non-visual changes, state explicitly:
  `VISUAL_QA: NOT EXECUTED — routing simulation only; no UI artifact exists.`
