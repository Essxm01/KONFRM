# KONFRM Customer Screen 18 V1 — Native Visual Design & Verification Report

## Executive Summary
- **Screen:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي»)
- **Role:** Customer (العميل)
- **Sub-Journey:** Account Child (CustomerBottomNavigation Tab 3 active)
- **Status:** `SCREEN18_V1_AWAITING_BRIDGE_AND_FOUNDER_VISUAL_REVIEW`
- **Active Git Branch:** `evidence/customer-screen18-design-review`
- **Target Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px)
- **Hardware Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)
- **Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145)

---

## 1. Product Invariants & Domain Boundaries

Customer Screen 18 represents the personal profile editing surface for renters. Following Founder approval and freezing of Screen 17 V4 AS-IS (`d1a8ab97442e35aa83a2866b476a0143be929528`), Screen 18 builds upon the minimal, unboxed personal passport identity while upholding strict security and architectural boundaries:

1. **Security & Credential Boundary (Screen 18 vs. Screen 19):**
   - Renter identity credentials (verified phone and email) are displayed as read-only verified facts with green badges (`#16A34A` / `#ECFDF5`).
   - Phone and email editing, OAuth account linking (Apple, Google), and password/passkey management are explicitly prohibited on Screen 18 and deferred to Screen 19 (Security Management).
   - An explicit explanatory footnote guides renters to Screen 19 for credential updates.
2. **Unified Username Proposal Boundary (Issue #172):**
   - The proposed `@username` draft is displayed with an explicit «مقترح #172» badge.
   - It is treated purely as a personal draft proposal; no fabricated availability or server-side uniqueness check is claimed in this visual prototype.
3. **Private Attributes Isolation:**
   - Birth date and gender fields are labeled with explicit «🔒 خاص — لا يظهر للعامة» privacy badges, clarifying that they are private identity attributes used for age verification and personalization rather than public display.
   - Age is automatically derived from the birth date without storing redundant derived values.
4. **Editable Portrait & Crop Invariant:**
   - Circular avatar ($104 \times 104$) features a black camera icon inside a WHITE circular container with an `#E5E7EB` border and $\ge 48\text{dp}$ touch target, adhering strictly to the Founder visual mandate.
   - Interactive photo action sheet provides options for Camera, Gallery, 1:1 Crop Preview, Remove Photo, and Cancel.
   - 1:1 circular crop studio provides a solid `#000000` canvas with zoom slider, 3x3 alignment guidelines, and an honest local prototype disclaimer.
5. **Dirty State & Unsaved Changes Protection:**
   - Form modification state is tracked. The primary save button is disabled when pristine.
   - Navigating back via the physical right arrow or tapping «إلغاء» when dirty presents a confirmation dialog preventing accidental data loss.

---

## 2. Visual Architecture & Design System Adherence

- **Exact Pure Black `#000000` Enforcement (Issue #175):**
  - All primary black elements use exact `#000000` (`Colors.black` / `const Color(0xFF000000)`).
  - Primary save button, heading texts, strong monochrome icons, and crop studio background strictly use `#000000`. Zero charcoal, navy, or near-black substitutions exist.
- **Cairo RTL Typography:**
  - Standard Cairo Arabic typography across headings, inputs, badges, and helper text.
  - Return arrow points physically **RIGHT** (`➔` / `Icons.arrow_forward_ios_rounded`) in the RTL header, ensuring correct directional metaphor for returning to the parent Account screen.
- **Card System & Surfaces:**
  - Clean neutral container cards (`#FFFFFF`, border `#E5E7EB`, radius 16px) over an `#F9FAFB` canvas.
  - Zero card soup or heavy drop shadows.
- **Accessibility 200% Font Scale:**
  - All section headers, labels, and input rows utilize responsive `Wrap` layouts.
  - Tested on physical Samsung A56 hardware with 200% font scaling, confirming zero RenderFlex overflow.
- **Shared App Shell:**
  - Shared `CustomerBottomNavigation` with Account (Tab 3) active.

---

## 3. Physical Hardware Captures on Samsung Galaxy A56 5G

All 8 captures were taken directly on a genuine Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080 x 2340 px) running the standalone Flutter debug APK:

| Scenario | File Name | Size (Bytes) | PNG SHA-256 | Description |
|---|---|---|---|---|
| `mainEditTop` | `01_screen18_v1_a56_edit_profile_top.png` | 241,743 | `1600b446b666be6c5f791433d2d5b88f29b3b81ebd888641d5f1c71a0d8dfe61` | Top fold: header with physical right return arrow, avatar with white camera badge, basic data fields |
| `mainEditScrolled` | `02_screen18_v1_a56_edit_profile_scrolled.png` | 203,816 | `d5441b974ba3cab92e9c89762bf078b29463795ac2b28f710a4e950ecc2104dd` | Scrolled fold: verified identifiers card, Screen 19 footnote, save CTA, prototype banner |
| `photoActionSheet` | `03_screen18_v1_a56_photo_action_sheet.png` | 190,994 | `206a6bb1f2de68e6653b83350761c05f759125b5b787dc9ad5e6a52e958bad0e` | Bottom sheet with Camera, Gallery, 1:1 Crop, Remove Photo, and Cancel options |
| `photoCropModal` | `04_screen18_v1_a56_photo_crop_modal.png` | 597,009 | `0fd449493b26f8dcde3c84214fab1e17725cea7bf11117c58abe074a45ed20a0` | Solid `#000000` crop studio with circular mask ring, 3x3 grid, zoom slider, disclaimer badge |
| `discardConfirmationDialog` | `05_screen18_v1_a56_discard_dialog.png` | 243,829 | `9209fc1f1a213d393300699142f51f4aa26008c3260a78f12b35a09dc401254f` | Modal warning dialog on dirty back navigation with "متابعة التعديل" and "تجاهل التعديلات" |
| `validationErrorEmptyName` | `06_screen18_v1_a56_validation_error.png` | 248,091 | `896cc3881713548c8d2a272d806c32c0af68439822d63e02d3dd6fa5cd57c1c8` | Live inline validation error: red outline, warning icon, and Arabic validation message |
| `accessibility200Top` | `07_screen18_v1_a56_accessibility_200_top.png` | 233,845 | `e98bd292f113f776c1d42f8a96248929987e4875bf2924c2df94fea11424f05f` | 200% font scale top fold reflowing cleanly without clipping or RenderFlex overflow |
| `accessibility200Scrolled` | `08_screen18_v1_a56_accessibility_200_scrolled.png` | 187,454 | `27310cad2429acef0eec1b8058b73f491438decf4b13911bcf0e7903aaae1a12` | 200% font scale scrolled fold showing date wrap and responsive chip layouts |

---

## 4. Verification Evidence & Quality Gates
- **Source-Linked Tests:** 23/23 PASS (100% pass rate) via `mobile/apps/customer_app/test/screen18_source_linked_tests.dart`.
- **Static Analysis:** `No issues found!` via `flutter analyze`.
- **Physical Hardware Execution:** Fully verified on genuine Samsung Galaxy A56 5G hardware over ADB.
- **Evidence Immutability Compliance:** All artifacts published into new additive directory `review-evidence/customer-screen18/v1/`; all historical Screen 12, 13, 14, 15, 16, and Screen 17 V1–V4 evidence remain untouched per Issue #155.
- **Device Serial Redaction:** Hardware serial redacted as `[REDACTED_A56_ID]` in all documentation per Issue #145.
