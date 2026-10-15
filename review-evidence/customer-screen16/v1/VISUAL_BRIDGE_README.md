# KONFRM Customer Screen 16 V1 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 16 — Notification Center (مركز الإشعارات) [V1 Native Visual Design]  
**Status:** `SCREEN16_V1_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen16-design-review`  
**Governing Issues:** [GitHub Issue #168](https://github.com/Essxm01/KONFRM/issues/168) (Notification Center UI/UX), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Cross-Screen Consistency), [GitHub Issue #167](https://github.com/Essxm01/KONFRM/issues/167) (Deferred Technical/QA), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 14 V1 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen16_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `readyListTop` | `01_screen16_a56_ready_list_top.png` | 215,157 | `3140507dbd05956cd90c4eaf816d066ccc46b815b8a2c9a1fe185902a2fe57bd` | `034421ec3eb5cc024298863176177f853a963919919335051c4687d5ee2a2434` |
| 02 | `readyListScrolled` | `02_screen16_a56_ready_list_scrolled.png` | 180,086 | `96dbf83569066447595e2e57e2507433097b0bba34845ad83f3c06f7cc30b51e` | `b68bef5b465a11829ca8c0b1ea704bdd4df71ee70e48ebb0e5eb741e5dbd960e` |
| 03 | `emptyNoNotifications` | `03_screen16_a56_empty_no_notifications.png` | 94,207 | `af5a3d0368fc688e62c1d46d90dff74c7d9e5d81a9fd985c5e0aa0cd46ee94d8` | `d6f81c7280fbb6869cd45dcef0c452640e4e2742a85e798a704817df850c9838` |
| 04 | `initialLoading` | `04_screen16_a56_initial_loading.png` | 70,798 | `9595c5e1da43a0ab95523a6900818a0e7761ec5a788107db3d426a3adc95d760` | `8f825b6e6a048ecb950f2629aea3b5edfea46dd6b9f82609e6840f5e54956361` |
| 05 | `staleRefreshError` | `05_screen16_a56_stale_refresh_error.png` | 210,778 | `30a0069750aa54677f817b6fa18ca3bebe140f20e999acf16aca719cb668dc91` | `1559ecb93751810ba784b18a2f2d549ffe42295d4177f689fa4ac1a8078a5ed3` |
| 06 | `networkErrorInitial` | `06_screen16_a56_network_error_initial.png` | 90,133 | `371e27ca2311a3449b2d4fa0fe75daab32b2264caf11d0edfe12c697a0c626a5` | `132211bb64ea4b494b61afaf0ed1cd3f8345be47213b6647bdfe704e84c0bc9d` |
| 07 | `sessionExpired401` | `07_screen16_a56_session_expired_401.png` | 92,292 | `c5c6cf665261069ea8b8e53b74b7fd16d0e27cf36235e5e5efd3f797a84fb34d` | `708b86f0a3e3a15dd4cf74667d59074869e551a27821f953dfe88d08d717f3fa` |
| 08 | `actionRequiredDetail` | `08_screen16_a56_action_required_detail.png` | 189,334 | `6a7d28d3eccd756500d9b4506ac64fb7c75f719132ea39b7dd2adc5229b8ed13` | `8f25ca01db34a9d837e5d129d5bcbc7e22bbb230e9c1c8d3319a779be0c0114a` |
| 09 | `missingDestinationDialog` | `09_screen16_a56_missing_destination_dialog.png` | 181,311 | `ae68d07e4a351756af0fa427962cc8d0e420a2db5ba45f9e2a8f1fcb22e458cc` | `87adc507f1972ea02a88b67054839d03acafa3b2e5f7f23cd27336b672058315` |
| 10 | `singleCardFocus` | `10_screen16_a56_single_card_focus.png` | 189,334 | `6a7d28d3eccd756500d9b4506ac64fb7c75f719132ea39b7dd2adc5229b8ed13` | `8f25ca01db34a9d837e5d129d5bcbc7e22bbb230e9c1c8d3319a779be0c0114a` |
| 11 | `rejectionCardFocus` | `11_screen16_a56_rejection_card_focus.png` | 197,083 | `62996faf1b66fff0f9905dee42661ce05710857e2f4eb379f10ce35b38f54384` | `d88be24d3bb0c9edfaabe9643744ff250a6d18e0e75cd292154767df42a3d0d6` |
| 12 | `readUnreadToggled` | `12_screen16_a56_read_unread_toggled.png` | 210,702 | `22a90d62b2223540c13dd139b2c8544df4c0e6cc426ec7c4914aadbe8f439c5f` | `38207484c317c26e4033bed1f4e838870ebaab205ebbd27a5ef7485547d1a598` |
| 13 | `accessibility200Top` | `13_screen16_a56_accessibility_200_top.png` | 179,698 | `cf61aead1739bfb7b55b93269e67b7b046a5b13fa466ca553efd481c9c631768` | `882973e9a7435cb2376052282d742efe0c6fbc94d18a032d027d32eb63418f72` |
| 14 | `accessibility200Scrolled` | `14_screen16_a56_accessibility_200_scrolled.png` | 182,981 | `90e06bf213ce7eeb610ca271997dd2b8abeed714cf7c047e2b916a79d51b0fd2` | `dcbfe2481c834cf134985c2b69ae397a86e020ab2b692c8f9e6e0d87e5e8a707` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen16_preview_runner.dart`  
  SHA-256: `21bbeea7c9cee0784f175002cc967ad7ce254059c411af9e2ef5f64d40eb5427`
- **Behavioral Test Suite:** `review-source/screen16_source_linked_tests.dart`  
  SHA-256: `5bd63b6d999a2ab4803077ffd9bff01079fad65a3426f193d195707b8686a3c6`
- **Test Suite Result:** 15/15 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Visual System & Invariants Compliance

1. **Cairo RTL Typography:** Fully native Arabic-first layout (`TextDirection.rtl`), using Cairo font weights 800/700/600/500 with zero artificial left-to-right reversals.
2. **Monochrome Surface System:** Strict adherence to `#FFFFFF` surfaces, `#F9FAFB` canvas, `#F3F4F6` soft containers, `#E5E7EB` borders, `#000000` text/CTA. Zero generic blue styling.
3. **Canonical Bottom Navigation:** Active destination is strictly **Account (index 3)**, matching the parent screen hierarchy.
4. **Deposit Payment Invariant:** When a booking is approved, copy strictly states that deposit payment is required to confirm the booking (`أصبح دفع العربون الخطوة التالية لتأكيد الحجز`), never claiming the booking is already confirmed.
5. **Session Expiry (401) Isolation:** Private customer notifications are completely purged on 401; zero cached cards are displayed.
6. **200% Font Scale Robustness:** Verified with zero RenderFlex overflow across top header, action bar, notification cards, and dialogs.
