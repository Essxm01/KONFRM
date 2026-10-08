# Product State & Domain Truth Retrieval Guide

```yaml
MODULE: product_state_retrieval
PARENT_BRAIN: konfrm-product
PURPOSE: Authoritative retrieval procedures for booking lifecycle, financials, inventory holds, cancellation, and identity.
GOVERNING_RULE: "RETRIEVAL OVER DUPLICATION — ALWAYS RETRIEVE FROM AUTHORITATIVE CANON"
```

---

## 1. THE RETRIEVAL-OVER-DUPLICATION INVARIANT

Coding agents must **never hardcode or memorize mutable business constants** (e.g., commission percentages, stay bounds, deposit amounts, cancellation refund percentages, or payout minimums) inside runtime instructions or agent prompts.

Hardcoded business values inevitably drift from reality when policy evolves. Instead, this module provides the exact locator paths and interpretation procedures to retrieve live truth from the repository's authoritative sources:

| Domain | Authoritative Primary Source | Context Map Locator |
| :--- | :--- | :--- |
| **Business Invariants & Policies** | `docs/BUSINESS_RULES.md` | `authoritative_locators.business_and_product.primary_rules` |
| **Master Operating Invariants** | `docs/codex/KONFRM_MASTER_RULES.md` | `authoritative_locators.business_and_product.master_invariants` |
| **Architectural Decisions (ADRs)** | `docs/DECISIONS.md` | `authoritative_locators.business_and_product.decision_records` |
| **Active Conflict & Decision Register**| `docs/codex/KONFRM_DECISION_CONFLICTS.md` | `authoritative_locators.business_and_product.conflicts_log` |
| **Scope, Roles & Boundaries** | `docs/PROJECT.md` | Core repository context |

---

## 2. BOOKING LIFECYCLE & INVENTORY HOLD RETRIEVAL

### Authoritative Locator
- Primary Source: `docs/BUSINESS_RULES.md` (Section: Booking lifecycle and availability)
- Master Rule: `docs/codex/KONFRM_MASTER_RULES.md` (Rule MR-12)

### Retrieval & Interpretation Procedure
1. **Initial Submission:**
   - A customer booking submission creates a booking in `PENDING_OWNER_APPROVAL`.
   - **Crucial Invariant:** Instant booking does **NOT** exist in KONFRM. A submission is strictly a request awaiting Owner evaluation.
2. **Inventory Blocking States Retrieval:**
   - **DO NOT BLOCK:** `PENDING_OWNER_APPROVAL` does **NOT** block dates on the property calendar. Other guests may inquire or request overlapping dates.
   - **BLOCK INVENTORY:** Retrieve inventory-blocking states dynamically from `docs/BUSINESS_RULES.md` (Section: Booking lifecycle and availability) and MR-12. Inventory is held only once an eligible booking reaches an approved or confirmed state per Canon.
   - Availability checks must revalidate atomically and fail closed on any collision.
3. **Owner Decision Semantics:**
   - Retrieve the exact Owner-approval and rejection transition state names from `docs/BUSINESS_RULES.md` (Section: Booking lifecycle and availability) and MR-12. Semantically: Owner approval advances the request to the payment-eligible state; Owner rejection is a terminal decision.
4. **Deposit Payment & Confirmation:**
   - Retrieve the exact deposit-payment eligibility state and confirmed state from `docs/BUSINESS_RULES.md` (Section: Booking lifecycle and availability) and MR-12. Semantically: deposit payment is permissible **ONLY AFTER** Owner approval; successful deposit payment transitions the booking to the confirmed state.
   - A confirmed booking must never create an additional payment request.
5. **Global Stay Bounds:**
   - Retrieve allowed minimum and maximum stay bounds from `docs/BUSINESS_RULES.md` (Section: Booking lifecycle and availability) and `docs/codex/KONFRM_MASTER_RULES.md` (MR-12). Price quotes are not inventory holds.

---

## 3. FINANCIAL MODEL & PRICING SEMANTICS RETRIEVAL

