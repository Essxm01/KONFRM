# Integration protocol — for Antigravity (Candidate v1.1)

**PACKAGE STATUS: CANDIDATE / DRAFT**, not installed in live runtime. Never auto-install into `main`.

## Prerequisites
- Verified `origin/main` baseline (post-PR #110 merge, SHA: `5c97ab19ed6da3b1a6ecddf7dbf129c059c86811`).
- PR #106 remains strictly in DRAFT / HOLD during candidate hardening.
- Primary product delivery priority (Phase 5 / Mission 02 Customer Flutter discovery) remains protected and unmodified.

## Multi-Agent Parallel Execution Governance
1. Any future integration must maintain **ONE PRIMARY PRODUCT DELIVERY PRIORITY** alongside **FOUNDER-AUTHORIZED PARALLEL LANES**.
2. Writable surfaces must remain strictly disjoint: each lane declares `exclusive_writable_surfaces`.
3. Parallel lanes are forbidden from modifying canonical shared root files (`tasks/CURRENT_TASK.md`, `AGENTS.md`, `docs/INDEX.md`, etc.).
4. Focus state reads are lock-free across agents. Focus ledger writes are append-only with globally unique IDs.

## Staged Integration Steps (Post-Candidate Approval)
1. Following Bridge review and explicit Founder approval, create an isolated integration branch from verified `origin/main`.
2. Inspect root governance authorities: `AGENTS.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, `docs/CURRENT_STATE.md`, `tasks/CURRENT_TASK.md`, `docs/codex/KONFRM_MASTER_RULES.md`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md`. Confirm current status; never perform wholesale overwrite.
3. Stage files from candidate package into their canonical paths (`.agents/skills/konfrm-adhd/`, `docs/focus/`, `scripts/`).
4. Validate deterministic checks: `node scripts/check-konfrm-focus.mjs` and `node scripts/test-konfrm-focus.mjs`.
5. Register as `CROSS_CUTTING_PROCESS_OVERLAY` in router/manifest documentation. Do NOT register as an eighth domain brain. Preserve established authorities:
   - `konfrm-product`: product soul and Canon semantics (active).
   - `konfrm-quality`: verification and defect RCA.
   - `konfrm-flutter`: Flutter application client.
   - `konfrm-design`: design system and presentation.
6. Verify against the 19 behavioral acceptance scenarios in `BEHAVIOR_ACCEPTANCE.md`.
7. Submit an isolated PR for Bridge review; merge requires explicit Founder decision.
