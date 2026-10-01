---
name: impeccable-wrapper
description: "KONFRM-governed wrapper for the Impeccable design craftsmanship engine. Consolidates polish, critique, distill, quieter, bolder, and delight playbooks while enforcing strict permission gating, zero binary hook execution, and evaluating mobile surfaces against DF2 semantic roles rather than legacy web tokens."
---

# Impeccable Craftsmanship — KONFRM Governed Wrapper

Wraps `pbakaus/impeccable` (Commit `c74755d920985f7a92cef691ca970ba95f90126e`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Consolidated Playbook Architecture

The 6 separate upstream tools are unified into a single project-local reference library located at:
`docs/ai/skills/impeccable-wrapper/playbooks/`

### A. Primary Approved Playbooks (Always Available)
1. **`polish.md`:** Surface fit, finish, pixel precision, spacing cadence, visual alignment, and border subtlety.
2. **`critique.md`:** Systematic evaluation of visual hierarchy, ergonomics, readability, and consistency.
3. **`distill.md`:** Radical simplification, removing visual noise, elevating useful density.
4. **`quieter.md`:** Calming aggressive visual elements, lowering contrast of secondary metadata, creating breathing room within high-density layouts.

### B. Permission-Gated Playbooks (Requires Founder/Spec Authorization)
5. **`bolder.md`:** *GATED.* High-contrast emphasis and visual distinction. Must not be used on transactional screens without explicit Founder sign-off.
6. **`delight.md`:** *GATED.* Emotional design, micro-moments. Strictly forbidden on financial transaction, booking, or payout paths to avoid trivializing money or causing anxiety.

---

## 2. Review Authority: Mobile vs. Web Distinction

When conducting critiques or polish audits, agents must distinguish between Web and Mobile design authorities:

- **For Future Native Mobile Surfaces:**
  - Evaluate against **DF2 semantic roles** (`DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`), approved Primitive contracts when they exist, and validated candidate values.
  - Existing `DESIGN_SYSTEM/TOKENS/*.json` files are **Web implementation evidence**, NOT automatic Mobile Canon. Do not criticize mobile layouts for not matching legacy web pixel values.
- **For Current Web Surfaces (`admin-app/`, current `customer-app/`, `owner-app/`):**
  - Existing Web design tokens and Tailwind variables may be used as the current implementation baseline.

---

## 3. Mandatory Guardrails & Security Policies

1. **Zero Binary Execution:**
   - Upstream repository contains binary hooks (`.codex/hooks.json`, rust binaries). These are **strictly prohibited** in KONFRM. No automated binary or shell hooks may be registered or executed.
2. **No Decorative Clutter:**
   - Gamification, confetti animations, bouncy cartoon physics, and decorative badges are prohibited on core screens.
3. **RTL Native Evaluation:**
   - Critiques must assess visual balance from an Arabic-first, RTL reading perspective (right-to-left flow, mirrored padding, and Western Arabic numerals `0-9`).
