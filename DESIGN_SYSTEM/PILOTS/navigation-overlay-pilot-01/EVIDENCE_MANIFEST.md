# Phase 4F Visual Evidence Manifest

**Pilot Directory:** `DESIGN_SYSTEM/PILOTS/navigation-overlay-pilot-01/`
**Evidence Subdirectory:** `evidence/`
**Generation Engine:** Google Chrome Headless via CDP (`chrome.exe --headless=new --hide-scrollbars`)
**Base Commit SHA:** `ff4ac0b4322b8a7c50273dd7a459a93dcf090551`
**Artifact Total:** 29 rendered image artifacts
**Data Status:** `LAB_SCENARIO_DATA`
*(All names, booking IDs, property records, and metrics are synthetic lab scenario data for visual, layout, and presentation testing only — `LAB_SCENARIO_DATA ≠ production evidence`).*

---

## 1. Complete Artifact Register

| # | Artifact Filename | Dimensions (W×H) | Size (Bytes) | Git Blob SHA | Role / Screen Family | Key Inspected Feature / Verification Criteria | Outcome |
|---|---|---|---|---|---|---|---|
| 1 | `customer_explore_360.png` | 360 × 800 | 21,417 | `c6e6c30dfcc6b54facab9eae37c4b8dabbe470c6` | Customer Top-Level | 4-tab bottom nav, Explore header (brand + account affordance, no Bell), 360px compact reflow, zero horizontal clipping | **PASS** |
| 2 | `customer_explore_390.png` | 390 × 844 | 21,849 | `46a32b1af93c792db4aa5dce680dfd2e4dee9755` | Customer Top-Level | 4-tab bottom nav, Explore header, baseline iPhone 390px viewport, active tab styling, unclipped leading/trailing edges | **PASS** |
| 3 | `customer_explore_430.png` | 430 × 932 | 21,891 | `c7b7b8364161e47e4fbe8f5115d8dc4a1f18cbc3` | Customer Top-Level | 4-tab bottom nav, large 430px viewport, edge alignment, safe margins, unclipped | **PASS** |
| 4 | `customer_notifications_390.png` | 390 × 844 | 29,674 | `db560c5e7318498764827e9a6e83bfb2bfde26ab` | Customer Account Child Exception (Screen 16) | **Screen 16 Account Shell Child Exception (Master Rule MR-17)**: RTL Back to Account, visible 4-tab bottom nav with Account tab ACTIVE | **PASS** |
| 5 | `customer_detail_390.png` | 390 × 844 | 29,715 | `4c10deb94713349acd212253757aa35222841d6f` | Customer Nested Entity | Nested Property Detail: RTL Back button, hero image, sticky CTA bar, bottom nav hidden, unclipped | **PASS** |
| 6 | `candidate_a_customer_detail_390.png` | 390 × 844 | 33,243 | `48f2629fc03753ac9352f733c18e88e83df1dd3f` | Customer Nested (Candidate A) | **DUAL BOTTOM CHROME DEFECT**: Competing persistent bottom action regions (sticky CTA stacked on bottom nav) | **FAIL (Defect)** |
| 7 | `candidate_c_customer_detail_390.png` | 390 × 844 | 29,715 | `4c10deb94713349acd212253757aa35222841d6f` | Customer Nested (Candidate C) | **ROLE-AWARE CONTEXTUAL**: Clean single bottom chrome (sticky CTA replaces bottom nav with RTL Back) | **PASS** |
| 8 | `customer_sheet_390.png` | 390 × 844 | 27,605 | `c0f390129343e6552d6aa4b808ba06cdbace525c` | Contextual Bottom Sheet | Search refine filter sheet, optional drag handle, 16px top radius, explicit Close (X), dimmed scrim, unclipped | **PASS** |
| 9 | `customer_sheet_keyboard_390.png` | 390 × 844 | 31,576 | `7a2c9822c90a9ffccf60d972ac5624a65b9cf39c` | Contextual Bottom Sheet | On-screen keyboard active (280px mock), sheet adapts, sticky apply CTA remains visible | **PASS** |
| 10 | `customer_auth_v2_390.png` | 390 × 844 | 22,565 | `dd62c5c7944eb4cf9f42219b658a4cb3eb800d3b` | Customer Auth V2 | **FULL-SCREEN SEQUENTIAL ROUTE FLOW** (Screen 08 phone entry, continuation intent badge, Back arrow) | **PASS** |
| 11 | `owner_home_360.png` | 360 × 800 | 25,153 | `d2dd5be847832897bc2794faab1e7814f598205f` | Owner Top-Level Hub | Action-First Home hub: **NO BOTTOM NAV**, urgent booking action banner, quick operational domain grid, 360px reflow | **PASS** |
| 12 | `owner_home_390.png` | 390 × 844 | 25,526 | `7f1c5baf38326b79ba02e28ac3b56721e1957edd` | Owner Top-Level Hub | Action-First Home hub: **NO BOTTOM NAV**, verified owner identity header, operational cards, unclipped 3-col grid | **PASS** |
| 13 | `owner_home_430.png` | 430 × 932 | 26,007 | `4f35c3994a20808fc8a8ed1bbe1247c2ee344f4a` | Owner Top-Level Hub | Action-First Home hub: **NO BOTTOM NAV**, large 430px viewport, balanced density | **PASS** |
| 14 | `owner_queue_390.png` | 390 × 844 | 18,305 | `1816d68e8033fbdfe0c33aedea4c12c413055a04` | Owner Nested Queue | Bookings operational queue: RTL Back button returning to Home, pending decision card | **PASS** |
| 15 | `owner_detail_390.png` | 390 × 844 | 19,969 | `25caac6bc61ebf91a7e5fa198c6edea1c1145704` | Owner Nested Detail | Booking Detail decision surface: RTL Back, guest info, sticky decision pair (Accept Black / Reject Destructive) | **PASS** |
| 16 | `owner_properties_390.png` | 390 × 844 | 13,922 | `2b65ef7a3573a4a664979d31c6abb17539e25ce7` | Owner Nested Hub | Properties & Availability operational hub: RTL Back, unit inventory card, Add Unit primary CTA | **PASS** |
| 17 | `owner_wallet_390.png` | 390 × 844 | 15,277 | `82dbb98eab7cb13a22368dfb7a982316cb301e6c` | Owner Nested Context | Wallet & Payout hub: RTL Back, available balance in dark card, plain money language, Payout Request CTA | **PASS** |
| 18 | `owner_dialog_390.png` | 390 × 844 | 27,397 | `f75cccaa48f6dd67b2d28b3eadd2da5da522ae6c` | Consequential Dialog | Reject Booking confirmation dialog: centered 12px card, truthful consequence copy without invented SLA/ranking | **PASS** |
| 19 | `dialog_radius_10_owner_390.png` | 390 × 844 | 27,246 | `1b9ee1d0e9355379c3bfc55c2974c5734be819a3` | Dialog Geometry Variant | Consequential Dialog with **10px radius** (valid close alternative, slightly sharper) | **PASS** |
| 20 | `dialog_radius_12_owner_390.png` | 390 × 844 | 27,397 | `f75cccaa48f6dd67b2d28b3eadd2da5da522ae6c` | Dialog Geometry Variant | Consequential Dialog with **12px radius** (provisional candidate, aligned with 4E containers) | **PASS** |
| 21 | `dialog_radius_16_owner_390.png` | 390 × 844 | 27,716 | `96e588b4d036dfedacae88012e074069e659626c` | Dialog Geometry Variant | Consequential Dialog with **16px radius** (softer, rounder card geometry) | **PASS** |
| 22 | `admin_review_queue_1280.png` | 1280 × 900 | 29,783 | `096bf52c60f1b2322fcdc162d57bdfbd8b940a0c` | Admin Desktop Boundary (1280) | Admin operational table workspace at 1280px (UI QA Protocol requirement): desktop horizontal nav, queue table | **PASS** |
| 23 | `admin_review_queue_1440.png` | 1440 × 900 | 29,821 | `ae9eb54bc460117bd308d6814c45cea080f58cb4` | Admin Desktop Boundary (1440) | Admin operational table workspace at 1440px: desktop horizontal navigation, queue table, zero mobile bottom nav | **PASS** |
| 24 | `stress_true_200_customer_detail_390.png` | 390 × 844 | 37,544 | `f7ff9acedd17f140e246c7d7958291b6a01904f7` | Stress & Accessibility | Customer Property Detail under **True 200% Text Scale**: vertical reflow of sticky CTA bar, wrapped titles, zero clipping | **PASS** |
| 25 | `stress_true_200_sheet_390.png` | 390 × 844 | 34,749 | `8cd9706822c7fc8dcd908b389c479b7fd2ce3fe1` | Stress & Accessibility | Bottom Sheet under **True 200% Text Scale**: vertical button stacking in footer, wrapped chip labels, unclipped | **PASS** |
| 26 | `stress_long_arabic_owner_queue_390.png` | 390 × 844 | 18,992 | `c22ca798d8823603846ffc7e2d2d22cded09749c` | Stress & Arabic RTL | Owner Queue with **Long Arabic Strings**: reference ID `#KN-2026-9948271`, multi-line guest name, no clipping | **PASS** |
| 27 | `sheet_radius_12_390.png` | 390 × 844 | 27,467 | `5ad096a23dff2687f50d6caf15ef29ce46d01210` | Overlay Geometry Variant | Bottom sheet with **12px top radius** (strictly matched to 4E container radius) | **PASS** |
| 28 | `sheet_radius_16_390.png` | 390 × 844 | 27,605 | `c0f390129343e6552d6aa4b808ba06cdbace525c` | Overlay Geometry Variant | Bottom sheet with **16px top radius** (balanced mobile sheet curvature — recommended) | **PASS** |
| 29 | `sheet_radius_20_390.png` | 390 × 844 | 27,727 | `90cf042d2df5539389cc86d4c66130ceedb547a7` | Overlay Geometry Variant | Bottom sheet with **20px top radius** (softer, rounder sheet curvature) | **PASS** |

