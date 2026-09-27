# KONFRM UI QA protocol

Use this for every visible phase; code inspection alone is insufficient.

## Viewports

- Customer/Owner: inspect `360×800`, `390×844`, and `430×932`; confirm sticky actions and bottom navigation do not obscure content.
- Admin: inspect `1280px` and `1440px` desktop widths; check useful operational density.

## Required checks

- Light-first KONFRM foundations, Cairo, semantic tokens, no unapproved navy/gradient/glass surface.
- FOUNDER_VISUAL_RULE_2026_09_27 compliance: No yellow/amber/orange boxed UI by default (cards, banners, alerts, pills, stale/recovery panels). Summer Yellow #FFD700 is a micro brand-signature accent only.
- Stale state with safely preserved canonical data must remain informational (neutral or soft-blue surface, slate/blue text/icon, blue retry) and must NEVER render warning-heavy Amber boxes.
- Shared header, navigation, or shell modifications require comparative audit across the equivalent Screen Family (AUTH, TOP_LEVEL, NESTED, TRANSACTIONAL, TERMINAL_RESULT); Screen 16 retains visible Bottom Navigation with Account active.
- Arabic/RTL ordering, dates, prices, mixed numerals, labels/icons, chevrons, form alignment.
- No clipping, overflow, accidental two-line actions, unsafe touch target, hidden fixed content, fake image/avatar/metric/status, or raw enum.
- Exercise loading, success, genuine empty, error/retry, disabled, submission, and conflict states where applicable.
- Capture actual rendered visual evidence (screenshots) for the affected flow and record viewport, state, route/context, and revision in the phase report. Green CI / successful build alone is strictly insufficient for UI acceptance.
- For a redesign, also capture the comparable pre-change state or describe the intentional before/after difference so visual regression is reviewable.

## Mandatory interaction evidence

For every affected visible flow, exercise the applicable buttons, links, navigation, primary CTA, inputs/forms, validation, loading/error/retry/conflict paths, disabled/enabled transitions, back navigation, scroll, sticky/fixed elements, bottom-navigation overlap, keyboard/input obstruction, and destructive/confirmation actions.

A screenshot is visual evidence only, not functional acceptance. Exercise every affected primary CTA unless it would require an unsafe action; record the exact reason and the safest alternative evidence when it cannot be exercised.

Do not use the mobile UX guide to override KONFRM-specific product/design authority; it is general quality guidance.
