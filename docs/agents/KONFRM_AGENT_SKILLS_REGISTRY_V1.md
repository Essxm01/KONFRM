# KONFRM Agent Skills Registry V1
## Master Catalog, Bundle Manifests, and Network Classification Matrix

**Document Version:** 1.2.0
**Status:** DRAFT — PENDING FINAL BRIDGE APPROVAL
**Scope:** Universal Catalog of Audited Internal and External Agent Skills
**Target Repository:** `Essxm01/KONFRM`
**Governing Standard:** `docs/agents/KONFRM_AGENT_SKILLS_GOVERNANCE_V1.md`

---

## 1. Registry Architecture & Governance Standards

This registry provides the authoritative evaluation of all native KONFRM skills, active governed wrappers, and audited external candidate skills. Every external skill is evaluated as a self-contained **`KONFRM_SKILL_BUNDLE_V1`** containing root `SKILL.md` and required local references.

### Recommendation Classes
- **`MANDATORY`**: Core operational skill required for specified roles.
- **`RECOMMENDED`**: Highly valuable domain accelerator, approved for active use within its profile.
- **`ON_DEMAND`**: Specialized tool loaded strictly when explicitly requested for a targeted task.
- **`EXPERIMENTAL`**: Under evaluation; isolated testing permitted, but not authorized for production workflows.
- **`USER_LEVEL_ONLY`**: Personal prompt/pacing preference; belongs in user client settings, never in repository.
- **`DISCOVERY_ONLY_OUTSIDE_EXECUTION`**: Discovery tool permitted outside active task runs; prohibited during execution.
- **`INTERNAL_SKILL_CANDIDATE`**: Future internal skill to be authored natively; not an external vendor skill.
- **`REJECT`**: Incompatible with KONFRM architecture, unsecure, or context-wasteful. Forbidden from repository.

### Network Classification Classes
- **`LOCAL_ONLY`**: 100% self-contained local execution; zero outbound network calls, telemetry, or remote API dependencies. Default approved class.
- **`NETWORK_OPTIONAL_EXPLICIT`**: Operates completely in local core mode by default. External reference mode requires explicit Founder authorization.
- **`NETWORK_REQUIRED_ON_DEMAND`**: Network calls required for primary function. Prohibited from default runtime; on-demand use only with explicit approval.
- **`REJECT_NETWORK_PROFILE`**: Requires external SaaS bearer tokens or unconditional phone-home behavior. Banned from repository.

---

## 2. Internal Skills & Active Governed Wrappers Audit (Audited Base Check)

Every skill listed below has been verified on the base checkpoint (`9c908d2756fba0d421e67959ecfbc13d0ca35f9b`).

