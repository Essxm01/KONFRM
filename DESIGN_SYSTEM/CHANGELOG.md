# KONFRM Design System Changelog

## 2.1.6 — 2026-10-01

### Canonical brand asset integration & legacy logo replacement

- Integrated official KONFRM brand assets provided by the Founder:
  - `konfrm-symbol-black.svg` — Primary canonical symbol (black K symbol on transparent background)
  - `konfrm-wordmark-black.svg` — Primary canonical wordmark (black KONFRM wordmark on transparent background)
  - `konfrm-symbol-white.svg` — Inverse symbol (white K symbol on transparent background, for dark contexts)
  - `konfrm-wordmark-white.svg` — Inverse wordmark (white KONFRM wordmark on transparent background, for dark contexts)
- Deployed canonical runtime brand assets across `customer-app/public`, `owner-app/public`, and `admin-app/public`.
- Replaced legacy blue logo references across `owner-app` auth screens (`SplashScreen`, `LoginScreen`, `CreateOwnerAccountScreen`, `OwnerKycOnboarding`) and `admin-app` (`App.tsx`, `AdminLogin.tsx`) to use `konfrm-symbol-black.svg`.
- Updated compatibility runtime asset targets (`konfrm-mark.svg`, `favicon.svg`, `LOGO.svg`) with the canonical black symbol.
- Removed obsolete `DESIGN_SYSTEM/Logo Final.svg`.
- Asset intake and replacement only; no UI component redesign, no token changes, no business rule changes.

## 2.1.5 — 2026-10-01

### Founder mobile brand identity amendment

- Recorded the Founder decision that KONFRM **mobile** brand identity is monochrome-first: **Black / White** (mark and wordmark expression), confident, minimal, structured, clear — with vitality coming from real imagery/content, useful state change, interaction feedback, motion, and confident hierarchy rather than multiple brand accent colors.
- **Summer Yellow `#FFD700` removed from the core mobile brand architecture**: no longer a mobile micro-signature, CTA accent, identity color, or default decorative accent; not replaced by another secondary brand color.
- **Blue no longer the dominant mobile brand-identity color**: retained only as a restrained product interaction accent; `#276EF1` recorded as the Founder-preferred interaction-accent **candidate**, pending validation in real component contexts (CTA, active navigation, selected state, focus, link/action text, progress, pressed/disabled, contrast) before lower-level token canonicalization.
- The previous web blue `#0059FF` no longer governs the mobile primary brand/action identity; historical web token values are untouched by this amendment and must not be mistaken for the new Mobile Canon.
- Logo assets (custom K symbol + wordmark SVGs) remain outside the repository pending a separate Logo Asset Intake / Integration task; logo artwork color ≠ UI text token ≠ surface token.
- Documentation/design-authority amendment only; no token files changed, no generated files changed, no app/runtime code changed, no logo assets added, no backend/database behavior changed.

## 2.1.4 — 2026-10-01

### Mobile Design Foundation canonical specification (DF2)

- Added [`MOBILE_DESIGN_FOUNDATION.md`](./MOBILE_DESIGN_FOUNDATION.md) as the canonical mobile design foundation specification (Gate 3B follow-up): Trust/Clarity/Vitality North Star, dense-by-purpose philosophy, authority/evidence hierarchy, semantic role model, color/typography/RTL/numerals/session-state/action/motion/accessibility foundations, platform adaptation matrix, external-Skill policy, anti-patterns, and full CANONICAL NOW / IMPLEMENTATION CANDIDATE / DEFERRED classification.
- Records the Founder numeral decision for Arabic KONFRM UI: Western Arabic numerals by default (`1,600 ج.م`), RTL preserved, LTR-isolated numeric/phone/ID runs, date/calendar localization unchanged.
- Independent platform/accessibility/design-system review completed; all required corrections applied; final Bridge verification passed; DF2 promoted to canonical. Documentation/design authority only; no runtime, token, component, backend, or database behavior changed.

## 2.1.3 — 2026-09-27

### Founder visual consistency rule

- Recorded the Founder decision that Summer Yellow `#FFD700` is a micro brand-signature accent only and must not become yellow/amber/orange boxed UI (cards, banners, alerts, pills, stale/retry/recovery panels or large container fills) without an explicit named Founder exception.
- Defined stale-with-preserved-data as informational by default: preserve safe canonical content and use neutral/soft-blue recovery treatment rather than amber warning containers.
- Added screen-family navigation/header consistency: Auth, top-level, nested, transactional and terminal-result surfaces are reconciled within their own families rather than patched screen-by-screen.
- Updated Customer notification guidance: Screen 16 may exist through Account without adding a Bell to Explore.
- Documentation/design-authority update only; no runtime UI, backend, database, booking, payment or permission logic changed.

## 2.1.2 — 2026-08-23

### Founder entry and Owner UX decision sync

- Recorded approval for first-run-only Customer and Owner Splash/onboarding policy (`UX-ENTRY-01`), Owner action-first Home (`UX-OWNER-01`) and role-specific navigation (`UX-NAV-01`).
- Separated first-run branded introduction from technical bootstrap/session loading and reconfirmed that Admin has no consumer Splash/onboarding model.
- No runtime UI, business logic, backend or database changes.

## 2.1.1 — 2026-08-23

### Founder decision-state sync

- Recorded Founder approval for `UX-NAV-02`, `UX-ADMIN-CHAT-01` and `UX-ADMIN-LOGIN-01`.
- Clarified that these approvals define capability/policy only; they do not implement Favorites persistence, Admin conversation authorization or Admin login changes.
- No runtime UI, business logic, backend or database changes.

## 2.1.0 — 2026-08-23

### Product experience authority

- Added the role-specific Product Experience System, current-state UX audit, information architecture, visibility matrix, migration plan and Founder review pack.
- Documented recommendations and Founder decisions separately from approved existing rules.
- No live application UI, route, API, database or business rule changed.

## 2.0.0 — 2026-08-23

### Major governance change

- Replaced the Owner-derived SOLA extraction model with an independent KONFRM design authority.
- Established light-first surfaces, official KONFRM terminology, Cairo typography, central status presentation, and no-standard-navy-surface policy.
- Added canonical token generation, an anti-drift baseline checker and a static legacy-drift backlog.
- This release defines contracts only; it does not migrate or redesign product screens.

## 1.0.0 — 2026-08-15

- Historical forensic extraction from the Owner App. Superseded as an authority model by v2.0.0.


## Unreleased Design Lab addendum — 2026-09-18

- Added a Founder-authorized cross-role Design Lab vision covering composition, interaction grammar, role personalities, state completeness, mobile ergonomics, truth/trust presentation and acceptance philosophy.
- Added one consolidated current Customer Phase 5 screen model (01–26), including embedded surfaces and package boundaries.
- Added the C3 Screen 06 Property Details / Booking Decision final design contract.
- Extended relevant component/guideline contracts with card-soup prevention, state-aware recovery actions, canonical trust-claim rules, server-authoritative quote presentation, mobile touch/typography requirements and physical-device acceptance guidance.
- Preserved historical audits, legacy drift, tokens, generated output and implementation evidence; no product code, backend, database, finance, booking or roadmap logic changed.
