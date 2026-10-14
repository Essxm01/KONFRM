# KONFRM — Antigravity Execution Prompt
## Customer Screen 12 — My Bookings | Original Native Flutter Design Candidate V1

TASK_ID: CUSTOMER_SCREEN12_MY_BOOKINGS_NATIVE_DESIGN_V1
DATE: 2026-10-14 Cairo
AUTHORITY: Founder approved Screen11 V2 visual direction and expressly authorized moving to Screen12 visual design.
DELIVER: ONE real Flutter isolated design candidate for Samsung Galaxy A56, with all genuine device screenshots + source + comprehensive REPORT.md on GitHub, ready for Founder optical review.
STATE TARGET: SCREEN12_V1_AWAITING_FOUNDER_VISUAL_REVIEW.
NOT AUTHORIZED: production code modification, real booking/Auth/payment submission, Supabase/DB/backend/Cloudflare modification, merge or deployment.

# 1. MANDATORY REALITY PREFLIGHT

Read the ENTIRE prompt. Verify repository main, current worktree, existing branches, modified/uncommitted files and running tasks before touching any source. Never reset, override or duplicate active work; stop and report overlapping Screen12 implementation. Do not assume an historical task marker is current.

Repository: https://github.com/Essxm01/KONFRM
Main SHA checked when preparing prompt: f6911eeecfa100cbbfec935e15769e66966ce835 (recheck).
Current task index: https://github.com/Essxm01/KONFRM/issues/128 — newest top entry Screen12 NOW.
Screen11 V2 visually APPROVED ONLY by Founder, pinned images and report: https://github.com/Essxm01/KONFRM/tree/026845e6acbff9c4466942f64a2cbf0321bbcdc7/review-evidence/customer-screen11/v2
Open separately governed deferrals: https://github.com/Essxm01/KONFRM/issues/144 — a11y 200%, placeholder navigation, production success/auth/E2E; https://github.com/Essxm01/KONFRM/issues/145 — urgent public test report identifier sanitization. DO NOT repeat any unique device identifier in public screenshots or reports; do not alter Screen11 evidence as an unrelated scope extension. Existing radius issue #139 still unresolved.
The existing screen source:
- mobile/apps/customer_app/lib/features/bookings/presentation/bookings_view.dart is an UNAUTHORIZED-only truthful native Customer tab, not a functional personal booking list.
- mobile/apps/customer_app/lib/app/shell/customer_app_shell.dart has four native top-level tabs, with Bookings at index 2 and a real CustomerBottomNavigation.
- mobile/apps/customer_app/lib/app/app.dart sets ar locale, Cairo native theme and root Customer shell.
- Historical React references: customer-app/src/components/CustomerMyBookingsScreen.tsx, customer-app/src/utils/customerBookingPresentation.ts, customer-app/src/utils/customerScreen12MyBookings.test.ts. These contain useful STATUS and STATE meanings, but are NOT an approved native visual design.
- Historical Screen12 branches: phase5/customer-screen12-my-bookings and fix/customer-screen12-session-expiry-closure. Check real purpose/HEADs, do not overwrite or reactivate them.
Read AGENTS.md, docs/INDEX.md, docs/CURRENT_STATE.md, docs/CONTEXT_ROUTER.md, docs/BUSINESS_RULES.md, docs/DECISIONS.md, docs/codex/KONFRM_MASTER_RULES.md as applicable. Read DESIGN_SYSTEM/README.md, DESIGN_SYSTEM/GOVERNANCE.md, DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md, DESIGN_SYSTEM/EXPERIENCE/CUSTOMER_PHASE5_MASTER_UX.md, current native components/tokens and screen family governance. tasks/CURRENT_TASK.md on main may still point to a completed Screen07 task; it is NOT authority to regress the Founder focus.
Inspect actual current physical approved native Screen03 top-level shell references plus Screens08–11 for consistent brand/RTL/typography, not old React visuals.

Before code provide a concise read-only source preflight summary: current main SHA and branch; native BookingsView reality; historical React Screen12 logic; conflicts/overlap; root shell/Design System family and exact scope. If an essential higher-authority rule contradicts the task, STOP for Founder resolution.

# 2. PRIORITY DESIGN SKILLS — EXPLICIT ACTUAL INVOCATION BEFORE UI WORK

