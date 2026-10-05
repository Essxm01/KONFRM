# Navigation authority

Navigation follows destination frequency and user job—not visual symmetry. `UX-NAV-01` is approved: Customer, Owner and Admin do not need identical navigation, tab counts, headers or information density. They remain one KONFRM family through the central Design System, while each role’s navigation serves its frequent jobs.

---

## Role Navigation Matrix

| Role | Current Web Prototype Authority | Future Mobile Phase 4F Authority (Formalized) |
|---|---|---|
| **Customer** | Bottom navigation: Explore, Favorites, Bookings, Account; property/booking/auth/support/wallet are contextual modal or full-screen flows. | **4 Root Destinations:** Explore, Favorites, Bookings, Account. Bottom nav visible **STRICTLY** on these 4 roots; **HIDDEN** on nested screens (Property Detail, Booking Detail, Screen 07 Booking Request Review, Auth V2). Sticky actions replace bottom nav on nested screens. Dual bottom chrome is **PROHIBITED**. |
| **Owner** | *Web Behavioral Evidence Only:* Legacy React web prototype includes bottom navigation (Home, Bookings, Wallet, Properties, Messages). | **Action-First Operational Hub:** **NO CUSTOMER-STYLE BOTTOM NAVIGATION.** Stack routing from Home hub. Frequent operations accessed via 3-column domain grid on Home (`الطلبات`, `الوحدات`, `المحفظة`). Calendar nested from Property ops; Messages booking-contextual (eligibility OPEN); Profile/Notifications via header affordances; Disputes contextual (presentation deferred). |
| **Admin** | Desktop horizontal operations navigation: Overview, Verification, Properties, Payouts, Disputes; detail views contextual. | **Desktop Operational Workspace Preserved:** Horizontal/sidebar operations navigation, data tables, and split review panels. Zero mobile bottom navigation, sheets, or mobile touch target contamination. |

---

## Core Architectural Rules

1. **Back vs Close Semantic Distinction:**
   - **BACK (Arrow pointing Right in RTL [➔]):** Hierarchical return up a navigation stack. Never use an X to navigate backward.
   - **CLOSE (X icon or Cancel text):** Dismisses a temporary overlay layer (Bottom Sheet or Dialog) without mutating underlying stack. Never use a Back arrow merely to dismiss a temporary sheet.
2. **Dual Bottom Chrome Prohibition:**
   - Persistent bottom navigation and persistent sticky decision bars must **NEVER** coexist simultaneously on the same screen.
   - On nested screens requiring sticky action, the bottom navigation is hidden, reserving clearance padding for the sticky action + platform safe area.
3. **Dedicated Transactional Review (Screen 07):**
   - Booking Request Review is a dedicated full-screen transactional review component (`FULL_PAGE_NESTED / DEDICATED_FULL_SCREEN_TRANSACTIONAL_REVIEW`, implementing C4_FINAL_DESIGN_SPEC).
   - Bottom navigation is hidden; return path is RTL Back (➔) to Property Detail. Screen 07 is **never a BottomSheet**.
4. **Context Restoration Contract:**
   - Every contextual view has a defined return path. Returning from detail or filter sheet preserves active search/explore state. Auth interruption preserves continuation intent.
   - Physical runtime state persistence is deferred to native Flutter Phase 4I (`DEFERRED_TO_4I`).
