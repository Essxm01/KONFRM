# KONFRM Customer Screen 17 V2 — Flagship Personal Passport («مساحتي في كونفرم»)
## Visual Design & Verification Report

## Executive Summary
- **Screen:** Customer Screen 17 — Account Home / Personal Passport (الحساب / مساحتي في كونفرم)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Root Hub (`CustomerBottomNavigation` Tab index 3 active)
- **Mode:** Flagship Founder-Directed Visual Reset (V2-Premium)
- **Status:** `SCREEN17_V2_PREMIUM_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`
- **Active Git Branch:** `evidence/customer-screen17-design-review`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:**
  - [GitHub Issue #170](https://github.com/Essxm01/KONFRM/issues/170) (Founder Visual Reset & Direction)
  - [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Priorities & Consistency)
  - [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar, QR & Connected Profiles)
  - [GitHub Issue #173](https://github.com/Essxm01/KONFRM/issues/173) (Customer Wallet & Financial Boundaries)
  - [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Historical Evidence Directory Immutability)
  - [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Device Serial Redaction Protocol)

---

## 1. Domain Context & Founder Visual Reset Rationale
Customer Screen 17 serves as the primary Account anchor for vacation rental guests on KONFRM. 

Following visual review of Screen 17 V1 (`1f1b5a043d82ff2cb6c5d72ce2bd10ede78b83ef`), the Founder directed an immediate visual reset to establish an original, flagship customer experience. The conventional web-like list of settings was rejected in favor of an **editorial, high-end mobile profile** inspired by premium lifestyle and travel products (Airbnb, Pinterest, WhatsApp):
- **Identity Hero:** Replaced generic text lists with a portrait-first 104dp circular profile avatar featuring a genuine studio portrait of a young Egyptian renter (`Ahmed` / `أحمد مصطفى`).
- **Camera Affordance Badge:** Overlapping true-black (`#000000`) circular camera icon button ($34 \times 34\,\text{dp}$) positioned at the bottom-left of the avatar.
- **Privacy Invariant:** In strict adherence to Founder directives, telephone numbers and email addresses are **EXPLICITLY NOT** rendered in the primary hero fold, preventing private credential leakage when looking at the screen in public or shared spaces.
- **Header Structure:** Clean root title `حسابي` on the physical right (RTL), paired with a discrete Personal QR affordance on the physical left ($44 \times 44\,\text{dp}$ touch target). Zero developer controls or debug selectors are exposed in customer captures.
- **Fast Shortcuts (3-Column):** Equal-width shortcut cards for primary rental destinations: `حجوزاتي` (1 حجز نشط), `المفضلة` (4 وحدات), and `الإشعارات` (2 جديد with counter badge).
- **Contextual Upcoming Stay Card:** High-contrast banner highlighting the customer's next trip (`فيلا فاخرة بإطلالة مباشرة على البحر - مراسي`, 20-25 أكتوبر), status badge, and forward progression chevron.
- **Grouped Navigation:** Clean, calm rounded cards grouped by domain (`الحساب والملف الشخصي`, `المالية والمدفوعات`, `المساعدة والدعم`) with soft neutral icon containers.
- **Share Strip:** An organic referral/share strip (`شارك كونفرم مع أصدقائك`) positioned before session termination.
- **Logout Action:** Outlined red-tinted sign-out row triggering a native confirmation dialog.

---

## 2. Personal QR Code System (Procedural Implementation)
Tapping the QR button in the top header opens a high-contrast modal bottom sheet providing a secure physical and in-person check-in identity presentation:
- **Dual Tabs:** `رمزي` (My Code) and `مسح رمز` (Scan Code).
- **Procedural Custom QR Painter:** Renders a crisp vector QR code with corner finder patterns, timing patterns, data grid, and a central "K" monogram badge.
- **Privacy Assurance:** Accompanied by explicit customer assurance:  
  `رمز تعريفي آمن مشفر — لا يشارك أرقام الهواتف أو وسائل الدفع` (Secure encrypted identity code — does not share phone numbers or payment instruments).
- **Actions:** Primary black button `مشاركة الرمز` and secondary outlined button `حفظ الصورة`.

---

## 3. Financial Boundary Separation & Customer Wallet Concept (Issue #173)
Under navigation group `المالية والمدفوعات`, a proposed row `محفظة كونفرم` is presented with an explicit indicator badge (`مفهوم مالي #173`):
- **Concept Modal:** Displays available balance (`0.00 ج.م`) and pending settlement (`مبالغ قيد التسوية: 1,200 ج.م (طلب استرداد معتمد)`).
- **Strict Governance Disclaimer:** The modal features an explicit, prominent financial boundary disclosure:  
  `تنبيه الحوكمة المالية: المحفظة والاسترداد المالي قيد الدراسة التشريعية والمالية بموجب القضية #173. لا توجد أي تسوية بنكية أو شحن رصيد فعلي في هذا الإصدار التجريبي.`
- **Strict Separation:** No live financial processing, banking API integration, or automated refund settlement is implemented or claimed. All financial logic remains strictly deferred under Issue #173.

---

## 4. Screen 18 Connected Design Vision: Profile Edit
Screen 17 V2 sets up the future Screen 18 (Profile Edit / تعديل الملف الشخصي) flow:
1. **Avatar Photo Management:**
   - Tap on camera badge or `تعديل الملف` button triggers photo selector (Gallery / Camera).
   - Circular crop tool maintaining 1:1 aspect ratio with zoom and pan.
   - Immediate client-side image compression and preview update.
2. **Handle / Username Claiming (`@username`):**
   - Editable handle field formatted with leading `@`.
   - Real-time client format check (letters, numbers, underscores; 3-20 chars).
   - Displayed as a calm subtitle under the full name in the hero.
3. **Personal Attributes:**
   - Full Name (الاسم الكامل): Cairo Arabic typography, required.
   - Date of Birth & Age Verification: Underage booking prevention gate (18+ requirement).
   - Gender (اختياري / Optional): Non-discriminatory guest preference.
4. **Stay Preferences (تفضيلات الإقامة):**
   - Notification preferences (SMS, WhatsApp, Push).
   - Language selection (العربية canonical default, English optional).

---

## 5. Screen 19 Connected Accounts Vision: Identity Federation
Screen 17 V2 includes a concept navigation row `الحسابات المرتبطة` (`مفهوم مقترح`):
1. **Federated Sign-In Providers:**
   - Apple Sign-In linking ("تسجيل الدخول باستخدام Apple").
   - Google Sign-In linking ("تسجيل الدخول باستخدام Google").
2. **Secondary Verified Contact Channels:**
   - Secondary mobile number addition with OTP verification.
   - Secondary recovery email for booking receipts.
3. **Session & Security Management:**
   - Active device sessions list (Device type, OS, last active timestamp, city).
   - "تسجيل الخروج من جميع الأجهزة الأخرى" (Revoke all other sessions).

---

## 6. Physical Hardware Captures on Samsung Galaxy A56 5G

All 15 scenarios were captured directly from a physical Samsung Galaxy A56 5G running the standalone Flutter APK:

| Scenario | File Name | Size (Bytes) | PNG SHA-256 | Description |
|---|---|---|---|---|
| `authenticatedFlagshipTop` | `01_screen17_v2_a56_flagship_hero_top.png` | 245,418 | `61e9acab06a551d0da4aa87f6c626db074e0e46f7382f8b5b535db187525886a` | Flagship hero top fold with 104dp portrait, display name, handle, shortcuts, and stay card |
| `authenticatedFlagshipScrolled` | `02_screen17_v2_a56_flagship_hero_scrolled.png` | 185,574 | `92d85168094516b6841b7003d1ad8d53ebeda4193ba0022da4241dfd0faa42da` | Scrolled view showing grouped navigation cards, left-pointing chevrons, and share strip |
| `authenticatedNoPhotoFallback` | `03_screen17_v2_a56_no_photo_initials_fallback.png` | 173,856 | `24438a3088bf36b02dd5692d95bad8a0732e1a31bd6835f58d895094a6387ed6` | Clean initials fallback avatar container when customer has not uploaded a photo |
| `authenticatedIncompleteProfile` | `04_screen17_v2_a56_incomplete_profile_prompt.png` | 166,695 | `04c8e7159f1cfc1c1f272b6cff3d2f2e6660e0881c9ad50a4ec9831d50b5e792` | Gentle profile completion card ("أكمل ملفك الشخصي") with action button |
| `guestUnauthenticated` | `05_screen17_v2_a56_guest_unauthenticated.png` | 88,980 | `f4f2b83a381d7191c78d864f8fb159cd9d1b20b525fb5199208d52538203a7bb` | Guest state presenting welcome card and login button with zero private data leakage |
| `initialLoadingSkeleton` | `06_screen17_v2_a56_initial_loading_skeleton.png` | 60,628 | `6a70f1e3ace6184175e2f472697289204b4a775171e724847d772e99250905d5` | High-fidelity shimmer skeleton cards simulating initial network retrieval |
| `networkErrorInitial` | `07_screen17_v2_a56_network_error_initial.png` | 82,980 | `a3e73d69bfdca8d3151d798c023260f8af72c5ec40780239282b5355ac3a1e12` | Full-screen initial load network error state with retry action button |
| `sessionExpired401` | `08_screen17_v2_a56_session_expired_401.png` | 84,527 | `8989630abaed602a677b9bbba1caa0368f25a36ca89d9e7a04040121f7860b08` | Session expired notice with complete profile purge, requiring re-authentication |
| `qrModalMyCode` | `09_screen17_v2_a56_qr_modal_my_code.png` | 201,526 | `992cb02d7bd794c72ce33904aab8a93a630aa8d20600ed3ac63a4890860d4a0a` | Personal QR bottom sheet showing user code, monogram, and privacy assurance |
| `qrModalScan` | `10_screen17_v2_a56_qr_modal_scanner.png` | 183,706 | `d1e748d4548b04c66abea28c0371b332296e8345cc4d7ee6bf46182029029e9e` | QR scanner tab preview demonstrating camera viewfinder interface |
| `walletModalConcept` | `11_screen17_v2_a56_wallet_modal_concept.png` | 209,645 | `100ed88d8c9778446914be22b7cb97395931cd9ff2bf2e70a972a3ede397f2ec` | Proposed customer wallet concept modal with explicit governance disclaimer |
| `logoutConfirmationDialog` | `12_screen17_v2_a56_logout_confirmation_dialog.png` | 236,280 | `9931bd2313a5456271fbdff750f05cdea0a5c1b3e300339aa5b253f7c887364a` | Modal confirmation dialog asking to confirm sign out with clear actions |
| `compactHeroVariant` | `13_screen17_v2_a56_compact_hero_variant.png` | 237,549 | `8bc7d5f8563d0e943741631780a18e58afc19da47b6114b34fa5466a84855e02` | Compact identity card layout demonstrating flexibility across smaller device heights |
| `accessibility200Top` | `14_screen17_v2_a56_accessibility_200_top.png` | 229,628 | `553071c7ff0f1fbb3fdae51338bd94712044b7a559ab74a827ce216a918a1e49` | Top fold reflowing cleanly at 200% font scale with zero RenderFlex overflow |
| `accessibility200Scrolled` | `15_screen17_v2_a56_accessibility_200_scrolled.png` | 164,154 | `ac3fef8549cf263adab84931df435172dbf0537678bad60f296107dd30457e38` | Scrolled view at 200% font scale showing bottom navigation clearance |

---

## 7. Quality Gates & Verification Evidence
- **Source-Linked Tests:** 21/21 PASS (100% pass rate) via `mobile/apps/customer_app/test/screen17_source_linked_tests.dart`.
- **Static Analysis:** `0 issues found` via `flutter analyze`.
- **Zero Developer Controls in Visuals:** All developer toggles and scenarios are controlled strictly through ADB keycodes; zero QA buttons appear in customer screenshots.
- **Physical Hardware Execution:** Verified on genuine Samsung Galaxy A56 5G hardware over ADB.
- **Cross-Screen Consistency:** Bottom navigation, card containers, typography, and spacing match approved Screens 12, 15, and 16.
- **Evidence Immutability Compliance:** All artifacts published into new additive directory `review-evidence/customer-screen17/v2-premium/`; all historical Screen 17 V1 evidence preserved 100% intact under `review-evidence/customer-screen17/v1/`.
