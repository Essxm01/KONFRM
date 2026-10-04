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
- **`OPTION_A` (Candidate A):** Open / Editorial Structure (Minimal containers; whitespace + typography + 1px dividers carry grouping; 0px container radius).
- **`OPTION_B` (Candidate B):** Contained / Modular Structure (Enclosed card modules for every section; 16px container radius; subtle shadows).
- **`OPTION_C` (Candidate C):** Role-Aware Hybrid (Open composition for Customer property detail; connected `Open Grouped Content` for Owner operations; 12px container radius; crisp 8px desktop tables for Admin).

---

## 2. Hard Gates Evaluation

Before open deliberation, the Evidence Clerk subjected all three options to Court Hard Gates:

| Hard Gate | Rule Authority | Candidate A | Candidate B | Candidate C |
|---|---|---|---|---|
| **GATE 1: PRODUCT_TRUTH** | `BUSINESS_RULES.md` | **PASS** | **PASS** | **PASS** |
| **GATE 2: NO_CARD_SOUP** | `MOBILE_DESIGN_FOUNDATION.md` §14, `cards.md` | **PASS** | **FAIL** (Creates card soup across Customer detail and Owner queue) | **PASS** (Restricts cards to independent entities; uses open grouped rows) |
| **GATE 3: ACCESSIBILITY** | WCAG 2.2 AA / Platform Touch Guidance | **PASS** | **WARN** (Border crowding at 200% scale) | **PASS** (Preserves >=44pt targets, unclipped at 200%) |
| **GATE 4: ARABIC_RTL** | `MOBILE_DESIGN_FOUNDATION.md` §11 | **PASS** | **PASS** | **PASS** |
| **GATE 5: ROLE_GRAMMAR** | `MOBILE_DESIGN_FOUNDATION.md` §23 | **PASS** | **FAIL** (Clones SaaS dashboard into Customer travel discovery) | **PASS** (Strictly differentiates Customer hospitality vs Owner operations) |
| **GATE 6: ADMIN_BOUNDARY** | `MOBILE_DESIGN_FOUNDATION.md` §7.3 | **PASS** | **FAIL** (Forces mobile card styling onto desktop) | **PASS** (Preserves desktop table workspace) |

**Gate Result:** Candidate B failed Gates 2, 5, and 6. It is retained only as an evaluated comparator. Deliberation centers on Candidate A vs Candidate C.

---

## 3. Specialist Consultation & Attribution Ledger

```
SKILL:                konfrm-product-ux
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-product-ux/SKILL.md
SOURCE_ANCHOR:        §1 Role-Specific UX Mandates
APPLIED_PRINCIPLE:    Customer requires discovery reassurance and unboxed hospitality; Owner requires operational certainty and high useful scanability; Admin requires audit throughput.
POSITION:             OPTION_C (Role-Aware Hybrid)
EVIDENCE:             Customer detail is evaluated faster when facts are unboxed; Owner home gains density when records share one container.
CONFIDENCE:           HIGH
LIMITATION:           Persona inference; real booking conversion requires future live metrics.
```

```
SKILL:                konfrm-mobile-design
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-mobile-design/SKILL.md
SOURCE_ANCHOR:        §2 Mobile Surface & Shape Hierarchy & §3 Subordinating External Numeric Heuristics
APPLIED_PRINCIPLE:    Surface roles precede raw values; container shape must harmonize with button (6px) and field (8px) without forcing a single universal radius.
POSITION:             OPTION_C (Recommends 12px Container Radius Candidate)
EVIDENCE:             12px containers provide a clean geometric progression (6px action → 8px field → 12px container) without looking overly bubbly.
CONFIDENCE:           HIGH
LIMITATION:           Native Flutter rendering acceptance deferred to Phase 4I.
```

