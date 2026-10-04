---
name: konfrm-design-court
description: "Governed collaborative design-adjudication layer for materially ambiguous KONFRM design decisions. Convenes a minimal panel of specialist roles, synthetic role-lens personas, an original-idea defender, a challenger and a red-team prosecutor; applies evidence classification and hard gates; and returns an advisory collective verdict with consensus class, minority opinion and Founder escalation when needed. Advisory only: it does not replace Founder authority, promote Canon, constitute user research, or guarantee multi-agent execution."
---

# KONFRM Design Court v1

**Status:** Founder-approved governance infrastructure (v1). Output is **advisory governance evidence**.

> [!IMPORTANT]
> ### GOVERNING PRINCIPLE
> **The Design Court must prefer an honest unresolved verdict over a confident unsupported recommendation.**
>
> The Court improves design judgment. It does not manufacture certainty.
> A Court verdict is NEVER automatically Founder approval, Product Truth, Business Canon, or final Design Canon.

---

## 1. Authority Order (Founder Subordination)

| # | Layer | May be overridden by Court? |
|---|-------|-----------------------------|
| 1 | Founder / explicitly approved Product authority | NO |
| 2 | Product Truth / Business Rules / Financial Rules / Security constraints | NO |
| 3 | Existing KONFRM Design Canon / governed design decisions | NO |
| 4 | Applicable non-waivable accessibility or platform constraints | NO |
| 5 | **Design Court evaluated recommendation** | — |
| 6 | Individual internal skills | informs Court |
| 7 | External skill / reference heuristics | informs Court |
| 8 | Trends / taste / aesthetic preference | informs Court |

A lower layer may inform a higher layer. It may NOT override it. The Court is subordinate to the Founder and cannot re-decide Founder decisions (see §8).

---

## 2. When the Court Runs (Routing)

The Court is invoked by `konfrm-design-router` only for **materially unresolved design decisions**.

### COURT_NOT_REQUIRED (no decision theater)
Return `COURT_NOT_REQUIRED` and use the normal minimal skill path for:
- typo / copy fix
- literal clipping bug
- obvious broken RTL property (e.g. un-mirrored directional chevron)
- known accessibility defect with an established fix
- exact implementation parity fix
- backend behavior or routine code bug
- already-governed visual rule with no material ambiguity

### Modes
| Mode | Use for | Typical panel |
|------|---------|---------------|
| `FAST_PANEL` | Bounded but materially ambiguous choices: radius A vs B, icon treatment, local field treatment, secondary action treatment, small component-language decisions | 3–5 relevant specialists + 1–2 personas + challenger + verdict |
| `FULL_COURT` | New primitive systems, navigation architecture, major screen architecture, cross-role conflicts, brand-language changes, component-system or token-family strategy, interaction architecture, material Founder-vs-system tension | Full relevant role set + relevant personas + defender + challenger + red team |

`FAST_PANEL` is the default when the Court is required. `FULL_COURT` is never the default and is never used for trivial issues.

---

## 3. Roles (detail: [ROLES.md](./ROLES.md))

Presiding: **Presiding Design Judge**, **Evidence Clerk**.
Specialists: **Product UX Counsel**, **Visual Systems Director**, **Brand & Experience Counsel**, **Platform & Accessibility Counsel**, **Arabic / RTL Counsel**, **Visual QA Prosecutor**.
Adversarial: **Original Idea Defender**, **Challenger / Alternative Advocate**.
Lenses: **Synthetic Persona Panel** ([PERSONA_PANEL.md](./PERSONA_PANEL.md)).

The Judge frames, manages and issues the verdict; the Judge does NOT impose personal taste and holds NO Founder authority.

---

## 4. Deliberation (detail: [DELIBERATION_PROTOCOL.md](./DELIBERATION_PROTOCOL.md))

```
ROUND 0  CASE DOCKET            (frame the case; no debate before framing)
ROUND 1  SEALED INDEPENDENT BRIEFS
ROUND 2  BRAINSTORMING WORKSHOP (max 1 new idea + 1 refinement per expert)
ROUND 3  CROSS EXAMINATION      (max 2 material challenges per expert)
ROUND 4  PERSONA HEARING        (synthetic role lenses only)
ROUND 5  RED TEAM               (Prosecutor attacks the leading option)
ROUND 6  EVIDENCE GATE          (INSUFFICIENT_EVIDENCE → smallest useful validation → RESUME SAME CASE)
         HARD GATES → MULTI-CRITERIA DELIBERATION → CONSENSUS → MINORITY OPINION → ANTI-BIAS CHECK → VERDICT
```

