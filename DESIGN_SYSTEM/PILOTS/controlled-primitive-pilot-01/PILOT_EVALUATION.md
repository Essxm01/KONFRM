# KONFRM — Controlled Primitive Pilot 01 Evaluation Report
## Final Textual Evidence Closure Patch
### Interaction Accent • Primary Button Geometry • Text Actions • Core State Matrix

> [!CAUTION]
> ### GOVERNANCE STATUS: DESIGN PILOT — NOT PRODUCTION UI — NOT CANON
> This document and its accompanying rendering harnesses (`index.html` and `width-stress.html`) represent an isolated exploratory design pilot conducted under `DESIGN_SYSTEM/PILOTS/controlled-primitive-pilot-01/` on branch `design/controlled-primitive-pilot-01`.
> **Zero values in this document become Design Canon or production code.** All numeric dimensions, colors, radii, paddings, and font sizes remain **Implementation Candidates** subject to independent review by Codex and Z Code, and final explicit Founder decision.
> Neither this report nor the accompanying prototype declares any option a "winner" or "promising candidate."

---

## 1. Executive Summary & Pre-Flight Verification

- **Workspace Root:** `KONFRM-CANONICAL` (Repository Root)
- **Active Branch:** `design/controlled-primitive-pilot-01`
- **Base Commit SHA:** `1938e453bb82be739b1f31468db37c18dc4b8b1d` (Canonical `origin/main`)
- **Pilot Implementation Mode:** Deterministic HTML/CSS harness with live DOM layout queries (`getClientRects`, `getBoundingClientRect`, `getComputedStyle`) and Chromium-rendered visual evidence (`evidence/round2_1/`).
- **Final Textual Evidence Closure Scope:**
  1. Correct the 360px synthesis to state the exact measured evidence: Short and Medium labels fit on 1 line across 6/12/22px, while the Long stress label wraps to 2 lines identically across 6/12/22px.
  2. Purge all active "commitment" semantics; describe booking request state changes strictly as **FLOW / NAVIGATIONAL** and **STATE-CHANGING PRIMARY ACTION**.
  3. Replace psychological "financial certainty" role claims with observable terms: **clear financial-state visibility** and **operational scanability**.
  4. Ensure geometry claims remain strictly at the hypothesis level (echoing angular mark vectors / intermediate rounded treatment / softer rounded contouring) without declaring any option inherently superior or brand-contradictory.
  5. Clean image and clickability language: describe visible chromatic salience differences without inferring click probability, usability superiority, trust, or outdoor readability.
  6. Ensure the final Founder-facing synthesis reflects only evidence actually established by the pilot.

---

## 2. Standardized Skill Routing Report

