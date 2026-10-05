# Phase 4F Route / Surface Matrix

**Status:** `SYSTEM_EVALUATED_MATRIX`
**Phase:** `PHASE_4F_NAVIGATION_OVERLAY_SYSTEM`
**Scope:** Customer Mobile, Owner Mobile, Admin Desktop Boundary
**Data Status:** `LAB_SCENARIO_DATA`
*(Route matrices and identifiers reflect layout and navigation presentation architecture; `LAB_SCENARIO_DATA ≠ production evidence`).*

---

## 1. Matrix Classification System

Every route/destination in KONFRM is classified by:
1. **Capability Status:**
   - **`CURRENT_GOVERNED_CAPABILITY`**: Active, evidenced, or governed product capability with established backend/frontend scope.
   - **`FUTURE_ROADMAP_CAPABILITY`**: Recognized product capability in roadmap whose detailed product policy is deferred (e.g. general renter cancellation matrix, independent chat inbox).
2. **Presentation Modality:**
   - **`TOP_LEVEL`**: Persistent top-level shell destination with direct primary access (Customer 4-tab shell; Owner Action-First Home Hub).
   - **`FULL_PAGE_NESTED`**: Dedicated full-screen destination in the navigation hierarchy; owns its app bar, scroll container, and return path; hides top-level bottom nav.
   - **`BOTTOM_SHEET`**: Short, temporary contextual layer anchored to the viewport bottom; retains underlying visual context; dismissible via explicit close or gesture.
   - **`DIALOG`**: Centered modal overlay for short, high-consequence confirmation or high-stakes acknowledgement.
   - **`INLINE`**: Expandable or progressive disclosure section embedded inside the current screen without layer escalation.
   - **`DEFERRED_PRODUCT_POLICY`**: Product policy and presentation deferred to its governing roadmap phase.

---

## 2. Customer Application Route Matrix

