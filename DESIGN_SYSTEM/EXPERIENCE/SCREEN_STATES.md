# Role-aware screen states

Every major data screen operates under an intentional, role-aware state presentation model:

| State | Customer | Owner | Admin |
|---|---|---|---|
| **Loading** | Skeleton preserves discovery and booking geometry; in-place spinner for quote calculations. | Preserves account boundary; shows current-account shell/skeleton, never prior Owner data. | Keeps queue/table structure with scoped skeleton/spinner, not decorative art. |
| **Empty (True)** | Explains normal absence (e.g. no bookings yet) with positive exploration guidance. | Explains operational absence (e.g. zero pending requests today) with clear status reassurance. | Explains queue is fully processed distinctly from a query error. |
| **Empty (Search / Filters)** | Explains criteria mismatch (*"لا توجد نتائج تطابق بحثك"*) with primary `[إعادة ضبط الفلاتر]` CTA. | Explains filter mismatch with actionable reset CTA. | Explains audit filter mismatch with clear filter clear affordance. |
| **Error (Screen-Level)** | Used only when top-level payload completely fails. Centered view with plain Arabic explanation and prominent `[إعادة المحاولة]`. | Centered operational error with explicit retry CTA; zero cross-account stale retention. | Centered table/overview error with clear failure scope; zero fake zero metrics. |
| **Error (Section-Level)** | Scoped alert inside failed section. Other sections remain fully interactive. | Scoped alert inside failed operational card (e.g. Wallet summary fails, Booking queue works). | Scoped alert inside failed table slice or inspector. |
| **Offline** | Transactional booking fails closed; safe last-known reads marked offline with retry. | Payouts and status transitions fail closed; cached queue marked disconnected. | Audit actions fail closed; operational disconnect prominently flagged. |
| **Disabled** | Helper text explains why action is inactive when non-obvious (e.g. missing required dates). | Helper text explains operational threshold (e.g. payout disabled because balance < 500 EGP). | Helper text explains missing permission or prerequisites. |
| **Success** | Reassuring confirmation (Screen 11 confirms request sent to Owner; deposit payment strictly follows approval). | Operational confirmation (Toast for routine edits; explicit status update for decisions). | Queue refresh with audit trail confirmation. |
| **Unauthorized** | Fails closed; clears private booking lists; displays *"انتهت جلسة تسجيل الدخول"* with `[تسجيل الدخول]`. | Fails closed; clears private wallet/ledger arrays; prompts for fresh authentication. | Blocks operational console completely until session restored. |
| **Partial** | Healthy sections interactive; failed section isolated with retry; no fake fallbacks. | Healthy queue items interactive; failed wallet summary shows scoped error panel; no `0 ج.م` fallback. | Partial table loads preserve healthy columns; failed metrics display error panel. |
| **Stale** | Cached discovery cards visible for recognition; neutral/soft-blue banner explains non-current status; prices marked non-current. | Cached queue visible with offline notice; action buttons re-verify server truth before mutation. | Cached audit list visible with explicit non-current timestamp notice. |
| **Conflict** | Dedicated review card highlights price/availability delta in bold; submit CTA disabled until accepted. | Operational conflict notice requires reload of changed booking truth. | Audit conflict flags concurrent modification by another administrator. |

---

## Screen vs Section Failure Rules

1. **Local failure never collapses the screen:** If one independent query in a multi-query screen fails, render a `SECTION_ALERT` within that specific container. Never replace the entire screen with an error view when healthy content is available.
2. **True Empty vs Zero Search Results:**
   - *Marketplace Empty:* Genuine absence of inventory. Supportive copy encouraging later exploration.
   - *Search Zero Results:* Filter mismatch. Always provide an explicit `[إعادة ضبط الفلاتر]` primary action.
3. **Session Expiry Fail-Closed Boundary:**
   - Private personal, financial, and booking data must be cleared immediately upon session expiration to prevent cross-account privacy leakage.
   - Session expiration is an identity state, not a network error.
