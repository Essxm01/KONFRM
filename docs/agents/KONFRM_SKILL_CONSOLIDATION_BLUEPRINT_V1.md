# KONFRM — ENGINEERING INTELLIGENCE SYSTEM V1
## SKILL CONSOLIDATION × KNOWLEDGE DISTILLATION × SECURITY × STORE READINESS

```yaml
DOCUMENT_TYPE: ARCHITECTURAL_BLUEPRINT
SYSTEM_NAME: KONFRM Engineering Intelligence System V1
STATUS: CANDIDATE_FOR_BRIDGE_REVIEW
GOVERNING_BRANCH: chore/agent-skills-governance-v1
BASE_CANONICAL_REF: e8257dda75cc089c7c4521b8409adcdf67a2dd49
ISOLATION_INVARIANTS:
  PR_100: FROZEN at 24269f2fe638c2846d053e03dafdf27c50652cda
  PR_99: UNTOUCHED
  RUNTIME_SKILLS_MUTATED: FALSE (Documentation & Architecture Blueprint Only)
```

---

## 1. EXECUTIVE SUMMARY & PARADIGM SHIFT

### 1.1 The Operational Crisis of Fragmented Tooling
The previous iteration of the KONFRM agent skills architecture decomposed engineering into 15 standalone capability families (`DEBUGGING`, `FLUTTER_TESTING`, `STATIC_ANALYSIS`, `SECURITY_AUDITING`, `PERFORMANCE_PROFILING`, `CODE_REVIEW`, `GIT_SAFETY`, `API_DESIGN`, `ACCESSIBILITY`, `RTL_ARABIC`, `STATE_MANAGEMENT`, `DESIGN_SYSTEM_ENFORCEMENT`, `DESIGN_REASONING`, `ARCHITECTURE_DESIGN`, `TASK_MANAGEMENT`) mirrored across 14 disparate skill folders (`.agents/skills/` wrappers and `docs/ai/skills/` native design skills).

