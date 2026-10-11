# KONFRM — Unified Bridge × UI/UX Design Playbook

**Version:** 1.0.1 — 2026-10-12  
**Purpose:** A founder-facing, reusable design decision and inspection playbook. It supplements, and never replaces, the canonical KONFRM product/business/architecture rules.  
**Authority:** New explicit Founder decisions > existing approved project canon > verified implementation reality > external design skills.  
**Status:** Founder-authorized repository preservation (2026-10-12). Advisory research synthesis; NOT product canon, a design-system release, or implementation authorization.

## 1. Scope and honest limitations

This document is based on actual inspection of the seven GitHub repositories identified below, including their README and targeted SKILL.md references, and on KONFRM's uploaded Master Rules, Quality Gates and UI QA Protocol. These repositories include many more modules than can be exhaustively inspected in one pass: the techniques below are a **targeted extraction**, not a claim to have run, installed, or comprehensively read every command in all repositories. External Agent Skills are working guides; they are not independently verified evidence of runtime correctness.

The Bridge combines Product/UX strategy, interaction design, visual direction, interface critique, design system governance, engineering handoff, and factual QA. **Antigravity remains the code execution and device-testing agent**, operating under permission gates. The Founder remains the approval authority. Do not send work back to a separate Design Lab unless the Founder explicitly asks.

## 2. External knowledge — what to actually use

