# Three-Role Mental Models & Boundary Protection Guide

```yaml
MODULE: role_mental_models
PARENT_BRAIN: konfrm-product
PURPOSE: Authoritative behavioral models, friction tolerances, and boundary protection for Customer, Owner, and Admin.
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md (§4.2)
```

---

## 1. THREE-ROLE ARCHITECTURAL SEPARATION

KONFRM is a three-role platform. Designing or implementing features without understanding each role's distinct psychology and operational requirements leads to generic, confused product experiences.

```text
+---------------------+---------------------+---------------------+
|      CUSTOMER       |        OWNER        |        ADMIN        |
|  (Renter / Guest)   |  (Host / Operator)  | (Platform Reviewer) |
+---------------------+---------------------+---------------------+
| Surface: Mobile-App | Surface: Mobile-App | Surface: Desktop-Web|
| Driver: Trust & Calm| Driver: Ops Control | Driver: Risk & Audit|
| Goal: Safe Booking  | Goal: Triage & Cash | Goal: Truth & Safety|
+---------------------+---------------------+---------------------+
```

---

## 2. CUSTOMER MENTAL MODEL (RENTER / GUEST)

### Psychological State & Core Job
- **Psychological Profile:** Emotionally invested in a vacation or family trip, spending significant personal funds, often navigating an unfamiliar geographic area. Naturally anxious about property misrepresentation, hidden fees, cancelled trips, and security.
- **Core Job:** Find an authentic property meeting family needs, understand the total cost upfront, submit a serious request, and pay the deposit with complete financial safety.

### Behavioral Priorities & Friction Tolerances
1. **Friction-Free Browsing Before Identity:**
   - Customers must be able to explore all published properties, inspect high-resolution photos, filter dates/amenities, and review house rules without forced authentication walls.
   - Auth is prompted only when taking a committed action (saving to favorites, submitting a booking request).
2. **Absolute Pricing Clarity (The 3-Amount Truth):**
   - High tolerance for fair pricing; zero tolerance for hidden surprise fees.
   - Always present three transparent values:
     - **إجمالي الإقامة (Total Stay):** Complete price for all nights.
     - **العربون المطلوب (Deposit Due):** Upfront deposit amount retrieved from canonical server-side quote / financial summary per Canon (conceptually corresponds to deposit policy in MR-13; retrieve current policy dynamically).
     - **المتبقي (Remaining Balance):** Total stay price minus upfront deposit (collection method remains OPEN / UNCONFIRMED per MR-15, DC-08; Customers must NEVER be shown platform commission or internal financial splits).
3. **Request-Not-Instant Booking Mental Model:**
   - Customers understand that high-value vacation rentals require host approval.
   - The UI must project calm expectation: *"Your booking request has been sent. The host will review your dates."*
   - Never show countdown panic timers or aggressive urgency prompts.
4. **Zero Dark Patterns & Anti-Scarcity:**
   - Strictly prohibit fake social proof (*"5 people viewing this"*), false countdown timers (*"Price rises in 10 mins"*), or artificial strikethrough markdowns.
5. **Privacy & Communication Reassurance:**
   - Messaging remains strictly within the platform in the context of the booking.
   - Direct phone and contact details are strictly withheld across all booking states; communication remains in-app and booking-contextual to protect both guest and host from off-platform scams and disintermediation.

---

## 3. OWNER MENTAL MODEL (HOST / PROPERTY OPERATOR)

### Psychological State & Core Job
- **Psychological Profile:** Protective of high-value physical real estate, juggling turnover logistics, focused on calendar occupancy and reliable cash flow. Has zero patience for consumer-marketing fluff or sluggish interfaces.
- **Core Job:** Triage incoming requests rapidly, maintain live calendar availability, monitor unit review status, and track financial earnings with absolute certainty.

### Behavioral Priorities & Operational Grammar
1. **High-Utility Operational Instrument:**
   - The Owner app is a working operational tool, not a lifestyle browsing feed.
   - Prohibit hero photography, marketing banners, and promotional carousels on the Owner home surface.
2. **Action-First Operational Hub (Prohibition of Bottom Navigation):**
   - **Canonical Architecture:** Mobile Owner experiences strictly prohibit consumer-style 4-tab bottom navigation (Master Rule MR-02, ADR-006, Phase 4F).
   - High-frequency domains are surfaced via a high-contrast 3-column domain grid on Home:
     - **الطلبات (Requests Queue):** Direct drill-down into pending booking triage with badge counters.
     - **الوحدات (Properties / Units):** Direct drill-down into property states and listing inventory.
     - **المحفظة (Wallet & Balances):** Direct drill-down into financial balances, transactions, and payouts.
3. **Decision-Unit Triage Grammar:**
   - A pending request is a standalone decision unit.
   - It must present: Guest count, Stay dates (check-in / check-out), Total Stay, Upfront Deposit, and **صافي مستحقاتك (Net Earnings / deposit entitlement, retrieved from Canon)**.
   - Action pair: Clear Primary Action (`قبول الطلب` - Accept) paired with Destructive Outline Action (`رفض` - Decline).
4. **Anti-Card Soup Structural System:**
   - Homogeneous operational rows (e.g., unit settings, payout configurations, property list items) share a single structural container (12px provisional radius) separated by hairlines.
   - Avoid creating separate nested cards for every line item.
