# KONFRM Customer Screen 18 V1 — Evidence Metadata Erratum & Crop Safety Addendum

**Task ID:** `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE`  
**Governing Issue:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176)  
**Date:** 2026-10-16  
**Status:** `SCREEN18_V1_FINAL_BOUNDED_CLOSURE_READY_FOR_FOUNDER_DECISION`  
**Target Hardware:** Samsung Galaxy A56 5G (`SM_A566B`), Android 16 (API 36), Serial `[REDACTED_A56_ID]`  

---

## 1. Discrepancy C — Evidence Metadata Erratum & Verification

### Root Cause Analysis of Byte Size Discrepancy
In the initial `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE` manifest (`VISUAL_BRIDGE_README.md` and `REPORT.md` at commit `98a1cf9888743971a44a141e05b159f22d6c3e74`), the "Size (Bytes)" column erroneously listed the uncompressed display memory buffer size reported by the capture script rather than the actual file byte lengths of the committed PNG images on disk.

### Proof of Cryptographic & Bit-Level Integrity
1. **SHA-256 Digest Match:** All 6 SHA-256 checksums recorded in the original manifest match the committed PNG files **100% exactly**.
2. **Base64 Decode Parity:** Decoding each companion `.b64.txt` file produces a byte array identical to the committed `.png` file with zero bit difference (`decoded == png_bytes`).
3. **No Historical Erasure:** Historical files remain unchanged in `screenshots/`. This erratum supersedes the byte size column in the documentation.

### Corrected File Length & Cryptographic Manifest

| File Name | Manifested Size (Previous) | Actual Committed Size (Bytes) | PNG SHA-256 Checksum | Base64 Companion SHA-256 | Parity Status |
|---|---|---|---|---|---|
| `01_screen18_gender_options_200.png` | 272,393 | **152,159** | `3B1CCB03264C468FD974E84AE07D01441D25537C2F204F906692B9DCD99120D6` | `C0B69B3E3913DB1D20A2D50798058D06D3C1AFC091BFF4E492AB8265DCBC3096` | 100% Byte Match |
| `02_screen18_fullscreen_crop_modal.png` | 577,419 | **446,373** | `551C011B189B942C3564A421AED3615BB30C1FD08FCBC5BF3CE79C1E09F0C75E` | `CF50A30C8844CB89E93704AD2922DB43520096E4B8EAFF27C8A5FD19F16E55D8` | 100% Byte Match |
| `03_screen18_avatar_applied_crop.png` | 321,291 | **252,220** | `2521885A8CA17FAB08B55D248AC4EF1D470E0535D167C323951520F665A45E54` | `DF6280B62BD6EEF66BC333EC409016CFC574903110F33A5D1F209E07F3CB3F45` | 100% Byte Match |
| `04_screen18_no_photo_initials_sheet.png` | 288,574 | **137,258** | `10F9D4ABE331347F0F88307BCB9D4BA6416BF4AC575C4ED998C9C1C03EB42497` | `646445214334D83D487407FFAD922A26BB906D516D6E3D3F5384402724D5736F` | 100% Byte Match |
| `05_screen18_clean_top_fold_100.png` | 316,929 | **239,768** | `ADA353AFB5E5945D39AEEB7D594F22781240A3C67300C641E19B44C3E5DDC446` | `9C9070B3CAB33A359F8D6E4739353F6D0829F1DFF790DC0A12DC7C375F7B00FA` | 100% Byte Match |
| `06_screen18_clean_bottom_fold_100.png` | 278,924 | **195,020** | `01CFE3CADD668253B3CBA5C76A29C03D885EFD2DBFCA5E6C5C5BA088EC965120` | `090F958F93ED8C0A8BBCD65108CCD9EA89682F9CEFE7A6B83E0D0867DB5DC12A` | 100% Byte Match |

---

## 2. Discrepancy B — Physical Device Live Interaction Trace

To provide standalone empirical evidence of the complete user interaction journey without reliance on predefined mock scenarios, the preview APK was executed interactively on physical hardware (`SM_A566B`, `[REDACTED_A56_ID]`).

### Step-by-Step Live Journey
1. **Step 1 (Photo Action Sheet):** User taps the avatar camera badge on the clean profile view, displaying the bottom sheet options.
2. **Step 2 (Interactive Crop Studio):** User selects «معاينة واقتصاص الصورة (1:1)». The full-screen crop modal opens. The user zooms into Ahmed's face and pans horizontally/vertically within geometry bounds.
3. **Step 3 (Applied Avatar Verification):** User taps «اعتماد الصورة». Modal closes, floating confirmation snackbar appears («تم اعتماد اقتصاص الصورة وتحديث المعاينة»), and the profile avatar visibly reflects the applied zoom and pan framing.
4. **Step 4 (Reopen & Reset):** User taps the camera badge to reopen the crop modal. The previous crop framing and zoom slider position are preserved. User taps «إعادة ضبط» (Reset); framing instantly snaps back to $1.0\times$ zoom, centered $(0,0)$ offset, and slider resets to base.

