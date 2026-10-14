# KONFRM Customer Screen 13 (Booking Details / Stay Hub — تفاصيل الحجز) — V1 Physical Evidence

**Task ID:** `CUSTOMER_SCREEN13_STAY_HUB_NATIVE_VISUAL_V1`  
**State Target:** `SCREEN13_VISUAL_V1_READY_FOR_FOUNDER_REVIEW`  
**Target Hardware:** Samsung Galaxy A56 5G (Android 16 API 36)  
**Execution Mode:** Visual Design Candidate Verification (Zero production code modifications; 100% isolated native Flutter preview)  
**Evidence Branch:** `evidence/customer-screen13-design-review`  
**Display Framebuffer:** 1080 × 2340 px @ 450 dpi  
**Capture Method:** Native `adb exec-out screencap -p` directly from physical hardware framebuffer  
**Hardware Privacy (Issue #145):** ADB hardware serial numbers and personal hardware identifiers are strictly redacted.

---

## 1. Executive Summary & Design Highlights

Customer Screen 13 (Booking Details / Stay Hub — تفاصيل الحجز) is the focused native screen dedicated to inspecting booking lifecycle details, property metadata, stay dates, guest occupancy, and transparent financial breakdowns. Following Founder approval of Customer Screen 12 V2, this V1 candidate establishes the authoritative native visual model:

1. **Nested Full-Screen Grammar & Root-to-Detail Flow:**
   - Screen 13 is a nested detail destination navigated to from Screen 12 (`حجوزاتي`).
   - Bottom navigation bar is strictly hidden, providing maximum vertical focus and ergonomic clarity.
   - Top App Bar provides a native RTL Back affordance (`→`) returning directly to `حجوزاتي`, centered title `تفاصيل الحجز`, and an explicit Refresh icon button.

2. **Near-Zero-Blue Palette (Monochrome Customer Identity):**
   - Completely adheres to the Founder's Black/White/Neutral design mandate.
   - Pure canvas: `#FAFAFA` background, `#FFFFFF` elevated cards, `#E5E7EB` crisp borders, `#111827` primary Cairo text, and `#6B7280` secondary metadata text.
   - Purged all unapproved blue hues and yellow/amber panic banners.
   - Status badges use restrained semantic tints: `#F3F4F6` (pending review / cancelled / unknown), `#FEF2F2` (deposit required / action needed), and `#F0FDF4` (confirmed stay).

3. **Mathematical Financial Integrity & Truthful Booking Semantics:**
   - Flat-rate pricing invariant: `totalStay == nightlyPrice * nights`.
   - First-night deposit invariant: `depositAmount == nightlyPrice`.
   - Remaining balance invariant: `remainingAmount == totalStay - depositAmount`.
   - Zero invented countdown timers or fabricated 24-hour payment clocks.
   - In `APPROVED_PENDING_PAYMENT`, the primary CTA `دفع العربون ←` (48dp height, 8px provisional radius per Issue #139) clearly indicates that the booking is NOT yet confirmed until deposit payment is settled.
   - In `CONFIRMED`, the deposit is displayed as paid, and no duplicate payment CTA is presented.

4. **Fail-Closed Privacy & Transparent Error Handling:**
   - **401 Unauthorized / Session Expired:** Immediately purges and withholds all cached booking information, displaying a calm re-authentication card.
   - **Stale Cache Refresh Notice:** Retains validated cached data under transient network refresh failure, displaying a calm neutral gray notice banner (`#F3F4F6`) with retry action rather than alarming yellow warning styling.
   - **Unknown Status Fallback:** Safely groups unrecognized backend states under `بيانات الحالة قيد المراجعة` with support affordance, never exposing raw backend enums.

5. **Accessibility & Dynamic Type Reflow:**
   - Validated at 200% text scaling on physical Samsung Galaxy A56 hardware.
   - Uses multiline wrapping and vertical stacking; strictly avoids `FittedBox(fit: BoxFit.scaleDown)` truncation.
   - Primary CTA and Back button remain completely accessible, reachable, and tappable at 200% scale.

---

## 2. Evidence Files Index

| # | Scenario Description | PNG Screenshot | Bridge Companion (Base64) | Resolution | PNG Size |
|---|---|---|---|---|---|
| **01** | **Pending Owner Approval (First Fold Priority, No Payment Due Now)** | [01_screen13_a56_pending_owner_approval.png](01_screen13_a56_pending_owner_approval.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/01_screen13_a56_pending_owner_approval.png)) | [01_visual_bridge.jpg.b64.txt](01_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 171 KB |
| **02** | **Approved Pending Payment (Owner Approved, Deposit Required, Black CTA)** | [02_screen13_a56_approved_pending_payment.png](02_screen13_a56_approved_pending_payment.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/02_screen13_a56_approved_pending_payment.png)) | [02_visual_bridge.jpg.b64.txt](02_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 161 KB |
| **03** | **Confirmed Stay (Deposit Paid, Booking Confirmed, No Payment Button)** | [03_screen13_a56_confirmed_stay.png](03_screen13_a56_confirmed_stay.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/03_screen13_a56_confirmed_stay.png)) | [03_visual_bridge.jpg.b64.txt](03_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 170 KB |
| **04** | **Cancelled Historical (Guest Cancelled, Read-Only Details & Reason)** | [04_screen13_a56_cancelled_historical.png](04_screen13_a56_cancelled_historical.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/04_screen13_a56_cancelled_historical.png)) | [04_visual_bridge.jpg.b64.txt](04_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 156 KB |
| **05** | **Unknown Status Fallback (Calm Neutral Status, No Invented Timers)** | [05_screen13_a56_unknown_status_fallback.png](05_screen13_a56_unknown_status_fallback.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/05_screen13_a56_unknown_status_fallback.png)) | [05_visual_bridge.jpg.b64.txt](05_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 157 KB |
| **06** | **Long Title & Booking Code (Graceful Multiline Text Wrapping)** | [06_screen13_a56_long_title_and_code.png](06_screen13_a56_long_title_and_code.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/06_screen13_a56_long_title_and_code.png)) | [06_visual_bridge.jpg.b64.txt](06_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 180 KB |
| **07** | **Accessibility 200% Text Scaling — Top Fold (No Overflow, Natural Reflow)** | [07_screen13_a56_accessibility_200_top.png](07_screen13_a56_accessibility_200_top.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/07_screen13_a56_accessibility_200_top.png)) | [07_visual_bridge.jpg.b64.txt](07_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 152 KB |
| **08** | **Accessibility 200% Text Scaling — Scrolled (Reachable Primary CTA)** | [08_screen13_a56_accessibility_200_scrolled.png](08_screen13_a56_accessibility_200_scrolled.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/08_screen13_a56_accessibility_200_scrolled.png)) | [08_visual_bridge.jpg.b64.txt](08_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 130 KB |
| **09** | **Initial Loading State (Honest Skeleton, Zero Fake Data, Back Button Active)** | [09_screen13_a56_initial_loading_skeleton.png](09_screen13_a56_initial_loading_skeleton.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/09_screen13_a56_initial_loading_skeleton.png)) | [09_visual_bridge.jpg.b64.txt](09_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 36 KB |
| **10** | **Unauthorized / Session Expired 401 (Fail-Closed, Zero Private Data Leak)** | [10_screen13_a56_unauthorized_session_expired.png](10_screen13_a56_unauthorized_session_expired.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/10_screen13_a56_unauthorized_session_expired.png)) | [10_visual_bridge.jpg.b64.txt](10_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 64 KB |
| **11** | **Stale Cache Refresh Notice (Retains Validated Data, Neutral Notice Banner)** | [11_screen13_a56_stale_cache_refresh_notice.png](11_screen13_a56_stale_cache_refresh_notice.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v1/11_screen13_a56_stale_cache_refresh_notice.png)) | [11_visual_bridge.jpg.b64.txt](11_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 157 KB |

---

## 3. Companion Documents & Reproducibility Source

- **Full Verification Report (12 Mandatory Sections):** [REPORT.md](REPORT.md)
- **Visual Bridge Text Companions & SHA-256 Manifest:** [VISUAL_BRIDGE_README.md](VISUAL_BRIDGE_README.md)
- **Isolated Flutter Preview Runner Source:** [review-source/screen13_preview_runner_v1.dart](review-source/screen13_preview_runner_v1.dart)
- **Runner Launch Recipe & Specifications:** [review-source/README.md](review-source/README.md)