5. **Financial Certainty & Distinct Balance Buckets:**
   - Owners demand exact ledger reconciliation across four distinct canonical buckets (`owner_wallets`):
     - **رصيد متاح (Available Balance):** Cleared funds eligible for payout withdrawal (`available_balance`).
     - **رصيد معلق (Pending Balance):** Confirmed deposits held until the post-check-in release clock expires per Canon (`pending_balance`).
     - **رصيد محجوز (Held Balance):** Funds frozen due to dispute holds or compliance reviews (`held_balance`).
     - **رصيد قيد السحب / المعالجة (Reserved for Payout):** Active payout requests currently being processed (`reserved_for_payout_balance`).
   - Balances derive strictly from the server ledger (`owner_wallets`), never calculated client-side.

---

## 4. ADMIN MENTAL MODEL (PLATFORM REVIEWER & OPERATOR)

### Psychological State & Core Job
- **Psychological Profile:** Risk-conscious, accountable for marketplace integrity, legal compliance, fraud prevention, and dispute resolution. Needs high information density, clear evidence trails, and unambiguous decision controls.
- **Core Job:** Review submitted properties for quality and authenticity, verify Owner identity documents (KYC), audit payout requests, and adjudicate booking disputes.

### Behavioral Priorities & Review Governance
1. **Dense Desktop-Operational Environment:**
   - Admin operations run on desktop viewports (`admin-app/`).
   - Relies on sortable, filterable data tables, dense queue views, and side-by-side comparison panes.
2. **Evidence-Based Verification Standards:**
   - **Property Review:** Conducts independent property review for listings in pending-review state; upon approval, transitions to `PUBLISHED` + `VERIFIED` for public marketplace discovery per Canon (`backend/server/src/app.ts:2172-2190`, `docs/BUSINESS_RULES.md`). Do not invent unapproved subjective publication criteria (mandatory photo resolution, pricing realism thresholds, etc.) without an explicit Founder decision.
   - **Owner KYC Review:** Inspects National ID front/back + live selfie (**Prototype-only** per MR-14; production KYC document packages, provider rails, and retention rules require Founder/legal revalidation before being treated as permanent production requirements).
   - **Truth in Verification (MR-14):** System verifies manual document review; it must **never claim automated biometric or AI facial liveness verification** unless explicitly implemented.
3. **Operational Governance & Audit Alignment:**
   - Actions align with confirmed endpoint capabilities (docs/ai/skills/konfrm-product-ux/SKILL.md §1.C).
   - Reason codes and review notes are required only where existing Canon or backend endpoints explicitly require them (e.g. rejection/revision feedback where enforced; property approval accepts no reason code).
   - Do not invent universal mandatory reason capture or fabricated operational friction.
4. **Dispute Resolution Protocol:**
   - When a booking dispute arises, the Admin inspects timestamped event logs (booking creation, owner response, payment completion, check-in time, and in-app message logs).
   - Decisions are enforced through canonical platform ledger adjustments, not subjective intervention.

---

## 5. CROSS-ROLE INFORMATION BOUNDARY MATRIX

To prevent dangerous information leaks and privilege escalation, the following visibility rules are non-negotiable:

| Data / Concept | Customer Surface | Owner Surface | Admin Surface |
| :--- | :--- | :--- | :--- |
| **Total Booking Price** | VISIBLE (`إجمالي الإقامة`) | VISIBLE (`إجمالي الحجز`) | VISIBLE |
| **Upfront Deposit** | VISIBLE (`العربون المطلوب`) | VISIBLE (`العربون المطلوب / بحسب حالة الحجز`) | VISIBLE |
| **Remaining Balance** | VISIBLE (`المتبقي`) | VISIBLE (`المتبقي`) | VISIBLE |
| **Platform Commission** | **STRICTLY PROHIBITED** | VISIBLE (`عمولة المنصة`) | VISIBLE |
| **Owner Net Deposit** | **STRICTLY PROHIBITED** | VISIBLE (`صافي مستحقاتك`) | VISIBLE |
| **Owner National ID / KYC** | **STRICTLY PROHIBITED** | VISIBLE (Own documents only)| VISIBLE (Full review queue) |
| **Wallet & Payout Records** | **STRICTLY PROHIBITED** | VISIBLE (Own wallet only) | VISIBLE (System-wide ledger) |
| **Direct Phone / Contact Info** | **STRICTLY PROHIBITED** | **STRICTLY PROHIBITED** | VISIBLE (Audit/support only) |
| **Property Admin Review Notes**| **STRICTLY PROHIBITED** | VISIBLE (Rejection reason) | VISIBLE (Full audit trail) |

---

## 6. SESSION BOUNDARY & PRIVACY INVARIANTS

1. **Clean Session Boundary on Identity Transition:**
   - A single human identity (`users`) may hold both Customer and Owner capabilities.
   - However, application state and view models must remain strictly segregated.
   - Logging out or switching accounts must immediately destroy all Owner-scoped state, caches, and active provider containers.
2. **Fail-Closed on Unauthorized Role Elevation:**
   - A valid customer token attempting to access `/api/v1/owner/*` or `/api/v1/admin/*` must fail closed with HTTP 403 Forbidden.
   - The UI must render an honest session error, never a corrupted blank view.