Read .agents/SKILL_ROUTER.md and .agents/SKILL_MANIFEST.yaml, then actually READ and APPLY:
- .agents/skills/konfrm-design/SKILL.md — PRIMARY UX and visual design brain.
- .agents/skills/konfrm-design/references/role_experience.md — anxious/repeated-visit guest, scannable jobs.
- .agents/skills/konfrm-design/references/visual_system.md — canonical identity, Cairo, spacing/monochrome.
- .agents/skills/konfrm-design/references/rtl_content.md — RTL, date chronology, mixed Arabic/Latin, Western 0–9, price Bidi.
- .agents/skills/konfrm-design/references/states_interactions.md — guest, expired session, empty/loading/error/stale, actionable states.
- .agents/skills/konfrm-design/references/accessibility_design.md — 200% real reflow, not scaled-down illegible values.
- .agents/skills/konfrm-design/references/visual_review.md — physical visual QA.
Then .agents/skills/konfrm-flutter/SKILL.md for isolated Flutter UI and .agents/skills/konfrm-quality/SKILL.md for verification. Consult konfrm-product when interpreting actual booking policy or unrecognized states; do not claim fake skills or invent agents. Report actual paths consulted and applied rules in DESIGN_SKILL_ACTIVATION_EVIDENCE.

# 3. SCREEN12 CUSTOMER UX MISSION

My Bookings is a REPEATEDLY VISITED ROOT TAB where the guest must instantly know:
1. Is there something I need to do NOW (e.g. Owner approved, deposit payment next)?
2. What is the state of my current or pending stays?
3. Which accommodation, request and dates does each refer to?
4. How do I open the matching booking details when genuinely available?
5. If data is not loaded, or I am logged out/session expired/network failed, what is the truthful, safe next step?

This is NOT Screen11 terminal success, not an invoice, not a dense operational Admin table or old React dashboard. Aim for ONE premium, calm, readable, original Arabic-first native Flutter layout, without generic card soup, endless colored badges, over-decorated tabs, novelty headers, irrelevant actions, or fake trust/availability.

Keep the native four-tab root navigation: استكشف, المفضلة, حجوزاتي, الحساب, only one active. Use a faithful isolated preview of current native bottom nav with correct RTL and safe areas; do not create a duplicate bar nor pretend a fake production route works.

HARD BRAND FAMILY GATE: Screen11 was corrected because adding English KONFRM beside approved centered geometric symbol was ungoverned visual drift. Determine the CORRECT top-level Screen03/Screen12 header grammar from current authority and actual accepted screenshots; keep branded element mode, position, size, Cairo typography, padding and root nav consistent with approved TOP-LEVEL FAMILY. Do not blindly copy Auth arrow or terminal success header into root tab. Never add English wordmark next to logo without actual Founder-approved family contract. Comparative CROSS_SCREEN_VISUAL_CONSISTENCY_REPORT required with exact evidence paths and purposeful family differences.

# 4. CANONICAL STATUS, GROUPING AND SECURITY

Lifecycle: PENDING_OWNER_APPROVAL → Owner approval → APPROVED_PENDING_PAYMENT → successful authorized deposit payment → CONFIRMED. A submitted pending request is NOT accepted/paid/confirmed and does NOT hold inventory. Owner approval alone does NOT confirm booking. Deposit only AFTER Owner approval. Never promise approval, response SLA, expiry/payment deadline, refund/cancellation entitlement, retained dates, no-show or balance-payment policy absent approved canon.

Reference mapping in historical customerBookingPresentation.ts (confirm against latest governing source, not unconstrained UX invention):
- PENDING_OWNER_APPROVAL: قيد مراجعة المالك; CURRENT; no money due yet; not action-required.
- APPROVED_PENDING_PAYMENT: العربون مطلوب or بانتظار دفع العربون; ACTION_REQUIRED; this is the only action-required status in current mapped contract. Preview must NOT activate payment.
- CONFIRMED: الحجز مؤكد; CURRENT.
- REJECTED: لم يوافق المالك; HISTORY.
- CANCELLED_BY_GUEST or CANCELLED_BY_OWNER: distinct history labels ONLY if canonical status known; never invent ability to cancel.
- EXPIRED or COMPLETED: HISTORY only if received canonically; no invented timer.
- UNKNOWN or future status: neutral unknown/OTHER with no misleading paid/rejected label and no raw enum to user.

Only show populated groups:
1. يحتاج إجراء منك (only if appropriate real eligible records exist).
2. الحالية (Owner pending and confirmed).
3. السابقة (past states).
4. حجوزات أخرى (optional if unknown state).
Preserve canonical server order WITHIN each section. Nav action-required count only for actual approved-pending-payment, never merely pending-owner. Each tappable-looking booking row must make property name, status, matching booking reference and useful dates obvious; stay/guest count only where canonical. Avoid exposing private user/owner identity or internal platform commissions. Financial values should be shown only when truly decision-relevant from authoritative source or synthetic fixture in visual preview, never calculated locally. Number-first currency (e.g. 13,500 ج.م), booking identifiers and Latin snippets directionally isolated LTR inside RTL; customer-visible numerals Western 0–9.

# 5. MANDATORY HONEST UI STATES

