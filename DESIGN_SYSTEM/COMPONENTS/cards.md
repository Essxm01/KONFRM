# Card, MetricCard, ListRow, PropertyCard and BookingCard shells

Cards are light: `surface.primary`, `border.default`, `radius.card`, `cardPadding`, and at most `shadow.subtle`. Borders and spacing take precedence over shadow.

Founder visual rule: yellow/amber/orange boxed surfaces are not an approved KONFRM card family. Do not use Summer Yellow or warning amber to create cards, summary boxes, notices or status panels. Genuine caution uses a neutral/light container with restrained semantic icon/text if needed.

| Contract | Required content | Notes |
|---|---|---|
| Standard | coherent grouped content | not a decorative container stack |
| Interactive | standard card plus clear action/focus state | whole-card click must remain accessible |
| MetricCard | label, one primary number, supporting context | does not invent dark KPI slabs |
| Summary | concise status/value/action | suitable for a decision moment |
| Selected | standard card plus selected border/surface | selection is not colour-only |
| Warning | genuine caution context only | neutral/light container by default; never a yellow/amber/orange brand-card type |
| ListRow | title, supporting metadata, optional trailing action | predictable height and divider logic |
| PropertyCard shell | real image (1.4:1), independent favorite button, title before location, compact facts, prominent price per night | shared across Explore, Search Results, Favorites; never fake property imagery or synthetic badges |
| BookingCard shell | booking identity, property, dates/status and contextual action | no raw enum label to users |

## Shared PropertyCard Anatomy (Phase 5 / Screen 03)

The `PropertyCard` is the canonical discovery unit across Explore, Search Results, and Favorites:
- **Media**: 1.4:1 aspect ratio (`aspect-[1.4/1]`), real photography or neutral `#F1F5F9` placeholder with icon and "لا توجد صورة".
- **Favorite Action**: Top-left floating heart button with >=48px touch target; active state is KONFRM Blue `#0059FF`; handles pending state gracefully.
- **Hierarchy**: Title (16px `font-extrabold`, `line-clamp-2`) placed strictly before canonical location (13px `font-medium`, `line-clamp-2`, muted `text-slate-500`).
- **Facts**: 13px `font-medium` compact row (X ضيوف · Y غرف · Z حمام) formatted truthfully without zero-values.
- **Price**: 18–20px `font-extrabold` in EGP with clean suffix `/ ليلة` (eliminates redundant "السعر في الليلة").
- **Clean Surface**: No synthetic trust badges ("إقامة موثقة"), no fake rating stars, no internal dividers, and no nested CTA links (the entire card is the interactive trigger to Property Detail).

Dark-card is not a normal variant. A hover effect may use neutral border/elevation changes, never a glow or decorative translation system.

## Open-surface composition rule & Phase 4E Structural Models

Do not use cards as the default visual separator. Prefer whitespace, typography, dividers and open rows when the content belongs to one continuous journey.

Avoid **card soup**: a card inside a card, a rounded box for every fact, or repeated bordered containers that make a decision screen feel like a dashboard.

### Structural Composition by Role (Phase 4E Hybrid Model)
- **Customer (`OPEN_EDITORIAL_DEFAULT`):** Editorial, photography-led composition. Content flows continuously; property facts, descriptions, and amenities are unboxed with restrained dividers / subtle hairline-style separation (exact native stroke width remains `OPEN` / deferred to Phase 4I; 1px is controlled Web pilot rendering reference only). Cards are restricted strictly to independent discovery objects (`PropertyCard`) or coherent financial decision units (booking quote breakdown).
- **Owner (`OPERATIONAL_GROUPING_DEFAULT_WHEN_SEMANTIC`):** Connected operational records share a single outer container with subtle internal dividers (`OPEN_GROUPED_CONTENT`; exact native stroke width remains `OPEN` / deferred to Phase 4I; 1px in pilot is controlled Web rendering reference). Saves vertical space, eliminates card framing repetition, and maximizes operational triage density without generic metric-card sprawl.
- **Admin (`DESKTOP_WEB_PRESERVED`):** Desktop operational tables, FIFO queues, and dense inspector side-panels (`CONTROLLED_WEB_BOUNDARY_REFERENCE`). Mobile cards must not replace dense multi-column tabular workspaces.

### Structural Container Selection Logic
1. **`OPEN_CONTENT` (No enclosing container, restrained dividers):**
   - Use when content belongs to one continuous reading or inspection task (e.g. Customer property facts, house rules, amenities list). Has **NO ENCLOSING STRUCTURAL CONTAINER**; relationships are defined by typography, whitespace, and optional subtle dividers. Does not possess or require a container radius token.
2. **`OPEN_GROUPED_CONTENT` (Single outer container, subtle internal dividers):**
   - Use when related homogeneous records or interactive rows form an operational collection (e.g. Owner booking queue, unit listings, earnings history). Exact native stroke width remains `OPEN` / deferred to Phase 4I.
3. **`INTERACTIVE_CONTAINER / CARD` (Restricted Bounded Container):**
   - Use strictly when an entity is independently actionable, movable, or recognizable as a discrete decision unit (e.g. `PropertyCard`, actionable `BookingCard`, server quote financial breakdown).
   - *Never* use a card merely because content exists or to frame simple paragraphs.
4. **Prohibited Container Anti-Patterns:**
   - Card soup (nested containers).
   - Card per individual metric or stat.
   - Framing every text paragraph in a separate box.
   - Combining border + shadow + tinted background + exaggerated radius simultaneously without semantic justification.
