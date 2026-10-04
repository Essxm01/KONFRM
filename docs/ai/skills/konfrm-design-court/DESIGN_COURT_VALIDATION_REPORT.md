# Design Court — Historical Validation Report (Non-Mutating Replay)

> [!IMPORTANT]
> **GOVERNANCE NOTICE: HISTORICAL_NON_MUTATING_REPLAY**
> This document is test evidence validating that the Design Court v1 protocol functions properly.
> It does **NOT** reopen the closed Phase 4D task, does **NOT** mutate KONFRM Design Canon, and does **NOT** re-litigate the Founder's binding decision (8px mobile field radius).

---

## KONFRM DESIGN COURT — VERDICT (REPLAY)

**CASE_ID:** `HISTORICAL_REPLAY_PHASE_4D_FIELD_RADIUS`  
**QUESTION:** 6px vs 8px Mobile Field Radius for Form & Selection Primitives  
**MODE:** `FAST_PANEL`  
**DELIBERATION_TOPOLOGY:** `SINGLE_AGENT_STRUCTURED_PANEL`  
**ROLE / SURFACE:** Customer & Owner Mobile data-entry fields (Future Native Mobile Flutter target simulation reference)  

**OPTIONS:**
- **Option A (6px):** Exact geometric match with Primary Button (6px `PRIMARY_ONLY` provisional candidate). Strict geometric unity across action and data entry.
- **Option B (8px):** Subtle 2px curve softening for taller controlled Web pilot input containers (48px pilot geometry). Semantic differentiation: Action = 6px, Data Entry = 8px.

