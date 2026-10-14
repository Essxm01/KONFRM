# KONFRM — Two-Way GitHub Relay Between Bridge and Antigravity
**Founder directive:** 2026-10-14, Bridge 12 → Bridge 13+  
**Scope:** All future authorized Antigravity work; Customer, Owner, Admin, shared Design System, backend and documentation where relevant.  
**Classification:** Operating protocol; NOT project code, independent task authorization, proof of execution, approval to merge/deploy, or release signoff.  
**Repository visibility:** PUBLIC. Never store credentials, tokens, private customer data, real account identifiers or private device captures.

## 1. Intent and roles

The Founder is a **human messenger of SHORT NOTIFICATIONS ONLY**, not a courier of large technical prompts, reports, screenshots or logs.

- **Bridge (ChatGPT):** Inspect current GitHub and canonical decision reality; write the entire approved self-contained task prompt to a versioned, disposable GitHub Markdown file; verify the actual file, branch, SHA and complete content; send Founder only one compact copy-ready notification for Antigravity. After an Antigravity completion notification, independently open and inspect the committed execution report, evidence manifest, screenshots and related implementation revisions. Verify technical/product/UI/UX truth; do not trust claimed green CI or claimed visual acceptance alone. Return one focused Founder decision / next step.
- **Antigravity:** Open the exact committed prompt in GitHub and read its ENTIRE body before implementing; verify current branch/HEAD, project Canon, permitted scope and active conflicts; execute, test and physically review as permitted. Publish a **complete detailed Markdown report and optimized privacy-safe actual screenshots together on the SAME evidence branch/directory**; include provenance and exact evidence links. Send Founder only a short copy-ready completion notification addressed to Bridge with the verified report URL and evidence location.
- **Founder:** For dispatch, paste Bridge's SHORT message to Antigravity. For completion, paste Antigravity's SHORT message to Bridge. Founder is not expected to move large prompts/reports, collect screenshots, parse logs or assemble links manually.

This is **two-way GitHub-mediated handoff**, not an always-on direct connector or an asynchronous automatic integration. Neither Bridge nor Antigravity is considered notified until Founder forwards the short message (or a separately connected authorized tool provides the information).

## 2. Forward direction: Bridge → Antigravity

1. Verify current task and permissions, task ID, main and active branch, current issue/PR, relevant role UX and design-family screenshot baselines, architecture and financial/security invariants.
2. For design-related tasks, explicitly route through the repository's `.agents/SKILL_ROUTER.md` / `konfrm-design` and relevant RTL/visual-system references BEFORE implementation. Require a cross-screen comparison against approved visual evidence, not a newly invented logo/header or an old React visual reference.
3. Write full standalone prompt to **an isolated temporary docs-only branch** and versioned Markdown path, e.g. branch `temp/antigravity-prompt/CUSTOMER_SCREEN12_V1`, path `prompt/CUSTOMER_SCREEN12_V1.md`. If private material would be included, use an approved private location instead; do not publish it to this public repo.
4. Commit then **read the GitHub file back**: verify complete body, branch/ref, task/version and exact commit SHA. Give Antigravity an immutable commit-pinned GitHub raw/blob URL.
5. ChatGPT response to Founder must contain only a SHORT copy-ready dispatch command, not the full prompt, and a brief status/link as needed. Command: “اقرأ ملف البرومبت الكامل من [verified immutable GitHub link]، راجع الحالة الحالية والمهارات المطلوبة ثم نفّذ النطاق المسموح فقط. بعدها ارفع التقرير الكامل وREADME والصور الحقيقية في نفس مجلد أدلة GitHub، وأرسل لي رسالة قصيرة تحتوي على رابط التقرير وفرع الأدلة والـCommit. توقّف لو الملف ناقص أو الحالة متعارضة؛ لا تدمج أو تنشر دون إذن.”
6. Never silently modify a prompt after the Founder has dispatched its exact version. Amendments require a new version and separately authorized dispatch.

## 3. Return direction: Antigravity → GitHub → Bridge

For each task with UI/device evidence, use a **dedicated evidence-only branch**, for example:

- Branch: `evidence/customer-screen12-design-review`
- Directory: `review-evidence/customer-screen12/v1/`
- Complete execution report: `review-evidence/customer-screen12/v1/REPORT.md`
- Evidence index / manifest: `review-evidence/customer-screen12/v1/README.md`
- Sanitized device captures: `review-evidence/customer-screen12/v1/01_*.png`, `02_*.png`, ...
- Optionally task-specific, privacy-safe ancillary test evidence beside these assets.

This is a **pattern**, not a declaration that a specific branch or report presently exists. If a task is not visually-oriented, choose an equally traceable task-specific report directory on a disposable documentation/evidence branch; no fabricated screenshots. Do not merge evidence branches into main merely for handoff.

### Minimum full REPORT.md contents

