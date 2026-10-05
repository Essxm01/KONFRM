# Active Task — PHASE_4H_COMPONENT_CONTRACT_CATALOG

TASK_ID: PHASE_4H_COMPONENT_CONTRACT_CATALOG
TASK_CLASS: DESIGN_SYSTEM_FOUNDATION_PHASE
STATUS: READY_FOR_BRIDGE_REVIEW
PR: #98
EXECUTION_STARTED: YES
BASE_MAIN_SHA: bb4534fc9edbb3b44ab6431c259f115220e7fbf9
BRANCH: design/component-contract-catalog-01
SCOPE: Phase 4H Component Contract & Reference Catalog — Turn validated Phase 4A–4G decisions into consumable, role-aware component contracts with state matrix, RTL/Bidi behavior, accessibility behavior, role differences, reference catalog, and permitted/open values register.

## Boundaries
- Does NOT start Phase 4I (Native Flutter Foundation).
- Does NOT implement Flutter components or initialize Flutter workspace.
- Does NOT modify production applications (`customer-app/`, `owner-app/`, `admin-app/`).
- Does NOT modify token files (`DESIGN_SYSTEM/TOKENS/*.json`) or backend/database/API contracts.
- Does NOT invent Product behavior, financial rules, or status enums.
- Preserves upstream closed decisions: Cairo Profile B typography (4B), Stable Black `#000000` + 6px Primary Button (4C), Outline-Led + 8px Field radius + Restrained Interaction Accent (4D), Role-Aware Hybrid Structural System + 12px Structural Container radius + 16px Page Insets + 4/8/12/16/24/32 spacing scale (4E), Role-Aware Contextual Navigation & Overlays + 16px Sheet Radius + 12px Dialog Radius + DF2 v1.5 + CHANGELOG 2.1.10 (4F), Role-Aware Layered State System + Four-Layer State Delivery + Canonical Domain Status Mappings + DF2 v1.6 + CHANGELOG 2.1.11 (4G).
- Preserves non-negotiables: ERROR != EMPTY; FAILED_QUERY != FAKE_ZERO; NORMAL_PENDING != WARNING; STALE != CURRENT; UNAUTHORIZED != GENERIC_ERROR; CONFLICT != SILENT_SUBMISSION; CRITICAL_FAILURE != TOAST_ONLY; DUAL_BOTTOM_CHROME PROHIBITED; OWNER_BOTTOM_NAV PROHIBITED; exact semantic colors OPEN; exact neutrals OPEN; exact blue OPEN; exact shadows OPEN; toast duration OPEN; native acceptance DEFERRED TO 4I.

## Closure Gates
- [x] Component inventory & gap analysis documented (`COMPONENT_INVENTORY.md`, `CONTRACT_GAP_ANALYSIS.md`).
- [x] Component contract schema & master matrix documented (`COMPONENT_CONTRACT_MATRIX.md`, `OPEN_VALUES_REGISTER.md`).
- [x] Master component state matrix & product truth dependency matrix documented.
- [x] Role difference matrix & RTL / Accessibility contracts documented.
- [x] Reference catalog built (`DESIGN_SYSTEM/PILOTS/component-contract-catalog-01/index.html`).
- [x] Visual evidence captured and inspected (`EVIDENCE_MANIFEST.md`, `evidence/*.png`).
- [x] Cross-component consistency audit completed.
- [x] Phase 4I native validation handoff matrix defined.
- [x] Shared component contracts reconciled / formalized in `DESIGN_SYSTEM/COMPONENTS/`.
- [x] Deterministic checks passed (`npm run design:check`, `npm run ai:skills:check`, `node scripts/test-design-court-contract.mjs`, `git diff --check`).
- [x] Publication PR created (`#98`).
- [x] Phase 4I status remains strictly `NOT_STARTED`.

---

