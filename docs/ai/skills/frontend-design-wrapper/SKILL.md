---
name: frontend-design-wrapper
description: "KONFRM-governed wrapper for Anthropic's frontend-design skill. Leverages anti-generic layout reasoning and visual hierarchy while strictly adhering to KONFRM's monochrome-first brand direction, candidate typography rules, and native Arabic RTL requirements."
---

# Frontend Design — KONFRM Governed Wrapper

Wraps `anthropics/skills` / `frontend-design` (Commit `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Approved Anti-Generic Heuristics

The upstream skill provides valuable layout and hierarchy reasoning to prevent lazy AI design defaults:
1. **Avoid Template Homogeneity:** Avoid repetitive "card inside card inside card" layouts. Group information based on semantic relevance and operational necessity.
2. **Intentional Hierarchy:** Build clear visual hierarchy through order, grouping, scale, and contrast rather than wrapping arbitrary text chunks in generic colored boxes.
3. **Restrained Functional Surfaces:** Use clean, light-dominant surfaces, crisp text contrast, and purposeful 1dp borders rather than heavy drop shadows, neon accents, or decorative gradients.

---

## 2. Mandatory KONFRM Guardrails (DF2 v1.1 Alignment)

1. **Brand Identity Direction vs. Action Treatment:**
   - Upstream suggests inventing expressive accent color themes. In KONFRM, the canonical brand identity direction is solid **Black and White** with a restrained blue interaction accent role (`#276EF1` candidate).
   - Do not assume "all primary buttons are canonically #000000" or that specific neutral slates are frozen mobile tokens; exact UI ink and neutral values are implementation candidates evaluated during component validation.
2. **RTL Direction-Relative Semantics:**
   - Upstream examples assume English LTR structure. In KONFRM, interfaces follow Arabic-first RTL reading order with direction-relative semantics (`start` / `end`).
   - Do not enforce blanket right-alignment without considering visual hierarchy, and respect explicit physical/spatial exceptions (e.g. media timelines, circular progress, isolated LTR phone numbers).
3. **Typography Candidate Status:**
   - Upstream recommends standard Latin fonts (Inter, Roboto). In KONFRM, **Cairo** is the primary implementation candidate for mobile UI and current Web baseline, pending real device rendering validation.

---

## 3. Upstream Reference

The complete upstream guidance is preserved locally for reference at:
`docs/ai/skills/frontend-design-wrapper/vendor/UPSTREAM_SKILL.md`
