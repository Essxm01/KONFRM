# KONFRM — ENGINEERING INTELLIGENCE SYSTEM V1
## SKILL CONSOLIDATION × KNOWLEDGE DISTILLATION × SECURITY × STORE READINESS

```yaml
DOCUMENT_TYPE: ARCHITECTURAL_BLUEPRINT
SYSTEM_NAME: KONFRM Engineering Intelligence System V1
STATUS: READY_FOR_RUNTIME_BRAIN_AUTHORING
GOVERNING_BRANCH: chore/agent-skills-governance-v1
BASE_CANONICAL_REF: c1df82e3d1f6745e17626e3d645e7fc12688ede9
ISOLATION_INVARIANTS:
  PR_100: FROZEN at 24269f2fe638c2846d053e03dafdf27c50652cda
  PR_99: UNTOUCHED
  RUNTIME_SKILLS_MUTATED: FALSE (Architecture Blueprint Only)
```

---

## 1. PRIME DIRECTIVE & DOMAIN-SCOPED AUTHORITY

### 1.1 The Prime Directive
A skill system becomes dangerous when it is confidently wrong. KONFRM Engineering Intelligence prioritizes structural truth, explicit boundaries, and live evidence over apparent completeness:

```
ACCURACY > APPARENT COMPLETENESS
AUTHORITY > GENERIC BEST PRACTICE
LIVE OFFICIAL FACT > MODEL MEMORY
RETRIEVAL > DUPLICATED CANON
CONDITIONAL REQUIREMENT > UNIVERSAL RULE
```

- **Unknown Must Remain Unknown:** Gaps are never filled with plausible-sounding conventions simply to make a blueprint appear complete.
- **Open Decisions Must Remain Open:** Values marked provisional or awaiting Founder adjudication remain `OPEN`.
- **Deferred Work Must Remain Deferred:** Future features or architecture phases are not treated as active implementations.

### 1.2 Domain-Scoped Authority
Rather than a simplistic, global linear hierarchy, KONFRM operates under **Domain-Scoped Authority**. Different categories of truth have distinct, non-overlapping jurisdictions:

```
+----------------------------------------------------------------------------------------------------+
| DOMAIN-SCOPED AUTHORITY JURISDICTIONS                                                              |
+----------------------------------------------------------------------------------------------------+
| 1. PRODUCT & BUSINESS JURISDICTION:                                                                |
|    Founder-approved KONFRM Canon owns booking behavior, financial rules, user roles, product       |
|    priorities, and UX product decisions. External generic best practices cannot redefine them.    |
+----------------------------------------------------------------------------------------------------+
| 2. MANDATORY PLATFORM & STORE JURISDICTION:                                                        |
|    First-party Apple, Google, and Android platform specifications govern technical eligibility and  |
|    store submission constraints. Founder Canon cannot declare a mandatory store submission         |
|    requirement irrelevant. (The Founder may choose not to ship to a platform or feature, but       |
|    cannot compel an external platform to accept a non-compliant artifact).                         |
+----------------------------------------------------------------------------------------------------+
| 3. SECURITY JURISDICTION:                                                                          |
|    Security standards constrain safe implementation and identify unacceptable risk. Security       |
|    guidance cannot silently alter product economics or business logic. Material trade-offs must be |
|    escalated as PRODUCT_REQUIREMENT x SECURITY_CONSTRAINT, never silently overwritten.             |
+----------------------------------------------------------------------------------------------------+
| 4. REPOSITORY REALITY JURISDICTION:                                                                |
|    Actual committed source code and verified runtime evidence own statements about what currently  |
|    exists physically. Intended architecture or documentation cannot claim an implementation exists |
|    when code and runtime evidence say otherwise.                                                   |
+----------------------------------------------------------------------------------------------------+
```

### 1.3 Authority by Question Type
To establish instant epistemic clarity, agents resolve questions against their authoritative source of truth:

```text
QUESTION TYPE                         SOURCE OF TRUTH
What should KONFRM do?               Project Canon / accepted Founder decision
What does KONFRM code do now?        Current repository + runtime evidence
How should engineering work?         Governed/pinned engineering method
What does platform/store require?    Live first-party official source
What security control applies?       Current threat surface + governed security baseline
What remains undecided?              OPEN / unresolved authority record
```

### 1.4 The Core Law: Capability Family != Runtime Skill
KONFRM distinguishes internal capability from agent runtime interfaces:
> **A Capability Family is an internal engineering competence module.**
> **A Runtime Skill is a coarse-grained, end-to-end Domain Brain.**

Runtime skills are the visible entry points exposed to coding agents. Capability families are competence units organized as companion reference modules (`references/*.md`) within their governing domain brain. Agents must never be presented with fragmented tools when 7 coherent domain brains provide complete contextual authority.

### 1.5 The Target 7-Domain-Brain Direction
KONFRM organizes engineering, product, design, and release intelligence into **7 Governed Domain Brains**:

```
+----------------------------------------------------------------------------------------------------+
|                                    KONFRM AGENT OPERATING LAYER                                    |
|                               (Antigravity / Codex / Compatible Agents)                             |
+----------------------------------------------------------------------------------------------------+
                                                  |
                         +------------------------+------------------------+
                         |  Deterministic Context Router: .agents/CONTEXT_MAP.yaml  |
                         +------------------------+------------------------+
                                                  |
         +----------------------------------------+----------------------------------------+
         |                                        |                                        |
+--------v-------+                       +--------v-------+                       +--------v-------+
| konfrm-product |                       | konfrm-design  |                       | konfrm-quality |
| Product Soul,  |                       | DF2 Authority, |                       | Root Cause RCA,|
| Role Invariants|                       | Arabic RTL,    |                       | Tests, Review, |
| Truth Retrieval|                       | Visual QA      |                       | Security Audit |
+--------+-------+                       +--------+-------+                       +--------+-------+
         |                                        |                                        |
         |         +---------------------+        |        +---------------------+         |
         +-------->|    konfrm-flutter   |<-------+------->| konfrm-admin-web    |<--------+
         |         | Flutter Core Client,|        | React 19, Vite, Web |         |
         |         | Presentation/App/Data        | Ergonomics, Tables  |         |
         |         +----------+----------+        |        +----------+----------+         |
         |                    |                   |                   |                    |
         |                    +---------+         |         +---------+                    |
         |                              |         |         |                              |
         |                     +--------v---------v---------v--------+                     |
         |                     |            konfrm-backend           |                     |
         |                     |  Cloudflare Worker, Supabase REST,  |                     |
         |                     |  PostgreSQL RLS, Financial Impl.    |                     |
         |                     +------------------+------------------+                     |
         |                                        |                                        |
         +----------------------------------------+----------------------------------------+
                                                  |
                                         +--------v--------+
                                         | konfrm-delivery |
                                         | Git Safety, CI, |
                                         | Store Policy,   |
                                         | Release Gates   |
                                         +-----------------+
```


## 2. FORENSIC AUDIT & DUPLICATION MATRIX OF CURRENT SKILL REALITY

### 2.1 Complete Inventory of Current 14 Skills
The repository currently contains 14 skills distributed across `.agents/skills/`, `docs/ai/skills/`, and obsolete mirrors in `.zcode/skills/`:

| Skill Identifier | Physical Location | Origin / Upstream | Stated Purpose | Operational Flaw / Overlap |
| :--- | :--- | :--- | :--- | :--- |
| `impeccable-wrapper` | `.agents/skills/impeccable-wrapper/` | Impeccable Design Engine | Polish, critique, distill UI design | Competes with DF2 Canon; attempts to impose foreign web tokens on Flutter mobile. |
| `ui-ux-pro-max-wrapper` | `.agents/skills/ui-ux-pro-max-wrapper/` | UI/UX Pro Max Intelligence | Multi-stack UI/UX guidelines | High prompt overhead; generic recommendations duplicate native `konfrm-mobile-design`. |
| `emil-wrapper` | `.agents/skills/emil-wrapper/` | Emil Kowalski Animations | Micro-interactions and motion curves | Redundant motion heuristics; conflicts with KONFRM transactional motion constraints. |
| `frontend-design-wrapper`| `.agents/skills/frontend-design-wrapper/` | Anthropic Frontend Design | Anti-generic web layout & typography | Web-biased; duplicates Cairo typography rules and RTL bidi isolation. |
| `vercel-composition-wrapper` | `.agents/skills/vercel-composition-wrapper/` | Vercel React Patterns | React compound component patterns | Web-only; leaked into mobile Flutter tasks due to lack of surface gating. |
| `vercel-web-guidelines-wrapper`| `.agents/skills/vercel-web-guidelines-wrapper/`| Vercel Web Guidelines | Web performance & accessibility | Competes with `konfrm-accessibility`; irrelevant to Flutter mobile shell. |
| `konfrm-design-router` | `docs/ai/skills/konfrm-design-router/` | Internal Repo Native | Design task triage and skill activation | Intermediate router meta-skill; forces 2-step routing overhead on simple edits. |
| `konfrm-design-court` | `docs/ai/skills/konfrm-design-court/` | Internal Repo Native | Multi-role design debate adjudication | Overly complex debate simulation; slow for standard, deterministic implementation tasks. |
| `konfrm-design-reasoning`| `docs/ai/skills/konfrm-design-reasoning/`| Internal Repo Native | Structured design dialectics & perception | Overlaps with `konfrm-product-ux` and `konfrm-design-court`. |
| `konfrm-product-ux` | `docs/ai/skills/konfrm-product-ux/` | Internal Repo Native | Product UX, 3-role models, state grammar| Splits authority with `konfrm-mobile-design` on state grammar and booking flows. |
| `konfrm-mobile-design` | `docs/ai/skills/konfrm-mobile-design/` | Internal Repo Native | DF2 mobile layout & component rules | Core authority fragmented across 5 other design sub-skills. |
| `konfrm-rtl-arabic` | `docs/ai/skills/konfrm-rtl-arabic/` | Internal Repo Native | Arabic typography, RTL, bidi isolation | Isolated skill that should be an intrinsic foundation of all mobile UI work. |
| `konfrm-accessibility` | `docs/ai/skills/konfrm-accessibility/` | Internal Repo Native | Platform accessibility standards | Disconnected from core component building; treated as an afterthought. |
| `konfrm-visual-qa` | `docs/ai/skills/konfrm-visual-qa/` | Internal Repo Native | Device viewports, visual state verification | Disconnected from testing lifecycle; belongs inside quality verification. |

### 2.2 Duplication & Contradiction Matrix
The fragmentation across these 14 skills created direct contradictions and repetitive guidance across 6 critical engineering domains:

```
+-----------------------------------------------------------------------------------------------------------------------------------+
| DOMAIN AREA       | FRAGMENTED OWNERS                             | NATURE OF CONFLICT / DUPLICATION                             |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| UI State Grammar  | konfrm-product-ux, konfrm-mobile-design,      | Competed over state definitions; web wrappers imported toast/ |
|                   | ui-ux-pro-max-wrapper                         | skeleton patterns instead of product-contract truthful states.|
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Arabic RTL / Bidi | konfrm-rtl-arabic, frontend-design-wrapper,   | konfrm-rtl-arabic enforced Western Arabic numerals and start/ |
|                   | konfrm-mobile-design                          | end semantics; frontend wrapper attempted to mirror all axes. |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Accessibility     | konfrm-accessibility, ui-ux-pro-max-wrapper,  | Mobile touch targets conflicted with web click target tokens; |
| & Touch Targets   | vercel-web-guidelines-wrapper                 | web wrapper introduced desktop assumptions to mobile screens. |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Motion & Animation| emil-wrapper, impeccable-wrapper,             | External wrappers introduced spring animations (400ms-600ms); |
|                   | konfrm-mobile-design                          | KONFRM mandates restrained, non-blocking transactional motion.|
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Component         | vercel-composition-wrapper,                   | React compound component patterns (Context, children cloning) |
| Architecture      | frontend-design-wrapper                       | inadvertently suggested for Flutter widgets.                  |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Code Review &     | konfrm-visual-qa, konfrm-design-court,        | Visual QA treated review as screenshot check; Court ran       |
| Quality Gates     | AGENTS.md Quality Gates                       | debates; neither integrated with Dart analyzer or CI gates.   |
+-----------------------------------------------------------------------------------------------------------------------------------+
```


## 3. AUTHORITY SEPARATION & OWNERSHIP MODEL V2

### 3.1 The Principle: One Truth Definition = One Authority
The simplistic assumption that "One Concept = One Brain" is replaced with an authoritative lifecycle separation:
> **ONE TRUTH DEFINITION = ONE GOVERNING AUTHORITY**
> **Lifecycle Execution: DEFINE -> REPRESENT -> IMPLEMENT -> VERIFY -> RELEASE**

Legitimate cross-domain consumption is not duplicate ownership. Duplication exists only when two brains independently **define** the same truth.

### 3.2 Financial Authority Separation
Financial rules cannot be owned by Backend simply because Backend writes the code:
- **`DEFINE` (Authoritative Business Canon / Product):** Defines pricing principles, fee structures, payout schedules, and refund policies strictly anchored in `docs/BUSINESS_RULES.md` and explicit Founder decisions. Backend is strictly forbidden from inventing financial formulas.
- **`IMPLEMENT` (Backend):** Implements server-authoritative calculations, ledger transactions, and payment gateway webhooks.
- **`VERIFY` (Quality):** Verifies financial invariants with boundary tests, negative-value guards, rounding checks, and idempotency tests.
- **`RELEASE` (Delivery):** Audits release gates and ensures payment compliance before production deployment.

### 3.3 Semantic / Presentation / Implementation / Verification Ownership
This separation applies across all cross-domain concepts:

```
+---------------------------------------------------------------------------------------------------+
| CONCEPT           | DEFINE (Authority)| REPRESENT (UI/UX) | IMPLEMENT (Code)  | VERIFY (Quality)  |
+-------------------+-------------------+-------------------+-------------------+-------------------+
| UI States         | konfrm-product    | konfrm-design     | konfrm-flutter /  | konfrm-quality    |
|                   | (Business states) | (Visual states)   | konfrm-admin-web  | (State testing)   |
+-------------------+-------------------+-------------------+-------------------+-------------------+
| Financial Ledger  | konfrm-product    | konfrm-design     | konfrm-backend    | konfrm-quality    |
|                   | (Business rules)  | (Price formatting)| (Server engine)   | (Financial tests) |
+-------------------+-------------------+-------------------+-------------------+-------------------+
| Booking Flows     | konfrm-product    | konfrm-design     | konfrm-flutter /  | konfrm-quality    |
|                   | (State machine)   | (Interaction flow)| konfrm-backend    | (Integration test)|
+-------------------+-------------------+-------------------+-------------------+-------------------+
| Accessibility     | Product (Roles) & | konfrm-design     | konfrm-flutter /  | konfrm-quality    |
|                   | Platform Standards| (Interaction/spec)| konfrm-admin-web  | (Semantics audit) |
+-------------------+-------------------+-------------------+-------------------+-------------------+
| Security Controls | Threat Surface &  | konfrm-design     | konfrm-flutter /  | konfrm-quality    |
|                   | Governed Baseline | (Obscuring views) | konfrm-backend    | (MASVS audit)     |
+---------------------------------------------------------------------------------------------------+
```

