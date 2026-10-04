# Design Court — Evidence Model

The Court reuses the evidence-quality and research-claim-hygiene discipline of `konfrm-design-reasoning` (source vs inference vs transfer risk). This file adds Court-specific classification, attribution and topology rules.

---

## 1. Evidence Classes (Evidence Clerk)

| Class | Meaning | Typical strength |
|-------|---------|------------------|
| `CANON` | Published KONFRM Design Canon, Business Rules, Founder decisions | Binding (hard gate) |
| `PRODUCT_EVIDENCE` | Real product code/behavior, real user research, live evidence | High |
| `TESTED_VISUAL_EVIDENCE` | Rendered artifacts actually produced and inspected (pilot screenshots, composites) | Medium–High |
| `PLATFORM_ACCESSIBILITY_EVIDENCE` | WCAG criteria (web), platform guidance (iOS 44pt / Android 48dp), measured contrast | High for constraints; not aesthetic law |
| `EXTERNAL_REFERENCE` | External skill/wrapper/design-system statements | Advisory |
| `EXPERT_HEURISTIC` | Reasoned craft judgment without direct test | Low–Medium |
| `PERSONA_INFERENCE` | Synthetic role-lens prediction | Low; never research |
| `UNKNOWN` | Unsupported or unverifiable claim | None |

Opinions may not be presented as facts. A claim with no classifiable basis is `UNKNOWN`.

`EVIDENCE_STRENGTH` reported per case: `STRONG` (tested/product evidence on the deciding criteria) · `MODERATE` · `WEAK` (heuristic/persona only) · `INSUFFICIENT`.

## 2. True Attribution Rule

For every specialist/skill shown in a Court report:

```
SKILL:       <name>
STATUS:      CONSULTED | NOT_CONSULTED | UNAVAILABLE
POSITION:    <only if CONSULTED>
EVIDENCE:    <concise, classified>
CONFIDENCE:  LOW | MEDIUM | HIGH
LIMITATION:  <if applicable>
```

- `CONSULTED` means the skill's governing file was actually read/applied in this case.
- `NOT_CONSULTED` → no position, no vote.
- `UNAVAILABLE` (required specialist missing or unreadable) → **no fabricated position and no fabricated vote**; record the gap and its effect on confidence. If the missing specialist covers a deciding criterion, downgrade to `INSUFFICIENT_EVIDENCE` or request the specialist.
- Never write aggregate claims such as "the design skills prefer X" without per-skill consultation evidence.

## 3. Deliberation Topology Truth

`DELIBERATION_TOPOLOGY` is mandatory in every report:
- `TRUE_MULTI_AGENT` — only when separate agent instances actually produced independent positions.
- `SINGLE_AGENT_STRUCTURED_PANEL` — one agent executed the roles sequentially with sealed briefs.

Never claim autonomous agents conversed when only one agent executed structured roles. Sealed briefs reduce anchoring but do not constitute independent multi-agent consensus; consensus labels in single-agent mode describe structured role agreement, not independent votes.

## 4. External Skill Subordination

External testimony is `EXTERNAL_REFERENCE` / `EXPERT_HEURISTIC`. It is subordinate to KONFRM Canon. Universalized external thresholds (e.g. one raw-pixel touch target for all platforms) are rejected; platform-specific guidance is preserved.
