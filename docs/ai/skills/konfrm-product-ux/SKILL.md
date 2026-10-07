---
name: konfrm-product-ux
description: "Use for product and UX design principles, role-specific mental models, and truthful state definitions. Do not use as the primary skill for code implementation, client state management, or defect verification; use konfrm-flutter for Flutter client implementation and konfrm-quality for verification."
---

# KONFRM Product UX Principles

Defines the authoritative product user experience contracts across all three KONFRM product roles: Customer, Owner, and Admin. Governed by `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` and `docs/BUSINESS_RULES.md`.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.4, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role) and canonical business invariants (`docs/BUSINESS_RULES.md`). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste, business rules, or brand identity.**

---

## 1. Role-Specific UX Mandates

### A. Customer Experience (Current `customer-app/` Web & Future Mobile Target)
- **Friction-Free Discovery:** Instant access to real rental property inventory. Unauthenticated visitors can freely browse, filter, inspect details, and review amenities before auth is required.
- **Zero Fake Scarcity:** No misleading countdown timers, false viewer counts ("5 people looking at this now"), artificially inflated strikethrough prices, or dark UX patterns.
- **Booking Request Clarity (Never Instant Booking):**
  - Booking is strictly a **REQUEST**; instant confirmation does not exist in KONFRM.
  - Owner review and approval strictly precedes deposit payment. No deposit payment occurs before Owner approval. (Current PAYMENT_MODE=PROTOTYPE never collects card credentials; live payment credential flows remain open for future production specification).
  - Transparent pricing display: total stay price, deposit amount (equal to the first-night price), and remaining balance (total stay price minus deposit).
  - Customers see only customer-relevant pricing; internal platform commission and Owner splits are never exposed to the customer.
  - Stay bounds are globally 2–30 nights.
  - **Confirmed Cancellation Policy Representation:** Display only confirmed applicable policy (e.g. confirmed cancellation caused by Owner fault requires a full deposit refund and zero platform commission). Never invent unresolved cancellation or refund terms; the wider renter cancellation and refund matrix remains **OPEN / UNRESOLVED** per `docs/BUSINESS_RULES.md`.
- **Calm, High-Confidence Transaction Paths:** Customer interfaces must project financial safety, clarity, and legal certainty without high-pressure marketing friction.

### B. Owner Experience (Current `owner-app/` Web & Future Mobile Target)
- **Operational Certainty:** Clear, current server-authoritative visibility into available canonical state (property status, booking requests awaiting review, approved bookings, confirmed stays, and check-in schedules). Never imply WebSockets, live-sync, or instantaneous background synchronization guarantees.
- **Canonical Earnings & Split Structure:**
  - Platform commission is strictly **20% of the deposit only**. The Owner receives **80% of the deposit**.
  - Remaining balance equals total stay price minus deposit. The platform charges **zero commission** on the remaining balance.
  - The remaining-balance collection method and process remain **OPEN / UNDECIDED**; UI must not invent automated collection mechanisms or guarantees.
  - Financial balances and history are strictly server-authoritative, derived exclusively from `owner_wallets` and immutable `wallet_ledger_entries`. UI never reconstructs balances from nightly rates.
  - Do not invent bank transfer timing, delivery guarantees, or external provider behavior. (Prototype accounting rule: net deposit moves from Pending to Available 24 hours after check-in; minimum payout is 500 EGP).
- **Calendar & Availability Truth:**
  - `PENDING_OWNER_APPROVAL` does **not** block calendar availability.
  - `APPROVED_PENDING_PAYMENT` and `CONFIRMED` **block** availability.
  - Quotes are not inventory holds. Availability checks fail closed upon network uncertainty or date conflicts.
  - Calendar modifications validate against server-authoritative state; never assume instantaneous offline synchronization.
- **High Information Density:** Operational dashboards prioritize scannable data grids, calendar matrices, and actionable request lists over oversized empty hero banners.

### C. Admin Experience (`admin-app/` Desktop Web Operational)
- **Operational Governance & Audit Clarity:** Align moderation, property verification, dispute reconciliation, and payout actions with confirmed backend capabilities and audit logs. Do not invent unbacked claims of universal immutability or mandatory reason capture; separate confirmed existing audit behavior from desirable future governance candidates.
- **Batch Efficiency:** Operations staff handle high-volume queues (KYC verification, property reviews, payout approvals). Keyboard navigation, dense data tables, and batch actions are prioritized.
- **Governance Discipline:** Explicit confirmations for consequential state transitions. Financial operations display server-authoritative state without inventing unverified multi-party approvals or arbitrary operational procedures.
- **Zero Decorative Fluff:** Admin is a clean, desktop-operational instrument. Strictly avoid animations that delay triage or obscure data.

---

## 2. Truthful State Grammar

Interfaces must never deceive the user about system state, network progress, or data availability (DF2 §16):

1. **Error is Not Empty:**
   - Failed canonical reads must show a scoped error and retry state (`إعادة المحاولة`), never an honest-looking empty list, zero metric, or zero balance.
   - An empty or zero state is valid only when confirmed by a successful canonical response.
2. **No Phantom Progress:**
   - Never show simulated or indeterminate progress bars for discrete actions (e.g. artificial 0%→100% timers during API calls). Use honest spinner states or skeleton loaders.
3. **Explicit Empty States:**
   - Every list, search result, and table must provide an informative, polite Arabic empty state explaining *why* it is empty and *what action* the user can take (e.g. "لا توجد طلبات حجز جديدة").
4. **Unambiguous Error States:**
   - Errors must state clearly what went wrong and provide an immediate recovery path. Never show raw HTTP status codes, stack traces, or silent failures.
5. **Optimistic UI Constraints:**
   - Optimistic state updates are permitted ONLY for non-financial, easily reversible actions (e.g. toggling a favorite property).
   - Financial actions (request submission, payment authorization, payout release) MUST await backend confirmation before reflecting state change.

---

## 3. High Useful Density

KONFRM is an operational marketplace platform, not a decorative brochure website:
- **Prioritize Content over Padding:** Keep spacing purposeful. Avoid excessive empty space in operational screens.
- **Scannable Information Hierarchy:**
  - Primary metric or title clearly emphasized.
  - Supporting metadata and status badges immediately visible.
  - Clear, prominent primary action.
- **Visual Restraint:** Restrained surface elevation, subtle borders, white/light dominant surfaces, and zero distracting background textures.
