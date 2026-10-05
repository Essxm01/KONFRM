# Phase 4F Navigation & Overlay Discovery

**Status:** `SYSTEM_EVALUATED_DISCOVERY`
**Phase:** `PHASE_4F_NAVIGATION_OVERLAY_SYSTEM`
**Governing Authority:** `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` (DF2 v1.4), `docs/codex/KONFRM_MASTER_RULES.md`
**Data Status:** `LAB_SCENARIO_DATA`
*(Discovery patterns and synthetic layout data serve layout and navigation presentation architecture; `LAB_SCENARIO_DATA ≠ production evidence`).*

---

## 1. Executive Summary & Architectural Scope

Phase 4F establishes the navigation, header, hierarchy, return-path, overlay (bottom sheet / dialog), sticky action, and safe-area geometry across KONFRM mobile applications (Customer and Owner), with explicit boundary verification for desktop Admin.

In accordance with Section 8 of the Phase 4F directive:
> Navigation follows user job, destination frequency, hierarchy, and context—not visual symmetry.
> Customer, Owner, and Admin do not share identical navigation structures, tab counts, or chrome. One KONFRM family does not mean three recolored clones. A destination is not top-level merely because it exists.

---

## 2. Navigation Authority Conflict Audit

Before formulating candidate systems, all prior specifications, components, and web implementations were audited and classified against the canonical hierarchy:

| Item / Subject | Document / Implementation Source | Canonical Mobile Architecture | Authority Classification | Resolution / Disposition |
|---|---|---|---|---|
| **Owner Bottom Navigation** | `DESIGN_SYSTEM/EXPERIENCE/NAVIGATION.md`, `owner-app/src/components/layout/BottomNavigation.tsx` (5 tabs) | `KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md` §3 explicitly mandates: `app/ router (dashboard-style, بدون bottom-nav عميل)` | `CONFLICT` (Source: `WEB_BEHAVIORAL_EVIDENCE_ONLY` vs `CANONICAL_ARCHITECTURE`) | **Architecture wins unconditionally.** Mobile Owner app has dashboard-style nested routing **WITHOUT** Customer-style bottom navigation. Web 5-tab bar is permanently rejected for mobile. |
| **Active Accent Color** | `DESIGN_SYSTEM/COMPONENTS/navigation.md` (specifies `#0059FF`) | `docs/CURRENT_STATE.md`, Phase 4B/4C/4E outcomes: `EXACT_BLUE: OPEN`. Restrained interaction-accent role is governed. | `CONFLICT` (Source: `LEGACY_DESIGN_EVIDENCE` vs `PROVISIONAL_DESIGN_DIRECTION`) | **Exact blue remains OPEN.** Neither `#0059FF` nor `#276EF1` is canonized. Active tab uses semantic restrained interaction accent; pilot uses `#276EF1` comparator only. |
| **Touch Target Units** | `DESIGN_SYSTEM/COMPONENTS/navigation.md` (raw "48px touch targets") | Cross-platform guidance: iOS ~44pt, Android ~48dp. Native acceptance deferred to 4I. | `CONFLICT` (Source: `LEGACY_DESIGN_EVIDENCE` vs `PLATFORM_ACCESSIBILITY_EVIDENCE`) | **Web px does not establish native acceptance.** Touch guidance is iOS ~44pt / Android ~48dp; native acceptance is `DEFERRED_TO_4I`. |
| **Customer Auth Modality** | `customer-app/src/components/CustomerAuthModal.tsx` (modal overlay) | Screen 08–10 Auth V2 specification: sequential full-screen route flow (`08 → 09 → 10`). | `CONFLICT` (Source: `WEB_BEHAVIORAL_EVIDENCE_ONLY` vs `APPROVED_PRODUCT_UX`) | **Auth V2 is strictly FULL-SCREEN.** Web modal was interim implementation evidence. Protected action interruption preserves continuation intent upon return. |
| **Customer Property Detail Modality** | `customer-app/src/components/PropertyDetailModal.tsx` (modal container) | Mobile deep entity: nested full-page destination with dedicated contextual app bar, hero, and sticky booking-request surface. | `CONFLICT` (Source: `WEB_BEHAVIORAL_EVIDENCE_ONLY` vs `APPROVED_PRODUCT_UX`) | **Property Detail is FULL PAGE NESTED.** Modals/sheets are not navigation substitutes for primary entity evaluation. |
| **Explore Header Notifications** | Web legacy patterns / generic apps (adding Bell to Explore header) | `DESIGN_SYSTEM/COMPONENTS/navigation.md` §Header: "no Bell icon in the Explore header. Customer Notification Center is a separate Account-origin destination." | `CANONICAL_ARCHITECTURE` | **Preserved unconditionally.** Explore header retains brand mark + single account/identity affordance. No notification bell clutter. |
| **Customer Tab Count** | `customer-app/src/components/CustomerBottomNav.tsx` | Exactly 4 destinations: استكشف (`Compass`), المفضلة (`Heart`), حجوزاتي (`CalendarDays`), الحساب (`UserRound`). | `CANONICAL_ARCHITECTURE` | **Preserved unconditionally.** Exactly 4 tabs. No 5th permanent tab (chat/payment are contextual; notifications are Account-origin). |
| **Admin Boundary** | `admin-app/` | Desktop web table/queue/audit workspace. No mobile bottom nav. | `CANONICAL_ARCHITECTURE` | **Preserved unconditionally.** Admin desktop operational table workspace is isolated from mobile navigation changes. |