```markdown
### KONFRM DESIGN SKILL USAGE REPORT (FINAL TEXTUAL CLOSURE)
- TASK_CLASSIFICATION: Role: Shared (Customer & Owner Mobile) | Surface: Future Native Mobile Target (Flutter/Dart DF2 v1.1) | Scope: Foundational Action Primitives & Interaction Accent
- DESIGN_SKILLS_USED:
  - `konfrm-design-router` (Triage and governance gate)
  - `konfrm-design-reasoning` (Dialectic claim hygiene, neutral hypothesis framing)
  - `konfrm-product-ux` (Truthful state grammar, request lifecycle invariants)
  - `konfrm-mobile-design` (DF2 v1.1 interpretation, mobile touch conventions)
  - `konfrm-rtl-arabic` (Bidirectional `<bdi>` isolation, Western Arabic numerals, non-breaking currency grouping)
  - `konfrm-accessibility` (WCAG 2.2 AA contrast formulas, high-contrast focus offset, aria-busy simulation states)
  - `konfrm-visual-qa` (Multi-frame rendering inspection, headless Chromium visual verification)
- DESIGN_SKILLS_NOT_USED:
  - `vercel-web-guidelines-wrapper`: Strictly excluded; prohibited as mobile authority.
  - `vercel-composition-wrapper`: Strictly excluded; React-only pattern prohibited on Flutter target.
  - `frontend-design-wrapper`: Evaluated; excluded to prevent generic web aesthetics from diluting mobile primitive ergonomics.
  - `impeccable/bolder` & `impeccable/delight`: Suppressed by default on transactional primary actions.
- ADVISORY WRAPPERS CONSULTED:
  - `impeccable-wrapper` (`critique` & `distill`): Used to strip bias badges, neutralize borders, and eliminate visual clutter.
  - `emil-wrapper`: Consulted for physical tap responsiveness, pressed scale damping (`scale(0.985)`), and non-blocking loading spinner feel.
  - `ui-ux-pro-max-wrapper`: Consulted as advisory reference for mobile touch affordance patterns.
- DESIGN_HYPOTHESES_CONSIDERED:
  - Accent: Option A (Stable Black) vs. Option B (Stable Blue) vs. Option C (Contextual Strategy).
  - Geometry: Family A (Low 6px) vs. Family B (Moderate 12px) vs. Family C (High 22px).
- HUMAN_FACTORS_EVIDENCE:
  - Bar & Neta (2006), Leder & Carbon (2005), Reber et al. (2004) contour perception & processing fluency research evaluated with qualitative ratings and strict source vs inference boundaries.
  - Fitts's Law hit-area inference completely retracted.
- TARGET_ROLE_REASONING:
  - Customer: Anxiety reduction, clear booking request meaning, prominent touch signifiers.
  - Owner: Rapid triage scanning, clear financial-state visibility, operational scanability.
- COUNTERARGUMENTS:
  - Option A risks lower chromatic salience; Option B risks visual competition with sea/sky photography; Option C introduces dual-color cognitive rules; Family A risks feeling boxy/administrative; Family C produces a softer curved appearance differing from the angular mark.
- CANON_LANGUAGE_TENSION:
  - PRESENT — REQUIRES GOVERNED INTERPRETATION (DF2 §9 monochrome-first vs. DF2 §15 primary accent wording).
- EVIDENCE_VS_CANON:
  - Canon dictates Black/White brand identity and restrained interaction accent role. The exact CTA color and corner radius remain open candidates tested herein.
- VALIDATION_NEEDED:
  - Real Flutter testbed compiled and deployed on physical iOS and Android devices under outdoor Egyptian sunlight conditions.
- VISUAL_QA:
  - EXECUTED. Rendered and verified via headless Chromium across 360px, 390px, and 430px test frames (`evidence/round2_1/`).
```

---

## 3. Changelog of Corrected Claims

| Area | Review Finding | Correction Status |
| :--- | :--- | :--- |
| **1. Width Test Naming** | Tests at 360/390/430px were described as device viewports. | **WITHDRAWN & CORRECTED:** Renamed to `DETERMINISTIC WEB FRAME-WIDTH SIMULATION`. Reports test frame width separately from browser `window.innerWidth`. |
| **2. Line Wrap Detection** | Code inferred line wrapping from container height. | **WITHDRAWN & CORRECTED:** Replaced with `Range.getClientRects()` on the `.btn-label` element. Height heuristics eliminated. |
| **3. 360px Text Fitting** | Early summary implied all text fits single-line at 360px. | **CORRECTED:** Short and Medium labels fit on 1 line across 6/12/22px; Long stress label wraps to 2 lines identically across 6/12/22px. Wrapping behavior is 100% identical across all three radii. |
| **4. Commitment Semantics** | Active text used "commitment actions" and legal phrasing. | **WITHDRAWN & CORRECTED:** Replaced with governed terms: `FLOW / NAVIGATIONAL` and `STATE-CHANGING PRIMARY ACTION`. Booking submission is strictly a request entering `PENDING_OWNER_APPROVAL`. |
| **5. Financial Certainty Claim** | Claimed Owner primitive creates "financial certainty". | **WITHDRAWN & CORRECTED:** Replaced with observable terms: `clear financial-state visibility` and `operational scanability`. |
| **6. Geometry Brand Claims** | Stated 22px contradicts brand identity or 6px is maximally congruent. | **WITHDRAWN & DOWNGRADED:** Framed as hypotheses (echoes angular mark / intermediate rounded treatment / softer contouring) without declaring any candidate superior. |
| **7. Image & Clickability Claims** | Used phrases like "maximum clickability" or "zero image clash". | **WITHDRAWN & SCOPED:** Scoped strictly to: *"In the tested welcome-hero.jpg asset and tested layout, Black and Blue produce visibly different chromatic relationships with the image (Blue is more chromatically salient in this specific rendering)."* Zero conversion/trust inferences. |

