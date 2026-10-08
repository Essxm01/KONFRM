# Active Task — QUALITY_EVIDENCE_MESH_STAGE_A

TASK_ID: QUALITY_EVIDENCE_MESH_STAGE_A
TASK_CLASS: CI_SECURITY_EVIDENCE_MESH_IMPLEMENTATION
STATUS: IMPLEMENTED / VALIDATED / READY_FOR_BRIDGE_REVIEW
PR: #104 (DRAFT - DO NOT MERGE)
HEAD_SHA: ec100ea241b312a02b3c1042795ecbc4876fe66b
BASE_MAIN_SHA: dd53b5dcb1d967dfdfabfea637dad2d2bf037540
BRANCH: feat/quality-ci-safety-stage-a
GOVERNING_SPEC: docs/agents/KONFRM_QUALITY_EVIDENCE_MESH_PILOT.md (Stage A)
SCOPE: Implement the first stage of the KONFRM Quality Evidence Mesh using `actionlint` and `zizmor`, under strict security, privacy, and repository isolation requirements.

## Boundaries Preserved
- ZERO SECRET ACCESS: No .env, credentials, API keys, tokens, or private environment variables read, printed, or exported.
- STRICT ISOLATION: Feature branch `feat/quality-ci-safety-stage-a` based on verified `origin/main` (`dd53b5dcb1d967dfdfabfea637dad2d2bf037540`).
- OUT OF SCOPE: Does NOT modify PR #102, PR #103, PR #99, `main`, production apps (`customer-app/`, `owner-app/`, `admin-app/`), backend logic, database/migrations, Cloudflare configuration, or business/financial Canon.
- NO DEPLOYMENT / NO AUTO-MERGE: Read-only `contents: read` GitHub token permissions; no push to production.
- NO CODEX REVIEWS: Codex reviews prohibited due to quota exhaustion.

## Closure Gates — Stage A
- [x] Phase 1 Security Audit: Complete inventory of CI jobs, triggers, permissions, and tool versions across existing workflows.
- [x] Phase 2 Implementation: Dedicated least-privilege workflow `.github/workflows/quality-evidence-mesh.yml` authored with pinned immutable action SHAs, read-only permissions, and clear PASS/FAIL/WARNING reporting.
- [x] Phase 2 Triage Configuration: Baseline configuration `.zizmor.yml` established to document legacy exceptions without weakening security policies for new or unexempted workflows.
- [x] Phase 3 Negative Test Verification (Verify the Verifiers):
  - [x] Negative Test 1 (`actionlint`): Proved intentional malformed expression in temporary fixture fails closed with non-zero exit code.
  - [x] Negative Test 2 (`zizmor`): Proved intentional insecure workflow (untrusted checkout/PR head) in temporary fixture fails closed with non-zero exit code.
  - [x] Tracked workflows audit: Both scanners run cleanly on actual tracked workflows under `.zizmor.yml` baseline.
- [x] Phase 4 Complete Validation:
  - [x] `npm run ai:skills:check` passed 100% (21/21 required artifacts verified, 0 defects).
  - [x] `npm run design:check` passed 100% (0 new drift).
  - [x] `git diff --check` passed (0 whitespace errors).
  - [x] `npm run ci:safety:check` passed 100% (4/4 test suites).
  - [x] Production isolation preserved.
- [x] Phase 5 Delivery: Committed, pushed to `origin feat/quality-ci-safety-stage-a`, and Draft PR #104 opened (`READY_FOR_BRIDGE_REVIEW / DO_NOT_MERGE`).

---

## Historical Task — PHASE_4I_MISSION_C_ANDROID_RUNTIME_INTEGRATION (Mission C — HISTORICAL / COMPLETED)

TASK_ID: PHASE_4I_MISSION_C_ANDROID_RUNTIME_INTEGRATION
TASK_CLASS: NATIVE_ANDROID_RUNTIME_VALIDATION
STATUS: HISTORICAL / COMPLETED (BRIDGE_ACCEPTED)
BASE_MAIN_SHA: 9c908d2756fba0d421e67959ecfbc13d0ca35f9b
BASE_MISSION_B_SHA: 82f98db300a15a9cf790dc8834e85c07670f38d4
MISSION_C_COMMIT_SHA: e3fa755cd5f2636c4e10ac55d6651ed58ccc3932
BRANCH: phase4i/android-runtime-validation
SCOPE: Physical Android device runtime validation (Samsung Galaxy A56 5G, Android 16 / API 36), visual/accessibility verification across 100%/125%/150%/200% text scaling, and bounded PrimaryButton layout/semantics hardening.

---

## Historical Task — PHASE_4I_MISSION_B_PRIMITIVES_AND_SCENARIOS (Mission B — HISTORICAL / COMPLETED)

