# Cards, Containers & List Rows

> [!NOTE]
> **Component Maturity & Scope Disclaimer:** This specification defines shared component contracts across KONFRM's three roles (Customer, Owner, Admin). Web implementations (React 19 / TypeScript) serve as the current running baseline (`CONTROLLED_WEB_PILOT_REFERENCE`). Native mobile specifications establish contract boundaries for the future Flutter target (`PHASE_4I_TARGET`). Exact native mobile layout parameters and styling details are explicitly governed in Phase 4I.

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Geometric Invariants:**
  - `radius.card / radius.container`: **12px** (`SYSTEM_EVALUATED_PROVISIONAL_CONTAINER_RADIUS` for semantic structural containers and grouped operational collections; open editorial surfaces have NO container radius).
  - Mobile Page Inset: **16px** (`pagePadding`).
  - Spacing Scale: Relational **4 / 8 / 12 / 16 / 24 / 32 px**.
  - PropertyCard Media Ratio: **1.4:1** (`CURRENT_WEB_AUTHORITY + PROVISIONAL_MOBILE_REFERENCE`, not canonical universal invariant).
- **Structural Elevation Baseline:** `FLAT_BY_DEFAULT / NO SHADOW` for containers; elevation and shadows are reserved strictly for temporary overlays (bottom sheets, popovers, dialogs).
- **Open Parameters:** Exact border color hexes, shadow elevation parameters, and native mobile stroke widths (`DEFERRED_TO_4I`). 1px hairline stroke is controlled Web pilot rendering reference only.
- **Founder Invariants:** Yellow/amber/orange boxed surfaces are strictly prohibited across Customer, Owner, and Admin (`MR-17`). No dark KPI slabs. No card soup.

---

## 2. Component Taxonomy & Subcontracts

The Cards family governs structural bounding, grouped records, list rows, discovery cards, and transactional cards:

| Subcontract | Role & Purpose | Presentation Grammar |
|---|---|---|
| `StructuralContainer` | Generic bounded content container | 12px radius, neutral flat surface (`FLAT_BY_DEFAULT / NO SHADOW`), 16px padding, subtle border. Never stacked inside another card. |
| `OpenGroupedContainer` | Owner operational record collection | Single 12px outer card, subtle internal hairline dividers. Eliminates card repetition in operational queues. |
| `ListRow` | Interactive navigation or record row | `CONTENT_ADAPTIVE` vertical expansion, primary title + secondary metadata, trailing RTL navigation chevron pointing left (`←`). |
| `CustomerPropertyCard` | Canonical discovery unit (Screen 03) | 1.4:1 photography reference, floating heart favorite, title strictly before location, truthful compact facts, bold EGP / night price, clean unboxed surface. |
| `BookingCard` | Role-specific booking lifecycle unit | Customer: booking identity, dates, status, action. Owner: queue triage row with dates, guest count, gross amount, action pair. Admin: review record row. |
| `MetricCard` | Operational metric summary unit | Clean label, single primary number, supporting context. Zero dark KPI slabs; zero yellow/amber background boxes. |

---

## 3. Subcontract Details

### 3.1 StructuralContainer
- **Role:** Bounding discrete decision units (e.g. quote breakdown, verified summary).
- **Styling:** `surface.primary` (White `#FFFFFF`), `border.default` (Slate `#E2E8F0`), `radius.container` (12px), `padding` (16px), `FLAT_BY_DEFAULT / NO SHADOW`.
- **Elevation Discipline:** Content containers remain flat on the page surface. Shadows are reserved for elevated overlays (sheets, dropdowns, dialogs).
- **Rule:** Never use a card merely because content exists. Prefer open editorial typography and whitespace where content flows continuously.

### 3.2 OpenGroupedContainer (Owner Operational Default)
- **Role:** Operational triage collections (Owner booking requests, property listings, transaction history).
- **Structure:** Single 12px outer container. Internal rows separated by subtle hairline dividers (1px in Web pilot; native stroke `OPEN / DEFERRED_TO_4I`).
- **Advantage:** Maximizes triage density, eliminates vertical framing clutter, provides unified scroll context.