### 3.4 Disambiguated Ownership Mapping

| Concept Area | Definitive Authority (`DEFINE`) | Presentation Authority (`REPRESENT`) | Implementation Authority (`IMPLEMENT`) | Verification Authority (`VERIFY`) |
| :--- | :--- | :--- | :--- | :--- |
| **Rental Business Rules** | `docs/BUSINESS_RULES.md` / `konfrm-product` | `konfrm-design` | `konfrm-backend` & `konfrm-flutter` | `konfrm-quality` |
| **User Roles & Mental Models** | `konfrm-product` | `konfrm-design` | `konfrm-flutter` & `konfrm-admin-web` | `konfrm-quality` |
| **Visual Design & DF2 Identity** | `DESIGN_SYSTEM/` / `konfrm-design` | `konfrm-design` | `konfrm-flutter` & `konfrm-admin-web` | `konfrm-quality` |
| **Typography & RTL Arabic** | `konfrm-design` | `konfrm-design` | `konfrm-flutter` & `konfrm-admin-web` | `konfrm-quality` |
| **Mobile Architecture** | `docs/architecture/` / `konfrm-flutter` | N/A | `konfrm-flutter` | `konfrm-quality` |
| **Admin Web Architecture** | `konfrm-admin-web` | `konfrm-design` | `konfrm-admin-web` | `konfrm-quality` |
| **Persistence & Edge Proxy** | `docs/DATABASE.md` / `konfrm-backend` | N/A | `konfrm-backend` | `konfrm-quality` |
| **Root-Cause Debugging (RCA)** | `konfrm-quality` | N/A | Implementation Brains | `konfrm-quality` |
| **Testing Strategy** | `konfrm-quality` | N/A | Implementation Brains | `konfrm-quality` |
| **Release & Store Compliance** | `konfrm-delivery` | N/A | Implementation Brains | `konfrm-delivery` |


## 4. TARGET 7-BRAIN CONSOLIDATED SPECIFICATIONS

### 4.1 Internal Brain Modular Anatomy (`MINIMAL_SUFFICIENT_RUNTIME_CONTEXT`)
To prevent domain brains from becoming bloated mega-skills, each brain adheres to a two-tier modular directory structure:

```
.agents/skills/<brain-name>/
├── SKILL.md                  <-- Fast Router, Invariants, Core Lifecycle Workflow
└── references/               <-- Lazy-Loaded Deep Knowledge Modules (Loaded on demand)
    ├── <module-1>.md
    ├── <module-2>.md
    └── <module-3>.md
```

- **Root `SKILL.md`:** Compact enough for fast routing and immediate execution. Contains domain scope, governing invariants, standard execution workflow, reference index, and handoff contracts. Correctness and clarity outrank arbitrary line count limits.
- **Companion Reference Modules (`references/*.md`):** Deep domain instructions, code patterns, and verification checklists loaded only when a task requires them.

---

### 4.2 Brain 1: `konfrm-product` (Product Soul & Domain Truth)
- **Primary Mission:** Preserve authentic business logic, user psychology, and market reality by interpreting and retrieving authoritative Business Canon.
- **Truth Retrieval Mandate:** Runtime Product brain owns **PRODUCT INTERPRETATION and RETRIEVAL**, not a duplicated business rules database. It points directly to `docs/BUSINESS_RULES.md` and `docs/codex/KONFRM_MASTER_RULES.md`.
- **Governing Scope:**
  - Defines/interprets: Product goals, business semantics, user-role intent (Customer, Owner, Admin), accepted product rules, and market assumptions that are explicitly documented.
  - Epistemic distinction: Distinguishes between `ACCEPTED_CANON`, `VALIDATED_RESEARCH_INSIGHT`, `FOUNDER_HYPOTHESIS`, and `OPEN_ASSUMPTION`.
  - Boundaries: Product brain does NOT define technical security controls or WCAG/platform accessibility standards. It provides sensitive product context, trust expectations, and user needs; Security, Design, and Platform authorities translate those into controls.
- **Companion Modules:**
  - `references/product_state_retrieval.md`: How to inspect and interpret authoritative business rules.
  - `references/role_mental_models.md`: Customer, Owner, and Admin behavioral priorities and friction tolerances.
- **Boundaries:** Does not write code or migrations. Hands off rules to `konfrm-design` and `konfrm-backend`.

---

### 4.3 Brain 2: `konfrm-design` (Unified UI/UX Authority)
- **Primary Mission:** Enforce the single visual and interaction design truth across all surfaces, adhering to Design Foundation 2 (DF2 v1.7).
- **Governing Invariants:**
  - DF2 Foundations: Monochrome-first identity. Primary Black is provisional/governed, not immutable visual law. Color is reserved for semantic statuses and restrained accents. Open design values remain `OPEN`.
  - Cairo Typography: Strict typographic scale, explicit line heights, tabular figures for numeric prices (`ج.م`).
  - Native RTL Arabic: Start/End logical alignment, bidirectional text isolation, Western Arabic numerals (0-9) as default.
  - Applicable Truthful States: Components implement only `APPLICABLE_TRUTHFUL_STATES` defined by their product contract. No manufacturing of unused states for apparent completeness.
  - Motion: Purposeful, restrained micro-interactions. No blocking animations. Duration and curves follow current design Canon.
  - Platform Touch Ergonomics: Platform touch guidance is approximately Android: ~48dp, iOS: ~44pt, adhering to current platform/design Canon.
  - Accessibility Authority: Defines accessible interaction and presentation specifications translating user needs and platform criteria into design reality.
- **Companion Modules:**
  - `references/df2_tokens_and_components.md`: DF2 component contracts and token mappings.
  - `references/arabic_rtl_bidi.md`: Bidirectional text handling and RTL layout flipping.
  - `references/accessibility_standards.md`: Platform accessibility guidelines and screen reader semantics.
  - `references/visual_qa_checklist.md`: Visual state verification and RTL alignment checks.
- **Boundaries:** Defines visual/interaction contracts. Hands off implementation to `konfrm-flutter` and `konfrm-admin-web`.

---

### 4.4 Brain 3: `konfrm-flutter` (Mobile Implementation Brain)
- **Primary Mission:** Implement production-grade Flutter client applications for Android and iOS adhering to canonical mobile architecture.
- **Architectural Baseline:** Governed by `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md` and `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`:
  - **Feature-First Architecture:** Organized into `presentation / application / data` (NO mandatory `domain/` layer; avoids over-abstracted Clean Architecture ceremony).
  - **State Management:** Riverpod for application state. Architecture does not over-canonize a single provider class where not required.
  - **Navigation:** Declarative `go_router` with strong typing and route guards. Deep-link architecture supported; concrete URL scheme remains deferred until canonically established.
  - **Networking & Serialization:** Standard `package:http` initially; manual DTO/adapter mapping (`fromMap`/`toMap`) initially. Zero uninspected code generation.
  - **Secure Storage:** Uses the KONFRM secure-storage abstraction backed by platform-appropriate protected storage (e.g. Android KeyStore, iOS Keychain). Concrete plugin is an implementation choice, not Canon.
  - **Fail-Closed UI:** Honest error feedback via `AsyncValue`; never swallow exceptions or display partial corrupted state.
  - **Offline Policy:** No generic offline mutation replay; no local financial authority.
  - **Credential Isolation:** Strict Customer and Owner credential isolation.
