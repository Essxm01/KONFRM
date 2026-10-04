# KONFRM — Cairo Typography Foundation Validation 01 (Round 1 Report)

**Repository:** `KONFRM-CANONICAL`  
**Branch:** `design/typography-foundation-cairo-01`  
**Base Commit SHA:** `e98c47fda65c938ebd0af745534c150a1a94428e` (origin/main)  
**Governance Mode:** CONTROLLED DESIGN PILOT ONLY — EVIDENCE PARITY & MEASUREMENT CORRECTION  
**Canon Promotion:** NONE  
**Production Code Changed:** NONE  
**Git Mutations:** NONE (No commit, push, or PR)  
**Primary Anchor Primitive:** Button Radius Candidate = `6px`, Color Strategy = `Stable Black` (`#0F172A`), Touch Height = `48px` (Pilot Web CSS-Pixel Implementation Value only; not final native mobile Canon)  
**Font Family Authority:** CAIRO (Founder visual decision confirmed; not reopened).  

---

> [!IMPORTANT]
> ### Governance & Evidence Neutrality Directive
> This report documents the **Round 1 Evidence Parity Correction** for Cairo mobile typography validation.
> - **Zero Selection Bias:** All language recommending, ranking, or favoring Profile B as a "winner" or "best candidate" has been removed. Profiles A, B, and C receive identical methodological coverage, symmetrical DOM measurements, and equal visual audit presentation.
> - **Founder Selection Status:** `CURRENT_BEST_EVIDENCE_CANDIDATE: NONE — FOUNDER SELECTION NOT YET PERFORMED`. `PROFILE_RANKING: NOT ESTABLISHED`.
> - **Default Neutral Profile in Decision Lab:** `PROFILE A (Existing Baseline)`.
> - **Web vs. Native Boundary:** All findings represent **Web typography and layout evidence** under headless Chromium simulation. Native iOS Dynamic Type, Android fontScale, and Flutter engine rendering remain unvalidated (deferred to Phase 4I).
> - **Test Widths:** 360px, 390px, and 430px represent **deterministic Web test frames**, completely distinct from browser `window.innerWidth` and commercial hardware designations.

---

## 1. Executive Summary & Historical Evidence Status

Following independent Codex review, the initial Round 1 artifacts were audited and identified with coverage asymmetry, arithmetic width assumptions, and profile selection bias. This revision executes a comprehensive, same-task evidence correction:

1. **Previous Round 1 Evidence Preserved but Downgraded:**  
   The initial screenshot set in `evidence/round1/` has been preserved for audit trail integrity and formally classified as:  
   `PRE-CORRECTION EVIDENCE — NOT CURRENT SELECTION AUTHORITY` (see [`evidence/round1/HISTORICAL_STATUS.md`](./evidence/round1/HISTORICAL_STATUS.md)).
2. **Current Authoritative Evidence:**  
   The corrected, fully symmetrical 72-combination dataset and balanced screenshots are established in:  
   [`evidence/round1_corrected/`](./evidence/round1_corrected/).

---

## 2. Pinned Font Asset Provenance Record

To ensure 100% reproducible layout measurements and eliminate host-machine or network font drift, Cairo is pinned repository-locally for this pilot:

- **Upstream Source:** Official Google Fonts repository (`google/fonts/ofl/cairo`)
- **Direct Source Asset:** `Cairo[slnt,wght].ttf`
- **Committed Local File:** `DESIGN_SYSTEM/PILOTS/typography-foundation-cairo-01/fonts/Cairo-VariableFont.ttf`
- **License:** SIL Open Font License, Version 1.1 (see [`OFL.txt`](./fonts/OFL.txt))
- **File Size:** `599,548` bytes
- **SHA-256 Checksum:** `667c987182391c91f4e57a2f455b1794fb5e3ee6ca4ef3383e86bb690fa9c964`
- **Pilot Font-Family Alias:** `"KONFRM Typography Pilot Cairo"`
- **Loading Gate:** Fail-closed `document.fonts.load('700 15px "KONFRM Typography Pilot Cairo"', '...')` verified with `document.fonts.check()`. If the pinned asset fails to load, measurement execution halts immediately with an explicit error badge.