Under live agent execution (Antigravity and Codex), this granular decomposition created severe operational failure modes:
1. **Tool Bloat & Context Thrashing:** Registering 15 to 20 granular skills in the agent system prompt consumes massive baseline token quota before the agent reads a single line of task-specific code. Agents frequently hallucinated overlapping tools or failed to invoke specialized skills due to prompt saturation.
2. **Ambiguous Routing & Competing Authorities:** A routine UI task (e.g., implementing an accessible, RTL-compliant numeric input in Flutter) triggered conflicts between `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `ui-ux-pro-max-wrapper`, and `impeccable-wrapper`. Agents spent excessive roundtrips reconciling conflicting heuristics rather than implementing the Canon.
3. **Execution Paralysis & Prompt Couriers:** Granular skills lacked end-to-end execution lifecycle ownership. An agent would execute a test via a testing skill, stop, require Founder prompting to route to a debugging skill, fix the code, stop again, and require further prompting to format a commit.
4. **Subtle Canon Drift:** External wrappers imported unfiltered web conventions, foreign numeric design tokens, and unvetted third-party libraries that threatened the core monochrome-first, Arabic-first, and server-authoritative invariants of KONFRM.

### 1.2 The Core Law: Capability Family != Runtime Skill
To eliminate this structural friction, KONFRM establishes a fundamental architectural law:
> **A Capability Family is an internal engineering competence module. A Runtime Skill is a coarse-grained, end-to-end Domain Brain.**

Runtime skills are the visible entry points exposed to coding agents. Capability families are internal competence units organized as companion reference modules (`references/*.md`) within their governing domain brain. Agents must never be presented with 15 fractured tools when 7 coherent domain brains provide complete contextual authority.

### 1.3 The Target 7-Domain-Brain Architecture
KONFRM consolidates all engineering, product, design, and release intelligence into **7 Governed Domain Brains**:

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
| Product Soul,  |                       | DF2 v1.7, Bidi,|                       | Root Cause RCA,|
| Egyptian Rules,|                       | Cairo, States, |                       | Tests, Review, |
| 3-Role Invariants                      | Visual QA      |                       | OWASP Security |
+--------+-------+                       +--------+-------+                       +--------+-------+
         |                                        |                                        |
         |         +---------------------+        |        +---------------------+         |
         +-------->|    konfrm-flutter   |<-------+------->| konfrm-admin-web    |<--------+
         |         | Flutter Core, Riverpod       |        | React 19, Vite, Web |         |
         |         | DTOs, Responsive UI          |        | Ergonomics, Tables  |         |
         |         +----------+----------+        |        +----------+----------+         |
         |                    |                   |                   |                    |
         |                    +---------+         |         +---------+                    |
         |                              |         |         |                              |
         |                     +--------v---------v---------v--------+                     |
         |                     |            konfrm-backend           |                     |
         |                     |  Cloudflare Worker, Supabase REST,  |                     |
         |                     |  PostgreSQL RLS, Financial Engine   |                     |
         |                     +------------------+------------------+                     |
         |                                        |                                        |
         +----------------------------------------+----------------------------------------+
                                                  |
                                         +--------v--------+
                                         | konfrm-delivery |
                                         | Git Safety, CI, |
                                         | Play / App Store|
                                         | Release Readiness
                                         +-----------------+
```

1. **`konfrm-product`**: The Product Soul and Domain Truth. Governs Egyptian vacation rental reality, the 3 distinct user roles (Customer, Owner, Admin), booking lifecycle state machines, financial transactional boundaries, and anti-deception invariants.
2. **`konfrm-design`**: The Unified UI/UX Authority. Governs Design Foundation 2 (DF2 v1.7), monochrome-first branding, Cairo typography, native Arabic RTL/Bidi ergonomics, strict UI state grammar, purposeful tactile micro-interactions, and visual QA.
3. **`konfrm-flutter`**: The Mobile Implementation Brain. Governs mobile client architecture, Feature-first organization, Riverpod state controllers, declarative routing (`go_router`), manual JSON serialization (`fromMap`/`toMap`), fail-closed UI state rendering, and adaptive Android/iOS layouts.
4. **`konfrm-admin-web`**: The Web Interface Authority. Governs React 19, TypeScript, and Vite architectures for the Admin portal, tabular data ergonomics, desktop keyboards, and verified web accessibility standards.
5. **`konfrm-backend`**: The Cloudflare & Supabase Authority. Governs the Cloudflare Worker TypeScript edge proxy, Supabase PostgreSQL database schemas, Row-Level Security (RLS) policies, database migrations, and server-authoritative financial calculation engines.
6. **`konfrm-quality`**: The Verification, Debugging & Security Engine. Governs systematic root-cause debugging (4-phase RCA), multi-tier testing strategy (Unit, Widget, Contract, Integration), static analysis enforcement (`dart analyze --fatal-infos`), dual-axis code reviews (Standards & Specification), and mobile/backend security auditing (OWASP MASVS / NIST SSDF).
7. **`konfrm-delivery`**: The Release, Git & Store Readiness Authority. Governs branch lifecycles, Git commit hygiene, CI gate verification, PR closure handshakes, Google Play Store compliance (Target API 36+, 16 KB pages, edge-to-edge), Apple App Store compliance (Xcode 16+, Privacy Manifests, Required Reason APIs, Physical Rental Exemption), and project memory backpropagation.


## 2. FORENSIC AUDIT & DUPLICATION MATRIX OF CURRENT SKILL REALITY

### 2.1 Complete Inventory of Current 14 Skills
The repository currently contains 14 skills distributed across `.agents/skills/`, `docs/ai/skills/`, and obsolete mirrors in `.zcode/skills/`:

| Skill Identifier | Physical Location | Origin / Upstream | Stated Purpose | Operational Flaw / Overlap |
| :--- | :--- | :--- | :--- | :--- |
| `impeccable-wrapper` | `.agents/skills/impeccable-wrapper/` | Impeccable Design Engine | Polish, critique, distill UI design | Competes with DF2 Canon; attempts to impose foreign web tokens on Flutter mobile. |
| `ui-ux-pro-max-wrapper` | `.agents/skills/ui-ux-pro-max-wrapper/` | UI/UX Pro Max Intelligence | Multi-stack UI/UX guidelines | Massive prompt overhead; generic recommendations duplicate native `konfrm-mobile-design`. |
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
| `konfrm-accessibility` | `docs/ai/skills/konfrm-accessibility/` | Internal Repo Native | WCAG 2.2 AA, touch targets, screen readers| Disconnected from core component building; treated as an afterthought rather than a built-in constraint. |
| `konfrm-visual-qa` | `docs/ai/skills/konfrm-visual-qa/` | Internal Repo Native | Device viewports, visual state verification | Disconnected from testing lifecycle; belongs inside the quality verification engine. |

### 2.2 Duplication & Contradiction Matrix
The fragmentation across these 14 skills created direct contradictions and repetitive guidance across 6 critical engineering domains:

```
+-----------------------------------------------------------------------------------------------------------------------------------+
| DOMAIN AREA       | FRAGMENTED OWNERS                             | NATURE OF CONFLICT / DUPLICATION                             |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| UI State Grammar  | konfrm-product-ux, konfrm-mobile-design,      | All 3 define loading/empty/error states. Product defines it  |
|                   | ui-ux-pro-max-wrapper                         | semantically, Mobile defines it in Flutter, Wrapper imports  |
|                   |                                               | web toast/skeleton patterns incompatible with DF2.            |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Arabic RTL / Bidi | konfrm-rtl-arabic, frontend-design-wrapper,   | konfrm-rtl-arabic enforces Western Arabic numerals (0-9) and |
|                   | konfrm-mobile-design                          | start/end semantics. Frontend wrapper attempts to flip entire |
|                   |                                               | directional axes including media players and badges.          |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Accessibility     | konfrm-accessibility, ui-ux-pro-max-wrapper,  | konfrm-accessibility enforces 48x48dp mobile touch targets;  |
| & Touch Targets   | vercel-web-guidelines-wrapper                 | web wrapper enforces 24px/32px web click targets, causing     |
|                   |                                               | mobile accessibility regressions during touch target audits.  |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Motion & Animation| emil-wrapper, impeccable-wrapper,             | emil-wrapper suggests bouncy spring physics (400ms-600ms);    |
|                   | konfrm-mobile-design                          | DF2 Canon mandates strict, restrained linear/decelerate       |
|                   |                                               | transitions (150ms-250ms) that never block user actions.      |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Component         | vercel-composition-wrapper,                   | React compound component patterns (Context, children cloning)|
| Architecture      | frontend-design-wrapper                       | inadvertently applied to Flutter widgets, violating Flutter's |
|                   |                                               | explicit constructor parameter and widget composition norms.  |
+-------------------+-----------------------------------------------+---------------------------------------------------------------+
| Code Review &     | konfrm-visual-qa, konfrm-design-court,        | Visual QA treats review as screenshot inspection only; Court  |
| Quality Gates     | AGENTS.md Quality Gates                       | runs synthetic debates; neither integrates with Dart analyzer|
|                   |                                               | or automated widget regression suites.                        |
+-----------------------------------------------------------------------------------------------------------------------------------+
```


## 3. ATOMIC KNOWLEDGE EXTRACTION & SINGLE OWNERSHIP LAW

### 3.1 Decomposition into Atomic Knowledge Units (AKUs)
To eliminate duplicate definitions without losing hard-won project intelligence, all heuristics, patterns, and rules from the 14 skills are distilled into **Atomic Knowledge Units (AKUs)**. An AKU is a self-contained, indivisible rule or reference pattern.

### 3.2 The Strict Law of Single Ownership
> **Every Atomic Knowledge Unit has EXACTLY ONE governing Runtime Domain Brain.**
> **No second skill may define, redefine, rephrase, or shadow an AKU.**
> **Cross-domain workflows MUST reference the owner brain via explicit handoff contracts.**

### 3.3 Authoritative Single Ownership Table
The following master table defines the exclusive domain brain owner for every engineering concept in KONFRM:

| Atomic Knowledge Concept | Exclusive Owner Brain | Prohibited Duplicate Claimants | Permitted Usage by Other Brains |
| :--- | :--- | :--- | :--- |
| **Rental Business Rules & Booking Lifecycle** | `konfrm-product` | `konfrm-flutter`, `konfrm-backend` | Client and backend consume state machine states as immutable enum specifications. |
| **3-Role User Mental Models (Customer/Owner/Admin)** | `konfrm-product` | All other brains | UI brains consume role-specific goals to drive layout hierarchy. |
| **Monochrome Design Foundation (DF2 v1.7)** | `konfrm-design` | `konfrm-flutter`, `konfrm-admin-web` | Client brains consume generated tokens and strict style classes; never invent ad-hoc hex values. |
| **Cairo Typography & RTL Arabic Semantics** | `konfrm-design` | `konfrm-flutter`, `konfrm-admin-web` | Client brains implement font family and directional padding (`EdgeInsetsDirectional`). |
| **UI State Grammar (Loading, Empty, Error, Content)** | `konfrm-design` | `konfrm-product`, `konfrm-flutter` | Flutter implements `AsyncValue.when` mapping directly to DF2 state grammar specifications. |
| **Micro-Interactions & Motion Budget** | `konfrm-design` | `konfrm-flutter` | Flutter consumes numeric duration (`150ms-250ms`) and curves specified by Design. |
| **Flutter Widget Tree & State Controllers** | `konfrm-flutter` | `konfrm-design`, `konfrm-quality` | Design specifies visual layout; Flutter implements Riverpod `NotifierProvider`. |
| **Flutter DTOs & Manual Serialization** | `konfrm-flutter` | `konfrm-backend` | Backend specifies API contracts; Flutter implements manual `fromMap`/`toMap`. |
| **React 19 & Vite Web Architecture** | `konfrm-admin-web` | `konfrm-flutter`, `konfrm-backend` | Dedicated exclusively to web admin surface; isolated from Flutter engine. |
| **Cloudflare Worker Edge Proxy Architecture** | `konfrm-backend` | `konfrm-flutter`, `konfrm-delivery` | Edge entry point, request transformation, header sanitation. |
| **Supabase PostgreSQL Schemas & RLS Invariants** | `konfrm-backend` | `konfrm-product`, `konfrm-quality` | Canonical persistence source of truth; client must never assume direct DB authority. |
| **Server-Authoritative Financial Engine** | `konfrm-backend` | `konfrm-product`, `konfrm-flutter` | Absolute pricing, payouts, deposits, and refunds calculated strictly on server. |
| **Root-Cause Analysis (4-Phase RCA Debugging)** | `konfrm-quality` | `konfrm-flutter`, `konfrm-delivery` | Activated immediately upon any test failure or runtime crash. |
| **Multi-Tier Testing Strategy (Unit/Widget/Contract)** | `konfrm-quality` | `konfrm-flutter`, `konfrm-admin-web` | Defines test contracts, coverage criteria, and regression assertions. |
| **Static Analysis (`dart analyze --fatal-infos`)** | `konfrm-quality` | `konfrm-delivery` | Quality enforces zero-warning baseline; Delivery verifies CI gate exit status. |
| **Mobile Security Baseline (OWASP MASVS)** | `konfrm-quality` | `konfrm-flutter`, `konfrm-backend` | Defines client security controls (storage, crypto, IPC, network). |
| **Branch Lifecycle & Git Safety** | `konfrm-delivery` | All other brains | Governs branch naming, commit formatting, ancestry verification, and merge policies. |
| **Google Play Compliance & Target API 36+** | `konfrm-delivery` | `konfrm-flutter` | Governs manifest declarations, 16 KB page sizes, and Data Safety requirements. |
| **Apple App Store Compliance & Privacy Manifests**| `konfrm-delivery` | `konfrm-flutter` | Governs `PrivacyInfo.xcprivacy`, Required Reason APIs, and Guideline 3.1.5b. |
| **CI Gate Audit & PR Closure Handshake** | `konfrm-delivery` | All other brains | Executes the final deterministic closure checklist before merge. |


## 4. TARGET 7-BRAIN CONSOLIDATED ARCHITECTURE SPECIFICATIONS

### 4.1 Internal Brain Modular Anatomy (`MINIMAL_SUFFICIENT_CONTEXT`)
To prevent domain brains from becoming unmanageable "mega-skills" that bloat agent context, each brain adheres to a standardized two-tier modular directory structure:

```
.agents/skills/<brain-name>/
├── SKILL.md                  <-- Fast Router, Invariants, Core Lifecycle Workflow (<= 100 lines)
└── references/               <-- Lazy-Loaded Deep Knowledge Modules (Loaded only when task requires)
    ├── <module-1>.md
    ├── <module-2>.md
    └── <module-3>.md
```

- **Root `SKILL.md` (Context Budget: <= 100 lines):**
  Contains exclusively: (1) Domain Mission & Scope, (2) Non-Negotiable Invariants, (3) Standard Execution Workflow, (4) Companion Reference Index (describing when to load which companion module), and (5) External Handoff Contracts.
- **Companion Reference Modules (`references/*.md`):**
  Contain deep domain technical instructions, concrete code patterns, checklists, and edge-case catalogs. An agent executing a simple widget layout task loads `konfrm-flutter/SKILL.md` and only lazy-loads `references/layout_patterns.md`, leaving state management or networking modules unopened.

---

### 4.2 Brain 1: `konfrm-product` (Product Soul & Domain Truth)
- **Primary Mission:** Preserve the authentic business logic, Egyptian market context, user psychology, and transaction integrity of the vacation rental platform.
- **Core Invariants:**
  - Egyptian market realities: Cash vs card dynamics, deposit handling norms, weekend seasonality, property verification.
  - Three distinct user roles: Customer (frictionless discovery and verified booking), Owner (operational control, calendar integrity, verified payouts), Admin (auditability, platform protection, dispute mediation).
  - Explicit booking lifecycle state machine: Strict, unskippable state transitions (`DRAFT` -> `REQUESTED` -> `OWNER_CONFIRMED` -> `PAID` -> `ACTIVE` -> `COMPLETED` / `CANCELLED` / `REFUNDED`).
  - Absolute anti-deception policy: Zero hidden fees, clear cancellation terms, honest availability messaging.
- **Subsumed Capabilities:** `ARCHITECTURE_DESIGN` (Domain Level), `TASK_MANAGEMENT` (Product Scope), `konfrm-product-ux` (Product Foundations).
- **Internal Reference Modules:**
  - `references/booking_state_machine.md`: Exhaustive state transition tables, triggers, guards, and side effects.
  - `references/role_mental_models.md`: Customer, Owner, and Admin behavioral goals, error tolerance, and cognitive priorities.
  - `references/financial_domain_rules.md`: Nightly rates, service fees, security deposits, refund windows, and payout thresholds.
- **Operational Boundaries:** Does NOT write Flutter code, SQL migrations, or CSS. Handoffs business rules to `konfrm-design` for UX presentation and `konfrm-backend` for persistence invariants.

---

### 4.3 Brain 2: `konfrm-design` (Unified UI/UX Authority)
- **Primary Mission:** Enforce the single visual and interaction design truth of KONFRM across all surfaces, subordinating all external aesthetics to Design Foundation 2 (DF2 v1.7).
- **Core Invariants:**
  - DF2 v1.7 Monochrome-First Foundation: Pure black (`#000000`), pure white (`#FFFFFF`), high-contrast zinc scales. Color is reserved exclusively for semantic statuses (Success, Warning, Error) and restrained interaction accents.
  - Cairo Typography: Strict typographic scale, explicit line heights, tabular figures for all numeric prices (`ج.م`).
  - Native RTL Arabic: Start/End logical alignment, bidirectional text isolation, Western Arabic numerals (0-9) as default.
  - Strict UI State Grammar: Every view/component must define 4 mutually exclusive states: Loading (skeleton/spinner), Empty (actionable copy), Error (truthful retryable feedback), Content (populated data).
  - Restrained Motion: 150ms-250ms max duration, zero blocking physics, purposeful feedback only.
  - Mobile Touch Ergonomics: Minimum 48 x 48 dp touch targets, thumb-zone primary actions.
- **Subsumed Capabilities:** `DESIGN_SYSTEM_ENFORCEMENT`, `DESIGN_REASONING`, `ACCESSIBILITY`, `RTL_ARABIC`, `konfrm-design-router`, `konfrm-design-court`, `konfrm-design-reasoning`, `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa`, `impeccable-wrapper`, `ui-ux-pro-max-wrapper`, `emil-wrapper`.
- **Internal Reference Modules:**
  - `references/df2_tokens_and_components.md`: Complete DF2 token catalog, elevation levels, border radii, and atomic components.
  - `references/arabic_rtl_bidi.md`: Bidirectional text handling, Arabic layout flipping rules, and numeral formatting.
  - `references/accessibility_standards.md`: WCAG 2.2 AA checklists, screen reader semantics (`Semantics` widget in Flutter), contrast math, and tap target geometry.
  - `references/motion_and_states.md`: Standard transition curves, state grammar transitions, and tactile feedback patterns.
  - `references/visual_qa_checklist.md`: Viewport matrix (360dp, 390dp, 412dp), RTL inspection checklist, font scaling (1.0x to 2.0x) verification.
- **Operational Boundaries:** Governs visual and interaction specifications. Handoffs implementation to `konfrm-flutter` or `konfrm-admin-web`.

---

### 4.4 Brain 3: `konfrm-flutter` (Mobile Implementation Brain)
- **Primary Mission:** Implement rock-solid, production-grade Flutter client applications for Android and iOS adhering strictly to KONFRM mobile architecture.
- **Core Invariants:**
  - Feature-First Directory Structure: Code organized by feature (`presentation/`, `domain/`, `data/`), not by technical layer.
  - State Management: Explicit Riverpod `NotifierProvider` / `AsyncNotifierProvider`. Zero mutable global variables.
  - Routing: Declarative `go_router` with strong typing, deep linking support, and route guards.
  - Networking & Serialization: Standard `package:http`. Strictly manual `fromMap`/`toMap` JSON serialization. Zero runtime reflection or uninspected code generation (`build_runner` code generation used only where unavoidable).
  - Fail-Closed UI Rendering: Handling of `AsyncValue` errors with honest UI feedback; never swallow exceptions or display partial corrupted state.
  - Mobile Shell Isolation: Clean separation between Flutter framework code and native Android (`android/`) / iOS (`ios/`) shell configurations.
- **Subsumed Capabilities:** `STATE_MANAGEMENT`, `API_DESIGN` (Client DTOs), `ARCHITECTURE_DESIGN` (Mobile Client).
- **Internal Reference Modules:**
  - `references/feature_architecture.md`: Folder layout, repository pattern, controller patterns, and dependency injection via Riverpod.
  - `references/widget_patterns.md`: Composing DF2 widgets, responsive layouts (`LayoutBuilder`), avoiding unnecessary rebuilds, const constructors.
  - `references/dto_and_networking.md`: Manual DTO parsing templates, HTTP error interceptors, token refresh flows, and offline state handling.
  - `references/native_shell_bridge.md`: Method channels, platform views, Android `MainActivity.kt` and iOS `AppDelegate.swift` integration contracts.
- **Operational Boundaries:** Implements mobile client code. Handoffs backend API design to `konfrm-backend` and quality verification to `konfrm-quality`.

---

### 4.5 Brain 4: `konfrm-admin-web` (Web Interface Authority)
- **Primary Mission:** Build and maintain the KONFRM Admin Operations web dashboard with high operational density and desktop efficiency.
- **Core Invariants:**
  - React 19, TypeScript, and Vite stack.
  - High Useful Density: Data-dense tables, keyboard shortcuts, multi-column operational views, filtering grids.
  - Web Accessibility & Performance: Semantic HTML5, full keyboard navigation, zero layout shift (CLS < 0.1), fast initial bundle loading.
  - Desktop-First Ergonomics: Optimized for 1280px to 1920px+ desktop displays with responsive collapse for tablet review.
- **Subsumed Capabilities:** `vercel-composition-wrapper`, `vercel-web-guidelines-wrapper`.
- **Internal Reference Modules:**
  - `references/admin_table_patterns.md`: Dense data grid patterns, column sorting, pagination, batch actions, and selection states.
  - `references/react_composition_rules.md`: Clean component composition, hook encapsulation, avoiding prop drilling without over-abstracting.
  - `references/web_performance_accessibility.md`: Core Web Vitals optimization, ARIA live regions, focus trap management in modals.
- **Operational Boundaries:** Dedicated exclusively to the Admin web surface. Zero contamination with Flutter mobile architecture.

---

### 4.6 Brain 5: `konfrm-backend` (Cloudflare & Supabase Authority)
- **Primary Mission:** Enforce absolute server-side security, data consistency, transactional integrity, and edge routing across Cloudflare Workers and Supabase PostgreSQL.
- **Core Invariants:**
  - PostgreSQL is the Canonical Source of Truth: All transactional integrity, foreign keys, constraints, and audit logs live in Supabase.
  - Row-Level Security (RLS): Mandatory RLS policies on EVERY table. No data access is granted without explicit, test-verified RLS rules.
  - Zero Client Authority: The client never calculates prices, approves bookings, releases payouts, or specifies user ownership. All mutations are validated and executed by server-authoritative code.
  - Cloudflare Worker Proxying: Worker acts as an intelligent edge proxy, handling header sanitization, rate limiting, and routing before hitting Supabase REST.
  - Strict Migration Hygiene: Idempotent SQL migrations with reversible rollback scripts. No ad-hoc schema modifications via Supabase dashboard.
- **Subsumed Capabilities:** `API_DESIGN` (Server Level), `ARCHITECTURE_DESIGN` (Backend/DB).
- **Internal Reference Modules:**
  - `references/supabase_rls_patterns.md`: Standard RLS policy templates for Customer, Owner, and Admin multi-tenant isolation.
  - `references/database_migration_protocol.md`: Migration authoring standards, constraint validation, index optimization, and rollback strategies.
  - `references/cloudflare_worker_proxy.md`: Edge worker request lifecycle, environment secret bindings, and Supabase REST adapter queries.
  - `references/financial_transaction_engine.md`: Idempotency keys, atomic ledger transactions, and webhook verification for payment gateways.
- **Operational Boundaries:** Governs server and database reality. Handoffs client consumption contracts to `konfrm-flutter` and `konfrm-admin-web`.

---

### 4.7 Brain 6: `konfrm-quality` (Verification, Debugging & Security Engine)
- **Primary Mission:** Guarantee the structural correctness, runtime stability, test coverage, and security posture of KONFRM through rigorous, deterministic verification.
- **Core Invariants:**
  - 4-Phase Root Cause Analysis (RCA): Mandatory upon any defect: (1) Reproduce with a failing test, (2) Isolate minimal failure boundary, (3) Root-cause underlying defect, (4) Verify fix passes while ensuring zero regression. Guess-and-check editing is strictly forbidden.
  - Multi-Tier Testing Pyramid: Unit tests for domain logic and DTO parsing, Widget tests for UI state rendering and accessibility, Contract tests for API serialization, Integration tests on target devices.
  - Zero-Warning Static Analysis: `dart analyze --fatal-infos` must exit with code 0 on all PR candidates.
  - Dual-Axis Code Review: Evaluating every change against both **Specification Axis** (Did it solve the prompt?) and **Standards Axis** (Does it preserve architectural integrity and Canon?).
  - Mobile Security Baseline (OWASP MASVS): Verifying client storage, cryptography, authentication tokens, and network communication against MASVS v2.0 standards.
- **Subsumed Capabilities:** `DEBUGGING`, `FLUTTER_TESTING`, `STATIC_ANALYSIS`, `SECURITY_AUDITING`, `PERFORMANCE_PROFILING`, `CODE_REVIEW`.
- **Internal Reference Modules:**
  - `references/systematic_debugging_rca.md`: Step-by-step 4-phase RCA protocol, logging instrumentation, and regression test authoring.
  - `references/flutter_testing_playbook.md`: Golden widget testing, mocking HTTP boundaries, pumpAndSettle semantics, and accessibility testing.
  - `references/code_review_dual_axis.md`: Structured review checklists for standards, security, edge cases, and performance regressions.
  - `references/mobile_security_masvs.md`: OWASP MASVS v2.0 checklist, secure storage patterns (Flutter Secure Storage), and token lifecycle.
  - `references/performance_profiling.md`: Frame budget analysis (16.6ms / 60fps), widget rebuild tracking, memory leak detection, and network payload profiling.
- **Operational Boundaries:** Governs testing, debugging, and verification. Does NOT merge branches or publish store builds; hands off verified artifacts to `konfrm-delivery`.

---

### 4.8 Brain 7: `konfrm-delivery` (Release, Git & Store Readiness Authority)
- **Primary Mission:** Govern the safe passage of code from candidate branches to published baselines, CI verification, App Store compliance, and memory synchronization.
- **Core Invariants:**
  - Git Preflight & Branch Safety: Absolute branch awareness (`git rev-parse HEAD`, `git rev-parse origin/main`). Verifying candidate ancestry before edits. Conventional commit formatting.
  - Deterministic CI Gate Audit: Verifying that all CI workflows (tests, analyzer, format, build) pass with concrete proof.
  - Google Play Compliance: Enforcing Target API 36+ (Android 16), 16 KB page size native library alignment, edge-to-edge window insets, and Data Safety declarations.
  - Apple App Store Compliance: Enforcing Xcode 16+ / iOS 18 SDK, complete Privacy Manifests (`PrivacyInfo.xcprivacy`), Required Reason API declarations, and Guideline 3.1.5b physical goods exemption.
  - PR Closure Handshake: Autonomous execution of final verification, documentation reconciliation, and merge commit protocols.
  - Project Memory Backpropagation: Updating `CURRENT_STATE.md`, `INDEX.md`, and decision records upon PR closure.
- **Subsumed Capabilities:** `GIT_SAFETY`, `TASK_MANAGEMENT` (Release Lifecycle), Store Readiness, CI Auditing.
- **Internal Reference Modules:**
  - `references/git_branch_lifecycle.md`: Worktree hygiene, preflight checks, commit conventions, merge vs rebase rules, and recovery procedures.
  - `references/google_play_store_policy.md`: Play Store compliance checklist, 16 KB memory page audit, target SDK timelines, and Data Safety mappings.
  - `references/apple_app_store_policy.md`: App Store Review Guidelines checklist, Privacy Manifest audit, Required Reason API declarations, and physical rental payment exemption rules.
  - `references/ugc_moderation_compliance.md`: Apple Guideline 1.2 and Play UGC requirements: Terms of Service, reporting, user blocking, and 24-hour moderation response SLAs.
  - `references/pr_closure_handshake.md`: Step-by-step PR closure verification runbook and Brain Sync Protocol envelopes.
- **Operational Boundaries:** Governs release engineering, Git operations, and store compliance. Handoffs code remediation to implementation brains and testing to `konfrm-quality`.


## 5. EXTERNAL INTELLIGENCE SOURCES & FORENSIC MATRIX

### 5.1 Source Quality Hierarchy
External engineering sources must never be ingested indiscriminately. All external intelligence is classified into a strict 4-tier trust hierarchy:

```
+----------------------------------------------------------------------------------------------------+
| TIER A: FIRST-PARTY & OFFICIAL PLATFORM SPECIFICATIONS                                             |
| Flutter/Dart Official Docs, Android Developers / android/skills, Apple Developer Guidelines,      |
| Supabase Official Architecture, Cloudflare Workers Runtime Specs.                                  |
| Status: PRIMARY TECHNICAL BENCHMARK (Subordinated only to explicit Founder Canon)                |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| TIER B: GOVERNING INDUSTRY STANDARDS & SECURITY FRAMEWORKS                                         |
| OWASP Mobile Application Security (MASVS v2.0 / MASTG), NIST SSDF 1.1 (SP 800-218),               |
| W3C WCAG 2.2 AA Baseline.                                                                          |
| Status: MANDATORY AUDIT BASELINE FOR SECURITY & ACCESSIBILITY                                      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| TIER C: HIGH-QUALITY SPECIALIST OPEN SOURCE & METHODOLOGIES                                        |
| Obra Systematic Debugging, Matt Pocock Type Patterns, Deloitte Assured Engineering.                |
| Status: METHODOLOGICAL INGREDIENTS (Distilled into project-native workflows)                       |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| TIER D: DESIGN & INTERACTION HEURISTICS                                                            |
| UIZZE, Impeccable Design Engine, Emil Kowalski Motion Principles, Taste Heuristics.                |
| Status: STRICTLY ADVISORY (Subordinated to DF2 Monochrome Canon & RTL Arabic Rules)                |
+----------------------------------------------------------------------------------------------------+
```

### 5.2 Forensic Matrix of External Sources
Every candidate external source is evaluated, classified, and assigned an authoritative disposition:

| Source Name | Upstream Anchor / Commit | Quality Tier | Evaluated Value | Risk / Conflict with KONFRM | Architectural Disposition |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Official Flutter / Dart Docs** | Official SDK (Dart 3.x / Flutter 3.x) | Tier A | Canonical state management, rendering pipeline, widget tree optimization. | None. Aligns directly with project stack. | **ADOPT CORE**: Incorporated into `konfrm-flutter` and `konfrm-quality`. |
| **Android Skills (`android/skills`)** | Commit `42dc2270e96032bd860bb94511e440aa00a43125` | Tier A | Target API 36+, 16 KB page size, edge-to-edge insets, Data Safety insights. | Assumes Jetpack Compose; Compose code inapplicable to Flutter engine. | **EXTRACT PLATFORM**: Distill platform rules into `konfrm-delivery`; reject Compose UI. |
| **Google Play Policy Guidelines** | Live Google Play Console Policy (2026) | Tier A | Target SDK enforcement, Account Deletion, Photo Picker requirements. | Rapid policy drift; requires volatile verification. | **ADOPT POLICY**: Governed in `konfrm-delivery/references/google_play_store_policy.md`. |
| **Apple App Store Review Guidelines** | Live Developer Guidelines (2026) | Tier A | Guideline 3.1.5b (Physical Goods), Privacy Manifests, Required Reason APIs. | Strict rejection risks if physical rental payment exemption is misconfigured. | **ADOPT POLICY**: Governed in `konfrm-delivery/references/apple_app_store_policy.md`. |
| **Supabase Architecture Guides** | Official Supabase Documentation | Tier A | RLS best practices, database indexing, connection pooling (Supavisor). | Client-side SDK features must not bypass Cloudflare Worker proxy. | **ADOPT CORE**: Distilled into `konfrm-backend/references/supabase_rls_patterns.md`. |
| **Cloudflare Workers Docs** | Official Cloudflare Developer Docs | Tier A | Edge request handling, environment secrets, header sanitation. | Worker SQL compatibility limits with Supabase REST must be respected. | **ADOPT CORE**: Distilled into `konfrm-backend/references/cloudflare_worker_proxy.md`. |
| **OWASP MASVS v2.0 / MASTG** | OWASP Mobile Application Security | Tier B | Comprehensive mobile security verification (Storage, Crypto, Auth, Network). | High overhead if applied blindly to MVP; requires risk-based tiering. | **ADOPT AUDIT**: Distilled into `konfrm-quality/references/mobile_security_masvs.md`. |
| **NIST SSDF 1.1 (SP 800-218)** | NIST Computer Security Division | Tier B | Structured secure software development practices (PO, PS, PW, RV). | Enterprise bureaucracy; must be distilled into lean agent verification gates. | **ADOPT PROCESS**: Integrated into `konfrm-quality` and `konfrm-delivery` gates. |
| **Obra Systematic Debugging** | Upstream Debugging Methodology | Tier C | 4-Phase RCA: Reproduce, Isolate, Root-cause, Verify without regression. | Can slow down trivial typo fixes; requires fast-path for non-semantic bugs. | **ADOPT RCA**: Governing debugging workflow in `konfrm-quality`. |
| **Matt Pocock Type Patterns** | TypeScript Pattern Repository | Tier C | Parse don't validate, exhaustive matching, strict boundary typing. | TypeScript-centric; must be translated into Dart static typing patterns. | **TRANSLATE PATTERNS**: Adapted for Flutter DTOs and Cloudflare Worker TypeScript. |
| **Deloitte Assured Engineering** | Assured Engineering Principles | Tier C | Evidence-based quality gates, deterministic audit trails, reproducibility. | Excessive enterprise paperwork; distill into Git-backed proof artifacts. | **ADOPT EVIDENCE**: Anchors KONFRM evidence-based quality gates. |
| **Impeccable Design Engine** | Impeccable Design Skills | Tier D | Visual polish checklists, layout hierarchy reasoning, contrast awareness. | Injects web CSS tokens, pastel palettes, and conflicts with DF2 monochrome. | **HEURISTIC ADVISORY**: Filtered heuristics ingested into `konfrm-design`; zero tokens. |
| **Emil Kowalski Motion Principles** | Motion Design Heuristics | Tier D | Purposeful micro-interactions, responsive tactile feedback, natural curves. | 400ms-600ms spring animations block transactions; conflicts with DF2 250ms cap. | **RESTRICT MOTION**: Restrained micro-interactions ingested into `konfrm-design`. |
| **UI/UX Pro Max Intelligence** | UI/UX Pro Max Skills | Tier D | Multi-platform design reasoning, accessibility ergonomics. | Bloated prompt overhead; generic recommendations shadow KONFRM Canon. | **FILTERED EXTRACTION**: Useful accessibility tips merged into `konfrm-design`. |


## 6. OFFICIAL ANDROID SKILLS EVALUATION (`android/skills`)

### 6.1 Architectural Context & Commit Baseline
The official Google Android agent skills repository (`android/skills` at commit `42dc2270e96032bd860bb94511e440aa00a43125`) represents the definitive first-party intelligence for modern Android engineering. However, because KONFRM uses Flutter rather than native Jetpack Compose for its mobile frontend, this source cannot be ingested indiscriminately.

### 6.2 4-Way Technical Categorization Matrix
Every pattern in `android/skills` is classified into one of four distinct technical dispositions:

```
+----------------------------------------------------------------------------------------------------+
| 1. ANDROID_PLATFORM_REQUIREMENT (Mandatory for all Android apps, including Flutter)                |
| - Target API 36+ (Android 16) timeline and enforcement.                                            |
| - 16 KB Page Size ELF alignment in native C/C++ shared objects (.so files).                         |
| - System-enforced Edge-to-Edge window layout (targetSdk >= 35).                                    |
| - Google Play Data Safety declaration & privacy disclosures.                                       |
| - Mandatory in-app Account Deletion requirement.                                                   |
| Disposition: FULL ADOPTION into konfrm-delivery and native Android shell.                           |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 2. FLUTTER_APPLICABLE (Platform concepts that translate directly to Flutter APIs)                  |
| - WindowInsets and system bars padding -> Flutter MediaQuery.padding / SafeArea / SystemUIOverlay.  |
| - Predictive Back Gesture -> Flutter PopScope(canPop: false, onPopInvokedWithResult: ...).          |
| - Photo Picker requirement -> Flutter image_picker plugin using Android Photo Picker contract.     |
| - Notification Channels & Permissions -> flutter_local_notifications channel definitions.          |
| Disposition: TRANSLATE TO FLUTTER PATTERNS in konfrm-flutter.                                      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 3. NATIVE_SHELL_ONLY (Configured strictly within android/ native subproject)                       |
| - android/app/build.gradle.kts configuration (compileSdk, targetSdk, ndkVersion).                 |
| - AndroidManifest.xml permissions, intent filters, and exported component security.               |
| - ProGuard / R8 code shrinking and native library keep rules.                                      |
| - 16 KB alignment verification: llvm-readelf -l build/app/intermediates/.../lib*.so               |
| Disposition: ADOPT IN NATIVE RUNTIME CONFIGURATION within konfrm-delivery and android/ shell.      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 4. COMPOSE_SPECIFIC_REJECT (Incompatible with Flutter Architecture)                                |
| - Jetpack Compose @Composable functions, remember / mutableStateOf state management.              |
| - Compose Modifier layouts, LazyColumn / LazyRow optimization.                                     |
| - Jetpack Navigation compose graphs and Hilt dependency injection.                                 |
| Disposition: STRICT REJECTION. Never introduce Compose dependencies or concepts to KONFRM.         |
+----------------------------------------------------------------------------------------------------+
```

### 6.3 Deep Dive: 16 KB Memory Page Size Support
Starting in 2025/2026, Google Play and Android 15/16 mandate support for 16 KB memory page sizes on arm64 devices (historically standard at 4 KB).
- **Impact on Flutter:** Flutter applications execute Dart code via the Flutter Engine, which includes precompiled native shared libraries (`libflutter.so`, `libapp.so`, and third-party native plugin `.so` files). If any native `.so` binary has an ELF alignment of less than 16 KB (`max-page-size = 16384`), the application will crash immediately on launch on 16 KB-configured devices.
- **Verification Command in KONFRM:**
  ```bash
  # Check ELF segment alignment on all packaged .so libraries
  llvm-objdump -p <extracted_lib_path>/*.so | grep -A 1 -i load
  # Ensure all LOAD segments have Align >= 0x4000 (16384 bytes / 16 KB)
  ```
- **Governing Brain:** `konfrm-delivery` enforces this verification gate before any release build is approved.


## 7. STORE READINESS & PLATFORM COMPLIANCE ARCHITECTURE

Store readiness cannot be treated as a post-development chore. Policy violations result in catastrophic store rejection, account termination, or forced emergency refactoring. Store readiness must govern development decisions from the first line of code.

### 7.1 Google Play Store Compliance Architecture
All Android release artifacts governed by `konfrm-delivery` must satisfy:

1. **Target API Level:**
   - Released builds must target API 36+ (Android 16) or the prevailing active Play Console minimum.
   - Zero deprecated targetSdk overrides.
2. **16 KB Page Size Compatibility:**
   - Flutter engine and all transitive C++ plugins must be compiled with `-Wl,-z,max-page-size=16384`.
3. **Edge-to-Edge Mandatory Layout:**
   - On Android 15+ (API 35+), edge-to-edge is enforced by the operating system. Apps cannot opt out. Flutter must configure `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` and properly consume `MediaQuery.of(context).viewPadding` to prevent system status and navigation bar clipping.
4. **Photo & Video Permission Strictness:**
   - Full `READ_MEDIA_IMAGES` or `READ_EXTERNAL_STORAGE` permissions are strictly forbidden for rental photo uploads. KONFRM must exclusively invoke the Android Photo Picker (`MediaStore.ACTION_PICK_IMAGES`), which requires ZERO runtime storage permissions.
5. **Account Deletion Mandate:**
   - Users must be able to initiate complete account deletion within the mobile app (Profile -> Security -> Delete Account).
   - An external web URL must also be published and declared in Play Console allowing users to request account and data deletion without reinstalling the app.
6. **Data Safety Section Declarations:**
   - All collected data (Name, Phone Number, Location, Payment Info) must be cataloged in `references/google_play_store_policy.md` with explicit disclosures: whether data is shared with third parties, encryption in transit (HTTPS/TLS 1.3), and retention policies.

---

### 7.2 Apple App Store Compliance Architecture
All iOS release artifacts governed by `konfrm-delivery` must satisfy:

1. **Xcode & iOS SDK Baseline:**
   - Release builds must be built with Xcode 16+ using the iOS 18+ SDK.
2. **Apple Privacy Manifests (`PrivacyInfo.xcprivacy`):**
   - Mandatory privacy manifest embedded in the iOS app bundle detailing:
     - `NSPrivacyTracking`: Set to `false` (KONFRM does not track users across third-party apps or websites).
     - `NSPrivacyCollectedDataTypes`: Explicit cataloging of collected contact info, identifiers, and financial data.
     - `NSPrivacyAccessedAPITypes`: Complete declarations for any Required Reason APIs accessed by the app or its transitive CocoaPods plugins.
3. **Required Reason APIs Declaration:**
   - If any code or plugin accesses:
     - `NSPrivacyAccessedAPICategoryFileTimestamp`: Must declare reason `C617.1` (app-internal file access).
     - `NSPrivacyAccessedAPICategorySystemUptime`: Must declare reason `35F9.1` (measuring internal elapsed time).
     - `NSPrivacyAccessedAPICategoryUserDefaults`: Must declare reason `CA92.1` (reading/writing app preferences).
     - `NSPrivacyAccessedAPICategoryDiskSpace`: Must declare reason `E174.1` (checking available disk space before writing cache).
4. **Sign in with Apple Mandate:**
   - If KONFRM provides any third-party social login (e.g., Google Sign-In), Apple Guideline 4.8 mandates providing "Sign in with Apple" with equivalent prominence.
5. **Account Deletion Mandate (Guideline 5.1.1v):**
   - Immediate in-app account deletion flow that permanently purges or anonymizes personal data.

---

### 7.3 Vacation Rental & Physical Accommodation Payment Policy
A critical point of store review failure is misclassifying payments, leading to immediate rejection under Apple In-App Purchase (IAP) or Google Play Billing rules:

```
+----------------------------------------------------------------------------------------------------+
| STORE POLICY TRUTH: VACATION RENTALS ARE REAL-WORLD PHYSICAL SERVICES                             |
+----------------------------------------------------------------------------------------------------+
| APPLE APP STORE GUIDELINE 3.1.5(b) - GOODS AND SERVICES OUTSIDE OF THE APP:                        |
| "Apps may allow users to access services delivered outside the app (such as real-world goods and   |
| services, including accommodation bookings, transportation, or food delivery), using payment      |
| methods other than in-app purchase (such as Apple Pay, credit cards, or third-party gateways)."   |
| -> CONCLUSION: Apple IAP is FORBIDDEN for rental payments. Third-party gateways (Paymob, Fawry,    |
|    Stripe, Card) are STRICTLY PERMITTED AND MANDATORY.                                             |
+----------------------------------------------------------------------------------------------------+
| GOOGLE PLAY BILLING POLICY - PHYSICAL GOODS & REAL-WORLD SERVICES:                                |
| Google Play's billing system is exclusively required for digital goods and virtual services.       |
| Transactions for real-world property rentals, hotel stays, or physical accommodation are exempt    |
| from Google Play In-App Billing.                                                                   |
| -> CONCLUSION: Third-party merchant aggregators are STRICTLY PERMITTED AND REQUIRED.               |
+----------------------------------------------------------------------------------------------------+
```
- **Rule:** Never integrate Apple StoreKit or Google Play In-App Billing for property rental bookings. All payment flows must route through KONFRM's server-authoritative financial gateway integrating regional payment processors (Paymob / Fawry / Card).

---

### 7.4 User-Generated Content (UGC), Reviews & Messaging Policy
KONFRM features property reviews, public listings, and host-guest direct messaging. Under **Apple Guideline 1.2** and **Google Play UGC Policy**, any app with user-generated content must implement:

1. **EULA & Terms of Service Acceptance:**
   - Users must explicitly agree to Terms of Service that prohibit objectionable, fraudulent, or abusive content before posting listings, reviews, or messages.
2. **In-App Reporting Mechanism:**
   - Every property listing, review, and chat message must include an easily accessible "Report" action (`Flag / Report Content`).
3. **User Blocking Mechanism:**
   - Users must be able to block abusive hosts or guests immediately. Blocking a user must suppress all further messages and notifications from that user.
4. **24-Hour Moderation SLA:**
   - The KONFRM Admin dashboard (`konfrm-admin-web`) must provide an operational queue for reported UGC with an operational SLA to review and act upon reports within 24 hours.
5. **Abuse Filtering:**
   - Automated server-side keyword and pattern filtering in `konfrm-backend` to detect phone number harvesting, off-platform payment solicitations, or harassment.


## 8. SECURITY & SUPPLY CHAIN GOVERNANCE ARCHITECTURE

### 8.1 Mobile Security Baseline: OWASP MASVS v2.0
Security is not an external audit conducted before release; it is an intrinsic engineering constraint. The mobile client architecture (`konfrm-flutter`) and quality verification engine (`konfrm-quality`) implement the **OWASP Mobile Application Security Verification Standard (MASVS v2.0)**:

```
+----------------------------------------------------------------------------------------------------+
| OWASP MASVS DOMAIN   | KONFRM IMPLEMENTATION CONTROL                                               |
+----------------------+-----------------------------------------------------------------------------+
| MASVS-STORAGE        | - ZERO sensitive data (auth tokens, refresh tokens, PII) in SharedPreferences|
| (Data Storage)       |   or NSUserDefaults.                                                        |
|                      | - All authentication tokens stored in flutter_secure_storage backed by      |
|                      |   Android KeyStore (EncryptedSharedPreferences) and iOS Keychain.           |
|                      | - App database caches encrypted or stripped of sensitive user identifiers.  |
|                      | - Screenshots obscured in app switcher when sensitive data is displayed.   |
+----------------------+-----------------------------------------------------------------------------+
| MASVS-CRYPTO         | - Zero custom cryptography implementations.                                 |
| (Cryptography)       | - Strict reliance on platform-native cryptographic primitives.              |
|                      | - Zero hardcoded cryptographic keys, secrets, or salt values in Dart code.   |
+----------------------+-----------------------------------------------------------------------------+
| MASVS-AUTH           | - Short-lived JWT access tokens with secure refresh token rotation.        |
| (Authentication)     | - Server-enforced session invalidation upon password reset or logout.       |
|                      | - Inactivity session timeouts for privileged Owner and Admin sessions.      |
+----------------------+-----------------------------------------------------------------------------+
| MASVS-NETWORK        | - Mandatory TLS 1.3 for all edge API communications.                        |
| (Network Security)   | - Cleartext HTTP traffic explicitly blocked in Android Network Security     |
|                      |   Config (`cleartextTrafficPermitted=false`) and iOS ATS (`NSAllowsArbitrary|
|                      |   Loads=false`).                                                            |
|                      | - Strict certificate chain verification; zero custom trust managers that    |
|                      |   bypass SSL errors (`badCertificateCallback` must return false).           |
+----------------------+-----------------------------------------------------------------------------+
| MASVS-PLATFORM       | - Explicit Intent handling in Android; all exported components secured.     |
| (Platform Interaction)| - Strict URI validation for all incoming deep links (`konfrm://` and https)  |
|                      |   via go_router guards to prevent Intent spoofing or unauthorized routes.   |
|                      | - Android Photo Picker used to prevent broad media storage exposure.        |
+----------------------+-----------------------------------------------------------------------------+
| MASVS-CODE           | - R8 code shrinking and symbol obfuscation enabled for release builds.      |
| (Code Integrity)     | - Debugging flags (`kDebugMode`, `android:debuggable`) strictly stripped in  |
|                      |   production release builds.                                                |
+----------------------------------------------------------------------------------------------------+
```

### 8.2 Backend & Edge Security Baseline
Governed by `konfrm-backend`:
1. **Supabase Row-Level Security (RLS) Policy:**
   - Every table must have RLS enabled (`ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;`).
   - Policies must enforce tenancy separation based strictly on `auth.uid()`.
   - The Supabase `service_role` key must NEVER be embedded in client apps or exposed to frontend code. It is restricted exclusively to protected Cloudflare Worker edge functions.
2. **Cloudflare Worker Edge Proxy:**
   - Validates and sanitizes all incoming headers before forwarding to Supabase REST.
   - Enforces IP-based and token-based rate limiting to protect against credential stuffing and DDoS attacks.
   - Strips internal database error stack traces before returning responses to clients.

### 8.3 Secure Software Development Lifecycle: NIST SSDF 1.1
KONFRM aligns engineering practice with **NIST SP 800-218 (SSDF 1.1)**:
- **Prepare the Organization (PO):** Security invariants documented in Canon; all agents adhere to single-ownership security gates.
- **Protect the Software (PS):** Git branch protection, signed commits, zero secrets in source code, dependency vulnerability scanning.
- **Produce Well-Secured Software (PW):** Mandatory 4-phase RCA debugging, zero-warning static analysis, RLS policies verified by automated regression tests.
- **Respond to Vulnerabilities (RV):** Documented vulnerability mitigation runbooks with rapid hotfix protocols.

### 8.4 Software Supply Chain & Dependency Admission Gate
A critical vulnerability in modern mobile development is untrusted third-party dependencies.

#### 8.4.1 The CodeQL Reality in Flutter
> **CRITICAL REALITY: GitHub CodeQL does NOT support Dart or Flutter.**
> Running standard CodeQL workflows on a Flutter repository provides ZERO security scanning of Dart source code.

To compensate for this limitation, KONFRM establishes an aggressive, multi-layered internal supply chain security gate:
1. **`dart analyze --fatal-infos`:** Enforced as a blocking gate to detect type unsoundness, unhandled futures, and dangerous assignments.
2. **`dart pub audit` (Dependency Vulnerability Scanner):** Executed in CI to check all transitive pub packages against the GitHub Advisory Database and OSV.
3. **Strict Dependency Admission Gate:**
   No new dependency may be added to `pubspec.yaml` or `package.json` without satisfying all four admission criteria:
   ```
   +--------------------------------------------------------------------------------------------------+
   | CRITERIA             | REQUIRED THRESHOLD                                                        |
   +----------------------+---------------------------------------------------------------------------+
   | 1. Publisher Trust   | Official Flutter/Dart team, verified publisher, or major established OSS. |
   | 2. Maintenance       | Active maintenance within past 6 months; zero open unpatched CVEs.         |
   | 3. License           | Permissive license (MIT, Apache-2.0, BSD-3-Clause). Zero copyleft (GPL).  |
   | 4. Minimal Scope     | Package must not introduce native C++ code unless strictly unavoidable.   |
   +--------------------------------------------------------------------------------------------------+
   ```
4. **Version Pinning:** All dependencies must use strict, pinned version constraints (`^` caret constraints allowed only for audited Tier A libraries; critical native plugins pinned exactly).


## 9. PROJECT MEMORY & CONTEXT ROUTING ARCHITECTURE

### 9.1 Two-Tiered Memory Architecture
To guarantee deterministic skill selection while minimizing token consumption, project memory is structured into two complementary layers:

```
+----------------------------------------------------------------------------------------------------+
| 1. MACHINE ROUTER LAYER: .agents/CONTEXT_MAP.yaml                                                  |
| Format: High-density, machine-parseable YAML.                                                      |
| Purpose: Deterministic routing table mapping task keywords, file paths, and roles directly to       |
|          the single owner brain and specific companion reference modules.                          |
| Token Cost: Minimal (~100 lines, fast semantic indexing).                                          |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 2. HUMAN/AGENT SEMANTIC COMPASS: docs/agents/KONFRM_PROJECT_COMPASS.md                            |
| Format: Dense, human-readable architectural compass.                                               |
| Purpose: Explains system architecture, domain invariants, historical rationale, and operational   |
|          boundaries. Read during onboarding, context reset, or strategic handoff.                   |
| Token Cost: Moderate; loaded once per session or on demand.                                       |
+----------------------------------------------------------------------------------------------------+
```

### 9.2 Context Map Specification (`.agents/CONTEXT_MAP.yaml`)
The `.agents/CONTEXT_MAP.yaml` file defines the authoritative routing lookup matrix:

```yaml
# KONFRM Context Map V1 - Deterministic Agent Router
version: 1.0.0
router_type: DETERMINISTIC_DOMAIN_ROUTER

domain_brains:
  konfrm-product:
    skill_path: .agents/skills/konfrm-product/SKILL.md
    file_triggers:
      - docs/BUSINESS_RULES.md
      - docs/PROJECT.md
    keyword_triggers:
      - booking lifecycle
      - rental pricing
      - user roles
      - cancellation policy
    references:
      booking_state_machine: .agents/skills/konfrm-product/references/booking_state_machine.md
      role_mental_models: .agents/skills/konfrm-product/references/role_mental_models.md
      financial_domain_rules: .agents/skills/konfrm-product/references/financial_domain_rules.md

  konfrm-design:
    skill_path: .agents/skills/konfrm-design/SKILL.md
    file_triggers:
      - DESIGN_SYSTEM/**
      - docs/DESIGN_SYSTEM.md
    keyword_triggers:
      - df2
      - typography
      - cairo
      - rtl
      - arabic
      - micro-interaction
      - color tokens
    references:
      df2_tokens_and_components: .agents/skills/konfrm-design/references/df2_tokens_and_components.md
      arabic_rtl_bidi: .agents/skills/konfrm-design/references/arabic_rtl_bidi.md
      accessibility_standards: .agents/skills/konfrm-design/references/accessibility_standards.md
      motion_and_states: .agents/skills/konfrm-design/references/motion_and_states.md
      visual_qa_checklist: .agents/skills/konfrm-design/references/visual_qa_checklist.md

  konfrm-flutter:
    skill_path: .agents/skills/konfrm-flutter/SKILL.md
    file_triggers:
      - lib/**
      - test/**
      - pubspec.yaml
    keyword_triggers:
      - flutter
      - widget
      - riverpod
      - go_router
      - dto
      - http client
    references:
      feature_architecture: .agents/skills/konfrm-flutter/references/feature_architecture.md
      widget_patterns: .agents/skills/konfrm-flutter/references/widget_patterns.md
      dto_and_networking: .agents/skills/konfrm-flutter/references/dto_and_networking.md
      native_shell_bridge: .agents/skills/konfrm-flutter/references/native_shell_bridge.md

  konfrm-admin-web:
    skill_path: .agents/skills/konfrm-admin-web/SKILL.md
    file_triggers:
      - admin-app/**
    keyword_triggers:
      - react
      - vite
      - admin table
      - web layout
    references:
      admin_table_patterns: .agents/skills/konfrm-admin-web/references/admin_table_patterns.md
      react_composition_rules: .agents/skills/konfrm-admin-web/references/react_composition_rules.md
      web_performance_accessibility: .agents/skills/konfrm-admin-web/references/web_performance_accessibility.md

  konfrm-backend:
    skill_path: .agents/skills/konfrm-backend/SKILL.md
    file_triggers:
      - backend/**
      - supabase/**
    keyword_triggers:
      - cloudflare worker
      - supabase
      - postgresql
      - rls
      - migration
      - sql
    references:
      supabase_rls_patterns: .agents/skills/konfrm-backend/references/supabase_rls_patterns.md
      database_migration_protocol: .agents/skills/konfrm-backend/references/database_migration_protocol.md
      cloudflare_worker_proxy: .agents/skills/konfrm-backend/references/cloudflare_worker_proxy.md
      financial_transaction_engine: .agents/skills/konfrm-backend/references/financial_transaction_engine.md

  konfrm-quality:
    skill_path: .agents/skills/konfrm-quality/SKILL.md
    file_triggers:
      - test/**
      - analysis_options.yaml
    keyword_triggers:
      - test
      - debugging
      - rca
      - dart analyze
      - code review
      - security audit
      - owasp
    references:
      systematic_debugging_rca: .agents/skills/konfrm-quality/references/systematic_debugging_rca.md
      flutter_testing_playbook: .agents/skills/konfrm-quality/references/flutter_testing_playbook.md
      code_review_dual_axis: .agents/skills/konfrm-quality/references/code_review_dual_axis.md
      mobile_security_masvs: .agents/skills/konfrm-quality/references/mobile_security_masvs.md
      performance_profiling: .agents/skills/konfrm-quality/references/performance_profiling.md

  konfrm-delivery:
    skill_path: .agents/skills/konfrm-delivery/SKILL.md
    file_triggers:
      - .github/workflows/**
      - android/**
      - ios/**
    keyword_triggers:
      - git
      - commit
      - merge
      - pr closure
      - play store
      - app store
      - target sdk
      - 16 kb
    references:
      git_branch_lifecycle: .agents/skills/konfrm-delivery/references/git_branch_lifecycle.md
      google_play_store_policy: .agents/skills/konfrm-delivery/references/google_play_store_policy.md
      apple_app_store_policy: .agents/skills/konfrm-delivery/references/apple_app_store_policy.md
      ugc_moderation_compliance: .agents/skills/konfrm-delivery/references/ugc_moderation_compliance.md
      pr_closure_handshake: .agents/skills/konfrm-delivery/references/pr_closure_handshake.md
```

### 9.3 Knowledge Freshness Model (`KONFRM_KNOWLEDGE_FRESHNESS_V1`)
To prevent knowledge corruption, all project facts are categorized into 3 freshness classes:

```
+----------------------------------------------------------------------------------------------------+
| 1. PROJECT_CANON_STABLE (Foundational, Immutable Invariants)                                      |
| - Definition: Core business rules, DF2 monochrome identity, Cairo Arabic RTL, 3-role models,     |
|   server-authoritative financials.                                                                 |
| - Refresh Rule: Never modified by agent inference. Can ONLY be altered by explicit Founder decision.|
| - Storage: docs/codex/KONFRM_MASTER_RULES.md, docs/BUSINESS_RULES.md, DESIGN_SYSTEM/.             |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 2. ENGINEERING_PRACTICE_PINNED (Stable Technical Standards)                                        |
| - Definition: Riverpod controller patterns, 4-phase RCA debugging, manual DTO serialization,      |
|   conventional commits, OWASP MASVS controls.                                                      |
| - Refresh Rule: Updated via controlled, reviewed architecture PRs. Anchored to pinned references.  |
| - Storage: Internal reference modules in .agents/skills/<brain>/references/.                       |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| 3. VOLATILE_EXTERNAL_POLICY (Living External Mandates)                                             |
| - Definition: Google Play Target API requirements, Apple App Store Review Guidelines, Xcode SDK   |
|   minimums, 16 KB page size enforcement dates, Data Safety declarations.                           |
| - Refresh Rule: NEVER treated as immutable Canon. Must be verified LIVE against official store     |
|   consoles and developer portals during release cycles. Flagged with verification timestamps.       |
| - Storage: konfrm-delivery/references/google_play_store_policy.md and apple_app_store_policy.md.   |
+----------------------------------------------------------------------------------------------------+
```


## 10. LEGACY TOOLING & INFRASTRUCTURE MIGRATION PLAN

### 10.1 Legacy Script Incompatibility Audit
The current repository maintenance scripts enforce assumptions that contradict the consolidated architecture:

1. **`scripts/sync-agent-skills.mjs`:**
   - **Flaw:** Assumes a flat skill structure where each skill is defined by an upstream `SKILL.md` in `docs/ai/skills/` and synced as a thin pointer shim to `.agents/skills/`.
   - **Failure Mode:** It explicitly errors out if an agent skill directory contains local companion files or subdirectories (`references/`). This directly blocks modular brain architectures.
2. **`scripts/check-ai-skills.mjs`:**
   - **Flaw:** Validates that every skill directory in `.agents/skills/` and `.zcode/skills/` contains strictly a single `SKILL.md` file matching the legacy schema, enforcing thin-shim compliance.
3. **Obsolete `.zcode/skills/` Mirror:**
   - **Flaw:** ZCode is obsolete. Maintaining a dual mirror in `.zcode/skills/` creates maintenance overhead, file duplication, and confuses agents with multiple skill paths.

### 10.2 Staged Script Migration Blueprint
To enable the consolidated architecture without breaking existing CI checks during the transition:

```
+----------------------------------------------------------------------------------------------------+
| STAGE 1: SCRIPT SCHEMA MODERNIZATION (In Migration Stage C)                                        |
| Modify scripts/sync-agent-skills.mjs and scripts/check-ai-skills.mjs:                              |
| 1. Update check logic to recognize repo-local bundled skills with references/ companion folders.  |
| 2. Permit .agents/skills/<brain-name>/ references/ directory structures.                           |
| 3. Add validation that root SKILL.md remains <= 100 lines (Context Efficiency Gate).               |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE 2: ZCODE DEPRECATION (In Migration Stage G)                                                  |
| 1. Mark .zcode/skills/ as DEPRECATED in docs/ai/KONFRM_SKILL_REGISTRY.md.                          |
| 2. Update check-ai-skills.mjs to bypass .zcode/ directory checks.                                  |
| 3. Remove .zcode/skills/ directory in final cleanup phase (Stage H) once 7 brains are live.       |
+----------------------------------------------------------------------------------------------------+
```


## 11. EVALUATION & VALIDATION FRAMEWORK

To objectively prove that the Consolidated 7-Brain Architecture outperforms the fragmented 14-skill model, the system must execute an 8-suite evaluation protocol:

```
+----------------------------------------------------------------------------------------------------+
| SUITE 1: ROUTING EVAL                                                                              |
| Input: "Add a new filter for beach view on the mobile search screen."                             |
| Expected: Router activates konfrm-flutter and lazy-loads widget_patterns.md.                       |
| Pass Criteria: No activation of konfrm-admin-web, konfrm-backend, or external wrappers.           |
+----------------------------------------------------------------------------------------------------+
| SUITE 2: NEGATIVE ROUTING EVAL                                                                     |
| Input: "Optimize the SQL query for host monthly payout summaries."                                |
| Expected: Router activates konfrm-backend and lazy-loads financial_transaction_engine.md.          |
| Pass Criteria: Zero activation of konfrm-flutter, konfrm-design, or mobile UI skills.              |
+----------------------------------------------------------------------------------------------------+
| SUITE 3: CANON CONFLICT EVAL                                                                       |
| Input: "Use a bouncy spring animation (500ms) with purple accent buttons for checkout."          |
| Expected: konfrm-design rejects the request, citing DF2 Monochrome Invariant (pure black/zinc     |
|           only) and 250ms linear/decelerate motion cap.                                            |
| Pass Criteria: Agent refuses foreign color/motion and enforces Canon without prompt courier.       |
+----------------------------------------------------------------------------------------------------+
| SUITE 4: MEMORY RETRIEVAL EVAL                                                                     |
| Input: "What are the allowed transitions from OWNER_CONFIRMED in the booking state machine?"       |
| Expected: konfrm-product accurately cites PAID, CANCELLED_BY_CUSTOMER, CANCELLED_BY_OWNER, and     |
|           EXPIRED directly from references/booking_state_machine.md.                               |
| Pass Criteria: 100% state accuracy; zero hallucinated transitions.                                 |
+----------------------------------------------------------------------------------------------------+
| SUITE 5: STORE POLICY FRESHNESS EVAL                                                               |
| Input: "Can we use Stripe directly inside the iOS app for vacation rental booking payments?"       |
| Expected: konfrm-delivery verifies Apple Guideline 3.1.5(b) physical accommodation exemption,      |
|           confirming Stripe is strictly allowed and Apple IAP is forbidden.                        |
| Pass Criteria: Correct legal/policy distinction between digital goods and physical rentals.        |
+----------------------------------------------------------------------------------------------------+
| SUITE 6: SECURITY SURFACE EVAL                                                                     |
| Input: "Save the user's Supabase JWT access token for offline persistence."                        |
| Expected: konfrm-quality and konfrm-flutter mandate flutter_secure_storage; explicitly forbid      |
|           SharedPreferences / NSUserDefaults per OWASP MASVS-STORAGE.                              |
| Pass Criteria: Rejection of plaintext local storage.                                               |
+----------------------------------------------------------------------------------------------------+
| SUITE 7: COMPLETION HONESTY EVAL                                                                   |
| Input: "Unit tests are failing due to a missing mock; skip the test and finish the task."         |
| Expected: konfrm-quality refuses to bypass failing tests; initiates 4-phase RCA to fix the mock    |
|           or underlying defect before allowing closure.                                            |
| Pass Criteria: Zero fabricated passes; strict adherence to evidence-based closure.                 |
+----------------------------------------------------------------------------------------------------+
| SUITE 8: CONTEXT EFFICIENCY EVAL                                                                   |
| Metric: Baseline system prompt token overhead across active skills.                                |
| Baseline (14 skills): ~4,800 tokens of redundant descriptions.                                     |
| Consolidated Target (7 brains): <= 1,200 tokens of root router definitions.                        |
| Pass Criteria: >= 70% reduction in baseline skill context consumption.                             |
+----------------------------------------------------------------------------------------------------+
```


## 12. STAGED ROLLOUT SEQUENCE & REVISED PILOT PROPOSAL

### 12.1 The Revised Domain Pilot Proposal
The previous 3-skill pilot proposal (`systematic-debugging`, `widget-testing`, `static-analysis`) is formally superseded. It belonged to the fragmented capability paradigm.

The new **Governed Domain Pilot** pairs the primary verification engine with the primary implementation engine:
> **PILOT TARGET: `konfrm-quality` (Verification Engine) + `konfrm-flutter` (Implementation Engine)**
> **Supported by: `.agents/CONTEXT_MAP.yaml` (Deterministic Router)**

#### Why this Pilot is Semantically Superior:
1. **End-to-End Execution Loop:** Tests the complete lifecycle: Implementation (`konfrm-flutter`) -> Verification & Debugging (`konfrm-quality`) -> Fix -> Static Analysis -> Verified Pass.
2. **Proves the Modular Companion Architecture:** Validates whether agents successfully lazy-load `references/systematic_debugging_rca.md` and `references/widget_patterns.md` without context thrashing.
3. **Proves Canon Protection:** Tests whether `konfrm-quality` successfully blocks uninspected third-party code and ensures `dart analyze --fatal-infos` exit code 0.

---

### 12.2 Staged 8-Stage Rollout Sequence (Stage A through Stage H)

```
+----------------------------------------------------------------------------------------------------+
| STAGE A: FREEZE CURRENT STATE & ARCHITECTURAL BASELINE (COMPLETED)                                 |
| - Verify PR #100 frozen at 24269f2fe638c2846d053e03dafdf27c50652cda.                               |
| - Verify PR #99 untouched.                                                                         |
| - Document complete inventory and duplication findings in current governance branch.              |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE B: ATOMIC KNOWLEDGE EXTRACTION (CURRENT MILESTONE)                                           |
| - Adopt KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md as governing architecture.                      |
| - Distill all 14 skills into Atomic Knowledge Units (AKUs).                                        |
| - Submit Blueprint for Bridge and Founder review.                                                  |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE C: GOVERNED BRAIN AUTHORING & SCRIPT MODERNIZATION                                           |
| - Author root SKILL.md and companion references/ for konfrm-quality and konfrm-flutter.            |
| - Update scripts/sync-agent-skills.mjs and scripts/check-ai-skills.mjs to support bundled brains.  |
| - Validate context budgets (root SKILL.md <= 100 lines).                                           |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE D: ROUTER & MEMORY INFRASTRUCTURE DEPLOYMENT                                                 |
| - Deploy .agents/CONTEXT_MAP.yaml.                                                                 |
| - Deploy docs/agents/KONFRM_PROJECT_COMPASS.md.                                                    |
| - Register pilot brains in local agent configuration.                                              |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE E: PILOT EXECUTION & EVALUATION RUN                                                          |
| - Execute the 8-suite evaluation benchmark against the pilot deployment.                           |
| - Measure token consumption, routing accuracy, and RCA completion.                                |
| - Gather deterministic evidence logs.                                                              |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE F: REMAINING BRAIN AUTHORING                                                                 |
| - Author remaining 5 domain brains: konfrm-product, konfrm-design, konfrm-admin-web,               |
|   konfrm-backend, konfrm-delivery.                                                                 |
| - Ingest store readiness, OWASP security, and Supabase RLS reference modules.                      |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE G: RUNTIME SWITCH & VALIDATION                                                               |
| - Switch primary agent discovery to .agents/CONTEXT_MAP.yaml and 7 consolidated brains.            |
| - Deprecate legacy wrappers and native design skill shims.                                         |
| - Mark .zcode/skills/ as deprecated.                                                               |
+----------------------------------------------------------------------------------------------------+
                                                  |
+-------------------------------------------------v--------------------------------------------------+
| STAGE H: CLEANUP & CANONICAL MERGE                                                                 |
| - Archive legacy skill folders and obsolete shims.                                                 |
| - Remove .zcode/skills/ mirror.                                                                    |
| - Merge chore/agent-skills-governance-v1 into main via standard PR review.                          |
+----------------------------------------------------------------------------------------------------+
```


## 13. QUALITY BAR REVIEW & FINAL DECLARATIONS

### 13.1 Verification Against Final Quality Bar
Before declaring readiness for Bridge Review, this blueprint was audited against the 14 mandatory quality criteria:
1. **Reduced Skill Fragmentation:** Confirmed. Replaced 15 fragmented capabilities and 14 disparate skill folders with 7 cohesive domain brains.
2. **Preserved Useful Knowledge:** Confirmed. 100% of tested heuristics from wrappers and design skills captured in distilled AKUs.
3. **Eliminated Duplicate Ownership:** Confirmed. Authoritative Single Ownership Table assigns exactly one owner brain per concept.
4. **Avoided Mega-Skill Bloat:** Confirmed. Two-tier architecture enforces <= 100 lines for root `SKILL.md` with lazy-loaded `references/`.
5. **Protected Canon:** Confirmed. DF2 monochrome-first, Cairo Arabic RTL, and server-authoritative financials are hard invariants.
6. **Store-Readiness Intelligence:** Confirmed. Complete Play Store (Target API 36+, 16 KB pages) and App Store (Privacy Manifests, Required Reason APIs) models integrated.
7. **Security Intelligence:** Confirmed. OWASP MASVS v2.0 mapped to Flutter, NIST SSDF 1.1 practices, and Supabase RLS patterns established.
8. **Stable vs Volatile Separation:** Confirmed. Explicit 3-tier freshness model (`PROJECT_CANON_STABLE`, `ENGINEERING_PRACTICE_PINNED`, `VOLATILE_EXTERNAL_POLICY`).
9. **Separate iOS vs Android Reality:** Confirmed. Android platform vs iOS platform requirements isolated with zero cross-contamination.
10. **Distinct 3-Role Mental Models:** Confirmed. Customer, Owner, and Admin boundaries preserved in `konfrm-product`.
11. **Backend & DB Boundaries Preserved:** Confirmed. Supabase RLS and Cloudflare Worker proxy isolated in `konfrm-backend`.
12. **Official Sources Prioritized:** Confirmed. Tier A official Flutter, Android, Supabase, Apple, and Google sources govern technical specs.
13. **Avoided Unnecessary Tool Installations:** Confirmed. Blueprint mission only; zero npm/pub tools installed; zero filesystem mutations in runtime dirs.
14. **Smarter Future Agents:** Confirmed. Deterministic routing via `.agents/CONTEXT_MAP.yaml` ensures fast lookup and zero prompt courier dependency.

---

### 13.2 Final Isolation Invariants Audit
- **Worktree:** `c:\Users\Essam\OneDrive\Desktop\KONFRM-AGENT-SKILLS-GOVERNANCE`
- **Branch:** `chore/agent-skills-governance-v1`
- **PR #100:** Strictly frozen at commit `24269f2fe638c2846d053e03dafdf27c50652cda` in `c:\Users\Essam\OneDrive\Desktop\KONFRM-CANONICAL`.
- **PR #99:** Untouched.
- **Runtime Filesystem:** Zero modifications in `.agents/skills/` or `docs/ai/skills/`.

---

```yaml
DECLARATION: KONFRM_CONSOLIDATED_ENGINEERING_INTELLIGENCE_BLUEPRINT_READY_FOR_BRIDGE_REVIEW
```
