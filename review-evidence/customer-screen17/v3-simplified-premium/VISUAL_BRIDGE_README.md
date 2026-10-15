# KONFRM Customer Screen 17 V3 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 17 — Account Home / Simplified Premium («حسابي — مساحتي في كونفرم») [V3 Founder UX Recomposition]  
**Status:** `SCREEN17_SIMPLIFIED_PREMIUM_AWAITING_BRIDGE_FOUNDER_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen17-design-review`  
**Governing Issues:**
- [GitHub Issue #170](https://github.com/Essxm01/KONFRM/issues/170) (Founder UX Recomposition & Visual Decisions)
- [GitHub Issue #174](https://github.com/Essxm01/KONFRM/issues/174) (Explore Header Notification Bell & Navigation Contract Reconciliation)
- [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Priorities & Cross-Screen Consistency)
- [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar, QR & Connected Profiles)
- [GitHub Issue #173](https://github.com/Essxm01/KONFRM/issues/173) (Customer Wallet & Financial Boundaries)
- [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Historical Evidence Directory Immutability)
- [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 15 V3 Simplified Premium screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen17_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `authenticatedFlagshipTop` | `01_screen17_v3_a56_flagship_hero_top.png` | 249,128 | `b744595cd48d4143f8e9dc8285e9306e5841c40648627799707281bffe42d77f` | `572b45c3527e6dbe937c94633d820d61e7f1d91f9c70a4b3aa689152644be229` |
| 02 | `authenticatedFlagshipScrolled` | `02_screen17_v3_a56_flagship_hero_scrolled.png` | 172,755 | `634a76ca6ba94b41093d74520a33ff4027d5cbf54c61892a92d40b40b6311f55` | `0dd802258ec25707366354e8fe96cda1bf7386d2eeb0f191d445b3569037ea92` |
| 03 | `authenticatedNoPhotoFallback` | `03_screen17_v3_a56_no_photo_initials_fallback.png` | 178,795 | `6ba548afa879f837785c5c1f5cdea3bd05d96f4a8b95c716da6330f14dfdaaef` | `548feb5b24337eac0e450458af97ebde8aa4e8829e4fe80711a29691e21b8f5d` |
| 04 | `authenticatedIncompleteProfile` | `04_screen17_v3_a56_incomplete_profile_prompt.png` | 170,752 | `9f2d1bf72312cb617875f653157f0a58c5587a4a20877ff0d22b60f9a4763015` | `78df45c682ace063520fa8fc8b752430d1ff3a69e9e136d7cd28cc62376e1ca7` |
| 05 | `guestUnauthenticated` | `05_screen17_v3_a56_guest_unauthenticated.png` | 89,117 | `869aa355aec6da0a2f754dc486478b4eb0ee82bc87d7a5a311a18e9844813df1` | `e65bc8078964e522f99306514136ce250a5443f63a965eb24e926abb422b81e3` |
| 06 | `initialLoadingSkeleton` | `06_screen17_v3_a56_initial_loading_skeleton.png` | 59,915 | `d60361b61b03294fd7c3e4214083af896397ab1667653f9d6cab04786ee9ac54` | `6a764b2c7fa7c8985050004f61c214e780f6a7cd4554a1a45bc4e9e149378f13` |
| 07 | `networkErrorInitial` | `07_screen17_v3_a56_network_error_initial.png` | 82,664 | `305fe34708c95d3c43c29de8f89bc1d70a4b220b3a340c584feacac8ce995b5a` | `c53fe2b69c53149d19447aacc3722ab01f40861f0ba29692893c5b95f9425ea4` |
| 08 | `sessionExpired401` | `08_screen17_v3_a56_session_expired_401.png` | 84,484 | `63d4e00e086a766d583466fcb1af699aaed238fc2b7bf6009acafc6a6ce9c113` | `062a4c75e0df04ea237302e817600d87dee394ea325f65f0ed0c445a74e22c20` |
| 09 | `qrModalMyCode` | `09_screen17_v3_a56_qr_modal_my_code.png` | 188,162 | `8d2a2d3bd658a75dd477070eac01f773bf3103a4dd578a9053a110165b3506b2` | `676b9768b77ed9a7ac50c3d08604b84a1b9064ea5ba5777ec1b5e49fe5d47b7d` |
| 10 | `qrModalScan` | `10_screen17_v3_a56_qr_modal_scanner.png` | 188,781 | `391aa933474a6d27b70377abab114c47ac337e9fa5032b7e0f23f6eb33c38d76` | `34d9c50d12be2ed82a529def441d994f62634db5f3ed2060896d16dc29511a55` |
| 11 | `walletModalConcept` | `11_screen17_v3_a56_wallet_modal_concept.png` | 220,496 | `cbdab47bdcaf8636ce6016dccecd9676177c70ae409d5d0d7222d26986f6d904` | `b3bbccbe410244bc877a32fa233c146c903d34d551da7ecbae0b0319b762a62e` |
| 12 | `logoutConfirmationDialog` | `12_screen17_v3_a56_logout_confirmation_dialog.png` | 238,634 | `4a7ba687589293882add47b7cb018219af47bade89fb271087bacca2861b04f6` | `4d248066eeaf6e007336a1cf5066df08f16ba92895ce4e5d59080b81e75bfe8c` |
| 13 | `compactHeroVariant` | `13_screen17_v3_a56_compact_hero_variant.png` | 227,002 | `7479a878e4c75569843f53da2842203a892e4123be462ea76366aa4982b6a024` | `e2d970b94e90ddcaf9cd6bfb0139fe4ad359bf768d9236fad976940ab21059fb` |
| 14 | `accessibility200Top` | `14_screen17_v3_a56_accessibility_200_top.png` | 234,897 | `b3223527f89b52f057b91e65d014d403009c08abff7134560dcfae84a4c04056` | `dc76c1803e32e709874923b9e374b5390f523768addc33aef840b15e38cc3057` |
| 15 | `accessibility200Scrolled` | `15_screen17_v3_a56_accessibility_200_scrolled.png` | 142,868 | `fff0aba5e7ab95e77610c3a7033367f1933f063c3572f33878500404671019fd` | `c965ffe56f9ddaba0d452e2571d16e915b75da9b8178435058c7c14e883d0a09` |

---

## 2. Mirrored Review Sources Hashes

- **Preview Runner Source:** `review-source/screen17_preview_runner.dart`  
  SHA-256: `ed24156a477872df416afec34c1663f3863dc0e0e97c65f0ed0b68a06b087d83`
- **Behavioral Test Suite:** `review-source/screen17_source_linked_tests.dart`  
  SHA-256: `ad2e955c6d804860438029a4c9698c45bf9802f7fe86911d1c031f0d9b6da03e`
- **Studio Portrait Asset:** `review-source/screen17_demo_portrait_bytes.dart`  
  SHA-256: `d84fab1b8219082a62443c89c0e8dfd2aed47a7d8d81d3be97a8c09e3a640901`

---

## 3. Automated Test Suite & Static Analysis Results

- **Test Suite Pass Rate:** 21/21 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues / 0 warnings.
