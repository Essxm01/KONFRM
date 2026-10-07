# KONFRM Agent Skills Registry V1
## Master Catalog, Bundle Manifests, Progressive Disclosure, and Network Classification Matrix

**Document Version:** 1.3.0
**Status:** DRAFT — PENDING FINAL BRIDGE APPROVAL
**Scope:** Universal Catalog of Audited Internal, Governed, and Candidate Agent Skills
**Target Repository:** `Essxm01/KONFRM`
**Governing Standard:** `docs/agents/KONFRM_AGENT_SKILLS_GOVERNANCE_V1.md`

---

## 1. Registry Architecture & Governance Standards

This registry provides the authoritative evaluation of all native KONFRM skills, active governed wrappers, and audited external candidate skills. Every governed skill is maintained as a physically flat **`KONFRM_SKILL_BUNDLE_V1`** direct child under `.agents/skills/<skill-name>/` paired with governance records in `docs/ai/skills/<skill-name>/`.

### Progressive Disclosure Model (`KONFRM_SKILL_DISCLOSURE_V1`)
To minimize token consumption and eliminate directory traversal overhead, all skills adhere to three disclosure levels:
- **Level 0 — Discovery Metadata:** Skill Name, Governed Taxonomy Prefix, Trigger Intent, Direct Path, and Description meeting the Description Quality Standard (answers WHEN to use, WHAT task class, and WHEN NOT to use).
- **Level 1 — `SKILL.md`:** Authoritative executable workflow loaded **only** upon skill selection.
- **Level 2 — Supporting References:** Deep-dive guides in `references/` loaded **only** when a specific subtask demands them.

### Activation Modes
- **`ALWAYS_ON_RULE`**: Universal project constitutional rules (Canon precedence, Git safety, no rule fabrication, root-cause diagnosis). Maintained in the minimal core (`AGENTS.md` / Master Rules), never bloated into a skill.
- **`MANDATORY_ON_TRIGGER`**: Domain skill that is not always loaded, but becomes strictly mandatory when a matching task condition exists (e.g., bug $\to$ systematic debugging; Flutter change $\to$ static analysis).
- **`RECOMMENDED_ON_TRIGGER`**: Highly effective domain accelerator loaded when matching task context occurs.
- **`ON_DEMAND`**: Specialized capability invoked strictly when explicitly requested by a task contract or subagent.
- **`EXPERIMENTAL`**: Under evaluation; isolated testing permitted, but not authorized for routine production workflows.
- **`USER_LEVEL_ONLY`**: Personal prompt/pacing preference; belongs in user client settings (`~/.gemini/config/skills/`), never in repository.
- **`DISCOVERY_ONLY_OUTSIDE_EXECUTION`**: Tool permitted outside active task runs; prohibited during execution.
- **`INTERNAL_SKILL_CANDIDATE`**: Future internal skill to be authored natively; not an external vendor skill.
- **`REJECT`**: Incompatible with KONFRM architecture, unsecure, or context-wasteful. Forbidden from repository.

### Network Classification Classes
- **`LOCAL_ONLY`**: 100% self-contained local execution; zero outbound network calls, telemetry, or remote API dependencies. Default approved class.
- **`NETWORK_OPTIONAL_EXPLICIT`**: Operates completely in local core mode by default. External reference mode requires explicit Founder authorization.
- **`NETWORK_REQUIRED_ON_DEMAND`**: Network calls required for primary function. Prohibited from default runtime; on-demand use only with explicit approval.
- **`REJECT_NETWORK_PROFILE`**: Requires external SaaS bearer tokens or unconditional phone-home behavior. Banned from repository.

### Governed Naming Taxonomy
All skills conform to standard functional prefixes:
`konfrm-core-*` | `konfrm-flutter-*` | `konfrm-web-*` | `konfrm-backend-*` | `konfrm-qa-*` | `konfrm-design-*`

---

## 2. Internal Skills & Active Governed Wrappers (Audited Base Check)

Every skill listed below has been verified on the base checkpoint (`9c908d2756fba0d421e67959ecfbc13d0ca35f9b`) and resides as a direct child of `.agents/skills/`.

