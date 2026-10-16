# Customer Screen 20 — Production-Fidelity Factual Microfix Evidence Directory

This directory contains the authoritative visual evidence, source mirrors, and verification reports for **Customer Screen 20: Payment History («سجل المدفوعات»)** following the Bridge Independent Visual Review of delivery `62a99085f81e6ae2b80041b0d4116726025b02f1` ([GitHub Issue #179 Comment](https://github.com/Essxm01/KONFRM/issues/179)).

The Bridge confirmed that the refined visual direction is a **PASS**, and requested ONE single, bounded, factual micro-patch addressing three specific customer truth items with zero visual redesign.

## Directory Structure

```
review-evidence/customer-screen20/v1-production-fidelity-factual-microfix/
├── README.md                                    # This directory index
├── REPORT.md                                   # Comprehensive microfix verification report
├── DESIGN_SKILL_COURT_STORE_RECEIPT.md         # Design Skills, Design Court triage & store compliance receipt
├── review-source/                              # Exact frozen source mirrors
│   ├── screen20_preview_runner.dart            # Flutter native preview runner
│   └── screen20_source_linked_tests.dart       # Behavioral and geometry tests (23/23 PASS)
└── screenshots/                                # Physical Samsung Galaxy A56 captures & Base64 companions
    ├── 03_screen20_payment_history_detail_sheet.png
    ├── 03_screen20_payment_history_detail_sheet.b64.txt
    ├── 05_screen20_payment_history_reconciliation_pending.png
    └── 05_screen20_payment_history_reconciliation_pending.b64.txt
```

## Three Bounded Factual Fixes Implemented

1. **Internal Transaction ID Purged & Booking Copy Action Aligned:**
   - Omitted the unapproved transaction reference row (`رقم المعاملة`) from the customer detail sheet.
   - Renamed copy action to «نسخ رقم الحجز» (`copy_booking_ref_button`), copying `humanBookingNumber` (e.g. `183223`) to system clipboard with accurate toast «تم نسخ رقم الحجز».
   - Private `item.id` preserved as internal model key only; future public reference scheme tracked under Issue #181.

2. **Truthful Neutral Detail Amount Label & Unapproved Specs Purged:**
   - Replaced unconditional label «المبلغ المسدد» with neutral «المبلغ» across all transaction states (Paid, Pending, Reconciling, Refunded).
   - Dropped unapproved «وسيلة الدفع» row from detail sheet.
   - Removed unapproved policy copy (`وفق سياسة الإلغاء المعتمدة`) and card guarantees from refunded fixture, retaining concise status-true copy («تم استرداد مبلغ العربون بنجاح.»).

3. **Redundant Reconciliation Banner Removed:**
   - Completely purged the redundant blue alert banner (`reconciliation_alert_banner`) that leaked internal transaction IDs and overclaimed future banking timelines.
   - Uncertainty is communicated honestly and cleanly via individual card badges («قيد المطابقة», «قيد المعالجة»).

## Governing Invariants & Immutability
- Historical evidence in `review-evidence/customer-screen20/v1/` and `review-evidence/customer-screen20/v1-production-fidelity-refinement/` preserved untouched per Issue #155.
- Screens 12–19 evidence preserved untouched.
- Zero changes to production code (`customer_app/lib/`), backend, or database.
- Physical device serial redacted per Issue #145 (`[REDACTED_A56_ID]`).
