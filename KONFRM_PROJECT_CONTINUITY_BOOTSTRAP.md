# KONFRM — Project Continuity Bootstrap

**Purpose:** Durable recovery entry point for a new ChatGPT account, new AI agent, new session, context reset, developer handoff, or machine recovery.
**Authority:** Routing/continuity document only. It does not replace product, business, architecture, database, design, security, or roadmap authorities.
**Founder continuity principle:** GitHub/repository state must be sufficient to recover the project without relying on remembered chat history.

---

# 1. First Rule

Do not trust model memory, an old conversation summary, a stale local workspace, or an unverified branch as the current project state.

Recover from the repository.

The correct recovery hierarchy is:

1. Git branch / commit reality.
2. Latest explicit Founder decision recorded in repository authorities.
3. Current-state and active-task documents.
4. Governing product/business/architecture/design authorities.
5. Verified implementation/live evidence.
6. Historical material only as evidence, never automatic authority.

---

# 2. Mandatory Fresh-Session Recovery Sequence

On a new account/session, read in this order before proposing or modifying anything:

1. AGENTS.md
2. docs/INDEX.md
3. docs/CURRENT_STATE.md
4. tasks/CURRENT_TASK.md
5. docs/codex/KONFRM_MASTER_RULES.md
6. KONFRM_EXECUTION_DEPENDENCY_ORDER.md
7. docs/CONTEXT_ROUTER.md
8. The selective domain authorities required by the active task.

For Founder-style collaboration or a strategic restart, also read:

- KONFRM_MASTER_PROJECT_CONTEXT.md
- docs/codex/KONFRM_FOUNDER_OPERATING_CONTEXT.md
- docs/codex/KONFRM_FOUNDER_OPERATING_PROFILE.md
- docs/codex/KONFRM_FOUNDER_DEEP_OPERATING_PROFILE.md
- docs/codex/KONFRM_DECISION_CONFLICTS.md
- docs/codex/KONFRM_CURRENT_REALITY.md
- docs/codex/KONFRM_COMPLETION_MATRIX.md
- docs/codex/KONFRM_QUALITY_GATES.md

For UI/UX work, additionally route through DESIGN_SYSTEM/ and docs/codex/KONFRM_UI_QA_PROTOCOL.md.

Do not load every repository document into context at once. Follow docs/CONTEXT_ROUTER.md.

---

# 3. Recovery Prompt for Any New AI Account

Use this prompt after connecting the repository:

> You are resuming the KONFRM project from repository truth, not from memory. Do not modify anything yet. Read AGENTS.md, docs/INDEX.md, docs/CURRENT_STATE.md, tasks/CURRENT_TASK.md, docs/codex/KONFRM_MASTER_RULES.md, KONFRM_EXECUTION_DEPENDENCY_ORDER.md, and docs/CONTEXT_ROUTER.md. Establish current branch/HEAD, origin/main, open PRs, current task status, active macro phase, unresolved Founder decisions, and applicable authorities. Then load only the domain files needed for the active task. Treat historical React mobile code as behavior/UX evidence where applicable, not Flutter implementation authority. Preserve Business Rules, finance rules, architecture boundaries and Design governance. Report the recovered reality and proposed next action before any mutation.

---

# 4. Fixed Strategic Model

The original PHASE 0–22 roadmap remains the macro Product/Delivery Roadmap.

Execution is dependency-driven, not a blind waterfall.

The permanent model is:

PHASE IDs define product organization and history.

Dependencies define actual task execution order.

Later-phase work may be pulled forward only when it is a proven prerequisite, and only in the minimum required subset.

A future phase is never silently declared complete because one prerequisite was pulled forward.

Canonical macro execution authority:

- KONFRM_EXECUTION_DEPENDENCY_ORDER.md

Original roadmap source:

- خطة عمل التطبيق.txt

---

# 5. Flutter Transition Model

The Customer and Owner future mobile applications target Flutter/Dart.

Admin remains Web.

The Flutter transition is not a restart.

Preserve:

- product truth;
- Business Rules;
- backend/API contracts;
- Supabase schema/migrations;
- Auth/session architecture;
- state lifecycles;
- approved UX flows/copy;
- Design System decisions;
- historical implementation evidence.

React Customer/Owner implementations remain behavioral/UX/regression evidence, but are not future Flutter component/visual authority and must not be mechanically ported.

---

# 6. Strategic Snapshot — 2026-10-04

This is a dated recovery snapshot, not a substitute for current Git evidence.

- Latest durable main baseline at snapshot creation: e98c47fda65c938ebd0af745534c150a1a94428e.
- PR #86 merged: Controlled Primitive Pilot 01.
- Pilot 01 status: CLOSED / MERGED.
- Founder-selected provisional Primary Button direction: 6px radius + Stable Black Primary.
- Cairo is Founder-selected as the primary KONFRM UI font-family direction.
- Exact mobile typography sizes/weights/line-heights/native scaling remain under validation and are not yet final mobile Canon.
- Active macro program: PHASE 4 — Unified Mobile Design System.
- Immediate dependency at snapshot time: Cairo Typography Foundation evidence integrity and Founder selection.

If later repository state conflicts with this snapshot, the fresher repository state wins.

---

# 7. PHASE 4 Internal Order

Do not invent a new design task merely because a new visual question appears.

Approved internal order:

4A Foundation / Brand / Role / RTL / Design Governance
→ 4B Typography Foundation
→ 4C Action System
→ 4D Form & Selection Primitives
→ 4E Structural System
→ 4F Navigation & Overlay System
→ 4G Product States & Content Presentation
→ 4H Component Contract / Reference Catalog
→ 4I Minimal Native Flutter Validation Gate

