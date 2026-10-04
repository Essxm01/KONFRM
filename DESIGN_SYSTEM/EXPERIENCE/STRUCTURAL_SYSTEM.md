# Structural System and Layout

**Status:** `FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE_4E_STRUCTURAL_MODEL`
**Governing Authority:** `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` §13, §14; `DESIGN_SYSTEM/COMPONENTS/cards.md`

Phase 4E establishes the structural composition, grouping grammar, and layout rhythm across KONFRM product surfaces, enacting Founder-selected **Option C: Role-Aware Hybrid Structural System**.

---

## 1. Role Structural Grammar

Layout grammar adapts to user mental models; consistency of underlying design primitives does not force identical surface composition across roles.

- **Customer Experience (`OPEN_EDITORIAL_DEFAULT`):**
  - *Tone & Character:* Leisure discovery, hospitality warmth, relaxed inspection.
  - *Structural Rule:* Photography and content lead. Proximity and whitespace carry grouping before adding containers. Property facts, descriptions, and amenities flow unboxed with restrained dividers / subtle hairline-style separation (exact native stroke width remains `OPEN` / deferred to Phase 4I; 1px is controlled Web pilot rendering reference only).
  - *Bounded Containers:* Strictly restricted to discrete decision units (e.g., booking quote breakdown) or independent exploration entities (`PropertyCard`).
  - *Prohibition:* "Card soup" and SaaS dashboard framing around vacation rental discovery.

- **Owner Experience (`OPERATIONAL_GROUPING_DEFAULT_WHEN_SEMANTIC`):**
  - *Tone & Character:* Operational triage, control, state certainty, high scanability.
  - *Structural Rule:* Related operational records share a single outer container with subtle internal dividers (`OPEN_GROUPED_CONTENT`; exact native stroke width remains `OPEN` / deferred to Phase 4I; 1px in pilot is controlled Web rendering reference).
  - *Bounded Containers:* Preferred where shared boundaries group related items (pending booking requests, unit listings, earnings history), avoiding repetitive stacked card borders and saving vertical space.
  - *Prohibition:* Cloning Customer editorial whitespace into high-volume triage queues, or turning Owner into a disconnected metric-card grid.

- **Admin Experience (`DESKTOP_WEB_PRESERVED`):**
  - *Tone & Character:* High-volume audit governance, desktop throughput.
  - *Structural Rule:* Multi-column data tables, FIFO review queues, and compact filter side-panels with restrained 8px structural radii (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).
  - *Boundary Rule:* Phase 4E mobile structural grammar does not force mobile card patterns onto Admin desktop workflows.

---

## 2. Grouping Decision Tree

Before applying a container to any UI elements, evaluate the grouping relationship:

1. **`OPEN_CONTENT` (No enclosing container, restrained dividers):**
   - *When to Use:* Content belongs to a continuous narrative or single-task inspection flow (Customer property description, house rules, amenities list).
   - *Structural Model:* Has **NO ENCLOSING STRUCTURAL CONTAINER**; relationships are defined by typography, whitespace, and optional subtle dividers. Does not possess or require a container radius token.
2. **`OPEN_GROUPED_CONTENT` (Single outer container, subtle internal dividers):**
   - *When to Use:* Homogeneous operational records form a collective list (Owner booking queue, unit management rows, notification settings). Exact native stroke width remains `OPEN` / deferred to Phase 4I.
3. **`INTERACTIVE_CONTAINER / CARD` (Restricted Bounded Container):**
   - *When to Use:* The entity is independently actionable, movable, or recognizable as an independent product object (`PropertyCard`), or forms an isolated multi-attribute decision unit (server price quote breakdown).
4. **Prohibited Patterns:**
   - Card soup (nesting a card inside a card).
   - Card per individual metric or fact.
   - Framing plain text paragraphs in rounded boxes.
   - Stacking border + shadow + tinted background simultaneously without semantic purpose.

---

## 3. Spacing Relationship Hierarchy

Spacing is a relationship, not an arbitrary number. Spatial relationships govern hierarchy across all surfaces:

### Spacing Relational Hierarchy (CANONICAL NOW)
Relationships govern hierarchy across all surfaces:
- **Tier 1 (Micro / Intra-element):** Relationships between intimately linked elements (e.g., Title to Subtitle, Price to Nightly suffix, icon-to-label offsets, status dot gaps).
- **Tier 2 (Intra-group / Item):** Relationships between related items within a group (e.g., Field to Field, Row to Row, compact list item gutters).
- **Tier 3 (Section Separation):** Separation between distinct semantic sections or operational groups (e.g., Description section to Amenities section).
- **Tier 4 (Major Landmark):** Major structural boundaries and clearances (e.g., Hero gallery to Content body, Sticky bar clearance).

**Canonical Relationship Invariant:**
`TIER_1 < TIER_2 < TIER_3 < TIER_4`

