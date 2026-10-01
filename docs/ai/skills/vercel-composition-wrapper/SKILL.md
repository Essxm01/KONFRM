---
name: vercel-composition-wrapper
description: "KONFRM-governed wrapper for Vercel's React component composition patterns. Provides architectural patterns for compound components, flexible prop contracts, and hook composition strictly for React web applications while preventing Flutter architectural contamination."
---

# React Composition Patterns — KONFRM Governed Wrapper

Wraps `vercel-labs/agent-skills` / `composition-patterns` (Commit `063bee94c3f4df8453406c830b0a7df0f2860278`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Application Scope: React Web Apps ONLY

- **Permitted Scope:** Architectural design of React components located within `admin-app/` and current React prototypes (`customer-app/`, `owner-app/`).
- **Strictly Prohibited:** Future Flutter applications follow the separately governed Gate3B Flutter architecture. React composition guidance must not cross that boundary.

---

## 2. Approved Architectural Patterns

1. **Compound Component Composition:**
   - Instead of massive monolithic components with 30 props, structure complex UI into cohesive compound components sharing context:
     ```tsx
     <Table>
       <Table.Header>...</Table.Header>
       <Table.Body>
         <Table.Row>...</Table.Row>
       </Table.Body>
     </Table>
     ```
2. **Slot & Render Delegation:**
   - Allow parent components to inject custom trailing actions, badges, or dialog triggers via slots rather than hardcoded conditional branches.
3. **Headless State Extraction:**
   - Separate complex operational logic (e.g. dispute review form state, payout multi-select filters) into dedicated custom hooks (`useDisputeReview`, `usePayoutFilters`), leaving presentation components declarative and testable.

---

## 3. Mandatory Guardrails

1. **Architecture Only — Zero Visual Taste Overrides:**
   - This skill provides code structure patterns only. It has **no authority** over styling, fonts, colors, spacing, or visual hierarchy. All styling must consume Tailwind utility classes mapped to KONFRM design tokens.
2. **Maintain RTL Arabic Accessibility:**
   - Compound components must preserve correct DOM tree order and ARIA roles for keyboard navigation in RTL mode.

---

## 4. Upstream Provenance & Reference

- **Upstream Repository:** `https://github.com/vercel-labs/agent-skills`
- **Pinned Commit:** `063bee94c3f4df8453406c830b0a7df0f2860278`
- **Source Path:** `skills/composition-patterns/SKILL.md` (the pinned file declares `license: MIT`, though the repository root lacks a general LICENSE file; retained as provenance reference only, with zero copied vendor files)
