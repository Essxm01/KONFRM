# KONFRM Customer Screen 17 V3 — Simplified Premium Engineering & Design Report
**Screen Name:** Customer Screen 17 — Account Home («حسابي — مساحتي في كونفرم»)  
**Authoritative Directive:** Founder UX Recomposition ([GitHub Issue #170](https://github.com/Essxm01/KONFRM/issues/170))  
**Target Status:** `SCREEN17_SIMPLIFIED_PREMIUM_AWAITING_BRIDGE_FOUNDER_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, 1080 x 2340 px)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Active Branch:** `evidence/customer-screen17-design-review`  
**Historical Baselines Preserved:**
- Screen 17 V1 Traditional Baseline: `1f1b5a043d82ff2cb6c5d72ce2bd10ede78b83ef` (`review-evidence/customer-screen17/v1/`)
- Screen 17 V2 Premium Baseline: `117338307827d157a36e710f39629fde0d282760` (`review-evidence/customer-screen17/v2-premium/`)

---

## 1. Executive Summary & Design Evolution

Following Founder directive in GitHub Issue #170, Customer Screen 17 has undergone a purposeful architectural and visual recomposition from a boxed personal dashboard into a **soft, minimal, editorial Personal Home**.

### Three-Stage Design Evolution Matrix

| Dimension | V1 Baseline (Rejected) | V2 Premium Baseline | V3 Simplified Premium (Delivered) |
| :--- | :--- | :--- | :--- |
| **Architectural Model** | Utility settings list | Boxed Identity Dashboard | **Soft Editorial Personal Home** |
| **Identity Hero Layout** | Small avatar + phone in list | Enclosed rectangular card (white card on grey canvas) | **Unboxed Identity Composition** directly on canvas |
| **Camera Badge Treatment** | None | White icon on black circle | **Black icon (`#111827`) inside white circle (`#FFFFFF`) with 48dp touch target** |
| **Top Shortcut Strip** | None | 3 Large Shortcut Tiles (Bookings, Favorites, Notifications) | **Completely Removed** (Eliminating redundant card soup) |
| **Upcoming Stay Strip** | Absent / Generic | Large card with reservation data | **Restrained, Compact Summary Card** (Live green dot, verified title, dates, physical left chevron `<`) |
| **Navigation Architecture** | Repeated ungrouped list tiles | Hybrid cards + tiles | **Calm Grouped Sections** with 1px internal dividers (`#F3F4F6`), zero nested card soup |
| **Bottom Navigation Theme** | Default Material 3 (Purple tint) | Default Material 3 (Purple tint) | **Exact Shared Customer Navigation** (Neutral `#F3F4F6` indicator pill, `#000000` selected items, matching Screens 15/16) |
| **QR Code Disclosure** | N/A | "Encrypted identity token" claim | **Truthful Digital Identifier Card** (No exaggerated encryption claims, no guest fallback) |
| **Wallet Concept Modal** | N/A | Mocked 1,200 EGP refund claim | **Truthful `0.00 ج.م` Balance** with zero fabricated claims and clear Issue #173 governance disclaimer |

---

## 2. In-Depth Technical & Design Architecture

### 2.1 Unboxed Identity Hero
- **Canvas Integration:** The large outer container (`BoxDecoration(color: Colors.white, borderRadius: 20)`) enclosing the avatar, name, and edit button in V2 was completely removed. The identity now breathes naturally on the `#F9FAFB` screen background.
- **Studio Portrait Asset:** Features the consenting, realistic studio portrait of Ahmed (`أحمد مصطفى`) rendered in a 104x104dp circular mask (`ClipOval`) with a 3dp white border and subtle ambient elevation shadow.
- **Camera Affordance Update:**
  - Icon: Black (`#111827`), size 18dp (`Icons.camera_alt_outlined`).
  - Container: White circular surface (`#FFFFFF`), 36x36dp, bordered by 1.5dp `#E5E7EB` with light elevation.
  - Touch Target: Enclosed within a 48x48dp transparent gesture area, satisfying WCAG 2.2 AAA touch target guidelines.
- **Identity Typography:**
  - Full Name: Cairo Bold 22 (`#111827`).
  - Proposed Handle: Cairo SemiBold 13 (`#4B5563`) inside `#F3F4F6` pill, wrapped in `Directionality(textDirection: TextDirection.ltr)` to prevent RTL punctuation inversion.
  - Compact Edit CTA: Pill button (`#FFFFFF`, border `#E5E7EB`, 13dp Cairo Bold, `#111827`).
  - **Phone Privacy:** The telephone number is strictly excluded from the hero fold.

### 2.2 Removal of 3 Shortcut Tiles & Issue #174 Reconciliation
- **Shortcut Deletion:** The 3 shortcut tiles (`حجوزاتي`, `المفضلة`, `الإشعارات`) were completely removed from `_buildAuthenticatedAccountSliver()`.
- **Navigation Invariants:**
  - Bookings (حجوزاتي) is already permanently accessible in the bottom navigation bar at Index 2.
  - Favorites (المفضلة) is already permanently accessible in the bottom navigation bar at Index 1.
  - Notification Center (الإشعارات) was originally designated as an Account child destination. Per Issue #174, moving the notification bell affordance to the Explore (Screen 03) root header aligns with international consumer travel patterns (e.g. Airbnb).
  - **Reconciliation Proposal:** We formalize this contract amendment under GitHub Issue #174 without modifying Explore or Screen 16 code in this screen preview.

### 2.3 Restrained Upcoming Stay Summary
- Rendered only when genuine booking state exists (`profile.hasUpcomingStay == true`).
- Sleek, compact card (`#FFFFFF`, border `#E5E7EB`, borderRadius 16dp).
- Live reservation status dot (`#16A34A`, 8dp circle) paired with `إقامتك القادمة` and a crisp `حجز مؤكد` badge.
- Property title in Cairo ExtraBold 15, stay dates and nights in Cairo SemiBold 12, and a physical LEFT chevron (`<`) for RTL progression.

### 2.4 Calm, Compact Grouped Navigation (Anti-Card-Soup)
Replaced individual nested cards with 3 calm grouped cards with 1px internal dividers:
1. **الحساب والملف الشخصي:**
   - الملف الشخصي (Name, handle, private data -> Screen 18 Vision).
   - الخصوصية والأمان (Account protection, sessions, authentication -> Screen 19 Vision).
   - الإعدادات والحسابات المرتبطة (Apple, Google, passkeys -> Proposed concept under Screen 19).
2. **المالية والمدفوعات:**
   - سجل المدفوعات (Deposit receipts, transaction history -> Screen 20 Vision).
   - محفظة كونفرم (Available balance, refund credits -> Proposed concept under Issue #173).
3. **المساعدة والخدمات:**
   - المساعدة والدعم (FAQs, booking guidelines -> Screen 21 Vision).
   - شارك كونفرم مع معارفك (Official invite flow integrated cleanly as a standard row).
4. **Sign Out:**
   - Reachable white card with Cairo Bold 14 in `#DC2626` (Red), triggering a non-destructive confirmation dialog (`dialog_confirm_logout` / `dialog_cancel_logout`).

### 2.5 Canonical Customer Bottom Navigation Bar
- Configured via `ThemeData.navigationBarTheme`:
  - `indicatorColor: const Color(0xFFF3F4F6)` (Soft neutral grey pill, eliminating Material 3 lavender/purple tint).
  - Selected icon & label: `#000000` (Cairo Bold 12).
  - Unselected icon & label: `#6B7280` (Cairo Medium 12).
- Passed directly to `Scaffold(bottomNavigationBar: CustomerBottomNavigation(selectedIndex: 3))` to guarantee 100% visual consistency with approved Screens 15 and 16.

### 2.6 Truthful Personal QR & Wallet Concepts
- **Personal QR Sheet (`_buildQrModalSheet`):**
  - Title: `بطاقة الحساب الشخصية (QR)` (Personal Account Card).
  - Truthful disclosure: `رمز تعريفي رقمي لمشاركة معرّف الحساب المعتمد — لا يشارك أرقام الهواتف أو وسائل الدفع`.
  - Guarded: Unauthenticated users tapping the header QR button receive immediate guidance (`يرجى تسجيل الدخول أولاً لعرض رمز حسابك الشخصي`) with zero guest QR identity fallback.
- **Proposed Wallet Modal (`_buildWalletModalSheet`):**
  - Clean `0.00 ج.م` balance.
  - Zero fabricated refund amounts (removed `مبالغ قيد التسوية: 1,200 ج.م`). Replaced with `لا توجد عمليات سابقة أو مبالغ معلقة`.
  - Prominent financial governance disclaimer referencing Issue #173 legislative & operational boundaries.

---

## 3. Physical Samsung Galaxy A56 5G Hardware Evidence

All captures were taken on actual physical hardware connected via ADB:
- **Device Model:** Samsung Galaxy A56 5G (`SM-A566B`)
- **OS:** Android 16 (API 36)
- **Physical Viewport:** 1080 x 2340 px, 450 dpi
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)

### Complete 15-Scenario Evaluation Matrix

| Scenario | Screenshot Name | Hardware Evidence Description |
| :--- | :--- | :--- |
| **01** | `01_screen17_v3_a56_flagship_hero_top.png` | Initial authenticated viewport: unboxed Ahmed studio portrait, black-on-white camera badge (48dp target), Cairo typography, restrained upcoming stay card, and shared bottom navigation. |
| **02** | `02_screen17_v3_a56_flagship_hero_scrolled.png` | Scrolled state: calm grouped sections (الحساب, المالية, المساعدة) with 1px dividers, physical left chevrons (`<`), and red logout button. |
| **03** | `03_screen17_v3_a56_no_photo_initials_fallback.png` | Graceful fallback when portrait is removed: bold Arabic monogram (`أ.م`) in `#111827` circular avatar. |
| **04** | `04_screen17_v3_a56_incomplete_profile_prompt.png` | Contextual prompt for incomplete account setup with quick `إكمال` action button. |
| **05** | `05_screen17_v3_a56_guest_unauthenticated.png` | Honest unauthenticated state: zero leaked private data, login prompt with primary CTA. |
| **06** | `06_screen17_v3_a56_initial_loading_skeleton.png` | Shimmer skeleton reflecting the unboxed hero and calm grouped cards; zero 3-shortcut card skeletons. |
| **07** | `07_screen17_v3_a56_network_error_initial.png` | Recoverable network error state with retry CTA. |
| **08** | `08_screen17_v3_a56_session_expired_401.png` | Secure 401 session expiration view prompting re-authentication. |
| **09** | `09_screen17_v3_a56_qr_modal_my_code.png` | Personal QR sheet: digital identifier matrix, user identity summary, truthful non-banking disclosure, and share affordances. |
| **10** | `10_screen17_v3_a56_qr_modal_scanner.png` | QR scanner tab view with clear viewfinder framing. |
| **11** | `11_screen17_v3_a56_wallet_modal_concept.png` | Proposed Wallet concept modal (#173): `0.00 ج.م` balance, zero fake refund claims, and legal governance notice. |
| **12** | `12_screen17_v3_a56_logout_confirmation_dialog.png` | Modal logout confirmation dialog with clear cancel and destructive exit actions. |
| **13** | `13_screen17_v3_a56_compact_hero_variant.png` | Alternative horizontal compact hero composition with black-on-white camera badge. |
| **14** | `14_screen17_v3_a56_accessibility_200_top.png` | 200% Android system font scaling at top fold: zero overflow, perfect text wrapping. |
| **15** | `15_screen17_v3_a56_accessibility_200_scrolled.png` | 200% font scaling scrolled view: grouped navigation rows expand vertically without RenderFlex errors. |

---

## 4. Verification & Quality Gates

1. **Automated Unit & Widget Tests:**
   - Test File: `mobile/apps/customer_app/test/screen17_source_linked_tests.dart`
   - Result: **21/21 passed (100% pass rate)**.
   - Tests assert removal of 3 shortcut tiles, unboxed hero, black-on-white camera badge, zero phone display, wallet truthful zero claim, and 200% font scale robustness.
2. **Static Analysis:**
   - Command: `flutter analyze tool/screen17_preview_runner.dart test/screen17_source_linked_tests.dart`
   - Result: **No issues found (0 warnings, 0 errors)**.
3. **Evidence Immutability:**
   - V1 evidence in `review-evidence/customer-screen17/v1/` remains byte-for-byte immutable.
   - V2 evidence in `review-evidence/customer-screen17/v2-premium/` remains byte-for-byte immutable.
   - All V3 artifacts are published additively in `review-evidence/customer-screen17/v3-simplified-premium/`.

---

## 5. Architectural Vision for Screen 18 & Screen 19

- **Screen 18 (Profile Edit / تعديل الملف الشخصي):**
  - Implement full editing form for display name, bio, and social handles.
  - Implement Android Scoped Photo Picker and camera capture with 1:1 circular cropping.
- **Screen 19 (Privacy, Security & Linked Accounts / الخصوصية والأمان):**
  - Session management (active devices and IP audit).
  - Secure linked accounts (Apple Sign-In, Google, Passkeys) adhering to canonical server-derived identity.
