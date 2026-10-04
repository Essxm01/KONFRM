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
- Field Strategy: Outline-Led baseline on white cards. Note: Border color `#8E8E93` (~3.26:1 contrast) is classified as `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE_ONLY`; exact native Neutrals remain `OPEN`.
- Container Geometry: Input height of 48px is classified as `CONTROLLED_WEB_PILOT_GEOMETRY`; exact native field height remains `OPEN / DEFERRED TO 4I`.
- Arabic-first RTL native layout with logical start/end and Western Arabic digits (`0–9`).
- Founder Authority: Founder binding decision is 8px mobile field radius (published in Phase 4D, PR #92).

**HARD_GATE_RESULT:**
- Option A (6px): **PASS** (Zero Business Canon, Product Truth, financial, security, or accessibility violations).
- Option B (8px): **PASS** (Zero Business Canon, Product Truth, financial, security, or accessibility violations).

---

### Specialist Consultation & Attribution Ledger

| Skill | Status | Consultation Source | Applied Principle | Position | Evidence / Rationale | Confidence | Limitation |
|---|---|---|---|---|---|---|---|
| `konfrm-product-ux` | `CONSULTED` | `docs/ai/skills/konfrm-product-ux/SKILL.md` | Role mental model: Customer decisions prioritize trust and clarity; Owner prioritizes operational density. | Option B (8px) | 8px provides subtle perceptual affordance distinction between actionable triggers and editable data-entry fields without reducing touch targets or scan speed. | HIGH | Focuses on role task clarity; geometry preference is secondary to error prevention. |
| `konfrm-mobile-design` | `CONSULTED` | `docs/ai/skills/konfrm-mobile-design/SKILL.md` | Platform ergonomics: visible control geometry separated from touch targets; container mass proportionality. | Option B (8px) | Controlled 48px Web pilot containers visually absorb 8px radius with natural contour tension; 6px on large containers appears slightly severe on modern mobile viewports. | HIGH | Evaluated on 390px mobile simulation; exact native Flutter rendering and geometry deferred to Phase 4I. |
| `konfrm-accessibility` | `CONSULTED` | `docs/ai/skills/konfrm-accessibility/SKILL.md` | Web WCAG baseline: non-text component boundary contrast and interactive target bounds. | NO_PREFERENCE (Equally Valid) | Both 6px and 8px preserve full interactive bounds and non-text contrast boundaries; no material radius-dependent accessibility difference was identified in the available controlled Web evidence; native acceptance deferred to 4I. | HIGH | Evaluates conformance, not aesthetic brand flavor. |
| `konfrm-rtl-arabic` | `CONSULTED` | `docs/ai/skills/konfrm-rtl-arabic/SKILL.md` | Logical start/end padding symmetry and Arabic baseline flow. | NO_PREFERENCE (Equally Valid) | Both radii preserve Arabic baseline flow and padding symmetry; no Bidi or text clipping difference observed between 6px and 8px. | HIGH | Language typography is independent of subtle corner curvature. |
| `konfrm-visual-qa` | `CONSULTED` | `docs/ai/skills/konfrm-visual-qa/SKILL.md` | Attacking leading option across viewports and component states. | Evaluated Both (Attacking Leading Option) | Verified that neither 6px nor 8px introduces border aliasing or clipping across 360px and 390px frames (`input_radius_6px_owner.png`, `input_radius_8px_owner.png`). | HIGH | Web canvas screenshot evidence; native rasterizer deferred to Phase 4I. |
| `ui-ux-pro-max-wrapper` | `NOT_CONSULTED` | — | — | — | Suppressed by Router: local radius choice resolved by internal skills without catalog lookup. | — | — |
| `emil-wrapper` | `NOT_CONSULTED` | — | — | — | Suppressed: static field geometry does not involve gestural springs or physical motion. | — | — |
| `vercel-web-guidelines-wrapper` | `NOT_CONSULTED` | — | — | — | Excluded: mobile primitive evaluation; web-only wrapper prohibited from native mobile architecture. | — | — |

*Attribution check: 5 internal skills consulted with explicit source files and principles; 3 external wrappers not consulted (zero fabricated positions or votes).*

---

### Round 1 — Sealed Independent Briefs (Summary)
- **Product UX Counsel:** Recommends Option B (8px). Reason: clear cognitive distinction between button action (6px) and data-entry container (8px). Risk: minor system complexity if radii proliferate. Confidence: HIGH.
- **Visual Systems Director:** Leans Option B (8px) with strong respect for Option A (6px). Reason: 8px softens the taller 48px box while retaining discipline; 6px remains a viable strict architectural alternative. Confidence: MEDIUM.
- **Platform & Accessibility Counsel:** Neutral. Both options meet interactive target standards and container ergonomics. Confidence: HIGH.

---

### Round 2 & 3 — Adversarial Hearing & Cross-Examination

#### Original Idea Defender (Championing 6px Button-Parity Baseline)
- *Position:* "KONFRM is an architectural, disciplined brand. Sharing 6px across buttons and inputs creates absolute geometric harmony and prevents arbitrary radius drift."
- *Objection to 8px:* "Introducing 8px for fields creates two close radius tokens (6px vs 8px) that may look like an accidental inconsistency rather than deliberate design to casual observers."

#### Challenger (Championing 8px Softened Candidate)
- *Position:* "A 48px text box (pilot geometry) has 3× the visual area of a 44px button line. A 6px corner on a large input card feels austere and boxed-in. 8px provides optical softening proportionate to container mass."
- *Rebuttal to Defender:* "The differentiation is semantic, not accidental: buttons trigger state changes (sharp, decisive 6px), whereas inputs invite text entry (open, welcoming 8px)."

---

### Round 4 — Synthetic Persona Hearing

> [!NOTE]
> `SYNTHETIC_ROLE_LENS` evaluation only — NOT empirical user research.

- **`TRUST_SENSITIVE_FIRST_TIME_CUSTOMER` Lens:**
  - *Immediate Understanding:* Both fields are instantly recognizable as inputs due to crisp outline (tested at #8E8E93 web pilot reference) and explicit top labels.
  - *Perceptual Distinction:* The 8px curve subtly conveys a slightly softer, more approachable booking inquiry flow compared to the austere 6px.
  - *Risk / Mistake:* Zero functional difference in error rate predicted.
- **`OPERATIONAL_OWNER` Lens:**
  - *Immediate Understanding:* High-density property creation form is legible in both treatments.
  - *Perceptual Distinction:* 6px feels slightly more technical and spreadsheet-like; 8px feels modern without sacrificing data density. Neither impedes rapid scanning.

---

### Round 5 — Red Team (Visual QA Prosecutor)
- **Stress Reflow & Scaling Check:** Inspected `input_radius_6px_owner.png` and `input_radius_8px_owner.png`.
  - Border integrity: Verified 1px outline renders crisply on both.
  - Text scale 200%: Cross-radius A/B equivalence at 200% text scaling was NOT tested in the pilot (controlled 200% stress evidence exists only for the selected 8px pilot candidate: `input_stress_owner.png` / `input_stress_customer.png`). At 100% scale, label reflow and error wrapping operate reliably under both radii.
  - Button competition: Under 8px, the field does not visually compete with the 6px `#000000` Primary button; the visual hierarchy remains CTA-dominant.
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

- **CONSENSUS:** `STRONG_CONSENSUS` (in favor of 8px for mobile data-entry fields).
- **FINAL_VERDICT:** **8px Mobile Field Radius** (`OPTION_B`).
- **WHY:**
  1. *Optical Proportion:* 8px softens taller controlled Web pilot input containers (48px pilot geometry) without drifting into bubbly consumer roundness (10px). Exact native field height remains OPEN / deferred to Phase 4I.
  2. *Deliberate Semantic Differentiation:* Action triggers remain crisp (6px `PRIMARY_ONLY`), while data entry is subtly softened (8px).
  3. *Zero Boundary Clutter:* Retains high density and pairs harmoniously with Outline-Led white card surfaces.
- **MINORITY_OPINION:**
  - *Dissent:* Preserving single 6px global radius across buttons and inputs guarantees absolute mathematical minimalism.
  - *Condition for Reconsideration:* If future cross-platform testing in Phase 4I shows that sub-pixel rendering on low-DPI Android screens causes 8px and 6px to look unintentionally mismatched in tight inline groupings.
- **CONFIDENCE:** `HIGH`
- **FOUNDER_DECISION_REQUIRED:** `NO` (Historical non-mutating validation; the Founder already evaluated these exact candidates and approved 8px).
- **DECISION_STATUS:** `ADVISORY` (Test evidence only; does NOT canonize).
- **COURT_OUTCOME:** `VERDICT_REACHED`

---

## Non-Mutating Governance Invariants Check
- `HISTORICAL_REPLAY_MUTATED_CANON:` **NO**
- `REOPENS_CLOSED_PHASE:` **NO**
- `FOUNDER_DECISION_PRESERVED:` **YES** (8px remains Founder-Selected Provisional Candidate)
- `PHASE_4D_STATUS_AFFECTED:` **NO** (Phase 4D remains `CLOSED / MERGED / PUBLISHED`)
