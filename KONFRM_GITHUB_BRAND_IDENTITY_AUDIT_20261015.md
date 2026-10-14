# KONFRM — GitHub Brand Identity Integrity Audit

**Audit date:** 2026-10-15 (Africa/Cairo). **Repository:** `Essxm01/KONFRM`. **Verified `main` SHA:** `f6911eeecfa100cbbfec935e15769e66966ce835`.
**Scope:** read-only inspection of official design foundation, logos, tokens, Flutter shared Theme/navigation, latest Founder decisions, cross-role guidelines and recent approved native design evidence. This document is an **audit / anti-drift registry**, NOT a new Design System canonical token release, a brand redesign, an implementation command, or an authorization to recolor Owner/Admin/Web.

## Executive verdict

**PARTIALLY CONSOLIDATED — FOUNDERSHIP INTENT SAFE, MAIN SOURCE CONSISTENCY NOT YET RECONCILED.**

The brand identity is **preserved** on GitHub in canonical black/white assets and the mobile foundation, and newer Founder color decisions are saved in the Bridge GitHub document/Issue #123/#148. However, **not all text/token/runtime files on `main` currently express that same latest Customer visual direction**. A naive AI agent reading old Customer master UX or legacy Web JSON as native-mobile authority can incorrectly recreate blue-dominant UI. A full 'everything in GitHub is up to date and correct' claim would be FALSE.

## 1. VERIFIED positive identity anchors on MAIN

| Axis | Main GitHub evidence | Accurate interpretation |
| --- | --- | --- |
| Name | `DESIGN_SYSTEM/README.md`: **KONFRM / كونفرم** | Product identity documented correctly; legacy SOLA identifiers in historical/infrastructure contexts do not redefine product name. |
| Brand symbol | `DESIGN_SYSTEM/ASSETS/brand/konfrm-symbol-black.svg` and `konfrm-symbol-white.svg` | Exact designated standalone geometric mark assets are present. Neither a new hand-drawn icon nor added wordmark should silently replace the approved presentation. |
| Wordmark & lockup | `DESIGN_SYSTEM/ASSETS/brand/konfrm-wordmark-black.svg`, `konfrm-wordmark-white.svg`, `konfrm-lockup-black.svg`, `konfrm-lockup-white.svg`; `customer-app/public/konfrm-symbol-black.svg` and `konfrm-wordmark-black.svg` | Brand assets exist for appropriate use. **Presence of asset is NOT approval to show the English wordmark on every header.** Correct application depends on approved screen family. |
| Overall mobile color direction | `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` v1.7 §9 states **mobile Black/White brand, black primary action, no saturated blue brand identity; blue demoted to optional restrained interaction** | Governing modern foundation correctly records primary monochrome identity; `#276EF1` is still a CANDIDATE, not blanket permission. |
| Typography | `DESIGN_SYSTEM/TOKENS/typography.json`, `DESIGN_SYSTEM/GUIDELINES/typography.md`, `mobile/packages/konfrm_design_system/lib/src/theme/konfrm_theme.dart`, `.../pubspec.yaml` | Cairo is the UI family in docs and implemented native shared theme; Arabic-first; typography values in mobile are provisional. |
| RTL and Western numeric output | `DESIGN_SYSTEM/GUIDELINES/rtl.md`, `.agents/skills/konfrm-design/references/rtl_content.md` | RTL default, logical right Back versus left-chronological arrow, isolated LTR IDs, Western `0–9` dates/amounts. |
| Visual comfort | `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` §§6–8, `.agents/skills/konfrm-design/references/visual_system.md` and `DESIGN_SYSTEM/TOKENS/spacing.json` | Useful information density, meaningful white-space relationships, no Card Soup; micro 4/8, within groups 8/12, between groups 16/24, large boundary 24/32 candidate hierarchy. Not license to change finalized tokens on the fly. |
| Cross-role family | `DESIGN_SYSTEM/GUIDELINES/roles.md`, `.agents/skills/konfrm-design/references/role_experience.md`, `DESIGN_SYSTEM/GOVERNANCE.md` | Customer premium hospitality editorial (mobile); Owner action-first grouped operations (mobile); Admin high-signal, auditable desktop. **One brand identity ≠ identical page layout/tab navigation/data density.** |
| Founder anti-yellow | `DESIGN_SYSTEM/GOVERNANCE.md`, latest MR-17 and mobile foundation | No yellow/amber/orange boxed surfaces or fake urgency. Real semantic error/success/warning signals still accessible. |
| Actual native black primary | `mobile/packages/konfrm_design_system/lib/src/theme/konfrm_theme.dart` defines `KonfrmColors.primary = 0xFF000000`, Cairo font. | Confirmed primary black in current shared native theme (not proof every UI screen honors it). |

