# Customer Screen 22 — Booking-Scoped Chat («محادثة الحجز») Final Truth Microfix Evidence

This directory contains the authoritative physical device screenshots, automated tests, and verification artifacts for the Final Truth Microfix of **Customer Screen 22 — Booking-Scoped Chat («محادثة الحجز»)** on branch `evidence/customer-screen22-design-review`.

## Target Hardware Specifications

- **Device:** Samsung Galaxy A56 5G (`SM_A566B`)
- **Serial:** `[REDACTED_A56_ID]` (Redacted per Issue #145)
- **OS:** Android 16 (API Level 36)
- **Display Resolution:** 1080 × 2340 pixels @ 450 dpi
- **Text Scaling:** Normal (1.0×) and Accessibility (2.0×)

## Running the Preview on Hardware

```powershell
flutter run -d [REDACTED_A56_ID] -t tool/screen22_preview_runner.dart
```

### Hardware Interactive Scenario Keys:
- **1:** Authorized Thread (Top Fold — Collapsed Booking Details)
- **2:** Booking Details Disclosure Expanded
- **3:** Scrolled Long Conversation (Neutral Host Seed)
- **4:** Composer Active Draft with Send CTA
- **5:** Message Pending Send (Local Optimistic)
- **6:** Submission Timeout / Uncertain State (Send Disabled, Factual Draft Copy)
- **7:** Confirmed Delivery Failure with Compact Neutral Retry
- **8:** Device Offline Neutral Status (Send Disabled, Draft Preserved)
- **9:** Unauthenticated Guest Access Barrier
- **0:** Unavailable / Ineligible Chat Thread
- **A:** Accessibility 200% Font Scale Reflow (Conversation)
- **B:** Accessibility 200% Font Scale Reflow (Composer)

## Directory Structure

```
v1-final-truth-microfix/
├── REPORT.md                             # Comprehensive truth microfix and verification report
├── README.md                             # Execution instructions & scenario guide
├── DESIGN_SKILL_COURT_STORE_RECEIPT.md  # Design skills, Design Court & Store Platform receipt
├── review-source/                        # Archived runner and test sources
│   ├── screen22_preview_runner.dart
│   └── screen22_source_linked_tests.dart
└── screenshots/                          # 12 hardware captures + .b64.txt companions
    ├── 01_screen22_authorized_thread_top.png (.b64.txt)
    ├── 02_screen22_booking_disclosure_expanded.png (.b64.txt)
    ├── 03_screen22_thread_scrolled_long.png (.b64.txt)
    ├── 04_screen22_composer_draft_active.png (.b64.txt)
    ├── 05_screen22_message_sending_pending.png (.b64.txt)
    ├── 06_screen22_submission_timeout_uncertain.png (.b64.txt)
    ├── 07_screen22_message_delivery_failed.png (.b64.txt)
    ├── 08_screen22_offline_state.png (.b64.txt)
    ├── 09_screen22_unauthorized_guest_barrier.png (.b64.txt)
    ├── 10_screen22_unavailable_thread.png (.b64.txt)
    ├── 11_screen22_a11y_200_thread.png (.b64.txt)
    └── 12_screen22_a11y_200_composer.png (.b64.txt)
```