---

## 2. Evidence Integrity & Methodology Audit

- **Independent File Inspection:** All 29 image files exist in `DESIGN_SYSTEM/PILOTS/navigation-overlay-pilot-01/evidence/` with non-zero byte counts.
- **Removed Stale Artifacts:**
  - `customer_dialog_390.png` was permanently removed to prevent inventing Customer cancellation product policy before the cancellation/refund product phase.
- **Screen 16 Account Shell Child Exception (Finding A):**
  - Added `customer_notifications_390.png` (`db560c5e7318498764827e9a6e83bfb2bfde26ab`, 29,674 bytes).
  - Verifies Master Rule MR-17 and UI QA Protocol: Screen 16 retains visible 4-tab bottom navigation with Account tab active (`customerBottomNav('ACCOUNT')`).
- **Admin Dual Viewport Coverage (Finding C):**
  - Added `admin_review_queue_1280.png` (`096bf52c60f1b2322fcdc162d57bdfbd8b940a0c`, 29,783 bytes) alongside `admin_review_queue_1440.png` (`ae9eb54bc460117bd308d6814c45cea080f58cb4`, 29,821 bytes).
  - Satisfies the KONFRM UI QA Protocol requirement for Admin desktop evidence at both 1280px and 1440px viewports.
- **Mobile Horizontal Clipping Repair & CDP Device Emulation (Finding B):**
  - Regenerated all mobile artifacts using precise Chrome DevTools Protocol (CDP) device metrics emulation (`Emulation.setDeviceMetricsOverride`), eliminating the Windows headless Chrome window-size minimum constraint that caused horizontal truncation of leading RTL content.
  - Added vertical reflow rules for 200% text scale in sticky decision surfaces and sheet footers to guarantee `scrollWidth <= clientWidth` and prevent any child element overflow.
