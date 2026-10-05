# KONFRM Agent Execution & Routing Policy

**Status:** ACTIVE OPERATING POLICY  
**Scope:** AI-agent task routing, execution ownership, verification discipline, resource/quota management, Founder-assisted manual intervention, and inter-agent handoff.  
**Authority:** Latest explicit Founder decision overrides this document. This policy does not override product, business, financial, security, database, architecture, or Design System Canon.

---

## 1. Purpose

KONFRM uses multiple AI agents with different strengths, access levels, execution costs, and context/token constraints.

The objective is not to make every agent do the same work. The objective is to route each task to the agent best suited to it while preserving:

- correctness,
- clear ownership,
- resource efficiency,
- independent verification,
- runtime evidence,
- low duplication,
- safe Founder escalation.

The default orchestration model is:

`Bridge → assign owner → execute → verify → self-correct → re-verify → accept/reject → integrate`.

A green build, successful command, or agent self-declaration is never sufficient by itself when stronger evidence is required.

---

## 2. Active Execution Team

### Bridge

Bridge is the orchestration and acceptance layer.

Bridge owns:

- understanding current project reality before assigning work,
- task decomposition,
- authority and dependency resolution,
- ownership boundaries,
- product/business/finance/architecture protection,
- prompt construction,
- review of agent reports,
- independent source/Git/runtime verification,
- acceptance or rejection,
- merge governance,
- Founder translation.

Bridge should not delegate product or architecture decisions merely because an implementation agent can technically make them.

### Antigravity

Antigravity is the default **high-volume execution and integration agent**.

Prefer Antigravity for:

- long-running execution,
- environment/toolchain work,
- Flutter/Android runtime,
- Android Studio / SDK / AVD / emulator work,
- integration,
- repeated command execution,
- broad but bounded file inspection,
- build/test loops,
- screenshots and runtime evidence,
- Git integration operations,
- deployment,
- Supabase / Cloudflare / infrastructure tasks,
- local machine investigation,
- multi-step verification,
- work requiring stronger direct access/control of the project environment.

When Antigravity can perform routine or execution-heavy work safely at comparable quality, prefer it over spending scarce Codex quota.

### Codex

Codex is a **scarce specialist reasoning resource**.

Codex has tighter practical token/quota constraints and should not be consumed on long repetitive execution when Antigravity can do that work.

Prefer Codex for bounded tasks where reasoning density matters more than execution volume, including:

- difficult code reasoning,
- architecture/API/component design,
- subtle logical defects,
- complex Flutter/Dart component behavior,
- non-obvious refactoring,
- hard test design,
- RTL/Bidi edge cases,
- accessibility reasoning,
- code-review findings requiring engineering judgment,
- ambiguous implementation trade-offs,
- difficult root-cause analysis,
- targeted design-system engineering.

Codex must still be used actively where its specialist reasoning adds material value. Resource conservation does **not** mean excluding Codex from the project.

### Z Code

Z Code is currently unavailable and removed from the active execution model.

Do not:

- assign tasks to Z Code,
- create interfaces solely for Z Code,
- preserve unnecessary workflows that depend on Z Code.

Do not introduce a replacement third execution agent unless a real project need justifies it.

---

## 3. Resource-Aware Routing Rule

Use the following default decision:

### Route to Antigravity first when the task is execution-heavy

Examples:

- many commands,
- repeated tests,
- environment diagnostics,
- large verification passes,
- runtime/device work,
- Git/integration,
- broad mechanical changes,
- deployment,
- screenshots,
- long-running local operations.

### Route to Codex first when the task is reasoning-heavy

Examples:

- subtle bug diagnosis,
- component contract design,
- difficult state logic,
- architecture boundary decisions,
- complex refactoring,
- test strategy,
- code correctness questions requiring deep judgment.

### Split a mixed task

Do not give Codex a large execution-heavy task merely because it can technically complete it.

For a mixed task:

1. Bridge isolates the difficult reasoning problem.
2. Codex solves/reviews the reasoning-dense portion.
3. Antigravity performs the heavy integration/runtime/verification portion when appropriate.
4. Bridge independently reviews acceptance evidence.

Example:

Instead of asking Codex to read dozens of files, implement broadly, run repeated builds, configure devices, and capture evidence, assign Codex the difficult component or root-cause problem, then let Antigravity perform environment/runtime/integration verification.

---

## 4. No Duplicate Implementation

Agents may work shoulder-to-shoulder, but they must not independently implement the same subsystem without an explicit review purpose.

Rules:

- one subsystem = one implementation owner,
- shared contracts = Bridge-controlled,
- integration/runtime = Antigravity by default,
- specialist application/design-system code = Codex where assigned,
- final acceptance = Bridge.

