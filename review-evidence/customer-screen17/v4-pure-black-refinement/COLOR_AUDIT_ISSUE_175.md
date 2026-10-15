# KONFRM Repository-Wide Color Inventory & Pure-Black Audit (Issue #175)

**Date:** 2026-10-16  
**Auditor:** Antigravity  
**Governing Issue:** GitHub Issue #175 (Mandatory Pure-Black `#000000` Rule & Repository Audit)  
**Related Issues:** Issue #170 (Screen 17 Refinement), Issue #166 (Design Consistency)  
**Audit Policy:** Read-Only Inventory. No production or package mutations performed in this audit pass.

---

## 1. Executive Summary

Founder has issued a binding visual directive:
> **ALL UI ELEMENTS INTENDED TO BE BRAND BLACK MUST USE EXACT PURE BLACK `#000000`.**  
> Charcoal, dark navy, blue-black, and almost-black substitutions are NOT accepted.  
> Approved values: Hex `#000000`, Flutter `const Color(0xFF000000)` or `Colors.black`, CSS `#000000`, RGB `rgb(0, 0, 0)`.

In response, an exhaustive search was conducted across the entire codebase targeting near-black substitutes:
- Hex values: `#111827` (Tailwind Gray 900), `#0F172A` (Tailwind Slate 900), `#18181B` (Tailwind Zinc 900), `#09090B` (Tailwind Zinc 950), `#1F2937` (Tailwind Gray 800)
- Tailwind utility classes: `slate-900`, `slate-950`, `gray-900`, `gray-950`, `zinc-900`, `zinc-950`, `neutral-900`, `neutral-950`

### High-Level Metrics
- **Total near-black matches identified:** 563 matches across 5 subsystems.
- **Active Screen 17 Preview Runner (`tool/screen17_preview_runner.dart`):** **EXACTLY 0 near-black occurrences**. Remediated 100% to `#000000`.
- **Primary source of Web near-black:** Tailwind `slate-900` / `slate-950` / `#0F172A` legacy classes in React web applications (`customer-app`, `owner-app`, `admin-app`).
- **Primary source of Mobile near-black:** Historical Screen 14/15 preview runners and `ValidationReferenceOnly.text` in `konfrm_theme.dart`.

---

## 2. Match Breakdown by Pattern

| Target Pattern | Hex / Class Identity | Total Occurrences | Subsystems Found |
| :--- | :--- | :---: | :--- |
| `111827` | Tailwind Gray 900 hex | 100 | `mobile/apps` (98), `mobile/packages` (1), `DESIGN_SYSTEM` (1) |
| `0F172A` | Tailwind Slate 900 hex | 115 | `customer-app` (25), `owner-app` (3), `admin-app` (2), `DESIGN_SYSTEM` (85) |
| `18181B` | Tailwind Zinc 900 hex | 13 | `mobile/apps` (5), `DESIGN_SYSTEM` (8) |
| `09090B` | Tailwind Zinc 950 hex | 14 | `mobile/apps` (12), `DESIGN_SYSTEM` (2) |
| `1F2937` | Tailwind Gray 800 hex | 1 | `mobile/apps` (1) |
| `slate-900` | Tailwind Slate 900 utility | 292 | `customer-app` (130), `owner-app` (65), `admin-app` (81), `DESIGN_SYSTEM` (16) |
| `slate-950` | Tailwind Slate 950 utility | 28 | `customer-app` (26), `admin-app` (1), `DESIGN_SYSTEM` (1) |
| `gray-900` / `950` | Tailwind Gray utility | 0 | None |
| `zinc-900` / `950` | Tailwind Zinc utility | 0 | None |
| `neutral-900` / `950`| Tailwind Neutral utility | 0 | None |
| **Total** | | **563** | |

---

## 3. Subsystem Detailed Analysis