---

## 3. Controlled Candidate Profiles (Symmetrical Definitions)

The pilot evaluates three viable typographic profiles across the 10 roles defined in the DF2 Mobile Role Model (`DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` §10). Surfaces, spacing, colors, button 6px radius, stable black `#0F172A`, and 48px touch container height remain strictly invariant.

| Role | Role Intent (DF2 §10) | Profile A (Existing Baseline) | Profile B (Mobile Balanced) | Profile C (High-Clarity) |
| :--- | :--- | :--- | :--- | :--- |
| **`display`** | Rare high-level screen introduction | `28px / 800 / 1.35` | `24px / 700 / 1.30` | `26px / 700 / 1.35` |
| **`pageTitle`** | Primary page / screen title | `22px / 800 / 1.45` | `20px / 700 / 1.35` | `22px / 700 / 1.40` |
| **`sectionTitle`**| Section grouping heading | `18px / 700 / 1.50` | `17px / 700 / 1.40` | `18px / 700 / 1.45` |
| **`cardTitle`** | Card / list item / modal title | `16px / 700 / 1.50` | `15px / 700 / 1.40` | `16px / 700 / 1.45` |
| **`body`** | Default readable body copy | `14px / 500 / 1.65` | `14px / 500 / 1.50` | `15px / 500 / 1.55` |
| **`bodyStrong`** | In-copy emphasis without heading | `14px / 700 / 1.65` | `14px / 700 / 1.50` | `15px / 700 / 1.55` |
| **`label`** | Field labels, compact controls | `13px / 700 / 1.50` | `12px / 600 / 1.35` | `13px / 700 / 1.40` |
| **`supporting`** | Helper / metadata copy | `12px / 600 / 1.50` | `12px / 400 / 1.40` | `13px / 500 / 1.45` |
| **`numeric`** | Financial / operational values | `16px / 700 / 1.50` | `16px / 700 / 1.30` | `17px / 700 / 1.35` |
| **`button`** | Actionable control label | `14px / 700 / 1.40` | `15px / 700 / 1.20` | `15px / 700 / 1.25` |

---

## 4. Test Methodology & Geometry Measurement Correction

### Arithmetic Width Assumption Removed
In the previous pre-correction matrix, content width was calculated using the formula `contentWidth = frameWidth - 48`.  
Codex review identified that this assumption diverged from actual rendered shell layout. In this corrected pass, all geometry values are measured directly from live DOM rectangles:
- `FRAME_WIDTH_RENDERED`: Measured via `frame.getBoundingClientRect().width`.
- `CONTENT_WIDTH_RENDERED`: Measured via `contentContainer.getBoundingClientRect().width`.
- `Padding & Borders`: Recorded via `window.getComputedStyle()`.

### Authoritative Shell & Nested Layout Geometry

To eliminate ambiguity between outer containers, inner padding envelopes, vertical scrollbar effects, and card title boxes, every reported width is categorized strictly as `MEASURED_DOM` (with selector and live bounding rect) or `DERIVED` (with its exact algebraic equation):

#### Definitions & DOM Selectors:
- **`FRAME_WIDTH` (`MEASURED_DOM`):** `#single-device-frame` (`.device-shell`). Total outer frame bounding box width. Borders: `12px` inline-start + `12px` inline-end (`box-sizing: border-box`). Client width = `frameWidth - 24px`.
- **`SHELL_CONTENT_WIDTH` (`MEASURED_DOM`):** `#device-scroll-content` (`.device-content`). Outer bounding box width of scroll container = `336px` (360), `366px` (390), `406px` (430). Padding: `16px` inline-start + `16px` inline-end (`32px` total).
- **`VERTICAL_SCROLLBAR_WIDTH` (`MEASURED_DOM`):** Due to `overflow-y: auto` and `max-height: 720px`, when simulated content height exceeds 720px, Windows Chromium allocates a `15px` vertical scrollbar, reducing `.device-content` client width from `336px` to `321px` (at 360px), `366px` to `351px` (at 390px Customer), and `406px` to `391px` (at 430px Customer). When content does not scroll (Owner at 390px/430px at 100% scale), scrollbar width is `0px`.
- **`CARD_OUTER_WIDTH` (`MEASURED_DOM`):** `#cust-card-surface` / `#owner-card-surface` (`.card-surface`). Measured bounding box width of the card.
  - With vertical scrollbar: `289px` (360), `319px` (390), `359px` (430).
  - Without vertical scrollbar: `304px` (360), `334px` (390), `374px` (430).
  - Borders: `1px` inline-start + `1px` inline-end (`2px` total).
  - Padding: `14px` inline-start + `14px` inline-end (`28px` total).