- **Companion Modules:**
  - `references/feature_architecture.md`: Feature folder layout (`presentation/`, `application/`, `data/`).
  - `references/widget_patterns.md`: Composing DF2 widgets and responsive layouts.
  - `references/dto_and_networking.md`: Manual DTO parsing and HTTP error handling.
  - `references/native_shell_bridge.md`: Android and iOS native shell integration contracts.
- **Boundaries:** Implements mobile code. Relies on `konfrm-backend` for server contracts and `konfrm-quality` for verification.

---

### 4.5 Brain 4: `konfrm-admin-web` (Web Interface Authority)
- **Primary Mission:** Build and maintain the KONFRM Admin Operations web dashboard with high operational density.
- **Governing Invariants:**
  - React 19, TypeScript, and Vite stack located in `admin-app/`.
  - Admin UX Invariant: **OPERATIONAL CLARITY + USEFUL DENSITY + AUDITABILITY + SAFE ACTIONABILITY**. Actual interaction patterns (tables, filter grids, batch actions, keyboard shortcuts) are selected according to the operational task, not imposed as universal widget mandates.
  - Web Standards: Semantic HTML5, full keyboard navigation, accessible contrast.
  - Desktop-First Ergonomics: Optimized for desktop operational workflows.
- **Companion Modules:**
  - `references/admin_table_patterns.md`: Dense data grid patterns and batch actions.
  - `references/react_composition_rules.md`: Component composition and hook encapsulation.
  - `references/web_performance_accessibility.md`: Web accessibility and Core Web Vitals.
- **Boundaries:** Isolated strictly to `admin-app/`. Zero cross-contamination with Flutter mobile architecture.

---

### 4.6 Brain 5: `konfrm-backend` (Cloudflare & Supabase Authority)
- **Primary Mission:** Enforce server-side security, transactional integrity, and edge routing across Cloudflare Workers and Supabase PostgreSQL.
- **Governing Invariants:**
  - PostgreSQL Canonical Persistence: Supabase database is the source of truth for transactions, foreign keys, and audit logs.
  - Row-Level Security (RLS): User-accessible and exposed data surfaces must be protected by appropriate RLS or equivalent server-only isolation. Private schemas and server-only tables use appropriate isolation. The Supabase `service_role` key is NEVER exposed to client apps.
  - Server Financial Authority: Calculations and ledger mutations executed strictly on server per Business Canon. Backend never invents financial rules.
  - Migration Reality: Safe, tested, ordered migrations with an explicit recovery strategy. Forward migration safety, data preservation, and transactional boundaries outrank artificial reversible rollback requirements.
  - Physical Reality Classification: Backend controls must be labeled as `CURRENT_VERIFIED`, `REQUIRED_ARCHITECTURE`, `RECOMMENDED_HARDENING`, or `FUTURE_CAPABILITY` based on physical code reality.
- **Companion Modules:**
  - `references/supabase_rls_patterns.md`: Multi-tenant RLS isolation templates.
  - `references/database_migration_protocol.md`: Migration authoring standards and indexing rules.
  - `references/cloudflare_worker_proxy.md`: Worker lifecycle and Supabase REST adapter queries.
  - `references/financial_implementation.md`: Ledger transactions and payment webhook handlers.
- **Boundaries:** Implements server reality. Client brains consume contracts without schema write authority.

---

### 4.7 Brain 6: `konfrm-quality` (Verification, Debugging & Security Engine)
- **Primary Mission:** Guarantee structural correctness, runtime stability, and security posture through deterministic verification.
- **Governing Invariants:**
  - RCA Oracle Model: **REPRODUCE WITH THE SMALLEST CREDIBLE ORACLE**. Preferred when feasible: failing automated regression test. Valid reproductions include physical-device reproduction, accessibility tree evidence, integration failure, API trace, database state evidence, store rejection message, or deployment log. Never manufacture an artificial unit test merely to satisfy a debugging ritual. After fix, add regression automation where practical and valuable.
  - Repository-Defined Static Analysis: Run the repository-defined static analysis gate for the affected surface (`flutter analyze` for Flutter packages, `dart analyze` for pure Dart). Strictness follows repository configuration and task gates; skills do not redefine analyzer policy independently.
  - Test Taxonomy: Testing spans application/business logic, pure utilities, DTO/adapters, widgets, API contracts, and integration/system boundaries (no mandatory domain layer).
  - Golden Testing: Classified as `ON_DEMAND_VISUAL_REGRESSION_TOOL` for deterministic pixel validation; does not replace physical runtime visual QA.
  - Dual-Axis Code Review: Evaluating changes against Specification Axis (prompt fidelity) and Standards Axis (architectural integrity).
  - Security Verification: Audits client and server controls against selected security baselines (OWASP MASVS v2.0).
  - Performance: Measurement-driven frame/jank/performance profiling using Flutter DevTools across variable refresh rates (60Hz, 90Hz, 120Hz).
- **Companion Modules:**
  - `references/systematic_debugging_rca.md`: 4-phase RCA protocol and oracle selection.
  - `references/flutter_testing_playbook.md`: Golden testing, HTTP boundary mocking, and accessibility testing.
  - `references/code_review_dual_axis.md`: Structured standards and spec review checklists.
  - `references/mobile_security_masvs.md`: OWASP MASVS v2.0 verification controls.
  - `references/performance_profiling.md`: Measurement-driven DevTools profiling.
- **Boundaries:** Governs verification and debugging. Hands off verified artifacts to `konfrm-delivery`.

---

### 4.8 Brain 7: `konfrm-delivery` (Release, Git & Store Readiness Authority)
- **Primary Mission:** Govern branch lifecycles, CI verification, App Store / Play Store compliance, and memory synchronization.
- **Governing Invariants:**
  - Git Preflight & Safety: Branch awareness (`git rev-parse HEAD`, `git rev-parse origin/main`), candidate ancestry verification, conventional commits.
  - CI Gate Audit: Verifying that tests, analyzer, format, and build pass with concrete proof.
  - Store Policy Live-Check: Managing store compliance via the Volatile Knowledge Model, verifying live official requirements before release.
  - Platform vs Store Distinction: Distinguishes technical OS requirements (Android/iOS) from conditional store policies (Google Play / App Store).
  - PR Closure Handshake: Autonomous execution of final verification, documentation reconciliation, and merge protocols.
  - Memory Backpropagation: Updating `CURRENT_STATE.md` and decision records upon PR closure.
- **Companion Modules:**
  - `references/git_branch_lifecycle.md`: Worktree hygiene, preflight checks, commit formatting, and merge rules.
  - `references/google_play_store_policy.md`: Play Store compliance checklist and volatile requirement cache.
  - `references/apple_app_store_policy.md`: App Store Review Guidelines checklist and volatile requirement cache.
  - `references/ugc_moderation_compliance.md`: User-generated content compliance requirements.
  - `references/pr_closure_handshake.md`: Step-by-step PR closure verification runbook.
- **Boundaries:** Release engineering and store compliance. Hands off code fixes to implementation brains.


## 5. EXTERNAL INTELLIGENCE SOURCES & FORENSIC MATRIX

### 5.1 Source Quality Hierarchy
External engineering sources are classified into a 4-tier trust hierarchy governed by domain-scoped authority:

```
+----------------------------------------------------------------------------------------------------+
| TIER A: FIRST-PARTY & OFFICIAL PLATFORM SPECIFICATIONS                                             |
| Flutter/Dart Official Docs, Android Developers / android/skills, Apple Developer Guidelines,      |
| Supabase Official Architecture, Cloudflare Workers Runtime Specs.                                  |
| Status: PRIMARY TECHNICAL BENCHMARK FOR APIS & STORE RULES. Where official docs present multiple   |
|         architectural choices, KONFRM Canon selects the project architecture (e.g. Riverpod).     |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| TIER B: GOVERNING INDUSTRY STANDARDS & SECURITY FRAMEWORKS                                         |
| OWASP Mobile Application Security (MASVS v2.0 / MASTG), NIST SSDF 1.1 (SP 800-218),               |
| W3C WCAG Baseline.                                                                                 |
| Status: SELECTED ENGINEERING & VERIFICATION BASELINE. (Not a compliance or certification claim).    |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| TIER C: HIGH-QUALITY SPECIALIST OPEN SOURCE & METHODOLOGIES                                        |
| Obra Systematic Debugging, Matt Pocock Type Patterns, Deloitte Assured Engineering.                |
| Status: METHODOLOGICAL INGREDIENTS (Distilled into project-native workflows).                      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| TIER D: DESIGN & INTERACTION HEURISTICS                                                            |
| UIZZE, Impeccable Design Engine, Emil Kowalski Motion Principles, Taste Heuristics.                |
| Status: STRICTLY ADVISORY (Subordinated to DF2 Canon & RTL Arabic Rules).                         |
+----------------------------------------------------------------------------------------------------+
```

### 5.2 Forensic Matrix of External Sources

| Source Name | Upstream Anchor / Commit | Quality Tier | Evaluated Value | Risk / Conflict with KONFRM | Architectural Disposition |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Official Flutter / Dart Docs** | Official SDK (Dart 3.x / Flutter 3.x) | Tier A | State management, rendering pipeline, widget tree optimization. | Official docs show multiple patterns (ChangeNotifier vs Riverpod); Canon selects Riverpod. | **ADOPT CORE**: Incorporated into `konfrm-flutter` and `konfrm-quality`. |
| **Android Skills (`android/skills`)** | Commit `42dc2270e96032bd860bb94511e440aa00a43125` | Tier A | Platform requirements, 16 KB pages, insets handling, Data Safety. | Assumes Jetpack Compose; Compose is not a KONFRM Flutter implementation authority. | **EXTRACT PLATFORM**: Platform rules to `konfrm-delivery`; Compose rejected for Flutter. |
| **Google Play Policy Guidelines** | Official Play Console Policy | Tier A | Target SDK enforcement, Account Deletion, Photo Picker guidelines. | Policy drifts over time; requires volatile verification. | **ADOPT POLICY**: Governed in `konfrm-delivery` (Volatile Policy). |
| **Apple App Store Review Guidelines** | Official Apple Developer Guidelines | Tier A | Guideline 3.1.5b (Physical Goods), Privacy Manifests, Required Reasons. | Rejection risk if payment exemption or manifest is misconfigured. | **ADOPT POLICY**: Governed in `konfrm-delivery` (Volatile Policy). |
| **Supabase Architecture Guides** | Official Supabase Documentation | Tier A | RLS patterns, database indexing, connection pooling. | Client must not bypass Cloudflare Worker proxy. | **ADOPT CORE**: Distilled into `konfrm-backend`. |
| **Cloudflare Workers Docs** | Official Cloudflare Developer Docs | Tier A | Edge request handling, environment secrets, header sanitation. | Worker SQL compatibility limits with Supabase REST must be respected. | **ADOPT CORE**: Distilled into `konfrm-backend`. |
| **OWASP MASVS v2.0 / MASTG** | OWASP Mobile Application Security | Tier B | Mobile security verification (Storage, Crypto, Auth, Network). | High overhead if applied without risk tiering. | **ADOPT AUDIT**: Distilled into `konfrm-quality` as verification baseline. |
| **NIST SSDF 1.1 (SP 800-218)** | NIST Computer Security Division | Tier B | Secure software development practices (PO, PS, PW, RV). | Enterprise process lens; distilled only after evaluating relevance to Git Safety. | **ADOPT PROCESS**: Integrated into quality and delivery gates. |
| **Obra Systematic Debugging** | Upstream Debugging Methodology | Tier C | 4-Phase RCA: Reproduce, Isolate, Root-cause, Verify without regression. | Oracle must be proportionate to bug; avoid test dogma. | **ADOPT RCA**: Governing debugging workflow in `konfrm-quality`. |
| **Matt Pocock Type Patterns** | TypeScript Pattern Repository | Tier C | Parse don't validate, boundary typing. | Translate TypeScript patterns to Dart static typing. | **TRANSLATE PATTERNS**: Adapted for DTOs and Worker TypeScript. |
| **Deloitte Assured Engineering** | Assured Engineering Principles | Tier C | Evidence-based quality gates, deterministic audit trails. | Distill into Git-backed proof artifacts. | **ADOPT EVIDENCE**: Anchors evidence-based quality gates. |
| **Impeccable Design Engine** | Impeccable Design Skills | Tier D | Visual polish checklists, layout hierarchy reasoning. | Foreign web tokens and pastel palettes conflict with DF2. | **HEURISTIC ADVISORY**: Filtered heuristics to `konfrm-design`; zero tokens. |
| **Emil Kowalski Motion Principles** | Motion Design Heuristics | Tier D | Purposeful micro-interactions, responsive tactile feedback. | Long spring animations conflict with transactional speed. | **RESTRICT MOTION**: Restrained micro-interactions to `konfrm-design`. |
| **UI/UX Pro Max Intelligence** | UI/UX Pro Max Skills | Tier D | Multi-platform design reasoning, accessibility heuristics. | High prompt overhead; generic recommendations shadow Canon. | **FILTERED EXTRACTION**: Extracted accessibility tips to `konfrm-design`. |


## 6. OFFICIAL ANDROID SKILLS EVALUATION (`android/skills`)

### 6.1 Architectural Context & Commit Baseline
The official Google Android agent skills repository (`android/skills` at commit `42dc2270e96032bd860bb94511e440aa00a43125`) provides first-party Android platform intelligence. Because KONFRM uses Flutter for mobile, patterns are classified into distinct technical categories.

### 6.2 4-Way Technical Categorization Matrix

