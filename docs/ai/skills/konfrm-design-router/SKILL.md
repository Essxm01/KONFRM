---
name: konfrm-design-router
description: "Master design triage router for KONFRM. Classifies tasks by role (Customer/Owner/Admin), surface reality (Current React/Web vs Future Native Mobile Flutter Target), and task type. Activates the minimal necessary skill set, routes meaningful visual decisions through konfrm-design-reasoning, manages external skills as debate participants, and mandates the standardized KONFRM Design Skill Usage Report."
---

# KONFRM Design Router

The Master Design Triage Layer for the KONFRM platform across all AI agents (Codex, Antigravity, ZCode).

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.3, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role) and canonical business invariants (`docs/BUSINESS_RULES.md`). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste, business rules, or brand identity.**

---

## 1. Responsibilities

1. **Request Classification:** Automatically classify every incoming design/UI request by:
   - **Role:** Customer, Owner, Admin, or Shared Design System.
   - **Surface Reality:**
     - **Current Web Implementation:** `customer-app/` (React SPA), `owner-app/` (React SPA), `admin-app/` (React SPA).
     - **Future Native Mobile Target:** Future Flutter/Dart applications governed by DF2 v1.3 (`mobile/customer_app`, `mobile/owner_app` — topology not yet initialized).
   - **Task Type:** UX Architecture, Visual Design, Micro-Polish, Accessibility Audit, Visual QA, or Code Structure.
2. **Minimal Skill Activation:** Select ONLY the specific internal and wrapped external skills relevant to the task. Suppress unneeded or conflicting tools.
3. **Structured Design Reasoning Pipeline:** For meaningful new Primitive, visual-hierarchy, or component-design choices, route requests through `konfrm-design-reasoning`. For routine bug fixes, typos, layout alignment, or known accessibility remediations, bypass the heavy dialectic and proceed directly with proportional discipline.
4. **External Skills as Debate Participants:** Treat external skills as competing advisory perspectives in a disciplined dialectic, rather than authoritative commands.
5. **Pre-flight Conflict Resolution:** Detect potential conflicts between external advice and KONFRM Design Canon before work begins, ensuring Canon wins unconditionally.
6. **Standardized Reporting Enforcement:** Mandate the appropriate reporting block upon task completion: `FULL` mode for unresolved visual/architectural decisions, or `COMPACT` mode for routine implementations and fixes.
7. **Design Court Escalation:** Route only materially unresolved design decisions to `konfrm-design-court` (`FAST_PANEL` by default, `FULL_COURT` for system-level or cross-role decisions). Routine work never enters the Court (see §3).

---

## 2. Request Classification & Routing Matrix

| Surface Reality | Codebase Location | Current Architecture | Applicable Internal Skills | Approved External Wrappers |
|---|---|---|---|---|
| **Current Customer Web** | `customer-app/` | React / Vite / Tailwind | `konfrm-product-ux`, `konfrm-design-reasoning`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `ui-ux-pro-max-wrapper` (advisory), `impeccable-wrapper` (polish/critique) |
| **Current Owner Web** | `owner-app/` | React / Vite / Tailwind | `konfrm-product-ux`, `konfrm-design-reasoning`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `ui-ux-pro-max-wrapper` (advisory), `impeccable-wrapper` (polish/critique/distill) |
| **Current Admin Web** | `admin-app/` | React / Vite / Tailwind | `konfrm-product-ux`, `konfrm-design-reasoning`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `impeccable-wrapper` (distill/quieter) |
| **Future Mobile Target** | Future `mobile/` boundary (uninitialized) | Flutter / Dart (DF2 v1.3) | `konfrm-product-ux`, `konfrm-design-reasoning`, `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `ui-ux-pro-max-wrapper` (advisory search only), `impeccable-wrapper` (polish/critique), `emil-wrapper` (tactile/gesture candidates) |
| **Design System Authority** | `DESIGN_SYSTEM/` | Semantic Tokens & Specs | `konfrm-design-reasoning`, `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility` | `impeccable-wrapper` (audit), `ui-ux-pro-max-wrapper` (advisory style search) |

> [!WARNING]
> **CRITICAL REPOSITORY MAPPING RULE:**
> Existing `customer-app/` and `owner-app/` directories are **React/Web implementations**, NOT Flutter apps. Never silently route existing `customer-app/` source as Flutter. When reviewing current React applications, React composition and web guidelines are applicable; when architecting future Flutter surfaces, web-only wrappers are strictly prohibited.

---

## 3. The Visual Decision Pipeline

For meaningful new Primitive, component, or visual-language decisions, the resolution pipeline executes in this strict sequence:

```
konfrm-design-router
  │ (Triage role, surface, and decision scope)
  ▼