### 3.3 ListRow
- **Role:** Settings, account destinations, property facilities, navigation menus.
- **Anatomy:**
  - Leading Affordance (Optional): Icon or thumbnail.
  - Content Block: Primary title (`15px font-semibold text-slate-900`) + Secondary text (`13px font-normal text-slate-500`).
  - Trailing Affordance: Navigation chevron (RTL: Arrow pointing Left `←`), value badge, or switch control.
- **Adaptive Height:** Vertical dimension is `CONTENT_ADAPTIVE`. Rows expand vertically to accommodate wrapped text and metadata under 200% text scaling without clipping.
- **Touch Target:** Minimum platform touch bounds (iOS ~44pt / Android ~48dp; Web pilot min-height 48px). Exact native mobile row height is `OPEN / DEFERRED_TO_4I`.

### 3.4 CustomerPropertyCard (Phase 5 / Screen 03)
The `PropertyCard` is the canonical discovery unit across Explore, Search Results, and Favorites:

#### Current Web PropertyCard Authority (`CONTROLLED_WEB_PILOT_REFERENCE`)
- Implemented in React/Tailwind in `customer-app/`.
- Media: 1.4:1 aspect ratio (`aspect-[1.4/1]`), real photography or neutral placeholder with icon and "لا توجد صورة".
- Favorite Action: Top-left floating heart button with >=48px CSS touch target; active state `#0059FF`.
- Hierarchy: Title placed strictly before location; compact facts row (guests, rooms, baths); bold EGP / night price.

#### Future Mobile Contract (`PHASE_4I_TARGET`)
- Media: 1.4:1 aspect ratio (`PROVISIONAL_MOBILE_REFERENCE`).
- Favorite Action: Floating heart button with platform touch target (iOS ~44pt / Android ~48dp); active state uses interaction-accent semantic role (`EXACT BLUE = OPEN`).
- Typography: Inherits Cairo Profile B semantic roles (`cardTitle`, `body`, `numeric`).
- Clean Surface: No synthetic trust badges ("إقامة موثقة"), no fake rating stars, no internal dividers, and no nested CTA links (the entire card surface triggers navigation to Property Detail).

### 3.5 BookingCard
- **Role:** Canonical presentation of a booking entity across Customer, Owner, and Admin.
- **Customer Variant:** Property thumbnail + title, check-in/out dates, total price, canonical status badge (`StatusBadge`), contextual action button (e.g. "متابعة الطلب", "عرض التفاصيل").
- **Owner Variant:** Booking reference code, guest display name, guest count, dates, gross booking amount, canonical status badge, contextual action pair (Accept / Reject when `PENDING_OWNER_APPROVAL`).
- **Admin Variant:** Tabular or dense card row with full booking identity, guest ID, owner ID, property ID, transaction status, payout eligibility.

### 3.6 MetricCard / SummaryUnit
- **Role:** High-level summary metrics (Owner earnings, total units, booking counts).
- **Structure:** Neutral light surface, clear 13px label, prominent 24–32px numeric value (formatted with Western Arabic numerals and currency suffix), compact 12px secondary trend or context note.
- **Prohibitions:** Strictly prohibited from using dark KPI slabs or amber/yellow warning card backgrounds.

---

## 4. State Matrix

| State | Visual Behavior | Interactive Behavior |
|---|---|---|
| `IDLE` | Clean neutral surface (`#FFFFFF`), subtle border (`#E2E8F0`), standard text contrast. Flat by default. | Clickable/tappable if interactive; whole surface triggers primary route. |
| `PRESSED / HOVER` | Subtle background tint (`#F8FAFC`) or subtle border darkening (`#CBD5E1`). No exaggerated scale, glow, or 3D transform. | Visual feedback upon pointer-down / hover. |
| `FOCUSED` | Visible outline / focus ring with 2px offset. | Keyboard accessible via Tab; Enter/Space activates. |
| `LOADING / SKELETON` | Neutral placeholder matching card dimensions (1.4:1 media box + text skeleton lines). Shimmer optional. | Non-interactive during fetch. |
| `DISABLED` | Muted content opacity (0.5), subtle gray border. | Non-clickable; assistive tech announces disabled state with reason if applicable. |
| `STALE` | Preserved cached data with neutral/soft-blue stale notice header and refresh action. Never yellow/amber box (MR-17). | Interactive; refresh action re-fetches authoritative server truth. |

