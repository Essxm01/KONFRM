---
name: konfrm-rtl-arabic
description: "Authoritative Arabic-first and RTL design engineering standards for KONFRM. Enforces logical start/end, selective directional semantics (no universal mirror-everything), Western Arabic numerals (0-9) as default, canonical money formatting ('1,600 ج.م'), separately governed calendar localization, and bidirectional sub-run isolation."
---

# KONFRM Arabic-First RTL Design Standards

Authoritative specifications for right-to-left (RTL) Arabic interface engineering across KONFRM Web and Mobile surfaces. Governed by `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` §11–§12.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.3, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals as default, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste, localization rules, or brand identity.**

---

## 1. Core Foundations: Arabic-First & RTL-Native

Arabic is the primary native language of the KONFRM marketplace and product experience:
- Interfaces are engineered RTL-native from the ground up, not translated from LTR English templates.
- Natural reading flow progresses from top-right to bottom-left.
- Structure layouts using logical direction-relative semantics (`start` / `end`, `leading` / `trailing`) rather than hardcoded physical `left` / `right`.

---

## 2. Directional Semantics & Exceptions (No Blind Mirroring)

### A. Direction-Relative UI (Follows RTL Semantics)
- **Navigation Controls:** Back buttons point right (→) to return to previous screens in RTL. Forward drill-down disclosure chevrons point left (←).
- **Card & List Items:** Leading icons, avatars, and property thumbnails sit on the start (RIGHT); body text flows start-to-end; trailing indicators and disclosure cues sit on the end (LEFT).
- **Form Controls:** Text alignment is right-aligned by default; dropdown carets and clear triggers sit at the end (LEFT).

### B. Semantic & Platform Exceptions (Anti-Rule: Do NOT "Mirror Everything")
- **The "Mirror Everything" Anti-Rule:** In DF2 (§11), *"mirror everything"* is explicitly **NOT canonical**. Elements must never be mirrored merely because the parent container or screen is RTL.
- **Progress Direction & Media Timelines:** Direction-relative UI follows RTL semantics where meaning is truly direction-relative. However, horizontal progress bars, media timelines, audio/video scrubbers, charts, maps, and system pickers must be evaluated by their intrinsic semantic meaning and platform conventions rather than being forced into rigid mirroring.
- **Clockwise Circular Progress:** Activity spinners and circular indicators retain standard clockwise rotation.
- **Isolated LTR Data Runs:** Phone numbers, URLs, booking reference IDs (`#KNF-88219`), and IBANs must be isolated to maintain standard LTR flow within the RTL container.

---

## 3. Typography & Font Candidates

- **Cairo Font Family Status:**
  - Cairo Profile B scale and metrics is the **SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY** foundation, supported by strong Web evidence and Phase 4B typography evaluation.
  - Final native mobile acceptance remains deferred to real device legibility, scaling, and rendering performance validation in Phase 4I.
- **Typographic Craft Considerations (Observational Guidance):**
  - Arabic script features distinct vertical ascenders and descenders. Tight Latin line-height defaults can cause diacritic or descender clipping. Ensure vertical line-heights are tested on device to provide comfortable reading breathing room.
  - Button text vertical optical centering should be verified visually on device, accounting for script baseline characteristics.
  - Do not hardcode rigid universal typographic scales into global canon; scales are validated per component and role.

---

## 4. Numerals & Financial Formatting Governance

### A. Numerals: Western Arabic Digits (0–9) as Default
- **Default Rule:** Western Arabic numerals (`0, 1, 2, 3, 4, 5, 6, 7, 8, 9`) are the **DEFAULT** in Arabic KONFRM UI (DF2 §12).
- **Canonical Money Presentation:** Customer-facing monetary values and financial calculations canonically use Western Arabic digits:
  - Standard format: `1,600 ج.م` with standard thousands separators and a non-breaking space before the currency suffix.
  - Nightly rate format: `1,600 ج.م / ليلة`.
  - Total price format: `الإجمالي: 4,800 ج.م`.
- **Date & Calendar Localization Separately Governed:**
  - Date and calendar numeral localization is a **SEPARATELY GOVERNED DECISION**; do not assert universal cross-platform bans on Eastern digits in dates or calendars, nor mandate them. Specific calendar and date-picker localization follows confirmed Product Truth and platform conventions.
- **Technical & Financial Invariants:** Technical IDs, phone numbers, OTP verification runs, and banking identifiers strictly require standard numeric representation with bidirectional isolation to prevent parsing and layout inversion errors.

---

## 5. Bidirectional Text (Bidi) Handling

When rendering mixed Arabic and English or alphanumeric strings:
- Isolate phone numbers, transaction hashes, and English names into distinct LTR sub-runs so punctuation and numbers do not invert or break layout flow.
- Ensure screen readers correctly announce isolated numbers and currencies in Arabic context without scrambling digit order.
