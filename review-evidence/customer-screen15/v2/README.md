# KONFRM Customer Screen 15 V2 — Focused Visual Corrections Review Evidence

This directory contains the additive **V2 visual corrections evidence**, hardware screenshots, Base64 companions, mirrored source code, and verification results for **Customer Screen 15: Favorites (المفضلة)** following Bridge independent review under [GitHub Issue #165](https://github.com/Essxm01/KONFRM/issues/165).

> **Preservation Notice:** The original 14 baseline visual captures, test manifests, and report files from V1 remain preserved and unaltered in `review-evidence/customer-screen15/` per [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155).

---

## 1. Summary of Authorized V2 Visual Corrections

Bridge independently reviewed commit `b86b25f8ee934e30d81b48db18510c98c5e3738d` and approved the overall layout, typography, and state architecture, while mandating ONLY three targeted visual corrections:

1. **Property Imagery Fallback (Issue 1):**
   - **Problem:** `ArchitecturalPropertyThumbnail` previously painted blue/teal vector geometric illustrations (sky, water, louvers, pool reflections) that dominated the accommodation cards and did not represent actual properties.
   - **V2 Solution:** Replaced with the canonical Screen 03/06 calm, honest, neutral fallback placeholder (`Color(0xFFF1F5F9)` / `Color(0xFFE2E8F0)` with centered architectural icon `Icons.home_work_outlined` 44dp). All vector illustration painting is removed. The card structure, 1.4:1 aspect ratio, price hierarchy, black region badge pill, and 48dp circular heart action button are 100% preserved.

2. **Bottom Navigation Adaptive Layout at 200% Accessibility Scaling (Issue 2):**
   - **Problem:** Fixed `height: 62` caused the bottom navigation tab labels (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`) to be vertically clipped when system font scale was increased to 200%.
   - **V2 Solution:** Updated `_buildCustomerBottomNav()` to an adaptive layout with `constraints: BoxConstraints(minHeight: 62)`, `SafeArea(top: false)`, vertical padding, and `Column(mainAxisSize: MainAxisSize.min)` with `maxLines: 1, overflow: TextOverflow.visible, height: 1.2`. At 200% text scaling, the bar naturally expands without vertical clipping or RenderFlex overflow, ensuring all 4 labels remain completely visible, legible, and comfortably tappable.

3. **Truthful Neutral Unavailable-Property Copy (Issue 3):**
   - **Problem:** The previous copy stated *"أوقف المالك النشر مؤقتاً"*, which made an unsupported claim attributing property unavailability to a specific owner action.
   - **V2 Solution:** Updated to truthful, neutral wording: *"غير متاحة للحجز حالياً"* (Currently not available for booking). Reflects only the known unavailable state without inventing owner actions. Tests updated and verified.

---

## 2. Physical Test Environment

- **Device:** Samsung Galaxy A56 5G (`SM-A566B` / `a56x`)
- **OS:** Android 16 (API 36)
- **Physical Resolution:** 1080 x 2340 pixels
- **Serial Number:** `[REDACTED]` (per [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145))
- **Capture Method:** Hardware screen capture via ADB direct framebuffer pull (`screencap -p`)
- **Typography:** Cairo font family (Arabic RTL native alignment)

---

## 3. V2 Hardware Visual Evidence (6 Affected Scenarios)

Only the 6 genuinely affected visual scenarios were re-captured on physical hardware. The remaining 8 unaffected scenarios (empty state, guest unauthorized, session expired 401, shimmer loading, network error, stale refresh banner, undo toast, and dev overlay) remain identical and valid in the V1 baseline directory.

| # | Filename | Description & V2 Verification Focus | SHA-256 (PNG) |
|---|---|---|---|
| 01 | `01_screen15_v2_a56_ready_list_top.png` | Ready list top fold showing canonical neutral property fallback, Cairo bold title, region badge pill, and active Favorites tab | `4E032ED33DF70FAFCBD8EC26A0D0CE3E3DBCD416EEAB6BDF3C60AFDB46ED0B15` |
| 02 | `02_screen15_v2_a56_ready_list_scrolled.png` | Scrolled view showing calm neutral thumbnail continuity across multiple cards without visual fatigue | `6128214B54AAACA9898CC0521E48D29C5901829F0A1601ECF066F2FAEDA59DB7` |
| 10 | `10_screen15_v2_a56_unavailable_item.png` | Unavailable card showing neutral badge (*"غير متوفرة حالياً"*), truthful copy (*"غير متاحة للحجز حالياً"*), and remove affordance | `C0DEE711F80048826D9ECCE743A70113FE7254A421491128DB421C98681B99B3` |
| 11 | `11_screen15_v2_a56_single_card_focus.png` | Isolated card deep-dive verifying 1.4:1 ratio, 48dp circular heart button, Cairo typography, and directional Arabic price | `0C8B991AB0B6B53EAAFCDC1F9D29756F9F6875B5C426C8AD53372B3B708C9EC7` |
| 12 | `12_screen15_v2_a56_accessibility_200_top.png` | 200% Accessibility scaling: bottom navigation expands gracefully, all 4 labels completely visible and unclipped, 0 overflow | `AB6A381AA0BE546C235B70D2C498927C7AEFEC8ED9285281ADB8ACFCE79660CB` |
| 13 | `13_screen15_v2_a56_accessibility_200_scrolled.png` | 200% Accessibility scaling scrolled: full card body reflows cleanly, specifications wrap without clipped text | `B6654F2AFE4572DB661964AA6B85DE5C45B35D12763E31C2C74A150B89A1D48D` |

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
- `review-source/screen15_preview_runner.dart` (SHA256: `F7F583113A6A8DFB60352299FEA1CFE15ACA7EF337F1EA56FDDB2FA98848B4C5`)
- `review-source/screen15_source_linked_tests.dart` (SHA256: `87BC1A94450E46FD9BEDB29B6BECF4ADE016638D6514EB90257EF6D5F6EC306A`)
