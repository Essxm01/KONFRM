# Universal state model

State presentation in KONFRM is governed by four distinct categories that must never be collapsed into a generic "status":

1. **View / Data-Lifecycle State:** data availability in viewport
2. **Action / Mutation State:** user transition lifecycle
3. **Domain / Business Status:** server-authoritative entity lifecycle
4. **Feedback / Delivery Method:** component presentation layer

---

## 1. View / Data-Lifecycle Taxonomy

Every data-driven surface explicitly supports:

| State | Contract |
|---|---|
| `LOADING` | Request in flight. Preserve structure with Skeleton where shape is predictable; bounded progress/spinner for dynamic calculations. Never show prior-account data as current. |
| `LOADED` | Canonical data successfully retrieved and populated in viewport. |
| `EMPTY` | Data request succeeded, but canonical dataset genuinely contains 0 items. Explains genuine absence with positive discovery/creation path. |
| `ERROR` | Data request failed. **An error must NEVER masquerade as Empty.** Identifies scope, plain-language failure, what remains safe, and retry path. |
| `OFFLINE` | Connectivity lost. Transactional data (money, availability) fails closed. Safe last-known read data may display with clear disconnected notice. **No offline mutation queue.** |
| `UNAUTHORIZED` | Authentication missing or expired. Distinct from Empty or generic Error. Fails closed, clears private session data, offers re-authentication with safe continuation intent. |
| `PARTIAL` | Independent section failed while others succeeded. Failed section shows scoped alert with retry; successful sections remain fully interactive. Never substitutes `0` or empty list for failed section. |
| `STALE` | Safe cached/last-known content preserved after background refresh failure. Marked honestly with neutral or soft-blue informational notice and retry. **No yellow/amber boxed styling (MR-17).** Stale prices marked non-current (`آخر سعر معروف: 3,500 ج.م (يحتاج تحديث)`). Proceeding to detail or booking re-fetches canonical server truth fail-closed. |
| `CONFLICT` | Server state changed while client was deciding (e.g. quote changed, dates booked). Blocks submission CTA, highlights exact delta in bold, and requires explicit user review and acceptance before proceeding. |

---

## 2. Action / Mutation Taxonomy

Governs the lifecycle of user commands and form submissions:

- **`IDLE`**: Control ready for user input; validation passed or untouched.
- **`SUBMITTING`**: Mutation in flight. Control disabled to prevent duplicate submission; in-flight wording displayed (e.g. *"جارٍ إرسال الطلب..."*); context preserved. No fake success animations before server confirmation.
- **`SUCCEEDED`**: Server confirmed command completion. Triggers state-appropriate feedback (Toast for routine low-risk actions; dedicated surface for contractual milestones).
- **`FAILED`**: Server rejected mutation. Control returns to interactive state; specific error message displayed near decision point.
- **`CONFLICTED`**: Server state changed; submission blocked until revalidation is accepted.
- **`DISABLED`**: Action temporarily unavailable due to unsatisfied preconditions. When reason is non-obvious, truthful explanatory helper text is required.

---

## 3. Core State Truth Invariants

1. **`ERROR != EMPTY`**: A network, server, or query failure must never render as an empty list, zero results, or blank slate.
2. **`FAILED_QUERY != FAKE_ZERO`**: A failed query must never render as a credible `0` metric, `0 ج.م` balance, or "all systems stable" status.
3. **`PARTIAL != ERROR`**: Local section failure must not collapse the entire screen. The failed section isolates its error and retry while healthy sections remain usable.
4. **`UNAUTHORIZED != ERROR`**: Session loss is an identity boundary, not a generic defect. Fails closed, clears private session data, and provides direct login redirect.
5. **`STALE != CURRENT`**: Stale safe content may remain visible for orientation, but decision-critical data (prices, availability) must never be presented as freshly verified.
6. **`CONFLICT != SILENT_SUBMISSION`**: Quotes or availability changes require explicit user review and acceptance.
7. **`CRITICAL_FAILURE != TOAST_ONLY`**: Mandatory decisions, blocking conditions, and financial failures require persistent alerts, never toasts alone.

---

## 4. The Four Critical State Questions

Every non-trivial state presentation must answer:

1. **WHAT HAPPENED?** Plain-language statement of the situation.
2. **WHAT IS STILL TRUE?** What safe context is preserved.
3. **WHAT IS UNKNOWN / NOT CURRENT?** Honest boundary of knowledge.
4. **WHAT CAN THE USER DO NEXT?** Explicit actionable recovery path.
