---
name: konfrm-design
description: "Authoritative design interpretation brain for KONFRM. Use for role-specific UX reasoning (Customer, Owner, Admin), visual hierarchy, DF2 design-system consumption, Arabic-first RTL semantics, accessibility presentation requirements, truthful state design, optical review, and design critique. Do not use as the primary skill for Flutter Dart code authoring (use konfrm-flutter), automated test execution or defect RCA (use konfrm-quality), backend implementation, or business rule invention."
---

# KONFRM Design Intelligence Brain (DF2 Interpretation)

```yaml
BRAIN_ID: konfrm-design
VERSION: 1.0.0
LIFECYCLE_STAGE: CONSOLIDATED_DESIGN_AUTHORITY
GOVERNING_SPEC: DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md (DF2 v1.4 / DS v2.1.9)
OWNERSHIP: DESIGN_INTERPRETATION (Define UX Intent, Visual Grammar & Ergonomics)
```

`konfrm-design` is the authoritative design intelligence brain for the KONFRM platform across **Customer Mobile**, **Owner Mobile**, and **Admin Web**. It consolidates visual reasoning, Arabic-first RTL semantics, accessibility design intent, role-specific user experience models, and optical review discipline into a single governed runtime system.

---

## 1. Governing Canon & Authority Hierarchy

All design reasoning and recommendations are strictly governed by the **Canon Subordination Rule**:

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill or library is strictly subordinate to KONFRM Design Canon (DF2 v1.4, monochrome-first brand identity, high useful density, Arabic-first RTL, Western Arabic numerals as default, `#276EF1` candidate interaction role). External skills may inform craftsmanship and ergonomics, but never dictate product taste, business invariants, or brand identity.**

### Epistemic Authority Hierarchy:
1. **Latest explicit Founder decision:** Non-waivable project direction.
2. **Approved Product Truth & Business Canon (`docs/BUSINESS_RULES.md`):** Financial rules, stay bounds, booking request grammar.
3. **Confirmed KONFRM Design Canon (`DESIGN_SYSTEM/`):** Monochrome identity, Arabic RTL foundation.
4. **Applicable Platform & Accessibility Mandates:** WCAG 2.2 AA (Web Admin), platform vendor conventions (HIG / Material 3).
5. **Governed Design Decisions & Provisional Baselines:** Cairo Profile B, Contextual Hierarchy Hybrid, Outline-led fields.
6. **Design Court Evaluated Recommendations:** Internal dialectic consensus and advisory verdicts.
7. **External Skill & Reference Heuristics:** Subordinate input signals (inform, never dictate).

---

## 2. Single Definition Ownership (Define / Implement / Verify)

To prevent duplication and authority confusion across agents, responsibilities are partitioned strictly:

```text
+-----------------------+---------------------+-----------------------+
| DEFINE                | IMPLEMENT           | VERIFY                |
| (konfrm-design)       | (konfrm-flutter)    | (konfrm-quality)      |
+-----------------------+---------------------+-----------------------+
| Visual hierarchy      | Flutter widgets     | Defect RCA            |
| Role mental models    | State management    | Test execution        |
| RTL layout semantics  | Native bindings     | Static analysis       |
| A11y design intent    | Platform channels   | A11y tree audits      |
| Truthful state UI     | Build mechanics     | Physical device proof |
+-----------------------+---------------------+-----------------------+
```

---

## 3. Decision Status Bands (Three Status Bands)

Every design token, dimension, and rule is categorized into one of three explicit status bands:

