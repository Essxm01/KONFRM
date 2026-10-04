# KONFRM Phase 4E — Structural Discovery & Inventory

**Phase:** Phase 4E — Structural System
**Status:** `PILOT_DISCOVERY_COMPLETE`
**Governing Authority:** `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` (§3–§8, §13, §14, §23, §26–§30), `DESIGN_SYSTEM/COMPONENTS/cards.md`
**Inspected Repositories:** `customer-app/`, `owner-app/`, `admin-app/`, `DESIGN_SYSTEM/TOKENS/`
**Date:** 2026-10-04

---

## 1. Executive Summary

Phase 4E investigates the structural language of KONFRM across its three distinct product roles:
1. **Customer (Mobile Web / Future Flutter Target):** Leisure/travel booking user seeking discovery, trust, hospitality, decision clarity, and low cognitive ambiguity.
2. **Owner (Mobile Web / Future Flutter Target):** Operational property business user asking *"ما الذي يحتاج مني تصرفًا الآن؟"* seeking action priority, scanability, and useful operational density.
3. **Admin (Desktop Web):** Platform operator conducting property verifications, KYC reviews, payout approvals, and dispute investigations using tables, queues, and detail side panels.

### Core Foundation Law: "Spacing is a relationship, not a number"
As codified in `MOBILE_DESIGN_FOUNDATION.md` §13:
- Related elements sit closer than unrelated ones.
- Section separation > intra-section spacing.
- Content insets and internal component gaps must remain consistent per surface role.
- Regular vertical rhythm for scanning; zero arbitrary filler whitespace.
- Useful screen occupancy over decorative padding.

---

## 2. Structural Inventory Across Real Surfaces