## 2. VERIFIED conflicts and drift exposures on MAIN — not safely 'all correct'

**C1 HIGH — Old Web palette disguised as global mobile authority:** `DESIGN_SYSTEM/TOKENS/colors.json` brand.primary is still `#0059FF` and explicitly describes it for 'Primary action, active selection and focus'; `brand.accent = #FFD700`; `border.focus` and semantic info colors also carry blue. **This JSON is an existing Web/legacy governed baseline; do NOT delete or mass recolor it**, as Foundation §9 explicitly says Web tokens remain untouched until governed migration. However, an AI agent must NOT apply brand.primary from this file to NEW Customer Flutter primary buttons. The file's generic label `authority: DESIGN_SYSTEM/` without platform-qualified mobile override makes mistaken consumption possible.

**C2 HIGH — Customer UX text contradicts newer Founder instructions:** `DESIGN_SYSTEM/EXPERIENCE/CUSTOMER_PHASE5_MASTER_UX.md` says current active bottom-navigation uses Blue icon + Blue label `#0059FF` (approx line 76), and general `KONFRM Blue #0059FF` / Summer Yellow micro accent near lines 139–145. These remain useful for screen map and behavior, but the conflicting COLORS are historical and NOT the latest Customer mobile visual authority.

**C3 HIGH — Directly active mobile Theme has implicit blue propagation risk:** In `mobile/packages/konfrm_design_system/lib/src/theme/konfrm_theme.dart`, `KonfrmColors.primary` is black but `ValidationReferenceOnly.interaction = 0xFF276EF1` is mapped to `ColorScheme.secondary`, `inversePrimary`, and other secondary/tertiary semantics. Marked reference-only provisional; Material widget defaults may nevertheless produce blue when not explicitly themed. This is an **actual source path risk**, not proof any particular released screen currently shows it. Mitigation: every NEW isolated Customer visual task checks native active nav, selected/focused controls and screenshots for unintended default blue, without global theme changes until an approved design-system reconciliation.

**C4 MEDIUM — Historical Founder summary says blue is primary:** `DESIGN_SYSTEM/FOUNDER_EXPERIENCE_REVIEW_AR.md` at section 1 says `الأزرق هو اللون الأساسي` and lists that as previously approved. Preserve as historical decision evidence only; **explicitly superseded in Customer native by Founder Oct-13 near-monochrome override**, and mobile foundation. Do not rewrite historical decisions as if they never existed.

**C5 MEDIUM — Button radii & platform separation not fully reconciled:** `DESIGN_SYSTEM/TOKENS/radius.json` is Web baseline with 12px control and 16px cards; skill `visual_system.md` says 6px primary CTA / 8px fields / 12px outer containers, all PROVISIONAL. Founder Issue #139 holds unresolved exact shared mobile primary radius 8px vs 10px in recent prototypes. Do NOT canonize one arbitrary number or silently normalize all screen families. Review actual approved sibling screenshots and wait Founder/system approval.

