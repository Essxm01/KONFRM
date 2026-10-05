# KONFRM Phase 4H — Component Contract Matrix & Master Contracts

**Document Status:** CANONICAL CONTRACT SPECIFICATION — PHASE 4H  
**Branch:** `design/component-contract-catalog-01`  
**Purpose:** Formal, consumable contracts for all component families across KONFRM, providing unambiguous behavioral, state, RTL, accessibility, and role-aware specifications.

---

## 1. Component State Matrices

The Phase 4G State System establishes a strict four-category state architecture:
1. **Component Interaction State** (Primitive control lifecycle: resting, pressed, focused, disabled, etc.)
2. **View & Data State** (Collection & resource lifecycle: loading, loaded, empty, error, offline, unauthorized, partial, stale, conflict)
3. **Action & Mutation State** (Network operation lifecycle: idle, submitting, succeeded, failed, conflicted, disabled)
4. **Domain & Business Status** (Canonical backend entities: booking status, property status, payout status, KYC status)

To maintain semantic truth and prevent state category conflation, contracts evaluate state across three focused composition matrices:

### 1.1 Component Interaction State Matrix

*Evaluates local interactive and presentation states of individual component primitives.*

| Component Family | RESTING / DEFAULT | PRESSED / ACTIVE | FOCUSED | HOVER (Web Only) | DISABLED | SELECTED | READ_ONLY | ERROR |
|---|---|---|---|---|---|---|---|---|
| **Button (Primary/Secondary)** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `N/A` | `N/A` | `N/A` |
| **IconButton** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `SUPPORTED` | `N/A` | `N/A` |
| **InputField / Phone / Numeric** | `REQUIRED` (Unfilled) | `N/A` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `N/A` | `SUPPORTED` | `REQUIRED` |
| **SearchField** | `REQUIRED` (Unfilled) | `N/A` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `N/A` | `N/A` | `SUPPORTED` |
| **SelectTrigger** | `REQUIRED` (Unfilled) | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `SUPPORTED` | `N/A` | `REQUIRED` |
| **Checkbox** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `REQUIRED` | `N/A` | `SUPPORTED` |
| **StatusBadge** | `REQUIRED` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **SectionAlert** | `REQUIRED` | `N/A` | `SUPPORTED` (CTA) | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **Toast** | `REQUIRED` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **StructuralContainer (Card)** | `REQUIRED` | `SUPPORTED` | `SUPPORTED` | `SUPPORTED` | `SUPPORTED` | `SUPPORTED` | `N/A` | `N/A` |
| **OpenGroupedContainer** | `REQUIRED` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **ListRow / SettingsRow** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `REQUIRED` | `SUPPORTED` | `N/A` | `N/A` |
| **CustomerPropertyCard** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `N/A` | `N/A` | `N/A` | `N/A` |
| **BookingCard** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `SUPPORTED` | `N/A` | `N/A` | `N/A` | `N/A` |
| **BottomNavigation (Customer)** | `REQUIRED` | `REQUIRED` | `REQUIRED` | `N/A` | `SUPPORTED` | `REQUIRED` (Active) | `N/A` | `N/A` |
| **AppBar Family** | `REQUIRED` | `N/A` | `SUPPORTED` (Actions) | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **BottomSheet** | `REQUIRED` | `N/A` | `REQUIRED` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **ConfirmationDialog** | `REQUIRED` | `N/A` | `REQUIRED` | `N/A` | `N/A` | `N/A` | `N/A` | `N/A` |
| **StickyActionSurface** | `REQUIRED` | `N/A` | `SUPPORTED` (CTA) | `N/A` | `SUPPORTED` (CTA) | `N/A` | `N/A` | `N/A` |

*Note on Form Fields:* Form fields evaluate `UNFILLED / NO_VALUE` vs `FILLED`. They do **not** use the Phase 4G view-level `EMPTY` state.

### 1.2 View & Data State Composition Matrix

*Evaluates how container, surface, and composite components compose with Phase 4G View/Data lifecycle states.*

