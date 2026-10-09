# Customer Phase 5 and Proposed Owner/Admin — Screen Contracts Draft

**Status:** DRAFT / PROPOSED / NOT CANON  
**Prepared:** 2026-10-10  
**Parent:** [`KONFRM_EXECUTION_TASKS.md`](./KONFRM_EXECUTION_TASKS.md)  
**Authority:** Customer screen identities and approved journey principles are drawn from `DESIGN_SYSTEM/EXPERIENCE/CUSTOMER_PHASE5_MASTER_UX.md`. Owner and Admin sections below are proposed planning inventories, not approved screen lists or product behavior.

## Contract rules

- Screen IDs and names below follow the approved 26-screen Customer UX inventory. A screen may be a route, modal, or webview as its UX authority specifies; the exact navigation expression is to be verified against current IA.
- “Data/API” names describe the facts needed. They do **not** invent endpoint paths, request fields, persistence tables, or state transitions. For every package, confirm the current OpenAPI/API contract and server implementation before wiring. If no verified contract exists, record an evidence gap and block business-dependent implementation.
- Server-owned facts include identity, ownership, property eligibility, availability, quote totals, booking status, deposit/remaining balance, payment result, refunds, payout and authorization. Client state may hold drafts and presentation state only.
- Every data screen needs explicit initial/loading, success, empty, error, retry, stale-data, offline/slow-network, unauthorized, and session-expired treatment as applicable. Never turn an API error into empty/zero/success.
- Accessibility baseline: semantic names/roles/states, logical focus order, keyboard operation where relevant, visible focus, text scaling and reflow, contrast, reduced motion, accessible error/status announcements, and VoiceOver/TalkBack checks. Distinguish simulated browser/profile checks from native platform evidence.
- Responsive baseline for every screen: use available mobile width and safe areas, allow text/content growth, handle orientation/window-size changes without clipping or obscuring actions, and test narrow supported phone widths plus large text. Do not assume tablet, desktop, foldable or landscape behavior is approved; confirm supported targets from the mobile architecture and record the test profile.
- Arabic is the primary direction. Isolate mixed Latin identifiers, emails, URLs, phone numbers and amounts; use locale-aware currency/date formatting only after approved locale and money-format contract is verified. Preserve semantic reading order when visual layout changes for RTL.
- Acceptance below is a minimum proposal. It cannot close a phase without applicable tests, privacy/security review, regression and required live evidence.

## 01 — Splash / App Launch

- **Purpose / user question:** Is KONFRM starting, and can the app safely restore an existing session?
- **Entry / exit:** Cold or warm launch. Continue to Welcome/Explore or the correct authenticated role route only after session validation; preserve deep-link intent where supported.
- **Canonical facts / data:** App version/configuration; persisted session validation result from the approved auth contract. No booking, payment or role status is inferred from local storage.
- **Primary action / states:** No business action. Short deterministic startup; loading, recoverable network failure, invalid/expired session and unsupported-version states.
- **Navigation / layout:** No transient splash in back stack. System status/safe areas respected; avoid flashing the wrong role or private content before authorization.
- **RTL / accessibility / privacy:** Brand mark has an appropriate accessible name if meaningful; decorative mark hidden. Do not expose tokens, phone number or prior-user data in logs/screenshots.
- **Dependencies / acceptance:** Auth bootstrap and deep-link contract. Verify cold/warm start, expired session, network loss and app resume without fabricated signed-in state or unbounded loading.

## 02 — Welcome / Guest Entry

- **Purpose / user question:** How can I browse or continue to my intended task?
- **Entry / exit:** First launch or explicit sign-out. Browse to Explore as guest; request authentication only when the selected action requires it, preserving that action.
- **Canonical facts / data:** Public app configuration and guest capability; do not imply account creation or a verified phone.
- **Primary action / states:** Browse, sign in/continue with phone (labels and auth method must match approved auth contract). Loading, offline, maintenance and retry states if configured.
- **Navigation / layout:** No role picker unless current product authority requires it. Auth interruption returns to the initiating property/booking action after success.
- **RTL / accessibility / privacy:** Arabic-first, actionable controls are keyboard/screen-reader accessible; explain guest limits plainly. Avoid requesting data before need.
- **Dependencies / acceptance:** Browse-first auth rule, auth feature availability and deep-link state. Verify guest browsing and action preservation through sign-in/cancel/back.

## 03 — Explore / Home

- **Purpose / user question:** What suitable published places can I discover?
- **Entry / exit:** Welcome, Explore tab, app resume, or return from detail. Open Search, Results, Property Details, Favorites or Account through approved IA.
- **Canonical facts / data:** Only backend-eligible published properties, location/category/configuration and explicitly approved promotional content. No hardcoded property availability, rank or price presented as live truth.
- **Primary action / states:** Search or select a property. Distinct loading, real-empty, recoverable error/retry, partial content and offline/stale states; an error must not look like “no properties.”
- **Navigation / layout:** Customer bottom navigation Explore/Favorites/Bookings/Account. Preserve filter/search context when returning where designed. Use stable card order from a documented server/client rule.
- **RTL / accessibility / privacy:** Correct image alternatives; do not place essential price/status solely in image. Readable text at scaling settings; announce result refresh when meaningful.
- **Dependencies / acceptance:** Public property API, visibility rules, image delivery and search contract. Verify unpublished/ineligible property exclusion and honest empty/error states.

