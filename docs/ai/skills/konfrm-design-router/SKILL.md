---
name: konfrm-design-router
description: "Master design triage router for KONFRM. Classifies tasks by role (Customer/Owner/Admin), platform (Mobile Flutter/Web React), and task type. Activates the minimal necessary skill set, enforces Canon Subordination, and mandates the standardized KONFRM Design Skill Usage Report."
---

# KONFRM Design Router

The Master Design Triage Layer for the KONFRM platform across all AI agents (Codex, Antigravity, ZCode).

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Responsibilities

1. **Request Classification:** Automatically classify every incoming design/UI request by:
   - **Role:** Customer, Owner, Admin, or Cross-role Platform.
   - **Platform:** Mobile (Flutter / Dart), Web (React / TypeScript / Tailwind), or Shared Design Tokens.
   - **Task Type:** UX Architecture, Visual Design, Micro-Polish, Accessibility Audit, Visual QA, or Code Refactor.
2. **Minimal Skill Activation:** Select ONLY the specific internal and wrapped external skills relevant to the task. Suppress unneeded or conflicting tools.
3. **Pre-flight Conflict Resolution:** Detect potential conflicts between external advice and KONFRM Design Canon before code is written, ensuring Canon wins unconditionally.
4. **Standardized Reporting Enforcement:** Require the standardized `KONFRM DESIGN SKILL USAGE REPORT` block on completion.

---

## 2. Request Classification Matrix

| Role | Primary Target App | Primary Technology | Core Operational Goal | Primary Activated Internal Skills | Approved External Wrappers |
|------|--------------------|--------------------|-----------------------|-----------------------------------|----------------------------|
| **Customer** | `customer-app/` | Flutter / Dart | Friction-free property discovery, transparent pricing, instant booking clarity, zero fake scarcity. | `konfrm-product-ux`, `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `ui-ux-pro-max-wrapper` (advisory search only), `impeccable-wrapper` (polish/critique), `emil-wrapper` (tactile gestures) |
| **Owner** | `owner-app/` | Flutter / Dart | Operational certainty, payout transparency, dispute tracking, calendar control, high density. | `konfrm-product-ux`, `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `ui-ux-pro-max-wrapper` (advisory), `impeccable-wrapper` (polish/critique/distill), `emil-wrapper` (transitions) |
| **Admin** | `admin-app/` | React / Vite / Tailwind | Auditability, fast high-density triage, batch verification, zero decorative fluff, desktop ergonomics. | `konfrm-product-ux`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `impeccable-wrapper` (distill/quieter) |
| **Design System** | `DESIGN_SYSTEM/` | Tokens (JSON) / Components | Authority maintenance, token generation, accessibility contracts, drift prevention. | `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility` | `impeccable-wrapper` (audit), `ui-ux-pro-max-wrapper` (advisory style search) |

---

## 3. Skill Suppression & Rejection Rules

When routing, the following skills MUST be actively suppressed or rejected:
- **`sleek-design-mobile-apps`**: REJECT. Requires paid third-party API key and leaks source code externally.
- **`high-end-visual-design`**: REJECT. Enforces low-density luxury agency spacing and dark slabs directly contrary to KONFRM's high useful density.
- **`vercel-web-guidelines` / `vercel-composition-patterns`**: SUPPRESS for all Mobile/Flutter tasks. Confined exclusively to `admin-app/`.
- **`impeccable/bolder` & `impeccable/delight`**: SUPPRESS by default on all transactional flows (booking, checkout, payouts, verification). Requires explicit Founder/Spec permission.
- **`extract-design-system` / `canvas-design` / `design-taste-frontend`**: SUPPRESS from automated product routing. Manual sandbox exploration only.

---

## 4. Conflict Resolution Pre-flight Check

Before executing design or UI code, check for and resolve the following canonical boundaries:

1. **Touch Target Sizing:**
   - *External rule:* Universal 44×44px or 48×48px.
   - *KONFRM Canon:* 48×48dp for primary interactive actions; 36–40dp acceptable for secondary/dense controls with adequate touch padding. Platform-appropriate, not universal 44px.
2. **Color Palette & Brand Identity:**
   - *External rule:* Blue primary brand buttons, colorful accents, or dark luxury slabs.
   - *KONFRM Canon:* Monochrome-first Black/White core brand identity. Yellow is removed from core brand. White/light-first surfaces. `#276EF1` is a restrained candidate interaction role, never primary brand artwork.
3. **Typography & Layout Direction:**
   - *External rule:* LTR defaults, system fonts (Inter, Roboto), Eastern Arabic numerals (٠-٩).
   - *KONFRM Canon:* Cairo font, Arabic-first RTL native layout, Western Arabic numerals (`0-9`, e.g. `1,600 ج.م`), directional mirroring.
4. **Information Density:**
   - *External rule:* Expansive whitespace, oversized cards, low-density marketing padding.
   - *KONFRM Canon:* High useful density, operational clarity, truthful state grammar.

---

## 5. Standardized Output Enforcement

Every design/UI task executed under KONFRM must culminate in the standardized usage block:

```markdown
### KONFRM DESIGN SKILL USAGE REPORT
- DESIGN_SKILLS_USED: [skills utilized with version/source]
- DESIGN_SKILLS_NOT_USED: [skills considered and excluded, with specific rationale]
- CANON_CONFLICTS: [conflicts detected and explicit resolution per KONFRM Canon]
- EVIDENCE_VS_CANON: [advisory search/inspiration inputs vs authoritative canonical decisions]
- VISUAL_QA: [tested viewports (360/390/430), component states, RTL mirror verification]
```
