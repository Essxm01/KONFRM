# KONFRM Design Court v1 — Deliberation & Verdict Report

**CASE_ID:** `DC-4E-001`
**DATE:** 2026-10-04
**PHASE:** Phase 4E — Structural System
**PILOT:** `structural-system-pilot-01`
**MODE:** `FULL_COURT`
**DELIBERATION_TOPOLOGY:** `SINGLE_AGENT_STRUCTURED_PANEL`
*(Deliberation executed sequentially with sealed role briefs by a structured single-agent panel; consensus reflects structured role alignment, not independent autonomous agents).*

---

## 1. Case Docket & Question

**Presiding Question:**
*"What structural system should govern KONFRM Customer and Owner mobile surfaces while preserving Admin's desktop operational boundary?"*

**Evaluating Options:**
- **`OPTION_A` (Candidate A):** Open / Editorial Structure (Minimal containers; whitespace + typography + 1px hairline dividers carry grouping; 0px container radius).
- **`OPTION_C` (Candidate C):** Role-Aware Hybrid Structure (Open composition for Customer property detail; connected `Open Grouped Content` for Owner operations; crisp desktop tables for Admin; 12px container radius evaluated as pilot candidate).
- **`REJECTED_COMPARATOR` (Candidate B):** Contained / Modular Structure (Enclosed card modules for every section; 16px container radius; subtle shadows). Evaluated strictly as comparator; eliminated by Hard Gates.

---

## 2. Hard Gates Evaluation

Before open deliberation, the Evidence Clerk subjected all three options to Court Hard Gates:

| Hard Gate | Rule Authority | Candidate A | Candidate B | Candidate C |
|---|---|---|---|---|
| **GATE 1: PRODUCT_TRUTH** | `BUSINESS_RULES.md` | **PASS** | **PASS** | **PASS** |
| **GATE 2: NO_CARD_SOUP** | `MOBILE_DESIGN_FOUNDATION.md` §14, `cards.md` | **PASS** | **FAIL** (Eliminated: produces card soup across Customer detail and Owner queue) | **PASS** (Restricts cards to independent entities; uses open grouped rows) |
| **GATE 3: ACCESSIBILITY** | WCAG 2.2 AA / Platform Guidance Category (Controlled Web Evidence) | **PASS** (No structural blocker in controlled Web evidence) | **WARN** (Border crowding and nested container clutter under 200% scale) | **PASS** (No structural accessibility blocker identified in controlled Web evidence; unclipped under 200% text scale, visible action hit regions preserved; native touch target acceptance ~44pt iOS / ~48dp Android `DEFERRED_TO_4I`) |
| **GATE 4: ARABIC_RTL** | `MOBILE_DESIGN_FOUNDATION.md` §11 | **PASS** | **PASS** | **PASS** |
| **GATE 5: ROLE_GRAMMAR** | `MOBILE_DESIGN_FOUNDATION.md` §23 | **PASS** | **FAIL** (Eliminated: forces desktop SaaS card containerization onto Customer vacation discovery) | **PASS** (Strictly differentiates Customer hospitality vs Owner operations) |
| **GATE 6: ADMIN_BOUNDARY** | `MOBILE_DESIGN_FOUNDATION.md` §7.3 | **PASS** | **FAIL** (Eliminated: forces mobile card styling onto desktop) | **PASS** (Preserves desktop table workspace; controlled Web boundary reference) |

**Gate Result:** Candidate B is **`ELIMINATED_BY_HARD_GATE`** (failed Gates 2, 5, and 6). It is classified as `REJECTED_COMPARATOR` and retained in evaluation history only. It is **NOT** a valid option for Founder selection.
Deliberation and Founder decision domain: **`OPTION_A vs OPTION_C only`**.

---

## 3. Specialist Consultation & Attribution Ledger

```
SKILL:                konfrm-product-ux
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-product-ux/SKILL.md
SOURCE_ANCHOR:        §1 Role-Specific UX Mandates
APPLIED_PRINCIPLE:    Customer requires unboxed hospitality and discovery clarity without pressure; Owner requires operational certainty and high useful scanability; Admin requires high-throughput audit workspace.
POSITION:             OPTION_C (Role-Aware Hybrid)
EVIDENCE:             Customer property facts are evaluated faster when unboxed; Owner home gains operational triage density when records share one container.
CONFIDENCE:           HIGH
LIMITATION:           Persona inference; booking conversion requires future live metrics.
```