| Role | Surface | User Job | Current Structure | Grouping Method | Inset Pattern | Section Pattern | Card Usage | Row Usage | Divider Usage | Surface Usage | Radius Pattern | Shadow Pattern | Density Level | Known Problem | Disposition |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Customer** | **Explore / Search Results (Screen 03)** | Discover and compare available stays | Vertical list of property cards with sticky top search bar and bottom nav | Contained cards (`PropertyCard`) | `px-4` (16px) page inset; `gap-4` (16px) card stack | `mb-4` to `mb-6` between header and results | 100% contained in individual `rounded-2xl` cards | Internal comparison row (Facts ↔ Price) | None within card; border between card and canvas | `bg-white` card on `bg-slate-50` canvas | `rounded-2xl` (16px) on cards, `rounded-full` on favorite button | `shadow-xs hover:shadow-md` | Balanced | Border + subtle shadow on every card; hover states simulate desktop cards on touch viewports | `CHANGE`: Refine card shape to align with mobile shape hierarchy |
| **Customer** | **Property Detail / Booking Decision (Screen 06)** | Evaluate stay, select dates/guests, view authoritative quote, submit request | Single scrollable modal/page with sticky decision bar | Mixed: open editorial header & facts + contained quote & calendar | `p-4` (16px) body padding; `space-y-6` (24px) vertical section rhythm | Clear section titles (`text-base font-bold`) separated by `border-t border-slate-100` | Used selectively for quote box and process banner; facts & amenities are open | Open horizontal facts row (`py-3 border-y`); 2-column amenities grid | `border-y border-slate-100` for facts; `border-t` for major sections | `bg-white` canvas; `bg-slate-50` for quote & calendar wrapper | `rounded-2xl` (16px) on quote box; `rounded-xl` (12px) on deposit highlight | Minimal (sticky bar uses `shadow-lg`, cards largely flat) | High Useful Density | Nested rounded container inside quote (`rounded-xl` inside `rounded-2xl`); calendar container feels heavily boxed | `PRESERVE`: Open facts & amenities; `CHANGE`: Simplify quote containment & unify radii |
| **Customer** | **My Bookings / Trips (Screen 12)** | Track pending and confirmed bookings | Sectioned list (`يحتاج إجراء منك`, `الحالية والقادمة`, `السابقة`) | Segmented status cards; empty/guest states | `px-4` (16px) horizontal; `space-y-4` (16px) | Section headings (`text-[15px] font-extrabold`) | Every booking is a standalone interactive card | Multi-line row with thumbnail, title, dates, badge | Internal divider before action/status row | `bg-white` card on `bg-slate-50` canvas | `rounded-2xl` (16px) | `shadow-xs` | Medium | Redundant border + shadow on every booking item; creates visual repetition when list grows | `CHANGE`: Explore divider-separated operational rows |
| **Owner** | **Owner Home (Screen 01)** | Identify urgent actions, upcoming bookings, property health, wallet | Action-first vertical stack: Attention Banner → Upcoming Stay → Properties → Wallet → Quick Actions | Contained modular cards (`ActionCards`, `RecentBookingsSection`, `WalletSummarySection`) | `px-4` (16px) horizontal; `space-y-6` (24px) section gap | Explicit section headers (`text-[20px] font-extrabold`) with "عرض الكل" | Modular cards for every functional unit | Horizontal row with thumbnail and renter avatar | Internal card dividers (`border-t border-slate-100`) | `bg-white` on `var(--konfrm-surface-canvas)` | `rounded-[var(--konfrm-radius-elevated-card)]` (16px) | `box-shadow: var(--konfrm-shadow-subtle)` | Medium-High | Metric/action cards feel slightly like independent dashboard widgets rather than a cohesive operational flow | `CHANGE`: Tighten operational grouping; reduce container framing |
| **Owner** | **Bookings Queue (Screen 02)** | Review, filter, approve, or reject booking requests | Tabbed queue (Pending, Confirmed, Past) with filter pills | Stacked booking action cards | `px-4` (16px); `space-y-3` (12px) between cards | Filter bar followed by item list | Standalone card per booking request | Rich metadata rows with pricing breakdown | Card footer divider separating data from decision actions | `bg-white` card on light canvas | `rounded-2xl` (16px) on cards, 8px on buttons/chips | `shadow-xs` | High | Border + shadow + rounded corners repeated for every item makes long queues look noisy | `CHANGE`: Evaluate connected list rows with shared container |
| **Owner** | **Property Operations / List (Screen 03)** | View unit statuses, pricing, calendar locks | List of properties with status indicators and action menus | Card stack per property | `px-4` (16px); `space-y-4` (16px) | Search/add header then property cards | Card per unit | Thumbnail + status badge + unit metadata | Bottom divider before management actions | `bg-white` | `rounded-2xl` (16px) | `shadow-xs` | High | Heavy boxing makes multiple properties consume excessive vertical height | `CHANGE`: Compact interactive rows with shared container |
| **Admin** | **Property Review Queue** | Review pending property submissions FIFO, filter by status | Metric KPI row (3 cards) + Filter/Search Card + Full Data Table | Modular KPI cards + Search container + Table workspace | `p-6` (24px) desktop container; `space-y-6` (24px) | Breadcrumb/Header → KPI row → Search Card → Table Card | 3 KPI cards, 1 Filter card, 1 Table container card | Table rows (`py-3.5 px-4`) with hover state | Table row borders (`border-b border-slate-100`) | `bg-white` cards on `bg-slate-50` desktop background | `rounded-2xl` (16px) applied universally to desktop cards & tables | `shadow-xs` | High Operational | Mobile `rounded-2xl` (16px) applied to large desktop tables and filter bars looks excessively rounded; KPI cards stack decorative borders | `PRESERVE`: Table & queue density; `CHANGE`: Restrain desktop radii to 8px/12px |

---

## 3. Structural Drift Analysis

Through forensic inspection of current frontends and token definitions, 8 specific structural drift patterns were identified:

### 1. Card Soup & Modular Over-Boxing
- **Observation:** In `customer-app/src/components/CustomerBookingDetailsScreen.tsx` and `owner-app/src/components/dashboard/`, nearly every distinct piece of data is placed inside a separate `rounded-2xl border border-slate-200 bg-white` box.
- **Classification:** `DESIGN_DRIFT` (Violates `MOBILE_DESIGN_FOUNDATION.md` §14 and `cards.md`: *"Do not use cards as the default visual separator. Avoid card soup"*).
- **Remediation:** Introduce **Open Grouped Content** as the canonical default for continuous information, reserving Cards for standalone, movable, or independently actionable entities.

