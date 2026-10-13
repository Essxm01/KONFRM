# Architectural decision memory

This log records durable decisions that are visible in current code, migrations, or current governance. It is not a changelog. Where original rationale is absent, that is stated rather than reconstructed.

## ADR-001 — Supabase is the canonical business-data store

**Date:** active before the retained migration history
**Status:** Active

### Context
Customer, Owner, Admin, booking, payment, and wallet flows need one persistent source of truth.

### Decision
Use Supabase PostgreSQL as canonical data storage and Supabase Storage for property media. Production frontend/backend fallback state must not claim business success.

### Consequences
Persistence failure is a visible failure. Schema changes require migration review. Current baseline schema history before migration 008 is incomplete in this repository.

### Related
`backend/server/src/services/dbRepository.ts`, `backend/database/migrations/`, [DATABASE.md](./DATABASE.md)

## ADR-002 — Keep the narrow Worker REST/RPC compatibility adapter for now

**Date:** active implementation; original adoption rationale not fully recorded
**Status:** Active technical debt

### Context
The Cloudflare Worker cannot assume local direct-PostgreSQL query behavior.

### Decision
`backend/server/src/services/dbClient.ts` matches supported repository SQL and translates it to Supabase REST/RPC operations.

### Consequences
Matchers must be strict and tested over the deployed path. Do not add a generic SQL parser or silently fall through to unsupported Worker pg behavior. A future infrastructure migration needs an explicit decision.

### Related
`backend/server/src/services/dbClient.ts`, [ARCHITECTURE.md](./ARCHITECTURE.md)

## ADR-003 — Use unified human identity with optional Owner capability

**Date:** 2026-08-20 (migration `014`; lifecycle hardening in later commits)
**Status:** Active

### Context
The same human may be Customer and Owner, while a pure Customer must not enter Owner operations.

### Decision
`users` is the human identity; `owners` is an optional extension using the same UUID. Owner app state mounts only after canonical Owner validation and is scoped by `owner.id`.

### Consequences
Typed phone/local storage is not authority. Logout and account changes destroy Owner-scoped state. Explicit Owner registration is separate from login and can add the Owner extension without duplicating the human identity; KYC/onboarding remains separate from verification approval.

### Related
`backend/database/migrations/014_unified_identity_users_schema.sql`, `owner-app/src/context/AuthContext.tsx`, `owner-app/src/App.tsx`

## ADR-004 — Prototype deposit payment uses canonical financial summary and atomic RPC

**Date:** 2026-08-23 (migration `019`)
**Status:** Active

### Context
The prototype has no confirmed real-money Paymob configuration, and Worker-side pseudo-transactions are unsafe.

### Decision
Use explicit `PAYMENT_MODE=PROTOTYPE`; create canonical transactions and finalize through `konfrm_complete_deposit_payment(...)` using the existing booking financial summary.

### Consequences
No real charge/card handling occurs in prototype. Finalization is idempotent and credits only canonical Owner net deposit to pending wallet balance. Live mode fails closed until real Paymob work is explicitly implemented.

### Related
`backend/database/migrations/019_konfrm_complete_deposit_payment.sql`, `backend/server/src/services/paymentService.ts`, [BUSINESS_RULES.md](./BUSINESS_RULES.md)

## ADR-005 — DESIGN_SYSTEM is independent KONFRM authority

**Date:** 2026-08-23 (Design System v2.0.0)
**Status:** Active

### Context
No application should define global product design implicitly.

### Decision
`DESIGN_SYSTEM/` governs visual foundations, components, and product experience. Apps consume it; current screens are implementation evidence, not authority.

### Consequences
New global visual/component rules require central proposal, approval, documentation/token, versioning, then app consumption.

### Related
`DESIGN_SYSTEM/README.md`, `DESIGN_SYSTEM/GOVERNANCE.md`, [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)

## ADR-006 — One design family, role-specific experiences

**Date:** 2026-08-23 (Design System v2.1.0+)
**Status:** Active

### Context
Customer, Owner, and Admin have different jobs and cannot safely share identical information hierarchy or navigation.

### Decision
Use shared design foundations but role-specific UX contracts. Customer/Owner are mobile-first; Admin is desktop operational.

### Consequences
Do not migrate screens by visual symmetry alone. Follow approved experience decisions and keep Founder recommendations distinct from approved policy.

### Related
`DESIGN_SYSTEM/EXPERIENCE/`, `DESIGN_SYSTEM/EXPERIENCE/DECISIONS.json`

## ADR-007 — First-run Owner introduction is device state, not authentication

**Date:** 2026-08-23
**Status:** Active

### Context
First-run branding/onboarding must not authorize a user or reappear after logout.

### Decision
Owner first-run state is persisted separately from auth using KONFRM-named local keys. It shows once, then returns to the existing canonical Owner authentication boundary.

### Consequences
Splash/onboarding are never session validation, and a pure Customer still cannot become an Owner.

### Related
`owner-app/src/utils/ownerFirstRun.ts`, `owner-app/src/App.tsx`, `DESIGN_SYSTEM/EXPERIENCE/DECISIONS.json`

## ADR-008 — Customer Search Journey (Screens 03, 04, 05) Architecture & Filter Model

**Date:** 2026-10-13
**Status:** Active (Founder-Approved Architecture Specification)

### Context
Screen 03 (Explore), Screen 04 (Search & Refine), the Region Multi-Select Bottom Sheet, and Screen 05 (Search Results) constitute an interconnected search and discovery journey requiring coherent surface hierarchy, state preservation, and accessible Arabic RTL ergonomics.

### Decision
1. **Screen 03 Two-Tier Entry:** Tapping the main pill search trigger body opens the **Region Multi-Select Bottom Sheet** directly (location-first); tapping the tune/filter icon opens **Screen 04 (Search & Refine)** directly with all advanced filters.
2. **Screen 04 Surface Presentation:** Screen 04 is a dedicated **Full-Page Route (`FULL_PAGE_NESTED`)** with top sticky navigation to maximize vertical space for stay dates, guest counter, unit types, and price slider.
3. **Screen 05 Hybrid Interactive Filter Chips:** Active filter chips implement dual interaction:
   - Tapping the chip label/body opens the specific filter editor with existing selections preserved.
   - Tapping an explicit, accessible (×) control removes only that filter and refreshes Screen 05 results in place.
   - For aggregated multi-region chips, tapping the body opens the Region Multi-Select editor. Never silently clear all selected regions on label tap.
4. **State Synchronization & Truthfulness:**
   - Filter state remains synchronized across Screen 03, Screen 04, and Screen 05.
   - Unrelated filters are strictly preserved when editing or removing a specific parameter.
   - Zero-match queries render explicit empty results; never silently fall back to all properties.
   - Dates remain customer search intent only (2–30 nights); never sent to the search API as availability filters or claimed as guaranteed availability.

### Consequences
1. Design contracts and future Flutter implementations for Screens 04, 05, and Region Selection must adhere to this architecture.
2. **Implementation Status Boundary:** This ADR documents the approved interaction and surface architecture only. Executable code for Screen 04 (Search & Refine), Region Multi-Select, and Screen 05 (Search Results) remains **strictly unimplemented**.
3. In PR #120 (Screen 03), the search trigger opens a temporary dependency notice bottom sheet pending formal authorization of the search execution task.

### Related
`tasks/screen04_search_refine_and_region_selector_design_review.md`, `mobile/apps/customer_app/lib/features/discovery/`

