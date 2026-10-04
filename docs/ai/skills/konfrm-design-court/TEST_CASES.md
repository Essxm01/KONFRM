# Design Court — Governance Test Cases

These scenarios validate that the Court **contract** classifies governance situations correctly. They do NOT simulate human design judgment.

Executed deterministically by `scripts/test-design-court-contract.mjs` (built-in Node APIs only, no network, no model calls), which is invoked by `npm run ai:skills:check`. The JSON block below is the single fixture source; the test parses it, applies the contract rules, and compares against `expected`. The test also verifies that every rule token it relies on is present in the Court contract files.

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Known RTL chevron bug | `COURT_NOT_REQUIRED` |
| 2 | Beautiful option exposes Owner phone publicly (9/10 panel support) | `BLOCKED_BY_PRODUCT_OR_CANON` (majority ignored) |
| 3 | Ambiguous primitive choice 6px vs 8px (`HISTORICAL_NON_MUTATING_REPLAY`) | `COURT_REQUIRED`, `FAST_PANEL`, no Canon mutation, Phase 4D not reopened |
| 4 | A/B visual choice with no artifacts | `NEEDS_VISUAL_EVIDENCE` |
| 5 | Customer calmness vs Owner density | `FULL_COURT` with role-sensitive weighting |
| 6 | External skill claims universal 44px mobile target | Reject universalization; preserve iOS 44pt / Android 48dp |
| 7 | Required specialist unavailable | `STATUS: UNAVAILABLE`, no fabricated position, no fabricated vote |
| 8 | Founder selected A; later panel marginally prefers B; no material new evidence | `PRESERVE_FOUNDER_DECISION`, `NO_REOPEN` |

```json
{
  "cases": [
    {
      "id": "CASE_1_KNOWN_RTL_CHEVRON_BUG",
      "input": {
        "category": "OBVIOUS_BROKEN_RTL_PROPERTY",
        "materialAmbiguity": false,
        "options": []
      },
      "expected": { "courtOutcome": "COURT_NOT_REQUIRED", "courtRequired": false }
    },
    {
      "id": "CASE_2_OWNER_PHONE_EXPOSED",
      "input": {
        "category": "SCREEN_DECISION",
        "materialAmbiguity": true,
        "options": [
          { "id": "A_BEAUTIFUL_PUBLIC_OWNER_PHONE", "panelSupport": 9, "hardGateViolations": ["PRODUCT_TRUTH", "SECURITY_CONSTRAINT"] }
        ],
        "panelSize": 10
      },
      "expected": { "courtOutcome": "BLOCKED_BY_PRODUCT_OR_CANON", "consensus": "BLOCKED_BY_CANON", "majorityOverrideApplied": false }
    },
    {
      "id": "CASE_3_FIELD_RADIUS_6_VS_8",
      "input": {
        "category": "PRIMITIVE_CHOICE",
        "scope": "BOUNDED_COMPONENT",
        "materialAmbiguity": true,
        "replayMode": "HISTORICAL_NON_MUTATING_REPLAY",
        "options": [ { "id": "6PX", "hardGateViolations": [] }, { "id": "8PX", "hardGateViolations": [] } ],
        "artifacts": ["input_radius_6px_owner.png", "input_radius_8px_owner.png"],
        "requiresVisualEvidence": true
      },
      "expected": { "courtRequired": true, "mode": "FAST_PANEL", "mutatesCanon": false, "reopensClosedPhase": false }
    },
    {
      "id": "CASE_4_AB_NO_ARTIFACTS",
      "input": {
        "category": "PRIMITIVE_CHOICE",
        "scope": "BOUNDED_COMPONENT",
        "materialAmbiguity": true,
        "options": [ { "id": "A", "hardGateViolations": [] }, { "id": "B", "hardGateViolations": [] } ],
        "artifacts": [],
        "requiresVisualEvidence": true
      },
      "expected": { "courtOutcome": "NEEDS_VISUAL_EVIDENCE", "consensus": "INSUFFICIENT_EVIDENCE" }
    },
    {
      "id": "CASE_5_CUSTOMER_CALM_VS_OWNER_DENSITY",
      "input": {
        "category": "CROSS_ROLE_CONFLICT",
        "scope": "SHARED_COMPONENT_SYSTEM",
        "materialAmbiguity": true,
        "roles": ["Customer", "Owner"],
        "options": [ { "id": "CALM", "hardGateViolations": [] }, { "id": "DENSE", "hardGateViolations": [] } ],
        "artifacts": ["composite_customer.png", "composite_owner.png"],
        "requiresVisualEvidence": true
      },
      "expected": { "courtRequired": true, "mode": "FULL_COURT", "roleSensitiveWeighting": true }
    },
    {
      "id": "CASE_6_EXTERNAL_UNIVERSAL_44PX",
      "input": {
        "category": "EXTERNAL_HEURISTIC_CLAIM",
        "materialAmbiguity": false,
        "externalClaims": [ { "source": "ui-ux-pro-max-wrapper", "property": "TOUCH_TARGET", "value": "44px", "universal": true } ],
        "options": []
      },
      "expected": { "externalClaimDisposition": "REJECT_UNIVERSALIZATION", "platformGuidance": { "ios": "44pt", "android": "48dp" } }
    },
    {
      "id": "CASE_7_SPECIALIST_UNAVAILABLE",
      "input": {
        "category": "PRIMITIVE_CHOICE",
        "scope": "BOUNDED_COMPONENT",
        "materialAmbiguity": true,
        "options": [ { "id": "A", "hardGateViolations": [] }, { "id": "B", "hardGateViolations": [] } ],
        "artifacts": ["a.png", "b.png"],
        "requiresVisualEvidence": true,
        "specialists": [
          { "skill": "konfrm-product-ux", "available": true },
          { "skill": "konfrm-rtl-arabic", "available": false, "required": true }
        ]
      },
      "expected": { "unavailableSkill": "konfrm-rtl-arabic", "status": "UNAVAILABLE", "position": null, "vote": null }
    },
    {
      "id": "CASE_8_FOUNDER_STABILITY",
      "input": {
        "category": "PRIMITIVE_CHOICE",
        "scope": "BOUNDED_COMPONENT",
        "materialAmbiguity": true,
        "founderSelected": "A",
        "panelPreference": { "option": "B", "margin": "MARGINAL" },
        "materialNewEvidence": [],
        "options": [ { "id": "A", "hardGateViolations": [] }, { "id": "B", "hardGateViolations": [] } ],
        "artifacts": ["a.png", "b.png"]
      },
      "expected": { "founderAction": "PRESERVE_FOUNDER_DECISION", "reopen": "NO_REOPEN", "courtOutcome": "VERDICT_REACHED" }
    }
  ]
}
```

Adding a scenario: append a case to the JSON block with `input` and `expected`; extend the classifier only if a genuinely new contract rule is introduced (and document that rule in the Court files first).
