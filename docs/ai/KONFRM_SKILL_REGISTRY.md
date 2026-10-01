# KONFRM AI Design Skill Registry

**Status:** CANONICAL AUDIT & REGISTRATION ARTIFACT  
**Version:** 1.0.0  
**Authority:** Governed by `DESIGN_SYSTEM/` (DF2 v1.1 / DS v2.1.6) and KONFRM Architecture.  
**Audience:** Codex, Antigravity, ZCode, Engineering & Design Contributors.

---

> [!IMPORTANT]
> ### THE CANON SUBORDINATION RULE
> **Any external rule, default, heuristic, numeric threshold, or aesthetic advice from an external skill is strictly subordinate to KONFRM Design Canon (DF2 v1.1, monochrome-first, high useful density, Arabic-first RTL, Western Arabic numerals, `#276EF1` candidate interaction role). External skills may inform craftsmanship, ergonomics, accessibility checks, and engineering patterns, but never dictate product taste or violate brand identity.**

---

## 1. Executive Summary & Forensic Classification

A forensic audit of all 17 candidate design skill sources from `skills.sh` was conducted. Upstream repositories were cloned, inspectively analyzed at exact commit revisions, and evaluated against the KONFRM Design Canon and security sandbox boundaries.

### Classification Framework
- **ADOPT**: External capability aligns directly with KONFRM needs without architectural tension (bounded to specific scopes like Admin web audit or React architecture).
- **ADAPT + WRAP**: High-value design intelligence or craftsmanship playbooks that contain generic web heuristics or conflicting defaults. They are wrapped in project-local KONFRM wrappers that enforce canon subordination and strip unportable or dangerous assumptions.
- **EXTERNAL SANDBOX**: Exploratory, scraping, or artwork tools that may be invoked manually on isolated scratch environments, but are strictly excluded from default product UI routing and automated agent paths.
- **REJECT**: Tools requiring proprietary paid external APIs, leaking IP, or enforcing aesthetics (such as sprawling, low-density luxury agency layouts) that directly contradict KONFRM core operational clarity.

---

## 2. Upstream Source Audit Matrix