---

## 3. Screen Family & Navigation Pattern Inventory

### Pattern 1: Customer Top-Level Destination (Explore, Favorites, Bookings, Account)
- **Role:** Customer
- **Screen Family:** `TOP_LEVEL_CUSTOMER`
- **Current Entry:** App launch / tab switch via bottom navigation.
- **Current Exit:** Tab switch, or dive into nested entity.
- **Persistent Nav Present?:** YES (4-tab bottom navigation).
- **Header Pattern:**
  - On Explore: Standalone KONFRM mark (start) + Account/Identity affordance (end). No Bell.
  - On Favorites / Bookings / Account: Semantic page title + contextual status/action if warranted; no back arrow (top-level).
- **Back Pattern:** NONE (top-level root).
- **Close Pattern:** NONE.
- **Temp Layer Type:** NONE.
- **Sticky Action?:** NONE on top-level root.
- **Safe Area Pattern:** Top platform safe area padded on header; bottom platform safe area padded beneath bottom navigation bar.
- **Context Preservation:** Preserves active scroll position and filtered query state when switching tabs.
- **Authority Class:** `APPROVED_PRODUCT_UX` / `CANONICAL_ARCHITECTURE`
- **Disposition:** `PRESERVE`

---

### Pattern 2: Customer Nested Entity (Property Detail)
- **Role:** Customer
- **Screen Family:** `NESTED_CUSTOMER`
- **Current Entry:** Tap card from Explore / Search Results / Favorites.
- **Current Exit:** Hierarchical Back arrow to parent origin.
- **Persistent Nav Present?:** NO. Top-level bottom nav is hidden to avoid dual bottom chrome and focus collision with sticky booking action.
- **Header Pattern:** Contextual App Bar: RTL Back button (semantic start), optional share/favorite action (semantic end). Title collapses/fades into app bar on scroll.
- **Back Pattern:** Semantic RTL Back arrow (pointing rightward in RTL) returning to the exact scroll position and filter state of Explore/Results.
- **Close Pattern:** NONE (hierarchical return, not dismiss).
- **Temp Layer Type:** NONE (full-screen page).
- **Sticky Action?:** YES. Sticky bottom decision surface: canonical nightly price + dates summary + Primary CTA ("طلب الحجز" / "إرسال طلب الحجز" / "متابعة الحجز" — NEVER "تأكيد الحجز" prior to Owner approval).
- **Safe Area Pattern:** Header respects top notch/island; sticky action respects bottom safe area. Scrolling content reserves matching bottom clearance padding to prevent obscured content.
- **Context Preservation:** Contract-defined: returning via Back restores Explore scroll position and active search filters.
- **Authority Class:** `APPROVED_PRODUCT_UX`
- **Disposition:** `CHANGE` (Promote from Web modal to full-page nested flow).

