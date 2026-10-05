# KONFRM Mobile Design Foundation — v1.5

**Status:** CANONICAL SPECIFICATION — DF2
Independent platform/accessibility/design-system review and final Bridge verification completed. DF2 is canonical.
**Amendment v1.1 (Founder brand-identity decision):** mobile brand identity is monochrome-first — Black/White; Summer Yellow removed from the core mobile brand architecture; blue demoted to a restrained interaction accent (candidate `#276EF1`). See §9.
**Amendment v1.2 (Phase 4C Action System synchronization):** records independently reviewed SYSTEM-VALIDATED PROVISIONAL Action System mappings inside the canonical foundation without promoting exact provisional component values to final native Canon. Native component and accessibility acceptance remains strictly deferred to Phase 4I. The canonical document is authoritative about STATUS, SEMANTIC ROLES, and ARCHITECTURAL DIRECTION, not falsely about final native token acceptance.
**Amendment v1.3 (Phase 4D Form & Selection Primitives synchronization):** records independently evaluated and Founder-approved SYSTEM-VALIDATED PROVISIONAL Form & Selection primitive directions (Outline-led field baseline, 8px mobile field radius for field-shaped controls, explicit top-label hierarchy, semantic restrained interaction-accent focus emphasis, Owner-evidenced checkbox, toggle deferred) inside the canonical foundation without promoting provisional component values to final native Canon. Exact neutrals, stroke width, blue candidate (`#276EF1`), focus geometry, and platform component mappings remain OPEN / IMPLEMENTATION CANDIDATE. Native component and accessibility acceptance remains strictly deferred to Phase 4I. Admin remains Web.
**Amendment v1.4 (Phase 4E Structural System synchronization):** records Founder-approved SYSTEM-VALIDATED PROVISIONAL Phase 4E Structural System direction (Option C — Role-Aware Hybrid Structural System: Customer open/editorial default, Owner operational grouped-content direction, Admin desktop boundary preserved, spacing relationship hierarchy, semantic container/card criteria, flat structural elevation default). Evaluates 12px structural-container radius as SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS based on controlled evidence, while exact neutrals (#FFFFFF, #E2E8F0, #F8FAFC) remain OPEN implementation candidates. Native component and accessibility acceptance remains strictly deferred to Phase 4I. Navigation, app bars, sheets, dialogs, and overlay architecture remain deferred to Phase 4F.
**Amendment v1.5 (Phase 4F Navigation & Overlay System synchronization):** records independently evaluated and Founder-compliant SYSTEM-VALIDATED PROVISIONAL Phase 4F Navigation & Overlay System direction (Role-Aware Contextual Navigation: Customer 4-tab top-level root destinations [Explore, Favorites, Bookings, Account]; Owner action-first operational hub with dashboard-style nested routing and NO Customer-style bottom navigation; Auth V2 sequential full-screen route flow [08 → 09 → 10]; Screen 07 dedicated full-screen transactional review; mutual exclusivity of persistent bottom navigation and sticky actions [dual bottom chrome prohibited]; BottomSheet semantics with explicit close control required, optional drag handle, conditional backdrop dismissal, and 16px provisional top radius; Dialog semantics with 12px provisional surface radius for consequential confirmation; semantic safe-area and context-restoration contracts defined). Exact neutrals, exact blue candidate (`#276EF1`), exact overlay shadow parameters, and exact scrim values remain OPEN / IMPLEMENTATION CANDIDATE. Native component, gesture, detent, and safe-area acceptance remains strictly deferred to Phase 4I. Admin remains Web.
**Scope:** The design foundation governing future `mobile/customer_app`, `mobile/owner_app`, mobile design tokens, canonical mobile primitives, AI design Skills, visual QA and the controlled pilot.
**Upstream authority (not reopened here):**

- `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md` — Flutter + Dart, Customer/Owner separation, Admin stays Web, platform-adaptive direction.
- `docs/architecture/KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md` — single canonical repository, `mobile/` boundary only.
- `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md` — architecture boundaries; `konfrm_design_system` is a **reserved** package boundary fed by this document.
- `DESIGN_SYSTEM/GOVERNANCE.md` v2.1.3 — design authority model, enforcement, Founder visual rules.

**This document defines the foundation layer: principles, semantic roles, classification of decisions, and validation requirements.** It deliberately does **not** finalize numeric token values, component dimensions, motion timings, dark mode, or icon-family choices. Governance and decision maturity are classified across two complementary dimensions:

1. **DF2 Decision / Canonicality Classification:**
   - **CANONICAL NOW:** Foundational principles, semantic role models, authority hierarchies, and approved non-negotiable rules.
   - **IMPLEMENTATION CANDIDATE:** Directionally favored values or patterns awaiting formal validation on target surfaces.
   - **DEFERRED / REQUIRES VALIDATION:** Decisions explicitly deferred to dedicated implementation or validation phases.

2. **Evidence / Maturity Status:**
   - **SYSTEM-VALIDATED PROVISIONAL:** Independently reviewed, controlled design evidence supports the decision (e.g., Phase 4C Action System results). This status is significantly stronger than an untested candidate, but it **does NOT equal CANONICAL NOW** final native tokens or components; it remains subject to the governing native acceptance gate (Phase 4I).

---

## 1. Purpose and Scope

KONFRM is moving from a web prototype product to a production mobile product (Customer + Owner Flutter applications). The existing `DESIGN_SYSTEM/` contains mature governance and semantic tokens for the web surfaces, a documented legacy-drift inventory, and a small but valuable mobile shell contract (`IMPLEMENTATION/mobile.md`). No Flutter design system exists yet.

DF2 establishes, before any Flutter code:

1. the design **North Star** and philosophy (Trust / Clarity / Vitality; dense by purpose);
2. the **authority and evidence hierarchy** for mobile design decisions;
3. the **semantic design-system model** (role families, not raw values);
4. the **foundational rules** for color, typography, Arabic/RTL/Bidi, numerals and money, spacing/layout, surface/shape/elevation, action hierarchy, state grammar, navigation, forms, imagery, motion, accessibility, and platform adaptation;
5. the **boundary between what is canonical now, what is an implementation candidate, and what is deferred**;
6. the **inputs and validation requirements** that later token/primitive work must satisfy before anything becomes canonical.

**In scope:** mobile design foundation for Customer and Owner Flutter apps.
**Out of scope:** Flutter initialization, `mobile/` creation, component implementation, token value finalization, legacy web migration, dark mode decisions, Admin redesign, payment/provider decisions, Pilot scope.

## 2. Authority and Evidence Hierarchy

When design evidence conflicts, resolution follows this order. Higher levels always outrank lower ones; external skills and aesthetic references never outrank KONFRM Canon.

1. Founder-approved Product / Business / Brand truth (explicit decisions, DECISIONS.json `APPROVED_EXISTING`, dated Founder directives).
2. Canonical product truth: approved API contracts (`docs/api/openapi.yaml` slices), verified runtime behavior, `BUSINESS_RULES.md`, server-authoritative state.
3. Applicable accessibility requirements (platform-specific; see §21 — Web WCAG measurements are not automatically native rules).
4. Apple HIG / Android (Material 3) platform conventions.
5. Official Flutter behavior and capabilities.
6. Relevant usability / human-factors evidence.
7. Mature external design systems as references (Base, Material, Carbon).
8. Aesthetic references and trends (Telda screenshots — inspiration only).
9. AI or agent preference (never authoritative).

**Within the scope each authority legitimately governs, KONFRM Canon outranks lower-level external references and AI preference. Applicable legal/accessibility requirements remain implementation constraints and cannot be waived by Canonical visual preference.** A genuinely new requirement follows the established chain: **propose → central approval → central documentation/token → version → app consumption.** Never the reverse.

Founder/Product authority governs KONFRM product meaning, business rules and brand intent. Applicable legal and accessibility requirements constrain implementation and are not waivable by aesthetic or brand preference. When a presentation choice conflicts with such a requirement, preserve the approved product meaning through an accessible implementation and escalate any unresolved product trade-off rather than shipping an inaccessible exception.

## 3. KONFRM Design North Star

Founder-approved core attributes: **TRUST · CLARITY · VITALITY.**

Product character: **trusted service platform + modern tech product + a hospitality touch.**

Direction:

- lively and attractive; clear; decisive; structured; productive;
- information-rich; visually strong; clean; organized;
- minimal but **not empty**; high **useful** density; no arbitrary empty space;
- no random visual noise; every element earns its place;
- strong KONFRM identity recognizable quickly.

Core principle: **DENSE BY PURPOSE, NOT BY COMPRESSION.**

More precisely: **high useful information density + strong visual hierarchy + low interaction ambiguity + controlled visual noise.**

This is a design direction, not a license to invent tokens or components outside the governance chain (§2, §24).

## 4. Trust / Clarity / Vitality

**TRUST** comes primarily from:

- truthful data and server-authoritative state;
- clear, explicit states (error ≠ empty; stale ≠ error; pending ≠ success; missing ≠ zero);
- predictable actions and consistent behavior across equivalent surfaces;
- financial clarity (canonical totals, server-authoritative balances, no invented numbers);
- visible system feedback and good recovery;
- visual craft — not decorative assurance, fake badges, fake ratings, fake scarcity or social proof.

**CLARITY** comes from:

- hierarchy built through order, grouping, typography, spacing, contrast, alignment and action clarity — not through shrinking text or stacking borders;
- one obvious primary action per decision point;
- labels and states that say what they mean (plain business language for Owner finance — UX-OWNER-02 intent).

**VITALITY** may come from:

- real property imagery (Customer);
- restrained interaction accent (§9) and confident black/white identity contrast;
- useful state changes and interaction feedback;
- content freshness and confident hierarchy.

Vitality must **not** come from: random gradients, many colors, endless motion, decorative cards, glow, or fake glass.

## 5. Simplicity and Useful Density

**A. Simplicity.** Minimalism in KONFRM means **remove noise, not remove useful information.** Adding necessary context can improve simplicity. A screen missing a decision-critical fact is not "simple"; it is incomplete.

**B. Density — three different concepts that must never be conflated:**

- **Information density:** how much *useful, decision-relevant* content a surface carries.
- **Visual density:** how tightly elements are packed visually.
- **Cognitive load:** how much effort understanding and acting requires.

KONFRM targets **high useful information density with low cognitive load**. Density is achieved through information and hierarchy, never by counting cards, shrinking text, or compressing touch targets. Owner surfaces may be denser than Customer surfaces (§7); neither may become clutter.

**C. Whitespace must have a purpose:** grouping, separation, hierarchy, readability, touch clarity, or visual rhythm. "Premium feel" alone never justifies unused space in product UI. Whitespace that separates groups is information; whitespace that fills emptiness is waste.

## 6. Visual Hierarchy

1. Each surface declares its **primary information**, **supporting information**, and **primary action** before implementation begins.
2. Scan order follows the role's mental model (Customer: imagery → price/facts → state → action; Owner: what needs action → operational state → detail).
3. Hierarchy is built by: order → grouping → typography role → spacing relationship → contrast → alignment → action clarity. Decorative emphasis (borders, shadows, color) is the last resort, not the first.
4. Grouping uses proximity and shared surfaces; card containers communicate real semantic grouping, not styling habit (§14).
5. Repeated controls for the same action on one surface require an explicit reason.
6. Hierarchy ambiguity (two elements competing to be "the" primary thing) is a defect, not a style.

## 7. Role Psychology

### 7.1 Customer

Primary mental needs: discovery, reassurance, property understanding, visual confidence, price clarity, availability clarity, booking confidence, recovery from uncertainty and errors.

Feel: **hospitality + modern technology + trustworthy service.**

Imagery may be prominent (§19). Prohibitions: no fake ratings, no fake social proof, no fake scarcity, no fabricated trust badges, no internal commission/wallet data (UX-FOUND-02 financial privacy).

### 7.2 Owner

Primary mental needs: control, action priority, operational awareness, booking decisions, property state, availability, financial confidence, server-authoritative status.

Feel: **operational clarity + control + confidence.**

Owner may be **denser** than Customer. But: not tiny text, not enterprise-dashboard clutter, not KPI-card soup, not a dark fintech dashboard by default (GOVERNANCE P0 rule).

### 7.3 Admin boundary

Admin remains a **Web** application. DF2 may state shared brand/system relationships (same tokens lineage, same status grammar, same Arabic-first principles) but **does not define and must not invent a Flutter Admin system.**

## 8. Semantic Design-System Model

The future mobile design system is a **semantic role model**, not a palette of raw values. Conceptual families:

| Family | Canonical intent (DF2) | Implementation values |
|---|---|---|
| **BRAND** | Monochrome-first Black/White identity language (mark / wordmark identity expression) | Exact neutral / ink values CANDIDATE |
| **SURFACE** | canvas / grouped content / interactive container / elevated overlay / sheet roles | CANDIDATE |
| **TEXT** | primary / secondary / muted / inverse roles + minimum readability requirement | CANDIDATE |
| **BORDER** | separation vs emphasis vs focus roles | CANDIDATE |
| **INTERACTION** | Action / selection / focus / pressed / disabled interaction roles, including a restrained blue interaction-accent role where appropriate | `#276EF1` CANDIDATE; derived interaction states CANDIDATE |
| **SEMANTIC STATUS** | success / info / warning / danger — never color-only (§16) | CANDIDATE |
| **TYPOGRAPHY ROLE** | §10 role model | CANDIDATE |
| **SPACING ROLE** | §13 relationship model | CANDIDATE |
| **SHAPE ROLE** | control / card / sheet / pill geometry roles | CANDIDATE |
| **ELEVATION ROLE** | flat / raised / overlay semantic levels | CANDIDATE |
| **MOTION ROLE** | §20 purpose classes | CANDIDATE (numbers DEFERRED) |
| **ICON ROLE** | §24 icon strategy rules | CANDIDATE (family DEFERRED) |
| **LAYOUT ROLE** | §13 insets/rhythm/safe-area relationships | CANDIDATE |

Rule: role semantics are CANONICAL NOW (as defined in this document); concrete numeric values inside each role are IMPLEMENTATION CANDIDATE until validated (§29), and some are explicitly DEFERRED.

## 9. Color Foundation

**Brand-color architecture — Founder amendment (CANONICAL NOW; supersedes the previous mobile blue/yellow framing):**

- **Black / White is the primary KONFRM mobile brand identity**: confident, minimal, structured, clear. The Brand Mark / Wordmark identity is monochrome-first. Vitality comes from content — real property imagery, useful state change, interaction feedback, motion, information freshness, and confident hierarchy — not from multiple brand accent colors.
- **Mobile Primary Action provisional treatment is Stable Black (`#000000`)**: Status is **SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK** (evaluated in Phase 4C Stage 2 & 3A; fallback comparator `#18181B`). This is a provisional candidate, **not** final native token Canon (native acceptance deferred to Phase 4I). Existing Web `TOKENS/colors.json` (`#0059FF`) remains untouched.
- **Blue is no longer the dominant brand-identity color, and is NOT the Primary CTA color.** Blue remains only as a **restrained PRODUCT INTERACTION ACCENT**, appearing lightly and intentionally in non-primary interactive moments. Candidate: **`#276EF1`** — Founder-preferred directional candidate, **IMPLEMENTATION CANDIDATE (OPEN)**: it is not a final lower-level mobile token and must be validated in appropriate non-primary component contexts (active navigation, selected state, links/action text where appropriate, focus treatment candidate, progress/loading where appropriate, disabled/pressed relationships, contrast/accessibility on intended surfaces) before token canonicalization. Core screens must not feel "blue-branded".
- **Summer Yellow `#FFD700` is removed from the core mobile brand architecture.** It is no longer a mobile micro-signature, CTA accent, identity color, or default decorative accent, and it is not replaced by another secondary brand color. (Historical/web yellow references remain web-governance history and carry no mobile authority.)
- The previous saturated web blue (`#0059FF`) likewise no longer governs the mobile primary brand/action identity. (Historical web usage is untouched by this amendment.)

**Separation of concerns (CANONICAL NOW):** BRAND IDENTITY (monochrome-first), PRODUCT INTERACTION ACCENT (restrained blue), SEMANTIC STATUS color, SURFACE color, and CONTENT IMAGERY are distinct concerns. Identity never doubles as status; status never doubles as decoration; imagery is content, not branding.

**Status never by color alone** — status carries a text label and/or icon plus accessible name (§16, §21).

**Scope boundary:** the web `TOKENS/colors.json` values (including `#0059FF` and `#FFD700`) are untouched by this amendment and must **not** be mistaken for the new Mobile Canon. Mobile token integration happens later under its own validated implementation task.

**Logo assets:** the custom K symbol and full wordmark SVGs are ready for a separate Logo Asset Intake / Integration task — they are **not** integrated here. Logo artwork color ≠ UI text token ≠ surface token; that distinction is preserved explicitly. The symbol is expected to appear more frequently due to compactness, but exact symbol-vs-wordmark usage rules require asset/use-case validation first.

**Unchanged surface principles (CANONICAL NOW):**

- Light-first identity: white/neutral surfaces. Black/white identity expression concerns the mark/wordmark and monochrome contrast — it does **not** introduce dark UI surfaces (the GOVERNANCE forbidden-dark-surfaces policy remains).
- Semantic families exist for success / info / warning / danger; warning is copy-first on a neutral/light surface; no amber/orange boxed containers.
- Product feel remains calm, clear, modern, premium: lively through content, not through many colors.
- Dark mode: **not decided** (§28). Android Dynamic Color: **not decided** (§28).

## 10. Typography Foundation

**Preserve semantic-role thinking; consolidate where it improves clarity.** The web system defines 11 roles; the mobile role model below is the DF2 consolidation intent:

| Role (conceptual) | Canonical intent | Maps from web evidence |
|---|---|---|
| display | rare identity/hero moment | display |
| pageTitle | primary page/screen title | pageTitle |
| sectionTitle | section grouping heading | sectionTitle |
| cardTitle | card/list-item/modal title | cardTitle |
| body | default readable copy | body |
| bodyStrong | in-copy emphasis | bodyStrong |
| label | field labels, compact controls, status labels | label |
| supporting | helper/metadata copy | caption + metadata (consolidation candidate) |
| numeric | financial/operational values | numeric (tabular intent) |
| button | actionable control label | button |

**CANONICAL NOW (principles):**

- Arabic readability leads. **Required/decision-critical text must remain comfortably readable, scalable, and unclipped on every supported scaling setting.** There is **no universal mobile minimum pixel rule** in DF2 (the web 12px floor is web evidence, not a mobile canon — §29 validates mobile readability values).
- Numeric/financial values use **tabular numeral intent** where the platform text stack supports it, keeping Cairo for surrounding UI.
- Mixed-script behavior follows §11 (numerals, phones, IDs isolated LTR per §12).
- Text never relies on truncation to hide decision-critical information; truncation rules follow §11.
- Hierarchy is expressed primarily through the role model, not through ad-hoc sizes.

**SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY:** Cairo Profile B typography scale and metrics (display 24/700/1.30, pageTitle 20/700/1.35, sectionTitle 17/700/1.40, cardTitle 15/700/1.40, body 14/500/1.50, bodyStrong 14/700/1.50, label 12/600/1.35, supporting 12/400/1.40, numeric 16/700/1.30, button 15/700/1.20). Validated in Phase 4B. Profile B is provisional design foundation, not promoted to final native Canon. Native Flutter typography acceptance is deferred to Phase 4I.
**DEFERRED:** display-font decisions; per-role letter-spacing values; native mobile Flutter acceptance (Phase 4I).

## 11. Arabic / RTL / Bidi

Arabic-first RTL is **foundation-level, not post-processing.** CANONICAL rules:

1. **Semantic RTL:** direction-relative layout and alignment use semantic start/end throughout. Physical left/right is permitted only when it intentionally represents fixed spatial or real-world direction, media/chart/map semantics, or platform-defined physical behavior. Such cases are explicit exceptions, not substitutes for RTL-aware layout.
2. **Paragraph direction:** Arabic content lays out RTL; embedded Latin/numeric runs follow §12 isolation.
3. **Mixed Arabic + English:** never concatenate fragments in ways that produce accidental reversal; embed foreign runs with isolation.
4. **Phone numbers, technical IDs, URLs where displayed, Latin technical strings, and direction-sensitive numeric sub-runs:** directional isolation as needed, preserving logical reading order. For mixed-direction monetary content, isolate only the required sub-runs while preserving the intended Arabic currency suffix order.
5. **Directional icons:** back/forward use direction-aware semantics — back points toward the RTL-previous edge; do not mirror unrelated symbols.
6. **Label + icon order:** the icon appears on the RTL-leading side of its label (document-order first), matching the existing web rule.
7. **Dates:** presentation conventions are a separate localization decision (§12 numeral rule does not automatically define date/calendar localization); existing Product Truth governs specific cases.
8. **Truncation/wrapping:** truncation never hides decision-critical data; wrapping must not produce orphan characters or arbitrary mid-token breaks in identifiers (existing web lesson: `overflow-wrap` semantics with `word-break: normal` intent).
9. **Screen-reader logical order:** announced order matches visual reading order; isolated runs remain coherent when traversed.

**NOT canonical:** "mirror everything." Some patterns (media playback, progress direction, platform-standard pickers) follow their own platform conventions.

## 12. Numeral and Financial Display Foundation

**Founder decision — CANONICAL NOW for DF2:**

- Arabic KONFRM UI uses **Western Arabic numerals by default**: `0 1 2 3 4 5 6 7 8 9`.
- Default Customer-facing money example: **`1,600 ج.م`** — not `١٬٦٠٠ ج.م`.
- Arabic UI remains RTL.
- Numeric / phone / technical-ID runs may be isolated LTR (§11).
- This decision does **not** automatically define every future date/calendar localization rule; date/calendar conventions remain a separate localization decision unless existing Product Truth already governs a specific case.
- The approved rendering `1,600 ج.م` must be validated visually and with VoiceOver/TalkBack so numeric isolation does not reorder, detach, or misannounce the Arabic currency suffix.

Financial display rules (CANONICAL NOW):

- Financial state is **server-authoritative**; the client never calculates balances, eligibility, fees, or totals as authority.
- Customer sees booking-relevant totals/deposit/remaining only (UX-FOUND-02); Owner sees business-language balances (UX-OWNER-02 intent) — internals stay behind detail.
- Tabular numeral intent for aligned financial columns (§10).

## 13. Spacing and Layout

**Spacing is a relationship, not a number.** CANONICAL relationships:

1. **Proximity grouping:** related elements sit closer to each other than to unrelated ones; spacing expresses the grouping.
2. **Section separation:** sections separate more strongly than intra-section items.
3. **Content insets** and **internal component gaps** are consistent per surface role — the same kind of surface uses the same relationship.
4. **Screen rhythm:** regular vertical rhythm for scanning; no arbitrary gaps, no filler spacing.
5. **Safe-area relationship:** content respects platform safe areas; sticky/persistent controls reserve their own space and may never cover the last actionable content (existing `IMPLEMENTATION/mobile.md` shell contract).
6. **Useful screen occupancy:** surfaces are occupied by useful information and purposeful structure. Empty filler space is waste; forced density is noise.

### Spacing Relational Hierarchy (CANONICAL NOW)
Relationships govern spacing hierarchy across all surfaces:
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

### Mobile Content Insets (SYSTEM-EVALUATED PROVISIONAL STRUCTURAL INSET)
- **Customer Mobile:** 16px horizontal page inset (`--struct-page-inset: 16px`). Selected as provisional mobile page inset because controlled evidence showed useful content width, visual edge separation, and coherent layout rhythm across mobile viewports.
- **Owner Mobile:** 16px horizontal page inset. Matches Customer for system-wide layout consistency, pairing with 12px vertical row padding for operational density.
- **Admin Desktop Boundary:** 24px (`p-6`) desktop gutter. Preserves desktop wide-canvas ergonomics (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).

*Explicit Rule:* `PAGE_INSET != SAFE_AREA_INSET`. Page insets provide horizontal content margins; platform safe-area insets (notches, home indicators, system bars) are platform-controlled independently. Layouts must compose both correctly without claiming that 16px replaces or guarantees hardware safe-area accommodation.

**Truly invariant only by platform requirement:** system safe-area insets themselves.

## 14. Surface / Shape / Elevation

**Roles before values (CANONICAL NOW):**

- **canvas** — the base screen background.
- **open grouped content** — grouped items sharing one container with internal separation (preferred KONFRM grouping shape; fights card soup).
- **interactive container** — a tappable row/card surface.
- **elevated/overlay container** — floating above content.
- **modal/sheet surface** — task-focused blocking surface.

### Overlay Shape & Elevation Discipline (SYSTEM-EVALUATED PROVISIONAL PHASE_4F_OVERLAY_GEOMETRY)

Phase 4F established the shape, radius, and elevation rules for floating and overlay surfaces:
- **Mobile BottomSheet Top Radius:** **16px** (`SYSTEM-EVALUATED PROVISIONAL BOTTOM_SHEET_TOP_RADIUS`). Controlled visual comparison across 12px, 16px, and 20px confirms 16px provides balanced curvature against 12px structural containers and 8px inputs. Distinct from button (6px), input (8px), container (12px), and dialog (12px) radii.
- **Mobile Dialog Surface Radius:** **12px** (`SYSTEM-EVALUATED PROVISIONAL DIALOG_RADIUS`). Controlled visual comparison across 10px, 12px, and 16px confirms 12px aligns harmoniously with Phase 4E structural containers without excess roundness.
- **Overlay Elevation & Scrim:** Structural page content is flat by default (`FLAT_BY_DEFAULT`). Elevation is reserved strictly for floating/overlay layers (app bars, sticky decision bars, bottom sheets, dialogs). Exact shadow parameters (`0 -4px 24px...`, `0 12px 36px...`) and scrim opacity/blur values are controlled Web pilot rendering references; exact tokens remain **OPEN / IMPLEMENTATION CANDIDATE**; native rendering acceptance is deferred to Phase 4I.

### Structural System Model (FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE_4E_STRUCTURAL_MODEL)
Founder approved **Option C: Role-Aware Hybrid Structural System**.

#### A. Customer Structural Grammar: OPEN_EDITORIAL_DEFAULT
- Photography and content hierarchy lead the presentation.
- Proximity, typography, and whitespace carry grouping before adding containers.
- Decision-critical content is visible early without artificial gating.
- Open, unboxed presentation for property description, amenities, and essential facts; separated by restrained dividers / subtle hairline-style separation (exact native stroke width remains OPEN / deferred to Phase 4I; 1px is controlled Web pilot rendering reference only).
- Bounded containers are strictly reserved for independent entities (`PropertyCard` in explore search results) or coherent financial decision units (booking price quote breakdown).
- Prohibits "card soup" and repetitive dashboard framing around hospitality content.

#### B. Owner Structural Grammar: OPERATIONAL_GROUPING_DEFAULT_WHEN_SEMANTIC
- Operational grouping is intentionally stronger than Customer.
- Connected operational records share a single container with subtle internal dividers (`OPEN_GROUPED_CONTENT`; exact native stroke width remains OPEN / deferred to Phase 4I; 1px in pilot is controlled Web rendering reference).
- Preferred over stacked independent cards to maximize scanability, action priority, state certainty, and compact useful density.
- Saves vertical screen real-estate and eliminates repetitive card border noise.
- Contained operational units are used only where grouping improves comprehension; does not turn Owner into a generic metric-card dashboard.

#### C. Admin Boundary: DESKTOP_WEB_PRESERVED
- Admin remains desktop operational Web (1440×900+).
- Phase 4E mobile structural grammar must not force mobile-card composition onto Admin tables, review queues, or detail panes (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).

#### D. Card Semantic Model
Cards are restricted semantic containers. Allowed strictly for:
- Independent discovery objects (e.g., `PropertyCard`).
- Multi-attribute booking objects where one complete record and action unit must be recognized.
- Coherent decision summaries where containment clarifies a financial decision.
*Prohibited:* Card per metric, card per fact, card per paragraph, nested cards, or card as default layout separator.

#### E. Shape Roles & Radius System
Semantic shape roles precede raw values:
- **`SHAPE_ACTION`:** Primary button radius is `6px` (`PROVISIONAL_PRIMARY_ONLY`; Phase 4C). Secondary button radius remains open.
- **`SHAPE_INPUT`:** Form and selection controls radius is `8px` (`PROVISIONAL_FIELD_SHAPED_ONLY`; Phase 4D).
- **`SHAPE_CONTAINER`:** Structural containers and cards radius evaluated as `12px` (`SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`). Controlled visual evidence across 6 Customer and Owner screenshots established that 10px is a valid close alternative, 12px is a balanced provisional system tie-breaker providing comfortable contour distinct from 6px buttons and 8px fields without generic rounded-SaaS bubbling, while 16px is materially rounder with higher generic-SaaS styling risk in repeated operational groups. Reversible implementation detail; native acceptance deferred to Phase 4I (`NO_MATERIAL_FOUNDER_DECISION_REQUIRED: YES`).
- **`OPEN_CONTENT`:** Has **NO ENCLOSING STRUCTURAL CONTAINER**. Content relationships are structured via typography, whitespace, and optional subtle dividers. It does not possess or require a container radius token. (If a literal flat-edged contained element exists, its geometry is governed by that component).
- **`SHAPE_INDICATOR`:** Status badges and chips. Exact geometry remains `OPEN_OR_COMPONENT_GOVERNED`.
- **`SHAPE_OVERLAY`:** Dialogs, bottom sheets, and floating app bars. Geometry deferred to Phase 4F.
*(Note: 6px → 8px → 12px is an EXPERT_HEURISTIC, not a self-validating mathematical proof).*

#### F. Elevation & Surface Hierarchy
- **Flat by Default:** Normal structural content is flat. Surfaces rely on spacing, background tone, and subtle neutral boundaries/dividers before shadows (exact native stroke width remains OPEN / deferred to Phase 4I; 1px is controlled Web pilot rendering reference only).
- **Canvas & Surface Reference:** Subtle neutral boundary on light-first canvas. Web pilot rendering reference values (`#FFFFFF` surface, `#E2E8F0` divider, `#F8FAFC` canvas) are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE` only; exact neutral tokens remain `OPEN`.
- **Elevation Roles:** Shadows are reserved strictly for floating/overlay layers where physical layering occurs (app bar on scroll, sticky decision bar, modal sheets). Exact elevation tokens and overlay geometry are deferred to Phase 4F.
- **Native Acceptance:** Physical mobile rendering and touch target acceptance are `DEFERRED_TO_4I`.

**Rules (CANONICAL NOW):**

- No card soup; no nested cards without a semantic reason. Prefer one primary separation cue for a relationship and avoid redundant decorative stacking; multiple signals may coexist when each communicates a distinct role or state, supports focus/contrast/accessibility, or follows platform elevation and overlay conventions.
- Every border/shadow/surface treatment communicates something real (grouping, elevation, interactivity, danger).
- Contained transient tasks use the presentation that best matches the task, platform and available window. A bottom sheet is one valid presentation on suitable compact contexts, not a universal KONFRM geometry. Platform-supported sheets, form sheets, popovers, dialogs, panes or full-screen presentations may be used when they better preserve context, usability or adaptivity.

**IMPLEMENTATION CANDIDATE:** exact radius family, border widths/colors, shadow/elevation values (web values are the strongest evidence base, validated per §29).
**DEFERRED:** dark-mode surface set.

## 15. Action Hierarchy

CANONICAL action classes, semantic meanings, and Mobile Phase 4C provisional mappings:

- **PRIMARY** — the one decision-critical valid action of the current state, when an active decision point has one.
  - *Canonical Semantic Meaning:* Primary advances the user's primary business or lifecycle intent for an active decision point.
  - *Mobile Phase 4C Provisional Mapping:* Stable Black (`#000000`), provisional 6px Primary-only radius (`PRIMARY_ONLY`), Cairo Profile B `15 / 700 / 1.20`.
  - *Governance Status:* **SYSTEM-VALIDATED PROVISIONAL** (exact component values are provisional candidates, not CANONICAL NOW final native tokens; native component and accessibility acceptance is deferred to Phase 4I).
- **SECONDARY** — subordinate alternatives or supporting actions.
  - *Canonical Semantic Meaning:* Subordinate non-destructive alternative or supporting action.
  - *Mobile Phase 4C Provisional Mapping:* Contextual / Hierarchy-Based Hybrid model. **Subtle Fill** is default provisional treatment; **Conditional Neutral Outline** is permitted strictly when Subtle Fill lacks sufficient boundary separation against container surfaces in actual context. Ghost is reserved for tertiary roles.
  - *Governance Status:* **SYSTEM-VALIDATED PROVISIONAL STRATEGY** (exact neutral token and secondary radius remain **OPEN / FUTURE GOVERNED DESIGN DECISION**).
- **TERTIARY** — low-emphasis auxiliary, detail-expansion, or navigation return actions.
  - *Visual Treatment:* Ghost / text-like (transparent fill, zero border). Button-shaped components retain Cairo Profile B `15 / 700 / 1.20` (never shrunken to 13–14px). Must remain discoverable; not valid for decision-critical actions.
- **CONTEXTUAL** — actions attached to the specific object, list row, or task they affect (e.g., row-level actions follow the row).
  - *Classification:* **Attachment relationship**, not an arbitrary visual style. Treatment follows semantic hierarchy (Primary, Secondary, Tertiary, or Destructive) within that object's context.
- **DESTRUCTIVE** — destructive, negative, removal, or consequence-bearing actions.
  - *Consequence-Aware Semantics:* Destructive is a **semantic consequence dimension**, evaluated by Consequence Level, Hierarchy Rank, and Discoverability (never determined by paired vs unpaired layout alone):
    - *Destructive Primary:* Permitted **only** within an explicit destructive confirmation context (dialog, sheet, modal, full-screen confirmation, or other platform-appropriate confirmation surface) where the confirmed destructive action is consciously verified and two-step confirmation is warranted per Product/UX authority.
    - *Destructive Secondary:* Visible subordinate destructive treatment (**Destructive Outline**) for paired rejection/discard actions or standalone destructive actions requiring clear danger affordance without a full confirmation modal.
    - *Destructive Tertiary / Ghost:* Permitted **only** for genuinely low-consequence, reversible, non-critical utilities where discoverability remains intact and Product Canon permits the capability.
    - *High-Consequence Prohibition:* High-consequence or material destructive actions must **never** be visually weakened into Ghost merely because they are unpaired.
    - *Confirmation Scope:* Confirmation is consequence-aware, not universal (routine destructive actions do not require two-step confirmation modals).
    - *Product Truth:* Destructive actions cannot invent capabilities; cancellation and refund policies remain strictly **`OPEN / UNDECIDED`** under Product and Financial Canon.

Rules:

1. Only valid canonical-state actions are shown (`UX-ACTION-01`); disabled actions communicate *why* when user understanding requires it. Recovery actions may temporarily become decision-primary when a canonical prerequisite fails.
2. **One clear primary action per active decision point:** Repeated independent decision units (such as separate Owner booking request cards in an operational list) may each contain their own Primary within the same viewport. Multiple Primaries must never compete for visual dominance within the same decision hierarchy.
3. Action placement follows the object/task it affects (contextual attachment).
4. Destructive confirmation uses the approved confirmation grammar according to context and consequence severity.
5. Actions respect touch-target and state-grammar rules (§21, §16).

## 16. State Grammar

A shared state grammar for every data surface. CANONICAL distinctions:

| State | Meaning | Never confused with |
|---|---|---|
| LOADING | request in flight, no content yet | ERROR, EMPTY |
| EMPTY | verified genuinely-no-content success | ERROR (UX-STATE-01: **error is not empty**) |
| ERROR | request failed; retry affordance | EMPTY, STALE |
| STALE | previously served content preserved while refresh failed | ERROR, fresh content presented as current |
| DISABLED | control intentionally unavailable, with reason where understanding requires | loading |
| SUCCESS | canonical operation completed | PENDING |
| PENDING | operation accepted, canonical outcome not yet resolved | SUCCESS |
| WARNING | genuine caution, copy-first, no boxed amber (§9) | SUCCESS |
| DESTRUCTIVE / FAILURE | destructive confirmation or failure consequence | SUCCESS |

Rules:

- **MISSING DATA ≠ ZERO.** A missing value is never rendered as a credible zero.
- **No raw backend error message is UI copy.** Feature layers map stable canonical error codes to localized product copy, with a safe fallback for unexpected errors (matches the Gate 3B error architecture).
- Status never relies on color alone — text label and/or icon + accessible name always accompany it (§21).
- Financial states remain server-authoritative; the client presents, never computes authority (Gate 3B).
- Each surface declares its full state set before implementation (screen-states discipline from `EXPERIENCE/SCREEN_STATES.md`).

## 17. Navigation Principles

CANONICAL principles (implementation lives in Gate 3B go_router decisions):

1. Navigation grammar is **role-specific** (UX-NAV-01): Customer bottom-tab destination model (4 roots visible by default, nested screens hidden by default, Screen 16 Notification Center as governed Account shell child exception retaining visible bottom nav with Account active per Master Rule MR-17); Owner dashboard-style operational model (no customer-style bottom nav); Admin out of scope (desktop web).
2. Screen-family consistency (UX-NAV-03): auth surfaces, top-level surfaces, nested entity surfaces, transactional surfaces, and terminal-result surfaces each follow one consistent header/transition grammar within their family.
3. Auth gates are driven by observable session state; protected context restoration after authentication is a product behavior, not a styling detail (Gate 3B session model).
4. Full-screen flows for identity-critical sequences (Auth V2); sheets for contained tasks; platform-appropriate presentation (§22).
5. Deep links: architecture-ready, rollout DEFERRED.

## 18. Forms / Inputs Principles

CANONICAL principles:

1. Every field has an explicit label; helper text explains consequence, not implementation.
2. Validation is mirror-of-server: client validation aids UX; the server remains authority. Canonical server error codes map to localized field-level messages.
3. Field-level error identification is text-associated (not color-only) and announced to assistive tech (§21).
4. Input keyboards/IME match content type (numeric fields isolate numeral runs per §12).
5. State grammar applies: loading/disabled/error states of controls are explicit; a disabled control communicates why when needed.
6. Destructive field actions (clear, discard) follow §15 destructive grammar.

**Phase 4D Form & Selection Primitives Synchronization:**

- **Field Visual Strategy:** **Outline-Led Field Baseline** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). Standalone fields utilize a white field surface with a thin neutral outline, providing clear boundary definition on light surfaces without floating labels.
- **Mobile Field Radius:** **8px** (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`). Applies strictly to mobile field-shaped Form & Selection controls (text input, phone container, email container, numeric/currency container, search container, multiline textarea, select/picker trigger when rendered as a field).
  - *Boundary:* Does **not** apply to Primary Button (which retains 6px `PRIMARY_ONLY` provisional radius), secondary buttons, icon buttons, checkboxes, toggles, chips, segmented controls, steppers, cards, rows, sheets, dialogs, overlays, or global container shapes.
  - *Semantic Differentiation:* Action / Primary Button = 6px; Data Entry / Field-Shaped Control = 8px. This is deliberate semantic differentiation.
- **Label / Helper / Error Hierarchy:** Explicit persistent top label (Cairo Profile B `label` 12/600/1.35), contextual helper copy (`supporting` 12/400/1.40), and field-associated textual error (text-identified, adjacent, announced, never color-only). Floating labels are not selected for mobile due to Arabic descender clipping and translation expansion.
- **Focus Direction:** **Semantic Restrained Interaction-Accent Emphasis** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). Restrained interaction accent provides obvious focus feedback without competing visually with the Stable Black Primary CTA. Web pilot references (`#276EF1`, 1px accent field border + 3px outer halo) are rendering references only.
- **Select / Picker Primitive Boundary:** Phase 4D defines field trigger and field semantics (label, placeholder, selected value, affordance, disabled/error states, RTL alignment). Overlay presentation containers (sheets, dialogs, dropdown lists) and navigation behavior are strictly `PHASE 4F AUTHORITY DEFERRED` (pilot overlays are composition references only).
- **Selection Controls:** Checkbox is `OWNER PRODUCT-EVIDENCED CONTROL` (notification preferences); Toggle is `DEFERRED / FUTURE BOUNDED CONTROL` (zero current canonical product evidence; no switch migration is manufactured).
- **Platform Touch Sizing:** iOS guidance: 44pt; Android guidance: 48dp. Interactive touch target bounds are decoupled from visible component geometry. No universal raw-pixel mobile target rule is canonized.
- **Open Variables / Native Validation:** Exact neutral hex, exact native stroke width, exact blue token candidate (`#276EF1`), exact focus ring/halo geometry, and exact native field heights remain `OPEN / IMPLEMENTATION CANDIDATE`. Native component and accessibility acceptance is strictly `DEFERRED TO PHASE 4I`.

## 19. Imagery

**Customer (CANONICAL NOW principles):**

- Real property imagery is **high-value product content**, not decoration; it may be prominent.
- Imagery relationships: image supports price/facts/state — never replaces them; facts remain readable while imagery loads.
- No-image handling is a designed state (placeholder that communicates absence truthfully), not a gray accident.
- Loading behavior must not shift layout; progressive presentation follows platform conventions.
- Exact aspect ratios/crop rules: **DEFERRED** unless existing approved product evidence requires a specific case (current property-card evidence is a candidate input, not a canon).

**Owner:** imagery identifies the property; it must not overpower operational status or actions.

**Anti-rules:** no stock/fake imagery, no decorative hero images unrelated to the listing, no imagery hiding missing data.

## 20. Motion / Feedback

**KONFRM motion philosophy (CANONICAL NOW — purpose classes, not numbers):**

1. **Motion must have a purpose** — one of: feedback, state change, spatial continuity, explanation, meaningful delight. Motion without one of these purposes does not ship.
2. **Frequency sensitivity:** frequent actions are fast/subtle or instant; rare moments may be richer.
3. **Motion never delays core work.** If an animation slows task completion, it is wrong regardless of beauty.
4. **Reduced motion:** a reduced-motion setting must retain full comprehension — purpose is preserved, expressiveness is reduced.
5. **Platform-native behavior matters:** system-standard transitions are the default; custom motion must outperform them to exist.
6. **Gesture-driven interactions remain interruptible and understandable** — no forced choreography.
7. **Avoid decorative perpetual motion** (loops, pulsing decoration).

**Feedback rules:** every action produces timely visible feedback; async operations surface explicit state-grammar states (§16); destructive actions confirm per §15.

**IMPLEMENTATION CANDIDATE / DEFERRED:** duration/curve/spring token tables. A later KONFRM Motion Skill may use external craft references (e.g., Emil Kowalski) — external motion skills do not govern Product Truth.

## 21. Accessibility

CANONICAL requirements (platform-appropriate mapping — Web WCAG numbers are not automatically native rules):

- **VoiceOver / TalkBack:** every interactive element has an accessible name; images have meaningful labels or are marked decorative; groupings announce as units where meaningful.
- **Logical traversal:** announced order matches visual/RTL reading order; isolated LTR runs remain coherent.
- **Scalable text:** the entire app must remain usable and unclipped at platform large-text settings (this is the mobile readability canon, replacing any fixed-pixel minimum claim).
- **Focus:** keyboard/external-keyboard focus is visible and logical; focus follows §20 reduced-motion rules.
- **Contrast:** text meets platform-appropriate contrast expectations in both default and scaled states; contrast is validated, not assumed from web values.
- **Status not color-only:** §16 rule applies to every status surface.
- **Touch targets:** controls meet **platform-appropriate accessible target sizing**; iOS and Android mappings follow platform guidance (iOS guidance: **44pt × 44pt**; Android guidance: **48dp × 48dp**). Interactive target bounds are separated from visible component geometry; compact or inline controls expand their hit areas to meet guidance without artificially inflating visible padding. No universal raw pixel dimension (e.g., 44px or 48px) is canonized as a native mobile rule. (Phase 4C Web evidence represents a controlled 360px Web frame-width simulation; native Flutter component and accessibility acceptance is strictly **DEFERRED TO PHASE 4I** — Web simulation evidence does not constitute iOS, Android, or Flutter native platform acceptance).
- **Reduced motion:** §20 rule 4.
- **Keyboard/IME:** content-type-correct keyboards; §18 rules.
- **Error identification:** field and form errors are text-identified and announced (§18).
- **Large-text reflow:** layouts must reflow without information loss or horizontal trapping.

## 22. iOS / Android Adaptation Matrix

**KONFRM cross-platform consistency means the SAME:** identity, product meaning, semantic hierarchy, state meaning, quality level, role priorities.

**NOT NECESSARILY SAME:** control presentation, navigation behavior, sheet/dialog behavior, back behavior, system icons, touch-target mapping, system transitions, typography adaptation, calendar/picker presentation.

| Pattern | Shared KONFRM intent | iOS adaptation principle | Android adaptation principle |
|---|---|---|---|
| Back navigation | When the current surface has a parent context, provide a predictable return path without losing safe work | Follow iOS navigation/back conventions, including appropriate system gestures/affordances when a parent context exists | Honor system Back / predictive Back when a parent context exists; do not invent a redundant in-app Back affordance at a root |
| Bottom navigation | Customer 4-destination model; state preserved | Tab bar conventions | Material navigation bar conventions |
| Sheets | Contained task presentation that preserves appropriate context | Use the appropriate iOS sheet, form-sheet, popover, or full-screen presentation for the task and window context | Use the appropriate Material bottom sheet, dialog, pane/side presentation, or full-screen pattern according to task and window/adaptive context |
| Dialogs | Decision confirmation, destructive separation | Alert conventions | Dialog conventions |
| Lists/rows | Grouped semantic rows, consistent action placement | iOS list styling | Material list styling |
| Pickers/calendars | Canonical date semantics | System date pickers | Material date pickers |
| Text scaling | Full reflow without loss | Dynamic Type maxima | fontScale maxima |
| Targets | Platform-appropriate accessible sizing | HIG minimums | Material touch minimums |
| Motion | Purpose classes (§20) | System transition feel | Material motion feel |

No Flutter implementation code is prescribed here.

## 23. Customer vs Owner Grammar

- **Customer grammar:** imagery-forward discovery; reassurance and clarity; hospitality tone; booking-lifecycle states; financial privacy (booking-relevant amounts only); generous but purposeful touch targets.
- **Owner grammar:** operational density permitted; action-first surfaces; property health and state visibility; business-language finance; faster, quieter presentation; server-authoritative status everywhere.
- The two apps **share** the foundation (this document) and packages; they do **not** share screen structures, flows, navigation graphs, or feature state.
- Admin: Web-only; shares brand lineage and status grammar concepts — no Flutter Admin system is defined by DF2.

## 24. External Reference & Skill Policy

External design systems, reference implementations, and AI "Skills" are **specialist references — never canonical KONFRM authority.** Examples (non-exhaustive): Uber Base, Material, Apple HIG, Carbon, Impeccable, Emil Kowalski motion skills, Taste skill, future skills.sh skills.

Future classification vocabulary for any external artifact: **ADOPT / ADAPT / WRAP / SANDBOX / REJECT.**

Intended specialist roles (candidates only, not installed or integrated by DF2):

- **Impeccable:** QA / critique / hardening candidate.
- **Emil Kowalski skills:** motion / interaction craft candidate.
- **Taste:** creative ideation / visual exploration candidate.

Where an external reference conflicts with KONFRM Canon, **KONFRM Canon wins.** Adoption of any external skill follows the same chain as any token: propose → central approval → central documentation → version → consumption.

## 25. Anti-Patterns

Hard prohibitions (each violation is a defect regardless of visual appeal):

1. Generic AI UI aesthetics.
2. Card soup; nested cards without semantic reason.
3. Tiny text used to force density; text below validated mobile readability.
4. Giant empty hero space or fake premium whitespace in product UI.
5. Excessive pills/chips; decorative badges.
6. Gradients without purpose; fake glass; glow; excessive/exaggerated shadows.
7. Random accent colors; every-color-at-once surfaces.
8. Copied fintech-dashboard language; fake KPIs.
9. Fake reviews, fake ratings, fake scarcity, fake trust badges, decorative alerts/status cards.
10. Unnecessary modalization of simple flows.
11. Web UI ported unchanged to native; platform-inappropriate navigation.
12. Unjustified hardcoded physical left/right in direction-relative RTL product layout.
13. Identical Customer and Owner layouts for consistency's sake.
14. Yellow/amber/orange boxed containers (§9).
15. Motion that delays work or loops decoratively.
16. Raw backend error strings as UI copy.
17. Missing-value-as-zero.
18. Any element that does not earn its place.

## 26. CANONICAL NOW

1. North Star: Trust / Clarity / Vitality; dense-by-purpose formulation (§3–§5).
2. Authority hierarchy (§2) and governance chain (§24).
3. Mobile brand identity is monochrome-first (Black/White); identity and interaction color are intentionally separated; a restrained blue interaction-accent role is canonical while the preferred value `#276EF1` remains an IMPLEMENTATION CANDIDATE; Summer Yellow is removed from the core mobile brand architecture; identity/interaction/status/surface/imagery remain separate; light-first surfaces remain canonical; no yellow/amber/orange boxed UI.
4. Arabic-first RTL as foundation-level concern; semantic start/end; isolated LTR runs; direction-aware icons; no "mirror everything".
5. **Western Arabic numerals by default; money example `1,600 ج.م`; date/calendar localization remains separate.**
6. Truth-first state grammar: ERROR ≠ EMPTY, STALE ≠ ERROR, PENDING ≠ SUCCESS, MISSING ≠ ZERO; no raw backend message as UI copy; status never color-only; financial states server-authoritative.
7. Action hierarchy (PRIMARY/SECONDARY/TERTIARY/CONTEXTUAL/DESTRUCTIVE) with its rules.
8. Role psychology and role-specific grammar: Customer hospitality/discovery vs Owner operational control; Admin stays Web.
9. Platform-adaptive intent: same identity/meaning/hierarchy/quality; platform-different presentation (§22 matrix).
10. Spacing-as-relationship, whitespace-must-earn-its-place, surface roles before values, no card soup.
11. Motion purpose classes and reduced-motion comprehension (§20).
12. Imagery truth principles (§19).
13. External references/Skills are subordinate to Canon (§24).
14. Anti-patterns (§25).
15. The decision-classification discipline itself (§26–§28).
16. RTL Back (arrow right [➔]) vs Close (X / Cancel) semantic distinction (§17).
17. Dual bottom chrome prohibition: persistent bottom navigation and sticky action surfaces are mutually exclusive (§17).
18. Owner mobile architecture lock: Action-First Operational Hub with nested routing; Customer-style bottom navigation is prohibited (§17).
19. Safe-area separation contract: page insets != platform safe areas != persistent control clearance (§17).

## 27. IMPLEMENTATION CANDIDATES

1. Exact mobile typography scale per role (§10) — validated for Arabic legibility, scaling, and screens.
2. Exact spacing scale and insets (§13) — evaluated provisional scale 4/8/12/16/24/32 and 16px page insets recorded in §13.
3. Exact radius/border/shadow/elevation values per surface role (§14) — 12px structural-container radius evaluated as provisional candidate in §14; overlay/sheet radii deferred to Phase 4F.
4. Exact semantic color role values and the restrained interaction-accent value (`#276EF1`) validated in component contexts beyond the locked brand facts (§9); exact neutral/ink palette values (no UI-black invented in DF2).
5. **Transport-independent design-token delivery**: the existing generated-token pipeline concept (`TOKENS/*.json` → generated consumer artifacts) is an implementation candidate for mobile, with all mobile values validated before canonicalization.
6. Exact state-surface compositions (skeletons, empty/error art) per state grammar (§16).
7. Native Flutter typography acceptance of Cairo Profile B — deferred to Phase 4I.
8. Field/control exact native dimensions, neutral border hex, stroke width, and native focus treatments (§18, §21) — provisional 8px field radius, outline-led baseline, and restrained interaction-accent focus direction recorded in §18.
9. Overlay surface radii: Mobile BottomSheet top radius 16px (`SYSTEM-EVALUATED PROVISIONAL`) and Dialog surface radius 12px (`SYSTEM-EVALUATED PROVISIONAL`) recorded in §14.
10. Customer 4-tab top-level bottom navigation destinations (Explore, Favorites, Bookings, Account; Screen 16 Notification Center governed Account shell child exception per Master Rule MR-17) and Owner 3-column operational domain grid recorded in §17.

## 28. DEFERRED / OPEN

1. Dark mode (light-first identity is strong evidence; full support is an open product decision).
2. Android Dynamic Color policy.
3. Final image ratios/crop rules (unless a specific approved case exists).
4. Detailed motion token tables (ms/curves/springs).
5. Final date/calendar localization conventions (beyond §12).
6. Exact platform component mappings requiring prototypes/device validation.
7. Icon family for mobile (Lucide-family strategy open; §24 governs).
8. Dark-surface special products (none planned; none authorized).
9. Admin mobile anything (Admin remains Web).
10. Exact overlay shadow parameters, blur values, and scrim opacity/RGBA values (§14).
11. Native mobile detent behaviors, gestures, and native safe-area implementation (§17, Phase 4I).

## 29. Validation Required Before Token Canonicalization

Before any DF2 candidate value becomes a canonical mobile token, it must pass:

1. **Arabic legibility validation** on real devices (Cairo rendering, RTL reading, minimum comfortable sizes at default and large text scaling).
2. **Scaling reflow validation** (largest platform text settings; no information loss, no clipping, no horizontal trapping).
3. **Contrast validation** in the actual surfaces where tokens apply (text/borders/status), platform-appropriate.
4. **Touch-target validation** per platform mapping on real devices.
5. **Reduced-motion comprehension validation.**
6. **Performance sanity** (typography/imagery/motion choices do not degrade target devices).
7. **Governance chain completion** (§2): propose → approval → central documentation/token → version → consumption, recorded in CHANGELOG/DECISIONS as applicable.
8. **Visual QA capture set** per the existing shell-contract viewports (360×800, 390×844, 430×932 plus constrained-height states) as baseline evidence, extended by real-device checks.

## 30. Inputs to Canonical Mobile Primitives

When canonical mobile primitives are later specified, they consume as inputs:

1. This document's role families and classified decisions.
2. `TOKENS/*.json` semantic relationships (as evidence and starting candidates — not as auto-approved numbers).
3. `IMPLEMENTATION/mobile.md` shell contract (baseline viewport, max width, safe areas, sheet behavior, target guidance, QA viewports).
4. `COMPONENTS/*.md` contracts as semantic behavior specs (buttons, inputs, cards, badges, alerts, modals, bottom-sheets, navigation, states).
5. `EXPERIENCE/DECISIONS.json` approved items (action hierarchy, navigation, entry, state, visibility, color rules).
6. Newer Customer surfaces (Auth V2, Screens 16–18) as the cleanest implemented expression of current KONFRM intent.
7. DF1-B forensic findings (§5 drift patterns to avoid; §14 strengths to preserve).
8. Founder North Star and Telda reference intent (§3, §24 — inspiration only).

## 31. Non-Goals

DF2 does not: initialize Flutter or `mobile/`; implement components or tokens in code; create or install Skills; finalize dark mode or dynamic color; choose icon families or payment providers; migrate legacy web UI; decide Pilot scope; redesign Admin; alter backend/business rules; or claim pixel-level Base Gallery conformance.
