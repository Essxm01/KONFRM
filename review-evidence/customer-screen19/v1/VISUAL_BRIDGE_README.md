# KONFRM Customer Screen 19 V1 — Visual Bridge Evidence Manifest
**Screen:** Customer Screen 19 — Settings («الإعدادات») [V1 Native Visual Design]  
**Status:** `SCREEN19_V1_FOUNDER_AUTHORIZED_DESIGN_ONLY__AWAITING_BRIDGE_REVIEW_AND_FOUNDER_DECISION`  
**Target Device:** Samsung Galaxy A56 5G (`SM_A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen19-design-review`  
**Pinned Baseline:** `70278470f9d4158196423a82567c4cd23e8a3114`  
**Governing Issues:** [GitHub Issue #177](https://github.com/Essxm01/KONFRM/issues/177) (Screen 19 Contract), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Mandatory Pure Black `#000000`), [GitHub Issue #174](https://github.com/Essxm01/KONFRM/issues/174) (Notifications Navigation Routing), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar & Connected Profiles Boundaries), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Screen 17 Prelive Gate), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Cairo RTL), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 8 V1 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen19_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `mainSettingsTop` | `01_screen19_settings_clean_top_100.png` | 193,943 | `bab5e4c778a17cd6762ad15ae2e22fd6593cad039ef1e419e3c724ae81f6fdc4` | `88a6bf3b533e3380e1ddfa5e4048f79cc80fccbe809bdcef95ba88d10d00f8e6` |
| 02 | `mainSettingsScrolled` | `02_screen19_settings_clean_scrolled_100.png` | 185,937 | `c48a157e77d70f611cbbb9d979cc63b4663582b59689302ea7d64e3cc0d4a808` | `65046af070ad9b5d1fc3e990c12c2807ba64ad9d2101560e11502fba90f8c943` |
| 03 | `notificationsPermissionDenied` | `03_screen19_settings_permission_denied_sheet.png` | 190,096 | `1ed33389cd618ff3bcdabf2ee1cd05a0979e9857174e562e9d90c1f6199fbbe6` | `d861a20b8c1b04e5175960c9e9cd7b7be67ac9b6c8c4994e1e2f2a05ca3b8644` |
| 04 | `signOutConfirmationDialog` | `04_screen19_settings_sign_out_dialog.png` | 180,567 | `9c5d6d7ac67390fc5efc43c11457f5f53128d8270f956895280ca9b8436cf67a` | `8c2aab73677334b249fa9813196316c681dc0e6c9331c4607ab459802ed0b7ed` |
| 05 | `unauthenticatedGuestState` | `05_screen19_settings_unauthenticated_guest.png` | 181,713 | `c9020e78dcae7d3703696cbe5334bb88480e7af1a9477f68f05e9c695b46f237` | `13833946a8c4c952f2fa9bc0697c86795d02bdc2e4696e6ac771b251b99e1ae9` |
| 06 | `accountDeletionInfoSheet` | `06_screen19_settings_account_deletion_sheet.png` | 181,848 | `b6fdb51bef9cbd29dd9b3e5356c965d364cd45c8eedd8f75add1e725f5fbb39f` | `d857294dde2bca03473fd941bbb3707a04ff5fd940503cfa091fa8b7b3cfdef8` |
| 07 | `accessibility200Top` | `07_screen19_settings_a11y_200_top.png` | 146,150 | `65175db2a196ee18ca70d67b33d334ec18542d8c3b0f42e368d8094a99da3f9b` | `04020ca3ee194500905e8eb95e80c3aebbb25647b489875334b10da1e0514bfe` |
| 08 | `accessibility200Scrolled` | `08_screen19_settings_a11y_200_scrolled.png` | 155,688 | `f30e5c62dde0f33a85cdda1546929fa264a6eddc1b469538533eb621fa115458` | `569471542f746db6e14a1ee7179bdd1571dcb4ea9d221e2031623de2de64dc4f` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen19_preview_runner.dart`  
  SHA-256: `758ba23d54319d431eff8c262bebd611380091694b99fc8f7980feb0434675e7`
- **Behavioral Test Suite:** `review-source/screen19_source_linked_tests.dart`  
  SHA-256: `65ab18120bf91f20a34787db6f5edad7f7df819b17d6771982e0fc6943e1f5e1`
- **Test Suite Result:** 18/18 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Visual System & Invariants Compliance

1. **Exact Pure Black `#000000`:** Enforced throughout the screen per Issue #175. Zero charcoal, navy, blue-black, or near-black substitutions exist in source or visuals.
2. **Canonical Nested Customer Navigation:** Implements `NESTED_CUSTOMER` top app bar per `DESIGN_SYSTEM/COMPONENTS/navigation.md` §3.3:
   - Physical **RIGHT** return arrow (`➔`) pointing back to parent Account screen.
   - Symmetrically centered title «الإعدادات».
   - **Bottom Navigation Bar HIDDEN**, strictly adhering to the design-system invariant.
3. **Account & Security (الأمان وطرق الدخول):**
   - Masked primary identifiers (`+20 10 •••• 5678` and `a•••••@gmail.com`) rendered as verified credentials with green `مؤكّد` badges and lock icons.
   - Proposed entry rows for alternate phone and email labeled «قريباً» with honest verification disclaimers.
   - Proposed Apple and Google sign-in rows labeled «غير متاح حالياً» with honest identity boundaries (Issue #172).
   - Informative footnote explaining identity verification requirements for credential changes.
4. **Notifications & System Permissions (الإشعارات والتنبيهات):**
   - Honest distinction between OS-level permission state and channel preferences.
   - Status pill clearly indicating «مفعّل» (or «متوقف بالنظام» with dedicated guidance sheet).
   - Interactive local-only toggle switches with pure black active tracks (`#000000`) and white thumbs.
   - Transparent disclaimer clarifying local simulation boundaries.
5. **App Preferences (تفضيلات التطبيق):**
   - Arabic default language pill (`العربية (الافتراضية)`).
   - Pricing & payment currency (`الجنيه المصري (EGP)`).
   - Reduced motion tile honestly disclosing that it automatically respects OS accessibility settings.
   - Light mode theme baseline reflecting approved brand palette.
6. **Privacy & Account Actions (الخصوصية وإدارة الحساب):**
   - Direct navigation affordances to Privacy Policy and Terms of Service.
   - Account deletion & data portability action tile labeled «قيد الاعتماد», opening a formal governance and regulatory notice sheet (Issue #172).
   - Demonstration-only sign-out action opening a guarded confirmation dialog with cancel and red confirmation affordances.
7. **Accessibility & Responsive 200% Font Scale:**
   - Evaluated and verified on genuine hardware at 200% text scale.
   - All badges and status indicators wrap naturally inside flex containers without single-line ellipsis, label clipping, or RenderFlex overflow.