- **`CARD_INNER_CONTENT_WIDTH` (`DERIVED`):** Available horizontal content space inside the card.
  - *Scrolled Layout Equation:* `cardOuter (MEASURED_DOM) - cardBorders (2px) - cardPaddings (28px) = cardOuter - 30px`.
    - 360px frame: `289px - 30px = 259px`
    - 390px frame: `319px - 30px = 289px`
    - 430px frame: `359px - 30px = 329px`
  - *Unscrolled Ideal Layout Equation:* `frameWidth - shellBorders (24px) - contentPaddings (32px) - cardBorders (2px) - cardPaddings (28px) = frameWidth - 86px`.
    - 360px frame: `360px - 86px = 274px` (DERIVED unscrolled baseline)
    - 390px frame: `390px - 86px = 304px` (DERIVED unscrolled baseline / MEASURED in Owner 390 unscrolled)
    - 430px frame: `430px - 86px = 344px` (DERIVED unscrolled baseline / MEASURED in Owner 430 unscrolled)
- **`CARD_TITLE_BOX_WIDTH` (`MEASURED_DOM`):** `#cust-card-title` / `#owner-card-title` (`.typo-card-title`). Live bounding rect width of the title container element:
  - 360px frame: `259px` (`MEASURED_DOM`)
  - 390px frame: `289px` (`MEASURED_DOM` in Customer) / `304px` (`MEASURED_DOM` in Owner unscrolled)
  - 430px frame: `329px` (`MEASURED_DOM` in Customer) / `344px` (`MEASURED_DOM` in Owner unscrolled)
- **`TEXT_CONTENT_BOX_WIDTH` (`MEASURED_DOM`):** `#cust-body-copy` / `#owner-body-copy` (`.typo-body`). Bounding rect matches `CARD_TITLE_BOX_WIDTH`: `259px` (360), `289px` (390 Customer), `329px` (430 Customer).

#### Deterministic Geometry Summary Table:

| Test Frame | Measurement Condition | Shell Content (`.device-content`) | Vertical Scrollbar | Card Outer (`.card-surface`) | Card Inner Content Box | Card Title Box (`.typo-card-title`) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **360px** | **MEASURED_DOM (Live Scrolled)** | `336px` (Client: `321px`) | `15px` | `289px` (Client: `287px`) | `259px` (DERIVED: `289 - 30`) | **`259px`** |
| 360px | *DERIVED (Unscrolled Baseline)* | `336px` (Client: `336px`) | `0px` | `304px` | `274px` (DERIVED: `304 - 30`) | `274px` |
| **390px** | **MEASURED_DOM (Live Scrolled - Customer)** | `366px` (Client: `351px`) | `15px` | `319px` (Client: `317px`) | `289px` (DERIVED: `319 - 30`) | **`289px`** |
| 390px | **MEASURED_DOM (Unscrolled - Owner)** | `366px` (Client: `366px`) | `0px` | `334px` (Client: `332px`) | `304px` (DERIVED: `334 - 30`) | **`304px`** |
| **430px** | **MEASURED_DOM (Live Scrolled - Customer)** | `406px` (Client: `391px`) | `15px` | `359px` (Client: `357px`) | `329px` (DERIVED: `359 - 30`) | **`329px`** |
| 430px | **MEASURED_DOM (Unscrolled - Owner)** | `406px` (Client: `406px`) | `0px` | `374px` (Client: `372px`) | `344px` (DERIVED: `374 - 30`) | **`344px`** |

