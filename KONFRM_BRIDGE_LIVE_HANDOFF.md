# KONFRM — BRIDGE 11 → BRIDGE 12 | OFFICIAL HANDOFF
**Date:** 2026-10-13 (+03). **SENDER: محادثة الجسر 11; RECEIVER: محادثة الجسر 12 ONLY.**
**Status:** Continuity instructions, not implementation/merge/deploy approval.
**Truthfulness:** Claims below derive from Founder conversation, Antigravity reports and selective GitHub verification on date shown. Agent statements do not become physical acceptance.

## BRIDGE 12 MANDATE
Lead product strategy, UI/UX visual judgment, engineering scope and independent QA. Antigravity is the execution developer (Flutter, React, Supabase, Cloudflare, CI, GitHub, device). You are not just a prompt writer: reason, challenge, compare alternatives, identify root cause, craft one tightly scoped prompt after permission, verify device evidence and expose residual gaps. Speak clear Egyptian Arabic to a non-technical but demanding founder: first user impact, then practical reason, professional recommendation and ONE next action. No flattery, fake certainty, repeated questions, speculative deployments, or endless cosmetic loops. If your advice differs from Founder's hope, argue from real screen geometry, business impact, constraints, and tests.

Process: inspect real current state → governing product/design authority → independently diagnose root cause → propose bounded trade-off → Founder authorizes → Antigravity codes/tests/real-device checks → Bridge independently reviews → Founder visual approval → separate merge/deployment authority.

## PRODUCT & UNCHANGED RULES
KONFRM is a short-stay coastal accommodation marketplace. Customer seeks authentic photos, resort/region, nightly price, capacity, beds/baths, confident booking request. Owner seeks operational control of calendars, properties, requests, documents, incomes. Admin needs desktop operational queues, evidence, permission and audit. Same design language; DIFFERENT hierarchy per role.
Server/PostgreSQL/Supabase are canonical for business facts. Stay length 2–30 nights under current contract. Deposit = actual first-night price. Current commission = 20% of deposit and owner net = 80% of deposit. Request PENDING_OWNER_APPROVAL does not confirm booking or hold dates. Payment after Owner approval only. Real quote/fingerprint/availability owned by backend. No auto-submit after auth and no fabricated success, ratings, verification or financial rules.
Founder-inspired future Owner on-site inspection fee and future 2.5% deposit-commission scenario are NOT approved product changes. They are only research ideas saved in PR #119 DRAFT, do not replace current business logic or claim any unit is guaranteed 100%.

## COMPRESSED HISTORY (DO NOT RESTART)
Founder-approved black KONFRM geometric logo, Android launcher/splash corrections merged PR #113/#114 and physically reviewed on Samsung A56. Cairo typography, disciplined RTL and color/outline system. 12dp was selected for Screen03 immediate button softness, not a silent global token update; search pill is 26dp.
Screen06 Property Details merged PR #116; Screen07 Booking Review merged PR #118 with price change, date conflict, network/auth and server quote guards. Native Customer Auth 08–10 and protected booking/favorites end-to-end still have pending dependencies; do not equate merged visual UI with completed user journey.
Current Screen03 Explore redesigned from tall Form Soup to browse-first Search Pill; personal Arabic greeting/avatar header, real user photo first, selected dark/black clothes Avatar Candidate 3 fallback, no guest notification bell until functional, consistent outline icons, region search pill RTL, heading أماكن الإقامة (not نتائج البحث before an actual search).
**Verified GitHub 2026-10-13:** PR #120 OPEN, UNMERGED, non-Draft at inspection; HEAD 041e1f68ade9bbc2f11dc130150fd1ee96f5a496. Antigravity reported 145/145 tests, 0 analyze issues and Samsung A56 images from live public discovery API. Founder HAS NOT given Screen03 final approval.
Other relevant PR statuses at inspection: #115 UI/UX Design Bridge Playbook OPEN/DRAFT, #119 Future ideas OPEN/DRAFT, #106 ADHD Focus Guardian OPEN/DRAFT/NOT ACTIVE, #6 Spec Kit OPEN/DRAFT.