```
SKILL:                konfrm-mobile-design
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-mobile-design/SKILL.md
SOURCE_ANCHOR:        §3 Subordinating External Numeric Heuristics & Decision Status Bands
APPLIED_PRINCIPLE:    Subordinates external numeric heuristics to platform conventions and component validation; recognizes provisional status bands (Primary Button 6px PRIMARY_ONLY, Mobile Field 8px FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL) while global shape system remains open; native mobile acceptance DEFERRED_TO_4I.
POSITION:             OPTION_C (Supports Role-Aware Hybrid structural model; 12px container radius evaluated as COURT_RECOMMENDED_PILOT_CANDIDATE).
EVIDENCE:             Visual inspection shows 12px structural containers harmonize with 8px field geometry and 6px button geometry without looking overly rounded or generic. (Note: 6px → 8px → 12px is an EXPERT_HEURISTIC / VISUAL_SYSTEM_REASONING, not Mobile Design authority).
CONFIDENCE:           HIGH (on structural role distinction) / MEDIUM (on exact radius tokenization, which remains open candidate).
LIMITATION:           Native Flutter rendering and touch acceptance deferred to Phase 4I.
```

```
SKILL:                konfrm-accessibility
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-accessibility/SKILL.md
SOURCE_ANCHORS:       §1 Contrast Ratios & Legibility Framework & §2 Touch Targets & Platform Guidance Categories
APPLIED_PRINCIPLE:    Visual bounds and hit regions are distinct; content insets and vertical rhythm must accommodate 200% text scaling without clipping; platform guidance (~44pt iOS / ~48dp Android) is distinct from raw web pixels; exact mobile target dimensions remain subject to empirical device and component validation.
POSITION:             OPTION_C (Both A and C pass controlled Web accessibility checks; C provides clearer bounded grouping for interactive operational sets).
EVIDENCE:             Controlled Web pilot artifact stress_text_scale_200.png confirms zero text clipping or container distortion under 200% zoom. Controlled Web reflow preserved visible actions without clipping; native hit-region acceptance is not established by this evidence and is DEFERRED_TO_4I.
CONFIDENCE:           HIGH (controlled Web evidence)
LIMITATION:           Evaluated on controlled Web pilot; physical screen reader and native touch-target acceptance deferred to native Flutter Phase 4I.
```

```
SKILL:                konfrm-rtl-arabic
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-rtl-arabic/SKILL.md
SOURCE_ANCHORS:       §1 Core Foundations: Arabic-First & RTL-Native & §3 Typography & Font Candidates
APPLIED_PRINCIPLE:    Arabic-first reading flow progresses start-to-end (RTL); Cairo Profile B is provisional typography foundation; layout hierarchy must absorb vertical ascender/descender heights and multi-line title expansion; isolated LTR numerals preserve canonical Arabic currency format (1,600 ج.م).
POSITION:             OPTION_C (Handles multi-line titles and right-to-left optical hierarchy with balanced density).
EVIDENCE:             stress_long_arabic_390.png proves 4-line Arabic property title wraps cleanly with zero container distortion; numerals format canonically as 37,000 ج.م / ليلة.
CONFIDENCE:           HIGH
LIMITATION:           Tested with Cairo Profile B in controlled Web pilot; font subsetting and native rendering deferred to Phase 4I.
```

```
SKILL:                konfrm-visual-qa
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-visual-qa/SKILL.md
SOURCE_ANCHORS:       CORE TENET: CI GREEN != VISUAL QA PASSED & §1 Initial QA Reference Matrix
APPLIED_PRINCIPLE:    Visual inspection across realistic viewport candidate coverage set (360px, 390px, 430px) is mandatory; layout success requires inspecting rendered pixels.
POSITION:             OPTION_C verified across 18 visual artifacts.
EVIDENCE:             Inspected artifacts confirm Candidate C avoids card soup, preserves responsive reflow across 360/390/430 viewports, and isolates Admin desktop table layout.
CONFIDENCE:           HIGH
LIMITATION:           Visual pilot evidence on Web; physical mobile device validation remains authoritative in Phase 4I.
```

