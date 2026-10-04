# Design Court — Deliberation Protocol

Structured decision evidence only. No private chain-of-thought is required or disclosed.

---

## Round 0 — Case Docket (no debate before framing)

```
CASE_ID:
DESIGN_QUESTION:
TARGET_ROLE:            Customer | Owner | Admin | Shared
TARGET_SURFACE:         Current Web | Future Native Mobile | Design System
DECISION_SCOPE:
KNOWN_CANON:
PRODUCT_TRUTH_LOCKS:
OPEN_VARIABLES:
OPTIONS:                A, B (, C)
OUT_OF_SCOPE:
MODE:                   FAST_PANEL | FULL_COURT
DELIBERATION_TOPOLOGY:  TRUE_MULTI_AGENT | SINGLE_AGENT_STRUCTURED_PANEL
```

If triage shows no material ambiguity, stop here with `COURT_NOT_REQUIRED`.

## Round 1 — Sealed Independent Briefs

Each consulted expert submits before seeing others (~120–150 words):
`POSITION` · `MAX_2_REASONS` · `MAIN_RISK` · `CONFIDENCE (LOW/MEDIUM/HIGH)`.
In `SINGLE_AGENT_STRUCTURED_PANEL` mode, briefs are written in sequence and not revised after later briefs are revealed.

## Round 2 — Brainstorming Workshop

Per expert: **maximum 1 new idea + 1 refinement**. The Clerk merges duplicates. Purpose: improve the option set, not spam variants.

## Round 3 — Cross Examination

Per expert: **maximum 2 material challenges**, format:
`CLAIM → OBJECTION → EVIDENCE → PRODUCT_CONSEQUENCE` (~80 words each; rebuttal ~80 words).
Rejected: objections equivalent to "I don't like it" or "it feels better" without evidence or design reasoning.

## Round 4 — Persona Hearing

Run only relevant synthetic role lenses ([PERSONA_PANEL.md](./PERSONA_PANEL.md)). Record clarity, confusion, confidence, friction, likely error point. Output is `PERSONA_INFERENCE`, not empirical research.

## Round 5 — Red Team

The Visual QA Prosecutor attempts to invalidate the current leading option across:
narrow width · large text scaling · Arabic wrapping · RTL/Bidi · disabled/error/loading states · action hierarchy · role mismatch · density collapse · visual noise · misleading trust · generic AI/SaaS convergence · unsupported Product behavior.

**If a material failure is found: NO FINAL VERDICT yet.** Correct the option or move to the Evidence Gate.

## Round 6 — Evidence Gate

The Court is allowed and required to declare `INSUFFICIENT_EVIDENCE`. Request the **smallest useful validation**, in rising cost order:
A/B composite → side-by-side screenshots → realistic composed screen → narrow-width rendering → scaling test → micro-prototype → real-device validation → user research (only if genuinely necessary).

Outcome while waiting: `NEEDS_VISUAL_EVIDENCE` (or `NEEDS_USER_RESEARCH`). An A/B visual choice with no rendered artifacts cannot reach `VERDICT_REACHED`.
After evidence arrives: **RESUME SAME CASE** (same `CASE_ID`); do not open a new case unnecessarily.

---

## Hard Gates (before scoring or consensus)

Eliminate any option violating: `BUSINESS_CANON`, `PRODUCT_TRUTH`, `FINANCIAL_RULE`, `SECURITY_CONSTRAINT`, `APPLICABLE_ACCESSIBILITY_REQUIREMENT`, `PLATFORM_IMPOSSIBILITY`, `RTL_CORRECTNESS`, `ARCHITECTURE_BOUNDARY`.

A Hard Gate failure overrides popularity; a majority cannot override a Hard Gate failure. If every option fails → `BLOCKED_BY_PRODUCT_OR_CANON`.

## Multi-Criteria Deliberation (surviving options only)

Criteria: `TASK_SUCCESS_CLARITY`, `ROLE_FIT`, `INTERACTION_AMBIGUITY`, `BRAND_CONGRUENCE`, `VISUAL_HIERARCHY_CRAFT`, `ACCESSIBILITY_PLATFORM_FIT`, `ARABIC_RTL_INTEGRITY`, `STATE_ROBUSTNESS`, `SYSTEM_COHERENCE`, `REVERSIBILITY_FUTURE_COST`.

No global hardcoded weighting. Publish the `WEIGHTING_EMPHASIS` used for the case:
- **Customer** tends to emphasize trust, clarity, hospitality, low ambiguity.
- **Owner** tends to emphasize scanability, operational efficiency, useful density, state certainty.
- **Admin** tends to emphasize truth, throughput, exceptions, auditability.

Cross-role conflicts (e.g. Customer calmness vs Owner density) route to `FULL_COURT` or explicitly role-sensitive deliberation with separate per-role weighting. Weights are reasoning aids, not mathematical truth.

## Consensus Classification (exactly one)

`UNANIMOUS` · `STRONG_CONSENSUS` · `NARROW_CONSENSUS` · `SPLIT_DECISION` · `INSUFFICIENT_EVIDENCE` · `BLOCKED_BY_CANON` · `NO_MATERIAL_DIFFERENCE`. Do not fake consensus.

## Minority Opinion

Mandatory when material disagreement remains: dissenting position · strongest supporting reason · condition under which the minority may become correct. A credible dissent is never erased because it lost.

## Anti-Bias Check (before verdict)

`ANCHORING_BIAS`, `CONFIRMATION_BIAS`, `AUTHORITY_BIAS`, `GROUPTHINK`, `NOVELTY_BIAS`, `STATUS_QUO_BIAS`, `TREND_FOLLOWING`, `EXTERNAL_DESIGN_SYSTEM_WORSHIP`, `FOUNDER_HISTORY_OVERGENERALIZATION`, `GENERIC_SAAS_CONVERGENCE`, `AI_ROUNDING_BIAS`.

Final challenge: **IF OUR PREFERRED VERDICT IS WRONG, WHAT IS THE MOST PLAUSIBLE REASON?**

## Founder Gate & Stability

- Residual difference is materially aesthetic/brand → `NEEDS_FOUNDER_VISUAL_DECISION` (prefer 1 question, max 3).
- Prior Founder selection + marginal later preference without material new evidence → `PRESERVE_FOUNDER_DECISION`, `NO_REOPEN`.

## Outcome (exactly one)

`VERDICT_REACHED` · `NEEDS_VISUAL_EVIDENCE` · `NEEDS_USER_RESEARCH` · `NEEDS_FOUNDER_VISUAL_DECISION` · `BLOCKED_BY_PRODUCT_OR_CANON` · `NO_MATERIAL_DIFFERENCE` · `COURT_NOT_REQUIRED`.
