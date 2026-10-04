# KONFRM Phase 4E — Structural System Evaluation

**Phase:** Phase 4E — Structural System
**Pilot ID:** `structural-system-pilot-01`
**Governing Authority:** `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`, `DESIGN_SYSTEM/COMPONENTS/cards.md`
**Evaluation Date:** 2026-10-04 (Formalized: 2026-10-05)
**Founder Decision:** `OPTION_C_APPROVED` (Role-Aware Hybrid Structural System)
**Status:** `FOUNDER_SELECTED_SYSTEM_EVALUATED_PROVISIONAL`

---

## 1. Structural Decisions Evaluated

### A. Spacing Scale Family
The Web baseline 8pt-derived spacing scale was empirically tested across 360px, 390px, 430px, and 1440px viewports:
- **`4px (xs)` — Micro-gap:** Micro-offset for status dots, icon-to-label offsets, and badge internal insets.
- **`8px (sm)` — Component Intra-gap:** Standard gap between label and field, button icon and text, and chip groupings.
- **`12px (md)` — Density Bridge:** Critical for mobile operational density. Bridges 8px and 16px; ideal for dense Owner list row padding, filter segments, and compact card gutters.
- **`16px (lg)` — Content Inset & Standard Padding:** The universal mobile horizontal margin (`px-4`) and standard card padding. Proven resilient across all screen widths.
- **`24px (xl)` — Section Gap:** Natural vertical rhythm between distinct semantic sections on mobile. Provides breathing room without wasting vertical screen occupancy.
- **`32px (2xl)` — Major Boundary:** Separates top photo hero from page body, and major modal footers from content.
- **`40px / 48px` — Sizing & Touch Clearance:** Reserved for sizing clearance and platform touch guidelines (~44pt iOS / ~48dp Android); native touch acceptance deferred to Phase 4I.

*Verdict:* The `4/8/12/16/24/32` scale is evaluated as **`SYSTEM_EVALUATED_STRUCTURAL_CANDIDATE`** for future mobile design tokens. No new spacing value should be introduced without demonstrated semantic need and governed design-system approval.

---

### B. Page Content Insets
- **Customer Mobile:** 16px horizontal inset (`--struct-page-inset: 16px`). Allows maximum content width while maintaining comfortable reading margins and page layout rhythm (`PAGE_INSET != SAFE_AREA_INSET`).
- **Owner Mobile:** 16px horizontal inset. Matches Customer for system-wide layout consistency, but uses tighter internal row padding (12px vs 16px) to achieve operational density.
- **Admin Desktop Boundary:** 24px (`p-6`) desktop padding. Respects desktop wide-canvas ergonomics (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).

---

### C. Section Rhythm Hierarchy
To prevent arbitrary spacing drift, the rhythm hierarchy is codified into four unambiguous relationship tiers:
1. **Tier 1 (Micro / Intra-element):** 4px – 8px (e.g., Title to Subtitle, Price to Nightly suffix).
2. **Tier 2 (Intra-group / Item):** 12px – 16px (e.g., Field to Field, Row to Row).
3. **Tier 3 (Section Separation):** 24px (e.g., Description section to Amenities section).
4. **Tier 4 (Major Landmark):** 32px (e.g., Hero gallery to Content body, Sticky bar clearance).

---

### D. Open Grouped Content vs Cards
One of the primary goals of Phase 4E is eliminating **Card Soup**. The evaluation establishes clear semantic criteria:
- **Open Content (`OPEN_CONTENT`; no enclosing container, subtle internal dividers):**
  - Use when content belongs to a continuous narrative or single-task inspection (e.g., Customer Property Description, Amenities, Essential Facts).
  - Preserves hospitality breathing room and editorial lightness.
- **Open Grouped Content (`OPEN_GROUPED_CONTENT`; single outer container, subtle internal dividers [exact native stroke width `OPEN` / deferred to Phase 4I]):**
  - Use when multiple homogeneous operational records form a collection (e.g., Owner Booking Queue, Owner Properties Summary).
  - Eliminates repeated border/shadow noise and saves vertical space compared to stacked individual cards.
- **Standalone Cards (Enclosed container):**
  - Use **only** when an entity is independently movable, actionable, or self-contained (e.g., `PropertyCard` in discovery search results, Urgent Attention action banner).
  - Must never be nested inside another card.

---

### E. Shape Roles & Radius System
- **`SHAPE_ACTION` (6px):** Action-oriented controls (Primary buttons; `PROVISIONAL_PRIMARY_ONLY`). Secondary button radius remains open.
- **`SHAPE_INPUT` (8px):** Data entry containers (Text fields, search bars, pickers; `PROVISIONAL_FIELD_SHAPED_ONLY`).
- **`SHAPE_CONTAINER` (12px):** Structural containers and cards radius evaluated and selected as `SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`. Controlled bounded evidence check (10px vs 12px vs 16px) confirmed 12px harmonizes visually with 8px inputs and 6px buttons without looking boxy (10px) or overly bubbly (16px). (Note: 6px → 8px → 12px is an `EXPERT_HEURISTIC / VISUAL_SYSTEM_REASONING`, not self-validating mathematical proof).
- **Open Content (`OPEN_CONTENT`):** For open editorial or inline divided content; requires no enclosing structural container and no container radius token.
- **`SHAPE_INDICATOR` (Status Badges / Chips):** Compact rectangular or softly rounded indicators. Exact Badge/Tag geometry remains `OPEN_OR_COMPONENT_GOVERNED`; pilot did not assert universal 9999px Canon.