---

### Pattern 3: Customer Contextual Refinement (Search Filters / Date Picker Sheet)
- **Role:** Customer
- **Screen Family:** `TEMPORARY_CONTEXTUAL_LAYER`
- **Current Entry:** Tap search bar or filter pill on Explore / Search Results.
- **Current Exit:** Tap Close (X), swipe down (conditional), or tap primary "عرض الوحدات" (Apply) action.
- **Persistent Nav Present?:** Covered by modal backdrop.
- **Header Pattern:** Temporary Layer Header: Sheet title ("تصفية نتائج البحث") + explicit Close icon button (X).
- **Back Pattern:** NONE (Close/X only).
- **Close Pattern:**
  - `EXPLICIT_DISMISS_CONTROL`: REQUIRED (visible Close X button).
  - `DRAG_HANDLE`: OPTIONAL (only when sheet is draggable).
  - `BACKDROP_TAP_DISMISS`: CONDITIONAL (permitted on low-risk search filters; prohibited on unsaved destructive/high-stakes workflows).
- **Temp Layer Type:** `BOTTOM_SHEET` (rounded top corners, elevated over dimmed scrim).
- **Height Discipline:** Contextual task; web pilot geometry uses max-height 85% reference; native detent behavior is `DEFERRED_TO_4I`.
- **Sticky Action?:** Sticky bottom action inside sheet ("عرض الوحدات").
- **Context Preservation:** Dismissing without apply leaves previous search criteria intact. Applying updates underlying Explore feed.
- **Authority Class:** `APPROVED_PRODUCT_UX`
- **Disposition:** `PRESERVE` (Standardize sheet geometry and dismiss behavior).

---

### Pattern 4: Customer Protected Flow Interruption (Auth V2)
- **Role:** Customer
- **Screen Family:** `AUTH_FULL_SCREEN`
- **Current Entry:** Tapping Favorite as guest, tapping Book as guest, or tapping Guest Account affordance on Explore.
- **Current Exit:** Back arrow (returns to prior unauthenticated context) or successful completion (continuation to target action).
- **Persistent Nav Present?:** NO (clean full-screen authentication flow).
- **Header Pattern:** Dedicated minimal header: Brand mark or minimal title ("تسجيل الدخول / إنشاء حساب") + Back / Cancel affordance.
- **Back Pattern:** RTL Back arrow returning to interrupted screen (e.g., Property Detail with selected dates preserved).
- **Close Pattern:** Cancel text or X if treated as interrupting flow, returning cleanly.
- **Temp Layer Type:** NONE (Full-screen sequential route flow: `08 → 09 → 10`).
- **Sticky Action?:** Form submit action ("إرسال رمز التحقق" / "تأكيد").
- **Safe Area Pattern:** Standard full-page safe areas; keyboard-aware resize avoiding button clipping.
- **Context Preservation:** Continuation intent and auth-origin context are preserved via contract.
- **Authority Class:** `CANONICAL_ARCHITECTURE` / `APPROVED_PRODUCT_UX`
- **Disposition:** `CHANGE` (Enforce full-screen sequential route flow per Auth V2 lock).

---

