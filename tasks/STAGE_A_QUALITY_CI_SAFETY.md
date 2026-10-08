# KONFRM Task Contract — Quality Evidence Mesh (Stage A)

TASK_ID: QUALITY_EVIDENCE_MESH_STAGE_A
TASK_CLASS: CI_SECURITY_EVIDENCE_MESH_REMEDIATION
STATUS: REMEDIATION_COMPLETE / DRAFT_PR_104_VALIDATED / READY_FOR_BRIDGE_REVIEW
PR: #104 (DRAFT — DO NOT MERGE)
BRANCH: feat/quality-ci-safety-stage-a
BASE_MAIN_SHA: dd53b5dcb1d967dfdfabfea637dad2d2bf037540
HEAD_REF: feat/quality-ci-safety-stage-a (dynamic branch HEAD)
GOVERNING_SPEC: docs/agents/KONFRM_QUALITY_EVIDENCE_MESH_PILOT.md (Stage A)

## Mission
Implement and remediate the first stage of the KONFRM Quality Evidence Mesh using `actionlint` and `zizmor` under strict zero-trust security, privacy, and repository-isolation constraints.

## Boundaries Preserved
- ZERO SECRET ACCESS: No `.env` files, credentials, API keys, tokens, or private environment variables read, printed, or exported.
- STRICT ISOLATION: Feature branch `feat/quality-ci-safety-stage-a` tracking `origin/main`.
- FORBIDDEN MUTATIONS: PR #102, PR #103, PR #99, `main`, production apps (`customer-app/`, `owner-app/`, `admin-app/`), backend logic, database/migrations, Cloudflare configuration, and business/financial Canon are untouched.
- NO DEPLOYMENT / NO AUTO-MERGE: Read-only `contents: read` token permissions in workflow; auto-merge disabled.
- NO CODEX REVIEW: Quotas preserved; zero `@codex review` calls.

## Remediation Gates (Bridge Review Iteration)
- [x] Narrowly Scoped Security Exceptions: Replace blanket file ignores in `.zizmor.yml` with line-level traceable exceptions and structured inventory.
- [x] Baseline Drift Detection: Verify that adding an unpinned action or excessive permission to an existing legacy workflow triggers immediate detection.
- [x] Isolated Negative Test Fixtures: Update `scripts/test-ci-safety.mjs` to execute in isolated OS temporary directories (`os.tmpdir()`), completely outside `.github/workflows/`.
- [x] Safe Harness Error Handling: Ensure safe cleanup in `finally` blocks, exact diagnostic matching, and harness self-verification.
- [x] CI Negative Test Execution: Wire the negative-test harness into `.github/workflows/quality-evidence-mesh.yml` using the same pinned tool binaries.
- [x] Dependency Hash Hardening: Verify `zizmor` installation integrity via immutable wheel digests or pinned constraints without uncontrolled `pip` upgrades.
- [x] Task History Preservation: Restore `tasks/CURRENT_TASK.md` to historical Phase 4I authority; maintain Stage A tracking in this dedicated document.
- [x] Full Final Validation: Actionlint clean, Zizmor clean with visible baseline, all negative tests pass, `npm run ci:safety:check` passes, `npm run ai:skills:check` passes, `npm run design:check` passes, `git diff --check` passes.