### Mobile Evaluated Spacing Scale (SYSTEM-EVALUATED PROVISIONAL NUMERIC MAPPING)
The relational spacing family evaluated in Phase 4E:
- `Tier 1 (Micro / Intra-element):` **4px** (xs, e.g. status dot, badge internal inset) / **8px** (sm, e.g. button icon to text, chip gap, label to input).
- `Tier 2 (Intra-group / Item):` **12px** (md, e.g. dense Owner row padding, compact gutters) / **16px** (lg, e.g. standard container padding).
- `Tier 3 (Section Separation):` **24px** (xl, vertical rhythm between distinct semantic sections).
- `Tier 4 (Major Landmark):` **32px** (2xl, major structural boundary, hero to body).

*Rule:* Formal Phase 4E relational spacing family is strictly `4 / 8 / 12 / 16 / 24 / 32 px`. Numeric values are SYSTEM-EVALUATED PROVISIONAL and not final native token Canon. Token-file authoring remains separately governed.
*(Note: 40px / 48px sizing clearances observed in Web pilots are controlled Web sizing or clearance evidence, not part of the formal Phase 4E spacing scale. Sizing clearance and platform touch guidance [iOS ~44pt / Android ~48dp] are evaluated separately; native acceptance is deferred to Phase 4I. Never conflate CSS pixels with platform pt/dp).*

---

## 4. Mobile Content Insets

- **Customer Mobile:** 16px horizontal page inset (`--struct-page-inset: 16px`). Selected as provisional mobile page inset because controlled evidence showed useful content width, visual edge separation, and coherent layout rhythm across mobile viewports.
- **Owner Mobile:** 16px horizontal page inset. Matches Customer for system-wide layout consistency, pairing with 12px internal row padding for operational density.
- **Admin Desktop Boundary:** 24px desktop gutter (`p-6`). Preserves desktop wide-canvas ergonomics (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).

*Explicit Rule:* `PAGE_INSET != SAFE_AREA_INSET`. Page insets provide horizontal content margins; platform safe-area insets (notches, home indicators, system bars) are platform-controlled independently. Layouts must compose both correctly without claiming that 16px replaces or guarantees hardware safe-area accommodation.

---

## 5. Shape Roles & Radius System

Semantic roles precede raw numeric values:

- **`SHAPE_ACTION`:** `6px` Primary Button radius (`PROVISIONAL_PRIMARY_ONLY`; Phase 4C). Secondary button radius remains open.
- **`SHAPE_INPUT`:** `8px` Mobile Field radius (`PROVISIONAL_FIELD_SHAPED_ONLY`; Phase 4D).
- **`SHAPE_CONTAINER`:** `12px` Structural Container radius (`SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`). Controlled visual evidence across 6 Customer and Owner screenshots established that 10px is a valid close alternative, 12px is a balanced provisional system tie-breaker providing comfortable contour distinct from 6px buttons and 8px fields without generic rounded-SaaS bubbling, while 16px is materially rounder with higher generic-SaaS styling risk in repeated operational groups. Reversible implementation detail; native acceptance deferred to Phase 4I (`NO_MATERIAL_FOUNDER_DECISION_REQUIRED: YES`).
- **`OPEN_CONTENT`:** Has **NO ENCLOSING STRUCTURAL CONTAINER**. Content relationships are structured via typography, whitespace, and optional subtle dividers. It does not possess or require a container radius token. (If a literal flat-edged contained element exists, its geometry is governed by that component).
- **`SHAPE_INDICATOR`:** Compact rectangular or soft indicators. Exact geometry remains `OPEN_OR_COMPONENT_GOVERNED`.
- **`SHAPE_OVERLAY`:** Dialogs, bottom sheets, and floating app bars. Geometry deferred to Phase 4F.

*(Note: 6px → 8px → 12px is an EXPERT_HEURISTIC, not a self-validating mathematical proof).*

---

## 6. Elevation & Surface Hierarchy

- **Flat by Default:** Normal structural content is flat. Surfaces rely on spacing, subtle neutral backgrounds, and restrained dividers/boundaries before shadows (exact native stroke width remains `OPEN` / deferred to Phase 4I; 1px is controlled Web pilot rendering reference only).
- **Canvas & Surface Reference:** Subtle neutral boundary on light-first canvas. Web pilot rendering reference values (`#FFFFFF` surface, `#E2E8F0` divider reference, `#F8FAFC` canvas reference) are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE` only; exact neutral tokens remain `OPEN`.
- **Elevation Roles:** Shadows are reserved strictly for floating/overlay layers where physical layering occurs (app bar on scroll, sticky decision bar, modal sheets). Exact elevation tokens and overlay geometry are deferred to Phase 4F.
- **Native Acceptance:** Physical mobile rendering, scaling, and touch target acceptance are `DEFERRED_TO_4I`.
