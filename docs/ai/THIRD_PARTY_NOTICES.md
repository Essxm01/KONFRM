# Third-Party Notices & Attribution

This project incorporates reference material, design playbooks, and advisory catalogs from third-party open-source projects governed under their respective licenses. All third-party material has been audited, pinned to exact commit revisions, and integrated under project-local wrappers with explicit KONFRM Canon guardrails.

---

## 1. Summary of Vendored & Adapted Third-Party Assets

| Project | Upstream Repository / Source URL | Pinned Commit SHA | Actual Upstream License | Exact Copyright / Attribution | License File | Vendored / Adapted Paths in KONFRM |
|---|---|---|---|---|---|---|
| **Anthropic Skills** (`frontend-design`) | https://github.com/anthropics/skills | `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` | Apache-2.0 | Anthropic, PBC. | [`ANTHROPIC_SKILLS_APACHE_2.0.txt`](licenses/ANTHROPIC_SKILLS_APACHE_2.0.txt) | `docs/ai/skills/frontend-design-wrapper/vendor/UPSTREAM_SKILL.md` |
| **Vercel Web Interface Guidelines** | https://github.com/vercel-labs/web-interface-guidelines | `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1` | MIT | Copyright (c) 2025 Vercel Labs | [`VERCEL_WEB_INTERFACE_GUIDELINES_MIT.txt`](licenses/VERCEL_WEB_INTERFACE_GUIDELINES_MIT.txt) | `docs/ai/skills/vercel-web-guidelines-wrapper/vendor/web-interface-guidelines.md` |
| **Vercel Agent Skills** (`composition-patterns`, `web-design-guidelines`) | https://github.com/vercel-labs/agent-skills | `063bee94c3f4df8453406c830b0a7df0f2860278` | **UNRESOLVED** *(No general license in upstream tree; composition-patterns declares license: MIT)* | Vercel Labs (Unspecified in tree) | N/A (Do not claim compliance) | Provenance reference only; zero copied vendor files |
| **UI/UX Pro Max Skill** | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill | `09170eec67eefd46a7ae85de61b40c194020f997` | MIT | Copyright (c) 2024 Next Level Builder | [`UI_UX_PRO_MAX_MIT.txt`](licenses/UI_UX_PRO_MAX_MIT.txt) | `docs/ai/skills/ui-ux-pro-max-wrapper/vendor/` |
| **Impeccable Design Engine** | https://github.com/pbakaus/impeccable | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | Copyright 2025 Paul Bakaus (Derived notice: ehmo MIT) | [`IMPECCABLE_APACHE_2.0.txt`](licenses/IMPECCABLE_APACHE_2.0.txt) | `docs/ai/skills/impeccable-wrapper/playbooks/` |
| **Emil Kowalski Skills** (`emil-design-eng`) | https://github.com/emilkowalski/skills | `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128` | MIT | Copyright (c) 2026 Emil Kowalski | [`EMIL_SKILLS_MIT.txt`](licenses/EMIL_SKILLS_MIT.txt) | `docs/ai/skills/emil-wrapper/vendor/UPSTREAM_SKILL.md` |

---

## 2. Source-Specific License Texts

Source-specific license files preserving exact upstream copyright declarations are stored in `docs/ai/licenses/`:
- **UI/UX Pro Max:** [`docs/ai/licenses/UI_UX_PRO_MAX_MIT.txt`](licenses/UI_UX_PRO_MAX_MIT.txt)
- **Vercel Web Interface Guidelines:** [`docs/ai/licenses/VERCEL_WEB_INTERFACE_GUIDELINES_MIT.txt`](licenses/VERCEL_WEB_INTERFACE_GUIDELINES_MIT.txt)
- **Emil Kowalski Skills:** [`docs/ai/licenses/EMIL_SKILLS_MIT.txt`](licenses/EMIL_SKILLS_MIT.txt)
- **Anthropic Skills (frontend-design):** [`docs/ai/licenses/ANTHROPIC_SKILLS_APACHE_2.0.txt`](licenses/ANTHROPIC_SKILLS_APACHE_2.0.txt)
- **Impeccable:** [`docs/ai/licenses/IMPECCABLE_APACHE_2.0.txt`](licenses/IMPECCABLE_APACHE_2.0.txt)