```
+----------------------------------------------------------------------------------------------------+
| 1. ANDROID_PLATFORM_REQUIREMENT (Mandatory for all Android apps, including Flutter)                |
| - Target API enforcement timeline.                                                                 |
| - 16 KB Page Size ELF alignment in native C/C++ shared objects (.so files).                         |
| - Edge-to-Edge window insets handling.                                                             |
| - Google Play Data Safety declaration disclosures.                                                 |
| Disposition: FULL ADOPTION into konfrm-delivery and native Android shell.                           |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 2. FLUTTER_APPLICABLE (Platform concepts that translate directly to Flutter APIs)                  |
| - WindowInsets and system bars padding -> consumed via Flutter insets/padding APIs.                |
| - Predictive Back Gesture -> Flutter PopScope handling.                                            |
| - Photo selection -> system Photo Picker where platform/plugin supports it.                        |
| - Notification Channels & Permissions -> standard platform notification channels.                  |
| Disposition: TRANSLATE TO FLUTTER PATTERNS in konfrm-flutter.                                      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 3. NATIVE_SHELL_ONLY (Configured strictly within android/ native subproject)                       |
| - android/app/build.gradle.kts configuration (compileSdk, targetSdk, ndkVersion).                 |
| - AndroidManifest.xml permissions, intent filters, and exported component security.               |
| - ProGuard / R8 code shrinking and native library keep rules for JVM/native bytecode.             |
| - 16 KB alignment verification on packaged native binaries.                                        |
| Disposition: ADOPT IN NATIVE RUNTIME CONFIGURATION within konfrm-delivery and android/ shell.      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 4. NOT_A_KONFRM_FLUTTER_AUTHORITY (Incompatible with Flutter Architecture)                         |
| - Jetpack Compose @Composable functions, remember / mutableStateOf state management.              |
| - Compose Modifier layouts, LazyColumn / LazyRow optimization.                                     |
| - Jetpack Navigation compose graphs and Hilt dependency injection.                                 |
| Disposition: NOT A KONFRM FLUTTER IMPLEMENTATION AUTHORITY. If a future bounded native Android     |
| surface genuinely requires native UI, that requires an explicit architecture decision.            |
+----------------------------------------------------------------------------------------------------+
```


## 7. STORE READINESS & PLATFORM COMPLIANCE ARCHITECTURE

Store readiness governs development decisions from the start to prevent release blocks.

### 7.1 Google Play Store Compliance Architecture
All Android release artifacts governed by `konfrm-delivery` must satisfy:

1. **Target API Level (Volatile Policy):**
   - Observed Requirement (verified 2026-10-07): Starting August 31, 2026, new apps and updates generally must target **Android 16 / API 36+**.
   - Verification rule: Reverify live against official Play Console requirements before release.
2. **16 KB Page Size Compatibility (Volatile Platform Requirement):**
   - Google requires apps targeting Android 15/API 35+ on Play to support 16 KB page sizes on 64-bit devices.
   - Enforcement note: Updates lacking support will be blocked from release starting February 1, 2027.
   - Verification gate: Inspect final AAB/APK native libraries (`libflutter.so`, `libapp.so`, and third-party native plugin `.so` files) using official Android verification guidance (`llvm-objdump -p <lib>/*.so | grep -A 1 -i load`). Remediate impacted artifacts/plugins.
3. **Edge-to-Edge Layout:**
   - On Android 15+ (API 35+), edge-to-edge is the system default. Flutter must handle system bars and insets correctly so content is not obscured, verified at runtime.
4. **Photo Selection & Media Permissions:**
   - Adhere to the principle of **LEAST PRIVILEGE**. For user property photo uploads, prefer the system Photo Picker where current platform/plugin behavior supports it (requiring no broad storage permissions). If a future feature legitimately requires broader media access, re-evaluate policy.
5. **Account Deletion (Google Play Conditional Policy):**
   - If account creation exists in the app: provide a discoverable in-app account deletion request path and an external web deletion resource, declared in Play Console per current policy.
6. **Data Safety Section:**
   - Truthfully declare collected data, transfer encryption, and retention policies.

---

### 7.2 Apple App Store Compliance Architecture
All iOS release artifacts governed by `konfrm-delivery` must satisfy:

1. **Build Tooling & SDK Baseline (Volatile Policy):**
   - Observed Requirement (verified 2026-10-07): Since April 28, 2026, App Store Connect uploads must use **Xcode 26+** with the **iOS 26 SDK+**.
   - Verification rule: Verify current official App Store Connect build requirements before release.
2. **Apple Privacy Manifests (`PrivacyInfo.xcprivacy`):**
   - Embedded manifest reflecting actual runtime SDK and data behavior.
   - Workflow:
     1. Inspect first-party code.
     2. Inspect actual linked third-party SDKs.
     3. Inspect generated Xcode privacy report where available.
     4. Identify Required Reason API usage.
     5. Choose only Apple-approved reasons truthfully matching actual usage.
     6. Validate manifest.
   - Specific reasons (e.g. `CA92.1`, `35F9.1`) are declared ONLY when justified by actual code/SDK inspection.
   - `NSPrivacyTracking` is declared truthfully based on runtime data behavior, not an assumed static value.
3. **Third-Party Apple SDK Governance:**
   - Audit linked SDKs against Apple's list of SDKs requiring privacy manifests and signatures. (Verify list live against official Apple Developer portal).
4. **Sign in with Apple (Guideline 4.8):**
   - If third-party social logins are offered, evaluate Guideline 4.8 and its exceptions against the actual authentication configuration.
5. **Account Deletion (Guideline 5.1.1v):**
   - If account creation exists: allow people to initiate account deletion in-app. Deletion may be asynchronous/manual if reasonable and transparent. Respect legally required data retention.

---

### 7.3 Vacation Rental & Physical Accommodation Payment Policy
Store review requires precise classification of transaction categories:

```
+----------------------------------------------------------------------------------------------------+
| STORE POLICY TRUTH: VACATION RENTALS ARE REAL-WORLD PHYSICAL SERVICES                             |
+----------------------------------------------------------------------------------------------------+
| APPLE APP STORE GUIDELINE 3.1.5(b) - GOODS AND SERVICES OUTSIDE OF THE APP:                        |
| Services delivered outside the app (such as real-world accommodation bookings) are exempt from     |
| Apple In-App Purchase (IAP). Apple policy requires non-IAP payment methods for such services.       |
| -> StoreKit is NOT used for accommodation booking transactions.                                    |
+----------------------------------------------------------------------------------------------------+
| GOOGLE PLAY BILLING POLICY - PHYSICAL GOODS & REAL-WORLD SERVICES:                                |
| Google Play Billing must not be used for physical goods and real-world services. Real-world property|
| rentals are exempt from Google Play Billing.                                                       |
| -> Google Play Billing is NOT used for accommodation booking transactions.                         |
+----------------------------------------------------------------------------------------------------+
```
- **External Payment Methods:** A compatible external payment method or gateway may be used for property bookings subject to: current store policy, provider availability, geography, Egyptian legal/regulatory requirements, KONFRM product decisions, backend security, and commercial terms. Reverify before production launch.
- **Legal/Regulatory Boundary:** Store policy is distinct from Egyptian law and commercial regulations. Payment gateway selection requires dedicated legal and tax evaluation: `LEGAL/REGULATORY REVIEW REQUIRED`. Agents must not claim regulatory compliance by inference.

---

### 7.4 User-Generated Content (UGC), Reviews & Messaging Policy
- **Feature Classification:** Chat and Reviews are currently classified as `FUTURE_FEATURE_OBLIGATION` until activated on the product roadmap.
- **Store Policy Requirements:** When UGC features are introduced, current store policies mandate:
  - Objectionable-content filtering / user agreement.
  - In-app reporting mechanism for listings, reviews, and messages.
  - Blocking mechanism for abusive users.
  - Timely developer response and action against abusive content/users.
  - Contact information for moderation.
  *(Any internal operational response SLA, such as 24 hours, is a Founder/Product/Operations decision, not an externally mandated universal store rule).*


## 8. SECURITY & SUPPLY CHAIN GOVERNANCE ARCHITECTURE

