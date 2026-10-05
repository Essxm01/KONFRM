# Universal State Presentation Contracts

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Structural Invariants:**
  - 4-Tier State Delivery Hierarchy (`STATUS_BADGE`, `INLINE_TEXT`, `SECTION_ALERT`, `TOAST`).
  - 14 Universal Lifecycle States.
  - 7 Core State Truth Invariants (`ERROR != EMPTY`, `FAILED_QUERY != FAKE_ZERO`, etc.).
  - 4 Critical State Questions (`WHAT HAPPENED?`, `WHAT IS STILL TRUE?`, `WHAT IS UNKNOWN?`, `WHAT CAN USER DO NEXT?`).
  - Founder Prohibition: Yellow/amber/orange boxed alert surfaces are prohibited across Customer, Owner, and Admin (`MR-17`).
- **Open Parameters:** Exact spinner animation timing, skeleton pulse timing, toast duration (transient, accessible), and semantic color hexes (`OPEN / DEFERRED_TO_4I`).

---

## 2. Component Taxonomy & Subcontracts

The State Presentation family governs how view lifecycle, data presence, mutation progress, and errors are visually communicated:

| Subcontract | Role & Purpose | Presentation Grammar |
|---|---|---|
| `StateView` | Universal lifecycle container | Renders Full-Screen, Section, or Inline state layouts answering the 4 Critical State Questions. |
| `SkeletonLoader` | Structural placeholder for predictable data | Neutral gray shimmering boxes matching exact target component geometry. Never shifts layout. |
| `ProgressSpinner` | Dynamic calculation and in-flight loader | Restrained circular spinner for non-geometric loads and button mutation insets. |
| `EmptyStateView` | Data request succeeded with 0 items | Truthful explanation of absence + positive discovery/creation action. Never an error. |
| `ErrorStateView` | Request failed or network error | Honest scope, plain Arabic failure reason, preserved safe context, prominent retry button. |
| `StaleStateNotice` | Cached data with refresh failure | Neutral/soft-blue banner with refresh trigger. Prices marked non-current. No yellow box. |
| `ConflictStateView` | Server truth mutated during client decision | Submission blocked, delta highlighted in bold, requires explicit review and acceptance. |

---

## 3. Subcontract Details

### 3.1 SkeletonLoader
- **Geometry:** Matches exact dimensions of final loaded components (e.g. 1.4:1 ratio for PropertyCard image, 16px height lines for text).
- **Animation:** Subtle opacity pulse or linear gradient shimmer across neutral slate palette (`#F1F5F9` to `#E2E8F0`).
- **Rule:** Never jump or shift layout when data resolves. Structure must be preserved.

### 3.2 ProgressSpinner
- **Use Cases:** Button mutation states (`SUBMITTING`), dynamic financial recalculations, unshaped data fetches.
- **Color:** Neutral dark (`#0F172A`) on light surfaces; White (`#FFFFFF`) inside primary buttons.
- **Rule:** Spinners in buttons replace the leading icon or accompany the in-flight verb ("جارٍ الإرسال...").

### 3.3 EmptyStateView
- **Anatomy:** Neutral illustration/icon + clear heading ("لا توجد حجوزات سابقة") + brief explanation + positive action button ("استكشف العقارات المتاحة").
- **Truth Invariant:** Can ONLY be shown when a successful API call returned an empty collection `[]`. Never shown on network errors or 5xx responses.

### 3.4 ErrorStateView
- **Anatomy:** Warning/danger icon + plain-language failure heading + explanation of what remains safe + actionable retry CTA (`[إعادة المحاولة]`).
- **Scopes:**
  - *Screen Error:* Replaces page body when critical data cannot load.
  - *Section Error:* Bounded alert inside specific section; remainder of screen stays interactive.
  - *Inline Error:* Below specific input field during validation failure.

### 3.5 StaleStateNotice
- **Presentation:** Neutral or soft-blue header notice with clear retry button (`[تحديث]`).
- **Price Tagging:** Stale prices must display an honest non-current label: `آخر سعر معروف: 3,500 ج.م (يحتاج تحديث)`.
- **Fail-Closed Rule:** Proceeding to booking or transaction re-fetches canonical server truth; fails closed if unverified.

