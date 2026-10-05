# Cards, Containers & List Rows

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Geometric Invariants:**
  - `radius.card / radius.container`: **12px** (`SYSTEM_EVALUATED_PROVISIONAL_CONTAINER_RADIUS`).
  - Mobile Page Inset: **16px** (`pagePadding`).
  - Spacing Scale: Relational **4 / 8 / 12 / 16 / 24 / 32 px**.
  - PropertyCard Media Ratio: **1.4:1** (`aspect-[1.4/1]`).
- **Open Parameters:** Exact border color hexes, shadow elevation parameters, and native mobile stroke widths (`DEFERRED_TO_4I`). 1px hairline stroke is controlled Web pilot rendering reference only.
- **Founder Invariants:** Yellow/amber/orange boxed surfaces are strictly prohibited across Customer, Owner, and Admin (`MR-17`). No dark KPI slabs. No card soup.

---

## 2. Component Taxonomy & Subcontracts

The Cards family governs structural bounding, grouped records, list rows, discovery cards, and transactional cards:

| Subcontract | Role & Purpose | Presentation Grammar |
|---|---|---|
| `StructuralContainer` | Generic bounded content container | 12px radius, neutral surface, 16px padding, subtle border. Never stacked inside another card. |
| `OpenGroupedContainer` | Owner operational record collection | Single 12px outer card, subtle internal hairline dividers. Eliminates card repetition in operational queues. |
| `ListRow` | Interactive navigation or record row | Unified height, primary title + secondary metadata, trailing RTL navigation chevron pointing left (`←`). |
| `CustomerPropertyCard` | Canonical discovery unit (Screen 03) | 1.4:1 photography, floating heart favorite (>=48px touch target), title strictly before location, truthful compact facts, bold EGP / night price, clean unboxed surface. |
| `BookingCard` | Role-specific booking lifecycle unit | Customer: booking identity, dates, status, action. Owner: queue triage row with dates, guest count, gross amount, action pair. Admin: review record row. |
| `MetricCard` | Operational metric summary unit | Clean label, single primary number, supporting context. Zero dark KPI slabs; zero yellow/amber background boxes. |

---

## 3. Subcontract Details

### 3.1 StructuralContainer
- **Role:** Bounding discrete decision units (e.g. quote breakdown, verified summary).
- **Styling:** `surface.primary` (White `#FFFFFF`), `border.default` (Slate `#E2E8F0`), `radius.container` (12px), `padding` (16px), optional subtle shadow.
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
- **Touch Target:** Minimum 48px vertical height.

### 3.4 CustomerPropertyCard (Phase 5 / Screen 03)
The `PropertyCard` is the canonical discovery unit across Explore, Search Results, and Favorites:
- **Media:** 1.4:1 aspect ratio (`aspect-[1.4/1]`), real photography or neutral placeholder with icon and "لا توجد صورة".
- **Favorite Action:** Top-left floating heart button with >=48px touch target; active state is KONFRM Blue (candidate `#276EF1`); handles pending state gracefully.
- **Hierarchy:** Title (16px `font-extrabold`, `line-clamp-2`) placed strictly before canonical location (13px `font-medium`, `line-clamp-2`, muted `text-slate-500`).
- **Facts:** 13px `font-medium` compact row (X ضيوف · Y غرف · Z حمام) formatted truthfully without zero-values.
- **Price:** 18–20px `font-extrabold` in EGP with clean suffix `/ ليلة` (eliminates redundant "السعر في الليلة").
- **Clean Surface:** No synthetic trust badges ("إقامة موثقة"), no fake rating stars, no internal dividers, and no nested CTA links (the entire card is the interactive trigger to Property Detail).

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
| `IDLE` | Clean neutral surface (`#FFFFFF`), subtle border (`#E2E8F0`), standard text contrast. | Clickable/tappable if interactive; whole surface triggers primary route. |
| `PRESSED / HOVER` | Subtle background tint (`#F8FAFC`) or subtle border darkening (`#CBD5E1`). No exaggerated scale, glow, or 3D transform. | Visual feedback upon pointer-down / hover. |
| `FOCUSED` | Visible 2px outline / focus ring with 2px offset. | Keyboard accessible via Tab; Enter/Space activates. |
| `LOADING / SKELETON` | Shimmer/pulse placeholder matching card dimensions (1.4:1 media box + text skeleton lines). | Non-interactive during fetch. |
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

- **Interactive Targets:** Any interactive card or nested button must provide at least **48 × 48 px** touch area.
- **Nested Interactivity:** In `CustomerPropertyCard`, the favorite heart button is independently focusable and clickable with an explicit `aria-label` ("إضافة إلى المفضلة" / "إزالة من المفضلة") and >=48px touch target. Clicking the heart must not trigger navigation to Property Detail (`stopPropagation`).
- **Semantic Structure:** Cards use semantic container tags (`<article>`, `<section>`, or `<li>` in lists) with proper heading hierarchy (`<h3>` for card titles).

---

## 8. Composition Invariants & Anti-Patterns

1. **Card Soup Prohibition:** Never place a bordered/shadowed card inside another card. Group related items within a single container using whitespace or subtle dividers.
2. **No Box for Every Fact:** Do not put single bullet points, amenities, or property facts in rounded box cards.
3. **No Yellow/Amber Alert Cards:** Genuine caution uses neutral/light containers with restrained semantic icon/text; never yellow/amber box fills or borders (`MR-17`).
4. **No Synthetic Badges:** Never inject marketing trust badges ("إقامة موثقة") onto property cards without canonical product verification authority.
