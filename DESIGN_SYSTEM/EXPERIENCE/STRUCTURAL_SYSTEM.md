# Structural System and Layout

**Status:** `FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE_4E_STRUCTURAL_MODEL`  
**Governing Authority:** `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` §13, §14; `DESIGN_SYSTEM/COMPONENTS/cards.md`

Phase 4E establishes the structural composition, grouping grammar, and layout rhythm across KONFRM product surfaces, enacting Founder-selected **Option C: Role-Aware Hybrid Structural System**.

---

## 1. Role Structural Grammar

Layout grammar adapts to user mental models; consistency of underlying design primitives does not force identical surface composition across roles.

- **Customer Experience (`OPEN_EDITORIAL_DEFAULT`):**
  - *Tone & Character:* Leisure discovery, hospitality warmth, relaxed inspection.
  - *Structural Rule:* Photography and content lead. Proximity and whitespace carry grouping before adding containers. Property facts, descriptions, and amenities flow unboxed with restrained 1px hairline dividers.
  - *Bounded Containers:* Strictly restricted to discrete decision units (e.g., booking quote breakdown) or independent exploration entities (`PropertyCard`).
  - *Prohibition:* "Card soup" and SaaS dashboard framing around vacation rental discovery.

- **Owner Experience (`OPERATIONAL_GROUPING_DEFAULT_WHEN_SEMANTIC`):**
  - *Tone & Character:* Operational triage, control, state certainty, high scanability.
  - *Structural Rule:* Related operational records share a single outer container with internal dividers (`OPEN_GROUPED_CONTENT`).
  - *Bounded Containers:* Preferred where shared boundaries group related items (pending booking requests, unit listings, earnings history), avoiding repetitive stacked card borders and saving vertical space.
  - *Prohibition:* Cloning Customer editorial whitespace into high-volume triage queues, or turning Owner into a disconnected metric-card grid.

- **Admin Experience (`DESKTOP_WEB_PRESERVED`):**
  - *Tone & Character:* High-volume audit governance, desktop throughput.
  - *Structural Rule:* Multi-column data tables, FIFO review queues, and compact filter side-panels with restrained 8px structural radii (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).
  - *Boundary Rule:* Phase 4E mobile structural grammar does not force mobile card patterns onto Admin desktop workflows.

---

## 2. Grouping Decision Tree

Before applying a container to any UI elements, evaluate the grouping relationship:

1. **`OPEN_CONTENT` (0px radius, 1px hairline dividers):**
   - *When to Use:* Content belongs to a continuous narrative or single-task inspection flow (Customer property description, house rules, amenities list).
2. **`OPEN_GROUPED_CONTENT` (Single container, internal 1px dividers):**
   - *When to Use:* Homogeneous operational records form a collective list (Owner booking queue, unit management rows, notification settings).
3. **`INTERACTIVE_CONTAINER / CARD` (Restricted Bounded Container):**
   - *When to Use:* The entity is independently actionable, movable, or recognizable as an independent product object (`PropertyCard`), or forms an isolated multi-attribute decision unit (server price quote breakdown).
4. **Prohibited Patterns:**
   - Card soup (nesting a card inside a card).
   - Card per individual metric or fact.
   - Framing plain text paragraphs in rounded boxes.
   - Stacking border + shadow + tinted background simultaneously without semantic purpose.

---

## 3. Spacing Relationship Hierarchy

Spacing is a relationship, not an arbitrary number. Spatial relationships govern hierarchy:

| Tier | Semantic Role | Range / Value | Typical Usage |
|---|---|---|---|
| **Tier 1** | Micro / Intra-element | `4px – 8px` | Title to subtitle, price to nightly suffix, icon-to-label offsets, status dot gaps |
| **Tier 2** | Intra-group / Item | `12px – 16px` | Field to field, row to row, compact list item gutters |
| **Tier 3** | Section Separation | `24px` | Description section to amenities section, distinct operational groups |
| **Tier 4** | Major Landmark | `32px` | Hero gallery to content body, sticky bar clearance |

*Evaluated Spacing Scale:* `4px, 8px, 12px, 16px, 24px, 32px` (`SYSTEM_EVALUATED_STRUCTURAL_CANDIDATE`).  
*Rule:* No new spacing value should be introduced without demonstrated semantic need and governed design-system approval.

---

## 4. Mobile Content Insets

- **Customer Mobile:** 16px horizontal page inset (`--struct-page-inset: 16px`). Maximizes usable width while avoiding edge clipping on curved device corners.
- **Owner Mobile:** 16px horizontal page inset. Matches Customer for system-wide layout consistency, pairing with 12px internal row padding for operational density.
- **Admin Desktop Boundary:** 24px desktop gutter (`p-6`). Preserves desktop wide-canvas ergonomics (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).

---

## 5. Shape Roles & Radius System

Semantic roles precede raw numeric values:

- **`SHAPE_ACTION`:** `6px` Primary Button radius (`PROVISIONAL_PRIMARY_ONLY`; Phase 4C). Secondary button radius remains open.
- **`SHAPE_INPUT`:** `8px` Mobile Field radius (`PROVISIONAL_FIELD_SHAPED_ONLY`; Phase 4D).
- **`SHAPE_CONTAINER`:** `12px` Structural Container radius (`SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`). Balanced geometry harmonizes with 8px field geometry and 6px button geometry without generic rounded-SaaS bubbling.
- **`SHAPE_OPEN`:** `0px` radius for inline divided content.
- **`SHAPE_INDICATOR`:** Compact rectangular or soft indicators. Exact geometry remains `OPEN_OR_COMPONENT_GOVERNED`.
- **`SHAPE_OVERLAY`:** Dialogs, bottom sheets, and floating app bars. Geometry deferred to Phase 4F.

*(Note: 6px → 8px → 12px is an EXPERT_HEURISTIC, not a self-validating mathematical proof).*

---

## 6. Elevation & Surface Hierarchy

- **Flat by Default:** Normal structural content is flat. Surfaces rely on spacing, subtle neutral backgrounds, and 1px dividers/borders before shadows.
- **Canvas & Surface Reference:** Subtle neutral boundary on light-first canvas. Web pilot rendering reference values (`#FFFFFF` surface, `#E2E8F0` divider reference, `#F8FAFC` canvas reference) are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE` only; exact neutral tokens remain `OPEN`.
- **Elevation Roles:** Shadows are reserved strictly for floating/overlay layers where physical layering occurs (app bar on scroll, sticky decision bar, modal sheets). Exact elevation tokens and overlay geometry are deferred to Phase 4F.
- **Native Acceptance:** Physical mobile rendering, scaling, and touch target acceptance are `DEFERRED_TO_4I`.
