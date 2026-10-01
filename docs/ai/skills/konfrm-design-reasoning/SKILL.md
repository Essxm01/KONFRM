---
name: konfrm-design-reasoning
description: "Human-centered design reasoning and perceptual decision layer for KONFRM. Sits between Canon and visual choices, running structured design dialectics (Hypotheses A/B/C), evaluating perception/Gestalt/brand congruence, role lenses, and recommending micro-validations."
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

## 1. The Required Decision Loop

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
  └── Gather empirical evidence (Levels A–G) across human factors, cognitive psychology, and mature systems.
ROLE LENS
  └── Filter through the specific cognitive and emotional needs of Customer, Owner, or Admin.
BRAND CONGRUENCE
  └── Analyze alignment with the geometric, structured KONFRM brand identity.
PLATFORM / ACCESSIBILITY CHECK
  └── Validate against WCAG, touch targets, platform conventions, and RTL dynamics.
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
> Never skip directly from *"Skill X recommends radius 12"* to *"use radius 12."* Every unresolved dimension requires structured dialectic evaluation.

---

## 2. Human Perception Domains

Agents must actively reason using established principles of human perception and cognitive psychology. These principles serve as **research lenses**, not universal laws; cultural context (Egyptian marketplace), user role, and task intent modulate their application:

1. **Gestalt Organization:** Proximity, similarity, continuity, closure, figure/ground, and common region. How elements group and separate without relying on heavy borders or dividers.
2. **Processing Fluency:** Ease of mental processing. Familiar layout structures and predictable alignments reduce cognitive load during high-stakes booking and payment tasks.
3. **Contour & Curvature Perception:** How sharp vs. rounded contours affect human threat detection, warmth, and approachability.
4. **Angular vs. Rounded Associations:**
   - *Angular / Sharp Geometry:* Associated with precision, competence, structure, engineering, solidity, and authority.
   - *Curved / Rounded Geometry:* Associated with warmth, friendliness, approachability, physical comfort, and human scale.
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

## 3. Role-Specific Reasoning

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

## 4. Brand Congruence Reasoning

The canonical KONFRM brand identity (Founder masters under `DESIGN_SYSTEM/ASSETS/brand/`) features a **strongly geometric, angular, structured character** in its primary symbol and wordmark:

- **Shape Continuity Hypothesis:** A lower, sharper corner-radius family (e.g., subtle 4px–8px radii) creates strong visual harmony with the angular brand mark, projecting engineering precision, institutional competence, and structural strength.
- **Warmth / Touchability Counter-Hypothesis:** In Customer-facing contexts, overly sharp contours can appear severe or unapproachable. More pronounced corner rounding (e.g., 10px–16px radii) may increase perceived hospitality, comfort, and physical touch affordance.
- **The Core Design Question:**
  *"What degree of shape continuity between KONFRM's angular brand identity and its product controls maximizes brand coherence while preserving warmth, usability, affordance, and platform appropriateness?"*

> [!CAUTION]
> **DO NOT CANONIZE SHAPE FAMILIES PREMATURELY:**
> Neither sharp corners, rounded corners, zero radius, nor pill geometry are canonical. They remain competing implementation hypotheses to be evaluated in Primitive Pilots across specific role contexts.

---

## 5. Color Reasoning

Never apply naive or reductive color associations:
- ❌ *"The logo is black, therefore all buttons must be solid black."*
- ❌ *"Blue signifies trust, therefore all interactive surfaces must be blue."*

Instead, reason through multidimensional factors:
1. **Brand Identity vs. Interaction Role:** Monochrome (Black/White) governs brand identity; restrained blue (`#276EF1` candidate) serves an interaction-accent role.
2. **Action Salience:** High-contrast prominence of the primary action against light surfaces.
3. **Content Photography:** Accommodating vibrant, multi-colored property photography without visual dissonance or competing color noise.
4. **Context & Role:** Customer transactional flow vs. Owner operational dashboard vs. Admin governance table.
5. **State Communication:** Unambiguous distinction between interactive states (default, hover, pressed, disabled) and semantic states (error, success, warning).
6. **Accessibility:** Strict contrast compliance (WCAG AA/AAA) across all color pairings.

