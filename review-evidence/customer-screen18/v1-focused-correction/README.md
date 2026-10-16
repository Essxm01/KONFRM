# KONFRM Customer Screen 18 V1 — Focused UX & Interaction Correction

## Summary
- **Screen Name:** Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي»)
- **Role:** Customer (العميل)
- **Task ID:** `CUSTOMER_SCREEN18_V1_BOUNDED_CLOSURE`
- **Execution Mode:** Isolated Native Flutter Preview Runner & Behavioral Tests (Design-First Evidence)
- **Active Git Branch:** `evidence/customer-screen18-design-review`
- **Baseline Commit:** `a063a1a8e362606dbbc33cafadc66452ac85cda0`
- **Current Status:** `SCREEN18_V1_BOUNDED_CORRECTION_READY_FOR_BRIDGE_AND_FOUNDER_REVIEW`
- **Governing Issues:** [GitHub Issue #176](https://github.com/Essxm01/KONFRM/issues/176), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145)

---

## Deliverables in this Directory
1. **6 Physical Device Screenshots:** Captured from Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, 1080x2340 px, hardware serial `[REDACTED_A56_ID]`).
   - `01_screen18_gender_options_200.png`: 200% text scale vertical gender tiles showing full «أفضل عدم الإفصاح» without clipping.
   - `02_screen18_fullscreen_crop_modal.png`: Fullscreen dark crop studio with hidden bottom navigation.
   - `03_screen18_avatar_applied_crop.png`: Avatar hero visibly reflecting applied zoom/pan and clean «اسم مقترح» badge.
   - `04_screen18_no_photo_initials_sheet.png`: Initials fallback avatar with photo sheet hiding crop/remove actions.
   - `05_screen18_clean_top_fold_100.png`: Clean top fold at 100% scale with camera badge and natural Arabic copy.
   - `06_screen18_clean_bottom_fold_100.png`: Scrolled fold with sanitized security footnote and prototype disclaimer.
2. **6 Base64 Companion Files:** Matching `.b64.txt` files for optical verification by Bridge and Founder.
3. **`review-source/` Directory:**
   - `screen18_preview_runner.dart`: Complete isolated Flutter preview runner with all 3 corrections implemented.
   - `screen18_source_linked_tests.dart`: Comprehensive 23-test behavioral and widget test suite (100% pass rate).
   - `screen17_demo_portrait_bytes.dart`: Real test portrait asset bytes.
4. **`VISUAL_BRIDGE_README.md`:** Cryptographic SHA-256 hash manifest.
5. **`REPORT.md`:** Detailed executive design and technical verification report.
