# KONFRM AI Design Skill Registry

**Status:** CANDIDATE — SKILL INTEGRATION GATE
**Version:** 1.1.0
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
- **ADAPT + WRAP**: High-value design intelligence or craftsmanship playbooks that contain generic web heuristics or conflicting defaults. They are wrapped in project-local KONFRM wrappers that enforce canon subordination and strip unportable, networked, or dangerous write assumptions.
- **EXTERNAL SANDBOX**: Exploratory, scraping, or artwork tools that may be invoked manually on isolated scratch environments, but are strictly excluded from default product UI routing and automated agent paths.
- **REJECT**: Tools requiring credentials to third-party network services that may transmit prompts or context externally, or enforcing aesthetics (such as sprawling, low-density luxury agency layouts) that directly contradict KONFRM core operational clarity.

---

## 2. Upstream Source Audit Matrix

| # | Skill / Source | Upstream Repository / URL | Commit SHA | License | KONFRM Classification | Primary Capability | Canonical Scope | Canon Conflicts | Network & Security Profile | Agent Discovery Status |
|---|----------------|---------------------------|------------|---------|-----------------------|--------------------|-----------------|-----------------|----------------------------|------------------------|
| 1 | `frontend-design` | `anthropics/skills` | `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` | Apache-2.0 | **ADAPT + WRAP** | Anti-generic UI reasoning, visual hierarchy | Web (Admin/Current apps) & Cross-platform concepts | Assumes LTR by default; colorful accent defaults | Local snapshot; zero network egress | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 2 | `skills.sh/topic/design` | `https://www.skills.sh/topic/design` | N/A (Web Catalog) | N/A | **REJECT / NON-INSTALLABLE** | Topic aggregator / index catalog | Reference only (outside repo) | N/A | N/A | N/A |
| 3 | `web-design-guidelines` | `vercel-labs/agent-skills` + `web-interface-guidelines` | `063bee94c3f4df8453406c830b0a7df0f2860278` + `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1` | guidelines: MIT; agent-skills: UNRESOLVED | **ADAPT + WRAP (ADOPT WEB)** | Static checks against web interface best practices | Admin Web App (`admin-app/`) & current Web apps | Next.js/Vercel platform bias, no RTL/Arabic rules | Local pinned snapshot; zero network egress; verbatim upstream skill removed | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 4 | `vercel-composition-patterns` | `vercel-labs/agent-skills` | `063bee94c3f4df8453406c830b0a7df0f2860278` | UNRESOLVED (provenance only) | **ADAPT + WRAP (ADOPT REACT)** | React compound components, hook composition | React Web codebases (`admin-app/`, current web) | Flutter architecture clash if misused | Local wrapper only; verbatim upstream skill removed; zero network | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 5 | `ui-ux-pro-max` | `nextlevelbuilder/ui-ux-pro-max-skill` | `09170eec67eefd46a7ae85de61b40c194020f997` | MIT (2024 Next Level Builder) | **ADAPT + WRAP** | Advisory searchable catalog & curated heuristic taxonomy | Advisory inspiration queries across all apps | Universal 44px/12px heuristics subordinate to DF2; runner blocks all write flags | Local runner; zero network egress; strict allowlist parser | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 6 | `sleek-design-mobile-apps` | `sleekdotdesign/agent-skills` | `aa88b4dc5b2e35def6e3a89df85a6461af66a4d0` | MIT | **REJECT / EXTERNAL SANDBOX** | Mobile screen generator via external service | Excluded from default product routing | Proprietary UI taste, bypasses KONFRM DF2 tokens | External network service requiring credentials; transmits prompts/context | AGENT_DOES_NOT_SUPPORT_PROJECT_SKILLS |
| 7 | `canvas-design` | `anthropics/skills` | `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` | Apache-2.0 | **EXTERNAL SANDBOX** | HTML5 Canvas visual art, poster generation | Brand/Marketing artwork exploration only | Not suitable for transactional Flutter/React UI | Local only; zero network | Sandbox manual only |
| 8 | `impeccable/polish` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Surface fit, finish, spacing, micro-polish | All apps (Customer, Owner, Admin) | Evaluated against DF2 semantic roles, not web tokens | Local markdown playbook; no binary execution | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 9 | `impeccable/critique` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Design system & ergonomics review playbook | All apps (Customer, Owner, Admin) | Assumes LTR by default; requires RTL overlay | Local markdown playbook; no binary execution | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 10 | `impeccable/bolder` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (PERMISSION-GATED)** | Radical visual distinction, contrast elevation | Founder/Spec authorized marketing only | Clashes with restrained operational utility | Local markdown playbook | Gated: Founder approval |
| 11 | `impeccable/delight` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (PERMISSION-GATED)** | Emotional design, micro-moments | Founder/Spec authorized completion states | Decorative clutter, slows transactional paths | Local markdown playbook | Gated: Founder approval |
| 12 | `impeccable/distill` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Simplification, decluttering, high density | All apps (Customer, Owner, Admin) | Strong alignment with KONFRM high density | Local markdown playbook | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 13 | `impeccable/quieter` | `pbakaus/impeccable` | `c74755d920985f7a92cef691ca970ba95f90126e` | Apache-2.0 | **ADAPT + WRAP (CONSOLIDATED)** | Restraint, visual hierarchy quieting | All apps (Customer, Owner, Admin) | Strong alignment with KONFRM calm clarity | Local markdown playbook | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |
| 14 | `extract-design-system` | `arvindrk/extract-design-system` | `1873741ba8dea755e35e6e15134f7918cd58e036` | MIT | **EXTERNAL SANDBOX** | Web scraping & CSS token extraction | Scratch research only; never in production pipeline | Generated tokens could clobber `DESIGN_SYSTEM/` | Requires Playwright/Chromium execution | Sandbox manual only |
| 15 | `design-taste-frontend` | `leonxlnx/taste-skill` | `ce26fc25c0e5e8cab638f883de62d9a86ee5e45b` | MIT | **EXTERNAL SANDBOX** | Editorial & landing page taste exploration | Marketing & landing page scratch exploration | Incompatible with transactional application flows | Local only; zero network | Sandbox manual only |
| 16 | `high-end-visual-design` | `leonxlnx/taste-skill` | `ce26fc25c0e5e8cab638f883de62d9a86ee5e45b` | MIT | **REJECT FOR KONFRM PRODUCT UI** | Sprawling cinematic luxury agency layout | Excluded from product applications | Low information density, dark slabs, anti-operational | Local only | Rejected from product UI |
| 17 | `emil-design-eng` | `emilkowalski/skills` | `d16ebe60d09a5ba2afcb7054ede9d0a10c9f6128` | MIT | **ADAPT + WRAP** | Interaction craft, tactile motion, animation | Customer & Owner Mobile, Admin Web | Hardcoded duration numbers, motion clutter | Local snapshot; zero network egress | INSTALLED_BUT_DISCOVERY_NOT_VERIFIED |

