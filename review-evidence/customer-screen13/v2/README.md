# KONFRM Customer Screen 13 (Booking Details / Stay Hub — تفاصيل الحجز) — V2 Focused Physical Evidence

**Task ID:** `CUSTOMER_SCREEN13_STAY_HUB_FOCUSED_V2`  
**State Target:** `SCREEN13_V2_AWAITING_FOUNDER_VISUAL_REVIEW`  
**Target Hardware:** Samsung Galaxy A56 5G (Android 16 API 36)  
**Execution Mode:** Focused Corrective Design Prototype (Zero production code modifications; 100% isolated native Flutter preview)  
**Evidence Branch:** `evidence/customer-screen13-design-review`  
**Display Framebuffer:** 1080 × 2340 px @ 450 dpi  
**Capture Method:** Native `adb shell screencap -p` directly from physical hardware framebuffer  
**Hardware Privacy (Issue #145):** ADB hardware serial numbers and personal hardware identifiers are strictly redacted.

---

## 1. Executive Summary & V2 Corrective Highlights

Following the independent Bridge visual audit of Screen 13 V1 (Issue #151), this V2 focused candidate delivers all four mandated repairs with mathematical precision, calm monochrome elegance, and physical verification on the real Samsung Galaxy A56 5G:

1. **Repair A — Civil Date Truth & Weekday Accuracy:**
   - Fixtures now utilize structured ISO 8601 civil dates (`checkInIso`, `checkOutIso`), parsed into `DateTime` and formatted via `CivilDateFormatter`.
   - **Weekdays are 100% verified against the Gregorian calendar:**
     - `2026-10-20` is **الثلاثاء** (Tuesday) — fixed from V1's false `الأحد`.
     - `2026-10-25` is **الأحد** (Sunday) — fixed from V1's false `الجمعة`.
     - `2027-01-10` is **الأحد** (Sunday) — fixed from V1's false `السبت`.
     - `2027-01-16` is **السبت** (Saturday) — fixed from V1's false `الجمعة`.
   - Automated startup assertion `assertFixtureIntegrity` verifies `nights == checkOutDateTime.difference(checkInDateTime).inDays` for every record.

2. **Repair B — Truthful, Reassuring, SLA-Free Copy:**
   - **PENDING_OWNER_APPROVAL:** Purged unverified notification SLAs (no false promises of push/SMS/email delivery times).
   - **EXPIRED:** Purged all fabricated countdown clocks and fake urgency timers.
   - **UNKNOWN:** Calibrated to `حالة الحجز غير متاحة حاليًا` with customer support assistance affordance.
   - **CANCELLED_BY_GUEST:** Removed false re-booking availability promises.

3. **Repair C — Complete State Coverage & Fail-Closed Privacy:**
   - Expanded state coverage to 15 distinct deterministic scenarios:
     - `401 Unauthorized / Session Expired`: Fail-closed screen completely withholding booking data.
     - `403 Forbidden / Access Denied`: Neutral error screen preventing property ownership or tenant leakage.
     - `404 Not Found`: Calm neutral screen without status guesswork.
     - `Network Error Without Cache`: Clear connection error screen with primary retry CTA.
     - `Dynamic In-Flight 401 Purge (Scenario 15)`: Simulates real-time session expiration by immediately evicting sensitive memory data.
     - `Stale Cache With Disabled CTA (Scenario 11)`: Clearly displays cached data with neutral refresh warning and a muted, locked payment button (`بانتظار تحديث الحالة... 🔒`) to prevent payments on stale records.

4. **Repair D — First-Fold Deposit Visibility & Anti-Card-Soup Restraint:**
   - **First-Fold Deposit Prominence:** In `APPROVED_PENDING_PAYMENT`, a dedicated `#F9FAFB` pill prominently displays `العربون المطلوب للتأكيد: 2,700 ج.م` directly above the black primary CTA `دفع العربون ←` within the first fold.
   - **Anti-Card-Soup:** Eliminated heavy nested card borders from inside the Stay Details card. Replaced with calm, soft `#F9FAFB` fills for arrival/departure dates.
   - **RTL Reading Order:** Property thumbnail is anchored on the right edge (first child in RTL Row), creating a natural Arabic reading flow next to title and location.
   - **Financial Formatting:** Comma thousands separators (`2,700`, `13,500`, `51,000`) applied across all figures.
   - **200% Accessibility Scaling:** Vertical stacking and flexible CTA button height eliminate all horizontal overflow at 200% dynamic type scale.

---

## 2. Evidence Files Index

| # | Scenario Description | PNG Screenshot | Bridge Companion (Base64) | Resolution | PNG Size |
|---|---|---|---|---|---|
| **01** | **Pending Owner Approval (First Fold Priority, No Payment Due Now, Calibrated Copy)** | [01_screen13_a56_pending_owner_approval.png](01_screen13_a56_pending_owner_approval.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/01_screen13_a56_pending_owner_approval.png)) | [01_visual_bridge.jpg.b64.txt](01_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 180 KB |
| **02** | **Approved Pending Payment (Owner Approved, Deposit Required Visible Above Black CTA)** | [02_screen13_a56_approved_pending_payment.png](02_screen13_a56_approved_pending_payment.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/02_screen13_a56_approved_pending_payment.png)) | [02_visual_bridge.jpg.b64.txt](02_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 167 KB |
| **03** | **Confirmed Stay (Deposit Paid, Booking Confirmed, No Payment Button)** | [03_screen13_a56_confirmed_stay.png](03_screen13_a56_confirmed_stay.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/03_screen13_a56_confirmed_stay.png)) | [03_visual_bridge.jpg.b64.txt](03_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 167 KB |
| **04** | **Cancelled Historical (Guest Cancelled, Read-Only Details & Reason, Zero Re-book Promises)** | [04_screen13_a56_cancelled_historical.png](04_screen13_a56_cancelled_historical.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/04_screen13_a56_cancelled_historical.png)) | [04_visual_bridge.jpg.b64.txt](04_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 157 KB |
| **05** | **Unknown Status Fallback (Calm Neutral Status, No Invented Timers)** | [05_screen13_a56_unknown_status_fallback.png](05_screen13_a56_unknown_status_fallback.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/05_screen13_a56_unknown_status_fallback.png)) | [05_visual_bridge.jpg.b64.txt](05_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 140 KB |
| **06** | **Long Title & Booking Code (Graceful Multiline Text Wrapping, 2027 True Dates)** | [06_screen13_a56_long_title_and_code.png](06_screen13_a56_long_title_and_code.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/06_screen13_a56_long_title_and_code.png)) | [06_visual_bridge.jpg.b64.txt](06_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 183 KB |
| **07** | **Accessibility 200% Text Scaling — Top Fold (Vertical Stacking, No Overflow)** | [07_screen13_a56_accessibility_200_top.png](07_screen13_a56_accessibility_200_top.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/07_screen13_a56_accessibility_200_top.png)) | [07_visual_bridge.jpg.b64.txt](07_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 153 KB |
| **08** | **Accessibility 200% Text Scaling — Scrolled (Stay Details & Payment Breakdown)** | [08_screen13_a56_accessibility_200_scrolled.png](08_screen13_a56_accessibility_200_scrolled.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/08_screen13_a56_accessibility_200_scrolled.png)) | [08_visual_bridge.jpg.b64.txt](08_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 154 KB |
| **09** | **Initial Loading State (Honest Skeleton, Zero Fake Data, Back Button Active)** | [09_screen13_a56_initial_loading_skeleton.png](09_screen13_a56_initial_loading_skeleton.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/09_screen13_a56_initial_loading_skeleton.png)) | [09_visual_bridge.jpg.b64.txt](09_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 35 KB |
| **10** | **Unauthorized / Session Expired 401 (Fail-Closed, Zero Private Data Leak)** | [10_screen13_a56_unauthorized_session_expired.png](10_screen13_a56_unauthorized_session_expired.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/10_screen13_a56_unauthorized_session_expired.png)) | [10_visual_bridge.jpg.b64.txt](10_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 65 KB |
| **11** | **Stale Cache Refresh Notice (Retains Validated Data, Neutral Notice, CTA Disabled)** | [11_screen13_a56_stale_cache_refresh_notice.png](11_screen13_a56_stale_cache_refresh_notice.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/11_screen13_a56_stale_cache_refresh_notice.png)) | [11_visual_bridge.jpg.b64.txt](11_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 155 KB |
| **12** | **Forbidden / Access Denied 403 (Safe Fail-Closed View, No Ownership Leak)** | [12_screen13_a56_forbidden_access_denied.png](12_screen13_a56_forbidden_access_denied.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/12_screen13_a56_forbidden_access_denied.png)) | [12_visual_bridge.jpg.b64.txt](12_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 65 KB |
| **13** | **Not Found 404 (Neutral Safe View, No State Guessing)** | [13_screen13_a56_not_found_booking.png](13_screen13_a56_not_found_booking.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/13_screen13_a56_not_found_booking.png)) | [13_visual_bridge.jpg.b64.txt](13_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 66 KB |
| **14** | **Network Error Without Cache (Honest Error Screen with Retry CTA)** | [14_screen13_a56_no_cache_error.png](14_screen13_a56_no_cache_error.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/14_screen13_a56_no_cache_error.png)) | [14_visual_bridge.jpg.b64.txt](14_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 69 KB |
| **15** | **Dynamic 401 In-Flight Purge Transition (Instant Sensitive Data Eviction)** | [15_screen13_a56_simulated_401_purge_transition.png](15_screen13_a56_simulated_401_purge_transition.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen13-design-review/review-evidence/customer-screen13/v2/15_screen13_a56_simulated_401_purge_transition.png)) | [15_visual_bridge.jpg.b64.txt](15_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 74 KB |

---

## 3. Companion Documents & Reproducibility Source

- **Full Verification Report (12 Mandatory Sections):** [REPORT.md](REPORT.md)
- **Visual Bridge Text Companions & SHA-256 Manifest:** [VISUAL_BRIDGE_README.md](VISUAL_BRIDGE_README.md)
- **Isolated Flutter Preview Runner Source:** [review-source/screen13_preview_runner_v2.dart](review-source/screen13_preview_runner_v2.dart)
- **Runner Launch Recipe & Specifications:** [review-source/README.md](review-source/README.md)