| # | Runtime Skill Name | Governed Taxonomy Category | Direct Runtime Path | Trigger Intent | Activation Mode | Network Class | Level 0 Quality-Standard Description | Level 2 References |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| **01** | `konfrm-product-ux` | `konfrm-design-*` / Core | `.agents/skills/konfrm-product-ux/` | Customer booking, Owner operations, Admin audit UX | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when designing or implementing user-facing flows across Customer, Owner, or Admin apps. Enforces 3-role UX, truthful state grammar, and density. Do not use for backend-only migrations. | None |
| **02** | `konfrm-mobile-design` | `konfrm-design-*` / Flutter | `.agents/skills/konfrm-mobile-design/` | Flutter UI, layout, styling, DF2 tokens | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when implementing or styling mobile widgets for Customer or Owner Flutter apps. Enforces DF2 Mobile Foundation v1.7, component-scoped radii, and 4–32 spacing. Do not use for Admin Web. | None |
| **03** | `konfrm-rtl-arabic` | `konfrm-core-*` / Universal | `.agents/skills/konfrm-rtl-arabic/` | Arabic text, RTL layout, currency, Bidi isolation | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when handling Arabic strings, RTL directional layouts, Cairo typography, Egyptian currency (`1,600 ج.م`), or Western digits (`0-9`). Do not use for English-only backend scripts. | None |
| **04** | `konfrm-accessibility` | `konfrm-qa-*` / Universal | `.agents/skills/konfrm-accessibility/` | Accessibility audit, screen readers, semantic labels | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when auditing or modifying accessible labels, TalkBack/VoiceOver semantics, touch targets, or text scaling. Enforces WCAG 2.2 AA. Do not use for non-UI data layer code. | None |
| **05** | `konfrm-visual-qa` | `konfrm-qa-*` / Visual | `.agents/skills/konfrm-visual-qa/` | Visual review, multi-viewport verification, UI states | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when validating physical rendering across candidate viewports (100%/125%/150%/200%) and interactive states. Do not use as a substitute for automated unit tests. | None |
| **06** | `konfrm-design-router` | `konfrm-core-*` / Triage | `.agents/skills/konfrm-design-router/` | Triage of incoming design or UI engineering tasks | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when triaging or classifying new UI tasks by role, surface, and complexity to activate minimal skill sets. Do not use for routine non-design code edits. | None |
| **07** | `konfrm-design-reasoning`| `konfrm-design-*` / Advisory | `.agents/skills/konfrm-design-reasoning/` | Ambiguous UI layouts, complex visual decisions | `RECOMMENDED_ON_TRIGGER`| `LOCAL_ONLY` | Use when resolving contested visual trade-offs via structured dialectics (Hypotheses A/B/C). Do not use for standardized token applications. | None |
| **08** | `konfrm-design-court` | `konfrm-core-*` / Adjudication| `.agents/skills/konfrm-design-court/` | Severe design conflict, unresolved UI disputes | `ON_DEMAND` | `LOCAL_ONLY` | Use strictly when convened by Bridge to adjudicate high-friction, ambiguous design decisions with multi-role debate. Do not use for routine implementation tasks. | None |
| **09** | `frontend-design-wrapper`| `konfrm-design-*` / Advisory | `.agents/skills/frontend-design-wrapper/` | Web/mobile visual layout anti-patterns | `RECOMMENDED_ON_TRIGGER`| `LOCAL_ONLY` | Use when building novel UI layouts requiring visual hierarchy refinement. Bound to Cairo and DF2 monochrome identity. Do not use for backend logic. | None |
| **10** | `impeccable-wrapper` | `konfrm-design-*` / Polish | `.agents/skills/impeccable-wrapper/` | Micro-polish, alignment audit, optical spacing | `RECOMMENDED_ON_TRIGGER`| `LOCAL_ONLY` | Use when performing final visual polish and spatial alignment audits. Enforces zero binary hook execution. Do not use for business logic or data pipelines. | None |
| **11** | `emil-wrapper` | `konfrm-design-*` / Motion | `.agents/skills/emil-wrapper/` | Gestures, tactile feedback, micro-animations | `RECOMMENDED_ON_TRIGGER`| `LOCAL_ONLY` | Use when implementing interruptible gestures, sheet physics, or tactile micro-interactions in Flutter. Easing heuristics are candidates. Do not use for Admin Web. | None |
| **12** | `ui-ux-pro-max-wrapper` | `konfrm-design-*` / Reference | `.agents/skills/ui-ux-pro-max-wrapper/` | Searchable UX guidelines across patterns | `ON_DEMAND` | `LOCAL_ONLY` | Use when researching specialized UX patterns (e.g. complex data filtering, undo stacks). Forbids repository token mutations. Do not use for general coding. | None |
| **13** | `vercel-web-guidelines-wrapper`| `konfrm-web-*` / Guidelines | `.agents/skills/vercel-web-guidelines-wrapper/` | Admin Web performance, semantics, accessibility | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when implementing or reviewing Admin Web (React 19) components. Enforces web accessibility and responsive HTML. Strictly forbidden in Flutter code. | None |
| **14** | `vercel-composition-wrapper`| `konfrm-web-*` / Patterns | `.agents/skills/vercel-composition-wrapper/` | React 19 component composition, prop design | `RECOMMENDED_ON_TRIGGER`| `LOCAL_ONLY` | Use when structuring compound React 19 components and custom hooks for Admin Web. Strictly forbidden in Flutter mobile code. | None |