---

## 3. Forensic Analysis by Source

### 1. `anthropics/skills/frontend-design`
- **Source:** `github.com/anthropics/skills` / `skills/frontend-design/SKILL.md`
- **Revision:** `8a1541c4a3ffa5a20a5a91de0dcf3f0bab1d1ef4` (Apache-2.0)
- **Forensic Assessment:** Provides superior anti-generic layout heuristics, warning against cookie-cutter templates, arbitrary cards, and uniform spacing. Strongly beneficial when ideating screens.
- **Canon Conflict:** Tends to invent bold, expressive color palettes and assumes LTR reading order.
- **Governing Guardrail:** Wrapped via `frontend-design-wrapper`. Color palette must strictly adhere to KONFRM Black/White identity direction, `#276EF1` candidate interaction role, and Arabic-first RTL with logical start/end.

### 2. `skills.sh/topic/design`
- **Source:** `https://www.skills.sh/topic/design`
- **Forensic Assessment:** This is a public aggregator page on `skills.sh` grouping design-tagged skills. It is not an individual git repository or installable agent skill.
- **Disposition:** Excluded from installation; catalog reference only.

### 3. `vercel-labs/agent-skills/web-design-guidelines`
- **Source:** `github.com/vercel-labs/agent-skills` / `skills/web-design-guidelines/SKILL.md` + `github.com/vercel-labs/web-interface-guidelines`
- **Revisions:** `063bee94c3f4df8453406c830b0a7df0f2860278` + `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1`
- **Licenses:** `web-interface-guidelines`: MIT License, Copyright 2025 Vercel Labs (preserved at `docs/ai/licenses/VERCEL_WEB_INTERFACE_GUIDELINES_MIT.txt`); `agent-skills`: UNRESOLVED (no license file present in upstream repository tree at pinned commit).
- **Forensic Assessment:** High-quality static checklist for web performance, accessibility, DOM size, and web typography. Upstream fetches rules dynamically via HTTP from GitHub.
- **Resolution (Option 1):** Pinned exact commit `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1` and vendored a local snapshot of the documented MIT guidelines (`docs/ai/skills/vercel-web-guidelines-wrapper/vendor/web-interface-guidelines.md`). The verbatim `UPSTREAM_SKILL.md` from `agent-skills` has been removed to preserve a clean licensing boundary. Zero runtime network egress is guaranteed.
- **Canon Conflict:** Confined strictly to web; does not apply to future Flutter mobile apps.
- **Governing Guardrail:** Wrapped via `vercel-web-guidelines-wrapper`. Activated solely for `admin-app/` and current web reviews.

