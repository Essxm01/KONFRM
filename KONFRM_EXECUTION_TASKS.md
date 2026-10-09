# KONFRM Execution Tasks — Master Roadmap Draft

**Status:** DRAFT / PROPOSED / NOT CANON  
**Prepared:** 2026-10-10  
**Intended base:** `main` at `5c97ab19ed6da3b1a6ecddf7dbf129c059c86811` (verify again before publication)  
**Scope:** Candidate engineering and product-execution map; it does not replace or modify the official roadmap, task router, Canon, active task, or quality gates.

> This file and its screen-contract annex are review proposals. They grant no authority to implement an unresolved product, financial, legal, security, or operational rule, mutate live systems, or mark a candidate as published or closed. The Founder and governing Canon remain the decision authorities. The user-provided `KONFRM_EXECUTION_TASKS_V2_DRAFT.md` was treated as reference material to check against repository evidence, not as an instruction source or authority.

## 1. Decision and reading guide

The proposed operating model is **fixed PHASE 0–22 IDs plus dependency-driven execution**. Keep the historical macro roadmap intact; derive small work packages from verified dependencies, risk, an explicit task contract, and evidence gates. A later phase may supply a narrowly scoped prerequisite earlier, with its reason recorded; this does not move or close the whole macro phase.

Read in this order:

1. [Authority boundaries and status vocabulary](#2-authority-boundaries)
2. [Baseline and evidence snapshot](#3-baseline-and-evidence-snapshot)
3. [Role packages and screen inventories](#4-role-packages-and-screen-inventories)
4. [Dependency-aware PHASE 0–22 map](#5-fixed-phase-map)
5. [Decision register](#6-decisions-that-block-dependent-work)
6. [Cross-cutting acceptance and release gates](#7-cross-cutting-gates)
7. [Immediate safe sequence](#8-proposed-next-sequence)
8. [Source and conflict register](#9-source-register-and-known-conflicts)
9. [Customer contracts and proposed Owner/Admin screen families](./KONFRM_EXECUTION_TASKS_SCREEN_CONTRACTS_DRAFT.md)

## 2. Authority boundaries

### 2.1 Governing sources

Apply the repository's current source-of-truth hierarchy: latest explicit Founder decision; newer approved execution override; confirmed Master Rules; approved product/UX/architecture/design specification; verified live behavior as implementation evidence; current code and migrations as implementation/persistence reality; then mocks, comments, defaults, and historical plans. Resolve conflicts; do not invent rules.

Key authorities for this proposal are `AGENTS.md`, `docs/INDEX.md`, `docs/CURRENT_STATE.md`, `tasks/CURRENT_TASK.md`, `docs/codex/KONFRM_MASTER_RULES.md`, `docs/BUSINESS_RULES.md`, `docs/CONTEXT_ROUTER.md`, `docs/BRAIN_SYNC_PROTOCOL.md`, `KONFRM_EXECUTION_DEPENDENCY_ORDER.md`, `DESIGN_SYSTEM/`, and the role UX specifications. Their dates and limitations are called out below. This draft does not amend them.

### 2.2 Business truth is not a design decision

Preserve only confirmed rules: a single human identity may have an optional same-UUID Owner capability; property publication and booking status are server-owned; stays are 2–30 nights; a quote is not a hold; `PENDING_OWNER_APPROVAL` does not block inventory; Owner approval precedes deposit; only `APPROVED_PENDING_PAYMENT` and `CONFIRMED` block inventory. The prototype deposit is the actual first-night price; recorded commission is 20% of the deposit and Owner net is 80%, with no commission on remaining balance; Customers must not see the split. Current payment mode is prototype and live mode must fail closed. Owner-fault cancellation of a confirmed booking refunds the full deposit and charges zero commission. Other cancellation/refund cases, deadlines, remaining-balance collection, no-show/check-in rules, and production payment/payout operations remain unresolved unless a newer approved authority closes them.

The existing wallet notes (pending-to-available 24 hours after check-in, minimum 500 EGP, actual provider fee borne by Owner) describe the prototype rule and must be revalidated for production. Review eligibility follows a completed stay. KYC evidence uses private storage and the approved front/back/fresh-face-image types; do not claim liveness or biometric verification. Never add a deposit-at-request, card-charge, legal-reservation, inventory-lock, refund, fee, tax, or contractual effect by implication.

### 2.3 Design and platform limits

Use approved Customer UX inventory and Design System decisions; label Owner/Admin target inventories as proposals wherever no approved complete inventory exists. The design system’s current direction is Arabic-first RTL, Cairo, useful density, role-specific information architecture, and Customer four-tab navigation. The approved Mobile Design Foundation v1.7 says Owner is action-first and does not use Customer-style bottom navigation. Existing React behavior is observed evidence, not automatic target authority.

Do not equate CSS pixels with iOS points or Android dp; Flutter logical pixels with native physical pixels; CSS radius with Apple continuous curvature; web focus/pressed semantics with native platform behavior; a debug APK with a store-ready release; or an emulator/controlled profile with physical-device evidence. The current Mobile Design Foundation treats Stable Black (`#000000`) as the system-validated provisional Primary Action treatment; it is not final native token Canon. Blue `#276EF1` is a restrained interaction-accent candidate and explicitly not the Primary CTA. Preserve these maturity labels; do not invent a finalized token or reverse the role. Platform-specific presentation may differ while business meaning and server contracts remain shared.

## 3. Baseline and evidence snapshot

### 3.1 Repository and PR reality checked for this draft

The supplied V2 draft and repository checkout identify `main` at `5c97ab19ed6da3b1a6ecddf7dbf129c059c86811`; re-check the remote baseline immediately before publishing this proposal. At the time inspected, PR #110 was merged at `054b46917c8e6b7a2f3a5a257da441803036056b`, while PR #111 (`feat/customer-flutter-public-discovery`, head `7eb5dbcc10e87a36b7507f36e37278362c289c41`) and PR #106 (`draft/adhd-skill-focus-guardian-v1`, head `7ca529421e58e0b0f5ca5ee67e9e057b4db4d768`) remained separate Draft candidates. PR #106 is outside scope. Do not describe PR #111 as published or complete; its PR record reports Flutter module CI jobs skipped by path detection, local package/app tests and Android compilation performed on the candidate, and no production API/live-device validation. Revalidate all PR and CI facts at execution time.

The checkout's `tasks/CURRENT_TASK.md` and `docs/CURRENT_STATE.md` still refer to older Phase 5 / PR #110 candidate state. GitHub merge evidence takes precedence for the specific PR publication fact; the repository task contract and current-state page still require owner-maintained reconciliation. This draft does not update either file or silently claim that all status memory is synchronized.

### 3.2 Current app surfaces — observed, not target completeness

| Surface | Repository evidence observed | What it does not prove |
| --- | --- | --- |
| Customer Flutter | The merged Phase 5 shell exists in `mobile/apps/customer_app`; on `main` the feature folders cover account, bookings, discovery, and favorites. | Does not prove all 26 approved Customer screens, real production API wiring, complete auth/booking/payment, or store readiness. PR #111 is a separate candidate. |
| Customer UX | `DESIGN_SYSTEM/EXPERIENCE/CUSTOMER_PHASE5_MASTER_UX.md` defines the current approved 26-screen Customer inventory and key journey rules. | UX specification is not implementation or live evidence. |
| Owner React | Current React code includes onboarding/auth/KYC and dashboard, bookings, properties, messages, wallet, profile, calendar, disputes and notification surfaces; mock-capable repository paths exist. | It is not an Owner Flutter app or proof of canonical data use. Existing bottom navigation is observed legacy implementation; MDF v1.7 target direction is action-first nested navigation without Customer-style bottom navigation. |
| Owner Flutter | No `mobile/apps/owner_app` was present in the inspected baseline. | Does not preclude future approved implementation; do not report it as existing. |
| Admin React | Current code includes login/session, overview, Owner verification, property review queue/detail, payout queue/detail and dispute queue/detail. | A complete approved Admin screen inventory and notification destination are not established; proposed target screens remain proposals. |
| Validation app | `mobile/apps/design_system_validation` is a design/technical lab. | It is not the production Customer/Owner app and its demo state is not business success. |

### 3.3 Data, backend, deployment, and security snapshot

Supabase PostgreSQL is canonical persistence. A branch-aware source inventory of `backend/database/migrations/` on `main` at `5c97ab19ed6da3b1a6ecddf7dbf129c059c86811` finds retained files numbered `008` through `034` inclusive (27 files). Each file's presence on this `main` revision establishes Git existence and that it is part of the published repository baseline; it does **not** establish application to any live database. No live database was queried for this correction.

Exact source inventory (`EXISTS_IN_GIT` on the named `main` SHA): `008_flow_adm_08_payout_execution.sql`; `009_flow_adm_09_disputes_execution.sql`; `010_flow_owner_identity_verification.sql`; `011_property_images.sql`; `012_property_images_remediation.sql`; `013_add_payment_transactions_table.sql`; `014_unified_identity_users_schema.sql`; `015_auth_02b2_sessions_and_otp.sql`; `016_additive_property_wizard_fields.sql`; `017_booking_01_request_lifecycle.sql`; `018_booking_01_1_booking_conversations.sql`; `019_konfrm_complete_deposit_payment.sql`; `020_owner_registration_kyc.sql`; `021_harden_critical_rpc_privileges.sql`; `022_identity_session_persistence_integrity.sql`; `023_finalize_identity_session_persistence.sql`; `024_atomic_property_media_commit.sql`; `025_availability_blocking_integrity.sql`; `026_atomic_booking_request_creation.sql`; `027_wallet_ledger_append_only.sql`; `028_customer_favorites.sql`; `029_customer_favorites_acl_hardening.sql`; `030_audit_logs_admin_throttle_index.sql`; `031_auth_v2_identity_and_challenges.sql`; `032_customer_email_first_nullable_phone.sql`; `033_customer_notifications.sql`; `034_customer_verified_email_linking.sql`.

| Migration range / files | Git existence on `main` | Main/merge status | Live application evidence available in reviewed repository sources | Classification for this roadmap |
| --- | --- | --- | --- | --- |
| `008`–`020` (13 retained files) | `EXISTS_IN_GIT` at baseline SHA | `PRESENT_ON_MAIN`; individual old PR/merge provenance is not reconstructed in this targeted correction | P1.1 records a dated live inventory with an incomplete historical ledger and observed effects/omissions; it does not establish every retained file as applied one-to-one. | `NOT_VERIFIED_PER_FILE`; inspect P1.1 and exact live ledger/effects in a separately authorized read-only verification. |
| `021`–`026` | `EXISTS_IN_GIT` at baseline SHA | `PRESENT_ON_MAIN` / published repository state | `docs/DATABASE.md` and P14.1/P1.2/P1.3/P1.4/P1.5 evidence describe these as published and live-verified/applied, with specific reports for critical ACLs, property-media RPC, availability and atomic booking creation. These are dated evidence claims, not rechecked here. | `DOCUMENTED_APPLIED_LIVE` in cited records; preserve dates/revisions from each report and reverify before live-dependent execution. |
| `027` wallet ledger append-only | `EXISTS_IN_GIT` at baseline SHA | `PRESENT_ON_MAIN`; main history contains its commit | `tasks/PRE_PHASE_4_REMEDIATION_EXECUTION.md` (committed 2026-09-06) says Bridge read-only verification found it in live `schema_migrations`; `docs/DATABASE.md` and `tasks/P1_6_WALLET_LEDGER_PERSISTENCE.md` say repository-only / `NOT_APPLIED_LIVE`. The reviewed documents provide conflicting assertions and no raw query output or exact live snapshot revision here. | `CONFLICTING_DOCUMENTED_LIVE_STATUS — NOT_INDEPENDENTLY_VERIFIED`; do not claim applied or unapplied as current live fact. |
| `028` favorites; `029` favorites ACL hardening | `EXISTS_IN_GIT` at baseline SHA | `PRESENT_ON_MAIN`; P2.2 commit is in main history | The same 2026-09-06 remediation plan says Bridge read-only checks found both in live `schema_migrations` and observed the service-role ACL; `docs/CURRENT_STATE.md` leaves remaining live evidence to task evidence and `KONFRM_RESCUE_BACKLOG.md` says live verification is pending. No raw output/revision is reproduced here. | `CONFLICTING_OR_INCOMPLETE_DOCUMENTED_LIVE_STATUS — NOT_INDEPENDENTLY_VERIFIED`; neither the SQL file nor API/client implementation proves live application. |
| `030`–`034` (five files) | `EXISTS_IN_GIT` at baseline SHA | `PRESENT_ON_MAIN`; history shows PR merges for 030–034 (PR #25, #40, #51, #66 and #74 in main's first-parent history) | No exact live migration-ledger/effect evidence for these five files was identified in the reviewed current repository sources. QA-only application, if any, is not production evidence. | `NOT_VERIFIED_LIVE`; do not infer application from merge, tests, deployment, or filenames. |

`PRESENT_ON_MAIN` means the file is reachable in the named main commit, not that it was applied to production. `DOCUMENTED_APPLIED_LIVE` is an attributed historical evidence claim, not a fresh verification. `NOT_VERIFIED_LIVE` means this review did not establish either applied or unapplied state. `CONFLICTING...` must remain unresolved until an authorized read-only check records project/environment, query/effect, timestamp and exact evidence; this task authorizes no DB access or mutation. The source history is incomplete: P1.1 reports the live application ledger omitted 013/014/017/018 despite observed effects, and `000_schema_baseline` was present only in the live ledger. Never treat the ledger, Git files, or migration numbers as interchangeable.

The recorded live inventory (2026-08-30) found RLS enabled without table policies on inventoried public tables, with direct ordinary-role access denied in that model and backend service-role access in use. P14.1 corrected critical RPC grants live; broader RLS/storage-object access remains an open verification/remediation concern. This is a dated read-only snapshot, not a current live recheck or permission to mutate production.

Frontends call `/api/v1`; no direct frontend Supabase client was found in the inspected code. Worker database access uses a narrow REST/RPC compatibility adapter. `PAYMENT_MODE=PROTOTYPE`; live payment must fail closed. Cloudflare is the expected Worker/Pages direction, but each deployment needs exact revision and route evidence. Legacy Vercel references are not deployment authority.

### 3.4 Platform release reality observed

Customer Android release configuration uses `flutter.targetSdkVersion` and currently signs the `release` variant with the debug signing config (TODO in Gradle); a successful debug/release APK compilation is not a Play-ready signed AAB. The iOS project is generated scaffolding with bundle identifier `com.konfrm.customerApp`, deployment target 15.0, and no verified Xcode/App Store upload gate in this review. There is no Owner Flutter target observed. Recheck these facts in the release task before acting.

As of this draft date, Google Play's official target-API page states that new apps and updates must target Android 16/API 36 or later from 2026-08-31. Some personal developer accounts created after 2023-11-13 require a closed test with at least 12 continuously opted-in testers for 14 days before production access. Apple states uploads from 2026-04-28 require Xcode 26 or later with the listed OS 26 SDKs. These are external, time-sensitive gates: verify account eligibility and policy again at submission. Sources: [Play target API](https://support.google.com/googleplay/android-developer/answer/11926878), [Play testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465), [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/?id=02212025a).

Store planning must also include accurate Data Safety / app privacy disclosures, account deletion where accounts can be created, privacy-policy URL, signing/key custody, metadata, screenshots and beta review. Payment-provider classification and legal/product treatment must be reviewed at submission; do not infer that KONFRM's exact transaction qualifies under any store-payment category. See [Play Data Safety](https://support.google.com/googleplay/android-developer/answer/10787469), [Play account deletion](https://support.google.com/googleplay/android-developer/answer/13327111), [Apple app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/), [Apple account deletion](https://developer.apple.com/support/offering-account-deletion-in-your-app/), [Apple review guidelines](https://developer.apple.com/app-store/review/guidelines/), [Play app signing](https://developer.android.com/studio/publish/app-signing), and [TestFlight](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/). Policy links were checked 2026-10-10 and must be rechecked at execution.

## 4. Role packages and screen inventories

### 4.0 Historical SOLA board reconciliation

`SOLA_EXECUTION_TASKS.md` is retained historical planning and a useful record of the earlier React Customer flow and implementation claims. It must not be renamed, deleted, or copied as the current master. It contains an 18-screen Customer journey, BATCH 1–10 checkmarks, and later AUTH-01/AUTH-02 clusters; these describe the file's own history/evidence scope. They do not establish that those screens are implemented in Flutter, that each legacy batch is currently closed, or that the current approved 26-screen UX has been built. Historical screenshots/local QA, a checked task box, a live probe from an older revision, a current candidate PR, and current `main` are distinct evidence classes.

| Historical SOLA grouping | Current treatment in this proposal |
| --- | --- |
| Screen 1 Splash/App Entry | Maps to current Screen 01; validate bootstrap/session behavior in Flutter. |
| Screen 2 Explore Home | Maps to Screen 03; retain Screen 02 Welcome/Guest Entry as a distinct approved journey step. |
| Screen 3 Search | Maps to Screen 04 Search & Refine; keep Screen 05 Results separate. |
| Screen 4 Search Results | Maps to Screen 05. |
| Screen 5 Property Details | Maps to Screen 06 consolidated Property Details/Booking Decision; gallery, dates, guests and quote are embedded, not extra top-level screens. |
| Screens 6–8 Date Selection, Guest Selection, Price Review | Embedded controls/content within Screen 06; do not count them as independent primary screens. |
| Screen 9 Booking Request Review | Maps to Screen 07, with verified request semantics and customer-safe money summary. |
| Screen 10 OTP Auth | Split into Screens 08 Phone Entry and 09 OTP Verification; Screen 10 is now First-time Profile Setup. |
| Screen 11 Request Success | Maps to Screen 11; only server-confirmed request creation. Historical “Owner response SLA” copy is not authority unless currently approved. |
| Screen 12 My Bookings | Maps to Screen 12. |
| Screens 13–16 booking status-specific details | Consolidate into Screen 13 with server-driven actions/statuses; do not invent expiration, cancellation or payment deadlines. |
| Screen 17 Favorites | Maps to Screen 15. |
| Screen 18 Account | Maps to Screen 17, with profile/settings/payment/support and other approved child screens separated as current inventory requires. |
| No direct historical equivalent | Screens 14, 16, 18–26 cover payment history, notifications, profile, settings, help, booking chat, disputes/evidence, reviews, terms and privacy; each depends on actual contracts/policies. |

The old board includes explicit policy assertions and later notes marking some invented check-in/cash-on-arrival copy as removed. Preserve that as historical evidence only. Re-check any asserted Owner response SLA, expiry, booking/availability lock, payment, cancellation, legal/contract effect, or financial promise against current Canon before it enters UI or API. PHASE 0–22 from `خطة عمل التطبيق.txt` remain the fixed macro roadmap; its older prototype sequencing is clarified by the approved dependency graph, not replaced by this proposal.

### 4.1 Customer — approved UX inventory

The current approved UX authority defines 26 screens. Detailed proposed engineering contracts for each are in the [screen-contract annex](./KONFRM_EXECUTION_TASKS_SCREEN_CONTRACTS_DRAFT.md). Screen ID/title names preserve that UX authority; all endpoint, persistence, loading, error, permission, and acceptance details remain subject to the current API/product contract.

| ID | Screen | ID | Screen |
| --- | --- | --- | --- |
| 01 | Splash / App Launch | 14 | Deposit Payment |
| 02 | Welcome / Guest Entry | 15 | Favorites |
| 03 | Explore / Home | 16 | Notification Center |
| 04 | Search & Refine | 17 | Account Home |
| 05 | Search Results | 18 | Profile / Edit Profile |
| 06 | Property Details / Booking Decision | 19 | Settings |
| 07 | Booking Request Review | 20 | Payment History |
| 08 | Auth Phone Entry | 21 | Help & Support |
| 09 | OTP Verification | 22 | Booking-scoped Chat |
| 10 | First-time Profile Setup | 23 | Dispute / Evidence |
| 11 | Booking Request Sent | 24 | Review / Rating |
| 12 | My Bookings | 25 | Terms |
| 13 | Booking Details / Stay Hub | 26 | Privacy Policy |

The approved IA says embedded gallery, availability, guests, quote and filters are not extra primary screens; Screen 06 is consolidated. Browse-first auth preserves the interrupted action. Customer navigation has Explore/Favorites/Bookings/Account; Screen 16 retains navigation with Account active when entered from Account. Entry points, child routes and back behavior must be checked against the current IA, not inferred from a screenshot.

### 4.2 Owner — observed current surfaces vs proposed target groups

Observed React surface names include session/auth/onboarding/KYC, Home, Bookings, Properties and property wizard/detail, Messages, Wallet, Profile, Calendar, Disputes, and a notification modal. Treat mock repositories as non-production unless the active provider is proven. The proposed Owner Flutter inventory is in the [role-screen proposal annex](./KONFRM_EXECUTION_TASKS_SCREEN_CONTRACTS_DRAFT.md#owner-proposed-screen-families). Every listed family is `PROPOSED / NEEDS FOUNDER UX APPROVAL`; the list is a reviewable starting inventory, not an approved screen count or mandatory route structure. MDF v1.7 supplies the approved direction: action-first Owner experience with nested navigation and no Customer-style bottom navigation. Do not carry over a Customer-style bottom bar.

### 4.3 Admin — observed current surfaces vs proposed target groups

Observed React surface names include session/login, overview, Owner verification queue, property review queue/detail, payout queue/detail, and dispute queue/detail. The proposed Admin inventory is in the [role-screen proposal annex](./KONFRM_EXECUTION_TASKS_SCREEN_CONTRACTS_DRAFT.md#admin-proposed-screen-families). Every proposed family is `PROPOSED / NEEDS FOUNDER UX APPROVAL`; it does not claim a complete approved Admin IA. Notification access is not established by a disabled bell or an API route alone.

## 5. Fixed phase map

The macro IDs and historical labels remain fixed. The descriptions below summarize the approved roadmap and dependency clarification; they do not close, reorder, or rename phases. Current subtask status must be recorded per task against exact branch, base SHA, candidate SHA, merge/deploy evidence and closure gates. The older `docs/codex/KONFRM_EXECUTION_MAP.md` is a useful breakdown but its active routing and baseline are stale; do not copy its status column as current.

| Phase | Fixed macro outcome | Dependency-aware work focus | Gate / limitation |
| --- | --- | --- | --- |
| 0 | Baseline / reality / access stabilization | Establish branch, baseline, CI, access, runtime and deployment facts. | Exact source and access evidence; no assumed environment truth. |
| 1 | Database backbone | Identity, property/media, availability, booking/finance and wallet persistence boundaries. | Inspect migration history and live effects; staged/candidate is not applied/live. |
| 2 | Backend contracts | Public, Customer, Owner, Admin and Worker contracts; truthful errors and authorization. | Server/database own business truth; verify the deployed adapter path. |
| 3 | Owner → Admin → Customer vertical slice | Same property/booking entity and state propagation across roles. | No mock success, duplicate local truth or refresh-only proof. |
| 4 | Unified Design System | Tokens, components, RTL, motion, startup, accessibility and governance. | Preserve open design values; icon family decision remains open. |
| 5 | Customer / Renter UI/UX | Flutter customer product, discovery through account and booking surfaces. | Approved 26-screen UX is target; branch #111 remains candidate as of snapshot. |
| 6 | Owner UI/UX | Action-first Owner mobile experience and role workflows. | Depends on backend truth and Owner-specific IA; no customer bottom-nav assumption. |
| 7 | Admin UI/UX | Desktop operations, verification, property, payout and dispute tasks. | Use real evidence and auditability; unresolved policies block dependent decisions. |
| 8 | Booking integration | Request → Owner decision → Customer consequence; availability and recovery. | Approval before payment; pending-owner request is not an inventory hold. |
| 9 | Notification engine | Model trusted domain events before delivery and UI. | No invented unread state; event matrix is unresolved. |
| 10 | Payment prototype | Prototype deposit initiation/completion after Owner approval. | Idempotent canonical totals; live mode fail closed; no production gateway inference. |
| 11 | Wallet / payout / financial integrity | Ledger-derived balances, eligibility, release, payout queue and audit. | Apply prototype rules faithfully; production legal/operational revalidation required. |
| 12 | Chat | Booking-context, authorized Customer/Owner conversation. | Access, unread and retention decisions remain open. |
| 13 | Cancellation / disputes / reviews | Contract policy, dispute handling and eligible reviews. | Founder policy decisions precede policy-dependent implementation. |
| 14 | Security / privacy pass | Continuous authorization, RLS/storage, session, secrets and privacy gates. | Security work is continuous; final consolidated review remains here. |
| 15 | Full visual consistency audit | Refresh cross-app drift from current screens and prioritize migrations. | Final audit follows sufficient Phase 4–7 evidence; no wholesale redesign assumption. |
| 16 | Role UX audit | Audit actual role jobs, IA gaps and approved improvements. | Use observed current experience plus approved authority; do not promote legacy. |
| 17 | Edge cases / failure states | Errors, empty/loading/disabled, retry, conflict and offline/slow network. | Continuous quality is required; consolidate after functional surfaces exist. |
| 18 | Realistic test data | Isolated, governed fixtures and test-data lifecycle. | Controlled data only; no production mutation. Dependency clarification places needed fixtures before final E2E/audit gates. |
| 19 | End-to-end scenarios | Cross-role supply, booking, money, failure/recovery and privacy paths. | Stable backend, authorization and controlled fixtures required. |
| 20 | Live deployment verification | Exact release revision, deployed route and read-only behavior checks. | Build/CI is not live proof; avoid business-data mutations. |
| 21 | Demo polish | Truthful, representative demonstration after core gates. | No fake success or demo-only behavior leakage. |
| 22 | Final product blueprint | Evidence-led architecture/product handoff and remaining decisions. | Close only when applicable earlier gates have evidence and owners. |

### 5.1 Dependency corrections without renumbering

- Keep PHASE 0 → 3 as the core foundation: persistence → backend contracts → same-entity cross-role vertical slice.
- Phase 4–7 design and UI can proceed only around real or explicitly approved capabilities; do not create a future capability because a screen wants it.
- Booking integration precedes dependent notifications and payment lifecycle; payment follows Owner approval; wallet/payout follows canonical financial events; chat follows booking context; cancellation/dispute/review policy needs decisions.
- Security, error truthfulness, RTL, accessibility, and regression remain continuous. Their numbered final audit phases are consolidation gates, not permission to defer basic protections.
- PHASE 18 controlled test data may be executed early where it is a prerequisite to final E2E and audit evidence. Preserve its macro ID and final phase meaning.
- Record each dependency pull-forward as a narrow package with its reason, scope, decision owner and return point.

### 5.2 Proposed delivery packages

These package IDs are draft planning identifiers, not official task-router IDs. Each concrete task must be narrowed to one task contract with exact branch/base SHA and named implementer/reviewer. Accountable role below means the role that must own the decision/evidence; it is not an invented assignment to a specific person or agent.

| Draft package | Scope / affected systems | Prerequisites | Accountable role | Test and evidence strategy | Exit / material risk |
| --- | --- | --- | --- | --- | --- |
| PKG-00 Baseline reconciliation | Repository, task state, CI, GitHub PRs, deployment inventory | None | Maintainer + independent reviewer | Branch/base/HEAD, PR/merge state, CI job paths, exact deployed revision and access report | Current fact sheet linked to evidence; stale memory identified. Risk: a stale task file routes work incorrectly. |
| PKG-01 Identity/session contract | Customer/Owner/Admin clients, backend auth, PostgreSQL/session | PKG-00; current identity authority | Backend/security owner | Auth contract tests, cross-role UUID invariant, expiry/revoke, unauthorized matrix, live read-only probe when authorized | No role/ownership leakage; persistence and session semantics verified. Founder decision if production auth method/OTP delivery remains open. |
| PKG-02 Supply/media lifecycle | Owner, Admin, Customer, API, DB, Storage | Identity/authz and property/media contracts | Backend + Owner/Admin product owner | Draft→review→publish/reject same-entity test, private KYC ACL checks, public media checks, failure injection | Published visibility and rejection reason propagate; no private evidence exposure. |
| PKG-03 Availability and quote | Customer, Owner calendar, backend, DB | Property lifecycle; current availability/price rules | Backend + Product | Calendar boundary tests, serialization/conflict tests, quote response reconciliation, fail-closed DB errors | Quote is not a hold; only approved blocking statuses block. Price/guest exceptions require decision. |
| PKG-04 Cross-role vertical slice | Owner → canonical API/DB → Admin → Customer | PKG-01/02; exact same entity | Architecture/Backend lead + all role owners | Controlled entity trace with IDs, audit evidence, no mock/fallback, read-only production check only if authorized | Same entity/state visible across roles; no local shadow truth. Critical risk package. |
| PKG-05 Design System foundations | Shared Flutter package, Customer/Owner Flutter, Admin Web | Design authority; MDF v1.7 | Design System owner | Token/component tests, RTL, semantics, text-scale, reduced-motion, screenshot/profile evidence | Approved components/tokens; open icon/color/CTA decisions remain recorded. |
| PKG-06 Customer Flutter foundation | Customer Flutter app, routing, auth bootstrap, API client | PKG-01, PKG-05; approved Customer IA | Customer mobile owner | Unit/widget tests, API contract, Android/iOS profile tests, state restoration, device matrix | Shell does not masquerade as all 26 screens; session and errors truthful. |
| PKG-07 Customer discovery and detail | Screens 03–06; public/search/detail API, media, favorites link | PKG-02/03/05/06; PR #111 reviewed separately | Customer mobile + backend | Search/detail API tests, unpublished exclusion, quote/availability consistency, RTL/a11y, Android/iOS devices | No stale/mocked availability or fake empty; no unapproved hold. |
| PKG-08 Customer auth and request | Screens 07–11; identity, quote, booking creation | PKG-01/03/06/07; booking contract | Backend + Customer mobile + Product | OTP/session tests, idempotency, interrupted-action restore, ownership/privacy and timeout-after-commit | `PENDING_OWNER_APPROVAL` only after server success; no payment/contract at submission. |
| PKG-09A Customer booking status views | Screens 12–13; server-backed bookings list and details, without payment execution | PKG-08 and PKG-13 status contract; Customer privacy DTO | Backend + Customer mobile | Status/ownership/error tests, state mapping and stale/deep-link tests | Phase 8 request/Owner decision propagation is independently testable before payment; no fabricated actions. |
| PKG-09B Prototype payment entry | Screen 14; approval-gated prototype payment UI | PKG-09A, completed PKG-13 Phase 8 verification, Phase 10 payment contract and approved provider sandbox where needed | Backend + Customer mobile + Finance/Product | Amount/idempotency tests; approved-pending-payment gate; prototype/live boundary | Explicitly follows booking integration; does not make Phase 8 depend on payment. Real-money readiness remains separate. |
| PKG-10 Customer account and support | Screens 15, 17–19 and 21; favorites, account/profile/settings and support | PKG-01; identity/profile and support contracts | Customer mobile + Product/Privacy | Per-screen contracts, privacy and retention tests, accessibility/RTL, support route tests | Notification, chat, payment history, dispute/review, and legal/privacy policy surfaces stay in their separately gated packages. |
| PKG-11 Owner Flutter foundation and operations | Owner entry, action-first home, property, calendar, bookings, wallet, messages, verification | PKG-01/02/03/05 and approved Owner IA; no Customer bottom bar | Owner mobile + Product | Widget/API contract tests, role access, private KYC checks, date/money reconciliation and physical devices | Proposed Owner inventory approved before build; do not port legacy React mocks as truth. |
| PKG-12 Admin desktop foundation and property/KYC operations | Admin session, overview, verified property/KYC queues and details, audit; contract-ready payout/dispute capabilities are separately gated | PKG-01/02 plus verified Admin API, authorization, data and audit contracts; Admin inventory Founder gate | Admin web + Operations/Product | Admin role matrix, decision/reason audit, private media ACL, false-zero/error tests, browser accessibility | Independently build/test Web against verified contracts; Owner Flutter is not a prerequisite. Payout/dispute actions wait on their own data/policy contracts; a narrow cross-role runtime scenario may later require an Owner client. |
| PKG-13 Phase 8 booking cross-app integration | Customer request → Owner approve/reject → Customer receives same booking status; competing-date invariant and recovery | PKG-01–04, PKG-08; no PKG-09A/09B prerequisite | Backend + Product + Customer/Owner/Admin contract owners | State-machine, authorization, concurrency, idempotency, same-entity state trace; controlled E2E fixture is a closure subgate | Close canonical request and Owner-decision propagation before prototype payment. Excludes payment initiation and payment-driven confirmation. High/critical. |
| PKG-14 Notifications and chat | Screen 16 event model/delivery and Screen 22 booking-scoped conversations | PKG-01/13; approved event, access and retention decisions | Backend + Product/Privacy | Recipient authorization, retries, duplicate delivery, push permission, message/attachment ACL | No generic unread/push/chat behaviors before model and policies. |
| PKG-15 Wallet, payout and financial integrity | Screen 20 history where linked to canonical payment events; canonical ledger/balance, release and payout after payment events | PKG-03, PKG-09B, PKG-13; provider/legal/operations decisions for live | Finance/Product + Backend/Security | Amount invariant, immutable ledger, idempotent event handling, reconciliation, isolated payout tests | Prototype accounting and live money are distinct; live money blocked until provider, legal and operations gates. |
| PKG-16 Cancellation, dispute and reviews | Screen 23 dispute/evidence and Screen 24 review; policy state machine and role UX | Founder decision register; PKG-13 and approved stay-completion source | Founder/Product + Operations | Decision tables, authorization, audit, refund/review eligibility tests | No policy-specific implementation before approved policy. Critical decision dependency. |
| PKG-17 Security, privacy and observability | Authz, RLS, Storage, secrets, deletion, telemetry, incident visibility; Screens 25–26 policy presentation only from approved text | Continuous; exact affected system | Security/Backend + Privacy | Threat model, negative access tests, storage object checks, secret scan, truthful telemetry and controlled live evidence | Close each risk with specific evidence; broad RLS/storage gaps not hidden by P14.1 closure. |
| PKG-18 Controlled test fixtures and E2E | Isolated database/storage fixtures and cross-role scenarios | Schema/API/authz contract; fixture governance | QA + Backend/Privacy | Seed/teardown proof, no production mutation, supply/booking/money/failure/privacy scenarios | Fixtures are isolated, deterministic and cleaned; gates final E2E and audits. |
| PKG-19 Native release readiness | Android/iOS signing/build, store declarations/assets, device test, monitoring/rollback | Stable app, API/auth/privacy/legal readiness; store policy recheck | Mobile release owner + Founder/account owner | Signed AAB/archive, physical device matrix, store validation, permission/privacy manifest review, staged rollout/rollback drill | `STORE READY` only with store-specific proof; no release without approved launch decision. |
| PKG-20 Controlled market launch and operations | Support, incident response, live monitoring, release cohort and rollback | PKG-15–19, legal/payment provider approvals, launch decision | Founder + Operations + Engineering | Production smoke with exact SHA, monitoring thresholds, support escalation simulation, rollback evidence | Controlled release only after explicit Founder authorization and all release gates. |
| PKG-21 Final blueprint/handoff | Canonical architecture, status, remaining risk, operational ownership | Applicable prior phase gates and decisions | Founder + architecture owner | Evidence links, exact revisions, decisions, known gaps, runbooks | Handoff reflects observed system, not aspirational design. |

Proposed repository areas below are starting boundaries, not a command to create every path. Confirm the actual task branch and architecture before implementation; paths marked “future” do not exist in the inspected main baseline.

| Package | Likely repository area(s) to inspect / change when separately authorized |
| --- | --- |
| PKG-00 | `docs/`, `tasks/`, `.github/workflows/`, GitHub PR/deployment records; no authority-routing edits in this proposal. |
| PKG-01 | `backend/server/src/` auth/session/routes/repositories, `backend/database/migrations/`, `mobile/apps/customer_app/`, `owner-app/`, `admin-app/`; verify exact module paths first. |
| PKG-02 | `owner-app/`, `admin-app/`, `customer-app/`, `backend/server/src/`, `backend/database/migrations/`, Supabase Storage configuration/evidence. |
| PKG-03 | `backend/server/src/`, `backend/database/migrations/`, `mobile/apps/customer_app/`, future `mobile/apps/owner_app/`, existing `owner-app/`. |
| PKG-04 | Same-entity integration across `backend/server/src/`, DB migrations, `owner-app/`, `admin-app/`, `customer-app/`; future Flutter apps under `mobile/apps/`. |
| PKG-05 | `DESIGN_SYSTEM/`, `mobile/packages/konfrm_design_system/`, Flutter app themes, `admin-app/src/`; keep app code consuming the system. |
| PKG-06–10 | `mobile/apps/customer_app/`, `mobile/packages/konfrm_design_system/`, relevant `mobile/packages/` API/auth packages if present; backend contract in `backend/server/src/`. |
| PKG-11 | Future `mobile/apps/owner_app/` plus shared `mobile/packages/`; current React evidence in `owner-app/`; do not create until inventory/task approved. |
| PKG-12 | `admin-app/src/`, `backend/server/src/`, `backend/database/migrations/` only when a contract/migration is separately approved. |
| PKG-13–16 | `backend/server/src/`, `backend/database/migrations/`, affected role apps; contracts/policies in authoritative Product docs, changed only by authority owner. |
| PKG-17 | Affected `backend/`, `mobile/`, `owner-app/`, `admin-app/`, `.github/workflows/`, `docs/`; security scope follows finding and approved contract. |
| PKG-18 | Test directories, isolated fixture tooling and test-only migrations/scripts where approved; never production dataset. |
| PKG-19–20 | `mobile/apps/*/android/`, `mobile/apps/*/ios/`, store metadata/assets (repo location to be decided), `.github/workflows/`, runbooks/monitoring configuration. No release/deployment from this roadmap PR. |
| PKG-21 | `docs/` and task-owned handoff artifacts after evidence closure; do not overwrite historical records. |

### 5.2.1 Dependency graph sanity check

The following is the explicit package dependency graph for this draft. Founder/Product decision gates are conditions, not package-to-package edges. Continuous security work (PKG-17) is not a serial prerequisite to starting feature work; its applicable evidence is a closure gate. Phase 8 is closed at canonical request/Owner-decision propagation; payment initiation and payment-driven confirmation belong after it in Phase 10.

| Package | Direct package prerequisites | Additional decision/evidence gate |
| --- | --- | --- |
| PKG-00 | — | Baseline evidence. |
| PKG-01 | PKG-00 | Current identity/auth contract. |
| PKG-02 | PKG-01 | Property/media contract and ACL. |
| PKG-03 | PKG-02 | Approved current availability/pricing rules. |
| PKG-04 | PKG-01, PKG-02 | Same-entity cross-role proof. |
| PKG-05 | PKG-00 | Design authority and unresolved token gates. |
| PKG-06 | PKG-01, PKG-05 | Approved Customer IA. |
| PKG-07 | PKG-02, PKG-03, PKG-05, PKG-06 | Verified public API/media behavior. |
| PKG-08 | PKG-01, PKG-03, PKG-06, PKG-07 | Booking request contract and auth decision. |
| PKG-09A | PKG-08, PKG-13 | Customer-safe status DTO. |
| PKG-09B | PKG-09A, PKG-13 | Phase 10 prototype-payment contract; Owner approval gate. |
| PKG-10 | PKG-01 | Profile and support contracts; does not own notifications/chat/disputes/reviews/legal/privacy policy surfaces. |
| PKG-11 | PKG-01, PKG-02, PKG-03, PKG-05 | Founder-approved Owner family map and API/authorization contracts. |
| PKG-12 core | PKG-01, PKG-02 | Founder-approved Admin family map and verified Admin API/authorization/audit contracts; **no PKG-11 edge**. Payout actions in PKG-15 and dispute actions in PKG-16 are separate gated slices. |
| PKG-13 | PKG-01, PKG-02, PKG-03, PKG-04, PKG-08 | Phase 8 booking contract; deadline rules only if the approved flow uses them. |
| PKG-14 | PKG-01, PKG-13 | Notification, chat access, retention and delivery decisions. |
| PKG-15 | PKG-03, PKG-09B, PKG-13 | Canonical finance; production provider/legal/operations gate for live money. |
| PKG-16 | PKG-13 | Founder-approved cancellation/dispute/review policies and completion source. |
| PKG-17 | — | Security/privacy checks attach continuously to affected work; applicable findings block closure. |
| PKG-18 | PKG-01, PKG-02, PKG-03 | Isolated fixture governance; fixture readiness precedes final cross-role E2E closure. |
| PKG-19 | PKG-06, PKG-07, PKG-09A, PKG-09B, PKG-10, PKG-11, PKG-12, PKG-14, PKG-15, PKG-16, PKG-17, PKG-18 | Per-app scope; applicable native build/device/store gates. Admin Web release is independently scoped from Owner mobile release. |
| PKG-20 | PKG-15, PKG-16, PKG-17, PKG-18, PKG-19 | Explicit launch approval, legal/provider/support/monitoring/rollback readiness. |
| PKG-21 | PKG-00, PKG-01, PKG-02, PKG-03, PKG-04, PKG-05, PKG-06, PKG-07, PKG-08, PKG-09A, PKG-09B, PKG-10, PKG-11, PKG-12, PKG-13, PKG-14, PKG-15, PKG-16, PKG-17, PKG-18, PKG-19, PKG-20 as applicable | Evidence-backed final status and handoff. |

One valid topological order is: `00 → 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 11 → 12(core) → 10 → 17 → 18 → 13 → 09A → 09B → 14 → 15 → 16 → 19 → 20 → 21`. This ordering is illustrative among independent packages; it is not a new macro-phase order. Because every package edge points from an earlier item in this order to a later item, the declared package graph is acyclic. The required dependency is `PKG-13 → PKG-09A → PKG-09B`; there is no reverse edge from Phase 8 to payment. Payout/dispute actions are not prerequisites for the Admin Web foundation; if those actions are included in an Admin release slice, their PKG-15/16 gates apply to that slice only.

### 5.3 Parallel work and hard dependencies

**Can proceed in parallel after baseline/context is established:** (a) Customer per-screen contract cleanup against approved IA; (b) Admin and Owner inventory discovery (clearly labeled observed/proposed); (c) store-account/identifier/privacy-policy inventory; (d) design token/accessibility audit; and (e) backend/API contract inventory. These are read-only planning and bounded evidence tasks; implementation still waits for each feature's prerequisites.

**Must wait for a dependency or decision:**

- Customer submit/payment UI waits for verified booking status and API contracts; payment waits for Owner approval.
- Owner actions wait for canonical Owner authorization and server transitions; Admin decisions wait for audit/reason and private-evidence contracts.
- Notifications wait for event/recipient semantics; chat waits for booking scope, authorization and retention; reviews/disputes/cancellations wait for approved policy.
- Wallet/payout live money waits for canonical ledger, provider, reconciliation, operational and legal decisions.
- Production release waits for signed artifacts, platform-account requirements, privacy disclosures, physical-device verification, live backend/security checks, support/monitoring and explicit launch approval.

Do not parallelize two writers in one checkout. Use separate branches/worktrees and reconcile dependencies through task contracts.

### 5.4 Execution status and evidence model

Status is per artifact/revision, not per phase name. Multiple statuses can be true for distinct revisions, but each claim must name its evidence.

| Status | Required evidence | Does not mean |
| --- | --- | --- |
| `IMPLEMENTED` | Source change exists on named branch and SHA; scope identified. | It passed tests or is integrated. |
| `TESTED` | Named tests actually executed, result/count/tool/runtime recorded against exact SHA. | Device/live/store behavior verified. |
| `DEVICE VERIFIED` | Exact app SHA tested on named physical device/OS/build; observed scenarios/evidence recorded. | Live backend or store approval. |
| `LIVE VERIFIED` | Exact deployed SHA/environment/route plus authorized real behavior evidence. | Published-to-main or legally launchable. |
| `STORE READY` | Store-specific signed artifact, policies, metadata, privacy, account, SDK/API and submission checks complete for that store/account. | Approved/released by store or authorized launch. |
| `RELEASED` | Store/controlled distribution publication evidence and release revision/cohort. | Business launch success or zero defects. |
| `BLOCKED` | Exact unmet dependency/access/failed gate and evidence. | Permanent failure; resume when condition changes. |
| `NEEDS FOUNDER DECISION` | Narrow unresolved product/business/legal/financial question and dependent packages. | Technical task is complete. |

Use `CANDIDATE`, `PUBLISHED`, and `CLOSED` only as defined by repository governance: branch work remains candidate until merge; published requires merge/publication evidence; closed requires all task-specific gates. Do not label a phase complete because one role app or PR is complete.

### 5.5 Task contract required for each package slice

Every execution issue/task should name: task ID and parent package/phase; objective and explicit non-goals; base main SHA, branch and starting SHA; authorities and exact paths; affected roles/API/data; prerequisites and unresolved decisions; writer and independent reviewer; expected output; test matrix (unit/widget/integration/security/E2E/device/live as applicable); fixture and secret/access handling; acceptance and rollback criteria; risks; evidence links; and the next owner/action. Keep a single writer per checkout and do not combine independent PR #106/#111 work.

## 6. Decisions that block dependent work

Open decisions are not generic TODOs. Each dependent task must identify the minimum decision it needs, route it to the Founder/Product authority, and continue independent technical work only where that work does not assume an answer.

| Decision | Current state | Blocks / constrains | Minimum resolution evidence |
| --- | --- | --- | --- |
| Renter cancellation and refund matrix | Open except confirmed Owner-fault case | Cancellation UI/API, disputes, refunds, fees and policy copy | Approved state-by-state actor, time, amount and audit contract. |
| Request/approval/payment deadlines and competing requests | Open | Availability holds, expiry jobs, notifications, customer promises | Approved clocks, state transitions, conflict behavior and timezone. |
| Remaining balance collection | Open | Payment schedule and Customer explanation | Approved method, timing, failure/refund treatment and provider path. |
| Check-in/out, no-show and stay completion | Open beyond existing release/review rules | Wallet release, support, disputes, review eligibility | Approved evidence, timestamps, actor and exception path. |
| Notification event matrix | Open | Notification persistence, delivery and unread UI | Event/recipient/channel/permission/retry and privacy matrix. |
| Chat retention, attachments and Admin access | Open | Storage, moderation and retention implementation | Approved participant, access, report, delete/retain and audit contract. |
| Dispute evidence, deadlines and outcomes | Open | Admin decisions, refund/hold/reversal mechanics | Approved lifecycle, roles, evidence privacy and financial effects. |
| Review schema/moderation and eligibility exceptions | Partial/open | Review submission, visibility, edit/report and abuse handling | Approved eligibility, content, moderation and display policy. |
| Privacy deletion and retention schedule | Open | Account deletion, legal hold, KYC and message retention | Approved data class, retention basis, deletion/anonymization and user UX. |
| Production payment/payout provider and legal/operations | Open | Live money, webhooks, reconciliation, payout release and store review | Founder-approved provider and operations, independent legal/compliance review, security and live verification. |
| Icon family and remaining visual tokens | Open where documented | Broad migration of icons/color/shadow/motion | Explicit design decision; do not mass-migrate first. |
| App store account, identifiers, privacy declarations and release owner | Not evidenced as finalized | Store submission and public release | Account ownership, exact identifiers, policy disclosures, release keys and readiness evidence. |
| Admin target screen inventory and notification destination | Not canonically complete | Admin IA implementation | Product/UX-approved inventory and destination behavior. |

## 7. Cross-cutting gates

Every execution package should specify affected role(s), source authority, dependency, exact baseline, intended artifact, out-of-scope systems, acceptance evidence, and status/owner. Completion is not a green build alone.

- **Product and persistence:** canonical server-derived status, ownership, money and permissions; honest failure; idempotent write behavior; no mock/fallback production truth.
- **Security and privacy:** role/ownership boundary, least privilege, private KYC access, secrets, retention/deletion implications, and exact live evidence when a live system is touched. Broader RLS/storage concerns remain explicit.
- **RTL and accessibility:** Arabic/Cairo layout, mixed-direction isolation, semantics, keyboard/focus, text scaling/reflow, contrast, reduced motion, touch targets, error announcements and assistive technology checks on target platforms. Record what is simulated versus physical-native.
- **Quality:** focused unit/widget/integration/E2E and regression results, source revision, device/emulator/profile, target OS/SDK, route, data fixture, screenshots/logs and known omissions. Never call skipped or unrun jobs passed.
- **Release:** minimum Android target/API, signed AAB and key custody, iOS Xcode/SDK and archive validation, privacy/data-safety declarations, account deletion, metadata, review eligibility, staged rollout/rollback, crash/analytics handling and support ownership. Recheck current platform policies.
- **Live evidence:** exact deployed SHA, route, role, scenario and observed result. Keep candidate, published, live-verified and closed status separate.

### 7.1 Launch readiness by platform

These are readiness gates to verify, not claimed current completion. Android and iOS require separate evidence.

| Gate | Android / Google Play | iOS / App Store | Current snapshot / next proof |
| --- | --- | --- | --- |
| Native source and package | Customer Flutter target exists; verify Owner target and actual `applicationId`. | Customer Flutter scaffold exists; verify Owner target, bundle IDs and signing. | Main baseline had Customer only; Owner Flutter target not observed. |
| Toolchain / target | Verify `compileSdk`, target API 36+ at submission, supported device range and permission manifest. | Xcode 26+ and required SDK as of policy date; verify deployment target and archive validation. | Current Android target inherits Flutter default; iOS deployment target 15.0; neither is store evidence. |
| Artifact / signing | Signed Android App Bundle, upload key custody, Play App Signing, no debug signing. | Archive/export with distribution certificate and provisioning; signing credentials managed securely. | Customer release Gradle currently uses debug signing config; no signed store artifact evidenced. |
| Device quality | Physical device matrix including Android versions, screen sizes, Arabic RTL, accessibility, network/permission states. | Physical iPhone/iPad matrix, OS versions, Arabic RTL, VoiceOver and Dynamic Type. | Existing Android hardware checks are task-specific; they do not establish the full store matrix. No iOS hardware/build proof in this snapshot. |
| Privacy and permissions | Manifest permission minimization, Play Data Safety, account deletion path and privacy URL; declarations match SDK/backend behavior. | App privacy labels, privacy URL, in-app account deletion where applicable, permission purpose strings and SDK disclosures. | Data inventory, deletion/retention decisions and submitted declarations not evidenced complete. |
| Store assets / testing | Current screenshots, metadata, content rating, app access instructions; account-specific test track/closed test if applicable. | App screenshots/metadata, privacy details, TestFlight internal/external validation and review requirements. | Store accounts, identifiers finalization, assets and testing-track evidence not established. |
| Backend / money / operations | Production API and security verified; approved payment classification/provider; support, monitoring, crash response and rollback. | Same; verify Apple guideline classification at submission without assuming the transaction category. | Prototype payment only; production provider, legal/operational flow and launch approval open. |

**Release blocker:** Current baseline is not `STORE READY` for either platform. For Android, debug-signing on `release` is a direct configuration blocker until corrected and validated. For iOS, required Xcode/SDK archive and device evidence are absent. Both also lack complete store account/identifier/privacy/support/real-money readiness evidence. A compiled APK, local test result or Draft PR cannot close these gates.

### 7.2 Human comprehension / support readiness

Every transactional screen and staff tool needs a comprehension check with representative Arabic-first users: can the user distinguish request from approval, approval from payment, quote from hold, prototype from real money, and pending/error from success? Validate labels, amount basis, next action and consequences without relying on color or icon alone. Record test task, participant context (without unnecessary PII), observed confusion, severity and remediation. This is product comprehension evidence, not permission to change payment or legal rules.

Operational readiness must name support ownership, escalation route, response expectations approved by the business, dispute/evidence handling, privacy requests, release monitoring, incident severity, rollback decision-maker and provider reconciliation owner. Do not publish response SLAs or support hours until approved. No production launch gate passes on an unstaffed “support” link or an assumed recovery process.

## 8. Proposed next sequence

This is a proposal, not authorization to skip current task ownership or merge a candidate.

1. Reconcile repository task/current-state memory with actual GitHub merge state for PR #110, without editing official routing in this proposal PR.
2. Review PR #111 as its own Customer discovery candidate; verify skipped CI path behavior and close its task-specific checks. Do not mix its remaining work with this planning document.
3. Establish a current Phase 5 task contract for the next approved Customer slice from the 26-screen UX, and confirm API availability/ownership before UI wiring.
4. Keep Owner Flutter as a separately scoped experience/design package after current backend contracts and Owner IA dependencies are verified.
5. Define Admin target inventory before expanding Admin UI.
6. Route open Founder decisions before booking, finance, cancellation, dispute, notification or live-payment behavior depends on them.
7. Maintain continuous security, accessibility, RTL, truthful states and regression gates; use controlled fixtures for final cross-role scenarios.

## 9. Source register and known conflicts

### 9.1 Repository authorities and evidence

| Source | Use in this draft | Limitation / handling |
| --- | --- | --- |
| `AGENTS.md`; `docs/INDEX.md`; `docs/CONTEXT_ROUTER.md` | Mandatory process and context authority | This draft does not amend routing. |
| `docs/codex/KONFRM_MASTER_RULES.md`; `docs/BUSINESS_RULES.md` | Confirmed role, booking, payment and privacy boundaries | Product decisions outrank screens/mocks; unresolved rules stay unresolved. |
| `KONFRM_EXECUTION_DEPENDENCY_ORDER.md` | Fixed macro IDs and dependency graph | Preserve original roadmap; narrow prerequisites may move, phases do not. |
| `KONFRM_EXECUTION_TASKS_V2_DRAFT.md` supplied by user | Working reference and comparison input | Non-authoritative; every accepted claim was checked against current repo/GitHub or labeled provisional. |
| `docs/CURRENT_STATE.md`; `tasks/CURRENT_TASK.md` | Task/memory context | Stale relative to PR #110 merged evidence; requires owner reconciliation. |
| `docs/codex/KONFRM_EXECUTION_MAP.md` | Micro-boundary concepts and dependency coverage | Header, baseline, active routing and status entries are stale; not current completion proof. |
| `docs/codex/KONFRM_CURRENT_REALITY.md`; `KONFRM_COMPLETION_MATRIX.md`; `KONFRM_RESCUE_BACKLOG.md` | Historical September 2026 snapshots | Internal rows conflict with later P14.1 resolution and one another; use as historical, not live state. |
| `DESIGN_SYSTEM/EXPERIENCE/CUSTOMER_PHASE5_MASTER_UX.md` | Approved Customer 26-screen UX | Specification is not implemented behavior. |
| `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` v1.7 | Approved role-level mobile direction | Owner action-first/no Customer bottom nav; existing React is implementation evidence. |
| `OWNER_EXPERIENCE.md`, `ADMIN_EXPERIENCE.md`, React source | Observed legacy surfaces and operational workflows | Not complete approved target screen lists. |
| `docs/DATABASE.md`, P1.1/P14.1 reports, migrations | Canonical data and dated security facts | Live snapshot is dated 2026-08-30; reverify before live tasks. Migration files alone do not prove application. |
| GitHub PR #110 / #111 / #106 | Merge/candidate/CI facts at snapshot time | Dynamic; refresh before task execution. #106 is outside scope. |

### 9.2 Known documentation inconsistencies to surface, not repair here

- `tasks/CURRENT_TASK.md` still describes PR #110 as a Draft candidate though GitHub reports it merged. Update under its owner task, not this proposal.
- `docs/CURRENT_STATE.md`, the execution map, current-reality snapshot, completion matrix, and rescue backlog contain older baselines and stale statuses. Some rows conflict internally; do not promote their September/early October state into current truth.
- `docs/codex/KONFRM_DECISION_CONFLICTS.md` DC-13 summary marks the ACL issue resolved while an older row says it remains blocking. P14.1 and migration 021 evidence close that specific critical RPC ACL issue; broader RLS-without-policy and storage object access remain distinct open concerns.
- Historical `SOLA` roadmap/screens contain outdated branding, screen counts and implementation assumptions. Preserve them as historical records; the approved current Customer inventory is 26 screens.
- Existing Owner React bottom tabs conflict with the approved Mobile Design Foundation v1.7 target. The target direction is action-first Owner navigation; this is not an open conflict requiring a new blue-tab rule.
- DF2 v1.7 identifies Stable Black `#000000` as the system-validated provisional Primary Action treatment, not final native token Canon. Blue `#276EF1` is an open restrained interaction-accent candidate and is explicitly not the Primary CTA; preserve the distinction between role and maturity. Do not infer that approved Customer navigation blue determines CTA color.
- Existing mock repositories and demo scenarios are not production success or canonical business data.

## 10. Proposal review checklist

Before adopting this plan, confirm that: (1) the fixed phase names/IDs are preserved; (2) PR and baseline statuses are refreshed; (3) the Customer annex remains aligned to UX authority; (4) Owner/Admin proposals are explicitly approved or remain proposed; (5) open product decisions are not guessed; (6) external store rules are rechecked; (7) current task routing and official docs are updated only through their normal authority owners; and (8) each implementation is separately authorized with a scoped task contract.

