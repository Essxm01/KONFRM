# Navigation & App Bar Contracts

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Structural Invariants:**
  - Customer Navigation: Exactly 4 persistent root destinations (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`).
  - Screen 16 Governed Exception (`MR-17`): Notification Center is an `ACCOUNT_SHELL_CHILD_EXCEPTION` where Bottom Navigation remains **VISIBLE** and the Account tab remains **ACTIVE**.
  - Owner Navigation: Action-First Operational Hub with nested stack routing. **Customer-style bottom navigation is PROHIBITED BY CANONICAL MOBILE ARCHITECTURE.**
  - Dual Bottom Chrome Prohibition: Bottom navigation and sticky action surfaces must **NEVER** coexist on the same screen.
  - Header Families: Exactly 7 governed app bar screen configurations.
- **Open Parameters:** Exact blue accent hex (`OPEN / CANDIDATE #276EF1`), shadow elevation parameters (`OPEN`), and physical touch target sizing in native mobile (`DEFERRED_TO_4I`). iOS ~44pt / Android ~48dp guidance.

---

## 2. Component Taxonomy & Subcontracts

| Subcontract | Role & Purpose | Target Surface & Governance |
|---|---|---|
| `CustomerBottomNavigation` | Root destination switching for Customer | Exactly 4 tabs: Explore, Favorites, Bookings, Account. Hidden on nested screens except Screen 16. |
| `OwnerOperationalHub` | Action-first operational entry for Owner | 3-column domain grid on Home (`الطلبات`, `الوحدات`, `المحفظة`). No bottom nav. |
| `AppBar` | Screen header with context and navigation | 7 governed configurations across Customer, Owner, Admin. |
| `StickyActionSurface` | Transactional bottom decision bar | Bottom-anchored surface with safe clearance. Never coexists with Bottom Navigation. |
| `NavigationGrammar` | Stack return and overlay dismiss semantics | Back (➔) vs Close (X) strict distinction; context restoration contract. |

---

## 3. Subcontract Details

### 3.1 CustomerBottomNavigation
- **Root Tabs:**
  1. `استكشف` (Explore, `Compass` icon)
  2. `المفضلة` (Favorites, `Heart` icon)
  3. `حجوزاتي` (Bookings, `CalendarDays` icon)
  4. `الحساب` (Account, `UserRound` icon)
- **Active State:** Restrained interaction-accent role (candidate `#276EF1`). Label in `11px font-bold text-blue-600`.
- **Inactive State:** Neutral slate (`#64748B`). Label in `11px font-medium text-slate-500`.
- **Visibility Logic:**
  - Visible on top-level tabs.
  - Hidden on nested browsing, transactional review (Screen 07), and full-screen flows (Auth V2).
  - **Screen 16 Exception:** Visible on Notification Center; Account tab remains highlighted.

### 3.2 OwnerOperationalHub
- **Architecture:** Zero bottom navigation. Operates as an Action-First Operational Hub with dashboard-style nested stack routing.
- **Home Surface:**
  - High-contrast 3-column domain grid (`الطلبات`, `الوحدات`, `المحفظة`) for direct operational triage.
  - Contextual access paths: Calendar (nested under Property operations), Messages (booking-contextual), Profile/Notifications (app bar affordances).
  - Prohibits hidden hamburger menus.

### 3.3 AppBar (7 Governed Screen Configurations)
1. `TOP_LEVEL_CUSTOMER`: Standalone KONFRM mark (32px, `alt="KONFRM"`) + single account/identity affordance on Explore:
   - Guest: `UserRoundPlus` icon button (44px target, routes to Auth V2).
   - Authenticated: Avatar / initials / `UserRound` routing to Account.
   - Notifications: Zero Bell icon on Explore; Notification Center is inside Account.
2. `NESTED_CUSTOMER`: Contextual header for browsing detail: RTL Back button (arrow pointing right [➔]) + Page title + optional actions (Share, Favorite).
3. `NESTED_TRANSACTIONAL_CUSTOMER`: Review header (Screen 07): RTL Back button (➔) + Review title ("مراجعة طلب الحجز"). Bottom nav hidden; sticky submission CTA at bottom.
4. `AUTH_FULL_SCREEN_HEADER`: Flow header for Auth V2 (`08 → 09 → 10`): Brand mark / step indicator + Back arrow / Cancel text.
5. `TOP_LEVEL_OWNER`: Operational hub header: Owner identity + verification pill + operational alert affordance.
6. `NESTED_OWNER`: Stack header for operational queues and entities: RTL Back button (➔) + Queue/Entity title + status badge.
7. `TEMPORARY_LAYER_HEADER`: Contextual overlay header: Sheet title + Close X; centered Dialog title.

### 3.4 StickyActionSurface
- **Role:** Anchored bottom surface for irreversible or contractual user decisions (e.g. "إرسال طلب الحجز", "قبول الطلب").
- **Clearance:** Scrollable page content reserves bottom clearance padding (`pb-24` or equivalent) to prevent content occlusion.
- **Mutual Exclusion:** Persistent bottom navigation and persistent sticky decision bars must **NEVER** coexist on the same screen simultaneously.

---

## 4. State Matrix

| State | Customer Bottom Nav | Owner Operational Hub | AppBar Actions |
|---|---|---|---|
| `IDLE / ROOT` | Visible (4 tabs); active tab highlighted. | High-contrast 3-column grid active. | Root branding / profile affordance. |
| `NESTED` | Hidden (except Screen 16 Account shell). | Stack navigation; Back button active. | Back button (➔) + contextual title. |
| `INTERACTING / SCROLL` | Anchored at bottom; elevation separates from feed. | Hub scrolls naturally with page. | Elevated app bar with subtle border. |
| `OVERLAY_ACTIVE` | Scrim covers bottom chrome. | Scrim covers operational surfaces. | Overlay header replaces screen app bar. |

---

## 5. Role Differences

- **Customer:** Tab-based exploration with 4 root destinations and deep detail nesting.
- **Owner:** Action-First Operational Hub with domain cards and nested stack queues; zero bottom navigation.
- **Admin:** Desktop web sidebar / topbar navigation (`CONTROLLED_WEB_BOUNDARY_REFERENCE`). Zero mobile bottom navigation.

---

## 6. RTL & Bidirectional Layout Rules

- **Back Arrow Direction:** In RTL, the Back affordance points **RIGHT** (`➔`), returning the user backward up the chronological stack.
- **Chevrons in ListRows:** Forward navigation chevrons point **LEFT** (`←`), indicating forward depth into a child screen.
- **Title Alignment:** App bar titles align start (Right) or center depending on platform conventions.
- **Action Icons:** Leading affordance (Back button) on the right; trailing affordances (Share, Favorite, Close X) on the left.

---

## 7. Accessibility & Touch Discipline

- **Touch Targets:** Minimum **44 × 44 pt** (iOS) / **48 × 48 dp** (Android) for all tab items, back buttons, and header actions.
- **Screen Reader Roles:** Bottom navigation uses `<nav aria-label="التنقل الرئيسي">` with `aria-current="page"` on the active tab.
- **Keyboard Navigation:** Left/Right arrow keys navigate tabs; Enter/Space activates.

---

## 8. Composition Invariants & Anti-Patterns

1. **Dual Bottom Chrome Prohibition:** Bottom navigation and sticky decision bars must never coexist.
2. **Back vs Close Distinction:** Back (➔) for hierarchical return; Close (X) for dismissing temporary overlays. Never mix them.
3. **No Bottom Nav for Owner:** Owner application must never implement Customer-style bottom tab navigation.
