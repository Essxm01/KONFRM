---
name: emil-wrapper
description: "KONFRM-governed wrapper for Emil Kowalski's interaction design and animation principles. Provides guidelines for purposeful micro-interactions and tactile feedback while treating numeric duration and easing heuristics as candidates and forbidding motion that obstructs transactional workflows."
---

# Emil Kowalski Design Engineering — KONFRM Governed Wrapper

Wraps `emilkowalski/skills` / `emil-design-eng` (Commit `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Core Principles Approved for KONFRM

1. **Purposeful Feedback:** Every animation must communicate state change, spatial continuity, or affordance confirmation. Avoid animations that exist purely for decoration.
2. **Interruptibility & Direct Manipulation:** Gestures (sheet dismiss, swipe to delete, modal close) should respond immediately to touch input and be interruptible mid-flight without jarring glitches.
3. **Immediate Perceived Response:** Feedback should begin on touch-down (active/pressed state), not wait for network round-trips or release events.

---

## 2. Mandatory Guardrails & Transaction Constraints

1. **Motion Must Never Delay Transactional Work:**
   - On critical user journeys (booking confirmation, checkout, dispute reconciliation, owner payout execution), animations MUST NEVER artificially delay or block the user.
   - Do not invent artificial mandatory duration ceilings (e.g. 150–250ms) as global Canon; motion values remain implementation candidates requiring device validation.
2. **Advisory Duration & Easing Metrics:**
   - Specific numeric timing values suggested by upstream guidance (e.g. spring tension, damping ratios, cubic-bezier curves) are **advisory candidates**. They must be validated against actual component behavior and platform capabilities.
3. **Haptic Feedback as Candidate Patterns:**
   - Tactile feedback (haptics) is encouraged to reinforce important state changes, but specific haptic strengths or patterns remain candidates requiring device feel validation.
4. **Strict Accessibility Compliance (Reduced Motion):**
   - Always verify that animations honor system reduced-motion settings (`MediaQuery.of(context).disableAnimations` in Flutter; `@media (prefers-reduced-motion: reduce)` in Web). When active, transitions must be instant or simple opacity fades.

---

## 3. Upstream Reference

The complete upstream guidance is preserved locally for reference at:
`docs/ai/skills/emil-wrapper/vendor/UPSTREAM_SKILL.md`
