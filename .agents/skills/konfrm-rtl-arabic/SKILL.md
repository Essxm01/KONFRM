---
name: konfrm-rtl-arabic
description: "Authoritative Arabic-first and RTL design engineering standards for KONFRM. Enforces directional mirroring, Cairo typography hierarchy, line-height compensation, canonical Western Arabic numerals (0-9), EGP currency formatting ('1,600 ج.م'), bidirectional text handling, and descender padding."
---

# KONFRM Arabic-First RTL Design Standards

Authoritative specifications for right-to-left (RTL) Arabic interface design across Flutter (Mobile) and React/Tailwind (Web).

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Core Principles: Arabic-First, RTL-Native

Arabic is the primary native language of the Egyptian real estate market and the KONFRM platform:
- The UI is engineered RTL-first, not retrofitted from an English LTR template.
- Reading flow begins from top-right to bottom-left.
- Primary navigation bars, action headers, and back buttons originate on the right.

---

## 2. Directional Mirroring Rules

### A. What MUST Mirror in RTL
- **Navigation Controls:** Back chevrons point RIGHT (→) to return to previous screens. Forward drill-down chevrons point LEFT (←).
- **Horizontal Progress:** Step indicators, onboarding carousels, and time-based sliders advance from right to left.
- **Card Layouts:** Leading icons, avatars, and thumbnails sit on the RIGHT; text body and trailing disclosure chevrons sit on the LEFT.
- **Form Controls:** Text alignment is right-aligned (`textAlign: TextAlign.right` / `text-right`). Clear buttons and dropdown arrows sit on the left.

### B. What MUST NOT Mirror (Remains LTR)
- **Media Controls:** Play, pause, fast-forward, and audio timeline sliders remain universally LTR.
- **Clockwise Circular Progress:** Spinners and circular charts maintain standard clockwise rotation.
- **Phone Numbers:** E.164 and local numbers format LTR (`+20 10 1234 5678`).
- **Alphanumeric Codes:** Booking references, transaction IDs, OTP verification fields, and IBANs remain LTR (`#KNF-88219`).

---

## 3. Typography & Cairo Hierarchy

The canonical UI typeface is **Cairo**. Arabic script requires specialized typographic handling:
- **Line-Height Compensation:** Arabic glyphs possess prominent ascenders and descenders. Standard Latin line-heights (1.1–1.2) clip Arabic diacritics and letters.
  - Body text line-height must be **1.4x to 1.6x** font size.
  - Headings line-height must be **1.25x to 1.35x**.
- **Asymmetric Vertical Padding:**
  - Due to Arabic descenders, buttons and input fields often look visually off-center if given identical top/bottom padding.
  - Add **1–2dp extra bottom padding** or adjust baseline alignment (`TextBaseline.alphabetic`) to achieve true visual optical centering.
- **Hierarchy Scale:**
  - Display / Hero: 24–28sp, Bold/Black (Cairo font-black / font-bold).
  - Title / Section: 18–20sp, Bold (Cairo font-bold).
  - Subtitle: 15–16sp, SemiBold (Cairo font-semibold).
  - Body: 14–15sp, Regular/Medium (Cairo font-normal / font-medium).
  - Caption / Metadata: 11–13sp, Medium (Cairo font-medium).

---

## 4. Numerals & Financial Formatting Canon

To ensure complete financial transparency and eliminate calculation errors, KONFRM strictly governs numeral representation:

### Canonical Numerals: Western Arabic Digits (0–9)
- **Rule:** Western Arabic digits (`0, 1, 2, 3, 4, 5, 6, 7, 8, 9`) are CANONICAL across all apps.
- **Eastern Arabic Digits (`٠, ١, ٢, ٣, ٤, ٥, ٦, ٧, ٨, ٩`) are STRICTLY FORBIDDEN** in financial amounts, dates, booking totals, phone numbers, and operational tables.
- **Rationale:** Banking gateways, credit card processing, mobile SMS OTPs, and backend APIs operate on ASCII digits. Mixing digit systems causes critical parse failures and user confusion in financial checkout.

### Currency Formatting
- Standard format: `[Amount] ج.م` with comma thousand separators and non-breaking space.
- Example: `1,600 ج.م` (not `ج.م 1600`, not `1600 EGP`, not `١٦٠٠ ج.م`).
- Nightly rate context: `1,600 ج.م / ليلة`.
- Total price context: `الإجمالي: 4,800 ج.م`.

---

## 5. Bidirectional Text (Bidi) Handling

When rendering mixed Arabic and English or alphanumeric strings:
- Wrap isolated numbers, phone numbers, and codes with Unicode Directional Markers or directional widgets:
  - Flutter: `Bidi.stripHtmlIfNeeded(...)` or wrap in `Directionality(textDirection: TextDirection.ltr, child: ...)`
  - React / Web: `<span dir="ltr">...</span>` or CSS `unicode-bidi: isolate;`
- Ensure phone number inputs strictly declare LTR direction while the placeholder and error helper text remain RTL.