| Component Family | LOADING | EMPTY | ERROR | OFFLINE | UNAUTHORIZED | PARTIAL | STALE | CONFLICT |
|---|---|---|---|---|---|---|---|---|
| **StateView (Screen / Section)** | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` |
| **SkeletonLoader** | `BUILT-IN` | `FORBIDDEN` | `FORBIDDEN` | `FORBIDDEN` | `FORBIDDEN` | `FORBIDDEN` | `FORBIDDEN` | `FORBIDDEN` |
| **SectionAlert** | `N/A` | `FORBIDDEN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` | `BUILT-IN` |
| **SearchField** | `SUPPORTED` (In-flight) | `COMPOSE` (Zero results view) | `COMPOSE` | `COMPOSE` | `N/A` | `N/A` | `N/A` | `N/A` |
| **CustomerPropertyCard** | `COMPOSE` (Skeleton) | `FORBIDDEN` | `COMPOSE` | `COMPOSE` | `N/A` | `N/A` | `COMPOSE` | `N/A` |
| **BookingCard** | `COMPOSE` (Skeleton) | `FORBIDDEN` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `N/A` | `COMPOSE` | `COMPOSE` |
| **OpenGroupedContainer** | `COMPOSE` (Skeleton) | `COMPOSE` (Empty list) | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` |
| **StructuralContainer** | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` |
| **BottomSheet** | `COMPOSE` | `COMPOSE` | `COMPOSE` | `COMPOSE` | `N/A` | `N/A` | `N/A` | `N/A` |

### 1.3 Action & Mutation State Composition Matrix

*Evaluates how interactive action primitives and forms manage operational mutations.*

| Component Family | IDLE | SUBMITTING | SUCCEEDED | FAILED | CONFLICTED | DISABLED |
|---|---|---|---|---|---|---|
| **Button (Action Primary)** | `REQUIRED` | `REQUIRED` (In-flight spinner) | `SUPPORTED` (Flow contract) | `REQUIRED` (Returns to IDLE) | `COMPOSE` (Conflict alert) | `REQUIRED` |
| **IconButton** | `REQUIRED` | `SUPPORTED` | `SUPPORTED` | `REQUIRED` | `N/A` | `REQUIRED` |
| **FormComposition** | `REQUIRED` | `REQUIRED` (Single in-flight guard) | `REQUIRED` (Flow contract) | `REQUIRED` (Inline errors + alert) | `REQUIRED` | `REQUIRED` |
| **ConfirmationDialog** | `REQUIRED` | `REQUIRED` (CTA spinner) | `REQUIRED` (Dismiss on success) | `REQUIRED` (Display error) | `REQUIRED` | `REQUIRED` |
| **StickyActionSurface** | `REQUIRED` | `REQUIRED` (CTA spinner) | `REQUIRED` (Flow contract) | `REQUIRED` (Display error) | `REQUIRED` | `REQUIRED` |

---

## 2. Role Difference Matrix

*Compares shared component families across Customer, Owner, and Admin.*

| Component Family | Customer Application | Owner Application | Admin Application | Architectural Relationship |
|---|---|---|---|---|
| **Button** | Stable Black 6px Primary; Subtle Fill Secondary; Hospitality & Decision Next-Step. | Stable Black 6px Primary; Consequential Destructive Secondary; Operational Triage. | Desktop button styling (blue/slate/danger); denser 36px/40px heights. | `SAME COMPONENT / ROLE-AWARE ACTIONS` |
| **InputField** | Outline-Led 8px radius; Search & Date/Guest focus; Phone auth. | Outline-Led 8px radius; Operational pricing, listing edit, payout details. | Desktop compact tabular/form inputs with thin borders. | `SAME COMPONENT / ROLE VARIANT` |
| **StatusBadge** | Displays booking/stay confirmation; NO generic "verified account" trust badges. | Displays Property, Booking Request, KYC, and Payout lifecycle states. | Displays raw queue status, audit eligibility, and verification flags. | `SAME COMPONENT / ROLE-FILTERED ENUMS` |
| **SectionAlert** | Informational/Process guidance (Open typography); Booking conflict notices. | KYC rejected reasons, Payout delays, Property review correction notices. | System errors, worker exceptions, queue sync discrepancies. | `SAME COMPONENT / ROLE CONTENT` |
| **Structural Container** | `OPEN_EDITORIAL_DEFAULT` (Unboxed facts, hairline dividers; Cards for property/quote only). Flat by default. | `OPEN_GROUPED_CONTENT` (One outer 12px container with internal hairline dividers). Flat by default. | Desktop multi-column audit tables and dense inspector panels. | `ROLE-SPECIFIC STRUCTURAL GRAMMAR` |
| **ListRow** | Navigation & Settings links (Chevron pointing left [←]); Compact booking facts. `CONTENT_ADAPTIVE` height. | Operational unit queues, settings rows, booking request lists with trailing triage CTA. `CONTENT_ADAPTIVE` height. | Dense tabular rows with multi-column audit data and inline actions. | `ROLE-SPECIFIC COMPOSITION` |
| **PropertyCard** | Discovery hero (1.4:1 media reference, favorite heart, price/night, compact facts). | Not used as discovery; Owner uses operational listing row with status badge. | Not used as discovery; Admin uses review queue record with image gallery inspector. | `CUSTOMER-SPECIFIC ASSEMBLY` |
| **BookingCard** | Stay recognition, dates, property title, payment/check-in next action. | Request priority, guest count, night count, payout amount, Accept/Decline action pair. | Multi-field audit record with renter identity, owner identity, payout status. | `ROLE-SPECIFIC ASSEMBLY` |
| **Navigation Shell** | 4-tab persistent bottom nav (Explore, Favorites, Bookings, Account) + Screen 16 exception. | Action-First Nested stack routing; Customer-style bottom nav PROHIBITED. | Desktop persistent sidebar / top navigation bar. | `ROLE-SPECIFIC ARCHITECTURE` |
| **AppBar** | Customer Header family (`TopLevelCustomer`, `NestedCustomer`, `TransactionalCustomer`). | Owner Header family (`TopLevelOwner`, `NestedOwner` with queue badges). | Desktop breadcrumb / operational workspace header. | `FAMILY / COMPOSITION PATTERN` |
| **BottomSheet** | Filter/refine sheets, date pickers, guest selector. | Fast unit status toggle sheet, filter sheets. | Not used on desktop (uses centered modals or side drawers). | `CUSTOMER/OWNER SHARED OVERLAY` |
| **ConfirmationDialog** | Reserved for irreversible booking withdrawal / cancellation (policy open). | Operational booking rejection (*"سيتم رفض طلب الحجز"*), destructive actions. | Audit revocation, property permanent ban confirmation. | `SHARED CONSEQUENTIAL OVERLAY` |
| **Toast** | Low-risk transient confirmation (*"تم حفظ الإقامة في المفضلة"*). | Low-risk confirmation (*"تم حفظ تعديلات الوحدة"*). | Operational copy/export confirmation (*"تم نسخ المعرف"*). | `SHARED TRANSIENT LAYER` |

---

## 3. Product Truth Dependency Matrix

| Component | Product Truth Entity / Source | Server-Authoritative Fields | Hard Constraints & Presentation Truth |
|---|---|---|---|
| **StatusBadge** | `properties`, `bookings`, `payment_transactions`, `owner_wallets`, `payout_requests`, `owners`, `owner_verification_documents` | `status`, `verification_status` | Never fabricates status; normal pending is not warning; no marketing trust inference. Text contrast targets >= 4.5:1. |
| **CustomerPropertyCard** | `properties` (public slice) | `id`, `title`, `region`, `resort_name`, `base_price_per_night`, `images`, `bedrooms`, `bathrooms`, `max_guests` | Real media reference only (1.4:1); no fake rating stars; no scarcity countdowns; price in EGP `/ ليلة`. |
| **Customer BookingCard** | `bookings`, `properties` | `status`, `check_in_date`, `check_out_date`, `total_amount`, `deposit_amount`, `property.title` | Actor causality preserved; never collapses `CANCELLED_BY_OWNER` with `CANCELLED_BY_GUEST`. |
| **Owner BookingCard** | `bookings`, `renters` (via safe booking view) | `id`, `status`, `check_in_date`, `check_out_date`, `total_amount`, `deposit_amount`, `guests_count`, `created_at` | Shows decision urgency; shows deposit and Owner net entitlement (80%); no customer private data leakage. |
| **MetricCard (Owner)** | `owner_wallets`, `bookings`, `properties` | `available_balance`, `pending_balance`, `pending_requests_count`, `published_units_count` | Available (min 500 EGP) strictly separated from Pending (releases 24h post check-in); never renders `0 ج.م` on query failure. |
| **ConfirmationDialog** | Consequential mutation endpoint | Action target ID, mutation endpoint (`reject`, `archive`) | Plain Arabic truth; explains exact consequence; zero response SLA promises. |
| **SectionAlert (Conflict)** | Quote validation / Booking availability | Server quote delta, price change, conflicting booked dates | Blocks submission CTA until customer explicitly accepts new truth. |
| **SectionAlert (Stale)** | Cached query cache | Last-known timestamp, cached price/data | Marks data non-current; provides explicit `[تحديث]` CTA; re-validates before payment. |

---

## 4. RTL / Bidi Behavior Contract

| Component | Layout Direction | Semantic Alignment | Icon Mirroring Rule | Text / Numeric Isolation Rule |
|---|---|---|---|---|
| **Button** | RTL | Icon at semantic start (RTL right), text at semantic end (RTL left). | Directional arrows mirror (Back arrow points Right [➔], Forward points Left [←]). Checkmarks, crosses, search icons DO NOT mirror. | Numbers formatted as Western Arabic (`0–9`). Mixed English codes wrapped in `<bdi>`. |
| **InputField / Phone** | RTL container | Label & placeholder align right. | Trailing clear action (`×`) at visual left. | Phone numbers, UUIDs, IBANs strictly LTR-isolated with `dir="ltr"` and `unicode-bidi: isolate`. |
| **SearchField** | RTL | Search icon at semantic start (RTL right), clear button at semantic end (RTL left). | Search icon (`Search`) does NOT mirror. Clear icon (`X`) does NOT mirror. | Search query text aligns right for Arabic, left for Latin. |
| **ListRow** | RTL | Leading icon/metadata at visual right, title/content center-right, chevron at visual left. | Disclosure chevron mirrors: points **Left** (`ChevronLeft` / `←`) to indicate navigation progression in RTL. | Secondary metadata badges align to visual left. |
| **CustomerPropertyCard** | RTL | Title, location, facts, and price align right. | Favorite heart button pinned at visual left (top-start or top-end per layout; top-left default in pilot). | Price formatted as `1,600 ج.م` with comma thousand separator and Western Arabic digits (`0–9`). |
| **BottomNavigation** | RTL | Tabs ordered right-to-left: `استكشف` (Rightmost) → `المفضلة` → `حجوزاتي` → `الحساب` (Leftmost). | Tab icons (`Compass`, `Heart`, `CalendarDays`, `UserRound`) DO NOT mirror. | Tab labels align center within tab cell. |
| **AppBar Family** | RTL | Back return button at visual right (points Right [➔]); Title center or right; Actions at visual left. | Hierarchical Back arrow mirrors: points **Right** (`ArrowRight` / `➔`) to return up stack in RTL. | Close button (`X`) remains non-directional. |
| **BottomSheet** | RTL | Title aligns right; Close button (`X`) pins to visual left. | Close icon does NOT mirror. | Drag handle (when present) centers horizontally. |
| **ConfirmationDialog** | RTL | Title & consequence body align right; Action buttons stack or align in RTL order. | Danger/Warning icons DO NOT mirror. | Primary affirmative CTA placed at natural reading progression. |

---

## 5. Accessibility & 200% Reflow Intent Contract

*Note: All items represent Accessibility Intent. Native screen reader (VoiceOver/TalkBack) and dynamic type acceptance are strictly `DEFERRED_TO_4I`.*

| Component | Accessible Role | Accessible Name / Label | State Exposure | 200% Text Reflow Expectation |
|---|---|---|---|---|
| **Button** | `button` | Text content or `aria-label` / `Semantics(label)`. | Exposes `disabled`, `busy` (loading). Never color-only. | Text wraps to multiple lines; button expands vertically; minimum platform target preserved; no text clipping. |
| **IconButton** | `button` | Mandatory explicit label (`aria-label` / tooltip / semantic label). Never unlabeled. | Exposes `disabled`, `selected` (favorite heart). | Touch bounding box satisfies platform guidance; icon scales proportionally up to platform threshold. |
| **InputField** | `textbox` | Explicit persistent top label associated via `for`/`id` or native field label slot. | Exposes `invalid`, `required`, `disabled`, `error-message`. | Label and helper text wrap naturally; container height expands vertically to fit text; no horizontal scroll. |
| **Checkbox** | `checkbox` | Label text associated with checkbox input. | Exposes `checked` / `unchecked` / `disabled`. Never relies on color alone. | Label wraps multiline; checkbox box remains aligned to first text line; target bounds satisfy platform guidance. |
| **StatusBadge** | `status` / `img` (semantic) | Arabic label text serves as accessible name. | Identified by text, NOT color alone. Text contrast targets >= 4.5:1. | Badge container expands horizontally or wraps; font scales up cleanly without clipping descenders. |
| **SectionAlert** | `alert` / `region` | Title and message read in sequence; retry CTA exposed. | Persistent until resolved. Focus moves to alert on consequential error. | Alert container grows vertically; text wraps; retry CTA wraps beneath copy if horizontal space tightens. |
| **Toast** | `status` (live region) | Announcement read via `aria-live="polite"` / native accessibility announcement. | Transient lifecycle; dismissed automatically. | Toast width expands up to viewport margins; text wraps to multiple lines without truncation. |
| **StateView** | `region` / `status` | State title + explanatory message + recovery action. | Complete state exposed to screen reader. | Full vertical reflow; illustration/icon scales or compresses gracefully; recovery CTA remains prominent. |
| **BottomSheet** | `dialog` | Sheet title provides accessible name. Explicit close control accessible to focus. | Focus trapped inside sheet while open; restored to trigger upon dismissal. | Content within body scrolls vertically; header and footer CTA remain pinned; text wraps completely. |
| **ConfirmationDialog**| `alertdialog` | Dialog title + consequence body announced immediately. Focus trapped inside dialog. | Safe dismiss action is default focused control; consequence action clearly labeled. | Dialog expands vertically up to 90vh; text wraps; action buttons stack vertically when text expands at 200%. |
| **StickyActionSurface**| `region` | Screen reader encounters action at end of reading sequence. | In-flight loading state disables CTA. | Surface height expands to accommodate multiline CTA text; content scrollview clearance increases dynamically. |

---

## 6. Detailed Component Contracts (Top 20 Families)

### 6.1 Button & IconButton
- **PURPOSE:** Trigger an immediate action, state mutation, or navigation transition.
- **USE WHEN:** User must commit an action (e.g. "إرسال طلب الحجز", "تأكيد الرفض", "تحديث").
- **DO NOT USE WHEN:** Direct navigation to a standard page URL without state mutation (use Link / ListRow).
- **ROLE APPLICABILITY:** Customer (Booking Commit, Search), Owner (Triage, KYC Submit), Admin (Audit Actions).
- **PLATFORM AUTHORITY:** Web uses `radius.control` (12px); Mobile uses `6px` Primary Button radius (`FOUNDER-SELECTED PROVISIONAL PRIMARY_ONLY`).
- **ANATOMY:** Container, Label Text, Optional Leading/Trailing Icon, In-flight Spinner.
- **SEMANTIC VARIANTS:** Decision Primary (Stable Black `#000000`), Standard Primary, Neutral Secondary (Subtle Fill), Conditional Neutral Outline, Tertiary/Ghost, Destructive Primary, Destructive Secondary (Outline), Destructive Ghost.
- **INTERACTION STATES:** Default, Pressed, Focused, Loading, Disabled.
- **MUTATION PROTECTION:** In-flight mutex protection against duplicate network mutations (`SINGLE_IN_FLIGHT_MUTATION_GUARD`).
- **CONTENT CONTRACT:** Action verbs in plain Arabic ("إرسال", "تأكيد", "إلغاء", "تحديث"). Never promise unverified states (e.g. never "تأكيد الحجز" prior to payment).
- **PRODUCT TRUTH DEPENDENCIES:** Must represent valid server lifecycle transitions (`UX-ACTION-01`).
- **RTL / BIDI:** Directional icons mirror (➔ / ←); Western Arabic digits (`0–9`).
- **ACCESSIBILITY:** Accessible name mandatory; state not color-only; platform touch bounds (iOS ~44pt / Android ~48dp; Web min 48px CSS).
- **200% REFLOW:** Text wraps to 2 lines; button height increases; no horizontal text truncation.
- **COMPOSITION RULES:** Exactly ONE Decision Primary per active decision unit. Multiple Primaries allowed across distinct independent cards.
- **FORBIDDEN COMBINATIONS:** Yellow/amber primary button; multiple competing Primaries in one decision unit; disabled button concealing recoverable failure without retry copy.
- **GOVERNED VALUES:** Primary Black `#000000` (provisional), Primary Radius `6px` (provisional primary-only).
- **OPEN VALUES:** Secondary radius, exact neutral fill/border hex, exact destructive red hex, exact focus halo.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I` (haptics, platform touch targets, voiceover).

### 6.2 InputField (Text, Phone, Numeric, Textarea)
- **PURPOSE:** Allow user to enter, edit, and submit text, telephone numbers, financial amounts, and multiline descriptions.
- **USE WHEN:** Data entry required in forms, authentication, profile editing, and property setup.
- **DO NOT USE WHEN:** Single selection from <=4 options (use SegmentedControl / Radio); binary on/off (use Checkbox).
- **ROLE APPLICABILITY:** Customer (Phone entry, Search query), Owner (Unit pricing, details, bank details), Admin (Review notes).
- **PLATFORM AUTHORITY:** Outline-Led field baseline; Mobile Field Radius: `8px` (`FOUNDER-SELECTED PROVISIONAL FIELD_ONLY`).
- **ANATOMY:** Explicit Top Label, Field Container (White surface, thin neutral outline), Value / Placeholder, Optional Leading Icon, Optional Trailing Clear Action, Helper Copy, Error Copy.
- **SEMANTIC VARIANTS:** Text, Phone, Numeric / Currency, Multiline Textarea, Search.
- **INTERACTION STATES:** Unfilled (`NO_VALUE`), Focused (Restrained blue interaction accent), Filled, Error, Disabled, Read-only. (Does NOT use Phase 4G view-level `EMPTY`).
- **CONTENT CONTRACT:** Plain Arabic labels; concise placeholder; specific error messages explaining exact failure.
- **PRODUCT TRUTH DEPENDENCIES:** Field-level validation rules from backend schema.
- **RTL / BIDI:** RTL text alignment; Phone and numeric inputs strictly LTR-isolated with Western Arabic digits (`0–9`).
- **ACCESSIBILITY:** Top label associated via ID; error announced to screen reader; contrast compliant outline.
- **200% REFLOW:** Field height expands naturally; labels and errors wrap without clipping descenders.
- **COMPOSITION RULES:** Label is always persistent top label; floating labels are PROHIBITED.
- **FORBIDDEN COMBINATIONS:** Floating labels; error indicated by red border alone without text; placeholder-only fields without labels.
- **GOVERNED VALUES:** Outline-Led baseline, Mobile Field Radius `8px` (provisional field-only), Cairo Profile B.
- **OPEN VALUES:** Exact neutral outline hex, exact focus halo geometry, exact native field height (`DEFERRED_TO_4I`).
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I` (virtual keyboard behavior, cursor positioning, input accessory).