## 04 — Search & Refine

- **Purpose / user question:** Which dates, place, guest count and filters should define the search?
- **Entry / exit:** Explore or Results search control; apply returns to Results, cancel returns without applying draft changes as specified by UX.
- **Canonical facts / data:** User-entered draft criteria; server-derived property availability and any authoritative filter options. A selected date range is not a reservation or hold.
- **Primary action / states:** Set destination/dates/guest count/filters and apply/reset. Validate dates/guest inputs against approved limits; errors and empty option lists remain explicit.
- **Navigation / layout:** Keyboard/date-picker flow, system back and focus restoration are specified. Embedded controls remain part of this surface, not new macro screens.
- **RTL / accessibility / privacy:** Calendar arrow direction and reading order tested in RTL; date labels announced; numeric/date fields parse Arabic/Latin input according to contract. Do not expose hidden location history.
- **Dependencies / acceptance:** Search/filter API, timezone and guest/date rules. Verify persisted criteria, clear/reset, invalid ranges, back/cancel and assistive technology.

## 05 — Search Results

- **Purpose / user question:** Which returned properties match my criteria, and what can I compare?
- **Entry / exit:** Search apply, Explore result selection, or back from details. Select a result to Screen 06; refine criteria to Screen 04.
- **Canonical facts / data:** Backend result set, published/eligible status, display price basis, property media and approved availability summary. Date-bound availability must not be called held/reserved.
- **Primary action / states:** Open details, favorite/unfavorite when authorized, sort/filter. Loading, real-empty, API error, partial image failure, pagination and stale results are distinct.
- **Navigation / layout:** Preserve scroll and search context on return; sort order and pagination source are explicit. Do not silently show mock or cached stale listings as current.
- **RTL / accessibility / privacy:** Cards expose title, location, approved price unit and favorite state as one comprehensible semantic group. Mixed Latin property IDs isolated.
- **Dependencies / acceptance:** Public search, detail link, favorites API and image storage. Verify response ordering, stale/error behavior, guest and signed-in paths.

## 06 — Property Details / Booking Decision

- **Purpose / user question:** Does this property fit, and what is the current quote for my dates and party?
- **Entry / exit:** Result, favorite, deep link. Return preserves context; continue to Screen 07 only with a valid current quote and required fields.
- **Canonical facts / data:** Published property content, approved media, server availability, 2–30-night stay rule, allowed guest count, quote and deposit/remaining breakdown as the approved API provides. Quote is not an availability hold.
- **Primary action / states:** View gallery/amenities/rules, select dates/guests, request a quote, proceed to review. Distinguish unavailable dates, invalid input, quote expiry/staleness if specified, and API failure.
- **Navigation / layout:** Gallery, dates, guests and quote are embedded surfaces, not extra primary screens. Sticky action must remain reachable without obscuring content or system insets.
- **RTL / accessibility / privacy:** Mixed-direction address/IDs isolated; media has useful alternatives; focus returns to invoking control; expanding content announces state. Do not display Owner commission/net.
- **Dependencies / acceptance:** Public detail, availability and quote contracts; UX-approved booking constraints. Verify no request is sent or inventory held by merely viewing/quoting; totals match server response.

## 07 — Booking Request Review

- **Purpose / user question:** What exact stay request and customer-facing amount am I submitting for Owner review?
- **Entry / exit:** Screen 06 continue; back returns to detail with criteria intact. Submit leads to Screen 11 only after server accepts request creation.
- **Canonical facts / data:** Property, dates, guests, authoritative quote, actual first-night deposit and remaining balance only as the approved customer DTO exposes; no internal 20/80 split.
- **Primary action / states:** Confirm and send a request for Owner approval. Revalidate quote/availability on submit; show conflict, stale quote, auth required, validation and network errors. Do not imply payment at request submission.
- **Navigation / layout:** No duplicate booking creation from repeated tap/retry; show a clear progress state with accessible label.
- **RTL / accessibility / privacy:** Currency components are formatted as one amount with stable bidi ordering; summary labels are announced before values; sensitive contact data minimized.
- **Dependencies / acceptance:** Booking-request API and idempotency contract. Confirm status is `PENDING_OWNER_APPROVAL`, request does not itself charge a card or block inventory, and error retry cannot create duplicates.

## 08 — Auth Phone Entry

- **Purpose / user question:** Which phone number should be used to access or create my account?
- **Entry / exit:** Auth-required action or Welcome. Continue to OTP only through the currently approved authentication delivery contract; back/cancel restores the prior browsing action.
- **Canonical facts / data:** Phone input and server response; no client-side claim that number is verified or account exists.
- **Primary action / states:** Submit phone. Validation, sending, rate limit, unavailable delivery, network error and recovery states must match real server behavior; no hardcoded OTP in production UI.
- **Navigation / layout:** Preserve pending destination and draft, but not secret OTP. Avoid leaking whether another user has an account unless the approved contract permits it.
- **RTL / accessibility / privacy:** Phone input direction and country code are explicit; numeric keyboard and accessible label; mask or limit display in logs and analytics.
- **Dependencies / acceptance:** Auth V2/production auth decision, OTP delivery mode, rate limiting and privacy review. Separate Founder QA fixed-OTP configuration from production.

## 09 — OTP Verification