### Full 72-Combination Rendered Matrix
The corrected matrix measures every combination of:
`3 Profiles (A, B, C) × 2 Roles (Customer, Owner) × 3 Test Frames (360, 390, 430) × 4 Text Scales (100%, 125%, 150%, 200%) = 72 Combinations`.
All rows are recorded with element-by-element line counts via `Range.getClientRects()`, scroll/client widths, nested width breakdown, and screen-level horizontal overflow in [`evidence/round1_corrected/rendered_matrix.json`](./evidence/round1_corrected/rendered_matrix.json).

---

## 5. Screen-Level Horizontal Overflow Findings & 200% Diagnosis

### Diagnosis of Previous 200% Scaling Scrollbar
**Result:** `PRODUCT_SIMULATION_OVERFLOW_CONFIRMED`.

**Investigation Evidence:**
1. In the initial 200% scaling screenshot (`scaling_200_profile_b.png`), a horizontal scrollbar was visible at the bottom of the device simulation.
2. Direct DOM inspection reveals that the scrollbar was situated directly on `.device-content` (the simulated mobile viewport), **NOT** on the outer lab shell (`.viewport-simulation-area` or browser window).
3. Under 200% text scaling (where font sizes are doubled, e.g. 14px → 28px, 16px → 32px, 20px → 40px), un-wrapped horizontal flex rows (`screen-nav-bar`, `fin-row`, image badges, and form phone rows) expand beyond the available inner card layout width (`259px` live measured / `274px` unscrolled ideal at 360px frame).
4. Because `.device-content` has `overflow-y: auto`, CSS Overflow Level 3 rules automatically compute its `overflow-x` to `auto`, causing the browser to render a native horizontal scrollbar.

### Symmetrical Matrix Overflow Breakdown (72 Combinations)
Across the 72 combinations, **56 passed with zero overflow** and **16 produced screen-level horizontal overflow**:

| Scale Factor | 360px Test Frame | 390px Test Frame | 430px Test Frame |
| :--- | :--- | :--- | :--- |
| **100% (1.0x)** | **0 / 6 Overflows (Pass)** | **0 / 6 Overflows (Pass)** | **0 / 6 Overflows (Pass)** |
| **125% (1.25x)** | **0 / 6 Overflows (Pass)** | **0 / 6 Overflows (Pass)** | **0 / 6 Overflows (Pass)** |
| **150% (1.50x)** | **3 / 6 Overflows** (Customer A, B, C overflow; Owner passes) | **1 / 6 Overflows** (Customer C only; A & B pass; Owner passes) | **0 / 6 Overflows (Pass)** |
| **200% (2.00x)** | **6 / 6 Overflows** (Customer & Owner overflow across A, B, C) | **3 / 6 Overflows** (Customer A, B, C overflow; Owner passes) | **3 / 6 Overflows** (Customer A, B, C overflow; Owner passes) |

**Empirical Architectural Insights:**
- *Owner Screen Resilience:* Owner operations UI is significantly more resilient to overflow than Customer UI because its financial data rows and status chips are structured with shorter text phrases. Owner UI passed with zero overflow at 100%, 125%, and 150% across all widths, and passed at 200% in 390px and 430px frames.
- *Profile C Expansiveness:* Due to larger nominal sizes (15px body, 17px numeric), Profile C triggers overflow earlier (overflowing in Customer 390px at 150%) and produces the largest overflow delta (+142px at 200%).
- *Responsive Component Implication:* At 200% text scaling, fixed horizontal rows require responsive wrapping (`flex-wrap: wrap`) in component contracts regardless of which typography profile is selected.

---

## 6. Tabular Numeral Rendered Measurement Harness

### Empirical Testing Methodology
To test whether `font-variant-numeric: tabular-nums` provides distinct alignment in Cairo, a live measurement harness rendered equal-length numeric strings under both `normal` and `tabular-nums` across weights `500`, `600`, and `700`:

| Weight | String | Normal Rendered Width | Tabular (`tnum`) Rendered Width | Measured Delta | Alignment Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **500 (Medium)** | `1111` | 35.78px | 35.78px | **0.00px** | Pass |
| **500 (Medium)** | `8888` | 35.78px | 35.78px | **0.00px** | Pass |
| **500 (Medium)** | `1234` | 35.78px | 35.78px | **0.00px** | Pass |
| **500 (Medium)** | `5678` | 35.78px | 35.78px | **0.00px** | Pass |
| **500 (Medium)** | `1,600` | 39.44px | 39.44px | **0.00px** | Pass |
| **500 (Medium)** | `4,800` | 39.44px | 39.44px | **0.00px** | Pass |
| **600 (SemiBold)** | `1111` | 35.78px | 35.78px | **0.00px** | Pass |
| **600 (SemiBold)** | `8888` | 35.78px | 35.78px | **0.00px** | Pass |
| **600 (SemiBold)** | `1234` | 35.78px | 35.78px | **0.00px** | Pass |
| **600 (SemiBold)** | `5678` | 35.78px | 35.78px | **0.00px** | Pass |
| **600 (SemiBold)** | `1,600` | 39.50px | 39.50px | **0.00px** | Pass |
| **600 (SemiBold)** | `4,800` | 39.50px | 39.50px | **0.00px** | Pass |
| **700 (Bold)** | `1111` | 35.59px | 35.59px | **0.00px** | Pass |
| **700 (Bold)** | `8888` | 35.59px | 35.59px | **0.00px** | Pass |
| **700 (Bold)** | `1234` | 35.59px | 35.59px | **0.00px** | Pass |
| **700 (Bold)** | `5678` | 35.59px | 35.59px | **0.00px** | Pass |
| **700 (Bold)** | `1,600` | 39.58px | 39.58px | **0.00px** | Pass |
| **700 (Bold)** | `4,800` | 39.58px | 39.58px | **0.00px** | Pass |

### Findings & Conclusion
- **`TABULAR_FEATURE_EFFECT`:** `NOT DISTINGUISHABLE IN TESTED CAIRO RENDERING`.
- **MEASURED FACT:** "In the tested pinned Cairo rendering, across the tested strings and weights 500/600/700, numeric width remained stable and no additional measurable width effect from `tabular-nums` was observed." (Measured delta is `0.00px` across all 18 tested conditions).
- **Engineering Explanation:** In the official Cairo variable font asset, Western Arabic digits (`0, 1, 2, 3, 4, 5, 6, 7, 8, 9`) are **already designed with monospaced default glyph advances** (e.g. `1111` and `8888` both measure exactly `35.59px` at weight 700). Enabling `font-variant-numeric: tabular-nums` produces a `0.00px` delta because Cairo's default digit advances are already tabular. This empirical observation is scoped specifically to the tested pinned font file under Web Chromium rendering and does not assert universal behavior across all scripts or native platforms.
- **`NUMERIC_ALIGNMENT_OBSERVED`:** `PASS`. Financial values and tables with equal digit counts align vertically with mathematical consistency.
- **Machine-Readable Dataset:** Stored in [`evidence/round1_corrected/numeral_measurements.json`](./evidence/round1_corrected/numeral_measurements.json) (exactly 18 logical rows).
- **Visual Evidence:** Captured in [`evidence/round1_corrected/tabular_numerals_harness.png`](./evidence/round1_corrected/tabular_numerals_harness.png) (showing the complete 18-row table, header, and finding box).

---

## 7. Arabic Clipping Evidence & Claim Hygiene

### Three-Tier Evidence Classification
1. **Tier A — Box / Layout Clipping (DOM Measured):**  
   Measured via `Range.getClientRects()`, bounding boxes, and container scroll properties. At 100% and 125% scale, no line clipping, text truncation, or box-overflow was observed in either Customer or Owner screens. At 150% and 200%, screen-level horizontal overflow occurs due to un-wrapped flex rows, but no individual text lines suffered unexpected mid-token clipping.