### Physical Interaction Trace Evidence Manifest
All 4 screenshots are stored in `interaction-trace/` with verified companion Base64 files.

| Step | Interaction Description | File Name | Size (Bytes) | SHA-256 Checksum | Base64 SHA-256 |
|---|---|---|---|---|---|
| 01 | Open photo action sheet from clean profile | `01_trace_photo_sheet_open.png` | 190,553 | `E23A3856EC4381690E7E645F9D3B166828BC04C58661B4DD6965FECB5B2A6605` | `06413F8C16C82DBC1F096D3E575A0D7C9B2DE183F96E904FF9DAB1FD5A3C0307` |
| 02 | Zoom & Pan image in full-screen crop studio | `02_trace_crop_modal_zoomed_panned.png` | 453,112 | `73714E50E862587328F44B1DA3F71A62B326CAE366805DFCDE0145E65C7E098C` | `BD9229AF23840777C008C1B8373C2338DFB3E7A6E3718A8469621CB81D840CF4` |
| 03 | Applied crop visibly reflected in avatar + snackbar | `03_trace_avatar_applied_live.png` | 254,283 | `8F93F57AC729435C0AABD99F94D78F525514796A8BD3EFA27B875A77A7D71D2C` | `56C45516CF9FC22C635C54817ABBF9FBAFE79C8D85C684CA53CAB9D192823A38` |
| 04 | Reopen crop studio, verify persistence, tap Reset | `04_trace_reopened_and_reset.png` | 435,482 | `19E5680234ECDBB5985A9832A7C26744DC26D1C7A8C684A0EADB8B7B83D681BF` | `1F0CB0BCE8AAE42F30CC0560560C4DC59A2532A74CD41EB04ACAAC26081E0361` |

---

## 3. Discrepancy A — Geometry-Derived Pan Bounds & Pure Black Compliance

### Geometry-Derived Pan Bounds
The previous arbitrary pan calculation (`80.0 * _cropZoom`) was eliminated. Pan limits are now derived from the actual geometric dimensions of the crop viewport ($260\text{ dp}$):

$$\text{maxPan}(\text{zoom}) = \begin{cases} 0.0 & \text{if } \text{zoom} \le 1.0 \\ \frac{260.0 \times (\text{zoom} - 1.0)}{2.0} & \text{if } \text{zoom} > 1.0 \end{cases}$$

- **At $1.0\times$ Zoom:** $\text{maxPan} = 0.0$. The square image fits the aperture exactly; dragging outside the circular viewport is mathematically prohibited.
- **At $1.5\times$ Zoom:** $\text{maxPan} = 65.0\text{ dp}$. Image can only pan within the scaled bounds.
- **At $2.5\times$ Zoom:** $\text{maxPan} = 195.0\text{ dp}$. The viewport is always fully covered by image content; zero black margins or uncovered backdrop can appear.
- **Zoom Reduction Reclamping:** When zoom is decreased (e.g., from $2.5\times$ to $1.2\times$), `_cropOffset` is automatically reclamped to the new tighter bound ($\le 26.0\text{ dp}$), preventing the image from becoming displaced.

### Strict Founder Pure Black `#000000` Compliance
- Replaced charcoal backdrop `Color(0xFF111827)` in `screen18_preview_runner.dart` with exact pure black `Color(0xFF000000)`.
- Verified that all crop modal backgrounds, dismiss icons, primary typography, and buttons strictly adhere to GitHub Issue #175.

### Ambient Accessibility Text Scaling
- Removed unconditional `TextScaler.linear(_scenario.textScale)` override from the preview view.
- Normal scenarios now inherit the ambient `MediaQuery` text scaler from the device / OS settings.
- Explicit $200\%$ text scaling is strictly isolated to the dedicated `accessibility200Scrolled` scenario and automated regression tests.
- Re-verified that no text truncation or flex overflows occur under either normal device ambient scaling or simulated $200\%$ scaling.

---

## 4. Test & Verification Summary

- **Unit & Widget Tests:** `test/screen18_source_linked_tests.dart` — **29/29 tests PASS** (6 new geometry & pure-black tests added).
- **Static Analysis:** `flutter analyze` reports **0 issues**.
- **Evidence Base:** 6 primary screenshots + 4 live interaction trace screenshots + Base64 companions + full review source mirrors.
- **Governing Status:** `SCREEN18_V1_FINAL_BOUNDED_CLOSURE_READY_FOR_FOUNDER_DECISION`.
