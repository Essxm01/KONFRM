# KONFRM Engineering Intelligence Skill Router V1

```yaml
ROUTER_VERSION: 1.1.0
GOVERNING_SYSTEM: KONFRM Engineering Intelligence System V1
ROUTING_MODEL: DOMAIN_SCOPED_COMBINED_SIGNALS
ACTIVE_RUNTIME_BRAINS:
  - konfrm-flutter
  - konfrm-quality
  - konfrm-design
DEFERRED_BRAINS:
  - konfrm-product
  - konfrm-admin-web
  - konfrm-backend
  - konfrm-delivery
```

---

## 1. ROUTING PRINCIPLES

1. **Combined Signals Routing:** Route based on task intent, affected file scope, product surface, user role, and risk level. Never route on naive keyword matching alone.
2. **Domain-Scoped Authority:** Route tasks strictly to the governing brain owning that lifecycle phase:
   - Design interpretation, visual hierarchy, DF2 tokens, Arabic RTL semantics, A11y design intent -> `konfrm-design`
   - Client implementation mechanics (Flutter Dart code, widgets, Riverpod) -> `konfrm-flutter`
   - Defect diagnosis, verification, review, and completion proof -> `konfrm-quality`
3. **No Recursive Directory Scans:** Agents use direct file locators from `.agents/SKILL_MANIFEST.yaml` and `.agents/CONTEXT_MAP.yaml`.
4. **Minimal Sufficient Runtime Context:** Load only the primary brain's root `SKILL.md`. Lazy-load companion reference modules (`references/*.md`) only when the task actively touches that specific domain risk or seam.

---

## 2. DETERMINISTIC DECISION MATRIX

```text
+-----------------------------------------------------+--------------------+--------------------+
| TASK CLASS / INTENT                                 | PRIMARY BRAIN      | HANDOFF / GATE     |
+-----------------------------------------------------+--------------------+--------------------+
| UI/UX reasoning / role-specific information model   | konfrm-design      | konfrm-flutter*    |
| Visual hierarchy / DF2 token consumption / spacing  | konfrm-design      | konfrm-flutter*    |
| Arabic RTL layout policy / Bidi isolation design    | konfrm-design      | konfrm-flutter*    |
| Accessibility design intent / touch hit contracts   | konfrm-design      | konfrm-flutter*    |
| Optical review / visual critique ("what good looks")| konfrm-design      | konfrm-quality     |
| Materially ambiguous design decision / dialectic    | konfrm-design      | Design Court Gate  |
+-----------------------------------------------------+--------------------+--------------------+
| New Flutter widget / layout implementation          | konfrm-flutter     | konfrm-quality     |
| Flutter state management (Riverpod)                 | konfrm-flutter     | konfrm-quality     |
| Flutter navigation / go_router / deep link seams    | konfrm-flutter     | konfrm-quality     |
| Flutter manual DTO / HTTP networking adapter        | konfrm-flutter     | konfrm-quality     |
| Flutter RTL / accessibility mechanics               | konfrm-flutter     | konfrm-quality     |
| Native Android / iOS shell integration in Flutter   | konfrm-flutter     | konfrm-quality     |
+-----------------------------------------------------+--------------------+--------------------+
| Bug diagnosis / unexpected test failure / crash     | konfrm-quality     | konfrm-flutter*    |
| Root Cause Analysis (4-phase RCA)                   | konfrm-quality     | konfrm-flutter*    |
| Static analysis review (flutter analyze)            | konfrm-quality     | konfrm-flutter*    |
| Multi-tier test strategy / test authoring           | konfrm-quality     | konfrm-flutter*    |
| Code review (Specification & Standards axes)        | konfrm-quality     | None (Verdicts)    |
| Security & OWASP MASVS verification                 | konfrm-quality     | konfrm-flutter*    |
| Physical runtime evidence audit / completion proof  | konfrm-quality     | None (Verdicts)    |
+-----------------------------------------------------+--------------------+--------------------+
| Pure documentation task (Markdown docs only)        | NONE (Bypass)      | None               |
| Backend SQL migration / Cloudflare Worker proxy     | konfrm-backend**   | Docs / Database Canon            |
| Web Admin dashboard (React 19 / Vite in admin-app)  | konfrm-admin-web** | Web Admin Guidelines             |
+-----------------------------------------------------+--------------------+--------------------+

* Handoff to konfrm-flutter occurs when code modification of Flutter client source is required.
** Deferred brains until later rollout stages.
```