## Closed Upstream Dependency — Phase 4G Content & State Presentation System
- **PHASE_4G_STATUS:** `CLOSED / MERGED / PUBLISHED`
- **PR:** `#97`
- **MERGE_COMMIT:** `bb4534fc9edbb3b44ab6431c259f115220e7fbf9`
- **Architecture Model:** `ROLE_AWARE_LAYERED_STATE_SYSTEM` (`SYSTEM-EVALUATED PROVISIONAL`).
- **State Delivery:** `FOUR_LAYER` (Identify: StatusBadge; Explain: InlineText; Recover/Block: SectionAlert/ScreenState; Transient Confirm: Toast).
- **Core Invariants:** `ERROR != EMPTY`, `FAILED_QUERY != FAKE_ZERO`, `NORMAL_PENDING != WARNING`, `STALE != CURRENT`, `CONFLICT != SILENT_SUBMISSION`, `CRITICAL_FAILURE != TOAST_ONLY`.
- **Domain Status Mappings:** Property lifecycle, Property verification, Booking lifecycle, Payment transactions, Wallet balance buckets, Payout requests, Owner KYC Identity (`owners.verification_status`), Owner verification documents (`owner_verification_documents.status`).
- **DF2:** `v1.6`
- **CHANGELOG:** `2.1.11`

## Closed Upstream Dependency — Phase 4F Navigation & Overlay System
- **PHASE_4F_STATUS:** `CLOSED / MERGED / PUBLISHED`
- **PR:** `#96`
- **MERGE_COMMIT:** `2385cd13a078aedc1f40769af5b394eed1210c00`
- **Architecture Model:** `ROLE_AWARE_CONTEXTUAL` (Customer 4-tab roots + Screen 16 Account-shell exception; Owner action-first nested with no bottom nav).
- **Bottom Sheet Top Radius:** `16px` (`SYSTEM-EVALUATED PROVISIONAL`).
- **Dialog Surface Radius:** `12px` (`SYSTEM-EVALUATED PROVISIONAL`).
- **DF2:** `v1.5`
- **CHANGELOG:** `2.1.10`

## Closed Upstream Dependency — Phase 4E Structural System
- **PHASE_4E_STATUS:** `CLOSED / MERGED / PUBLISHED`
- **PR:** `#95`
- **MERGE_COMMIT:** `ff4ac0b4322b8a7c50273dd7a459a93dcf090551`
- **Structural Model:** `ROLE_AWARE_HYBRID` (Customer open editorial default; Owner operational grouping default).
- **Mobile Structural Container Radius:** `12px` (`SYSTEM-EVALUATED PROVISIONAL`).
- **Mobile Page Horizontal Insets:** `16px` (`SYSTEM-EVALUATED PROVISIONAL`).
- **Relational Spacing Scale:** `4 / 8 / 12 / 16 / 24 / 32 px` (`SYSTEM-EVALUATED PROVISIONAL`).
- **Surface Elevation:** Flat default; elevation reserved for overlays.

## Closed Upstream Dependency — Design Court v1 (Governance Infrastructure)
- **STATUS:** `CLOSED / MERGED / PUBLISHED`
- **PR:** `#93`
- **MERGE_COMMIT:** `674194e675731985b347d241d046f6acc48cf785`
- **Infrastructure:** `konfrm-design-court` is available as cross-cutting governance infrastructure (14 governed design skills, 8 internal).

## Closed Upstream Dependency — Phase 4D Form & Selection Primitives
- **PHASE_4D_STATUS:** `CLOSED / MERGED / PUBLISHED`
- **PR:** `#92`
- **MERGE_COMMIT:** `0134f60984d5d52f3442ef49763bf6c75a564214`
- **Field Strategy:** `OUTLINE_LED` (white surface, thin outline, explicit top label).
- **Mobile Field Radius:** `8px` (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL`).

## Closed Upstream Dependency — Phase 4C Action System
- **PHASE_4C_STATUS:** `CLOSED / MERGED`
- **PR:** `#90`
- **MERGE_COMMIT:** `95e3789ae824cdc6ca0a6608f1752f3137ac5ac5`
- **Action Strategy:** `CONTEXTUAL_HIERARCHY_HYBRID`.
- **Primary Button Radius:** `6px` (`PRIMARY_ONLY`).
- **Primary Color:** Stable Black `#000000`.

## Next Roadmap Dependency (after 4H)
- **PHASE_4I_NATIVE_FLUTTER_FOUNDATION**
  - **STATUS:** `NOT_STARTED`
  - **EXECUTION_STARTED:** `NO`

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
