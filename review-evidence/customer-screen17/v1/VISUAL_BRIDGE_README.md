# KONFRM Customer Screen 17 V1 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 17 — Account Home (الحساب) [V1 Native Visual Design]  
**Status:** `SCREEN17_V1_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen17-design-review`  
**Governing Issues:** [GitHub Issue #170](https://github.com/Essxm01/KONFRM/issues/170) (Account Home UI/UX), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Consistency), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Technical/QA), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 14 V1 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen17_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `authenticatedCompleteTop` | `01_screen17_v1_a56_authenticated_complete_top.png` | 151,905 | `09cde8082aace401f592748842004e8c6556d845da689c56ee72bd8d09a4db3d` | `5a63a303614ab0c9ea9f7ffbd59f2632fc5dc5516adcdbe3d4c996c5f884c3c7` |
| 02 | `authenticatedCompleteScrolled` | `02_screen17_v1_a56_authenticated_complete_scrolled.png` | 126,821 | `716dc7103b059dbc9ebd2c6d2a05854cdeef3cf2a88d0edfc999f39f3efa29d7` | `546499ee06a32aaefc8186f36d5ab6b362f5cfccff581fb4c1db407aa30e3a6d` |
| 03 | `incompleteProfilePrompt` | `03_screen17_v1_a56_incomplete_profile_prompt.png` | 156,528 | `13d70df0e83346caf9b98e24149a71c16e35134f2c9f4e1a70e71790b418b5ce` | `e52e0437753d651e7273ac7b15a3be1fd0b0033e86c1dfb7806b57d2ae7f74fa` |
| 04 | `guestUnauthenticated` | `04_screen17_v1_a56_guest_unauthenticated.png` | 109,893 | `55a55dec69bcea88d4b767c951e6832a09710177c1df0d0687830eb832ed22f1` | `a1f480491b0e22fbf3dc82df53053c4289314d14abe7b64b6513882844c49594` |
| 05 | `initialLoadingSkeleton` | `05_screen17_v1_a56_initial_loading_skeleton.png` | 59,188 | `9e3d46e31bee79cc997c7a9cf6427e23379558f9cf174608fe2dd585e2c20ed4` | `4f4009014375effe27850c033495cb714ddf61d28e9f4f7b27a3e351f56b455e` |
| 06 | `networkErrorInitial` | `06_screen17_v1_a56_network_error_initial.png` | 83,160 | `a64a07416528c23f16932af8bd36193d7e7e90458c85a5808e67f3ef9bf505f9` | `430da10f150b63eca690c604876645f0bea38a5258b1197afa7fd6791b0662b7` |
| 07 | `staleRefreshError` | `07_screen17_v1_a56_stale_refresh_error.png` | 154,333 | `96c5eb7042103f8f4a4f733e91dedba1c83446167ac78649f8651ace027d21ed` | `a96bfea4724aedf2fa877c1feb15bf94f52c60ff47c5e6773d20b7ca3047578a` |
| 08 | `sessionExpired401` | `08_screen17_v1_a56_session_expired_401.png` | 83,788 | `390a7db4e8c0ab6f1ddbcad96130d6b48ff8d33e906d9ceb37cbc12b44a4257b` | `894c7659e5699e7cbad1541f9b484693c43340c40e878f5582aaa736c21e6256` |
| 09 | `identityIntegrityFailure` | `09_screen17_v1_a56_identity_integrity_failure.png` | 93,037 | `db02dd9d76803c1194961daaf266752716fa8f66c84f20ac65126e9984233172` | `8e0688e1449519b8dff39dff69daf3f179639cae25c29bfb64a8d05b14834500` |
| 10 | `logoutConfirmationDialog` | `10_screen17_v1_a56_logout_confirmation_dialog.png` | 149,176 | `4eeb0b8fc331eb1dd90c36ede8be497d2bb0b9aea96e77893f305094eec8340f` | `253937fad50c282c7d366b0dc2fc5b3a93293943e6be1801262bb9e8d670d347` |
| 11 | `navigationInteractionFeedback` | `11_screen17_v1_a56_navigation_interaction_feedback.png` | 142,928 | `425598d5be9cee6918beaefbc351ae82bf87bb464d538c20b1fd4b16107fb533` | `44507210d3186e7ce5c282c22e4ec308f0d7fed0d8443cc7f505bd6de11f775f` |
| 12 | `verifiedEmailVariant` | `12_screen17_v1_a56_verified_email_variant.png` | 156,470 | `08a0be99fb5538dcb9540c472021e6d5202bdc6c6d5a7c9665d6fbe051888275` | `2fc15f015628aaf02f5cfaeef969bc5a0844bf10a02eeb27ccb874fd928f9b1c` |
| 13 | `accessibility200Top` | `13_screen17_v1_a56_accessibility_200_top.png` | 133,751 | `4ec86c51169300f34b7ab0cb92a987aa29a8b0acec1a37c4c55bebb33bc74a69` | `79c846649b6325b66957547e9264446f4c914c3863ee109d9969f99a5233088e` |
| 14 | `accessibility200Scrolled` | `14_screen17_v1_a56_accessibility_200_scrolled.png` | 139,111 | `3a955e0e3cbdf89c42978201a34659dab469859a65f158db64a1c8b630e1dbb0` | `39ffbeb59806b24d0ca1ba069fca8a69c589cd732118e07b12eff71555a8fd7f` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen17_preview_runner.dart`  
  SHA-256: `e58cbd6f7c27ab103e34598c742b32f5a9115dd2e601f7a7a16feb8be731bfca`
- **Behavioral Test Suite:** `review-source/screen17_source_linked_tests.dart`  
  SHA-256: `2bfd3be61a29e5d2437fc0c4894b4ffb89bb4f58a376c88ae616e625b182f2fb`
- **Test Suite Result:** 20/20 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Visual System & Invariants Compliance

1. **Cairo RTL Typography & Header:** Root page title "حسابي" rendered in bold Cairo on the physical right.
2. **Deterministic Physical Chevron Directions:** All row navigation affordances to deeper surfaces point physically **LEFT** (`<`) on hardware pixels, matching forward progression in RTL Arabic.
3. **Monochrome Surface Palette:** Strict adherence to `#FFFFFF` surfaces, `#F9FAFB` canvas, `#F3F4F6` soft containers, `#E5E7EB` borders, `#000000` text/CTA. Zero generic blue styling.
4. **Canonical Shared Bottom Navigation:** 4-tab `CustomerBottomNavigation` with **Account (Tab index 3) active**, matching approved Screens 12, 15, and 16.
5. **Verified Identity & Privacy:** Masked phone (`+20 10••••5678`) rendered with explicit LTR isolation (`<bdi>`), preventing number scrambling in RTL Arabic.
6. **Incomplete Profile Prompt:** Gentle notice card when `fullName` is missing, with clear "إكمال البيانات" action.
7. **Session Expiry (401) Isolation:** Private customer details completely purged on 401; zero cached cards are displayed.
8. **200% Font Scale Robustness:** Verified with zero RenderFlex overflow across top header, identity card, grouped sections, and modal dialogs.