`FAST_PANEL` may compress rounds 2–4 but may not skip the Docket, Hard Gates, Red Team, Anti-Bias Check, or attribution truth.

---

## 5. Hard Gates (Majority Cannot Override)

Before scoring or consensus, eliminate any option that violates:
`BUSINESS_CANON`, `PRODUCT_TRUTH`, `FINANCIAL_RULE`, `SECURITY_CONSTRAINT`, `APPLICABLE_ACCESSIBILITY_REQUIREMENT`, `PLATFORM_IMPOSSIBILITY`, `RTL_CORRECTNESS`, `ARCHITECTURE_BOUNDARY`.

**A Hard Gate failure overrides popularity. No majority, however large, can override a Hard Gate failure.**
Example: nine panelists prefer an option that exposes the Owner phone publicly contrary to Product Truth → outcome `BLOCKED_BY_PRODUCT_OR_CANON` (consensus class `BLOCKED_BY_CANON`), never a 9–1 winner.

---

## 6. Evidence, Attribution & Topology Truth (detail: [EVIDENCE_MODEL.md](./EVIDENCE_MODEL.md))

- **Evidence classes:** `CANON`, `PRODUCT_EVIDENCE`, `TESTED_VISUAL_EVIDENCE`, `PLATFORM_ACCESSIBILITY_EVIDENCE`, `EXTERNAL_REFERENCE`, `EXPERT_HEURISTIC`, `PERSONA_INFERENCE`, `UNKNOWN`. The Evidence Clerk classifies every material claim.
- **True attribution rule:** every specialist/skill shown in a report carries `STATUS: CONSULTED | NOT_CONSULTED | UNAVAILABLE`. For every `CONSULTED` entry, both `CONSULTATION_SOURCE` (exact repo-relative governed file read) and `APPLIED_PRINCIPLE` (one concise applied principle) are mandatory to ensure auditability. A skill that was not consulted gets NO position. An unavailable skill gets NO fabricated position and NO fabricated vote. Never write "the design skills prefer X" without consultation evidence.
- **DELIBERATION_TOPOLOGY** must be reported as `TRUE_MULTI_AGENT` or `SINGLE_AGENT_STRUCTURED_PANEL`. Never claim autonomous agents conversed when one agent executed structured roles. In single-agent mode, sealed briefs are written before other positions are revealed; this reduces anchoring but is NOT independent multi-agent consensus.
- **Persona truth guard:** `SYNTHETIC PERSONA OPINION != USER RESEARCH EVIDENCE`. Synthetic personas are NOT user research. Never write "users prefer X" from persona simulation; write "the <role> synthetic role lens predicts …".

---

## 7. Specialist Skill Consultation

The Court orchestrates — it does not replace — the existing skill ecosystem:
- **`konfrm-design-reasoning`** supplies the evidence-quality model, hypothesis discipline (A/B/C), research claim hygiene and micro-validation principles. The Court adds multi-role adjudication, structured disagreement, persona lenses, red team, consensus classification and the Founder gate. It references, and does not duplicate, the reasoning skill.
- Internal skills (`konfrm-product-ux`, `konfrm-mobile-design`, `konfrm-accessibility`, `konfrm-rtl-arabic`, `konfrm-visual-qa`) are the primary governed specialist sources.
- External wrappers (`frontend-design-wrapper`, `ui-ux-pro-max-wrapper`, `impeccable-wrapper`, `emil-wrapper`, `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`) may be consulted as **advisory expert witnesses** only when relevant. They are never invoked automatically and remain **subordinate to KONFRM Canon**; a universalized external heuristic (e.g. one raw-pixel mobile target for every platform) is rejected in favour of platform-specific guidance (iOS 44pt / Android 48dp).

---

## 8. Founder Authority & Decision Stability

