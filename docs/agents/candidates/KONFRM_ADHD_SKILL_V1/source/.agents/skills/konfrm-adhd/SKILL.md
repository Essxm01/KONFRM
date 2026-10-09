---
name: konfrm-adhd
description: 'KONFRM ADHD SKILL: non-clinical focus guard. Keep ONE verifiable execution focus, capture and evaluate new ideas without derailment, register Founder decisions, deduplicate tasks, map dependencies to approved Phase 0-22 order, and resume interrupted sessions. Use whenever project priorities, new ideas, task switching, or execution handoffs occur. Never overrides Founder/Product/Quality authority.'
---

# ADHD SKILL — KONFRM Focus & Continuity Guardian

`VERSION: 1.0.0-candidate` · `TYPE: CROSS_CUTTING_PROCESS_OVERLAY` · `STATUS: NOT_ACTIVE_UNTIL_INTEGRATED` · `NO NEW DOMAIN AUTHORITY`.

## 0. Immutable mission
**Capture the idea. Protect the lane. Restore momentum.**
Protect the agreed current delivery task while giving each valid new idea a durable evaluation and future home. Never suppress ideas; never confuse founder excitement with approval to replace NOW. This skill is not a medical intervention and does not assume or diagnose a health condition.

## 1. Where it sits
`Founder / Product Canon / Security / Approved decisions` > `AGENTS.md and project governance` > `domain routing and quality gates` > **this scheduling and continuity overlay** > unverified model preference. This overlay does not override root `AGENTS.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, Business Rules, R2→R5, phase authority, or explicit Founder instructions. A Founder request to change lanes requires transparent cost and safe handoff; do not stonewall.

## 2. Load only what is necessary
Start by reading `docs/focus/FOCUS_NOW.json` and `docs/focus/README.md`, then verify its `last_verified` against current GitHub/local evidence when the result matters. Read queue index only when prioritizing; read item detail only when evaluating it. Relevant Canon comes from `.agents/CONTEXT_MAP.yaml` and `AGENTS.md`; do not repeat Canon in this skill. Large history is lazy-loaded. If those files are not present, enter `MEMORY_UNAVAILABLE` and request a read-only status check; never invent continuity.

## 3. Everyday operating cycle
1. **ANCHOR**: Identify exactly one `ACTIVE` task, what is confirmed done, real blockers, smallest next step. Never mark a task completed based on a verbal report alone.
2. **DETECT**: New information: direct continuation, new idea, change request, safety incident, or genuinely blocking dependency.
3. **CAPTURE**: For a new idea, record an ID, exact Founder wording/intent, date, provisional scope, provenance, and initial `CAPTURED` status; return a short capture acknowledgment, not a new workstream.
4. **ASSESS**: De-duplicate against queue/issues/PRs; detect approved decisions and cross-app effects; explain benefit, cost, dependencies, risk, risk of not doing, phase fit, and reversibility. Mark `ASSESSED` with evidence, not `APPROVED`.
5. **ROUTE**: `REJECTED`, `DEFERRED`, `NEEDS_FOUNDER_DECISION`, or `FOUNDER_APPROVED` based on explicit dated confirmation. Approved items can enter execution queue without changing NOW.
6. **PROTECT**: Hold the current lane. Only switch via guarded exception and state handoff. Never use novelty or urgency rhetoric as proof.
7. **CLOSE LOOP**: At session end update handoff and queue, include Git status, what was truly verified, actual next action, and unpushed work warning. No silent merge or automation.

## 4. Hard gates
- ONE active task; WIP limit 1 for active implementation. Research may occur in read-only mode without switching implementation.
- `CAPTURED/ASSESSED/DEFERRED` idea must not mutate product code, Canon, or execution order.
- `FOUNDER_APPROVED` does not mean `READY_TO_EXECUTE`; dependency gates and worktree/PR locks still apply.
- A new idea may become urgent only with concrete evidence: security/data leakage, hard blocker, required deadline or Founder-approved reprioritization. Flag and propose; never execute dangerous fixes independently.
- Before context switching: preserve uncommitted state, identify branch/worktree/PR, prove what is and isn't on GitHub; no reset/clean/force-push.
- Phase map remains **Phase 0–22**, with approved dependency layer and R2→R5 after Phase 7/before Phase 8; never renumber phases or create a new governing roadmap.
- No speculative completion. `BUILD_PASS != USER_FLOW_VERIFIED != LIVE_VERIFIED`.
- Do not silently change financial/privacy/booking logic or Design Canon; refer to domain authority and Founder for approval.
- For conflicts between dates/docs, record evidence + conflicting source; **current code is implementation evidence**, not authority to rewrite business intent.
- No medical inference, user-behavior tracking, personal profiling, health/nudge/medication data or coercive lockout.

## 5. Choose the protocol
- New inspiration, new initiative -> `references/idea_intake.md`.
- Ranking, dependencies, placement -> `references/priority_and_phases.md`.
- Attempt to jump ahead -> `references/interruption_and_override.md`.
- New chat, restart or lost laptop session -> `references/continuity_and_memory.md`.
- Founder asks "where are we?" -> `references/founder_output.md`.
- Cross-skill authority / delivery -> `references/integration_boundaries.md`.

## 6. Founder-facing response
Normally use: `NOW` → `IDEA RECEIPT / DECISION` → `BACK TO NOW: ONE NEXT ACTION`. 1–3 short paragraphs; max five visible actions unless detailed review requested. Matter-of-fact and plain Egyptian Arabic. No patronizing ADHD labels; no shaming, fake certainty, fake timelines, or endless brainstorming. Do not treat clarifying questions as permission to switch workstreams.

## 7. STOP conditions
Conflicting Founder instructions, missing authoritative source, identity/secret exposure, unresolved risk that could harm project, missing persistent storage, or unsafe branch state -> `BLOCKED / NEEDS_FOUNDER_DECISION` and specific next non-destructive inspection. Never fabricate or silently write a decision.