---

## 4. DF2 §9 vs. §15 Governance Scan

Direct inspection of `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` confirms an explicit textual tension between Sections 9 and 15:

- **DF2 §9 (Color Foundation, lines 169–170):**
  - "Black / White is the primary KONFRM mobile brand identity: confident, minimal, structured, clear. The Brand Mark / Wordmark identity is monochrome-first."
  - "Blue is no longer the dominant brand-identity color. Blue remains only as a **restrained PRODUCT INTERACTION ACCENT**, appearing lightly and intentionally in actionable/interactive moments. Candidate: **`#276EF1`**... must be validated in real component contexts (primary CTA, active navigation, selected state...) before token canonicalization. Core screens must not feel 'blue-branded'."
- **DF2 §15 (Action Hierarchy, line 288):**
  - "- **PRIMARY** — the one decision-critical action of the current state, when a state has one (restrained interaction-accent treatment — §9)."

### Governance Assessment
```
CANON_LANGUAGE_TENSION: PRESENT — REQUIRES GOVERNED INTERPRETATION
```
- **The Tension:** Section 15's canonical definition of PRIMARY references the restrained interaction-accent treatment (§9). Section 9 mandates that the mobile brand identity is monochrome-first, that core screens must not feel blue-branded, and treats exact CTA color as an implementation candidate to be validated.
- **The Trade-Off:**
  - If the primary CTA on every core screen is Blue (`#276EF1`), the screen risks feeling "blue-branded", which creates tension with §9's monochrome-first foundation.
  - If the primary CTA is Solid Black (`#0F172A`), it satisfies §9's monochrome-first brand foundation, but departs from §15's phrasing "(restrained interaction-accent treatment — §9)".
- **Resolution:** This tension cannot be resolved autonomously by an agent or pilot writer; it requires explicit Founder interpretation and decision.

---

## 5. Deterministic Web Frame-Width Simulation Findings

Using the dedicated deterministic test harness ([`width-stress.html`](./width-stress.html)), layout metrics were queried directly from the browser DOM via `Range.getClientRects()`, `getBoundingClientRect()`, and `getComputedStyle()` at three standard frame widths (360px, 390px, 430px):

### 5.1 Measured Live DOM Metrics Table

| Case | Radius | Frame.w | Win.w | btn.w | btn.h | label.w | Lines (Range) | pad.h | font | l.height | Overflow |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Short** ("إرسال طلب الحجز") | 6px | 360px | 702px | 324.0px | 48.0px | 107.2px | **1 LINE** | 20px | 15px | 18px | **NO** |
| **Short** ("إرسال طلب الحجز") | 12px | 360px | 702px | 324.0px | 48.0px | 107.2px | **1 LINE** | 20px | 15px | 18px | **NO** |
| **Short** ("إرسال طلب الحجز") | 22px | 360px | 702px | 324.0px | 48.0px | 107.2px | **1 LINE** | 20px | 15px | 18px | **NO** |
| **Medium** ("إرسال طلب الحجز (3 ليالٍ)") | 6px | 360px | 702px | 324.0px | 48.0px | 159.0px | **1 LINE** | 20px | 15px | 18px | **NO** |
| **Medium** ("إرسال طلب الحجز (3 ليالٍ)") | 12px | 360px | 702px | 324.0px | 48.0px | 159.0px | **1 LINE** | 20px | 15px | 18px | **NO** |
| **Medium** ("إرسال طلب الحجز (3 ليالٍ)") | 22px | 360px | 702px | 324.0px | 48.0px | 159.0px | **1 LINE** | 20px | 15px | 18px | **NO** |
| **Long** ("إرسال طلب حجز الفيلا بعد مراجعة التفاصيل") | 6px | 360px | 702px | 324.0px | 62.0px | 256.5px | **2 LINES** | 20px | 15px | 18px | **NO** |
| **Long** ("إرسال طلب حجز الفيلا بعد مراجعة التفاصيل") | 12px | 360px | 702px | 324.0px | 62.0px | 256.5px | **2 LINES** | 20px | 15px | 18px | **NO** |
| **Long** ("إرسال طلب حجز الفيلا بعد مراجعة التفاصيل") | 22px | 360px | 702px | 324.0px | 62.0px | 256.5px | **2 LINES** | 20px | 15px | 18px | **NO** |
| **All Cases** | 6 / 12 / 22 | 390px | 702px | 354.0px | 48.0px | — | **Identical** | 20px | 15px | 18px | **NO** |
| **All Cases** | 6 / 12 / 22 | 430px | 702px | 394.0px | 48.0px | — | **Identical** | 20px | 15px | 18px | **NO** |

