---
name: konfrm-product
description: Authoritative product soul and domain truth brain for KONFRM. Use for interpreting business rules, booking lifecycle semantics, financial model meaning, role mental models (Customer, Owner, Admin), pricing/deposit concepts, and epistemic classification (Canon vs Insight vs Hypothesis vs Open). Do not use as the primary skill for Flutter client implementation (use konfrm-flutter), UI presentation or design tokens (use konfrm-design), defect RCA or testing (use konfrm-quality), or backend database schema authoring.
---

# `konfrm-product` — Product Soul & Domain Truth Engine

```yaml
BRAIN_ID: konfrm-product
SYSTEM: KONFRM Engineering Intelligence System V1
STATUS: ACTIVE_CONSOLIDATED
SURFACE: cross_role_product (Customer, Owner, Admin business invariants, domain semantics, and mental models)
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md
```

---

## 1. PRIMARY MISSION & TRUTH RETRIEVAL MANDATE

`konfrm-product` is the authoritative product interpretation and domain truth brain for the KONFRM platform. Its mission is to preserve authentic rental business logic, user psychology, and market reality by interpreting and retrieving authoritative Business Canon.

### The Truth Retrieval Invariant
> **THE PRODUCT BRAIN OWNS PRODUCT RETRIEVAL AND INTERPRETATION, NOT A DUPLICATED BUSINESS RULES DATABASE.**

The brain must **NOT** permanently duplicate mutable business values such as:
- Commission percentage formulas
- Deposit calculation rules
- Booking status transition state lists
- Availability-blocking state enums
- Cancellation and refund penalty matrices
- Wallet payout minimums or schedule clocks
- Payment provider implementation assumptions

Instead, the brain maintains precise retrieval instructions pointing to canonical repository sources (`docs/BUSINESS_RULES.md`, `docs/codex/KONFRM_MASTER_RULES.md`, `docs/DECISIONS.md`, `docs/PROJECT.md`, `docs/codex/KONFRM_DECISION_CONFLICTS.md`). When a specific value or rule is needed, it retrieves and verifies that value dynamically.

---

## 2. EPISTEMIC CLASSIFICATION FRAMEWORK

Every product statement, requirement, and domain interpretation must be explicitly categorized into one of four distinct epistemic status bands:

```text
+------------------------------+--------------------------------------------------------------------------+
| CLASSIFICATION               | DEFINITION & GOVERNING AUTHORITY                                         |
+------------------------------+--------------------------------------------------------------------------+
| ACCEPTED_CANON               | Formally established with Confirmed status in Master Rules, confirmed    |
|                              | sections of docs/BUSINESS_RULES.md, confirmed ADRs, or explicit Founder  |
|                              | decisions. Fully authoritative.                                          |
+------------------------------+--------------------------------------------------------------------------+
| VALIDATED_RESEARCH_INSIGHT   | Empirically grounded in real user testing, live behavior traces, or      |
|                              | pilot feedback, but not yet codified as universal business policy.       |
+------------------------------+--------------------------------------------------------------------------+
| FOUNDER_HYPOTHESIS           | Directional vision, proposed workflow, or strategic intent from the      |
|                              | Founder. Directional guidance; never silently promoted to Canon.         |
+------------------------------+--------------------------------------------------------------------------+
| OPEN_ASSUMPTION              | Unresolved product gap, missing cancellation matrix, or unconfirmed     |
|                              | production SLA requiring an explicit Founder decision.                   |
+------------------------------+--------------------------------------------------------------------------+
```

### Epistemic Rules of Engagement
1. **Zero Silent Promotion:** Never promote a `VALIDATED_RESEARCH_INSIGHT` or `FOUNDER_HYPOTHESIS` into `ACCEPTED_CANON` without an explicit dated Founder decision or merged Canon update.
2. **Explicit Open Status Preservation:** If a business policy is unconfirmed (such as the detailed renter cancellation/refund matrix, remaining-balance collection method, or automatic request expiry timeouts), explicitly label it `OPEN_ASSUMPTION` / `NEEDS_FOUNDER_DECISION`. Do **NOT** invent plausible business terms.
3. **Fail-Closed on Uncertainty:** If business requirements conflict across sources, consult `docs/codex/KONFRM_DECISION_CONFLICTS.md` and follow the governing precedence hierarchy.

---

## 3. THREE-ROLE DIFFERENTIATED INTELLIGENCE

