# Priority + Dependency Planner (guidance, not algorithmic product authority)

## Order of decision, never reverse
1. Immutable hard gates: security, legal, privacy, financial/product Canon, Founder-decision authority, live incident containment, R2→R5 before Phase 8.
2. Hard prerequisites and shared-file/PR worktree collision risks.
3. Current work closeability: will finishing NOW unlock work or prevent redo?
4. Value: measurable product trust, user journey completion, defect-risk reduction, release criticality.
5. Execution cost: research, review, scope, regression, switching overhead, dependency churn.
6. Founder intent / confidence / reversible experimentation.

## Transparent scoring for ASSESSMENT only
Use 0–5 with evidence for `impact`, `critical_path`, `risk_reduction`, `urgency_evidence`, `effort`, `switch_cost`, `uncertainty`.

`candidate_score = 4*critical_path + 3*impact + 3*risk_reduction + 2*urgency_evidence - 2*effort - 3*switch_cost - 2*uncertainty`

- Mandatory gates decide first, numerical score only helps rank eligible work within a comparable phase.
- Never interpret made-up score as certainty. Unknown -> explicitly unknown + do not auto-promote.
- P0: verified security/data integrity incident -> immediate containment proposal, escalate to founder with evidence. P1: critical-path blocker or material regression. P2: high-value approved improvement after dependencies. P3: polish/optional. This is an internal coordination label, NOT product severity without QA proof.
- A high score cannot bypass `Founder_Approval`, external deadlines, branch protection, or canonical policies.

## Phase slot references
Use existing Phase 0–22 plan (`خطة عمل التطبيق.txt`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md`) rather than rewriting it.
- `CURRENT_TASK`: continue only the verified existing current task.
- `AFTER_PR_105`: after Stage B is safely reconciled, not a command to merge.
- `FOUNDATION_GOVERNANCE`: security/skills/CI/documentation work with a bounded dependency.
- `PHASE_5_GUEST_UX`: Customer/Guest experience, role-specific phase.
- `PHASE_6_HOST_UX`: Owner/Host experience.
- `PHASE_7_ADMIN_UX`: Admin Dashboard experience.
- `POST_PHASE_7_R2_R5`: approved deferred debts, ordered R2 then R3 then R4 then R5, required before Phase 8.
- `PHASE_8_PLUS`: later operational E2E/payment/chat/release only after applicable gates.
- `UNPLACED`: needs authority/dependency discovery; do not invent a phase assignment.

## Group for efficiency
Group ideas when they touch one screen family, shared component contract, testing oracle, backend endpoint or approval meeting. **But do not merge unrelated requirements or increase blast radius**. Prefer low-risk foundational work that prevents rebuilding a screen twice, if the current task is safe to pause. Show expected saved work, not invented hours.

## Re-evaluate when
NOW completes; a previously unknown blocker appears; PR status changes; a security incident is verified; a Founder changes a decision; milestone reached. Do not reshuffle the queue every message or create urgency from novelty.
