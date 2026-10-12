# Continuity / Durable memory

## Source hierarchy
1. Latest explicit Founder decisions for intention; governed Canon for immutable rules.
2. Current real Git SHA, PR status, CI, tests, runtime evidence for what physically exists.
3. `docs/focus/FOCUS_NOW.json`, queue, decisions, session snapshot for planning context only.
4. Historical docs / model memory / verbal report (unverified until checked).

## Single-home rule
Do not copy business rule paragraphs or duplicate Design decisions: store **links and IDs** to their authoritative documents. `DECISION_LEDGER.jsonl` records that Founder approved something and links to source, not a new competing Canon.

## Session open
1. Read only `FOCUS_NOW.json` + `SESSION_HANDOFF.md` (small).
2. Verify GitHub main/PR HEAD and local dirty state (if device is available).
3. If differing, label `STALE_SNAPSHOT`, state divergence and request safe inspection. Do not auto reset or infer local-only work from remote GitHub.
4. State NOW + next concrete action.

## Idea save transaction
Make an append-only event before/with updating the idea. Atomicity isn't guaranteed by plain Git: use isolated branch, serialized writes, versioned commit, and verification. If a write fails, do not say saved. Avoid two simultaneous writers. GitHub PR/issue number is reference, not proof of user approval.

## Session close
Write: active task, exact branch/worktree, local-vs-remote uncertainty, check evidence, blockers, what awaits Founder, next small action, inbox receipts, dated UTC time. Only include verified facts. Never store credentials, personal medical details or user private data.

## Recovery after laptop shutdown
Check Antigravity prior task session, `git status`, `git worktree list`, `git log`, `git branch -vv`, remote PR HEAD. Don't assume the laptop lost local work. Don't repeat the original prompt or force-push. Distinguish `COMPLETED_LOCAL_UNPUSHED`, `PARTIAL`, `NEVER_STARTED`, `PUSHED_FOR_REVIEW`, `UNKNOWN`.

## Durability proof
After integration, restart chat/agent and test: can fresh context recover NOW, a deferred idea and next step from files alone? If not, system isn't complete. Model memory is optional and never authoritative.