KONFRM is a three-role marketplace. Each role has fundamentally distinct psychology, operational priorities, and friction tolerances:

> **Application Naming & Identity Boundaries:** Approved user-facing application display names are **KONFRM | GUEST**, **KONFRM | HOST**, and **Admin Dashboard**. Technical internal identifiers `customer`, `owner`, and `admin` remain unchanged across repository code, endpoints, database schemas, and directory structures.

### 1. Customer (KONFRM | GUEST / Renter)
- **Mental Model:** *"Can I trust this property, understand the true total cost, and book safely without unexpected surprises or high-pressure tactics?"*
- **Core Values:** Transparent pricing (Total, Deposit, Remaining balance), property confidence, verified amenities, truthful progress.
- **Key Invariants:**
  - Booking is strictly a **REQUEST**; instant booking does **NOT** exist in KONFRM.
  - Owner review and approval strictly precedes deposit payment.
  - Never expose internal platform commission, Owner net earnings, or admin internals.
  - Zero fake scarcity (no fake counters, fake timers, or false urgency banners).
  - Search & discovery truth: canonical public search parser (`backend/server/src/contracts/publicProperty.ts`) filters strictly by destination, unitType, guests, and maxPrice. Date-range and amenity search filtering are `OPEN_ASSUMPTION` / deferred backend capabilities; per-property availability is evaluated via `/api/v1/customer/properties/:id/availability`.

### 2. Owner (KONFRM | HOST / Property Operator)
- **Mental Model:** *"What requests require my attention right now, and what is the exact operational and financial state of my properties?"*
- **Core Values:** Operational control, request triage speed, calendar integrity, financial certainty.
- **Key Invariants:**
  - High-utility operational instrument: zero decorative marketing fluff or hero photography.
  - Action-First Hub: Mobile Owner experiences (**KONFRM | HOST**; internal technical identifier `owner`) currently employ an Action-First Operational Hub governed by Phase 4F Navigation Canon (`DESIGN_SYSTEM/EXPERIENCE/NAVIGATION.md`, ADR-006). This architecture is a governing UX/design decision rather than an immutable business or financial invariant. Design evolution belongs to `konfrm-design` and is subject to Design Court review and Founder-approved evolution.
  - Anti-card soup: related operational rows share a single structural container (presentation geometry and border-radius tokens governed by `konfrm-design`).
  - Financial certainty: distinct balance buckets (Available, Pending release clock, Held, Reserved) derived strictly from the server ledger; never reconstructed locally.

### 3. Admin (Admin Dashboard / Platform Reviewer)
- **Mental Model:** *"Where is the objective evidence, what is the platform risk, and are authorization and marketplace integrity boundaries strictly preserved?"*
- **Core Values:** Verifiable evidence, risk mitigation, auditability, safe operational interventions.
- **Key Invariants:**
  - Desktop-operational environment: dense data tables, structured review queues, audit logs.
  - Strict evidence requirements: authentic property photography, National ID front/back + live face for Owner KYC (**Prototype-only** per MR-14; zero fabricated biometric liveness claims). Production KYC requirements require Founder/legal revalidation.
  - Endpoint-specific governance & auditability: require reason codes only where existing Canon or backend implementation explicitly enforces them (e.g. property review notes are optional, and standard property approval accepts no reason code; do not invent unbacked claims of universal mandatory reason capture). Separate confirmed existing audit behavior from desirable future governance candidates.

---

## 4. CROSS-BRAIN OWNERSHIP CONTRACT

To eliminate domain overlap, the repository enforces a strict lifecycle boundary model:
> **DEFINE -> REPRESENT -> IMPLEMENT -> VERIFY -> RELEASE**

```text
+-------------------+--------------------+--------------------+--------------------+--------------------+
| DOMAIN CONCEPT    | DEFINE (Product)   | REPRESENT (Design) | IMPLEMENT (Client) | VERIFY (Quality)   |
+-------------------+--------------------+--------------------+--------------------+--------------------+
| Business Rules    | konfrm-product     | konfrm-design      | konfrm-flutter /   | konfrm-quality     |
| & Invariants      | (Core meaning)     | (Presentation flow)| konfrm-backend     | (Contract tests)   |
+-------------------+--------------------+--------------------+--------------------+--------------------+
| UI State Models   | konfrm-product     | konfrm-design      | konfrm-flutter /   | konfrm-quality     |
|                   | (Business states)  | (Visual states)    | konfrm-admin-web   | (State assertion)  |
+-------------------+--------------------+--------------------+--------------------+--------------------+
| Financial Ledger  | konfrm-product     | konfrm-design      | konfrm-backend /   | konfrm-quality     |
| & Balances        | (Accounting rules) | (Price formatting) | konfrm-flutter     | (Ledger invariant) |
+-------------------+--------------------+--------------------+--------------------+--------------------+
| Role Psychology   | konfrm-product     | konfrm-design      | konfrm-flutter /   | konfrm-quality     |
| & Boundaries      | (Role mental model)| (UX ergonomics)    | konfrm-admin-web   | (Access checks)    |
+-------------------+--------------------+--------------------+--------------------+--------------------+
```

