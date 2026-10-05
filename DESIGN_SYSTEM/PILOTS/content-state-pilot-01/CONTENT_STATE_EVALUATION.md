# Phase 4G — Content & State Presentation System Evaluation

**Document Version:** 1.0.0  
**Phase:** Phase 4G — Content & State Presentation System  
**Status:** `PILOT_EVALUATION_DRAFT`  
**Purpose:** Comparative architectural evaluation of candidate state presentation systems against KONFRM Business Canon, Founder Rules, and Multi-Role UX Requirements.

---

## 1. Candidate Presentation Hypotheses (Section 40)

To resolve the state presentation requirements of KONFRM without preconceptions, three structurally distinct candidate systems were formulated and evaluated:

```mermaid
flowchart TD
    subgraph Candidate A [Candidate A: Badge-Centric System]
        A1["Every status rendered as a pill badge"]
        A2["High visual density; color-heavy"]
        A3["Risk: Chip Soup, Color Fatigue, Truncation at 200%"]
    end

    subgraph Candidate B [Candidate B: Message-Centric System]
        B1["Every status rendered as an alert box / banner"]
        B2["Highly descriptive; heavy vertical footprint"]
        B3["Risk: Box Clutter, Alert Fatigue, MR-17 Violation"]
    end

    subgraph Candidate C [Candidate C: Role-Aware Layered System]
        C1["Layered Hierarchy:\nBadge (Identify) → Inline (Explain) → Section/Screen (Recover)"]
        C2["Role-Tuned:\nCustomer (Editorial/Reassuring) | Owner (Action-Priority) | Admin (Audit Truth)"]
        C3["Strict Restraint: No Amber Boxes, No Chip Soup, Truthful Failure"]
    end
```

### Candidate A: Badge-Centric System
- **Core Concept:** Primary delivery mechanism for all statuses and states is a compact pill badge or chip.
- **Hypothesis:** Maximizes screen efficiency and provides a uniform, highly scannable UI across all screens.
- **Observed Failure Modes:**
  - *Status-Chip Soup:* Screens accumulate multiple colored pills (e.g. Property status + Payment status + Booking status + Verification badge) creating chaotic visual noise.
  - *Color Over-Dependence:* Users must decipher subtle color distinctions between badges to understand urgency.
  - *Inability to Deliver Consequence:* High-stakes states (e.g. rejected booking, changed quote) cannot fit necessary explanatory copy into a compact badge.
  - *Accessibility / 200% Text Scaling:* Badges easily wrap awkwardly or clip their text under extreme scaling.
  - **Verdict:** **FAILS HARD GATES** (`NO_CHIP_SOUP`, `ACCESSIBILITY_REFLOW`, `EXPLANATORY_INTEGRITY`).

---

### Candidate B: Message-Centric System
- **Core Concept:** Primary delivery mechanism is an explicit, boxed message card or banner for every status change, notice, or process milestone.
- **Hypothesis:** Maximizes user understanding by providing complete, self-contained explanatory boxes everywhere.
- **Observed Failure Modes:**
  - *Visual Bloat & Card Fatigue:* Every screen becomes stacked with heavy boxed containers, destroying the open editorial elegance of Customer screens and the high density needed for Owner operations.
  - *Founder Rule Violation:* System inevitably relies on boxed warning/stale containers, directly violating **Founder Rule MR-17** ("NO yellow/amber/orange boxed UI by default").
  - *Devaluation of Critical Alerts:* Routine procedural notices look identical to critical system failures, causing alert blindness.
  - **Verdict:** **FAILS HARD GATES** (`FOUNDER_MR_17_NO_AMBER_BOXES`, `OPEN_EDITORIAL_CANON`, `USEFUL_DENSITY`).

---

