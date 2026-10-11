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
4. **Define a design intent in one sentence:** what will become easier, clearer, or more trustworthy for this role.
5. **Present genuine visual evidence first:** at native dimensions; use a prototype, design artifact or exported screenshots. No pseudo-screen passed as real. Tag illustrative prices/locations/photo inventory outside the consumer UI.
6. **Critique before founder review:** hierarchy, affordances, density, copy, typography, colors, responsiveness, accessibility, trust and states.
7. **Use constraints, not arbitrary variation:** preserve selected Concept A; refine only the authorized component; remove elements with no informational or interaction job.
8. **Founder visual approval:** distinguish selection of a direction from final screen acceptance. No runtime implementation until specifically authorized.
9. **Engineering contract:** Antigravity receives precise file-level scope, canonical product rules, acceptance criteria and explicit forbidden changes; split Backend region contract from Flutter UI work if necessary.
10. **Verification:** Flutter analyze/tests; manual Android A56 real device; screenshots at 360×800, 390×844, 430×932; screen readers/text scale/states; no fake fallback; verify same build/commit and live flow where appropriate.
11. **Independent review:** PR diff and code checks, runtime evidence, root cause/fix/retest of actual defect. CI green is not visual proof. No merge/deploy without Founder approval.
12. **Keep/reject register:** record Founder-approved decisions and rationale in canonical project docs only with permission; temporary playbook is advisory.

## 6. Native-specific acceptance gates

### Layout, copy, accessibility

- Use actual Cairo typography in Flutter and inspect RTL mixed numbers/currency/date formatting.
- Verify 360/390/430 mobile viewports and 200% scale where reasonable. Check non-clipped buttons, tappable controls, long bilingual property titles, absent village names, failed images, price precision, and very large guest counts.
- Touch targets, focus order and spoken semantic names for search control, checkbox, favorite and close actions.
- Bottom Sheet: drag / system back / explicit Cancel must preserve the confirmed state; Apply must be enabled for empty selection under the approved zero-region rule.
- User feedback: distinguish loading, offline, failed request, no eligible regions, zero matching stays, previously selected now-ineligible region and retry. Do not disguise error as empty.

### Motion quality

- Ask first whether motion helps orientation/feedback. Short, interruptible transitions for Bottom Sheet/pressed state; no theatrical animation for frequent actions.
- Avoid motion causing shifted content while user reads; honor reduced-motion settings and maintain static state cues.
- Adapt design intent to Flutter's own animation/gesture semantics instead of copying CSS code or Expo-specific libraries.

### Runtime truth

- Build API-connected QA APK using approved, existing `KONFRM_API_BASE_URL` configuration, not hardcoded fictitious public data or exposed secrets.
- Preview/demo images are NOT proof of live inventory; validate photo loading against actual published public property data.
- Test empty region list vs empty active filter vs no matches; these represent **three different states**.
- Confirm state changes and prices with real backend response. Never treat an unverified API response as business-rule authority.

## 7. PR #114 — separate Android brand fix (historical QA snapshot; merged 2026-10-12)

- [PR #114](https://github.com/Essxm01/KONFRM/pull/114) candidate HEAD: `dd9f3fb2fd5690aefae689b96a8641bc090202fb`.
- At pre-merge inspection: OPEN / DRAFT, base main `6a08f064b9288b17bdb12667e6385a72d58de76e`, mergeable CLEAN, 10 successful checks and 4 scope-based skips, no failed/pending checks. **Subsequent independent GitHub verification:** PR #114 MERGED; merge commit and new main `05270c5fb3fa4970d0e2f7ca6e4b99444f405096`.
- Founder-provided Samsung A56 screenshots show corrected launcher and white splash icon without clipping. Antigravity separately reports Dark Mode cold-start transition PASS and no code changes. Frame numbering in Antigravity's text table has an internal typo/ordering anomaly (`106–089`), so don't claim Bridge independently reproduced frame-by-frame video validation.
- Known separate runtime dependency: `DISCOVERY_RUNTIME_QA = BLOCKED_BY_CONFIGURATION` on test APK built without required `--dart-define`. Not a reason to change Android icon scope.
- Founder authorized ordinary merge; Bridge performed and independently verified merge commit `05270c5fb3fa4970d0e2f7ca6e4b99444f405096`. No manual production deployment was authorized or performed under this playbook.

## 8. Open work queue — protect sequence

1. PR #114 is merged and verified; keep Android brand correction closed. Separately resolve the configured Customer Flutter QA API endpoint before claiming live property discovery works.
2. Bridge now owns Design Lab responsibilities: assess and finalize existing Screen 03 Search Bar / Region Selector; no more external Design Lab handoff by default.
3. Design Screen 06 Property Details within chosen Concept A, create high-fidelity native-dimension visual artifacts before coding.
4. Separately analyze a canonical Region-only backend contract (IDs, eligible options, OR union, caching/ineligibility, backward compatibility) before Flutter implementation.
5. Keep product, design, tests, mobile realities, and PR review as separate signoff gates.

**This document is a working knowledge artifact, not a replacement for product canon or evidence of installation/execution of the GitHub skills.**