TASK_ID: PHASE_4I_MISSION_B_PRIMITIVES_AND_SCENARIOS
TASK_CLASS: NATIVE_DESIGN_SYSTEM_IMPLEMENTATION
STATUS: HISTORICAL / COMPLETED (BRIDGE_ACCEPTED at 82f98db300a15a9cf790dc8834e85c07670f38d4)
PR: NONE (MERGED INTO MISSION C VALIDATION LINEAGE)
EXECUTION_STARTED: YES
BASE_MAIN_SHA: 9c908d2756fba0d421e67959ecfbc13d0ca35f9b
BASE_MISSION_A_SHA: 9f24b2bea5130faeaa05e39b204ef4c8abc7b464
MISSION_B_IMPLEMENTATION_COMMIT: f933900
MISSION_B_ACCEPTED_COMMIT: 82f98db300a15a9cf790dc8834e85c07670f38d4
BRANCH: phase4i/mobile-primitives-and-scenarios
SCOPE: Phase 4I Mission B — governed shared Flutter typography/primitives, accessibility/RTL semantics, representative validation scenarios and tests, and bounded Mission A/B documentation reconciliation.

## Historical Boundaries — Mission B
- Does not implement Customer/Owner production apps or routing.
- Does not modify Admin, backend, database, Supabase, Cloudflare, API contracts, business/finance/auth/booking/payment logic, token JSON, or Phase 5/6 implementation.
- Open values stay validation-reference-only and are not promoted to Canon.

## Historical Closure Gates — Mission B (`HISTORICAL / COMPLETED`)
- [x] Required package/app pub get, analyze, tests, formatting, Android APK build, repository design/governance checks, and diff check pass.
- [x] Package owns the single Cairo font source and validation app consumes it by package font semantics.
- [x] Flutter primitives, semantics, RTL/bidi, scaling tests, and catalog scenarios match Phase 4H contracts.
- [x] Production/backend/database/API/token JSON/Phase 5/6 forbidden paths remain untouched.
- [x] Mission B implementation `f933900` and closure `82f98db300a15a9cf790dc8834e85c07670f38d4` committed and Bridge-accepted on `phase4i/mobile-primitives-and-scenarios`.

---

## Historical Task — PHASE_4I_NATIVE_BOOTSTRAP_BASELINE (Mission A — HISTORICAL / COMPLETED)

TASK_ID: PHASE_4I_NATIVE_BOOTSTRAP_BASELINE
TASK_CLASS: NATIVE_MOBILE_INTEGRATION_BASELINE
STATUS: HISTORICAL / COMPLETED (MISSION_A_BASELINE_CREATED at 9f24b2bea5130faeaa05e39b204ef4c8abc7b464)
PR: NONE (MISSION_A_BASELINE)
EXECUTION_STARTED: YES
BASE_MAIN_SHA: 9c908d2756fba0d421e67959ecfbc13d0ca35f9b
BRANCH: phase4i/native-bootstrap-baseline
SCOPE: Minimum Flutter repository boundary, validation harness, package skeleton, Android toolchain check, and stable Codex interface contract.

## Historical Closure Gates — Mission A (`HISTORICAL / COMPLETED`)
- [x] Canonical starting base independently verified (`9c908d2756fba0d421e67959ecfbc13d0ca35f9b`).
- [x] Minimum `mobile/` boundary created (`mobile/packages/konfrm_design_system`, `mobile/apps/design_system_validation`).
- [x] Validation app created with Arabic RTL shell (`design_system_validation`).
- [x] `konfrm_design_system` package created with clean entrypoint.
- [x] Customer production Flutter app has NOT been created.
- [x] Owner production Flutter app has NOT been created.
- [x] Codex ownership paths and interface documented (`mobile/README.md`).
- [x] Approved Cairo font asset wired from repository source (`assets/fonts/`).
- [x] Dependencies resolve (`flutter pub get` on package and app).
- [x] Formatting clean (`dart format`).
- [x] Static analysis clean (`flutter analyze` on package and app: zero issues).
- [x] Legitimate tests pass (`flutter test` on package and app: 100% pass).
- [x] Android debug build succeeds (`flutter build apk --debug`).
- [x] Current State reflects merged Phase 4H and started Phase 4I.
- [x] Immutable baseline commit SHA produced: `9f24b2bea5130faeaa05e39b204ef4c8abc7b464`.
- [ ] A clean working-tree state at baseline creation is not attested by this Mission B checkout; pre-existing untracked workspace files remain excluded from Mission B.

---

## Closed Upstream Dependency — Phase 4H Component Contract & Reference Catalog
- **PHASE_4H_STATUS:** `CLOSED / MERGED / PUBLISHED`
- **PR:** `#98`
- **MERGE_COMMIT:** `9c908d2756fba0d421e67959ecfbc13d0ca35f9b`
- **Component Contracts:** 24 component families reconciled; shared authority formalized in `DESIGN_SYSTEM/COMPONENTS/`.
- **Reference Catalog:** Arabic RTL reference catalog published at `DESIGN_SYSTEM/PILOTS/component-contract-catalog-01/index.html`.
- **DF2:** `v1.7`
- **CHANGELOG:** `2.1.12`

## Closed Upstream Dependency — Phase 4G Content & State Presentation
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

## Historical Roadmap Transitions (`HISTORICAL / COMPLETED` — Superseded)
- **PHASE_4I_NATIVE_FLUTTER_FOUNDATION (Mission A & Mission B):** `HISTORICAL / COMPLETED` (`9f24b2bea5130faeaa05e39b204ef4c8abc7b464` -> `82f98db300a15a9cf790dc8834e85c07670f38d4`)
- **PHASE_4I_MISSION_C_ANDROID_RUNTIME_INTEGRATION (Mission C):** `HISTORICAL / COMPLETED` (`e3fa755cd5f2636c4e10ac55d6651ed58ccc3932`)

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
