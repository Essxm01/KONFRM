# KONFRM Action System Governance Reconciliation Draft — Phase 4C Stage 3A

**Document Status:** `GOVERNANCE RECONCILIATION DRAFT & MIGRATION PLAN`  
**Governing Phase:** Phase 4C — Action System  
**Stage:** Stage 3A (Action Contract Formalization & Governance Reconciliation Draft)  
**Evidence Baseline:** Stage 2 Independently Verified PASS (Commit `f33674c902a4d2c63fcb5fd0fa6414851be5e7d2`)  
**Shared Authority Boundary:** This is an analytical and planning document. It does **not** edit shared authoritative Design System files (`DESIGN_SYSTEM/COMPONENTS/`, `DESIGN_SYSTEM/EXPERIENCE/`, `DESIGN_SYSTEM/TOKENS/`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`), does not modify `DECISIONS.json`, and does not promote provisional findings into Canon without explicit separate governance integration.

---

## 1. Executive Summary & Purpose

The purpose of Stage 3A Governance Reconciliation is to perform a rigorous **READ / COMPARE analysis** between:
1. The **current authoritative Design System documents and tokens** (which largely reflect the web prototype baseline and early DF2 v1.1 drafts), and
2. The **independently validated findings of Phase 4C Stages 1 & 2** (Founder-selected Stable Black `#000000`, 6px Primary Radius, Cairo Profile B `15px`, Contextual / Hierarchy-Based Hybrid Action Strategy, Conditional Neutral Outline, and the Action Group Reflow Contract).

Rather than silently overwriting legacy documents or prematurely forcing provisional values into production tokens, this document maps every point of tension, establishes clear platform scopes, and produces an actionable reconciliation matrix for future governed integration.

---

## 2. Master Governance Reconciliation Matrix

| Source File | Current Rule / Statement | Current Scope | Stage 2 / 3A Validated Result | Relation | Proposed Future Action (Stage 3B / Phase 4I) | Risk If Left Unchanged |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `COMPONENTS/buttons.md` (Line 7) | `Primary = brand.primary with inverse text` | Legacy Web authority (`brand.primary` = `#0059FF`) | Mobile Primary is **Stable Black (`#000000`)** (provisional candidate; blue demoted to accent). | **CLARIFY_SCOPE / SUPERSEDE (FOR MOBILE)** | Scope `brand.primary` to Web prototype only. Introduce mobile token `mobile.color.action.primary = #000000` in mobile token manifest. | High: Future Flutter engineers will render blue primary buttons, violating monochrome-first brand identity. |
| `COMPONENTS/buttons.md` (Line 3) | `All buttons use ... radius.control` | Web authority (`radius.control` = `12px` in `radius.json`) | Primary Button Radius is **`6px` (`PRIMARY_ONLY`)**. Secondary radius remains `OPEN`. | **SUPERSEDE (FOR MOBILE)** | Introduce `mobile.radius.button.primary = 6px`. Mark secondary radius as explicitly open. Prevent 12px pill inheritance on mobile. | High: Mobile buttons will render with 12px bubble corners, clashing with the validated 6px architectural geometry. |
| `COMPONENTS/buttons.md` (Line 3, Line 19) | `minimum 44px height/target on mobile` and `prefer a 48px touch area` | Legacy general mobile guidance | Platform-specific separation: **iOS: 44pt**, **Android: 48dp**. Separate visual geometry from interactive touch bounds. | **CLARIFY_SCOPE** | Update `buttons.md` to distinguish visual height from touch area and cite iOS 44pt / Android 48dp. Eliminate universal 48px raw pixel rule. | Medium: Overconstrains visual layout on compact screens while failing platform-native touch standards. |
| `COMPONENTS/buttons.md` (Lines 8–10) | `Secondary: surface.secondary`<br>`Outline: alternative or cancel`<br>`Ghost: tertiary` | Web discrete variant list | **Contextual / Hierarchy-Based Hybrid:** Subtle Fill is default neutral secondary; Conditional Neutral Outline is contrast-gated; Ghost is tertiary. | **SUPERSEDE (FOR MOBILE)** | Replace rigid discrete table with the semantic Action Role Model and Decision Tree from `ACTION_SYSTEM_CONTRACT_DRAFT.md`. | High: Designers will deploy Outline arbitrarily on white cards, producing visual border clutter. |
| `COMPONENTS/buttons.md` (Line 11) | `Destructive: semantic.danger only` | General single variant | **Destructive Hierarchy:** Destructive Outline for subordinate pairing; Destructive Primary for confirmation modals only; Destructive Ghost for tertiary. | **SUPERSEDE (FOR MOBILE)** | Expand destructive section to define Destructive Outline vs Destructive Primary confirmation gating. | High: Dangerous actions will be styled with solid red CTAs on top-level screens, creating panic and accidental triggers. |
| `COMPONENTS/buttons.md` (Line 13) | `Loading disables repeat submission while retaining an accessible label` | General web contract | Loading requires **multi-input activation suppression** (native `disabled` + `aria-busy` / platform equivalent) + distinct `0.85` opacity. | **CLARIFY_SCOPE** | Explicitly specify activation suppression for Space/Enter keys and distinct visual contrast from disabled (`0.45`). | High: Duplicate booking or payment API calls during slow network states. |
| `EXPERIENCE/ACTION_HIERARCHY.md` (Line 9) | `Secondary: Reversible/supporting action \| Secondary/outline treatment` | Cross-app experience guide | Secondary is **Subtle Fill by default**; Outline is reserved for low-contrast containers. | **SUPERSEDE (FOR MOBILE)** | Refine definition from "outline treatment" to "Contextual Hybrid (Subtle Fill default, Conditional Neutral Outline where needed)". | Medium: Semantic confusion leading to inconsistent secondary button styles across Customer and Owner. |
| `EXPERIENCE/ACTION_HIERARCHY.md` (Lines 20–21) | `Comfortable: ... >=44px target`<br>`Standard: ... >=44px target on mobile` | Cross-app control sizes | iOS 44pt / Android 48dp target separation; touch bounds separate from visible container. | **CLARIFY_SCOPE** | Replace raw `>=44px` with platform-appropriate units (`pt` on iOS, `dp` on Android). | Low: Platform engineering confusion regarding physical vs logical pixels. |
| `EXPERIENCE/DECISIONS.json` (`UX-ACTION-01`) | `State-aware action hierarchy: Only valid canonical-state actions are shown; decision-critical actions dominate, destructive actions are separated.` | Canonical UX Decision (`APPROVED_EXISTING`) | Validates and aligns perfectly with Phase 4C Stage 2 & 3A contract rules. | **KEEP / EXTENDS** | Retain `UX-ACTION-01` as active canonical parent. Propose future child decision `UX-ACTION-02` (Action Contract Formalization) upon Phase 4C closure. | None: Strong structural continuity. |
| `MOBILE_DESIGN_FOUNDATION.md` (§15, Line 288) | `PRIMARY — the one decision-critical action ... (restrained interaction-accent treatment — §9)` | Canonical Mobile Foundation (DF2 v1.1) | Primary CTA is **Stable Black (`#000000`)**, not blue. Blue `#276EF1` is demoted strictly to interaction accents/links. | **CLARIFY_SCOPE / REFINE** | Prepare DF2 v1.2 amendment aligning §15 Primary treatment with Founder Stable Black decision, preserving blue for non-primary accents. | High: New mobile developers reading DF2 v1.1 will attempt to implement blue primary buttons. |
| `TOKENS/colors.json` (Line 9) | `brand.primary: #0059FF` | Web color token authority | Web remains `#0059FF`. Mobile action primary candidate is `#000000`. | **CLARIFY_SCOPE** | Maintain `colors.json` for web legacy compatibility. Create isolated `TOKENS/mobile/` token namespace during Phase 4I. | Critical: Silently changing `brand.primary` would break existing web apps (`customer-app`, `owner-app`, `admin-app`). |
| `TOKENS/radius.json` (Line 3) | `radius.control: 12px` | Web radius token authority | Primary Button Radius is `6px (PRIMARY_ONLY)`. Secondary radius is `OPEN`. | **CLARIFY_SCOPE** | Preserve `radius.json` for web. Define `mobile.radius.button.primary = 6px` in mobile token space. | High: Incompatible corner rounding between web legacy and mobile design. |
| `TOKENS/typography.json` (Line 15) | `roles.button: fontSize: 14px, lineHeight: 1.4` | Web typography token authority | Cairo Profile B Button is **`15px / 700 / 1.20`** (System-Validated Provisional). | **CLARIFY_SCOPE** | Preserve web `typography.json`. Author mobile typography tokens reflecting Cairo Profile B values established in Phase 4B. | Medium: Text scaling and vertical alignment discrepancies on mobile buttons. |
| `GOVERNANCE.md` (Line 27) | `No yellow/amber/orange boxed UI (UX-COLOR-01)` | Active governance contract | Enforced in Stage 2 remediation: all Lab warning banners neutralized to white cards with subtle borders. | **KEEP / NO_CHANGE** | Reaffirm as non-negotiable cross-role visual rule. | None: Rule is fully verified and compliant. |

---

## 3. In-Depth Analysis of Mandatory Reconciliation Items

### Item 1: `buttons.md` — "Primary = brand.primary"
- **Current Text:** Line 7 of `buttons.md` specifies `brand.primary with inverse text` for the Primary variant.
- **Architectural Reality:** In `TOKENS/colors.json`, `brand.primary` is `#0059FF` (a legacy bright cobalt blue from the web prototype). In DF2 Amendment v1.1, the Founder established a monochrome-first mobile brand identity (Black/White). In Phase 4C Stage 1 & 2, the Founder evaluated four black candidates and formally selected **Pitch Black (`#000000`)** as the provisional Primary Button color.
- **Resolution Strategy:**
  - *Do NOT overwrite `brand.primary: #0059FF` in `colors.json`:* Doing so would cause immediate visual regression across the live web applications (`customer-app`, `owner-app`, `admin-app`).
  - *Platform Scoping:* `brand.primary: #0059FF` must be scoped explicitly as `PLATFORM: WEB_LEGACY`.
  - *Mobile Namespace:* Future mobile token generation must introduce `mobile.color.action.primary = #000000` (or `color.action.primary.black`).
  - *Relation:* `CLARIFY_SCOPE` for web; `SUPERSEDE` for future mobile architecture.

### Item 2 & 3: `buttons.md` — Mobile Minimum 44px & 48px Preferred Area
- **Current Text:** Line 3 says `minimum 44px height/target on mobile`. Line 19 says `For frequent Customer/Owner mobile controls, prefer a 48px touch area even though 44px remains the minimum`.
- **Architectural Reality:** This legacy wording confuses **visual component height** with **interactive touch target bounds**, and introduces a raw pixel value (`px`) that does not map cleanly to native mobile screen densities:
  - Apple iOS HIG mandates **`44pt × 44pt`** logical points.
  - Google Android Material 3 mandates **`48dp × 48dp`** density-independent pixels.
  - Setting a universal `48px` minimum visual height restricts design flexibility for compact operational controls and inline utility actions.
- **Resolution Strategy:**
  - Separate concerns: Visual component height (padding + font metrics) is decoupled from interactive hit target bounds.
  - Formally adopt platform guidance: iOS `44pt`, Android `48dp`.
  - In `buttons.md`, replace the raw `48px` preference with platform-specific touch target delegation: "Components ensure a minimum interactive hit area of 44pt on iOS and 48dp on Android, while allowing visual component geometry to adapt to density requirements."
  - *Relation:* `CLARIFY_SCOPE`.

### Item 4 & 5: `buttons.md` and `ACTION_HIERARCHY.md` — Secondary & Outline Descriptions
- **Current Text:** `buttons.md` lists `Secondary: surface.secondary with primary text` and `Outline: alternative or cancel action | transparent/primary surface with default border`. `ACTION_HIERARCHY.md` defines `Secondary: Reversible/supporting action | Secondary/outline treatment`.
- **Architectural Reality:** Lumping secondary actions into a generic "outline treatment" or presenting Outline as a standalone cosmetic variant encourages arbitrary visual usage (e.g., creating high-friction border soup on cards). Stage 2 validated that **Contextual / Hierarchy-Based Hybrid** is the true system grammar:
  - **Subtle Fill** is the default neutral secondary treatment across standard white surfaces.
  - **Neutral Outline** is strictly conditional, reserved for surfaces where Subtle Fill lacks contrast.
  - **Destructive Outline** is a dedicated danger secondary variant, not an arbitrary outline color.
  - **Ghost** serves tertiary and low-weight auxiliary needs.
- **Resolution Strategy:**
  - Modernize `buttons.md` and `ACTION_HIERARCHY.md` to reference the 7 semantic action roles defined in `ACTION_SYSTEM_CONTRACT_DRAFT.md`.
  - Supersede the legacy assumption that secondary actions are primarily "outline".
  - *Relation:* `SUPERSEDE (FOR MOBILE)`.

### Item 6: `ACTION_HIERARCHY.md` — Mobile `>=44px` Target Wording
- **Current Text:** Lines 20–21 specify `>=44px target on mobile` for Comfortable and Standard controls.
- **Architectural Reality:** As analyzed in Item 2, `>=44px` is a web heuristic. On iOS, 44pt is native. On Android, 48dp is native.
- **Resolution Strategy:**
  - Reconcile `ACTION_HIERARCHY.md` to state: "Meets platform touch target minimums (iOS 44pt / Android 48dp)".
  - *Relation:* `CLARIFY_SCOPE`.

### Item 7: `DECISIONS.json` — `UX-ACTION-01`
- **Current Text:**
  ```json
  { "id": "UX-ACTION-01", "title": "State-aware action hierarchy", "category": "actions", "status": "APPROVED_EXISTING", "recommendation": "Only valid canonical-state actions are shown; decision-critical actions dominate, destructive actions are separated.", "reason": "Protects business lifecycle correctness.", "affectedApps": ["customer-app", "owner-app", "admin-app"] }
  ```
- **Architectural Reality:** `UX-ACTION-01` is an approved canonical foundation. The Phase 4C Action Contract does **not** contradict or invalidate it; rather, it provides the detailed semantic grammar, geometry, typography, and state definitions that implement `UX-ACTION-01`.
- **Resolution Strategy:**
  - **Do NOT edit or overwrite `UX-ACTION-01` in Stage 3A.**
  - **Do NOT insert provisional Phase 4C values into `DECISIONS.json`** while they remain provisional.
  - *Proposed Future Action:* Upon Phase 4C completion and Founder closure, propose a formal child decision `UX-ACTION-02` ("Phase 4C Action System Contract: Stable Black #000000, Contextual Hybrid Grammar, 6px Primary Radius, Reflow Contract") classified according to central governance.
  - *Relation:* `KEEP / EXTENDS`.

### Item 8: `MOBILE_DESIGN_FOUNDATION.md` (DF2) Impact Analysis
- **Current Text in DF2 v1.1:**
  - §9: Monochrome-first identity; Summer Yellow removed; blue demoted to interaction accent candidate `#276EF1`.
  - §15: `PRIMARY — the one decision-critical action ... (restrained interaction-accent treatment — §9)`.
- **Architectural Reality:**
  - DF2 v1.1 §15 retained an earlier assumption that the primary CTA would use the restrained interaction accent (blue `#276EF1`).
  - In Phase 4C Stage 1 & 2, the Founder explicitly reviewed visual evidence of Cairo typography on black vs blue buttons, and selected **Pitch Black (`#000000`)** as the Primary Button color, keeping `#276EF1` open strictly as a non-primary accent (links, active tabs, focus indicator).
- **DF2 Classification Audit:**
  - *Supported Principles:* Monochrome-first identity (§9), High useful density (§5), State grammar (§16), Semantic RTL (§11), Tabular numerals (§12), No yellow containers (§9).
  - *Refined Principles:* Section 15 Primary Action styling shifts from blue interaction accent to Stable Black `#000000`. Secondary Action shifts from generic neutral to Contextual Hybrid.
  - *Not-Reopened Principles:* DF2 authority hierarchy, Cairo UI family candidate, platform-adaptive direction.
- **Proposed Future Action:** Draft an amendment for DF2 v1.2 upon Phase 4C closure to synchronize §15 with the Founder's Stable Black decision.
- **Relation:** `CLARIFY_SCOPE / REFINE`.

### Item 9: `TOKENS/` Potential Misdirection Audit
- **Tension 1: `colors.json`:**
  - `brand.primary = #0059FF` (Web cobalt).
  - *Misdirection Risk:* An automated tool or future mobile engineer might map Primary Button background to `brand.primary`, creating blue buttons.
- **Tension 2: `radius.json`:**
  - `radius.control = 12px` (Web rounded controls).
  - *Misdirection Risk:* Mobile Primary Button has a locked provisional radius of `6px (PRIMARY_ONLY)`. Consuming `radius.control` creates 12px bubbly corners.
- **Tension 3: `typography.json`:**
  - `roles.button = { fontSize: "14px", lineHeight: "1.4" }`.
  - *Misdirection Risk:* Phase 4B validated Cairo Profile B Button at `15px / 700 / 1.20`. Consuming `typography.json` shrinks button text to 14px.
- **Governance Safeguard:**
  - **Zero token files are modified in Stage 3A.**
  - Future token reconciliation must establish an isolated `tokens/mobile/` package (or `platform: mobile` metadata) rather than corrupting web tokens.

---

## 4. Canon Promotion Boundary & Safety Invariants

Stage 3A is strictly limited to drafting the contract and the reconciliation plan:
1. **No Shared Authority Edits:** Files in `DESIGN_SYSTEM/COMPONENTS/`, `DESIGN_SYSTEM/EXPERIENCE/`, `DESIGN_SYSTEM/TOKENS/`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`, `DESIGN_SYSTEM/GOVERNANCE.md`, and `DESIGN_SYSTEM/CHANGELOG.md` remain completely unmodified.
2. **No Token Mutations:** `TOKENS/*.json` are untouched.
3. **No DECISIONS.json Modifications:** Canonical status is preserved; zero provisional tokens are forced into `APPROVED_EXISTING`.
4. **No Production Application Impact:** Zero lines changed in `customer-app/`, `owner-app/`, `admin-app/`, backend, or database.
5. **No Project State Drift:** `docs/CURRENT_STATE.md` and `tasks/CURRENT_TASK.md` are preserved.

---

## 5. Next Steps for Governed Integration (Stage 3B & Beyond)

Upon independent review and approval of this Stage 3A reconciliation draft:
1. **Stage 3B (Targeted Authority Sync):**
   - Update `DESIGN_SYSTEM/COMPONENTS/buttons.md` with platform scoping and the 7-role Action Contract.
   - Update `DESIGN_SYSTEM/EXPERIENCE/ACTION_HIERARCHY.md` with the Contextual Hybrid model.
   - Add a non-breaking mobile action token draft in `DESIGN_SYSTEM/TOKENS/mobile/` or metadata annotations.
2. **Phase 4I (Native Component Engineering & Acceptance):**
   - Implement canonical Flutter action primitives (`KonfrmButton`, `KonfrmIconButton`) in the reserved `konfrm_design_system` package.
   - Perform native accessibility audit (TalkBack / VoiceOver, dynamic text scaling, haptic feedback).
   - Formally promote validated provisional tokens to mobile Canon.

---

*End of Action System Governance Reconciliation Draft (Phase 4C Stage 3A)*
