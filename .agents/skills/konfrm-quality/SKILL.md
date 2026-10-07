---
name: konfrm-quality
description: Use for diagnosing defects, systematic 4-phase root cause analysis (RCA), selecting smallest credible oracles, test selection, static analysis review, dual-axis code review, security and accessibility verification, and proving task completion with evidence. Do not use as the primary skill for product-rule definition, Flutter client architecture, design invention, or database schema authoring.
---

# `konfrm-quality` — Verification, Debugging & Quality Engine

```yaml
BRAIN_ID: konfrm-quality
SYSTEM: KONFRM Engineering Intelligence System V1
STATUS: PILOT_ACTIVE
SURFACE: all_surfaces (mobile, web, edge, test suites)
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md
```

---

## 1. PRIMARY MISSION & BOUNDARIES

`konfrm-quality` owns the diagnostic, verification, code review, and evidence standards of the KONFRM repository.

### What It Owns:
- Systematic defect diagnosis and 4-phase Root Cause Analysis (RCA).
- Selection of the smallest credible reproduction oracle.
- Multi-tier testing strategy and test contract selection.
- Routing and enforcement of repository-defined static analysis gates (`flutter analyze`, `dart analyze`).
- Dual-axis code review (Specification fidelity and Standards compliance).
- Verification against selected security (OWASP MASVS v2.0) and accessibility baselines.
- Detection of architecture drift and completion honesty enforcement.

### What It Does NOT Own:
- **Product Rule Definition:** Does NOT invent or redefine business rules or financial formulas.
- **Client Architecture Authoring:** Does NOT redesign Flutter or Admin Web architecture; verifies against approved specifications.
- **Design Invention:** Does NOT invent visual aesthetics, colors, or component styles.
- **Release Merge Authority:** Does NOT execute Git branch merges; hands off verified evidence to `konfrm-delivery`.

---

## 2. NON-NEGOTIABLE INVARIANTS

1. **4-Phase Root Cause Analysis (RCA):**
   Mandatory for any defect, test failure, or regression:
   `Phase 1: Reproduce` -> `Phase 2: Isolate` -> `Phase 3: Root-Cause` -> `Phase 4: Verify without regression`.
   Guess-and-check editing and speculative trial-and-error fixes are strictly forbidden.
2. **Smallest Credible Oracle:**
   > `REPRODUCE WITH THE SMALLEST CREDIBLE ORACLE.`
   Preferred when feasible: an automated failing regression test.
   Valid reproductions also include: physical device behavior, accessibility semantics tree inspection, API traces, database query logs, build/signing errors, or deterministic rendered mismatches.
   Never manufacture an artificial unit test merely to satisfy a debugging ritual. After fixing, add regression automation where practical and valuable.
3. **Repository-Defined Static Analysis:**
   > `RUN THE REPOSITORY-DEFINED STATIC ANALYSIS GATE FOR THE AFFECTED SURFACE.`
   - For Flutter packages/apps: `flutter analyze`.
   - For pure Dart libraries: `dart analyze`.
   Strictness flags follow repository configuration and active task gates. Skills never redefine analyzer policies independently. Never auto-suppress analyzer errors or use blanket ignore annotations to force a green gate.
4. **Test Taxonomy Without Mandatory Domain Layer:**
   Tests span: application/business logic, pure utilities, DTOs/adapters, widgets, API contracts, and integration/system boundaries. Test architecture must not reintroduce a rejected mandatory domain layer.
5. **Golden Testing as On-Demand Visual Tool:**
   Golden tests are classified as `ON_DEMAND_VISUAL_REGRESSION_TOOL`. They validate deterministic pixel rendering on demand; they do NOT replace physical runtime visual QA on real devices.
6. **Dual-Axis Code Review:**
   Every code change must be evaluated against two orthogonal axes:
   - **Specification Axis:** Did the change solve the exact user request without hallucinating features?
   - **Standards Axis:** Does the change preserve architecture boundaries, Canon, and security baselines?
