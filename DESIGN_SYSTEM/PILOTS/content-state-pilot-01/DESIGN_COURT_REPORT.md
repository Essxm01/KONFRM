# KONFRM Design Court v1 — Deliberation & Verdict Report

> [!NOTE]
> **DATA CLASSIFICATION: LAB_SCENARIO_DATA**
> All data displayed in this pilot (names, booking IDs, property records, queues, pricing, and dates) is synthetic scenario data for layout and presentation testing only.
> `LAB_SCENARIO_DATA ≠ production evidence`.

**CASE_ID:** `DC-4G-001`  
**DATE:** 2026-10-05  
**PHASE:** Phase 4G — Content & State Presentation System  
**PILOT:** `content-state-pilot-01`  
**MODE:** `FULL_COURT`  
**DELIBERATION_TOPOLOGY:** `SINGLE_AGENT_STRUCTURED_PANEL`  
*(Deliberation executed sequentially with sealed role briefs by a structured single-agent panel; consensus reflects structured role alignment, not independent autonomous agents).*

---

## 1. Case Docket & Presiding Question

### Presiding Question
*"What Content & State Presentation system should govern KONFRM so Customer, Owner and Admin can distinguish real loading, absence, failure, progress, status, stale truth and recovery without visual alarmism or false confidence?"*

### Evaluating Candidates
- **`CANDIDATE_A` (Badge-Centric System):** Primary presentation layer relies on compact pill badges/chips for all statuses and lifecycle notifications. High horizontal density; relies heavily on color coding.
- **`CANDIDATE_B` (Message-Centric System):** Primary presentation layer relies on boxed alert banners, message cards, and callout containers for every status change, process milestone, and notice.
- **`CANDIDATE_C` (Role-Aware Layered State System — Recommended):** Disciplined 4-tier delivery hierarchy:
  1. *Identification:* Subtle text or compact badge when state recognition is sufficient.
  2. *Contextual Explanation:* Inline typography on natural surfaces for normal process milestones.
  3. *Actionable Recovery:* Scoped section or screen alert when an action is blocked or fails.
  4. *Transient Confirmation:* Toast reserved strictly for low-risk, completed actions.
  Role-tuned: Customer (reassuring/editorial), Owner (action-priority/financial certainty), Admin (audit truth/tables).

---

## 2. Hard Gates Evaluation (Round 6)

Before open deliberation, the Evidence Clerk subjected all three candidate systems to Court Hard Gates:

| Hard Gate | Governing Authority | Candidate A | Candidate B | Candidate C |
| :--- | :--- | :--- | :--- | :--- |
| **GATE 1: PRODUCT_TRUTH** | `docs/BUSINESS_RULES.md` | **FAIL** (Cannot convey full causal consequence in compact badges; conflates cancellation with rejection) | **PASS** (Explicit text conveys consequence) | **PASS** (Plain Arabic consequence; cancellation distinct from rejection; truthful data bounds) |
| **GATE 2: BUSINESS_CANON** | Master Rules MR-11, MR-12, MR-13 | **PASS** | **PASS** | **PASS** (Booking request-based; no premature confirmation; availability fails closed) |
| **GATE 3: FINANCIAL_TRUTH** | Master Rules MR-13, MR-16 | **FAIL** (Badges obscure 24h deposit pending vs available boundary) | **PASS** | **PASS** (Zero customer leakage of 80/20 split; Owner pending vs available explicitly distinguished; 500 EGP minimum enforced) |
| **GATE 4: AUTHORITY_AND_PRIVACY** | Master Rules MR-09, MR-10 | **PASS** | **PASS** | **PASS** (Fails closed on 401/403; private data cleared immediately; session expired state offers safe re-auth) |
| **GATE 5: ERROR_NOT_EMPTY** | Master Rule MR-07, `states.md` §1 | **WARN** (Badges can blend into list without clear failure boundary) | **PASS** | **PASS** (Strict separation: Error never renders as Empty; zero fallback metrics prohibited) |
| **GATE 6: FAIL_CLOSED_BOUNDARIES** | Master Rules MR-12, MR-16 | **PASS** | **PASS** | **PASS** (Transactional money and availability fail closed on disconnect/failure; no offline mutation queue) |
| **GATE 7: NO_FAKE_TRUST_OR_URGENCY** | `badges.md` §2, `alerts.md` §1 | **FAIL** (Promotes chip soup with pseudo-trust status tags) | **FAIL** (Creates alert fatigue with urgent-looking boxed notices for routine milestones) | **PASS** (Zero fake ratings, scarcity, or verified-stay marketing claims; process states are calm) |
| **GATE 8: FOUNDER_MR_17_NO_AMBER_BOXES** | Master Rule MR-17 (`FOUNDER_VISUAL_RULE_2026_09_27`) | **WARN** (Relies on yellow pills for normal process) | **FAIL** (Eliminated: relies on yellow/amber/orange boxed alert cards for process and stale data) | **PASS** (Zero amber/yellow box containers; neutral/soft-blue for stale; open typography for process) |
| **GATE 9: ACCESSIBILITY_AND_REFLOW** | WCAG 2.2 AA / Platform Guidance | **FAIL** (Badge rows wrap awkwardly and truncate under 200% text scale) | **WARN** (Excessive vertical stack pushes CTA below fold) | **PASS** (Clean vertical reflow under true 200% scale; non-color indicators; zero horizontal clipping) |
| **GATE 10: RTL_CORRECTNESS** | `MOBILE_DESIGN_FOUNDATION.md` §11–§12 | **PASS** | **PASS** | **PASS** (Logical start/end; Western Arabic numerals 0-9; canonical money format `1,600 ج.م`) |
| **GATE 11: ROLE_SPECIFIC_UX** | Master Rule MR-02, `SCREEN_STATES.md` | **FAIL** (Imposes identical badge soup across all three roles) | **FAIL** (Imposes identical box banners across all three roles) | **PASS** (Customer editorial, Owner operational, Admin audit/table boundaries strictly preserved) |

