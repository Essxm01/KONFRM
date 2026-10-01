---
name: frontend-design-wrapper
description: "KONFRM-governed wrapper for Anthropic's frontend-design skill. Leverages anti-generic layout reasoning, purposeful typographic hierarchy, and craftsmanship while strictly enforcing KONFRM's monochrome-first palette, Cairo typography, and native Arabic RTL requirements."
---

# Frontend Design — KONFRM Governed Wrapper

Wraps `anthropics/skills` / `frontend-design` (Commit `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Approved Anti-Generic Principles

The upstream skill's core value is eliminating lazy, cookie-cutter AI interface defaults:
1. **Avoid Template Homogeneity:** Do not build repetitive "card inside card inside card" layouts. Vary density, grouping, and visual weights according to real content hierarchy.
2. **Intentional Typographic Contrast:** Establish clear hierarchy through size, weight, and tracking rather than wrapping every piece of text in uniform gray badges.
3. **Restrained Decoration:** Use functional white surfaces, crisp high-contrast text, and subtle 1dp borders instead of heavy drop shadows or unnecessary gradients.

---

## 2. Mandatory KONFRM Guardrails

1. **Aesthetic Subordination to Monochrome Core:**
   - Upstream suggests inventing expressive accent color themes. In KONFRM, **this is strictly prohibited**.
   - Primary palette is Black (`#000000`) and White (`#FFFFFF`) with neutral slates.
   - Blue (`#276EF1`) is reserved exclusively as a candidate interaction accent.
   - Yellow is permanently removed from the mobile core brand identity.
2. **Mandatory RTL Architecture:**
   - Upstream examples assume English LTR layouts. Every interface built in KONFRM must follow Arabic-first RTL reading order, right-aligned text, mirrored back buttons, and Western Arabic numerals (`0-9`).
3. **Subordinate System Fonts:**
   - Upstream recommends standard web fonts (Geist, Inter, Roboto). In KONFRM, the canonical UI font is **Cairo** with line-height compensation (1.4–1.6x).

---

## 3. Upstream Reference

The complete upstream guidance is preserved locally for reference at:
[`vendor/UPSTREAM_SKILL.md`](file:///C:/Users/Essam/OneDrive/Desktop/KONFRM-SCREEN17-18-REMEDIATION/docs/ai/skills/frontend-design-wrapper/vendor/UPSTREAM_SKILL.md)
