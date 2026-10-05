# Tabs, SegmentedControl, BottomNavigation and Header

- **Tabs:** switch peer views; active state uses `brand.primary`/selected surface, visible focus and an accessible relationship to the panel.
- **SegmentedControl:** compact mutually exclusive filter or mode control; selected state has text and surface/border distinction.

---

## BottomNavigation Architecture & Authority

### Current Web Authority (Prototype Evidence)
- **Web Status:** `WEB_BEHAVIORAL_EVIDENCE_ONLY`.
- In the legacy React web prototype, Customer and Owner both physically contain a bottom navigation bar.
- Tab icons use a unified `strokeWidth={2.2}`. Legacy active state was rendered as Blue icon + Blue label (`#0059FF`) with slate-400 inactive state.
- This historical web implementation is preserved for web prototype continuity but **must NOT** be treated as canonical native mobile authority.

### Future Mobile Authority (Phase 4F Formalization)
- **Customer Mobile Navigation:**
  - Exactly four persistent root destinations: `استكشف` (Explore, `Compass`), `المفضلة` (Favorites, `Heart`), `حجوزاتي` (Bookings, `CalendarDays`), and `الحساب` (Account, `UserRound`).
  - Bottom navigation is visible **by default on these four top-level roots**.
  - On nested screens (Property Detail, Booking Detail, Screen 07 Booking Request Review, deep workflows, or Auth V2), bottom navigation is **hidden by default**.
  - **Screen 16 Governed Exception (Master Rule MR-17):** Notification Center (Screen 16) is a governed `ACCOUNT_SHELL_CHILD_EXCEPTION` where Bottom Navigation remains **VISIBLE** and the Account tab remains **ACTIVE**.
  - Active tab uses the **restrained interaction-accent semantic role** (pilot candidate `#276EF1`; exact blue remains **`OPEN`**). Inactive state uses neutral slate.
- **Owner Mobile Navigation:**
  - Operates as an **Action-First Operational Hub** with dashboard-style nested stack routing.
  - **Customer-style bottom navigation is PROHIBITED BY CANONICAL MOBILE ARCHITECTURE.**
  - Frequent operations are directly discoverable on Home via a high-contrast 3-column domain grid (`الطلبات`, `الوحدات`, `المحفظة`).
  - Contextual access paths are governed for other recognized destinations: Calendar (nested from Property operations), Messages (booking-contextual; eligibility OPEN), Profile/Notifications (top app bar affordances), and Disputes (contextual; presentation deferred).
  - Zero hidden hamburger dumping ground.
- **Dual Bottom Chrome Prohibition:**
  - Persistent bottom navigation and persistent sticky decision bars must **NEVER** coexist on the same screen simultaneously.
  - When navigating into a nested transactional screen requiring sticky action, the bottom navigation is hidden, and the sticky bar occupies the bottom area with reserved content clearance.
- **Touch Target & Sizing Guidance:**
  - Platform-appropriate guidance: iOS ~44pt, Android ~48dp.
  - Physical mobile acceptance is **`DEFERRED_TO_4I`**.

---

## Header & App Bar Screen Families

Light `surface.primary` or canvas-adjacent surface, page context, limited actions, and no standard dark/navy app-header variant.

Header and navigation grammar is governed by **screen families**, not a single universal header:

1. **`TOP_LEVEL_CUSTOMER`:**
   - Standalone KONFRM mark (32px, `alt="KONFRM"`) + single account/identity affordance on Explore:
     - *Guest Explore:* `UserRoundPlus` icon button (44px touch target, 40px `rounded-xl` visual surface, `aria-label="تسجيل الدخول أو إنشاء حساب"`, routes to Auth V2).
     - *Authenticated Explore:* Truthful identity affordance routing to Account (`avatarUrl` → initials → `UserRound`).
     - *Notifications:* No Bell icon in Explore header; Notification Center is accessed via Account.
   - Other root tabs (Favorites, Bookings, Account) display semantic page title; zero Bell icon.
2. **`NESTED_CUSTOMER`:**
   - Contextual header for browsing detail: RTL Back button (arrow pointing right [➔]) + Page title + optional contextual actions (Share, Favorite).
3. **`NESTED_TRANSACTIONAL_CUSTOMER`:**
   - Header for dedicated transactional review (Screen 07 Booking Request Review): RTL Back button (➔) + Review title ("مراجعة طلب الحجز"). Bottom nav hidden; sticky submission CTA at bottom.
4. **`AUTH_FULL_SCREEN_HEADER`:**
   - Minimal flow header for Auth V2 (`08 → 09 → 10`): Brand mark / step indicator + Back arrow / Cancel text.
5. **`TOP_LEVEL_OWNER`:**
   - Operational hub header: Owner identity + verification pill + operational alert affordance.
6. **`NESTED_OWNER`:**
   - Stack header for operational queues and entities: RTL Back button (➔) + Queue/Entity title + status badge.
7. **`TEMPORARY_LAYER_HEADER`:**
   - Header for contextual overlays: Sheet title + Close X; centered Dialog title.

---

## Navigation Grammar & Return Paths

1. **Back vs Close Semantic Distinction:**
   - **BACK (Arrow pointing Right in RTL [➔]):** Represents hierarchical return up a navigation stack (e.g. Property Detail → Explore, Booking Detail → Bookings Queue). Never use an X to navigate backward.
   - **CLOSE (X icon or Cancel text):** Represents dismissing a temporary overlay layer (Bottom Sheet or Dialog) without mutating underlying stack. Never use a Back arrow merely to dismiss a temporary sheet.
2. **Modal vs Full Page Discipline:**
   - **Full Page Nested:** Mandatory for meaningful destinations, full entity evaluation (Property Detail), dedicated transactional review (Booking Request Review Screen 07), multi-step wizards, and Auth V2 (`08 → 09 → 10`).
   - **BottomSheet:** Reserved strictly for short contextual tasks, search/refine filters, pickers, and transient confirmations. Never a full-screen navigation substitute.
   - **Dialog:** Reserved strictly for short consequential confirmation, high-stakes acknowledgement, and destructive irreversible decisions (e.g. Owner reject booking request).
   - **Inline Expansion:** Reserved for secondary details within current entity (accordions, expandable rows).
3. **Context Restoration Contract:**
   - Returning via Back from detail or sheet preserves active query, filter criteria, and scroll position.
   - Auth interruption preserves continuation intent and target context without premature submission.
   - Runtime implementation is **`DEFERRED_TO_4I`**.
