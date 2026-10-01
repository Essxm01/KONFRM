---
name: konfrm-design-router
description: "Master design triage router for KONFRM. Classifies tasks by role (Customer/Owner/Admin), surface reality (Current React/Web vs Future Native Mobile Flutter Target), and task type. Activates the minimal necessary skill set, enforces Canon Subordination, and mandates the standardized KONFRM Design Skill Usage Report."
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
   - **Role:** Customer, Owner, Admin, or Shared Design System.
   - **Surface Reality:**
     - **Current Web Implementation:** `customer-app/` (React SPA), `owner-app/` (React SPA), `admin-app/` (React SPA).
     - **Future Native Mobile Target:** Future Flutter/Dart applications governed by DF2 v1.1 (`mobile/customer_app`, `mobile/owner_app` — topology not yet initialized).
   - **Task Type:** UX Architecture, Visual Design, Micro-Polish, Accessibility Audit, Visual QA, or Code Structure.
2. **Minimal Skill Activation:** Select ONLY the specific internal and wrapped external skills relevant to the task. Suppress unneeded or conflicting tools.
3. **Pre-flight Conflict Resolution:** Detect potential conflicts between external advice and KONFRM Design Canon before work begins, ensuring Canon wins unconditionally.
4. **Standardized Reporting Enforcement:** Require the standardized `KONFRM DESIGN SKILL USAGE REPORT` block on completion.

---

## 2. Request Classification & Routing Matrix

| Surface Reality | Codebase Location | Current Architecture | Applicable Internal Skills | Approved External Wrappers |
|---|---|---|---|---|
| **Current Customer Web** | `customer-app/` | React / Vite / Tailwind | `konfrm-product-ux`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `ui-ux-pro-max-wrapper` (advisory), `impeccable-wrapper` (polish/critique) |
| **Current Owner Web** | `owner-app/` | React / Vite / Tailwind | `konfrm-product-ux`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `ui-ux-pro-max-wrapper` (advisory), `impeccable-wrapper` (polish/critique/distill) |
| **Current Admin Web** | `admin-app/` | React / Vite / Tailwind | `konfrm-product-ux`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `vercel-web-guidelines-wrapper`, `vercel-composition-wrapper`, `impeccable-wrapper` (distill/quieter) |
| **Future Mobile Target** | Future `mobile/` boundary (uninitialized) | Flutter / Dart (DF2 v1.1) | `konfrm-product-ux`, `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility`, `konfrm-visual-qa` | `ui-ux-pro-max-wrapper` (advisory search only), `impeccable-wrapper` (polish/critique), `emil-wrapper` (tactile/gesture candidates) |
| **Design System Authority** | `DESIGN_SYSTEM/` | Semantic Tokens & Specs | `konfrm-mobile-design`, `konfrm-rtl-arabic`, `konfrm-accessibility` | `impeccable-wrapper` (audit), `ui-ux-pro-max-wrapper` (advisory style search) |

> [!WARNING]
> **CRITICAL REPOSITORY MAPPING RULE:**
> Existing `customer-app/` and `owner-app/` directories are **React/Web implementations**, NOT Flutter apps. Never silently route existing `customer-app/` source as Flutter. When reviewing current React applications, React composition and web guidelines are applicable; when architecting future Flutter surfaces, web-only wrappers are strictly prohibited.

---

## 3. Skill Suppression & Rejection Rules

When routing, the following skills MUST be actively suppressed or rejected:
- **`sleek-design-mobile-apps`**: REJECT. External network service requiring credentials; transmits prompts/design context; excluded from default KONFRM routing.
- **`high-end-visual-design`**: REJECT. Enforces low-density luxury agency spacing and dark slabs directly contrary to KONFRM's high useful density.
- **`vercel-web-guidelines` / `vercel-composition-patterns`**: PROHIBITED from governing future Flutter-native architecture. Confined strictly to React/Web codebases (`admin-app/`, current `customer-app/`, current `owner-app/`).
- **`impeccable/bolder` & `impeccable/delight`**: SUPPRESS by default on all transactional flows (booking, checkout, payouts, verification). Requires explicit Founder authorization.
- **`extract-design-system` / `canvas-design` / `design-taste-frontend`**: SUPPRESS from automated product routing. Manual sandbox exploration only.

---

## 4. Canon vs. Candidate Pre-Flight Discipline

Before reviewing or producing design work, enforce the decision boundaries established in DF2 (§26–§28):

1. **What is CANONICAL NOW:**
   - Monochrome-first brand identity (Solid Black/White).
   - Restrained blue interaction-accent **role** (separate from identity).
   - Light-first dominant surfaces.
   - Arabic-first RTL native layout with logical start/end and Western Arabic numerals (`0-9`).
   - Truthful state grammar (ERROR ≠ EMPTY, STALE ≠ ERROR, PENDING ≠ SUCCESS, MISSING ≠ ZERO).
   - Action hierarchy (Primary, Secondary, Tertiary, Contextual, Destructive).
   - Platform adaptation (preserve meaning/hierarchy, adapt presentation).
   - High useful density over decorative whitespace.
2. **What is an IMPLEMENTATION CANDIDATE (Do NOT promote to Canon):**
   - Exact primary CTA color treatment (whether black, blue, or other treatment — to be resolved by Primitive Pilots).
   - Preferred interaction accent value (`#276EF1`).
   - Exact neutral/ink token values (no UI-black invented in DF2).
   - Exact typography scale and line-heights.
   - Cairo as the bundled mobile UI font family (strong candidate pending mobile rendering validation).
   - Exact spacing scale, corner radii, borders, shadows, and control dimensions.
   - Exact motion durations, easing curves, and spring constants.
   - Exact platform component mappings.

---

## 5. Standardized Output Enforcement

Every design/UI task executed under KONFRM must culminate in the standardized usage block:

```markdown
### KONFRM DESIGN SKILL USAGE REPORT
- DESIGN_SKILLS_USED: [skills utilized with version/source]
- DESIGN_SKILLS_NOT_USED: [skills considered and excluded, with specific rationale]
- CANON_CONFLICTS: [conflicts detected and explicit resolution per KONFRM Canon]
- EVIDENCE_VS_CANON: [advisory search/inspiration inputs vs authoritative canonical decisions]
- VISUAL_QA: [tested viewports or explicit NOT EXECUTED statement if simulation/routing only]
```
