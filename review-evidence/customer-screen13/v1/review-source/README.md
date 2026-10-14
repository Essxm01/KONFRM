# Screen 13 V1 Preview Runner — Launch Recipe & Fixture Specification

**Task ID:** `CUSTOMER_SCREEN13_STAY_HUB_NATIVE_VISUAL_V1`  
**Source Path:** `screen13_preview_runner_v1.dart`  
**Execution Environment:** Isolated native Flutter runner (Zero production code modifications)

---

## 1. Launch Recipe

To run this isolated preview runner on a connected device (e.g., Samsung Galaxy A56 5G):

```bash
# 1. Ensure connected device is detected
flutter devices

# 2. Launch directly using Flutter run from the repository root
flutter run -t review-evidence/customer-screen13/v1/review-source/screen13_preview_runner_v1.dart -d <device-id>
```

Alternatively, from within the `customer_app` directory:
```bash
cd mobile/apps/customer_app
flutter run -t ../../../review-evidence/customer-screen13/v1/review-source/screen13_preview_runner_v1.dart
```

---

## 2. Hardware Keyevents & QA Scenario Selector

The runner provides deterministic hardware keyevent switching and an optional on-screen QA scenario dropdown (toggled with the `Q` key, hidden by default for clean captures):

| Key / Keycode | Scenario ID & Description |
|---|---|
| **Key 1** (keycode 8) | `01. pendingOwnerApproval`: Request under owner review. Reassuring copy, no payment due now. |
| **Key 2** (keycode 9) | `02. approvedPendingPayment`: Owner approved. Deposit required. Black primary CTA `دفع العربون ←` (8px radius). |
| **Key 3** (keycode 10) | `03. confirmedStay`: Booking confirmed. Deposit paid. No payment CTA. |
| **Key 4** (keycode 11) | `04. cancelledHistorical`: Cancelled by guest. Read-only cancellation date & reason. |
| **Key 5** (keycode 12) | `05. unknownStatusFallback`: Safe fallback for unhandled backend status. Customer support affordance. |
| **Key 6** (keycode 13) | `06. longTitleAndCode`: Multiline property title and extended booking reference number. |
| **Key 7** (keycode 14) | `07. accessibility200Top`: 200% text scaling at top fold. Natural reflow without overflow. |
| **Key 8** (keycode 15) | `08. accessibility200Scrolled`: 200% text scaling scrolled down to primary CTA and stay details. |
| **Key 9** (keycode 16) | `09. initialLoadingSkeleton`: Honest loading skeleton with active RTL back navigation. |
| **Key 0** (keycode 7) | `10. unauthorizedSessionExpired`: 401 session expired. Fail-closed; zero private data leaked. |
| **Key A** (keycode 29) | `11. staleCacheRefreshNotice`: Retains last validated cached detail with calm neutral notice banner. |
| **Key Q** (keycode 45) | Toggle floating on-screen QA scenario selector bar. |

---

## 3. Mathematical & Business Invariants Verified

The runner includes an automated startup assertion `assertFixtureIntegrity()` that verifies:
1. Flat-rate pricing math: `nightlyPrice * nights == totalStay` for every booking record.
2. Canonical first-night deposit: `depositAmount == nightlyPrice` for every booking record.
3. Remaining balance integrity: `remainingAmount == totalStay - depositAmount`.
4. Zero fake countdown timers or fabricated 24h payment deadlines.
5. Strict Egyptian Arabic RTL (`textDirection: TextDirection.rtl`) and Western Arabic digits (`0-9`).
6. Fail-closed privacy on 401 Session Expired (immediate purge of sensitive booking info).