### Strict Brain Boundaries
- **`konfrm-product` DOES NOT:**
  - Write Flutter Dart code, widgets, or Riverpod controllers (hands off to `konfrm-flutter`).
  - Write SQL migrations, database tables, or backend server code (hands off to `konfrm-backend`).
  - Author DF2 design tokens, color hexes, typography scales, or component styling (hands off to `konfrm-design`).
  - Define technical security implementation details (e.g. Android KeyStore crypto primitives) or WCAG/platform accessibility standards.
  - Execute automated tests or conduct 4-phase RCA debugging (hands off to `konfrm-quality`).

---

## 5. STANDARD RETRIEVAL & INTERPRETATION WORKFLOW

When receiving any task involving product behavior, booking flows, financial meaning, or user intent:

```text
[1. Identify Role]  --> [2. Retrieve Canon] --> [3. Epistemic Audit] --> [4. Interpret] --> [5. Handoff]
Customer, Owner,        Read locators via       Classify: Canon vs       Articulate core     Emit structured
or Admin surface.       .agents/CONTEXT_MAP     Insight vs Hypo vs Open  business intent     handoff contract
```

1. **Identify Role & Domain:** Determine whether the task concerns Customer, Owner, or Admin domain surfaces.
2. **Retrieve Authoritative Canon:** Use `.agents/CONTEXT_MAP.yaml` to retrieve the current truth from `docs/BUSINESS_RULES.md`, `docs/codex/KONFRM_MASTER_RULES.md`, or `docs/DECISIONS.md`. Never trust memory alone.
3. **Epistemic Audit:** Verify whether the requested behavior is `ACCEPTED_CANON`. If open or unconfirmed, flag it as `OPEN_ASSUMPTION` / `NEEDS_FOUNDER_DECISION`.
4. **Formulate Product Interpretation:** State the exact business invariant, role psychology, and lifecycle implications without inventing new rules or duplicating mutable values.
5. **Handoff:** Hand off the clear product contract to `konfrm-design` (for UX representation) or `konfrm-flutter` (for mobile implementation).

---

## 6. COMPANION REFERENCE MODULES

Load companion modules on demand when deep domain context is required:

| Module | Purpose | When to Load |
| :--- | :--- | :--- |
| [`product_state_retrieval.md`](./references/product_state_retrieval.md) | Retrieval procedures for booking lifecycles, financial splits, inventory holds, cancellation, and identity. | When inspecting or interpreting specific business invariants or status transitions. |
| [`role_mental_models.md`](./references/role_mental_models.md) | Deep psychological models, behavioral priorities, friction tolerances, and role cross-contamination guards. | When designing user journeys, triaging requests, or evaluating role-scoped access and presentation. |

---

## 7. RUNTIME HANDOFF CONTRACT

When handing off product requirements or interpreted business contracts to other brains, use the standard envelope:

```text
STATUS: [DEFINED | INTERPRETED | BLOCKED_OPEN_DECISION]
ROLE: [CUSTOMER | OWNER | ADMIN | CROSS_ROLE]
EPISTEMIC_STATUS: [ACCEPTED_CANON | VALIDATED_RESEARCH_INSIGHT | FOUNDER_HYPOTHESIS | OPEN_ASSUMPTION]
CORE_INVARIANT: [Precise business rule or invariant retrieved from Canon]
CANON_SOURCE: [File path and section in docs/BUSINESS_RULES.md or docs/codex/KONFRM_MASTER_RULES.md]
NEXT_BRAIN: [konfrm-design | konfrm-flutter | konfrm-backend | konfrm-quality]
NEXT_REASON: [Why handoff is required: e.g. UX presentation, mobile implementation, verification]
BLOCKER: [Unresolved Founder decision if OPEN_ASSUMPTION, else NONE]
```