### Authoritative Locator
- Primary Source: `docs/BUSINESS_RULES.md` (Sections: Prototype deposit payment & Owner wallet and ledger)
- Master Rule: `docs/codex/KONFRM_MASTER_RULES.md` (Rule MR-13)
- Decision Record: `docs/DECISIONS.md` (ADR-004)

### Retrieval & Interpretation Procedure
1. **Customer Pricing Presentation:**
   - Always retrieve and display three distinct customer-relevant amounts from canonical server-side pricing calculations or booking financial summaries (never locally reconstructed from a naive nightly-rate formula):
     - **Total Stay Price:** Retrieved from canonical server-side quote / financial summary.
     - **Upfront Deposit:** Retrieved dynamically from canonical server-side quote / financial summary per Canon (retrieve current deposit policy from `docs/BUSINESS_RULES.md` and MR-13; never hardcode or duplicate the deposit calculation rule).
     - **Remaining Balance:** Total stay price minus upfront deposit.
2. **Marketplace Commission & Splits (Internal Economics):**
   - Platform commission applies strictly to the deposit amount, never to the total stay price (MR-13). Retrieve exact commission percentage from `docs/BUSINESS_RULES.md` (Section: Prototype deposit payment) and MR-13.
   - Owner net share applies to the deposit amount. Retrieve exact split percentage from `docs/BUSINESS_RULES.md` and MR-13.
   - Zero platform commission is charged on the remaining balance (MR-13). The exact collection method and payment workflow for the remaining balance remain OPEN / UNCONFIRMED (MR-15, DC-08); UI and agents must not assume cash-at-arrival, card collection, or any automated payment mechanism without explicit Founder decision.
3. **Strict Information Leakage Prohibition (MR-13):**
   - **Customer Interface:** Customers must **NEVER** see KONFRM platform commission, Owner net earnings, wallet balances, or internal fee breakdowns.
   - **Owner Interface:** Owners see property booking breakdown: Total, Upfront Deposit, Net Deposit Entitlement (retrieved from Canon), and Remaining Balance (collection method remains open/unconfirmed).
4. **Payment Mode & Provider Retrieval:**
   - Retrieve the active payment mode (`PAYMENT_MODE`) and payment-provider configuration dynamically from `docs/INTEGRATIONS.md`, `docs/BUSINESS_RULES.md` (Section: Prototype deposit payment), and runtime environment configuration. Never hardcode or assume a fixed payment mode.
   - When operating in prototype mode per Canon, transactions are recorded canonically via database RPC without collecting card credentials or invoking live payment webhooks.
   - When operating in live mode (`PAYMENT_MODE=LIVE`), execution must fail closed if production payment-provider credentials or implementations are unavailable; it must never silently fall back to mock processing.

---

## 4. OWNER WALLET, LEDGER & PAYOUT RETRIEVAL

### Authoritative Locator
- Primary Source: `docs/BUSINESS_RULES.md` (Section: Owner wallet and ledger)
- State Rules: `docs/codex/KONFRM_MASTER_RULES.md` (MR-11)

### Retrieval & Interpretation Procedure
1. **Ledger Authority:**
   - Owner financial balances must be retrieved strictly from `owner_wallets` and immutable `wallet_ledger_entries`.
   - **Prohibition:** Never recalculate wallet balances dynamically on the client by summing booking prices.
2. **Deposit Entitlement Lifecycle (Post-Check-In Release Rule):**
   - When a deposit payment is confirmed, the Owner's canonical net deposit is credited to the **Pending Balance** (`pending_balance`).
   - The deposit does **NOT** enter Available Balance immediately.
   - **Canonical Release Rule:** The Owner net electronic deposit moves from Pending to Available according to the canonical post-check-in release clock (retrieve exact duration from `docs/BUSINESS_RULES.md` [Section: Owner wallet and ledger] and MR-16). The payment-completion RPC does not perform that release; it occurs via the scheduled release clock.
3. **Payout Thresholds & Fees:**
   - Retrieve minimum payout threshold from `docs/BUSINESS_RULES.md` (Section: Owner wallet and ledger) and MR-16. Never hardcode payout minimums.
   - Any payout provider transaction fee is borne by the Owner.
   - Production treatment of payout providers, payment rails, and verification/eligibility prerequisites remains OPEN / UNCONFIRMED per `docs/BUSINESS_RULES.md:53` and MR-16 (pending funds alone never authorize payout; require an explicit Founder decision before implementing concrete eligibility gates).