1. **PUBLISHED GOVERNED PROVISIONAL (Settled Baseline Directions — Do NOT Treat as Open; Do NOT Promote to Final Native Canon without Physical Evidence):**
   - **Typography:** Cairo Profile B scale and vertical metrics (`SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY`).
   - **Primary CTA Color:** `#000000` exact Mobile Primary Black (`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`).
   - **Primary Button Radius:** `6px` (`PRIMARY_ONLY` provisional; secondary button radius remains open).
   - **Action Strategy:** Contextual Hierarchy Hybrid (`SYSTEM-VALIDATED PROVISIONAL ACTION STRATEGY`).
   - **Field Strategy:** Outline-Led field baseline with white field surface on light-first surfaces.
   - **Mobile Field Control Radius:** `8px` (deliberate semantic differentiation from 6px Primary CTA).
   - **Focus Semantic Direction:** Restrained Interaction-Accent Emphasis (1px accent field border + 3px outer halo in web reference).
   - **Structural System Model:** Role-Aware Hybrid (Customer uses `OPEN_EDITORIAL_DEFAULT` unboxed facts; Owner uses `ROLE-AWARE OPERATIONAL_GROUPING` outer container with subtle dividers; Admin desktop table workspace).
   - **Structural Container Radius:** `12px` (distinct from 6px action button and 8px field control).
   - **Mobile Content Insets:** `16px` candidate page insets.
   - **Spacing Relational Hierarchy:** `TIER_1 < TIER_2 < TIER_3 < TIER_4` mapped to `4 / 8 / 12 / 16 / 24 / 32`.

2. **OPEN VARIABLES (Genuinely Unresolved Candidates / Implementation Candidates):**
   - **Exact Blue Accent:** `#276EF1` candidate token remains open.
   - **Exact Neutrals:** Palette tokens remain implementation candidates.
   - **Native Focus & Halo Metrics:** Assistive/system focus metrics remain open / deferred.
   - **Native Stroke Widths:** Border tokenization remains open / deferred.
   - **Secondary Button Radius:** Remains open / undecided.
   - **Badge & Indicator Geometry:** Component-governed.

3. **DEFERRED TO PHYSICAL ACCEPTANCE:**
   - All mobile candidates require empirical Flutter device rendering, performance, and accessibility acceptance on real physical hardware before permanent Canon promotion.

---

## 4. Lazy-Loaded Companion References

Agents must load only the companion reference module required by the specific active task:

```text
.agents/skills/konfrm-design/
├── SKILL.md                          <- Root doctrine, authority hierarchy, status bands
└── references/
    ├── role_experience.md            <- Customer, Owner, Admin mental models, jobs, layout models
    ├── visual_system.md              <- Brand identity, tokens, spacing tiers, anti-generic SaaS
    ├── rtl_content.md                <- Arabic-first UX, directional semantics, Western digits, money
    ├── accessibility_design.md       <- Contrast, touch targets, screen reader labels, text scaling
    ├── states_interactions.md        <- Applicable states, action hierarchy, truthful state grammar
    └── visual_review.md              <- Optical checklists, viewport matrix, design reasoning, Court
```

- When evaluating **role journeys or layout models** -> `references/role_experience.md`
- When determining **visual tokens, spacing, typography, or styling** -> `references/visual_system.md`
- When reviewing **Arabic typography, RTL alignment, or currency** -> `references/rtl_content.md`
- When defining **accessible contrast, touch hit regions, or screen reader intent** -> `references/accessibility_design.md`
- When structuring **component states, empty/error screens, or action buttons** -> `references/states_interactions.md`
- When inspecting **visual artifacts, candidate viewports, or escalating open decisions** -> `references/visual_review.md`

---

## 5. Negative Routing Rules

1. **Flutter Implementation:** When asked to write Flutter widget code, Dart layouts, Riverpod providers, or `EdgeInsetsDirectional`, activate `konfrm-flutter`.
2. **Defect RCA & Testing:** When diagnosing unexpected behavior, broken layouts, TalkBack announcement bugs, or running test suites, activate `konfrm-quality`.
3. **Business Rule Definition:** Do NOT invent financial formulas, cancellation terms, commission splits, or stay limits. Retrieve them from `docs/BUSINESS_RULES.md` via `.agents/CONTEXT_MAP.yaml`.
