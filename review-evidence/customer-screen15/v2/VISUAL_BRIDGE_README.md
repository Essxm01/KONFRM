# KONFRM Customer Screen 15 V2 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 15 — Favorites (المفضلة) [V2 Focused Visual Corrections & Consistency Pass]  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Source Branch:** `evidence/customer-screen15-design-review`  
**Governing Issues:** [GitHub Issue #165](https://github.com/Essxm01/KONFRM/issues/165) (V2 Corrections), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design-First Priorities), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (V1 Evidence Preservation), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All V2 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the updated native Flutter preview runner (`mobile/apps/customer_app/tool/screen15_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted in compliance with Issue #145.

| # | Scenario Identifier | File Name | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|-------------|---------------------------|
| 01 | `readyListTop` | `01_screen15_v2_a56_ready_list_top.png` | `741CDC8385F3D3B56A0108DB6F382C0E8740FC2E03DA9DD9F3643EFC95EDD778` | `E3C39F0444022C1EBBA9FCDE86A00A43EA3AD026FC2C6A6EC753AEFBD999DF62` |
| 02 | `readyListScrolled` | `02_screen15_v2_a56_ready_list_scrolled.png` | `8E86F8824EF9573C074DF1EA7F2A7730D209BF2E20BC2DFAEF1C3ED35490043C` | `83BAE7D45FAA7C1EAE063759B1426F5F1F6D792517704E914901B18D3E75EF72` |
| 10 | `unavailableItem` | `10_screen15_v2_a56_unavailable_item.png` | `7499F0AE9495F4AA9C83A8467E1150DFD97AB214C7E0AA9D41A2E0A8BA29A72C` | `7C633262656EED6CA56A9D4735E6DE1D05243EEDA9B809B46F8A163592D33087` |
| 11 | `singleCardFocus` | `11_screen15_v2_a56_single_card_focus.png` | `C0E97FBC6DB2319C229BE78106A56E539739158FA8762DBD120DC242D86248D3` | `85F108552463592F9E16785A6A5CF9C32A3111A649C61EB5D9FC1AF264C3904F` |
| 12 | `accessibility200Top` | `12_screen15_v2_a56_accessibility_200_top.png` | `043FFB256D464827E1C4CAFBE7FDFC92C52E175AD71813242F45F2944F9806DD` | `8210D3B26F93E4D3BC67E8A5768C47CF3C41C748D5A340216CE8FEECCD14E500` |
| 13 | `accessibility200Scrolled` | `13_screen15_v2_a56_accessibility_200_scrolled.png` | `D67C61E155AB4072F0251864D69B21BDA32F2B2DE0E397702BF938482BCC3B85` | `F21F77AC9FE342492FDF268BCE5782918BFD75A3CBD7C00E995B26F87743ACA7` |

---

## 2. Source-Linked Evidence Verification

- **Runner Source:** `review-source/screen15_preview_runner.dart` (SHA-256: `BEA9DF7A59620381E90FD97140C52EFDB567191FAA7E3E8534E850491867C58D`)
- **Behavioral Tests:** `review-source/screen15_source_linked_tests.dart` (SHA-256: `7804AA76EE5B205A9132939C8C31C788BBB2C80CB1AC6D4A8435517A9A4809D0`)
- **Tests Execution Result:** 13/13 Passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` 0 issues found.
