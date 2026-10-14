# Screen 13 V2 Focused Preview Runner — Launch Recipe & Fixture Specification

**Task ID:** `CUSTOMER_SCREEN13_STAY_HUB_FOCUSED_V2`  
**Source Path:** `screen13_preview_runner_v2.dart`  
**Execution Environment:** Isolated native Flutter runner (Zero production code modifications)  
**Governing Issue:** #151 (Stay Hub V1 Bridge Review Corrections)

---

## 1. Launch Recipe

To run this isolated preview runner on a connected device (e.g., Samsung Galaxy A56 5G):

```bash
# 1. Ensure connected device is detected
flutter devices

# 2. Launch directly using Flutter run from the repository root
flutter run -t review-evidence/customer-screen13/v2/review-source/screen13_preview_runner_v2.dart -d <device-id>
```

Alternatively, from within the `customer_app` directory:
```bash
cd mobile/apps/customer_app
flutter run -t ../../../review-evidence/customer-screen13/v2/review-source/screen13_preview_runner_v2.dart
```

---

## 2. Hardware Keyevents & QA Scenario Selector

The runner provides deterministic hardware keyevent switching and an optional on-screen QA scenario dropdown (toggled with the `Q` key, hidden by default for clean captures):

| Key / Keycode | Scenario ID & Description |
|---|---|
| **Key 1** (keycode 8) | `01. pendingOwnerApproval`: Request under owner review. Reassuring copy, zero unverified notification SLAs, no payment due now. |
| **Key 2** (keycode 9) | `02. approvedPendingPayment`: Owner approved. First-fold deposit badge `العربون المطلوب للتأكيد: 2,700 ج.م` directly above black CTA `دفع العربون ←` (8px radius). |
| **Key 3** (keycode 10) | `03. confirmedStay`: Booking confirmed. Deposit paid. No payment CTA. |
| **Key 4** (keycode 11) | `04. cancelledHistorical`: Cancelled by guest. Read-only cancellation date & reason. Zero false re-booking availability promises. |
| **Key 5** (keycode 12) | `05. unknownStatusFallback`: Safe fallback for unhandled backend status (`حالة الحجز غير متاحة حاليًا`). Zero invented countdown timers. |
| **Key 6** (keycode 13) | `06. longTitleAndCode`: Multiline property title and extended booking reference number. Correct 2027 civil dates (`2027-01-10` = الأحد, `2027-01-16` = السبت). |
| **Key 7** (keycode 14) | `07. accessibility200Top`: 200% text scaling at top fold. Vertical stacking of deposit pill and flexible button height prevent any overflow. |
| **Key 8** (keycode 15) | `08. accessibility200Scrolled`: 200% text scaling scrolled down to stay details, guest count, and full payment breakdown. |
| **Key 9** (keycode 16) | `09. initialLoadingSkeleton`: Honest loading skeleton with active RTL back navigation. Zero fake data. |
| **Key 0** (keycode 7) | `10. unauthorizedSessionExpired`: 401 session expired. Fail-closed; zero private data leaked. |
| **Key A** (keycode 29) | `11. staleCacheRefreshNotice`: Retains last validated cached detail with calm neutral notice banner. Payment CTA safely disabled with lock icon. |
| **Key B** (keycode 30) | `12. forbiddenAccessDenied`: 403 access denied. Neutral fail-closed view, zero property ownership or tenant leakage. |
| **Key C** (keycode 31) | `13. notFoundBooking`: 404 booking not found. Neutral, calm view without status guesswork. |
| **Key D** (keycode 32) | `14. noCacheErrorWithRetry`: Network error on cold launch without cache. Honest error screen with primary retry CTA. |
| **Key T** (keycode 48) | `15. simulated401PurgeTransition`: In-flight session revocation simulation. Instantly evicts loaded memory state and replaces with fail-closed lock screen. |
| **Key Q** (keycode 45) | Toggle floating on-screen QA scenario selector bar. |

---

## 3. Mathematical & Business Invariants Verified

The runner includes an automated startup assertion `assertFixtureIntegrity()` that verifies:
1. **Civil Date Truth:** ISO date fields parsed into `DateTime` and formatted via `CivilDateFormatter`. Programmatically asserts:
   - `2026-10-20` is `الثلاثاء` (Tuesday).
   - `2026-10-25` is `الأحد` (Sunday).
   - `2027-01-10` is `الأحد` (Sunday).
   - `2027-01-16` is `السبت` (Saturday).
   - `nights == checkOutDateTime.difference(checkInDateTime).inDays` for every record.
2. **Pricing Math Reconciliation:**
   - `nightlyPrice * nights == totalStay` for every booking record.
   - `depositAmount == nightlyPrice` (flat-rate first night deposit canonical rule).
   - `remainingAmount == totalStay - depositAmount`.
   - Comma formatting applied across all figures (`2,700`, `13,500`, `51,000`).
3. **Copy Truth:**
   - Purged unverified notification SLAs from `PENDING_OWNER_APPROVAL`.
   - Removed invented countdown timers from `EXPIRED`.
   - Purged false availability promises from `CANCELLED_BY_GUEST`.
   - Calibrated `UNKNOWN` to `حالة الحجز غير متاحة حاليًا`.
4. **First-Fold Deposit & Anti-Card-Soup:**
   - Prominently displays deposit amount in first fold immediately above the black CTA.
   - Removed nested borders from inside the Stay Details card; replaced with quiet soft `#F9FAFB` fill.
   - Property thumbnail anchored on the right in natural RTL reading order.
5. **Fail-Closed Privacy Security:**
   - Evaluated across 401, 403, and dynamic in-flight revocation (Key T). Zero sensitive data or property details leaked when unauthenticated.