- **Purpose / user question:** Can I verify access to this phone number?
- **Entry / exit:** Successful request from Screen 08. On server verification proceed to Screen 10 for first-time profile completion or restore the preserved target; failure remains here with recovery.
- **Canonical facts / data:** Server challenge ID, expiry, attempt and verification outcome. Local timer is display only unless backed by server expiry.
- **Primary action / states:** Submit code, request resend when permitted, edit phone. Invalid, expired, throttled, network/offline and verified states are distinct; never fake success.
- **Navigation / layout:** Prevent duplicate challenge/verification submissions; back to phone entry invalidates or preserves challenge only per auth contract.
- **RTL / accessibility / privacy:** OTP digit order/selection remains stable in RTL; each input announced; code obscured appropriately; paste/autofill only via secure platform API.
- **Dependencies / acceptance:** Auth challenge/verification contract, resend limits and session creation. Verify wrong/expired codes and no session before server success.

## 10 — First-time Profile Setup

- **Purpose / user question:** What minimum profile information is needed to use my Customer account?
- **Entry / exit:** Server-verified new Customer identity. Completion routes back to the interrupted action or Account; cancellation follows approved account rules.
- **Canonical facts / data:** Server identity and fields required by the approved Customer profile contract; one human identity with optional same-UUID Owner capability.
- **Primary action / states:** Save required profile fields. Requiredness, name format, optional fields and uniqueness must be sourced from current product/API authority. Loading/error/retry and existing-profile states explicit.
- **Navigation / layout:** Draft can survive recoverable errors; no separate identity creation for Owner capability.
- **RTL / accessibility / privacy:** Names support Arabic/Latin mixed scripts; field instructions/errors programmatically associated; collect minimum necessary personal data.
- **Dependencies / acceptance:** Auth/session and profile API, approved field policy, privacy. Verify server truth after save and interrupted-action restoration.

## 11 — Booking Request Sent

- **Purpose / user question:** Was my request recorded, and what happens next?
- **Entry / exit:** Confirmed successful request creation. Continue to Screen 13/12 or return to Explore; handle duplicated deep link idempotently.
- **Canonical facts / data:** Server-created booking identifier and actual status, submitted stay summary, current quote snapshot and response timing only if supported. `PENDING_OWNER_APPROVAL` is not approval, payment or inventory block.
- **Primary action / states:** View booking details, browse. If request outcome is ambiguous due network loss, reconcile with server before claiming success.
- **Navigation / layout:** Confirmation copy must say request sent for Owner review; no deposit payment or contractual reservation implication.
- **RTL / accessibility / privacy:** Announce success only after server confirms creation; mixed-direction booking reference isolated; no sensitive full payment details.
- **Dependencies / acceptance:** Booking-create response, status definitions, request de-duplication. Test confirmed response, timeout-after-commit recovery, and failure state.

## 12 — My Bookings

- **Purpose / user question:** What is the current server status of my requests and stays?
- **Entry / exit:** Bookings tab, account link or back from detail. Select one to Screen 13.
- **Canonical facts / data:** Authenticated Customer's server-authorized bookings, authoritative statuses/dates/property summary and payment summary as permitted.
- **Primary action / states:** Open booking, filter approved status groups, refresh. Empty, loading, stale, error and partial content are distinct; never infer cancellation/confirmation from missing data.
- **Navigation / layout:** Customer bottom navigation Bookings active. Status grouping and sorting follow an approved contract; avoid exposing Owner/Admin-only finance.
- **RTL / accessibility / privacy:** Status conveyed through text and semantics, not color alone; date ranges correctly ordered; list item has one predictable focus/activation target.
- **Dependencies / acceptance:** Customer bookings API, privacy DTO and status mapping. Verify each canonical status, empty/error/auth-expiry and role isolation.

## 13 — Booking Details / Stay Hub

- **Purpose / user question:** What is true about this booking now, and what can I do next?
- **Entry / exit:** Screen 12, Screen 11, notification deep link or chat context. Back returns to source; only show actions valid for authoritative status.
- **Canonical facts / data:** Server booking status, participants, dates/property, customer-visible financial summary, payment events, check-in/out instructions only when approved, cancellation/dispute/review eligibility only from authoritative rules.
- **Primary action / states:** Status-dependent action links; unavailable or uncertain actions explain why. Refresh/retry, conflict, forbidden, not found and stale deep-link outcomes explicit.
- **Navigation / layout:** Avoid presenting unsupported cancellation deadlines, check-in promises, no-show status, reservation lock or payment due dates.
- **RTL / accessibility / privacy:** Sensitive location/contact details disclosed only when authorized; amount/date bidi safe; status history semantically ordered.
- **Dependencies / acceptance:** Booking detail API, authorization and decisions in master register. Verify Customer can access only own booking and data/actions track server status.

## 14 — Deposit Payment