---

## 3. Detailed Attribution & Governance Notices

### A. UI/UX Pro Max Skill
- **Upstream License:** MIT License
- **Copyright:** (c) 2024 Next Level Builder
- **Audited Commit:** `09170eec67eefd46a7ae85de61b40c194020f997`
- **Notice:** Advisory catalogs and search scripts are maintained in `docs/ai/skills/ui-ux-pro-max-wrapper/vendor/` as local, zero-network reference data. Execution is strictly governed by `runner.py`, which implements a strict allowlist-only parser (`allow_abbrev=False`), reconstructs sanitized commands without raw argument passthrough, permanently prevents write/persistence flags, and declares all metrics subordinate to KONFRM Canon.

### B. Impeccable
- **Upstream License:** Apache License 2.0
- **Copyright:** Copyright 2025 Paul Bakaus
- **Audited Commit:** `c74755d920985f7a92cef691ca970ba95f90126e`
- **Third-Party Notice in Upstream:** Upstream `NOTICE.md` notes that `skill/reference/ios.md` and `skill/reference/android.md` are derived from ehmo's `platform-design-skills` (MIT License).
- **Notice:** Reference playbooks are consolidated in `docs/ai/skills/impeccable-wrapper/playbooks/`. Upstream binary hooks (`.codex/hooks.json`) and automated execution are completely disabled.

### C. Emil Kowalski Skills
- **Upstream License:** MIT License
- **Copyright:** (c) 2026 Emil Kowalski
- **Audited Commit:** `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128`
- **Notice:** Preserved locally for reference under `docs/ai/skills/emil-wrapper/vendor/UPSTREAM_SKILL.md`. Timing and spring values are treated as advisory candidates subordinate to KONFRM component validation.

### D. Anthropic Skills — Frontend Design
- **Upstream License:** Apache License 2.0
- **Audited Commit:** `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4`
- **License Location:** `skills/frontend-design/LICENSE.txt`
- **Notice:** Preserved locally for reference under `docs/ai/skills/frontend-design-wrapper/vendor/UPSTREAM_SKILL.md`. Governed by KONFRM monochrome-first brand rules and Arabic RTL layout requirements.

### E. Vercel Web Interface Guidelines
- **Upstream License:** MIT License
- **Copyright:** (c) 2025 Vercel Labs
- **Audited Commit:** `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1`
- **Notice:** A frozen, reviewed snapshot of guidelines is vendored locally at `docs/ai/skills/vercel-web-guidelines-wrapper/vendor/web-interface-guidelines.md` to ensure zero runtime network egress. Scope is confined to `admin-app/` web review.

### F. Vercel Agent Skills (Status: UNRESOLVED)
- **Source:** https://github.com/vercel-labs/agent-skills
- **Audited Commit:** `063bee94c3f4df8453406c830b0a7df0f2860278`
- **Licensing Status:** **UNRESOLVED**. No general `LICENSE` file is present in the repository root or subfolders at the pinned commit. While the pinned `skills/composition-patterns/SKILL.md` contains frontmatter declaring `license: MIT`, the repository lacks an overall license declaration, and `skills/web-design-guidelines/SKILL.md` contains no license field.
- **Disposition:** To avoid retaining third-party text where the redistribution basis is not clearly established, all verbatim `UPSTREAM_SKILL.md` files from `vercel-labs/agent-skills` have been **completely removed** from the repository. The wrappers (`vercel-composition-wrapper` and `vercel-web-guidelines-wrapper`) are 100% KONFRM-authored documents that retain upstream repository coordinates solely for provenance tracking. The separately licensed snapshot of `vercel-labs/web-interface-guidelines` (MIT License, Copyright (c) 2025 Vercel Labs) is retained under its own documented license.
