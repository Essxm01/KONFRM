# Universal State Presentation Contracts

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Maturity & Scoping Disclaimer:** This document governs cross-role state presentation architecture. Individual token hexes, motion dynamics, and platform implementations preserve their distinct maturity (`SYSTEM_EVALUATED_PROVISIONAL`, `CURRENT_WEB_REFERENCE`, `OPEN`, `DEFERRED_TO_4I`). It does not declare final native Canon for unsettled parameters.
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Structural Invariants:**
  - Explicit Four-Category Architecture: View/Data State, Action/Mutation State, Domain/Business Status, Feedback/Delivery Method. (These categories MUST NEVER collapse into one generic status enum).
  - 4-Tier State Delivery Hierarchy (`STATUS_BADGE`, `INLINE_TEXT`, `SECTION_ALERT / SCREEN_STATE`, `TOAST`, plus Phase 4F `DIALOG` for consequential confirmation).
  - 7 Core State Truth Invariants (`ERROR != EMPTY`, `FAILED_QUERY != FAKE_ZERO`, `NORMAL_PENDING != WARNING`, `STALE != CURRENT`, `UNAUTHORIZED != GENERIC_ERROR`, `CONFLICT != SILENT_SUBMISSION`, `CRITICAL_FAILURE != TOAST_ONLY`).
  - 4 Critical State Questions (`WHAT HAPPENED?`, `WHAT IS STILL TRUE?`, `WHAT IS UNKNOWN?`, `WHAT CAN USER DO NEXT?`).
  - Founder Prohibition: Yellow/amber/orange boxed alert surfaces are prohibited across Customer, Owner, and Admin (`MR-17`). Caution uses copy-first treatment on neutral/light surfaces.
- **Open Parameters:** Exact spinner animation timing, skeleton pulse timing, toast duration (transient, accessible), exact neutral/semantic color hexes (`OPEN / DEFERRED_TO_4I`).

---

## 2. Four-Category State Taxonomy

State in KONFRM is strictly factored into four orthogonal categories:

### Category A: View / Data-Lifecycle State (Data availability in viewport)
Governs whether canonical server data is present, in flight, absent, or unreachable:
1. `LOADING`: Initial or full-screen fetch in flight. Preserve layout structure with Skeleton where shape is predictable; progress loader for unshaped or dynamic loads. Prior-account data must never appear as current.
2. `LOADED`: Canonical server truth successfully retrieved and populated.
3. `EMPTY`: Data request succeeded, but canonical dataset genuinely contains 0 items. Explains genuine absence. Action CTA is **CONDITIONAL** (`EMPTY_STATE_ACTION: CONDITIONAL_WHEN_REAL_NEXT_ACTION_EXISTS`).
4. `ERROR`: Data request failed. **An error must NEVER masquerade as Empty.** Identifies failure boundary, safe context, and provides **STATE_APPROPRIATE_RECOVERY** (not always Retry).
5. `OFFLINE`: Network connectivity lost. Transactional data fails closed; safe cached data marked disconnected. Zero offline mutation queue.
6. `UNAUTHORIZED`: Authentication missing or expired. Identity boundary; fails closed, clears private session data, offers re-authentication with safe return intent.
7. `PARTIAL`: Localized section failed while sibling sections succeeded. Failed section isolates its scoped alert; rest of screen remains interactive. Never substitutes `0` for failed data.
8. `STALE`: Safe cached data preserved after background refresh failure. Displayed with neutral or soft-blue informative notice and refresh action. **No yellow/amber boxed UI (MR-17).** Stale prices marked non-current (`آخر سعر معروف: 3,500 ج.م (يحتاج تحديث)`). Checkout fails closed.
9. `CONFLICT`: Server truth changed during client session. Blocks submission CTA, highlights exact delta in bold, and requires explicit review and acceptance.

### Category B: Action / Mutation State (User transition lifecycle)
Governs the lifecycle of an explicit command or form submission:
1. `IDLE`: Control ready for user input; validation passed or untouched.
2. `SUBMITTING`: Mutation in flight. Single in-flight mutation guard (`SINGLE_IN_FLIGHT_MUTATION_GUARD`); in-flight verb displayed; inputs read-only. No fake success animations before server confirmation.
3. `SUCCEEDED`: Server-authoritative completion confirmed. Next presentation is governed by owning Product flow (`NEXT_PRESENTATION: OWNING_FLOW_CONTRACT`), such as local state update, Toast, queue refresh, dedicated result surface, or navigation.
4. `FAILED`: Server rejected mutation. Control returns to interactive state; specific error message displayed near decision point.
5. `CONFLICTED`: Server state changed; submission blocked until revalidation is accepted.
6. `DISABLED`: Action unavailable due to unsatisfied preconditions. When reason is non-obvious, truthful helper text is required.