- **Purpose / user question:** Is this booking approved for deposit payment, and what exact amount/method is currently available?
- **Entry / exit:** Only an authoritative `APPROVED_PENDING_PAYMENT` state may expose prototype payment entry. Success follows the verified server/payment result; failure returns to a truthful retry/status view.
- **Canonical facts / data:** Server-approved booking, payable deposit amount, currency, payment session/result and idempotency state. Prototype mode is not a real card charge; live mode fails closed absent approved provider implementation.
- **Primary action / states:** Initiate or resume only the supported payment flow. Pending, success, decline, timeout/unknown, cancellation and duplicate callback states must reflect server/webhook truth.
- **Navigation / layout:** No payment control while `PENDING_OWNER_APPROVAL`; do not claim real money movement from a simulated response. Do not invent remaining-balance mechanics.
- **RTL / accessibility / privacy:** Never collect/store card credentials outside approved provider SDK; announce state changes; mask any provider data.
- **Dependencies / acceptance:** Phase 8 status propagation, Phase 10 payment contract, provider/legal review for live. Verify approval gate, amount integrity, idempotency and fail-closed live mode.

## 15 — Favorites

- **Purpose / user question:** Which properties have I saved, and are they still available to view?
- **Entry / exit:** Favorites tab or property action. Open Screen 06; removal updates only saved status.
- **Canonical facts / data:** Authenticated server favorites and current public property data. A saved property is not a booking, availability hold or guarantee of publication.
- **Primary action / states:** Add/remove, browse. Guest behavior must match approved auth rule; loading, truly empty, hidden/unpublished property and API error distinct.
- **Navigation / layout:** Favorites tab active; preserve scroll. Optimistic updates only with rollback and truthful pending/error feedback.
- **RTL / accessibility / privacy:** Favorite control has localized label and selected state; not color-only. Avoid exposing another account's saved list.
- **Dependencies / acceptance:** Customer favorites API and public property eligibility. Verify persistence across sessions/devices and rollback on server failure.

## 16 — Notification Center

- **Purpose / user question:** What relevant, server-backed events have been delivered to me?
- **Entry / exit:** Account-origin path with Customer navigation retained and Account active per approved UX. Tap navigates only to an authorized existing destination.
- **Canonical facts / data:** Notification event/recipient/read state from an approved model. Until event matrix is approved and implemented, show no invented count, event or unread state.
- **Primary action / states:** Open target, mark read only if supported. Loading, empty, delivery error, expired/unauthorized target and permission denied explicit.
- **Navigation / layout:** Preserve source/target deep-link behavior; OS notification settings are separate from business event truth.
- **RTL / accessibility / privacy:** Announce unread/read states; notification preview must not expose sensitive data on lock screen without approved policy.
- **Dependencies / acceptance:** Phase 9 event matrix, access, delivery and deep-link contract. Verify only recipient events appear and missing destination is handled.

## 17 — Account Home

- **Purpose / user question:** Where can I manage my own account and get support?
- **Entry / exit:** Account tab or Screen 16. Navigate to profile, settings, payments, support and approved child surfaces.
- **Canonical facts / data:** Current authenticated Customer profile summary and server-backed links. No Owner capability or admin controls exposed by inference.
- **Primary action / states:** Open children, sign out. Loading/error/session expiry distinct; partial profile is honest.
- **Navigation / layout:** Account tab active; account-origin children preserve navigation as IA specifies.
- **RTL / accessibility / privacy:** Labels and focus order; avoid showing full phone/email when unnecessary; sign-out control accessible.
- **Dependencies / acceptance:** Profile/session API and Customer IA. Verify account isolation, expiry and sign-out revocation behavior.

## 18 — Profile / Edit Profile

- **Purpose / user question:** What profile data is stored, and how do I correct it?
- **Entry / exit:** Account. Save returns to account or profile summary; discard confirms losing edits only when needed.
- **Canonical facts / data:** Server profile and explicitly allowed editable fields; client edit buffer is draft.
- **Primary action / states:** Edit/save. Validation, conflict, network failure, reauthentication and success only after authoritative server response.
- **Navigation / layout:** Preserve user edits across recoverable errors; avoid simultaneous stale overwrite.
- **RTL / accessibility / privacy:** Arabic/Latin names, semantic labels and inline errors; avoid collecting additional fields without approved reason.
- **Dependencies / acceptance:** Profile API and field policy. Verify edits persist, authorization, conflict behavior and no fabricated local success.

## 19 — Settings

- **Purpose / user question:** Which supported app, notification, language and privacy controls can I manage?
- **Entry / exit:** Account. OS settings open only through supported platform APIs; return to prior screen.
- **Canonical facts / data:** Persisted preferences and permissions only where contract exists. A device permission is not the same as an enabled server notification channel.
- **Primary action / states:** Change supported preference, privacy/account control or sign out. Unsupported settings are omitted or clearly unavailable; save/error states explicit.
- **Navigation / layout:** Do not invent locale, currency or notification guarantees; provide account deletion entry only when its approved flow is implemented.
- **RTL / accessibility / privacy:** Toggles expose current state and accessible name; reduced-motion setting follows platform/design contract; permission rationale before OS prompt.
- **Dependencies / acceptance:** Preference persistence, notification model, privacy policy and deletion decision. Test denied permission, restore, sign-out and deletion request route.

## 20 — Payment History

- **Purpose / user question:** What payment events and amounts are recorded for my bookings?
- **Entry / exit:** Account or booking. Open a booking at Screen 13; do not expose owner ledger or internal commission.
- **Canonical facts / data:** Server payment transactions and customer-facing receipts/statuses. A prototype ledger event must be identified truthfully and not presented as card settlement.
- **Primary action / states:** View transaction/receipt if supported. Empty, pending, failed, refunded, unknown and load error states distinct; no inferred refund date.
- **Navigation / layout:** Filter only by supported server fields; currency totals reconcile to authoritative response.
- **RTL / accessibility / privacy:** Amounts and references bidi-safe; downloadable receipt privacy and retention approved; status includes text and semantics.
- **Dependencies / acceptance:** Customer-safe payment DTO, transaction state and refund policy. Verify privacy, amount matching and prototype/live distinction.

