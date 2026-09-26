# Toast and Alert

- **Toast:** transient confirmation of a completed action; concise, semantic, and not the only delivery of a critical error.
- **Alert:** persistent, actionable screen or section feedback; includes a clear title, explanation and retry/recovery action when applicable.

Both use semantic tokens only for real semantic state. Success feedback does not fabricate server success; errors do not masquerade as empty content.

## Semantic restraint

Do not use warning/amber styling to make normal product process feel urgent. A normal “request → Owner review → deposit later” explanation is informational, not a warning.

Reserve warning/danger semantics for a genuine attention or failure condition. Process education may use an open section or soft informational surface.

## Founder rule — no yellow/amber/orange alert boxes

Do not render new alert, banner, stale, retry, recovery or status containers with yellow/amber/orange fills or borders. This rule applies across Customer, Owner and Admin so one screen does not invent a visual language the rest of KONFRM does not use.

- **Stale data with safe preserved content:** neutral or soft-blue informational surface + clear retry action.
- **Ordinary in-progress/process explanation:** open/light informational treatment.
- **Genuine caution:** copy-first treatment on a neutral/light surface; a small warning icon or text accent may be amber when materially useful.
- **Error/destructive failure:** use the danger/rose family where the semantics truly warrant it.

A yellow/amber/orange boxed surface requires explicit Founder approval for a named exception.