**Gate Result:**
- **Candidate A is `ELIMINATED_BY_HARD_GATE`** (Failed Product Truth, Financial Clarity, and Accessibility Reflow under 200% scale). Classified as `REJECTED_COMPARATOR`.
- **Candidate B is `ELIMINATED_BY_HARD_GATE`** (Failed Founder Rule MR-17 via amber boxed UI, Open Editorial Canon, and Useful Density). Classified as `REJECTED_COMPARATOR`.
- **Candidate C is the sole surviving candidate** satisfying all Hard Gates. Deliberation proceeds on Candidate C.

---

## 3. Specialist Consultation & Attribution Ledger

```
SKILL:                konfrm-design-reasoning
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-design-reasoning/SKILL.md
SOURCE_ANCHOR:        §1 Structured Design Dialectics & Hypothesis Hygiene
APPLIED_PRINCIPLE:    Formulate mutually distinct hypotheses (A: Badge-Centric, B: Message-Centric, C: Layered State); subject each to hard falsification criteria; preserve empirical micro-validations; prevent premature canonization of unvalidated aesthetic claims.
POSITION:             CANDIDATE_C (Strongest dialectical resolution between density and clarity).
EVIDENCE:             Comparative screenshots `candidate_a_customer_bookings_390.png` vs `candidate_b_customer_bookings_390.png` vs `candidate_c_customer_bookings_390.png` demonstrate that Candidate C balances information delivery without chip-soup or box-clutter.
CONFIDENCE:           HIGH
LIMITATION:           Evaluated in controlled Web pilot; longitudinal user comprehension metrics pending live beta.
```

```
SKILL:                konfrm-product-ux
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-product-ux/SKILL.md
SOURCE_ANCHOR:        §1 Role-Specific UX Mandates & §3 Truthful State Grammar
APPLIED_PRINCIPLE:    Customer booking clarity (request-based, approval strictly precedes payment); Owner operational certainty (actionable decision queues, clear available vs pending money distinction); Admin audit truth (zero fake zero metrics, explicit failure containment).
POSITION:             CANDIDATE_C (Role-Aware Layered State System).
EVIDENCE:             `customer_search_empty_390.png` vs `customer_search_error_390.png` proves unambiguous distinction between zero search results and network failure; `owner_home_partial_390.png` proves safe partial degradation.
CONFIDENCE:           HIGH
LIMITATION:           Evaluated against prototype booking workflow; edge-case dispute states deferred.
```