### Candidate C: Role-Aware Layered State System
- **Core Concept:** A disciplined, multi-layered delivery hierarchy governed by the information density, consequence, and role context:
  1. **Tier 1 — Identification (`STATUS_BADGE` / `LABEL`):** Used when the user simply needs to recognize a canonical state (e.g. a confirmed booking in a list, a published property). Uses subtle neutral or semantic tones; never overused.
  2. **Tier 2 — Contextual Explanation (`INLINE_TEXT` / `OPEN_TYPOGRAPHY`):** Used for normal process guidance (e.g. *"طلبك وصل للمالك وسيتم الرد خلال ساعات"*). Relies on clean typography on natural surfaces without box wrappers.
  3. **Tier 3 — Actionable Recovery (`SECTION_ALERT` / `SCREEN_STATE`):** Used only when an operation fails, data is unavailable, or a user decision is required to proceed. Includes plain Arabic consequence and retry.
  4. **Tier 4 — Transient Confirmation (`TOAST`):** Reserved exclusively for routine, completed, low-risk actions (e.g. *"تم حفظ التغييرات"*). Critical errors never use toasts.
  5. **Tier 5 — Consequential Confirmation (`DIALOG`):** Centered modal overlay reserved for irreversible decisions with truthful verbal consequence.
- **Role Alignment:**
  - *Customer:* Reassuring, editorial, open whitespace, calm status indicators.
  - *Owner:* Action-priority, high density, clear separation of pending vs available money.
  - *Admin:* Audit truth, structured data tables, failure fails closed with zero fake zero metrics.
- **Verdict:** **PASSES ALL GATES** — Fully compliant with Canon, MR-17, and Accessibility standards.

---

## 2. Evaluation Against the 15 Design Court Questions (Section 60)

| # | Question | Candidate A (Badge) | Candidate B (Message) | Candidate C (Layered - Recommended) |
| :-: | :--- | :--- | :--- | :--- |
| **1** | Default hierarchy for identifying vs explaining vs recovering? | Single flat badge layer for all. | Boxed alert banner for everything. | **Strict 4-tier layer:** Subtle Badge (Identify) → Inline Text (Explain) → Section/Screen Alert (Recover) → Toast (Transient Confirm). |
| **2** | When is badge enough? | Everywhere (Excessive). | Rarely (Replaced by boxes). | **When state identification is self-sufficient** (e.g. `CONFIRMED` in history list, `PUBLISHED` unit). |
| **3** | When is inline text enough? | Never (Forces badge). | Rarely (Forces box). | **For normal process progression** (e.g. booking request sent, wallet 24h payout eligibility notice). |
| **4** | When is persistent alert required? | Overflows badge space. | Used constantly. | **When an action is blocked, a section fails, or revalidation requires user attention.** |
| **5** | When is full-screen state appropriate? | Avoided improperly. | Overused. | **When top-level data cannot load at all, or a clean zero-data state requires dedicated redirection.** |
| **6** | When is toast allowed? | Overused for errors. | Deprecated. | **Only for transient confirmation of low-risk, completed actions** (2–4s). Never for critical errors. |
| **7** | How should normal Pending differ from Warning? | Same yellow badge. | Same amber box. | **Normal Pending is neutral/soft-blue process state.** Warning is reserved for actionable deadlines or failures. |
| **8** | How should Error differ visually from Empty? | Similar badges. | Similar boxes. | **Empty explains normal absence with positive next action. Error explains failure with honest retry.** |
| **9** | How should Partial differ from Error? | Obscured. | Dual alert boxes. | **Successful sections stay interactive; failed section shows scoped alert + retry.** |
| **10** | How should Stale safe data be presented? | Stale badge. | Amber warning banner. | **Retains safe content with neutral/soft-blue informational notice and retry.** (No amber box). |
| **11** | How should Unauthorized differ from Error? | Auth error badge. | Generic error box. | **Fails closed, clears private data, states session expiration, offers re-authentication CTA.** |
| **12** | How should Conflict / changed quote be explained? | Red badge. | Generic error banner. | **Dedicated review notice highlighting changed values, blocking submission until accepted.** |
| **13** | How should each role's tone differ? | Identical badges. | Identical banners. | **Customer: Reassuring. Owner: Action-priority / financial certainty. Admin: Structured audit truth.** |
| **14** | Which current Web behaviors must be rejected? | Chip soup. | Amber boxed alerts. | **Reject amber session expired box (Screen 12); reject silent `.catch(() => [])` in Owner payout metadata.** |
| **15** | Which exact semantic colors remain open? | Presumes colors. | Presumes colors. | **All exact semantic colors remain OPEN / token-gated.** Phase 4G governs semantic roles only. |

