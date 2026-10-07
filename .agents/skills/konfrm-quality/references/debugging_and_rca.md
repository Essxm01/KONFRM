# `konfrm-quality` — Systematic Debugging & 4-Phase RCA

```yaml
MODULE: debugging_and_rca.md
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. THE 4-PHASE ROOT CAUSE ANALYSIS (RCA) PROTOCOL

Guess-and-check editing, speculative patching, and shot-gun debugging are strictly prohibited in KONFRM. Every reported defect or test failure must pass through the four formal phases:

```text
+-------------------+     +-------------------+     +-------------------+     +-------------------+
| PHASE 1:          |     | PHASE 2:          |     | PHASE 3:          |     | PHASE 4:          |
| REPRODUCE         | --> | ISOLATE           | --> | ROOT-CAUSE        | --> | VERIFY & REGRESS  |
| Deterministic     |     | Minimal failure   |     | Underlying flaw   |     | Fix passes; zero  |
| failure oracle    |     | boundary          |     | proven by facts   |     | collateral damage |
+-------------------+     +-------------------+     +-------------------+     +-------------------+
```

### Phase 1: Reproduce
Establish a repeatable reproduction before modifying any production code. Run the smallest credible oracle and capture the failure output.

### Phase 2: Isolate
Narrow down the failure boundary. Determine whether the bug originates in:
- The UI layer (widget building, gesture dispatch, accessibility semantics).
- The application layer (Riverpod state controller, intention handling).
- The data adapter layer (manual DTO parsing, network boundary).
- The platform shell boundary (native Android/iOS bridge, system insets).

### Phase 3: Root-Cause
Identify the fundamental design or code flaw causing the symptom. Do not stop at the immediate exception; explain *why* the bad state was created. Formulate a clear hypothesis and confirm it against physical code evidence.

### Phase 4: Verify & Regress
Once the fix is applied:
1. Re-run the reproduction oracle to confirm the failure is resolved.
2. Run the affected package's test suite to ensure zero unintended side-effects.
3. Run the static analysis gate on the affected surface.

---

## 2. SMALLEST CREDIBLE ORACLE SELECTION

> **Principle:** Choose the cheapest, fastest, and most deterministic reproduction mechanism that accurately captures the defect.

```
+------------------------------------+---------------------------------------------------------------+
| DEFECT CATEGORY                    | SMALLEST CREDIBLE ORACLE                                      |
+------------------------------------+---------------------------------------------------------------+
| Data transformation / DTO parsing  | Pure Dart unit test with failing JSON fixture.                |
| Controller state transition error  | Riverpod ProviderContainer test asserting state sequence.     |
| Widget layout / rebuild defect      | Widget test using testWidgets and tester.pump().              |
| Duplicate / missing accessibility  | Semantics tree inspection test (tester.getSemantics(...)).     |
| Physical OS / TalkBack mismatch    | Physical device reproduction log or accessibility tree dump.  |
| HTTP / API contract failure        | MockClient test asserting unexpected status code or payload.  |
| Build / packaging / ProGuard bug   | Local gradle assemble / flutter build execution trace.        |
| Store submission policy block      | Official store review rejection message or console telemetry. |
+------------------------------------+---------------------------------------------------------------+
```

### Invariant: Never Manufacture Artificial Tests
If a defect is fundamentally an interaction with the Android OS window insets or physical screen reader TalkBack, do NOT manufacture an artificial unit test that passes superficially while ignoring the physical failure mode. Use the genuine oracle, and add automated regression coverage where practical after the physical root cause is proven.