### Category C: Domain / Business Status (Entity lifecycle truth)
Server-authoritative domain lifecycle enums (`properties.status`, `properties.verification_status`, `bookings.status`, `payment_transactions.status`, `owner_wallets` balances, `payout_requests.status`, `owners.verification_status`). Mapped centrally in `DESIGN_SYSTEM/COMPONENTS/badges.md`.

### Category D: Feedback / Delivery Method (Presentation tier)
Layer 1 (`STATUS_BADGE`), Layer 2 (`INLINE_TEXT`), Layer 3 (`SECTION_ALERT / SCREEN_STATE`), Layer 4 (`TOAST`), plus Phase 4F `DIALOG` for consequential confirmations.

---

## 3. Subcontract Details

### 3.1 SkeletonLoader
- **Role:** Structure-preserving neutral placeholder for predictable layouts while data is in flight.
- **Geometry:** Matches approximate dimensions of final content (e.g. 1.4:1 ratio for PropertyCard media box, line placeholders for typography).
- **Motion:** Subtle pulse or shimmer is **OPTIONAL**. System must remain fully usable under **REDUCED_MOTION** without animated shimmer. Exact motion curve is `OPEN / DEFERRED_TO_4I`.
- **Colors:** Neutral palette. Hex values (`#F1F5F9` to `#E2E8F0`) are `CURRENT_WEB_REFERENCE_ONLY`; exact native tokens remain `OPEN / DEFERRED_TO_4I`.

### 3.2 ProgressSpinner
- **Role:** Indication of in-flight mutations (`SUBMITTING`), dynamic recalculations, or unshaped data loads.
- **Semantic Roles:** `progress foreground` on light surfaces; `on-primary progress foreground` inside primary buttons.
- **Colors:** Hex values (`#0F172A` on light, `#FFFFFF` inside primary) are `CURRENT_WEB_REFERENCE_ONLY`; exact tokens remain `OPEN / DEFERRED_TO_4I`.

### 3.3 EmptyStateView
- **Anatomy:** Neutral icon/illustration + clear explanation of genuine absence + conditional next action.
- **Action Grammar:** `EMPTY_STATE_ACTION: CONDITIONAL_WHEN_REAL_NEXT_ACTION_EXISTS`.
  - Customer with no favorites: positive exploration action ("استكشف العقارات") is appropriate.
  - Owner with zero listings: onboarding action ("أضف عقارك الأول") is appropriate.
  - Admin review queue with 0 pending items: informational confirmation ("لا توجد طلبات معلقة للمراجعة") with **NO ACTION BUTTON** is the correct result.
- **Truth Invariant:** Can ONLY be shown when a successful query returned an empty collection `[]`. Never on query failures.

### 3.4 ErrorStateView & Section Error
- **Anatomy:** Warning/danger indicator + plain-language failure scope + safe context preserved + state-appropriate recovery.
- **Recovery Grammar:** `STATE_APPROPRIATE_RECOVERY`. Recovery must match the underlying cause:
  - Network / transient failure: `RETRY` (`[إعادة المحاولة]`).
  - Cache refresh failure: `REFRESH` (`[تحديث]`).
  - Session expiration: `RE-AUTHENTICATE` (`[تسجيل الدخول]`).
  - Strict filters with 0 results: `CHANGE_FILTERS` (`[تعديل الفلاتر]`).
  - Quote / price changed: `REVIEW_CHANGED_TRUTH` (`[مراجعة السعر الجديد]`).
  - Form validation: `FIX_INPUT` (field-level correction).
  - Terminal missing entity: `RETURN` (`[العودة]`).
  - Account/payout block: `CONTACT_SUPPORT` (`[التواصل مع الدعم]`).
  Universal "Retry" is prohibited when retry cannot resolve the condition.

### 3.5 StaleStateNotice
- **Presentation:** Neutral or soft-blue header notice with clear refresh trigger (`[تحديث]`).
- **Price Tagging:** Stale prices must display an honest non-current label: `آخر سعر معروف: 3,500 ج.م (يحتاج تحديث)`.
- **Fail-Closed Rule:** Proceeding to checkout or contractual actions re-fetches canonical server truth; fails closed if unverified.

---

## 4. View / Data-Lifecycle State Matrix

| View/Data State | Visual Grammar | Action / Recovery Contract |
|---|---|---|
| `LOADING` | Structure-preserving skeleton or spinner. | Interactive controls disabled during load. |
| `LOADED` | Canonical data populated in natural surfaces. | Normal screen interactions enabled. |
| `EMPTY` | Clean neutral empty surface; zero error styling. | `EMPTY_STATE_ACTION: CONDITIONAL_WHEN_REAL_NEXT_ACTION_EXISTS`. |
| `ERROR` | High-contrast error message + failure boundary. | `STATE_APPROPRIATE_RECOVERY` (Retry, Refresh, Re-auth, Return, etc.). |
| `OFFLINE` | Disconnected banner; transactional forms fail closed. | No offline mutation queue; reconnect prompt. |
| `UNAUTHORIZED` | Identity boundary; private session data cleared. | Safe login redirect preserving continuation intent. |
| `PARTIAL` | Failed section isolated with alert; rest intact. | Scoped recovery for failed section only. |
| `STALE` | Soft-blue/neutral notice; non-current tags. | Refresh action (`[تحديث]`); fail-closed checkout. |
| `CONFLICT` | High-contrast delta callout; submit CTA disabled. | Review and explicit acceptance CTA. |