```
SKILL:                konfrm-mobile-design
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-mobile-design/SKILL.md
SOURCE_ANCHOR:        §1 Brand Identity & Visual Language & §2 Useful Density vs Air
APPLIED_PRINCIPLE:    Monochrome-first brand identity (`#000000` Primary Black); restrained blue interaction-accent role; useful density over decorative whitespace; eliminate yellow/amber container fills (Founder Rule MR-17); exact semantic palette remains OPEN / token-gated.
POSITION:             CANDIDATE_C (Decouples normal process from warning alarms).
EVIDENCE:             `customer_bookings_pending_390.png` uses soft neutral badge and calm typography for `PENDING_OWNER_APPROVAL`, avoiding false visual alarms.
CONFIDENCE:           HIGH
LIMITATION:           Native Flutter rendering and haptic feedback deferred to Phase 4I.
```

```
SKILL:                konfrm-accessibility
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-accessibility/SKILL.md
SOURCE_ANCHOR:        §1 Contrast Ratios & Legibility Framework & §2 Text Scaling & Reflow
APPLIED_PRINCIPLE:    Color must never be the sole carrier of semantic meaning; critical errors must not live only in toasts; all state surfaces must accommodate true 200% text scale without clipping, horizontal scrolling, or overlapping actions.
POSITION:             CANDIDATE_C (Passes 200% text scaling and non-color semantic validation).
EVIDENCE:             `stress_true_200_customer_error_390.png`, `stress_true_200_customer_conflict_390.png`, and `stress_true_200_owner_wallet_390.png` prove complete vertical reflow with zero horizontal clipping.
CONFIDENCE:           HIGH
LIMITATION:           Screen reader accessibility attributes evaluated via semantic HTML; native TalkBack / VoiceOver audit deferred to Phase 4I.
```

```
SKILL:                konfrm-rtl-arabic
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-rtl-arabic/SKILL.md
SOURCE_ANCHOR:        §1 Core Foundations: Arabic-First & RTL-Native & §3 Number Formatting & Currency
APPLIED_PRINCIPLE:    Natural RTL reading hierarchy; Western Arabic numerals (`0-9`) exclusively; canonical Egyptian Pound format (`1,600 ج.م`); proper bidirectional isolation for technical booking references (`BK-183223`) and phone numbers.
POSITION:             CANDIDATE_C (Strict RTL and Bidi compliance).
EVIDENCE:             `customer_quote_conflict_390.png` proves strikethrough old price and highlighted new price maintain proper RTL numeral placement without flipping currency symbols.
CONFIDENCE:           HIGH
LIMITATION:           Font shaping verified on Cairo Profile B in Web pilot; native Android/iOS Arabic text rendering engines deferred to Phase 4I.
```

```
SKILL:                konfrm-visual-qa
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-visual-qa/SKILL.md
SOURCE_ANCHOR:        §1 Viewport Set Mandates & §3 Component State Coverage
APPLIED_PRINCIPLE:    Verify all candidate states across 360px, 390px, and 430px mobile viewports and 1280px / 1440px desktop viewports; ensure `docScrollWidth <= clientWidth`; eliminate clipping root causes; verify distinct comparators have distinct visual artifacts.
POSITION:             CANDIDATE_C (Verified across 43 independent artifacts).
EVIDENCE:             43 image artifacts in `evidence/` verified with non-zero byte sizes, unique hashes for distinct states, and zero right-edge clipping.
CONFIDENCE:           HIGH
LIMITATION:           Desktop browser emulation; physical device touch lab testing scheduled for Phase 4I.
```

---

## 4. Synthetic Role Lenses (Round 4)

> [!IMPORTANT]
> **SYNTHETIC PERSONA OPINION ≠ USER RESEARCH EVIDENCE**
> The following represents structured perspective simulation to identify blind spots; it does NOT constitute real empirical user testing.

- **`TRUST_SENSITIVE_FIRST_TIME_CUSTOMER` (Synthetic Lens):**  
  *Observation:* Highly vulnerable to feeling misled by booking progress.  
  *Assessment:* Candidate C provides deep reassurance: Screen 11 clearly confirms *"طلبك وصل للمالك"* without claiming the booking is confirmed, and My Bookings clearly states that deposit payment only happens after the Owner approves. Rejects Candidate A's chip soup as confusing and Candidate B's alert boxes as alarming.
- **`RETURNING_CUSTOMER` (Synthetic Lens):**  
  *Observation:* Values fast, unhindered navigation and clear price changes.  
  *Assessment:* Candidate C's quote conflict state (`customer_quote_conflict_390.png`) highlights the exact price delta in a clean review card, allowing rapid comprehension and decision-making without obscure error codes.
- **`OPERATIONAL_OWNER` (Synthetic Lens):**  
  *Observation:* Highly focused on net income, payout eligibility, and immediate action items.  
  *Assessment:* Strongly endorses Candidate C's Wallet presentation (`owner_wallet_loaded_390.png`): Available balance is clearly distinguished from 24-hour Pending deposit funds, and the disabled payout button clearly states the 500 EGP threshold, eliminating support inquiries.
- **`QUEUE_OPERATOR_ADMIN` (Synthetic Lens):**  
  *Observation:* Needs fast throughput and total trust in queue counts.  
  *Assessment:* Strongly supports Candidate C's refusal to render fake 0 metrics upon overview query failure (`admin_overview_error_1440.png`). Acknowledges that truthful error reporting protects operational integrity.
- **`EXCEPTION_AUDIT_ADMIN` (Synthetic Lens):**  
  *Observation:* Demands strict separation between user-facing marketing claims and canonical verification data.  
  *Assessment:* Confirms that Candidate C preserves `VERIFIED` as an internal compliance state rather than an unverified marketing trust badge.

---

## 5. Red Team Evaluation (Round 5)

The Visual QA Prosecutor and Red Team attacked Candidate C across 14 failure axes:

| Attack Vector | Red Team Vulnerability Probe | Candidate C Defense & Resolution Evidence |
| :--- | :--- | :--- |
| **1. Error Masquerading as Empty** | Could a failed search or query render a clean empty box? | **DEFENDED:** Hard-coded distinction in `App.tsx` and pilot. Error renders explicit red-bordered container with retry; Empty renders compass/suitcase with redirection. Verified in `customer_search_empty_390.png` vs `customer_search_error_390.png`. |
| **2. Fake Zero Metrics** | Could Admin overview render "0 items pending" on network drop? | **DEFENDED:** Fixed historical defect A-02. Overview renders explicit error panel: *"لم يتم استلام بيانات موثوقة... لم تُعرض أي أرقام بديلة."* Verified in `admin_overview_error_1440.png`. |
| **3. Fake Success** | Does submitting a booking claim instant confirmation? | **DEFENDED:** Screen 11 confirms *"تم إرسال طلب الحجز بنجاح"* with clear lifecycle explanation that Owner review precedes deposit. Verified in `customer_booking_success_390.png`. |
| **4. Fake Warnings on Normal Process** | Are pending states styled with warning/amber colors? | **DEFENDED:** `PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, and `Wallet PENDING` map to `neutral-process` (slate/soft-blue). Zero warning alarms. Verified in `customer_bookings_pending_390.png`. |
| **5. Status-Chip Soup** | Do cards accumulate multiple badges? | **DEFENDED:** Maximum one primary status badge per card. Contextual facts use structured text. Verified in `candidate_c_customer_bookings_390.png`. |
| **6. Boxed Banner Clutter** | Do screens become stacked with heavy box borders? | **DEFENDED:** Boxed alerts reserved strictly for blocked actions or section failures. Routine guidance uses open typography. |
| **7. Lost Primary Action** | Does a state screen leave the user stranded without a CTA? | **DEFENDED:** Every recoverable state includes an explicit primary CTA (`[إعادة ضبط الفلاتر]`, `[إعادة المحاولة]`, `[تسجيل الدخول]`, `[إضافة وحدة]`). |
| **8. Ambiguous Disabled State** | Do disabled buttons fail to explain why they are inactive? | **DEFENDED:** Disabled payout button displays helper text: *"الزر غير نشط لأن الرصيد المتاح أقل من الحد الأدنى للسحب (500 ج.م)"*. Verified in `owner_wallet_disabled_390.png`. |
| **9. Technical Language Leakage** | Are database codes or HTTP 500 exposed? | **DEFENDED:** Zero technical jargon on Customer/Owner surfaces. Plain Egyptian/Modern Arabic exclusively. |
| **10. Money Truth Ambiguity** | Can pending funds look like available cash? | **DEFENDED:** Distinct green Available panel vs slate/neutral Pending panel with 24-hour check-in rule. Verified in `owner_wallet_loaded_390.png`. |
| **11. Stale Truth Shown as Fresh** | Can expired data look newly verified? | **DEFENDED:** Top informational banner explicitly discloses: *"تعذر تحديث النتائج. يتم عرض آخر بيانات متوفرة."* Verified in `customer_explore_stale_390.png`. |
| **12. Session-Expired Data Leakage** | Does private data remain visible after session loss? | **DEFENDED:** Session expired state clears private booking/wallet arrays immediately, failing closed. Verified in `customer_bookings_expired_390.png`. |
| **13. Overly Celebratory Routine UI** | Do routine actions trigger oversized confetti or animations? | **DEFENDED:** Routine operational tasks confirm quietly (Toast); dedicated success surfaces reserved for contractual milestones (e.g. Screen 11). |
| **14. 200% Text Clipping & RTL Breakage** | Do buttons truncate or chevron flip backwards? | **DEFENDED:** Responsive vertical reflow verified under 200% text scale in `stress_true_200_customer_conflict_390.png`. RTL Back arrow points right (➔). |