2. **Tier B — Visual Glyph Ink Inspection (Visual Web Evidence):**  
   Visual inspection of high-resolution screenshot artifacts confirmed that Cairo ascenders (أ، ل، ط) and descenders (ي، ح، ج، ع) retain clear counter-spaces and are not cropped by line bounding boxes.
3. **Tier C — Native Glyph Rendering (Platform Devices):**  
   `NOT TESTED / DEFERRED`. Web Canvas and Chromium DOM measurements do not equal native Flutter text rendering. Physical device validation on iOS and Android remains reserved for Phase 4I.

### Canvas TextMetrics Supporting Evidence
Direct measurement of Cairo glyph metrics at 16px / weight 700 via HTML5 Canvas `measureText()`:
- Glyph `'أ'`: Ascent = `13.52px`, Descent = `0.00px` (Total ink height = `13.52px`)
- Glyph `'ط'`: Ascent = `12.80px`, Descent = `0.00px` (Total ink height = `12.80px`)
- Glyph `'ي'`: Ascent = `8.40px`, Descent = `4.64px` (Total ink height = `13.04px`)
- Glyph `'ع'`: Ascent = `8.40px`, Descent = `5.12px` (Total ink height = `13.52px`)
- Glyph `'ح'`: Ascent = `8.40px`, Descent = `5.12px` (Total ink height = `13.52px`)

*Finding:* In all cases, the maximum vertical ink footprint (`13.52px`) remains strictly inside the 16px font-size and the `1.30–1.50` line-height envelope, providing clear clearance without ascender/descender collision.

---

## 8. Symmetrical Role Analysis

### A. Customer Role Parity (A vs B vs C)
The identical Customer booking surface was evaluated across all three profiles:
- *Page Title (`اكتشف إقامتك القادمة`):* Fits comfortably on 1 line across all profiles at 360px (Width: A = 196px, B = 178px, C = 196px).
- *Card Title (`فيلا خاصة بحمام سباحة في الساحل الشمالي`):* Renders on 1 line in standard layout; long stress title wraps to 2 lines across all three profiles.
- *Nightly Rate (`1,600 ج.م` / `لليلة الواحدة`):* Clear numeral rendering with stable currency suffix.
- *Booking Request Truth:* Dedicated body text ("سيتم إرسال طلبك إلى المالك للمراجعة...") reinforces truthful post-submission status (`PENDING_OWNER_APPROVAL`).
- *Primary Action Button:* 48px height, 6px radius, Stable Black (`#0F172A`) with label `إرسال طلب الحجز`.

### B. Owner Role Parity (A vs B vs C)
The identical Owner operations surface was evaluated across all three profiles:
- *Page Title (`إدارة حجوزاتك`):* Single-line header.
- *Section Title (`طلبات تحتاج إلى مراجعتك`):* Demarcates review queue without wrapping.
- *Financial Summary Cards:* Available balance `12,400 ج.م` and Pending requests `1 طلب جديد`.
- *Booking Request Card:* Booking status badge `طلب حجز جديد` | `في انتظار قرارك`, dates `15–18 أكتوبر 2026 (3 ليالٍ) • #KNF-88219`, guest `أحمد محمود • +20 10 9876 5432`.
- *Financial Payout Row:* `صافي المالك: 1,280 ج.م` (80% net payout).
- *Primary Action Button:* 48px height, 6px radius, Stable Black (`#0F172A`) with label `الموافقة على الطلب`.

---

## 9. Claim Reclassification Register

To ensure strict claim hygiene, all previous conclusions are reclassified:

| Topic | Previous Unchecked Assertion | Corrected Classification & Statement |
| :--- | :--- | :--- |
| **Weight 500 vs 400** | *"500 is distinctly superior to 400"* | **VISUAL OBSERVATION:** In the tested Web rendering, weight 500 appeared visually more robust and maintained clearer stroke definition than 400. Outdoor sunlight legibility remains a **HYPOTHESIS** pending physical device testing. |
| **Weight 800 Titles** | *"800 clogs Arabic loops"* | **VISUAL OBSERVATION:** On 360px and 390px frames, Cairo weight 800 appeared visually heavy, with closed character counters (ق، م، و) feeling denser compared to weight 700. |
| **Owner Scanning** | *"Profile B provides better operational scanning"* | **HYPOTHESIS:** Tighter line-heights in Profile B may reduce vertical travel for Owners, but operational scanning speed is a hypothesis that requires user/task testing. |
| **Touch Targets** | *"Fully accessible because ≥48px meets mobile standard"* | **PILOT WEB IMPLEMENTATION FACT:** The 48px button height is a Web CSS-pixel pilot implementation value. Compliance with native platform accessibility criteria (Apple HIG ~44pt, Android Material ~48dp) remains future native work. |
| **Tabular Numerals** | *"tabular-nums guarantees column alignment"* | **MEASURED FACT:** In the tested pinned Cairo rendering, across the tested strings and weights 500/600/700, numeric width remained stable and no additional measurable width effect from `tabular-nums` was observed (0.00px delta under `tnum` across all 18 conditions). Default Western Arabic digits share monospaced advances in this asset, producing stable vertical alignment. |

---

## 10. Corrected Visual Evidence Artifacts

The authoritative visual evidence set for Round 1 is located in `evidence/round1_corrected/`:

1. [`typography_lab_neutral_overview.png`](./evidence/round1_corrected/typography_lab_neutral_overview.png) — Overview of the Visual Decision Lab with Profile A default.
2. [`customer_side_by_side_360_scale100.png`](./evidence/round1_corrected/customer_side_by_side_360_scale100.png) — Symmetrical Customer comparison (A vs B vs C) at 360px / 100%.
3. [`customer_side_by_side_360_scale200.png`](./evidence/round1_corrected/customer_side_by_side_360_scale200.png) — Symmetrical Customer comparison (A vs B vs C) under 200% scaling stress.
4. [`owner_side_by_side_360_scale100.png`](./evidence/round1_corrected/owner_side_by_side_360_scale100.png) — Symmetrical Owner comparison (A vs B vs C) at 360px / 100%.
5. [`owner_side_by_side_360_scale200.png`](./evidence/round1_corrected/owner_side_by_side_360_scale200.png) — Symmetrical Owner comparison (A vs B vs C) under 200% scaling stress.
6. [`width_summary_390_scale100.png`](./evidence/round1_corrected/width_summary_390_scale100.png) — Symmetrical comparison across A/B/C at 390px frame width.
7. [`width_summary_430_scale100.png`](./evidence/round1_corrected/width_summary_430_scale100.png) — Symmetrical comparison across A/B/C at 430px frame width.
8. [`tabular_numerals_harness.png`](./evidence/round1_corrected/tabular_numerals_harness.png) — Rendered tabular numeral measurement table displaying all 18 rows.
9. [`rendered_matrix.json`](./evidence/round1_corrected/rendered_matrix.json) — Machine-readable dataset of all 72 test conditions with nested width breakdown.
10. [`numeral_measurements.json`](./evidence/round1_corrected/numeral_measurements.json) — Machine-readable dataset of all 18 tabular numeral test conditions (6 strings × 3 weights).

---

## 11. Final Evidence Synthesis & Selection Status

- **`CURRENT_BEST_EVIDENCE_CANDIDATE`:** `NONE — FOUNDER SELECTION NOT YET PERFORMED`
- **`PROFILE_RANKING`:** `NOT ESTABLISHED`
- **`PROFILE_WINNER_CONFIDENCE`:** `NOT APPLICABLE`
- **`EVIDENCE_INTEGRITY_CONFIDENCE`:** `HIGH` (All 72 combinations measured from real DOM; nested width discrepancy resolved with explicit `MEASURED_DOM` vs `DERIVED` classification; complete 18-combination tabular numeral dataset verified; bias removed; full parity established).
- **`FOUNDER_DECISION_READY_PENDING_CODEX`:** `YES` (Visual Decision Lab is neutral, reproducible, and ready for Founder inspection).