---

## 5. Action / Mutation State Matrix

| Action State | Visual Grammar | Next Presentation Contract |
|---|---|---|
| `IDLE` | Form / control ready for user input. | Normal interactive state. |
| `SUBMITTING` | Spinner inside CTA; in-flight verb displayed. | `SINGLE_IN_FLIGHT_MUTATION_GUARD` (duplicate clicks blocked). |
| `SUCCEEDED` | Feedback proportional to consequence. | `NEXT_PRESENTATION: OWNING_FLOW_CONTRACT` (toast, refresh, surface, or route). |
| `FAILED` | Control re-enabled; error text pinned to action. | User corrects input or triggers appropriate recovery. |
| `CONFLICTED` | Submission blocked; delta highlighted. | User reviews newly canonical server truth. |
| `DISABLED` | Muted opacity; not-allowed indicator. | Explanatory helper text if reason non-obvious. |

---

## 6. The Four Critical State Questions

Every non-trivial state presentation must answer:

1. **WHAT HAPPENED?** Plain-language statement of the situation.
2. **WHAT IS STILL TRUE?** What safe context is preserved.
3. **WHAT IS UNKNOWN / NOT CURRENT?** Honest boundary of knowledge.
4. **WHAT CAN THE USER DO NEXT?** Explicit actionable recovery path.

*Note:* These questions govern information completeness, proportional to consequence. They do NOT mandate a rigid four-box visual layout on every screen.

---

## 7. Role Differences

- **Customer:** Empty states encourage discovery when helpful ("استكشف العقارات"). Errors avoid technical jargon. Booking conflicts explain date or price changes gently.
- **Owner:** Empty states guide onboarding when applicable ("أضف عقارك الأول"). Payout errors explain verification requirements truthfully. Stale metrics state last sync time.
- **Admin:** Dense table states. Empty queue displays informational notice ("لا توجد طلبات معلقة للمراجعة") with **NO CTA button**. System errors display technical reference codes.

---

## 8. RTL & Bidirectional Layout Rules

- **Icon / Text Flow:** State icons precede Arabic text on the right (logical `start`).
- **Recovery Actions:** Align to logical `start` or full-width depending on mobile container.
- **Bidi Codes:** Error IDs, reference numbers, and currencies use `<bdi>` tags or directional isolation to guarantee correct reading in RTL text.

---

## 9. Accessibility Contract (Web vs Native Scoping)

### A. Platform-Agnostic Accessibility Intent
- Meaningful state announcement: View state transitions and critical errors are communicated to assistive technology.
- Error association: Inline field errors are programmatically associated with their input controls.
- Focus management: Full-screen error views place initial focus logically on the recovery action; dismissed temporary states restore focus to the trigger.
- Non-color reliance: State meaning never relies on color alone; text labels, icons, and structural indicators provide redundant cues.

### B. Current Web Mapping (`CURRENT_WEB_MAPPING`)
- Dynamic state updates use `aria-live="polite"` (status/loading) or `aria-live="assertive"` (critical errors).
- Input errors link via `aria-describedby="field-error"`.
- Focus restoration handled via programmatic DOM element `.focus()`.

### C. Future Native Acceptance (`DEFERRED_TO_4I`)
- Flutter `Semantics` announcements, VoiceOver (iOS), and TalkBack (Android) live-region equivalents.
- Native accessibility node focus restoration and focus traversal order.
- Platform Dynamic Type / font scaling and reduced-motion preferences.

---

## 10. State Truth Invariants

1. **`ERROR != EMPTY`**: A network, server, or query failure must never render as an empty list, zero results, or blank slate.
2. **`FAILED_QUERY != FAKE_ZERO`**: A failed query must never render as a credible `0` metric, `0 ج.م` balance, or "all systems stable" status.
3. **`PARTIAL != ERROR`**: Local section failure must not collapse the entire screen. The failed section isolates its error and recovery while healthy sections remain usable.
4. **`UNAUTHORIZED != ERROR`**: Session loss is an identity boundary, not a generic defect. Fails closed, clears private session data, and provides direct login redirect.
5. **`STALE != CURRENT`**: Stale safe content may remain visible for orientation, but decision-critical data (prices, availability) must never be presented as freshly verified.
6. **`CONFLICT != SILENT_SUBMISSION`**: Quotes or availability changes require explicit user review and acceptance.
7. **`CRITICAL_FAILURE != TOAST_ONLY`**: Mandatory decisions, blocking conditions, and financial failures require persistent alerts, never toasts alone.
