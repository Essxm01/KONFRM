---
name: konfrm-product-ux
description: "Reference only. Consolidated into konfrm-product (business journey truth and product rules) and konfrm-design (presentation models). Do not use as primary product or design authority; use konfrm-product for product authority and konfrm-design for design authority."
---

# KONFRM Product UX Principles (Consolidated Legacy Reference)

Historical reference notes subordinated to `.agents/skills/konfrm-product/SKILL.md` (product authority) and `.agents/skills/konfrm-design/SKILL.md` (design authority).

---

> [!IMPORTANT]
> ### LEGACY CONSOLIDATION & SUBORDINATION NOTICE
> **This legacy module is strictly non-authoritative and has been consolidated into `.agents/skills/konfrm-product/SKILL.md` (product rules, role mental models, and canonical retrieval) and `.agents/skills/konfrm-design/SKILL.md` (DF2 v1.7 presentation models and state grammar).**
> - **Primary Product Authority:** Load `.agents/skills/konfrm-product/SKILL.md` and `.agents/skills/konfrm-product/references/product_state_retrieval.md` to retrieve live truth from `docs/BUSINESS_RULES.md` and `docs/codex/KONFRM_MASTER_RULES.md`.
> - **Primary Design Authority:** Load `.agents/skills/konfrm-design/SKILL.md` and `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` (v1.7).

---

## 1. Role-Specific UX Mandates (Subordinated Summary)

### A. Customer Experience (Current `customer-app/` Web & Future Mobile Target)
- **Friction-Free Discovery:** Instant access to published rental property inventory. Unauthenticated visitors can freely browse, filter, inspect details, and review amenities before auth is required.
- **Zero Fake Scarcity:** No misleading countdown timers, false viewer counts ("5 people looking at this now"), artificially inflated strikethrough prices, or dark UX patterns.
- **Booking Request Clarity (Never Instant Booking):**
  - Booking is strictly a **REQUEST**; instant confirmation does not exist in KONFRM.
  - Owner review and approval strictly precedes deposit payment. Retrieve active payment mode (`PAYMENT_MODE`), stay bounds, and lifecycle transition states dynamically via `konfrm-product` (`docs/BUSINESS_RULES.md`, `docs/INTEGRATIONS.md`).
  - Transparent pricing display: retrieve total stay price, upfront deposit amount, and remaining balance from canonical server-side pricing calculations / financial summaries (`docs/BUSINESS_RULES.md`, MR-13).
  - Customers see only customer-relevant pricing; internal platform commission and Owner splits are never exposed to the customer.
  - **Confirmed Cancellation Policy Representation:** Display only confirmed applicable policy (e.g. confirmed cancellation caused by Owner fault requires a full deposit refund and zero platform commission). Never invent unresolved cancellation or refund terms; the wider renter cancellation and refund matrix remains **OPEN / UNRESOLVED** per `docs/BUSINESS_RULES.md`.
- **Calm, High-Confidence Transaction Paths:** Customer interfaces must project financial safety, clarity, and legal certainty without high-pressure marketing friction.

### B. Owner Experience (Current `owner-app/` Web & Future Mobile Target)
- **Operational Certainty:** Clear, current server-authoritative visibility into available canonical state (property status, booking requests awaiting review, approved bookings, confirmed stays, and check-in schedules). Never imply WebSockets, live-sync, or instantaneous background synchronization guarantees.
- **Canonical Earnings & Split Structure:**
  - Retrieve platform commission split, Owner net deposit share, post-check-in release clock, and payout thresholds dynamically via `konfrm-product` (`docs/BUSINESS_RULES.md`, MR-13, MR-16).
  - Zero platform commission is charged on the remaining balance. The remaining-balance collection method and process remain **OPEN / UNDECIDED**; UI must not invent automated collection mechanisms or guarantees.
  - Financial balances and history are strictly server-authoritative, derived exclusively from `owner_wallets` and immutable `wallet_ledger_entries`. UI never reconstructs balances from nightly rates.
  - Do not invent bank transfer timing, delivery guarantees, or external provider behavior.
- **Calendar & Availability Truth:**
  - Retrieve non-blocking vs. inventory-blocking booking states dynamically from `docs/BUSINESS_RULES.md` (Section: Booking lifecycle and availability) and MR-12 via `konfrm-product`.
  - Quotes are not inventory holds. Availability checks fail closed upon network uncertainty or date conflicts.
  - Calendar modifications validate against server-authoritative state; never assume instantaneous offline synchronization.
- **High Information Density:** Operational dashboards prioritize scannable data grids, calendar matrices, and actionable request lists over oversized empty hero banners.

### C. Admin Experience (`admin-app/` Desktop Web Operational)
- **Operational Governance & Audit Clarity:** Align moderation, property verification, dispute reconciliation, and payout actions with confirmed backend capabilities and audit logs. Do not invent unbacked claims of universal immutability or mandatory reason capture; separate confirmed existing audit behavior from desirable future governance candidates.
- **Batch Efficiency:** Operations staff handle high-volume queues (KYC verification, property reviews, payout approvals). Keyboard navigation, dense data tables, and batch actions are prioritized.
- **Governance Discipline:** Explicit confirmations for consequential state transitions. Financial operations display server-authoritative state without inventing unverified multi-party approvals or arbitrary operational procedures.
- **Zero Decorative Fluff:** Admin is a clean, desktop-operational instrument. Strictly avoid animations that delay triage or obscure data.

---

## 2. Truthful State Grammar (Consolidated into `konfrm-design`)

Interfaces must never deceive the user about system state, network progress, or data availability (see `.agents/skills/konfrm-design/SKILL.md` and `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` v1.7):

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
