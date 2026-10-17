# KONFRM Customer Application (Screens 01–22) — Defect Findings & Source-Truth Remediation Ledger (V3)

**Document Purpose:** Detailed itemization of all design, typography, navigation, RTL, interactive control, and content truth defects identified across the 22-screen Customer application audit, along with exact code resolutions, test assertions, and physical Samsung Galaxy A56 5G hardware evidence.  
**Governing Issue:** [Issue #192](https://github.com/Essxm01/KONFRM/issues/192)  
**Dedicated Branch:** `evidence/customer-cross-screen-fidelity-audit`  
**Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 API 36, Device Serial `[REDACTED_A56_ID]`)  

---

## 1. Summary of Defect Triage & Reconciliation

Across the 22 screens of the canonical Customer application (`KONFRM_EXECUTION_TASKS.md` §4.1):
- **10 Screens Verified Baseline (`VERIFIED_NO_CHANGE`):** Screens 01, 02, 03, 11, 12, 15, 17, 20, 21, 22.
  - Screen 20: Frozen and approved at `bf1aeeb0ef2c8c8e6e6418ca036050d22e4dd6c3`.
  - Screen 21: Frozen and approved at `d04f8e5e657502b58886a9b9d0dd934d1a97f20a`.
  - Screen 22: Proposed awaiting Founder approval at `5db33beb768b0212a9fe44ff894ed931dfb006e3` (uncertain draft delivery safety hardened).
- **9 Candidate Screens Remediated across Batches A, B, and C:**
  - **Batch A (Screens 04, 05, 07, 10):**
    - Screen 04: Physical Right Back Arrow `[➔]`; title font size reduced to 16 to prevent 3-line wrap under 200% font scale.
    - Screen 05: Physical Right Back Arrow `[➔]`; responsive filter wrapping.
    - Screen 07: Physical Right Back Arrow `[➔]`; neutral deposit line item `عربون الليلة الأولى` (4,500 ج.م) without speculative prose; single clear notice banner `لا يُدفع العربون قبل موافقة المالك.`.
    - Screen 10: Physical Right Back Arrow `[➔]`; full-width accessible profile setup inputs.
  - **Batch B (Screens 13, 14, 16):**
    - Screen 13: Physical Right Back Arrow `[➔]`; purged unapproved check-in (3pm) / check-out (11am) hours (stay dates only); compressed status card to single sentence.
    - Screen 14: Physical Right Back Arrow `[➔]`; replaced branded card networks `(Visa / Mastercard / Meeza)` with neutral electronic gateway line `سداد آمن عبر بوابة الدفع الإلكتروني`.
    - Screen 16: Physical Right Back Arrow `[➔]`; removed unapproved `استلام المفاتيح` (key handover) from notification body.
  - **Batch C (Screens 18, 19):**
    - Screen 18: Physical Right Back Arrow `[➔]`; unverified email field cleanly presented as `البريد الإلكتروني` with fake green check and `(مؤكد)` removed.
    - Screen 19: Physical Right Back Arrow `[➔]`; purged visible test copy `بيانات تجريبية`; stateful interactive toggle switches via `InteractiveToggleRow`; interactive logout confirmation modal.
- **3 Historical Screens Pending Dedicated Isolated Runners:**
  - **Screen 06 (Property Details):** Sliver-scroll hero image overlay architecture. Historical baseline at `origin/feat/customer-screen06-property-details-v3` (`7107fcf`).
  - **Screen 08 (Phone Auth Entry) & Screen 09 (OTP Verification):** Auth step sequence requiring dedicated phone and pin input controllers. Baselines at `origin/evidence/customer-screen08-design-review` (`213a2e3`) and `origin/evidence/customer-screen09-design-review` (`e158924`).
- **Screen 23 (Dispute / Evidence):** Strictly locked and unstarted pending formal Founder authorization.

---

## 2. Comprehensive Defect Findings & Resolutions