---

## 5. Role Differences

- **Customer (`OPEN_EDITORIAL_DEFAULT`):**
  - Editorial, photography-led composition. Content flows continuously; property facts, descriptions, and amenities are unboxed with restrained whitespace.
  - Cards are restricted strictly to independent discovery objects (`PropertyCard`) or coherent financial decision units (booking quote breakdown).
- **Owner (`OPERATIONAL_GROUPING_DEFAULT_WHEN_SEMANTIC`):**
  - Connected operational records share a single outer container with subtle internal dividers (`OPEN_GROUPED_CONTENT`).
  - Saves vertical space, eliminates card framing repetition, and maximizes operational triage density without generic metric-card sprawl.
- **Admin (`DESKTOP_WEB_PRESERVED`):**
  - Desktop operational tables, FIFO queues, and dense inspector side-panels (`CONTROLLED_WEB_BOUNDARY_REFERENCE`). Mobile cards must not replace dense multi-column tabular workspaces.

---

## 6. RTL & Bidirectional Layout Rules

- **Directionality:** Native Arabic RTL layout (`dir="rtl"`).
- **Chevrons:** Trailing navigation chevrons point strictly to the **LEFT** (`←`), indicating forward navigation down the hierarchical stack in RTL.
- **Text Alignment:** Titles, descriptions, and metadata align to the right (logical `start`).
- **Media Alignment:** In horizontal card rows, media leads on the right (logical `start`) and text follows to the left (logical `end`).
- **Price & Numbers:** Western Arabic numerals (0–9) followed by canonical Egyptian Pound suffix (`ج.م`). Example: `1,600 ج.م / ليلة`.

---

## 7. Accessibility & Touch Discipline

### 7.1 Platform-Agnostic Intent
- **Minimum Interactive Bounds:** Interactive cards and nested controls must maintain unambiguous, non-overlapping touch hit boundaries meeting platform standards.
- **Nested Interactivity Decoupling:** When a card contains nested interactive controls (e.g. favorite button), the inner target must be independently focusable, operable, and decoupled from the card-level action.
- **Adaptive Reflow:** Container geometry expands dynamically (`CONTENT_ADAPTIVE`) under text scaling up to 200% without truncating or clipping critical metadata.

### 7.2 Current Web Mapping (`CONTROLLED_WEB_PILOT_REFERENCE`)
- Minimum **48 × 48 px** CSS touch target area.
- Semantic HTML markup (`<article>`, `<section>`, `<li>`) with proper heading levels (`<h3>` for card titles).
- Nested favorite button stops event propagation (`event.stopPropagation()`) to prevent accidental card navigation.
- Accessible labeling (`aria-label="إضافة إلى المفضلة" / "إزالة من المفضلة"`).
- Keyboard operable via Tab and Enter/Space.

### 7.3 Future Native Mobile Acceptance (`DEFERRED_TO_PHASE_4I`)
- Native touch targets: iOS ~44pt, Android ~48dp.
- Native accessibility node hierarchy (e.g. Flutter `Semantics` widget).
- Dynamic Type / Accessibility text scaling evaluation on physical devices.

---

## 8. Composition Invariants & Anti-Patterns

1. **Card Soup Prohibition:** Never place a bordered/shadowed card inside another card. Group related items within a single container using whitespace or subtle dividers.
2. **No Box for Every Fact:** Do not put single bullet points, amenities, or property facts in rounded box cards.
3. **No Yellow/Amber Alert Cards:** Genuine caution uses neutral/light containers with restrained semantic icon/text; never yellow/amber box fills or borders (`MR-17`).
4. **No Synthetic Badges:** Never inject marketing trust badges ("إقامة موثقة") onto property cards without canonical product verification authority.
