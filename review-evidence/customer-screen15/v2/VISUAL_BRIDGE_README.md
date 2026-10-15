# KONFRM Customer Screen 15 V2 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 15 — Favorites (المفضلة) [V2 Focused Visual Corrections]  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Source Branch:** `evidence/customer-screen15-design-review`  
**Governing Issues:** [GitHub Issue #165](https://github.com/Essxm01/KONFRM/issues/165) (V2 Corrections), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Priorities), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (V1 Evidence Preservation)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All V2 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the updated native Flutter preview runner (`mobile/apps/customer_app/tool/screen15_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted in compliance with Issue #145.

| # | Scenario Identifier | File Name | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|-------------|---------------------------|
| 01 | `readyListTop` | `01_screen15_v2_a56_ready_list_top.png` | `4E032ED33DF70FAFCBD8EC26A0D0CE3E3DBCD416EEAB6BDF3C60AFDB46ED0B15` | `CA6D4DF87AE23D532968A8F3D662921E83C0E5457D0EF587639AFDBF0DC9FEA1` |
| 02 | `readyListScrolled` | `02_screen15_v2_a56_ready_list_scrolled.png` | `6128214B54AAACA9898CC0521E48D29C5901829F0A1601ECF066F2FAEDA59DB7` | `EED222EE3146757F84B611F8CDD47F3634D9A60A8AB17897DDD85F4E0291C4D7` |
| 10 | `unavailableItem` | `10_screen15_v2_a56_unavailable_item.png` | `C0DEE711F80048826D9ECCE743A70113FE7254A421491128DB421C98681B99B3` | `ED659E4685DFD8736F982A95E11A5F46E79AD41C010B01AAFA4F90912A68B2FC` |
| 11 | `singleCardFocus` | `11_screen15_v2_a56_single_card_focus.png` | `0C8B991AB0B6B53EAAFCDC1F9D29756F9F6875B5C426C8AD53372B3B708C9EC7` | `7A6AB9A83402251C8BE86D2396832D0A9DBA346F69F9FCD19208EB77430C91FE` |
| 12 | `accessibility200Top` | `12_screen15_v2_a56_accessibility_200_top.png` | `AB6A381AA0BE546C235B70D2C498927C7AEFEC8ED9285281ADB8ACFCE79660CB` | `BA1BA3CC9868BC03555011227CB5968A7FDC7D1D8C0D54DC3B1C9517E5BD0414` |
| 13 | `accessibility200Scrolled` | `13_screen15_v2_a56_accessibility_200_scrolled.png` | `B6654F2AFE4572DB661964AA6B85DE5C45B35D12763E31C2C74A150B89A1D48D` | `DBF441F67EFE8F61BCFF7D3CD319936AC819F1288CEF36793A879117EB778E51` |

---

## 2. Source-Linked Evidence Verification

- **Runner Source:** `review-source/screen15_preview_runner.dart` (SHA-256: `F7F583113A6A8DFB60352299FEA1CFE15ACA7EF337F1EA56FDDB2FA98848B4C5`)
- **Behavioral Tests:** `review-source/screen15_source_linked_tests.dart` (SHA-256: `87BC1A94450E46FD9BEDB29B6BECF4ADE016638D6514EB90257EF6D5F6EC306A`)
- **Tests Execution Result:** 13/13 Passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` 0 issues found.
