# KONFRM Customer Screen 17 V1 — Native Visual Design & Verification Report

## Executive Summary
- **Screen:** Customer Screen 17 — Account Home (الحساب)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Root Hub (CustomerBottomNavigation Tab 3 active)
- **Status:** `SCREEN17_V1_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`
- **Active Git Branch:** `evidence/customer-screen17-design-review`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [GitHub Issue #170](https://github.com/Essxm01/KONFRM/issues/170), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145)

---

## 1. Domain Context & Product Invariants
Customer Screen 17 serves as the primary Account hub for renters using KONFRM. It acts as the anchor for customer profile management, personal identity presentation, activity tracking, payment history, and customer support.

### Business & Domain Invariants Enforced:
1. **Verified Identity Privacy & Safe Masking:** Phone numbers are masked according to standard Egyptian format (`+20 10••••5678`) and isolated using `<bdi dir="ltr">` text directionality, ensuring telephone numbers never scramble in RTL Arabic layouts.
2. **Canonical Customer Identity:** Displays verified identifiers only (`public.user_identifiers`). When a profile lacks a full name, it displays "مستأجر" alongside a gentle, actionable profile completion prompt ("أكمل بيانات حسابك") with an "إكمال البيانات" action button.
3. **Fail-Closed Identity Integrity:** If an authenticated session lacks verified phone or email identifiers in canonical data, it fails closed into an integrity notice ("لا يمكن التحقق من هوية الحساب") rather than fabricating placeholders.
4. **Session Expiry (401) Isolation:** On an unauthenticated or 401 expired state, all private customer details are wiped from the active state, preventing any private data leakage on shared devices. A clean login prompt is presented.
5. **Role Boundary Isolation:** Exposes customer-only capabilities (رحلاتك, النشاط, المدفوعات, الحساب, المساعدة). Zero owner operational controls or admin capabilities are exposed.

---

## 2. Visual Architecture & Design System Adherence
The design matches the approved visual standards of Customer Screens 12, 15, and 16:
- **Typography:** Cairo Arabic font family (`FontWeight.w800`, `w700`, `w600`, `w500`), strictly RTL (`TextDirection.rtl`).
- **Monochrome Surface Palette:**
  - Canvas: `#F9FAFB`
  - Cards & Header: `#FFFFFF`
  - Neutral Borders: `#E5E7EB`
  - Soft Icon Wells: `#F3F4F6` with deep charcoal/black icons (`#111827`)
  - Primary CTA / Badges: `#000000`
  - Muted Text / Subtitles: `#6B7280` / `#4B5563`
  - Zero generic blue styling.
- **Deterministic Physical Chevron Directions:** All navigation row chevrons leading to deeper surfaces point physically **LEFT** (`<`) on hardware pixels, representing true forward step progression in RTL Arabic.
- **Top Header:** Clean, compact Account root header with bold title (`حسابي`) on the physical right.
- **Canonical Bottom Navigation:** Employs the shared `CustomerBottomNavigation` with **Account (index 3)** active, maintaining contextual continuity with Screens 12, 15, and 16.

---

## 3. Physical Hardware Captures on Samsung Galaxy A56 5G

All 14 captures were taken from the physical Samsung Galaxy A56 5G running the standalone Flutter APK:

| Scenario | File Name | Size (Bytes) | PNG SHA-256 | Description |
|---|---|---|---|---|
| `authenticatedCompleteTop` | `01_screen17_v1_a56_authenticated_complete_top.png` | 151,905 | `09cde8082aace401f592748842004e8c6556d845da689c56ee72bd8d09a4db3d` | Complete profile top fold with avatar, name, masked phone, Trips & Activity sections |
| `authenticatedCompleteScrolled` | `02_screen17_v1_a56_authenticated_complete_scrolled.png` | 126,821 | `716dc7103b059dbc9ebd2c6d2a05854cdeef3cf2a88d0edfc999f39f3efa29d7` | Scrolled view showing Payments, Personal Data, Support, and Logout button |
| `incompleteProfilePrompt` | `03_screen17_v1_a56_incomplete_profile_prompt.png` | 156,528 | `13d70df0e83346caf9b98e24149a71c16e35134f2c9f4e1a70e71790b418b5ce` | Gentle profile completion notice when full name is missing |
| `guestUnauthenticated` | `04_screen17_v1_a56_guest_unauthenticated.png` | 109,893 | `55a55dec69bcea88d4b767c951e6832a09710177c1df0d0687830eb832ed22f1` | Guest state with phone login CTA and zero private data leakage |
| `initialLoadingSkeleton` | `05_screen17_v1_a56_initial_loading_skeleton.png` | 59,188 | `9e3d46e31bee79cc997c7a9cf6427e23379558f9cf174608fe2dd585e2c20ed4` | Shimmer/neutral card skeletons simulating initial network retrieval |
| `networkErrorInitial` | `06_screen17_v1_a56_network_error_initial.png` | 83,160 | `a64a07416528c23f16932af8bd36193d7e7e90458c85a5808e67f3ef9bf505f9` | Full-screen initial load network error with retry button |
| `staleRefreshError` | `07_screen17_v1_a56_stale_refresh_error.png` | 154,333 | `96c5eb7042103f8f4a4f733e91dedba1c83446167ac78649f8651ace027d21ed` | Non-blocking inline banner informing user of cached profile during network failure |
| `sessionExpired401` | `08_screen17_v1_a56_session_expired_401.png` | 83,788 | `390a7db4e8c0ab6f1ddbcad96130d6b48ff8d33e906d9ceb37cbc12b44a4257b` | Secure 401 session expired prompt with total profile cache purge |
| `identityIntegrityFailure` | `09_screen17_v1_a56_identity_integrity_failure.png` | 93,037 | `db02dd9d76803c1194961daaf266752716fa8f66c84f20ac65126e9984233172` | Fail-closed view when authenticated session lacks verified identifiers |
| `logoutConfirmationDialog` | `10_screen17_v1_a56_logout_confirmation_dialog.png` | 149,176 | `4eeb0b8fc331eb1dd90c36ede8be497d2bb0b9aea96e77893f305094eec8340f` | Modal confirmation dialog asking to confirm sign out |
| `navigationInteractionFeedback` | `11_screen17_v1_a56_navigation_interaction_feedback.png` | 142,928 | `425598d5be9cee6918beaefbc351ae82bf87bb464d538c20b1fd4b16107fb533` | Navigation preview dialog demonstrating route selection feedback |
| `verifiedEmailVariant` | `12_screen17_v1_a56_verified_email_variant.png` | 156,470 | `08a0be99fb5538dcb9540c472021e6d5202bdc6c6d5a7c9665d6fbe051888275` | User verified via email without phone, formatted with LTR isolation |
| `accessibility200Top` | `13_screen17_v1_a56_accessibility_200_top.png` | 133,751 | `4ec86c51169300f34b7ab0cb92a987aa29a8b0acec1a37c4c55bebb33bc74a69` | Top fold reflowing cleanly at 200% font scale with zero RenderFlex overflow |
| `accessibility200Scrolled` | `14_screen17_v1_a56_accessibility_200_scrolled.png` | 139,111 | `3a955e0e3cbdf89c42978201a34659dab469859a65f158db64a1c8b630e1dbb0` | Scrolled view at 200% font scale showing bottom navigation clearance |

---

## 4. Verification Evidence & Quality Gates
- **Source-Linked Tests:** 20/20 PASS (100% pass rate) via `mobile/apps/customer_app/test/screen17_source_linked_tests.dart`.
- **Static Analysis:** `0 issues found` via `flutter analyze`.
- **Physical Hardware Execution:** Verified on genuine Samsung Galaxy A56 5G hardware over ADB.
- **Cross-Screen Consistency:** Bottom navigation, card containers, typography, and spacing match approved Screens 12, 15, and 16.
- **Evidence Immutability Compliance:** All artifacts published into new additive directory `review-evidence/customer-screen17/v1/`; all historical Screen 12, 13, 14, 15, and 16 evidence untouched.
