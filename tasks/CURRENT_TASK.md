# Active Task — PHASE_4D_FORM_SELECTION_PRIMITIVES

TASK_ID: PHASE_4D_FORM_SELECTION_PRIMITIVES
ROADMAP_PHASE: PHASE_4_UNIFIED_DESIGN_SYSTEM
STATUS: READY_FOR_PUBLICATION
SUBSTANTIVE_STATUS: COMPLETE
FOUNDER_DECISION_STATUS: RECORDED
GOVERNANCE_SYNC_STATUS: COMPLETE
PUBLICATION_STATUS: PR_PENDING
BASE_MAIN_SHA: 3520ca0dd28c013a52a2b0cc15670eab1b974442
BRANCH: design/form-selection-pilot-01
SCOPE: Phase 4D — Form & Selection Primitives (text inputs, phone/email fields, search, select/pickers, checkbox/toggle where required, helper/error behavior, focus/keyboard behavior, and Arabic/RTL input details).

## Execution Position Notice
- `STATUS: READY_FOR_PUBLICATION` indicates that Phase 4D discovery, visual pilot, Founder decision recording, and shared governance synchronization are complete.
- `SUBSTANTIVE_STATUS: COMPLETE`
- `FOUNDER_DECISION_STATUS: RECORDED`
- `GOVERNANCE_SYNC_STATUS: COMPLETE`
- `PUBLICATION_STATUS: PR_PENDING`
- Publication PR is prepared against `main`. Do NOT mark CLOSED or MERGED until PR is merged.
- Next active design dependency after PR merge is **Phase 4E — Structural System** (`STATUS: NOT_STARTED`).