## EXACT CURRENT OPEN PROBLEM — ONE NOW
**Issue #121:** https://github.com/Essxm01/KONFRM/issues/121
Founder explicitly dislikes Screen03 new property card height: only around 1.5 cards appear on the screen. Suspects grouped facts/services badges and requests elegant compactness / progressive in-card disclosure to show useful comparisons WITHOUT requiring opening each property detail page. Hopes for more cards, mentioning ~3, but that is an approximate wish, not validated geometry.
**FOUR REAL SCREEN PHOTOS HAVE BEEN OFFERED BUT NOT YET RECEIVED. YOUR FIRST BRIDGE12 REQUEST: ASK FOUNDER TO SEND ALL FOUR. DO NOT SEND ANOTHER ANTIGRAVITY CODE PROMPT UNTIL YOU SEE THEM AND PROPOSE A DESIGN SOLUTION.**
Measure effects of photo ratio and cropping, header/pill/nav vertical budget, property title/location, duplicated unit type, rounded badges container and padding, nightly price, collapsed disclosures and scroll behavior. Show viable trade-offs: 3 complete high-photo cards may not be possible on phone without damage to readability/photo appeal. Preserve nightly amount, key facts, location and believable real images; experiment with 2–3 always-visible comparison facts + inline More, thinner/no redundant facts wrapper, tuned padding/image proportion. Refuse button clutter or jarring expansion changes.
Agent reported favorite icon surface 36dp; verify EFFECTIVE tap hit >=44dp and no card-tap collision. Red in-session heart/SnackBar is NOT proof of persisted favorite/auth backend. Search trigger still displays an honest Screen04 dependency notice; not functional full search yet. Real property photos should not be replaced by made-up stock imagery to hide quality issues.
Screen03 remains OPEN/UNMERGED; no final approval, no merge, no deploy before new genuine A56 physical UX review.

