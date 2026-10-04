# Design Court — Verdict Template

Keep within brevity targets (FAST_PANEL ~300–500 words; FULL_COURT ~600–900 words).

```markdown
## KONFRM DESIGN COURT — VERDICT

CASE_ID:
QUESTION:
MODE:                    FAST_PANEL | FULL_COURT
DELIBERATION_TOPOLOGY:   TRUE_MULTI_AGENT | SINGLE_AGENT_STRUCTURED_PANEL
ROLE / SURFACE:
OPTIONS:
KNOWN_CANON:
HARD_GATE_RESULT:        [per option: PASS | FAIL (<gate>)]

SKILLS_CONSULTED:        [per consulted skill:
                          - SKILL: <name>
                          - STATUS: CONSULTED
                          - CONSULTATION_SOURCE: <exact repo-relative governed file read>
                          - SOURCE_ANCHOR: <section heading / governed rule identifier actually used>
                          - APPLIED_PRINCIPLE: <faithful concise paraphrase applied>
                          - POSITION: <position>
                          - EVIDENCE: <evidence>
                          - CONFIDENCE: LOW | MEDIUM | HIGH
                          - LIMITATION: <limitation>]
SKILLS_UNAVAILABLE:      [name + effect on confidence; no positions, no votes]

SPECIALIST_POSITIONS:    [sealed-brief summaries, consulted roles only]
PERSONA_PANEL:           [SYNTHETIC_ROLE_LENS outputs — not user research]
ORIGINAL_IDEA_DEFENSE:
CHALLENGER_POSITION:     [or NO_CREDIBLE_CHALLENGE]
MAJOR_OBJECTIONS:
REBUTTALS:
RED_TEAM_RESULT:         [material failures found / none found + checks run]
EVIDENCE_STRENGTH:       STRONG | MODERATE | WEAK | INSUFFICIENT
WEIGHTING_EMPHASIS:

CONSENSUS:               UNANIMOUS | STRONG_CONSENSUS | NARROW_CONSENSUS | SPLIT_DECISION | INSUFFICIENT_EVIDENCE | BLOCKED_BY_CANON | NO_MATERIAL_DIFFERENCE
FINAL_VERDICT:
WHY:                     [max 3 major reasons]
MINORITY_OPINION:        [dissent · strongest reason · condition for becoming correct]
WHAT_COULD_MAKE_THIS_VERDICT_WRONG:
CONFIDENCE:              LOW | MEDIUM | HIGH

FOUNDER_DECISION_REQUIRED:    YES | NO
FOUNDER_DECISION_EXPLANATION: [only when required — see below]

DECISION_STATUS:         ADVISORY | CANDIDATE | VALIDATED_CANDIDATE
COURT_OUTCOME:           VERDICT_REACHED | NEEDS_VISUAL_EVIDENCE | NEEDS_USER_RESEARCH | NEEDS_FOUNDER_VISUAL_DECISION | BLOCKED_BY_PRODUCT_OR_CANON | NO_MATERIAL_DIFFERENCE | COURT_NOT_REQUIRED
```

> [!CAUTION]
> The Court may NOT emit `DECISION_STATUS: CANONICAL`. Canon promotion belongs to the Founder / Bridge governance process.

---

## Founder Decision Explanation (only when `NEEDS_FOUNDER_VISUAL_DECISION`)

Plain language, no jargon. Prefer 1 question; maximum 3 per case.

```
WHAT IS BEING DECIDED?
WHAT DOES OPTION A LOOK/FEEL LIKE?
WHAT DOES OPTION B LOOK/FEEL LIKE?
WHAT CHANGES IF A IS SELECTED?
WHAT CHANGES IF B IS SELECTED?
WHAT DOES NOT CHANGE?
WHAT DOES THE COURT RECOMMEND?
WHY?
```

Never ask the Founder to decide accessibility facts, technical constraints, or Product Truth.

---

## Router FULL Report Extension

When a Court case runs, the Router FULL report appends:

```
- COURT_USED: YES | NO
- COURT_MODE: FAST_PANEL | FULL_COURT | N/A
- COURT_OUTCOME:
- COURT_CONSENSUS:
- FOUNDER_DECISION_REQUIRED: YES | NO
```

COMPACT reports are unchanged.