### 3.1 Customer Mobile Flutter (`mobile/apps/customer_app/`)
- **Active Screen 17 Runner (`tool/screen17_preview_runner.dart`):** **0 occurrences**. Remediated 48 prior `#111827` occurrences directly to `const Color(0xFF000000)`.
- **Active Screen 17 Tests (`test/screen17_source_linked_tests.dart`):** **0 occurrences**.
- **Historical Screen Preview Runners (Immutable per Issue #155):**
  - `tool/screen14_preview_runner_v3_corrective.dart`: 48 occurrences of `Color(0xFF111827)` (Historical evidence baseline).
  - `tool/screen14_preview_runner_v3_final.dart`: 48 occurrences of `Color(0xFF111827)` (Historical evidence baseline).
  - `tool/screen15_preview_runner.dart`: 16 occurrences of `Color(0xFF09090B)` / `Color(0xFF18181B)`.
  - `tool/screen16_preview_runner.dart`: 1 occurrence of `Color(0xFF111827)`, 2 of `Color(0xFF09090B)`.
- **Production Flutter Code (`mobile/apps/customer_app/lib/`):**
  - `lib/features/account/presentation/account_view.dart`: 1 occurrence of `Color(0xFF111827)` on line 124 (placeholder profile text).

### 3.2 Mobile Shared Packages (`mobile/packages/konfrm_design_system/`)
- **File:** `lib/src/theme/konfrm_theme.dart` (Line 95):
  - `static const Color text = Color(0xFF111827);` inside `ValidationReferenceOnly`.
  - Note: `KonfrmColors.primary` is already defined correctly as `const Color(0xFF000000)` on line 85.
  - Action deferred to design-token governance task to update `ValidationReferenceOnly.text` to `#000000`.

### 3.3 Customer Web Application (`customer-app/src/`)
- **Total near-black occurrences:** 181
  - `slate-900`: 130 occurrences (headings, card titles, button labels, modal headers).
  - `slate-950`: 26 occurrences (high-emphasis badges, dark borders).
  - `#0F172A`: 25 occurrences (raw hex in CSS / inline styles).
- **Primary Root Cause:** Legacy Tailwind slate palette configured during early web prototyping.
- **Recommended Remediation:** Configure Tailwind theme extension to map `primary-black: '#000000'` and systematically migrate `text-slate-900` / `bg-slate-900` intended for brand black to `text-black` / `bg-black`.

### 3.4 Owner Web Application (`owner-app/src/`)
- **Total near-black occurrences:** 68
  - `slate-900`: 65 occurrences (table headers, property card titles, drawer headings).
  - `#0F172A`: 3 occurrences.
- **Recommended Remediation:** Replace near-black operational typography with pure black `#000000` during Phase 5 Owner alignment.

### 3.5 Admin Web Application (`admin-app/src/`)
- **Total near-black occurrences:** 84
  - `slate-900`: 81 occurrences (data grid headers, audit logs, status badges).
  - `slate-950`: 1 occurrence.
  - `#0F172A`: 2 occurrences.
- **Recommended Remediation:** Replace dark slate in Admin desktop web during Phase 6 Admin alignment.

### 3.6 Design System Authority (`DESIGN_SYSTEM/`)
- **Total near-black occurrences:** 113
  - `#0F172A`: 85 occurrences (in Phase 4E/4F pilot CSS, token specs, and markdown reference tables).
  - `slate-900`: 16 occurrences (in pilot HTML/CSS reference classes).
  - `#18181B`: 8 occurrences (in pilot comparison notes).
  - `slate-950`: 1 occurrence.
  - `#09090B`: 2 occurrences.
  - `#111827`: 1 occurrence.
- **Note:** In Phase 4B/4C, exact primary black was formally standardized as `#000000` (`SYSTEM-VALIDATED PROVISIONAL EXACT PRIMARY BLACK`), but earlier pilot documentation retained `#0F172A` as a rendering reference.

---

## 4. Preservation of Semantic Grays

Per Issue #175 and Founder design rules:
- **True Neutrals and Grays are PRESERVED**:
  - Secondary text / subtitles: `#4B5563` (Gray 600), `#6B7280` (Gray 500)
  - Subtle borders / dividers: `#E5E7EB` (Gray 200), `#F3F4F6` (Gray 100)
  - Placeholder icons / chevrons: `#9CA3AF` (Gray 400)
  - Light surface canvas: `#F9FAFB` (Gray 50)
- The `#000000` mandate applies strictly to **elements intended to be black** (screen titles, primary CTAs, active icons, unread text, primary typography), ensuring Cairo typographic hierarchy and soft canvas contrast are preserved.

---

## 5. Next Steps for Repository Migration

1. **Screen 17 Baseline:** Completely clean and pure `#000000` validated.
2. **Phase 4 Token Formalization:** Update `mobile/packages/konfrm_design_system/lib/src/theme/konfrm_theme.dart` line 95 to `#000000` under token maintenance.
3. **Web Applications Pass:** Schedule a focused search-and-replace PR for `customer-app/`, `owner-app/`, and `admin-app/` replacing `text-slate-900` / `bg-slate-900` with pure black `#000000` when those applications are opened for execution.
