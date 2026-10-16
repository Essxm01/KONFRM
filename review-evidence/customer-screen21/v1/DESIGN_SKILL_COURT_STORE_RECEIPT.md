# KONFRM Customer Screen 21 — Design Skills Activation, Design Court Review & Store Platform Compliance

**Task:** Customer Screen 21 — Help & Support («المساعدة والدعم») Native Flutter Design V1  
**Governing Issues:** #185, #186, #183, #175, #174, #173, #172, #171, #166, #155, #145  
**Physical Verification Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 / API 36, Serial `[REDACTED_A56_ID]`)  
**Design Baseline:** Cairo Typography (Package Authority), Arabic RTL First, Pure Black `#000000`, Canonical NESTED_CUSTOMER  

---

## 1. Design Skills Activation & Applied Outcomes

Per **Issue #183** mandatory governance, specialized KONFRM design brains were activated and consulted during this execution pass:

### A. `konfrm-design` (Foundation, Layout & Typography Authority)
- **Consultation Objective:** Establish quiet, premium Arabic RTL Help & Support visual hierarchy, govern search and category chip presentation, ensure 48dp+ touch targets, and maintain pure black `#000000` compliance.
- **Applied Outcomes:**
  1. **Canonical NESTED_CUSTOMER App Bar:** Structured header with physical right back arrow `[➔]` (`Icons.arrow_forward_rounded`), 18pt bold Cairo title «المساعدة والدعم», 1px light divider `#E5E7EB`, and strictly zero bottom navigation bar.
  2. **Card & Form Radius Grammar:** Used governed 8px radius for search and input fields, 12px radius for containers and contact cards, and 6px radius for the primary submit CTA.
  3. **High-Contrast Accordion Presentation:** Designed clear FAQ cards with 1px border `#E5E7EB`, smooth chevron state indicators, and pure black outline on expanded cards to establish strong visual hierarchy.
  4. **Accessibility 200% Font Scale Reflow:** Unlike static printed documents, Help & Support is an ambient UI screen. Verified that all components (chips, search, accordion, form fields, consent checkbox, and submit CTA) reflow organically under `TextScaler.linear(2.0)` without horizontal clipping or overflow bars.
  5. **Issue #175 Pure Black Compliance:** Purged all dark charcoal and navy tones (`#111827`, `#1F2937`, `#0F172A`). Used pure `#000000` for active category chip, expanded card borders, title text, and CTA buttons.

### B. `konfrm-product` (Product Invariants & Domain Truth Authority)
- **Consultation Objective:** Ground FAQ fixtures in confirmed business invariants, enforce truthful support submission boundaries, and define booking context consent rules.
- **Applied Outcomes:**
  1. **Sourced FAQ Fixtures (MR-12, MR-13, Booking Canon):** Confined FAQ items exclusively to confirmed platform rules: first-night deposit semantics, stay duration limits (2–30 nights), two-stage confirmation lifecycle, account settings navigation, and free cancellation before owner approval. Purged all unapproved check-in/checkout hours, key exchange rules, and penalty matrices.
  2. **Opt-In Booking Context Invariant (Amendment 3):** Governed dual-origin navigation (Account vs Booking Details). When arriving from a booking, the booking number is displayed with digits only (`183223`) and accompanied by an explicit consent checkbox defaulting strictly to **OFF (`false`)**. General inquiries can be submitted without forced booking disclosure.
  3. **Zero Phantom Submission Confirmations:** Gated form submission to reflect that backend ticketing is deferred to PRELIVE Issue #186. Form submission demonstrates honest UX states (validation, sending, timeout notice with draft preservation, retry button) with zero fake ticket IDs or unverified response promises.
  4. **Unauthenticated Guest Shielding:** Gated contact form submission behind a login requirement banner for unauthenticated users, while keeping public FAQ discovery accessible.

### C. `konfrm-flutter` (Native Flutter Implementation Authority)
- **Consultation Objective:** Implement clean Riverpod/ChangeNotifier state management, responsive scroll behavior, keyboard automation, and accessible touch targets.
- **Applied Outcomes:**
  1. **Deterministic Controller Architecture:** Built `CustomerHelpSupportController` with 12 isolated scenarios, real-time query filtering across fixtures, category isolation, and immutable state transitions.
  2. **Keyboard-Driven Capture Protocol:** Implemented global hardware key event handlers (`LogicalKeyboardKey.digit1` through `digit0`, `keyA`, `keyB`) allowing 100% deterministic, instant switching via ADB without floating QA buttons on the preview surface.
  3. **Seamless Auto-Scroll on Intake Open:** Automatically animates scroll position to the bottom when contact form scenarios are activated, ensuring full visibility of the form, consent checkbox, draft text, and submit CTA on real hardware.
  4. **Draft Text Preservation:** Wired controller state to preserve draft text through validation errors and timeout/uncertain state transitions.