### Finding 01: Physical RTL Back-Arrow Inversion (Global Architectural Defect)
- **Defect ID:** `DEFECT-RTL-BACK-01`
- **Severity:** P0 (Critical Navigation & Spatial Law)
- **Affected Screens:** Screens 04, 05, 07, 10, 13, 14, 16, 18, 19.
- **Root Cause:** Flutter's default `matchTextDirection: true` on `Icons.arrow_back` automatically flips the arrow in RTL layouts, causing it to point **LEFT `[←]`** (toward the inner content) instead of the entry bezel on the right.
- **Enacted Resolution:** Enforced canonical pattern across all preview runners:
  ```dart
  Directionality(
    textDirection: TextDirection.ltr,
    child: SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        icon: Icon(Icons.arrow_forward_rounded, color: Color(0xFF000000), size: 24),
        onPressed: onPressed ?? () {},
      ),
    ),
  )
  ```
- **Automated Verification:** Asserted `find.byIcon(Icons.arrow_forward_rounded)` wrapped in `TextDirection.ltr` across all 3 test suites (14/14 PASS).
- **Physical A56 Evidence:** Verified in all 18 hardware screenshots in `screenshots/`.

---

### Finding 02: Screen 04 Search & Refine Title Font Overflow at 200% Font Scale
- **Defect ID:** `DEFECT-A11Y-S04-02`
- **Severity:** P1 (Accessibility Typography Wrapping)
- **Affected Screen:** Screen 04 (Search & Refine)
- **Root Cause:** App bar title `تخصيص البحث والفلاتر` used font size 18 with an adjacent `إعادة ضبط` text button. Under `TextScaler.linear(2.0)`, the title text wrapped to 3 lines, causing visual congestion in the app bar.
- **Enacted Resolution:** Reduced title font size to 16 with bold weight (`FontWeight.bold`). The title now wraps cleanly into 2 lines at 200% scaling, preserving generous padding and zero overflow.
- **Automated Verification:** Verified in `batch_a_corrected_tests.dart` under 200% text scale.
- **Physical A56 Evidence:** `02_screen04_corrected_a11y_200.png`.

---

### Finding 03: Screen 07 Booking Request Review Redundant Deposit Claims
- **Defect ID:** `DEFECT-CANON-S07-02`
- **Severity:** P0 (Business Canon & Deposit Truth)
- **Affected Screen:** Screen 07 (Booking Request Review)
- **Root Cause:** The deposit line item included redundant subtext (`يُسدد بعد مراجعة وموافقة المالك...`) while a separate banner below also repeated deposit timing, creating clutter and speculative phrasing.
- **Enacted Resolution:**
  1. Simplified the deposit card line item to pure canonical `عربون الليلة الأولى` (4,500 ج.م) without prose.
  2. Maintained a single, authoritative notice banner: `لا يُدفع العربون قبل موافقة المالك.`.
  3. Purged all banned policy assertions ("non-refundable" or "pay remainder on arrival").
- **Automated Verification:** Tested in `batch_a_corrected_tests.dart` asserting exact Arabic phrases and absence of banned claims.
- **Physical A56 Evidence:** `05_screen07_corrected_normal.png` and `06_screen07_corrected_a11y_200.png`.

---

### Finding 04: Screen 13 Unapproved Timetable Hours & Overlong Status Text
- **Defect ID:** `DEFECT-CANON-S13-01`
- **Severity:** P0 (Epistemic Business Canon)
- **Affected Screen:** Screen 13 (Booking Details / Stay Hub)
- **Root Cause:** Screen 13 displayed arbitrary check-in (`يبدأ 03:00 م`) and check-out (`حتى 11:00 ص`) hours that are not confirmed universal platform invariants. Additionally, the status card description spanned 3 lines with multi-sentence repetition.
- **Enacted Resolution:**
  1. Removed check-in and check-out hour rows, retaining stay dates only: `14 – 18 يوليو 2026 (4 ليالٍ)`.
  2. Compressed status card description to a single concise sentence: `طلبك قيد المراجعة حالياً من المالك، ولا يلزم أي دفع في هذه المرحلة.`.
