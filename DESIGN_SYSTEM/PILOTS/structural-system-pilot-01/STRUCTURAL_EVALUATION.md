# KONFRM Phase 4E — Structural System Evaluation

**Phase:** Phase 4E — Structural System
**Pilot ID:** `structural-system-pilot-01`
**Governing Authority:** `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`, `DESIGN_SYSTEM/COMPONENTS/cards.md`
**Evaluation Date:** 2026-10-04
**Status:** `SYSTEM_EVALUATED_CANDIDATE`

---

## 1. Structural Decisions Evaluated

### A. Spacing Scale Family
The Web baseline 8pt-derived spacing scale was empirically tested across 360px, 390px, 430px, and 1440px viewports:
- **`4px (xs)` — Micro-gap:** Perfectly sized for status dots, icon-to-label offsets, and badge internal insets.
- **`8px (sm)` — Component Intra-gap:** Standard gap between label and field, button icon and text, and chip groupings.
- **`12px (md)` — Density Bridge:** Critical for mobile operational density. Bridges 8px and 16px; ideal for dense Owner list row padding, filter segments, and compact card gutters.
- **`16px (lg)` — Content Inset & Standard Padding:** The universal mobile horizontal margin (`px-4`) and standard card padding. Proven resilient across all screen widths.
- **`24px (xl)` — Section Gap:** Natural vertical rhythm between distinct semantic sections on mobile. Provides breathing room without wasting vertical screen occupancy.
- **`32px (2xl)` — Major Boundary:** Separates top photo hero from page body, and major modal footers from content.
- **`40px / 48px` — Sizing & Touch Clearance:** Reserved for minimum accessible touch target heights (`44–48px`) and bottom navigation clearance (`pb-28` to `pb-36`).

*Verdict:* The `4/8/12/16/24/32` scale is **SYSTEM-COHERENT** and validated for future mobile design tokens. No arbitrary odd-pixel gaps were found necessary.

---

### B. Page Content Insets
- **Customer Mobile:** 16px horizontal inset (`--struct-page-inset: 16px`). Allows maximum content width while preventing edge clipping on curved device corners.
- **Owner Mobile:** 16px horizontal inset. Matches Customer for system-wide layout consistency, but uses tighter internal row padding (12px vs 16px) to achieve operational density.
- **Admin Desktop Boundary:** 24px (`p-6`) desktop padding. Respects desktop wide-canvas ergonomics.

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
- **Open Content (0px radius, divided by 1px rules):**
  - Use when content belongs to a continuous narrative or single-task inspection (e.g., Customer Property Description, Amenities, Essential Facts).
  - Preserves hospitality breathing room and editorial lightness.
- **Open Grouped Content (Single outer container, internal 1px dividers):**
  - Use when multiple homogeneous operational records form a collection (e.g., Owner Booking Queue, Owner Properties Summary).
  - Eliminates repeated border/shadow noise and saves up to 40% vertical space compared to stacked individual cards.
- **Standalone Cards (Enclosed container):**
  - Use **only** when an entity is independently movable, actionable, or self-contained (e.g., `PropertyCard` in discovery search results, Urgent Attention action banner).
  - Must never be nested inside another card.

---

### E. Shape Roles & Radius System
Phase 4A established Primary Button radius at **6px** (`PRIMARY_ONLY`).
Phase 4D established Mobile Field radius at **8px** (`OUTLINE_LED` data entry).
Phase 4E evaluates container and card radii:
- **`SHAPE_ACTION` (6px):** Action-oriented controls (Primary buttons, secondary buttons). Communicates decisive clickability.
- **`SHAPE_INPUT` (8px):** Data entry containers (Text fields, search bars, pickers). Slightly softer geometry accommodates taller container mass (48px pilot geometry).
- **`SHAPE_CONTAINER` (12px vs 16px Candidate):**
  - *Candidate 12px (Balanced):* Harmonizes closely with 8px inputs and 6px buttons. Avoids overly bubbly consumer styling.
  - *Candidate 16px (Legacy Web):* Familiar from current web Tailwind classes, but can feel excessively rounded in dense operational contexts.
  - *Candidate 0px (Open):* For inline divided content.
- **`SHAPE_PILL / BADGE` (4px or 9999px):** Status badges use 4px for compact rectangular grounding; floating counters use fully rounded pills.

---

### F. Elevation & Surface Hierarchy
- **Philosophy:** Border-first and Spacing-first.
- **Canvas:** Flat light neutral (`#F8FAFC`).
- **Surface:** Pure white (`#FFFFFF`) with 1px neutral border (`#E2E8F0`).
- **Shadows:**
  - Standard cards and grouped units: **`none`** (flat border separation eliminates visual blur).
  - Sticky decision bar & App bar: **`0 -4px 16px rgba(0,0,0,0.05)`** (functional elevation indicating content scrolls beneath).
  - Modals and sheets: Controlled overlay shadow (Phase 4F owned).

---

## 2. Comparative Analysis of Candidate Systems

| Evaluation Dimension | Candidate A (Open / Editorial) | Candidate B (Modular / Contained) | Candidate C (Role-Aware Hybrid) |
|---|---|---|---|
| **Customer Role Fit** | **High** — Exceptional hospitality feel, photography-forward, minimal visual clutter. | **Low** — Over-boxed, feels like a SaaS dashboard rather than a vacation stay. | **High** — Open editorial facts above, bounded financial quote below. |
| **Owner Role Fit** | **Medium** — Harder to scan dense operational priorities without container grounding. | **Medium** — Clear module boundaries, but high card repetition produces noise. | **High** — Connected operational units (`Open Grouped Content`) maximize scanability and density. |
| **Admin Boundary Fit** | Neutral | Neutral | **High** — Desktop table and audit workspace strictly isolated from mobile cards. |
| **Card Soup Resistance** | **Superior** (0 cards created). | **Failed** (Card soup in every view). | **Superior** (Containers strictly justified by entity independence). |
| **Arabic RTL Integrity** | High | High | High |
| **200% Text Scaling** | High | High | High |
| **System Coherence** | High | High | **Superior** (Cohesive semantic role model across all touchpoints). |

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
   - *Fix:* Restricted Admin container radii to 8px, maintaining crisp desktop operational rigor.
