# Tabs, SegmentedControl, BottomNavigation and Header

- **Tabs:** switch peer views; active state uses `brand.primary`/selected surface, visible focus and an accessible relationship to the panel.
- **SegmentedControl:** compact mutually exclusive filter or mode control; selected state has text and surface/border distinction.
- **BottomNavigation:** Customer/Owner mobile navigation only; existing app icon plus label; 48px touch targets and safe-bottom space. Customer navigation features exactly 4 top-level tabs: استكشف (`Compass`), المفضلة (`Heart`), حجوزاتي (`CalendarDays`), and الحساب (`UserRound`). All tab icons use a unified `strokeWidth={2.2}`. Active state is rendered strictly as Blue icon + Blue label (`#0059FF`) with no background bubble, pill, circle, or surface fill. Inactive state is slate-400.
- **Header:** light `surface.primary` or canvas-adjacent surface, page context, limited actions, and no standard dark/navy app-header variant. On Customer Screen 03 Explore, the header combines the standalone KONFRM mark (32px, `alt="KONFRM"`) with exactly one control-radius account/identity affordance using canonical radius.control (12px / rounded-xl equivalent) across open space:
  - **Guest Explore:** `UserRoundPlus` icon button (44px touch target, 40px `rounded-xl` visual surface, `aria-label="تسجيل الدخول أو إنشاء حساب"`, opens existing auth modal; closing auth leaves Explore naturally available). No PhoneCall or text Login CTA on Explore.
  - **Authenticated Explore:** Truthful identity affordance routing to Account (`setActiveTab('ACCOUNT')`). Sized at 44px outer touch target with a 40px `rounded-xl` visual surface, rendering in priority order: canonical `avatarUrl` (12px / rounded-xl, with graceful fallback on load error) → initials (12px / rounded-xl neutral slate surface, only from non-empty canonical `fullName`) → `UserRound` (12px / rounded-xl).
  - **Notifications:** no Bell icon in the Explore header. Customer Notification Center is a separate Account-origin destination; its existence does not add notification chrome to Explore.
  *(Supersedes the interim brand-only header model while preserving browse-first ethos).*

Use an appropriate control rather than inventing a screen-specific filter or navigation pattern. Directional icons follow RTL behaviour.

## Navigation grammar

Use a full page for a meaningful destination or full entity; a BottomSheet for a short contextual task; a Dialog for short confirmation/high-stakes acknowledgement; and inline expansion for secondary detail that belongs to the current entity.

Back represents hierarchy. Close/X dismisses a temporary layer.

## Screen-family consistency

Header and navigation grammar is shared **within the same screen role/family**, not copied blindly across unrelated flows. Auth, top-level destinations, nested entity/utility screens, transactional screens and terminal-result screens may differ from one another, but equivalent screens must not accumulate one-off logo, Back, title, sticky-header or action placement rules because they were built in different phases. A family-level change must be reviewed and applied coherently rather than patching one screen in isolation.

Customer top-level navigation remains Explore / Favorites / Bookings / Account unless a newer Founder decision changes it. Contextual capabilities such as booking chat do not automatically deserve a permanent bottom-navigation tab.