konfrm-product-ux
  │ (Enforce business invariants, role mental models, truthful state grammar)
  ▼
konfrm-design-reasoning
  │ (Run 12-step decision loop: Hypotheses A/B/C, human perception, brand congruence)
  ▼
applicable role/platform skills (konfrm-mobile-design / konfrm-rtl-arabic / konfrm-accessibility)
  │ (Validate ergonomics, RTL logical properties, touch targets, contrast)
  ▼
external evidence & craft wrappers (impeccable, ui-ux-pro-max, emil, vercel)
  │ (Consult external lenses as debate participants)
  ▼
visual QA / prototype validation (konfrm-visual-qa)
    (Micro-validation plan or explicit NOT EXECUTED statement)
```

### Pipeline Execution Boundaries

- **MANDATORY FULL REASONING PIPELINE (`konfrm-design-reasoning`):**
  - New primitives or design token candidates
  - Visual language or design-system specification changes
  - High-impact interaction patterns (e.g. sheet vs modal, multi-step booking gestures)
  - Unresolved brand/UX tradeoffs
  - Meaningful new screen or flow design directions

- **BYPASS FULL PIPELINE (Direct Implementation / Proportional Review):**
  - Literal spacing, padding, or margin bug fixes
  - Icon alignment and text typography clipping fixes
  - Typo, translation string, or copy updates
  - Obvious responsive overflow corrections
  - Implementation parity fixes with existing screens
  - Routine accessibility remediations where the standard requirement is already known

### Design Court Escalation (`konfrm-design-court`)

```
Incoming design task → classify
  ├── routine / known / already governed  → normal minimal skill path (COMPACT report); Court returns COURT_NOT_REQUIRED
  ├── meaningful but resolvable by one reasoning pass → konfrm-design-reasoning (FULL report)
  └── materially unresolved design decision → konfrm-design-court
        ├── bounded choice (radius A vs B, icon/field/secondary treatment) → FAST_PANEL (default)
        └── primitive system, navigation/screen/interaction architecture, cross-role conflict,
            brand-language or token-family strategy, material Founder-vs-system tension → FULL_COURT
