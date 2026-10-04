# Current project state

**Last updated:** 2026-10-05
**Merge checkpoint:** `ff4ac0b4322b8a7c50273dd7a459a93dcf090551` (PR #95)
**Phase status:** Phase 0–3 complete; Phase 4 is `ACTIVE`. Phase 4A is `CLOSED`; Phase 4B Typography Foundation is `CLOSED / MERGED`; Phase 4C Action System is `CLOSED / MERGED` (PR #90); Phase 4D Form & Selection Primitives is `CLOSED / MERGED / PUBLISHED` (PR #92); Phase 4E Structural System is `CLOSED / MERGED / PUBLISHED` (PR #95); Phase 4F Navigation & Overlay System is `ACTIVE`.
**Cross-cutting governance infrastructure:** `DESIGN_COURT_V1` — `CLOSED / MERGED / PUBLISHED` (PR #93, merge checkpoint `674194e675731985b347d241d046f6acc48cf785`; 14 governed design skills, 8 internal; available as cross-cutting design-decision system).
**Publication evidence:** PR #19 merged (Phase 3); PR #86 merged (Phase 4A Primitive Pilot 01); PR #87 merged (Continuity & Roadmap); PR #88 merged (Phase 4B Cairo Typography Foundation); PR #90 merged (Phase 4C Action System); PR #92 merged (Phase 4D Form & Selection Primitives); PR #93 merged (Design Court v1 Governance Infrastructure); PR #95 merged (Phase 4E Structural System).

## Current status

KONFRM is currently executing **Phase 4 — Unified Design System / UI/UX Program**:
- **Phase 4A (Controlled Primitive Pilot 01):** `CLOSED`. Primary button radius selected at 6px. Primary color strategy selected as Stable Black. Status: Founder-Selected Provisional Design Foundation Candidate.
- **Phase 4B (Cairo Typography Foundation):** `CLOSED / MERGED` (PR #88, merge checkpoint `4cad3a4b0f9901e5315c35e6712e3e4a35f4cba5`). Primary UI font family established as Cairo. Founder visual preference selected as **Profile B — Mobile Balanced Candidate**. Status: **`SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY`** (System coherence verdict: `COHERENT_WITH_MINOR_FUTURE_COMPONENT_DEPENDENCIES`).
  - Profile B values: display 24/700/1.30, pageTitle 20/700/1.35, sectionTitle 17/700/1.40, cardTitle 15/700/1.40, body 14/500/1.50, bodyStrong 14/700/1.50, label 12/600/1.35, supporting 12/400/1.40, numeric 16/700/1.30, button 15/700/1.20.
  - Profile B is provisional design foundation, **NOT** promoted to final native Canon.
  - Exact primary black: **`#000000`** (**`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`**; validated in Phase 4C; `#18181B` fallback comparator only; not promoted to final native Canon).
  - Exact blue: **`OPEN`** (Restrained blue interaction-accent role is governed direction; `#276EF1` is pilot candidate only).
  - Exact neutral palette: **`OPEN`**.
  - Known Profile B Web stress evidence: 5 / 24 overflow cases under extreme scaling (150% and 200%). Causal classification: **`MIXED`**. Profile-selection impact: **`MINOR`**.
  - Native Flutter typography acceptance: **`DEFERRED TO 4I`**.
- **Phase 4C (Action System):** `CLOSED / MERGED` (PR #90, merge checkpoint `95e3789ae824cdc6ca0a6608f1752f3137ac5ac5`). Independent review: Stage 2 PASS, Stage 3A PASS, Stage 3B PASS (Blockers: NONE, Material findings: NONE, Minor findings: NONE). Design-System documentation/evidence publication only; no production-app, backend, database, or token JSON changes.
  - Action Strategy: **`CONTEXTUAL_HIERARCHY_HYBRID`** (`SYSTEM-VALIDATED PROVISIONAL ACTION STRATEGY`).
  - Exact Mobile Primary Black: **`#000000`** (`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`; `#18181B` fallback comparator only; not promoted to final native Canon).
  - Primary button radius: **`6px`** (`PRIMARY_ONLY` provisional; full global shape system and secondary radius remain open).
  - Button typography: Cairo Profile B **`15 / 700 / 1.20`** (`SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY`).
  - Neutral Secondary: **`Subtle Fill`** (default provisional secondary treatment); **`Conditional Neutral Outline`** (semantic/perceptual eligibility gated).
  - Destructive: consequence-aware model (Destructive Primary restricted to explicit confirmation context; Destructive Secondary outline for subordinate pairing; Destructive low-emphasis/Ghost gated to genuinely low consequence).
  - Primary uniqueness: per active decision point / independent decision unit.
  - Sizing & touch targets: iOS 44pt / Android 48dp guidance (no universal raw-pixel target).
  - Reflow: controlled 360px Web frame-width evidence.
  - Native component and accessibility acceptance: **`DEFERRED TO 4I`**.
  - Open variables preserved: Secondary Radius (`OPEN`), Exact Neutrals (`OPEN`), Exact Blue (`OPEN`, candidate `#276EF1`), Exact Destructive Color (`OPEN`), Exact Native Focus Treatment (`OPEN`), Global Shape System (`OPEN`), Cancellation/Refund Policy (`OPEN / UNDECIDED`), Token-File Authoring (`SEPARATELY GATED`).
- **Phase 4D (Form & Selection Primitives):** `CLOSED / MERGED / PUBLISHED` (PR #92, merge checkpoint `0134f60984d5d52f3442ef49763bf6c75a564214`; reviewed head `b3d7fb1b57ab8d4a8adb3e1941710ab68c6aefad`). Governed Customer + Owner evidence inspection and controlled visual pilot complete. Design-System documentation/evidence publication only; no production-app, backend, database, or token JSON changes.
  - Web pilot outline reference: `#8E8E93` (~3.26:1 against `#FFFFFF`; pilot rendering reference only, exact neutrals remain `OPEN`).
  - Field Strategy: **`OUTLINE_LED`** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`; white surface, thin neutral outline, explicit top label, separate helper/error, no floating labels).
  - Mobile Field Radius: **`8px`** (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`; applies strictly to mobile field-shaped controls; does not alter 6px Primary Button radius `PRIMARY_ONLY`).
  - Focus Direction: **`RESTRAINED_INTERACTION_ACCENT`** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`; Web pilot `#276EF1`, 1px accent field border + 3px outer halo are rendering references only).
  - Selection Controls: Checkbox is **`OWNER_PRODUCT_EVIDENCED`** (notification preferences); Toggle is **`DEFERRED_NO_CURRENT_PRODUCT_EVIDENCE`** (zero product evidence; no switch migration).
  - Sizing & Touch Targets: iOS 44pt / Android 48dp guidance (no universal raw-pixel mobile rule).
  - Open variables preserved: Exact Neutrals (`OPEN`), Exact Blue (`OPEN`, candidate `#276EF1`), Exact Native Focus Treatment (`OPEN`), Exact Native Stroke Width (`OPEN`), Global Shape System (`OPEN`), Native Acceptance (`DEFERRED TO 4I`).
- **Phase 4E (Structural System):** `CLOSED / MERGED / PUBLISHED` (PR #95, merge commit `ff4ac0b4322b8a7c50273dd7a459a93dcf090551`; branch `design/structural-system-pilot-01`, base checkpoint `674194e675731985b347d241d046f6acc48cf785`). Controlled visual pilot (`DESIGN_SYSTEM/PILOTS/structural-system-pilot-01/`), Design Court v1 deliberation, and Founder gate complete. Design-System documentation/evidence publication only; zero changes to production apps, backend, database, or token JSON.
  - Founder Decision: **Option C — Role-Aware Hybrid Structural System** (`APPROVED`).
  - Customer Grammar: `OPEN_EDITORIAL_DEFAULT` (unboxed facts, whitespace, restrained dividers / subtle hairline-style separation; cards restricted to independent discovery/quote units).
  - Owner Grammar: `OPERATIONAL_GROUPING_DEFAULT_WHEN_SEMANTIC` with `OPEN_GROUPED_CONTENT` (one outer 12px container, subtle internal dividers for homogeneous operational records; anti-card-soup; exact native stroke width `OPEN` / `DEFERRED_TO_4I`).
  - Admin Grammar: `DESKTOP_WEB_PRESERVED` (desktop data table/audit boundary preserved).
  - Mobile Structural Container Radius: **`12px`** (`SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`; bounded evidence: 10px valid close alternative, 12px balanced provisional system tie-breaker, 16px materially rounder with higher generic-SaaS styling risk; `NO_MATERIAL_FOUNDER_DECISION_REQUIRED: YES`).
  - Mobile Page Horizontal Insets: **`16px`** (`SYSTEM-EVALUATED PROVISIONAL MOBILE_PAGE_INSET`; page insets != platform safe-area insets).
  - Relational Spacing Scale: Canonical relational hierarchy `TIER_1 < TIER_2 < TIER_3 < TIER_4`; **`4 / 8 / 12 / 16 / 24 / 32 px`** (`SYSTEM-EVALUATED PROVISIONAL NUMERIC MAPPING`; 40/48px sizing clearances observed in Web pilots are not part of formal spacing scale).
  - Surface Elevation: Flat elevation default with subtle neutral border; shadow/elevation reserved exclusively for floating/modal surfaces (`ELEVATION_RESERVED_FOR_OVERLAYS`).
  - Open variables preserved: Exact Neutrals (`OPEN`; Phase 4E pilot hex values are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE` only), Exact Blue (`OPEN`, candidate `#276EF1`), Exact Native Stroke Width (`OPEN` / `DEFERRED_TO_4I`), Global Shape System (`OPEN`, Phase 4F/4I scope), Native Component Acceptance (`DEFERRED TO 4I`).
- **Design Court v1 (cross-cutting governance infrastructure):** `CLOSED / MERGED / PUBLISHED` (PR #93, merge commit `674194e675731985b347d241d046f6acc48cf785`). Adds `konfrm-design-court` as the 8th internal governed skill (14 governed skill directories). Available as cross-cutting design-decision system.

The connected property vertical slice through Phase 3 remains live-verified on production. Phase 4 develops the design foundations through controlled empirical pilots before native mobile integration.

## Implemented areas

- **Phase 3 property vertical slice:** `LIVE_CLOSED` on main `9ef59f64008db16df0386ac92c5d64bfc8c73b58`. Owner → Admin → Renter same-entity propagation was live-verified end to end. Owner property status revalidation is property-scoped and protected against out-of-order responses. Customer Property Detail fetches the canonical public detail contract and no longer fabricates description, amenities, location, images, capacity, type, or house-rule truth.
- **P2.3 Owner API Contract:** closed, merged, deployed, and live-verified before Phase 3. Owner profile/property/calendar/booking-financial/wallet reads use canonical server truth and fail-closed behavior.
- **Properties (M03/P1.3):** owner draft/create, canonical image upload/media records, submission, Admin review queue/detail/approval, public visibility, and same-property live propagation are closed through Phase 3.
- **Bookings:** Customer request lifecycle, Owner approve/reject, availability protection, and booking-context conversation/message persistence.
- **Payments:** prototype deposit initiation/completion with canonical financial summaries and migration `019` atomic finalization RPC; no real-money Paymob flow.
- **Wallet:** Owner wallet/ledger reads use `owner_wallets` and `wallet_ledger_entries`, not property-price reconstruction.
- **Identity/access:** P0.2 is published at `6d37b4589fca47fe56b294c4c12292b44a2db138`; P1.2 closed canonical session persistence at `92dc3916…`. See [`codex/P1_2_IDENTITY_SESSION_PERSISTENCE_REPORT.md`](./codex/P1_2_IDENTITY_SESSION_PERSISTENCE_REPORT.md).
- **Truthful states:** Admin validates sessions before shell render; Owner and Customer property surfaces distinguish loading/success/error truthfully and do not use fabricated canonical property data.
- **Owner entry:** first-ever device flow is a short KONFRM splash then one-time Owner onboarding; it is independent of authentication and does not change Owner capability rules.
- **Owner Home:** action-first Home uses canonical pending booking requests, future confirmed bookings, property status context, and direct available/pending wallet values; it does not use dashboard financial aliases as wallet truth.
- **Owner registration/KYC:** explicit Owner registration is separate from login and preserves a Customer’s UUID when adding the Owner extension. New Owners submit National ID front, National ID back, and a fresh face image to the private `owner-verification` bucket; the package becomes pending Admin review only after all three files validate.
- **Governance:** `DESIGN_SYSTEM/` is independent KONFRM visual/product-experience authority. The `docs/codex/` layer records phase authority, conflicts, evidence classification, quality gates, and sequencing without replacing source specifications.
- **Customer Favorites:** repository-implemented with migrations `028_customer_favorites.sql` and `029_customer_favorites_acl_hardening.sql`, backend customer endpoints, and Customer client integration. Any remaining live migration evidence remains governed by its own task evidence.

## Active architecture

- React/Vite apps call the TypeScript backend at `/api/v1`.
- Backend routes run through Node or Cloudflare Worker adapters, repositories, and a narrow Supabase REST/RPC compatibility layer.
- Supabase PostgreSQL and Storage are canonical. Payment prototype mode is explicit.

Read [ARCHITECTURE.md](./ARCHITECTURE.md), [DATABASE.md](./DATABASE.md), and [BUSINESS_RULES.md](./BUSINESS_RULES.md) only when the task touches those domains per [CONTEXT_ROUTER.md](./CONTEXT_ROUTER.md).

## Verified technical debt / known limits

- `dbClient.ts` remains a strict SQL-to-Supabase REST/RPC compatibility layer, not a general Worker transaction/query solution. Matcher collisions are a known risk.
- P1.1 reconciled retained migrations with live metadata. The live application ledger omits 013/014/017/018 despite their observed effects; 015 is repository-ahead of the observed session/OTP shape; the `000_schema_baseline` source remains unavailable. See [`codex/P1_1_SCHEMA_RLS_BASELINE_REPORT.md`](./codex/P1_1_SCHEMA_RLS_BASELINE_REPORT.md).
- Live public tables have RLS enabled and no policies, with the backend using service-role access. P14.1 is closed: migration `021_harden_critical_rpc_privileges.sql` was applied/read-only-verified; the four critical payment/KYC/registration RPCs are no longer executable by `anon` or `authenticated` and remain executable by `service_role`.
- Payment is intentionally `PROTOTYPE`; real Paymob credentials/networking are not implemented.
- Design-system legacy drift remains inventoried under `DESIGN_SYSTEM/`; the anti-drift baseline prevents new violations but does not migrate old screens.
- Cloudflare Pages project linkage/revision state remains external to repository configuration and requires live verification after frontend deployment work.
- Local baseline runtime retains the documented Node-version caveats; use the repo/CI runtime evidence rather than shell-specific assumptions.

## Open product/implementation decisions

- Complete cancellation/refund and remaining-balance payment policy should be confirmed before a task changes those paths.
- Any migration away from the Worker database compatibility adapter requires an explicit architecture decision.
- Approved experience recommendations not marked `APPROVED_EXISTING` in `DESIGN_SYSTEM/EXPERIENCE/DECISIONS.json` still need Founder/Product approval before implementation.

## Next work

**Active Roadmap Phase & Governance Continuity**

- **Phase 4E (Structural System):** `CLOSED / MERGED / PUBLISHED` (PR #95, merge commit `ff4ac0b4322b8a7c50273dd7a459a93dcf090551`).
  - Structural Model: `ROLE_AWARE_HYBRID`
  - Customer: `OPEN_EDITORIAL_DEFAULT`
  - Owner: `OPERATIONAL_GROUPING_WHEN_SEMANTIC`
  - Structural Container Radius: `12PX SYSTEM-EVALUATED PROVISIONAL`
  - Mobile Page Inset: `16PX SYSTEM-EVALUATED PROVISIONAL`
  - Spacing Mapping: `4/8/12/16/24/32 SYSTEM-EVALUATED PROVISIONAL`
  - DF2: `v1.4`
  - CHANGELOG: `2.1.9`
- **Active Phase:** **Phase 4F — Navigation & Overlay System**
  - **Status:** `ACTIVE`
  - **Execution Started:** `YES`
  - **Branch:** `design/navigation-overlay-pilot-01`
  - **Base Checkpoint:** `ff4ac0b4322b8a7c50273dd7a459a93dcf090551`
- **Next roadmap dependency:** Phase 4G — Content & State Presentation (`STATUS: NOT_STARTED`, `EXECUTION_STARTED: NO`).