### 2. Nested Rounded Containers
- **Observation:** In Customer Property Detail quote section, an inner highlighted deposit box (`p-2.5 rounded-xl border border-blue-100 bg-[#EAF1FF]`) sits inside a parent quote container (`rounded-2xl border border-slate-200`). Similarly, Owner Action Cards embed control buttons inside padded card wrappers.
- **Classification:** `DESIGN_DRIFT` / `WEB_LEGACY`.
- **Remediation:** Forbid nested cards without semantic necessity. Inner highlights must use flat tinted backgrounds with zero border or subtle inline rules rather than nested boxed containers.

### 3. Radius Proliferation & Lack of Shape Roles
- **Observation:**
  - Buttons currently use provisional 6px (`PRIMARY_ONLY`, Phase 4C).
  - Form Fields use provisional 8px (Phase 4D).
  - Web tokens still define `control: 12px, card: 16px, modal: 20px`.
  - Tailwind code mixes `rounded-lg` (8px), `rounded-xl` (12px), `rounded-2xl` (16px), and `rounded-full` (9999px) haphazardly.
- **Classification:** `DESIGN_DRIFT`.
- **Remediation:** Phase 4E must establish clear **Shape Roles**:
  - `SHAPE_ACTION`: 6px (Primary buttons).
  - `SHAPE_INPUT`: 8px (Data entry controls).
  - `SHAPE_CONTAINER`: Evaluated in this pilot (10px vs 12px vs 16px).
  - `SHAPE_PILL / BADGE`: Fully rounded or restrained.

### 4. Triple Visual Redundancy (Border + Shadow + Surface Change)
- **Observation:** Many cards combine a distinct background (`bg-white` vs `bg-slate-50`), a perimeter border (`border-slate-200`), and a drop shadow (`shadow-xs` / `shadow-subtle`).
- **Classification:** `DESIGN_DRIFT` (Violates `MOBILE_DESIGN_FOUNDATION.md` §14: *"Prefer one primary separation cue for a relationship and avoid redundant decorative stacking"*).
- **Remediation:** Enforce **Border-First or Surface-First** separation. Shadows are reserved strictly for true elevation (sticky headers, bottom sheets, floating CTAs).

### 5. Inconsistent Section Rhythms
- **Observation:** Across Customer and Owner screens, vertical spacing between sections varies arbitrarily: `space-y-4` (16px), `space-y-5` (20px), `space-y-6` (24px), `space-y-8` (32px), `my-7` (28px).
- **Classification:** `WEB_LEGACY`.
- **Remediation:** Consolidate vertical rhythm around an unambiguous relationship hierarchy:
  - Intra-element / tight gap: **4px / 8px**
  - Intra-group / item gap: **12px / 16px**
  - Section separation: **24px (Mobile default) / 32px (Major boundary)**

### 6. Role Cloning Risk
- **Observation:** If Owner Home is given the same loose, expansive card spacing as Customer Discovery, the Owner cannot scan urgent booking tasks efficiently. Conversely, if Customer Property Detail is packed like an Owner operations queue, the hospitality and leisure trust feel is ruined.
- **Classification:** `PRODUCT_PROBLEM`.
- **Remediation:** Structure must follow **Role Grammar**:
  - Customer: Open, editorial, breathing room, unboxed facts, imagery-led.
  - Owner: Connected rows, high useful scanability, grouped operational units.
  - Admin: Desktop tables, audit side-panels, dense information throughput.

### 7. Desktop Admin Mobile-Card Contamination
- **Observation:** Admin Property Review currently wraps search inputs, filters, and whole data tables inside mobile-style `rounded-2xl` (16px) cards with drop shadows.
- **Classification:** `WEB_LEGACY`.
- **Remediation:** Admin must retain its desktop operational identity. Tables require crisp, restrained structure (e.g., 8px container radius, flat subtle borders, zero mobile-card mimicking).

### 8. Decorative Whitespace vs Useful Screen Occupancy
- **Observation:** In some mobile detail views, excessive top/bottom padding leaves half the viewport empty on 360px/390px screens while decision-critical financial details are pushed below the fold.
- **Classification:** `PRODUCT_PROBLEM`.
- **Remediation:** Enforce `MOBILE_DESIGN_FOUNDATION.md` §5: *"High useful information density with low cognitive load."* Decision-critical information must fit naturally within the initial viewport.

---

## 4. Evaluation of Structural Candidate Systems

To provide rigorous empirical evidence, three distinct structural systems are formulated and tested:

