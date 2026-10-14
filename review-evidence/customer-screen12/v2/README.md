# KONFRM Customer Screen 12 (My Bookings / حجوزاتي) — V2 Physical Evidence

**Task ID:** `CUSTOMER_SCREEN12_MY_BOOKINGS_FOCUSED_V2`  
**State Target:** `SCREEN12_V2_AWAITING_FOUNDER_VISUAL_REVIEW`  
**Target Hardware:** Samsung Galaxy A56 5G (Android 16 API 36)  
**Execution Mode:** Visual Design Candidate Verification (Zero production code modifications; 100% isolated native Flutter preview)  
**Evidence Branch:** `evidence/customer-screen12-design-review`  
**Display Framebuffer:** 1080 × 2340 px @ 450 dpi  
**Capture Method:** Native `adb exec-out screencap -p` directly from physical hardware framebuffer  
**Hardware Privacy (Issue #145):** ADB hardware serial numbers and personal hardware identifiers are strictly redacted.

---

## 1. Executive Summary & V2 Focused Refinements

Customer Screen 12 (My Bookings / حجوزاتي) is the root customer tab dedicated to managing stay requests, active bookings, and reservation history. Following the independent review of V1, this V2 candidate implements all 6 focused structural and aesthetic corrections required by the Founder and Bridge:

1. **FIX A — Near-Zero-Blue Palette (Customer Monochrome Direction):**
   - Completely purged all unapproved blue hues (`#2563EB`, `#1D4ED8`, `#93C5FD`, `#EFF6FF`, `#BFDBFE`) from card borders, countdown chips, actionable outlines, and stale cache notification backgrounds.
   - Enforced a calm, authoritative monochrome black/white/neutral palette: `#FFFFFF` card surfaces, `#E5E7EB` borders, `#111827` primary text, `#6B7280` secondary text, and neutral badge backgrounds (`#F3F4F6` for review, `#FEF2F2` for action required, `#F0FDF4` for confirmed).

2. **FIX B — Truthful Booking State & Removal of Fake Deadlines:**
   - Eradicated invented 24-hour payment deadlines and simulated countdown clocks (`متبقي 12:45:00`).
   - Replaced with truthful deposit state representation (`العربون مطلوب`), honest financial summaries, and a prominent black CTA button (`تفاصيل الحجز والسداد ←`, 48dp height, 8px provisional radius).

3. **FIX C — Mathematical Fixture Consistency & Runtime Integrity:**
   - Corrected all synthetic fixtures to guarantee flat-rate pricing invariants: `nightlyPrice * nights == totalStay` and `depositAmount == nightlyPrice`.
   - Integrated an automated startup assertion `assertFixtureIntegrity()` that halts execution if any fixture deviates from canonical math.

4. **FIX D — Removal of Unverified Trust Badges:**
   - Completely removed the unconditional `موثق` (Verified) trust badge from property thumbnail placeholders across all scenarios.

5. **FIX E — State Coverage Completeness (Scenarios 08 & 09):**
   - Added **Scenario 08 (Initial Loading Skeleton):** A calm, honest skeleton loading state with non-actionable controls and zero fake counts.
   - Added **Scenario 09 (Unknown Status Fallback):** Unrecognized backend statuses are grouped safely and honestly under `حجوزات أخرى` with a neutral badge and support affordance.

6. **FIX F — Comfortable Optical Spacing & Canonical Navigation:**
   - Rebalanced all state screens (Guest Unauthorized, Session Expired, True Empty, Network Error) from heavy center slabs into elegant, airy vertical compositions with refined relational spacing.
   - Integrated the canonical 4-tab bottom navigation (`استكشاف`, `حجوزاتي`, `المفضلة`, `حسابي`) with active tab correctly set to index 2 (`حجوزاتي`), styled with a subtle `#F3F4F6` indicator pill and pure black icon/label.

---

## 2. Evidence Files Index

| # | Scenario Description | PNG Screenshot | Bridge Companion (Base64) | Resolution | PNG Size |
|---|---|---|---|---|---|
| **01** | **Loaded: Action Required (First Fold Priority)** | [01_screen12_a56_loaded_action_required.png](01_screen12_a56_loaded_action_required.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/01_screen12_a56_loaded_action_required.png)) | [01_visual_bridge.jpg.b64.txt](01_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 181 KB |
| **02** | **Loaded: Current & Past Bookings (Scrolled)** | [02_screen12_a56_loaded_current_and_history.png](02_screen12_a56_loaded_current_and_history.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/02_screen12_a56_loaded_current_and_history.png)) | [02_visual_bridge.jpg.b64.txt](02_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 177 KB |
| **03** | **Guest / Unauthorized State** | [03_screen12_a56_guest_unauthorized.png](03_screen12_a56_guest_unauthorized.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/03_screen12_a56_guest_unauthorized.png)) | [03_visual_bridge.jpg.b64.txt](03_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 98 KB |
| **04** | **Session Expired State** | [04_screen12_a56_session_expired.png](04_screen12_a56_session_expired.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/04_screen12_a56_session_expired.png)) | [04_visual_bridge.jpg.b64.txt](04_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 94 KB |
| **05** | **Authenticated True Empty State** | [05_screen12_a56_true_empty.png](05_screen12_a56_true_empty.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/05_screen12_a56_true_empty.png)) | [05_visual_bridge.jpg.b64.txt](05_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 91 KB |
| **06** | **Network Error with Retry State** | [06_screen12_a56_error_retry.png](06_screen12_a56_error_retry.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/06_screen12_a56_error_retry.png)) | [06_visual_bridge.jpg.b64.txt](06_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 93 KB |
| **07** | **Stale Cache Refresh Notice State** | [07_screen12_a56_stale_cache_with_notice.png](07_screen12_a56_stale_cache_with_notice.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/07_screen12_a56_stale_cache_with_notice.png)) | [07_visual_bridge.jpg.b64.txt](07_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 172 KB |
| **08** | **Initial Loading State (Skeleton)** | [08_screen12_a56_initial_loading.png](08_screen12_a56_initial_loading.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/08_screen12_a56_initial_loading.png)) | [08_visual_bridge.jpg.b64.txt](08_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 70 KB |
| **09** | **Unknown Status State (Other Bookings)** | [09_screen12_a56_unknown_status.png](09_screen12_a56_unknown_status.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/09_screen12_a56_unknown_status.png)) | [09_visual_bridge.jpg.b64.txt](09_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 168 KB |
| **10** | **Accessibility Text Scaling (200% Reflow)** | [10_screen12_a56_accessibility_200.png](10_screen12_a56_accessibility_200.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v2/10_screen12_a56_accessibility_200.png)) | [10_visual_bridge.jpg.b64.txt](10_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 179 KB |

---

## 3. Companion Documents & Reproducibility Source

- **Full Verification Report:** [REPORT.md](REPORT.md)
- **Visual Bridge Text Companions & SHA-256 Manifest:** [VISUAL_BRIDGE_README.md](VISUAL_BRIDGE_README.md)
- **Isolated Flutter Preview Runner Source:** [review-source/screen12_preview_runner_v2.dart](review-source/screen12_preview_runner_v2.dart)
- **Runner Launch Recipe & Specifications:** [review-source/README.md](review-source/README.md)
