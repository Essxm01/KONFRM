# KONFRM Customer Screen 17 V2 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 17 — Account Home / Personal Passport («مساحتي في كونفرم») [V2 Native Flagship Visual Design]  
**Status:** `SCREEN17_V2_PREMIUM_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen17-design-review`  
**Governing Issues:**
- [GitHub Issue #170](https://github.com/Essxm01/KONFRM/issues/170) (Founder Reset & Direction)
- [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Priorities & Consistency)
- [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar, QR & Connected Profiles)
- [GitHub Issue #173](https://github.com/Essxm01/KONFRM/issues/173) (Customer Wallet & Financial Boundaries)
- [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Historical Evidence Directory Immutability)
- [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 15 V2 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen17_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `authenticatedFlagshipTop` | `01_screen17_v2_a56_flagship_hero_top.png` | 245,418 | `61e9acab06a551d0da4aa87f6c626db074e0e46f7382f8b5b535db187525886a` | `386d8f32ef4333d7b2ef47f67d3edb2403204a40605bbe140463bba3730677c3` |
| 02 | `authenticatedFlagshipScrolled` | `02_screen17_v2_a56_flagship_hero_scrolled.png` | 185,574 | `92d85168094516b6841b7003d1ad8d53ebeda4193ba0022da4241dfd0faa42da` | `287b781f7326d71d890e5e70ecb8b07d657f67cfa176b3d8ee3cf10000c27dab` |
| 03 | `authenticatedNoPhotoFallback` | `03_screen17_v2_a56_no_photo_initials_fallback.png` | 173,856 | `24438a3088bf36b02dd5692d95bad8a0732e1a31bd6835f58d895094a6387ed6` | `cf7d6e36cd5c04014f5fae5a69d313a4c82f51bf3561502b9fe32072a9b844cd` |
| 04 | `authenticatedIncompleteProfile` | `04_screen17_v2_a56_incomplete_profile_prompt.png` | 166,695 | `04c8e7159f1cfc1c1f272b6cff3d2f2e6660e0881c9ad50a4ec9831d50b5e792` | `245e45477eced3a797ab62f0303e46bfa9c6d630820ac06fb999af50d4249530` |
| 05 | `guestUnauthenticated` | `05_screen17_v2_a56_guest_unauthenticated.png` | 88,980 | `f4f2b83a381d7191c78d864f8fb159cd9d1b20b525fb5199208d52538203a7bb` | `03255d068dbcedfccc284e98e709ca3d10772aae7b496265edb824bd58f90cd0` |
| 06 | `initialLoadingSkeleton` | `06_screen17_v2_a56_initial_loading_skeleton.png` | 60,628 | `6a70f1e3ace6184175e2f472697289204b4a775171e724847d772e99250905d5` | `3bde2136025e3c5d9c42fa9bd8e5ff3b846f1374977ce49c091b122bdf50951c` |
| 07 | `networkErrorInitial` | `07_screen17_v2_a56_network_error_initial.png` | 82,980 | `a3e73d69bfdca8d3151d798c023260f8af72c5ec40780239282b5355ac3a1e12` | `51abdefb419b853efeb9f4a13e377bbd08e6bdce1265c60b741579923847714b` |
| 08 | `sessionExpired401` | `08_screen17_v2_a56_session_expired_401.png` | 84,527 | `8989630abaed602a677b9bbba1caa0368f25a36ca89d9e7a04040121f7860b08` | `87e1e43fcbec79425f121a4295432612e7d4e0874575aa96ee0770eb5569e4b5` |
| 09 | `qrModalMyCode` | `09_screen17_v2_a56_qr_modal_my_code.png` | 201,526 | `992cb02d7bd794c72ce33904aab8a93a630aa8d20600ed3ac63a4890860d4a0a` | `7de45b8d956639f11f808c31a153e56ffc8de25e8a164b778d9e4d181c339d9a` |
| 10 | `qrModalScan` | `10_screen17_v2_a56_qr_modal_scanner.png` | 183,706 | `d1e748d4548b04c66abea28c0371b332296e8345cc4d7ee6bf46182029029e9e` | `b7046df1b7c6fce81d9e96e3e5f3b465f58f114f91ed8a637581fd9ecc0646c1` |
| 11 | `walletModalConcept` | `11_screen17_v2_a56_wallet_modal_concept.png` | 209,645 | `100ed88d8c9778446914be22b7cb97395931cd9ff2bf2e70a972a3ede397f2ec` | `4b7bb235804fd25d953d8653f86899dfd27813c3d8dd496c0397de252850e9f1` |
| 12 | `logoutConfirmationDialog` | `12_screen17_v2_a56_logout_confirmation_dialog.png` | 236,280 | `9931bd2313a5456271fbdff750f05cdea0a5c1b3e300339aa5b253f7c887364a` | `62232db013a2f9d43b1fc3801eef01c1b8787dce65328ebd9049435107f6ea10` |
| 13 | `compactHeroVariant` | `13_screen17_v2_a56_compact_hero_variant.png` | 237,549 | `8bc7d5f8563d0e943741631780a18e58afc19da47b6114b34fa5466a84855e02` | `a7530055c3ae24572d68da3beab04fdfd76466de026b738d37c3ef251165c6ae` |
| 14 | `accessibility200Top` | `14_screen17_v2_a56_accessibility_200_top.png` | 229,628 | `553071c7ff0f1fbb3fdae51338bd94712044b7a559ab74a827ce216a918a1e49` | `6de56353fb6db462fb65eb965b106c25a7212a4762b9dbd6041b19c3d1c01ece` |
| 15 | `accessibility200Scrolled` | `15_screen17_v2_a56_accessibility_200_scrolled.png` | 164,154 | `ac3fef8549cf263adab84931df435172dbf0537678bad60f296107dd30457e38` | `7d7920a201ee16d019983db0d15e3789aea2bce0613bf1381b1da2b3a26abd83` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen17_preview_runner.dart`  
  SHA-256: `8ed9f19dc0517722f6eb74dfb5bae1de58b941e79655e0e448b51d2941ff8b1b`
- **Behavioral Test Suite:** `review-source/screen17_source_linked_tests.dart`  
  SHA-256: `9f0b493027d056e980d621c7d0c9a8f6ac25b57e4fc5a2669d3d14b890a9e284`
- **Studio Portrait Asset:** `review-source/screen17_demo_portrait_bytes.dart`  
  SHA-256: `d84fab1b8219082a62443c89c0e8dfd2aed47a7d8d81d3be97a8c09e3a640901`
- **Test Suite Result:** 21/21 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Flagship Visual Architecture & Invariants Compliance

1. **Editorial Portrait Hero:** 104dp circular avatar with genuine consenting studio portrait (`Ahmed` / `أحمد مصطفى`), accompanied by an overlapping true-black camera badge (`#000000`).
2. **Founder Identity Privacy Invariant:** Telephone number and email are EXPLICITLY NOT rendered in the primary hero fold, preserving customer privacy on shared screens.
3. **Discrete Header Navigation:** Header features page title "حسابي" on the physical right (RTL), and a discrete 44x44dp Personal QR affordance on the physical left. Zero developer or debug controls are exposed in captured visuals.
4. **Fast Shortcuts Row:** 3-column equal-width shortcut tiles (حجوزاتي, المفضلة, الإشعارات) with an active unread notification counter badge.
5. **Contextual Upcoming Stay:** Hero reservation banner presenting upcoming trip details (`فيلا فاخرة بإطلالة مباشرة على البحر - مراسي`), dates, and forward progression affordance.
6. **Deterministic Physical Chevron Directions:** All row navigation affordances to deeper surfaces point physically **LEFT** (`<`) on hardware pixels, matching forward progression in RTL Arabic.
7. **Monochrome Surface Palette:** Strict adherence to `#FFFFFF` surfaces, `#F9FAFB` canvas, `#F3F4F6` soft containers, `#E5E7EB` borders, `#000000` text/CTA. Zero generic blue styling.
8. **Canonical Shared Bottom Navigation:** 4-tab `CustomerBottomNavigation` with **Account (Tab index 3) active**, matching approved Screens 12, 15, and 16.
9. **Personal QR Code Experience:** High-contrast procedural QR code modal with dual tabs (`رمزي` / `مسح رمز`) and privacy assurance disclaimer.
10. **Financial Boundary Separation:** Concept wallet modal explicitly discloses regulatory study status under Issue #173; no live financial balance or charging is simulated.
11. **200% Font Scale Robustness:** Verified with zero RenderFlex overflow across top header, portrait hero, shortcut cards, upcoming stay, grouped sections, and modals.