Only after Phase 4 foundation is sufficiently stable should Phase 5/6 Flutter implementation expand aggressively.

---

# 8. High-Level Execution Path After Phase 4

Preferred dependency path:

PHASE 5 — Customer Flutter UX + implementation
PHASE 6 — Owner Flutter UX + implementation
PHASE 7 — Admin Web UX refinement
PHASE 8 — Booking Cross-App integration
PHASE 9 — Notifications
PHASE 10 — Payment
PHASE 11 — Wallet / Payout
PHASE 12 — Chat
PHASE 13 — Cancellation / Disputes / Reviews
PHASE 14 — Full Security & Privacy consolidation
PHASE 18 — Realistic Marketplace Dataset
PHASE 17 — Full Edge / Failure Matrix
PHASE 15 — Final Visual Consistency Audit
PHASE 16 — Final Role UX Audit
PHASE 19 — End-to-End Scenarios
PHASE 20 — Final Live Revision Verification
PHASE 21 — Demo Polish
PHASE 22 — Product Blueprint / Handoff

This is execution precedence, not phase renumbering.

---

# 9. Surprise-Task Gate

Every new Founder question, AI suggestion or discovered issue must be classified before it interrupts the critical path:

- Blocking Dependency
- Architecture / Product Conflict
- Useful but Non-Blocking
- Future Feature
- Nice-to-Have / Curiosity

Permanent rule:

**A new question is not automatically a new task.**

Before pulling work forward, answer:

- What does it block now?
- What happens if deferred?
- What rework does it prevent?
- What rework can it create?
- Which macro phase owns the full capability?
- What minimum subset is actually required now?

---

# 10. Founder Decision Interface

Present decisions in the form best suited to the decision:

- Visual/UI/Typography/Motion: mobile visuals, interactive HTML, side-by-side states.
- UX flow/navigation: journeys, state transitions, clickable or visual flows.
- Business rules: plain-language scenarios and consequences.
- Financial logic: numeric examples, edge cases and invariants.
- Architecture: options, dependency impact, reversibility and migration cost.
- Security/privacy: risk, impact, containment and recovery.
- Admin operations: realistic queue/decision scenarios.
- Legal/provider/production payments: authoritative external facts plus explicit Founder decision where required.

Do not ask the Founder to make a visual decision from abstract technical numbers when visual evidence can be produced.

---

# 11. Agent Routing

Default execution roles:

- Antigravity: implementation-heavy repository/runtime/backend/network/security/GitHub/Supabase/Cloudflare/deploy writer.
- Codex: architecture/platform/accessibility/dependency correctness and independent read-only review.
- Z Code: structured documentation/specification and design-governance review when useful.

Risk-adjust review depth:

- Low-risk docs/metadata: writer + direct verification.
- Medium-risk architecture/package/design-system structure: writer + specialist review.
- High-risk Auth/Payments/DB/business rules/migrations/security/production deploy: writer + two independent reviewers where practical.

Green CI/build alone is never proof of real completion.

---

# 12. Product/Business Guardrails That Must Never Be Invented

Agents must not autonomously change product truth, financial logic or unresolved policy.

Examples of protected truths include:

- Booking is a REQUEST, not instant booking.
- PENDING_OWNER_APPROVAL does not block availability.
- APPROVED_PENDING_PAYMENT and CONFIRMED block availability.
- Payment happens only after Owner approval.
- Deposit equals actual first-night price.
- KONFRM commission is 20% of deposit only.
- Owner net deposit is 80% of deposit.
- Remaining balance equals total minus deposit.
- No commission on remaining balance.
- Customer never sees internal commission/Owner split.
- Remaining-balance method remains unresolved unless a later explicit Founder decision changes it.
- Full renter cancellation/refund matrix remains unresolved unless explicitly decided.
- Owner phone is not exposed; communication is in-app.
- Financial state is server-authoritative.

Always verify current BUSINESS_RULES authority before implementation; this list is a recovery safety net, not a replacement.

---

# 13. Closure Discipline

No task is closed merely because code exists or CI is green.

Use the project loop:

Reality
→ Root cause / dependency
→ Scope
→ Execute
→ Test
→ Self-fix
→ Retest
→ Independent review proportional to risk
→ Runtime / visual / live verification where applicable
→ Founder acceptance where required
→ Durable repository update
→ Closed

---

# 14. What Must Be Updated for Future Continuity

Do not continually rewrite this bootstrap for ordinary task movement.

Update this file only when the recovery model or strategic snapshot materially changes.

Use:

- docs/CURRENT_STATE.md for overall current reality;
- tasks/CURRENT_TASK.md for the one active execution contract;
- KONFRM_EXECUTION_DEPENDENCY_ORDER.md for macro sequencing and permanent dependency rules;
- docs/DECISIONS.md for durable decisions/rationale;
- docs/codex/KONFRM_DECISION_CONFLICTS.md for unresolved/superseded conflicts;
- DESIGN_SYSTEM/ for design authority;
- Git history/PRs for implementation evidence.

---

# 15. Emergency Recovery Checklist

If the Founder loses the current chat/account/machine:

1. Open the GitHub repository Essxm01/KONFRM.
2. Start from main unless a verified active branch/task says otherwise.
3. Give the new AI the Recovery Prompt in section 3.
4. Require it to report branch/HEAD, origin/main, open PRs and current task before edits.
5. Require it to state what is Canon, provisional, open or historical.
6. Do not allow it to infer missing Business Rules from old UI code.
7. Resume the active dependency, not whichever file looks newest.
8. If any authority conflicts, log/review the conflict instead of silently choosing.

With this procedure, a new account should be able to reconstruct the project from repository truth without relying on transferred model memory.
