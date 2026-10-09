# Integration & authority boundaries

## Skills routing
This is an always-available, lightweight **cross-cutting process overlay**, NOT an eighth domain brain.
- `konfrm-product`: Owns product interpretation, business invariants, and Canon semantics (active in main per PR #102 and #109).
- `konfrm-quality`: Owns defect diagnosis, 4-phase RCA, test selection, and verification evidence.
- `konfrm-flutter`: Owns native Flutter implementation for Customer and Owner applications.
- `konfrm-design`: Owns UX reasoning, visual hierarchy, DF2 design-system tokens, and RTL semantics.

ADHD SKILL never writes application code, invents product rules, or makes domain verdicts.

## Multi-agent parallel execution & concurrency protocol
The Founder has authorized a bounded multi-agent model (Codex on Product Flutter, Antigravity on Process/Tooling, Bridge on Governance/Review). To maintain focus invariants under concurrency:

1. **Lock-Free Reads:** Any agent across any worktree may inspect `docs/focus/` state files concurrently without taking locks.
2. **Disjoint Writable Ownership:** Every active lane must declare `exclusive_writable_surfaces`. No two active lanes may share or overlap writable surfaces. Overlapping claims are rejected by `check-konfrm-focus.mjs`.
3. **Canonical Shared Protection:** Parallel lanes may NEVER claim or mutate canonical shared root files (`tasks/CURRENT_TASK.md`, `AGENTS.md`, `docs/INDEX.md`, `docs/CURRENT_STATE.md`, `.agents/SKILL_ROUTER.md`, `.agents/SKILL_MANIFEST.yaml`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md`).
4. **Append-Only Decision Stream:** Concurrent updates to `DECISION_LEDGER.jsonl` must use globally unique IDs (`DEC-YYYYMMDD-NNN`) and reference explicit Founder authority.
5. **Safe Handoff on Priority Switch:** Side tasks cannot unilaterally replace the primary product priority. Switching the primary priority requires Founder approval and a documented handoff preserving prior state.

## Safe activation proposal
Do NOT edit live `AGENTS.md`, `.agents/SKILL_MANIFEST.yaml`, `.agents/SKILL_ROUTER.md`, or `.agents/CONTEXT_MAP.yaml` without a separate isolated integration PR after Bridge review and explicit Founder approval. Once approved, add only a concise discoverability link and process-overlay registration; preserve existing active domain brain counts. Trigger on `new idea`, `prioritization`, `lane coordination`, `resume`, `roadmap placement`, `Founder handoff` rather than every code-edit event.

## External references
- ayghri/i-have-adhd: action-first, suppress tangents, persistent session presentation (MIT).
- jdpolasky/chief-of-staff-2: portable visible Markdown memory, one source per fact, short router, minimal machinery (MIT).
- UditAkhourii/adhd: divergent options only at high-stakes choices, never daily capture default (MIT).
- adrianwedd/ADHDo: selective context and non-intrusive notification inspiration; NO health monitoring or copying unrelated systems.
- mrseth01/awesome-adhd and XargsUK/awesome-adhd: resource lists only; do not import clinical content or third-party dependencies.
All text in this skill is independently authored for KONFRM. Verify source license and provenance before reusing any third-party code or assets.
