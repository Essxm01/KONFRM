# KONFRM Action System Governance Reconciliation Draft — Phase 4C Stage 3A

**Document Status:** `GOVERNANCE RECONCILIATION DRAFT & MIGRATION PLAN`  
**Governing Phase:** Phase 4C — Action System  
**Stage:** Stage 3A (Action Contract Formalization & Governance Reconciliation Draft)  
**Evidence Baseline:** Stage 2 Independently Verified PASS (Commit `f33674c902a4d2c63fcb5fd0fa6414851be5e7d2`)  
**Shared Authority Boundary:** This is an analytical and planning document. It does **not** edit shared authoritative Design System files (`DESIGN_SYSTEM/COMPONENTS/`, `DESIGN_SYSTEM/EXPERIENCE/`, `DESIGN_SYSTEM/TOKENS/`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`), does not modify `DECISIONS.json`, and does not promote provisional findings into Canon without explicit separate governance integration.

---

## 1. Executive Summary & Purpose

The purpose of Stage 3A Governance Reconciliation is to perform a rigorous **READ / COMPARE analysis** between:
1. **Current Web Authority:** Active shared Design System documents and tokens governing the existing web applications (`customer-app`, `owner-app`, `admin-app`), and
2. **Mobile Phase 4C Provisional Results:** The independently validated findings of Phase 4C Stages 1 & 2 (Founder-selected Stable Black `#000000`, 6px Primary Radius, Cairo Profile B `15px`, Contextual / Hierarchy-Based Hybrid Action Strategy, Conditional Neutral Outline, and the Action Group Reflow Contract).

The objective is **not** to force the live Web prototype to inherit mobile values, nor to break existing Web production behavior. Rather, the goal is to **prevent future mobile implementations from incorrectly inheriting Web-legacy values**, while scoping shared governance documents cleanly and establishing an unambiguous migration roadmap.

---

## 2. Master Governance Reconciliation Matrix

| Source File | Current Web Authority | Mobile Phase 4C Provisional Result | Relation | Proposed Future Governance Action | Risk If Left Unaddressed |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `COMPONENTS/buttons.md` (Line 7) | `Primary = brand.primary with inverse text` (`brand.primary` = `#0059FF`) | Mobile Primary is **Stable Black (`#000000`)** (provisional candidate; blue demoted to accent). | **CLARIFY_SCOPE / SUPERSEDE (FOR MOBILE)** | Scope `brand.primary` to Web prototype only in documentation. Prepare governance mapping for mobile action primary to `#000000`. (Token file creation deferred to authorized token gate). | High: Future Flutter engineers reading `buttons.md` will implement blue primary buttons, violating monochrome-first brand identity. |
| `COMPONENTS/buttons.md` (Line 3) | `All buttons use ... radius.control` (`radius.control` = `12px` in `radius.json`) | Primary Button Radius is **`6px` (`PRIMARY_ONLY`)**. Secondary radius remains `OPEN`. | **SUPERSEDE (FOR MOBILE)** | Add platform scoping note in `buttons.md`: mobile Primary Button uses provisional 6px radius; secondary radius remains unconstrained. | High: Mobile buttons will render with 12px bubble corners, clashing with the validated 6px architectural geometry. |
| `COMPONENTS/buttons.md` (Line 3, Line 19) | `minimum 44px height/target on mobile` and `prefer a 48px touch area` | Platform-appropriate guidance: **iOS: 44pt**, **Android: 48dp**. Separate visual geometry from interactive touch bounds. | **CLARIFY_SCOPE** | Update `buttons.md` to distinguish visual height from touch area and cite iOS 44pt / Android 48dp guidance. Eliminate universal 48px raw pixel rule. | Medium: Overconstrains visual layout on compact screens while failing platform-native touch standards. |
| `COMPONENTS/buttons.md` (Lines 8–10) | `Secondary: surface.secondary`<br>`Outline: alternative or cancel`<br>`Ghost: tertiary` | **Contextual / Hierarchy-Based Hybrid:** Subtle Fill is default neutral secondary; Conditional Neutral Outline is contrast-gated; Ghost is tertiary. | **SUPERSEDE (FOR MOBILE)** | Reconcile discrete variant list with the semantic Action Role Model and Decision Tree from `ACTION_SYSTEM_CONTRACT_DRAFT.md`. | High: Designers will deploy Outline arbitrarily on standard white cards, producing visual border clutter. |
| `COMPONENTS/buttons.md` (Line 11) | `Destructive: semantic.danger only` | **Destructive Hierarchy:** Destructive Outline for subordinate pairing; Destructive Primary for confirmation contexts only; Destructive Ghost for utility. | **SUPERSEDE (FOR MOBILE)** | Expand destructive section to define Destructive Outline vs Destructive Primary confirmation gating. | High: Dangerous actions will be styled with solid red CTAs on top-level screens, creating alarm and accidental triggers. |
| `COMPONENTS/buttons.md` (Line 13) | `Loading disables repeat submission while retaining an accessible label` | Loading requires **multi-input activation suppression** (touch, mouse, keyboard Space/Enter) + distinct visual contrast from disabled. | **CLARIFY_SCOPE** | Explicitly specify activation suppression for Space/Enter keys and distinct visual contrast from disabled (`0.45`). | High: Duplicate booking or payment API calls during slow network states. |
| `EXPERIENCE/ACTION_HIERARCHY.md` (Line 9) | `Secondary: Reversible/supporting action \| Secondary/outline treatment` | Secondary is **Subtle Fill by default**; Neutral Outline is reserved for low-contrast containers. | **SUPERSEDE (FOR MOBILE)** | Refine definition from "outline treatment" to "Contextual Hybrid (Subtle Fill default, Conditional Neutral Outline where needed)". | Medium: Semantic confusion leading to inconsistent secondary button styles across Customer and Owner. |
| `EXPERIENCE/ACTION_HIERARCHY.md` (Lines 20–21) | `Comfortable: ... >=44px target`<br>`Standard: ... >=44px target on mobile` | iOS 44pt / Android 48dp guidance; touch bounds separate from visible container. | **CLARIFY_SCOPE** | Replace raw `>=44px` with platform-appropriate units (`pt` on iOS, `dp` on Android). | Low: Platform engineering confusion regarding physical vs logical pixels. |
| `EXPERIENCE/DECISIONS.json` (`UX-ACTION-01`) | `State-aware action hierarchy: Only valid canonical-state actions are shown; decision-critical actions dominate, destructive actions are separated.` | Validates and aligns perfectly with Phase 4C Stage 2 & 3A contract rules. | **KEEP / EXTENDS** | Retain `UX-ACTION-01` as active canonical parent. Propose future child decision `UX-ACTION-02` (Action Contract Formalization) upon Phase 4C closure. | None: Strong structural continuity. |
| `MOBILE_DESIGN_FOUNDATION.md` (§15, Line 288) | `PRIMARY — the one decision-critical action ... (restrained interaction-accent treatment — §9)` | Primary CTA is **Stable Black (`#000000`)**, not blue. Blue candidate `#276EF1` is demoted strictly to interaction accents/links. | **CLARIFY_SCOPE / REFINE** | Prepare DF2 v1.2 amendment aligning §15 Primary treatment with Founder Stable Black decision, preserving blue for non-primary accents. | High: New mobile developers reading DF2 v1.1 will attempt to implement blue primary buttons. |
| `TOKENS/colors.json` (Line 9) | `brand.primary: #0059FF` | Web remains `#0059FF`. Mobile action primary candidate is `#000000`. | **CLARIFY_SCOPE** | Maintain `colors.json` for web legacy compatibility. Map mobile action primary to `#000000` conceptually. (Token file authoring deferred). | Critical: Silently changing `brand.primary` would break existing web apps (`customer-app`, `owner-app`, `admin-app`). |
| `TOKENS/radius.json` (Line 3) | `radius.control: 12px` | Primary Button Radius is `6px (PRIMARY_ONLY)`. Secondary radius is `OPEN`. | **CLARIFY_SCOPE** | Preserve `radius.json` for web. Note mobile Primary Button uses provisional 6px radius. (Token file authoring deferred). | High: Incompatible corner rounding between web legacy and mobile design. |
| `TOKENS/typography.json` (Line 15) | `roles.button: fontSize: 14px, lineHeight: 1.4` | Cairo Profile B Button is **`15px / 700 / 1.20`** (System-Validated Provisional). | **CLARIFY_SCOPE** | Preserve web `typography.json`. Map mobile typography tokens to Cairo Profile B values established in Phase 4B. | Medium: Text scaling and vertical alignment discrepancies on mobile buttons. |
| `GOVERNANCE.md` (Line 27) | `No yellow/amber/orange boxed UI (UX-COLOR-01)` | Enforced in Stage 2 remediation: all Lab warning banners neutralized to white cards with subtle borders. | **KEEP / NO_CHANGE** | Reaffirm as non-negotiable cross-role visual rule. | None: Rule is fully verified and compliant. |

---

## 3. In-Depth Analysis of Mandatory Reconciliation Items

### Item 1: `buttons.md` — "Primary = brand.primary"
- **Current Web Authority:** Line 7 of `buttons.md` specifies `brand.primary with inverse text` for the Primary variant. In `TOKENS/colors.json`, `brand.primary` is `#0059FF` (a legacy bright cobalt blue from the web prototype).
- **Mobile Phase 4C Provisional Result:** In DF2 Amendment v1.1, the Founder established a monochrome-first mobile brand identity (Black/White). In Phase 4C Stage 1 & 2, the Founder evaluated four black candidates and formally selected **Pitch Black (`#000000`)** as the provisional Primary Button color.
- **Resolution Strategy:**
  - *Preserve Web Authority:* Do NOT overwrite `brand.primary: #0059FF` in `colors.json`. Doing so would cause immediate visual regression across live web applications (`customer-app`, `owner-app`, `admin-app`).
  - *Platform Scoping:* In `buttons.md`, scope `brand.primary: #0059FF` explicitly to `PLATFORM: WEB_LEGACY`.
  - *Future Mobile Mapping:* In future mobile governance, map the mobile action primary to `#000000`. Concrete token file authoring is **deferred** until explicitly authorized by a dedicated future governed design/token gate.
  - *Relation:* `CLARIFY_SCOPE` for web; `SUPERSEDE` for future mobile architecture.

### Item 2 & 3: `buttons.md` — Mobile Minimum 44px & 48px Preferred Area
- **Current Web Authority:** Line 3 says `minimum 44px height/target on mobile`. Line 19 says `For frequent Customer/Owner mobile controls, prefer a 48px touch area even though 44px remains the minimum`.
- **Mobile Phase 4C Provisional Result:** This legacy wording confuses **visual component height** with **interactive touch target bounds**, and introduces a raw pixel value (`px`) that does not map cleanly to native mobile screen densities:
  - Apple iOS HIG recommends **`44pt × 44pt`** logical points.
  - Google Android Material 3 recommends **`48dp × 48dp`** density-independent pixels.
  - Setting a universal `48px` minimum visual height restricts design flexibility for compact operational controls and inline utility actions.
- **Resolution Strategy:**
  - Separate concerns: Visual component geometry (padding + font metrics) is decoupled from interactive hit target bounds.
  - Formally adopt platform guidance: iOS `44pt`, Android `48dp`.
  - In `buttons.md`, replace the raw `48px` preference with platform-specific touch target delegation: "Components ensure a minimum interactive hit area of 44pt on iOS and 48dp on Android, while allowing visual component geometry to adapt to density requirements."
  - *Relation:* `CLARIFY_SCOPE`.

### Item 4 & 5: `buttons.md` and `ACTION_HIERARCHY.md` — Secondary & Outline Descriptions
- **Current Web Authority:** `buttons.md` lists `Secondary: surface.secondary with primary text` and `Outline: alternative or cancel action | transparent/primary surface with default border`. `ACTION_HIERARCHY.md` defines `Secondary: Reversible/supporting action | Secondary/outline treatment`.
- **Mobile Phase 4C Provisional Result:** Lumping secondary actions into a generic "outline treatment" or presenting Outline as a standalone cosmetic variant encourages arbitrary visual usage (e.g., creating high-friction border soup on cards). Stage 2 validated that **Contextual / Hierarchy-Based Hybrid** is the true system grammar:
  - **Subtle Fill** is the default neutral secondary treatment across standard white surfaces.
  - **Neutral Outline** is strictly conditional, reserved for surfaces where Subtle Fill lacks contrast.
  - **Destructive Outline** is a dedicated danger secondary variant, not an arbitrary outline color.
  - **Ghost** serves tertiary and low-weight auxiliary needs.
- **Resolution Strategy:**
  - Modernize `buttons.md` and `ACTION_HIERARCHY.md` to reference the 7 semantic action roles defined in `ACTION_SYSTEM_CONTRACT_DRAFT.md`.
  - Supersede the legacy assumption that secondary actions are primarily "outline".
  - *Relation:* `SUPERSEDE (FOR MOBILE)`.

### Item 6: `ACTION_HIERARCHY.md` — Mobile `>=44px` Target Wording
- **Current Web Authority:** Lines 20–21 specify `>=44px target on mobile` for Comfortable and Standard controls.
- **Mobile Phase 4C Provisional Result:** As analyzed in Item 2, `>=44px` is a web heuristic. On iOS, 44pt is native guidance. On Android, 48dp is native guidance.
- **Resolution Strategy:**
  - Reconcile `ACTION_HIERARCHY.md` to state: "Meets platform touch target guidance (iOS 44pt / Android 48dp)".
  - *Relation:* `CLARIFY_SCOPE`.

### Item 7: `DECISIONS.json` — `UX-ACTION-01`
- **Current Canonical Rule:**
  ```json
  { "id": "UX-ACTION-01", "title": "State-aware action hierarchy", "category": "actions", "status": "APPROVED_EXISTING", "recommendation": "Only valid canonical-state actions are shown; decision-critical actions dominate, destructive actions are separated.", "reason": "Protects business lifecycle correctness.", "affectedApps": ["customer-app", "owner-app", "admin-app"] }
  ```
- **Mobile Phase 4C Provisional Result:** `UX-ACTION-01` is an approved canonical foundation. The Phase 4C Action Contract does **not** contradict or invalidate it; rather, it provides the detailed semantic grammar, geometry, typography, and state definitions that implement `UX-ACTION-01`.
- **Resolution Strategy:**
  - **Do NOT edit or overwrite `UX-ACTION-01` in Stage 3A.**
  - **Do NOT insert provisional Phase 4C values into `DECISIONS.json`** while they remain provisional.
  - *Proposed Future Action:* Upon Phase 4C completion and Founder closure, propose a formal child decision `UX-ACTION-02` ("Phase 4C Action System Contract: Stable Black #000000, Contextual Hybrid Grammar, 6px Primary Radius, Reflow Contract") classified according to central governance.
  - *Relation:* `KEEP / EXTENDS`.

### Item 8: `MOBILE_DESIGN_FOUNDATION.md` (DF2) Impact Analysis
- **Current Canonical Foundation in DF2 v1.1:**
  - §9: Monochrome-first identity; Summer Yellow removed; blue demoted to interaction accent candidate `#276EF1`.
  - §15: `PRIMARY — the one decision-critical action ... (restrained interaction-accent treatment — §9)`.
- **Mobile Phase 4C Provisional Result:**
  - DF2 v1.1 §15 retained an earlier assumption that the primary CTA would use the restrained interaction accent (blue `#276EF1`).
  - In Phase 4C Stage 1 & 2, the Founder explicitly reviewed visual evidence of Cairo typography on black vs blue buttons, and selected **Pitch Black (`#000000`)** as the Primary Button color, keeping `#276EF1` open strictly as a non-primary accent (links, active tabs, focus indicator).
- **DF2 Classification Audit:**
  - *Supported Principles:* Monochrome-first identity (§9), High useful density (§5), State grammar (§16), Semantic RTL (§11), Tabular numerals (§12), No yellow containers (§9).
  - *Refined Principles:* Section 15 Primary Action styling shifts from blue interaction accent to Stable Black `#000000`. Secondary Action shifts from generic neutral to Contextual Hybrid.
  - *Not-Reopened Principles:* DF2 authority hierarchy, Cairo UI family candidate, platform-adaptive direction.
- **Proposed Future Action:** Draft an amendment for DF2 v1.2 upon Phase 4C closure to synchronize §15 with the Founder's Stable Black decision.
- **Relation:* `CLARIFY_SCOPE / REFINE`.

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
- **Governance Safeguard & Stage 3B Boundary:**
  - **Zero token files are modified in Stage 3A.**
  - **Stage 3B is TARGETED AUTHORITY / GOVERNANCE SYNCHRONIZATION only.** It does NOT authorize creating concrete mobile token JSON files.
  - Concrete token authoring is deferred until explicitly authorized by a dedicated future governed design/token gate per project dependency order.

---

## 4. Canon Promotion Boundary & Safety Invariants

Stage 3A is strictly limited to drafting the contract and the reconciliation plan:
1. **No Shared Authority Edits:** Files in `DESIGN_SYSTEM/COMPONENTS/`, `DESIGN_SYSTEM/EXPERIENCE/`, `DESIGN_SYSTEM/TOKENS/`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md`, `DESIGN_SYSTEM/GOVERNANCE.md`, and `DESIGN_SYSTEM/CHANGELOG.md` remain completely unmodified.
2. **No Token File Creation in Stage 3A or Stage 3B:** `TOKENS/*.json` are untouched. Stage 3B will not create concrete token files.
3. **No DECISIONS.json Modifications:** Canonical status is preserved; zero provisional tokens are forced into `APPROVED_EXISTING`.
4. **No Production Application Impact:** Zero lines changed in `customer-app/`, `owner-app/`, `admin-app/`, backend, or database.
5. **No Project State Drift:** `docs/CURRENT_STATE.md` and `tasks/CURRENT_TASK.md` are preserved.

---

## 5. Next Steps for Governed Integration (Stage 3B & Beyond)

Upon independent review and approval of this Stage 3A reconciliation draft:

1. **Stage 3B — Targeted Governance Documentation Synchronization:**
   - Update `DESIGN_SYSTEM/COMPONENTS/buttons.md` with platform scoping and the 7-role Action Contract.
   - Update `DESIGN_SYSTEM/EXPERIENCE/ACTION_HIERARCHY.md` with the Contextual Hybrid model.
   - Reconcile DF2 §15 text with Founder Stable Black decision.
   - *Boundary:* Stage 3B is strictly documentation synchronization; no concrete mobile token files are created in Stage 3B.

2. **Future Governed Design / Token Gate:**
   - Exact open design and token decisions (e.g., Secondary Button Radius, exact neutral palette, exact interaction blue, exact destructive color) may be resolved when explicitly authorized by the project dependency order.
   - Concrete mobile token-file creation (`tokens/mobile/`) requires explicit authorization under an approved token gate.
   - Stage 3B does NOT create token files.
   - Do not assert a mandatory phase number for open token decisions unless authoritative dependency order explicitly specifies it.

3. **Phase 4I — Native Mobile Implementation & Acceptance:**
   - Flutter component implementation and validation as governed by the authoritative roadmap (`konfrm_design_system` package primitives).
   - Platform accessibility validation (TalkBack / VoiceOver, dynamic text scaling, haptic feedback).
   - Platform-adaptive interaction behavior and touch-target verification.
   - Final native platform acceptance of relevant action primitives.

---

*End of Action System Governance Reconciliation Draft (Phase 4C Stage 3A)*