### 8.1 Mobile Security Baseline: OWASP MASVS v2.0
Client security is audited against **OWASP MASVS v2.0** (used as a selected engineering and verification baseline, not an external compliance claim):
- **MASVS-STORAGE:** Sensitive credentials (auth tokens, refresh tokens) use the KONFRM secure-storage abstraction backed by platform-appropriate protected storage (e.g. Android KeyStore, iOS Keychain). Plaintext SharedPreferences / NSUserDefaults are forbidden for secrets. Obscure sensitive views in app switcher where appropriate.
- **MASVS-CRYPTO:** Platform-native cryptographic primitives only; zero custom algorithms or hardcoded keys.
- **MASVS-AUTH:** Non-rotating refresh token semantics are the accepted Auth Canon. Security skills may flag risk as advisories, but may NOT rewrite accepted auth behavior without an explicit architecture/security/product decision.
- **MASVS-NETWORK:** HTTPS/TLS with modern secure configuration. Cleartext HTTP blocked in platform security configs. Zero bypassing of certificate trust verification.
- **MASVS-PLATFORM:** Strict deep-link URI validation via route guards. Least-privilege platform permissions.
- **MASVS-CODE & Release Hardening:**
  - *Android Native Shell:* ProGuard / R8 bytecode shrinking and keep rules applied where appropriate and supported by Flutter tooling; release artifact behavior verified. (R8 shrinks JVM/native-shell bytecode; it is NOT equivalent to Dart symbol obfuscation).
  - *Dart Obfuscation:* Dart obfuscation is a separate optional release-hardening decision. If considered, evaluate crash symbolication, split-debug-info, support workflows, and build operations. It is not a mandatory security control without a dedicated project decision.
  - *iOS:* Governed by current iOS release, compiler, and codesigning behavior.

### 8.2 Backend & Edge Security Baseline
Governed by `konfrm-backend`:
- **Supabase Row-Level Security (RLS):** User-accessible and exposed data surfaces must be protected by appropriate RLS or equivalent server-only isolation. Private schemas and server-only tables use appropriate controls. The `service_role` key is NEVER exposed to client code.
- **Cloudflare Worker Proxying:** Edge proxy sanitizes incoming headers before forwarding to Supabase REST. (Enhancements such as rate limiting are categorized as CURRENT_VERIFIED, REQUIRED_ARCHITECTURE, RECOMMENDED_HARDENING, or FUTURE_CAPABILITY based on physical code reality).

### 8.3 Secure Software Development Lifecycle: NIST SSDF 1.1 Process Lens
Aligned with **NIST SP 800-218 (SSDF 1.1)** as a process lens, not a source of manufactured mandatory controls:
- **Prepare the Organization (PO):** Security invariants documented; domain-scoped authority enforced.
- **Protect the Software (PS):** Branch protection, dependency vulnerability scanning, secrets isolation. (Controls like signed commits are adopted only when explicitly decided by project Canon).
- **Produce Well-Secured Software (PW):** Systematic RCA debugging, static analysis gates, server-authoritative financials.
- **Respond to Vulnerabilities (RV):** Documented vulnerability response runbooks.

### 8.4 Software Supply Chain & Dependency Governance

#### 8.4.1 Static Analysis & Supply Chain Realities
- **CodeQL Scope:** GitHub CodeQL does not currently support Dart/Flutter analysis. CodeQL protects supported repository languages (TypeScript in `admin-app/` and `backend/`). CodeQL passing does NOT equal full repository security.
- **Dart Security Tooling:** The command `dart pub audit` does not exist. Dart pub surfaces known GitHub Advisory Database advisories during dependency resolution (`flutter pub get`). Dependency security relies on: `flutter pub get` advisory output, lockfile inspection, GitHub security capabilities, and verified third-party scanners only if separately approved.

#### 8.4.2 Dependency Risk Evaluation Model
Adding a new third-party dependency requires risk-based evaluation across:
1. **Necessity & Alternatives:** Can functionality be achieved with existing dependencies or minimal first-party code?
2. **Maintainer Identity & Health:** Verified publisher, active maintenance, and release cadence.
3. **Vulnerability Evaluation:** Detect known advisories; determine whether affected versions are used; evaluate applicability, reachability, and exploitability where possible; prefer fixed versions. Unresolved materially applicable high/critical risk blocks admission unless explicitly accepted by authorized project/security authority. (A non-reachable transitive advisory is not identical to an exploitable direct vulnerability, but advisories must never be silently suppressed).
4. **License Compatibility:** Evaluated legally and technically for project suitability.
5. **Transitive Footprint:** Scope of transitive dependencies, native C/C++ code inclusion, platform permissions, and binary size impact.
6. **Lockfile & Constraints:** Ecosystem-appropriate constraints using lockfiles. Critical native or store-sensitive dependencies may justify stricter pinning while balancing security updates.


## 9. PROJECT MEMORY & CONTEXT ROUTING ARCHITECTURE

### 9.1 Two-Tiered Memory Architecture

```
+----------------------------------------------------------------------------------------------------+
| 1. MACHINE ROUTER LAYER: .agents/CONTEXT_MAP.yaml                                                  |
| Format: High-density, machine-parseable YAML. Contains locators and routing metadata ONLY.          |
| Contains ZERO duplicated business rules or design values.                                          |
| Purpose: Deterministic routing table mapping file paths, surfaces, roles, and mission contracts to |
|          domain brains.                                                                            |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 2. NON-AUTHORITATIVE RETRIEVAL COMPASS: docs/agents/KONFRM_PROJECT_COMPASS.md                      |
| Format: Dense architectural orientation guide.                                                     |
| Purpose: Fast orientation and context recovery. Non-authoritative; linked Canon always wins.       |
+----------------------------------------------------------------------------------------------------+
```

### 9.2 Context Map Locators & Trigger Paths
Trigger paths in `.agents/CONTEXT_MAP.yaml` reflect actual repository topology:
- **`admin-app/**`:** Triggers `konfrm-admin-web`.
- **`backend/**`:** Triggers `konfrm-backend`.
- **`customer-app/**`, `owner-app/**`:** Triggers current web applications.
- **`mobile/**` (Future `mobile/customer_app`, `mobile/owner_app`, `mobile/packages`):** Triggers `konfrm-flutter`.
- **`DESIGN_SYSTEM/**`:** Triggers `konfrm-design`.
- **`docs/**`:** Triggers `konfrm-product` for business rules, `docs/architecture/` for architecture boundaries.
- **Combined Signals Routing:** Routes by combined signals: exact file scope + task intent + product surface + role + risk + active mission contract. Naive keyword matching alone is strictly avoided.

### 9.3 Four Principal Knowledge Classes

```
+----------------------------------------------------------------------------------------------------+
| 1. PROJECT_CANON                                                                                   |
| Authoritative project, product, design, and architecture decisions.                                |
| Refresh Rule: Modified ONLY by explicit Founder decision.                                          |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 2. REPOSITORY_REALITY_DYNAMIC                                                                      |
| What currently exists physically at an exact Git commit / runtime environment.                     |
| Required Rule: NEVER infer CURRENT implementation from intended architecture. Inspect source, pin |
|                exact commit/HEAD, and use runtime/backend evidence. Changes every commit.          |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 3. ENGINEERING_METHOD_PINNED                                                                       |
| Audited methods, standards, and patterns chosen to improve execution (e.g. 4-phase RCA, MASVS).    |
| Refresh Rule: Updated via reviewed architecture PRs. Anchored to pinned references.                |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 4. VOLATILE_EXTERNAL_REQUIREMENT                                                                   |
| Live store, platform, and regulatory requirements (e.g. Google Play Target API, Xcode SDK minimums).|
| Refresh Rule: NEVER treated as permanent Canon. Must be verified LIVE against official sources.     |
| Volatile Storage Schema:                                                                           |
|   status: VERIFIED_CURRENT                                                                         |
|   verified_on: YYYY-MM-DD                                                                          |
|   official_source: "<Official URL or Console>"                                                     |
|   observed_requirement: "<Exact Requirement>"                                                      |
|   reverify_before: "<Release Milestone>"                                                           |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| (OPTIONAL) OPEN_DECISION                                                                           |
| Unresolved questions or choices awaiting Founder adjudication. Never coerced into the other four.  |
+----------------------------------------------------------------------------------------------------+
```