| # | Runtime Skill Name | Repository Path (Shim & Authoritative) | Exists? | Network Class | Status | Priority | Target Profile | Notes |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: | :--- | :--- |
| **01** | `konfrm-product-ux` | `.agents/skills/konfrm-product-ux/SKILL.md`<br>`docs/ai/skills/konfrm-product-ux/SKILL.md` | **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P0** | Mobile & Web Profiles | Enforces 3-role UX, truthful state grammar, high density. |
| **02** | `konfrm-mobile-design` | `.agents/skills/konfrm-mobile-design/SKILL.md`<br>`docs/ai/skills/konfrm-mobile-design/SKILL.md` | **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P0** | `CUSTOMER_FLUTTER`, `OWNER_FLUTTER` | Implements DF2 Mobile Foundation v1.7, component-scoped radii, 4–32 spacing scale. |
| **03** | `konfrm-rtl-arabic` | `.agents/skills/konfrm-rtl-arabic/SKILL.md`<br>`docs/ai/skills/konfrm-rtl-arabic/SKILL.md` | **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P0** | `CUSTOMER_FLUTTER`, `OWNER_FLUTTER`, `ADMIN_WEB` | Native Arabic RTL, Cairo typography, Bidi isolation, Western Arabic digits (`0-9`). |
| **04** | `konfrm-accessibility` | `.agents/skills/konfrm-accessibility/SKILL.md`<br>`docs/ai/skills/konfrm-accessibility/SKILL.md` | **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P0** | Mobile & Web, `QA_REVIEW` | WCAG 2.2 AA, screen reader semantics, text scaling. |
| **05** | `konfrm-visual-qa` | `.agents/skills/konfrm-visual-qa/SKILL.md`<br>`docs/ai/skills/konfrm-visual-qa/SKILL.md` | **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P0** | `QA_REVIEW`, Mobile Profiles | Multi-viewport physical validation, component state matrix. |
| **06** | `konfrm-design-router` | `.agents/skills/konfrm-design-router/SKILL.md`<br>`docs/ai/skills/konfrm-design-router/SKILL.md` | **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P0** | All Agents | Triage engine; activates minimal skill set per role. |
| **07** | `konfrm-design-reasoning`| `.agents/skills/konfrm-design-reasoning/SKILL.md`<br>`docs/ai/skills/konfrm-design-reasoning/SKILL.md`| **YES** | `LOCAL_ONLY` | **`RECOMMENDED`**| **P0** | Mobile & Web Profiles | Structured design dialectics (Hypotheses A/B/C) on complex UI. |
| **08** | `konfrm-design-court` | `.agents/skills/konfrm-design-court/SKILL.md`<br>`docs/ai/skills/konfrm-design-court/SKILL.md` | **YES** | `LOCAL_ONLY` | **`ON_DEMAND`** | **P0** | `BRIDGE_ORCHESTRATION` | Collaborative design adjudication panel for ambiguous decisions. |
| **09** | `frontend-design-wrapper`| `.agents/skills/frontend-design-wrapper/SKILL.md`<br>`docs/ai/skills/frontend-design-wrapper/SKILL.md`| **YES** | `LOCAL_ONLY` | **`RECOMMENDED`**| **P2** | Mobile & Web Profiles | Anti-generic layout reasoning; bound to Cairo & DF2 Canon. |
| **10** | `impeccable-wrapper` | `.agents/skills/impeccable-wrapper/SKILL.md`<br>`docs/ai/skills/impeccable-wrapper/SKILL.md` | **YES** | `LOCAL_ONLY` | **`RECOMMENDED`**| **P2** | Mobile & Web Profiles | Micro-polish, alignment audit; zero binary hook execution. |
| **11** | `emil-wrapper` | `.agents/skills/emil-wrapper/SKILL.md`<br>`docs/ai/skills/emil-wrapper/SKILL.md` | **YES** | `LOCAL_ONLY` | **`RECOMMENDED`**| **P2** | Mobile Profiles | Micro-interactions, interruptible gestures; easing heuristics are candidates. |
| **12** | `ui-ux-pro-max-wrapper` | `.agents/skills/ui-ux-pro-max-wrapper/SKILL.md`<br>`docs/ai/skills/ui-ux-pro-max-wrapper/SKILL.md`| **YES** | `LOCAL_ONLY` | **`ON_DEMAND`** | **P2** | Mobile & Web Profiles | Searchable UX guidelines; zero token mutations. |
| **13** | `vercel-web-guidelines-wrapper`| `.agents/skills/vercel-web-guidelines-wrapper/SKILL.md`<br>`docs/ai/skills/vercel-web-guidelines-wrapper/SKILL.md`| **YES** | `LOCAL_ONLY` | **`MANDATORY`** | **P1** | `ADMIN_WEB_PROFILE` | Web performance, web accessibility; strictly isolated to Admin Web. |
| **14** | `vercel-composition-wrapper`| `.agents/skills/vercel-composition-wrapper/SKILL.md`<br>`docs/ai/skills/vercel-composition-wrapper/SKILL.md`| **YES** | `LOCAL_ONLY` | **`RECOMMENDED`**| **P1** | `ADMIN_WEB_PROFILE` | React 19 compound components, flexible prop contracts. |

---

## 3. Audited External Candidate Skills Registry

