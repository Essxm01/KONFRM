---
name: konfrm-design-reasoning
description: "Human-centered design reasoning and perceptual decision layer for KONFRM. Sits between Canon and visual choices, running structured design dialectics (Hypotheses A/B/C), evaluating perception/Gestalt/brand congruence, role lenses, research claim hygiene, and recommending micro-validations."
---

# KONFRM Human-Centered Design Reasoning

A disciplined perceptual and cognitive decision layer for the KONFRM design architecture. Sits strictly between **KONFRM Canon / Product Truth** and **specific visual/component decisions**.

---

> [!IMPORTANT]
> ### GOVERNANCE & CANON BOUNDARY
> **This skill does NOT create product or business truth, and does NOT canonize values by itself.**
> A design suggestion from an external skill or craft guide must never be:
> - **A) Blindly accepted** merely because an external skill asserts it.
> - **B) Automatically rejected** merely because it is not yet explicitly defined in Canon.
>
> Instead, external suggestions become **design hypotheses** to be analyzed, challenged, researched, compared, tested, and resolved through disciplined human-centered reasoning.

---

## 1. Research Claim Hygiene & Evidence Extrapolation Rules

AI reasoning engines must not merely cite academic papers or heuristics; they must accurately understand what the source studied and explicitly label the boundary between source findings and KONFRM inferences.

Every empirical design claim must distinguish:
1. **WHAT THE SOURCE DIRECTLY FOUND:** The literal empirical observation made in the study.
2. **STUDY POPULATION / STIMULUS / TASK:** The subject pool (e.g. undergraduate students), stimuli (e.g. 2D geometric polygons, neutral household objects), and experimental task (e.g. rapid laboratory forced-choice preference).
3. **WHAT KONFRM IS INFERRING FROM IT:** The specific UX or visual hypothesis KONFRM derives for its product.
4. **LIMITATIONS / TRANSFER RISK:** Why findings from generic stimuli in a laboratory may not transfer directly to high-stakes Egyptian real-estate transactions, bilingual Arabic typography, or mobile touchscreen controls.
5. **WHAT REQUIRES PRODUCT-SPECIFIC VALIDATION:** The empirical test needed on actual KONFRM prototypes to confirm the hypothesis.

> [!TIP]
> **Claim Hygiene Examples:**
> - ✅ **ALLOWED (Disciplined Inference):**
>   *"Bar & Neta (2006) found a preference bias toward curved over sharp contours in their tested 2D neutral visual-object stimuli. This supports a general contour-perception hypothesis, but does not directly prove that rounded mobile buttons improve booking confidence or reduce transaction hesitation in rental apps."*
> - ❌ **FORBIDDEN (Unsubstantiated Extrapolation):**
>   *"Sharp mobile buttons increase user anxiety."*
> - ❌ **FORBIDDEN (Universal Psychology Law):**
>   *"Users will feel uncomfortable with sharp corners."*

Never extrapolate generic-object or abstract psychology studies directly into product-UI assertions without explicitly labeling the inference and transfer risk.

---

## 2. The Required Decision Loop

For any meaningful, unresolved visual or design decision, agents must execute the 12-step reasoning loop:

```
OBSERVE
  └── Identify the UI context, active role, and specific visual question.
HYPOTHESIZE
  └── Formulate 2–3 distinct, credible design hypotheses (Hypothesis A, B, and optionally C).
ARGUE FOR
  └── Articulate the strongest theoretical and empirical arguments supporting each hypothesis.
ARGUE AGAINST
  └── Attack each hypothesis with usability, cognitive load, perceptual friction, or edge cases.
RESEARCH
  └── Gather evidence evaluated along two axes: Methodological Quality × Contextual Relevance.
ROLE LENS
  └── Filter through the specific cognitive and emotional needs of Customer, Owner, or Admin.
BRAND CONGRUENCE
  └── Analyze alignment with the geometric, structured KONFRM brand identity.
PLATFORM / ACCESSIBILITY CHECK
  └── Validate against non-waivable WCAG/touch constraints and authoritative platform conventions.
ALTERNATIVES
  └── Compare trade-offs between hypotheses without creating superficial variety.
PROTOTYPE / VISUAL TEST
  └── Formulate a concrete micro-validation plan (or note VISUAL_QA status).
DECISION
  └── Synthesize findings into a provisional recommendation.
CONFIDENCE + STATUS
  └── Assign confidence (LOW / MEDIUM / HIGH) and status (EVIDENCE / CANDIDATE / VALIDATED CANDIDATE / CANONICAL).
```

> [!WARNING]
> Never skip directly from *"Skill X recommends radius 12"* to *"use radius 12."* Every unresolved dimension requires structured dialectic evaluation. Concrete numerical candidates belong in Primitive Pilots, never in the general reasoning doctrine.

