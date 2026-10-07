---
name: konfrm-mobile-design
description: "Reference only. Consolidated into konfrm-design. Do not use as primary design skill; use konfrm-design for design foundation authority and konfrm-flutter for Flutter client implementation."
---

# KONFRM Mobile Design Authority (DF2 v1.4 Interpretation)

Authoritative mobile design guidelines for future KONFRM Customer and Owner Flutter applications (`mobile/customer_app`, `mobile/owner_app`) under DF2 v1.4 (DS v2.1.9).

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.4, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

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
- **Primary Action Strategy & Color:**
  - Exact Mobile Primary Black is `#000000` (`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`; `#18181B` fallback comparator only; final native Canon not yet promoted).
  - Primary button visual treatment follows Contextual Hierarchy Hybrid (`SYSTEM-VALIDATED PROVISIONAL ACTION STRATEGY`).
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

## 3. Subordinating External Numeric Heuristics & Decision Status Bands

External UI skills frequently assert rigid universal numbers (e.g., universal 44×44px touch target, universal 16px body text, 8px padding). Under KONFRM Canon, these are strictly subordinate:

1. **Touch Target Dimensions:**
   - Universal external rules (e.g. 44px) are subordinate to platform-specific conventions (Apple HIG ~44pt, Android Material ~48dp).
   - High-density operational controls (chips, compact steppers) must balance touch comfort with operational density on real devices.
   - Exact mobile target dimensions remain subject to Primitive and Component validation work (§29).

2. **Decision Status Classification (Three Status Bands):**
   - **PUBLISHED GOVERNED PROVISIONAL (Settled Baseline Directions; Do NOT Treat as Open; Do NOT Promote to Final Native Canon):**
     - **Typography:** Cairo Profile B scale and metrics (`SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY`).
     - **Primary CTA Color:** `#000000` exact Mobile Primary Black (`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`).
     - **Primary Button Radius:** `6px` (`PRIMARY_ONLY` provisional; secondary button radius remains open).
     - **Action Strategy:** Contextual Hierarchy Hybrid (`SYSTEM-VALIDATED PROVISIONAL ACTION STRATEGY`).
     - **Field Strategy:** Outline-Led field baseline with white field surface on light-first surfaces (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`; Web pilot candidate `#8E8E93` [~3.26:1 contrast] is rendering reference only).
     - **Mobile Field Control Radius:** `8px` (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`; applies strictly to mobile field-shaped Form & Selection controls; deliberate semantic differentiation from 6px Primary CTA).
     - **Focus Semantic Direction:** Restrained Interaction-Accent Emphasis (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`; Web pilot rendering reference is 1px accent field border + 3px outer halo).
     - **Structural System Model:** Role-Aware Hybrid (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE_4E_STRUCTURAL_MODEL`). Customer uses `OPEN_EDITORIAL_DEFAULT` (content/imagery first, unboxed facts with subtle internal dividers, cards restricted to independent discovery/quote units, card soup prohibited); Owner uses `ROLE-AWARE OPERATIONAL_GROUPING` (`OPEN_GROUPED_CONTENT` sharing one outer container with subtle internal dividers for dense triage [exact native stroke width `OPEN` / deferred to Phase 4I; 1px is controlled Web pilot rendering reference only]); Admin desktop table workspace preserved (`WEB_BOUNDARY_REFERENCE_ONLY`).
     - **Structural Container Radius:** `12px` (`SYSTEM-EVALUATED PROVISIONAL STRUCTURAL_CONTAINER_RADIUS`; bounded evidence: 10px valid close alternative, 12px balanced provisional system tie-breaker, 16px materially rounder with higher generic-SaaS styling risk; `NO_MATERIAL_FOUNDER_DECISION_REQUIRED: YES`; distinct from 6px action and 8px field).
     - **Mobile Content Insets:** `16px` candidate (`SYSTEM-EVALUATED PROVISIONAL MOBILE_PAGE_INSET`; page insets != platform safe-area insets) for Customer and Owner mobile.
     - **Spacing Scale & Relational Hierarchy:** Canonical relational hierarchy `TIER_1 < TIER_2 < TIER_3 < TIER_4`; evaluated mobile numeric mapping `4/8/12/16/24/32` (`SYSTEM-EVALUATED PROVISIONAL NUMERIC MAPPING`; 40/48px sizing clearances observed in Web pilots are not part of formal spacing scale across four relational tiers: Micro, Intra-group, Section, Major Boundary). Rule: no new spacing value without demonstrated semantic need and central design-system governance.
   - **OPEN VARIABLES (Genuinely Unresolved / Implementation Candidates / Phase-Deferred):**
     - **Exact Blue:** `#276EF1` candidate token remains open.
     - **Exact Neutrals:** Palette tokens remain open / implementation candidates (`CONTROLLED_WEB_PILOT_RENDERING_REFERENCE`).
     - **Exact Native Focus Treatment:** Assistive/system focus and halo metrics remain open / deferred to Phase 4I.
     - **Exact Native Stroke Width:** Border/stroke tokenization remains open / deferred to Phase 4I.
     - **Exact Native Field Height:** Container height remains open / deferred to Phase 4I (48px in pilot was controlled Web pilot geometry).
     - **Secondary Button Radius:** Remains open / undecided.
     - **Badge / Indicator Geometry:** Remains open / component-governed (Phase 4G–4H).
     - **Overlay / Navigation Geometry:** App bars, navigation bars, bottom sheets, and dialogs remain Phase 4F scope (`STATUS: NOT_STARTED`).
   - **NATIVE ACCEPTANCE:**
     - `DEFERRED_TO_4I`: All provisional candidates require empirical Flutter device rendering, performance, and accessibility acceptance on real hardware before permanent Canon promotion.

---

## 4. Semantic Action Hierarchy

Every surface must declare its action hierarchy unambiguously (§15):
- **Primary Action:** The single most important forward action on the surface.
- **Secondary Action:** Important alternative or supporting actions.
- **Tertiary Action:** Subtle, text-based, or low-prominence actions.
- **Contextual Actions:** Inline actions scoped to specific cards or list items.
- **Destructive Action:** Critical irreversible operations requiring distinct visual caution.

Exact colors, dimensions, and radii for these roles are defined in component contracts, not hardcoded globally in this skill.