### 5.2 Key Empirical Takeaway
In rectangular containers where horizontal padding (20px) is applied, corner curvature (6px vs. 12px vs. 22px) does **not** alter text wrapping or line count. Text wrapping occurs when label width exceeds available container width (`btn.w - 2 * padding - iconWidth - gap`). Under 360px frame width, Short and Medium labels fit on 1 line across all three radii, while the Long stress label wraps to 2 lines identically across all three radii.

---

## 6. Web Text-Scaling Stress Simulation Findings

Line counts were measured directly on the label range using `Range.getClientRects()`, completely eliminating container height heuristics:

| Scale Level | Computed Font Size | Container Height | Label Width | Label Lines (Range) | Horizontal Overflow |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **100% (Baseline)** | **15px** | **48.0px** | **107.2px** | **1 LINE** | **NO OVERFLOW** |
| **125%** | **18.75px** | **48.5px** | **134.0px** | **1 LINE** | **NO OVERFLOW** |
| **150%** | **22.5px** | **53.0px** | **160.8px** | **1 LINE** | **NO OVERFLOW** |
| **200% (A11y Max)** | **30px** | **62.0px** | **214.5px** | **1 LINE** | **NO OVERFLOW** |

- **Empirical Clarification:** The label `إرسال طلب الحجز` does **not** wrap onto multiple lines at 150% or 200% within the tested container width.
- **Container Expansion Mechanism:** Container height expands from 48px to 62px purely because font-size and line-height scale upward, preserving comfortable vertical padding around the single-line text without clipping descenders or diacritics.

---

## 7. Controlled Accent Strategy Comparison (Isolated Variables)

### 7.1 Direct A/B/C Comparison (Identical Action & Layout)
All three options evaluate the identical action **`إرسال طلب الحجز`** in the primary position with 100% identical dimensions (`min-height: 48px`, `padding: 12px 20px`, `font-size: 15px`, `font-weight: 700`, `radius: 12px`, trailing chevron SVG, identical supporting chips, and identical link):

- **Option A (Stable Black Primary):** Solid Black CTA (`#0F172A`). Restrained blue reserved strictly for selection chips, focus rings, and inline links.
- **Option B (Stable Blue Primary):** Solid Blue CTA (`#276EF1`). Black reserved for brand wordmark and dark text.
- **Option C (Contextual Strategy — Same Action):** Solid Black CTA (`#0F172A`), because under the contextual rule, submitting a booking request represents a State-Changing primary action.

### 7.2 Contextual Strategy Multi-Stage Demonstration (Separated Box)
```
CONTEXTUAL STRATEGY EXAMPLE — NOT PART OF THE CONTROLLED A/B/C COLOR TEST
```
To explain how Option C functions across multiple workflow stages, a separate illustrative container demonstrates:
- **Flow Action:** `متابعة لاختيار الضيوف` styled in **Interactive Blue** (`#276EF1`).
- **State-Changing Action:** `إرسال طلب الحجز` styled in **Solid Black** (`#0F172A`).
Both stages maintain identical dimensions (`min-height: 48px`, `padding: 12px 20px`, `font: 15px / 700`).

### 7.3 Action Classification Table (Strict Product Truth)