- Task ID, prompt GitHub immutable URL + commit SHA, task goal and exact authorized scope.
- Actual starting main SHA, local/current branch and starting HEAD, final implementation branch and HEAD, evidence branch and evidence commit.
- Files/components actually inspected and changed; what was deliberately NOT changed, known overlap and blockers.
- Real design and business truth: role, screen family, branding/header consistency (including symbol-only versus symbol+wordmark), Arabic RTL/Bidi/Western digits, Cairo typography, canonical Design System tokens and states; current implementation limitations.
- `DESIGN_SKILL_ACTIVATION_EVIDENCE`: actual governed SKILL.md and supporting references read, specific principles applied, unavailable/not consulted distinctions; never claim a skill executed without evidence.
- `CROSS_SCREEN_VISUAL_CONSISTENCY_REPORT`: exact approved comparator screenshot paths, intentional family variants, unintended drift, visual judgment still awaiting Founder.
- Commands executed and truthful results (analyzer, widget/tests, runtime, real Android A56 or Admin browser), failed commands and uncertainty; distinguish test claims from measured pass.
- Honest task state: `IMPLEMENTED_CANDIDATE` / `READY_FOR_FOUNDER_VISUAL_REVIEW` / `BLOCKED`, never self-authorize Founder visual signoff, production/live correctness, merge or deploy.
- Screenshot/evidence manifest with **individual direct GitHub links**, scenario names, device/platform details, fixture or canonical provenance, capture method and sanitization confirmation.
- Necessary future follow-ups, deferred QA issues, merge/release blockers, pending Founder decision.
- Exact assertion of any production/DB/financial/auth change or explicit confirmation of none when none authorized.

### Evidence-integrity rules

- Screenshots must come from genuine requested devices/real browser contexts. No fake generated image, historical React/browser proxy for native Flutter, or invented runtime evidence.
- Optimize privacy-safe screenshots before PUBLIC GitHub upload (aim <500KB each when legible; don't sacrifice fidelity). Keep private originals out of Git.
- Provide BOTH report and screenshots on the **same evidence branch, next to each other**; README should link to `REPORT.md` and each actual screenshot.
- Verify the report and every cited screenshot really exists on GitHub AFTER push. Verify exact evidence branch HEAD and report content, and provide links at actual verified commit SHA where practical. If report can't be published, say `EVIDENCE_REPORT_UPLOAD_BLOCKED`; do not claim completion or paste an unverified link.
- Antigravity must NOT produce only a chat report while promising the Founder that Bridge can later inspect GitHub.
- If screenshots are unnecessary or impossible, describe that plainly and provide the appropriate source/test evidence; never substitute untruthful images.

### Completion message Antigravity sends to Founder (short, ready to forward unchanged to Bridge)

> اكتملت مهمة KONFRM: [TASK_ID]، والحالة [ACTUAL_STATUS]. رفعت التقرير الكامل والصور/الأدلة في نفس مجلد GitHub. التقرير: [VERIFIED_GITHUB_REPORT_URL]. فرع الأدلة: [EXACT_BRANCH]، Commit: [EXACT_EVIDENCE_SHA]. فرع التنفيذ: [BRANCH]، Commit: [IMPLEMENTATION_SHA]. يا Bridge راجع التقرير والصور بنفسك من GitHub، ثم قدّم نتيجة المراجعة وقرار المؤسس المطلوب. [BLOCKER_OR_NONE].

Founder can forward this exact short note with no large report or screenshots.

## 4. Bridge review when it receives ONLY the completion notification

1. Verify report exists at supplied GitHub commit/path. Fetch and read its **entire** Markdown, not only the title or Antigravity's short notification.
2. Verify evidence manifest and each actual screenshot at the indicated GitHub revision. Inspect genuine images, text clipping, visual hierarchy, same-family logo/header consistency, RTL/LTR numbers, fonts, CTA states, keyboard/safe areas and role-specific UX.
3. Cross-check implementation branch/HEAD and code diff as necessary, task's original pinned prompt, GitHub Issue/PR, tests and the real project Canon.
4. Classify findings as VERIFIED, AGENT_CLAIM_ONLY, FAILED, NEEDS_FOUNDER_DECISION or DEFERRED, not a binary green CI verdict.
5. Respond in clear Egyptian Arabic with what was actually verified, specific UI observations, relevant blockers and only the needed Founder decision/next action. **No request to paste the long report** if GitHub access works. If access fails, describe the exact blocker and request only the minimum link/permission correction.

## 5. Temporary prompt and evidence lifecycle

- Full task prompts and evidence/reports are temporary execution artifacts, NOT automatically permanent design Canon.
- Keep intact during execution, while Antigravity may still read them, until Bridge's independent review, Founder visual approval and all outstanding corrections/evidence dependencies have been checked.
- Report and screenshots share one evidence cleanup lifecycle. Mark `TRASH_READY` only once no current work or QA depends on them, with a minimal durable non-sensitive closure record (task IDs, code/evidence links or snapshot SHA, acceptance date/decision, deferred issues) retained in proper permanent governance.
- **Never** create tracked `trash/` in public Git as purported garbage collection. Prefer isolated temporary/evidence branch deletion after safe cleanup review and specific Founder approval. Moving tracked files to trash does not erase Git history, and Git branch deletion does not necessarily purge inaccessible historic objects.
- Never auto-delete immediately after a notification or green build.

## 6. Transition exception and continuity

**Current exception at 2026-10-14:** Founder already sent the full Screen 11 design prompt manually before these GitHub-handoff instructions existed. Antigravity has reportedly completed Screen 11 and provided the report to Founder, but **has not yet published the report to GitHub**; Founder will paste the Screen 11 report manually ONCE. Do not falsely claim this particular report or its visual QA is independently available or approved. Apply the new two-way protocol to subsequent authorized tasks and correction versions only, unless Founder expressly requests retroactive evidence publication.

**Bridge 13+ MUST read this protocol after the current handoff**, and use it alongside the existing design-skill activation, Arabic RTL, Founder visual consistency, temporary prompt retention and business/safety constraints in `KONFRM_BRIDGE_LIVE_HANDOFF.md`.

**LAST UPDATED:** 2026-10-14 — protocol adoption, not execution/result certification.