```
SKILL:                konfrm-accessibility
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-accessibility/SKILL.md
SOURCE_ANCHORS:       §1 Contrast Ratios & Legibility Framework & §2 Touch Targets & Platform Guidance Categories
APPLIED_PRINCIPLE:    Visual bounds and hit regions are distinct; content insets and vertical rhythm must accommodate 200% text scaling without clipping.
POSITION:             OPTION_C (Both A and C pass; C provides clearer focus bounding for interactive groups)
EVIDENCE:             `stress_text_scale_200.png` confirms zero text clipping under 200% zoom.
CONFIDENCE:           HIGH
LIMITATION:           Evaluated on controlled Web pilot; physical screen reader tests deferred to native Flutter.
```

```
SKILL:                konfrm-rtl-arabic
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-rtl-arabic/SKILL.md
SOURCE_ANCHORS:       §1 Core Foundations: Arabic-First & RTL-Native & §3 Typography & Readability Constraints
APPLIED_PRINCIPLE:    Layout hierarchy must absorb multi-line Cairo title expansion; isolated LTR numerals must preserve Arabic currency suffix order.
POSITION:             OPTION_C (Handles long titles gracefully)
EVIDENCE:             `stress_long_arabic_390.png` proves 4-line property title wraps cleanly with zero container distortion.
CONFIDENCE:           HIGH
LIMITATION:           Tested with Cairo Profile B; font subsetting performance deferred to native integration.
```

```
SKILL:                konfrm-visual-qa
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-visual-qa/SKILL.md
SOURCE_ANCHORS:       CORE TENET: CI GREEN != VISUAL QA PASSED & §1 Initial QA Reference Matrix
APPLIED_PRINCIPLE:    Visual inspection across realistic viewport bounds (360px, 390px, 430px) is mandatory; layout success requires inspecting rendered pixels.
POSITION:             OPTION_C verified across 18 visual artifacts.
EVIDENCE:             Inspected artifacts show zero clipping, zero unearned whitespace, and clean component alignment.
CONFIDENCE:           HIGH
LIMITATION:           Visual pilot evidence; physical device testing remains authoritative.
```

---

## 4. Multi-Role Panel Deliberation Summary

### Round 1: Role Briefs (Sealed)
- **Product UX Counsel:** Candidate C is the only system that respects the fundamental psychological difference between the Customer (relaxed leisure discovery) and the Owner (action-oriented property operator).
- **Visual Systems Director:** Candidate B produces excessive border noise. Candidate A is beautiful but leaves dense Owner queues looking like floating text. Candidate C delivers structured calm.
- **Visual QA Prosecutor:** Attacked Candidate C on 360px width. Test `stress_reflow_360_width.png` proved that Candidate C maintains 36–42px action hit targets with zero horizontal trapped scrolling.
- **Original Idea Defender:** Championed Candidate A for its radical minimalism and fidelity to the North Star ("Spacing is a relationship, not a number"). Noted that Candidate A achieves zero card soup natively.
- **Challenger:** Pushed back on Candidate A: "An Owner with 12 pending booking requests cannot scan open divider lines as quickly as bounded operational units. Candidate C's connected groups provide essential cognitive grouping."

### Round 2: Synthetic Role Lens Hearings
- *`TRUST_SENSITIVE_FIRST_TIME_CUSTOMER` (Role Lens):* Predicts that open facts and an unboxed property description feel more inviting and less commercial, while the bounded quote box provides reassuring financial clarity.
- *`OPERATIONAL_OWNER` (Role Lens):* Predicts that connected list rows with shared container borders (`Open Grouped Content`) allow rapid vertical scanning of bookings without eye fatigue.

### Round 3: Anti-Bias Challenge
**Mandatory Challenge Question:** *"If our preferred verdict (Candidate C) is wrong, what is the most plausible reason?"*
**Panel Finding:** The most plausible risk is that maintaining asymmetric structural grammars across Customer (open editorial) and Owner (connected operational units) could slightly increase future design token complexity compared to a single rigid card template. However, this asymmetry is a core product strength mandated by `MOBILE_DESIGN_FOUNDATION.md` §23.

---

## 5. Deliberation Verdict & Advisory Recommendation

