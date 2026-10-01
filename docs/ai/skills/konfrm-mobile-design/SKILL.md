---
name: konfrm-mobile-design
description: "Authoritative mobile design interpretation and safety standards for KONFRM. Implements DF2 v1.1 foundations, monochrome-first brand identity, restrained interaction-accent role, platform adaptation, and useful density without inventing unapproved numeric Canon."
---

# KONFRM Mobile Design Authority (DF2 v1.1 Interpretation)

Authoritative mobile design guidelines for future KONFRM Customer and Owner Flutter applications (`mobile/customer_app`, `mobile/owner_app`) under DF2 v1.1.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Brand Identity & Visual Language (Canonical Principles)

- **Monochrome-First Brand Identity:**
  - The canonical brand identity direction is solid Black and White.
  - Primary canonical symbol: `DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-black.svg` on light surfaces.
  - Inverse canonical symbol: `DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-white.svg` on dark surfaces.
  - Summer Yellow is permanently REMOVED from the core mobile brand architecture.
- **Identity vs. Interaction Separation:**
  - Brand identity (Black/White) and interaction accent are intentionally separated.
  - A **restrained blue interaction-accent role** is canonical, while the specific token value `#276EF1` remains an **IMPLEMENTATION CANDIDATE**.
  - Blue is an interaction accent role, NEVER the primary brand logo artwork.
- **Important Action Treatment Discipline:**
  - Black/White brand identity does **NOT** mean "every primary action button is canonically black."
  - The exact visual treatment of primary actions (solid black vs. blue interaction role vs. outlined) is an **open candidate question** to be evaluated in component contexts during Primitive Pilots.
  - Skills must not pre-answer or freeze this decision.
- **Light-First Dominant Intent:**
  - Light-first product intent is canonical: white and light neutral surfaces dominate.
  - Dark navy/slate slabs, high-contrast dark cards, and glassmorphism are not normal product surfaces.
  - Exact neutral and surface token values remain implementation candidates.

---

## 2. Platform Adaptation (HIG / Material 3 Conventions)

KONFRM adapts presentation to native mobile platforms while preserving core meaning and action hierarchy:

- **Apple HIG Adaptation:**
  - Respect iOS navigation patterns (Large Title collapsing on scroll, edge swipe back gesture mirrored for RTL).
  - Platform-appropriate sheets, dialogs, and navigation transitions.
  - Haptic feedback candidates: purposeful tactile confirmation on key state changes; exact haptic patterns require device testing.
- **Android / Material 3 Adaptation:**
  - Respect Android system back handling (`PopScope` / predictive back).
  - Platform-appropriate elevation, touch ripples, and edge-to-edge system navigation.
  - Avoid literal web button ports; utilize native interaction ergonomics.

---

## 3. Subordinating External Numeric Heuristics

External UI skills frequently assert rigid universal numbers (e.g., universal 44×44px touch target, universal 16px body text, 8px padding). Under KONFRM Canon, these are strictly subordinate:

1. **Touch Target Dimensions:**
   - Universal external rules (e.g. 44px) are subordinate to platform-specific conventions (Apple HIG ~44pt, Android Material ~48dp).
   - High-density operational controls (chips, compact steppers) must balance touch comfort with operational density on real devices.
   - Exact mobile target dimensions remain subject to Primitive and Component validation work (§29).
2. **Typography & Layout Dimensions:**
   - Exact type scales, line-height multipliers, corner radii, borders, and elevation values are **candidates**, not pre-approved numbers.
   - Cairo is an **implementation candidate** pending real mobile device rendering and performance validation (§27.7).
   - The 8pt-derived spacing scale is strong implementation evidence from Web, but requires mobile validation before canonicalization.

---

## 4. Semantic Action Hierarchy

Every surface must declare its action hierarchy unambiguously (§15):
- **Primary Action:** The single most important forward action on the surface.
- **Secondary Action:** Important alternative or supporting actions.
- **Tertiary Action:** Subtle, text-based, or low-prominence actions.
- **Contextual Actions:** Inline actions scoped to specific cards or list items.
- **Destructive Action:** Critical irreversible operations requiring distinct visual caution.

Exact colors, dimensions, and radii for these roles are defined in component contracts, not hardcoded globally in this skill.
