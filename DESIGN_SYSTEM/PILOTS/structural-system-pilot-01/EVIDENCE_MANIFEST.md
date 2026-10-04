# KONFRM Phase 4E — Evidence Manifest

**Phase:** Phase 4E — Structural System
**Pilot:** `structural-system-pilot-01`
**Location:** `DESIGN_SYSTEM/PILOTS/structural-system-pilot-01/evidence/`
**Total Artifacts:** 18
**Format:** PNG (Rendered via Headless Chromium, Cairo Variable Font, native Arabic RTL)
**Date:** 2026-10-04

---

## Visual Evidence Inventory

| # | Filename | Role | Candidate | Viewport | Scale | Stress | Description & Observed Behavior | Status |
|---|---|---|---|---|---|---|---|---|
| 01 | `candidate_a_customer_detail_390.png` | Customer | A (Open/Editorial) | 390×844 | 100% | Normal | Open property details. Minimal containers; facts separated by clean 1px dividers; quote bounded by top/bottom dividers. Highly readable, generous hospitality feel. | PASS |
| 02 | `candidate_b_customer_detail_390.png` | Customer | B (Modular/Contained) | 390×844 | 100% | Normal | Fully contained modules. Facts enclosed in a rounded-12px box; quote enclosed in rounded-16px container. High containment, but increases visual complexity and card framing. | PASS |
| 03 | `candidate_c_customer_detail_390.png` | Customer | C (Role Hybrid) | 390×844 | 100% | Normal | Open editorial facts row + bounded single-surface quote breakdown with 12px container radius. Ideal balance: unboxed editorial hospitality above, clear financial decision unit below. | PASS (Recommended) |
| 04 | `candidate_a_owner_home_390.png` | Owner | A (Open/Editorial) | 390×844 | 100% | Normal | Open operational sections. Minimal card framing. Works well for simple lists, but urgent attention banner lacks strong physical boundary contrast. | PASS |
| 05 | `candidate_b_owner_home_390.png` | Owner | B (Modular/Contained) | 390×844 | 100% | Normal | Heavy modular card stack. Every section is a bordered card with subtle shadow. Clear boundaries, but high card density on small screens creates visual repetition. | PASS |
| 06 | `candidate_c_owner_home_390.png` | Owner | C (Role Hybrid) | 390×844 | 100% | Normal | Connected operational groups with clean internal dividers (`Open Grouped Content`). High scanability, zero card soup, clear 12px container geometry. | PASS (Recommended) |
| 07 | `customer_detail_360.png` | Customer | C | 360×800 | 100% | Normal | Compact Android viewport test. Facts row reflows gracefully; zero horizontal clipping; Cairo Profile B remains comfortably readable. | PASS |
| 08 | `customer_detail_390.png` | Customer | C | 390×844 | 100% | Normal | Baseline iOS viewport test. Balanced vertical rhythm (24px section gap); clear hierarchy from imagery to quote to sticky decision CTA. | PASS |
| 09 | `customer_detail_430.png` | Customer | C | 430×932 | 100% | Normal | Large mobile viewport test. 16px page insets expand gracefully; no awkward empty horizontal stretches; content stays naturally proportioned. | PASS |
| 10 | `customer_results_390.png` | Customer | C | 390×844 | 100% | Normal | Explore search results stack. 1.4:1 photography ratio; prominent price anchor (16,500 ج.م / ليلة); 12px card corners; zero synthetic badges. | PASS |
| 11 | `owner_home_360.png` | Owner | C | 360×800 | 100% | Normal | Compact Android operational view. Attention banner fits without text truncation; financial columns wrap comfortably; zero overflow. | PASS |
| 12 | `owner_home_390.png` | Owner | C | 390×844 | 100% | Normal | Baseline Owner Home. Urgent booking banner stands out; 64,000 ج.م available balance is prominently scannable; clean connected property rows. | PASS |
| 13 | `owner_home_430.png` | Owner | C | 430×932 | 100% | Normal | Large mobile Owner Home. Connected rows maintain excellent density without feeling loose or sparse. | PASS |
| 14 | `owner_queue_390.png` | Owner | C | 390×844 | 100% | Normal | Operational Bookings Queue. Single connected group with divider-separated rows (`Open Grouped Content`), compact status badges, and inline actions. Zero card soup. | PASS |
| 15 | `admin_review_queue_1440.png` | Admin | C | 1440×900 | 100% | Normal | Desktop Admin Operational Workspace. 3 metric KPI cards + compact search/filter bar + dense FIFO review data table with 8px radius. Proves Admin does NOT use mobile cards. | PASS |
| 16 | `stress_text_scale_200.png` | Customer | C | 390×844 | 200% | Normal | True 200% text-scale stress test. Cairo Profile B scales to 2× size; words wrap gracefully onto multiple lines; zero text clipping or container overflow. | PASS |
| 17 | `stress_long_arabic_390.png` | Customer | C | 390×844 | 100% | Stress | Extreme Arabic copy stress: 4-line property title, multi-line destination string, 37,000 ج.م nightly price, long description. Layout handles extreme copy smoothly. | PASS |
| 18 | `stress_reflow_360_width.png` | Owner | C | 360×800 | 100% | Stress | Owner queue under 360px width with stress copy and multi-line metadata. Action buttons remain easily tappable (min 36–42px); zero horizontal trapped content. | PASS |

---

## Observed QA Findings & Verifications

1. **Card Soup Check: PASSED.**
   Candidate C replaces isolated stacked cards in Owner Queue and Property Facts with `Open Grouped Content` (one container, internal 1px dividers), reducing DOM container count by over 50% compared to Candidate B.
2. **Text Scaling Check: PASSED.**
   Under 200% text scaling (`stress_text_scale_200.png`), all essential facts, prices, and booking information remain accessible and readable. No clipping or truncation observed.
3. **Admin Desktop Boundary: PASSED.**
   `admin_review_queue_1440.png` verifies that Admin maintains a dense desktop operational table workspace with 8px corner radii and clean tabular rows, completely immune to mobile-card styling drift.
4. **Bidi / Numeric Order: PASSED.**
   In all views, Western Arabic numerals (`16,500`, `82,500`, `37,000`) maintain canonical Arabic currency suffix order (`ج.م / ليلة`).
