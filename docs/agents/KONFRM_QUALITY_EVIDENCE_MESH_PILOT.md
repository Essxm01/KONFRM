# KONFRM Quality Evidence Mesh — Pilot Contract

Status: PROPOSED / DRAFT — NOT ENABLED. Founder review required before implementation or merge.
Baseline: origin/main `dd53b5dcb1d967dfdfabfea637dad2d2bf037540`.
Purpose: add independent, trustworthy PR verification without changing existing product or financial rules.

## Non-negotiable authority and isolation

- Preserve `KONFRM_MASTER_RULES.md`, `KONFRM_QUALITY_GATES.md`, `KONFRM_UI_QA_PROTOCOL.md`, current Canon, `.agents/SKILL_ROUTER.md`, `konfrm-quality`, and the fixed PHASE 0–22 roadmap. This document is not a source of product truth.
- PR #102 (Product Brain), PR #99 (frozen), main, production applications, Cloudflare, Supabase, and any live environments are OUT OF SCOPE for this draft.
- One writer at a time. The approved implementation must use isolated branches and independent PRs, and never auto-merge or run `@codex review`.
- Never change a failing assertion, skip a test, or weaken a gate merely to make CI green. Unknown, skipped and blocked are separate from PASS.
- No real payments, no real KYC images, no genuine personal data, no production admin credentials. Use isolated test accounts, synthetic fixtures and sandbox database/services with explicit authorization.

## Candidate tool decisions (not yet installations)

| Candidate | Intended boundary | Gate strategy | Prerequisite |
| --- | --- | --- | --- |
| Playwright Test | React Customer / Owner / Admin web journeys | Deterministic targeted smoke first | Verify local/isolated server, canonical fixture reset and cross-role authorization |
| actionlint | GitHub Actions syntax and expressions | Cheap deterministic PR check | Pin binary/release digest; non-privileged execution |
| zizmor | GitHub Actions security audit | Non-blocking pilot; promote after triage | Pin release and risk-reviewed rules; explicit minimal token permissions |
| StrykerJS | JS/TS mutation adequacy on selected unit-test modules | Scheduled/manual, not every PR | Select true independent test oracles, performance budget and mutator boundaries |
| Superpowers skill concepts | Agent workflow discipline (systematic debugging, TDD, verification before completion) | Review-only integration into `konfrm-quality`; no blind installer | Inspect original instructions, licenses, side effects and contradictions with KONFRM Canon |
| Maestro | Mobile external black-box Android/iOS flows | Defer to separate mobile QA pilot | Confirm build artifacts, deterministic device reset and runner costs |
| Patrol | Flutter-specific device/system integrations | Evaluate as alternative/complement to Maestro, not automatic dual install | Flutter native app/toolchain availability, supported framework version, license |
| TesterArmy/e2e | Optional agentic exploratory testing, not core gate | Defer | Compare incremental coverage/cost with Playwright; model budget and sandbox |

## Stage boundaries

### Stage A — repo/CI safety baseline (first implementation PR)

1. Inventory active workflows, triggers, token permission scopes, required checks, fork PR handling, deployment events, installed tests and CI minutes.
2. Add `actionlint` and `zizmor` using immutable pinned versions or digests and minimal `contents: read` where applicable; scan the actual workflow files.
3. Categorize existing findings as true issues, approved exceptions or irrelevant findings. Fix only verified in-scope workflow issues, without modifying deployment rules, protected branches, secrets, or branch rulesets.
4. Demonstrate a known bad workflow fixture fails each relevant scanner; restore fixture. Preserve CI evidence in artifact/job summary.
5. No privileged `pull_request_target` execution of untrusted code and no secret exposure on PRs.

### Stage B — web journey pilot (separate PR)

1. Use Playwright Test with pinned dependencies in a dedicated QA package/directory, not a blanket monorepo dependency upgrade.
2. Stand up a non-production isolated customer web target with controlled data. Add three deterministic smoke cases: guest discovery, navigation into published property details, and truthful API failure/retry representation. Assert server truth and appropriate role boundaries.
3. Verify Arabic RTL at 360×800, 390×844, 430×932; then Owner/Admin target pilots at applicable desktop widths when appropriate.
4. Record visible assertions, screenshots/trace on failure and JUnit. Prove at least one injected UI defect fails before promotion.
5. Gate PRs only for relevant changes with controlled coverage and reliable fixtures. A skipped or setup-blocked test cannot make a false green.

### Stage C — mutation adequacy (separate PR)

Run StrykerJS only for a small, stable, pure JS/TS contract module with independent oracles and clean test runs. Track killed/survived mutants, uncovered logic and resource budget. Do not apply text mutation success as proof of product semantics. Avoid mutation of financial Canon.

### Stage D — agent skills refinement (separate PR)

Study existing `konfrm-quality`, `konfrm-product`, `konfrm-design`, Agent router/manifest and approved skills governance first. Port narrowly useful verification, debugging and TDD principles from external skills as original KONFRM-specific instructions. Do not copy entire third-party skill bundles or run automatic installers that overwrite `.agents/`, `.claude/`, MCP settings or local execution hooks. Check precedence and agent invocation by a concrete task rehearsal.

### Stage E — native mobile QA (deferred)

Confirm real Flutter mobile app readiness and supported build targets. Evaluate Maestro versus Patrol based on platform features, accessibility/RTL, device reset, CI runner limitations and actual scenarios. Use emulators/simulators, NOT the Founder's personal phone; do not toggle TalkBack or device-level settings on personal devices. Restore emulator state after each test.

### Stage F — cost-controlled intelligent exploration (optional)

Choose one limited opt-in external agentic evaluator with explicit model-call and spend budgets, no Codex quota dependence, no production secrets, audited transcripts and evidence-backed repro tests. Do not run a model-backed reviewer per commit.

## Evidence contract for each PR

- Exact base/HEAD SHA, full changed-file list and scope diff.
- Tool/version/license provenance, isolated installation path, actionable roll-back.
- Test inventory with total selected/started/passed/failed/skipped/blocked/flaky; selected-but-not-run is NOT PASS.
- Copy of test commands, CI job IDs, results and representative negative controls that demonstrate real failure detection.
- Role-specific accessibility/RTL/UI/UX and canonical data-state evidence where touched.
- Secret permission posture, deployment side effects, known unknowns, cost/runtime.
- Explicit Bridge/Founder approval before merge. Green CI alone is insufficient.

## Promotion criteria

Pilot -> required check only after successful repeatable runs on at least two independent commits, one deliberate defect detection, no false-green from skips or missing fixtures, and acceptable cost. Existing required checks remain untouched until separately approved.

## Planned external sources to recheck at implementation time

- Playwright: https://playwright.dev/docs/intro
- actionlint: https://github.com/rhysd/actionlint
- zizmor: https://github.com/zizmorcore/zizmor
- StrykerJS: https://stryker-mutator.io/docs/stryker-js/introduction/
- Superpowers: https://github.com/obra/superpowers
- Maestro: https://docs.maestro.dev/
- Patrol: https://patrol.leancode.co/
- TesterArmy/e2e: https://github.com/tester-army/e2e

This is a scope and acceptance contract only. It deliberately adds no dependency, executable workflow or production change.
