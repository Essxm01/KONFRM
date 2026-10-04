# Phase 4F Visual Evidence Manifest

**Pilot Directory:** `DESIGN_SYSTEM/PILOTS/navigation-overlay-pilot-01/`
**Evidence Subdirectory:** `evidence/`
**Generation Engine:** Google Chrome Headless (`chrome.exe --headless=new --hide-scrollbars`)
**Base Commit SHA:** `ff4ac0b4322b8a7c50273dd7a459a93dcf090551`
**Artifact Total:** 27 rendered image artifacts
**Data Status:** `LAB_SCENARIO_DATA`
*(All names, booking IDs, property records, and metrics are synthetic lab scenario data for visual, layout, and presentation testing only — `LAB_SCENARIO_DATA ≠ production evidence`).*

---

## 1. Complete Artifact Register

| # | Artifact Filename | Dimensions (W×H) | Size (Bytes) | Git Blob SHA | Role / Screen Family | Key Inspected Feature / Verification Criteria | Outcome |
|---|---|---|---|---|---|---|---|
| 1 | `customer_explore_360.png` | 360 × 800 | 14,377 | `f90e8bb8d671becfdb01b97942c3c68b3903b5c4` | Customer Top-Level | 4-tab bottom nav, Explore header (brand + account affordance, no Bell), 360px compact reflow | **PASS** |
| 2 | `customer_explore_390.png` | 390 × 844 | 15,520 | `823b900c15e5ae2d59eb117123768264493e3bee` | Customer Top-Level | 4-tab bottom nav, Explore header, baseline iPhone 390px viewport, active tab styling | **PASS** |
| 3 | `customer_explore_430.png` | 430 × 932 | 17,581 | `38ab0c370efd3d0d633dcd9f489279bde1949ac7` | Customer Top-Level | 4-tab bottom nav, large 430px viewport, edge alignment, safe margins | **PASS** |
| 4 | `customer_detail_390.png` | 390 × 844 | 20,400 | `1a154a528be6738a5a2a6e8782bdcbaefe65ad10` | Customer Nested Entity | Nested Property Detail: RTL Back button, hero image, sticky CTA bar, bottom nav hidden | **PASS** |
| 5 | `candidate_a_customer_detail_390.png` | 390 × 844 | 22,737 | `0d869a16043aac99cc26e4c97b5cd438d2761922` | Customer Nested (Candidate A) | **DUAL BOTTOM CHROME DEFECT**: Competing persistent bottom action regions (sticky CTA stacked on bottom nav) | **FAIL (Defect)** |
| 6 | `candidate_c_customer_detail_390.png` | 390 × 844 | 20,400 | `1a154a528be6738a5a2a6e8782bdcbaefe65ad10` | Customer Nested (Candidate C) | **ROLE-AWARE CONTEXTUAL**: Clean single bottom chrome (sticky CTA replaces bottom nav with RTL Back) | **PASS** |
| 7 | `customer_sheet_390.png` | 390 × 844 | 15,739 | `b9cb4aa366b02feba816160ee79acaa5b6c2b4a5` | Contextual Bottom Sheet | Search refine filter sheet, optional drag handle, 16px top radius, explicit Close (X), dimmed scrim | **PASS** |
| 8 | `customer_sheet_keyboard_390.png` | 390 × 844 | 19,727 | `092c833eb4d0e932fa7e2d1adcc2ab2a3a1383c0` | Contextual Bottom Sheet | On-screen keyboard active (280px mock), sheet adapts, sticky apply CTA remains visible | **PASS** |
| 9 | `customer_auth_v2_390.png` | 390 × 844 | 16,177 | `cfb7aebf7f731dbf55024a3c5620906368639f25` | Customer Auth V2 | **FULL-SCREEN SEQUENTIAL ROUTE FLOW** (Screen 08 phone entry, continuation intent badge, Back arrow) | **PASS** |
| 10 | `owner_home_360.png` | 360 × 800 | 14,710 | `2108f18ec3acee40aa8bfe78db4c9966439a8745` | Owner Top-Level Hub | Action-First Home hub: **NO BOTTOM NAV**, urgent booking action banner, quick operational domain grid | **PASS** |
| 11 | `owner_home_390.png` | 390 × 844 | 17,580 | `82a1d9e44a5268fd2b05578ee671890498c1185d` | Owner Top-Level Hub | Action-First Home hub: **NO BOTTOM NAV**, verified owner identity header, operational cards | **PASS** |
| 12 | `owner_home_430.png` | 430 × 932 | 21,570 | `f7f3e2d92d239a3c166b2eedbea09d052f3437af` | Owner Top-Level Hub | Action-First Home hub: **NO BOTTOM NAV**, large 430px viewport, balanced density | **PASS** |
| 13 | `owner_queue_390.png` | 390 × 844 | 12,540 | `df8abe192552cd845d2a1d8ceb32fd069db9f0d2` | Owner Nested Queue | Bookings operational queue: RTL Back button returning to Home, pending decision card | **PASS** |
| 14 | `owner_detail_390.png` | 390 × 844 | 15,436 | `920ba4f1e1de60247c7b660cee2a6f0480e35b97` | Owner Nested Detail | Booking Detail decision surface: RTL Back, guest info, sticky decision pair (Accept Black / Reject Destructive) | **PASS** |
| 15 | `owner_properties_390.png` | 390 × 844 | 11,180 | `348d8a0bec21d5f51f619e9164e5c05d7be7819c` | Owner Nested Hub | Properties & Availability operational hub: RTL Back, unit inventory card, Add Unit primary CTA | **PASS** |
| 16 | `owner_wallet_390.png` | 390 × 844 | 10,529 | `7ca0f5ac9fb0e44d5d471409823c5f9c6a4a3b88` | Owner Nested Context | Wallet & Payout hub: RTL Back, available balance in dark card, plain money language, Payout Request CTA | **PASS** |
| 17 | `owner_dialog_390.png` | 390 × 844 | 22,540 | `8399afdf934e520585e2804c52e5e1744e0a6bfe` | Consequential Dialog | Reject Booking confirmation dialog: centered 12px card, truthful consequence copy without invented SLA/ranking | **PASS** |
| 18 | `dialog_radius_10_owner_390.png` | 390 × 844 | 22,441 | `e29b40d5cab19599c74d86bf55f9ad7b4ff7806b` | Dialog Geometry Variant | Consequential Dialog with **10px radius** (valid close alternative, slightly sharper) | **PASS** |
| 19 | `dialog_radius_12_owner_390.png` | 390 × 844 | 22,540 | `8399afdf934e520585e2804c52e5e1744e0a6bfe` | Dialog Geometry Variant | Consequential Dialog with **12px radius** (provisional candidate, aligned with 4E containers) | **PASS** |
| 20 | `dialog_radius_16_owner_390.png` | 390 × 844 | 22,609 | `f9d53668a2913e93fe518a35f0c7816163d96e98` | Dialog Geometry Variant | Consequential Dialog with **16px radius** (softer, rounder card geometry) | **PASS** |
| 21 | `admin_review_queue_1440.png` | 1440 × 900 | 30,251 | `5fa9c01ddbeeac8a7ebba06aab78ee860981d226` | Admin Desktop Boundary | Admin operational table workspace: desktop horizontal navigation, queue table, zero mobile bottom nav | **PASS** |
| 22 | `stress_true_200_customer_detail_390.png` | 390 × 844 | 25,388 | `d90842f0283ac5e53c3e2c87f601fc693ba905e5` | Stress & Accessibility | Customer Property Detail under **True 200% Text Scale**: Cairo Profile B titles, buttons, sticky CTA reflow | **PASS** |
| 23 | `stress_true_200_sheet_390.png` | 390 × 844 | 22,869 | `b2b452386e5761e0be3e0e983b326e5abb08ef67` | Stress & Accessibility | Bottom Sheet under **True 200% Text Scale**: headers, filter labels, and buttons wrap without truncation | **PASS** |
| 24 | `stress_long_arabic_owner_queue_390.png` | 390 × 844 | 13,390 | `f1482ab95b9a300673e38cdae13c2649624eb54f` | Stress & Arabic RTL | Owner Queue with **Long Arabic Strings**: reference ID `#KN-2026-9948271`, multi-line guest name, no clipping | **PASS** |
| 25 | `sheet_radius_12_390.png` | 390 × 844 | 15,636 | `52e814aae9efe1b04f876d85d45615c44136f3d6` | Overlay Geometry Variant | Bottom sheet with **12px top radius** (strictly matched to 4E container radius) | **PASS** |
| 26 | `sheet_radius_16_390.png` | 390 × 844 | 15,739 | `b9cb4aa366b02feba816160ee79acaa5b6c2b4a5` | Overlay Geometry Variant | Bottom sheet with **16px top radius** (balanced mobile sheet curvature — recommended) | **PASS** |
| 27 | `sheet_radius_20_390.png` | 390 × 844 | 15,771 | `e21e39fd09a1e3724a6d2127464a2c4c05d179ed` | Overlay Geometry Variant | Bottom sheet with **20px top radius** (softer, rounder sheet curvature) | **PASS** |

