# KONFRM Customer Screen 18 V1 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي») [V1 Native Visual Design]  
**Status:** `SCREEN18_V1_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`  
**Target Device:** Samsung Galaxy A56 5G (`SM_A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen18-design-review`  
**Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176) (Screen 18 Contract), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Mandatory Pure Black `#000000`), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar & QR Boundaries), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Screen 17 Prelive Gate), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Consistency), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 8 V1 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen18_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `mainEditTop` | `01_screen18_v1_a56_edit_profile_top.png` | 241,743 | `1600b446b666be6c5f791433d2d5b88f29b3b81ebd888641d5f1c71a0d8dfe61` | `e56fb5e36f434e4f43747dbaf06594de0396a6ef60178d6277b975909286fbfc` |
| 02 | `mainEditScrolled` | `02_screen18_v1_a56_edit_profile_scrolled.png` | 203,816 | `d5441b974ba3cab92e9c89762bf078b29463795ac2b28f710a4e950ecc2104dd` | `5e80c65adb1a5d4d949f968ca7edd5d3f60f1885eca48def99af244f90d97e43` |
| 03 | `photoActionSheet` | `03_screen18_v1_a56_photo_action_sheet.png` | 190,994 | `206a6bb1f2de68e6653b83350761c05f759125b5b787dc9ad5e6a52e958bad0e` | `c7d6e9bed9475be537fe8f099232c9f3750d1bceddb72cb1a26e792a3135da09` |
| 04 | `photoCropModal` | `04_screen18_v1_a56_photo_crop_modal.png` | 597,009 | `0fd449493b26f8dcde3c84214fab1e17725cea7bf11117c58abe074a45ed20a0` | `aaf59d8d84a86bcdb4d2cbf5d61d9a8e58f9620d6527e36af4ff5b6dce35da50` |
| 05 | `discardConfirmationDialog` | `05_screen18_v1_a56_discard_dialog.png` | 243,829 | `9209fc1f1a213d393300699142f51f4aa26008c3260a78f12b35a09dc401254f` | `570f459ca0e0644c0a5f869f5eb3456270ca585a626e017ffdf28b6681973b8c` |
| 06 | `validationErrorEmptyName` | `06_screen18_v1_a56_validation_error.png` | 248,091 | `896cc3881713548c8d2a272d806c32c0af68439822d63e02d3dd6fa5cd57c1c8` | `c173fce34e2295f19a1d9931b8e4157b740a1a7fe59d4b6fe5a169f954031eba` |
| 07 | `accessibility200Top` | `07_screen18_v1_a56_accessibility_200_top.png` | 233,845 | `e98bd292f113f776c1d42f8a96248929987e4875bf2924c2df94fea11424f05f` | `48c11766e98a9afa60a908d38ecfb44b4067f182b26eca1c61b594a5ef581723` |
| 08 | `accessibility200Scrolled` | `08_screen18_v1_a56_accessibility_200_scrolled.png` | 187,454 | `27310cad2429acef0eec1b8058b73f491438decf4b13911bcf0e7903aaae1a12` | `1d2393e341ed679476d1bca5057156a8c9ed8832823bd166242a817f1594ab8a` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen18_preview_runner.dart`  
  SHA-256: `ae527e8e0f5a93e43e459d3b87f89ce28bedf0be3dc047e4c768733bc7ce583d`
- **Behavioral Test Suite:** `review-source/screen18_source_linked_tests.dart`  
  SHA-256: `0917081da313e85f3ada44649c3f8a1fe04af74b67225cdaada38a2e677df3b2`
- **Portrait Demo Bytes:** `review-source/screen17_demo_portrait_bytes.dart`  
  SHA-256: `d84fab1b8219082a62443c89c0e8dfd2aed47a7d8d81d3be97a8c09e3a640901`
- **Test Suite Result:** 23/23 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Visual System & Invariants Compliance

1. **Exact Pure Black `#000000`:** Enforced throughout the screen per Issue #175. Zero charcoal, navy, blue-black, or near-black substitutions exist.
2. **Editable Portrait & Camera Badge:** Circular avatar ($104 \times 104$) with real consented portrait bytes, editable camera badge with black camera icon inside a WHITE circle (`#FFFFFF` with `#E5E7EB` border, $\ge 48\text{dp}$ touch target) per Founder directive.
3. **Interactive Photo Sheet & 1:1 Circular Crop Modal:** Bottom sheet offering Camera, Gallery, Crop, Remove, and Cancel. Dedicated full-screen solid black (`#000000`) crop studio with zoom slider, 3x3 alignment grid, and honest local prototype disclaimer.
4. **Physical RTL Return Navigation:** Top app bar features back arrow pointing physically **RIGHT** (`➔` / `Icons.arrow_forward_ios_rounded`), consistent with Arabic RTL parent return navigation.
5. **Personal Identity Card:**
   - Full Name: outline-led text field with live validation ($\ge 2$ characters).
   - Unified `@username`: isolated LTR text field with explicit proposal badge («مقترح #172») and honest disclaimer note.
   - Private Birth Date: date picker with derived age badge («28 سنة (محسوب تلقائياً)») and «🔒 خاص — لا يظهر للعامة» privacy badge.
   - Private Gender: 3 segmented options («ذكر», «أنثى», «أفضل عدم الإفصاح») with privacy badge.
6. **Read-Only Verified Identifiers:** Phone and email rendered with green «موثّق» badges, accompanied by explicit footnote stating that credential security management belongs to Screen 19.
7. **Dirty Form Protection & Discard Dialog:** Dirty/pristine detection enables the 6px radius `#000000` save CTA only when modified and valid. Attempting to navigate back with unsaved changes prompts a confirmation dialog.
8. **Accessibility 200% Font Scale:** Tested and verified on physical hardware with responsive `Wrap` layouts resulting in zero RenderFlex overflow.
9. **Shared Customer App Shell:** Canonical `CustomerBottomNavigation` with Account (Index 3) selected.