---

## 6. Answers to the 15 Specific Court Questions (Section 60)

1. **Default Hierarchy for State Delivery:**  
   Subtle Badge (Identify) → Inline Typography (Explain Process) → Scoped Section/Screen Alert (Recover/Action) → Toast (Transient Confirmation).
2. **When is a Badge Enough?**  
   When canonical state recognition is self-sufficient and requires no immediate user decision (e.g. `CONFIRMED` in a history list, `PUBLISHED` unit).
3. **When is Inline Text Enough?**  
   For normal procedural guidance (e.g. *"طلبك وصل للمالك وسيتم الرد خلال ساعات"*). Relies on natural surface contrast without box borders.
4. **When is a Persistent Alert Required?**  
   When a user action is actively blocked, an independent section query fails, or revalidation requires explicit user review before proceeding.
5. **When is a Full-Screen State Appropriate?**  
   When top-level data cannot load at all, or a clean zero-data state requires dedicated redirection (e.g. Guest state, first-run empty properties).
6. **When is a Toast Allowed?**  
   Reserved strictly for transient confirmation of completed, low-risk actions (2–4s). Critical errors, financial warnings, and mandatory decisions must never rely solely on toasts.
7. **How Normal Pending Differs from Warning:**  
   Normal process (`PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, `Wallet PENDING`) uses soft neutral or soft-blue styling (`#F1F5F9`, `#334155`). Warning/Attention is reserved for actionable deadlines or consequential failures.
8. **How Error Differs from Empty:**  
   Empty explains normal data absence with positive exploration guidance. Error identifies failure scope with plain-language explanation and a clear `[إعادة المحاولة]` button.
9. **How Partial Differs from Error:**  
   Successful sections remain fully interactive; failed sections display a scoped alert with retry. The screen never collapses completely.
10. **How Stale Safe Data is Presented:**  
    Retains safe cached content with a neutral or soft-blue informational notice and retry button. Zero yellow/amber boxed styling (MR-17).
11. **How Unauthorized Differs from Error:**  
    Fails closed, clears private session data, explains that authentication is required/expired, and provides a direct `[تسجيل الدخول]` action.
12. **How Conflict / Changed Quote is Explained:**  
    Disables submission CTA, displays strikethrough old price and highlighted new price, and requires user review and acceptance before proceeding.
13. **How Role Tone Differs:**  
    Customer is reassuring and simple; Owner is operational, action-focused, and financially certain; Admin is precise, structured, and audit-focused.
14. **Rejected Web Behaviors:**  
    Rejected legacy amber session-expired card (Screen 12); rejected silent `.catch(() => [])` fallbacks in Owner payout metadata; rejected chip soup and alert box clutter.
15. **Open Semantic Colors:**  
    All exact semantic hex colors (green, red, blue, neutral, amber) remain **OPEN / token-gated**. Phase 4G establishes semantic roles and visual contracts only.

---

## 7. Final Verdict & Founder Gate Recommendation

- **COURT_OUTCOME:** `VERDICT_REACHED`
- **CONSENSUS_CLASS:** `STRONG_CONSENSUS`
- **CONFIDENCE_LEVEL:** `HIGH`
- **RECOMMENDED_CANDIDATE:** **`CANDIDATE_C — ROLE-AWARE LAYERED STATE SYSTEM`**
- **MINORITY_OPINION:** None opposed Candidate C. A minority note recommended evaluating whether complex multi-day booking states benefit from an optional secondary timestamp badge alongside the primary status badge; deferred to Phase 4H component catalog specification.

### Founder Decision Gate Determination (Section 64)
- **`FOUNDER_DECISION_REQUIRED:`** **`NO`**
- **Rationale:** Candidate C is the sole candidate that satisfies all non-negotiable Hard Gates, complies with Founder Rule MR-17 (No Amber Boxes), and upholds Server-Truth Canons. The residual differences between Candidate C and the rejected Candidates A and B are objective architectural defects (A fails consequence delivery/accessibility reflow; B violates MR-17 and useful density), not subjective aesthetic choices. No material Founder trade-off remains unresolved.