### 4. `vercel-labs/agent-skills/vercel-composition-patterns`
- **Source:** `github.com/vercel-labs/agent-skills` / `skills/composition-patterns/SKILL.md`
- **Revision:** `063bee94c3f4df8453406c830b0a7df0f2860278`
- **License:** UNRESOLVED (provenance only; file frontmatter states `license: MIT`, but the repository lacks an overall LICENSE file).
- **Forensic Assessment:** Excellent architectural patterns for React component composition, compound components, and prop drilling mitigation.
- **Resolution:** The verbatim `UPSTREAM_SKILL.md` has been removed. The wrapper (`docs/ai/skills/vercel-composition-wrapper/SKILL.md`) is a 100% KONFRM-authored specification that retains the upstream source coordinates as provenance.
- **Canon Conflict:** Applicable strictly to React. Future Flutter applications follow the separately governed Gate3B Flutter architecture; React composition guidance must not cross that boundary.
- **Governing Guardrail:** Wrapped via `vercel-composition-wrapper`. Scope confined to React web components.

### 5. `nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max`
- **Source:** `github.com/nextlevelbuilder/ui-ux-pro-max-skill` / `src/ui-ux-pro-max/`
- **Revision:** `09170eec67eefd46a7ae85de61b40c194020f997`
- **License:** MIT License, Copyright 2024 Next Level Builder (preserved at `docs/ai/licenses/UI_UX_PRO_MAX_MIT.txt`).
- **Forensic Assessment:** Provides an advisory searchable catalog and curated heuristic taxonomy querying CSV catalogs across 79 styles, 192 palettes, 74 font pairings, and 119 UX guidelines. Individual records provide external craft suggestions, not verified empirical research or authoritative product decisions.
- **Canon Conflict:**
  1. Enforces generic web numbers (e.g. universal 44×44px touch target, 12px min text) that contradict KONFRM DF2 mobile ergonomics.
  2. The upstream script includes persistence flags (`--persist`, `--output-dir`, `--page`, `--force`) that output a `design-system/` directory in the repository, threatening canonical `DESIGN_SYSTEM/` integrity.
  3. Relies on `${CLAUDE_PLUGIN_ROOT}` in invocation examples.
