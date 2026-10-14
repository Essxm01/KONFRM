# KONFRM Customer Screen 12 (My Bookings / حجوزاتي) — V1 Physical Evidence

**Task ID:** `CUSTOMER_SCREEN12_MY_BOOKINGS_NATIVE_DESIGN_V1`  
**State Target:** `SCREEN12_V1_AWAITING_FOUNDER_VISUAL_REVIEW`  
**Target Hardware:** Samsung Galaxy A56 5G (Android 16 API 36)  
**Execution Mode:** Visual Design Candidate Verification (Zero production code modifications; 100% isolated native Flutter preview)  
**Evidence Branch:** `evidence/customer-screen12-design-review`  
**Display Framebuffer:** 1080 × 2340 px @ 450 dpi  
**Capture Method:** Native `adb exec-out screencap -p` directly from physical hardware framebuffer

---

## 1. Executive Summary & Design Highlights

Screen 12 (My Bookings / حجوزاتي) is the root Customer tab dedicated to tracking reservations, stay requests, and historical bookings. This V1 candidate delivers an original, calm, authoritative native Flutter composition tailored for the Egyptian consumer, fully respecting the KONFRM Design System and product invariants:

1. **Top-Level Root Tab Grammar:**
   - **Page Header:** Prominent Cairo Bold title `حجوزاتي` (22sp) accompanied by a calming subtitle `تابع طلباتك وإقاماتك من مكان واحد.` (13sp) in muted neutral `#6B7280`.
   - **Root Destination Invariant:** As a root bottom-navigation destination, the header features **NO back navigation arrow**, **NO solitary brand symbol**, and **NO English text wordmark**. A compact 44×44dp pull-to-refresh icon button is anchored on the trailing side.
   - **Bottom Navigation Harmony:** Renders the standard customer 4-item navigation bar (`استكشاف`, `حجوزاتي`, `المفضلة`, `حسابي`) with active selection on `حجوزاتي`.

2. **Conditional Sectional Architecture:**
   - **"مطلوب إجراء منك" (Action Required):** Occupies first-fold priority whenever an actionable state exists (e.g., `APPROVED_PENDING_PAYMENT` awaiting deposit). Features an urgency countdown badge (`متبقي 12:45:00`), deposit amount, and a prominent black primary CTA button `سداد العربون` (50dp, 8px radius).
   - **"طلبات قيد المراجعة" (Pending Owner Approval):** Shows requests waiting for owner response (`قيد مراجعة المالك`) with calm neutral styling and clear expectations (no payment due now).
   - **"حجوزات مؤكدة" (Confirmed Stays):** Confirmed stays (`حجز مؤكد`) with check-in details and seamless access to stay information.
   - **"الحجوزات السابقة" (Past Bookings):** Historical stays (`مكتمل`, `ملغي`) rendered in restrained contrast for clean visual hierarchy.

3. **Strict Arabic RTL, Bidi & Numeric Isolation:**
   - **Date Progression:** Flows naturally right-to-left: `20 أكتوبر ← 25 أكتوبر 2026`, with the intervening arrow pointing **strictly LEFT** (`←`) in true Arabic reading sequence.
   - **Financial Clarity:** Rendered via `DirectionalPriceText` as Western Arabic numerals `0-9` followed by non-breaking space and currency (`2,700 ج.م`), preventing English/Arabic character order reversals.
   - **Booking Reference Isolation:** Monospace alphanumeric references (`BK-892415`) are isolated in LTR directional spans.

