# KONFRM Customer Screen 16 V2 — Focused Visual & Copy Correction Report

## Executive Summary
- **Screen:** Customer Screen 16 — Notification Center (مركز الإشعارات)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Sub-View (Entered from Customer Account context)
- **Status:** `SCREEN16_V2_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`
- **Active Git Branch:** `evidence/customer-screen16-design-review`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [Issue #168](https://github.com/Essxm01/KONFRM/issues/168) (Contract & Corrections), [Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Principles), [Issue #169](https://github.com/Essxm01/KONFRM/issues/169) (Deferred Technical/QA Backlog), [Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Resolved Items & Exact Implementation Details

### Correction 1: Physical RTL Arrow Directions
- **Problem in V1:** The header back button on the physical right was showing a left-pointing glyph (`<`), while the deposit CTA forward arrow was pointing right (`->`).
- **Remediation in V2:**
  - Header back button on physical right is wrapped in `Directionality(textDirection: TextDirection.ltr, child: Icon(Icons.arrow_forward_ios, size: 16))` to prevent automatic RTL mirroring. It now physically points **RIGHT (`>`)**, consistent with Arabic back navigation.
  - Deposit action CTA arrow in `_buildNotificationCard` is placed at the forward leading position in RTL and wrapped in `Directionality(textDirection: TextDirection.ltr, child: Icon(Icons.arrow_back, size: 14, color: Colors.white))`. It now physically points **LEFT (`<-`)**, consistent with forward progression in Arabic RTL.
  - Verified on actual physical Samsung A56 screen pixels across scenarios `01`, `02`, `08`, `12`, `13`, and `14`.

### Correction 2: Unread Notification Hierarchy
- **Problem in V1:** Repeated 1.5dp full black borders around unread cards produced heavy, visually aggressive black boxes.
- **Remediation in V2:**
  - Replaced full black outlines with a calm `#E5E7EB` (1.0dp) border for all cards, matching the approved design standards of Screens 12 and 15.
  - Unread cards utilize a subtle ambient shadow (`BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: Offset(0, 2))`).
  - Added an accessible unread visual marker beyond color: a 7px circular black dot marker (`●`) in the header row beside the title.
  - Accessible typography hierarchy: unread title uses `FontWeight.w700` (`#111827`) while read title uses `FontWeight.w600` (`#4B5563`).
  - Removed duplicate bottom "جديد" container for a calm, unified presentation.

### Correction 3: Truthful Synthetic Content & Default State
- **Problem in V1:** The runner opened by default into a populated feed with 3 fake unread notifications and unsupported claims.
- **Remediation in V2:**
  - **Truthful Default Launch:** The app boots by default into `Screen16Scenario.emptyNoNotifications` with an empty notification feed (`_items = []`), unread count of 0, and clear, peaceful empty state guidance (`لا توجد إشعارات حتى الآن`).
  - **Segregated QA Scenarios:** Populated notification fixtures are accessed exclusively through developer scenario triggers (Key 1/2/4/5/etc.).
  - **Scrubbed Unsupported Assertions:**
    - Removed customer cancellation intent assertion (`تم إلغاء الطلب بناءً على رغبتك`). Replaced with objective status update: `"تم تحديث حالة طلب الحجز إلى ملغى."`
    - Completely removed fabricated device login security events.
    - Removed unapproved payment confirmation deadline and expiry policy claims.
  - **Deposit Invariant Strictly Preserved:** Owner approval explicitly states deposit payment is required to confirm booking: `"أصبح دفع العربون الخطوة التالية لتأكيد الحجز."` It never claims or implies the booking is confirmed before deposit.
  - **Scenario 10 Distinction:** `singleCardFocus` now targets the cancelled booking card detail, ensuring distinct content and hash from `actionRequiredDetail` (Scenario 08).

---

## 2. Physical Hardware Captures on Samsung Galaxy A56 5G

All 14 captures were taken from the physical Samsung Galaxy A56 5G running the corrected Flutter runner:

| Scenario | File Name | Size (Bytes) | PNG SHA-256 | Description |
|---|---|---|---|---|
| `readyListTop` | `01_screen16_v2_a56_ready_list_top.png` | 200,560 | `597c601c3bfca9b858fae534beebf16aff8dbe62bb61cc2318c3ff810c335b82` | Top fold showing right-pointing header arrow, calm `#E5E7EB` borders, unread dot markers, and left-pointing deposit CTA arrow |
| `readyListScrolled` | `02_screen16_v2_a56_ready_list_scrolled.png` | 188,553 | `497dc737ed52b496fd76ee9fda2308b023d588bd0375fad498e60725f578c609` | Scrolled view verifying card separation, bottom navigation clearance, and unread dot indicators |
| `emptyNoNotifications` | `03_screen16_v2_a56_empty_no_notifications.png` | 93,103 | `45177161eb1601a8bc59e623376283ecd1cb98e4f2dcdb4f866c18085a47ded5` | Truthful default launch state showing 0 unread count, bell icon, and "استكشف الإقامات" CTA |
| `initialLoading` | `04_screen16_v2_a56_initial_loading.png` | 69,704 | `76bbd29fdca9c4d808a5135b5c9178847abc2aad7e59fb376491d845ea368554` | Shimmer card skeleton simulating fresh data loading |
| `staleRefreshError` | `05_screen16_v2_a56_stale_refresh_error.png` | 212,623 | `99e303bbc94741b66cbd0bf7da48d9f7f0c00ecb1529d456fef5852d7a2675a1` | Non-blocking inline banner informing user of cached data during network disruption |
| `networkErrorInitial` | `06_screen16_v2_a56_network_error_initial.png` | 89,016 | `7d3254db11105a78846804797bff6a9d101c11472679ed63e0fb26363481feb1` | Full-screen initial load network error with retry button |
| `sessionExpired401` | `07_screen16_v2_a56_session_expired_401.png` | 91,298 | `f969aa50d9928105276f9b9c048689d393d6ee2519a99213caeee06e70d30646` | Secure 401 prompt with 100% notification cache purge and zero leaked private cards |
| `actionRequiredDetail` | `08_screen16_v2_a56_action_required_detail.png` | 171,572 | `3c90400014df61ad4407ece9048c9b11d1d6cf358fa7a38ce805d8ed5be3f6a3` | Deposit action detail modal emphasizing booking is NOT confirmed until deposit is paid |
| `missingDestinationDialog` | `09_screen16_v2_a56_missing_destination_dialog.png` | 163,315 | `24c8625176c89db21935cee7597bbd50bc906515f2b4701278278974405ead3f` | Truthful destination unavailable dialog |
| `singleCardFocus` | `10_screen16_v2_a56_single_card_focus.png` | 177,311 | `23e536c2f13d871d44cf76a1e1034595711325aa3f1e2578b6d70637fbb0b476` | Detail view of cancelled booking card (distinct from Scenario 08) |
| `rejectionCardFocus` | `11_screen16_v2_a56_rejection_card_focus.png` | 182,785 | `b9c0a5092d4b83e54911ded194219d1caa8998102c948c37606b43fc4321ad74` | Non-blaming rejection card review |
| `readUnreadToggled` | `12_screen16_v2_a56_read_unread_toggled.png` | 196,145 | `8f19b978064c2ed648ae09ddd6e31b5d353c11e2cd62a37bde5e594edaf41e91` | Dynamic state transition after marking first notification as read |
| `accessibility200Top` | `13_screen16_v2_a56_accessibility_200_top.png` | 169,207 | `6425266b0423be3b82a5105cbe459f3825ea26a7d42004e0c0bc67ac746cc6a0` | 200% font scale showing unread cards, right-pointing back arrow, and zero overflow |
| `accessibility200Scrolled` | `14_screen16_v2_a56_accessibility_200_scrolled.png` | 187,049 | `7816e71b943c3efbf5ee56ab806f4ef1dffa89f8e2a5543d202b488996c6a9dc` | 200% text scale scrolled view verifying action buttons and bottom navigation |

---

## 3. Automated Testing & Static Analysis Evidence
- **Test Command:** `flutter test test/screen16_source_linked_tests.dart`
- **Result:** **16 / 16 Passed (100%)**
  - Unit tests: Model invariants, deposit confirmation strictness, non-blaming rejection copy, truthful empty default state, scenario loading, mark as read, mark all read, 401 purge, missing target notice.
  - Widget tests: RTL header rendering, back button semantics and LTR arrow direction, bottom nav Account tab assertion, card badge verification, empty state guidance, 401 prompt isolation, missing destination dialog, and 200% accessibility overflow assertion.
- **Static Analysis Command:** `flutter analyze tool/screen16_preview_runner.dart test/screen16_source_linked_tests.dart`
- **Result:** **0 issues found** (Clean analysis).

---

## 4. Strict Boundaries & Deferred Backlog (Issue #169)
- **Zero changes made to production code** (`customer_app/lib/`, backend, DB).
- All V1 evidence files in `review-evidence/customer-screen16/v1/` remain 100% immutable and preserved.
- Backend push delivery, server unread persistence, and release QA remain deferred under GitHub Issue #169.
- No merge, deploy, or advancement to Screen 17 until Founder visual approval of Screen 16 V2.
