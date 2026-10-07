# Visual System Foundations & Geometric Grammar

```yaml
MODULE: visual_system.md
BRAIN: konfrm-design
AUTHORITY: DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md §1–§8 + DESIGN_SYSTEM/TOKENS/
```

This reference defines the visual grammar, brand identity, geometric radii, spacing scales, and typographical discipline governing KONFRM interfaces under DF2 v1.7.

---

## 1. Brand Identity & Color Intent

### Monochrome-First Identity:
- **Canonical Direction:** Solid Black (`#000000`) and White (`#FFFFFF`).
- **Canonical Brand Symbols:**
  - Light surfaces: `DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-black.svg`.
  - Dark surfaces: `DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-white.svg`.
- **Summer Yellow Ban:** Summer Yellow is permanently REMOVED from the core mobile brand architecture.
- **Identity vs. Interaction Separation:**
  - Brand identity is monochrome.
  - Blue is strictly an **interaction accent role**, never the brand logo artwork.
  - The token `#276EF1` is an **IMPLEMENTATION CANDIDATE** for the interaction accent role.
- **Light-First Dominant Intent:**
  - White and light neutral surfaces dominate all normal product screens.
  - Heavy navy/slate slabs, high-contrast dark cards, floating glow cards, and glassmorphism are strictly prohibited.

---

## 2. Geometric Radius Differentiation

KONFRM deliberately differentiates corner radii across semantic component categories to avoid the visual monotony of generic SaaS design:

```text
+----------------------------+-----------+----------------------------------------------+
| SEMANTIC CONTROL ROLE      | RADIUS    | STATUS                                       |
+----------------------------+-----------+----------------------------------------------+
| Primary Action CTA         | 6px       | SYSTEM-VALIDATED PROVISIONAL (PRIMARY_ONLY)  |
| Field & Selection Controls | 8px       | PROVISIONAL CANDIDATE (PHASE 4D)             |
| Structural Outer Container | 12px      | PROVISIONAL SYSTEM TIE-BREAKER (PHASE 4E)    |
| Secondary Action Controls  | OPEN      | Implementation Candidate (undecided)         |
| Badges & Status Indicators | OPEN      | Component-governed (Phase 4G/4H)             |
+----------------------------+-----------+----------------------------------------------+
```

### Semantic Rationale & Provisional Status Preservation:
- **6px Primary CTA:** Crisp, decisive button contour aligned with financial commitment.
- **8px Form Fields:** Subtly softer contour signaling an interactive input container, creating clear visual contrast against the 6px primary action.
- **12px Outer Containers:** Balanced framing for grouped operational elements or editorial media cards, avoiding both boxy sharpness (0–4px) and juvenile pill ballooning (16px+).
- **Strict Provisional Status:** 6px, 8px, and 12px are evaluated provisional baseline directions, NOT final native Canon. Permanent promotion requires empirical Phase 4I device validation.

---

## 3. Relational Spacing Scale (4 Tiers)

Spacing is governed by a canonical relational hierarchy where smaller semantic tiers are strictly less than larger ones:

$$\text{TIER\_1 (Micro)} < \text{TIER\_2 (Intra-Group)} < \text{TIER\_3 (Section)} < \text{TIER\_4 (Major Boundary)}$$

### Mobile Evaluated Numeric Mapping:
- **Tier 1 (Micro Spacing):** `4px` / `8px` — Icon-to-label gaps, badge padding, inline metadata gaps.
- **Tier 2 (Intra-Group Spacing):** `8px` / `12px` — Field-to-label spacing, item separation within grouped containers.
- **Tier 3 (Section Spacing):** `16px` / `24px` — Spacing between independent cards, form sections, or header-to-content.
- **Tier 4 (Major Boundary Spacing):** `24px` / `32px` — Page edge margins, major layout divisions, sticky bottom bar clearances.

### Page Insets & Token Discipline:
- **Mobile Content Inset:** `16px` candidate (`SYSTEM-EVALUATED PROVISIONAL MOBILE_PAGE_INSET`). Page insets are distinct from platform hardware safe-area insets.
- **Governed Token Baseline:** Use governed spacing and component tokens by default. A deviation requires a documented component, platform, or rendering reason and must not silently create a new system token. Spacing scales govern relational layout structure; they do not make every other dimensional value in specialized components illegal.

---

## 4. Typography Foundations (Cairo Profile B)

- **Font Family Foundation:** Cairo Profile B scale and vertical metrics (`SYSTEM-VALIDATED PROVISIONAL TYPOGRAPHY`).
- **Script-Specific Metric Breathing Room:**
  - Arabic script features pronounced vertical ascenders and descenders. Latin-centric line heights cause clipping of diacritics or descending loops.
  - Provide adequate line height in body text to ensure relaxed legibility in Arabic.
  - Optical vertical centering of Arabic text inside buttons must account for baseline distribution, not mechanical bounding box centers.

---

## 5. Anti-Generic Visual Discipline

To maintain high brand authority and avoid looking like generic AI-generated templates:
1. **Hierarchy Before Decoration:** Guide the eye using contrast, weight, and proximity before reaching for borders or colored backgrounds.
2. **No "Card Soup":** Do not wrap every field or label in its own rounded box. Group related information logically or use unboxed editorial rows.
3. **Restraint in Accents:** The interaction accent (Blue candidate) must be used sparingly to indicate active selection, focus, or interactive links. Never use accent blue as a decorative background wash.
4. **Useful Density:** Density means showing high-value data without visual noise; it does not mean cramming elements with zero breathing room.
