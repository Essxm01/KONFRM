# KONFRM ADHD SKILL — Focus & Continuity Governance (Candidate v1.1)

**Status:** IMPLEMENTATION PACKAGE — NOT INSTALLED / NOT CANON / NOT MERGED. Hardened 2026-10-09.
**Mission:** Protect KONFRM execution continuity while never losing a Founder idea.
**Scope:** Project focus, capture, prioritization, phase placement, deduplication, parallel lane governance, and verifiable continuation. Not diagnosis, medical care, surveillance, or arbitrary executive authority.

## Contents
- `.agents/skills/konfrm-adhd/SKILL.md`: concise operating router — user-visible name **ADHD SKILL**.
- `.agents/skills/konfrm-adhd/references/`: on-demand decision, interruption, queue, memory, handoff, reporting protocols.
- `docs/focus/FOCUS_NOW.json`: single active primary product delivery priority and Founder-authorized parallel lanes.
- `docs/focus/IDEA_INBOX.json`: recorded ideas + assessments + provenance.
- `docs/focus/EXECUTION_QUEUE.json`: separately approved/scheduled work, NO automatic promotion.
- `docs/focus/DECISION_LEDGER.jsonl`: append-only references to decisions (does not replace product Canon).
- `docs/focus/SESSION_HANDOFF.md`: recovery snapshot, never evidence by itself.
- `scripts/check-konfrm-focus.mjs`: deterministic invariant validation with parallel lane and file-ownership checks.
- `scripts/test-konfrm-focus.mjs`: comprehensive negative controls validating WIP limits, disjoint ownership, and priority preservation.
- `BEHAVIOR_ACCEPTANCE.md`: 19-scenario human/agent acceptance matrix.
- `INSTALLATION_PROTOCOL.md`: safe Antigravity draft PR integration instructions.

## The Multi-Agent Contract
1. **ONE Primary Product Priority:** Single active product delivery focus (currently Phase 5 / Mission 02 Customer Flutter discovery).
2. **Founder-Authorized Parallel Lanes:** Secondary lanes permitted ONLY with explicit Founder authorization.
3. **Disjoint Writable Boundaries:** Strict non-overlapping file ownership across lanes.
4. **Canonical Protection:** Parallel lanes may NEVER modify shared canonical root files (`tasks/CURRENT_TASK.md`, `AGENTS.md`, etc.).
5. **Lock-Free Reads:** All agents inspect focus state without locks; writes are strictly confined to assigned surfaces.
6. **Founder Control:** Founder alone approves, pauses, or switches lanes. Priority changes preserve prior state via documented handoff.

## Governance Alignment
ADHD SKILL is a **cross-cutting process overlay**, NOT an eighth domain brain. Domain authorities remain:
- `konfrm-product`: product soul and Canon semantics (active in main).
- `konfrm-quality`: verification and defect RCA.
- `konfrm-flutter`: Flutter application client.
- `konfrm-design`: design system and presentation.

## Validation
`node scripts/check-konfrm-focus.mjs`, `node scripts/test-konfrm-focus.mjs`, and `node scripts/pilot-konfrm-focus.mjs`.
