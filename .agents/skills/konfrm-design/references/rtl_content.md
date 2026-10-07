# Arabic-First RTL Layout Semantics & Content Governance

```yaml
MODULE: rtl_content.md
BRAIN: konfrm-design
AUTHORITY: DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md §11–§12 + DESIGN_SYSTEM/GUIDELINES/rtl.md
```

This reference defines the core right-to-left (RTL) layout semantics, bidirectional content isolation, numeral conventions, and canonical financial string formatting across Arabic KONFRM surfaces.

---

## 1. Native Arabic-First Architecture

Arabic is the primary native language of KONFRM. All interfaces are engineered RTL-native from inception:
- **Reading Progression:** Arabic reading order is RTL; interface alignment and sequencing follow logical start/end while vertical page progression remains top-to-bottom.
- **Direction-Relative Alignment:** All spatial positioning uses logical directional coordinates (`start` / `end`, `leading` / `trailing`) rather than hardcoded physical coordinates (`left` / `right`).
- **Default Text Alignment:** Body text, headlines, form field labels, and descriptions are aligned to the logical `start` (RIGHT).

---

## 2. Directional UI vs. Exceptions (The "Mirror Everything" Anti-Rule)

In DF2 §11, the doctrine of *"mirror everything"* is explicitly **NOT canonical**. Layout elements must never be mirrored mechanically merely because the parent screen is in RTL mode:

### A. Elements That Follow RTL Semantics (Mirrored):
- **Navigation Controls:** Back buttons point RIGHT (→) to navigate back in history. Forward drill-down disclosure chevrons point LEFT (←) to navigate deeper.
- **List & Card Items:** Leading icons, avatars, and property thumbnails sit on the logical `start` (RIGHT). Trailing badges, action triggers, and chevron indicators sit on the logical `end` (LEFT).
- **Form Controls:** Field labels align to the `start` (RIGHT); dropdown carets, clear buttons, and password-visibility toggles sit at the `end` (LEFT).

### B. Platform Conventions & Semantic Exceptions (Do Not Blindly Mirror):
- **Temporal & System Controls:** Do not blindly mirror temporal, circular, or platform-standard controls. Preserve current platform conventions unless product semantics require otherwise.
- **System Progress Spinners:** Circular loading indicators and refresh spinners preserve standard platform rotation rather than being arbitrarily reversed.
- **Media Timelines & Progress Bars:** Audio/video playback timelines, scrubbers, and waveforms follow platform-standard temporal progression.
- **Maps & Absolute Coordinates:** Geographic maps and Cartesian coordinate axes preserve absolute spatial orientation.

---

## 3. Bidirectional (Bidi) Text & Technical Data Isolation

When Arabic text contains numbers, codes, or Latin characters, naive rendering causes punctuation jumping and digit scramble. All such runs must be isolated into distinct left-to-right (LTR) sub-runs:

- **Isolated LTR Data Types:**
  - Phone numbers (`+20 100 123 4567`)
  - Booking reference codes (`#KNF-88219`)
  - IBANs and bank account numbers (`EG380002...`)
  - URLs and email addresses
  - Technical transaction hashes and UUIDs
- **Design Intent:** The enclosing container flows RTL, but the technical string itself must maintain strict LTR sequence so that symbols like `#`, `+`, and dashes appear in their mathematically correct positions.

---

## 4. Numerals & Financial Formatting Governance

### A. Default Numeral System: Western Arabic (0–9)
- **Canonical Default:** Western Arabic numerals (`0, 1, 2, 3, 4, 5, 6, 7, 8, 9`) are the **DEFAULT** across all Arabic KONFRM UI surfaces (DF2 §12).
- Never arbitrarily switch to Eastern Arabic numerals (`٠, ١, ٢...`) in pricing, balances, or technical inputs.

### B. Canonical Financial Formatting:
- **Currency Unit:** `ج.م` (Egyptian Pound).
- **Formatting Rule:** Western Arabic digits + standard thousands separator (`,`) + non-breaking space + currency suffix (`ج.م`).
- **Standard Price Examples:**
  - Single amount: `1,600 ج.م`
  - Nightly rate: `1,600 ج.م / ليلة`
  - Total stay price: `الإجمالي: 4,800 ج.م`
  - Deposit amount: `العربون: 1,600 ج.م`

### C. Date & Calendar Localization Boundary:
- Date picker and calendar numeral formatting is a **SEPARATELY GOVERNED DECISION**.
- Do not assert universal cross-platform bans on Eastern numerals in calendar widgets, nor mandate them universally. Calendar display conforms to platform system conventions and confirmed product specifications.