### Pattern 5: Owner Action-First Home (Operational Hub)
- **Role:** Owner
- **Screen Family:** `TOP_LEVEL_OWNER`
- **Current Entry:** App launch / returning to root.
- **Current Exit:** Select an operational card/item to navigate into nested queue or domain.
- **Persistent Nav Present?:** **NO bottom navigation.** Canonical mobile architecture prohibits Customer-style bottom nav.
- **Header Pattern:** Operational App Bar: Owner identity / property context + Status pill + Actionable notification/dispute indicator.
- **Action-Priority Banner:** Displays urgent pending operational items (e.g. "طلب حجز جديد بانتظار ردك"); strictly omits unapproved SLAs (e.g. 4-hour countdowns).
- **Domain Access Path:** 3-column operational domain grid directly on Home (`الطلبات`, `الوحدات`, `المحفظة`).
  - Calendar / Availability: nested from Property operations / Property Detail.
  - Messages: booking-contextual (entered from eligible booking context when product policy allows; eligibility OPEN).
  - Profile & Notifications: entered from top app bar affordances.
  - Disputes: contextual support/operational destination; presentation details deferred.
- **Back Pattern:** NONE (top-level hub).
- **Close Pattern:** NONE.
- **Temp Layer Type:** NONE.
- **Sticky Action?:** NONE.
- **Safe Area Pattern:** Standard top safe area for header; bottom safe area padded at scroll end.
- **Context Preservation:** Revalidates upon focus with out-of-order response guard.
- **Authority Class:** `CANONICAL_ARCHITECTURE`
- **Disposition:** `CHANGE` (Eliminate bottom navigation; adopt action-first hub with discoverable domain entries).

---

### Pattern 6: Owner Nested Operational Queue & Detail (Bookings Queue → Booking Detail)
- **Role:** Owner
- **Screen Family:** `NESTED_OWNER`
- **Current Entry:** Tap "الطلبات" (Bookings Queue) from Home domain grid or action banner.
- **Current Exit:** RTL Back arrow to Home or parent queue.
- **Persistent Nav Present?:** NO.
- **Header Pattern:** Nested Operational Header: RTL Back button + Queue/Entity title ("تفاصيل الطلب #1048") + Contextual status badge.
- **Back Pattern:** RTL Back arrow (pointing rightward) returning to Home with exact queue position preserved.
- **Close Pattern:** NONE.
- **Temp Layer Type:** NONE.
- **Sticky Action?:** In Booking Detail: Sticky operational decision bar ("قبول الطلب" Primary Stable Black / "رفض الطلب" Secondary Destructive Outline).
- **Safe Area Pattern:** Header respects top platform inset; sticky actions respect bottom safe area with content clearance.
- **Context Preservation:** Approving/rejecting updates server state and refreshes queue; returning without action preserves list position.
- **Authority Class:** `CANONICAL_ARCHITECTURE` / `APPROVED_PRODUCT_UX`
- **Disposition:** `PRESERVE` & `FORMALIZE`

---

### Pattern 7: Consequential Confirmation Dialog (Owner Booking Rejection)
- **Role:** Owner
- **Screen Family:** `HIGH_STAKES_CONFIRMATION`
- **Current Entry:** Tapping "رفض الطلب" on Booking Detail.
- **Current Exit:** Confirm button (proceeds) or Cancel button ("تراجع") / backdrop tap (dismisses safely).
- **Persistent Nav Present?:** Covered by modal backdrop.
- **Header Pattern:** Dialog title stating the explicit consequence: "هل أنت متأكد من رفض طلب الحجز؟"
- **Body Text:** Grounded strictly in supported consequence: "سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون." (Strictly omits unapproved claims regarding availability reopening, rankings, response deadlines, SLAs, or penalties).
- **Rejection Reason:** Reason capture is `OPTIONAL / PRODUCT-CONTRACT DEPENDENT` (backend `POST /owner/bookings/:id/reject` does not require reason payload).
- **Back Pattern:** NONE.
- **Close Pattern:** Explicit "تراجع" (Cancel) button.
- **Temp Layer Type:** `DIALOG` (centered modal surface, 12px provisional radius, elevated over dimmed scrim).
- **Sticky Action?:** Pair of actions: Safe/Dismiss action ("تراجع") + Explicit Consequential action ("تأكيد رفض الطلب").
- **Authority Class:** `APPROVED_PRODUCT_UX`
- **Disposition:** `PRESERVE` & `HARDEN`