Current Canon remains:
- Black/White primary identity.
- Restrained blue interaction role.
- `#276EF1` exact token = **Implementation Candidate**.
- Exact primary CTA color treatment = **Unresolved Candidate** (subject to Primitive Pilots).

---

## 6. The Design Dialectic (Hypothesis A vs. B vs. C)

Before adopting or proposing a major visual direction, formulate a structured dialectic comparing competing hypotheses:

1. **Hypothesis A:** The conservative or brand-congruent hypothesis (e.g. structured, low-radius, monochrome-dominant).
2. **Hypothesis B:** The ergonomic or platform-native hypothesis (e.g. moderate rounding, platform-standard conventions).
3. **Hypothesis C (Optional):** The expressive or warmth-optimized hypothesis (e.g. higher rounding, softer visual texture).

For each hypothesis, document:
- Strongest argument **FOR** (theoretical, ergonomic, or brand alignment).
- Strongest argument **AGAINST** (risk of severity, generic-AI aesthetic, touch ambiguity, or platform friction).
- Target-role impact (Customer vs. Owner vs. Admin).
- Brand fit and visual coherence.
- Interaction clarity and affordance.
- Accessibility and platform constraints.
- Supporting evidence and its limitations.

---

## 7. Evidence Quality Hierarchy

When supporting a design hypothesis, agents must grade evidence by authoritative strength:

| Level | Evidence Category | Description & Authority |
|---|---|---|
| **LEVEL A** | Legal / A11y / Platform Constraints | Mandatory platform human interface guidelines (iOS HIG, Android Material), WCAG 2.1 AA/AAA contrast ratios, legal requirements. Non-waivable. |
| **LEVEL B** | Peer-Reviewed Human Factors & Perception | Published cognitive psychology, Gestalt visual perception research, ergonomic biomechanics, and consumer behavior studies. |
| **LEVEL C** | Established Design-System Evidence | Empirical patterns from mature, battle-tested design systems (Apple HIG, Google Material Design 3, IBM Carbon, Uber Base). |
| **LEVEL D** | KONFRM User Research & Behavioral Data | Qualitative interviews, task completion metrics, usability tests, and analytics gathered directly from KONFRM users. |
| **LEVEL E** | Competitive & Reference Products | Benchmarking leading regional and global platforms (Airbnb, Booking.com, Bayut, Uber). Informative but not decisive. |
| **LEVEL F** | External Skill Heuristic / Craft Opinion | Heuristics and playbooks from external skills (Frontend Design, Impeccable, UI/UX Pro Max). Useful guidance, but subordinate to Canon. |
| **LEVEL G** | Pure Aesthetic Preference | Subjective designer intuition, personal taste, or generic AI default styling. Lowest authority; never justifies overriding higher levels. |

---

## 8. User-Research Humility & Micro-Validation

When an unresolved design decision materially depends on human perception or preference, agents must specify the **smallest useful validation method**:
- **Comparative Prototype:** Side-by-side interactive micro-prototypes comparing Hypothesis A and B on target hardware.
- **5-Second Impression Test:** Testing visual hierarchy, brand perception, and clarity with first-time viewers.
- **Preference + Reasoning Interview:** Structured qualitative interviews probing *why* users prefer a specific treatment.
- **Task-Completion Observation:** Measuring error rates and touch accuracy during a critical task (e.g. booking request submission).
- **Comprehension Test:** Validating that users correctly interpret pricing breakdown, cancellation policy, or calendar state.
- **Device & Accessibility Audit:** Verifying physical touch ergonomics and screen-reader flow on actual physical mobile devices.

Do not recommend expensive, prolonged research for trivial layout adjustments. Reserve formal micro-validation for core Primitive choices.

---

## 9. Standardized Decision Output Block

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
- HYPOTHESIS A: [Description of first credible design direction]
- HYPOTHESIS B: [Description of second credible design direction]
- HYPOTHESIS C: [Optional third credible design direction]

EVIDENCE:
- [Cited evidence items categorized by Level A through Level G]

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
[WCAG contrast, touch target dimensions, RTL flow, platform conventions]

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
