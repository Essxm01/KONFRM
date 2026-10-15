# Customer Screen 17 V3 — Simplified Premium (Founder UX Recomposition)
**Screen Title:** «حسابي» — Account Home / Personal Home  
**Status:** `SCREEN17_SIMPLIFIED_PREMIUM_AWAITING_BRIDGE_FOUNDER_REVIEW`  
**Execution Context:** Isolated Native Flutter Preview (`mobile/apps/customer_app/tool/screen17_preview_runner.dart`)  
**Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, 1080 x 2340 px)  
**Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Governing Issues:**
- [Issue #170](https://github.com/Essxm01/KONFRM/issues/170) (Founder Design Recomposition Directives)
- [Issue #174](https://github.com/Essxm01/KONFRM/issues/174) (Notification Icon in Explore Header vs Navigation Contract Reconciliation)
- [Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First & Cross-Screen Consistency)
- [Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar, QR & Connected Profiles)
- [Issue #173](https://github.com/Essxm01/KONFRM/issues/173) (Customer Wallet & Financial Boundaries)
- [Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Directory Immutability)

---

## Key Recomposition Highlights

1. **Unboxed Personal Home (No Boxed Card):**
   - Transformed the identity hero from a rigid rectangular boxed dashboard card into a soft, minimal, editorial Personal Home seamlessly integrated into the background canvas (`#F9FAFB`).
   - Retained the high-clarity 104dp circular studio portrait of Ahmed (`أحمد مصطفى`), bold display name, LTR isolated handle (`@ahmed_mostafa`), and accessible profile edit affordance.
   - **Zero phone display in hero fold:** Protected customer privacy per strict founder directive.

2. **Updated Camera Badge:**
   - Redesigned with a **black camera icon** (`#111827`) centered inside a **white circular surface** (`#FFFFFF` with `#E5E7EB` border and subtle shadow) with a full **48dp accessible touch target**.
   - Fully eliminated the previous inverted white-on-black treatment.

3. **Complete Removal of the 3 Shortcut Tiles:**
   - Deleted the redundant 3 shortcut tiles (`حجوزاتي`, `المفضلة`, `الإشعارات`). Bookings and Favorites remain in the bottom navigation bar; Notifications transition to the Explore header per Issue #174.

4. **Issue #174 Navigation Architecture Alignment:**
   - Formalized contract reconciliation proposal regarding the notification bell in the Explore header without altering Explore or Screen 16 code.

5. **Restrained Upcoming Stay Summary:**
   - Single compact summary card featuring live green dot (`#16A34A`), truthful status `حجز مؤكد`, reservation details, and physical left chevron (`<`).

6. **Anti-Card-Soup Calm Navigation Groups:**
   - Grouped into 3 calm white cards with 1px internal dividers:
     - **الحساب والملف الشخصي:** الملف الشخصي, الخصوصية والأمان, الإعدادات والحسابات المرتبطة (مفهوم مقترح).
     - **المالية والمدفوعات:** سجل المدفوعات, محفظة كونفرم (مفهوم مقترح #173).
     - **المساعدة والخدمات:** المساعدة والدعم, شارك كونفرم مع معارفك.
   - Distinct, reachable `تسجيل الخروج` action button with safe confirmation dialog.

7. **Exact Shared Bottom Navigation (Matching Screens 15/16):**
   - Configured via `ThemeData.navigationBarTheme` with `#F3F4F6` neutral indicator pill, `#000000` selected label/icon, eliminating any purple tint.

8. **Truthful Personal QR & Wallet Concepts:**
   - Personal QR sheet: digital identifier card without encryption claims or guest QR fallback.
   - Wallet concept modal: clean `0.00 ج.م` balance with zero fabricated refund claims and clear financial governance disclaimer.

---

## Directory Inventory

- `01_screen17_v3_a56_flagship_hero_top.png` & `.b64.txt`
- `02_screen17_v3_a56_flagship_hero_scrolled.png` & `.b64.txt`
- `03_screen17_v3_a56_no_photo_initials_fallback.png` & `.b64.txt`
- `04_screen17_v3_a56_incomplete_profile_prompt.png` & `.b64.txt`
- `05_screen17_v3_a56_guest_unauthenticated.png` & `.b64.txt`
- `06_screen17_v3_a56_initial_loading_skeleton.png` & `.b64.txt`
- `07_screen17_v3_a56_network_error_initial.png` & `.b64.txt`
- `08_screen17_v3_a56_session_expired_401.png` & `.b64.txt`
- `09_screen17_v3_a56_qr_modal_my_code.png` & `.b64.txt`
- `10_screen17_v3_a56_qr_modal_scanner.png` & `.b64.txt`
- `11_screen17_v3_a56_wallet_modal_concept.png` & `.b64.txt`
- `12_screen17_v3_a56_logout_confirmation_dialog.png` & `.b64.txt`
- `13_screen17_v3_a56_compact_hero_variant.png` & `.b64.txt`
- `14_screen17_v3_a56_accessibility_200_top.png` & `.b64.txt`
- `15_screen17_v3_a56_accessibility_200_scrolled.png` & `.b64.txt`
- `review-source/` (mirrored runner, tests, and portrait asset)
- `VISUAL_BRIDGE_README.md` (hash manifest)
- `REPORT.md` (detailed design and architecture report)
