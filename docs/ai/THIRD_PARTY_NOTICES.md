# Third-Party Notices & Attribution

This project incorporates material, playbooks, and datasets from third-party open-source projects governed under their respective licenses. All third-party material has been audited, pinned to specific commit revisions, and integrated under project-local wrappers with explicit KONFRM Canon guardrails.

---

## 1. Summary of Vendored & Adapted Third-Party Assets

| Project | Upstream Repository / Source URL | Pinned Commit SHA | License | Vendored / Adapted Paths in KONFRM |
|---|---|---|---|---|
| **Anthropic Skills** (`frontend-design`) | https://github.com/anthropics/skills | `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` | Apache-2.0 | `docs/ai/skills/frontend-design-wrapper/vendor/UPSTREAM_SKILL.md` |
| **Vercel Agent Skills** (`composition-patterns`) | https://github.com/vercel-labs/agent-skills | `063bee94c3f4df8453406c830b0a7df0f2860278` | MIT / Apache-2.0 | `docs/ai/skills/vercel-composition-wrapper/vendor/UPSTREAM_SKILL.md` |
| **Vercel Agent Skills** (`web-design-guidelines`) | https://github.com/vercel-labs/agent-skills | `063bee94c3f4df8453406c830b0a7df0f2860278` | MIT / Apache-2.0 | `docs/ai/skills/vercel-web-guidelines-wrapper/vendor/UPSTREAM_SKILL.md` |
| **Vercel Web Interface Guidelines** (`command.md`) | https://github.com/vercel-labs/web-interface-guidelines | `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1` | MIT / Apache-2.0 | `docs/ai/skills/vercel-web-guidelines-wrapper/vendor/web-interface-guidelines.md` |
| **UI/UX Pro Max Skill** | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill | `09170eec67eefd46a7ae85de61b40c194020f997` | MIT | `docs/ai/skills/ui-ux-pro-max-wrapper/vendor/` |
| **Impeccable Design Engine** | https://github.com/pbakaus/impeccable | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | `docs/ai/skills/impeccable-wrapper/playbooks/` |
| **Emil Kowalski Skills** (`emil-design-eng`) | https://github.com/emilkowalski/skills | `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128` | MIT | `docs/ai/skills/emil-wrapper/vendor/UPSTREAM_SKILL.md` |

---

## 2. License Texts

Full license texts are preserved in the `docs/ai/licenses/` directory:
- **Apache License 2.0:** [`docs/ai/licenses/APACHE-2.0.txt`](docs/ai/licenses/APACHE-2.0.txt)
- **MIT License:** [`docs/ai/licenses/MIT.txt`](docs/ai/licenses/MIT.txt)

---

## 3. Detailed Attribution & Governance Notices

### A. UI/UX Pro Max Skill (MIT License)
- **Copyright:** (c) 2026 NextLevelBuilder
- **Source:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
- **Audited Commit:** `09170eec67eefd46a7ae85de61b40c194020f997`
- **Notice:** Vendored datasets and search script are maintained in `docs/ai/skills/ui-ux-pro-max-wrapper/vendor/` as single-source data. Invocation is governed strictly by `runner.py`, which strips unportable environment assumptions, blocks `--persist` mutations, and subordinates all returned metrics to KONFRM DF2 Canon.

### B. Impeccable (Apache License 2.0)
- **Copyright:** (c) 2026 Paul Bakaus
- **Source:** https://github.com/pbakaus/impeccable
- **Audited Commit:** `c74755d920985f7a92cef691ca970ba95f90126e`
- **Notice:** Reference playbooks (`polish.md`, `critique.md`, `distill.md`, `quieter.md`, `bolder.md`, `delight.md`) are consolidated in `docs/ai/skills/impeccable-wrapper/playbooks/`. Upstream binary hooks (`.codex/hooks.json`) and automated execution are completely disabled.

### C. Emil Kowalski Skills (MIT License)
- **Copyright:** (c) 2026 Emil Kowalski
- **Source:** https://github.com/emilkowalski/skills
- **Audited Commit:** `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128`
- **Notice:** Preserved locally for reference under `docs/ai/skills/emil-wrapper/vendor/UPSTREAM_SKILL.md`. Timing and curve values are treated as advisory candidates subordinate to KONFRM component validation.

### D. Anthropic Skills — Frontend Design (Apache License 2.0)
- **Copyright:** (c) 2026 Anthropic, PBC.
- **Source:** https://github.com/anthropics/skills
- **Audited Commit:** `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4`
- **Notice:** Preserved locally for reference under `docs/ai/skills/frontend-design-wrapper/vendor/UPSTREAM_SKILL.md`. Governed by KONFRM monochrome-first brand rules and Arabic RTL layout requirements.

### E. Vercel Agent Skills & Web Interface Guidelines (MIT / Apache-2.0)
- **Copyright:** (c) 2026 Vercel, Inc.
- **Sources:**
  - https://github.com/vercel-labs/agent-skills (Commit: `063bee94c3f4df8453406c830b0a7df0f2860278`)
  - https://github.com/vercel-labs/web-interface-guidelines (Commit: `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1`)
- **Notice:** A frozen, reviewed snapshot of `command.md` is vendored locally at `docs/ai/skills/vercel-web-guidelines-wrapper/vendor/web-interface-guidelines.md` to ensure zero runtime network egress. Scope is confined to `admin-app/` web review.