| # | Skill / Source | Upstream Repository / URL | Commit SHA | License | KONFRM Classification | Primary Capability | Canonical Scope | Canon Conflicts | Network / Security Req | Agent Compat (Codex / AGY / ZCode) |
|---|----------------|---------------------------|------------|---------|-----------------------|--------------------|-----------------|-----------------|------------------------|------------------------------------|
| 1 | `frontend-design` | `anthropics/skills` | `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` | Apache-2.0 | **ADAPT + WRAP** | Anti-generic UI reasoning, typography & visual hierarchy | Web (Admin) & Cross-platform UI concepts | Generic color palettes, LTR default | Local only; zero network | Yes / Yes / Yes |
| 2 | `skills.sh/topic/design` | `https://www.skills.sh/topic/design` | N/A (Web Catalog) | N/A | **REJECT / NON-INSTALLABLE** | Topic aggregator / index catalog | Reference only (outside repo) | N/A | N/A | N/A |
| 3 | `web-design-guidelines` | `vercel-labs/agent-skills` | `063bee94c3f4df8453406c830b0a7df0f2860278` | MIT / Apache-2.0 | **ADAPT + WRAP (ADOPT WEB)** | Static checks against web interface best practices | Admin Web App only (`admin-app/`) | Next.js/Vercel platform bias, no RTL/Arabic rules | Local only; zero network | Yes / Yes / Yes |
| 4 | `vercel-composition-patterns` | `vercel-labs/agent-skills` | `063bee94c3f4df8453406c830b0a7df0f2860278` | MIT / Apache-2.0 | **ADAPT + WRAP (ADOPT REACT)** | React compound components, hook composition | Admin Web App React components | Flutter architecture clash if misused | Local only; zero network | Yes / Yes / Yes |
| 5 | `ui-ux-pro-max` | `nextlevelbuilder/ui-ux-pro-max-skill` | `09170eec67eefd46a7ae85de61b40c194020f997` | MIT | **ADAPT + WRAP** | Searchable UI/UX database (styles, stacks, charts, UX) | Advisory inspiration queries across all apps | Rigid 44px touch min, 12px min text, `--persist` writes tokens | Local only; Python runtime; strip `${CLAUDE_PLUGIN_ROOT}` | Yes / Yes / Yes |
| 6 | `sleek-design-mobile-apps` | `sleekdotdesign/agent-skills` | `aa88b4dc5b2e35def6e3a89df85a6461af66a4d0` | MIT | **REJECT / EXTERNAL SANDBOX** | Mobile screen generator via external API | Excluded from default product routing | Proprietary UI taste, bypasses KONFRM DF2 tokens | Requires `SLEEK_API_KEY`, external HTTP calls to `sleek.design` | Rejected from auto paths |
| 7 | `canvas-design` | `anthropics/skills` | `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` | Apache-2.0 | **EXTERNAL SANDBOX** | HTML5 Canvas visual art, poster generation | Brand/Marketing artwork exploration only | Not suitable for transactional Flutter/React UI | Local only; zero network | Sandbox manual only |
| 8 | `impeccable/polish` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Surface fit, finish, spacing, micro-polish | All apps (Customer, Owner, Admin) | Default web heuristics override DF2 spacing | Local markdown playbook; no binary execution | Yes / Yes / Yes |
| 9 | `impeccable/critique` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Design system & ergonomics review playbook | All apps (Customer, Owner, Admin) | Assumes LTR by default; requires RTL overlay | Local markdown playbook; no binary execution | Yes / Yes / Yes |
| 10 | `impeccable/bolder` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (PERMISSION-GATED)** | Radical visual distinction, contrast elevation | Founder/Spec authorized marketing only | Clashes with restrained operational utility | Local markdown playbook | Gated: Founder approval |
| 11 | `impeccable/delight` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (PERMISSION-GATED)** | Emotional design, micro-moments | Founder/Spec authorized completion states | Decorative clutter, slows transactional paths | Local markdown playbook | Gated: Founder approval |
| 12 | `impeccable/distill` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Simplification, decluttering, high density | All apps (Customer, Owner, Admin) | Strong alignment with KONFRM high density | Local markdown playbook | Yes / Yes / Yes |
| 13 | `impeccable/quieter` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Restraint, visual hierarchy quieting | All apps (Customer, Owner, Admin) | Strong alignment with KONFRM calm clarity | Local markdown playbook | Yes / Yes / Yes |
| 14 | `extract-design-system` | `arvindrk/extract-design-system` | `1873741ba8dea755e35e6e15134f7918cd58e036` | MIT | **EXTERNAL SANDBOX** | Web scraping & CSS token extraction | Scratch research only; never in production pipeline | Generated tokens could clobber `DESIGN_SYSTEM/` | Requires Playwright/Chromium execution | Sandbox manual only |
| 15 | `design-taste-frontend` | `leonxlnx/taste-skill` | `ce26fc25c0e5e8cab638f883de62d9a86ee5e45b` | MIT | **EXTERNAL SANDBOX** | Editorial & landing page taste exploration | Marketing & landing page scratch exploration | Incompatible with transactional application flows | Local only; zero network | Sandbox manual only |
| 16 | `high-end-visual-design` | `leonxlnx/taste-skill` | `ce26fc25c0e5e8cab638f883de62d9a86ee5e45b` | MIT | **REJECT FOR KONFRM PRODUCT UI** | Sprawling cinematic luxury agency layout | Excluded from product applications | Low information density, dark slabs, anti-operational | Local only | Rejected from product UI |
| 17 | `emil-design-eng` | `emilkowalski/skills` | `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128` | MIT | **ADAPT + WRAP** | Interaction craft, tactile motion, animation | Customer & Owner Mobile, Admin Web | Hardcoded duration numbers, motion clutter | Local only; zero network | Yes / Yes / Yes |

---

## 3. Forensic Analysis by Source

### 1. `anthropics/skills/frontend-design`
- **Source:** `github.com/anthropics/skills` / `skills/frontend-design/SKILL.md`
- **Revision:** `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` (Apache-2.0)
- **Forensic Assessment:** Provides superior anti-generic layout heuristics, warning against cookie-cutter templates, arbitrary cards, and uniform spacing. Strongly beneficial when ideating screens.
- **Canon Conflict:** Tends to invent bold, expressive color palettes and assumes LTR reading order.
- **Governing Guardrail:** Wrapped via `frontend-design-wrapper`. Color palette must strictly adhere to KONFRM Black/White core, `#276EF1` candidate interaction role, and Arabic-first RTL.

### 2. `skills.sh/topic/design`
- **Source:** `https://www.skills.sh/topic/design`
- **Forensic Assessment:** This is a public aggregator page on `skills.sh` grouping design-tagged skills. It is not an individual git repository or installable agent skill.
- **Disposition:** Excluded from installation; catalog reference only.