---

## 2. Evidence Integrity & Methodology Audit

- **Independent File Inspection:** All 27 image files exist in `DESIGN_SYSTEM/PILOTS/navigation-overlay-pilot-01/evidence/` with non-zero byte counts.
- **Removed Stale Artifacts:**
  - `customer_dialog_390.png` was permanently removed to prevent inventing Customer cancellation product policy before the cancellation/refund product phase.
- **Regenerated Impacted Artifacts:**
  - `owner_home_360.png`, `owner_home_390.png`, `owner_home_430.png` were regenerated to remove the unapproved 4-hour SLA claim.
  - `owner_dialog_390.png` was regenerated with truthful consequence copy: "سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون." (removing unapproved claims regarding availability reopening, rankings, deadlines, or penalties).
- **Added Bounded Dialog Radius Artifacts:**
  - `dialog_radius_10_owner_390.png` (`e29b40d5cab19599c74d86bf55f9ad7b4ff7806b`, 22,441 bytes)
  - `dialog_radius_12_owner_390.png` (`8399afdf934e520585e2804c52e5e1744e0a6bfe`, 22,540 bytes)
  - `dialog_radius_16_owner_390.png` (`f9d53668a2913e93fe518a35f0c7816163d96e98`, 22,609 bytes)
  - Distinct byte sizes and hashes confirm true pixel-level geometric rendering differences across radii.
- **Context Restoration Status:**
  - `CUSTOMER_CONTEXT_RESTORATION: CONTRACT_DEFINED_RUNTIME_DEFERRED`. The static HTML pilot demonstrates presentation state and return-path structure; true runtime state restoration (go_router stacks, continuation intent / auth origin context) is deferred to native Flutter implementation and testing.
- **Candidate B Status:**
  - `B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`. Candidate B was evaluated as an architectural hypothesis and eliminated by canonical mobile route architecture (§8) before visual comparison.