## 21 — Help & Support

- **Purpose / user question:** How do I get help about my account or a specific stay?
- **Entry / exit:** Account or booking context. Route to approved support channel/form and return to source.
- **Canonical facts / data:** Published support content and case acknowledgment only after server confirms. No invented operating hours, response SLA or guaranteed resolution.
- **Primary action / states:** Read help or submit a support request where implemented. Validation, sending, success, uncertain timeout and failure states explicit.
- **Navigation / layout:** Preserve booking context only with consent and authorization; provide alternate channel if a capability is unavailable.
- **RTL / accessibility / privacy:** Plain Arabic copy, labeled fields, accessible validation; minimize personal and payment evidence.
- **Dependencies / acceptance:** Support ownership/channel, retention and escalation policy. Verify error/duplicate submission and accurate acknowledgment language.

## 22 — Booking-scoped Chat

- **Purpose / user question:** How can authorized Customer and Owner participants communicate about this booking?
- **Entry / exit:** Screen 13 when conversation exists and user is authorized. Back returns to booking; new conversation behavior only after product contract approval.
- **Canonical facts / data:** Server-authorized booking participants, messages, delivery/read state and attachment permissions. No unrestricted user search or Admin browsing by default.
- **Primary action / states:** Send text/approved attachment. Pending, sent, failed/retry, unavailable conversation, blocked access and offline states are distinct; retries do not duplicate messages.
- **Navigation / layout:** Thread context is booking-scoped; do not infer booking confirmation from a chat. Retention/read semantics remain decisions.
- **RTL / accessibility / privacy:** Message reading order, timestamps and mixed IDs correct; announce new messages without stealing focus; attachment previews protect privacy.
- **Dependencies / acceptance:** Phase 12 participant authorization, message API, attachment storage/retention and notification decisions. Verify cross-user denial, dedupe and truthful delivery.

## 23 — Dispute / Evidence

- **Purpose / user question:** How do I submit or review evidence for an eligible booking dispute?
- **Entry / exit:** Booking context only when a dispute path is approved and enabled. Submit leads to server-confirmed case status; view existing case only for participants/authorized staff.
- **Canonical facts / data:** Approved dispute eligibility, deadlines, evidence types/size, immutable case events and authorized status. Currently many such rules are open.
- **Primary action / states:** Add evidence/description or view case. Upload pending/failed, validation, deadline, unauthorized, server error and submitted states explicit.
- **Navigation / layout:** Do not fabricate refund, hold, cancellation or decision outcome. Preserve uploaded evidence only according to privacy/retention policy.
- **RTL / accessibility / privacy:** Evidence metadata and alternative text; private uploads; screen-reader progress/error; redact payment secrets and unnecessary identity evidence.
- **Dependencies / acceptance:** Founder-approved dispute lifecycle, storage ACL, audit and retention. Block policy-specific implementation while unresolved; test access and failed upload cleanup.

## 24 — Review / Rating

- **Purpose / user question:** Can I leave feedback for a completed eligible stay?
- **Entry / exit:** Eligible booking after server-confirmed completion. Submit returns to booking or review confirmation only after persisted success.
- **Canonical facts / data:** Server review eligibility, booking association, rating scale, moderation/visibility and edit rules. A pending booking is not review-eligible by assumption.
- **Primary action / states:** Enter allowed rating/comment and submit. Validation, moderation/pending state if defined, duplicate, network error and success explicit.
- **Navigation / layout:** No guarantee that a review will be published immediately absent moderation policy.
- **RTL / accessibility / privacy:** Rating control has textual labels/value, keyboard and assistive support; comment supports Arabic/mixed script; avoid exposing reviewer identity beyond policy.
- **Dependencies / acceptance:** Review schema, completion source, moderation and privacy. Verify ineligible/duplicate behavior and truthful publication status.

## 25 — Terms

- **Purpose / user question:** What current terms apply to my use of KONFRM?
- **Entry / exit:** Welcome, Account, signup gate or legal link. Return to prior route; acceptance event only where a versioned consent flow is approved.
- **Canonical facts / data:** Approved, versioned legal text and effective date from authorized source. The design pilot does not define contractual effect.
- **Primary action / states:** Read, open links, record consent only through approved auth/product contract. Load/version unavailable state must not show stale text as current.
- **Navigation / layout:** Accessible document reading, external-link behavior, text scaling and persistent scroll where appropriate.
- **RTL / accessibility / privacy:** Arabic legal document direction and numbered lists; headings/links semantic; record consent version/time only if approved.
- **Dependencies / acceptance:** Founder/legal approval, localization and version delivery. No “binding request” or “contractual reservation” semantics invented by UI.

## 26 — Privacy Policy