### 6.3 StatusBadge
- **PURPOSE:** Visually identify canonical domain status of an entity.
- **USE WHEN:** Summarizing entity lifecycle state in cards, queues, detail headers, or profiles.
- **DO NOT USE WHEN:** As a substitute for explanatory copy, error recovery, or as a marketing trust badge.
- **ROLE APPLICABILITY:** Customer (Booking state), Owner (Property, Booking, Payout, KYC), Admin (Queue audit).
- **PLATFORM AUTHORITY:** Phase 4G / badges.md canonical status mapping across 8 domain families.
- **ANATOMY:** Pill container, Semantic text label, Optional status dot.
- **SEMANTIC VARIANTS:** `neutral_process`, `informational_process`, `success`, `danger`, `neutral_muted`, `neutral_attention`.
- **INTERACTION STATES:** Static presentation (non-interactive).
- **PRODUCT TRUTH DEPENDENCIES:** Bound strictly to canonical server enums (`properties.status`, `properties.verification_status`, `bookings.status`, `payment_transactions.status`, `owner_wallets`, `payout_requests.status`, `owners.verification_status`, `owner_verification_documents.status`).
- **RTL / BIDI:** Arabic label text aligned center-right; Western Arabic digits if present.
- **ACCESSIBILITY:** Accessible text label; never relies on color alone; normal text targets `>= 4.5:1` text contrast against badge background.
- **200% REFLOW:** Badge container expands horizontally to fit scaled text; padding scales gracefully.
- **COMPOSITION RULES:** Always placed adjacent to entity title or within metadata row; never floating without context.
- **FORBIDDEN COMBINATIONS:** Amber/warning styling for normal pending milestones; marketing trust labels ("إقامة موثقة"); generic "CANCELLED" collapsing actor causality.
- **GOVERNED VALUES:** Canonical enum mappings (badges.md).
- **OPEN VALUES:** Exact semantic hex tokens.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.