- The Court NEVER replaces Founder authority.
- When the residual difference between valid options is materially aesthetic / brand preference → `NEEDS_FOUNDER_VISUAL_DECISION`, with a plain-language explanation (see [VERDICT_TEMPLATE.md](./VERDICT_TEMPLATE.md)). Prefer 1 Founder question; maximum 3 per case.
- Never ask the Founder to decide accessibility facts, technical constraints, or Product Truth.
- **Founder decision stability:** if the Founder already selected Option A, a later panel that marginally prefers B does NOT reopen it (`PRESERVE_FOUNDER_DECISION`, `NO_REOPEN`). Reopen only on materially new evidence of incompatibility, product harm, accessibility failure, platform failure, or material system inconsistency — and even then the Court only recommends re-review to the Founder.

---

## 9. Outcomes, Consensus & Status

**COURT_OUTCOME (exactly one):** `VERDICT_REACHED`, `NEEDS_VISUAL_EVIDENCE`, `NEEDS_USER_RESEARCH`, `NEEDS_FOUNDER_VISUAL_DECISION`, `BLOCKED_BY_PRODUCT_OR_CANON`, `NO_MATERIAL_DIFFERENCE`, `COURT_NOT_REQUIRED`.

**CONSENSUS (exactly one):** `UNANIMOUS`, `STRONG_CONSENSUS`, `NARROW_CONSENSUS`, `SPLIT_DECISION`, `INSUFFICIENT_EVIDENCE`, `BLOCKED_BY_CANON`, `NO_MATERIAL_DIFFERENCE`. Do not fake consensus.

**MINORITY_OPINION** is mandatory whenever material disagreement remains (dissent, strongest reason, condition under which it may become correct).

**DECISION_STATUS** the Court may emit: `ADVISORY`, `CANDIDATE`, `VALIDATED_CANDIDATE` only.
> The Court is prohibited from emitting a canonical decision status: `DECISION_STATUS: CANONICAL` is FORBIDDEN in any Court output. Canon promotion belongs exclusively to the Founder / Bridge governance process.

---

## 10. Anti-Bias Check (mandatory before verdict)

Inspect for: `ANCHORING_BIAS`, `CONFIRMATION_BIAS`, `AUTHORITY_BIAS`, `GROUPTHINK`, `NOVELTY_BIAS`, `STATUS_QUO_BIAS`, `TREND_FOLLOWING`, `EXTERNAL_DESIGN_SYSTEM_WORSHIP`, `FOUNDER_HISTORY_OVERGENERALIZATION`, `GENERIC_SAAS_CONVERGENCE`, `AI_ROUNDING_BIAS`.

Mandatory final challenge: **IF OUR PREFERRED VERDICT IS WRONG, WHAT IS THE MOST PLAUSIBLE REASON?**

---

## 11. Brevity Protocol — «خير الكلام ما قل ودل»

Targets (not reasons to omit material evidence): expert brief ~120–150 words; objection ~80; rebuttal ~80; persona hearing ~100 per persona; FAST_PANEL report ~300–500 words; FULL_COURT report ~600–900 words. No repetitive essays.

## 12. No Private Chain-of-Thought

The Court never requires disclosure of hidden reasoning. Output only: POSITION, EVIDENCE, OBJECTION, RESPONSE, RISK, VERDICT, CONFIDENCE. The protocol is structured decision evidence, not raw internal reasoning.

---

## 13. Files

| File | Purpose |
|------|---------|
| [ROLES.md](./ROLES.md) | Presiding, specialist and adversarial role mandates |
| [DELIBERATION_PROTOCOL.md](./DELIBERATION_PROTOCOL.md) | Rounds 0–6, hard gates, criteria, consensus, anti-bias |
| [PERSONA_PANEL.md](./PERSONA_PANEL.md) | Synthetic role lenses and truth guard |
| [EVIDENCE_MODEL.md](./EVIDENCE_MODEL.md) | Evidence classes, attribution truth, topology truth |
| [VERDICT_TEMPLATE.md](./VERDICT_TEMPLATE.md) | Standard verdict + Founder decision explanation |
| [TEST_CASES.md](./TEST_CASES.md) | Governance scenarios validated by `scripts/test-design-court-contract.mjs` |
| [DESIGN_COURT_VALIDATION_REPORT.md](./DESIGN_COURT_VALIDATION_REPORT.md) | Historical non-mutating replay (test evidence, not product authority) |