```
UNCONSULTED_EXTERNAL_WRAPPERS:
impeccable-wrapper:       NOT_CONSULTED
ui-ux-pro-max-wrapper:    NOT_CONSULTED
frontend-design-wrapper:  NOT_CONSULTED
(Not consulted in this case; panel restricted strictly to authoritative internal specialists to ensure true attribution).
```

---

## 4. Multi-Role Panel Deliberation Summary

### Round 1: Role Briefs (Sealed)
- **Product UX Counsel:** Candidate C is the only system that respects the fundamental psychological difference between the Customer (relaxed leisure discovery) and the Owner (action-oriented property operator). Candidate B is completely eliminated by Hard Gates.
- **Visual Systems Director:** Candidate B produces excessive border noise and repetitive card framing. Candidate A is beautiful but leaves dense Owner queues looking like floating text. Candidate C delivers structured calm.
- **Visual QA Prosecutor:** Attacked Candidate C on 360px width. Test `stress_reflow_360_width.png` proved that Candidate C maintains clean reflow with zero horizontal trapped scrolling; visible action buttons reflow without clipping (native hit-target dimensions deferred to Phase 4I).
- **Original Idea Defender:** Championed Candidate A for its radical minimalism and fidelity to the North Star ("Spacing is a relationship, not a number"). Noted that Candidate A achieves zero card soup natively.
- **Challenger:** Pushed back on Candidate A: "An Owner with 12 pending booking requests cannot scan open divider lines as quickly as bounded operational units. Candidate C's connected groups provide essential cognitive grouping."

### Round 2: Synthetic Role Lens Hearings
- *`TRUST_SENSITIVE_FIRST_TIME_CUSTOMER` (Role Lens):* Predicts that open facts and an unboxed property description feel more inviting and less commercial, while the bounded quote box provides reassuring financial clarity.
- *`OPERATIONAL_OWNER` (Role Lens):* Predicts that connected list rows with shared container borders (`Open Grouped Content`) allow rapid vertical scanning of bookings without eye fatigue.

### Round 3: Anti-Bias Challenge
**Mandatory Challenge Question:** *"If our preferred verdict (Candidate C) is wrong, what is the most plausible reason?"*
**Panel Finding:** The most plausible risk is that maintaining asymmetric structural grammars across Customer (open editorial) and Owner (connected operational units) could slightly increase future design token complexity compared to a single rigid card template. However, this asymmetry is a core product strength mandated by `MOBILE_DESIGN_FOUNDATION.md` §23. Candidate B failed Hard Gates, while Candidate A remains the principled aesthetic challenger for Founder selection.

---

## 5. Deliberation Verdict & Advisory Recommendation

- **COURT_OUTCOME:** **`NEEDS_FOUNDER_VISUAL_DECISION`**
  *Rationale:* While Candidate C is overwhelmingly superior to Candidate B in preventing card soup, the choice between **Candidate C (Role-Aware Hybrid Structure)** and **Candidate A (Pure Open / Editorial Structure)** directly determines KONFRM's enduring visual personality, shape hierarchy, and containment character. This is an aesthetic and brand-level choice that requires Founder visual selection.
- **COURT_RECOMMENDATION:** **`OPTION_C` (Candidate C: Role-Aware Hybrid)**
  - Customer: Open editorial composition for facts/amenities + single-surface quote container.
  - Owner: Connected operational units (`Open Grouped Content`) with 1px internal dividers.
  - Admin: Isolated desktop table workspace (`CONTROLLED_WEB_BOUNDARY_REFERENCE`).
  - Shape Role Reference: Primary Button 6px (`PROVISIONAL_PRIMARY_ONLY`) | Field Controls 8px (`PROVISIONAL_FIELD_SHAPED_ONLY`) | Structural Container 12px (`COURT_RECOMMENDED_PILOT_CANDIDATE`).
- **CONSENSUS:** `STRONG_CONSENSUS` (for eliminating Candidate B via Hard Gates and recommending Candidate C as structural model; Candidate A retained as valid aesthetic alternative for Founder selection).
- **CONFIDENCE:** `HIGH` (empirical evidence from 18 visual artifacts supports structural model distinction and elimination of Candidate B).
- **MINORITY_OPINION:**
  - *Defender Dissent:* Candidate A offers the purest expression of KONFRM minimalism by completely abolishing containers in favor of typographic proximity and hairline dividers. If the Founder prefers radical editorial simplicity over contained operational units, Candidate A remains technically viable and free of card soup.

