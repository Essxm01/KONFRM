---
name: ui-ux-pro-max-wrapper
description: "KONFRM-governed wrapper for UI/UX Pro Max design intelligence. Provides searchable local UX/UI guidelines across styles, stacks, and patterns while strictly subordinating numeric heuristics to KONFRM DF2 Canon, stripping Claude plugin root dependencies, and forbidding repository token mutations."
---

# UI/UX Pro Max — KONFRM Governed Wrapper

Wraps `nextlevelbuilder/ui-ux-pro-max-skill` (v2.13.0 / Commit `09170eec67eefd46a7ae85de61b40c194020f997`) under KONFRM Design Governance.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Mandatory Guardrails

1. **Advisory Inspiration Only:** All search results, style presets, and color palettes are advisory suggestions for exploration. They must never override canonical KONFRM tokens in `DESIGN_SYSTEM/TOKENS/`.
2. **Numeric Subordination:**
   - External heuristics claiming universal minimums (e.g., universal 44×44px touch target, 12px/16px font minimums) are strictly subordinate to KONFRM Canon (48dp primary, 36–40dp secondary with adequate spacing).
3. **Strict Ban on `--persist`:**
   - The `--persist` flag is permanently disabled. External skills are prohibited from writing `design-system/` directories or modifying existing token trees.
4. **Portable Local Runner:**
   - Do not rely on `${CLAUDE_PLUGIN_ROOT}` environment variables. Use the project-local runner script:
     ```bash
     python docs/ai/skills/ui-ux-pro-max-wrapper/runner.py "<query>" --domain <domain>
     ```
5. **No Direct Production Application:**
   - Do not apply raw output hex codes directly into production code. Map any desired style attribute to existing tokens in `DESIGN_SYSTEM/TOKENS/color.json`.

---

## 2. Permitted Search Usage

Query the local search engine for targeted ergonomic advice or layout ideas:

```bash
# Query UX guidelines for navigation or forms
python docs/ai/skills/ui-ux-pro-max-wrapper/runner.py "form validation" --domain ux

# Query chart accessibility considerations
python docs/ai/skills/ui-ux-pro-max-wrapper/runner.py "stacked bar" --domain chart

# Query stack-specific guidance
python docs/ai/skills/ui-ux-pro-max-wrapper/runner.py "list performance" --stack flutter
```

Available domains: `style`, `color`, `chart`, `landing`, `product`, `ux`, `typography`, `google-fonts`, `icons`, `gsap`, `react`, `web`.  
Available stacks: `flutter`, `react`, `html-tailwind`, `nextjs`, etc.

---

## 3. Resolving Conflicts with KONFRM Canon

| UI/UX Pro Max Output | KONFRM Canonical Mandate | Resolution |
|----------------------|--------------------------|------------|
| Suggests colorful SaaS blue/purple palette | Solid Black/White core brand identity | **Discard external palette.** Use canonical `#000000` / `#FFFFFF` with `#276EF1` candidate interaction accent. |
| Assumes LTR card flow | Arabic-first RTL native layout | **Mirror layout:** leading content on Right, disclosures on Left. |
| Suggests universal 44×44px button | DF2 mobile component contracts | **Use 48–52dp height** for primary buttons (`KonfrmPrimaryButton`). |
| Suggests writing tokens to disk via `--persist` | Guardrail blocks command | **Token changes must go through `DESIGN_SYSTEM/` workflow.** |
