---
name: konfrm-rtl-arabic
description: "Authoritative Arabic-first and RTL design engineering standards for KONFRM. Enforces logical start/end, directional mirroring, canonical Western Arabic numerals (0-9), EGP currency formatting ('1,600 ج.م'), and bidirectional sub-run isolation without inventing unapproved font or line-height canon."
---

# KONFRM Arabic-First RTL Design Standards

Authoritative specifications for right-to-left (RTL) Arabic interface engineering across KONFRM Web and Mobile surfaces.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Core Foundations: Arabic-First & RTL-Native

Arabic is the primary native language of the KONFRM marketplace and product experience:
- Interfaces are engineered RTL-native from the ground up, not translated from LTR English templates.
- Natural reading flow progresses from top-right to bottom-left.
- Structure layouts using logical direction-relative semantics (`start` / `end`, `leading` / `trailing`) rather than hardcoded physical `left` / `right`.

---

## 2. Directional Mirroring & Exceptions

### A. What MUST Mirror in RTL
- **Navigation Controls:** Back buttons point right (→) to return to previous screens. Forward drill-down disclosure chevrons point left (←).
- **Horizontal Progress:** Step indicators, onboarding carousels, and time-based progression flow from right to left.
- **Card & List Items:** Leading icons, avatars, and property thumbnails sit on the start (RIGHT); body text flows start-to-end; trailing indicators and chevrons sit on the end (LEFT).
- **Form Controls:** Text alignment is right-aligned by default; dropdown carets and clear triggers sit at the end (LEFT).

### B. Explicit Exceptions (Remain LTR)
- **Media Controls:** Audio/video timelines and play/pause controls maintain universal left-to-right orientation.
- **Clockwise Circular Progress:** Activity spinners and circular indicators retain standard clockwise motion.
- **Isolated LTR Data Runs:** Phone numbers, URLs, booking reference IDs (`#KNF-88219`), and IBANs must be isolated to maintain standard LTR flow within the RTL container.

---

## 3. Typography & Font Candidates

- **Cairo Font Family Status:**
  - Cairo is an **IMPLEMENTATION CANDIDATE** for the bundled mobile UI font family (§27.7), supported by strong Web evidence.
  - It is NOT yet locked as canonical mobile font pending real device legibility, scaling, and rendering performance validation (§29.1).
- **Typographic Craft Considerations (Observational Guidance):**
  - Arabic script features distinct vertical ascenders and descenders. Tight Latin line-height defaults can cause diacritic or descender clipping. Ensure vertical line-heights are tested on device to provide comfortable reading breathing room.
  - Button text vertical optical centering should be verified visually on device, accounting for script baseline characteristics.
  - Do not hardcode rigid universal typographic scales into global canon; scales are validated per component and role.

---

## 4. Numerals & Financial Formatting Canon

To ensure absolute financial transparency and eliminate calculation or parsing ambiguity, numeral representations are strictly canonical:

### Canonical Numerals: Western Arabic Digits (0–9)
- **Rule:** Western Arabic digits (`0, 1, 2, 3, 4, 5, 6, 7, 8, 9`) are CANONICAL across all applications.
- **Eastern Arabic Digits (`٠, ١, ٢, ٣, ٤, ٥, ٦, ٧, ٨, ٩`) are STRICTLY FORBIDDEN** in financial amounts, dates, booking totals, phone numbers, and operational tables.
- **Rationale:** Payment gateways, bank integrations, SMS OTPs, and backend APIs operate on standard numeric strings. Mixing numeral glyphs introduces critical parsing errors and checkout confusion.

### Currency Presentation
- Standard format: `1,600 ج.م` with standard thousands separators and a non-breaking space before the currency suffix.
- Nightly rate format: `1,600 ج.م / ليلة`.
- Total price format: `الإجمالي: 4,800 ج.م`.

---

## 5. Bidirectional Text (Bidi) Handling

When rendering mixed Arabic and English or alphanumeric strings:
- Isolate phone numbers, transaction hashes, and English names into distinct LTR sub-runs so punctuation and numbers do not invert or break layout flow.
- Ensure screen readers correctly announce isolated numbers and currencies in Arabic context without scrambling digit order.
