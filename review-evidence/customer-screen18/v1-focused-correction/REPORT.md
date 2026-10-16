# KONFRM Customer Screen 18 V1 — Focused UX & Interaction Correction Report

## Executive Summary
- **Screen:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي»)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Child (CustomerBottomNavigation Tab 3 active)
- **Task ID:** `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE`
- **Status:** `SCREEN18_V1_BOUNDED_CORRECTION_READY_FOR_BRIDGE_AND_FOUNDER_REVIEW`
- **Active Git Branch:** `evidence/customer-screen18-design-review`
- **Baseline Commit:** `a063a1a8e362606dbbc33cafadc66452ac85cda0`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145)

---

## 1. Problem Statement & Root Cause Diagnosis

Following independent Bridge visual review of Screen 18 V1 (`a063a1a8e362606dbbc33cafadc66452ac85cda0`), the visual direction was accepted as a strong baseline, but three concrete UX issues required a single bounded correction before Bridge and Founder review:

1. **Problem A — Superficial Photo Cropping Studio:**
   - *Diagnosis:* The crop modal previously adjusted a local zoom variable without applying the resulting transformation to the profile draft or reflecting it in the avatar. Furthermore, opening the crop studio loaded a hardcoded demo portrait rather than the user's active portrait draft bytes. Removing the photo and re-opening the sheet would also resurrect demo bytes or show crop options for an empty portrait.
2. **Problem B — Incomplete Accessibility at 200% Font Scale:**
   - *Diagnosis:* In the gender selection row, the label «أفضل عدم الإفصاح» was constrained to a single line with `TextOverflow.ellipsis`, resulting in truncated/ellipsized Arabic text at 200% text scale.
3. **Problem C — Developer Metadata Leaking into Customer UX:**
   - *Diagnosis:* Several customer-facing strings displayed developer reference metadata, including the username proposal badge `مقترح #172`, the security footnote referencing `شاشة 19`, and disclaimer banners containing GitHub issue numbers `#176`.

---

## 2. Implemented Corrections & Domain Invariants

### Correction A — Meaningful & Interactive Photo Cropping
- **Active Draft Integration:** The crop studio strictly uses `_draft.portraitBytes` as the editing input. It never falls back to hardcoded demo bytes when an active portrait exists.
- **Pan & Zoom Gestures:** The crop studio supports continuous slider-based zoom ($1.0\times$ to $2.5\times$) and two-dimensional pan gestures (`GestureDetector` with `onPanUpdate` tracking drag deltas) directly within the crop viewport.
- **Avatar Reflection:** Applying crop commits `cropScale` and `cropOffset` to `CustomerProfileEditDraft`. In the main view avatar hero ($104 \times 104\text{ dp}$), the crop offset is scaled proportionally by $(104.0 / 260.0)$ and rendered via `Transform.translate` and `Transform.scale`, ensuring exact visual parity between crop studio framing and avatar display.
- **Dirty State Tracking & Restoration:** Modifying zoom or offset marks the profile draft as dirty. Tapping «إلغاء» (Cancel) restores prior committed crop coordinates. Tapping «إعادة ضبط» (Reset) restores $1.0\times$ zoom and zero offset.
- **Fail-Closed Photo Deletion:** Removing the portrait sets `portraitBytes = null` and resets crop transformations. Opening the photo bottom sheet in a no-photo state conditionally hides the "Crop" and "Remove" options, presenting only "Take Photo" and "Choose from Gallery".
- **Fullscreen Modal Focus:** While the crop studio modal is active, the app shell bottom navigation (`CustomerBottomNavigation`) is hidden, giving complete focus to photo manipulation.

### Correction B — Accessible 200% Text Scaling
- **Dynamic Orientation Adaptation:** The gender selector (`_buildGenderSelector()`) inspects ambient text scale (`_scenario.textScale`). When text scale is $\ge 1.3$ (such as at 200% scale), the options dynamically switch from a horizontal row to a full-width vertical list of cards.
- **Zero Truncation or Ellipsis:** `maxLines: 1` and `TextOverflow.ellipsis` were completely removed from the option label. The full phrase «أفضل عدم الإفصاح» renders crisply and legibly on a single line or natural multiline wrap without any clipping.
- **Touch Target Integrity:** Every selectable tile maintains a minimum touch height of $48\text{ dp}$ (`BoxConstraints(minHeight: 48)`) with clear visual radio and checkmark indicators.

### Correction C — Customer-Grade Surface Copy
- **Username Badge:** Changed from `مقترح #172` to customer-facing `اسم مقترح` (`#4B5563` on `#F3F4F6`).
- **Username Helper Text:** Replaced developer phrasing with natural customer copy:
  `معرّف موحّد لحسابك ورابطك الشخصي. يخضع للتحقق من التوفر عند الاعتماد.`
- **Security Footnote:** Sanitized to eliminate technical screen IDs:
  `لحماية أمان حسابك، لا يمكن تعديل رقم الهاتف أو البريد الإلكتروني أو ربط وسائل تسجيل الدخول مباشرة من هذه الصفحة. لإدارة بيانات الأمان، يرجى الانتقال إلى إعدادات الأمان والحساب.`