- **Automated Verification:** Tested in `batch_b_corrected_tests.dart` with negative assertions for `03:00` and `11:00`.
- **Physical A56 Evidence:** `09_screen13_corrected_normal.png` and `10_screen13_corrected_a11y_200.png`.

---

### Finding 05: Screen 14 Pre-Checked Branded Payment Network Invention
- **Defect ID:** `DEFECT-CANON-S14-01`
- **Severity:** P0 (Epistemic Business Canon & Store Compliance)
- **Affected Screen:** Screen 14 (Deposit Payment)
- **Root Cause:** Screen 14 rendered a pre-checked selection claiming `البطاقة البنكية (Visa / Mastercard / Meeza)` with an active green checkmark, falsely indicating specific payment schemes were selected and integrated before backend/gateway integration.
- **Enacted Resolution:** Replaced with a neutral electronic payment line `سداد آمن عبر بوابة الدفع الإلكتروني` in an unselected neutral container without brand network claims.
- **Automated Verification:** Tested in `batch_b_corrected_tests.dart` asserting absence of `Visa`, `Mastercard`, and `Meeza`.
- **Physical A56 Evidence:** `11_screen14_corrected_normal.png` and `12_screen14_corrected_a11y_200.png`.

---

### Finding 06: Screen 16 Unapproved Key Handover Assertion
- **Defect ID:** `DEFECT-CANON-S16-01`
- **Severity:** P1 (Product Truth & Service Scope)
- **Affected Screen:** Screen 16 (Notification Center)
- **Root Cause:** Notification item claimed host message was about `ترتيبات الوصول واستلام المفاتيح` (key handover). Platform policy does not mandate physical key handovers for all properties.
- **Enacted Resolution:** Updated notification copy to truthful, neutral communication: `أرسل أحمد رسالة جديدة بخصوص تفاصيل وتنسيق الحجز.`.
- **Automated Verification:** Tested in `batch_b_corrected_tests.dart` asserting absence of `استلام المفاتيح`.
- **Physical A56 Evidence:** `13_screen16_corrected_normal.png` and `14_screen16_corrected_a11y_200.png`.

---

### Finding 07: Screen 18 Fake Verified Email Indicator
- **Defect ID:** `DEFECT-TRUTH-S18-01`
- **Severity:** P1 (Truthful Identity Presentation)
- **Affected Screen:** Screen 18 (Profile / Edit Profile)
- **Root Cause:** Email field displayed `البريد الإلكتروني (مؤكد)` with a green checkmark icon, while in product truth customer email verification is optional and secondary (only phone OTP is verified at registration).
- **Enacted Resolution:** Removed `(مؤكد)` and the green checkmark icon from the email field. Phone remains properly displayed as `رقم الهاتف المحمول (مؤكد)` with its verification tick.
- **Automated Verification:** Tested in `batch_c_corrected_tests.dart`.
- **Physical A56 Evidence:** `15_screen18_corrected_normal.png` and `16_screen18_corrected_a11y_200.png`.

---

### Finding 08: Screen 19 Inert Switch Toggles & Empty Logout Callback
- **Defect ID:** `DEFECT-INTERACTION-S19-01`
- **Severity:** P1 (Interactive Quality & Usability)
- **Affected Screen:** Screen 19 (Settings)
- **Root Cause:** Settings switches were inert (`onChanged: (_) {}`) and did not toggle state when tapped on hardware. The logout button had an empty callback `onPressed: () {}`.
- **Enacted Resolution:**
  1. Implemented stateful `InteractiveToggleRow` widget managing its own local boolean state and responding smoothly to user taps.
  2. Added interactive confirmation dialog for logout (`AlertDialog` asking `هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟` with cancel and confirm actions).
- **Automated Verification:** Tested in `batch_c_corrected_tests.dart` asserting switch state toggles and dialog appears/dismisses.
- **Physical A56 Evidence:** `17_screen19_corrected_normal.png` and `18_screen19_corrected_a11y_200.png`.