---

### F. Elevation & Surface Hierarchy
- **Philosophy:** Border-first and Spacing-first.
- **Canvas & Surface Relationship:** Light-first dominant intent; subtle neutral boundary on light-first canvas. Pilot rendering reference values (`#FFFFFF` surface, `#E2E8F0` divider reference, `#F8FAFC` canvas reference) are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE` only; exact neutrals remain `OPEN`.
- **Shadows:**
  - Standard cards and grouped units: **`none`** (flat border separation eliminates visual blur).
  - Sticky decision bar & App bar: **`0 -4px 16px rgba(0,0,0,0.05)`** (functional elevation indicating content scrolls beneath).
  - Modals and sheets: Controlled overlay shadow (Phase 4F owned).

---

## 2. Comparative Analysis of Candidate Systems

| Evaluation Dimension | Candidate A (Open / Editorial) | Candidate B (Modular / Contained) | Candidate C (Role-Aware Hybrid) |
|---|---|---|---|
| **Hard Gates Result** | **VALID** | **ELIMINATED_BY_HARD_GATE** (`REJECTED_COMPARATOR`) | **VALID (`COURT_RECOMMENDED`)** |
| **Founder Decision** | **VALID_NOT_SELECTED** | **REJECTED_COMPARATOR** | **FOUNDER_SELECTED_PROVISIONAL** |
| **Customer Role Fit** | **High** — Exceptional hospitality feel, photography-forward, minimal visual clutter. | **Low** — Over-boxed, feels like a SaaS dashboard rather than vacation discovery. | **High** — Open editorial facts above, bounded financial quote below. |
| **Owner Role Fit** | **Medium** — Harder to scan dense operational priorities without container grounding. | **Medium** — Clear module boundaries, but high card repetition produces noise. | **High** — Connected operational units (`Open Grouped Content`) maximize scanability and density. |
| **Admin Boundary Fit** | Neutral | Neutral | **High** — Desktop table and audit workspace strictly isolated from mobile cards. |
| **Card Soup Resistance** | **High** (0 cards created). | **Failed** (Card soup in every view). | **High** (Containers strictly justified by entity independence). |
| **Arabic RTL Integrity** | High | High | High |
| **200% Text Scaling** | High (controlled Web reflow) | Border crowding | High (controlled Web reflow) |
| **System Coherence** | High | High | **High** (Cohesive semantic role model across all touchpoints). |

---

## 3. Self-Correction & Defect Resolution

During empirical pilot implementation and headless screenshot capture, three defects were uncovered and resolved:
1. **Defect 1: Headless Window Centering in RTL:**
   - *Cause:* Chrome headless on Windows enforces a minimum window width of 504px. Flex centering on `main.pilot-stage` in RTL caused the rightmost 57px of 390px views to be clipped.
   - *Fix:* Replaced flex centering in embed mode with `position: absolute; top: 0; left: 0; direction: rtl;` on `.viewport-frame`. Output is now 100% visible and unclipped.
2. **Defect 2: Quote Box Container-in-Container:**
   - *Cause:* Previous implementation placed a bordered rounded-xl box inside a bordered rounded-2xl quote box.
   - *Fix:* Replaced inner highlight with a flat tinted background (`--accent-blue-soft: #EAF1FF`) and 0px border, restoring single-boundary cleanliness.
3. **Defect 3: Metric KPI Over-Rounding on Desktop Admin:**
   - *Cause:* Admin desktop tables were inheriting 16px mobile card radii.
   - *Fix:* Restricted Admin container radii to 8px (`CONTROLLED_WEB_BOUNDARY_REFERENCE`), maintaining crisp desktop operational rigor and proving mobile card language does not contaminate desktop.

---

## 4. Bounded Structural Radius Evaluation & Closure

To close the implementation-level container radius without burdening the Founder, a controlled evidence check evaluated Candidate C across radius values (`10px`, `12px`, `16px`) using the same viewport (390×844), typography (Cairo Profile B), page insets (16px), and content:

| Radius Candidate | Customer Decision Unit | Owner Grouped Unit | Visual System Coherence | Verdict |
|---|---|---|---|---|
| **`10px`** | Slightly crisper geometry; close visual alternative. | High operational density; compact corner geometry. | Crisp contour; 10px vs 12px is a subtle visual difference. | **VALID CLOSE ALTERNATIVE** |
| **`12px`** | Soft, calm, reassuring financial summary. | Clean, compact interior spacing; comfortable curve within 16px page margins. | Balanced geometry; distinct from 8px field controls and 6px action buttons without bubbly consumer excess. | **SELECTED PROVISIONAL SYSTEM TIE-BREAKER / BALANCED CANDIDATE** (`SYSTEM-EVALUATED PROVISIONAL`) |
| **`16px`** | Noticeably rounder; drifts toward consumer SaaS bubble styling. | Materially rounder corners; higher corner encroachment on dense repeated list rows. | Encounters generic rounded-SaaS risk in repeated operational containers. | **REJECTED (MATERIALLY ROUNDER / GENERIC-SAAS RISK)** |

*Conclusion:* Bounded visual evidence confirms that 10px and 12px represent subtle variations, while 16px is materially rounder with higher generic-SaaS styling risk in repeated operational groups. 12px is selected as the provisional system tie-breaker and balanced candidate. This is a reversible implementation-level detail with native acceptance deferred to Phase 4I (`NO_MATERIAL_FOUNDER_DECISION_REQUIRED: YES`). Recorded as `SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`.