| Action Classification | Concrete Pilot Examples | Assigned Color | Actual System Consequence | Reversibility |
| :--- | :--- | :--- | :--- | :--- |
| **Flow / Navigational** | • `متابعة`<br>• `عرض التفاصيل`<br>• `تطبيق التصفية`<br>• `اختيار الضيوف` | **Interactive Blue** (`#276EF1`) | In-app navigational progression and filtering preferences; **no state change to booking records**. | Fully and immediately reversible |
| **State-Changing Primary** | • `إرسال طلب الحجز` (Customer)<br>• `الموافقة على الطلب` (Owner) | **Solid Black** (`#0F172A`) | **إرسال طلب الحجز:** Creates/submits booking request for owner review (`PENDING_OWNER_APPROVAL`). Does not charge cards, does not bind contracts, does not block calendar availability.<br>**الموافقة على الطلب:** Transitions request to `APPROVED_PENDING_PAYMENT`, which participates in calendar blocking per Canon. Payment occurs only after approval. | Canonical lifecycle state transition |

### 7.4 Destructive Actions Boundary
```
DESTRUCTIVE SEMANTICS ARE OUTSIDE THE A/B/C PRIMARY-COLOR EXPERIMENT.
```
Destructive actions (such as Owner rejection) follow separate caution/destructive styling (soft neutral/red surface) and are never styled as primary completion. The renter cancellation/refund matrix is unresolved and excluded from this pilot.

---

## 8. Real Photographic Context Findings (`welcome-hero.jpg`)

Using the licensed repository asset (`customer-app/public/welcome-hero.jpg` — turquoise Mediterranean private pool, sunlit limestone, open blue sky) in identical side-by-side cards:

- **Observation:** In the tested `welcome-hero.jpg` asset and tested layout, Black and Blue produce visibly different chromatic relationships with the image.
  - Black CTA creates a distinct luminance separation against the pool water and stone hues.
  - Blue CTA (`#276EF1`) is more chromatically salient in this specific rendering, sharing a spectral color family with the pool water and summer sky in the image.
- **Strict Boundary:** Confined strictly to visual color observations in this tested asset; zero claims regarding conversion, trust, or outdoor readability are inferred.

---

## 9. Geometry Hypotheses (Neutral Framing)

- **HYPOTHESIS 1 (Low 6px):** 6px visually echoes the angular KONFRM brand symbol mark more closely.
- **HYPOTHESIS 2 (Moderate 12px):** 12px represents an intermediate rounded treatment balancing structure and curved signifiers.
- **HYPOTHESIS 3 (High 22px):** 22px produces a visibly softer rounded treatment common in modern consumer applications.
- **Hit-Area Boundary:** This pilot did not evaluate pointer/touch hit-test performance as a function of corner radius. If required later, that is a separate implementation/performance test.
- **Continuous Corner Boundary:** The web pilot implements standard CSS rounded corners (circular arcs). Native Flutter/iOS continuous-corner rendering remains unverified.

---

## 10. Reproducible WCAG 2.2 AA Contrast Calculations

Relative luminance formula: $L = 0.2126 R + 0.7152 G + 0.0722 B$ (after sRGB gamma linearization). Contrast ratio: $CR = (L_1 + 0.05) / (L_2 + 0.05)$.

| Color Pair | Foreground Hex | Background Hex | Relative Luminance ($L_1 : L_2$) | Exact Contrast Ratio | WCAG 2.2 AA Status | Margin over 4.5:1 Floor |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Black CTA on White** | `#FFFFFF` | `#0F172A` | $1.0000 : 0.0088$ | **17.85:1** | **PASS (AAA)** | $+13.35$ |
| **Blue CTA on White** | `#FFFFFF` | `#276EF1` | $1.0000 : 0.1791$ | **4.58:1** | **PASS (AA Normal)** | $+0.08$ *(Razor-thin)* |
| **Cobalt CTA on White** | `#FFFFFF` | `#1D4ED8` | $1.0000 : 0.1068$ | **6.70:1** | **PASS (AA Normal)** | $+2.20$ *(Robust)* |
| **Legacy Web Blue on White** | `#FFFFFF` | `#0059FF` | $1.0000 : 0.1441$ | **5.42:1** | **PASS (AA Normal)** | $+0.92$ |
| **Disabled CTA Control** | `#94A3B8` | `#E2E8F0` | $0.3670 : 0.7529$ | **2.08:1** | **EXEMPT** (Inactive) | N/A (Standard inactive exemption) |

