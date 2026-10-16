# KONFRM Customer Screen 18 V1 — Final Bounded UX, Crop Safety & Evidence Closure Report

## Executive Summary
- **Screen:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي»)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Child (CustomerBottomNavigation Tab 3 active)
- **Task ID:** `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE`
- **Status:** `SCREEN18_V1_FINAL_BOUNDED_CLOSURE_READY_FOR_FOUNDER_DECISION`
- **Active Git Branch:** `evidence/customer-screen18-design-review`
- **Baseline Commit:** `98a1cf9888743971a44a141e05b159f22d6c3e74`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145)

---

## 1. Problem Statement & Root Cause Diagnosis

Following independent Bridge visual review of Screen 18 V1 (`a063a1a8e362606dbbc33cafadc66452ac85cda0`) and subsequent bounded verification (`98a1cf9888743971a44a141e05b159f22d6c3e74`), three specific discrepancies were identified for final bounded closure:

1. **Discrepancy A — Arbitrary Pan Limits & Non-Pure-Black Backdrop:**
   - *Diagnosis:* The crop modal previously used an arbitrary pan limit (`80.0 * _cropZoom`), which allowed the photo to be dragged beyond the circular viewport, potentially exposing empty background. Additionally, the crop viewport container used charcoal `Color(0xFF111827)` at line 1963, violating the Founder's strict pure black mandate (Issue #175).
2. **Discrepancy B — Scenario Dependency & Unconditional Text Scaling:**
   - *Diagnosis:* The applied crop evidence relied on predefined scenario state rather than a complete physical device interaction trace. Furthermore, the preview runner unconditionally forced `TextScaler.linear(_scenario.textScale)` across all screens, preventing natural validation of ambient OS accessibility settings.
3. **Discrepancy C — Byte Size Discrepancy in Published Manifest:**
   - *Diagnosis:* The initial visual bridge manifest recorded uncompressed memory buffer lengths rather than the actual file byte lengths of the committed PNG images on disk, creating a documentation discrepancy despite 100% cryptographic SHA-256 and Base64 match.

---

## 2. Implemented Corrections & Domain Invariants

### Correction A — Geometry-Derived Pan Bounds & Pure Black Enforcement
- **Geometry-Derived Pan Bound Formula:** Eliminated arbitrary multipliers. The maximum allowed pan displacement in any direction is mathematically derived from the crop viewport dimension ($260\text{ dp}$):
  $$\text{maxPan}(\text{zoom}) = \begin{cases} 0.0 & \text{if } \text{zoom} \le 1.0 \\ \frac{260.0 \times (\text{zoom} - 1.0)}{2.0} & \text{if } \text{zoom} > 1.0 \end{cases}$$
- **Zero Drift at Base Scale:** At $1.0\times$ zoom, $\text{maxPan} = 0.0$. The square image fits the aperture exactly; dragging outside the circular viewport is impossible.
- **Continuous Clamping & Reclamping:** Offsets are clamped upon user pan gestures and automatically reclamped whenever zoom is reduced or reset. Uncovered background or image detachment is mathematically precluded.
- **Strict Pure Black `#000000` (Issue #175):** Replaced `Color(0xFF111827)` with exact pure black `Color(0xFF000000)` in the crop modal container and viewport backdrop.

### Correction B — Physical Device Live Interaction Trace & Ambient Text Scaling
- **Physical Device Interaction Trace:** Executed the complete user interaction journey interactively on the physical Samsung Galaxy A56 5G hardware without predefined scenario mocks:
  1. Open photo sheet from clean profile fold.
  2. Open full-screen crop studio, zoom in on face and pan framing.
  3. Tap «اعتماد الصورة» and verify visibly updated avatar and confirmation snackbar.
  4. Reopen crop studio, verify persistence of zoom/pan, tap «إعادة ضبط» (Reset) to snap back to $1.0\times$ and $(0,0)$.
- **Ambient Accessibility Text Scaling:** Preview views now respect the ambient OS `MediaQuery` text scale. The $200\%$ scaling override is strictly isolated to explicit accessibility testing scenarios and regression tests.

### Correction C — Evidence Metadata Erratum & Bit-Level Audit
- Formally published [`ERRATUM.md`](ERRATUM.md) documenting the memory buffer vs. disk file byte length difference.
- Verified that all 6 primary screenshot SHA-256 checksums match the committed files 100%.
- Verified bit-level roundtrip decode parity for all companion `.b64.txt` files (`decoded == data`).

---

## 3. Physical Hardware Evidence Matrix (Samsung Galaxy A56 5G)

All screenshots were captured directly from the physical Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px) running the standalone Flutter debug APK:

### 3.1 Primary Scenario Captures (Corrected File Lengths)

