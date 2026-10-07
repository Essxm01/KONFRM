# KONFRM Engineering Intelligence — Pilot Provenance & Upstream Audit V1

```yaml
DOCUMENT_TYPE: AUDIT_PROVENANCE_MANIFEST
STATUS: AUDITED_AND_PINNED
GOVERNING_SYSTEM: KONFRM Engineering Intelligence Pilot V1
RUNTIME_HOT_PATH_EXCLUDED: TRUE
```

---

## 1. PURPOSE & BOUNDARIES

This document records the exact provenance, upstream commit baselines, adopted concepts, rejected concepts, and license classifications for all external knowledge distilled into the Pilot V1 runtime brains (`konfrm-flutter` and `konfrm-quality`).

In accordance with the Minimal Sufficient Runtime Context principle, this provenance record lives outside the agent runtime execution hot path. Coding agents load operational procedures from `.agents/skills/` without incurring the context overhead of auditing histories.

---

## 2. AUDITED UPSTREAM SOURCES MATRIX

### 2.1 Official Flutter & Dart Documentation
- **Upstream Anchor:** Official Flutter SDK & Dart Language Guides (Dart 3.x / Flutter 3.x)
- **License:** BSD-3-Clause
- **Network Behavior:** Fully local; offline SDK documentation.
- **Concepts Adopted:**
  - `AsyncValue` fail-closed rendering pattern.
  - Riverpod provider scopes and container overriding in test harnesses.
  - `EdgeInsetsDirectional` and start/end layout semantics for RTL.
  - `Semantics` widget annotations (`button: true`, `label`, `hint`).
  - Surface-specific static analysis execution (`flutter analyze`, `dart analyze`).
- **Concepts Rejected:**
  - `ChangeNotifier` and mutable global provider singletons.
  - Deep hierarchical Clean Architecture with mandatory Use Case classes per endpoint.
- **KONFRM Adaptation:** Distilled into `konfrm-flutter` (`architecture.md`, `widgets_and_layout.md`).

---

### 2.2 Official Android Skills (`android/skills`)
- **Upstream Anchor:** GitHub `android/skills` @ Commit `42dc2270e96032bd860bb94511e440aa00a43125`
- **License:** Apache-2.0
- **Network Behavior:** Fully offline; static repository inspection.
- **Concepts Adopted:**
  - System window insets handling and Edge-to-Edge display on Android 15+ (API 35+).
  - Least-privilege photo and media selection (preferring system picker over broad permissions).
  - ProGuard/R8 bytecode shrinking distinctions (JVM bytecode vs Dart code).
  - 16 KB memory page size ELF alignment verification requirement.
- **Concepts Rejected:**
  - Jetpack Compose `@Composable` functions, remember/mutableStateOf state management.
  - Compose Modifier layout rules and Hilt dependency injection.
- **KONFRM Adaptation:** Extracted platform-level constraints into `konfrm-flutter` (`navigation_and_native.md`, `performance_and_testing_seams.md`).

---

### 2.3 OWASP Mobile Application Security (MASVS v2.0 / MASTG)
- **Upstream Anchor:** OWASP Mobile Application Security Verification Standard v2.0
- **License:** Creative Commons Attribution-ShareAlike 4.0 International
- **Network Behavior:** Fully offline specification.
- **Concepts Adopted:**
  - MASVS-STORAGE: Sensitive credentials restricted to platform-protected keystores (Android KeyStore, iOS Keychain); plaintext SharedPreferences forbidden.
  - MASVS-NETWORK: Enforced HTTPS/TLS, cleartext traffic disabled, zero certificate verification bypass.
  - MASVS-PLATFORM: Deep link parameter validation in navigation route guards.
- **Concepts Rejected:**
  - Universal exhaustive MASVS audit on routine non-sensitive UI tasks.
  - Generic refresh token rotation where it conflicts with accepted Auth Canon.
- **KONFRM Adaptation:** Distilled into `konfrm-quality` as a risk-triggered verification baseline (`security_and_accessibility_verification.md`).

---

### 2.4 Obra Systematic Debugging & TDD Methodologies
- **Upstream Anchor:** Upstream Systematic Debugging & Engineering Methodology
- **License:** Permissive / Open Source
- **Network Behavior:** Fully offline methodology.
- **Concepts Adopted:**
  - 4-Phase Root Cause Analysis: Reproduce -> Isolate -> Root-Cause -> Verify without regression.
  - Smallest Credible Oracle principle: Reproduce with the cheapest, most deterministic oracle available.
  - Dual-Axis Code Review: Evaluating changes across Specification fidelity and Standards compliance.
- **Concepts Rejected:**
  - Test Dogma: Forcing an artificial failing unit test when the defect is an OS window insets or physical screen reader bug.
- **KONFRM Adaptation:** Distilled into `konfrm-quality` (`debugging_and_rca.md`, `static_analysis_and_review.md`).

---