- **Governing Guardrail:** Wrapped via `ui-ux-pro-max-wrapper`. The wrapper provides a safe runner (`docs/ai/skills/ui-ux-pro-max-wrapper/runner.py`) using a strict allowlist parser (`allow_abbrev=False`) that executes queries locally, permanently blocks all write/persistence flags, rejects abbreviation bypasses, and declares all suggestions non-canonical and subordinate to DF2 tokens. Agents are instructed never to invoke the underlying vendor script directly.

### 6. `sleekdotdesign/agent-skills/sleek-design-mobile-apps`
- **Source:** `github.com/sleekdotdesign/agent-skills` / `skills/design-mobile-apps/SKILL.md`
- **Revision:** `aa88b4dc5b2e35def6e3a89df85a6461af66a4d0` (MIT)
- **Forensic Assessment:** Sleek is an external network service requiring credentials and may transmit prompts/design context or other user-supplied material depending on invocation; therefore it is excluded from default KONFRM routing.
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
- **Governing Guardrail:** Wrapped via `impeccable-wrapper`. Consolidates the playbooks into safe, local markdown references. Explicitly permission-gates `bolder` and `delight` (requires Founder approval). Completely disables all automated binary hooks. Critiques evaluate mobile surfaces against DF2 semantic roles, while current web surfaces use web tokens as implementation baseline.

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
- **Forensic Assessment:** Guidance on tactile UI, physical interaction modeling, interruptible gestures, and snappy micro-feedback.
- **Canon Conflict:** Numeric durations and easing curves are candidates requiring component/device validation. Motion must never delay transactional work.
- **Governing Guardrail:** Wrapped via `emil-wrapper`. Treats timing as advisory candidate values. Prohibits blocking animations on transactional booking and payout paths.

---

## 4. Governed Internal Skills Suite

In addition to wrapped external sources, KONFRM maintains a suite of 8 project-local, governed internal skills authored in `docs/ai/skills/` (14 governed skill directories in total: 8 internal + 6 governed wrappers):

| # | Internal Skill | Primary Mandate & Scope | Governed Reference |
|---|----------------|-------------------------|--------------------|
| 1 | `konfrm-design-router` | Master design triage, classification, minimal activation, external skills debate management, Design Court escalation | `docs/ai/skills/konfrm-design-router/SKILL.md` |
| 2 | `konfrm-design-reasoning` | Human-centered perceptual decision layer, 12-step decision loop, Hypotheses A/B/C, micro-validation planning | `docs/ai/skills/konfrm-design-reasoning/SKILL.md` |
| 3 | `konfrm-product-ux` | Role-specific UX mandates (Customer request flow, Owner certainty, Admin audit), truthful state grammar | `docs/ai/skills/konfrm-product-ux/SKILL.md` |
| 4 | `konfrm-mobile-design` | Future mobile/native architecture interpretation, platform ergonomics, candidate token safety | `docs/ai/skills/konfrm-mobile-design/SKILL.md` |
| 5 | `konfrm-rtl-arabic` | Arabic-first layout, logical start/end, Western Arabic numerals (0-9), bidirectional typography | `docs/ai/skills/konfrm-rtl-arabic/SKILL.md` |
| 6 | `konfrm-accessibility` | Web WCAG 2.2 AA baseline, platform-appropriate mobile accessibility criteria, touch targets, screen-reader semantics, reduced motion | `docs/ai/skills/konfrm-accessibility/SKILL.md` |
| 7 | `konfrm-visual-qa` | Multi-viewport regression testing, responsive breakpoint checks, screenshot validation protocols | `docs/ai/skills/konfrm-visual-qa/SKILL.md` |
| 8 | `konfrm-design-court` | Governed collaborative adjudication of materially ambiguous design decisions (specialist panel, synthetic role lenses, defender/challenger, red team, hard gates, consensus + minority opinion, Founder gate) | `docs/ai/skills/konfrm-design-court/SKILL.md` |

