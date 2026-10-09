---
name: konfrm-adhd
description: 'KONFRM ADHD SKILL: non-clinical focus guardian. Protects ONE primary product delivery priority, manages Founder-authorized parallel execution lanes with strict disjoint surfaces and ownership grammar, captures and evaluates new ideas without derailment, registers Founder decisions with optimistic revision checks, deduplicates tasks, maps dependencies to approved Phase 0-22 order, and resumes interrupted sessions. Use whenever project priorities, new ideas, parallel lanes, task switching, or execution handoffs occur. Never overrides Founder/Product/Quality authority.'
---

# ADHD SKILL — KONFRM Focus & Continuity Guardian

`VERSION: 1.1.0-candidate` · `TYPE: CROSS_CUTTING_PROCESS_OVERLAY` · `STATUS: NOT_ACTIVE_UNTIL_INTEGRATED` · `NO NEW DOMAIN AUTHORITY`.

## 0. Immutable mission
**Capture the idea. Protect the lane. Restore momentum.**
Protect the agreed primary product delivery priority while managing Founder-authorized parallel execution lanes. Give each valid new idea a durable evaluation and future home. Never suppress ideas; never confuse founder excitement with approval to replace NOW. This skill is not a medical intervention and does not assume or diagnose a health condition.

## 1. Where it sits
`Founder / Product Canon / Security / Approved decisions` > `AGENTS.md and project governance` > `domain routing and quality gates` > **this scheduling and continuity overlay** > unverified model preference.

This overlay does not override root `AGENTS.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, Business Rules, R2→R5, phase authority, or explicit Founder instructions. Domain authorities are established:
- `konfrm-product`: Authoritative product soul and Canon semantics (active in main per PR #102 & #109).
- `konfrm-quality`: Authoritative verification, defect RCA, and evidence gates.
- `konfrm-flutter`: Authoritative Flutter mobile implementation.
- `konfrm-design`: Authoritative design presentation, RTL, and tokens.
ADHD SKILL is a **cross-cutting process overlay**, NOT an eighth domain brain.

## 2. Load only what is necessary
Start by reading `docs/focus/FOCUS_NOW.json` and `docs/focus/README.md`, then verify `last_known_remote_head` against current GitHub/local evidence when the result matters. Read queue index only when prioritizing; read item detail only when evaluating it. Large history is lazy-loaded. Concurrent agents may read focus state in lock-free read-only mode. If files are missing, enter `MEMORY_UNAVAILABLE` and request a read-only status check; never invent continuity.

## 3. Everyday operating cycle
1. **ANCHOR**: Identify the ONE primary product delivery priority, any authorized parallel lanes, confirmed progress, real blockers, and smallest next steps.
2. **DETECT**: New information: direct continuation, new idea, change request, safety incident, or genuinely blocking dependency.
3. **CAPTURE**: For a new idea, record an ID, exact Founder wording/intent, date, provisional scope, provenance, and initial `CAPTURED` status; return a short capture acknowledgment, not a new workstream.
4. **ASSESS**: De-duplicate against queue/issues/PRs; detect approved decisions and cross-app effects; explain benefit, cost, dependencies, risk, phase fit, and reversibility. Mark `ASSESSED` with evidence, not `APPROVED`.
5. **ROUTE**: `REJECTED`, `DEFERRED`, `NEEDS_FOUNDER_DECISION`, or `FOUNDER_APPROVED` based on explicit dated confirmation. Approved items can enter execution queue without changing NOW.
6. **PROTECT**: Hold the primary lane. Parallel lanes require explicit Founder authorization, strict ownership grammar compliance, and disjoint worktrees.
7. **CLOSE LOOP**: At session end update handoff and queue, include Git status, what was truly verified, actual next action, and unpushed work warning. No silent merge or automation.

## 4. Hard gates
- **ONE primary product delivery priority:** Single active product task at any given time.
- **Founder-authorized parallel execution lanes:** Parallel lanes permitted ONLY with explicit Founder authorization (`authority`, `date`, `evidence`). Editable authorization strings are operational audit records requiring independent evidence, not cryptographically authenticated tokens.
- **One active task per agent & worktree:** No agent or worktree may hold multiple active assignments.
- **Strict ownership pattern grammar:** Declared surfaces must be exact files or `/**` subtrees. Path traversal, unsupported wildcards, absolute paths, and broad claims (`**`) are rejected.
- **Canonical protection:** No lane (primary or parallel) may claim protected canonical shared root files (`tasks/CURRENT_TASK.md`, `AGENTS.md`, etc.), directly or through parent directories.
- **Finished PRs cannot be active:** Merged PRs cannot be tracked as active work.
- **Lock-free read / single-writer revision check:** Concurrent agents inspect focus state without locks; decision writes require verifying expected ledger revision to prevent silent overwriting.
- **Founder retains full authority:** Founder alone approves, pauses, or switches lanes. Switching primary priority requires documenting a preserved handoff.
- **Phase order:** Phase map remains **Phase 0–22**, with R2→R5 after Phase 7/before Phase 8.
- **No medical inference:** No health data, user tracking, profiling, or coercive lockouts.

## 5. Choose the protocol
- New inspiration, new initiative -> `references/idea_intake.md`.
- Ranking, dependencies, placement -> `references/priority_and_phases.md`.
- Attempt to jump ahead / lane switch -> `references/interruption_and_override.md`.
- New chat, restart or lost laptop session -> `references/continuity_and_memory.md`.
- Founder asks "where are we?" -> `references/founder_output.md`.
- Cross-skill authority / delivery -> `references/integration_boundaries.md`.

## 6. Founder-facing response
Normally use: `NOW` → `IDEA RECEIPT / DECISION` → `BACK TO NOW: ONE NEXT ACTION`. 1–3 short paragraphs; max five visible actions unless detailed review requested. Matter-of-fact and plain Egyptian Arabic. No patronizing ADHD labels; no shaming, fake certainty, fake timelines, or endless brainstorming. Do not treat clarifying questions as permission to switch workstreams.

## 7. STOP conditions
Conflicting Founder instructions, missing authoritative source, identity/secret exposure, unresolved risk that could harm project, missing persistent storage, or unsafe branch state -> `BLOCKED / NEEDS_FOUNDER_DECISION` and specific next non-destructive inspection. Never fabricate or silently write a decision.