- **COURT_OUTCOME:** **`NEEDS_FOUNDER_VISUAL_DECISION`**
  *Rationale:* While Candidate C is overwhelmingly superior to Candidate B in preventing card soup, the choice between **Candidate C (Role-Aware Hybrid with 12px containers)** and **Candidate A (Pure Open / Editorial with 0px containers)** directly determines KONFRM's enduring visual personality, shape hierarchy, and containment character. This is an aesthetic and brand-level choice that requires Founder visual selection.
- **COURT_RECOMMENDATION:** **`OPTION_C` (Candidate C: Role-Aware Hybrid)**
  - Customer: Open editorial composition for facts/amenities + single-surface quote container.
  - Owner: Connected operational units (`Open Grouped Content`) with 12px outer radius and 1px internal dividers.
  - Admin: Isolated desktop table workspace with 8px radius.
  - Recommended Shape Family: 6px Action CTA → 8px Data Entry Field → 12px Structural Container.
- **CONSENSUS:** `STRONG_CONSENSUS` (for Candidate C over Candidate B; Candidate A preserved as valid minority aesthetic alternative).
- **CONFIDENCE:** `HIGH`
- **MINORITY_OPINION:**
  - *Defender Dissent:* Candidate A offers the purest expression of KONFRM minimalism by completely abolishing containers in favor of typographic proximity and hairline dividers. If the Founder prefers radical editorial simplicity over contained operational units, Candidate A remains technically and accessibly viable.

---

## 6. Founder Decision Dossier (Plain Arabic)

### القرار البصري المطلوب من المؤسس
**سؤال القرار:**
*"ما هو الطابع الهيكلي الذي يعبّر عن هوية كونفرم في تأطير المحتوى وتجميع العناصر بين العميل والمالك؟"*

### الخيارات المعروضة للمقارنة البصرية:

#### الخيار (ج) — الهجين الموجه للأدوار (توصية المحكمة):
- **العميل:** مساحة مفتوحة تحريرية؛ تفاصيل الإقامة والمميزات غير مقيدة داخل بطاقات؛ ملخص السعر فقط داخل حاوية موحدة ذات حواف (12px).
- **المالك:** تجميع العمليات المتشابهة داخل وحدة تشغيلية واحدة متصلة بحواف (12px) وفواصل داخلية رفيعة بدلاً من تكرار البطاقات المنفصلة.
- **المزايا:** يقضي تمامًا على "حساء البطاقات"، يوفر كثافة عالية ومريحة للمالك، ويحافظ على شعور الضيافة المريح للعميل.

#### الخيار (أ) — المفتوح / التحريري بالكامل (البديل البصري):
- **العميل والمالك:** إلغاء الصناديق والبطاقات بالكامل؛ الاعتماد على المسافات البيضاء والخطوط وفواصل رفيعة 1px للفصل بين العناصر (حواف 0px).
- **المزايا:** بساطة مطلقة وأقصى درجات الهدوء البصري، لكنه قد يجعل قوائم المالك الطويلة أقل تأطيرًا بصريًا.

#### الخيار (ب) — المقيد / الوحداتي (المقارن المرفوض من المحكمة):
- وضع كل قسم ومجموعة داخل بطاقة مستقلة ذات حواف (16px) وظلال خفيفة. (مرفوض لأنه ينتج تكدسًا بصريًا وتكرارًا مفرطًا للإطارات).

### ما الذي يتغير بهذا القرار:
- تحديد نصف قطر حاويات المحتوى والبطاقات (`12px` في الخيار ج مقابل `0px` في الخيار أ).
- اعتماد أسلوب "المحتوى المجمع المفتوح" كنمط أساسي لقوائم المالك.

### ما الذي لا يتغير إطلاقًا:
- زر الإجراء الأساسي يظل ثابتًا عند `6px` بلون أسود مستقر `#000000`.
- حقول الإدخال والبحث تظل ثابتة عند `8px` بنمط الإطار الواضح.
- خط Cairo Profile B ونسب الخطوط تبقى كما هي.
- شاشات الإدارة تظل جداول سطح مكتب احترافية ولا تتأثر ببطاقات الهاتف.
