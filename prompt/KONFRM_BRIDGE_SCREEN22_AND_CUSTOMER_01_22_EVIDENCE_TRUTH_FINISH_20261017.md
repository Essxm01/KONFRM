# KONFRM — BRIDGE BOUNDED FINALIZATION | SCREEN22 CHAT TRUTH + CUSTOMER01–22 AUDIT REBASE

DATE 2026-10-17, Africa/Cairo · PLAN MODE SHORT PRECHECK -> TWO SMALL INDEPENDENT CORRECTIVE COMMITS · DESIGN-ONLY
FOUNDER SCREEN22 ORIGINAL REQUIRED STYLE: CUSTOMER WHITE PHYSICAL LEFT, OWNER PURE BLACK PHYSICAL RIGHT, avatars left/right respectively, physically right-pointing Back at right edge, far-left Screen13 booking link, no repeated title subtitle/booking strip/scope notices, optional collapsed booking details. **ALL THESE VISUAL DIRECTION CHANGES HAVE BEEN MADE**; DON'T REDESIGN SCREEN22 AGAIN.

GOVERNING BRIDGE REVIEW SCREEN22: https://github.com/Essxm01/KONFRM/issues/191#issuecomment-6231888641
GOVERNING BRIDGE AUDIT REJECTION: https://github.com/Essxm01/KONFRM/issues/192#issuecomment-6231894938
SCREEN22 VERIFIED REMOTE HEAD: 09aa2146bef4a07e42ca04828b0c16bf4dc805ae
GLOBAL AUDIT VERIFIED REMOTE HEAD: 5daf6cd88948a717029f2a72b2ea3a2f07e7fd3f
APPROVED SCREEN21 FROZEN REAL SHA: d04f8e5e657502b58886a9b9d0dd934d1a97f20a
PRELIVE CHAT #190, CROSS-SCREEN #187, EVIDENCE HOLD #155, SKILLS/COURT #183.

## 01. PLAN MODE — RECONCILE SOURCE, DO NOT ASK FOUNDER AGAIN FOR RESOLVED DECISIONS
Read actual branch HEAD, reports, all screenshots and source. Inspect full review comments for both issues, plus KONFRM_EXECUTION_TASKS.md §4.1 exact screen inventory, actual .agents skills and Court. Write one short correction plan with exact files, observed defect and expected image/test. Two separate branches, no cherry-pick/merge across branches and no production/lib/backends. Founder Screen22 not frozen; Screen23 locked. No fake compliance votes.

