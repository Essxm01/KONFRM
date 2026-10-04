# Phase 4F Route / Surface Matrix

**Status:** `SYSTEM_EVALUATED_MATRIX`  
**Phase:** `PHASE_4F_NAVIGATION_OVERLAY_SYSTEM`  
**Scope:** Customer Mobile, Owner Mobile, Admin Desktop Boundary  

---

## 1. Matrix Classification System

Every route/destination in KONFRM is classified into exactly one primary presentation modality:

- **`TOP_LEVEL`**: Persistent top-level shell destination with direct primary access (Customer 4-tab shell; Owner Action-First Home Hub).
- **`FULL_PAGE_NESTED`**: Dedicated full-screen destination in the navigation hierarchy; owns its app bar, scroll container, and return path; hides top-level bottom nav.
- **`BOTTOM_SHEET`**: Short, temporary contextual layer anchored to the viewport bottom; retains underlying visual context; dismissible via close/swipe/action.
- **`DIALOG`**: Centered modal overlay for short, high-consequence confirmation or high-stakes acknowledgement.
- **`INLINE`**: Expandable or progressive disclosure section embedded inside the current screen without layer escalation.
- **`DEFERRED`**: Product capability recognized in roadmap but presentation modality not yet governed or deferred to a later phase.

---

## 2. Customer Application Route Matrix

