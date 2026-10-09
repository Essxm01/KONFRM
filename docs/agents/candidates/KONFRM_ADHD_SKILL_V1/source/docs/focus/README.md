# KONFRM Focus Ledger — scope and truth

**CANDIDATE / NOT ACTIVE** until an independent review integration PR is merged. No claim of live authority until merged and wired.

## Structure
- `FOCUS_NOW.json`: Execution pointer distinguishing **ONE PRIMARY PRODUCT DELIVERY PRIORITY** (`active`) from **FOUNDER-AUTHORIZED PARALLEL LANES** (`authorized_parallel_lanes`).
- `IDEA_INBOX.json`: Every captured idea with assessment state. Capture != approval.
- `EXECUTION_QUEUE.json`: Explicitly queue-approved future work with fixed dependency slots. No autostart.
- `DECISION_LEDGER.jsonl`: Append-only approvals/authorizations with provenance; defer to canonical decision authority for material product rules.
- `SESSION_HANDOFF.md`: Operational recovery snapshot, never proof of live GitHub state by itself.

## Multi-Agent Parallel Execution Policy
1. **One Primary Product Priority:** Single active product delivery focus (currently Phase 5 / Mission 02 Customer Flutter discovery).
2. **Founder-Authorized Parallel Lanes:** Parallel work requires explicit Founder authorization (`authority`, `date`, `evidence`).
3. **One Active Task Per Agent & Worktree:** No agent or worktree may hold multiple active tasks simultaneously.
4. **Disjoint Writable Boundaries:** Every lane declares `exclusive_writable_surfaces`. Overlapping writable surfaces fail validation immediately.
5. **Canonical Protection:** Parallel lanes may NEVER declare writable surfaces matching canonical shared root files (`tasks/CURRENT_TASK.md`, `AGENTS.md`, `docs/INDEX.md`, `docs/CURRENT_STATE.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md`).
6. **Concurrent Reads vs Writes:**
   - **Read:** Lock-free, read-only inspection by any agent across worktrees.
   - **Write:** Localized to declared lane surfaces. Ledger updates are append-only with unique event IDs.
7. **Founder Authority & Lane Switching:** Founder retains sole authority to approve, pause, stop, or reprioritize work. Switching the primary priority requires documenting a preserved handoff so prior progress is never lost.

## Validation
`node scripts/check-konfrm-focus.mjs` then `node scripts/test-konfrm-focus.mjs`.

## Security
No credentials, health information, OTPs, live tenant/owner data, or private chat transcripts in this ledger.