## 02. WORKSTREAM A — SCREEN22 NO MORE RE-LAYOUT: CORRECT ONLY VERIFIED TRUST GAPS
Branch `evidence/customer-screen22-design-review` at real remote HEAD `09aa2146bef4a07e42ca04828b0c16bf4dc805ae`. Preserve all earlier `v1/` and `v1-founder-layout-truth-correction/` intact #155. Create NEW additive versioned `review-evidence/customer-screen22/v1-final-truth-microfix/` and update isolated preview runner/test/task only. Preserve correct physical bubble position, arrow pointing RIGHT, collapsible details, authorized avatars fallback and booking link.
1. UNKNOWN after network timeout: Screenshot #06 still shows ACTIVE BLACK Send next to existing UNKNOWN message and draft. Code current `sendMessage()` only checks empty/guest/available and composer only checks hasDraft. Block any blind tap/double-send on UNKNOWN until authoritative resolution. The single action `مراجعة المسودة` should let user inspect text, not implicitly erase uncertainty or send a fresh message. Keep identity, don't silently turn unresolved message to a second optimistic record. No pretend actual server status when backend is absent.
2. OFFLINE: screenshot #08 has ACTIVE BLACK Send with nonempty local draft despite offline. Keep draft editing; send disabled until the actual server is eligible and connection is present (design-local state demonstration, not actual connectivity). No background auto-send promise, no fake pending network event from offline click.
3. Draft truth: Replace false `تم حفظ المسودة في هذا الجهاز لتجنب إرسال رسائل مكررة.` — currently only in-memory ChangeNotifier+TextEditingController — with one concise accurate ephemeral sentence e.g. `نص رسالتك ما زال هنا للمراجعة.` Only assert device-persistent after actual durable storage PRELIVE #190; never claim backend ACK or idempotency in preview.
4. Confirmed failure: screenshot #07 still uses a broad pale-red full-width strip and bright red CTA. Founder wants calm/minimal; show small inline status adjacent to failed bubble, one narrowly source-backed recovery action; true error red icon may remain for accessibility/meaning, but don't turn every failure into panic card. If server failure not proven, do NOT say confirmed failure in user copy. `retryFailedMessage()` is a local in-memory state flip; don't overstate it as safe network retry or duplicate prevention. Keep ONE action.
5. Seeded owner answer `المسار مباشر وسهل، وجميع اللوحات الإرشادية واضحة بمجرد الدخول من البوابة.` is an unsupported live property/access instruction. Replace only this with short neutral coordination wording that does not assert signage, check-in, parking, key logistics, eligibility/refund or Owner SLA. `مؤكد` booking badge in expanded panel only when scenario evidence actually seeds confirmed booking; do not assert user account has verified status. Real profile image loading and message transport remain prelive.
6. Focused Flutter widget tests MUST simulate clicking send with nonempty draft while UNKNOWN and OFFLINE and prove NO appended pending message and no draft loss; test `review` stays non-dispatching, source-based text does not imply persistent disk storage. Real rect geometry and right-arrow screenshots already passed; keep regression tests. Test 100% and 200% states; genuine new A56 captures only changed scenarios (#06 UNKNOWN, #07 FAILED, #08 OFFLINE, optionally #01 top/#12 composer if regression), .png+base64 and actual SHA/manifest, no screenshot-count theater. Bridge must independently compare; user/Founder final visual approval still pending.

## 03. WORKSTREAM B — REBASE THE ENTIRE AUDIT TO THE TRUE 26-SCREEN CUSTOMER CANON
Branch `evidence/customer-cross-screen-fidelity-audit` at real remote HEAD `5daf6cd88948a717029f2a72b2ea3a2f07e7fd3f`. Current branch has **ONLY 4 NEW MD + task marker**; no Screens01–21 before/after corrective Flutter/screenshots. State that truth. Do NOT start arbitrary replacement of production code or global icon package.
**Exact correct IDs from KONFRM_EXECUTION_TASKS.md §4.1:**
01 Splash/App Launch
02 Welcome/Guest Entry
03 Explore/Home
04 Search & Refine
05 Search Results
06 Property Details/Booking Decision
07 Booking Request Review
08 Auth Phone Entry
09 OTP Verification
10 First-time Profile Setup
11 Booking Request Sent
12 My Bookings
13 Booking Details/Stay Hub
14 Deposit Payment
15 Favorites
16 Notification Center
17 Account Home
18 Profile/Edit Profile
19 Settings
20 Payment History (+ private transaction/receipt detail design)
21 Help & Support
22 Booking-scoped Chat (latest V1 correction is **NOT FOUNDER FROZEN**).

1. Completely correct existing 22-row matrix's WRONG mapping: 01,02,08,09,10,14,15,17,18,19,20. This is a fundamental product map error. Don't simply change names and leave wrong descriptions, branches/screenshots, recommended fixes, state labels or overconfident PASS entries. For each row verify exact fully resolvable frozen SHA, approved branch, specific screenshot file(s) physically inspected normal+scrolled and 200% where available, exact runner/integrated Flutter source path, findings with proof and unknowns. Distinguish standalone isolated UI `tool/` from production-integrated `lib/` and historic web React. Do NOT invent evidence if historical branch lacks it; evidence for Screen05/08–13 exists on dedicated older branches. `scratch` path alone and 12-char guessed SHA is NOT verified proof.
2. Fix cardinality/accounting: claims NO_CHANGE 6 but lists 10, P1 11 but lists 12, and P0/P1/P2 overlap contrary exclusive category. Use per-screen `PRIMARY_VERDICT` exactly 22 rows and separately multiple `FINDING` records; clearly mark unknown/not inspected. Screen22 FOUNDER_PENDING, not NO_CHANGE/APPROVED.
3. REMOVE invented business obligations: `عربون الليلة الأولى` first-night deposit only after Owner approval is canonical, but NON-REFUNDABLE and `المتبقي يُسدد عند الوصول` are NOT confirmed and MUST NOT be presented as approved. MR-15 cancellation/refund/remaining balance open, no invented per-property tier/dates or penalty. Screen14 DEPOSIT, NOT CANCELLATION. Screen09 OTP, NOT Apple Pay/card selection. Screen10 profile, NOT PSP/3DS. Screen20 is payment history with an illustrative A4 receipt, NOT binary exportable PDF; actual PDF/tax/prelive #180, missing checkout UI #188 separate.
4. Don't universalize Screen22 collapsible header to 22 screens; auth, receipts, booking review and property decision require tailored hierarchy and essential legal/payment disclosures. Right-pointing hierarchical BACK as actual physical icon YES, but source screenshots/Flutter `matchTextDirection` need proof per affected screen before declaring defect. A 'NO_CHANGE' may be honest for copy yet unknown for arrow or 200%; distinguish per-dimension. Do not call all 22 screens A56/200% verified without actual corresponding physical screenshots, tests or file references.
5. `GLOBAL_PHYSICAL_RTL_BACK_ARROW_LAW.md` currently instructs replacing production `packages/konfrm_design_system` during design-only phase, which is NOT authorized. Treat as design contract/proposed isolated widget until explicit integration. `UNIFIED_ARABIC_CONTENT_AND_COMPRESSION_GUIDE.md`: remove fake financial guarantees, avoid blanket ban on red semantic error/destructive indications; useful meaningful alerts remain, avoid spammy giant warning cards. Court 'COMPLIANT_BY_DESIGN' for iOS/Apple/Play privacy must be downgraded to NOT_TESTED / MANDATORY_PRELIVE as applicable.
6. Founder asked to **correct actual prior-screen clutter**, not stop at four docs. Make ONE honest, targeted design-only candidate correction batch for the actually inspected P0/P1 visible defects: source-pinned before/after native A56 screenshots, additive evidence in new folder, no mutation to frozen source or prior evidence, no world-spanning 22-screen V2 rewrite. Where only integrated Flutter `lib/` exists, prepare narrow proposed patch with independent isolated preview and mark UNAPPLIED, never stealth-edit production. If provenance or device not available, explicitly report what remains NOT DONE; don't claim all 22 fixed.

## 04. GATES AND FINAL RETURN
Output A and B separately, exact TRUE branch SHA, GitHub diff, real image hash/manifest, measured touch geometry, actual Flutter tests where run, honest source/skill/Court and Apple/Google conclusions. Screens12–21 original Founder freezes remain binding and untouched, Screen22 until Founder chooses, Screen23 NOT authorized. Existing PRELIVE #163/#178/#180/#186/#190, candidates #188/#189 and gap #187 remain tracked. Reuse one Design Court docket for substantive choices, no fictional multi-agent consensus, no legal/financial policy invention.

FINAL STATES REQUESTED: A `SCREEN22_BOUNDED_TRUTH_MICROFIX__FOUNDER_VISUAL_YES_NO_PENDING`; B `CUSTOMER01_22_CANON_REBASED_AUDIT__SOURCE_LINKED_TRUE_FINDINGS__ADDITIVE_DESIGN_ONLY_CANDIDATES_ONLY` (or HONEST_PARTIAL if evidence missing).