### 2.5 Phase 4I Physical Android Runtime Validation Lessons
- **Internal Anchor:** PR #100 Samsung Galaxy A56 5G Physical Validation Evidence
- **Status:** Internal Project Reality
- **Concepts Adopted:**
  - Action button semantics: Ordinary icon action buttons (`IconButton`, `IconActionButton`) must have selected-state capability completely ABSENT (`hasSelectedState = false`). Never accept `isSelected == false` as acceptance criteria; selected capability is reserved strictly for genuine toggles (`hasSelectedState: true`, `isSelected: true | false`).
  - Duplicate semantics: Semantic wrappers must not wrap already semantic widgets with duplicate labels.
  - Physical reality: Passing local unit/widget tests does not equal physical runtime device verification.
  - Multi-platform isolation: Android TalkBack passes do not equal iOS VoiceOver compliance.
- **KONFRM Adaptation:** Codified as hard invariants in both `konfrm-flutter` and `konfrm-quality`.

---

### 2.6 Antigravity-Native Routing Architecture & Provenance (Phase A)
- **Official Host Reference:** Antigravity Customization System (`agy-customizations` and `docs/rules.md`).
- **Rule Convention:** Official hierarchical directory rules path `.agents/rules/*.md` discovered by walking up from the current directory to repository root.
- **Delivery Architecture:**
  - Codex Host: Directly consumes root `AGENTS.md` Mandatory Universal Core instruction pointing to `.agents/SKILL_ROUTER.md`.
  - Antigravity Host: Automatically discovers persistent workspace rule `.agents/rules/konfrm-skill-routing.md` pointing to `.agents/SKILL_ROUTER.md`.
  - Shared Single Truth: `.agents/SKILL_ROUTER.md` remains the sole routing intelligence file; zero Router, Canon, or Business Rule duplication in host entry points.
- **Discovery Taxonomy & Classification:**
  - `CODEX_DETERMINISTIC_ROUTING_PASS`: Verified via deterministic pointer in `AGENTS.md` and narrowed legacy frontmatter exclusions.
  - `ANTIGRAVITY_NATIVE_ROUTING_ARCHITECTURE_PASS`: Verified via native `.agents/rules/konfrm-skill-routing.md` rule existence, valid target path, zero duplicate Canon, and passing automated policy validator.
  - `ANTIGRAVITY_LIVE_DISCOVERY_PENDING_PUBLICATION`: Because Antigravity host runtime scans the active workspace root (`KONFRM-CANONICAL`) and branch `chore/agent-skills-governance-v1` remains in an isolated development worktree awaiting bridge review, live auto-discovery into host session prompts is pending merge/publication. No false pass is claimed.

---

### 2.7 Consolidated Design Runtime Brain Provenance (`konfrm-design` Phase B)
- **Primary Runtime Brain:** `.agents/skills/konfrm-design/SKILL.md` (with lazy companion references).
- **Consolidated Internal Sources:**
  - `docs/ai/skills/konfrm-mobile-design/`: DF2 v1.4 visual foundations, monochrome identity, geometric radii, relational spacing.
  - `docs/ai/skills/konfrm-rtl-arabic/`: Arabic-first UX, directional semantics, Western digits default, canonical currency formatting (`1,600 ج.م`), Bidi data run isolation.
  - `docs/ai/skills/konfrm-accessibility/`: Contrast frameworks (WCAG 2.2 AA for Web, display readability for Mobile), non-color-only communication, touch target hit regions, Arabic screen reader semantics (`hasSelectedState = false` on action controls), text scaling resilience, reduced motion.
  - `docs/ai/skills/konfrm-visual-qa/`: Optical inspection checklists, initial candidate viewport matrix (360×800, 390×844, 430×932, 1440×900).
  - `docs/ai/skills/konfrm-design-reasoning/`: Structured design dialectic loop (`OBSERVE` -> `HYPOTHESIZE` -> `ARGUE` -> `RESEARCH` -> `ROLE LENS` -> `BRAND` -> `A11Y` -> `DECISION`), research claim hygiene.
  - `docs/ai/skills/konfrm-design-court/`: Governed design adjudication escalation (`FAST_PANEL` / `FULL_COURT` modes, Hard Gates, consensus classification).
  - `docs/ai/skills/konfrm-product-ux/`: Presentation slice — role mental models (Customer discovery clarity, Owner operational certainty, Admin audit throughput), truthful state grammar (Error is never Empty, no phantom progress, optimistic UI bounds).
  - External wrappers (`frontend-design-wrapper`, `impeccable-wrapper`, `emil-wrapper`, `ui-ux-pro-max-wrapper`, `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`): Anti-generic visual hierarchy, purposeful motion without transactional delay, craftsmanship critiques.
- **Concepts Subordinated & Rejected:**
  - Rejected: Blind "mirror everything" doctrine; mechanical transposition of Web CSS-pixel thresholds into native mobile dp; universal 4-state dogma on every component; generic AI dashboard aesthetics (card soup, floating glow containers, arbitrary pills); unsubstantiated lab psychology extrapolations.
- **Disposition of Legacy Artifacts:**
  - Preserved in `docs/ai/skills/` for provenance and policy validator contract tests.
  - Narrowed frontmatter exclusions prevent discovery collisions in agent runtimes.
  - Registered as future retirement targets once Stage F full system freeze occurs.