### 6.4 SectionAlert & Toast (Feedback System)
- **PURPOSE:** Deliver persistent actionable recovery (SectionAlert) or transient low-risk confirmation (Toast).
- **USE WHEN:** SectionAlert: blocked submission, query error, conflict, stale data warning. Toast: completed low-risk confirmation ("تم الحفظ").
- **DO NOT USE WHEN:** Toast must NEVER be used for critical failures, financial warnings, or blocking errors.
- **ROLE APPLICABILITY:** Shared across Customer, Owner, Admin.
- **PLATFORM AUTHORITY:** Phase 4G Four-Layer State Delivery model; MR-17 Founder rule (NO yellow/amber boxed containers).
- **ANATOMY:** SectionAlert: Container (`OPEN / COMPONENT-GOVERNED` radius), Status Icon, Title, Description, Action Button. Toast: Floating pill, Icon, Confirmation text.
- **SEMANTIC VARIANTS:** Neutral Process, Informational (Soft Blue), Error / Danger (Rose/Red), Success.
- **INTERACTION STATES:** SectionAlert: Static container with state-appropriate recovery CTA. Toast: Transient display with automatic dismissal.
- **PRODUCT TRUTH DEPENDENCIES:** Server error codes, sync failures, mutation confirmations.
- **RTL / BIDI:** RTL alignment; icon at visual right, text center, CTA at visual left or stacked below.
- **ACCESSIBILITY:** Live region announcement; SectionAlert receives keyboard focus on error; Toast announced non-disruptively.
- **200% REFLOW:** Full vertical wrapping; action button drops below copy if horizontal width < 300px; no clipping.
- **COMPOSITION RULES:** Critical failures must be SectionAlert or ScreenState, NEVER Toast-only.
- **FORBIDDEN COMBINATIONS:** Yellow/amber/orange container fills or borders (MR-17); toast-only critical errors.
- **GOVERNED VALUES:** 4-tier state delivery hierarchy.
- **OPEN VALUES:** Exact toast display duration (`OPEN / PLATFORM_ACCESSIBILITY_GATED`), exact semantic background/border hex, alert radius (`OPEN / COMPONENT-GOVERNED`).
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I` (native overlay positioning, accessibility focus management).

### 6.5 StateView (ScreenState, SectionState, InlineState)
- **PURPOSE:** Present complete data-lifecycle state when content cannot be rendered normally.
- **USE WHEN:** Data request is Loading, Empty, Errored, Offline, Unauthorized, Stale, or Conflicted.
- **DO NOT USE WHEN:** Data is loaded and healthy (render normal components).
- **ROLE APPLICABILITY:** Customer (Explore empty, Bookings error), Owner (Requests empty, Wallet error), Admin (Queue empty/error).
- **PLATFORM AUTHORITY:** Phase 4G Role-Aware Layered State System (Candidate C).
- **ANATOMY:** State Illustration / Icon, Title (`pageTitle` or `sectionTitle`), Explanatory Message (`body`), State-Appropriate Recovery Action (conditional on real action existing).
- **SEMANTIC VARIANTS:** `LOADING`, `EMPTY`, `ERROR`, `OFFLINE`, `UNAUTHORIZED`, `PARTIAL`, `STALE`, `CONFLICT`.
- **EMPTY STATE ACTION:** Conditional upon a real next action existing (`EMPTY_STATE_ACTION: CONDITIONAL_WHEN_REAL_NEXT_ACTION_EXISTS`). Admin review queue empty has NO recovery CTA.
- **RECOVERY ACTIONS:** State-appropriate recovery (`STATE_APPROPRIATE_RECOVERY`: Retry, Refresh, Re-auth, Change filters, Review changed truth, Fix input, Return, Contact support — never a universal retry button).
- **INTERACTION STATES:** Interactive recovery CTAs when appropriate.
- **PRODUCT TRUTH DEPENDENCIES:** View lifecycle query state; answers the 4 Critical State Questions (What happened? What is still true? What is the impact? What can I do?).
- **RTL / BIDI:** Centered or right-aligned Arabic text; icons non-directional.
- **ACCESSIBILITY:** Announced to screen reader; focus directed to recovery CTA on error.
- **200% REFLOW:** Full responsive vertical flow; container expands; actions stack vertically.
- **COMPOSITION RULES:** `ERROR != EMPTY`; `FAILED_QUERY != FAKE_ZERO`; `PARTIAL != ERROR` (scoped section recovery).
- **FORBIDDEN COMBINATIONS:** Rendering empty state on network failure; showing `0 ج.م` on wallet error; yellow/amber alert boxes.
- **GOVERNED VALUES:** Invariants (ERROR!=EMPTY, etc.), Candidate C role-aware hierarchy.
- **OPEN VALUES:** Exact illustration vectors, exact background tokens.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.

### 6.6 Structural Container & ListRow
- **PURPOSE:** Provide structural grouping for related operational records or discrete decision units.
- **USE WHEN:** Grouping homogeneous records (Owner queue) or framing an independently actionable entity (PropertyCard, Server Quote).
- **DO NOT USE WHEN:** Content belongs to a continuous reading journey (use `OPEN_CONTENT` with unboxed typography and hairline dividers).
- **ROLE APPLICABILITY:** Customer (`OPEN_EDITORIAL_DEFAULT`), Owner (`OPEN_GROUPED_CONTENT`), Admin (`DESKTOP_WEB_PRESERVED`).
- **PLATFORM AUTHORITY:** Phase 4E Role-Aware Hybrid Structural System; Mobile Structural Container Radius: `12px` (`SYSTEM-EVALUATED PROVISIONAL` for semantic containers and grouped collections; open editorial has NO container radius).
- **ANATOMY:** Container (12px radius, `FLAT_BY_DEFAULT / NO SHADOW`, subtle border), Optional Title, Content Rows, Internal Hairline Dividers (1px reference).
- **SEMANTIC VARIANTS:** `OPEN_CONTENT` (No container), `OPEN_GROUPED_CONTENT` (Single container with dividers), `INTERACTIVE_CONTAINER / CARD` (Bounded decision unit).
- **INTERACTION STATES:** Resting, Pressed (ListRow), Focused.
- **ADAPTIVE HEIGHT:** ListRow vertical dimension is `CONTENT_ADAPTIVE`, expanding vertically under 200% text scaling without clipping.
- **RTL / BIDI:** RTL row layout; ListRow trailing chevron points **Left** (`←`) in RTL.
- **ACCESSIBILITY:** Container boundaries marked for screen reader; whole-row clicks have accessible role.
- **200% REFLOW:** Container expands vertically; rows expand in height; text wraps without clipping.
- **COMPOSITION RULES:** Anti-card soup: DO NOT nest cards inside cards; DO NOT frame every text paragraph in a box.
- **FORBIDDEN COMBINATIONS:** Card soup; yellow/amber container fills; dark KPI slabs.
- **GOVERNED VALUES:** Mobile Structural Container Radius `12px` (provisional), Mobile Page Inset `16px` (provisional), Spacing Scale `4/8/12/16/24/32`.
- **OPEN VALUES:** Exact neutral border hex, exact divider stroke width, exact native ListRow height (`DEFERRED_TO_4I`).
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.

### 6.7 Customer PropertyCard
- **PURPOSE:** Primary discovery card presenting a property in Explore, Search Results, and Favorites.
- **USE WHEN:** Displaying rental units in browse feeds.
- **DO NOT USE WHEN:** Displaying Owner management queues or Admin audit lists.
- **ROLE APPLICABILITY:** Customer exclusively.
- **PLATFORM AUTHORITY:** Phase 4E / Phase 5 Screen 03 spec (`CUSTOMER_PHASE5_MASTER_UX.md`).
- **AUTHORITY SPLIT:**
  - `CURRENT WEB PROPERTYCARD AUTHORITY`: React Tailwind implementation in `customer-app/`, >=48px CSS touch target, active `#0059FF`.
  - `FUTURE MOBILE CONTRACT`: Cairo Profile B semantic roles, platform touch bounds (iOS ~44pt / Android ~48dp), interaction-accent role with exact blue `OPEN`, 1.4:1 ratio is `PROVISIONAL_MOBILE_REFERENCE`.
