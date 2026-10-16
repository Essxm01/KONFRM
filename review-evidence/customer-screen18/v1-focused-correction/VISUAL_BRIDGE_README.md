# KONFRM Customer Screen 18 V1 — Focused UX Correction Visual Bridge Manifest

**Screen:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي») [Focused UX & Interaction Correction]  
**Task ID:** `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE`  
**Status:** `SCREEN18_V1_BOUNDED_CORRECTION_READY_FOR_BRIDGE_AND_FOUNDER_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM_A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen18-design-review`  
**Baseline Commit:** `a063a1a8e362606dbbc33cafadc66452ac85cda0`  
**Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176) (Screen 18 Contract), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Mandatory Pure Black `#000000`), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar & QR Boundaries), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Screen 17 Prelive Gate), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Consistency), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 6 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen18_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serial is redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `accessibility200Scrolled` | `01_screen18_gender_options_200.png` | 272,393 | `3B1CCB03264C468FD974E84AE07D01441D25537C2F204F906692B9DCD99120D6` | `C0B69B3E3913DB1D20A2D50798058D06D3C1AFC091BFF4E492AB8265DCBC3096` |
| 02 | `photoCropModal` | `02_screen18_fullscreen_crop_modal.png` | 577,419 | `551C011B189B942C3564A421AED3615BB30C1FD08FCBC5BF3CE79C1E09F0C75E` | `CF50A30C8844CB89E93704AD2922DB43520096E4B8EAFF27C8A5FD19F16E55D8` |
| 03 | `appliedCropAvatar` | `03_screen18_avatar_applied_crop.png` | 321,291 | `2521885A8CA17FAB08B55D248AC4EF1D470E0535D167C323951520F665A45E54` | `DF6280B62BD6EEF66BC333EC409016CFC574903110F33A5D1F209E07F3CB3F45` |
| 04 | `noPhotoInitials` | `04_screen18_no_photo_initials_sheet.png` | 288,574 | `10F9D4ABE331347F0F88307BCB9D4BA6416BF4AC575C4ED998C9C1C03EB42497` | `646445214334D83D487407FFAD922A26BB906D516D6E3D3F5384402724D5736F` |
| 05 | `mainEditTop` | `05_screen18_clean_top_fold_100.png` | 316,929 | `ADA353AFB5E5945D39AEEB7D594F22781240A3C67300C641E19B44C3E5DDC446` | `9C9070B3CAB33A359F8D6E4739353F6D0829F1DFF790DC0A12DC7C375F7B00FA` |
| 06 | `mainEditScrolled` | `06_screen18_clean_bottom_fold_100.png` | 278,924 | `01CFE3CADD668253B3CBA5C76A29C03D885EFD2DBFCA5E6C5C5BA088EC965120` | `090F958F93ED8C0A8BBCD65108CCD9EA89682F9CEFE7A6B83E0D0867DB5DC12A` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen18_preview_runner.dart`  
  SHA-256: `0146006120A669C29D2943E4A662D8A77E0B4FA4480498AA55CFF6397FA338EA`
- **Behavioral Test Suite:** `review-source/screen18_source_linked_tests.dart`  
  SHA-256: `A85526BE1D3331121E80931E646498DFECCFCB7E0B470F0D99B7CCC48ED21C5A`
- **Portrait Demo Bytes:** `review-source/screen17_demo_portrait_bytes.dart`  
  SHA-256: `D84FAB1B8219082A62443C89C0E8DFD2AED47A7D8D81D3BE97A8C09E3A640901`
- **Test Suite Result:** 23/23 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Summary of Confirmed Corrections

1. **Meaningful Photo Cropping (Correction A):**
   - Active draft portrait bytes used directly in crop studio.
   - Interactive zoom slider ($1.0\times$ to $2.5\times$) and drag/pan within circular viewport.
   - Applied crop scale and offset commit to `draft` and are visibly mirrored in the $104 \times 104$ avatar hero.
   - Draft marked dirty upon crop changes; Cancel restores prior crop; Reset restores $1.0\times$ zero offset.
   - In no-photo state, Crop and Remove options are hidden from the action sheet; demo bytes are never resurrected.
   - Bottom navigation bar is hidden while the crop modal is open.
2. **200% Accessibility Selection (Correction B):**
   - Dynamic vertical full-width layout for gender selector at text scale $\ge 1.3$.
   - `maxLines: 1` and `TextOverflow.ellipsis` removed; «أفضل عدم الإفصاح» renders in full without truncation.
   - Minimum $48\text{ dp}$ touch target preserved.
3. **Developer Metadata Sanitization (Correction C):**
   - Username badge changed from `مقترح #172` to customer-facing `اسم مقترح`.
   - Helper text updated to natural Arabic copy without technical issue numbers.
   - Security footnote sanitized to remove screen IDs (no `شاشة 19`).
   - Prototype banners and crop disclaimer sanitized to remove issue numbers (no `#176`).