---

## 6. Founder Decision Dossier (Plain Arabic)

### القرار البصري المطلوب من المؤسس
**سؤال القرار:**
*"هل تفضل أن يكون النظام البنائي لكونفرم: A — مفتوحًا/تحريريًا تقريبًا بالكامل، أم C — هجينًا حسب الدور: مفتوح للعميل ومجمّع تشغيليًا للمالك؟"*

### الخيارات المعروضة للاختيار:

#### الخيار (C) — الهجين الموجه للأدوار (توصية المحكمة البصرية):
- **العميل:** مساحة مفتوحة تحريرية؛ تفاصيل الإقامة والمميزات غير مقيدة داخل بطاقات؛ ملخص السعر المالي فقط داخل حاوية موحدة ذات حواف واضحة.
- **المالك:** تجميع العمليات والبيانات المتشابهة داخل وحدة تشغيلية واحدة متصلة بفواصل داخلية رفيعة (`Open Grouped Content`) بدلاً من تكرار البطاقات المنفصلة.
- **المزايا:** يقضي تمامًا على "حساء البطاقات"، يوفر كثافة قراءة مريحة وعالية للمالك لإدارة الحجوزات، ويحافظ على هدوء الضيافة للعميل.

#### الخيار (A) — المفتوح / التحريري بالكامل (البديل المعماري):
- **العميل والمالك:** إلغاء الصناديق والبطاقات بالكامل؛ الاعتماد على المسافات البيضاء والخطوط وفواصل رفيعة 1px للفصل بين العناصر (حواف 0px).
- **المزايا:** بساطة جذرية وأقصى درجات الهدوء البصري، لكنه يقلل من التأطير البصري للعمليات التشغيلية المكثفة في قوائم المالك.

#### ملاحظة حول الخيار (B) (المقارن المرفوض):
- تم اختبار الخيار B (بطاقات مقفلة بالكامل لكل قسم) ورفضته المحكمة البصرية تمامًا بموجب بوابات الأمان الصارمة (Hard Gates) لأنه يسبب تكدس الإطارات وفوضى البطاقات (Card Soup) ويشوه تجربة الهاتف. تم الاحتفاظ به في ملفات المقارنة التاريخية فقط ولا يُعرض كخيار للاختيار.

---

### ما الذي يتغير بهذا القرار:
- اعتماد النموذج البنائي العام (الهجين C الموجه للأدوار مقابل التحريري المفتوح A).
- اعتماد أسلوب "المحتوى المجمع المفتوح" (Open Grouped Content) في شاشات المالك في حال اختيار C.

### ما الذي لا يتغير إطلاقًا ولا يرتبط بهذا القرار:
- زر الإجراء الأساسي يظل ثابتًا عند `6px` بلون أسود مستقر `#000000` (`PROVISIONAL_PRIMARY_ONLY`).
- حقول الإدخال والبحث تظل ثابتة عند `8px` بنمط الإطار المفرغ (`PROVISIONAL_FIELD_SHAPED_ONLY`).
- نصف قطر الحاوية البنائية (12px المقترح في التجربة) هو مرشح اختباري تابع للمنظومة البصرية (`COURT_RECOMMENDED_PILOT_CANDIDATE`) وليس قرارًا ملزمًا الآن؛ سيتم تدقيقه لاحقًا بصريًا دون إثقال المؤسس بأرقام هندسية.
- درجات الألوان المحايدة الدقيقة تظل مفتوحة (`OPEN`)، والقيم المستخدمة في التجربة هي مراجع عرض تقنية وليست رموزًا نهائية (`CONTROLLED_WEB_PILOT_RENDERING_REFERENCE`).
- هندسة الشارات (Badges) تظل مفتوحة ومحكومة على مستوى المكونات (`OPEN_OR_COMPONENT_GOVERNED`).
- شاشات الإدارة تظل جداول سطح مكتب احترافية ولا تتأثر ببطاقات الهاتف (`WEB_BOUNDARY_REFERENCE_ONLY`).
- اعتماد استجابة اللمس على الأجهزة الحقيقية مؤجل لمرحلة الفلاتر الأصلية (`DEFERRED_TO_4I`).