### 3. `vercel-labs/agent-skills/web-design-guidelines`
- **Source:** `github.com/vercel-labs/agent-skills` / `skills/web-design-guidelines/SKILL.md`
- **Revision:** `063bee94c3f4df8453406c830b0a7df0f2860278` (MIT / Apache-2.0)
- **Forensic Assessment:** High-quality static checklist for web performance, accessibility, DOM size, and web typography.
- **Canon Conflict:** Confined strictly to web; does not apply to Flutter mobile apps. Contains zero Arabic/RTL guidance.
- **Governing Guardrail:** Wrapped via `vercel-web-guidelines-wrapper`. Activated solely for `admin-app/` web reviews.

### 4. `vercel-labs/agent-skills/vercel-composition-patterns`
- **Source:** `github.com/vercel-labs/agent-skills` / `skills/composition-patterns/SKILL.md`
- **Revision:** `063bee94c3f4df8453406c830b0a7df0f2860278` (MIT / Apache-2.0)
- **Forensic Assessment:** Excellent architectural patterns for React component composition, compound components, and prop drilling mitigation.
- **Canon Conflict:** Applicable strictly to React. Must not be applied to Flutter widget tree composition.
- **Governing Guardrail:** Wrapped via `vercel-composition-wrapper`. Scope confined to `admin-app/src/components/`.

### 5. `nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max`
- **Source:** `github.com/nextlevelbuilder/ui-ux-pro-max-skill` / `src/ui-ux-pro-max/`
- **Revision:** `09170eec67eefd46a7ae85de61b40c194020f997` (MIT)
- **Forensic Assessment:** Contains an extensive BM25 search engine querying CSV catalogs across 79 styles, 192 palettes, 74 font pairings, and 119 UX guidelines.
- **Canon Conflict:**
  1. Enforces generic web numbers (e.g. universal 44×44px touch target, 12px min text) that contradict KONFRM DF2 mobile ergonomics.
  2. The script command includes a dangerous `--persist` flag that outputs a `design-system/` directory in the repository, threatening canonical `DESIGN_SYSTEM/` integrity.
  3. Relies on `${CLAUDE_PLUGIN_ROOT}` in invocation examples.
- **Governing Guardrail:** Wrapped via `ui-ux-pro-max-wrapper`. The wrapper provides a portable local search runner, explicitly bans `--persist`, and declares all numeric suggestions subordinate to DF2 tokens.

### 6. `sleekdotdesign/agent-skills/sleek-design-mobile-apps`
- **Source:** `github.com/sleekdotdesign/agent-skills` / `skills/design-mobile-apps/SKILL.md`
- **Revision:** `aa88b4dc5b2e35def6e3a89df85a6461af66a4d0` (MIT)
- **Forensic Assessment:** Acts as a thin client querying external commercial SaaS (`https://sleek.design/api/...`) requiring `SLEEK_API_KEY` ($49.99/month).
- **Security & Canon Risk:** Sends project code and screen descriptions over the internet to an external server. Bypasses local token governance.
- **Disposition:** Strictly REJECTED. Never installed in any agent path.

### 7. `anthropics/skills/canvas-design`
- **Source:** `github.com/anthropics/skills` / `skills/canvas-design/SKILL.md`
- **Revision:** `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` (Apache-2.0)
- **Forensic Assessment:** Generates rich 2D canvas artwork, posters, and generative graphic compositions.
- **Canon Conflict:** Irrelevant to transactional real-estate booking, dispute resolution, or payout workflows.
- **Disposition:** EXTERNAL SANDBOX only. Never auto-routed in product workflows.

### 8–13. `pbakaus/impeccable/*` (Consolidated Core)
- **Source:** `github.com/pbakaus/impeccable` / `skill/reference/*.md`
- **Revision:** `c74755d920985f7a92cef691ca970ba95f90126e` (Apache-2.0)
- **Forensic Assessment:** Upstream packages 6 distinct sub-commands (`polish`, `critique`, `bolder`, `delight`, `distill`, `quieter`) representing markdown reference playbooks in a single repository. The repository also contains unreviewed binary hooks (`.codex/hooks.json`, rust binaries) which must not be executed.
- **Canon Assessment:**
  - `polish`, `critique`, `distill`, `quieter`: Highly aligned with craftsmanship, decluttering, and density.
  - `bolder`, `delight`: Introduce emotional design, gamification, and high variance that risk distracting from financial transparency and transactional clarity.
- **Governing Guardrail:** Wrapped via `impeccable-wrapper`. Consolidates the playbooks into safe, local markdown references. Explicitly permission-gates `bolder` and `delight` (requires Founder approval). Completely disables all automated binary hooks.

