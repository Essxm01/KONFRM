# KONFRM Task Contract — Quality Evidence Mesh (Stage B)

TASK_ID: QUALITY_EVIDENCE_MESH_STAGE_B
TASK_CLASS: DETERMINISTIC_UI_PLAYWRIGHT_PILOT
STATUS: REMEDIATION_COMPLETE / READY_FOR_BRIDGE_REVIEW
PR: #105 (Draft — DO NOT MERGE)
BRANCH: feat/quality-playwright-stage-b
BASE_MAIN_SHA: c51101c3d1bd38174e35d5338ab161031a3623dc
HEAD_SHA: eed772b5f137e0b2b1c071e7540fa114ac52cf48
GOVERNING_SPEC: docs/agents/KONFRM_QUALITY_EVIDENCE_MESH_PILOT.md (Stage B)

## Mission
Implement KONFRM's first deterministic, browser-based UI verification pilot using Playwright Test targeting the Customer Web application (`customer-app/`), under strict zero-trust security, privacy, and repository-isolation constraints.

## Boundaries Preserved
- ZERO SECRET ACCESS: No `.env` files, credentials, API keys, tokens, or private environment variables read, printed, or exported.
- STRICT ISOLATION: Feature branch `feat/quality-playwright-stage-b` and isolated worktree `KONFRM-QUALITY-PLAYWRIGHT-STAGE-B`.
- PRESERVE HISTORICAL CONTRACTS: `tasks/CURRENT_TASK.md` remains strictly untouched at historical Phase 4I state.
- FORBIDDEN MUTATIONS: PR #102, PR #103, PR #99, `main`, backend business logic, database schema/migrations, Cloudflare worker, financial Canon, and production apps are untouched.
- NO AUTO-MERGE / NO DIRECT MERGE: PR remains Draft; explicit Bridge review required.
- NO CODEX REVIEW: Quotas preserved; zero `@codex review` calls.
- CANONICAL PERSISTENCE & TRUTHFUL STATE: Playwright tests use deterministic synthetic fixtures; all external/unmocked network calls are blocked. Fail-closed error handling verified.

## Stage B Implementation Gates
- [x] Dedicated QA Workspace: Isolated package in `qa/web-playwright/` with pinned `@playwright/test` targeting Chromium.
- [x] Deterministic Test Fixtures: Synthetic search and detail fixtures with realistic Egyptian Pound (`EGP` / `ج.م`) pricing and Arabic copy.
- [x] Smoke Test 01 (Guest Discovery): Clean slate (Splash -> Welcome -> Guest Browse -> Explore), verify `konfrm_customer_entry_seen_v1` persistence, verify property cards and Arabic typography, verify returning guest bypass.
- [x] Smoke Test 02 (Property Details): Explore card selection -> canonical detail DTO interception (`/api/v1/customer/properties/:id`), verify detail precedence over summary, back navigation returning to Explore, and fail-closed handling on detail load error.
- [x] Smoke Test 03 (API Failure & Retry): Controlled search 500 error -> truthful error view & retry CTA (`إعادة المحاولة`), retry trigger restoring search results.
- [x] Multi-Viewport Mobile Matrix: Validate viewports `360 × 800`, `390 × 844`, and `430 × 932` with Arabic RTL presentation and screenshot evidence.
- [x] Negative Control Verification: Automated proof demonstrating that tampering with expected DOM or copy triggers assertion failure, confirming tests cannot pass vacuously.
- [x] GitHub Actions CI Workflow: `.github/workflows/quality-playwright-pilot.yml` with `contents: read`, pinned action SHAs, path filtering, and actionlint/zizmor compliance.
- [x] Local & Monorepo Validation: `npm run ci:safety:check`, `npm run ai:skills:check`, `npm run design:check`, and Playwright test suite passing cleanly.
- [x] Final Publication: Clean commit, branch pushed to origin, and Draft PR created with complete evidence envelope.
