---
name: vercel-web-guidelines-wrapper
description: "KONFRM-governed wrapper for Vercel's web interface guidelines. Applies static web quality, performance, and accessibility checks exclusively to the Admin web application while ignoring Next.js/Vercel hosting assumptions and preventing mobile Flutter contamination."
---

# Web Design Guidelines — KONFRM Governed Wrapper

Wraps `vercel-labs/agent-skills` / `web-design-guidelines` (Commit `063bee94c3f4df8453406c830b0a7df0f2860278`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Application Scope: Admin Web App ONLY

- **Permitted Scope:** Exclusively for auditing the Admin Web Application located at `admin-app/`.
- **Strictly Prohibited:** NEVER activate or apply these web guidelines to Flutter mobile applications (`customer-app/` or `owner-app/`). Mobile architecture is governed entirely by `konfrm-mobile-design`.

---

## 2. Approved Web Quality Checks

The following web-specific heuristics from upstream are approved for Admin app code reviews:
1. **DOM Size & Performance:** Avoid excessive DOM tree nesting. Keep operations dashboards lightweight and performant.
2. **Keyboard Accessibility:** All buttons, dropdowns, and modal dialogs must support keyboard focus (`Tab`, `Shift+Tab`, `Enter`, `Escape`).
3. **Form Semantics:** Form fields must have permanent visual labels or explicit `aria-label` attributes; placeholders alone are never sufficient.
4. **Layout Shifts (CLS):** Reserve container dimensions for async data tables to prevent Cumulative Layout Shift during data hydration.

---

## 3. Mandatory Guardrails & Infrastructure Realities

1. **Ignore Vercel & Next.js Hosting Assumptions:**
   - Upstream documentation assumes Next.js server actions, Next Image optimization, and Vercel edge deployment.
   - KONFRM Admin is a **Vite + React SPA** compiled statically and deployed to **Cloudflare Pages**. Ignore all Vercel-proprietary recommendations.
2. **Arabic RTL DOM Ordering:**
   - Visual reading order and DOM focus order must strictly match in RTL mode. Never use visual CSS reversals (`float: right` or reverse flex without logical ordering) that break tab navigation.
3. **Color Token Alignment:**
   - Web buttons and accents must use KONFRM's established web tokens (`#0059FF` Web primary baseline, neutral slates, `#FFFFFF` surfaces), not Vercel Geist default monochromatic grays.

---

## 4. Upstream Reference

The complete upstream guidance is preserved locally for reference at:
[`vendor/UPSTREAM_SKILL.md`](file:///C:/Users/Essam/OneDrive/Desktop/KONFRM-SCREEN17-18-REMEDIATION/docs/ai/skills/vercel-web-guidelines-wrapper/vendor/UPSTREAM_SKILL.md)
