# Screen 12 V2 Preview Runner — Launch Recipe & Fixture Specification

**Task ID:** `CUSTOMER_SCREEN12_MY_BOOKINGS_FOCUSED_V2`  
**Source Path:** `screen12_preview_runner_v2.dart`  
**Execution Environment:** Isolated native Flutter runner (Zero production code modifications)

---

## 1. Launch Recipe

To run this isolated preview runner on a connected device (e.g., Samsung Galaxy A56 5G):

```bash
# 1. Ensure connected device is detected
flutter devices

# 2. Launch directly using Flutter run
flutter run -t review-evidence/customer-screen12/v2/review-source/screen12_preview_runner_v2.dart -d <device-id>
```

Alternatively, from within the `customer_app` directory:
```bash
cd mobile/apps/customer_app
flutter run -t ../../../review-evidence/customer-screen12/v2/review-source/screen12_preview_runner_v2.dart
```

---

## 2. In-App QA Scenario Selector

The runner includes an unobtrusive Scenario Selector floating action bar at the top/bottom (omitted from official capture chrome via state parameters or scrolled into view) supporting 10 deterministic test states:

1. **Scenario 01:** `Loaded: Action Required` (First-fold priority for deposit payment)
2. **Scenario 02:** `Loaded: Current & Past Bookings` (Scrolled view of pending, confirmed, past)
3. **Scenario 03:** `Guest / Unauthorized` (Calm login invitation with Screen 08 CTA)
4. **Scenario 04:** `Session Expired` (Security recovery with re-login CTA)
5. **Scenario 05:** `Authenticated True Empty` (Encouraging empty state with Screen 03 Explore CTA)
6. **Scenario 06:** `Network Error with Retry` (Honest network failure container with retry action)
7. **Scenario 07:** `Stale Cache Refresh Notice` (MR-17 compliant calm notification banner above cached list)
8. **Scenario 08:** `Initial Loading Skeleton` (Honest loading skeleton without fake counts)
9. **Scenario 09:** `Unknown Status Fallback` (Unhandled status placed honestly under `حجوزات أخرى`)
10. **Scenario 10:** `Accessibility 200% Reflow` (Dynamic column reflow preventing horizontal clipping or font shrinkage)

---

## 3. Mathematical & Business Invariants Verified

The runner includes an automated startup assertion `assertFixtureIntegrity()` that verifies:
1. Flat-rate pricing math: `nightlyPrice * nights == totalStay` for every booking record.
2. Canonical first-night deposit: `depositAmount == nightlyPrice` for every booking record.
3. No fake countdown timers or fabricated 24h payment deadlines.
4. No unverified `موثق` trust badges on property cards.
5. Strict Egyptian Arabic RTL and Western Arabic digits (`0-9`) with `DirectionalPriceText`.
