# KONFRM Customer Screen 21 — Design Skills Activation, Design Court Review & Store Platform Compliance

**Task:** Customer Screen 21 — Help & Support («المساعدة والدعم») Final Bounded Founder-Truth & Accessibility Correction  
**Governing Issues:** #185, #186, #183, #175, #174, #173, #172, #171, #166, #155, #145  
**Physical Verification Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 / API 36, Serial `[REDACTED_A56_ID]`)  
**Design Baseline:** Cairo Typography (Package Authority), Arabic RTL First, Pure Black `#000000`, Canonical NESTED_CUSTOMER  

---

## 1. Design Skills Activation & Applied Outcomes

Per **Issue #183** mandatory governance, specialized KONFRM design brains were activated and consulted during this corrective pass:

### A. `konfrm-design` (Foundation, Layout & Typography Authority)
- **Consultation Objective:** Resolve vertical clipping on topic selection under 200% font scale, prevent form header row overflow, eliminate competing visual submit links, and maintain pure black `#000000` compliance.
- **Applied Outcomes:**
  1. **Content-Responsive Topic Selector:** Replaced rigid Flutter `DropdownButton` (which enforced fixed item heights and clipped large text) with a custom `InkWell` + `Container(constraints: minHeight: 48, ...)` selector. Text is set to `softWrap: true` inside an `Expanded` widget, allowing the full Arabic topic label («استفسار عن حجز حالي أو سابق») to wrap across two lines without vertical or horizontal clipping.
  2. **Scroll-Controlled Topic Sheet:** Wired topic selector to open an accessible bottom sheet modal (`_showTopicPickerSheet`) configured with `isScrollControlled: true`, `ConstrainedBox(maxHeight: 0.85 * height)`, and `SingleChildScrollView`. Title is wrapped in `Expanded` to prevent header overflow.
  3. **Header Row Overflow Remediation:** Wrapped the contact form header title («إرسال استفسار للدعم») in `Expanded` to eliminate the RenderFlex overflow seen at 200% font scale.
  4. **Uncertain State Action Hierarchy:** Replaced the competing inline «إعادة المحاولة» text link and bottom black submit CTA with a single governed `OutlinedButton` («مراجعة الاستفسار») featuring a 6px border radius and 1.5px pure black border.
  5. **Pure Black `#000000` Rule (Issue #175):** Zero dark charcoal or navy tones (`#111827`, `#1F2937`, `#0F172A`). Used pure `#000000` for active category chips, expanded card borders, title text, and primary CTAs.

### B. `konfrm-product` (Product Invariants & Domain Truth Authority)
- **Consultation Objective:** Audit FAQ fixtures against confirmed Master Rules, eliminate unconfirmed cancellation policy claims (MR-15), and ensure truthful in-memory draft retention messaging.
- **Applied Outcomes:**
  1. **Purged Unconfirmed Cancellation Claim:** Removed FAQ «هل يمكنني إلغاء طلب حجز قيد الانتظار؟» which claimed pending bookings can always be cancelled free of charge. This violated Master Rule MR-15 and `KONFRM_MASTER_PROJECT_CONTEXT.md` §24.3, as universal cancellation policies remain an open product decision.
  2. **Sourced Pending Status Meaning FAQ (MR-12 & MR-13):** Replaced with confirmed booking truth explaining what «قيد الانتظار» means:
     - Question: «ماذا تعني حالة الطلب «قيد الانتظار»؟»
     - Answer: «تعني أن طلب الحجز بانتظار مراجعة وقبول المالك للتواريخ والتفاصيل المطلوبة قبل الانتقال لمرحلة سداد العربون.»
     - Zero invented cancellation eligibility, fees, refund percentages, or cancellation deadlines.
  3. **Truthful In-Memory Draft Retention UX:** Corrected uncertain state copy from «تم حفظ مسودتك» to «تم الإبقاء على نص استفسارك لتجنب فقدانه. يرجى التحقق من اتصالك بالإنترنت قبل إرسال طلب جديد لمنع تكرار الرسائل.». Clarifies that draft text is held in memory during the session without fabricating persistent disk storage claims.
  4. **Eliminated Duplicate Case Risk:** Replaced the primary submit CTA during uncertain state with a review draft button that transitions safely to `idle` state without re-dispatching network requests.

### C. `konfrm-flutter` (Native Flutter Implementation Authority)
- **Consultation Objective:** Implement responsive widget layout, accessible sheet interactions, and controller draft review transitions.
- **Applied Outcomes:**
  1. **Controller Draft Review Transition:** Added `reviewDraftAfterUncertain()` to `CustomerHelpSupportController`, resetting `formStatus` from `timeoutUncertain` to `idle` while preserving user draft text in full.
  2. **Accessible Bottom Sheet Modal:** Implemented modal sheet with explicit 48dp+ tap targets (`ListTile`), soft-wrapped option text, and checkmark indicators for active selection.
  3. **Keyboard & ADB Automation:** Preserved full keyboard event routing (`LogicalKeyboardKey.digit1` through `digit0`, `keyA`, `keyB`) allowing instant scenario switching on physical hardware.

### D. `konfrm-quality` (Verification & Adversarial Review Authority)
- **Consultation Objective:** Update automated tests, enforce negative assertions against development text, and capture physical device evidence.
- **Applied Outcomes:**
  1. **Source-Linked Test Suite (25/25 PASS):** Updated `screen21_source_linked_tests.dart` with assertions verifying pending status meaning FAQ, absence of unapproved cancellation claims, timeout uncertain review action, and 200% topic selector visibility.
  2. **Zero Visible Development Copy Check:** Added negative assertion tests verifying that developer benchmark text (`استفسار تجريبي لمراجعة`) is completely absent from runner source and UI.
  3. **Physical Hardware Evidence:** Recaptured all 12 decision-grade scenes directly from the Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36) into `review-evidence/customer-screen21/v1-founder-truth-a11y-correction/screenshots/` with bit-for-bit Base64 companions.
  4. **Privacy Protocol (Issue #145):** Redacted device serial number across all documentation (`[REDACTED_A56_ID]`).

---

## 2. Design Court Triage & Formal Governance Docket

In accordance with the KONFRM Design Court governance protocol (`docs/codex/KONFRM_MASTER_RULES.md` and Issue #183), this delivery was deliberated under a structured single-agent panel:

- **Panel Format:** `SINGLE_AGENT_STRUCTURED_PANEL` (Deliberated through specialized governance lenses representing Design, Product, Flutter, and Quality authorities; not an external multi-agent board).

### Red-Team Gate Failures & Root Cause Analysis

| # | Red-Team / Review Finding | Root Cause in V1 Prototype | Review Verdict | Corrective Action Taken in This Pass |
|---|---|---|---|---|
| **1** | **Missed MR-15 Hard Gate (Unsupported Cancellation FAQ)** | V1 included FAQ «هل يمكنني إلغاء طلب حجز قيد الانتظار؟» claiming pending bookings can always be cancelled freely. | **REJECTED by Bridge** (Violates MR-15 & `KONFRM_MASTER_PROJECT_CONTEXT.md` §24.3). | Replaced with confirmed booking truth explaining pending status meaning («ماذا تعني حالة الطلب «قيد الانتظار»؟») per MR-12 and MR-13. Zero invented cancellation policies. |
| **2** | **200% Topic-Selector Clipping & Header Overflow** | Flutter standard `DropdownButton` enforces rigid internal height constraints (`itemHeight: 48.0`), clipping multi-line Cairo text at 200% font scale. Header row lacked `Expanded`. | **REJECTED by Bridge** (Visual clipping on primary interactive element). | Replaced with content-responsive selector (`minHeight: 48`, multiline wrapping, modal bottom sheet). Wrapped form header title in `Expanded`. Tested and verified on Samsung Galaxy A56. |
| **3** | **Visible Development Benchmark Copy** | Scenario 12 pre-seeded QA copy «استفسار تجريبي لمراجعة تدفق النصوص وعناصر التحكم بحجم 200%.». | **REJECTED by Bridge** (Development copy violates production-fidelity mandate). | Replaced with realistic customer inquiry copy: «أود الاستفسار عن تفاصيل الحجز وموعد تزويدي ببيانات الوصول بعد سداد العربون.». |
| **4** | **Uncertain Submission UX Collision** | Timeout notice displayed inline «إعادة المحاولة» link while keeping primary black «إرسال الاستفسار» CTA active below. Claimed «تم حفظ مسودتك». | **REJECTED by Bridge** (Invited duplicate submissions; false storage claim). | Removed inline retry link. Replaced submit CTA with single outlined «مراجعة الاستفسار» button returning safely to draft review. Updated copy to truthful in-memory retention. |

### Formal Panel Rulings

#### Case 1: Booking Lifecycle FAQ Truth vs Active Product Decisions
- **Context:** Whether to explain booking cancellation in FAQ when universal cancellation policies remain an open decision under MR-15.
- **Panel Ruling:** `PANEL_PROHIBITED_UNCONFIRMED_RULES`. FAQs must strictly explain confirmed platform invariants (status meanings, deposit rules, duration limits). When a policy is an active product decision (MR-15), FAQs must not anticipate or invent policy terms.

#### Case 2: Accessible Form Control Selection at 200% Font Scale
- **Context:** Choosing between standard Flutter `DropdownButton` and custom bottom sheet selector for accessibility compliance.
- **Panel Ruling:** `PANEL_MANDATED_ACCESSIBLE_SELECTOR`. Standard `DropdownButton` is fundamentally inadequate for 200% Arabic typography due to rigid vertical box constraints. The governed pattern for high-scaling selectors is a content-responsive tile opening a modal bottom sheet.

#### Case 3: Uncertain State Action Single-Action Protocol
- **Context:** Resolving action collision when network connectivity or backend confirmation times out.
- **Panel Ruling:** `PANEL_MANDATED_SINGLE_REVIEW_ACTION`. During uncertain state, the primary submit CTA must be suppressed to prevent accidental duplicate cases. A single «مراجعة الاستفسار» action returns the customer to draft editing without re-dispatching network requests.

---

## 3. Apple App Store & Google Play Store Platform Risk Assessment

| Store Guideline / Policy | Area of Review | Implementation Status | Store Review Assessment |
|---|---|---|---|
| **Apple App Store 5.1.1** (Data Privacy & User Consent) | Attachment of booking references to support requests | Booking context attachment requires explicit user opt-in (checkbox default OFF). Generic inquiries remain fully supported. | **LOW_RISK** |
| **Apple App Store 2.3** (Accurate Metadata & Truth in UI) | Fictitious contact channels, fake ticket numbers, or false promises | Purged all unverified phone numbers, WhatsApp links, response SLAs, and fake ticket IDs. UI accurately reflects confirmed features. | **LOW_RISK** |
| **Apple App Store 5.1.2** (Guest User Access) | Access to platform help for unauthenticated users | FAQs are publicly readable without requiring an account; contact intake requires authentication to prevent abuse. | **LOW_RISK** |
| **iOS Human Interface Guidelines (HIG)** | Visual styling, dynamic type, and navigation | Tested exclusively on physical Android 16 hardware (Samsung Galaxy A56 5G). iOS rendering, Cupertino patterns, and dynamic type on Apple hardware remain unverified. | **NOT_TESTED** (Pending iOS reality gate) |
| **Google Play User Support Policy** | Accessible customer support mechanisms | Provides clear, categorized FAQs and an in-app intake mechanism with transparent error recovery and retry. | **LOW_RISK** |
| **Real Support API & Live Channels** | Production support ticketing backend, WhatsApp API, and email routing | Runner affordances demonstrate visual UX only. Live support API endpoints and channels are deferred to PRELIVE Issue #186. | **DEFERRED_TO_PRELIVE_186** |
| **Android Accessibility (WCAG 2.1 AA)** | 200% font scaling & touch targets | Tested on physical Samsung Galaxy A56 5G (Android 16 API 36). Unclipped topic selector, scroll-controlled sheet modal, 48dp+ touch targets, zero overflow stripes. | **VERIFIED_PASS_ON_ANDROID** |

---

## 4. Summary Governance Verdict

- **Design Skills Compliance:** `PASS` (`konfrm-design`, `konfrm-product`, `konfrm-flutter`, and `konfrm-quality` actively integrated).
- **Design Court Governance:** `PANEL_APPROVED_AFTER_REMEDIATION` (All four review findings remediated, re-tested, and verified on Samsung Galaxy A56 hardware).
- **Store Platform Compliance:** `CONDITIONAL_ON_PRELIVE_GATES` (Open gates: iOS HIG `NOT_TESTED`, Support Backend & Live Channels `DEFERRED_TO_PRELIVE_186`).