---

## 3. Audited External Candidate Skills Registry

All external skills are evaluated as self-contained bundles. Upon installation, each runtime bundle resides as a direct child under `.agents/skills/<konfrm-runtime-name>/`. Routine execution agents **MUST NEVER** read the historical vendor snapshots in `docs/ai/skills/`.

| # | Upstream Skill & Pinned Commit SHA | KONFRM Runtime Name | Governed Taxonomy Category | Direct Runtime Path | Trigger Intent | Activation Mode | Network Class | Level 0 Quality-Standard Description | Level 2 References (Loaded on Demand Only) |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| **15** | `obra/superpowers`<br>`systematic-debugging`<br>`8ca22dba9a94f28898bbce59f2537ff4d87c747d` | `konfrm-systematic-debugging` | `konfrm-qa-*` | `.agents/skills/konfrm-systematic-debugging/` | Bug, failing test, build error, unexpected runtime behavior | **`MANDATORY_ON_TRIGGER` (PILOT)** | `LOCAL_ONLY` | Use when diagnosing any failing test, build breakage, or runtime defect across mobile, web, or backend. Enforces 4-phase root-cause analysis before editing. Do not use for greenfield feature authoring. | `references/root-cause-tracing.md`<br>`references/defense-in-depth.md`<br>`references/condition-based-waiting.md` |
| **16** | `flutter/agent-plugins`<br>`flutter-add-widget-test`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-widget-testing` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-widget-testing/` | Flutter widget testing, regression test creation, semantics verification | **`MANDATORY_ON_TRIGGER` (PILOT)** | `LOCAL_ONLY` | Use when creating or updating Flutter widget tests, finder assertions, tester pumps, and semantic node checks. Do not use for pure Dart unit tests or Admin Web. | None |
| **17** | `dart-lang/skills`<br>`dart-run-static-analysis`<br>`0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49` | `konfrm-dart-static-analysis` | `konfrm-flutter-*` / `konfrm-qa-*` | `.agents/skills/konfrm-dart-static-analysis/` | Dart/Flutter static analysis, lint verification, pre-completion gate | **`MANDATORY_ON_TRIGGER` (PILOT)** | `LOCAL_ONLY` | Use when running static analysis or verifying zero warnings across Dart/Flutter code. Enforces read-only analysis and dry-run fixes. Do not use for Admin Web or TypeScript. | None |
| **18** | `flutter/agent-plugins`<br>`flutter-add-integration-test`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-integration-test` | `konfrm-flutter-*` / `konfrm-qa-*` | `.agents/skills/konfrm-flutter-integration-test/` | Flutter device/driver end-to-end integration tests | `ON_DEMAND` | `LOCAL_ONLY` | Use when building automated device integration tests. Requires dedicated test entrypoint (`lib/main_test.dart`); forbids editing `lib/main.dart`. Do not use for component widget tests. | None |
| **19** | `flutter/agent-plugins`<br>`flutter-build-responsive-layout`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-responsive-layout` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-responsive-layout/` | Multi-screen Flutter layout, orientation, breakpoint adaptation | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when adapting Flutter views across phones and tablets. Enforces DF2 spacing scale (`4/8/12/16/24/32`). Do not use for Admin Web CSS layouts. | None |
| **20** | `flutter/agent-plugins`<br>`flutter-fix-layout-issues`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-layout-fixer` | `konfrm-flutter-*` / `konfrm-qa-*` | `.agents/skills/konfrm-flutter-layout-fixer/` | RenderFlex overflow, unbounded height/width constraints | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when resolving RenderFlex yellow tape overflows and unbounded constraints. Forbids blind SingleChildScrollView wrapping. Do not use for non-layout bugs. | None |
| **21** | `flutter/agent-plugins`<br>`flutter-apply-architecture-best-practices`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-architecture` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-architecture/` | Structuring Flutter feature directories, Riverpod providers | `RECOMMENDED_ON_TRIGGER` (ADAPTED) | `LOCAL_ONLY` | Use when creating new Flutter features or controllers. Enforces Feature-First, Riverpod without codegen, and fail-closed errors. Strips MVVM/ChangeNotifier. Do not use for Web/Backend. | None |
| **22** | `flutter/agent-plugins`<br>`flutter-setup-declarative-routing`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-routing` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-routing/` | Flutter route navigation, screen transitions, route guards | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when configuring declarative Flutter routes (`go_router`). Concrete deep-link URLs deferred. Do not use for web browser routing. | None |
| **23** | `flutter/agent-plugins`<br>`flutter-setup-localization`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-localization` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-localization/` | Flutter ARB files, localized string extract, string formatting | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when extracting or managing Flutter localized strings in ARB files. Enforces Western Arabic digits (`0-9`) default and Egyptian currency formatting. Do not use for hardcoded strings. | None |
| **24** | `flutter/agent-plugins`<br>`flutter-use-http-package`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-http` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-http/` | Flutter REST client calls, API error handling, network timeouts | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when implementing client HTTP network calls via `package:http`. Enforces fail-closed handling. Do not use for local database access. | None |
| **25** | `flutter/agent-plugins`<br>`flutter-add-widget-preview`<br>`0ef3972f93e2baa4156ba1cbb1e515cd53079c68` | `konfrm-flutter-widget-preview` | `konfrm-flutter-*` | `.agents/skills/konfrm-flutter-widget-preview/` | Isolated widget testbed harnesses, component preview | `ON_DEMAND` | `LOCAL_ONLY` | Use when creating isolated visual harness environments in `test/`. Forbids preview harness code in production `lib/`. Do not use for production widgets. | None |
| **26** | `dart-lang/skills`<br>`dart-add-unit-test`<br>`0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49` | `konfrm-dart-unit-test` | `konfrm-flutter-*` / `konfrm-qa-*` | `.agents/skills/konfrm-dart-unit-test/` | Pure Dart unit tests, data model serialization, business logic tests | `MANDATORY_ON_TRIGGER` | `LOCAL_ONLY` | Use when writing deterministic pure Dart unit tests for DTOs, controllers, or utility functions. Do not use for UI widget testing. | None |
| **27** | `dart-lang/skills`<br>`dart-collect-coverage`<br>`0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49` | `konfrm-dart-coverage` | `konfrm-qa-*` | `.agents/skills/konfrm-dart-coverage/` | Test coverage collection, LCOV reporting, test gap audit | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when auditing test coverage gaps across Dart packages. Prioritizes assertion rigor over coverage percentages. Do not use for routine bug fixes. | None |
| **28** | `dart-lang/skills`<br>`dart-build-cli-app`<br>`0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49` | `konfrm-dart-cli` | `konfrm-core-*` | `.agents/skills/konfrm-dart-cli/` | Offline Dart developer CLI tools, code generators | `ON_DEMAND` | `LOCAL_ONLY` | Use when creating standalone offline developer CLI tools. Zero CLI dependencies permitted in application packages. Do not use for app runtime features. | None |
| **29** | `mattpocock/skills`<br>`tdd`<br>`f3fc5632f401156837ee3872f14fe33ccf1024ea` | `konfrm-tdd` | `konfrm-qa-*` | `.agents/skills/konfrm-tdd/` | Test-driven development, red-green-refactor loops | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when developing complex algorithms or data transformations via red-green-refactor cycles. Does not interrupt Founder for established seams. Do not use for quick visual tweaks. | `references/tests.md`<br>`references/mocking.md` |
| **30** | `mattpocock/skills`<br>`code-review`<br>`f3fc5632f401156837ee3872f14fe33ccf1024ea` | `konfrm-code-review` | `konfrm-qa-*` | `.agents/skills/konfrm-code-review/` | PR review, code inspection, pre-merge closure audit | `RECOMMENDED_ON_TRIGGER` | `LOCAL_ONLY` | Use when reviewing pull requests along Standards and Spec axes. Findings are advisory. Do not use for code authoring. | None |
| **31** | `mattpocock/skills`<br>`codebase-design`<br>`f3fc5632f401156837ee3872f14fe33ccf1024ea` | `konfrm-core-*` / Advisory | `.agents/skills/konfrm-codebase-design/` | Modular code architecture, coupling/cohesion assessment | `ON_DEMAND` | `LOCAL_ONLY` | Use when evaluating architectural modularity or high coupling across subsystems. Advisory only; Canon governs. Do not use for routine bug fixes. | None |
| **32** | `mattpocock/skills`<br>`grill-with-docs`<br>`f3fc5632f401156837ee3872f14fe33ccf1024ea` | `konfrm-grill-docs` | `konfrm-core-*` / Bridge | `.agents/skills/konfrm-grill-docs/` | Requirements challenge, specification interrogation | `ON_DEMAND` | `LOCAL_ONLY` | Use during Bridge Grill Gate to stress-test underspecified task contracts before implementation. Do not use during code implementation. | None |
| **33** | `uizze/uizze`<br>`anti-ui-slop`<br>`4a0224f578f65a87f328e9c533b3d8bf1023c1f7` | `anti-ui-slop-wrapper` | `konfrm-design-*` | `.agents/skills/anti-ui-slop-wrapper/` | AI layout anti-patterns, missing UI states, inert buttons | `RECOMMENDED_ON_TRIGGER` (ADAPTED) | `NETWORK_OPTIONAL_EXPLICIT` | Use when reviewing component interfaces for generic AI card layouts and low contrast. Defaults to Local Core Mode (`LOCAL_ONLY`). Subordinated to DF2 Canon. Do not use for backend APIs. | `references/audit.md`<br>`references/craft.md`<br>`references/distill.md`<br>`references/polish.md` |
| **34** | `uizze/uizze`<br>`ui-radar`<br>`4a0224f578f65a87f328e9c533b3d8bf1023c1f7` | `ui-radar` | `konfrm-design-*` / Remote | `.agents/skills/ui-radar/` | Remote UI screen pattern exploration | `ON_DEMAND` | `NETWORK_REQUIRED_ON_DEMAND` | Use when exploring novel mobile screen patterns from external design database. Calls `GET https://uizze.com/api/search`. Requires explicit Founder permission. Prohibited from default runs. | None |
| **35** | `JuliusBrussee/caveman`<br>`caveman-explore`<br>`99aafe151a1be72be783e662858e8a0955add59f` | `caveman-explore` | `konfrm-core-*` / Explorer | `.agents/skills/caveman-explore/` | Fast symbol search across repository (`path:line`) | `EXPERIMENTAL / ON_DEMAND` | `LOCAL_ONLY` | Use strictly as read-only symbol hunter via isolated subagent. Normalized frontmatter (strips `model: haiku`). Do not use for code editing or dependency analysis. | None |
| **36** | `Leonxlnx/taste-skill`<br>`taste-skill`<br>`b482f7a970abb98c4108d4a9f761e458c64cefc8` | `taste-skill-wrapper` | `konfrm-design-*` / Critique | `.agents/skills/taste-skill-wrapper/` | Visual density, whitespace restraint, UI taste critique | `ON_DEMAND` | `LOCAL_ONLY` | Use when seeking aesthetic critique on layout density and typography scale. Advisory critique only; DF2 Canon supersedes. Do not use for functional logic. | None |

