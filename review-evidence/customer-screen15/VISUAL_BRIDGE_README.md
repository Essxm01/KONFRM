# KONFRM Customer Screen 15 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 15 — Favorites (المفضلة)  
**Target Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Source Branch:** `evidence/customer-screen15-design-review`  
**Governing Issues:** GitHub Issue #163 (Screen 14 Freeze), GitHub Issue #165 (Screen 15 Scope), GitHub Issue #166 (Design-First Principles), GitHub Issue #155 (Evidence Preservation)

---

## 1. Physical Device Captures & Verification Manifest

All screenshots were captured directly from a physical Samsung Galaxy A56 5G running the native Flutter customer application preview runner (`mobile/apps/customer_app/tool/screen15_preview_runner.dart`). No emulators or web wrappers were used. Hardware serials are redacted in compliance with Issue #145.

| # | Scenario Identifier | File Name | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|-------------|---------------------------|
| 01 | `readyListTop` | `01_screen15_a56_ready_list_top.png` | `43527A28A84698E69D8420CA6433107BEE920F868BB09B4F004BD40367594D41` | `3FD596F460CEF16CD81B1B1314A879169A52AF964A030712DE663D0FA36A3F21` |
| 02 | `readyListScrolled` | `02_screen15_a56_ready_list_scrolled.png` | `1CDD90D2674AFE017FA2A352C11278F6082BC19C5D16CCDA7638FBD8C176C305` | `B119F1CCE64F191402EC9DAA39C620C8CB01CBE421A58B1B58AF112E18386A4C` |
| 03 | `emptyNoFavorites` | `03_screen15_a56_empty_no_favorites.png` | `DBD8109BC681DDF9A753E8D5E817FE92ECA2A3A47A98CEB51A4BE9832830DF96` | `C6F2838BAA6156B0C33959D7240F3A54A94E16A3DC5E2ACDD24596D6A142460C` |
| 04 | `guestUnauthorized` | `04_screen15_a56_guest_unauthorized.png` | `FCD6C6261CD821BDAC8FF17AA41B9C62322C56D60BEC54E57FFC37392D77DD6C` | `7947948D3DB1AA2DD4ABB427E757FB8B171A798C2F2F7ABDE834A95588792B76` |
| 05 | `sessionExpired401` | `05_screen15_a56_session_expired_401.png` | `F8142E68B01AAE7ACDF34EA9085E8619B6ADE4CF6DFB33FBE324819EAA605B3F` | `7B848B92C44D3D82A6A3628716C15B7E673BFCFD2203AD23F5F92755AB53E1BC` |
| 06 | `initialLoading` | `06_screen15_a56_initial_loading.png` | `ACE340FED9CAC640FD6A2E72AF0D620DB3AB3B17E133DC272DDD92E57EC0B327` | `151D69499E72DD0A8A9EB195826A8EAABB8716FD23192FBC60C965EE0227452F` |
| 07 | `networkErrorInitial` | `07_screen15_a56_network_error_initial.png` | `227F32D8BFE483C06F2F9934C593E13BAAE19A75BD6EF212B80DE40FD5CCD8A5` | `0387F4F4B25E0AC64825E138E8F582E4FC158DA537ECFD996D516952872AD272` |
| 08 | `staleDataRefreshError` | `08_screen15_a56_stale_data_refresh_error.png` | `483EABCA47210325B50AEE20C8819E04FB706F23F02368002D2B1B79D5A20E73` | `B108CB0DB4EEBC64B43B211516C19B278BD55DB86CC3CD9201C349AC23854821` |
| 09 | `removedUndoToast` | `09_screen15_a56_removed_undo_toast.png` | `663BBB94A8B3BF4855B075D84B2CDC3B30D883ACA3C902934F2A0036A63DE75B` | `9291B71310E894C7AB1212CE6156C45FEFB055F0CFEE4CE4AE0217AC97D5A22D` |
| 10 | `unavailableItem` | `10_screen15_a56_unavailable_item.png` | `D7F6848D571543EF23D6186D0984918D01AF8FC4DB28DBD8701A7A5E37667252` | `E913E8B4B4AA057A390F442818B5BCE7BC44A5A59053E9F6D79B51B6728ED512` |
| 11 | `singleCardFocus` | `11_screen15_a56_single_card_focus.png` | `D4AB6A1CFBF6F2D590CF9B3F3BC5A81BC20AA795BF892B0C3E4444B271795F08` | `337CD2CAA6BEFB778E01DC95506634D39F5B06F282E9CE6CDD6F8310EB0F2C57` |
| 12 | `accessibility200Top` | `12_screen15_a56_accessibility_200_top.png` | `22BCC1685C5DB510735CF460A2F80D8D4C04F73D8E7B20CC83549E9B7D6F9C69` | `99E142A894A93E2BF4EB3A5741326B0ECDB4AB2C6A74617CD47A5FA9B2FFDCB5` |
| 13 | `accessibility200Scrolled` | `13_screen15_a56_accessibility_200_scrolled.png` | `54511826A5B263B4B397A4D1718FA410B969AD5931FDC29D3471C08BA630BD2E` | `8390EB83D19F6BB836BD8AD1F8A58EB2A628B6020900154E3C92C5C5AE246A96` |
| 14 | `qaAuditDevOverlay` | `14_screen15_a56_qa_audit_dev_overlay.png` | `87235A416C538CE0943C6313BD3BCEF6DBB73644C43BDB2C4BCD85E36371C6F1` | `6BAC8D200249817592A4651E2C874B77BBB98CB193D2B9134F110118B2C7EDA8` |

---

## 2. Source-Linked Evidence Verification

- **Runner Source:** `review-source/screen15_preview_runner.dart`
- **Behavioral Tests:** `review-source/screen15_source_linked_tests.dart`
- **Tests Execution Result:** 13/13 Passed (100%)
- **Static Analysis Result:** `flutter analyze` 0 issues found.