- **ANATOMY:** 1.4:1 Aspect Ratio Photo reference, Floating Favorite Heart Button (Top-Left), Title (Cairo `16px` bold, line-clamp 2), Location (Cairo `13px`, line-clamp 2), Compact Facts (X ضيوف · Y غرف · Z حمام), Price (Cairo `18–20px` EGP `/ ليلة`).
- **INTERACTION STATES:** Default, Pressed, Favorite Toggled.
- **PRODUCT TRUTH DEPENDENCIES:** Server property record (`id`, `title`, `region`, `resort_name`, `base_price_per_night`, `images`, `bedrooms`, `bathrooms`, `max_guests`).
- **RTL / BIDI:** RTL text alignment; Price in EGP `/ ليلة` with Western Arabic numerals (`0–9`).
- **ACCESSIBILITY:** Card has single accessible action to view details; Favorite heart is independent accessible button with decoupled click handling.
- **200% REFLOW:** Text wraps cleanly; line-clamps relaxed under extreme scaling; card height expands.
- **COMPOSITION RULES:** Unboxed clean surface; no internal borders; entire card is interactive trigger to Property Details.
- **FORBIDDEN COMBINATIONS:** Synthetic trust badges ("إقامة موثقة"); fake star ratings; scarcity counters ("تبقى غرفة واحدة!"); nested secondary links.
- **GOVERNED VALUES:** Aspect ratio `1.4:1` (`CURRENT_WEB_AUTHORITY + PROVISIONAL_MOBILE_REFERENCE`), Cairo Profile B typography, EGP `/ ليلة` format.
- **OPEN VALUES:** Exact favorite heart accent blue hex.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I` (image caching, hero transitions).

### 6.8 BookingCard (Customer & Owner Variants)
- **PURPOSE:** Present a booking record tailored to role-specific decision needs.
- **USE WHEN:** Displaying bookings in Customer "حجوزاتي" list or Owner "الطلبات" queue.
- **ROLE APPLICABILITY:** Role-specific assemblies for Customer and Owner.
- **ANATOMY (Customer):** Property Thumbnail, Property Title, Stay Dates (Check-in → Check-out), StatusBadge, Financial Summary (Total / Deposit Paid / Remaining Balance), Primary Contextual Action (e.g. "دفع العربون", "عرض التفاصيل").
- **ANATOMY (Owner):** Guest Identifier, Property Name, Stay Dates & Night Count, Guest Count, StatusBadge, Deposit & Net Entitlement (80%), Urgent Triage Action Pair ("قبول الطلب" Primary + "رفض" Destructive Outline).
- **INTERACTION STATES:** Default, Pressed (card tap to detail), Button interaction.
- **PRODUCT TRUTH DEPENDENCIES:** Canonical booking status, dates, financial breakdown.
- **RTL / BIDI:** RTL alignment; date ranges formatted right-to-left; amounts in EGP.
- **ACCESSIBILITY:** Accessible status description; unambiguous action button labels.
- **200% REFLOW:** Dates and financial figures wrap without truncation; action buttons stack if needed.
- **COMPOSITION RULES:** Customer version never shows commission or owner split; Owner version displays operational triage priority.
- **FORBIDDEN COMBINATIONS:** Single generic BookingCard with role flags; collapsing actor causality on cancellations.
- **GOVERNED VALUES:** 12px structural container radius, Profile B typography, status mappings.
- **OPEN VALUES:** Exact status badge colors, exact neutral container border.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.

### 6.9 Customer BottomNavigation
- **PURPOSE:** Primary top-level navigation shell for Customer mobile application.
- **USE WHEN:** Presenting top-level destinations to Customer users.
- **DO NOT USE WHEN:** Nested entity screens, dedicated transactional reviews (Screen 07), auth routes, or in the Owner application.
- **ROLE APPLICABILITY:** Customer exclusively. (PROHIBITED for Owner mobile application).
- **PLATFORM AUTHORITY:** Phase 4F Navigation & Overlay System.
- **ANATOMY:** Bottom bar container, 4 Tab Destinations (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`), Icons (`Compass`, `Heart`, `CalendarDays`, `UserRound`), Text Labels, Active Accent Indicator.
- **INTERACTION STATES:** Active (Restrained interaction accent blue, candidate `#276EF1`), Inactive (Slate-400/500), Pressed.
- **SCREEN 16 EXCEPTION:** Visible on Screen 16 (Notification Center) with Account tab active (`ACCOUNT_SHELL_CHILD_EXCEPTION`).
- **DUAL BOTTOM CHROME BAN:** Must NEVER coexist with a sticky action surface on the same screen.
- **RTL / BIDI:** Tabs ordered right-to-left; labels in Arabic; icons non-directional.
- **ACCESSIBILITY:** `tablist` with `tab` items; exposes `selected` state; labels accessible.
- **200% REFLOW:** Bar expands vertically to accommodate larger text; tab labels must remain understandable and wrap/reflow vertically; dropping or truncating labels is PROHIBITED.
- **GOVERNED VALUES:** Exactly 4 root destinations, mutual exclusivity with sticky actions.
- **OPEN VALUES:** Exact blue accent hex (`#276EF1` candidate), exact bar height token.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I` (safe-area bottom padding, tab state persistence).

### 6.10 AppBar Family (7 Configurations)
- **PURPOSE:** Provide contextual top-of-screen identity, navigation return, and contextual actions.
- **USE WHEN:** Top of every mobile screen.
- **ROLE APPLICABILITY:** Customer, Owner, Overlay surfaces.
- **PLATFORM AUTHORITY:** Phase 4F Navigation & Overlay System.
- **CONFIGURATIONS:**
  1. `TopLevelCustomer`: Mark (32px) + Account affordance (`UserRoundPlus` / Avatar).
  2. `NestedCustomer`: RTL Back (➔) + Title + Optional Actions (Favorite, Share).
  3. `TransactionalCustomer` (Screen 07): RTL Back (➔) + Review Title ("مراجعة طلب الحجز").
  4. `AuthFullScreen`: Brand mark / step indicator + Back (➔) / Cancel text.
  5. `TopLevelOwner`: Owner identity + verification pill + alert affordance.
  6. `NestedOwner`: RTL Back (➔) + Queue Title + StatusBadge.
  7. `TemporaryLayerHeader`: Title + Close (X).
- **RTL / BIDI:** RTL Back arrow mirrors: points **Right** (`ArrowRight` / `➔`) to go back up hierarchy. Close (`X`) does NOT mirror.
- **ACCESSIBILITY:** Accessible back/close buttons; screen title announced as heading (`H1`).
- **200% REFLOW:** Title wraps to second line or truncates with ellipsis; back button remains visible and accessible.
- **COMPOSITION RULES:** Back (➔) is strictly for hierarchical return; Close (X) is strictly for temporary overlay dismissal.
- **FORBIDDEN COMBINATIONS:** Dark/navy header themes; hamburger menu in Owner app; Back arrow to dismiss a temporary sheet.
- **GOVERNED VALUES:** Back vs Close grammar, screen family topologies.
- **OPEN VALUES:** Exact status-bar integration metrics.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.

### 6.11 BottomSheet
- **PURPOSE:** Contextual overlay surface for contained tasks, filters, pickers, and transient interactions.
- **USE WHEN:** Filter refinement, guest selection, date selection sheets.
- **DO NOT USE WHEN:** Auth V2 (`08 → 09 → 10`), Property Detail, Booking Request Review (Screen 07), multi-step flows (use Full Page Nested).
- **ROLE APPLICABILITY:** Customer and Owner.
- **PLATFORM AUTHORITY:** Phase 4F Navigation & Overlay System.
- **ANATOMY:** Top-rounded container, Optional Drag Handle, Sheet Header with Title and Explicit Close (X), Scrollable Content Body, Pinned Bottom Action.
- **GEOMETRY:** Top Radius: **`16px`** (`SYSTEM-EVALUATED PROVISIONAL`).
- **DISMISS GRAMMAR:** Explicit Close (X) is `REQUIRED`; Drag handle is `OPTIONAL`; Backdrop tap dismiss is `CONDITIONAL_LOW_RISK`.
- **ELEVATION & SCRIM:** Restrained elevation over dimmed backdrop scrim (pilot reference `0 -4px 24px rgba(15,23,42,0.10)`).
- **RTL / BIDI:** RTL header layout; Close (X) at visual left; Title at visual right.
- **ACCESSIBILITY:** Focus trapped inside sheet; Escape / Back dismisses sheet; focus restored to trigger.
- **200% REFLOW:** Content scrolls vertically inside body; footer CTA remains pinned; no vertical text clipping.
- **COMPOSITION RULES:** Exactly ONE temporary layer at a time; cascading sheets PROHIBITED.
- **FORBIDDEN COMBINATIONS:** Full-screen navigation masquerading as a sheet; sheet without an explicit close button; backdrop dismissal on unsaved forms.
- **GOVERNED VALUES:** 16px provisional top radius, explicit close requirement.
- **OPEN VALUES:** Exact native detents, exact scrim opacity/blur, transition duration (`DEFERRED_TO_4I`).
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I` (gesture dragging physics, keyboard avoidance).