### 14. `arvindrk/extract-design-system`
- **Source:** `github.com/arvindrk/extract-design-system`
- **Revision:** `1873741ba8dea755e35e6e15134f7918cd58e036` (MIT)
- **Forensic Assessment:** Runs Playwright to launch a headless browser against live URLs to harvest CSS tokens.
- **Canon Conflict:** KONFRM already possesses an established, governed design system (`DESIGN_SYSTEM/TOKENS/`). Automated scrapers could corrupt canonical tokens.
- **Disposition:** EXTERNAL SANDBOX for competitive research only. Prohibited from writing to repository token paths.

### 15. `leonxlnx/taste-skill/design-taste-frontend`
- **Source:** `github.com/leonxlnx/taste-skill` / `skills/taste-skill/`
- **Revision:** `ce26fc25c0e5e8cab638f883de62d9a86ee5e45b` (MIT)
- **Forensic Assessment:** Tailored for portfolio pages, brand landing pages, and creative web experiences.
- **Canon Conflict:** Uses low-density spacing and decorative typography unsuitable for operational dashboards and high-density mobile apps.
- **Disposition:** EXTERNAL SANDBOX for marketing/landing page exploration only.

### 16. `leonxlnx/taste-skill/high-end-visual-design`
- **Source:** `github.com/leonxlnx/taste-skill`
- **Revision:** `ce26fc25c0e5e8cab638f883de62d9a86ee5e45b` (MIT)
- **Forensic Assessment:** Enforces luxury agency visual tropes: massive empty viewports, dark slate slabs, low-contrast subtle gray text, and oversized editorial hero headings.
- **Canon Conflict:** Directly violates KONFRM principles: white/light surfaces, high useful density, high contrast, and operational clarity.
- **Disposition:** Strictly REJECTED for KONFRM product UI.

### 17. `emilkowalski/skills/emil-design-eng`
- **Source:** `github.com/emilkowalski/skills` / `skills/emil-design-eng/SKILL.md`
- **Revision:** `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128` (MIT)
- **Forensic Assessment:** World-class guidance on tactile UI, physical interaction modeling, interruptible gestures, and snappy micro-feedback.
- **Canon Conflict:** Hardcoded timing values (e.g. 200ms, spring constants) must not override KONFRM motion tokens, nor should animations delay core user actions.
- **Governing Guardrail:** Wrapped via `emil-wrapper`. Treats timing as advisory candidate values. Prohibits blocking animations on transactional booking and payout paths.

---

## 4. Multi-Agent Installation & Distribution Topology

KONFRM supports three active AI engineering agents:
1. **Codex**: Discovers skills in `.agents/skills/<skill-name>/SKILL.md` (or repo-root `skills/`).
2. **Antigravity**: Discovers skills in `.agents/skills/<skill-name>/SKILL.md` (project-local) and global `~/.gemini/antigravity/skills/`.
3. **ZCode**: Discovers skills in `.zcode/skills/<skill-name>/SKILL.md`.

### Single Source of Truth
To prevent drift, all canonical skills and wrappers are authored once in:
`docs/ai/skills/`

A deterministic synchronization script (`scripts/sync-agent-skills.mjs`) distributes these skills into project-local directories using explicit file copies (`--copy` principle, zero symlinks):
- `docs/ai/skills/*` → `.agents/skills/*` (Servicing Codex & Antigravity)
- `docs/ai/skills/*` → `.zcode/skills/*` (Servicing ZCode)

```
                            docs/ai/skills/ (Source of Truth)
                                   |
                     +-------------+-------------+
                     |                           |
             .agents/skills/              .zcode/skills/
        (Codex & Antigravity)                 (ZCode)
```

### Security & Hook Sandbox Guarantee
- **Zero Binary Hooks:** No `.codex/hooks.json` or pre-execution binaries are permitted.
- **Zero Auto-Execution:** All skills are static instruction documents (`SKILL.md`) and deterministic local helper scripts.
- **Zero External Egress:** No skill makes outbound HTTP requests during agent workflows.

---

## 5. Usage Reporting Specification

Any AI agent performing design or UI tasks on the KONFRM codebase MUST append the following standardized reporting block to its output:

```markdown
### KONFRM DESIGN SKILL USAGE REPORT
- DESIGN_SKILLS_USED: [list installed skills used, e.g., konfrm-design-router v1.0, konfrm-mobile-design v1.0]
- DESIGN_SKILLS_NOT_USED: [list evaluated skills that were excluded, with rationale]
- CANON_CONFLICTS: [explicit list of external vs KONFRM conflicts detected and how resolved]
- EVIDENCE_VS_CANON: [distinction between advisory external inputs and canonical decisions taken]
- VISUAL_QA: [viewports tested (360/390/430), component states verified, RTL mirrored check status]
```