Build ONE isolated Flutter Screen12 composition and reusable elements, with deterministic synthetic fixture states:
A. GUEST/UNAUTHORIZED: distinguish unknown personal list from empty; explain authentication is needed; no fake private data.
B. SESSION_EXPIRED: distinct sign-in recovery state, no claim current bookings loaded.
C. INITIAL_LOADING: calm truthful loading, not random blank.
D. AUTHENTICATED/TRUE_EMPTY after successful zero-item list result: concise honest empty + Explore.
E. AUTHENTICATED/LOADED: realistic mixed pending Owner, approved-pending-deposit, confirmed and past bookings demonstrating conditional groups. No real account.
F. ERROR/no usable list: error + retry not empty.
G. STALE_REFRESH_ERROR/with reliable last-known list: keep cached entries visible, subdued notice and retry; do not erase as empty.
H. UNKNOWN_STATUS: neutral other group, no false financial action.
I. RECENT_SUBMISSION_MISSING_FROM_LIST: optionally if canonical contract supports it; delayed list sync is not evidence booking failed, but don't invent successful request in production.

All states are preview fixtures. Only render a meaningful subset as physical screenshot scenarios while ensuring the UI concept handles each state. No fake signin/payment/booking navigation. Taps in visual demo must be harmless and honestly labeled preview-only; do NOT claim a finished Screen13 detail route.

# 6. DESIGN SYSTEM, RESPONSIVE AND A11Y HARD GATES

- Native Cairo, predominantly white and neutrals, black high-priority action, semantic status text with restrained emphasis. Do not clone prominent blue React styling, yellow/orange warnings, bright payment boxes, green confetti, gradients, superfluous card stacks or generic SaaS dashboard look.
- Arabic-native RTL from root; use directional alignment/insets and semantic back/status/chronological icons; no indiscriminate flipping. Mixed Arabic and technical codes must preserve proper LTR sequence; amounts number-before-currency.
- One consistent booking row/card grammar; no tiny text for status or user actions. Optimize hierarchy for quick scanning and worry-free understanding.
- 360dp, normal A56, and selected 390/430dp layout; safe areas and root nav; long Arabic property title/reference; RTL Bidi and numeric format. At 200% text scale use multiline WRAP, vertical stacking of labels and values, scroll reachability and sensible touch targets. IMPORTANT: Screen11 issue #144 already captured FittedBox(scaleDown) making financial text illegibly small: DO NOT recreate that accessibility anti-pattern here.
- Prefer >=48dp frequent action touch surfaces; no awkward overlays, bottom bar collisions, status/error mistaken for empty. One good design candidate, no unnecessary prototype forks or design court unless a genuine unresolved product policy decision exists.
- Use actual physical device screenshots to compare brand/header/nav, not only descriptions. Founder alone accepts new design; green CI does not imply visual signoff.

# 7. ISOLATED NATIVE PREVIEW ONLY — STRICT CODE BOUNDARY

Create a safe independent Flutter design preview harness with available KONFRM native Design System components, separate from production app routes:
- No changes in mobile/apps/customer_app/lib, customer shell, bookings_view.dart, mobile/packages/konfrm_design_system/lib or global tokens.
- No changes in customer-app React production, Owner, Admin, backend, DB/Supabase, Cloudflare, payment, booking/Auth contracts, finance, security or notifications.
- No production API requests, real sessions, customer bookings, OTP, protected POST, payment, cancellations or database mutation.
- No PR merge/deploy/release. No silent changes to issue #128 or deferred issues #144/#145.
- Preserve existing native unauthorized guard unchanged.
- Synthetic fixtures clearly declared in evidence README. No customer phone/email/device identifiers/payment numbers from real life.
- Keep isolated runner source and concise run recipe in same V1 evidence directory for independent review. If cannot publish safely, explicitly report reproducibility blocker. Keep original raw device screenshots local/private and gitignored.
- Test preview interactions without pretending to access real bookings. Do not perform unrelated cleanup/refactoring or start Screen13.

# 8. REAL SAMSUNG GALAXY A56 DEVICE QA AND SCREENSHOTS

Run genuine Flutter UI on connected physical Samsung Galaxy A56 Android 16; capture original genuine device framebuffer PNGs (not React, Figma, browser mock, screenshots generated via image tools or simulator). Test:
- Loaded first fold priority and root Bookings tab/brand/nav.
- Full populated conditional sections after scrolling, distinguish Owner pending vs deposit required vs confirmed/past.
- Guest/UNAUTHORIZED versus session expired.
- True empty versus network failure versus stale retained list.
- Long Arabic title, long booking reference, RTL amount/date formatting on 360dp.
- Accessibility 200% with genuine readable text reflow, full scrolling/visible next action. NO scale-down or clipped controls.
- Actual harmless scenario switching and hit-testing, safe Android bars; no invented real navigation. Verify any actual QA code states.
- Static Flutter analysis on isolated runner, focused widget/layout tests where available, actual commands and exit codes in report. Do not turn green analyzer alone into hardware/UX approval.

