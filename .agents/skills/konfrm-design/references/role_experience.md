# Role-Specific Experience Models & Information Hierarchy

```yaml
MODULE: role_experience.md
BRAIN: konfrm-design
AUTHORITY: DESIGN_SYSTEM/GUIDELINES/roles.md + docs/BUSINESS_RULES.md
```

KONFRM is a three-role platform. Each role operates under a distinct mental model, cognitive workload, and operational objective. Designers and agents must never treat one role's UI patterns as a reskin of another.

---

## 1. Customer Experience (Mobile Target & Web Discovery)

### Mental Model:
> *"Can I understand and trust this property and safely progress toward a booking decision?"*

### Primary Optimization:
- Discovery clarity, photographic transparency, honest pricing, and booking request clarity.

### Core UX Contracts:
1. **Friction-Free Browsing:** Unauthenticated guests can freely search, filter, and inspect detailed property descriptions and amenity checklists without upfront authentication barriers.
2. **Booking is Strictly a Request:**
   - Instant booking does NOT exist in KONFRM. Every booking begins as a `REQUEST_PENDING_OWNER_APPROVAL`.
   - Owner review and approval strictly precedes deposit payment. No deposit is ever collected prior to owner approval.
   - Stay length bounds are universally 2 to 30 nights.
3. **Price Transparency:**
   - Display total stay price, deposit amount (equal to the first-night price), and remaining balance (total minus deposit).
   - Never expose internal platform commission (20% of deposit) or Owner payout splits to the Customer.
4. **Zero Dark Patterns & Fake Scarcity:**
   - Strictly prohibit artificial countdown timers, fake viewer counters ("4 people viewing this right now"), or deceptive strikethrough pricing.
5. **Structural System Model (`OPEN_EDITORIAL_DEFAULT`):**
   - High-quality photography and property content lead the layout.
   - Unboxed factual rows separated by subtle dividers.
   - Cards are reserved strictly for distinct discovery units (e.g. search result listings) or floating quote summaries. Avoid "card soup" where every field is inside its own heavy box.

---

## 2. Owner Experience (Mobile Operations & Web Management)

### Mental Model:
> *"What needs my attention right now, and what is the exact operational state of my properties?"*

### Primary Optimization:
- Operational clarity, request triage, actionable task queues, and server-authoritative financial certainty.

### Core UX Contracts:
1. **Operational Triage over Visual Fluff:**
   - Operational dashboards lead with high-priority actionable items: pending booking requests awaiting review, upcoming check-ins, and maintenance alerts.
   - Oversized empty hero banners and decorative marketing graphics are strictly forbidden on operational screens.
2. **Server-Authoritative Earnings:**
   - Balances and transaction ledgers are derived exclusively from server `owner_wallets` and `wallet_ledger_entries`. UI never calculates earnings locally from nightly rates.
   - Financial split: Platform commission is strictly 20% of the deposit only (Owner receives 80% of deposit). The platform charges 0% commission on the remaining balance.
   - The remaining-balance collection method remains **OPEN / UNDECIDED** in product truth; UI must never invent automated collection guarantees.
3. **Calendar Availability Truth:**
   - `PENDING_OWNER_APPROVAL` does **not** block calendar availability.
   - `APPROVED_PENDING_PAYMENT` and `CONFIRMED` **block** calendar availability.
   - Quotes do not hold inventory. Availability checks fail closed upon network uncertainty.
4. **Structural System Model (`ROLE-AWARE OPERATIONAL_GROUPING`):**
   - Related operational metrics, property attributes, or check-in tasks share a single outer container with subtle internal dividers (`OPEN_GROUPED_CONTENT`).
   - High information density reduces scrolling and accelerates operational decision-making.

---

## 3. Admin Experience (Desktop Web Operational — `admin-app/`)

### Mental Model:
> *"What happened, what evidence exists, what is the risk, and what action can I safely take?"*

### Primary Optimization:
- Audit clarity, dense data triage, safe actionability, and exception handling.

### Core UX Contracts:
1. **High-Density Desktop Operational Space (`1440 × 900` baseline):**
   - Optimized for large monitors, keyboard navigation, and wide data tables.
   - Multi-column tables with sortable, filterable columns for property moderation, identity verification, dispute queues, and payout approvals.
2. **Evidence-First Actionability:**
   - Every administrative action (approving a listing, releasing a disputed deposit, rejecting an Owner KYC) must present associated evidence and audit history alongside the action control.
   - Explicit confirmation dialogs for irreversible or consequential state changes.
3. **Zero Animation Friction:**
   - Strictly avoid decorative animations or slow transition effects that delay high-volume operational throughput.
4. **Platform Form-Factor Discipline:**
   - Never force mobile card patterns or touch-first bottom sheets onto the Admin desktop workspace.

---

## 4. Cross-Role Architectural Summary

| Dimension | Customer | Owner | Admin |
| :--- | :--- | :--- | :--- |
| **Primary Platform** | Native Mobile (iOS/Android) | Native Mobile (iOS/Android) | Desktop Web (React 19) |
| **Dominant Need** | Trust, visual clarity, ease | Operational speed, financial certainty | Auditability, throughput, evidence |
| **Layout Model** | Editorial unboxed, photography-led | Grouped operational containers | Dense data tables & side panels |
| **Action Priority** | Single primary CTA ("طلب حجز") | Multi-request triage ("قبول" / "رفض") | Batch operations & audit confirmation |
| **Financial Exposure** | Customer total, deposit, balance | Deposit split (80/20), net earnings | Full escrow ledger, dispute evidence |