---

## 3. FAST-PATH EXECUTION SEQUENCES

### 3.1 Flutter Implementation Sequence
```text
Task: "Implement/modify a Flutter screen, widget, or state controller."
1. Activate: konfrm-flutter (.agents/skills/konfrm-flutter/SKILL.md)
2. Retrieve Canon: Look up relevant Design or Architecture locators via .agents/CONTEXT_MAP.yaml.
3. Lazy-Load References: Open only matching references (e.g., widgets_and_layout.md or architecture.md).
4. Implement: Author or modify Flutter code adhering to presentation/application/data feature-first architecture.
5. Handoff: Hand off to konfrm-quality for verification gate if task introduces non-trivial risk.
```

### 3.2 Defect Diagnosis & Remediation Sequence
```text
Task: "Diagnose and fix a test failure, runtime error, or visual mismatch."
1. Activate: konfrm-quality (.agents/skills/konfrm-quality/SKILL.md)
2. Lazy-Load References: Open references/debugging_and_rca.md.
3. Phase 1 & 2 (RCA): Reproduce with smallest credible oracle; isolate defect boundary.
4. Phase 3 (Root Cause): Identify underlying architectural or logical flaw.
5. Handoff to Implementation: If production code change needed, hand off to konfrm-flutter with proven root cause and oracle.
6. Remediate: konfrm-flutter applies targeted fix.
7. Phase 4 (Verify): konfrm-quality verifies oracle passes and runs surface static analysis gate.
```

### 3.3 Design Reasoning & Interpretation Sequence
```text
Task: "Review, structure, or refine UI/UX hierarchy, Arabic RTL layout, or visual styling."
1. Activate: konfrm-design (.agents/skills/konfrm-design/SKILL.md)
2. Retrieve Canon: Look up DF2 design tokens or guidelines via .agents/CONTEXT_MAP.yaml.
3. Lazy-Load References: Open only matching references (role_experience.md, visual_system.md, rtl_content.md, accessibility_design.md, states_interactions.md, or visual_review.md).
4. Formulate Design Contract: Define visual hierarchy, spacing tiers, and semantic states.
5. Handoff: Hand off to konfrm-flutter for Flutter client implementation, or konfrm-quality for optical verification.
```

---

## 4. NEGATIVE ROUTING RULES

1. **Pure Documentation / Policy Edits:** Do NOT load `konfrm-flutter`, `konfrm-quality`, or `konfrm-design` when editing markdown files in `docs/` that do not involve design or code verification.
2. **Backend / SQL Tasks:** Do NOT activate `konfrm-flutter` or `konfrm-design` for tasks touching exclusively `backend/` or `supabase/`.
3. **Web Admin Implementation:** Do NOT activate `konfrm-flutter` for tasks touching exclusively `admin-app/` implementation code.
4. **No Premature Gate Loading:** Do NOT load `konfrm-quality` security or performance modules for routine typographical or layout adjustments unless an explicit security boundary or frame-rate risk is touched.
5. **No Code Mechanics in Design Brain:** Do NOT load `konfrm-design` to write Dart widget code, Riverpod state logic, or fix Flutter compiler errors (use `konfrm-flutter` or `konfrm-quality`).

---

## 5. RUNTIME HANDOFF CONTRACT

When an agent transitions between brains, it must format the transition using the standardized handoff envelope:

```text
STATUS: [IN_PROGRESS | DIAGNOSED | IMPLEMENTED | VERIFIED | BLOCKED]
SURFACE: [mobile/customer_app | mobile/owner_app | mobile/packages | admin-app | backend]
RESULT: [Summary of findings or code changes executed]
AFFECTED_SCOPE: [Exact list of files or symbols modified/inspected]
EVIDENCE: [Smallest credible oracle output, analyzer status, or test pass proof]
RISK: [Identified security, architectural, or regression risks]
NEXT_BRAIN: [konfrm-flutter | konfrm-quality | konfrm-design | NONE]
NEXT_REASON: [Why handoff is required]
BLOCKER: [Description of genuine blocker if stopped, else NONE]
```
