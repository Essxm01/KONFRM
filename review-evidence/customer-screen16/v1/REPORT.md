# KONFRM Customer Screen 16 V1 — Native Visual Design & Verification Report

## Executive Summary
- **Screen:** Customer Screen 16 — Notification Center (مركز الإشعارات)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Sub-View (Accessible via Customer Account / Screen 12/13/15 hierarchy)
- **Status:** `SCREEN16_V1_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`
- **Active Git Branch:** `evidence/customer-screen16-design-review`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [Issue #168](https://github.com/Essxm01/KONFRM/issues/168), [Issue #166](https://github.com/Essxm01/KONFRM/issues/166), [Issue #167](https://github.com/Essxm01/KONFRM/issues/167), [Issue #145](https://github.com/Essxm01/KONFRM/issues/145)

---

## 1. Domain Context & Product Invariants
Customer Screen 16 serves as the primary notification hub for renters using KONFRM. It notifies customers about booking status changes, payment requirements, owner responses, and account security notices.

### Business & Domain Invariants Enforced:
1. **Deposit Payment Invariant:** When an owner approves a booking request, the notification body explicitly informs the customer that deposit payment is required to confirm the booking:
   `"أصبح دفع العربون الخطوة التالية لتأكيد الحجز"`
   The notification never claims or implies that the booking is already confirmed prior to deposit payment.
2. **Owner Rejection Handling:** Informs the customer objectively without attributing blame or generating hostility:
   `"لم يوافق المالك على طلب الحجز - المواعيد المطلوبة غير متوفرة حالياً، افتح الحجز لمراجعة التفاصيل."`
3. **Session Expiry (401) Isolation:** On an unauthenticated or 401 expired state, all private customer notifications are wiped from the active state, preventing any private data leakage on shared devices. A clean login prompt is presented.
4. **Missing Destination Graceful Fallback:** If a notification links to an expired, cancelled, or missing property/booking, tapping the card presents a polite, truthful notice (`"الوجهة المرتبطة بهذا الإشعار لم تعد متاحة أو تم إلغاؤها"`) instead of crashing or showing a raw 404.

---

## 2. Visual Architecture & Design System Adherence
The design matches the approved visual standards of Customer Screens 12, 13, 14, and 15:
- **Typography:** Cairo Arabic font family (`FontWeight.w800`, `w700`, `w600`, `w500`), strictly RTL (`TextDirection.rtl`).
- **Color Palette:**
  - Canvas: `#F9FAFB`
  - Cards & Header: `#FFFFFF`
  - Neutral Borders: `#E5E7EB`
  - Unread Border Highlight: `#000000` (1.5dp)
  - Primary CTA / Badges: `#000000`
  - Muted Text / Timestamps: `#6B7280` / `#4B5563`
  - Zero generic blue styling.
- **Top Header:** Clean, compact sub-view header from Account with a standard back button (`44x44` dp) pointing to the right (RTL), bold title (`الإشعارات`), unread count badge, and contextual subtitle.
- **List Action Bar:** Dedicated row displaying total unread count with an explicit "قراءة الكل" action that marks all items as read.
- **Canonical Bottom Navigation:** Employs the shared `CustomerBottomNavigation` with **Account (index 3)** active, maintaining contextual continuity.

---

## 3. Physical Hardware Captures on Samsung Galaxy A56 5G

All 14 captures were taken from the physical Samsung Galaxy A56 5G running the standalone Flutter APK:

| Scenario | File Name | Size (Bytes) | PNG SHA-256 | Description |
|---|---|---|---|---|
| `readyListTop` | `01_screen16_a56_ready_list_top.png` | 215,157 | `3140507dbd05956cd90c4eaf816d066ccc46b815b8a2c9a1fe185902a2fe57bd` | Initial ready state showing unread items, unread counter badge, and action cards |
| `readyListScrolled` | `02_screen16_a56_ready_list_scrolled.png` | 180,086 | `96dbf83569066447595e2e57e2507433097b0bba34845ad83f3c06f7cc30b51e` | Scrolled state verifying bottom navigation clearance and card separation |
| `emptyNoNotifications` | `03_screen16_a56_empty_no_notifications.png` | 94,207 | `af5a3d0368fc688e62c1d46d90dff74c7d9e5d81a9fd985c5e0aa0cd46ee94d8` | Empty state with peaceful copy and "استكشف الإقامات" navigation CTA |
| `initialLoading` | `04_screen16_a56_initial_loading.png` | 70,798 | `9595c5e1da43a0ab95523a6900818a0e7761ec5a788107db3d426a3adc95d760` | Shimmer loading skeleton simulating fresh network retrieval |
| `staleRefreshError` | `05_screen16_a56_stale_refresh_error.png` | 210,778 | `30a0069750aa54677f817b6fa18ca3bebe140f20e999acf16aca719cb668dc91` | Non-blocking inline banner informing user of cached state during network disruption |
| `networkErrorInitial` | `06_screen16_a56_network_error_initial.png` | 90,133 | `371e27ca2311a3449b2d4fa0fe75daab32b2264caf11d0edfe12c697a0c626a5` | Full-screen initial load network error with retry button |
| `sessionExpired401` | `07_screen16_a56_session_expired_401.png` | 92,292 | `c5c6cf665261069ea8b8e53b74b7fd16d0e27cf36235e5e5efd3f797a84fb34d` | Secure 401 session expired prompt with total notification cache purge |
| `actionRequiredDetail` | `08_screen16_a56_action_required_detail.png` | 189,334 | `6a7d28d3eccd756500d9b4506ac64fb7c75f719132ea39b7dd2adc5229b8ed13` | Action modal focusing deposit payment requirement |
| `missingDestinationDialog` | `09_screen16_a56_missing_destination_dialog.png` | 181,311 | `ae68d07e4a351756af0fa427962cc8d0e420a2db5ba45f9e2a8f1fcb22e458cc` | Truthful destination unavailable dialog |
| `singleCardFocus` | `10_screen16_a56_single_card_focus.png` | 189,334 | `6a7d28d3eccd756500d9b4506ac64fb7c75f719132ea39b7dd2adc5229b8ed13` | Deep-link interaction on notification item |
| `rejectionCardFocus` | `11_screen16_a56_rejection_card_focus.png` | 197,083 | `62996faf1b66fff0f9905dee42661ce05710857e2f4eb379f10ce35b38f54384` | Non-blaming rejection card review |
| `readUnreadToggled` | `12_screen16_a56_read_unread_toggled.png` | 210,702 | `22a90d62b2223540c13dd139b2c8544df4c0e6cc426ec7c4914aadbe8f439c5f` | Dynamic state transition after marking notifications as read |
| `accessibility200Top` | `13_screen16_a56_accessibility_200_top.png` | 179,698 | `cf61aead1739bfb7b55b93269e67b7b046a5b13fa466ca553efd481c9c631768` | 200% system font scaling showing robust layout with zero RenderFlex overflow |
| `accessibility200Scrolled` | `14_screen16_a56_accessibility_200_scrolled.png` | 182,981 | `90e06bf213ce7eeb610ca271997dd2b8abeed714cf7c047e2b916a79d51b0fd2` | 200% text scale scrolled view verifying action buttons and navigation |

---

## 4. Automated Testing & Static Analysis Evidence
- **Test Command:** `flutter test test/screen16_source_linked_tests.dart`
- **Result:** **15 / 15 Passed (100%)**
  - Unit tests: Model invariant assertions, non-confirmed deposit checks, unread count tracking, 401 cache purge, missing target handling.
  - Widget tests: RTL header rendering, bottom navigation Account tab assertion, card badge verification, empty state guidance, 401 prompt isolation, missing destination dialog, and 200% accessibility overflow assertion.
- **Static Analysis Command:** `flutter analyze tool/screen16_preview_runner.dart test/screen16_source_linked_tests.dart`
- **Result:** **0 issues found** (Clean analysis).

---

## 5. Scope Boundaries & Deferred Items (Issue #167)
Consistent with the Design-First methodology approved by the Founder:
- **Zero changes made to production code** (`mobile/apps/customer_app/lib/`, backend, or DB).
- Push notification reception (FCM / APNs) is deferred to pre-live integration.
- Server-side read/unread state synchronization via Supabase PostgreSQL is deferred to pre-live integration.
- All historical evidence across Screens 12, 13, 14, and 15 remains strictly preserved.