---

## 3. Human Perception Domains (Hypothesis Lenses)

Agents must reason using established principles of human perception and cognitive psychology. These principles serve as **research lenses and perceptual hypotheses**, not universal laws; cultural context (Egyptian marketplace), user role, and task intent modulate their application:

1. **Gestalt Organization:** Proximity, similarity, continuity, closure, figure/ground, and common region. How elements group and separate without relying on heavy borders or dividers.
2. **Processing Fluency:** Ease of mental processing. Familiar layout structures and predictable alignments reduce cognitive load during high-stakes booking and payment tasks.
3. **Contour & Curvature Perception:** How sharp vs. rounded contours affect human threat detection, warmth, and approachability in generic perceptual studies.
4. **Angular vs. Rounded Associations:**
   - *Angular / Sharp Geometry:* Research and design literature may associate angular contours with precision, competence, structure, engineering, solidity, and authority. This is a potential perceptual hypothesis; task context, cultural familiarity, and surrounding UI weight may alter or weaken this effect.
   - *Curved / Rounded Geometry:* Literature often associates curved contours with warmth, friendliness, approachability, physical comfort, and human scale. Context and execution modulate this effect, and excessive curvature may introduce distinct trade-offs (e.g. reduced horizontal text real estate or generic-consumer styling).
5. **Warmth vs. Competence Perception:** Balancing hospitality and trust (warmth) with financial rigor, auditability, and escrow safety (competence).
6. **Color Associations & Action Salience:** Evaluating action contrast against white-dominant surfaces, ensuring primary CTAs draw immediate visual attention without introducing decorative noise.
7. **Visual Weight & Salience:** Relative prominence of typography, buttons, and badges based on contrast, mass, and placement.
8. **Symmetry vs. Asymmetry:** Purposeful asymmetry to draw eye gaze to key information versus structural symmetry for operational stability.
9. **Density & Cognitive Load:** High useful information density (showing essential data clearly) versus compression (cramming elements together, causing visual fatigue).
10. **Affordance & Perceived Touchability:** Clear visual indicators that an element can be pressed, swiped, or toggled on mobile touchscreens without relying on hover states.
11. **Familiarity vs. Novelty:** Leveraging existing mental models from iOS/Android and regional applications while maintaining unique KONFRM identity.
12. **Trust Cues & Risk Perception:** Reassuring users at moments of financial commitment (deposit calculation, cancellation terms, bank payout status) through calm, unambiguous UI.
13. **Perceived Control & Complexity:** Giving Owners and Admins direct mastery over operational data without overwhelming cognitive thresholds.
14. **Hospitality vs. Operational Competence:** Customer surfaces balance hospitality warmth with transaction safety; Owner and Admin surfaces balance high density with operational precision.

---

## 4. Role-Specific Reasoning

Every major visual decision must be evaluated through the specific psychological and operational lens of the target role:

### A. Customer Role
- **Core Mental State:** Discovery, comparison, booking anxiety, financial vulnerability.
- **Evaluation Criteria:**
  - What is the likely effect on *confidence* and *perceived safety*?
  - Does this design enhance *hospitality* and *ease of navigation*?
  - Does it clarify the *booking request flow* and prevent transaction hesitation?
  - Does it eliminate cognitive friction when inspecting unit details or pricing breakdowns?

### B. Owner Role
- **Core Mental State:** Asset stewardship, operational speed, financial certainty, calendar management.
- **Evaluation Criteria:**
  - What is the likely effect on *perceived control* and *operational confidence*?
  - Does it facilitate *rapid scanning* of bookings, requests, and calendar dates?
  - Does it deliver *financial certainty* regarding deposit earnings and pending payouts?
  - Does it respect the Owner's time through high information density and clear state indicators?

### C. Admin Role
- **Core Mental State:** Triage efficiency, error prevention, compliance governance, audit defense.
- **Evaluation Criteria:**
  - What is the likely effect on *operational efficiency* and *triage speed*?
  - Does it ensure *auditability* and unmistakable decision logging?
  - Does it convey the *seriousness* of financial and dispute governance?
  - Does it prevent accidental approvals or destructive errors through clear visual hierarchy?

> [!IMPORTANT]
> **User-Research Humility:**
> AI role reasoning is a hypothesis, NOT a substitute for real human users. Never claim: *"Users will feel X"* or *"Egyptian renters prefer Y"* without empirical proof.
> Always formulate statements as:
> `Hypothesis: this may increase perceived X for [Role] because [Reasoning], which can be validated via [Validation Method].`

---

## 5. Brand Congruence Reasoning

The canonical KONFRM brand identity (Founder masters under `DESIGN_SYSTEM/ASSETS/brand/`) features a **strongly geometric, angular, structured character** in its primary symbol and wordmark:

