---
name: emil-wrapper
description: "KONFRM-governed wrapper for Emil Kowalski's interaction design and animation principles. Provides guidelines for purposeful, snappy micro-interactions and tactile feedback while subordinating duration and easing heuristics to KONFRM token architecture and forbidding motion that obstructs transactional workflows."
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
2. **Interruptibility & Direct Manipulation:** Gestures (sheet dismiss, swipe to delete, modal close) must respond immediately to finger position and be interruptible mid-flight without glitching.
3. **Snappy Perceived Performance:** Feedback must begin on touch-down (active state), not wait for network round-trips or release events.

---

## 2. Mandatory Guardrails & Transaction Constraints

1. **Transactional Paths Must Not Be Delayed:**
   - On critical user journeys (booking confirmation, checkout, dispute reconciliation, owner payout execution), animations MUST NEVER artificially delay the user.
   - Durations for transactional state transitions must remain within **150ms–250ms**. Lengthy 500ms+ sequence orchestrations are prohibited.
2. **Advisory Duration & Easing Metrics:**
   - Any specific numeric timing values suggested by upstream guidance (e.g. spring tension, damping, bezier curves) are **advisory candidates**. They must be reconciled with existing Flutter curve constants (`Curves.easeOutCubic`, `Curves.fastOutSlowIn`) and Web CSS variables.
3. **Strict Accessibility Compliance:**
   - Always verify that animations honor `MediaQuery.of(context).disableAnimations` (Flutter) or `prefers-reduced-motion: reduce` (Web). When active, transitions must be instant or simple opacity fades.
4. **Subtle Tactile Feedback:**
   - In Flutter mobile apps, pair critical action completion with subtle haptic impulses (`HapticFeedback.lightImpact()`), avoiding loud audio effects or bouncy visual noise.

---

## 3. Upstream Reference

The complete upstream guidance is preserved locally for reference at:
[`vendor/UPSTREAM_SKILL.md`](file:///C:/Users/Essam/OneDrive/Desktop/KONFRM-SCREEN17-18-REMEDIATION/docs/ai/skills/emil-wrapper/vendor/UPSTREAM_SKILL.md)
