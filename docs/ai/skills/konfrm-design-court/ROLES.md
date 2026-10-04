# Design Court — Roles

Roles are **structured responsibilities**, not autonomous authorities. Every role is subordinate to the Authority Order in [SKILL.md](./SKILL.md) §1. Only roles relevant to the case are seated; a seated role that was not actually executed is reported `NOT_CONSULTED`.

---

## Presiding Roles

### Presiding Design Judge
- Defines the exact case question and decision scope (Round 0 Docket).
- Preserves scope; rejects drift into out-of-scope topics.
- Identifies authority locks (Founder decisions, Product Truth, Canon).
- Distinguishes hard gates from preferences.
- Prevents repeated arguments; manages round limits.
- Issues the structured verdict using [VERDICT_TEMPLATE.md](./VERDICT_TEMPLATE.md).
- **Does NOT** impose personal taste, hold Founder authority, or promote Canon.

### Evidence Clerk
- Classifies every material claim into one evidence class (see [EVIDENCE_MODEL.md](./EVIDENCE_MODEL.md)): `CANON`, `PRODUCT_EVIDENCE`, `TESTED_VISUAL_EVIDENCE`, `PLATFORM_ACCESSIBILITY_EVIDENCE`, `EXTERNAL_REFERENCE`, `EXPERT_HEURISTIC`, `PERSONA_INFERENCE`, `UNKNOWN`.
- Prevents opinions being presented as facts.
- Merges duplicate brainstorm ideas.
- Maintains the attribution ledger (`CONSULTED` / `NOT_CONSULTED` / `UNAVAILABLE`).

---

## Specialist Counsel

| Role | Primary governed source | Evaluates |
|------|------------------------|-----------|
| **Product UX Counsel** | `konfrm-product-ux` | Task success, clarity, role fit, state truth, workflow friction, error/recovery quality, Product capability truth |
| **Visual Systems Director** | `konfrm-design-reasoning` (+ Design System authority) | Visual hierarchy, geometry, density, rhythm, shape relationships, system coherence, controlled noise, component relationships, generic-SaaS drift |
| **Brand & Experience Counsel** | `DESIGN_SYSTEM/` brand direction | TRUST, CLARITY, VITALITY; monochrome-first identity; modern technology; hospitality; KONFRM-specific character. Must challenge technically correct but personality-less UI |
| **Platform & Accessibility Counsel** | `konfrm-mobile-design`, `konfrm-accessibility` | Platform fit, ergonomics, a11y constraints, text scaling, focus, touch guidance, assistive semantics. **May hard-block a genuine constraint violation.** Must NOT turn Apple/Material preferences into universal KONFRM aesthetic law |
| **Arabic / RTL Counsel** | `konfrm-rtl-arabic` | Arabic-first composition, RTL semantics, Bidi, mixed script, numeric runs, money, phone/email/technical values, translation expansion, optical balance |
| **Visual QA Prosecutor** | `konfrm-visual-qa` | **Attacks the leading option**: clipping, weak hierarchy, visual noise, false clarity, role mismatch, state failures, scaling defects, generic AI aesthetics, RTL defects, edge cases. Not a ceremonial reviewer |

External wrappers may be called as **advisory expert witnesses** by a specialist when relevant; their testimony is classified `EXTERNAL_REFERENCE` or `EXPERT_HEURISTIC` and is subordinate to KONFRM Canon.

---

## Adversarial Roles

### Original Idea Defender
- Defends the incumbent / original design as strongly as reasonably possible.
- Purpose: prevent **novelty bias** — a new proposal must not win merely because it is new.
- When a Founder decision is the incumbent, the Defender also states what new evidence would be required to reopen it.

### Challenger / Alternative Advocate
- Represents the strongest credible alternative.
- Purpose: prevent **groupthink**.
- Must articulate a real, material case. If no credible alternative exists, state `NO_CREDIBLE_CHALLENGE` rather than generating fake objections to fill the template.

---

## Synthetic Persona Panel

See [PERSONA_PANEL.md](./PERSONA_PANEL.md). Personas are `SYNTHETIC_ROLE_LENS` instruments, never user research.