| Source | Targeted references inspected | Transferable principle | Application at KONFRM | Non-transferable assumption |
|---|---|---|---|---|
| [emilkowalski/skills](https://github.com/emilkowalski/skills) | [emil-design-eng](https://github.com/emilkowalski/skills/blob/main/skills/emil-design-eng/SKILL.md), [break-ui](https://github.com/emilkowalski/skills/blob/main/skills/break-ui/SKILL.md), [animate](https://github.com/emilkowalski/skills/blob/main/skills/animate/SKILL.md) | Most UI quality lies in micro-decisions; motion requires functional purpose; attack UI with realistic boundary cases | Region Sheet entry/exit, card press feedback, long village/region names, asset failure, 200% scale | Web/CSS easing snippets are **not** ready-to-use Flutter code; React Native/Expo instructions aren't Flutter instructions |
| [ConardLi/garden-skills](https://github.com/ConardLi/garden-skills) | [web-design-engineer](https://github.com/ConardLi/garden-skills/blob/main/skills/web-design-engineer/SKILL.md) and catalog | Gather brand/project reality first; declare a style system; build a v0; evaluate actual render; design-dial calibration | Strong high-fidelity visual compositions and iterative prototypes reviewed at 360/390/430 | Landing-page style recipes must not overwrite the official KONFRM design foundation |
| [elayadesign/ai-design-skills](https://github.com/elayadesign/ai-design-skills) | [landing-page-design](https://github.com/elayadesign/ai-design-skills/blob/main/skills/landing-page-design/SKILL.md) | Map one audience's problem, decision and primary action before visual treatment | Evaluate Owner invitation/onboarding, Admin operational screens and any KONFRM public landing page | Marketing hero, testimonials and conversion-landing sections are **not** requirements for Customer Explore |
| [MengTo/Skills](https://github.com/MengTo/Skills) | [design-first-ui-prompting](https://github.com/MengTo/Skills/blob/main/agent-skills/ui/design-first-ui-prompting/SKILL.md), [no-ai-design-slop](https://github.com/MengTo/Skills/blob/main/agent-skills/ui/no-ai-design-slop/SKILL.md) | Prompt against constraints, exact copy and visual rhythm; change only one/two variables per iteration; delete generic UI with no job | Lock Concept A and iterate Search only; avoid gratuitous card soup, badges, decorative hero, meaningless nav | Generative imagery's typographic text isn't trustworthy; use exact RTL text in renderer/native |
| [jakubkrehel/skills](https://github.com/jakubkrehel/skills) | [better-interface](https://github.com/jakubkrehel/skills/blob/main/skills/better-interface/SKILL.md), [interface-review](https://github.com/jakubkrehel/skills/blob/main/skills/interface-review/SKILL.md) and catalog | Audit accessibility → layout → copy → typography → color → polish; severity by actual task impact; classify PR regressions | Bridge review of component design and changed behavior; missing error recovery is high impact; distinguish introduced/pre-existing | A passing WCAG check or source diff isn't a substitute for actual native interaction/visual QA |
| [codeswithroh/tastemaker](https://github.com/codeswithroh/tastemaker) | [tastemaker](https://github.com/codeswithroh/tastemaker/blob/main/skills/tastemaker/SKILL.md), README | Extract reference DNA from pixels; preserve decisions; contrast checker; avoid inventing brand every session | Reuse approved B/W geometric identity + Cairo + premium property photography, record accepted vs rejected UI decisions | Random generated brand palette must NEVER replace locked KONFRM tokens; do not copy copyrighted composition/assets |
| [Owl-Listener/designer-skills](https://github.com/Owl-Listener/designer-skills) | [search-ux](https://github.com/Owl-Listener/designer-skills/blob/main/interaction-design/skills/search-ux/SKILL.md), [critique-information-density](https://github.com/Owl-Listener/designer-skills/blob/main/visual-critique/skills/critique-information-density/SKILL.md), [critique-visual-hierarchy](https://github.com/Owl-Listener/designer-skills/blob/main/visual-critique/skills/critique-visual-hierarchy/SKILL.md), broader design-practice index | Critique hierarchy, affordance, scan patterns, cognitive load, recovery; map states and prepare structured design-engineering handoff | Explore's first-fold property imagery, optional region filtering, Property Details price decision, Admin operational clarity | Generic free-text search/autocomplete advice conflicts with approved tap-to-region-select; reject it here |

**Strict adaptation rule:** Extract decision criteria and testing methods from external sources, not arbitrary style presets or code that conflicts with Flutter, Cairo, approved Brand, Accessibility or Business Rules.

## 3. KONFRM taste lock — already decided

**Product:** Trustworthy Arabic-first vacation rental marketplace (short stays), with distinct Customer, Owner, Admin user goals.

**Visual thesis:** Premium Hospitality Editorial — contemporary, credible, warm, high-density in useful information, property-photography-led; calm monochrome base with restrained blue interactive states.

- Brand: Founder-supplied new geometric KONFRM symbol, no geometry edits; black on white / white on black.
- Typography: Cairo in runtime; offline Noto Sans Arabic mockups are visual studies, **not** type parity evidence.
- Customer navigation: exactly four root tabs `استكشف / المفضلة / حجوزاتي / الحساب`.
- No large marketing hero, giant welcome/greeting, redundant account/favorite header icons, decorative avatar, repeated chips, or numerous empty nested cards.
- No fabricated verification badge, ratings, reviews, sale urgency, guaranteed authenticity, occupancy, pricing or availability.
- No fake owner communication action, immediate payment, local final booking total, or quietly changed financial rules.
- First Customer viewport prioritizes real accommodation imagery and decision facts, **not** a tall default filter form.
- Do not transplant marketing landing-page prescriptions onto the functional mobile Explore page.

### Founder decisions — Screen 03 / Search

- `CONCEPT_A = FOUNDER_SELECTED` and Search Bar visual direction approved; final runtime visual acceptance remains an independent gate.
- Single, familiar, light Search Bar labeled `اختار المنطقة`. It is a **button**, not a free-text input; on tap open Region Multi-Select Bottom Sheet, no keyboard.
- Region names only; no thumbnails, villages as search choices or unit-type chips.
- Regions are available only with >=1 public listing eligible to be discovered, independently from requested stay dates.
- `selectedRegions = []` means display ALL eligible public stays. `selectedRegions = [A,B]` means canonical membership in A OR B, deduplicated by property identity.
- Confirmed vs draft selection are separate. Cancel/Close discards draft without changing Explore. Apply empty selection explicitly removes region filter and shows all eligible stays.
- Clear-all action must be explicit and explain what will happen; avoid an ambiguous X. A left chevron that looks like Back should be removed or replaced with a clear dropdown affordance.
- A region becoming ineligible cannot be silently retained as a valid filter or silently discarded; show a correction state.
- No misleading fallback to all inventory after a filtered zero-results response.
- Canonical region IDs, region-options endpoint, and exact region-only backend membership remain **unverified engineering dependencies**, not a license to fake frontend filtering.

### Founder decisions — Screen 06 / Details

- Rich edge-to-edge gallery, title, public village/region, base nightly price, key guests/rooms/baths, real amenities only.
- Inline month availability calendar, date range and guest selection, stateful quote with BACKEND-AUTHORITATIVE total, sticky context-aware booking-review CTA.
- Booking request follows owner approval. Never change status/commission/deposit assumptions based on visuals; unapproved lifecycle changes require Founder decision.
- Hide root bottom tab bar inside Screen 06.

## 4. Independent mental model by role

| Role | Primary question | Design priority | Must not be hidden by polish |
|---|---|---|---|
| Customer | "هل المكان يناسبني فعلًا؟ وما الذي سأدفعه وكيف أحجز بأمان؟" | Photos, accurate location, base nightly price, sleeping capacity, availability and clear owner-approval status | Material quote difference, booking stage, recovery from errors, honesty about unavailable data |
| Owner | "ما المطلوب مني الآن؟ وهل التسعير والطلبات تحت سيطرتي؟" | Actionable booking requests, status clarity, pricing calendar, reliable confirmations, low administrative effort | Financial overrides, approval consequences, owner decision controls, duplicate-action prevention |
| Admin | "ما الذي يحتاج تدخلي؟ وما المخاطرة والأولوية والتاريخ؟" | Information density, triage queues, auditability, evidence, operational actions and clear safeguards | Legal/identity verification evidence, permission boundaries, irreversible actions |

## 5. Unified design execution protocol (Bridge + Lab)

1. **Reconstruct truth:** exact Founder task, role, current approved decisions, API/DTO reality, existing screenshots, viewport and canonical design tokens.
2. **State screen purpose:** primary user question and action, first-fold objective, success/failure/recovery.
3. **Extract visual reference DNA:** photo crop, density, content hierarchy, rhythm, interaction affordances, light/dark and material logic. Do not copy layouts/assets wholesale.
4. **Define a design intent in one sentence:** what will become easi