### D. `konfrm-quality` (Verification & Adversarial Review Authority)
- **Consultation Objective:** Formulate rigorous test suite (25/25 PASS), verify static analysis (0 issues), and capture physical hardware evidence on Samsung Galaxy A56 5G.
- **Applied Outcomes:**
  1. **Source-Linked Test Suite:** Authored 25 comprehensive behavioral and widget tests in `mobile/apps/customer_app/test/screen21_source_linked_tests.dart` verifying domain models, search filtering, category isolation, consent default OFF, form validation, draft preservation, zero forbidden test strings, pure black compliance, and 200% font scale reflow.
  2. **Zero Forbidden Strings Protocol:** Added negative assertion tests ensuring zero occurrences of forbidden prototype strings (`بيانات تجريبية`, `MR-13`, `BK-`, `PRELIVE #186`, `#186`) and zero unapproved contact channels (fake phone, fake WhatsApp, unverified email).
  3. **Physical Hardware Evidence:** Executed 12 automated captures directly from the native Android runtime on Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36) and generated Base64 companions in `review-evidence/customer-screen21/v1/screenshots/`.
  4. **Privacy Protocol (Issue #145):** Redacted physical hardware device serial numbers across all documentation (`[REDACTED_A56_ID]`).

---

## 2. Design Court Triage & Formal Governance Docket

In accordance with the KONFRM Design Court governance protocol (`docs/codex/KONFRM_MASTER_RULES.md` and Issue #183), this delivery was deliberated under a structured single-agent panel:

- **Panel Format:** `SINGLE_AGENT_STRUCTURED_PANEL` (Deliberated through specialized governance lenses representing Design, Product, Flutter, and Quality authorities; not an external multi-agent board).

### Red-Team Gate Failures & Immediate Remediation

| Red-Team Finding | Initial State in V1 Prototype | Red-Team Verdict | Corrective Action Taken |
|---|---|---|---|
| **1. Unapproved FAQ Invariants** | General FAQs included hypothetical check-in times and cancellation fee calculations. | **REJECTED** (Unverified business rules presented as customer truth). | Replaced all unconfirmed items with 5 strictly sourced FAQ fixtures derived from confirmed Master Rules (MR-12, MR-13, and Booking Canon). |
| **2. Mandatory Booking Metadata Disclosure** | Navigating from booking automatically attached booking details without user consent. | **REJECTED** (Violation of privacy boundaries and generic inquiry support). | Added an explicit opt-in consent checkbox («إرفاق بيانات هذا الحجز...») defaulting strictly to **OFF (`false`)**. Users can submit generic support inquiries freely. |
| **3. Floating QA Controls on Screen** | Initial preview runner displayed a visible floating action button for scenario switching. | **REJECTED** (Violates Founder mandate for clean, production-fidelity visual review). | Removed the floating button entirely. Scenario switching is triggered invisibly via double-tap on the app bar title or direct hardware keyevents via ADB. |

### Formal Panel Rulings

#### Case 1: In-App Form Submission Semantics vs Deferred Ticketing Backend
- **Context:** Deciding how the submit button should behave in the absence of a live support backend.
- **Panel Finding:** Fabricating a successful submission with a fictitious ticket number or fake SLA promise misleads reviewers and violates customer trust invariants.
- **Ruling:** `PANEL_APPROVED_TRUTHFUL_PROTOTYPE_BOUNDARY`. Submission triggers truthful visual validation and timeout/uncertain states with draft preservation. Production case APIs and ticketing endpoints are formally deferred under PRELIVE Issue #186.

#### Case 2: Ambient Accessibility Scaling vs Fixed Document Geometry
- **Context:** Evaluating whether Help & Support should use fixed geometry like Screen 20's A4 receipt or fluid accessibility reflow.
- **Panel Finding:** Help & Support is an interactive, conversational UI surface, not a legal printable document. Content must fully reflow under accessibility scaling (`TextScaler.linear(2.0)`) without horizontal truncation.
- **Ruling:** `PANEL_APPROVED_FULL_FLUID_SCALING`. All text, inputs, and chips scale smoothly to 200% with vertical expansion and 48dp+ touch targets.

#### Case 3: Public Help Center Access for Unauthenticated Guests
- **Context:** Handling unauthenticated guest users on Help & Support.
- **Panel Finding:** FAQ knowledge should be publicly discoverable to build guest confidence prior to booking, but unauthenticated ticket submission creates spam and security liabilities.
- **Ruling:** `PANEL_APPROVED_TIERED_ACCESS`. Guests can browse all source-backed FAQs freely; the contact form is replaced with a clear login barrier card.

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
| **Android Accessibility (WCAG 2.1 AA)** | 200% font scaling & touch targets | Tested on physical Samsung Galaxy A56 5G (Android 16 API 36). Zero overflow stripes; all interactive controls maintain 48dp+ touch targets. | **VERIFIED_PASS_ON_ANDROID** |

---

## 4. Summary Governance Verdict

- **Design Skills Compliance:** `PASS` (`konfrm-design`, `konfrm-product`, `konfrm-flutter`, and `konfrm-quality` actively integrated).
- **Design Court Governance:** `PANEL_RECOMMENDED_WITH_REMEDIATIONS` (All 3 red-team findings remediated and re-verified on hardware).
- **Store Platform Compliance:** `CONDITIONAL_ON_PRELIVE_GATES` (Open gates: iOS HIG `NOT_TESTED`, Support Backend & Live Channels `DEFERRED_TO_PRELIVE_186`).
