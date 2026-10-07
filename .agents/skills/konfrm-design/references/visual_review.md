# Optical Review, Design Dialectics & Governed Escalation

```yaml
MODULE: visual_review.md
BRAIN: konfrm-design
AUTHORITY: DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md §29 + docs/ai/skills/konfrm-design-court/
```

This reference defines optical inspection checklists, candidate device viewports, the structured human-centered design dialectic loop, and the Design Court escalation protocol for unresolved decisions.

---

## 1. Optical Review Checklist ("What Good and Wrong Look Like")

> [!CAUTION]
> ### CORE TENET: CI GREEN != VISUAL QA PASSED
> Passing unit tests, analyzers, and linters do NOT verify optical alignment, font clipping, RTL chevron direction, or contrast. Every UI change requires explicit visual verification.

### Optical Verification Checklist:
- [ ] **Back Navigation:** Back button chevron points RIGHT (→).
- [ ] **Forward Drill-Down:** Disclosure chevron points LEFT (←).
- [ ] **Start-Side Icons:** Leading icons, avatars, and property thumbnails sit at the logical start (RIGHT) of Arabic text.
- [ ] **End-Side Badges:** Trailing status indicators, dates, and badges sit at the logical end (LEFT).
- [ ] **Arabic Diacritics:** Text ascenders and descenders do not clip against container bounds.
- [ ] **Currency Formatting:** Monetary amounts render as `1,600 ج.م` using Western Arabic numerals (`0-9`).
- [ ] **Bidi Isolation:** Phone numbers, booking codes (`#KNF-88219`), and IBANs flow strictly LTR inside RTL text.
- [ ] **Action Hierarchy:** Primary CTA clearly dominates with provisional baseline `#000000` and candidate `6px` radius.
- [ ] **Form Controls:** Fields adhere to outline-led styling with candidate `8px` radius.
- [ ] **Structural Containers:** Grouped operational cards adhere to candidate `12px` radius; no "card soup".
- [ ] **Truthful States:** Failed network reads show an error with retry CTA; zero metrics never mask a fetch failure.

---

## 2. Candidate Viewport Matrix (Initial QA Reference)

Viewports must be selected based on surface, responsive risk, and task scope (not blindly executed across all viewports on every minor change):

### A. Mobile Viewports:
- **Compact Android Baseline (`360 × 800`):** Inspect for horizontal button clipping, chip wrapping, and software navigation bar collisions.
- **Standard iPhone Baseline (`390 × 844`):** Inspect safe area insets (Dynamic Island / notch, bottom home indicator) and standard reading hierarchy.
- **Large Flagship Baseline (`430 × 932`):** Inspect for excessive card stretching, unconstrained whitespace expansion, and max-width bounds.

### B. Desktop Web Viewports (`admin-app/`):
- **Desktop Operational Workspace (`1440 × 900`):** Full multi-column table view, sidebar navigation, and audit detail panes.
- **Compact Laptop Baseline (`1280 × 800`):** Table horizontal scrolling, responsive grid collapse.

---

## 3. Structured Design Reasoning (The Dialectic Loop)

For any meaningful, unresolved visual design choice, agents execute the structured dialectic loop:

```text
OBSERVE          -> Identify surface, active role, screen job, and specific visual question.
HYPOTHESIZE      -> Formulate 2–3 distinct, credible design hypotheses (Option A, B, C).
ARGUE            -> Present strongest arguments FOR and AGAINST each option.
RESEARCH         -> Evaluate evidence (Methodological Quality × Contextual Relevance).
ROLE LENS        -> Filter through specific Customer, Owner, or Admin cognitive needs.
BRAND            -> Evaluate alignment with monochrome-first, high useful density identity.
A11Y / PLATFORM  -> Verify against mandatory constraints (WCAG 2.2 AA) and adaptable platform recommendations (Apple HIG / Material 3).
DECISION         -> Synthesize findings into a provisional recommendation with confidence rating.
```

### Research Claim Hygiene:
Never extrapolate generic laboratory psychology studies into absolute product laws. Always distinguish:
1. What the study literally found.
2. The tested population and stimuli (e.g. 2D neutral polygons in laboratory conditions).
3. What KONFRM specifically infers for rental UI.
4. Known transfer risks and limitations.
5. What requires empirical device validation on KONFRM prototypes.

---

## 4. Governed Design Court Escalation Protocol

When a design decision is **materially ambiguous** and involves conflicting architectural principles, agents escalate via the Design Court protocol (an advisory adjudication panel that cannot create or promote Canon):

### A. COURT_NOT_REQUIRED (Fast Path):
Bypass Court for:
- Routine copy/typo fixes
- Obvious RTL mirroring bugs (e.g. unmirrored chevron)
- Known accessibility fixes with established solutions
- Already-governed visual rules with no material ambiguity

### B. Escalation Modes:
- **`FAST_PANEL` (Default):** Bounded ambiguous choices (e.g. candidate radius A vs B, field halo treatment, secondary action styling). 3–5 specialists + persona lenses + challenger + verdict.
- **`FULL_COURT`:** Major primitive systems, navigation architecture, or cross-role paradigm shifts.

### C. Hard Gates (Popularity Cannot Override):
Before scoring, immediately eliminate any proposal that violates:
- `BUSINESS_CANON`
- `PRODUCT_TRUTH`
- `FINANCIAL_RULE`
- `SECURITY_CONSTRAINT`
- `APPLICABLE_ACCESSIBILITY_REQUIREMENT`
- `RTL_CORRECTNESS`
- `ARCHITECTURE_BOUNDARY`

A proposal that violates a Hard Gate is marked `BLOCKED_BY_CANON`, regardless of majority preference.

### D. Consensus Classifications:
`UNANIMOUS_PANEL_RECOMMENDATION`, `STRONG_MAJORITY`, `SPLIT_PANEL`, `MINORITY_DISSENT`, `BLOCKED_BY_CANON`, `NEEDS_VISUAL_EVIDENCE`. Note: All verdicts are advisory recommendations to the Founder/Engineer; the Court has zero authority to promote proposals to Canon.