4. **Financial Truthfulness Invariant:**
   - A network error or database query failure is an **ERROR**, never an empty wallet (`0 ج.م`) or an empty ledger list (`ERROR != EMPTY`, `FAILED_QUERY != FAKE_ZERO`).

---

## 5. CANCELLATION & REFUND POLICY RETRIEVAL (HANDLING OPEN POLICY)

### Authoritative Locator
- Primary Source: `docs/BUSINESS_RULES.md` (Section: Needs product confirmation)
- Decision Conflict Register: `docs/codex/KONFRM_DECISION_CONFLICTS.md` (Conflict DC-08)

### Retrieval & Epistemic Classification Procedure
1. **What is ACCEPTED_CANON:**
   - **Owner Fault Cancellation:** If a confirmed booking is cancelled due to Owner fault (e.g. double booking, uninhabitable unit), the Customer receives a **full deposit refund** and the platform takes **zero platform commission**.
2. **What is an OPEN_ASSUMPTION (Must NOT be Invented):**
   - The wider **Renter Cancellation & Refund Matrix** (e.g. cancellation 7 days before check-in vs 24 hours before check-in) is **OPEN / UNRESOLVED**.
   - **Dispute Settlement & Ledger Mutation Rules:** Admin dispute resolution and financial settlement contracts remain **OPEN / BLOCKED** pending approved cancellation/dispute product decisions (`docs/codex/KONFRM_COMPLETION_MATRIX.md:46`).
   - The exact payment method for the remaining balance (cash at check-in vs card vs wallet transfer) is **OPEN / UNCONFIRMED**.
   - Automatic request expiration timeouts (e.g. 24h or 48h Owner response SLA) are **OPEN / UNCONFIRMED**.
3. **Agent Action:**
   - When asked to implement or specify renter cancellation behavior, the agent must output:
     `STATUS: BLOCKED_OPEN_DECISION`, `EPISTEMIC_STATUS: OPEN_ASSUMPTION`, citing `docs/BUSINESS_RULES.md` and `DC-08`.
    - Never fabricate tiered cancellation policies or arbitrary refund cutoff deadlines.

---

## 6. IDENTITY, PRIVACY & COMMUNICATION BOUNDARIES

### Authoritative Locator
- Primary Source: `docs/BUSINESS_RULES.md` (Section: Identity and access & Truthful state and privacy)
- Architectural Decision: `docs/DECISIONS.md` (ADR-003: Unified identity with optional Owner capability)

### Retrieval & Interpretation Procedure
1. **Unified Identity Model:**
   - `users` represents human identity. `owners` is an optional capability sharing the exact same UUID.
   - Merely entering the Owner app or logging in as a user does **NOT** grant Owner capability. Owner authentication requires a canonical Owner record in `owners` and a validated Owner session (`docs/BUSINESS_RULES.md:8`; KYC verification status does not block establishing an Owner session so Owners can access onboarding and KYC submission endpoints).
2. **Session Cleanup:**
   - Changing identities or logging out must immediately purge all account-scoped Owner and Customer state from in-memory stores and secure caches.
3. **Booking-Contextual Communication & Open Eligibility:**
   - Communication remains in-app and booking-contextual (`docs/BUSINESS_RULES.md:47`).
   - Exact booking-lifecycle eligibility rules for messaging remain **OPEN / UNCONFIRMED** (`DESIGN_SYSTEM/EXPERIENCE/NAVIGATION.md:12`, `OPEN_ASSUMPTION`). Retrieve an approved Founder/Canon contract before prescribing or restricting which specific booking states allow messaging.
   - Do **NOT** expose personal phone numbers, emails, or off-platform contact information between Customer and Owner at any booking state. Direct contact details remain strictly hidden.
4. **Reviews Eligibility:**
   - Reviews and ratings are eligible **ONLY AFTER** a stay is completed; never on pending, approved, or cancelled bookings.