- **Shape Continuity Hypothesis:** A lower / sharper corner-radius family creates visual harmony with the angular brand mark, projecting engineering precision, institutional competence, and structural strength.
- **Warmth / Touchability Counter-Hypothesis:** In Customer-facing contexts, overly sharp contours can appear severe or unapproachable. A moderate or strongly rounded radius family may increase perceived hospitality, comfort, and physical touch affordance.
- **The Core Design Question:**
  *"What degree of shape continuity between KONFRM's angular brand identity and its product controls maximizes brand coherence while preserving warmth, usability, affordance, and platform appropriateness?"*

> [!CAUTION]
> **DO NOT CANONIZE SHAPE FAMILIES PREMATURELY:**
> Neither sharp corners, rounded corners, zero radius, nor pill geometry are canonical. They remain competing implementation hypotheses to be evaluated in Primitive Pilots across specific role contexts. Qualitative descriptors (low/sharper, moderate, strongly rounded) must be used in doctrine; concrete numerical candidates belong strictly in empirical pilot testing.

---

## 6. Color Reasoning

Never apply naive or reductive color associations:
- ❌ *"The logo is black, therefore all buttons must be solid black."*
- ❌ *"Blue signifies trust, therefore all interactive surfaces must be blue."*

Instead, reason through multidimensional factors:
1. **Brand Identity vs. Interaction Role:** Monochrome (Black/White) governs brand identity; restrained blue (`#276EF1` candidate) serves an interaction-accent role.
2. **Action Salience:** High-contrast prominence of the primary action against light surfaces.
3. **Content Photography:** Accommodating vibrant, multi-colored property photography without visual dissonance or competing color noise.
4. **Context & Role:** Customer transactional flow vs. Owner operational dashboard vs. Admin governance table.
5. **State Communication:** Unambiguous distinction between interactive states (default, hover, pressed, disabled) and semantic states (error, success, warning).
6. **Accessibility:** Applicable contrast conformance (such as Web WCAG 2.2 AA baseline for text and essential controls) across color pairings.

Current Canon remains:
- Black/White primary identity.
- Restrained blue interaction role.
- `#276EF1` exact token = **Implementation Candidate**.
- Exact primary CTA color treatment = **Unresolved Candidate** (subject to Primitive Pilots).

---

## 7. The Design Dialectic (Hypothesis A vs. B vs. C)

Before adopting or proposing a major visual direction, formulate a structured dialectic comparing genuinely distinct, credible design hypotheses appropriate to the actual question:

- **Problem-Appropriate Hypotheses:** Formulate 2 to 3 distinct hypotheses tailored to the specific problem. Do not force an artificial third option if only two credible alternatives exist, and do not force a rigid A/B/C taxonomy across dissimilar design challenges.
- **Genuine Trade-offs:** Avoid superficial variations (e.g. changing 1px border without rationale). Each hypothesis must represent a distinct, defensible design philosophy, ergonomic approach, or architectural trade-off.

For each hypothesis, document:
- Strongest argument **FOR** (theoretical, ergonomic, or brand alignment).
- Strongest argument **AGAINST** (risk of severity, cognitive friction, visual noise, or platform mismatch).
- Target-role impact (Customer vs. Owner vs. Admin).
- Brand fit and visual coherence.
- Interaction clarity and affordance.
- Accessibility and platform constraints.
- Supporting evidence and its limitations.

---

## 8. Two-Dimensional Evidence Model: Quality × Relevance

Design decisions must not rely on a simplistic one-dimensional hierarchy that assumes generic academic papers automatically outrank project findings. Agents must evaluate evidence across **TWO independent dimensions**:

```
                  HIGH
                   ▲
                   │   [Cell 2]                      [Cell 1]
                   │   Broad Academic Research       KONFRM In-Situ Usability Test
                   │   (High Rigor, Low Relevance)   (High Rigor, High Relevance)
METHODOLOGICAL     │
QUALITY            │
                   │   [Cell 4]                      [Cell 3]
                   │   Generic AI Heuristic / Blog    Small Qualitative Interview
                   │   (Low Rigor, Low Relevance)    (Low Rigor, High Relevance)
                   │
                  LOW ─────────────────────────────────────────────► HIGH
                                CONTEXTUAL RELEVANCE TO KONFRM
```

### Dimension 1: Methodological Quality / Reliability
- **High Quality:** Peer-reviewed empirical studies, controlled double-blind trials, verified benchmark datasets, large-sample behavioral analytics.
- **Medium Quality:** Established design system patterns (Apple HIG, Google M3, IBM Carbon), formal heuristic evaluations by senior practitioners.
- **Lower Quality / Causal Strength:** Small qualitative interviews (n=3–5), informal designer craft opinions, external skill heuristics, subjective taste.