**KNOWN_CANON / PROVISIONAL CONTEXT:**
- Monochrome-first brand direction (Black/White).
- Primary Button provisional radius: 6px (`PRIMARY_ONLY` provisional candidate).
- Field Strategy: Outline-Led baseline with white field surface on light-first surfaces (structural grouping deferred to Phase 4E). Note: Border color `#8E8E93` (~3.26:1 contrast) is classified as `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE_ONLY`; exact native Neutrals remain `OPEN`.
- Container Geometry: Input height of 48px is classified as `CONTROLLED_WEB_PILOT_GEOMETRY`; exact native field height remains `OPEN / DEFERRED TO 4I`.
- Arabic-first RTL native layout with logical start/end and Western Arabic digits (`0–9`).
- Founder Authority: Founder binding decision is 8px mobile field radius (published in Phase 4D, PR #92).

**HARD_GATE_RESULT:**
- Option A (6px): **PASS** (Zero Business Canon, Product Truth, financial, security, or accessibility violations).
- Option B (8px): **PASS** (Zero Business Canon, Product Truth, financial, security, or accessibility violations).

---

### Specialist Consultation & Attribution Ledger

| Skill | Status | Consultation Source | Source Anchor | Applied Principle | Position | Evidence / Rationale | Confidence | Limitation |
|---|---|---|---|---|---|---|---|---|
| `konfrm-product-ux` | `CONSULTED` | `docs/ai/skills/konfrm-product-ux/SKILL.md` | §1 Role-Specific UX Mandates | Customer interfaces require calm, high-confidence transaction paths and booking clarity; Owner dashboards require operational certainty and high information density. | Option B (8px) lean | Role-lens inference: 8px subtly differentiates editable data-entry fields from 6px action triggers without reducing touch comfort or scan speed (classified as `EXPERT_HEURISTIC / ROLE-LENS INFERENCE`, not Product Truth or Canon). | MEDIUM | Focuses on role cognitive clarity and error prevention; Product UX Canon does not specify corner radii. |
| `konfrm-mobile-design` | `CONSULTED` | `docs/ai/skills/konfrm-mobile-design/SKILL.md` | §3 Subordinating External Numeric Heuristics & Decision Status Bands | Platform-specific touch-target guidance must not be flattened into one universal raw-pixel rule; exact visual dimensions and component geometry remain governed by validated component decisions and native acceptance. | NO_PLATFORM_OBJECTION / NO_RADIUS_PREFERENCE | Neither 6px nor 8px violates platform touch-target conventions (Apple HIG ~44pt, Android Material ~48dp); physical touch bounds are separate from visual corner radius; native mobile acceptance remains deferred to Phase 4I. | HIGH | Evaluates platform ergonomic constraints, not aesthetic container curvature preference. |
| `konfrm-accessibility` | `CONSULTED` | `docs/ai/skills/konfrm-accessibility/SKILL.md` | §1 Contrast Ratios & Legibility Framework & §2 Touch Targets | Web WCAG 2.2 AA baseline requires 3.0:1 non-text component boundary contrast; visual bounds and hit regions are distinct; native acceptance is evaluated separately. | NO_PREFERENCE (Equally Valid) | Both 6px and 8px preserve full interactive hit bounds and non-text outline contrast; no material radius-dependent accessibility difference was identified in the available controlled Web evidence; native acceptance deferred to Phase 4I. | HIGH | Evaluates statutory and platform accessibility conformance; corner curvature preference is non-accessible aesthetic choice. |
| `konfrm-rtl-arabic` | `CONSULTED` | `docs/ai/skills/konfrm-rtl-arabic/SKILL.md` | §1 Core Foundations: Arabic-First & RTL-Native & §3 Typography | Interfaces engineer logical start/end semantics and natural Arabic baseline flow without blind mirroring; Cairo Profile B scale is provisional foundation. | NO_PREFERENCE (Equally Valid) | Both radii preserve symmetrical logical start/end padding and Arabic baseline reading flow; corner curvature has zero material impact on Arabic Bidi isolation or script rendering. | HIGH | Language typography and directional flow are independent of subtle corner curvature. |
| `konfrm-visual-qa` | `CONSULTED` | `docs/ai/skills/konfrm-visual-qa/SKILL.md` | Core Tenet (CI GREEN != VISUAL QA PASSED) & §1 Initial QA Reference Matrix | Unit tests do not verify optical rendering; UI implementations require explicit visual inspection across relevant viewports, applicable component states, and optical checklists. | EVALUATED_BOTH (Zero Visual Defects) | Controlled Web screenshot inspection of `input_radius_6px_owner.png` and `input_radius_8px_owner.png` at 100% scale confirmed crisp 1px border rendering, zero antialiasing artifacts, and preserved CTA dominance under both candidates. | HIGH | Web canvas screenshot evidence; native Flutter rasterizer deferred to Phase 4I. |
| `ui-ux-pro-max-wrapper` | `NOT_CONSULTED` | — | — | — | — | Suppressed by Router: local radius choice resolved by internal skills without catalog lookup. | — | — |
| `emil-wrapper` | `NOT_CONSULTED` | — | — | — | — | Suppressed: static field geometry does not involve gestural springs or physical motion. | — | — |
| `vercel-web-guidelines-wrapper` | `NOT_CONSULTED` | — | — | — | — | Excluded: mobile primitive evaluation; web-only wrapper prohibited from native mobile architecture. | — | — |

*Attribution check: 5 internal skills consulted with verified source files, anchors, and principles; 3 external wrappers not consulted (zero fabricated positions or votes).*

---

### Round 1 — Sealed Independent Briefs (Summary)
- **Product UX Counsel:** Leans Option B (8px). Reason: subtle affordance cue between actionable button (6px) and data-entry field (8px) within calm transaction paths. Risk: slight token proliferation. Classification: `EXPERT_HEURISTIC / ROLE-LENS INFERENCE`. Confidence: MEDIUM.
- **Visual Systems Director:** Leans Option B (8px) with strong respect for Option A (6px). Reason: 8px visually softens the taller 48px box while retaining discipline; 6px remains a viable strict architectural alternative. Classification: `EXPERT_HEURISTIC`. Confidence: MEDIUM.
- **Platform & Accessibility Counsel (Mobile Design & Accessibility):** Neutral / No Platform Objection. Both candidates meet touch target standards, preserve contrast boundaries, and leave native acceptance to Phase 4I. Confidence: HIGH.

---

### Round 2 & 3 — Adversarial Hearing & Cross-Examination

#### Original Idea Defender (Championing 6px Button-Parity Baseline)
- *Position:* "KONFRM is an architectural, disciplined brand. Sharing 6px across buttons and inputs creates absolute geometric harmony and prevents arbitrary radius drift."
- *Objection to 8px:* "Introducing 8px for fields creates two close radius tokens (6px vs 8px) that may look like an accidental inconsistency rather than deliberate design to casual observers."

#### Challenger (Championing 8px Softened Candidate)
- *Position:* "The 48px Web pilot field geometry visually presents a larger field-shaped surface than the Primary action geometry. A 6px corner on a larger input container feels austere and boxed-in. 8px provides optical softening appropriate to container height."
- *Rebuttal to Defender:* "The differentiation is semantic, not accidental: buttons trigger state changes (sharp, decisive 6px), whereas inputs invite text entry (open, welcoming 8px)."

---

### Round 4 — Synthetic Persona Hearing

> [!NOTE]
> `SYNTHETIC_ROLE_LENS` evaluation only — NOT empirical user research.

- **`TRUST_SENSITIVE_FIRST_TIME_CUSTOMER` Lens:**
  - *Immediate Understanding:* Both fields are instantly recognizable as inputs due to crisp outline (tested at #8E8E93 web pilot reference) and explicit top labels.
  - *Perceptual Distinction:* The 8px curve subtly conveys a slightly softer, more approachable booking inquiry flow compared to the austere 6px.
  - *Risk / Mistake:* No radius-dependent error mechanism was identified by this synthetic role lens; no empirical error-rate claim is made.
- **`OPERATIONAL_OWNER` Lens:**
  - *Immediate Understanding:* High-density property creation form is legible in both treatments.
  - *Perceptual Distinction:* 6px feels slightly more technical and spreadsheet-like; 8px feels modern without sacrificing data density. Neither impedes rapid scanning.

---

### Round 5 — Red Team (Visual QA Prosecutor)
- **Baseline Radius Inspection (100% Scale):** Inspected `input_radius_6px_owner.png` and `input_radius_8px_owner.png` (controlled Web rendering at 100%).
  - Geometry & contour: 6px matches button geometry exactly; 8px provides subtle optical softening for the taller field-shaped container.
  - Border rendering: 1px outline renders crisply on both candidates without clipping or border aliasing.
  - Visual hierarchy & CTA relationship: Under 8px, the field does not visually compete with the 6px `#000000` Primary button; CTA dominance is preserved.
- **200% Text-Scale Stress Evidence:** Inspected `stress_text_scale_200.png`.
  - True 200% text-scale stress is recorded in `stress_text_scale_200.png`, but this artifact evaluates system text reflow, not a 6px-vs-8px A/B radius comparison.
  - `CROSS_RADIUS_200_PERCENT_EQUIVALENCE:` **NOT_TESTED** (cross-radius scaling equivalence was not tested in the pilot; no comparative error-wrapping or label-reflow claims between 6px and 8px at 200% are made).
- **Red Team Verdict:** No fatal flaws in either candidate. Both options are structurally sound.

---

### Round 6 — Multi-Criteria Deliberation & Anti-Bias Check

- **Criteria Evaluation:**
  - `VISUAL_HIERARCHY_CRAFT`: 8px leads slightly (harmonizes with 6px CTA while softening taller controlled Web pilot input containers).
  - `SYSTEM_COHERENCE`: 6px leads on mathematical simplicity (1 token); 8px leads on semantic role expression.
  - `ROLE_FIT`: Both pass.
  - `ACCESSIBILITY_PLATFORM_FIT`: Tie. No material radius-dependent accessibility difference was identified in the available controlled Web evidence; native acceptance deferred to Phase 4I.
- **Anti-Bias Verification:**
  - *Did we fall for Novelty Bias?* No; 6px was rigorously defended as the architectural baseline.
  - *Did we fall for AI Rounding Bias (pill-shape drift)?* No; 10px was explicitly rejected as generic consumer roundness.
  - *Mandatory Challenge:* "If 8px is wrong, what is the most plausible reason?"  
    *Answer:* In a dense desktop-like multi-column table (if ever used on mobile), having different radii for adjacent buttons and inputs could look uncoordinated if not carefully spaced.

---

### Verdict & Governance Disposition

- **CONSENSUS:** `NARROW_CONSENSUS` (in favor of 8px for mobile data-entry fields).
- **FINAL_VERDICT:** **8px Mobile Field Radius** (`OPTION_B`).
- **WHY:**
  1. *Optical Proportion:* 8px softens taller controlled Web pilot input containers (48px pilot geometry) without drifting into bubbly consumer roundness (10px). Exact native field height remains OPEN / deferred to Phase 4I.
  2. *Deliberate Semantic Differentiation:* Action triggers remain crisp (6px `PRIMARY_ONLY`), while data entry is subtly softened (8px).
  3. *Zero Boundary Clutter:* Retains high density and pairs harmoniously with Outline-Led white field surfaces on light-first backgrounds (structural card/row grouping deferred to Phase 4E).
- **MINORITY_OPINION:**
  - *Dissent:* Preserving single 6px global radius across buttons and inputs guarantees absolute mathematical minimalism.
  - *Condition for Reconsideration:* If future cross-platform testing in Phase 4I shows that sub-pixel rendering on low-DPI Android screens causes 8px and 6px to look unintentionally mismatched in tight inline groupings.
- **CONFIDENCE:** `MEDIUM`
- **FOUNDER_DECISION_REQUIRED:** `NO` (Historical non-mutating validation; the Founder already evaluated these exact candidates and approved 8px).
- **DECISION_STATUS:** `ADVISORY` (Test evidence only; does NOT canonize).
- **COURT_OUTCOME:** `VERDICT_REACHED`

---

## Non-Mutating Governance Invariants Check
- `HISTORICAL_REPLAY_MUTATED_CANON:` **NO**
- `REOPENS_CLOSED_PHASE:` **NO**
- `FOUNDER_DECISION_PRESERVED:` **YES** (8px remains Founder-Selected Provisional Candidate)
- `PHASE_4D_STATUS_AFFECTED:` **NO** (Phase 4D remains `CLOSED / MERGED / PUBLISHED`)