## Phase 4D Core Decisions & Governance Results
- **Field Visual Strategy:** **`OUTLINE_LED`** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). White surface, thin neutral outline, explicit persistent top label, separate helper/error, no floating-label dependency.
- **Mobile Field Radius:** **`8px`** (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`).
  - *Exact Scope:* Applies strictly to mobile field-shaped Form & Selection primitives: text input, phone container, email container, numeric container, search container, multiline textarea, select/picker trigger when rendered as a field.
  - *Deliberate Differentiation:* Primary Button retains 6px `PRIMARY_ONLY` provisional radius (Action = 6px; Data Entry = 8px). 8px does not apply to secondary buttons, checkboxes, toggles, chips, cards, sheets, or global shape.
  - *Evaluated Alternatives:* 6px and 10px recorded as evaluated alternatives, NOT selected for fields.
- **Focus Semantic Direction:** **`RESTRAINED_INTERACTION_ACCENT`** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). Provides obvious focus feedback without competing with Stable Black Primary CTA. Web pilot rendering values (`#276EF1`, 2px ring, 2px halo) are references only.
- **Selection Controls:** Checkbox is **`OWNER_PRODUCT_EVIDENCED`** (notification preferences); Toggle is **`DEFERRED_NO_CURRENT_PRODUCT_EVIDENCE`** (zero current canonical product evidence; no switch migration manufactured).
- **Select / Picker Primitive Boundary:** Phase 4D owns field trigger and field semantics; overlay containers, bottom sheets, dialogs, and picker navigation belong strictly to Phase 4F.
- **Platform Touch Sizing:** iOS guidance: 44pt; Android guidance: 48dp. Target bounds decoupled from visible geometry. No universal raw-pixel mobile target rule.
- **Preserved Open Variables:** Exact Neutrals (`OPEN`), Exact Blue (`OPEN`, candidate `#276EF1`), Exact Native Focus Treatment (`OPEN`), Exact Native Stroke Width (`OPEN`), Global Shape System (`OPEN`), Native Mobile Flutter Acceptance (`DEFERRED TO 4I`).
- **Production / Token Safety:** Zero runtime production changes (`customer-app`, `owner-app`, `admin-app`), zero backend/database changes, zero token JSON changes.

## Upstream Closed Dependency — Phase 4C Action System
- **PHASE_4C_STATUS:** `CLOSED / MERGED`
- **PR:** `#90`
- **MERGE_COMMIT:** `95e3789ae824cdc6ca0a6608f1752f3137ac5ac5`
- **Stage 2:** `CLOSED_INDEPENDENT_PASS`
- **Stage 3A:** `CLOSED_INDEPENDENT_PASS`
- **Stage 3B:** `CLOSED_INDEPENDENT_PASS`
- **Production Changes:** NONE
- **Token Changes:** NONE
- **Native Acceptance:** `DEFERRED_TO_4I`

## Next Dependency After 4D Publication Merge
- **PHASE_4E_STRUCTURAL_SYSTEM**
  - **STATUS:** `NOT_STARTED`
  - **EXECUTION_STARTED:** `NO`
  - Do NOT switch active task to Phase 4E until PR merges into `main`.

---

# Historical Reference (Preserved)

## Completed Phase 4C Checkpoint
- TASK_ID: PHASE_4C_ACTION_SYSTEM
- MERGED_PR: #90
- MERGE_COMMIT_SHA: 95e3789ae824cdc6ca0a6608f1752f3137ac5ac5
- STATUS: CLOSED / MERGED

## Completed Phase 4B Checkpoint
- TASK_ID: PHASE_4B_TYPOGRAPHY_FOUNDATION_CHECKPOINT
- MERGED_PR: #88
- MERGE_COMMIT_SHA: 4cad3a4b0f9901e5315c35e6712e3e4a35f4cba5
- STATUS: CLOSED / MERGED

# Phase 5 — Customer App Roadmap Tracking

TASK_ID: CUSTOMER_SCREENS_13_14_STAY_HUB_AND_DEPOSIT_PAYMENT
ROADMAP_PHASE: PHASE_5_CUSTOMER_EXPERIENCE
SEARCH_INTENT_RESET: DEFERRED / UNCHANGED
STAGE: LIVE_VERIFIED_COMPLETE
EXECUTOR: Founder + Bridge + UI/UX Design Lab
MERGED_SHA: 0d3a7f3b875e0e97c09cb6451d7c91af49340d6f
PR: #61

## Customer Screens Status Summary
- **Screens 08–10 (Customer Auth V2)**: MERGED & LIVE CLOSED (PR #50, PR #55, PR #56)
  - Screen 08 (Phone/Email Entry): Live verified with OTP challenge orchestration.
  - Screen 09 (OTP Verification & Timer): Live verified with cooldown & resend guarantees.
  - Screen 10 (Account Creation): Live verified with single-use continuation token.
- **Screen 11 (Booking Request Sent)**: MERGED & LIVE CLOSED (PR #57)
  - Dedicated full-screen confirmation surface with truthful post-submission lifecycle.
- **Screen 12 (My Bookings / حجوزاتي)**: MERGED & LIVE CLOSED (PR #58 + session-privacy closure)
  - Dedicated `BOOKINGS_TAB` Auth V2 origin with safe guest/expired flows.
  - Fail-closed private state on 401/403: clears `customerBookings`, `activeBooking`, `bookingDetailId`, `recentBookingSubmission`, and attention dot.
  - Real canonical bookings & complete status matrix without `مرفوض` on guest cancellation.
  - Accessible 44×44px refresh button & Screen 13 `booking.id` routing.
- **Screens 13 & 14 (Stay Hub & Deposit Payment)**: MERGED & LIVE CLOSED (PR #61)
  - Screen 13: dedicated full-screen stay hub with canonical booking data, lifecycle-aware presentation, property recognition, stay dates, guest count, state-aware financial summary, payment CTA when canonically eligible, hidden Bottom Navigation, no forbidden Owner direct-contact or cancellation CTAs, and no internal finance leakage.
  - Screen 14: production-grade deposit-payment entry with `متابعة إلى الدفع`, fail-closed provider-unavailable handling, resilient poll and expiry handling, zero prototype/demo/test wording, and `PROTECTED_PAYMENT` auth recovery.
- **Screen 15 (Favorites / المفضلة)**: MERGED & LIVE CLOSED (PR #64)
  - Dedicated Favorites surface with canonical server reads and mutations, explicit loading/empty/error/session states, protected same-property Auth resume, race-safe delete/undo behavior, responsive production verification, and no fabricated property or Favorite data.
- **Next Customer Design Target**:
  - Screen 16 — Notification Center — NOT STARTED

## Phase 5 / C4 (Screen 07) Closure Summary
- PR #35 merged into main at `2d27553569c7962e62080d7ab471d16ef1c9e435`.
- Screen 07 Booking Request Review and Safety Contract fully verified:
  - Truthful booking request lifecycle (طلب الحجز يُرسل إلى المالك → المالك يراجع الطلب → إذا وافق، يصبح دفع العربون هو الخطوة التالية → بعد نجاح دفع العربون يصبح الحجز مؤكدًا). No Owner-response SLA or duration is approved or stated.
  - Exact financial breakdown from calculation engine with zero client recalculation.
  - Fail-closed quote revalidation and price mismatch handling.
  - Zero payment collection / zero premature booking creation.
  - Founder physical preview passed on Samsung Galaxy A56.
  - All CI and production verification passed.

## Customer Screen 12 Live Verification Summary
- **Dedicated Auth V2 Origin (`BOOKINGS_TAB`)**:
  - Guest taps "حجوزاتي" -> Screen 12 renders clean Guest state with heading `سجّل الدخول لعرض حجوزاتك`.
  - Tapping "تسجيل الدخول" opens Auth V2 with origin `BOOKINGS_TAB` and intent `LOGIN`.
  - Cancelling Auth V2 returns directly to Screen 12 on tab "حجوزاتي" in Guest state.
- **Session Expired State**:
  - HTTP 401 on `/api/v1/customer/bookings` safely triggers `CustomerBookingsUnauthorizedError`.
  - Renders high-contrast amber session expired card: `انتهت جلسة تسجيل الدخول` with CTA `تسجيل الدخول مجددًا`.
  - Fails closed: clears all private bookings, active booking, detail modal ID, and recent submission banner.
- **True Empty State**:
  - Authenticated customer with 0 bookings renders `لا توجد حجوزات بعد` with subtext and CTA `استكشف الإقامات`.
  - Tapping `استكشف الإقامات` switches active tab to `استكشف`.
- **Real Canonical Bookings & Status Matrix**:
  - Live customer `+201049892908` loaded canonical bookings `BK-183223` and `BK-908747`.
  - Bookings rendered under section `السابقة` with badge `ملغي من جانبك` and icon `CircleSlash2`.
  - Absolute status truth: strictly prohibits `مرفوض` or `لم يوافق المالك` for cancellations.
  - Section `يحتاج إجراء منك` conditionally omitted when no `APPROVED_PENDING_PAYMENT` bookings exist.
- **Bottom Navigation Attention Dot**:
  - KONFRM Blue `#0059FF` dot (no green, no pulse) only active when `APPROVED_PENDING_PAYMENT` is present.
  - Correctly evaluated to `false` during live verification.
- **Single Clickable Card Surface & Screen 13 Integration**:
  - 44×44px accessible refresh button (`aria-label="تحديث الحجوزات"`).
  - Clicking card routes to Screen 13 `BookingDetailModal` by `booking.id`.
  - Closing Screen 13 cleanly restores Screen 12 without reload.
- **Responsive Visual Integrity**:
  - Multi-viewport screenshots saved and visually inspected:
    - `screen12_live_360x800.png` (Compact Android)
    - `screen12_live_390x844.png` (iPhone 14/15 standard)
    - `screen12_live_430x932.png` (iPhone Pro Max)
    - `screen12_live_guest.png` (Guest state)
    - `screen12_live_session_expired.png` (Session expired state)
    - `screen12_live_empty_state.png` (True empty state)


## Phase 3 closure verdict

`PHASE_3_LIVE_CLOSED`

The approved Phase 3 same-entity property vertical slice is complete and live-verified.

Live trace property:
`9927b705-7b9d-4f4c-a7cf-903c4a330ae2`

Verified flow:

1. Owner created the disposable QA property.
2. Owner uploaded real media through the standard property media flow.
3. Owner submitted the property for review.
4. Admin queue showed the same property ID.
5. Admin Detail loaded the same canonical property and media.
6. Admin approved it.
7. Canonical persisted state became `PUBLISHED + VERIFIED`.
8. The existing Owner session revalidated the same property without browser reload or re-authentication and showed the published state.
9. Customer Explore returned the same property.
10. Customer Detail fetched the same property ID and rendered canonical description, amenities, images, price, capacity, location, type, and applicable house rules without fabricated fallbacks.

The disposable QA property was archived afterwards through the standard Owner API.

## Phase 3 implementation outcomes

### Task 3.9 — Owner external-state revalidation

Closed.

- Property-scoped revalidation only.
- No broad multi-domain refresh requirement.
- Focus / visibility revalidation supported.
- Revalidation failure remains visible and retryable.
- Out-of-order response protection prevents an older request from overwriting newer canonical state.

### Task 3.11 — Customer canonical Property Detail

Closed.

- `GET /api/v1/customer/properties/:id` is the canonical detail source.
- Required canonical detail payload is validated fail-closed.
- Canonical empty images remain authoritative.
- Location does not fall back to stale Explore data after detail success.
- Canonical capacity drives guest limits.
- Canonical unit/property type, description, amenities, images, and persisted house-rule content are rendered truthfully.
- Loading/error/retry states remain explicit.

## Phase 3 publication evidence

- PR #19 merged into `main`.
- Phase 3 main SHA: `9ef59f64008db16df0386ac92c5d64bfc8c73b58`.
- Main CI run `34007323794`: `completed / success`.
- Owner, Customer, Admin, and Backend validation jobs succeeded.
- Cloudflare Worker deployment step succeeded.
- Live vertical slice result: `PHASE_3_LIVE_PASS`.

## Boundaries preserved

- No database schema change.
- No migration or RPC change.
- No booking, availability, or finance business-rule change.
- No architecture change.
- No broad Phase 4–7 UI redesign was introduced into Phase 3.

---

# Founder Phase 4 Entry Decision — 2026-09-06

The previous next gate was:

`STOP_BEFORE_PHASE_4`

That stop was intentionally waiting for explicit Founder continuation and UI/UX Design Lab / LAP entry.

The Founder has now explicitly resumed the program and authorized Phase 4 entry.

Current gate:

`PHASE_4_ENTRY_AUTHORIZED`

Meaning:

- Phase 4 may begin.
- LAP formally joins the Phase 4–7 design program.
- Bridge remains responsible for protecting architecture/business/finance rules and translating approved design into safe implementation packages.
- R2–R5 from the Pre-Phase-4 remediation plan are **deferred, not closed**.
- Their mandatory return point is after Phase 7 and before Phase 8.
- The canonical deferred closure contract is `tasks/POST_PHASE_7_DEFERRED_CLOSURE.md`.

Do not re-block Phase 4 merely because older remediation text required R5 before Phase 4; the Founder explicitly changed the execution timing while preserving the deferred obligations.

## Immediate next work

1. **Phase 4 UX Test Lane (`PHASE_4_UX_TEST_LANE`):** `LIVE_PROVISIONED_READY`.
   - Complete isolated test lane provisioned for `P4_UX_CUSTOMER`, `P4_UX_OWNER`, and `P4_UX_ADMIN`.
   - Real-behavior fixtures: Property A (Published), Property B (Pending Review in Admin Queue), Availability Block, and Booking Request.
   - Credentials secured locally in Windows Credential Manager (`KONFRM/UXTL/P4/*`); zero secrets in git.
   - Specification and tooling guide: [`tasks/PHASE_4_UX_TEST_LANE.md`](./PHASE_4_UX_TEST_LANE.md).
2. Begin the Phase 4 Unified Design System / UI/UX Design Lab × Bridge kickoff under the approved design operating contract using the active UX Test Lane for auditing and evaluation.

Do not automatically implement new functional/business capabilities discovered by design. Record them as dependencies/deferred opportunities unless the Founder explicitly pulls them forward.