| Route / Destination | Arabic Identifier | Presentation Modality | Header / App Bar Type | Navigation Chrome Visibility | Return Path (Back vs Close) | Sticky Action Surface? | Notes & Constraints |
|---|---|---|---|---|---|---|---|
| **Explore** | استكشف | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Brand mark + Account affordance) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Primary discovery feed; no Bell icon in header. |
| **Favorites** | المفضلة | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Semantic title: المفضلة) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Persistent 2nd tab; fail-closed on 401/403. |
| **My Bookings** | حجوزاتي | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Semantic title: حجوزاتي) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Persistent 3rd tab; shows attention badge if action required. |
| **Account** | الحساب | `TOP_LEVEL` | `TOP_LEVEL_CUSTOMER` (Semantic title: الحساب) | 4-Tab Bottom Nav: **VISIBLE** | None (Root destination) | NO | Persistent 4th tab; hub for personal profile, notifications, settings. |
| **Property Detail** | تفاصيل الوحدة | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Context actions) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Explore / Results | **YES** (Sticky Price + Request CTA) | Bottom nav hidden to eliminate dual bottom chrome collision. CTA: "طلب الحجز" (never "تأكيد"). |
| **Booking Detail** | تفاصيل الحجز | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Status badge) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → My Bookings | Contextual sticky action if pending action exists | Full view of reservation status, dates, financial breakdown, instructions. |
| **Booking Request Review** | مراجعة طلب الحجز | `BOTTOM_SHEET` | `TEMPORARY_LAYER_HEADER` (Title + Close X) | 4-Tab Bottom Nav: **COVERED** | **CLOSE (X icon)** | **YES** (Primary "إرسال طلب الحجز") | Short contextual sheet over Property Detail to verify dates/guests before submission. |
| **Auth V2 (08 Phone Entry)** | تسجيل الدخول / إنشاء حساب | `FULL_PAGE_NESTED` | `AUTH_FULL_SCREEN_HEADER` (Brand mark + Back/Cancel) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Interrupted context | Form Submit CTA | **MANDATORY FULL-SCREEN FLOW** (Screens 08→09→10); web modal superseded. |
| **Auth V2 (09 OTP Verification)** | تأكيد رمز التحقق | `FULL_PAGE_NESTED` | `AUTH_FULL_SCREEN_HEADER` (Title + Back) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Screen 08 | Form Verify CTA | Sequential step; 6-digit OTP entry, countdown timer. |
| **Auth V2 (10 Name / Completion)** | إكمال بيانات الحساب | `FULL_PAGE_NESTED` | `AUTH_FULL_SCREEN_HEADER` (Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Screen 09 | Form Complete CTA | First-time registration completion with continuation token. |
| **Search / Refine Filters** | تصفية البحث | `BOTTOM_SHEET` | `TEMPORARY_LAYER_HEADER` (Title + Close X) | 4-Tab Bottom Nav: **COVERED** | **CLOSE (X icon)** | **YES** (Sticky "عرض الوحدات") | Short contextual task over Explore/Search results; preserves criteria. |
| **Notification Center** | مركز الإشعارات | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Account | NO | Accessed via Account hub (NOT Explore header). |
| **Support / Help** | الدعم والمساعدة | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Parent context | NO | Contact channels, FAQ; full page rather than cramped modal. |
| **Wallet / Refund View** | رصيد الحساب | `FULL_PAGE_NESTED` | `NESTED_CUSTOMER` (RTL Back + Title) | 4-Tab Bottom Nav: **HIDDEN** | **BACK (Arrow Right)** → Account | NO | Customer balance view accessed via Account. |
| **Booking Cancellation Confirm** | تأكيد إلغاء الحجز | `DIALOG` | Centered Dialog Title | 4-Tab Bottom Nav: **COVERED** | **CLOSE (إلغاء button / X)** | Pair: Dismiss + Consequential Destructive | High-stakes decision; explicitly explains policy and consequences in words. |

---

## 3. Owner Application Route Matrix

| Route / Destination | Arabic Identifier | Presentation Modality | Header / App Bar Type | Navigation Chrome Visibility | Return Path (Back vs Close) | Sticky Action Surface? | Notes & Constraints |
|---|---|---|---|---|---|---|---|
| **Owner Home (Action Hub)** | لوحة التحكم | `TOP_LEVEL` | `TOP_LEVEL_OWNER` (Identity + Status + Alerts) | Bottom Nav: **NONE (Prohibited)** | None (Root destination) | NO | Action-first operational hub: pending booking actions, upcoming stays, quick domain entries. |
| **Bookings Queue** | الطلبات والحجوزات | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Filter tabs) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | NO | Operational queue of pending requests, confirmed stays, history. |
| **Booking Detail** | تفاصيل الطلب | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Status) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Bookings Queue | **YES** (Sticky Decision Bar: Accept/Reject) | Consequential decision surface; guest info, dates, payout quote. |
| **Properties Hub** | إدارة الوحدات | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Add CTA) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Optional Top/Floating Add CTA | Property inventory list, status cards, quick operational actions. |
| **Property Detail** | تفاصيل الوحدة | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Edit CTA) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Properties Hub | Sticky Operations CTA | Unit overview, pricing, settings, linked calendar shortcut. |
| **Add / Edit Property Wizard** | إضافة / تعديل وحدة | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Step Progress) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Cancel/Save draft | **YES** (Sticky Next/Save step action) | Multi-step wizard; strictly full-page nested flow (never a sheet). |
| **Calendar / Availability** | التقويم والتوفر | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Month switcher) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Property Detail / Hub | Contextual save/block action | Monthly view, date blocking, custom night pricing. |
| **Wallet / Payout Hub** | المحفظة والأرباح | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title + Balance) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Contextual Payout Request CTA | Available balance, pending payouts, ledger history. Plain money language. |
| **Messages / Guest Chat** | المحادثات | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Guest name) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Booking / Home | Sticky message composer | Contextual to confirmed bookings; operational communication only. |
| **Profile & Settings** | الملف الشخصي | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | Form Save CTA | Personal data, KYC status, bank account info, logout. |
| **Notifications** | الإشعارات | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | NO | System, booking, and payout alerts. |
| **Disputes** | النزاعات | `FULL_PAGE_NESTED` | `NESTED_OWNER` (RTL Back + Title) | Bottom Nav: **NONE** | **BACK (Arrow Right)** → Home Hub | File dispute CTA | Active disputes and arbitration history. |
| **Reject Booking Confirmation** | تأكيد رفض الطلب | `DIALOG` | Centered Dialog Title | Bottom Nav: **NONE** | **CLOSE (تراجع button / X)** | Pair: Dismiss + Consequential Destructive | Governed high-stakes confirmation; requires explicit reason and explains impact. |

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

1. **Top-Level Isolation:** Exactly 4 destinations on Customer (`EXPLORE`, `FAVORITES`, `BOOKINGS`, `ACCOUNT`). Exactly 1 root destination on Owner (`ACTION_FIRST_HOME_HUB`).
2. **Bottom Nav Mutual Exclusivity:** Bottom navigation is shown **ONLY** on Customer top-level destinations. On any nested entity or transactional flow, bottom navigation is hidden.
3. **Modal Discipline:** Sheets are strictly for short contextual tasks (<90% height, dismissible); Dialogs are strictly for consequential high-stakes decisions; all entity viewing and multi-screen workflows are full-page nested routes.
