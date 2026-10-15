# KONFRM Customer Screen 15 V2 — Focused Visual Corrections & Consistency Evidence

This directory contains the additive **V2 visual corrections and consistency evidence**, hardware screenshots, Base64 companions, mirrored source code, and verification results for **Customer Screen 15: Favorites (المفضلة)** following Bridge independent review under [GitHub Issue #165](https://github.com/Essxm01/KONFRM/issues/165).

> **Preservation Notice:** The original 14 baseline visual captures, test manifests, and report files from V1 remain preserved and unaltered in `review-evidence/customer-screen15/` per [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155).

---

## 1. Summary of Authorized V2 Visual Corrections & Consistency Pass

Following Bridge/Founder independent review, the visual architecture of Screen 15 was brought into complete consistency with approved customer screens (Screens 03, 06, and 12):

1. **Favorite Heart Action Button Placement (Consistency Pass):**
   - **Problem:** The favorite heart button was previously placed on the right side of the card, inconsistent with the Founder-approved customer card standard.
   - **Remediation:** Moved to the **physical LEFT side** of the property card (`Positioned(top: 10, left: 10)`). Preserved the >= 48dp circular white touch target, pure black heart icon, and subtle elevation shadow. The unavailable badge sits on the physical RIGHT (`Positioned(top: 14, right: 12)`), preventing any collision.

2. **Bottom Navigation Unification with Screen 12 (Consistency Pass):**
   - **Problem:** The bottom navigation visually diverged from approved customer screens.
   - **Remediation:** Integrated the canonical `CustomerBottomNavigation` component from `package:konfrm_design_system/konfrm_design_system.dart` using the exact `navigationBarTheme` styling from Screen 12:
     - Background: `#FFFFFF` with 0 elevation.
     - Indicator pill: `#F3F4F6` soft neutral grey.
     - Active icon and label: `#000000` pure black (Cairo 12 bold).
     - Inactive icon and label: `#6B7280` muted grey (Cairo 12 medium).
     - Active Tab: Index 1 (`المفضلة`).

3. **Property Imagery Fallback (Issue 1):**
   - Replaced custom painter vector illustrations with the canonical Screen 03/06 calm, honest, neutral fallback placeholder (`Color(0xFFF1F5F9)` / `Color(0xFFE2E8F0)` with centered architectural icon `Icons.home_work_outlined` 44dp).

4. **Truthful Neutral Unavailable-Property Copy (Issue 3):**
   - Updated copy to truthful, neutral wording: *"غير متاحة للحجز حالياً"* (Currently not available for booking) without attributing cause to owner intervention.

---

## 2. Physical Test Environment

- **Device:** Samsung Galaxy A56 5G (`SM-A566B` / `a56x`)
- **OS:** Android 16 (API 36)
- **Physical Resolution:** 1080 x 2340 pixels
- **Serial Number:** `[REDACTED_A56_ID]` (per [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145))
- **Capture Method:** Hardware screen capture via ADB direct framebuffer pull (`screencap -p`)
- **Typography:** Cairo font family (Arabic RTL native alignment)

---

## 3. V2 Hardware Visual Evidence (6 Affected Scenarios)

Only the 6 genuinely affected visual scenarios were re-captured on physical hardware. The remaining 8 unaffected scenarios (empty state, guest unauthorized, session expired 401, shimmer loading, network error, stale refresh banner, undo toast, and dev overlay) remain identical and valid in the V1 baseline directory.

| # | Filename | Description & Consistency Verification Focus | SHA-256 (PNG) |
|---|---|---|---|
| 01 | `01_screen15_v2_a56_ready_list_top.png` | Ready list top fold showing canonical neutral fallback, heart on physical LEFT, and unified Screen 12 bottom navigation | `741CDC8385F3D3B56A0108DB6F382C0E8740FC2E03DA9DD9F3643EFC95EDD778` |
| 02 | `02_screen15_v2_a56_ready_list_scrolled.png` | Scrolled view showing calm neutral thumbnail continuity, left-aligned heart buttons, and unified bottom nav | `8E86F8824EF9573C074DF1EA7F2A7730D209BF2E20BC2DFAEF1C3ED35490043C` |
| 10 | `10_screen15_v2_a56_unavailable_item.png` | Unavailable card showing left-side heart, right-side neutral badge (*"غير متوفرة حالياً"*), truthful copy (*"غير متاحة للحجز حالياً"*), and unified nav | `7499F0AE9495F4AA9C83A8467E1150DFD97AB214C7E0AA9D41A2E0A8BA29A72C` |
| 11 | `11_screen15_v2_a56_single_card_focus.png` | Isolated card deep-dive verifying heart positioned on physical LEFT, 1.4:1 ratio, Cairo typography, and directional Arabic price | `C0E97FBC6DB2319C229BE78106A56E539739158FA8762DBD120DC242D86248D3` |
| 12 | `12_screen15_v2_a56_accessibility_200_top.png` | 200% Accessibility scaling: canonical bottom navigation and cards scale gracefully, 0 overflow, heart remains on left | `043FFB256D464827E1C4CAFBE7FDFC92C52E175AD71813242F45F2944F9806DD` |
| 13 | `13_screen15_v2_a56_accessibility_200_scrolled.png` | 200% Accessibility scaling scrolled: full card body reflows cleanly, specifications wrap without clipped text | `D67C61E155AB4072F0251864D69B21BDA32F2B2DE0E397702BF938482BCC3B85` |

---

## 4. Verification & Testing

- **Widget & Behavioral Tests:** `flutter test test/screen15_source_linked_tests.dart`
  - **Result:** **13 passed, 0 failed** (100% pass rate).
- **Static Analysis:** `flutter analyze tool/screen15_preview_runner.dart test/screen15_source_linked_tests.dart`
  - **Result:** **No issues found** (0 warnings, 0 errors).
- **Scope Compliance:** Zero changes to production `customer_app/lib/`, backend APIs, database, or payment code. All technical deferred items remain managed under [GitHub Issue #167](https://github.com/Essxm01/KONFRM/issues/167).

---

## 5. Review Source Files

Exact runner and test source copies are archived in `review-source/`:
- `review-source/screen15_preview_runner.dart` (SHA256: `BEA9DF7A59620381E90FD97140C52EFDB567191FAA7E3E8534E850491867C58D`)
- `review-source/screen15_source_linked_tests.dart` (SHA256: `7804AA76EE5B205A9132939C8C31C788BBB2C80CB1AC6D4A8435517A9A4809D0`)