7. **Selected Security Baseline:**
   Security audits use OWASP MASVS v2.0 as a **selected engineering and verification baseline**, not a public certification claim. Security verification is risk-triggered; full audits are executed when sensitive surfaces (auth, storage, network) are touched.
8. **Completion Honesty:**
   Never declare a task complete without concrete, credible evidence satisfying the task gate. Passing local tests alone is NOT proof of physical device behavior when the governing task mandates physical validation.
9. **Repository Reality Rule:**
   > `NEVER CLAIM CURRENT IMPLEMENTATION FROM ARCHITECTURE ALONE.`
   Always verify physical code and runtime evidence at current HEAD.
10. **Phase 4I Distilled Verification Invariants:**
    - Verify that ordinary action buttons (`IconButton`, `IconActionButton`) do not emit `selected` semantics in the accessibility tree unless they are stateful toggles.
    - Verify that semantic wrappers do not duplicate existing button labels.
    - Physical Android device evidence cannot be substituted by emulator assertions when physical validation is required.
    - iOS is a distinct platform reality gate; do not infer iOS compliance from Android evidence.

---

## 3. EXECUTION WORKFLOW

```text
[DEFECT OR VERIFICATION TRIGGERED]
               │
               ▼
1. SELECT SMALLEST CREDIBLE ORACLE (references/debugging_and_rca.md)
   - Automated failing test / semantics dump / device log / API trace
               │
               ▼
2. 4-PHASE RCA EXECUTION
   - Phase 1: Reproduce failure deterministically.
   - Phase 2: Isolate minimal failure boundary.
   - Phase 3: Identify fundamental root cause.
               │
               ▼
3. CODE REMEDIATION DECISION
   - If Flutter client code modification required:
     Emit Handoff to `konfrm-flutter` with root cause & oracle.
   - If pure verification/review task:
     Proceed to analysis and audit.
               │
               ▼
4. VERIFICATION & STATIC ANALYSIS GATE (references/static_analysis_and_review.md)
   - Execute surface-specific analyzer (flutter analyze / dart analyze).
   - Re-run reproduction oracle to prove defect is resolved.
   - Run regression test suite to ensure zero collateral breakage.
               │
               ▼
5. AUDIT RISK SURFACES (references/security_and_accessibility_verification.md)
   - Audit touched security or accessibility boundaries.
               │
               ▼
6. EMIT VERIFICATION VERDICT OR HANDOFF
   - Format evidence and verdict using standard handoff envelope.
```

---

## 4. COMPANION REFERENCE MODULE INDEX

Load companion modules on demand when the task touches their specific technical domain:

- **`references/debugging_and_rca.md`:** 4-Phase Root Cause Analysis protocol, smallest credible oracle decision matrix, isolating failure boundaries, regression test criteria.
- **`references/testing_strategy.md`:** Multi-tier test taxonomy without mandatory domain layer, widget test best practices, network mocking seams, on-demand golden testing.
- **`references/static_analysis_and_review.md`:** Surface-specific analyzer execution, zero-suppression policy, dual-axis code review checklist, completion honesty verification.
- **`references/security_and_accessibility_verification.md`:** Risk-triggered OWASP MASVS v2.0 audit, non-rotating refresh token verification, accessibility semantics inspection, Phase 4I lessons.

---

## 5. CROSS-BRAIN HANDOFF CONTRACT

When handing off a diagnosed defect to `konfrm-flutter` for implementation fix:

```text
STATUS: DIAGNOSED
SURFACE: [mobile/customer_app | mobile/owner_app | mobile/packages]
RESULT: [Proven root cause analysis and defect explanation]
AFFECTED_SCOPE: [Exact file, class, and method requiring remediation]
EVIDENCE: [Output of smallest credible oracle showing deterministic reproduction]
RISK: [Identified regression risks to consider during implementation]
NEXT_BRAIN: konfrm-flutter
NEXT_REASON: [Request code remediation based on proven root cause]
BLOCKER: NONE
```
