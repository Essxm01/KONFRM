# KONFRM Customer Screen 16 V2 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 16 — Notification Center (مركز الإشعارات) [V2 Focused Visual & Copy Corrections]  
**Status:** `SCREEN16_V2_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen16-design-review`  
**Governing Issues:** [GitHub Issue #168](https://github.com/Essxm01/KONFRM/issues/168) (V2 Corrections & Scope), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Principles), [GitHub Issue #169](https://github.com/Essxm01/KONFRM/issues/169) (Deferred Technical/QA Backlog), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 14 V2 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the corrected native Flutter preview runner (`mobile/apps/customer_app/tool/screen16_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `readyListTop` | `01_screen16_v2_a56_ready_list_top.png` | 200,560 | `597c601c3bfca9b858fae534beebf16aff8dbe62bb61cc2318c3ff810c335b82` | `b5f56b248ec8527b71a4c046f943cc38e29f5ed361f37024e7bf86bb6c916a33` |
| 02 | `readyListScrolled` | `02_screen16_v2_a56_ready_list_scrolled.png` | 188,553 | `497dc737ed52b496fd76ee9fda2308b023d588bd0375fad498e60725f578c609` | `28b084ebfaf1694d7c6d9989cf728c991ece95cf4d34af8211280bc95f6f256f` |
| 03 | `emptyNoNotifications` | `03_screen16_v2_a56_empty_no_notifications.png` | 93,103 | `45177161eb1601a8bc59e623376283ecd1cb98e4f2dcdb4f866c18085a47ded5` | `efa830a22c8692863415548950c6c3c6ffcd71dc2155b398182fc2ff762f00bc` |
| 04 | `initialLoading` | `04_screen16_v2_a56_initial_loading.png` | 69,704 | `76bbd29fdca9c4d808a5135b5c9178847abc2aad7e59fb376491d845ea368554` | `140552c15c61356ad602e75d3f8502ed185ce57a2c82ed38d9c88540a33cd0e3` |
| 05 | `staleRefreshError` | `05_screen16_v2_a56_stale_refresh_error.png` | 212,623 | `99e303bbc94741b66cbd0bf7da48d9f7f0c00ecb1529d456fef5852d7a2675a1` | `524f89237615e3b5ff1e1e5587c805fcc2dae208c28b3a6615f72c6b9f1686c0` |
| 06 | `networkErrorInitial` | `06_screen16_v2_a56_network_error_initial.png` | 89,016 | `7d3254db11105a78846804797bff6a9d101c11472679ed63e0fb26363481feb1` | `1fed256188c7ff9c193d70e5ee20b79745397e87a7e5be14409ed128ceaedd0c` |
| 07 | `sessionExpired401` | `07_screen16_v2_a56_session_expired_401.png` | 91,298 | `f969aa50d9928105276f9b9c048689d393d6ee2519a99213caeee06e70d30646` | `b9aa398e0d500793acfa2b89aaa0eaa93ca15fb29143cca1eca6cebb07010aee` |
| 08 | `actionRequiredDetail` | `08_screen16_v2_a56_action_required_detail.png` | 171,572 | `3c90400014df61ad4407ece9048c9b11d1d6cf358fa7a38ce805d8ed5be3f6a3` | `edfe4ce6be440c4ef8cb073644d1e769f1b6d1cec94709c685fbd09fa97a31b3` |
| 09 | `missingDestinationDialog` | `09_screen16_v2_a56_missing_destination_dialog.png` | 163,315 | `24c8625176c89db21935cee7597bbd50bc906515f2b4701278278974405ead3f` | `db2ac9c9e7ce5af74812936cbefede23f470c7fdeb56a70308c52181db4b1ff3` |
| 10 | `singleCardFocus` | `10_screen16_v2_a56_single_card_focus.png` | 177,311 | `23e536c2f13d871d44cf76a1e1034595711325aa3f1e2578b6d70637fbb0b476` | `73b08d52c906ead77221d4de63c30356762d38d74a9243b15556322423801ba1` |
| 11 | `rejectionCardFocus` | `11_screen16_v2_a56_rejection_card_focus.png` | 182,785 | `b9c0a5092d4b83e54911ded194219d1caa8998102c948c37606b43fc4321ad74` | `0e3e397f823910e627358413891d99eb8d9c66ac84de5651a1ef226e071e1c37` |
| 12 | `readUnreadToggled` | `12_screen16_v2_a56_read_unread_toggled.png` | 196,145 | `8f19b978064c2ed648ae09ddd6e31b5d353c11e2cd62a37bde5e594edaf41e91` | `a59c8fd3c5e5d5c4d91b78838d7353bca91cdd416be25eefa8cd8a33dc78a173` |
| 13 | `accessibility200Top` | `13_screen16_v2_a56_accessibility_200_top.png` | 169,207 | `6425266b0423be3b82a5105cbe459f3825ea26a7d42004e0c0bc67ac746cc6a0` | `d058dea80ccf024a399add160a1e326589a94cac677a66b829440063b564c9fd` |
| 14 | `accessibility200Scrolled` | `14_screen16_v2_a56_accessibility_200_scrolled.png` | 187,049 | `7816e71b943c3efbf5ee56ab806f4ef1dffa89f8e2a5543d202b488996c6a9dc` | `244b2ad2f46d38699a247d9ac62e39c2f64218a6849ad3c473df8daec30b82f1` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen16_preview_runner.dart`  
  SHA-256: `21edff69622d080e640567c32b64692ccb7885b883625415b68ddff7a32c9002`
- **Behavioral Test Suite:** `review-source/screen16_source_linked_tests.dart`  
  SHA-256: `65c23d356b74335cc787dc1f7a5ea12ba654500b18e089df41f5f911db587db9`
- **Test Suite Result:** 16/16 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Targeted Corrections Verified in V2

1. **Physical RTL Arrow Directions:**
   - Header back button on physical right points physically **RIGHT (`>`)**, verified on Samsung Galaxy A56 hardware pixels.
   - Deposit action CTA arrow in the black container points physically **LEFT (`<-`)**, matching Arabic RTL forward progression.
2. **Quiet, Calm Unread Card Hierarchy:**
   - Removed aggressive repeated 1.5dp black borders around unread cards.
   - All cards now share a calm `#E5E7EB` 1.0dp border consistent with approved Customer Screens 12 and 15.
   - Distinct unread visual indicator implemented as an elegant 7px circular black dot marker beside the title in the header row, paired with bold title typography (`FontWeight.w700` vs `w600`) and clear semantics.
3. **Truthful Synthetic Content & Default State:**
   - Default view boots into a truthful empty state with 0 unread count and calm explore guidance (`لا توجد إشعارات حتى الآن`).
   - Populated notifications are segregated as explicit QA visual scenarios.
   - Unsupported cancellation intent (`تم إلغاء الطلب بناءً على رغبتك`) replaced with objective status update (`تم تحديث حالة طلب الحجز إلى ملغى`).
   - Fabricated device login security events completely removed.
   - Unapproved payment confirmation expiry policy claims removed.
   - Strict deposit invariant preserved: owner approval requires deposit payment to confirm, never claiming booking is confirmed before deposit.
