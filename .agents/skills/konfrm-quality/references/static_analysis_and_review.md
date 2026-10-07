# `konfrm-quality` — Static Analysis, Dual-Axis Review & Completion Honesty

```yaml
MODULE: static_analysis_and_review.md
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. SURFACE-SPECIFIC STATIC ANALYSIS GATES

Static analysis verification must target the exact repository surface touched by the change:

```
+------------------------------------+---------------------------------------------------------------+
| REPOSITORY SURFACE                 | COMMAND & VERIFICATION METHOD                                 |
+------------------------------------+---------------------------------------------------------------+
| Flutter Application / Package      | flutter analyze                                               |
| Pure Dart Library / CLI Utility    | dart analyze                                                  |
| TypeScript / Edge Worker / Admin   | npm run typecheck / oxlint / eslint                           |
+------------------------------------+---------------------------------------------------------------+
```

### Strict Zero-Suppression Policy
- Skills must NEVER add blanket ignore comments (`// ignore_for_file: ...` or `// ignore: ...`) solely to make a gate pass.
- Skills must NEVER reconfigure project analysis options (`analysis_options.yaml`) to soften warnings without explicit Founder authorization.
- Every detected lint or type warning must be resolved at the root cause in the source code.

---

## 2. DUAL-AXIS CODE REVIEW PROTOCOL

Every code change must be evaluated against two orthogonal review axes before approval:

### Axis 1: The Specification Axis (Prompt Fidelity)
- **Fidelity:** Did the change implement exactly what was requested?
- **Scope Discipline:** Did the change stay strictly within the authorized scope, or did it introduce unsolicited refactorings, premature optimizations, or unrelated fixes?
- **Anti-Hallucination:** Did the change avoid inventing business logic, payment rules, or mock data not present in the specification?

### Axis 2: The Standards Axis (Architectural & Canon Integrity)
- **Architecture Boundaries:** Does the change respect the `presentation/application/data` feature-first structure (zero unapproved domain layers)?
- **Canon Compliance:** Does the UI adhere strictly to DF2 monochrome identity, Cairo typography, and RTL directional alignment?
- **Security & Privacy:** Does the change isolate sensitive credentials in protected storage? Does it avoid logging user secrets?
- **Performance Seams:** Are immutable widgets marked `const`? Are heavy operations kept outside `build()` methods?

---

## 3. COMPLETION HONESTY & EVIDENCE DISCIPLINE

> **Core Law:** A build passing or CI turning green is NOT proof that production or physical device requirements have been satisfied.

```text
+----------------------------------------------------------------------------------------------------+
| COMPLETION VERIFICATION CHECKLIST                                                                  |
+----------------------------------------------------------------------------------------------------+
| 1. EXACT HEAD PINNING: Evidence must be captured at the exact committed Git SHA under review.      |
| 2. ORACLE REVERIFICATION: The initial failing oracle must be demonstrated passing after the fix.   |
| 3. NO REGRESSION: All existing package tests must execute and pass without failure.                |
| 4. STATIC ANALYSIS: Surface static analysis gate exits with code 0 (zero errors/warnings).        |
| 5. PHYSICAL DEVICE REALITY: When a task gate mandates physical device validation (such as Phase   |
|    4I Android runtime testing), emulator or mock assertions CANNOT be substituted.                 |
| 6. HONEST REFUSAL: If required physical hardware or live services are unavailable, the agent must |
|    honestly halt and declare BLOCKED, stating the exact physical evidence missing.                 |
+----------------------------------------------------------------------------------------------------+
```
