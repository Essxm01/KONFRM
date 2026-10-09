# Integration protocol — for Antigravity after current PR #105 safely reconciled

**PACKAGE STATUS: CANDIDATE**, not yet part of GitHub or active runtime. Never auto-install into `main`.

1. First preserve PR #105 local state. Only after reconciliation create isolated worktree/branch from verified `origin/main`: `feat/konfrm-focus-guardian-v1`.
2. Read root `AGENTS.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, `.agents/CONTEXT_MAP.yaml`, `docs/CURRENT_STATE.md`, `tasks/CURRENT_TASK.md`, `docs/codex/KONFRM_MASTER_RULES.md`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md` and relevant founder operating rules. Confirm current status. Never merge these files by wholesale replacement.
3. Copy only the files from this package, preserve existing files, validate all JSON and scripts. Run `node scripts/check-konfrm-focus.mjs` and `node scripts/test-konfrm-focus.mjs`.
4. Add a **thin routing pointer** in `AGENTS.md`/existing Router/Manifest consistent with existing schema and test constraints. Register as `PROCESS_OVERLAY` not eighth domain Brain; no new conflicting authority or automatic invocation in unrelated code tasks. Use on-demand read and project-state updates. Do not create new model memory store.
5. Optionally add `focus:check` and `focus:test` to root `package.json` in the isolated PR only if safe; update existing skills check tests to validate registration without falsely counting overlay as active domain brain.
6. Perform a read-only audit of existing current tasks and newest decisions before refreshing bootstrap snapshot. Do not copy stale historical SHA as live truth. No new backlog priority without Founder approval.
7. Verify negative control tests, original `ai:skills:check`, `ci:safety:check`, `design:check`, `git diff --check` and relevant CI. Open separate DRAFT PR only; no merge, no Codex review, no Secrets, no production code or database modifications.
8. Demonstrate 5 acceptance scenarios: incoming novelty idea stays out of NOW; duplicate idea de-duplicated; high-priority safety issue escalates with evidence (no auto-exec); power-loss recovery detects local-vs-remote unknown; Founder-approved queue item remains blocked by prerequisite until satisfied.
9. Bridge reviews real HEAD, CI and the scope; Founder approves merging separately.

This package intentionally does not edit repository `main` or existing PR worktrees.