---

### Pattern 8: Admin Operational Table Boundary
- **Role:** Admin
- **Screen Family:** `ADMIN_DESKTOP_WORKSPACE`
- **Current Entry:** Desktop browser URL / navigation bar.
- **Current Exit:** Sidebar / horizontal nav bar links.
- **Persistent Nav Present?:** Desktop top/sidebar navigation. **NO mobile bottom navigation.**
- **Header Pattern:** Desktop operational header with queue switcher, search, filters, and admin session indicator.
- **Back Pattern:** "العودة إلى قائمة المراجعة" (Back to Queue) breadcrumb link above review panels.
- **Close Pattern:** Modal close buttons where operational inspection popups are used.
- **Temp Layer Type:** Desktop modals / slide-overs for detail audit.
- **Sticky Action?:** Sticky audit decision bars on wide desktop viewports.
- **Authority Class:** `CANONICAL_ARCHITECTURE`
- **Disposition:** `PRESERVE`

---

## 4. Hierarchy & Navigation Layer Taxonomy

```
┌──────────────────────────────────────────────────────────┐
│ LAYER 1: TOP-LEVEL DESTINATION (Full Page)               │
│ - Customer: Explore, Favorites, Bookings, Account (4 tabs)│
│ - Owner: Action-First Home Hub (No bottom nav)           │
│ - Admin: Desktop Operations Workspace                    │
├──────────────────────────────────────────────────────────┤
│ LAYER 2: NESTED ENTITY / FLOW (Full Page)                │
│ - Customer: Property Detail, Booking Request Review (07), │
│   Booking Detail, Stay Hub                                │
│ - Owner: Bookings Queue, Property Ops, Payouts, Calendar  │
│ - Auth V2: Sequential Full-Screen Route Flow (08→09→10)  │
├──────────────────────────────────────────────────────────┤
│ LAYER 3: TEMPORARY CONTEXTUAL LAYER (Bottom Sheet)       │
│ - Short contextual tasks, search/refine filters, pickers  │
│ - Explicit dismiss control required; drag handle optional│
│ - Preserves underlying viewport context                  │
├──────────────────────────────────────────────────────────┤
│ LAYER 4: HIGH-STAKES CONFIRMATION (Dialog)               │
│ - Consequential decisions, destructive confirmations     │
│ - Centered overlay with explicit verbal consequence       │
├──────────────────────────────────────────────────────────┤
│ LAYER 5: INLINE SECONDARY DETAIL                         │
│ - Accordions, expandable rows within current entity      │
└──────────────────────────────────────────────────────────┘
```

### Governing Rule on Back vs Close
- **BACK (Arrow pointing Right in RTL [➔]):** Reserved strictly for hierarchical return through a navigation stack (e.g., Property Detail → Explore, Booking Detail → Bookings Queue). Never use an X to navigate backward.
- **CLOSE (X icon or Cancel text):** Reserved strictly for dismissing a temporary overlay layer (Bottom Sheet or Dialog) without mutating the underlying navigation hierarchy. Never use a Back arrow merely to dismiss a temporary contextual sheet.

### Governing Rule on Sticky Actions vs Bottom Navigation
- **Dual Bottom Chrome is PROHIBITED:** A screen must never display both a persistent Bottom Navigation bar and a persistent Sticky Decision Bar simultaneously.
- When navigating into a nested transactional screen (such as Customer Property Detail or Owner Booking Detail), the top-level Bottom Navigation is **HIDDEN / REPLACED** by the contextual Sticky Action Surface, with a clear RTL Back affordance in the app bar to return to the parent.