| Route / Destination | Arabic Identifier | Capability Status | Presentation Modality | Header / App Bar Type | Navigation Chrome Visibility | Return Path (Back vs Close) | Sticky Action Surface? | Notes & Constraints |
|---|---|---|---|---|---|---|---|---|
| **Explore** | استكشف | `CURRENT_GOVERNED_CAPABILITY` | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Brand mark + Account affordance) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Primary discovery feed; no Bell icon in header. |
| **Favorites** | المفضلة | `CURRENT_GOVERNED_CAPABILITY` | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Semantic title: المفضلة) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Persistent 2nd tab; fail-closed on 401/403. |
| **My Bookings** | حجوزاتي | `CURRENT_GOVERNED_CAPABILITY` | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Semantic title: حجوزاتي) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Persistent 3rd tab; shows attention badge if action required. |
| **Account** | الحساب | `CURRENT_GOVERNED_CAPABILITY` | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Semantic title: الحساب) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Persistent 4th tab; hub for personal profile, notifications, settings. |
| **Property Detail** | تفاصيل الوحدة | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Context actions) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Explore / Results | **YES** (Sticky Price + Request CTA) | Bottom nav hidden to eliminate dual bottom chrome collision. CTA: "طلب الحجز" (never "تأكيد"). |
| **Booking Detail / Stay Hub** | تفاصيل الحجز | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Status badge) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → My Bookings | Contextual sticky action if pending action exists | Full view of reservation status, dates, financial breakdown, instructions. |
| **Booking Request Review (Screen 07)** | مراجعة طلب الحجز | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_TRANSACTIONAL_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Property Detail | **YES** (Primary "إرسال طلب الحجز للمالك") | Dedicated full-screen review component implementing C4_FINAL_DESIGN_SPEC. Auth interception returns cleanly to review context. Never a BottomSheet. |
| **Auth V2 (08 Phone Entry)** | تسجيل الدخول / إنشاء حساب | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `AUTH_FULL_SCREEN_HEADER` (Brand mark + Back/Cancel) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Interrupted context | Form Submit CTA | **MANDATORY FULL-SCREEN FLOW** (Screens 08→09→10); web modal superseded. |
| **Auth V2 (09 OTP Verification)** | تأكيد رمز التحقق | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `AUTH_FULL_SCREEN_HEADER` (Title + Back) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Screen 08 | Form Verify CTA | Sequential step; 6-digit OTP entry, countdown timer. |
| **Auth V2 (10 Name / Completion)** | إكمال بيانات الحساب | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `AUTH_FULL_SCREEN_HEADER` (Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Screen 09 | Form Complete CTA | First-time registration completion with continuation intent. |
| **Search / Refine Filters** | تصفية البحث | `CURRENT_GOVERNED_CAPABILITY` | `BOTTOM_SHEET` | `TEMPORARY_LAYER_HEADER` (Title + Close X) | 4-Tab Bottom Nav: **COVERED** | **CLOSE (X icon)** | **YES** (Sticky "عرض الوحدات") | Short contextual task over Explore/Search results; preserves criteria. |
| **Notification Center** | مركز الإشعارات | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Account | NO | Accessed via Account hub (NOT Explore header). |
| **Support / Help** | الدعم والمساعدة | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Parent context | NO | Contact channels, FAQ; full page rather than cramped modal. |
| **Wallet / Credit View** | رصيد الحساب | `FUTURE_ROADMAP_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Account | NO | Roadmap customer credit view accessed contextually via Account. |
| **Booking Cancellation** | إلغاء الحجز | `FUTURE_ROADMAP_CAPABILITY` | `DEFERRED_PRODUCT_POLICY` | — | — | — | — | **DEFERRED.** Wider renter cancellation/refund policy is OPEN per `BUSINESS_RULES.md`; no general customer cancellation CTA established for Stay Hub in Phase 4F. |

---

## 3. Owner Application Route Matrix

| Route / Destination | Arabic Identifier | Capability Status | Presentation Modality | Header / App Bar Type | Navigation Chrome Visibility | Return Path (Back vs Close) | Sticky Action Surface? | Notes & Access Path |
|---|---|---|---|---|---|---|---|---|
| **Owner Home (Action Hub)** | لوحة التحكم | `CURRENT_GOVERNED_CAPABILITY` | `TOP_LEVEL` | `TOP_LEVEL_OWNER` (Identity + Status + Alerts) | Bottom Nav: **NONE (Prohibited)** | None (Root destination) | NO | Action-first operational hub: pending booking actions, upcoming stays, quick 3-column domain grid. |
| **Bookings Queue** | الطلبات والحجوزات | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Filter tabs) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | NO | Entered directly from Home hub domain grid or action banner. |
| **Booking Detail** | تفاصيل الطلب | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Status) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Bookings Queue | **YES** (Sticky Decision Bar: Accept/Reject) | Consequential decision surface; guest info, dates, payout quote. |
| **Properties Hub** | إدارة الوحدات | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Add CTA) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Optional Top/Floating Add CTA | Entered directly from Home hub domain grid. Unit inventory list. |
| **Property Detail** | تفاصيل الوحدة | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Edit CTA) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Properties Hub | Sticky Operations CTA | Unit overview, pricing, settings, linked calendar shortcut. |
| **Add / Edit Property Wizard** | إضافة / تعديل وحدة | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Step Progress) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Cancel/Save draft | **YES** (Sticky Next/Save step action) | Multi-step wizard; strictly full-page nested flow (never a sheet). |
| **Calendar / Availability** | التقويم والتوفر | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Month switcher) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Property Detail / Hub | Contextual save/block action | Entered contextually from Property operations / Property Detail. |
| **Wallet / Payout Hub** | المحفظة والأرباح | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Balance) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Contextual Payout Request CTA | Entered directly from Home hub domain grid. Plain money language. |
| **Messages / Guest Chat** | المحادثات | `FUTURE_ROADMAP_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Booking / Parent | Contextual message composer | Contextual from eligible booking context when product policy allows (`CHAT_CONTEXT: BOOKING_CONTEXTUAL`, `CHAT_ELIGIBILITY: OPEN / DEFERRED_TO_PHASE_12_PRODUCT_POLICY`). No persistent top-level slot. |
| **Profile & Settings** | الملف الشخصي | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Form Save CTA | Accessed via identity/account affordance in top app bar. |
| **Notifications** | الإشعارات | `CURRENT_GOVERNED_CAPABILITY` | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | NO | Accessed via operational notification affordance in top app bar. |
| **Disputes** | النزاعات | `FUTURE_ROADMAP_CAPABILITY` | `DEFERRED_TO_PHASE_13_PRODUCT_POLICY` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Workflow presentation deferred | Contextual support/operational destination (`NAVIGATION_ALLOCATION: NO_PERSISTENT_TOP_LEVEL_SLOT`). Presentation and policy deferred to Phase 13. |
| **Reject Booking Confirmation** | تأكيد رفض الطلب | `CURRENT_GOVERNED_CAPABILITY` | `DIALOG` | Centered Dialog Title | Bottom Nav: **NONE** | **CLOSE (تراجع button / X)** | Pair: Dismiss + Consequential Destructive | Consequence: "سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون." Rejection reason capture is `OPTIONAL / PRODUCT-CONTRACT DEPENDENT`. |

---

## 4. Admin Boundary Route Matrix (Desktop Web Only)

| Route / Destination | Modality | Layout Surface | Navigation Structure | Return Path | Notes |
|---|---|---|---|---|---|
| **Overview** | `TOP_LEVEL` | 1440px Desktop Grid | Persistent Top/Sidebar Navigation | Root | Operational metrics, queue dispatch. |
| **Verification Queue** | `TOP_LEVEL` | 1440px Table / Queue | Persistent Top/Sidebar Navigation | Root | KYC submissions awaiting review. |
| **Verification Detail** | `FULL_PAGE_NESTED` | 1440px Split Audit Panel | Sidebar intact | Breadcrumb: "العودة لقائمة التوثيق" | Side-by-side National ID inspect + decision. |
| **Property Queue** | `TOP_LEVEL` | 1440px Table / Queue | Persistent Top/Sidebar Navigation | Root | Unit submissions awaiting approval. |
| **Property Detail** | `FULL_PAGE_NESTED` | 1440px Split Audit Panel | Sidebar intact | Breadcrumb: "العودة لقائمة الوحدات" | Unit photos, amenities, safety audit. |
| **Payouts Queue** | `TOP_LEVEL` | 1440px Table / Queue | Persistent Top/Sidebar Navigation | Root | Eligible payout batches. |
| **Disputes Queue** | `TOP_LEVEL` | 1440px Table / Queue | Persistent Top/Sidebar Navigation | Root | Active claim investigations. |

**Admin Hard Gate:** Admin desktop remains isolated from mobile bottom navigation, sheets, and touch targets.

---

## 5. Architectural Rule Summary

1. **Top-Level Isolation:** Exactly 4 destinations on Customer (`EXPLORE`, `FAVORITES`, `BOOKINGS`, `ACCOUNT`). Exactly 1 root hub on Owner (`ACTION_FIRST_HOME_HUB`).
2. **Bottom Nav Mutual Exclusivity:** Bottom navigation is shown **ONLY** on Customer top-level destinations. On any nested entity or transactional flow, bottom navigation is hidden.
3. **Modal Discipline:** Sheets are strictly for short contextual tasks (<85% reference height in web pilot, dismissible); Dialogs are strictly for consequential high-stakes decisions; all entity viewing and multi-screen workflows are full-page nested routes.
4. **Owner Discoverability Without Hamburger:** Frequent operations (Bookings, Properties, Wallet) are accessed via Home hub 3-column domain grid; Calendar is nested from Property operations; Profile and Notifications are accessed via top app bar affordances; Messages (booking-contextual; eligibility OPEN) and Disputes (contextual; presentation deferred) do not possess permanent top-level chrome.