**C6 MEDIUM — Latest Founder overrides are on a separate documented handoff branch/Issues, NOT merged into authoritative `main` tokens.** Document [Founder Customer Monochrome Override](https://github.com/Essxm01/KONFRM/blob/docs/cross-account-recovery-20261013/KONFRM_BRIDGE_CUSTOMER_MONOCHROME_COLOR_DIRECTION_20261014.md) explicitly records near-zero blue, but source docs on `main` have unresolved conflicts. Official Issue [#148](https://github.com/Essxm01/KONFRM/issues/148) tracks reconciliation. This means 'written somewhere on GitHub' ≠ 'every automated design-token consumer now uses it'.

## 3. EXACT highest-precedence Founder visual directive, by scope

**Current native Customer only:** strongest visual direction is BLACK / WHITE / MUTED GREY FIRST and **NEAR-ZERO PROMINENT BLUE**. Historical saturated `#0059FF` must NEVER be interpreted as Customer mobile CTA, selected chip, date-range fill, link/callout or payments-status palette. Black primary action, white/light background, neutral gray supporting surfaces, Cairo/Arabic RTL/Western 0–9, meaningful groups & optical breathing room. Real property photos have their own natural colors. Restrained semantics such as error, destructive, success, favorites and necessary accessible focus preserve truthful state, not arbitrary decorative colors.

**Older mobile foundation** retained a small interaction-blue CANDIDATE `#276EF1`; **Founder 2026-10-13 [Issue #123](https://github.com/Essxm01/KONFRM/issues/123) specifically withdraws prominent blue for Customer** even for selected region/unit chips and budget slider: selection black on white, grey unbounded inactive slider, black when actively limited. This newer directive governs these conflicts for the CURRENT Customer review program.

**Owner and Admin:** Share brand, Cairo, RTL, overall light-first and state-truth values, but keep governed role-specific design and palettes. NO unreviewed global recolor of Owner wallet, operational system or Admin Web. Admin is desktop-first, not a Flutter mobile app.

**Screen-family brand signature, not one same header everywhere:** Root Explore may use lone mark paired with an identity affordance, terminal Screen11 approved small centered lone mark, Screen12 root 'حجوزاتي' with native four-tab bottom bar, Screen13 nested full screen centered title + right RTL Back (no root bottom bar), Screen14 future nested payment. Adding random English KONFRM wordmark beside lone mark on one sibling screen is unjustified and violates visual consistency; header identity follows approved SCREEN FAMILY and exact canonical assets.

## 4. Prevent agent regression — actionable verification gates

1. Read **main** `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`, `DESIGN_SYSTEM/GOVERNANCE.md`, `.agents/skills/konfrm-design/SKILL.md` and approved actual role-specific native physical snapshots; THEN latest dated Founder Issue #123 and this decision register (not only old JSON).
2. Before every new Customer native screen prompt record `BRAND_SOURCE_PRECEDENCE`: matching role/screen family, canonical logo variant, Cairo/RTL, monochrome near-zero blue, no unsupported bright yellow, spacing tiers, locally provisional radius.
3. Report `COLOR_RESTRAINT_QA`: screenshot and element list for each use of non-neutral colors, native Theme default secondary blue check. `CROSS_SCREEN_VISUAL_CONSISTENCY_REPORT`: compare correct root/detail/terminal **sibling family**; `VISUAL_DENSITY_AND_SPACING_QA`: verify real Arabic line height, meaningful whitespace, 200% no clipping, first-fold and scrolled CTA, safe area.
4. No AI agent may autonomously change `DESIGN_SYSTEM/TOKENS/colors.json`, global Flutter `konfrm_theme.dart`, shared radius or Web/Owner/Admin palettes simply to satisfy Customer aesthetic guidance. Propose a narrowly scoped, Founder-authorized **platform-specific canonical documentation/token reconciliation** and run visual regression across all three roles first.
5. Full official design reconciliation should update obsolete Customer blue instructions on `main` **without rewriting or deleting historical evidence** and introduce explicit mapping boundary for Web tokens vs current Native Customer role. Keep Issue #148 OPEN until audited and approved.

## 5. Audit status and boundaries

**AUDIT COMPLETE / CANONICAL CONSISTENCY PARTIAL**. This file is saved in the continuity docs branch and can be consumed immediately by Bridge13+ and new ANTIGRAVITY prompts, but is **not itself a merge to main nor an acceptance of new native tokens**.
**NO CHANGES** made to `main`, app code, native Theme, token JSON, financial logic, production UI, Owner/Admin, deploy or backend. An explicit Founder-authorized separate governance correction will be needed for full source consolidation, once Screen14 in-flight work is not interrupted.

**Canonical outstanding reconciliation:** [#148](https://github.com/Essxm01/KONFRM/issues/148).