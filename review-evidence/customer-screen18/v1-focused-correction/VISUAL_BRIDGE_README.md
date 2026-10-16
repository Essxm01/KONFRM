# KONFRM Customer Screen 18 V1 — Final UX Correction Visual Bridge Manifest

**Screen:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي») [Final Bounded UX & Crop Safety Closure]  
**Task ID:** `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE`  
**Status:** `SCREEN18_V1_FINAL_BOUNDED_CLOSURE_READY_FOR_FOUNDER_DECISION`  
**Target Device:** Samsung Galaxy A56 5G (`SM_A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen18-design-review`  
**Baseline Commit:** `98a1cf9888743971a44a141e05b159f22d6c3e74`  
**Companion Documents:** [`ERRATUM.md`](ERRATUM.md), [`REPORT.md`](REPORT.md)  
**Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176) (Screen 18 Contract), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Mandatory Pure Black `#000000`), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar & QR Boundaries), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Screen 17 Prelive Gate), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Consistency), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen18_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serial is redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

### 1.1 Primary Scenario Captures (Corrected File Lengths)
> **Note on Metadata Supersession:** The byte size column below reflects the exact file byte lengths on disk, superseding previous display memory buffer numbers. All SHA-256 digests and Base64 companion decodings remain 100% verified. See [`ERRATUM.md`](ERRATUM.md) for full audit details.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `accessibility200Scrolled` | `screenshots/01_screen18_gender_options_200.png` | 152,159 | `3B1CCB03264C468FD974E84AE07D01441D25537C2F204F906692B9DCD99120D6` | `C0B69B3E3913DB1D20A2D50798058D06D3C1AFC091BFF4E492AB8265DCBC3096` |
| 02 | `photoCropModal` | `screenshots/02_screen18_fullscreen_crop_modal.png` | 446,373 | `551C011B189B942C3564A421AED3615BB30C1FD08FCBC5BF3CE79C1E09F0C75E` | `CF50A30C8844CB89E93704AD2922DB43520096E4B8EAFF27C8A5FD19F16E55D8` |
| 03 | `appliedCropAvatar` | `screenshots/03_screen18_avatar_applied_crop.png` | 252,220 | `2521885A8CA17FAB08B55D248AC4EF1D470E0535D167C323951520F665A45E54` | `DF6280B62BD6EEF66BC333EC409016CFC574903110F33A5D1F209E07F3CB3F45` |
| 04 | `noPhotoInitials` | `screenshots/04_screen18_no_photo_initials_sheet.png` | 137,258 | `10F9D4ABE331347F0F88307BCB9D4BA6416BF4AC575C4ED998C9C1C03EB42497` | `646445214334D83D487407FFAD922A26BB906D516D6E3D3F5384402724D5736F` |
| 05 | `mainEditTop` | `screenshots/05_screen18_clean_top_fold_100.png` | 239,768 | `ADA353AFB5E5945D39AEEB7D594F22781240A3C67300C641E19B44C3E5DDC446` | `9C9070B3CAB33A359F8D6E4739353F6D0829F1DFF790DC0A12DC7C375F7B00FA` |
| 06 | `mainEditScrolled` | `screenshots/06_screen18_clean_bottom_fold_100.png` | 195,020 | `01CFE3CADD668253B3CBA5C76A29C03D885EFD2DBFCA5E6C5C5BA088EC965120` | `090F958F93ED8C0A8BBCD65108CCD9EA89682F9CEFE7A6B83E0D0867DB5DC12A` |

### 1.2 Physical Hardware Live Interaction Trace (Standalone Empirical Proof)
Captures the live physical interaction on Samsung Galaxy A56 5G without predefined scenario dependencies:

| Step | Interaction Description | File Name | Size (Bytes) | PNG SHA-256 Checksum | Base64 Companion SHA-256 |
|---|---|---|---|---|---|
| 01 | Open photo action sheet from clean profile | `interaction-trace/01_trace_photo_sheet_open.png` | 190,553 | `E23A3856EC4381690E7E645F9D3B166828BC04C58661B4DD6965FECB5B2A6605` | `06413F8C16C82DBC1F096D3E575A0D7C9B2DE183F96E904FF9DAB1FD5A3C0307` |
| 02 | Zoom & Pan image in full-screen crop studio | `interaction-trace/02_trace_crop_modal_zoomed_panned.png` | 453,112 | `73714E50E862587328F44B1DA3F71A62B326CAE366805DFCDE0145E65C7E098C` | `BD9229AF23840777C008C1B8373C2338DFB3E7A6E3718A8469621CB81D840CF4` |
| 03 | Applied crop visibly reflected in avatar + snackbar | `interaction-trace/03_trace_avatar_applied_live.png` | 254,283 | `8F93F57AC729435C0AABD99F94D78F525514796A8BD3EFA27B875A77A7D71D2C` | `56C45516CF9FC22C635C54817ABBF9FBAFE79C8D85C684CA53CAB9D192823A38` |
| 04 | Reopen crop studio, verify persistence, tap Reset | `interaction-trace/04_trace_reopened_and_reset.png` | 435,482 | `19E5680234ECDBB5985A9832A7C26744DC26D1C7A8C684A0EADB8B7B83D681BF` | `1F0CB0BCE8AAE42F30CC0560560C4DC59A2532A74CD41EB04ACAAC26081E0361` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen18_preview_runner.dart`  
  SHA-256: `8A9E9B78D62308BF7500D61B0F23F37036F5126A7A97F44600F6AC31560B3B1E`
- **Behavioral Test Suite:** `review-source/screen18_source_linked_tests.dart`  
  SHA-256: `1B10E0206A3A3EC454733B3E865DC863212084A1BE7E58ADBEC7FF974FB2643A`
- **Portrait Demo Bytes:** `review-source/screen17_demo_portrait_bytes.dart`  
  SHA-256: `D84FAB1B8219082A62443C89C0E8DFD2AED47A7D8D81D3BE97A8C09E3A640901`
- **Test Suite Result:** 29/29 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Summary of Confirmed Corrections & Invariants

1. **Geometry-Derived Pan Bounds & Safe Aperture Coverage (Discrepancy A):**
   - Eliminated arbitrary pan limits (`80.0 * _cropZoom`).
   - Derived mathematically: $\text{maxPan} = 260.0 \times (\text{zoom} - 1.0) / 2.0$.
   - At $1.0\times$ zoom, $\text{maxPan} = 0.0$; the image cannot be dragged outside the circular viewport.
   - Zoom reduction and Reset automatically reclamp offsets to the new tighter geometry bounds.
2. **Founder Exact Pure Black `#000000` (Issue #175):**
   - Replaced charcoal backdrop `Color(0xFF111827)` in crop modal with pure black `Color(0xFF000000)`.
   - Zero charcoal or dark navy values remain across all modal and preview components.
3. **Physical Hardware Live Trace (Discrepancy B):**
   - Complete end-to-end journey proven on Samsung Galaxy A56 5G hardware: Open Sheet → Open Crop → Zoom/Pan → Apply → Verify Avatar Update → Reopen → Reset.
   - Ambient OS accessibility text scaling is respected in normal view; explicit $200\%$ scaling is strictly isolated to the QA scenario.
4. **Evidence Metadata Integrity (Discrepancy C):**
   - All file sizes audited against actual committed files on disk.
   - Bit-level Base64 roundtrip decode parity verified 100%.