---

## 3. Specialized State Pattern Verification

### 3.1 True Empty vs Error Separation (Section 50)
The visual distinction between genuine data absence and server failure was tested and verified across three key domains:

1. **Customer Search:**
   - *True Empty (Zero Matches):* Compass icon, calm headline *"لا توجد نتائج تطابق بحثك"*, supportive copy suggesting adjusting dates or destination, and a primary `[إعادة ضبط الفلاتر]` button.
   - *Error State:* Alert icon, rose-tinted border, clear headline *"تعذر تحميل الإقامات"*, supportive copy stating network issue, and an explicit `[إعادة المحاولة]` button.
2. **Owner Booking Queue:**
   - *True Empty:* Calendar icon, calm headline *"لا توجد طلبات حجز حالياً"*, informative copy stating new requests will appear here immediately. Zero alert framing.
   - *Error State:* Scoped error panel inside the queue container, stating *"تعذر تحميل طلبات الحجز"* with retry CTA.
3. **Admin Verification Queue:**
   - *True Empty:* CheckCircle icon, headline *"قائمة المراجعة مكتملة بالكامل"*, confirming zero items currently pending.
   - *Error State:* Full table error replacement, headline *"تعذر تحميل قائمة المراجعة"*, confirming query failure without rendering misleading 0 counts.

### 3.2 Partial State Verification (Section 51)
- **Representative Scenario:** Owner Home Dashboard where Booking Requests load successfully, but Owner Wallet balance query encounters a network timeout.
- **Behavior:** The Booking Requests queue renders fully interactive with actionable decision buttons. The Wallet summary container renders an isolated neutral/soft-blue alert: *"تعذر تحميل بيانات المحفظة حالياً"* with an inline `[إعادة المحاولة]` button.
- **Integrity Rule:** Zero financial truth is fabricated; no `0 ج.م` fallback is rendered.

### 3.3 Stale Safe Data Verification (Section 51)
- **Representative Scenario:** Customer Explore feed where user previously retrieved property listings, but a background pull-to-refresh fails due to intermittent connectivity.
- **Behavior:** The previously retrieved property cards remain completely visible and interactive. A top informational banner (soft-blue/neutral, compliant with MR-17) appears: *"تعذر تحديث النتائج. يتم عرض آخر بيانات متوفرة."* with a subtle `[تحديث]` button.
- **Integrity Rule:** Safe catalog read data may be displayed as stale; transactional availability and quote calculations must NEVER be displayed as stale.

### 3.4 Conflict / Changed Quote Verification (Section 52)
- **Representative Scenario:** Customer Booking Request Review (Screen 07) where the nightly rate or service fee changed on the server between initial property viewing and checkout submission.
- **Behavior:** The submission CTA is disabled. A high-contrast informational card highlights the price difference:
  - *Old Total:* `3,200 ج.م` (Strikethrough)
  - *New Total:* `3,500 ج.م` (Highlighted)
  - *Explanation:* *"تم تحديث سعر الإقامة من قبل المالك. يرجى مراجعة القيمة الجديدة للمتابعة."*
  - *Action:* `[موافقة على السعر الجديد والمتابعة]` and `[إلغاء والعودة]`.

### 3.5 Accessibility & 200% Text Scaling Verification (Section 53, 55)
- All states reflow vertically when root typography is scaled to 200%.
- Action buttons in alerts, empty states, and error cards expand to full container width (`flex-direction: column`).
- Badges use inline-flex with wrapping allowances, preventing text truncation.
- Color is never the sole carrier of semantic meaning; every state includes explicit textual Arabic labels.
