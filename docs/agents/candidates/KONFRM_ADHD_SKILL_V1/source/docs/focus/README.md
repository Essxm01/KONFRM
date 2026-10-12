# KONFRM Focus Ledger — scope and truth

**CANDIDATE / NOT ACTIVE** until an independent review integration PR is merged. No claim of live authority until merged and wired.

## Structure
- `FOCUS_NOW.json`: Execution pointer distinguishing **ONE PRIMARY PRODUCT DELIVERY PRIORITY** (`active`) from **FOUNDER-AUTHORIZED PARALLEL LANES** (`authorized_parallel_lanes`). Includes `ledger_revision`.
- `IDEA_INBOX.json`: Every captured idea with assessment state. Capture != approval.
- `EXECUTION_QUEUE.json`: Explicitly queue-approved future work with fixed dependency slots. No autostart.
- `DECISION_LEDGER.jsonl`: Append-only records of decisions with provenance; defer to canonical decision authority for material product rules.
- `SESSION_HANDOFF.md`: Operational recovery snapshot, never proof of live GitHub state by itself.

## Ownership Pattern Grammar
Every declared writable surface (`exclusive_writable_surfaces`) must strictly conform to:
1. **Exact repository-relative file:** e.g. `mobile/apps/customer_app/pubspec.yaml` (no wildcards).
2. **Directory subtree ending in `/**`:** e.g. `mobile/apps/customer_app/**` (with at least one directory component before `/**`).

**Strict Rejections:**
- Path traversal (`..`, `.`), absolute paths (`/`, `\\`, `C:`).
- Unsupported glob syntax (`*` before `/**`, `?`, `[`, `]`, `{`, `}`).
- Ambiguous broad claims (`**`, root directory).
- Canonical path violations: No lane (primary or parallel) may declare surfaces encompassing canonical shared root files (`tasks/CURRENT_TASK.md`, `AGENTS.md`, `docs/INDEX.md`, `docs/CURRENT_STATE.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md`), even through parent directories.

## Concurrency & Decision Safety Protocol
- **Lock-Free Reads:** Any agent across any worktree may inspect focus files concurrently in read-only mode.
- **Single-Writer Coordination & Revision Checking:**
  - `DECISION_LEDGER.jsonl` appends require verifying the expected ledger revision against current line count.
  - If a concurrent write increments the revision, an append with stale expected revision fails closed: `CONCURRENCY_CONFLICT: ledger revision mismatch`.
  - Duplicate `event_id` is rejected.
- **Guarantees vs Procedural Recommendations:**
  - *Implemented Technical Guarantee:* Optimistic revision preconditions and duplicate-ID rejection prevent silent overwrites in deterministic execution.
  - *Procedural Recommendation:* Multi-agent execution across separate machines requires Git worktree and branch isolation. Cross-filesystem distributed locks are not claimed.
- **Audit Records:** Editable Founder authorization strings are operational audit records requiring independent evidence, not cryptographically signed certificates.

## Validation
`node scripts/check-konfrm-focus.mjs` then `node scripts/test-konfrm-focus.mjs`.

## Security
No credentials, health information, OTPs, live tenant/owner data, or private chat transcripts in this ledger.
