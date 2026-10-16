# KONFRM Customer Screen 19 V1 — Native Visual Design & Verification Report

## Executive Summary
- **Screen:** Customer Screen 19 — Settings («الإعدادات»)
- **Role:** Customer (العميل)
- **Sub-Journey:** Nested Destination from Screen 17 Account (Canonical `NESTED_CUSTOMER`, Bottom Navigation Hidden)
- **Status:** `SCREEN19_V1_FOUNDER_AUTHORIZED_DESIGN_ONLY__AWAITING_BRIDGE_REVIEW_AND_FOUNDER_DECISION`
- **Active Git Branch:** `evidence/customer-screen19-design-review`
- **Pinned Baseline:** `70278470f9d4158196423a82567c4cd23e8a3114`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [GitHub Issue #177](https://github.com/Essxm01/KONFRM/issues/177) (Screen 19 Contract), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Mandatory Pure Black `#000000`), [GitHub Issue #174](https://github.com/Essxm01/KONFRM/issues/174) (Notifications Navigation Routing), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar & Connected Profiles Boundaries), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Screen 17 Prelive Gate), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Cairo RTL), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Serial Redaction)

---

## 1. Product Invariants & Domain Boundaries

Customer Screen 19 represents the application settings and security management surface for customers. Following the visual approval of Screen 18 V1 (`70278470f9d4158196423a82567c4cd23e8a3114`), Screen 19 establishes a unified, trustworthy settings experience while upholding strict architectural, financial, and security boundaries:

1. **Security & Credential Boundary (Issue #172):**
   - Renter identity credentials (verified phone and email) are displayed in masked synthetic form (`+20 10 •••• 5678` and `a•••••@gmail.com`) with green `مؤكّد` badges and lock icons.
   - Proposed entry rows for alternate phone and email are labeled «قريباً» with explicit footnotes explaining verification requirements.
   - Proposed Apple and Google account linking rows are labeled «غير متاح حالياً» with honest copy, preserving existing identity boundaries.
   - Changing primary credentials is honestly explained as requiring identity re-verification.
2. **Notifications Architecture & Permissions Boundary (Issue #174):**
   - Screen 19 cleanly distinguishes between OS-level system permissions and channel preferences.
   - OS-level permission state is clearly reported («مفعّل» or «متوقف بالنظام»). If permission is revoked, a dedicated recovery sheet provides clear, platform-appropriate instructions for re-enabling it in Android device settings.
   - Channel toggles (Booking updates, Host messages, Price alerts) operate strictly as local in-memory simulations with a transparent disclaimer that toggling does not mutate backend push subscriptions.
   - The pending Explore-header notifications navigation proposal (Issue #174) remains external to Screen 19; this screen focuses solely on notification preferences.
3. **App Preferences & Accessibility Invariants:**
   - Default app language is set to Arabic (`العربية (الافتراضية)`).
   - Pricing and payment currency is anchored to Egyptian Pounds (`الجنيه المصري (EGP)`).
   - Reduced motion explicitly discloses that the app automatically adheres to the host device's OS-level accessibility setting.
   - Appearance theme is anchored to the approved Light neutral palette; Dark mode is labeled as currently unavailable and under study.
4. **Privacy & Regulatory Governance (Issue #172):**
   - Direct, accessible navigation links are provided to Privacy Policy (Screen 26) and Terms of Service (Screen 25).
   - Account deletion & data portability is labeled «قيد الاعتماد» and opens an informative legal policy sheet explaining that deletion requires regulatory verification to ensure no active bookings or outstanding wallet liabilities exist.
   - Sign-out is presented as a demonstration-only action that prompts a guarded confirmation dialog with explicit cancel and red confirmation options.
5. **Zero Production Mutations:**
   - Isolated prototype execution only. Zero production code, zero backend API calls, zero database mutations, and zero live OAuth state mutations.

---

## 2. Navigation Contract & Cross-Screen Discrepancy Note

### 2.1 Canonical Navigation Contract Compliance
Screen 19 strictly observes the canonical `NESTED_CUSTOMER` top app bar per `DESIGN_SYSTEM/COMPONENTS/navigation.md` §3.3:
- **Return Affordance:** Physical **RIGHT** circular back button (`➔` / `Icons.arrow_forward_ios`) returning the customer to Screen 17 Personal Home.
- **Title:** Centered, bold Cairo Arabic title «الإعدادات».
- **Bottom Navigation Bar:** **HIDDEN**, conforming to the core design system rule that nested screens must not display the bottom navigation bar.

### 2.2 Discrepancy Note Regarding Screen 18 Preview Runner
During review, Bridge and Founder will observe that the Screen 18 isolated preview runner (`screen18_preview_runner.dart`) included `CustomerBottomNavigation` with the Account tab (index 3) active. Screen 19 strictly implements the canonical design-system rule where nested screens hide the bottom navigation bar. This divergence between Screen 18's isolated runner and Screen 19's canonical runner is documented here as an intentional adherence to `DESIGN_SYSTEM/COMPONENTS/navigation.md` §3.3, pending final Founder harmonization across all nested child screens.

---

## 3. Visual Architecture & Design System Adherence

- **Exact Pure Black `#000000` Enforcement (Issue #175):**
  - All primary black elements use exact `#000000` (`Colors.black` / `const Color(0xFF000000)`).
  - All headings, primary buttons, monochrome icons, and active switch tracks use `#000000`. Zero charcoal (`#111827`, `#1F2937`), dark navy (`#0F172A`), or near-black substitutions exist in source or visuals.
- **Cairo RTL Typography:**
  - Standard Cairo Arabic typography across headings, labels, badges, body copy, and dialogs.
  - Directionality properly handles LTR components (phone numbers, email addresses, chevrons) within the Arabic RTL structure.
- **Card Hierarchy & Surfaces:**
  - Four distinct rounded container cards (`#FFFFFF`, border `#E5E7EB`, radius 12px) over an `#F9FAFB` screen canvas.
  - Consistent icon headers with contextual badge styling.
- **Accessibility 200% Font Scale:**
  - Evaluated on genuine hardware at 200% font scale.
  - All status badges and pills wrap cleanly beneath titles inside responsive `Wrap` layouts.
  - Zero single-line ellipsis, zero label clipping, and zero RenderFlex horizontal overflow.

---

## 4. Physical Hardware Captures on Samsung Galaxy A56 5G

All 8 captures were taken directly on a genuine Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px) running the standalone Flutter debug runner:

| Scenario | File Name | Size (Bytes) | PNG SHA-256 | Description |
|---|---|---|---|---|
| `mainSettingsTop` | `01_screen19_settings_clean_top_100.png` | 193,943 | `bab5e4c778a17cd6762ad15ae2e22fd6593cad039ef1e419e3c724ae81f6fdc4` | Top fold: Canonical header (back ➔, centered title, no bottom nav), Section 1 (الأمان وطرق الدخول) with masked verified identifiers, Section 2 (الإشعارات والتنبيهات) with OS permission state |
| `mainSettingsScrolled` | `02_screen19_settings_clean_scrolled_100.png` | 185,937 | `c48a157e77d70f611cbbb9d979cc63b4663582b59689302ea7d64e3cc0d4a808` | Scrolled fold: Section 3 (تفضيلات التطبيق) with Arabic and EGP pills, Section 4 (الخصوصية وإدارة الحساب) with legal links, deletion tile, sign out, and prototype disclaimer |
| `notificationsPermissionDenied` | `03_screen19_settings_permission_denied_sheet.png` | 190,096 | `1ed33389cd618ff3bcdabf2ee1cd05a0979e9857174e562e9d90c1f6199fbbe6` | Permission revoked state: Section 2 shows amber warning badge, bottom sheet explains Android OS permission recovery steps |
| `signOutConfirmationDialog` | `04_screen19_settings_sign_out_dialog.png` | 180,567 | `9c5d6d7ac67390fc5efc43c11457f5f53128d8270f956895280ca9b8436cf67a` | Guarded sign-out dialog: warning text explaining session termination on this device, neutral cancel button, red confirmation CTA |
| `unauthenticatedGuestState` | `05_screen19_settings_unauthenticated_guest.png` | 181,713 | `c9020e78dcae7d3703696cbe5334bb88480e7af1a9477f68f05e9c695b46f237` | Unauthenticated guest view: security card protects personal data with login prompt; sign-out action omitted |
| `accountDeletionInfoSheet` | `06_screen19_settings_account_deletion_sheet.png` | 181,848 | `b6fdb51bef9cbd29dd9b3e5356c965d364cd45c8eedd8f75add1e725f5fbb39f` | Account deletion & data portability sheet: formal notice detailing regulatory checks on active bookings and wallet balances |
| `accessibility200Top` | `07_screen19_settings_a11y_200_top.png` | 146,150 | `65175db2a196ee18ca70d67b33d334ec18542d8c3b0f42e368d8094a99da3f9b` | 200% font scale top fold: verifying zero horizontal overflow, badges reflowing cleanly below labels, pure Cairo typography |
| `accessibility200Scrolled` | `08_screen19_settings_a11y_200_scrolled.png` | 155,688 | `f30e5c62dde0f33a85cdda1546929fa264a6eddc1b469538533eb621fa115458` | 200% font scale bottom fold: verifying deletion tile with wrapped «قيد الاعتماد» badge, red sign-out button, and disclaimer readability |

---

## 5. Verification Evidence & Quality Gates
- **Source-Linked Tests:** 18/18 PASS (100% pass rate) via `mobile/apps/customer_app/test/screen19_source_linked_tests.dart`.
- **Static Analysis:** `No issues found!` via `flutter analyze`.
- **Pure Black Enforcement:** Zero forbidden charcoal or dark navy values in source per Issue #175.
- **Physical Hardware Execution:** Fully verified on genuine Samsung Galaxy A56 5G hardware over ADB.
- **Evidence Immutability Compliance:** All artifacts published into new additive directory `review-evidence/customer-screen19/v1/`; all historical Screen 12, 13, 14, 15, 16, 17, and Screen 18 V1 evidence remain untouched per Issue #155.
- **Device Serial Redaction:** Hardware serial redacted as `[REDACTED_A56_ID]` in all documentation per Issue #145.
- **Non-Goals Preserved:** Zero modifications to production apps (`mobile/apps/customer_app/lib/`), backend, or database. Screen 20 has not been started.