- **Purpose / user question:** What personal data is handled, why, with whom, and how can I exercise privacy choices?
- **Entry / exit:** Welcome, Account, signup and store metadata. Return to prior route; deletion request route only if implemented and approved.
- **Canonical facts / data:** Approved current policy, actual collection/sharing/retention behavior and subprocessors. Policy must match deployed product and store disclosures.
- **Primary action / states:** Read, request available privacy action, follow support. Missing/current-version error never substitutes fabricated content.
- **Navigation / layout:** Link to canonical web policy where available, retain source and effective date.
- **RTL / accessibility / privacy:** Accessible long-form text, semantic headings, tables/links; no sensitive diagnostics in analytics.
- **Dependencies / acceptance:** Data inventory, deletion/retention decision, provider review and legal approval. Verify in-app and store disclosures match actual SDK/backend behavior.

## Owner proposed screen families

**Status for every family below: `PROPOSED / NEEDS FOUNDER UX APPROVAL`.** These are navigable family candidates to let the Founder and UX authority review completeness and priorities. The `O-Pxx` labels are temporary planning IDs, not official routes, screen numbers, or Canon. A family may become a screen, a group of screens, a contextual sheet, or remain out of scope after review. Current React surfaces are implementation observations only.

Approved navigation direction is Owner-specific: action-first nested navigation, with **no Customer-style bottom navigation** (Mobile Design Foundation v1.7). The exact route tree and Home priorities remain gated. Do not invent a response SLA, payment rule, availability hold, payout timing, KYC completion status, notification promise, cancellation policy, or Admin decision outcome.

| Proposed family | User intent / likely entry and exit (subject to UX approval) | Canonical facts and action boundary | Role-specific UX acceptance and gate |
| --- | --- | --- | --- |
| O-P01 Entry, session and onboarding | Establish or restore Owner access; enter the operational workspace or continue approved onboarding. | Server-issued identity/role; same human UUID may have optional Owner capability. Login alone must not create Owner capability. | Distinguish authenticated Customer from Owner onboarding required; preserve task context; show session/error/empty states honestly. Founder gate: exact first-run, registration and verification sequence. |
| O-P02 Action-first Home | See what requires attention and navigate to the next valid Owner task. | Server-backed pending property/booking/action counts only; no fabricated zeros, balances or notification state. | Put actionable work before secondary analytics; each cue opens its authorized source; error is not empty. No KPI-card soup or customer-style tab bar. Founder/UX gate: priority, supported summaries and navigation hierarchy. |
| O-P03 Property workspace | Find properties and understand each canonical lifecycle state; open permitted edit/review actions. | Property owner, publication/review status, completeness and rejection reason from API. | Preserve ownership; separate draft, submitted, approved, rejected and published facts; disable or explain unavailable action without local state invention. Gate: family consolidation and exact status copy. |
| O-P04 Property create/edit | Create or correct a property draft and submit through the approved lifecycle. | Server validation and persisted property; current lifecycle; no publication bypass. | Show field-level errors, unsaved draft, retry and submission result distinctly; protect edits from stale overwrite. Gate: required fields and owner-facing submission language follow current contracts. |
| O-P05 Property media and verification evidence | Manage public listing media or submit private identity evidence as separate data classes. | Public property media versus private Owner KYC evidence and ACLs. | Never mix KYC into public media; show upload/processing/failure truth; no claimed liveness/biometric validation. Gate: exact capture, retention, access and replacement rules. |
| O-P06 Calendar and availability | Understand available/blocked dates and edit availability only where authorized. | Server property availability and canonical booking blocking statuses. `PENDING_OWNER_APPROVAL` does not block inventory; `APPROVED_PENDING_PAYMENT` and `CONFIRMED` do. | Distinguish existing bookings from Owner blocks; validate timezone/ranges; conflict and failure never appear as available. Gate: edit affordances, range semantics and schedule exceptions. |
| O-P07 Booking requests and stay details | Review the same request, then approve/reject through authorized server actions; inspect active/past stay data. | Canonical booking ID, status, dates, guest summary and allowed action; Owner approval precedes deposit. | Make request versus approval versus payment unmistakable; show server result and recovery; no payment release or legal-reservation semantics invented. Gate: rejection reasons, deadlines and request contention where unresolved. |
| O-P08 Booking-scoped conversation | Communicate about an authorized booking where chat is approved and enabled. | Authorized booking participants and server message/delivery state. | No generic user search; no delivery/read claim from local send alone; preserve booking context and data minimization. Gate: retention, attachments, unread semantics and Admin access. |
| O-P09 Wallet and payout | Understand canonical Owner-visible financial entries and any eligible payout actions. | Server ledger/balance and current prototype rules; no client reconstruction from property price. | Reconcile displayed amounts with canonical records; separate pending/available/held/reserved; never show Customer commission internals. Gate: payout timing/eligibility/provider fees and all production changes need explicit revalidation. |
| O-P10 Profile, verification status and support | Review Owner profile, verification state and approved support route. | Profile/KYC status and evidence access from authorized APIs. | Explain missing/rejected evidence only when server provides reason; never expose private evidence through public URL. Gate: editable fields, reupload path, retention, escalation and support hours. |
| O-P11 Notifications and disputes (conditional families) | Act on a notification or participate in an eligible dispute only if the respective product capability is approved. | Real event recipient/read model; approved dispute status and evidence policy. | Existing modal/bell surfaces do not establish a notification product contract. Do not promise delivery or outcomes. Gate: notification event matrix and dispute policy before route/CTA is committed. |

### Owner-specific UX acceptance outline