### 6.12 ConfirmationDialog
- **PURPOSE:** Centered overlay for short, consequential confirmation and irreversible decisions.
- **USE WHEN:** High-stakes actions supported by current product capabilities: Owner reject booking request, Admin property/KYC rejection. (Future capabilities such as banning accounts, releasing disputed payouts, deleting listings, or calendar blocking are `DEFERRED_TO_OWNING_PRODUCT_PHASE`).
- **DO NOT USE WHEN:** Navigation, long forms, entity details, routine low-risk actions.
- **ROLE APPLICABILITY:** Shared across Customer, Owner, Admin.
- **PLATFORM AUTHORITY:** Phase 4F Navigation & Overlay System.
- **ANATOMY:** Centered modal surface, Title, Plain Arabic Consequence Body, Action Pair (Safe Dismiss "تراجع" + Consequential Action).
- **GEOMETRY:** Surface Radius: **`12px`** (`SYSTEM-EVALUATED PROVISIONAL`).
- **CONSEQUENCE GRAMMAR:** Truthful plain Arabic consequence text mandatory (*"سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون"*). Never relies on color alone.
- **ELEVATION & SCRIM:** Centered over dimmed backdrop scrim (pilot reference `0 12px 36px rgba(15,23,42,0.16)`).
- **RTL / BIDI:** RTL text alignment; Action buttons laid out in natural RTL reading order.
- **ACCESSIBILITY:** `alertdialog` role; focus trapped; safe dismiss button is default focus; consequence announced.
- **200% REFLOW:** Dialog expands vertically (up to 90vh scrollable); action buttons stack vertically when text expands.
- **COMPOSITION RULES:** Short decisions only; single action pair; dismissing cancels safely without server mutation.
- **FORBIDDEN COMBINATIONS:** Centered modal for Auth V2; centered modal for Property Details; unapproved product consequence claims.
- **GOVERNED VALUES:** 12px provisional surface radius, plain Arabic consequence requirement.
- **OPEN VALUES:** Exact shadow parameters, exact scrim opacity.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.