### 4.1 Design Court v1 (`konfrm-design-court`)

- **Mandate:** Advisory adjudication of materially unresolved design decisions. Governing principle: *prefer an honest unresolved verdict over a confident unsupported recommendation.*
- **Source:** `docs/ai/skills/konfrm-design-court/` — `SKILL.md` (orchestration contract) + `ROLES.md`, `DELIBERATION_PROTOCOL.md`, `PERSONA_PANEL.md`, `EVIDENCE_MODEL.md`, `VERDICT_TEMPLATE.md`, `TEST_CASES.md`, and `DESIGN_COURT_VALIDATION_REPORT.md` (test evidence only).
- **Router relationship:** Invoked only by `konfrm-design-router` escalation for materially unresolved decisions; routine work returns `COURT_NOT_REQUIRED`.
- **Design Reasoning relationship:** Orchestrates, does not replace, `konfrm-design-reasoning` (evidence quality, hypothesis discipline, micro-validation); adds multi-role adjudication, structured disagreement, persona lenses, red team, consensus classification and the Founder gate.
- **Modes:** `FAST_PANEL` (default for bounded choices) and `FULL_COURT` (system-level, architecture, cross-role, brand-language decisions). `FULL_COURT` is never the default.
- **Founder subordination:** Never replaces Founder authority; may emit only `ADVISORY` / `CANDIDATE` / `VALIDATED_CANDIDATE`; cannot promote Canon; preserves prior Founder decisions absent material new evidence.
- **Persona rule:** Personas are `SYNTHETIC_ROLE_LENS` instruments — synthetic persona opinion is not user research evidence.
- **Hard gates:** Product Truth, Business/Financial rules, security, applicable accessibility, platform impossibility, RTL correctness and architecture boundaries eliminate options before any consensus; a majority cannot override a hard-gate failure.
- **Attribution & topology honesty:** Every skill in a report is `CONSULTED` / `NOT_CONSULTED` / `UNAVAILABLE`; no fabricated positions or votes. `DELIBERATION_TOPOLOGY` is reported as `TRUE_MULTI_AGENT` or `SINGLE_AGENT_STRUCTURED_PANEL`; single-agent execution is never presented as multi-agent consensus.
- **Validation:** `scripts/test-design-court-contract.mjs` (deterministic, executed by `npm run ai:skills:check`).
- **Discovery status:** Thin shims generated in `.agents/skills/` and `.zcode/skills/`; runtime discovery not claimed (see §5).

---

## 5. Multi-Agent Installation & Thin Discovery Shim Architecture

KONFRM supports three target AI engineering agents:
1. **Codex**: Discovers skills via `.agents/skills/<skill-name>/SKILL.md` (or repo-root `skills/`).
2. **Antigravity**: Discovers project-local skills via `.agents/skills/<skill-name>/SKILL.md` and global `~/.gemini/antigravity/skills/`.
3. **ZCode**: Discovers skills via `.zcode/skills/<skill-name>/SKILL.md`.

### Single Source of Truth & Thin Shims (Bloat Prevention)
To eliminate PR bloat and duplicate vendor storage, all canonical skills, wrappers, and vendored datasets are authored **ONCE** in:
`docs/ai/skills/`

The agent discovery directories (`.agents/skills/` and `.zcode/skills/`) contain **ONLY thin discovery shims**:
- Each shim contains valid YAML frontmatter (`name`, `description`) so agents discover the skill in their catalog.
- The shim body points directly to the canonical repository-relative path: `docs/ai/skills/<skill-name>/SKILL.md`.
- Large vendored datasets (e.g. UI/UX Pro Max CSV catalogs) exist **strictly once** in `docs/ai/skills/ui-ux-pro-max-wrapper/vendor/` and are never copied to agent directories.