- **Action hierarchy:** the first view exposes actionable work and canonical state; owner can identify what needs attention, why, and the next authorized action without scanning decorative metrics.
- **Data truth and recovery:** counts/balances/statuses come from authorized API data; loading, true empty, partial, stale, failure, conflict and retry are distinguishable. A failed query never becomes zero or available inventory.
- **Workflow integrity:** property and booking actions preserve server state and return a confirmed result; repeated taps/retries do not duplicate writes. No business outcome is inferred from client navigation.
- **Financial comprehension:** show only Owner-appropriate canonical values and approved prototype rules. Explain amount basis without inventing release dates, fees, tax, refund or remaining-balance behavior.
- **Private evidence:** KYC capture/view/download and transfer behavior respects private storage, authorization, minimization and retention. No biometric/liveness claim.
- **Platform/accessibility:** Arabic-first Cairo layout and RTL, mixed-script isolation, responsive reflow, semantics, focus/keyboard, contrast, reduced motion, text scaling and screen-reader checks. Record simulated versus physical Android/iOS evidence.
- **Approval gate:** Founder/UX approves family map, route hierarchy, Home priorities, labels and interaction behavior before implementation scope or any design decision is treated as Canon. Business-policy gates remain separately required.

## Admin proposed screen families

**Status for every family below: `PROPOSED / NEEDS FOUNDER UX APPROVAL`.** The `A-Pxx` labels are temporary planning IDs, not official routes, screen numbers, or Canon. Existing React queues/details are observed implementation evidence; they do not establish a complete target IA. Admin remains a desktop Web surface. A disabled notification bell is not a committed destination.

| Proposed family | Operator intent / likely entry and exit (subject to UX approval) | Canonical facts and action boundary | Role-specific UX acceptance and gate |
| --- | --- | --- | --- |
| A-P01 Admin access and session | Sign in and reach only authorized operational areas; recover expired/denied sessions. | Server-verified Admin identity, role, session and permission. | Fail closed; no credential leakage or Customer/Owner session confusion; denial and expiry are explicit. Gate: exact role/permission matrix and recovery route. |
| A-P02 Operational overview | See current workload and operational exceptions, then navigate to a real queue or source. | Server-backed counts and state with defined freshness; no fake zero or hardcoded success. | Every counter is traceable to records; partial/error/stale is visible; no action-less metric. Gate: approved metric definitions and destinations. |
| A-P03 Owner verification queue and detail | Find an Owner review and inspect authorized private evidence/reasons. | Canonical Owner/KYC status, private documents, audit events and allowed decision. | Need-to-know access, safe previews, no public evidence URL, clear missing/unavailable versus empty, no liveness assertion. Gate: evidence visibility, retention, reviewer roles and reason taxonomy. |
| A-P04 Property review queue and detail | Review property eligibility and record an authorized approval/rejection with reason. | Canonical property content/media, lifecycle status, server policy and audit history. | Decision preview names its target; state changes only after server confirmation; reason reaches the Owner where contract requires; failures do not appear approved. Gate: complete review policy/reason schema. |
| A-P05 Payout operations queue and detail | Inspect canonical payout request/ledger state and perform only authorized operations. | Server ledger, request state, eligibility, provider result and audit record. | Reconcile amounts and status; distinguish requested/processing/paid/failed; no fabricated payout or invented accounting action. Gate: production payout and reconciliation rules/legal/provider decision. |
| A-P06 Dispute operations queue and detail | Review an eligible case and evidence under an approved dispute process. | Authorized parties, case/evidence, deadlines, decisions and financial effects only when approved. | Protect evidence, expose complete decision context, record reason/audit and show no outcome before server confirmation. Gate: cancellation/refund/dispute policy and Admin authority. |
| A-P07 Audit, search and operational filters | Locate authorized records and understand decision history. | Existing canonical IDs, event history and access rules; no new permission implied by search. | Search/filter terms and result scope are explicit; preserve authorization and avoid false absence from partial query; audit actions are attributable. Gate: allowed fields, retention and role visibility. |
| A-P08 Notifications (not committed) | No target family is proposed until a real operator action, recipient/event model and destination are approved. | Existing bell/API surface alone is insufficient evidence. | Do not create a no-op panel or fictitious unread counts. Gate: business event, Admin audience, permission, delivery, read semantics and destination. |

### Admin-specific UX acceptance outline

- **Decision quality:** each review/operation presents the canonical record, evidence, policy context and permitted action together; consequential decisions state the target and require confirmation where approved.
- **Audit and truth:** queue totals reconcile to returned records; stale/partial/error states are not success or zero; each persisted decision/reason and actor is visible through the approved audit contract.
- **Least privilege:** Admin role permissions are explicit; KYC/private evidence is access-controlled; queue/search/detail do not bypass API ownership or authorization. Do not infer broader Admin access from a Web route.
- **Operational clarity:** distinguish pending review from failed retrieval, payout request from payment completion, and dispute review from refund/cancellation outcome. No unapproved policy or financial operation appears as an available control.
- **Desktop accessibility:** semantic headings/tables/forms, keyboard navigation and visible focus, non-color-only statuses, zoom/reflow where supported, readable dense data, accessible dialogs and errors; validate with target browsers and assistive technology.
- **Approval gate:** Founder/Operations/UX approve family map, operator permissions, queue metrics, decision reasons, audit visibility and destinations before implementation. Dispute/payout actions additionally wait for their separate policy and finance gates.

## Cross-screen acceptance matrix