- **APCA Status:** APCA scores (Lc 102, Lc 68, Lc 79) are supplemental experimental research metrics only, not an official regulatory standard. Formal compliance rests strictly on WCAG 2.2 AA.

---

## 11. Role-Context Neutral Validation

- **Customer Role (`إرسال طلب الحجز`):** Works coherently across Strategy A (Black), Strategy B (Blue), and Strategy C (State-Changing Black).
- **Owner Role (`الموافقة على الطلب`):** Works coherently across all strategies. Operational triage benefits from high contrast and clear financial-state visibility. Owner rejection (`رفض الطلب`) is rendered distinctly in soft caution styling (#FFF1F2), separated from primary completion.
- **Finding:** The primitive system functions coherently across both roles. Whether Customer and Owner share identical CTA styling remains open for Founder decision.

---

## 12. Accessibility & RTL Hardening

1. **Focus Indicator:** 2px solid dark ring with 2px offset (`outline: 2px solid #0F172A; outline-offset: 2px`).
2. **Loading State:** Live simulation toggle implementing `aria-busy="true"` and neutral screen reader announcements (`role="status"`), plus static sample clearly tagged as `STATIC SAMPLE`.
3. **Reduced Motion:** `@media (prefers-reduced-motion: reduce)` explicitly strips `transform: none !important` and `animation: none !important`.
4. **RTL Bidirectional Isolation:** Wrapped technical IDs in `<bdi>` (`#KNF-88219`), non-breaking currency spacing (`1,600&nbsp;ج.م`), and isolated dates (`<bdi>15–18 أكتوبر 2026</bdi>`).

---

## 13. Unresolved Pilot Values Inventory

| Parameter | Prototype Implementation Value | Candidate Status | Governing Future Authority |
| :--- | :--- | :--- | :--- |
| **Primary Corner Radius (Low)** | `6px` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Founder Decision / Flutter Mobile Spec |
| **Primary Corner Radius (Moderate)** | `12px` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Founder Decision / Flutter Mobile Spec |
| **Primary Corner Radius (High)** | `22px` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Founder Decision / Flutter Mobile Spec |
| **Primary Action Min-Height** | `48px` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Platform HIG/M3 Verification |
| **Primary Action Padding** | `12px 20px` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Typography & Clearance Verification |
| **Primary Action Font Size** | `15px` (`0.9375rem`) | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Arabic Cairo Legibility Review |
| **Primary Action Font Weight** | `700` (Bold) | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Arabic Cairo Legibility Review |
| **Primary Color (Black)** | `#0F172A` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Brand Canon vs. Interaction Role Review |
| **Primary Color (Blue)** | `#276EF1` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Component Contrast & Glare Review |
| **Primary Color (Cobalt)** | `#1D4ED8` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Component Contrast & Glare Review |
| **Disabled Surface** | `#E2E8F0` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Design Token System |
| **Disabled Content** | `#94A3B8` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Design Token System |
| **Focus Indicator Ring** | `2px solid #0F172A` (2px offset) | `PILOT IMPLEMENTATION VALUE — NOT CANON` | A11y Standards Review |
| **Pressed Scale Factor** | `scale(0.985)` | `PILOT IMPLEMENTATION VALUE — NOT CANON` | Flutter Haptic & Motion Spec |

---

## 14. Neutral Evidence Synthesis

```
================================================================================
EVIDENCE NARROWED TO:
================================================================================
1. PRIMARY BUTTON GEOMETRY:
   - 6px, 12px, and 22px radii remain open candidates.
   - At the 360px deterministic web frame-width simulation:
     - Short label ("إرسال طلب الحجز"): 1 line across 6 / 12 / 22px
     - Medium label ("إرسال طلب الحجز (3 ليالٍ)"): 1 line across 6 / 12 / 22px
     - Long product-safe stress label ("إرسال طلب حجز الفيلا بعد مراجعة التفاصيل"): 2 lines across 6 / 12 / 22px
   - Standard Arabic actions fit identically across the three radius candidates under tested dimensions.
   - The long stress label wraps at the narrow 360px frame width, and does so identically for all radii.
   - Line wrapping is governed by container width and horizontal padding, not corner curvature.
   - Radius preference remains a visual/brand hypothesis, not a technical winner:
     - 6px visually echoes the angular KONFRM mark more closely (HYPOTHESIS).
     - 12px represents an intermediate rounded treatment (HYPOTHESIS).
     - 22px produces a visibly softer treatment (HYPOTHESIS).
   - Zero winners declared. All 3 families preserved for Founder selection.

2. INTERACTION ACCENT STRATEGY:
   - Stable Black / Stable Blue / Contextual remain open candidates.
   - Controlled A/B/C direct comparison is strictly color-only.
   - In the tested welcome-hero.jpg asset and layout, Black and Blue produce visibly different chromatic relationships with the image (Blue is more chromatically salient in this specific rendering; Black provides a distinct luminance separation).
   - Contextual strategy adds an extra semantic/color rule (Flow vs. State-Changing) that requires later user validation.
   - No conversion, trust, or clickability winner was established.
   - Contrast calculations: Candidate Blue #276EF1 passes WCAG AA normal text (4.58:1) by +0.08; Cobalt #1D4ED8 provides a +2.20 safety margin.
   - Zero winners declared. All 3 strategies preserved for Founder selection.

3. PLATFORM & TOUCH TARGETS:
   - Web simulation implements standard CSS circular arc rounding. Native Flutter/iOS/Android validation remains future work on physical hardware.

4. CANON & GOVERNANCE:
   - Zero Canon promotion.
   - Exact CTA color treatment remains open.
   - Exact corner radius remains open.
   - DF2 §9 vs. §15 language tension remains explicitly unresolved, awaiting Founder interpretation.
================================================================================
```

*This evaluation report completes the Final Textual Evidence Closure Patch for Controlled Primitive Pilot 01. No code has been pushed or committed, and no values have been canonized.*

---

## 15. Founder Selection — Provisional Candidate

> [!IMPORTANT]
> ### GOVERNANCE RECORD: FOUNDER SELECTION STAGE COMPLETE
> **Radius Selection:** `6px`  
> **Primary Strategy Selection:** `Strategy A — Stable Black Primary`  
> **Selection Status:** `FOUNDER-SELECTED PROVISIONAL DESIGN FOUNDATION CANDIDATE`  
> **Evidence Validation Status:** `CLOSED`  
> **Canon Promotion Status:** `NONE` (Values remain provisional implementation candidates; Design Canon is not modified)  

Following the completion of technical and visual evidence validation for Controlled Primitive Pilot 01, the Founder has conducted the visual selection stage.

---

### 1. Selected Candidates & Status

| Governance Axis | Candidate Selected | Formal Status |
| :--- | :--- | :--- |
| **Primary Button Geometry** | **`6px` Radius** | **FOUNDER-SELECTED PROVISIONAL DESIGN FOUNDATION CANDIDATE** |
| **Primary Color Strategy** | **Strategy A — Stable Black Primary** | **FOUNDER-SELECTED PROVISIONAL DESIGN FOUNDATION CANDIDATE** |
| **Evidence Validation** | **CLOSED** | Evidence validation successfully closed across technical, contrast, and layout criteria. |
| **Design Canon** | **UNMODIFIED** | No token or radius promoted to final Canon. Values remain open candidate specifications. |

---

### 2. Meaning & Architectural Scope

#### A. Stable Black Primary Action
- **Primary Action Surface:** The normal Primary Action uses a stable Black-family surface treatment across transactional and flow milestones, unless a later governed exception is explicitly approved.
- **DF2 §9 vs. §15 Provisional Resolution:** This selection resolves the tension between DF2 §9 (Monochrome-First Brand Identity) and DF2 §15 (Primary Action Treatment) at the **PROVISIONAL CANDIDATE level** as:
  $$\text{Monochrome-First Primary Action} + \text{Restrained Blue Interaction Accent}$$
  Primary CTAs anchor the screen in the monochrome brand palette, while chromatic salience is reserved for specific interaction roles.

#### B. Restrained Blue Interaction Accent Role
- Blue is **not** removed from the system.
- Blue remains the designated restrained interaction accent for roles such as:
  - Text hyperlinks and inline interactive text actions
  - Active selection states, segmented controls, and toggle switches
  - Supporting interactive cues, active navigation indicators, and interactive emphasis where governed
  - Other governed interaction moments requiring chromatic signifiers without dominating screen identity
- **Focus Indicator Status:** Exact Focus Indicator color, style, and treatment remain explicitly **OPEN** and must be validated under the future accessibility and platform token specification. Blue is not canonically assigned as the final focus indicator treatment.
- Blue must not be used as a general background wash or dominant decorative color.

#### C. Scope Boundary for 6px Geometry
- The 6px corner radius is selected **strictly as the candidate for Primary Buttons**.
- **Design Hypothesis:** 6px gives Primary Actions a structured, geometric character that echoes the angular vectors of the KONFRM mark. This is an intentional design hypothesis, not an empirical claim of universal usability superiority.
- **Explicit Non-Generalization:** 6px must **NOT** be automatically generalized to:
  - Cards and container panels
  - Dialogs and modal surfaces
  - Bottom sheets and drawer containers
  - Filter chips, tags, and small badges
  - Input fields and text areas
  - Navigation bars, toolbars, and tab bars
  - Media thumbnails and photo tiles
  - Other component families
  Each component family must be evaluated according to its own ergonomic, containment, and visual role.

#### D. Semantic Color & Action Boundaries
- **Destructive Actions:** Destructive actions, where canonically defined, remain governed separately from Stable Black Primary treatment. (The renter cancellation and refund matrix remains OPEN; no cancellation behavior is invented or implied here.)
- **Semantic Independence:** Semantic roles—including `success`, `warning`, `error`, `informational`, and `destructive`—remain strictly independent from the Primary color strategy. Stable Black must never be used to flatten semantic differentiation.

#### E. Role & Surface Scope Boundaries
- **Mobile Scope:** This provisional primitive direction is intended to be tested across **Customer Mobile** and **Owner Mobile**.
- **Contextual Differentiation:** This selection does not assume that Customer and Owner applications must use identical component styling across every context; operational nuances will be evaluated in subsequent component pilots.
- **Admin App Exclusion:** Admin Web remains an operational desktop environment governed separately and is outside this mobile primitive decision.

---

### 3. Open Token & Implementation Values

The Founder selection establishes the structural strategy (Stable Black) and geometry class (6px), but exact token specifications remain explicitly **OPEN**:

| Token / Parameter | Current Pilot Value | Status | Governing Next Activity |
| :--- | :--- | :--- | :--- |
| **Exact UI Black Hex** | `#0F172A` | `OPEN` (Pilot implementation value only) | Token canonicalization review |
| **Primary Interaction Accent Hex** | `#276EF1` | `OPEN` — **IMPLEMENTATION CANDIDATE** (Not final token; not Canon) | Accessibility contrast, brand fit, interaction hierarchy, light-surface behavior, platform rendering, and real-device validation |
| **Alternative Cobalt Hex** | `#1D4ED8` | `OPEN` — **PILOT-ONLY EXPLORATORY ALTERNATIVE** (Not promoted to Design Foundation candidate; not Canon) | Supplemental exploratory reference only; not an active foundation candidate |
| **Continuous Corners** | CSS circular arc (`6px`) | `OPEN` | Native Flutter / iOS `SmoothRectangleBorder` validation |
| **Typography Scale & Line Height** | 15px Cairo Bold (`700`) | `OPEN` | Cairo typography scale audit |
| **Elevation & Shadow Tokens** | Flat (0 elevation) | `OPEN` | Mobile layer elevation spec |
| **Focus Indicator Color & Tokens** | 2px solid ring, 2px offset (color unassigned) | `OPEN` (Treatment & color unassigned) | Future accessibility & platform token specification |

---

### 4. Historical Comparison Integrity

- **Equality of Comparison:** All candidates tested in Pilot 01 (Radii: 6px, 12px, 22px; Strategies: Strategy A Stable Black, Strategy B Stable Blue, Strategy C Contextual) were fully valid for comparison and measured under identical technical conditions.
- **No Retrospective Rewriting:** The pilot documentation is not rewritten to suggest that 6px or Stable Black were objectively proven winners over alternative candidates.
- **Decision Basis:** The selection represents an explicit Founder product-governance choice. Future native Flutter / iOS / Android physical hardware validation remains mandatory before canonical promotion.