### Candidate A: Open / Editorial Structure
- **Philosophy:** Minimal bounding boxes. Whitespace, typography hierarchy, and thin dividers carry the grouping burden.
- **Characteristics:**
  - Content rests directly on the base canvas (`bg-white` or light neutral).
  - Groups separated by fine 1px dividers (`border-slate-100`).
  - Cards restricted strictly to self-contained items (like `PropertyCard` with photography).
  - Flat elevation; shadows strictly for sticky navigation and modals.
  - Generous vertical rhythm (24px / 32px).
- **Pros:** Completely eliminates card soup; maximum hospitality feel; highly readable; minimal visual clutter.
- **Cons:** On complex Owner operations, lack of containers can reduce perceived separation between dense operational objects.

### Candidate B: Contained / Modular Structure
- **Philosophy:** Clear, explicit boundaries for every functional unit. Every section or group is enclosed in a dedicated bordered container.
- **Characteristics:**
  - White container surfaces on subtle neutral canvas (`bg-slate-50`).
  - Distinct 1px border (`border-slate-200`) and subtle elevation (`shadow-xs`).
  - Moderate internal container padding (`p-4`).
  - Uniform container corner radius (12px or 16px).
- **Pros:** Strong containment; very clear where one module ends and another begins; familiar SaaS modular layout.
- **Cons:** High risk of card soup; repetitive visual framing; eats horizontal space on 360px viewports; feels overly "technical/dashboard" for Customer travel discovery.

### Candidate C: Role-Aware Hybrid (Recommended Baseline)
- **Philosophy:** Asymmetric structural grammar tailored to role mental models, anchored by a shared foundation.
- **Characteristics:**
  - **Customer:** Open / Editorial composition. Property detail facts, amenities, and policies are unboxed with subtle divider lines. Only multi-attribute decision units (such as Server Quote breakdown) use a clean single-surface container.
  - **Owner:** Grouped Operational Units. Related booking rows, property items, and wallet records share a single container with clean internal dividers (`Open Grouped Content`), preventing card soup while providing dense operational scanability.
  - **Admin Boundary:** Crisp Desktop Operational Layout. Standard data tables, compact filters, and audit side-panels with restrained 8px structural radii and zero mobile-card styling.
- **Shape System:**
  - Action CTA: 6px (Phase 4C locked).
  - Form Fields: 8px (Phase 4D locked).
  - Structural Containers / Cards: 12px (Balanced candidate) or 16px (Legacy candidate).
  - Open Content: 0px (divided inline).

---

## 5. Spacing Scale Coherence Analysis

Web tokens specify: `4px, 8px, 12px, 16px, 24px, 32px, 40px, 48px`.

| Value | Semantic Mobile Role | Demonstrated Product Need | Coherence Verdict |
|---|---|---|---|
| **4px (xs)** | Micro-gap: icon to label, badge internal inset, status dot offset | High (used everywhere in metadata and badges) | **ESSENTIAL** |
| **8px (sm)** | Tight inline gap: button icon to text, chip gap, helper text to input | High (standard component intra-spacing) | **ESSENTIAL** |
| **12px (md)** | Control gap: label to field, dense list row vertical gap, compact card padding | High (critical bridge between 8px and 16px for mobile density) | **ESSENTIAL (Has clear distinct role)** |
| **16px (lg)** | Content inset / Standard card padding / Stack gap between related items | Universal (standard mobile page horizontal margin) | **ESSENTIAL (Primary rhythm anchor)** |
| **24px (xl)** | Section gap / Page vertical rhythm / Major group separation | High (standard separation between distinct sections) | **ESSENTIAL** |
| **32px (2xl)**| Major boundary: hero to body, footer separator, sticky bar clearance | Moderate-High (ensures breathing room before major shifts) | **ESSENTIAL** |
| **40px (3xl)**| Extended boundary / Empty state vertical breathing room | Low-Moderate (rarely needed; often redundant with 32px or 48px) | **CANDIDATE (Evaluate consolidation)** |
| **48px (4xl)**| Large mobile touch target height / Screen bottom navigation clearance | High for heights/clearance; low as pure whitespace gap | **RETAIN AS SIZING / CLEARANCE** |

**Conclusion:** The 8pt-derived family with 4px micro-steps and 12px density-bridge is coherent, mathematically sound, and proven in real product screens. No arbitrary odd-pixel values (11px, 13px, 17px, 21px) are permitted.