| # | Upstream Skill Name | KONFRM Runtime Name | Upstream Repository & Exact Path | Verified 40-Char Commit SHA & Blob SHA | Network Class | Status | Priority | Target Profile | Primary Benefit, Risks & Required Bundled References |
| :--- | :--- | :--- | :--- | :--- | :---: | :--- | :---: | :--- | :--- |
| **15** | `systematic-debugging` | `konfrm-systematic-debugging` | `obra/superpowers`<br>`skills/systematic-debugging/SKILL.md` | Commit: `8ca22dba9a94f28898bbce59f2537ff4d87c747d`<br>Blob: `095d194ac041502905f15b01d22d294fb94db8b2` | `LOCAL_ONLY` | **`RECOMMENDED` (PILOT)** | **P1** | `QA_REVIEW`, All | **Benefit:** 4-phase root-cause analysis.<br>**Bundled References:** `root-cause-tracing.md`, `defense-in-depth.md`, `condition-based-waiting.md`.<br>**Sibling Rewrites:** Unresolved references to `test-driven-development` and `verification-before-completion` are mapped to KONFRM Quality Gates. |
| **16** | `flutter-add-widget-test` | `konfrm-flutter-widget-testing` | `flutter/agent-plugins`<br>`skills/flutter-add-widget-test/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `01ac7ac645a7f6f66603cb1c78a2a28dba3a5d32` | `LOCAL_ONLY` | **`RECOMMENDED` (PILOT)** | **P1** | Mobile, `QA_REVIEW` | **Benefit:** Widget pumping, tester finders, semantics validation.<br>**Bundle:** Root `SKILL.md` self-contained.<br>**Frontmatter:** Normalized (remove Gemini model metadata). |
| **17** | `dart-run-static-analysis` | `konfrm-dart-static-analysis` | `dart-lang/skills`<br>`skills/dart-run-static-analysis/SKILL.md` | Commit: `0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49`<br>Blob: `27ca6546684accbc8f96091d0b992f6f43a16d15` | `LOCAL_ONLY` | **`MANDATORY` (PILOT)** | **P1** | All Dart/Flutter Profiles | **Benefit:** Zero-warning `dart analyze` enforcement.<br>**Safety Rules:** Analyze is safe/read-only; `dart fix --dry-run` required; NO repo-wide `dart fix --apply`; NO repo-wide `dart format .`; NO `ignore_for_file` suppression. |
| **18** | `flutter-add-integration-test` | `konfrm-flutter-integration-test` | `flutter/agent-plugins`<br>`skills/flutter-add-integration-test/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `60902f1aa3156fa0c8e28df5448864dd5cc6c014` | `LOCAL_ONLY` | **`ON_DEMAND`** | **P1** | `QA_REVIEW`, Mobile Profiles | **Benefit:** Device/driver test automation.<br>**Safety Rule:** Classified strictly `ON_DEMAND`. Requires dedicated test entrypoint (`lib/main_test.dart`); forbids mutating production `lib/main.dart`. |
| **19** | `flutter-build-responsive-layout` | `konfrm-flutter-responsive-layout` | `flutter/agent-plugins`<br>`skills/flutter-build-responsive-layout/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `b85bfd7e82e30ac676d2140ddb436bfebd0992cb` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P1** | `CUSTOMER_FLUTTER`, `OWNER_FLUTTER` | **Benefit:** `LayoutBuilder` / `OrientationBuilder` patterns.<br>**Canon Guardrail:** Bound to phone/tablet density and DF2 spacing (`4/8/12/16/24/32`). |
| **20** | `flutter-fix-layout-issues` | `konfrm-flutter-layout-fixer` | `flutter/agent-plugins`<br>`skills/flutter-fix-layout-issues/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `3804a3c1d9fd2b88ee1ddc74716799cf2cd770c1` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P1** | Mobile Profiles, `QA_REVIEW` | **Benefit:** Systematic resolution of unbounded constraints & overflows.<br>**Canon Guardrail:** Forbids wrapping whole views in `SingleChildScrollView` blindly. |
| **21** | `flutter-apply-architecture-best-practices` | `konfrm-flutter-architecture` | `flutter/agent-plugins`<br>`skills/flutter-apply-architecture-best-practices/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `791994b12280e5734479079bd6255fa705e983c5` | `LOCAL_ONLY` | **`RECOMMENDED` (ADAPTED)** | **P1** | `CUSTOMER_FLUTTER`, `OWNER_FLUTTER` | **Benefit:** Multi-layer code separation.<br>**Adaptation Blueprint:** Strips MVVM / `ChangeNotifier`, hybrid directories, and offline mutation queues. Enforces Feature-First, Riverpod without codegen, manual DTOs, and fail-closed error handling. |
| **22** | `flutter-setup-declarative-routing` | `konfrm-flutter-routing` | `flutter/agent-plugins`<br>`skills/flutter-setup-declarative-routing/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `272031181bc8d8598c934a14b1d12cf08c7aa1bc` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P1** | Mobile Profiles | **Benefit:** `go_router` route trees and parameter guards.<br>**Guardrail:** Concrete deep-link URL schemes deferred. |
| **23** | `flutter-setup-localization` | `konfrm-flutter-localization` | `flutter/agent-plugins`<br>`skills/flutter-setup-localization/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `d3dd4596da225df783e1816c658125206566902b` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P1** | Mobile Profiles | **Benefit:** `AppLocalizations` and ARB standardization.<br>**Canon Guardrail:** Enforces Western Arabic numerals (`0-9`) default and Egyptian currency formatting. |
| **24** | `flutter-use-http-package` | `konfrm-flutter-http` | `flutter/agent-plugins`<br>`skills/flutter-use-http-package/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `bb60468d6448259b1708a2c34a01f43e77529437` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P1** | Mobile Profiles, Backend | **Benefit:** Clean `package:http` client with timeouts.<br>**Guardrail:** Enforces fail-closed handling; Dio deferred. |
| **25** | `flutter-add-widget-preview` | `konfrm-flutter-widget-preview` | `flutter/agent-plugins`<br>`skills/flutter-add-widget-preview/SKILL.md` | Commit: `0ef3972f93e2baa4156ba1cbb1e515cd53079c68`<br>Blob: `6ba68942e4b535b3459acb34071185c3dfaa0fb1` | `LOCAL_ONLY` | **`ON_DEMAND`** | **P2** | Mobile Profiles | **Benefit:** Component preview harnesses.<br>**Guardrail:** Preview code isolated strictly to `test/`. |
| **26** | `dart-add-unit-test` | `konfrm-dart-unit-test` | `dart-lang/skills`<br>`skills/dart-add-unit-test/SKILL.md` | Commit: `0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49`<br>Blob: `a4921a529000ddbfa6c98360dbc0b68f11fc4d4a` | `LOCAL_ONLY` | **`MANDATORY`** | **P1** | All Profiles | **Benefit:** Fast, deterministic pure Dart unit tests.<br>**Bundle:** Self-contained `SKILL.md`. |
| **27** | `dart-collect-coverage` | `konfrm-dart-coverage` | `dart-lang/skills`<br>`skills/dart-collect-coverage/SKILL.md` | Commit: `0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49`<br>Blob: `60dad77533dc0a98b7f4a8363ac1b56d589d353a` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P1** | `QA_REVIEW` | **Benefit:** Automated LCOV coverage collection and audit.<br>**Guardrail:** Assertion rigor over mere coverage chasing. |
| **28** | `dart-build-cli-app` | `konfrm-dart-cli` | `dart-lang/skills`<br>`skills/dart-build-cli-app/SKILL.md` | Commit: `0d9f1c4a0ae29d6f5180bf6143d7997ec3bacf49`<br>Blob: `c888b42c94118e953a48f82bdf6a8a5eba025b52` | `LOCAL_ONLY` | **`ON_DEMAND`** | **P3** | Tooling / Infrastructure | **Benefit:** Offline tooling and pilot harnesses.<br>**Guardrail:** Zero CLI dependencies inside application packages. |
| **29** | `tdd` | `konfrm-tdd` | `mattpocock/skills`<br>`skills/engineering/tdd/SKILL.md` | Commit: `f3fc5632f401156837ee3872f14fe33ccf1024ea`<br>Blob: `01eadaa34e7c9a63a67d6dc3cce1cc81b0e49985` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P2** | All Development Profiles | **Benefit:** Red-green-refactor discipline.<br>**Bundled References:** `tests.md`, `mocking.md`.<br>**Founder Policy:** Do NOT interrupt Founder when seam is established. Escalate only if seam alters architecture, business rules, or public API. |
| **30** | `code-review` | `konfrm-code-review` | `mattpocock/skills`<br>`skills/engineering/code-review/SKILL.md` | Commit: `f3fc5632f401156837ee3872f14fe33ccf1024ea`<br>Blob: `373a4f26e6cfa3617778397945bb069d9cb184bc` | `LOCAL_ONLY` | **`RECOMMENDED`** | **P2** | `QA_REVIEW`, `BRIDGE_ORCHESTRATION` | **Benefit:** Structured code review along Standards and Spec axes.<br>**Guardrail:** Derives fixed points directly from mission contracts. Findings are advisory. |
| **31** | `codebase-design` | `konfrm-codebase-design` | `mattpocock/skills`<br>`skills/engineering/codebase-design/SKILL.md` | Commit: `f3fc5632f401156837ee3872f14fe33ccf1024ea`<br>Blob: `3f63c8146dd2604b419c929e9876b90c30d410e9` | `LOCAL_ONLY` | **`ON_DEMAND`** | **P2** | Architecture / Lead | **Benefit:** Cohesion and coupling evaluation.<br>**Guardrail:** Advisory only; defers to KONFRM Canon. |
| **32** | `grill-with-docs` | `konfrm-grill-docs` | `mattpocock/skills`<br>`skills/engineering/grill-with-docs/SKILL.md` | Commit: `f3fc5632f401156837ee3872f14fe33ccf1024ea`<br>Blob: `62b9efb6f991d1b229adee7506962f13ced0c499` | `LOCAL_ONLY` | **`ON_DEMAND`** | **P2** | `BRIDGE_ORCHESTRATION` | **Benefit:** Requirements challenge.<br>**Guardrail:** Integrated into Bridge Grill Gate protocol. |
| **33** | `anti-ui-slop` | `anti-ui-slop-wrapper` | `uizze/uizze`<br>`skills/anti-ui-slop/SKILL.md` | Commit: `4a0224f578f65a87f328e9c533b3d8bf1023c1f7`<br>Blob: `81761062c1e482ddc7ea30e4f4e250ef67b73c0e` | `NETWORK_OPTIONAL_EXPLICIT` | **`RECOMMENDED` (ADAPTED)** | **P2** | Mobile & Web Profiles | **Benefit:** Catches generic AI card layouts, low contrast, weak states.<br>**Split Architecture:** Defaults to **Local Core Mode** (`LOCAL_ONLY`). Remote reference mode requires explicit Founder approval.<br>**Bundled References:** `reference/audit.md`, `craft.md`, `distill.md`, `polish.md`.<br>**Canon Guardrails:** Subordinated strictly to DF2 Canon. |
| **34** | `ui-radar` | `ui-radar` | `uizze/uizze`<br>`skills/ui-radar/SKILL.md` | Commit: `4a0224f578f65a87f328e9c533b3d8bf1023c1f7`<br>Blob: `77de69c7ad9db38331b52d59d47b2ad15f215357` | `NETWORK_REQUIRED_ON_DEMAND` | **`ON_DEMAND`** | **P3** | Mobile Profiles, Design | **Benefit:** Queries UI patterns from 800k screen database.<br>**Network Reality:** Calls `GET https://uizze.com/api/search?...`. Requires explicit network permission and Founder approval for on-demand use. |
| **35** | `caveman-explore` | `caveman-explore` | `JuliusBrussee/caveman`<br>`skills/caveman-explore/SKILL.md` | Commit: `99aafe151a1be72be783e662858e8a0955add59f`<br>Blob: `5bc2aa79833d34c411b5680ed0e7c60496982426` | `LOCAL_ONLY` | **`EXPERIMENTAL / ON_DEMAND`** | **P3** | All Profiles (Subagent only) | **Benefit:** Read-only AST symbol and line hunter (`path:line`).<br>**Frontmatter:** Normalized (strips `model: haiku`).<br>**Guardrail:** Must remain strictly read-only and invoked only via isolated subagent. Full adoption deferred pending pilot evidence. |
| **36** | `design-taste-frontend` | `taste-skill-wrapper` | `Leonxlnx/taste-skill`<br>`skills/taste-skill/SKILL.md` | Commit: `b482f7a970abb98c4108d4a9f761e458c64cefc8`<br>Blob: `b72132fcd466da605623ffe96e370b3991fc5285` | `LOCAL_ONLY` | **`ON_DEMAND`** | **P3** | Mobile & Web Profiles | **Benefit:** Visual critique, layout density review.<br>**Guardrail:** Class: `DESIGN_REFERENCE`. Advisory critique only; DF2 Canon supersedes. |

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
| `i-have-adhd` | `ayghri/i-have-adhd`<br>`skills/i-have-adhd/SKILL.md` | **`USER_LEVEL_ONLY`** | Personal response formatting preference (action-first, numbered steps). Belongs in user client configuration; never committed to repository. |

---

## 5. Protocol Concept Adaptations (Loop Factory Concepts)

| Protocol Concept | Source | Classification | Operational Rule in KONFRM |
| :--- | :--- | :---: | :--- |
| **Grill Gate** | Adapted from `Loop-Factory` | **`RECOMMENDED` (P1)** | Pre-implementation requirements interrogation on ambiguous tasks before writing code. Enforced at Bridge level. |
| **Spec Backpropagation** | Adapted from `Loop-Factory` | **`SPLIT AUTHORITY`** | **`PROPOSE_BACKPROP = AVAILABLE TO ALL`**: Execution agents surface new facts in task summaries.<br>**`AUTHORITATIVE_BACKPROP_WRITE = BRIDGE ONLY`**: Only Bridge Orchestration or authorized doc-reconciliation tasks may write updates to `CURRENT_STATE.md` or Canon docs. |