```

Court triggers: unresolved primitive choice; two or more credible visual directions; role conflict; brand-vs-UX tradeoff; major component/system choice; major screen decision; interaction-architecture ambiguity; Founder explicitly requests the Design Court.

- Do NOT send every UI task through the Court. Typos, literal clipping, obvious RTL property bugs, known a11y fixes, parity fixes, backend behavior and routine code bugs never require it.
- The Court orchestrates `konfrm-design-reasoning` and the specialist skills; it does not replace them.
- Court output is advisory (`ADVISORY` / `CANDIDATE` / `VALIDATED_CANDIDATE`); it never replaces Founder authority or promotes Canon.

---

## 4. External Skills as Debate Participants

External skills are not authoritative command sources; they are structured participants in a design dialectic:

- **`frontend-design`**: Argues for distinctiveness, intentional hierarchy, and memorable character against generic templates.
- **`impeccable/critique`**: Attacks hierarchy weaknesses, visual noise, layout incoherence, and usability ambiguities.
- **`impeccable/distill`**: Champions simplification; asks what elements or borders can be removed without sacrificing useful operational information.
- **`impeccable/quieter`**: Tests whether visual noise is too high, dampening excessive visual competition.
- **`impeccable/bolder`**: Consulted as a counterpoint when a screen risks looking timid or bland (implementation strictly gated by Founder authorization).
- **`impeccable/delight`**: Consulted for subtle micro-interaction moments on completion states (strictly prohibited from delaying transactional booking or payout flows).
- **`emil-design-eng`**: Argues for physical interaction feel, tactile feedback, spring mechanics, and responsive gesture continuity.
- **`ui-ux-pro-max`**: Provides an advisory searchable catalog and curated heuristic/taxonomy reference material across styles, navigation models, and interaction patterns (individual recommendations are non-canonical craft references).
- **`taste-skill` / `high-end`**: Strictly excluded from default product routing. Consulted only in **SANDBOX COUNTERPOINT** mode when the task explicitly requests an exploratory visual counter-hypothesis.

> [!CAUTION]
> **No Assertiveness Dominance:**
> Never allow an external skill to prevail simply because its advice is phrased more assertively. Canon and disciplined human-centered evidence always decide.

---

## 5. Skill Suppression & Rejection Rules

When routing, the following skills MUST be actively suppressed or rejected:
- **`sleek-design-mobile-apps`**: REJECT. External network service requiring credentials; transmits prompts/design context; excluded from default KONFRM routing.
- **`high-end-visual-design`**: REJECT for product UI. Enforces low-density luxury agency spacing and dark slabs directly contrary to KONFRM's high useful density.
- **`vercel-web-guidelines` / `vercel-composition-patterns`**: PROHIBITED from governing future Flutter-native architecture. Confined strictly to React/Web codebases (`admin-app/`, current `customer-app/`, current `owner-app/`).
- **`impeccable/bolder` & `impeccable/delight`**: SUPPRESS by default on all transactional flows (booking, checkout, payouts, verification). Requires explicit Founder authorization.
- **`extract-design-system` / `canvas-design` / `design-taste-frontend`**: SUPPRESS from automated product routing. Manual sandbox exploration only.

---

## 6. Design Authority Snapshot & Pre-Flight Decision Classification

Before reviewing, routing, or producing design work, enforce the decision status boundaries reflecting published Phases 4A–4D:

### 1. STABLE GOVERNING DIRECTION (Canon / Fixed Product Invariants)
- **Brand Identity:** Monochrome-first identity (Solid Black/White).
- **Interaction Role:** Restrained blue interaction-accent **role** (separate from brand identity).
- **Surface Dominance:** Light-first dominant surfaces.
- **Directional Semantics:** Arabic-first RTL native layout with logical start/end and Western Arabic numerals (`0–9`).
- **State Grammar:** Truthful state grammar (ERROR ≠ EMPTY, STALE ≠ ERROR, PENDING ≠ SUCCESS, MISSING ≠ ZERO).
- **Action Hierarchy:** Five-tier action grammar (Primary, Secondary, Tertiary, Contextual, Destructive).
- **Role-Specific UX:** Role mental models (Customer booking clarity, Owner operational certainty, Admin audit governance).
- **Information Density:** High useful operational density over decorative whitespace.
- **Platform Adaptation:** Preserve semantic hierarchy across platforms while adapting presentation ergonomics.

### 2. PUBLISHED GOVERNED PROVISIONAL DECISIONS (Do NOT Treat as Open; Do NOT Falsely Promote to Final Native Canon)
- **Typography:** Cairo Profile B scale and metrics (`SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY`; native mobile Flutter acceptance deferred to Phase 4I).
- **Exact Mobile Primary Black:** `#000000` (`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`; `#18181B` fallback comparator only; not promoted to final native Canon).
- **Primary Button Radius:** `6px` (`PRIMARY_ONLY` provisional; secondary button radius and global shape system remain open).
- **Action Strategy:** Contextual Hierarchy Hybrid (`SYSTEM-VALIDATED PROVISIONAL ACTION STRATEGY`).
- **Field Visual Strategy:** Outline-Led field baseline with white field surface on light-first surfaces (structural grouping deferred to Phase 4E; `SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`; Web pilot candidate `#8E8E93` [~3.26:1 contrast] is rendering reference only).
- **Mobile Field-Shaped Control Radius:** `8px` (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`; applies strictly to mobile field-shaped Form & Selection controls; deliberate semantic differentiation from 6px Primary CTA).
- **Focus Semantic Direction:** Restrained Interaction-Accent Emphasis (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`; Web pilot rendering reference is 1px accent field border + 3px outer halo).

