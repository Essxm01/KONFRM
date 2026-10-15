# KONFRM — Bridge 14 NEW CHAT HANDOFF | DESIGN-FIRST / Screen 15 Favorites

**Effective Founder decision:** 2026-10-15, Africa/Cairo.  
**Audience:** The successor ChatGPT conversation named **«محادثة الجسر 14»** and Antigravity coordinators.  
**Read in order:** (1) THIS file; (2) [KONFRM_BRIDGE_LIVE_HANDOFF.md](KONFRM_BRIDGE_LIVE_HANDOFF.md), reading its **LATEST** dated addendum first; (3) CURRENT GitHub Issues [#166](https://github.com/Essxm01/KONFRM/issues/166), [#165](https://github.com/Essxm01/KONFRM/issues/165), [#163](https://github.com/Essxm01/KONFRM/issues/163), [#155](https://github.com/Essxm01/KONFRM/issues/155) and queue [#128](https://github.com/Essxm01/KONFRM/issues/128); (4) latest actual GitHub branch/commit heads. Older text below the newest dated addenda is HISTORY and cannot override the new Founder decisions.

## 1. FOUNDER'S NEW HIGHEST-PRIORITY WAY OF WORKING (DO NOT LOSE THIS)

Founder explicitly said:
> «مش عاوز ألف في دايرة مراجعات ما بتخلصش ... لو التصميم تمام خلاص احفظ، أجل كل حاجة تانية ... واحفظها على جيت هب وادخل في السكرين اللي بعدها.»

Then clarified:
> «مش عاوزين نضيع كل الوقت على التصليحات انا عاوز اركز على التصميم واي حاجة تانية عادي ممكن نصلحها طالما هتساعد معانا في التصميم لكن اي حاجة ممكن متأثرش علينا وممكن نأجلها اكتبها واحفظها في التأجيلات على جت هب».

**Binding interpretation:** This phase is about **great native Customer mobile UI/UX, screen by screen**. Do not repeatedly reopen an accepted visual screen because engineering/integration/mock tests/evidence perfection are unfinished. Fix a problem NOW only if it **actually changes the user-visible experience, truthful UI, ability to accurately preview/evaluate the design, basic physical interaction, or immediate privacy/safety**. Minor isolated technical adaptations that unblock design are allowed. Record all other deficiencies explicitly in GitHub as deferred issues with the exact finding, evidence, suggested fix, required future gate, and impact; move on. Do not erase or forget them.

**IMPORTANT non-waiver:** This is NOT permission to deploy a vulnerable implementation or mark financial/auth/booking integration safe. Material production security, transaction-integrity, privacy and finance concerns can be parked **for integration/release** while next screen **design** advances; they remain **MANDATORY BLOCKERS before production adoption/merge/live**. Never show fabricated payment confirmation, false availability/financial guarantees or other untrue customer-facing UI merely to expedite design. New user-visible P0 is fix-now (bounded), not silently deferred.

Full operating decision: [#166 — Founder Design First](https://github.com/Essxm01/KONFRM/issues/166).

### Simple decision test for future Bridge
- **FIX NOW:** The actual screenshot/UI is wrong, incoherent, hard to read or tap, shows developer controls, contains unapproved financial statements, customer-visible security issue, or cannot faithfully demonstrate the intended UX. Solve only the smallest relevant issue without changing architecture/business rules.
- **DEFER TO GITHUB:** Backend/Supabase/DB, payment gateways, live financial reconciliation, genuine booking/Auth/E2E, production navigation, integration security hardening, wider CI and nonessential test/evidence exhaustive coverage, cosmetic dev-overlay details that don't affect customer UI, old duplicated/incorrect scenario evidence, overbroad refactors. Include release gate; do not claim verified.
- **REVIEW CADENCE:** One substantive visual review. One focused visual correction when genuinely necessary; avoid V2/V3/V4 loops for non-visual perfection. Founder holds final visual decision. Capture necessary genuine physical A56 evidence with truthful source/test claims; no fake tests/screenshots.

## 2. CURRENT FOCUS: SCREEN 15 = «المفضلة» / FAVORITES — CUSTOMER NATIVE FLUTTER

**NOW:** [#165](https://github.com/Essxm01/KONFRM/issues/165) is **Founder-authorized and already dispatched to Antigravity** by Founder. **Do NOT create a duplicate work order, tell Founder to resend the same prompt, or reopen Screen14 first.** At snapshot time, Antigravity has NOT yet delivered a Screen15 native Flutter package in this conversation; wait for its handoff or inspect the live GitHub task if later updated. The authorization is for native **isolated visual design** only, not for production integration.

**CURRENT canonical 26-screen Customer UX inventory**: [KONFRM_EXECUTION_TASKS.md](https://github.com/Essxm01/KONFRM/blob/main/KONFRM_EXECUTION_TASKS.md) §4.1 maps #14 Deposit Payment, **#15 Favorites**, #16 Notification Center. [Screen contracts draft](https://github.com/Essxm01/KONFRM/blob/main/KONFRM_EXECUTION_TASKS_SCREEN_CONTRACTS_DRAFT.md) §15 (lines ~159–167) explains: saved properties collection, Favorites tab / property heart, open Property Details Screen06, remove/un-remove saved state, auth gate for guest, genuinely empty/loading/error/session cases, current eligible property truth. A saved property is NOT a booking or held inventory.

**DON'T CONFUSE OLD NUMBERING:** Legacy [SOLA_EXECUTION_TASKS.md](https://github.com/Essxm01/KONFRM/blob/main/SOLA_EXECUTION_TASKS.md) calls Screen15 `Booking Details — Confirmed`, now obsolete for the 26-screen native plan. The current inventory consolidates old booking status screens into current Screen13. Historical Screen17 Favorites maps to **current Screen15**.

**DON'T REBUILD THE WRONG APP:** Existing React Customer Web has Favorites source [CustomerFavoritesScreen.tsx](https://github.com/Essxm01/KONFRM/blob/main/customer-app/src/components/CustomerFavoritesScreen.tsx) + [customerScreen15Favorites.ts](https://github.com/Essxm01/KONFRM/blob/main/customer-app/src/utils/customerScreen15Favorites.ts); `tasks/CURRENT_TASK.md` historically claims Web Screen15 PR #64 merged/live. This is a useful **observed implementation reference**, NOT a claim Flutter Screen15 has been visually approved, shipped, or integrated. Antigravity should inspect it for behaviors and adapt visuals into native Flutter in Cairo/RTL/black-white first style.

**Screen15 visual quality gate:**
- Beautiful, calm, clear Arabic RTL mobile layout aligned with Screens12/13/14 approved direction, correct Customer bottom tabs (Explore / Favorites / Bookings / Account), Favorites active; avoid card soup and developer chrome.
- Main saved-property cards feel trustworthy; heart selected/unselected & reversible action; open original listing details; clear friendly empty state and Explore CTA; guest Auth entry (preserving action); loading/error/expiry distinct if relevant to rendering.
- Reproduce essential states in an **isolated Flutter preview**; test genuinely relevant taps/scroll at normal and larger text on Samsung A56. No invented favorites inventory, real-time prices, hold guarantee, backend call, or false claims.
- Collect enough authentic photos to decide visual design. A runnable preview and concise honest report, actual SHA/URLs. Founder visual signoff remains separate. Do not demand an exhaustive state-matrix or production-grade integration to approve appearance.

**NEXT after Screen15 if subsequently authorized:** Screen16 **Notification Center**, NOT direct post-payment success as screen number 15.

## 3. SCREEN 14 ALREADY CLOSED VISUALLY — DO NOT START ANOTHER ROUND

**Founder explicit decision:** `SCREEN14_V3_FINAL_FOUNDER_VISUAL_APPROVED_ONLY__TECHNICAL_QA_DEFERRED`. Bridge independently inspected the real V3-final visual companions and accepted their **visual core** against V1 and approved Screen12/13. Founder explicitly ordered the design to be frozen and technical issues parked. Do not ask permission again or restart design V4. This is **not** authorization to treat payment mocks as production-safe.

**FROZEN visual source and evidence:** [b5963d849023edfd0318b5d47da41595f131617d](https://github.com/Essxm01/KONFRM/commit/b5963d849023edfd0318b5d47da41595f131617d) — `review-evidence/customer-screen14/v3-final/`. Previous immutable predecessors: original V3 [5d9cfd05447670a662c6685468d00669945bb90d](https://github.com/Essxm01/KONFRM/commit/5d9cfd05447670a662c6685468d00669945bb90d), corrective V3 [583b23ca6a90f42038cfa121c739429442643da6](https://github.com/Essxm01/KONFRM/commit/583b23ca6a90f42038cfa121c739429442643da6). Earlier V1/V2 retained as well.

**Technical/Evidence issues are parked NON-BLOCKING FOR DESIGN in** [#163](https://github.com/Essxm01/KONFRM/issues/163): (a) Scenario 01/02 screenshots and companions identical hashes, so `02` not distinct scrolled evidence; (b) financial `responseRevision` accepted without monotonic freshness; (c) 18/18 tests reported by Antigravity, but widget tests do not exercise rejected payment injection end-to-end; (d) future payment/provider/bookings/auth status, idempotency, session isolation, no double charge, cross-role truth, real 12→13→14 navigation, OS accessibility/release gates; (e) MR15 amount timing/method remains unresolved. **Return at integration stage, not current visual design.** Never call any unverified production path 'tested' merely because isolated mock tests passed.

**Other archived integration QA:** Screen12 [#150](https://github.com/Essxm01/KONFRM/issues/150), Screen13 [#152](https://github.com/Essxm01/KONFRM/issues/152). These also must NOT stall the next native screen design.

## 4. EVIDENCE, AUTHORITY, AND ANTI-DRIFT

- [#155 GLOBAL EVIDENCE RETENTION](https://github.com/Essxm01/KONFRM/issues/155): retain **ALL** screenshots, PNG/B64 companions, code/runners, reports, rejected/approved versions from Customer/Owner/Admin until final entire-app assembly/export AND explicit specific Founder cleanup approval. No delete/prune/trash/force-push/broad `rm -rf`. [#156](https://github.com/Essxm01/KONFRM/issues/156) is independent authorized audit/recovery, not priority to block Screen15.
- No Flutter production `mobile/apps/customer_app/lib/` edits based solely on frozen preview; no backend/Supabase/DB/Paymob/Auth/payment gateway/real money, cross-app design tokens, financial logic, business rule, merge or deploy without relevant new approval.
- MR-13 = first-night deposit, **NOT** arbitrary percentage. MR-15 = unresolved remainder rules, no invented timing or cash on arrival. Server authoritative for eligibility, status, prices, permissions, and money.
- A screenshot in a React web app or a Flutter prototype is not proof of mobile production integration. `main`, feature PR, evidence branch, docs branch, live deployment and actual A56 screenshots are distinct.
- If source conflicts: most recent **explicit Founder directive** + approved current 26-screen inventory and master rules override historical 18-screen `SOLA_EXECUTION_TASKS.md`, stale #128 text, and older bridge handoff snapshots. Re-verify GitHub changes.

## 5. BRIDGE14 OPERATING PERSONALITY AND RESPONSE MODE

You are the independent KONFRM Bridge product/UX/technical reviewer, **NOT** the coding executor. Antigravity implements/tests/GitHub. Speak to nontechnical Founder in straightforward Egyptian Arabic, explain bottom-line before code jargon, avoid repetitive clarifications, and draft precise Antigravity instructions grounded in actual files. Read reports critically, inspect essential **actual screenshots** when design review is requested, inspect related code for UI truth; a green Build/CI or a boast about 100% tests isn't design acceptance. Focus on Customer role emotional expectations (clarity, calm, trust, ease, no confusing money promise) while respecting different Owner/Admin roles and shared backend/business rules.

Upon next Antigravity Screen15 delivery: validate repo SHA/source & real images; prioritize **visual decision**. If real UX defect: one bounded corrective prompt. If backend/security/release-only: add/append GitHub deferred issue (cite exact evidence) then advance. Do not create another endless correction loop, and do not launch Screen16 until authorized/next design decision. Founder already approved starting Screen15; do not ask again.

## 6. Handoff status

`BRIDGE14_DESIGN_FIRST__SCREEN14_VISUALLY_FROZEN__SCREEN15_FAVORITES_IN_PROGRESS_WITH_ANTIGRAVITY__NONVISUAL_QA_DEFERRED_TO_GITHUB`.

**Important accuracy:** “IN PROGRESS” means the Founder dispatched Screen15 instructions; no Screen15 design/real A56 evidence has been independently delivered or accepted in this handoff yet. This document does NOT assert Antigravity finished Screen15 or that any Flutter native Screen15 is Live.