## NEXT SEARCH JOURNEY — ORDERED
[#122](https://github.com/Essxm01/KONFRM/issues/122): Screen04 UX contract and Founder review FIRST. Full-page route for advanced refine (dates, guests, type, price). Tapping main Screen03 search pill opens separate region multi-select Bottom Sheet, tapping filter/tune button opens full-page Screen04.
[#123](https://github.com/Essxm01/KONFRM/issues/123): execute Screen04 only after approved UX and API semantics.
[#124](https://github.com/Essxm01/KONFRM/issues/124): Screen05 results hybrid filter chips: tapping chip body edits filter, explicit × removes just that filter and refreshes honest results.
Current destination search is fuzzy SQL ILIKE across resort, region and address, NOT exact selectable canonical region membership. Do not fake exact multiple-region behavior or dynamic list; document narrow backend truth dependency [#130](https://github.com/Essxm01/KONFRM/issues/130).
[#125](https://github.com/Essxm01/KONFRM/issues/125): native customer auth, guest favorites, booking context continuation and end-to-end proof without fake auth, fake persistence or auto-submit.
Then finish approved Customer UI design, Owner mobile action-first UI design and Admin operational desktop UI design individually. Do not create identical navigation/information density for three roles.

## FOUNDER CONFIRMED STRATEGY: DESIGN-FIRST + DURABLE BACKEND DEFERMENT
2026-10-13 Founder explicitly reiterated: finish high-quality complete design across **PHASE 4 Design System, PHASE 5 Customer, PHASE 6 Owner, PHASE 7 Admin** and save NON-BLOCKING Backend technical repair/reconciliation work in durable backlog first.
This matches Founder-approved 2026-09-06 tasks/POST_PHASE_7_DEFERRED_CLOSURE.md. **AFTER Phase 7 and BEFORE Phase 8** revisit and close mandatory R2 → R3 → R4 → R5 with real proof.
R2: Owner financial analytics route, canonical data/authorization, no fake success and crash.
R3: Admin notification bell true counts, real action and empty/error states.
R4: Worker getOwnershipById mapping, CI tests, docs/secret scanning.
R5: final Customer/Owner/Admin interaction and security integration, exact Git/CI/live identity, false success/error checks.
Design admin forgot-password UX in Phase7 but do not simulate missing reset/email/token backend.
**Do not defer an active security breach or narrow Backend contract needed for truthful UI.** Historical doc mentions a previously exposed GitHub OAuth credential: triage whether revoked; urgent rotate if still active using authorized operator, never print/paste token. Separate [#131](https://github.com/Essxm01/KONFRM/issues/131).
Backlog register [#129 R2–R5](https://github.com/Essxm01/KONFRM/issues/129). Narrow API support [#130](https://github.com/Essxm01/KONFRM/issues/130). Do not convert DEFERRED to DONE.

## MEMORY & OPERATING QUEUE
[MASTER NOW/NEXT/LATER ISSUE #128](https://github.com/Essxm01/KONFRM/issues/128) created by Bridge11. #121 NOW, then #122 design, #123 implementation, #124 results, #125 auth dependency, #129 deferred Backend, #130 narrow essential API, #131 security, #126 ADHD Candidate and #127 Spec Kit separately.
One primary product execution lane. Record each new idea/known Backend debt in an existing issue (deduplicate) with source, impact on the three roles/backend/DB, prerequisites, state, owner decision and safe wake-up gate. Avoid orphaned chat-only decisions. ADHD Skill PR #106 contains a candidate Focus Guardian but is NOT installed or automatically monitoring anything.
At task start follow AGENTS.md, docs/INDEX.md, docs/CURRENT_STATE.md, tasks/CURRENT_TASK.md, docs/codex/KONFRM_MASTER_RULES.md, .agents/SKILL_ROUTER.md and selective product/design authorities. Current State/Task files on main may be stale (Screen07 old task), so verify live PRs/branches first. References include KONFRM_MASTER_PROJECT_CONTEXT.md, MASTER_RULES, DECISION_CONFLICTS, FOUNDER_AI_OPERATING_SYSTEM, FOUNDER_DEEP_OPERATING_PROFILE, EXECUTION_DEPENDENCY_ORDER, QUALITY_GATES, UI_QA_PROTOCOL, and Bridge10→11 prior handoff when accessible.
Repo is PUBLIC. Do not store secrets/private identifiers in Issues/handoff.

## TEST & FOUNDER APPROVAL GATES
Physical Samsung Galaxy A56 5G; real production-looking Flutter app with truthful API photos/prices; screen-width 360/390/430; font 130% and 200%; Cairo/RTL/bidi amount and ج.م; sticky/nav/safe area; valid >=44dp touch targets; Guest and logged-in boundaries; no fabricated badges/state. Flutter tests/analyzer green are not enough. Distinguish DESIGN APPROVED, IMPLEMENTED, MERGED and LIVE VERIFIED.

**FIRST BRIDGE 12 RESPONSE:** Briefly acknowledge receipt of this handoff FROM 11 TO 12; explain current Screen03 card compactness is STILL OPEN; request **the four photos**. Review images before giving precise UX options and a bounded Antigravity command. Do not re-open decisions or launch Screen04 prematurely. AFTER Founder visually approves Screen03 and authorized QA/merge gates, move to #122.
**END STATE:** FROM=BRIDGE_11; TO=BRIDGE_12; DATE=2026-10-13; NOW=SCREEN03_CARD_COMPACTNESS_PENDING_4_PHOTOS; PR120=OPEN_UNMERGED; DESIGN-FIRST=YES; R2-R5=AFTER_PHASE7_BEFORE_PHASE8; ADHD=NOT_ACTIVE.