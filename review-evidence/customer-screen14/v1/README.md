# KONFRM Customer Screen 14 V1 Evidence Directory
## Deposit Payment / دفع العربون — Native Flutter Candidate

```yaml
TASK_ID: CUSTOMER_SCREEN14_DEPOSIT_PAYMENT_NATIVE_VISUAL_V1
REVIEW_BRANCH: evidence/customer-screen14-design-review
TARGET_STATUS: SCREEN14_VISUAL_V1_READY_FOR_FOUNDER_REVIEW
APPROVAL_STATE: FOUNDER_VISUAL_APPROVAL_PENDING
HARDWARE: Samsung Galaxy A56 5G (SM-A566B, Android 16)
EVIDENCE_DIR: review-evidence/customer-screen14/v1/
TOTAL_SCENARIOS: 15 Physical Captures
```

---

## 1. Directory Structure

- **[REPORT.md](REPORT.md):** Comprehensive 12-section technical, behavioral, visual, financial, accessibility, and quality report.
- **[VISUAL_BRIDGE_README.md](VISUAL_BRIDGE_README.md):** 1-to-1 manifest mapping all 15 framebuffer PNG captures to UTF-8 Base64 ASCII companions with SHA-256 integrity hashes and curl decoding recipes.
- **[review-source/](review-source/):** Isolated, runnable native Flutter preview harness source code (`screen14_preview_runner_v1.dart`) and launch instructions.
- **`01_*.png` to `15_*.png`:** True uncompressed physical device framebuffer screenshots (1080 × 2340).
- **`01_visual_bridge.jpg.b64.txt` to `15_visual_bridge.jpg.b64.txt`:** Single-line Base64 companions for direct headless Bridge review.

---

## 2. Physical Screenshot Index & Pinned Raw Links

| Scenario | Direct High-Res PNG Link | Direct ASCII Bridge Companion Link |
| :--- | :--- | :--- |
| **01. Ready State — Top Fold** | [01_screen14_a56_ready_top_fold.png](01_screen14_a56_ready_top_fold.png) | [01_visual_bridge.jpg.b64.txt](01_visual_bridge.jpg.b64.txt) |
| **02. Ready State — Scrolled Financials** | [02_screen14_a56_ready_scrolled_financials.png](02_screen14_a56_ready_scrolled_financials.png) | [02_visual_bridge.jpg.b64.txt](02_visual_bridge.jpg.b64.txt) |
| **03. Initiating State (Disabled CTA)** | [03_screen14_a56_initiating_state.png](03_screen14_a56_initiating_state.png) | [03_visual_bridge.jpg.b64.txt](03_visual_bridge.jpg.b64.txt) |
| **04. Payment Pending (Status Check CTA)** | [04_screen14_a56_payment_pending.png](04_screen14_a56_payment_pending.png) | [04_visual_bridge.jpg.b64.txt](04_visual_bridge.jpg.b64.txt) |
| **05. Network Reconciliation Required** | [05_screen14_a56_network_reconciliation_required.png](05_screen14_a56_network_reconciliation_required.png) | [05_visual_bridge.jpg.b64.txt](05_visual_bridge.jpg.b64.txt) |
| **06. Failed Attempt (Safe Retry)** | [06_screen14_a56_failed_attempt.png](06_screen14_a56_failed_attempt.png) | [06_visual_bridge.jpg.b64.txt](06_visual_bridge.jpg.b64.txt) |
| **07. Transaction Expired (Booking Active)** | [07_screen14_a56_transaction_expired.png](07_screen14_a56_transaction_expired.png) | [07_visual_bridge.jpg.b64.txt](07_visual_bridge.jpg.b64.txt) |
| **08. Amount Changed Conflict Guard** | [08_screen14_a56_amount_changed_conflict.png](08_screen14_a56_amount_changed_conflict.png) | [08_visual_bridge.jpg.b64.txt](08_visual_bridge.jpg.b64.txt) |
| **09. Provider Unavailable (Factual Boundary)** | [09_screen14_a56_provider_unavailable.png](09_screen14_a56_provider_unavailable.png) | [09_visual_bridge.jpg.b64.txt](09_visual_bridge.jpg.b64.txt) |
| **10. Confirmed Synthetic Success** | [10_screen14_a56_confirmed_synthetic_success.png](10_screen14_a56_confirmed_synthetic_success.png) | [10_visual_bridge.jpg.b64.txt](10_visual_bridge.jpg.b64.txt) |
| **11. Already Confirmed State** | [11_screen14_a56_already_confirmed.png](11_screen14_a56_already_confirmed.png) | [11_visual_bridge.jpg.b64.txt](11_visual_bridge.jpg.b64.txt) |
| **12. State Changed Ineligible** | [12_screen14_a56_state_changed_ineligible.png](12_screen14_a56_state_changed_ineligible.png) | [12_visual_bridge.jpg.b64.txt](12_visual_bridge.jpg.b64.txt) |
| **13. Unauthorized 401 (Fail-Closed Purge)** | [13_screen14_a56_unauthorized_session_expired.png](13_screen14_a56_unauthorized_session_expired.png) | [13_visual_bridge.jpg.b64.txt](13_visual_bridge.jpg.b64.txt) |
| **14. Accessibility 200% — Top Fold** | [14_screen14_a56_accessibility_200_top.png](14_screen14_a56_accessibility_200_top.png) | [14_visual_bridge.jpg.b64.txt](14_visual_bridge.jpg.b64.txt) |
| **15. Accessibility 200% — Scrolled** | [15_screen14_a56_accessibility_200_scrolled.png](15_screen14_a56_accessibility_200_scrolled.png) | [15_visual_bridge.jpg.b64.txt](15_visual_bridge.jpg.b64.txt) |