```
                           docs/ai/skills/ (Source of Truth ONCE)
                                   │
                     ┌─────────────┴─────────────┐
                     ▼                           ▼
              .agents/skills/             .zcode/skills/
             (Thin Shims Only)           (Thin Shims Only)
```

### Agent Discovery Verification Statuses
- **Codex:** `INSTALLED_BUT_DISCOVERY_NOT_VERIFIED`
  *Evidence:* Filesystem shims present in `.agents/skills/` with valid YAML frontmatter; runtime invocation requires active Codex session.
- **Antigravity:** `INSTALLED_BUT_DISCOVERY_NOT_VERIFIED`
  *Evidence:* Filesystem shims present in `.agents/skills/` with valid YAML frontmatter; workspace skill re-indexing requires session restart/reload.
- **ZCode:** `INSTALLED_BUT_DISCOVERY_NOT_VERIFIED`
  *Evidence:* Filesystem shims present in `.zcode/skills/` with valid YAML frontmatter; runtime invocation requires active ZCode environment.

### Security & Hook Sandbox Guarantee
- **Zero Binary Hooks:** No `.codex/hooks.json` or pre-execution binaries are permitted.
- **Zero Auto-Execution:** All skills are static instruction documents (`SKILL.md`) and deterministic local helper scripts.
- **Local-Only Execution:** All active routed skills execute from pinned local snapshots with zero runtime network egress.

---

## 6. Usage Reporting Specification: Dual-Mode Reporting

Any AI agent performing design or UI tasks on the KONFRM codebase MUST append the appropriate reporting block to its output:

### Mode A: FULL REPORT (for unresolved visual decisions, new primitives, or token architecture)
```markdown
### KONFRM DESIGN SKILL USAGE REPORT (FULL)
- TASK_CLASSIFICATION: [Role: Customer/Owner/Admin | Surface: Web/Future Mobile | Scope: Primitive/Language/Major Screen]
- DESIGN_SKILLS_USED: [list installed skills used, e.g., konfrm-design-router v1.0, konfrm-design-reasoning v1.0]
- DESIGN_SKILLS_NOT_USED: [list evaluated skills that were excluded, with rationale]
- DESIGN_HYPOTHESES_CONSIDERED: [competing hypotheses formulated (e.g., A vs B), or N/A]
- HUMAN_FACTORS_EVIDENCE: [empirical perception/ergonomic evidence cited, distinguishing real research from AI inference]
- TARGET_ROLE_REASONING: [specific customer/owner/admin cognitive lens applied]
- COUNTERARGUMENTS: [strongest critique or counterpoint considered against the chosen direction]
- CANON_CONFLICTS: [explicit list of external vs KONFRM conflicts detected and how resolved]
- EVIDENCE_VS_CANON: [distinction between advisory external inputs and canonical decisions taken]
- VALIDATION_NEEDED: [recommended micro-validation method (prototype, test, survey), or NONE]
- VISUAL_QA: [viewports tested or explicit NOT EXECUTED statement if simulation/routing only]
- COURT_USED: [YES | NO]
- COURT_MODE: [FAST_PANEL | FULL_COURT | N/A]
- COURT_OUTCOME: [Design Court outcome, or N/A]
- COURT_CONSENSUS: [consensus class, or N/A]
- FOUNDER_DECISION_REQUIRED: [YES | NO]
```

### Mode B: COMPACT REPORT (for routine fixes, literal bugs, typos, and known accessibility remediations)
```markdown
### KONFRM DESIGN SKILL USAGE REPORT (COMPACT)
- TASK_CLASSIFICATION: [Role | Surface | Scope: Bugfix/Alignment/Copy/Routine A11y]
- SKILLS_CONSULTED: [minimal internal/external skills consulted]
- GOVERNING_CANON: [relevant DF2 / Business Rules section]
- CANON_CHECK: [PASS — zero canon mutations or false promotions]
- VISUAL_QA: [tested viewports or explicit NOT EXECUTED statement]
```