### Dimension 2: Contextual Relevance to KONFRM
- **High Relevance:** Usability tests, task metrics, and interviews conducted directly with Egyptian property owners, local coastal renters, or KONFRM operational staff on bilingual Arabic/English interfaces.
- **Medium Relevance:** Direct visual inspection of relevant local/regional platforms (e.g. verified Egyptian fintech or real-estate flows) and mobile platform conventions on target hardware.
- **Lower Relevance:** Abstract laboratory studies on generic polygons or neutral geometric objects without transaction risk, payment commitment, or Arabic typography.

### Non-Waivable Constraints vs. Authoritative Platform Guidance
- **Non-Waivable Constraints (Not Trade-Off Evidence):** Applicable statutory legal requirements, the Web accessibility baseline (WCAG 2.2 AA where applicable), and physical hardware touch constraints are non-negotiable minimums.
- **Authoritative Platform Guidance:** Apple Human Interface Guidelines (HIG) and Google Material Design provide authoritative platform guidance and interaction conventions. However, **do not label every platform design recommendation as a universal legal mandate or cross-platform law**. There is no universal raw 44px or 48px cross-platform rule; platform components adapt presentation while preserving semantic hierarchy.

---

## 9. User-Research Humility & Micro-Validation

When an unresolved design decision materially depends on human perception or preference, agents must specify the **smallest useful validation method**:
- **Comparative Prototype:** Side-by-side interactive micro-prototypes comparing Hypothesis A and B on target hardware.
- **5-Second Impression Test:** Testing visual hierarchy, brand perception, and clarity with first-time viewers.
- **Preference + Reasoning Interview:** Structured qualitative interviews probing *why* users prefer a specific treatment.
- **Task-Completion Observation:** Measuring error rates and touch accuracy during a critical task (e.g. booking request submission).
- **Comprehension Test:** Validating that users correctly interpret pricing breakdown, cancellation policy, or calendar state.
- **Device & Accessibility Audit:** Verifying physical touch ergonomics and screen-reader flow on actual physical mobile devices.

Do not recommend expensive, prolonged research for trivial layout adjustments. Reserve formal micro-validation for core Primitive choices.

---

## 10. Standardized Decision Output Block

When evaluating any unresolved major design decision, agents must format the evaluation using this mandatory block:

```markdown
### KONFRM DESIGN REASONING EVALUATION

DESIGN QUESTION:
[Clear, precise statement of the visual or component decision under consideration]

TARGET ROLE:
[Customer | Owner | Admin | Cross-Role Shared System]

KNOWN CANON:
[Authoritative project canon that constrains this decision (e.g. DF2 monochrome identity, restrained blue role)]

HYPOTHESES:
- HYPOTHESIS A: [Description of first credible design direction, e.g. low/sharper radius]
- HYPOTHESIS B: [Description of second credible design direction, e.g. moderate radius]
- HYPOTHESIS C: [Optional third credible design direction, e.g. strongly rounded]

EVIDENCE EVALUATION (Quality × Relevance):
- [Evidence item 1]: Methodological Quality: [HIGH/MED/LOW] | Contextual Relevance: [HIGH/MED/LOW]
  - What the source found: ...
  - Stimulus / population: ...
  - KONFRM inference & transfer risk: ...

STRONGEST CASE FOR EACH:
- HYPOTHESIS A: [Best argument FOR]
- HYPOTHESIS B: [Best argument FOR]
- HYPOTHESIS C: [Best argument FOR]

STRONGEST CASE AGAINST EACH:
- HYPOTHESIS A: [Best argument AGAINST]
- HYPOTHESIS B: [Best argument AGAINST]
- HYPOTHESIS C: [Best argument AGAINST]

HUMAN-PERCEPTION INTERPRETATION:
[Analysis across Gestalt, processing fluency, contour perception, visual salience, and density]

BRAND-CONGRUENCE INTERPRETATION:
[Analysis of alignment with KONFRM's angular, structured brand identity vs. warmth requirements]

PLATFORM/A11Y CONSTRAINTS:
[Applicable Web WCAG baseline, platform touch target conventions, RTL flow, authoritative platform guidance]

UNKNOWNS:
[Assumptions that require real-world validation rather than AI speculation]

VALIDATION PLAN:
[Smallest useful micro-validation method to test the competing hypotheses]

PROVISIONAL DECISION:
[Disciplined recommendation based on evidence and trade-off analysis]

CONFIDENCE:
[LOW | MEDIUM | HIGH]

DECISION STATUS:
[EVIDENCE | CANDIDATE | VALIDATED CANDIDATE | CANONICAL]
```

> [!NOTE]
> Only governance-authorized processes (Founder / Bridge review) may promote a decision status to **CANONICAL**.
