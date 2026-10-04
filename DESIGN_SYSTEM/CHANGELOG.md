# KONFRM Design System Changelog

## 2.1.8 — 2026-10-04

### Phase 4D Form & Selection Primitives governance synchronization

- Governed Customer + Owner product evidence inspection completed across `customer-app/` and `owner-app/` (Admin remains Web operational).
- Controlled Web visual evaluation completed across field visual strategies, radius options (6px, 8px, 10px), focus modalities, viewports, scaling, and RTL/Bidi states.
- Recorded Founder approval of system recommendation: 8px Mobile Field Radius (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`). Applies strictly to mobile field-shaped Form & Selection controls; does not alter 6px Primary Button radius (`PRIMARY_ONLY`), secondary buttons, checkboxes, toggles, cards, sheets, or global shape.
- Recorded Outline-led field baseline as system-validated provisional direction (white surface, thin neutral outline, clear boundary, no floating-label dependency).
- Formalized explicit label / helper / error hierarchy inheriting Cairo Profile B (`label` 12/600/1.35, `supporting` 12/400/1.40); floating labels not selected due to Arabic legibility and translation expansion.
- Formalized RTL / Bidi field rules: semantic start/end alignment, LTR isolation for phone/email, Western Arabic numerals (0–9), canonical money format `1,600 ج.م`, and search start/end affordances.
- Recorded semantic restrained interaction-accent focus direction (provides obvious focus without competing with Stable Black Primary CTA; pilot `#276EF1`, 2px ring, 2px halo remain Web pilot rendering references only).
- Defined Select / Picker boundary: Phase 4D owns field trigger, label, placeholder, selected value, and field semantics; bottom sheets, dialogs, and overlay container architecture remain strictly Phase 4F.
- Classified Checkbox as Owner product-evidenced (notification preferences); Toggle classified as deferred with zero current product evidence (no manufactured switch migration).
- Sizing and touch targets follow platform-appropriate guidance (iOS: 44pt; Android: 48dp); no universal raw-pixel mobile rule; visible geometry separated from interactive touch target bounds.
- Exact neutrals, exact blue, exact error red, exact focus ring/halo geometry, and native stroke width remain OPEN / implementation candidates.
- Updated Mobile Design Foundation to DF2 v1.3 (`DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`).
- Synchronized component and experience authority (`DESIGN_SYSTEM/COMPONENTS/inputs.md`, `DESIGN_SYSTEM/COMPONENTS/forms.md`, `DESIGN_SYSTEM/EXPERIENCE/FORMS_AND_CONTROLS.md`).
- No token JSON changes.
- No runtime production changes.
- No backend/database changes.
- Native component and accessibility acceptance remains strictly deferred to Phase 4I.

## 2.1.7 — 2026-10-04

### Phase 4C Action System governance synchronization

- Completed independently reviewed Phase 4C Action System evidence, formalization, and shared-governance synchronization (Stages 2, 3A, and 3B passed independent reviews with zero blockers, zero material findings, zero minor findings).
- Updated Button/IconButton component authority (`DESIGN_SYSTEM/COMPONENTS/buttons.md`) with explicit Web-vs-Mobile scope.
- Updated Action Hierarchy shared semantic specification (`DESIGN_SYSTEM/EXPERIENCE/ACTION_HIERARCHY.md`).
- Updated Mobile Design Foundation to DF2 v1.2 (`DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`).
- Recorded Contextual/Hierarchy-Based Hybrid action strategy as `SYSTEM-VALIDATED PROVISIONAL ACTION STRATEGY`.
- Recorded Stable Black `#000000` as `SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK` (with `#18181B` as fallback comparator only; not promoted to final native Canon).
- Recorded Primary radius `6px` as `PRIMARY_ONLY` provisional (not a global shape or secondary button radius decision; `SECONDARY_RADIUS: OPEN`).
- Recorded Cairo Profile B button typography `15 / 700 / 1.20` as system-validated provisional.
- Recorded Subtle Fill as default provisional secondary treatment and Conditional Neutral Outline semantic/perceptual eligibility.
- Recorded destructive consequence model and low-consequence Ghost gate.
- Recorded per-decision-point Primary uniqueness (independent decision units may each contain a primary action without competing for visual dominance).
- Recorded iOS 44pt / Android 48dp guidance with no universal raw native px rule.
- Recorded reflow contract and controlled 360px Web frame-width evidence.
- Preserved current Web token and runtime authority.
- No token JSON changes.
- No production app changes.
- No backend/database changes.
- Native component and accessibility acceptance remains deferred to Phase 4I.

## 2.1.6 — 2026-10-01

### Canonical brand asset integration & legacy logo replacement

- Integrated official KONFRM brand assets provided by the Founder in `DESIGN_SYSTEM/ASSETS/brand/`:
  - `konfrm-symbol-black.svg` — Primary canonical symbol (black K symbol on transparent background)
  - `konfrm-wordmark-black.svg` — Primary canonical wordmark (black KONFRM wordmark on transparent background)
  - `konfrm-symbol-white.svg` — Inverse symbol (white K symbol on transparent background, for dark contexts)
  - `konfrm-wordmark-white.svg` — Inverse wordmark (white KONFRM wordmark on transparent background, for dark contexts)
- Pruned speculative runtime assets; each app retains only assets it actively uses (`konfrm-symbol-black.svg`, `konfrm-wordmark-black.svg` on Customer/Owner splash, and `favicon.svg` solely for browser icon metadata).
- Migrated visible UI references across `customer-app`, `owner-app`, and `admin-app` to canonical semantic asset paths.
- Removed ambiguous duplicate legacy assets (`LOGO.svg`, `DESIGN_SYSTEM/LOGO.svg`, `owner-app/public/LOGO.svg`, `*/public/konfrm-mark.svg`).
- Reconciled Customer and Owner splash screens with DF2 v1.1 brand governance (wordmark SVG rendering, removal of yellow accent bar on Owner splash, neutral secondary subtitle).
- Updated visible browser titles to KONFRM and reconciled authority documentation (`DESIGN_SYSTEM/README.md`, `docs/DESIGN_SYSTEM.md`).
- Asset intake, replacement, and authority reconciliation only; no token changes, no generated token mutations, no backend/database behavior changed.

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
