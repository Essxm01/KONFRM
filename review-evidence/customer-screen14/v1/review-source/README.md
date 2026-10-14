# KONFRM Customer Screen 14 V1 — Review Source & Launch Guide

```yaml
TASK_ID: CUSTOMER_SCREEN14_DEPOSIT_PAYMENT_NATIVE_VISUAL_V1
REVIEW_RUNNER: review-source/screen14_preview_runner_v1.dart
TEST_DEVICE: Samsung Galaxy A56 5G (SM-A566B, Android 16, API 36)
PLATFORM: Flutter (Dart 3.x)
SURFACE: Customer App (Phase 5 Isolated Design Prototype)
STATUS: SCREEN14_VISUAL_V1_READY_FOR_FOUNDER_REVIEW
```

---

## 1. Overview & Isolation Boundaries

This directory hosts the complete, isolated native Flutter visual prototype runner for **Customer Screen 14 (Deposit Payment / دفع العربون)**.

### Strict Scope Boundaries
- **Zero Production App Pollution:** Tracked files under `mobile/apps/customer_app/lib/`, `mobile/packages/konfrm_design_system/lib/`, `customer-app/`, backend, and database remain 100% untouched.
- **Zero Real Financial Mutation:** No POST payments, no real Paymob calls, no bank card capture, no PIN/OTP fields, and no payment RPCs.
- **Pure Client State Simulation:** All booking records, payment statuses, and reconciliation flows are synthetic fixtures with programmatic math integrity assertions.

---

## 2. Reproducibility & Launch Instructions

To launch and inspect the exact Screen 14 candidate on a connected device or emulator:

### Step 1: Copy Runner to Customer App Tool Workspace
```bash
mkdir -p mobile/apps/customer_app/tool
cp review-evidence/customer-screen14/v1/review-source/screen14_preview_runner_v1.dart mobile/apps/customer_app/tool/screen14_preview_runner_v1.dart
```

### Step 2: Launch on Physical Samsung Galaxy A56
```bash
cd mobile/apps/customer_app
flutter run -d "SM A566B" -t tool/screen14_preview_runner_v1.dart
```

### Step 3: Keyboard & ADB Scenario Switching
The runner responds to hardware keys and ADB `input keyevent` commands for deterministic state inspection:

| Key | Keycode | Scenario Target |
| :---: | :---: | :--- |
| `1` | `8` | `01_screen14_a56_ready_top_fold.png` (Top fold: Deposit Hero 2,700 EGP, Black CTA) |
| `2` | `9` | `02_screen14_a56_ready_scrolled_financials.png` (Scrolled: Financial breakdown & stay dates) |
| `3` | `10` | `03_screen14_a56_initiating_state.png` (In-progress waiting, disabled duplicate tap) |
| `4` | `11` | `04_screen14_a56_payment_pending.png` (Pending check: Check Status CTA, no double pay) |
| `5` | `12` | `05_screen14_a56_network_reconciliation_required.png` (Network uncertainty recovery) |
| `6` | `13` | `06_screen14_a56_failed_attempt.png` (Failed transaction: retry fresh attempt) |
| `7` | `14` | `07_screen14_a56_transaction_expired.png` (Session expired only: booking remains approved) |
| `8` | `15` | `08_screen14_a56_amount_changed_conflict.png` (Deposit mismatch guard: 2,500 vs 2,700 EGP) |
| `9` | `16` | `09_screen14_a56_provider_unavailable.png` (Gateway unavailable: factual boundary) |
| `0` | `7` | `10_screen14_a56_confirmed_synthetic_success.png` (Synthetic confirmed finalization fixture) |
| `A` | `29` | `11_screen14_a56_already_confirmed.png` (Booking confirmed masebaqan: no deposit due) |
| `B` | `30` | `12_screen14_a56_state_changed_ineligible.png` (Booking state changed: payment disabled) |
| `C` | `31` | `13_screen14_a56_unauthorized_session_expired.png` (401 session expired: fail-closed purge) |
| `D` | `32` | `14_screen14_a56_accessibility_200_top.png` (200% text scale top fold) |
| `E` | `33` | `15_screen14_a56_accessibility_200_scrolled.png` (200% text scale scrolled) |
| `Q` | `45` | Toggle on-screen QA scenario selector bar |

---

## 3. Clean-up Protocol

After evaluation, remove the temporary tool folder to maintain complete working-tree hygiene:
```bash
rm -rf mobile/apps/customer_app/tool
git status
```