- **Prototype Banner:** Sanitized to remove issue tags:
  `معاينة تجريبية: يتم حفظ وتعديل البيانات محلياً فقط على هذا الجهاز. لن يتم إرسال أي تعديلات إلى خوادم الإنتاج.`
- **Crop Disclaimer:** Sanitized to natural Arabic:
  `معاينة محلية لتعديل واقتصاص الصورة — لا يتم رفع الصور إلى الخادم`

---

## 3. Physical Hardware Evidence Matrix (Samsung Galaxy A56 5G)

All screenshots were captured directly from the physical Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px) running the standalone Flutter debug APK:

| Screenshot | Scenario | Size (Bytes) | SHA-256 Digest | Key Verification Point |
|---|---|---|---|---|
| `01_screen18_gender_options_200.png` | `accessibility200Scrolled` | 272,393 | `3B1CCB03264C468FD974E84AE07D01441D25537C2F204F906692B9DCD99120D6` | 200% scale vertical gender tiles showing «أفضل عدم الإفصاح» without clipping or ellipsis |
| `02_screen18_fullscreen_crop_modal.png` | `photoCropModal` | 577,419 | `551C011B189B942C3564A421AED3615BB30C1FD08FCBC5BF3CE79C1E09F0C75E` | Fullscreen pure black crop studio with bottom navigation hidden, zoom slider, rule-of-thirds grid |
| `03_screen18_avatar_applied_crop.png` | `appliedCropAvatar` | 321,291 | `2521885A8CA17FAB08B55D248AC4EF1D470E0535D167C323951520F665A45E54` | Main edit fold with avatar visibly reflecting applied crop zoom and pan, clean `اسم مقترح` badge |
| `04_screen18_no_photo_initials_sheet.png` | `noPhotoInitials` | 288,574 | `10F9D4ABE331347F0F88307BCB9D4BA6416BF4AC575C4ED998C9C1C03EB42497` | Initials fallback avatar («أ.م») with photo sheet showing only Camera/Gallery/Cancel (no crop/remove) |
| `05_screen18_clean_top_fold_100.png` | `mainEditTop` | 316,929 | `ADA353AFB5E5945D39AEEB7D594F22781240A3C67300C641E19B44C3E5DDC446` | Clean top fold at 100% text scale, black camera badge on white circle, natural Arabic copy |
| `06_screen18_clean_bottom_fold_100.png` | `mainEditScrolled` | 278,924 | `01CFE3CADD668253B3CBA5C76A29C03D885EFD2DBFCA5E6C5C5BA088EC965120` | Scrolled fold showing sanitized security footnote (no screen IDs) and prototype disclaimer |

### Base64 Companions

| Base64 Companion File | SHA-256 Digest |
|---|---|
| `01_screen18_gender_options_200.b64.txt` | `C0B69B3E3913DB1D20A2D50798058D06D3C1AFC091BFF4E492AB8265DCBC3096` |
| `02_screen18_fullscreen_crop_modal.b64.txt` | `CF50A30C8844CB89E93704AD2922DB43520096E4B8EAFF27C8A5FD19F16E55D8` |
| `03_screen18_avatar_applied_crop.b64.txt` | `DF6280B62BD6EEF66BC333EC409016CFC574903110F33A5D1F209E07F3CB3F45` |
| `04_screen18_no_photo_initials_sheet.b64.txt` | `646445214334D83D487407FFAD922A26BB906D516D6E3D3F5384402724D5736F` |
| `05_screen18_clean_top_fold_100.b64.txt` | `9C9070B3CAB33A359F8D6E4739353F6D0829F1DFF790DC0A12DC7C375F7B00FA` |
| `06_screen18_clean_bottom_fold_100.b64.txt` | `090F958F93ED8C0A8BBCD65108CCD9EA89682F9CEFE7A6B83E0D0867DB5DC12A` |

### Review Source Files

| Mirrored Review Source | SHA-256 Digest |
|---|---|
| `screen18_preview_runner.dart` | `0146006120A669C29D2943E4A662D8A77E0B4FA4480498AA55CFF6397FA338EA` |
| `screen18_source_linked_tests.dart` | `A85526BE1D3331121E80931E646498DFECCFCB7E0B470F0D99B7CCC48ED21C5A` |
| `screen17_demo_portrait_bytes.dart` | `D84FAB1B8219082A62443C89C0E8DFD2AED47A7D8D81D3BE97A8C09E3A640901` |

---

## 4. Verification & Quality Gates

- **Unit and Widget Tests:** 23/23 tests pass (`flutter test test/screen18_source_linked_tests.dart`).
- **Static Analysis:** Zero errors, zero warnings (`flutter analyze tool/screen18_preview_runner.dart test/screen18_source_linked_tests.dart`).
- **Evidence Immutability:** Historical evidence directories (`review-evidence/customer-screen14/` through `review-evidence/customer-screen17/` and `review-evidence/customer-screen18/v1/`) remain strictly untouched per Issue #155.
- **Privacy & Redaction:** Device serial strictly redacted as `[REDACTED_A56_ID]` per Issue #145.
- **Design Authority Compliance:** Exact `#000000` pure black maintained across headings, primary action, bottom nav, and modal backgrounds per Issue #175.
