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
   - Instant booking does NOT exist in KONFRM. Every booking begins as a request awaiting Owner review.
   - Owner review and approval strictly precedes deposit payment. No deposit is ever collected prior to owner approval.
   - Stay length bounds and booking state lifecycle are governed by Business Canon (`docs/BUSINESS_RULES.md`); design interfaces retrieve bounds and valid state transitions from canonical business rules rather than hardcoding them.
3. **Price Transparency:**
   - Present customer-authorized line items (e.g. nightly rate, deposit amount, remaining balance) clearly and truthfully.
   - Price formulas and calculations are governed strictly by Business Canon (`docs/BUSINESS_RULES.md`).
   - Never expose internal platform commission calculations, operational margins, or Owner payout splits to Customer surfaces.
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
   - Operational dashboards lead with high-priority actionable items (e.g. pending booking requests awaiting review, upcoming check-ins).
   - Oversized empty hero banners and decorative marketing graphics are strictly forbidden on operational screens.
2. **Server-Authoritative Earnings Display:**
   - Balances, payout availability, and transaction ledgers are derived exclusively from server-authoritative wallet state (`docs/BUSINESS_RULES.md`). The UI must never calculate earnings or balances locally from nightly rates.
   - Retrieve current Owner-visible financial contracts, commission splits, and payout minimums from Business Canon. Present only values authorized for the Owner role.
   - The remaining-balance collection method remains **OPEN / UNDECIDED** in product truth; UI must never invent automated collection mechanisms or guarantees.
3. **Calendar Availability Truth:**
   - Retrieve canonical availability-blocking states from Business Canon (`docs/BUSINESS_RULES.md`).
   - Availability presentation must reflect server truth; quotes do not hold inventory. Availability checks fail closed upon network uncertainty.
4. **Structural System Model (`ROLE-AWARE OPERATIONAL_GROUPING`):**
   - Related operational metrics, property attributes, or check-in tasks share a single outer container with subtle internal dividers (`OPEN_GROUPED_CONTENT`).
   - High information density reduces scrolling and accelerates operational decision-making.

---

## 3. Admin Experience (Desktop Web Operational — `admin-app/`)

### Mental Model:
> *"What happened, what evidence exists, what is the risk, and what action can I safely take?"*

### Primary Optimization:
- Operational clarity, useful density, auditability, safe actionability, and exception handling.

### Core UX Contracts:
1. **Core Invariant: OPERATIONAL CLARITY + USEFUL DENSITY + AUDITABILITY + SAFE ACTIONABILITY:**
   - Admin is a clean, desktop-operational instrument. Strictly avoid animations that delay triage or obscure data.
   - Admin remains Web: do not force mobile card soup or bottom sheets onto desktop screens.
2. **Pattern Selection by Operational Task (Not a Rigid Template):**
   - UI patterns (e.g. multi-column data tables, side detail panes, queue lists, filter bars, search controls, keyboard shortcuts) are PATTERNS selected when the specific operational workflow requires them, not an unyielding universal mandate for every screen.
   - Workflows (e.g. property review, verification triage, payout review) are `ILLUSTRATIVE_PATTERN_ONLY` unless explicitly specified in governing feature contracts.
3. **Evidence-First Actionability:**
   - Every administrative action must display associated server evidence and audit records alongside the action control.
   - Consequential, irreversible state changes require explicit confirmation dialogs.
4. **Controlled Desktop Reference Viewport:**
   - `1440 × 900` serves as a controlled initial desktop reference viewport for layout evaluation, not an immutable layout contract for all Admin screens.

---

## 4. Cross-Role Architectural Summary

| Dimension | Customer | Owner | Admin |
| :--- | :--- | :--- | :--- |
| **Primary Platform** | Native Mobile (iOS/Android) | Native Mobile (iOS/Android) | Desktop Web (React 19) |
| **Dominant Need** | Trust, visual clarity, ease | Operational speed, financial certainty | Auditability, throughput, evidence |
| **Layout Model** | Editorial unboxed, photography-led | Grouped operational containers | Dense data tables, queues & side panes |
| **Action Priority** | Single primary CTA ("طلب حجز") | Multi-request triage ("قبول" / "رفض") | Evidence-backed triage & action confirmation |
| **Financial Exposure** | Customer total, deposit, balance | Authorized wallet balances & splits | Authorized audit data & server ledger records |