### Per-screen component and responsive inventory

This names the minimum component roles each screen contract must cover. Exact shared component names are implementation choices governed by the Design System; do not create one-off components where an approved shared primitive fits.

| Screen | Minimum UI components to contract | Responsive acceptance |
| --- | --- | --- |
| 01 | Brand mark, startup progress/status, retry action when needed | Safe-area aligned; no fixed-height assumption; startup remains usable with large text. |
| 02 | Welcome heading, guest browse action, auth action, concise benefit/limit copy | Primary actions stack/reflow on narrow width; no horizontal clipping at supported text scale. |
| 03 | Search entry, category/curation section, property cards, bottom navigation | Cards adapt to available phone width; no hard-coded desktop grid in mobile app. |
| 04 | Destination/date/guest/filter inputs, calendar/date picker, apply/reset actions | Controls reflow vertically; calendar labels remain readable in narrow width and large text. |
| 05 | Results header/count, sort/filter controls, property cards, loading/empty/error views | Cards remain single-column on narrow phones unless approved otherwise; controls wrap without hiding results. |
| 06 | Property gallery, identity/amenity sections, availability selector, guest control, quote summary, sticky action | Sticky area respects safe area and keyboard; content scrolls behind no overlay; gallery and summary reflow without fixed viewport height. |
| 07 | Request summary, amount breakdown, policy/next-step copy, submit action, progress/error states | Amount labels wrap without separating values; submit remains reachable and is not obscured by system insets. |
| 08 | Country code/phone field, validation message, submit action, progress/error state | Country code and number do not collide in RTL; field/action reflow at narrow width. |
| 09 | OTP entry, resend/edit actions, expiry/status announcement, error state | Inputs remain operable with on-screen keyboard and large text; no clipped code cells. |
| 10 | Profile fields, consent links if approved, save action, validation state | Fields stack; errors expand form height; save remains reachable when keyboard is open. |
| 11 | Server-confirmed status panel, booking reference, next-step action, explore action | Long references and status text wrap; actions remain visible without implying payment. |
| 12 | Booking status filters/groups, booking cards, refresh/empty/error states, bottom navigation | Status tabs scroll/reflow accessibly; cards fit narrow width and 200% text. |
| 13 | Booking summary, status timeline, financial summary, status-eligible actions, support/chat links | Dense summaries become vertical; actions do not overflow; long property/booking IDs isolate and wrap. |
| 14 | Approved payment amount, provider/prototype surface, progress/result/retry states | Provider surface fits available insets/keyboard; amounts and error copy reflow; no fixed modal clipping. |
| 15 | Favorite property cards, remove/favorite controls, empty/error/loading views, bottom navigation | Cards and controls fit narrow phones; favorite action remains separately targetable. |
| 16 | Notification list items, read/unread state, empty/error state, deep-link destination | Event copy wraps; read state not communicated by color alone; retained bottom navigation fits. |
| 17 | Account identity summary, profile/settings/payment/support rows, sign-out action, bottom navigation | Account rows reflow with long Arabic labels and large text; no truncated essential action. |
| 18 | Editable profile fields, validation, save/cancel, conflict/error feedback | Form height expands; keyboard, focus and save action remain manageable at large text. |
| 19 | Settings rows, supported toggles, permission explanation, privacy/account actions | Labels wrap next to controls without overlap; toggles remain operable at large text. |
| 20 | Payment event list, amount/status/reference rows, filters and empty/error states | Amount and reference rows reflow; no horizontally clipped transaction details. |
| 21 | Help topic list/content, support form if approved, submit/error/acknowledgment state | Long-form copy and form fields reflow; external support actions remain reachable. |
| 22 | Message list, composer, attachment control if approved, delivery/error state | Keyboard/composer/safe area interaction verified; long messages wrap without forcing horizontal scroll. |
| 23 | Case status, evidence list/uploader if approved, progress/error state, submit action | Evidence metadata and upload controls reflow; progress/errors do not cover other actions. |
| 24 | Eligibility/status explanation, rating control, comment field, submit state | Rating controls remain labeled and usable; comment field and errors grow vertically. |
| 25 | Version/effective-date header, semantic legal headings/lists/links, consent action if approved | Long legal text scrolls and reflows; no fixed-height document pane or horizontal clipping. |
| 26 | Version/effective-date header, semantic privacy sections/links, deletion/contact action if approved | Long privacy text reflows; action links remain distinguishable and reachable at large text. |

## Cross-screen acceptance matrix

| Area | Evidence required before declaring screen complete |
| --- | --- |
| Truth | API contract and server source confirm displayed values and allowed actions; errors do not become zero/empty/success. |
| Navigation | Entry/exit, back, deep link, interrupted action, tab state and focus restoration tested. |
| Arabic / RTL | Arabic and mixed-direction representative data, money/date/ID rendering and reading order verified. |
| Accessibility | Semantics, keyboard/focus, screen reader, text scaling/reflow, contrast and reduced motion evidence on stated target/profile. |
| Privacy/security | Role ownership, least data, private-media access, logs/analytics and deletion/retention impact reviewed. |
| Reliability | Loading/empty/error/timeout/conflict/offline/retry and duplicate-submit scenarios tested with controlled fixtures. |
| Platform | Android and iOS differences recorded; native/hardware evidence is explicitly distinguished from simulator, browser and profile simulation. |

