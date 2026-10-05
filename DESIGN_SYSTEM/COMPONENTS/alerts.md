# Toast and Alert

KONFRM delivers feedback and recovery through a disciplined, four-tier hierarchy governed by consequence, density, and role context:

## Four-tier state delivery hierarchy

1. **Layer 1 — Identification (`STATUS_BADGE` / `LABEL`):** Used when the user simply needs to recognize a canonical state (e.g. a confirmed booking in a list, a published property). Badges identify state; they do not substitute for explanatory copy.
2. **Layer 2 — Contextual Explanation (`INLINE_TEXT` / `OPEN_TYPOGRAPHY`):** Used for normal procedural guidance (e.g. *"طلبك وصل للمالك وبانتظار قراره"*). Relies on clean typography on natural surfaces without box wrappers. Zero response SLA is promised.
3. **Layer 3 — Actionable Recovery (`SECTION_ALERT` / `SCREEN_STATE`):** Persistent, actionable feedback used when an action is blocked, a query fails, or revalidation requires user attention. Always includes scope, plain-language explanation, and an actionable retry/recovery button.
4. **Layer 4 — Transient Confirmation (`TOAST`):** Reserved exclusively for transient confirmation of completed, low-risk actions (e.g. *"تم حفظ التغييرات"*). Exact toast duration is **OPEN / component-and-platform-gated** (transient, long enough to perceive and read, deferred to Phase 4H / native accessibility validation).

### Consequential decision overlay
Irreversible, high-consequence decisions invoke the already-governed Phase 4F `DIALOG` overlay surface (`DIALOG_CONSEQUENCE`). Dialogs are an existing overlay mechanism, not a fifth state-delivery tier.

## Critical error rule
**Critical errors, financial warnings, and mandatory decisions must NEVER rely solely on toasts.** Durable errors require persistent section or screen alerts.

## Semantic restraint
- Do not use warning/amber styling to make normal product process feel urgent. Ordinary operational milestones (`PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, `Wallet PENDING`, `PENDING_VERIFICATION`) map to neutral/process styling, not warnings.
- Reserve warning/danger semantics for a genuine attention, consequential risk, or failure condition supported by canonical data.
- Process education uses open section typography or soft informational surfaces.

## Founder rule — no yellow/amber/orange alert boxes

Do not render alert, banner, stale, retry, recovery or status containers with yellow/amber/orange fills or borders. This rule applies across Customer, Owner and Admin so one screen does not invent a visual language the rest of KONFRM does not use.

- **Stale data with safe preserved content:** neutral or soft-blue informational surface + clear retry action (`[تحديث]`).
- **Ordinary in-progress/process explanation:** open/light typography on natural surfaces without box borders.
- **Genuine caution:** copy-first treatment on a neutral/light surface; a small warning icon or text accent may be amber when materially useful.
- **Error/destructive failure:** use the danger/rose family where the semantics truly warrant it.

Exact semantic tokens and hex colors remain **OPEN / token-gated**.