Suggest 6–9 meaningful device captures across these scenarios, not repetitive twenty. Prefer less than 500KB PNG each when readable, redact notifications and identifiers without altering app UI pixels. Never include unique physical ADB serial in public reports, shell command examples or image metadata.

# 9. GITHUB AS TWO-WAY RELAY — COMPLETE REPORT NEXT TO IMAGES

Read canonical GitHub relay protocol:
https://github.com/Essxm01/KONFRM/blob/docs/cross-account-recovery-20261013/KONFRM_BRIDGE_GITHUB_RELAY_PROTOCOL.md

Evidence branch: evidence/customer-screen12-design-review (create only if safe, do not merge)
Directory: review-evidence/customer-screen12/v1/

MUST PUBLISH CO-LOCATED:
- REPORT.md: comprehensive truthful technical/product/UX/a11y/QA/status report.
- README.md: scenario table and clickable individual pinned GitHub URLs.
- VISUAL_BRIDGE_README.md: mapping, provenance, checksums and dimensions.
- 01_*.png etc: original real Samsung A56 captures, legible, sanitized, optimized.
- 01_visual_bridge.jpg.b64.txt etc: ONE PER PNG, pure UTF-8 single-line Base64 encoding of ordinary JPEG derived from corresponding original PNG. Bridge requires these TEXT companions for independent optical inspection via GitHub; do not force a second upload task.
- review-source/screen12_preview_runner_v1.dart + actual launch recipe, privacy-safe source baseline. No production integration.
- Do NOT publish unique device serials, app notifications, customer/owner records, account numbers, secret keys or machine-specific private paths.

REPORT.md must include:
1. TASK_ID, immutable prompt link/SHA, verified main and preview/evidence HEAD, source paths and scope.
2. DESIGN_SKILL_ACTIVATION_EVIDENCE (actual exact consulted modules + principles applied/unavailable).
3. CROSS_SCREEN_VISUAL_CONSISTENCY_REPORT (actual approved top-level/other comparator screens, brand/nav/header matches and justified family differences).
4. Product/status/section model vs native current unauthorized and historical React, actions/payment truth.
5. Actual state scenario coverage: loaded/action-needed/Owner-pending/confirmed/past, guest, expired, loading, true empty, no-cache error, stale error, unknown status.
6. Pixel and physical interaction QA, RTL/Bidi, Western 0–9, 360dp/200% legible accessibility, limitations.
7. Exact flutter analyze/test/device command outcomes/exit codes and per-scenario A56 direct links.
8. No production changes, no backend/DB/auth/payment mutations, no merge/deploy; no fake working Screen13.
9. Open dependencies and Founder decisions (Screen11 issue #144, privacy #145, radius #139 remain outstanding).
10. Final status SCREEN12_V1_AWAITING_FOUNDER_VISUAL_REVIEW — Founder visual approval PENDING.

After push READ BACK REPORT and README from GitHub, verify actual PNG files and each Base64 companion decodes to real JPEG of matching dimensions. Record exact evidence branch commit. If not accessible return EVIDENCE_REPORT_UPLOAD_BLOCKED instead of unverified success.

# 10. FINAL SHORT COMPLETION MESSAGE TO FOUNDER

Only after successful verified publication, send ONE compact Arabic ready-to-forward notice, not a long report:

"اكتملت مهمة CUSTOMER_SCREEN12_MY_BOOKINGS_NATIVE_DESIGN_V1. الحالة: SCREEN12_V1_AWAITING_FOUNDER_VISUAL_REVIEW. التقرير الكامل: [ACTUAL_VERIFIED_PINNED_REPORT_URL]. الصور والمعاينات: [ACTUAL_VERIFIED_PINNED_VISUAL_BRIDGE_README_URL]. فرع الأدلة: [EXACT_BRANCH]، Commit: [EXACT_SHA]. كود المعاينة: [ACTUAL_SOURCE_URL]. الاختبارات: [HONEST_BRIEF_STATUS]. لا تعديل للكود الإنتاجي ولا دمج أو نشر. يا Bridge اقرأ التقرير والصور والكود مباشرة من GitHub وقارن مع الديزاين المعتمد ثم ارجع للمؤسس بقرار المراجعة."

Do not self-approve Founder visual signoff, begin Screen13, delete evidence or mark cleanup TRASH_READY merely because build/tests passed.

END. ONLY ORIGINAL SCREEN12 VISUAL CANDIDATE V1.