Independent verification is encouraged.

Duplicate implementation is not.

An agent reviewing another agent's code must not silently rewrite it outside its assigned ownership.

---

## 5. Self-Correction Is Mandatory

For approved in-scope work, the execution lifecycle is:

`PLAN → EXECUTE → EVALUATE → IDENTIFY GAPS → SELF-CORRECT → RE-TEST → RE-EVALUATE → FINALIZE`

Agents should not stop after the first successful build or first passing test.

They must fix routine in-scope failures themselves before returning, unless blocked by:

- a genuine Founder/Product decision,
- unauthorized architecture/business/financial change,
- destructive/live approval gate,
- missing required access,
- unresolved external dependency.

Accuracy has priority over speed.

However, self-correction must not become redundant re-reading or unbounded repetition.

---

## 6. Efficiency Protocol: Read Once, Delta First

KONFRM explicitly prefers rigorous verification without wasteful repeated discovery.

Default protocol:

`READ ONCE → INDEX → IMPLEMENT → TARGETED VERIFY → SELF-CORRECT → FULL FINAL VERIFY`

### Authority Snapshot

At task start, the agent should read the relevant governing files once and retain an internal authority snapshot containing:

- file/path,
- relevant decision,
- scope constraint,
- important baseline/commit where applicable.

Do not repeatedly reopen unchanged authority files merely "to be safe."

### Reopen only when

- the file changed,
- a conflict appeared,
- a failing test requires exact authority,
- final evidence requires a precise source check,
- baseline drift is detected.

### Delta-first verification

After implementation:

- inspect changed files/diff first,
- run targeted tests while iterating,
- run the full required verification suite near final closure,
- after a failure, fix and rerun the affected targeted checks before the final suite.

Do not perform full repository rediscovery after every small edit.

---

## 7. No Redundant Evidence Collection

Once a claim has been proven by valid evidence and the source of that evidence has not changed, do not repeatedly collect equivalent evidence without a reason.

Examples:

- unchanged package tests need not be rerun after an app-only two-file correction unless a dependency relationship could invalidate them,
- unchanged authority files need not be reread,
- an already-proven Git ancestry fact need not be recomputed after unrelated source edits unless HEAD/base changed.

Exceptions include:

- final closure gates explicitly requiring a fresh check,
- runtime/UI evidence after visual code changes,
- security/business/financial paths where fresh evidence is necessary,
- any detected source or baseline drift.

---

## 8. Verification Ownership

### Codex

Codex should own tests and source-level verification for the code it writes where its environment supports them.

If the Codex environment itself blocks execution, do not waste quota repeatedly retrying the same environment failure.

Bridge may transfer **verification only** to Antigravity while preserving Codex as code owner.

### Antigravity

Antigravity may externally verify an uncommitted Codex worktree when needed.

When doing so:

- do not edit Codex-owned source,
- fingerprint the source/diff before verification when integrity matters,
- run tests/builds,
- fingerprint again after verification,
- report any code failure back to Bridge/Codex,
- do not silently self-fix code outside Antigravity ownership.

### Bridge

Bridge accepts neither agent's PASS declaration at face value.

Bridge may independently inspect:

- branch,
- HEAD,
- ancestry,
- diff,
- public APIs,
- tests,
- docs,
- runtime evidence,
- PR/merge state.

---

## 9. Flutter / Shared SDK Concurrency Safety

When using a shared Flutter SDK on the same workstation:

- do not run multiple Flutter/Dart commands concurrently unless explicitly proven safe,
- default to sequential Flutter execution,
- wait for one command to fully exit before starting the next,
- investigate lock/process ownership before deleting SDK locks or killing processes,
- never broadly kill all `dart.exe` or `java.exe` processes.

If a stale/hung process is proven:

- terminate only the identified PID(s),
- use the minimum safe intervention,
- verify Flutter startup again afterward.

---

## 10. Founder-Assisted Manual Intervention

The Founder is available and willing to perform safe manual actions when this materially helps unblock the project.

Do not treat the Founder as technically advanced.

When manual Founder action is appropriate, Bridge should provide exact step-by-step instructions including:

- what application to open,
- what menu or location to use,
- what command to paste,
- what output/result should appear,
- what output to send back,
- what must **not** be touched.

Use Founder intervention when:

- a local GUI action cannot be performed reliably by the agent,
- permissions require human approval,
- a device/USB/OS setting requires physical interaction,
- local PowerShell inspection is safer/faster,
- Android Studio/AVD configuration requires human assistance,
- an external access/authentication step requires the account owner.

Do not escalate routine coding/debugging work to the Founder merely because an agent encountered one failure.