---

## 4. Evaluated and Excluded / Candidate Skills

| Upstream Skill Name | Repository & Upstream Path | Classification | Detailed Rationale & Governance Verdict |
| :--- | :--- | :---: | :--- |
| `flutter-improving-accessibility` | Nonexistent in `flutter/agent-plugins` | **`REMOVED`**<br>(Replaced by `INTERNAL_SKILL_CANDIDATE`) | **DOES NOT EXIST UPSTREAM.** Audited `flutter/agent-plugins` tree confirmed no such skill exists. Removed from external catalog. Future strategy: author native `konfrm-flutter-accessibility` based on `konfrm-accessibility`, official Flutter docs, and Phase 4I learnings. |
| `design-mobile-apps` (Sleek) | `designed-by-ai/skills`<br>`skills/design-mobile-apps/SKILL.md` | **`REJECT`** | Requires paid SaaS bearer token (`SLEEK_API_KEY`); targets React Native and HTML (stack mismatch with native Flutter); creates competing design authority. |
| `caveman` (Prose Compressor) | `JuliusBrussee/caveman`<br>`skills/caveman/SKILL.md` | **`REJECT`** | Output prose compression token benefits are unmeasured in KONFRM; directly conflicts with required structured verification reports and nuanced Arabic RTL analysis. |
| `loop-factory` (Full Suite) | `JuliusBrussee/Loop-Factory`<br>`.agents/skills/loop-factory/SKILL.md` | **`REJECT` (Whole)** | Introduces rogue directories (`inbox/active/archive`) that directly conflict with canonical `tasks/CURRENT_TASK.md` and `docs/CURRENT_STATE.md`. |
| `find-skills` | `vercel-labs/skills`<br>`skills/find-skills/SKILL.md` | **`DISCOVERY_ONLY_OUTSIDE_EXECUTION`** | Natural language dynamic discovery bypasses KONFRM deterministic version pinning. Prohibited during active task execution. |
| `dart-setup-ffi-assets` | `dart-lang/skills`<br>`skills/dart-setup-ffi-assets/SKILL.md` | **`REJECT`** | Out of scope. KONFRM has zero requirement for custom native C/Rust FFI asset compilation. |
| `i-have-adhd` | `ayghri/i-have-adhd`<br>`skills/i-have-adhd/SKILL.md` | **`USER_LEVEL_ONLY`** | Personal response formatting preference (action-first, numbered steps). Belongs in user client configuration (`~/.gemini/config/skills/`); never committed to repository. |

---

## 5. Protocol Concept Adaptations (Loop Factory Concepts)

| Protocol Concept | Source | Classification | Operational Rule in KONFRM |
| :--- | :--- | :---: | :--- |
| **Grill Gate** | Adapted from `Loop-Factory` | **`RECOMMENDED` (P1)** | Pre-implementation requirements interrogation on ambiguous tasks before writing code. Enforced at Bridge level. |
| **Spec Backpropagation** | Adapted from `Loop-Factory` | **`SPLIT AUTHORITY`** | **`PROPOSE_BACKPROP = AVAILABLE TO ALL`**: Execution agents surface new facts in task summaries.<br>**`AUTHORITATIVE_BACKPROP_WRITE = BRIDGE ONLY`**: Only Bridge Orchestration or authorized doc-reconciliation tasks may write updates to `CURRENT_STATE.md` or Canon docs. |
