---
name: konfrm-product-ux
description: "Core product and UX design principles for KONFRM. Enforces role-specific goals (Customer friction-free discovery, Owner operational certainty, Admin audit governance), truthful state grammar, financial transparency, and high useful density over decorative whitespace."
---

# KONFRM Product UX Principles

Defines the authoritative product user experience contracts across all three KONFRM applications: Customer, Owner, and Admin.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Role-Specific UX Mandates

### A. Customer App (`customer-app/`)
- **Friction-Free Discovery:** Instant access to real rental property inventory. Unauthenticated visitors can freely browse, filter, inspect details, and review amenities before auth is required.
- **Zero Fake Scarcity:** No misleading countdown timers, false viewer counts ("5 people looking at this now"), artificially inflated strikethrough prices, or dark UX patterns.
- **Instant Booking Clarity:**
  - Total pricing broken down transparently before confirmation (nightly rate, cleaning fee, platform fee, deposit).
  - Explicit refund and cancellation policies visible before checkout.
  - Instant booking confirmation without ambiguous pending states.
- **Calm, High-Confidence Transaction Paths:** Customer interfaces must project financial safety, clarity, and legal certainty.

### B. Owner App (`owner-app/`)
- **Operational Certainty:** Real-time visibility into property status, confirmed bookings, check-in schedules, and key exchange handoffs.
- **Earnings Transparency:**
  - Net payout breakdown per booking: Gross rent minus platform fee equals net owner deposit.
  - Clear payout schedules, estimated arrival dates, and instant notification of bank transfers.
  - Clear dispute resolution status without hidden deductions.
- **Calendar & Pricing Control:**
  - Instant blocking/unblocking of calendar dates with zero lag.
  - Granular seasonal and weekend pricing rules with immediate feedback.
- **High Information Density:** Operational dashboards prioritize scannable data grids and calendar views over oversized empty hero banners.

### C. Admin App (`admin-app/`)
- **Auditability & Traceability:** Every moderation decision, property verification, dispute reconciliation, and payout execution must have an immutable audit trail and explicit reason logging.
- **Batch Efficiency:** Operations staff handle high-volume queues (KYC verification, property reviews, payout approvals). Keyboard navigation, dense data tables, and batch actions are prioritized.
- **Uncompromised Governance:** No destructive actions occur without clear confirmations. Financial operations (payout releases, escrow freezes) require strict dual-check clarity.
- **Zero Decorative Fluff:** Admin is a clean, desktop-operational instrument. Strictly avoid animations that delay triage or obscure data.

---

## 2. Truthful State Grammar

Interfaces must never deceive the user about system state, network progress, or data availability:

1. **No Phantom Progress:**
   - Never show simulated or indeterminate progress bars for discrete actions (e.g. artificial 0%→100% timers during API calls). Use honest spinner states or skeleton loaders.
2. **Explicit Empty States:**
   - Every list, search result, and table must provide an informative, polite Arabic empty state explaining *why* it is empty and *what action* the user can take (e.g. "لا توجد حجوزات قادمة — يمكنك استكشاف الوحدات المتاحة").
3. **Unambiguous Error States:**
   - Errors must state clearly what went wrong and provide an immediate recovery path (e.g. "إعادة المحاولة" or contact support). Never show raw HTTP status codes, stack traces, or silent failures.
4. **Optimistic UI Constraints:**
   - Optimistic state updates are permitted ONLY for non-financial, easily reversible actions (e.g. toggling a favorite property).
   - Financial actions (payment authorization, booking confirmation, payout release) MUST await backend confirmation before showing success.

---

## 3. High Useful Density

KONFRM is an operational marketplace platform, not a decorative brochure website:
- **Prioritize Content over Padding:** Keep spacing disciplined (8pt base system: 4, 8, 12, 16, 24, 32px). Avoid excessive 64px+ empty spacing in operational screens.
- **Scannable Information Hierarchy:**
  - Primary metric or title (Cairo Bold/Extrabold).
  - Supporting metadata and status badges immediately visible.
  - Clear, prominent primary action.
- **Visual Restraint:** Restrained surface elevation, subtle borders (`border-neutral-200`), white dominant surfaces, and zero distracting background textures.