- **Added Bounded Dialog Radius Artifacts:**
  - `dialog_radius_10_owner_390.png` (`1b9ee1d0e9355379c3bfc55c2974c5734be819a3`, 27,246 bytes)
  - `dialog_radius_12_owner_390.png` (`f75cccaa48f6dd67b2d28b3eadd2da5da522ae6c`, 27,397 bytes)
  - `dialog_radius_16_owner_390.png` (`96e588b4d036dfedacae88012e074069e659626c`, 27,716 bytes)
  - Distinct byte sizes and hashes confirm true pixel-level geometric rendering differences across radii.
- **Added Bounded Sheet Radius Artifacts:**
  - `sheet_radius_12_390.png` (`5ad096a23dff2687f50d6caf15ef29ce46d01210`, 27,467 bytes)
  - `sheet_radius_16_390.png` (`c0f390129343e6552d6aa4b808ba06cdbace525c`, 27,605 bytes)
  - `sheet_radius_20_390.png` (`90cf042d2df5539389cc86d4c66130ceedb547a7`, 27,727 bytes)
- **Context Restoration Status:**
  - `CUSTOMER_CONTEXT_RESTORATION: CONTRACT_DEFINED_RUNTIME_DEFERRED`. The static HTML pilot demonstrates presentation state and return-path structure; true runtime state restoration (go_router stacks, continuation intent / auth origin context) is deferred to native Flutter implementation and testing.
- **Candidate B Status:**
  - `B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`. Candidate B was evaluated as an architectural hypothesis and eliminated by canonical mobile route architecture (§8) before visual comparison.