### 3. OPEN VARIABLES (Genuinely Unresolved / Candidate / Phase-Deferred)
- **Exact Blue Candidate Token:** `#276EF1` remains candidate / open.
- **Exact Neutral Palette:** Hex tokens remain open / implementation candidates.
- **Exact Native Focus Treatment:** Ring width, halo opacity, and native assistive focus remain open / deferred to Phase 4I.
- **Exact Native Stroke Width:** Border/stroke tokenization remains open / deferred to Phase 4I.
- **Exact Native Field Height:** Native input container height remains open / deferred to Phase 4I (48px in pilot was controlled Web pilot geometry).
- **Secondary Button Radius:** Remains open / undecided.
- **Global Shape System:** Card, sheet, row, and dialog radii remain open / Phase 4E & 4F scope.
- **Structural System:** Spacing scale, content insets, section separation, and elevation levels remain Phase 4E scope (`STATUS: NOT_STARTED`).
- **Final Native Component Acceptance:** Mobile Flutter implementation and accessibility acceptance deferred to Phase 4I.
- **Token-File Authoring:** Authoring `DESIGN_SYSTEM/TOKENS/*.json` remains separately gated.

> [!CRITICAL]
> **GOVERNANCE STATUS DISTINCTIONS:**
> Agents and the Design Court must strictly recognize:
> - **`PROVISIONAL != OPEN`**: Governed provisional decisions are settled baseline directions; they must NOT be treated as unresolved or re-litigated without new material evidence.
> - **`PROVISIONAL != FINAL_NATIVE_CANON`**: Governed provisional decisions require native Flutter/platform acceptance in Phase 4I before becoming permanent native Canon. Do not collapse these statuses.

---

## 7. Standardized Output Enforcement: Dual-Mode Reporting

To prevent context noise on micro-tasks while maintaining rigorous governance on major visual decisions, the router mandates two distinct reporting modes:

### Mode A: FULL REPORT (for unresolved visual decisions, new primitives, or token architecture)

Used whenever `konfrm-design-reasoning` is invoked:

```markdown
### KONFRM DESIGN SKILL USAGE REPORT (FULL)
- TASK_CLASSIFICATION: [Role: Customer/Owner/Admin | Surface: Web/Future Mobile | Scope: Primitive/Language/Major Screen]
- DESIGN_SKILLS_USED: [skills utilized with version/source]
- DESIGN_SKILLS_NOT_USED: [skills evaluated and excluded, with specific rationale]
- DESIGN_HYPOTHESES_CONSIDERED: [competing hypotheses formulated (e.g., A vs B), or N/A]
- HUMAN_FACTORS_EVIDENCE: [empirical perception/ergonomic evidence cited, distinguishing real research from AI inference]
- TARGET_ROLE_REASONING: [specific customer/owner/admin cognitive lens applied]
- COUNTERARGUMENTS: [strongest critique or counterpoint considered against the chosen direction]
- CANON_CONFLICTS: [conflicts detected and explicit resolution per KONFRM Canon]
- EVIDENCE_VS_CANON: [advisory external inputs vs authoritative canonical decisions]
- VALIDATION_NEEDED: [recommended micro-validation method (prototype, test, survey), or NONE]
- VISUAL_QA: [tested viewports or explicit NOT EXECUTED statement if simulation/routing only]
- COURT_USED: [YES | NO]
- COURT_MODE: [FAST_PANEL | FULL_COURT | N/A]
- COURT_OUTCOME: [Design Court outcome, or N/A]
- COURT_CONSENSUS: [consensus class, or N/A]
- FOUNDER_DECISION_REQUIRED: [YES | NO]
```

The `COURT_*` fields are populated only when `konfrm-design-court` ran; otherwise `COURT_USED: NO` and the remaining Court fields are `N/A`.

### Mode B: COMPACT REPORT (for routine fixes, literal bugs, typos, and known accessibility remediations)

Used when bypassing the full 12-step reasoning pipeline:

```markdown
### KONFRM DESIGN SKILL USAGE REPORT (COMPACT)
- TASK_CLASSIFICATION: [Role | Surface | Scope: Bugfix/Alignment/Copy/Routine A11y]
- SKILLS_CONSULTED: [minimal internal/external skills consulted]
- GOVERNING_CANON: [relevant DF2 / Business Rules section]
- CANON_CHECK: [PASS — zero canon mutations or false promotions]
- VISUAL_QA: [tested viewports or explicit NOT EXECUTED statement]
```