| Screenshot | Scenario | Actual Size (Bytes) | SHA-256 Digest | Key Verification Point |
|---|---|---|---|---|
| `01_screen18_gender_options_200.png` | `accessibility200Scrolled` | 152,159 | `3B1CCB03264C468FD974E84AE07D01441D25537C2F204F906692B9DCD99120D6` | 200% scale vertical gender tiles showing «أفضل عدم الإفصاح» without clipping or ellipsis |
| `02_screen18_fullscreen_crop_modal.png` | `photoCropModal` | 446,373 | `551C011B189B942C3564A421AED3615BB30C1FD08FCBC5BF3CE79C1E09F0C75E` | Fullscreen pure black `#000000` crop studio with bottom navigation hidden, zoom slider, rule-of-thirds grid |
| `03_screen18_avatar_applied_crop.png` | `appliedCropAvatar` | 252,220 | `2521885A8CA17FAB08B55D248AC4EF1D470E0535D167C323951520F665A45E54` | Main edit fold with avatar visibly reflecting applied crop zoom and pan, clean `اسم مقترح` badge |
| `04_screen18_no_photo_initials_sheet.png` | `noPhotoInitials` | 137,258 | `10F9D4ABE331347F0F88307BCB9D4BA6416BF4AC575C4ED998C9C1C03EB42497` | Initials fallback avatar («أ.م») with photo sheet showing only Camera/Gallery/Cancel (no crop/remove) |
| `05_screen18_clean_top_fold_100.png` | `mainEditTop` | 239,768 | `ADA353AFB5E5945D39AEEB7D594F22781240A3C67300C641E19B44C3E5DDC446` | Clean top fold at 100% text scale, black camera badge on white circle, natural Arabic copy |
| `06_screen18_clean_bottom_fold_100.png` | `mainEditScrolled` | 195,020 | `01CFE3CADD668253B3CBA5C76A29C03D885EFD2DBFCA5E6C5C5BA088EC965120` | Scrolled fold showing sanitized security footnote (no screen IDs) and prototype disclaimer |

### 3.2 Physical Hardware Live Interaction Trace Captures

| Step | Interaction Description | File Name | Size (Bytes) | SHA-256 Digest | Base64 SHA-256 |
|---|---|---|---|---|---|
| 01 | Open photo action sheet from clean profile | `01_trace_photo_sheet_open.png` | 190,553 | `E23A3856EC4381690E7E645F9D3B166828BC04C58661B4DD6965FECB5B2A6605` | `06413F8C16C82DBC1F096D3E575A0D7C9B2DE183F96E904FF9DAB1FD5A3C0307` |
| 02 | Zoom & Pan image in full-screen crop studio | `02_trace_crop_modal_zoomed_panned.png` | 453,112 | `73714E50E862587328F44B1DA3F71A62B326CAE366805DFCDE0145E65C7E098C` | `BD9229AF23840777C008C1B8373C2338DFB3E7A6E3718A8469621CB81D840CF4` |
| 03 | Applied crop visibly reflected in avatar + snackbar | `03_trace_avatar_applied_live.png` | 254,283 | `8F93F57AC729435C0AABD99F94D78F525514796A8BD3EFA27B875A77A7D71D2C` | `56C45516CF9FC22C635C54817ABBF9FBAFE79C8D85C684CA53CAB9D192823A38` |
| 04 | Reopen crop studio, verify persistence, tap Reset | `04_trace_reopened_and_reset.png` | 435,482 | `19E5680234ECDBB5985A9832A7C26744DC26D1C7A8C684A0EADB8B7B83D681BF` | `1F0CB0BCE8AAE42F30CC0560560C4DC59A2532A74CD41EB04ACAAC26081E0361` |

### 3.3 Review Source Mirror Checksums

| Mirrored Review Source | Size (Bytes) | SHA-256 Digest |
|---|---|---|
| `screen18_preview_runner.dart` | 88,343 | `8A9E9B78D62308BF7500D61B0F23F37036F5126A7A97F44600F6AC31560B3B1E` |
| `screen18_source_linked_tests.dart` | 27,560 | `1B10E0206A3A3EC454733B3E865DC863212084A1BE7E58ADBEC7FF974FB2643A` |
| `screen17_demo_portrait_bytes.dart` | 24,632 | `D84FAB1B8219082A62443C89C0E8DFD2AED47A7D8D81D3BE97A8C09E3A640901` |

---

## 4. Verification & Quality Gates

- **Unit and Widget Tests:** 29/29 tests pass (`flutter test test/screen18_source_linked_tests.dart`).
- **Static Analysis:** Zero errors, zero warnings (`flutter analyze mobile/apps/customer_app/tool/screen18_preview_runner.dart mobile/apps/customer_app/test/screen18_source_linked_tests.dart`).
- **Evidence Immutability:** Historical evidence directories (`review-evidence/customer-screen14/` through `review-evidence/customer-screen17/` and `review-evidence/customer-screen18/v1/`) remain strictly untouched per Issue #155.
- **Privacy & Redaction:** Device serial strictly redacted as `[REDACTED_A56_ID]` per Issue #145.
- **Design Authority Compliance:** Exact `#000000` pure black maintained across headings, primary action, bottom nav, and modal backgrounds per Issue #175.
- **Status:** Closed and fully verified.
