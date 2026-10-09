# KONFRM Focus Ledger — scope and truth

**CANDIDATE / NOT ACTIVE** until a reviewed integration PR is merged. No claim of durable memory until this ledger has been merged and wired to the skill.

- `FOCUS_NOW.json` is an execution pointer; exactly 1 `ACTIVE` item; NOT a second `tasks/CURRENT_TASK.md` authority.
- `IDEA_INBOX.json` contains every captured relevant idea with assessment state. Never equate capture and approval.
- `EXECUTION_QUEUE.json` contains explicitly queue-approved future work with fixed dependency slots. No autostart.
- `DECISION_LEDGER.jsonl` is append-only approvals/rejections with provenance; defer to canonical decision authority for material rules.
- `SESSION_HANDOFF.md` is an operational note, not proof of GitHub/runtime state.
- Each accepted idea has exactly one home, with references by ID in other files.

**One active implementation task.** Exception: read-only analysis that does not change another branch or distract from NOW. Collisions require pause and Founder approval.

**Verification:** `node scripts/check-konfrm-focus.mjs` then `node scripts/test-konfrm-focus.mjs`.

**Security:** no credentials, health information, OTPs, live tenant/owner data, Figma access keys or raw private chat transcripts in this ledger.

**Update order:** append decision/event with evidence -> update idea status -> if approved for queue update queue -> if founder approved execution transition update FOCUS_NOW after safe handoff. In case of partial write, flag mismatch; never silently proceed.