4. **Accessibility 200% Invariant (Solving Issue #144):**
   - Screen 11 issue #144 documented an accessibility anti-pattern where `FittedBox(scaleDown)` caused horizontal compression and letter-by-letter truncation under large text scaling.
   - Screen 12 V1 solves this at the structural layout level: under accessibility scaling (> 1.3 text scale or 200%), the booking card **dynamically reflows into a vertical stack**. The thumbnail, status badge, and property title each occupy full horizontal width, wrapping across multiple lines with zero truncation and zero font shrinkage.

5. **Truthful State Distinctions:**
   - **Guest / Unauthorized:** Distinct screen explaining that personal bookings require signing in, featuring a prominent CTA `تسجيل الدخول / إنشاء حساب` directing to Screen 08. Zero fabricated bookings.
   - **Session Expired:** Distinct security recovery state explaining that authentication has lapsed, with CTA `إعادة تسجيل الدخول`.
   - **True Empty:** Authenticated user with zero bookings receives a welcoming, clean empty state with an actionable CTA `استكشف الوحدات` routing back to Screen 03 Explore.
   - **Stale Cache Refresh (MR-17 Compliant):** When a refresh fails while valid cached data exists, the list is retained in full, topped with a calm, neutral-blue info banner (`#EFF6FF` / `#BFDBFE`) and a retry button. Zero alarming yellow/amber warnings.

---

## 2. Evidence Files Index

| # | Scenario Description | PNG Screenshot | Bridge Companion (Base64) | Resolution | PNG Size |
|---|---|---|---|---|---|
| **01** | **Loaded: Action Required (First Fold Priority)** | [01_screen12_a56_loaded_action_required.png](01_screen12_a56_loaded_action_required.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/01_screen12_a56_loaded_action_required.png)) | [01_visual_bridge.jpg.b64.txt](01_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 194 KB |
| **02** | **Loaded: Current & Past Bookings (Scrolled)** | [02_screen12_a56_loaded_current_and_history.png](02_screen12_a56_loaded_current_and_history.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/02_screen12_a56_loaded_current_and_history.png)) | [02_visual_bridge.jpg.b64.txt](02_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 198 KB |
| **03** | **Guest / Unauthorized State** | [03_screen12_a56_guest_unauthorized.png](03_screen12_a56_guest_unauthorized.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/03_screen12_a56_guest_unauthorized.png)) | [03_visual_bridge.jpg.b64.txt](03_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 99 KB |
| **04** | **Session Expired State** | [04_screen12_a56_session_expired.png](04_screen12_a56_session_expired.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/04_screen12_a56_session_expired.png)) | [04_visual_bridge.jpg.b64.txt](04_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 96 KB |
| **05** | **Authenticated True Empty State** | [05_screen12_a56_true_empty.png](05_screen12_a56_true_empty.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/05_screen12_a56_true_empty.png)) | [05_visual_bridge.jpg.b64.txt](05_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 95 KB |
| **06** | **Network Error with Retry State** | [06_screen12_a56_error_retry.png](06_screen12_a56_error_retry.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/06_screen12_a56_error_retry.png)) | [06_visual_bridge.jpg.b64.txt](06_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 96 KB |
| **07** | **Stale Cache Refresh Notice State** | [07_screen12_a56_stale_cache_with_notice.png](07_screen12_a56_stale_cache_with_notice.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/07_screen12_a56_stale_cache_with_notice.png)) | [07_visual_bridge.jpg.b64.txt](07_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 195 KB |
| **08** | **Accessibility Text Scaling (200% Reflow)** | [08_screen12_a56_accessibility_200.png](08_screen12_a56_accessibility_200.png) ([Raw](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen12-design-review/review-evidence/customer-screen12/v1/08_screen12_a56_accessibility_200.png)) | [08_visual_bridge.jpg.b64.txt](08_visual_bridge.jpg.b64.txt) | 1080 × 2340 | 173 KB |

---

## 3. Companion Documents & Reproducibility Source

- **Full Verification Report:** [REPORT.md](REPORT.md)
- **Visual Bridge Text Companions & SHA-256 Manifest:** [VISUAL_BRIDGE_README.md](VISUAL_BRIDGE_README.md)
- **Isolated Flutter Preview Runner Source:** [review-source/screen12_preview_runner_v1.dart](review-source/screen12_preview_runner_v1.dart)