---

## 11. Founder Workstation Capabilities

Current known Founder-assisted capabilities include:

- Windows workstation,
- PowerShell access,
- Android Studio installed and currently reported as up to date,
- willingness to follow precise step-by-step technical instructions,
- ability to assist with Android emulator/AVD or physical-device steps if needed.

These are operational capabilities, not permanent architecture facts.

Verify them before relying on them if environment state may have changed.

---

## 12. Android Runtime Strategy

For native Android validation:

1. Prefer existing Android Studio / SDK assets.
2. Inspect before installing or upgrading anything.
3. Create/use one controlled AVD when emulator evidence is appropriate.
4. Do not upgrade Flutter/SDK/JDK/Gradle merely because a runtime task starts.
5. Use a physical Android device when emulator evidence is insufficient or unavailable.
6. Android evidence does not count as iOS acceptance.

Runtime acceptance must include actual behavior where relevant, not only APK compilation.

---

## 13. UI/UX Runtime Evidence

Visible UI work requires stronger proof than static analysis.

When required, verify:

- typography rasterization,
- RTL/Bidi,
- text scaling,
- touch targets,
- SafeArea,
- keyboard behavior,
- Android Back,
- overlays,
- navigation,
- sticky action separation,
- loading/error/state behavior,
- screenshots/runtime evidence.

A green CI/build result does not prove visual/runtime correctness.

---

## 14. Founder Escalation Threshold

Escalate to the Founder only for:

- genuine product/business/finance decisions,
- material UX/design direction,
- major architecture choice,
- destructive/live mutation approval,
- account/permission/authentication action,
- external blocker requiring physical/manual intervention,
- tool adoption with material project impact.

Do not ask the Founder to choose routine implementation details that can be resolved safely by the assigned agent and Bridge.

---

## 15. Communication & Handoff Contract

Every significant agent task should communicate:

- exact objective,
- verified baseline,
- assigned ownership,
- allowed paths/systems,
- forbidden scope,
- governing authority,
- acceptance criteria,
- required tests/evidence,
- self-correction expectations,
- Git rules,
- final report format.

A handoff should distinguish:

- what is proven,
- what is inferred,
- what remains unverified,
- what requires another agent,
- what requires Founder action.

Do not present limitations as completion.

---

## 16. Git Safety

Unless an exceptional task explicitly requires otherwise:

- no `git add .`,
- no `git add -A`,
- no `git clean -fd`,
- no `git reset --hard`,
- explicit staging only,
- do not discard unrelated untracked files,
- do not rewrite reviewed immutable commits,
- pin important HEAD/base SHAs before merge,
- verify post-merge ancestry and resulting `origin/main`.

During cross-agent uncommitted verification, preserve the exact worktree and use fingerprints when needed.

---

## 17. Accuracy vs. Speed

KONFRM deliberately prefers early detection over later remediation.

It is acceptable for important tasks to take longer when the time is spent on:

- legitimate testing,
- self-correction,
- runtime verification,
- evidence collection,
- safe integration review.

It is not acceptable to spend time on:

- repeated unchanged-file discovery,
- duplicate agent implementation,
- redundant full-suite runs with no invalidating change,
- repeated environment retries after the blocker is already classified,
- reopening closed Founder decisions without new material evidence.

The operating target is:

**maximum practical correctness with minimum redundant work.**

---

## 18. Routing Summary

Use this default routing:

| Work Type | Default Owner |
| --- | --- |
| Orchestration, decomposition, acceptance, merge governance | Bridge |
| Runtime, environment, Android Studio/AVD, screenshots | Antigravity |
| Long repetitive verification/build/test execution | Antigravity |
| Git integration, deploy, Supabase, Cloudflare | Antigravity |
| Difficult code reasoning and subtle defects | Codex |
| Flutter/Dart component design and focused refactoring | Codex |
| Architecture/API/component judgment | Codex + Bridge |
| Specialist test design / RTL / accessibility reasoning | Codex |
| Product/business/finance authority | Bridge / Founder when required |
| Manual local GUI/PowerShell action | Founder, only with Bridge step-by-step guidance |

When uncertain:

**Antigravity-first for execution volume.  
Codex-first for reasoning density.  
Bridge controls ownership and acceptance.**

---

## 19. Change Control

This document governs execution behavior, not product Canon.

Update it when:

- agent capabilities materially change,
- quota/resource constraints change,
- a new execution agent is formally introduced,
- Founder changes delegation preferences,
- a recurring workflow failure reveals a durable orchestration rule.

Do not edit historical project/business decisions merely to match this policy.

Latest explicit Founder instruction remains the highest authority for agent-routing behavior.
