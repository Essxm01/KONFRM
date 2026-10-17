# KONFRM Customer Application (Screens 01–22) — Comprehensive Design, Fidelity & Evidence Audit Matrix

**Mode:** PLAN MODE — GLOBAL CUSTOMER APPLICATION AUDIT  
**Governing Directives:**
- [Founder Master Order & Plan Contract (2026-10-17)](https://github.com/Essxm01/KONFRM/blob/2371e2968ecc2907201a85cd96aa57364eccdecc/prompt/KONFRM_FOUNDER_SCREEN22_AND_CUSTOMER_01_22_GLOBAL_DESIGN_PLAN_MODE_20261017.md)
- [Issue #192: 22-Screen Design Audit & Physical RTL Back-Arrow Law](https://github.com/Essxm01/KONFRM/issues/192)
- [Issue #191: Screen 22 Booking Chat Founder Correction](https://github.com/Essxm01/KONFRM/issues/191#issuecomment-6227072272)
- [Issue #187: Cross-Screen UX Gaps & Missing Journeys](https://github.com/Essxm01/KONFRM/issues/187)
- [Issue #185: Screen 21 Approval & Freeze Baseline](https://github.com/Essxm01/KONFRM/issues/185)
- [Issue #183: Design Skills Activation, Design Court & Store Platform Gates](https://github.com/Essxm01/KONFRM/issues/183)
- [Issue #182: Cross-Screen Content & Defect Issues](https://github.com/Essxm01/KONFRM/issues/182)
- [Issue #175: Pure Black #000000 Mandatory Rule](https://github.com/Essxm01/KONFRM/issues/175)
- [Issue #166: Founder Design-First Priorities — Native UI/UX & Cairo RTL](https://github.com/Essxm01/KONFRM/issues/166)
- [Issue #155: Historical Evidence Directory Immutability](https://github.com/Essxm01/KONFRM/issues/155)
- [Issue #145: Hardware Serial Redaction Protocol](https://github.com/Essxm01/KONFRM/issues/145)

**Dedicated Review Branch:** `evidence/customer-cross-screen-fidelity-audit`  
**Base Commit (Frozen Screen 21):** `d04f8e5e657502b58886a9b9d0dd934d1a97f20a`  
**Hardware Reference:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, Serial `[REDACTED_A56_ID]`)  

---

## 1. Executive Summary & Audit Scope

This document establishes the authoritative, definitive 22-screen audit of the entire KONFRM Customer mobile application (Screens 01 through 22). It provides an exhaustive, evidence-backed evaluation of:
1. **Physical RTL Back-Arrow Geometry:** Guaranteeing that every nested child screen places its Back button on the physical right edge with an arrowhead visibly pointing **RIGHT `[➔]`** towards the screen edge in Arabic RTL.
2. **Visual Hierarchy & Header Quietness:** Purging multi-layer header clutter, persistent subtitles, repetitive breadcrumb banners, and redundant scope boxes in favor of calm, single-line headers with collapsible disclosure where needed.
3. **Pure Black `#000000` Compliance (Issue #175):** Ensuring strict elimination of all charcoal, slate, and navy approximations in primary brand elements, titles, and active CTAs.
4. **Epistemic Business Canon & Content Truth:** Eradicating unverified operational claims (instant refund promises, fake check-in times, automated SLAs, phantom message delivery checkmarks, and speculative tax numbers).
5. **Accessibility 200% Font Scale Reflow:** Guaranteeing zero text truncation, zero RenderFlex layout overflow exceptions, and preserved `minHeight: 48dp` interactive touch targets under `TextScaler.linear(2.0)`.

---

## 2. Global Classification Taxonomy

Every screen is evaluated and categorized into one of five rigorous operational verdicts:

- `NO_CHANGE`: Formally approved, frozen, and fully compliant with all governing design canons and Founder orders. No further design intervention required.
- `P0`: Critical functional or business defect requiring immediate remediation before release (e.g., conflicting financial rules, policy violations, or blocking navigation failure).
- `P1`: Material visual, navigation, or accessibility defect (e.g., inverted Back-arrow direction, header overcrowding, text clipping at 200% font scale, or charcoal contrast violation).
- `P2`: Minor aesthetic polish, subtle spacing alignment, or micro-typography refinement.
- `PRELIVE`: Live backend integration, external payment gateway, WebSocket presence, or device camera/storage capability properly deferred to prelive gates per Issue #190 / #186.

---

## 3. Comprehensive 22-Screen Audit Matrix

| Screen | Title (Arabic / English) | Category | Frozen Branch & Commit SHA | Back Arrow Status | Header & Clutter Status | Pure Black (#000000) | Content & Canon Truth | 200% A11y Scaling | Existing Hardware Evidence (A56) | Verdict |
|:---:|---|:---:|---|:---:|:---:|:---:|:---:|:---:|---|:---:|
| **01** | واجهة التطبيق الأساسية<br>Customer Shell & Entry | `TOP_LEVEL_TAB` | `phase5/customer-c1-shell-entry`<br>`ba3149b3e53e` | N/A (Root shell) | PASS (Clean bottom tab shell) | PASS | PASS | PASS | `scratch/samsung_live_screen_portrait_app.png` | `NO_CHANGE` |
| **02** | تسجيل الدخول / رمز التحقق<br>Auth & OTP Sheet | `MODAL_SHEET` | `phase5/customer-c1-shell-entry`<br>`ba3149b3e53e` | Close `[✕]` on physical left | PASS (Modal sheet) | PASS | PASS (Truthful OTP gate) | PASS | `scratch/uidump_auth.xml` | `NO_CHANGE` |
| **03** | استكشاف الوحدات<br>Explore Feed | `TOP_LEVEL_TAB` | `feat/customer-screen03-explore-redesign`<br>`093c141a7365` | N/A (Top Tab 1) | PASS (Minimal search bar + category pills) | PASS | PASS (Source-backed properties) | PASS | `scratch/samsung_live_explore_loaded.png` | `NO_CHANGE` |
| **04** | البحث وتخصيص الفلاتر<br>Search & Filter Refine | `NESTED_CUSTOMER` | `feat/customer-screen04-search-refine`<br>`b0ca18a415ba` | **DEFECT** (Points left `[←]`) | **CLUTTER** (Redundant filter summary strip) | PASS | PASS | PASS (Dynamic sticky CTA) | `scratch/search_kb.png` | `P1` |
| **05** | نتائج البحث المعفاة<br>Filtered Search Results | `NESTED_CUSTOMER` | `evidence/customer-screen05-a56-review`<br>`ba3f1bc739d2` | **DEFECT** (Auto-mirrored left) | PASS (Clean grid header) | PASS | PASS | PASS | `review-evidence/customer-screen05/` (6 A56 captures) | `P1` |
| **06** | تفاصيل الوحدة والعقار<br>Property Details View | `NESTED_CUSTOMER` | `feat/customer-screen06-property-details-v3`<br>`7107fcffeae2` | **DEFECT** (Hero back icon points left) | **CLUTTER** (Persistent unit badge over hero) | PASS | PASS (Verified amenities) | PASS | `scratch/samsung_a56_screen06_top_remediated.png` | `P1` |
| **07** | مراجعة تفاصيل الحجز<br>Booking Review & Quote | `NESTED_CUSTOMER` | `feat/customer-screen07-booking-review-v2`<br>`157a57181e87` | **DEFECT** (Points left `[←]`) | PASS (Card stack) | PASS | **DEFECT** (Needs «عربون الليلة الأولى» alignment per Screen 20) | PASS | `scratch/samsung_a56_screen07_01_ready.png` | `P0` |
| **08** | التحقق من الهوية الرقمية<br>Identity Verification / KYC | `NESTED_CUSTOMER` | `evidence/customer-screen08-design-review`<br>`213a2e35fb95` | **DEFECT** (Points left `[←]`) | PASS (Step progress) | PASS | PASS (Privacy-safe instructions) | PASS | `review-evidence/customer-screen08/` (9 A56 captures) | `P1` |
| **09** | اختيار وسيلة السداد<br>Payment Method Selection | `NESTED_CUSTOMER` | `evidence/customer-screen09-design-review`<br>`e1589241ffd1` | **DEFECT** (Points left `[←]`) | PASS (Restrained list) | PASS | PASS (Card & Apple Pay only) | PASS | `review-evidence/customer-screen09/` (9 A56 captures) | `P1` |
| **10** | بوابة السداد الآمن<br>Payment 3DS Processing | `NESTED_CUSTOMER` | `evidence/customer-screen10-design-review`<br>`fcbf978f0f90` | Cancel text action | PASS (Secure vault) | PASS | PASS (Epistemic gateway honesty) | PASS | `review-evidence/customer-screen10/` (9 A56 captures) | `P1` |
| **11** | تأكيد إرسال الطلب<br>Booking Request Sent Hub | `TERMINAL_HUB` | `evidence/customer-screen11-design-review`<br>`026845e6acbf` | Return CTA to Trips | PASS (Celebratory minimalist hub) | PASS | PASS («قيد الانتظار» truth) | PASS | `review-evidence/customer-screen11/` (6 A56 captures) | `NO_CHANGE` |
| **12** | حجوزاتي ورحلاتي<br>My Bookings / Trips Hub | `TOP_LEVEL_TAB` | `evidence/customer-screen12-design-review`<br>`492b1dc5e98f` | N/A (Top Tab 2) | PASS (Filter segments: الحالية / السابقة) | PASS | PASS (Numeric booking IDs only) | PASS | `review-evidence/customer-screen12/` (10 A56 captures) | `NO_CHANGE` |
| **13** | إدارة الحجز وتفاصيل الإقامة<br>Stay Hub & Booking Detail | `NESTED_CUSTOMER` | `evidence/customer-screen13-design-review`<br>`7c05a9b081cf` | **DEFECT** (Points left `[←]`) | **CLUTTER** (Multi-badge status bar) | PASS | PASS (All deep links verified) | PASS | `review-evidence/customer-screen13/` (15 A56 captures) | `P1` |
| **14** | إلغاء الحجز والسياسة<br>Cancellation Flow | `NESTED_CUSTOMER` | `evidence/customer-screen14-design-review`<br>`b5963d849023` | **DEFECT** (Points left `[←]`) | PASS (Stepwise flow) | PASS | **DEFECT** (Align with MR-15 & Screen 21 pending cancellation rule) | PASS | `review-evidence/customer-screen14/` (12 A56 captures) | `P0` |
| **15** | الملف الشخصي والإعدادات<br>Customer Profile Hub | `TOP_LEVEL_TAB` | `evidence/customer-screen15-design-review`<br>`5aabc3843ea3` | N/A (Top Tab 4) | PASS (Quiet list menu) | PASS | PASS (Account truth) | PASS | `review-evidence/customer-screen15/` (8 A56 captures) | `NO_CHANGE` |
| **16** | الإشعارات والرسائل الواردة<br>Notifications & Inbox | `NESTED_CUSTOMER` | `evidence/customer-screen16-design-review`<br>`c2d966623d76` | **DEFECT** (Points left `[←]`) | PASS (Categorized feed) | PASS | PASS (Zero fake alerts) | PASS | `review-evidence/customer-screen16/` (7 A56 captures) | `P1` |
| **17** | قائمة المفضلة والمحفوظات<br>Saved Wishlists | `TOP_LEVEL_TAB` | `evidence/customer-screen17-design-review`<br>`d1a8ab97442e` | N/A (Top Tab 3) | PASS (Grid layout) | PASS | PASS | PASS | `review-evidence/customer-screen17/` (6 A56 captures) | `NO_CHANGE` |
| **18** | تقييم الإقامة والمراجعة<br>Review & Rating Submission | `NESTED_CUSTOMER` | `evidence/customer-screen18-design-review`<br>`70278470f9d4` | **DEFECT** (Points left `[←]`) | PASS (5-star input + commentary) | PASS | PASS (Truthful submission gate) | PASS | `review-evidence/customer-screen18/` (9 A56 captures) | `P1` |
| **19** | سجل العمليات المالية<br>Payment History & Invoices | `NESTED_CUSTOMER` | `evidence/customer-screen19-design-review`<br>`c2145f9a6bdf` | **DEFECT** (Points left `[←]`) | PASS (Filtered transaction cards) | PASS | PASS (TXN hidden in list per order) | PASS | `review-evidence/customer-screen19/` (10 A56 captures) | `P1` |
| **20** | إيصال السداد الموحد (PDF)<br>Unified Payment Receipt | `NESTED_CUSTOMER` | `evidence/customer-screen20-design-review`<br>`bf1aeeb0ef2c` | Physical Right `[➔]` | PASS (A4 preview with print/share) | PASS | PASS («عربون الليلة الأولى» verified) | PASS | `review-evidence/customer-screen20/` (8 A56 captures) | `NO_CHANGE` |
| **21** | المساعدة والدعم المتقدم<br>Help & Support Center | `NESTED_CUSTOMER` | `evidence/customer-screen21-design-review`<br>`d04f8e5e6575` | Physical Right `[➔]` | PASS (Search + FAQs + Support form) | PASS | PASS (Truthful FAQs & unconfirmed gate) | PASS | `review-evidence/customer-screen21/` (12 A56 captures) | `NO_CHANGE` |
| **22** | محادثة الحجز المباشرة<br>Booking-Scoped Chat | `NESTED_CUSTOMER` | `evidence/customer-screen22-design-review`<br>`09aa2146bef4` | **PASS** (Physical Right `[➔]`) | **PASS** (Calm single line + disclosure) | PASS | **PASS** (Natural rental coordination) | PASS | `review-evidence/customer-screen22/` (12 A56 captures) | `NO_CHANGE` |

---

## 4. Priority Findings & Actionable Remediation Plan

### Priority P0: Critical Canon & Financial Invariant Remediation (2 Screens)
1. **Screen 07 (Booking Review & Quote):**
   - **Defect:** Price breakdown uses generic deposit terminology («المبلغ المستحق الآن») without explicitly naming it **«عربون الليلة الأولى»**.
   - **Remediation:** Update breakdown line item to «عربون الليلة الأولى (غير قابل للاسترداد وفق سياسة المالك)» and highlight that the remainder is payable upon arrival/check-in, achieving 100% vocabulary unison with Customer Screen 20 and Founder Receipt Directive.
2. **Screen 14 (Cancellation Flow):**
   - **Defect:** Historical copy contains claims that pending bookings can always be cancelled without penalty.
   - **Remediation:** Align cancellation copy with **Master Rules MR-15** and **Screen 21 FAQ Truth**: clarify that pending bookings («قيد الانتظار») are awaiting host confirmation and explain cancellation rights truthfully based on confirmed booking parameters rather than universal guarantees.

### Priority P1: Physical RTL Back-Arrow Law Remediation (11 Screens)
- **Affected Screens:** Screen 04, 05, 06, 07, 08, 09, 10, 13, 14, 16, 18, 19.
- **Root Cause Defect:** In Flutter, using standard `Icons.arrow_forward_rounded` or `Icons.arrow_back` inside an RTL tree causes automatic bidirectional icon mirroring. This erroneously points the Back button towards the physical LEFT `[←]` (the interior of the screen) instead of pointing towards the physical RIGHT `[➔]` (the exit edge).
- **Universal Fix:** Migrate all nested app bars to the **Global Physical RTL Back-Arrow Law**:
  ```dart
  Directionality(
    textDirection: TextDirection.ltr,
    child: IconButton(
      icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF000000)),
      onPressed: () => Navigator.of(context).maybePop(),
    ),
  )
  ```

### Priority P2: Visual Spacing & Header Compression (3 Screens)
- **Screen 04:** Remove redundant sticky filter summary chips that duplicate search criteria.
- **Screen 06:** Remove floating badge over property hero photo to prevent obscuring gallery views.
- **Screen 13:** Compress multi-badge status header into a calm single-line presentation consistent with Screen 22.

---

## 5. Architectural Non-Goals & Invariants
- **Zero Production App Code Touch in Plan Mode:** Production directories (`mobile/apps/customer_app/lib/`, backend, and migrations) remain strictly untouched.
- **Evidence Immutability (Issue #155):** All historical evidence directories (`review-evidence/customer-screen05/` through `screen22/v1/`) remain immutable.
- **Serial Redaction (Issue #145):** Physical hardware serials are permanently masked as `[REDACTED_A56_ID]`.
- **Screen 23 Gate:** Customer Screen 23 (Dispute / Evidence) remains strictly unstarted pending formal Founder approval.