### 6.13 StickyActionSurface
- **PURPOSE:** Pin high-priority commitment actions to bottom of viewport while content scrolls beneath.
- **USE WHEN:** Booking Request Review (Screen 07), Deposit Payment, Property Detail booking bar.
- **DO NOT USE WHEN:** Persistent Bottom Navigation is active on the screen (DUAL BOTTOM CHROME PROHIBITED).
- **ROLE APPLICABILITY:** Customer and Owner.
- **PLATFORM AUTHORITY:** Phase 4F Navigation & Overlay System.
- **ANATOMY:** Surface container (White / light background, subtle top hairline border), Action Details (e.g. Total Price), Primary Action Button (Stable Black 6px), Safe-area bottom padding.
- **CLEARANCE CONTRACT:** Scrollable content view must reserve bottom clearance equal to Sticky Bar Height + Safe Bottom Inset so content is never occluded.
- **RTL / BIDI:** RTL alignment; price details at visual right, commitment CTA at visual left.
- **ACCESSIBILITY:** Reached naturally at end of scroll reading sequence; keyboard focus management.
- **200% REFLOW:** Surface expands vertically if text wraps; clearance adapts dynamically.
- **COMPOSITION RULES:** Mutual exclusivity with BottomNavigation; exactly ONE primary action button.
- **FORBIDDEN COMBINATIONS:** Dual bottom chrome (Bottom Nav + Sticky Bar on same screen); fixed height causing text clipping.
- **GOVERNED VALUES:** Mutual exclusivity with bottom nav, safe-area clearance contract.
- **OPEN VALUES:** Exact top border token, exact elevation.
- **NATIVE ACCEPTANCE:** `DEFERRED_TO_4I`.