---

## 4. State Matrix (14 Universal States)

| State | Visual Grammar | Action / Recovery |
|---|---|---|
| `LOADING` | Geometric skeleton or bounded spinner. | Interactive inputs disabled during load. |
| `LOADED` | Canonical data populated in natural surfaces. | Normal screen interactions enabled. |
| `EMPTY` | Clean neutral empty surface; zero error styling. | Positive creation / discovery action CTA. |
| `ERROR` | High-contrast error message + failure boundary. | Actionable retry button (`[إعادة المحاولة]`). |
| `OFFLINE` | Disconnected banner; transactional forms fail closed. | No offline mutation queue; retry when online. |
| `UNAUTHORIZED` | Identity boundary; private session data cleared. | Safe login redirect preserving destination. |
| `PARTIAL` | Failed section isolated with alert; rest intact. | Scoped retry for failed section only. |
| `STALE` | Soft-blue/neutral notice; non-current tags. | Refresh action (`[تحديث]`); fail-closed checkout. |
| `CONFLICT` | High-contrast delta callout; submit CTA disabled. | Review and explicit acceptance CTA. |
| `IDLE` | Form / control ready for input. | Normal interactive state. |
| `SUBMITTING` | Spinner inside CTA; button text = in-flight verb. | Double-click disabled; inputs read-only. |
| `SUCCEEDED` | Toast (low-risk) or dedicated success surface. | Navigates to confirmed milestone view. |
| `FAILED` | Control re-enabled; error text pinned to action. | User corrects input or retries submission. |
| `DISABLED` | Muted opacity (0.5); cursor not-allowed. | Explanatory helper text if reason non-obvious. |

---

## 5. Role Differences

- **Customer:** Empty states encourage discovery ("استكشف العقارات"). Errors avoid technical jargon. Booking conflicts explain date or price changes gently.
- **Owner:** Empty states guide onboarding ("أضف عقارك الأول"). Payout errors explain verification requirements truthfully. Stale metrics clearly state last sync time.
- **Admin:** Dense table states: empty queue displays "لا توجد طلبات معلقة للمراجعة". System errors display error reference codes for technical troubleshooting.

---

## 6. RTL & Bidirectional Layout Rules

- **Icon / Text Flow:** State icons precede Arabic text on the right (logical `start`).
- **Retry Actions:** Retry buttons align to logical `start` or full-width depending on mobile container.
- **Bidi Codes:** Error IDs, reference numbers, and currencies use `<bdi>` tags to guarantee correct LTR reading in RTL text.

---

## 7. Accessibility & Focus Management

- **Live Regions:** Dynamic state changes (errors, loading completion) use `aria-live="polite"` or `aria-live="assertive"`.
- **Error Linkage:** Inline errors connect to inputs via `aria-describedby="field-error"`.
- **Keyboard Trapping:** Full-screen error views place initial focus on the retry button.

---

## 8. State Truth Invariants

1. **`ERROR != EMPTY`**: A network, server, or query failure must never render as an empty list, zero results, or blank slate.
2. **`FAILED_QUERY != FAKE_ZERO`**: A failed query must never render as a credible `0` metric, `0 ج.م` balance, or "all systems stable" status.
3. **`PARTIAL != ERROR`**: Local section failure must not collapse the entire screen. The failed section isolates its error and retry while healthy sections remain usable.
4. **`UNAUTHORIZED != ERROR`**: Session loss is an identity boundary, not a generic defect. Fails closed, clears private session data, and provides direct login redirect.
5. **`STALE != CURRENT`**: Stale safe content may remain visible for orientation, but decision-critical data (prices, availability) must never be presented as freshly verified.
6. **`CONFLICT != SILENT_SUBMISSION`**: Quotes or availability changes require explicit user review and acceptance.
7. **`CRITICAL_FAILURE != TOAST_ONLY`**: Mandatory decisions, blocking conditions, and financial failures require persistent alerts, never toasts alone.