## 10. LEGACY TOOLING & INFRASTRUCTURE MIGRATION PLAN

### 10.1 Legacy Script Incompatibility Audit
1. **`scripts/sync-agent-skills.mjs`:** Assumes flat `SKILL.md` files; fails if skill folders contain `references/` companion subdirectories.
2. **`scripts/check-ai-skills.mjs`:** Validates legacy flat schema; must be updated to support bundled directory structures.
3. **Obsolete `.zcode/skills/` Mirror:** Deprecate without premature deletion.

### 10.2 Staged Script Migration Blueprint
- **Stage C:** Update `scripts/sync-agent-skills.mjs` and `scripts/check-ai-skills.mjs` to recognize bundled skills with `references/` folders.
- **Stage G:** Mark `.zcode/skills/` as deprecated in documentation.
- **Stage H:** Cleanly retire `.zcode/skills/` after the consolidated system is fully proven.


## 11. EVALUATION & VALIDATION FRAMEWORK

The system will be evaluated across 8 concrete evaluation suites:
1. **Routing Eval:** Feature tasks route to the appropriate domain brain and load relevant references based on combined signals.
2. **Negative Routing Eval:** Backend SQL tasks do not activate frontend UI skills.
3. **Canon Conflict Eval:** Agent rejects requests that violate Canon (e.g. unapproved colors or foreign tokens).
4. **Memory Retrieval Eval:** Product brain retrieves accurate business rules directly from `docs/BUSINESS_RULES.md` without hallucinations.
5. **Store Policy Freshness Eval:** Verifies correct understanding of physical accommodation payment exemptions under Apple Guideline 3.1.5b.
6. **Security Surface Eval:** Mandates secure-storage abstraction for credentials; rejects plaintext local storage.
7. **Completion Honesty Eval:** Refuses to declare tasks complete without credible oracle reproduction and verification.
8. **Context Efficiency Eval:** Measures actual context signals (files opened, references loaded, routing steps) rather than unmeasured token percentages.


## 12. STAGED ROLLOUT SEQUENCE & REVISED PILOT PROPOSAL

### 12.1 The Governed Domain Pilot Proposal
The previous 3-skill pilot (`systematic-debugging`, `widget-testing`, `static-analysis`) is formally superseded.

**Target Governed Domain Pilot:**
- **Pilot Brains:** `konfrm-quality` (Verification Engine) + `konfrm-flutter` (Implementation Engine).
- **Supporting Infrastructure:** Router metadata and companion reference loading.
- **Validation Goal:** Prove end-to-end implementation -> verification -> RCA debugging -> static analysis loop using lazy-loaded references without context thrashing.

### 12.2 Staged 8-Stage Rollout Sequence (Stage A through Stage H)
- **Stage A (Completed):** Freeze state; verify PR #100 frozen at `24269f2fe638c2846d053e03dafdf27c50652cda`; PR #99 untouched.
- **Stage B (Current Milestone):** Finalize Epistemic Authority Model; freeze Blueprint (`READY_FOR_RUNTIME_BRAIN_AUTHORING`).
- **Stage C:** Author draft modules for `konfrm-quality` and `konfrm-flutter`; modernize scripts.
- **Stage D:** Deploy router metadata and non-authoritative Project Compass.
- **Stage E:** Run evaluation benchmark against pilot deployment.
- **Stage F:** Author remaining domain brains (`konfrm-product`, `konfrm-design`, `konfrm-admin-web`, `konfrm-backend`, `konfrm-delivery`).
- **Stage G:** Switch runtime discovery; deprecate legacy wrappers and `.zcode/skills/`.
- **Stage H:** Retire legacy skills; merge governance branch into main via standard PR.


## 13. QUALITY BAR REVIEW & FINAL DECLARATIONS

### 13.1 Verification Against Epistemic & Authority Directives
- **Domain-Scoped Authority Established:** Global linear authority replaced with 4 distinct jurisdictions: Product/Business, Mandatory Platform/Store, Security, and Repository Reality.
- **Authority by Question Mapped:** Standardized epistemic lookup table established for agents.
- **Dynamic Repository Reality Integrated:** `REPOSITORY_REALITY_DYNAMIC` defined with strict rule: never infer current implementation from intended architecture.
- **Four Knowledge Classes Defined:** `PROJECT_CANON`, `REPOSITORY_REALITY_DYNAMIC`, `ENGINEERING_METHOD_PINNED`, `VOLATILE_EXTERNAL_REQUIREMENT` (plus `OPEN_DECISION`).
- **Product Scope Disambiguated:** Product brain owns product goals, business semantics, role intent, and documented market assumptions; does not define technical security controls or WCAG standards.
- **Accessibility & Security Ownership Separated:** Ownership V2 maps DEFINE, REPRESENT, IMPLEMENT, VERIFY across Product, Design, Implementation, and Quality.
- **RCA Oracle Model Grounded:** `REPRODUCE WITH THE SMALLEST CREDIBLE ORACLE` adopted; test dogma eliminated.
- **Static Analysis Gate Grounded:** Surface-specific analyzer execution (`flutter analyze` vs `dart analyze`) adopted; no skill-invented analyzer policy.
- **Release Hardening Disambiguated:** ProGuard/R8 JVM bytecode shrinking separated from optional Dart symbol obfuscation.
- **NIST SSDF Process Lens:** SSDF used as a process lens; no manufactured mandatory controls (signed commits removed).
- **Migration Reality Grounded:** Reversible rollback requirement replaced with safe, tested, ordered migrations with explicit recovery strategies.
- **Admin UX Grounded:** Admin invariant established as operational clarity, useful density, auditability, and safe actionability; tables/filters treated as task patterns, not universal mandates.
- **Store Policies Verified:** Apple Xcode 26+ / iOS 26 SDK+ and Google Play API 36+ documented as live volatile snapshots with official verification dates.
- **Android vs Google Play Disambiguated:** Account deletion correctly classified as a conditional Google Play store policy, not an Android OS requirement.
- **Compose Authority Positioned:** Jetpack Compose classified as `NOT A KONFRM FLUTTER IMPLEMENTATION AUTHORITY`.
- **Dependency Risk Model Refined:** Advisories evaluated by reachability and exploitability; zero silent suppression.
- **Project Compass Role Preserved:** Explicitly defined as a `NON-AUTHORITATIVE RETRIEVAL COMPASS`.

---

### 13.2 Isolation Invariants Audit
- **Worktree:** `c:\Users\Essam\OneDrive\Desktop\KONFRM-AGENT-SKILLS-GOVERNANCE`
- **Branch:** `chore/agent-skills-governance-v1`
- **PR #100:** Strictly frozen at commit `24269f2fe638c2846d053e03dafdf27c50652cda` in `c:\Users\Essam\OneDrive\Desktop\KONFRM-CANONICAL`.
- **PR #99:** Untouched.
- **Runtime Filesystem:** Zero runtime skills created or mutated. Zero app code modified.

---

```yaml
DECLARATION: KONFRM_ENGINEERING_INTELLIGENCE_BLUEPRINT_READY_FOR_RUNTIME_BRAIN_AUTHORING
```
