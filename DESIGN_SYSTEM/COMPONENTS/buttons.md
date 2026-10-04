# Button and IconButton

**Governance Status:** `AUTHORITY SCOPED SPECIFICATION`  
**Phase Integration:** Phase 4C Stage 3B (Targeted Shared Governance Synchronization)  
**Native Mobile Status:** `Native Component & Accessibility Acceptance: DEFERRED TO PHASE 4I`

---

## 1. Document Scope and Governance Boundaries

This document defines the component contract for Buttons and IconButtons across KONFRM platforms:
1. **Current React / Web Applications (`customer-app`, `owner-app`, `admin-app`):** Retain their active Web Design System tokens, CSS variables, and runtime behavior as defined in Section 2 (`CURRENT WEB IMPLEMENTATION / TOKEN AUTHORITY`). Mobile values do not alter Web tokens.
2. **Mobile Target (Future Flutter Architecture):** Governed by the semantic and behavioral contract defined in Section 3 (`MOBILE PHASE 4C PROVISIONAL ACTION MAPPING`). These values are **system-validated provisional** and do not mutate active Web token JSON files.
3. **Native Acceptance Boundary:** Web prototype and simulation evidence does not constitute native Flutter acceptance. Native component implementation, VoiceOver/TalkBack audits, and dynamic text scaling acceptance remain strictly deferred to Phase 4I.

---

## 2. Current Web Implementation / Token Authority

The active React/Web applications continue to consume the established web tokens and styling rules. These tokens remain active authority for the web codebase:

| Web Variant | Purpose | Token / Surface Authority |
| :--- | :--- | :--- |
| **Primary** | One main action in a decision area | `brand.primary` (`#0059FF`) with inverse text |
| **Secondary** | Lower-priority non-destructive action | `surface.secondary` with primary text |
| **Outline** | Alternative or cancel action | Transparent / primary surface with default border |
| **Ghost** | Tertiary action | Transparent, neutral hover only |
| **Destructive** | Irreversible confirmed action | `semantic.danger` only |

### Web Implementation Rules
- **Typography & Geometry:** Web buttons use Cairo, `radius.control` (12px in `radius.json`), and `typography.button`.
- **Target Baseline:** Web controls observe a minimum 44px height baseline for touch-capable web viewports.
- **Color Invariants:** Yellow is never the normal primary CTA (`UX-COLOR-01`).
- **Icon Buttons (Web):** `IconButton` is an icon-only control with a 44px web target, visible focus ring, and mandatory accessible label (`aria-label` / tooltip). Web applications use existing Lucide icons consistently; this does not approve a global icon library migration. Emojis are strictly forbidden as action icons.
- **Recovery Affordance:** A disabled primary action must not hide a recoverable failure. When retry is the valid next step, the recovery action may replace the disabled CTA until canonical state is restored.

---

## 3. Mobile Phase 4C Provisional Action Mapping

For future mobile applications, Phase 4C establishes a semantic, hierarchy-driven action grammar. Visual treatment is determined by **action semantics, consequence, and hierarchy**, rather than arbitrary container styles.

### 3.1 Semantic Action Roles (Mobile Provisional)

| Mobile Action Role | Semantic Purpose | Provisional Treatment | Governance Status |
| :--- | :--- | :--- | :--- |
| **Decision Primary** | The single essential, valid next action for an active decision point or independent decision unit. | **Stable Black (`#000000`)**<br>Radius: `6px` (`PRIMARY_ONLY`)<br>Cairo Profile B `15 / 700 / 1.20` | **SYSTEM-VALIDATED PROVISIONAL**<br>(Native acceptance deferred to Phase 4I) |
| **Standard Primary** | Important completion action in a local section not competing with a Decision Primary. | **Stable Black (`#000000`)**<br>Radius: `6px` (`PRIMARY_ONLY`)<br>Cairo Profile B `15 / 700 / 1.20` | **PROVISIONAL**<br>(Must not compete in same hierarchy) |
| **Neutral Secondary** | Subordinate non-destructive alternative or supporting action. | **Subtle Fill** (Default Provisional)<br>Radius: `OPEN`<br>Cairo Profile B `15 / 700 / 1.20` | **PROVISIONAL STRATEGY**<br>(Exact neutral token: `OPEN`) |
| **Conditional Neutral Outline** | Neutral secondary requiring stronger perimeter when Subtle Fill lacks sufficient boundary separation. | **Neutral Outline** (perimeter border, transparent fill)<br>Radius: `OPEN` | **PROVISIONAL STRATEGY**<br>(Contrast/affordance gated) |
| **Tertiary / Ghost** | Low-weight, auxiliary, detail-expansion, or navigation return action. | **Ghost / Text-like** (Transparent fill, zero border)<br>Cairo Profile B `15 / 700 / 1.20` | **PROVISIONAL STRATEGY**<br>(Typography remains Profile B) |
| **Destructive Secondary** | Subordinate rejection or destructive action paired with an affirmative Primary. | **Destructive Outline** (red perimeter, transparent fill)<br>Radius: `OPEN` | **PROVISIONAL STRATEGY**<br>(Exact danger token: `OPEN`) |
| **Destructive Primary** | Affirmative confirmation of an intentional destructive action within an explicit destructive confirmation context. | **Destructive Solid Fill**<br>Radius: `OPEN` | **PROVISIONAL STRATEGY**<br>(Confirmation context gated) |
| **Destructive Tertiary / Ghost** | Low-emphasis discard or removal for genuinely low-consequence operations. | **Destructive Ghost** (text-only, transparent fill) | **PROVISIONAL STRATEGY**<br>(Strict low-consequence gate) |

### 3.2 Primary Uniqueness & Coexistence
- **Scope:** Exactly **one Decision Primary per active decision point / decision unit**.
- **Coexistence:** Multiple Decision Primaries may coexist in the same viewport **only** when they belong to distinct, independently actionable decision units (e.g., consecutive Owner booking request cards in an operational list). They must never compete for visual dominance within the same decision hierarchy.
- **Lifecycle Validity:** A Decision Primary must represent an actionable, server-valid transition. It must never visually imply a lifecycle transition that canonical backend state does not permit (`UX-ACTION-01`).

### 3.3 Conditional Neutral Outline Eligibility
On standard light surfaces, Subtle Fill remains the **default provisional secondary treatment**. Neutral Outline may replace Subtle Fill **if and only if all of the following conditions are met**:
1. Subtle Fill does not provide sufficient component boundary separation against the surrounding surface in the actual container context.
2. Ghost / Text-like treatment would provide insufficient visible affordance for the action's importance.
3. The action is strictly neutral, non-destructive, and subordinate to Primary.
4. Adding an outline perimeter does not create border clutter or compete with Primary.
5. The affordance cannot be resolved more cleanly through layout, grouping, or surface contrast.
*(Eligibility is perceptual and contrast-driven; no hardcoded raw hex or unvalidated numeric contrast threshold rules apply).*

### 3.4 Destructive Consequence Dimension
Destructive is not an ad-hoc visual style, but a **semantic consequence dimension** evaluated by **Consequence Level**, **Hierarchy Rank**, and **Discoverability**:
1. **Destructive Primary:** Permitted **only** within an explicit destructive confirmation context (dialog, sheet, modal, full-screen confirmation, or other platform-appropriate confirmation surface) where the destructive consequence is clearly stated, two-step confirmation is warranted per Product/UX authority, and Product Canon permits the action.
2. **Destructive Secondary:** Standard visible destructive treatment (**Destructive Outline**) for paired rejection/discard actions or standalone destructive actions requiring clear danger affordance without a full confirmation modal.
3. **Destructive Tertiary / Ghost (Low-Consequence Gate):** Permitted **only** when all of the following conditions are met:
   - Consequence is strictly local, minor, or transient;
   - Action is not decision-critical;
   - Action is not irreversible and causes zero material harm;
   - Straightforward recovery/reversal is available;
   - Ghost styling will not obscure or trivialize the action's consequence;
   - Discoverability remains intact;
   - Product Canon permits the capability.
4. **Prohibitions:** High-consequence or material destructive actions must **never** be visually weakened into Ghost merely because they are unpaired. Confirmation is consequence-aware, not universal (routine destructive actions do not require two-step confirmation modals). Zero invented cancellation or refund capabilities (`CANCELLATION_REFUND_POLICY: OPEN / UNDECIDED`).

---

## 4. Contextual Actions

**Contextual** is an attachment and placement relationship, **not an arbitrary eighth visual style**:
- A contextual action is physically and semantically attached to the specific object, list row, or task it affects.
- Its visual presentation strictly follows the semantic action hierarchy: it may be a Primary, Secondary, Tertiary/Ghost, or Destructive action depending on its role and consequence within that object's context.

---

## 5. Interaction State Semantics

Implementations must provide comprehensive state coverage based on shared semantic requirements. Exact Web pilot CSS values (e.g., `scale(0.98)`, `brightness(0.90)`, `opacity: 0.85`, `0 0 0 2px #fff`) are **pilot reference treatments**, not cross-platform contract tokens:

- **Default (Resting):** Clearly interactive and role-correct visual styling. Base state exposed to accessibility tree.
- **Pressed / Active:** Immediate perceivable activation feedback upon touch/click (visual and/or haptic per platform conventions).
- **Focus / Accessible Focus:** Clearly visible focus indicator where applicable; must never be suppressed without a valid accessible replacement. (Exact native focus treatment: `OPEN`).
- **Loading:**
  - Active busy/progress feedback, visibly distinct from disabled.
  - Multi-input activation suppression across all inputs (touch, mouse, keyboard Space/Enter).
  - Duplicate submission protection.
  - Accessible busy semantics (`aria-busy` on Web / platform semantic equivalent).
- **Disabled:** Clearly unavailable and non-interactive. Communicates unavailability; recovery action replaces disabled state where understanding requires it.
- **Selected:** Used exclusively where an action carries toggle or selection semantics.
- **Hover:** Pointer-capable environments only. **No mandatory mobile hover** (touch devices have no hover).

---

## 6. Touch Targets and Component Geometry

### 6.1 Separation of Concerns
1. **Visible Component Geometry:** The rendered visual boundary of the button (background, padding, border). Exact visible mobile component height and padding remain: **`OPEN / IMPLEMENTATION VALIDATION REQUIRED`** (no universal 52–56px mobile height canon).
2. **Interactive Target Bounds:** The tappable hit area evaluated by the platform touch dispatcher.

### 6.2 Platform Touch Target Guidance
- **iOS Platform Guidance:** Minimum **`44pt × 44pt`** interactive area (Apple Human Interface Guidelines).
- **Android Platform Guidance:** Minimum **`48dp × 48dp`** interactive area (Android Material / Accessibility Guidance).
- **Guidance Rule:** There is no universal raw `44px` or `48px` native mobile rule. Compact or inline controls expand their invisible touch target bounds to satisfy platform guidance without distorting visible component padding.

---

## 7. Action Group Reflow Contract

### 7.1 Reflow Requirement
Action groups must reflow from a horizontal arrangement to a vertical/stacked arrangement **when and only when** the horizontal composition cannot preserve:
1. Complete readable labels (zero truncation of decision-critical text).
2. Valid platform touch-target geometry.
3. Sufficient interactive separation between controls.
4. Arabic word integrity (zero mid-word fragmentation or awkward wrapping).
5. Zero clipping and zero overlap.
6. Clear visual hierarchy.

### 7.2 Evidence Boundary
- Controlled Stage 2 evidence (`hybrid_action_360_stress_reflow.png`) reflects a **controlled 360px Web frame-width simulation** under 200% text scaling (30px text vs 15px baseline).
- There is **no universal `150%` or `200%` numeric breakpoint token**, and **no universal `360px` hardcoded media query**. Layout reflow is evaluated dynamically by platform-adaptive layout containers based on label length and text scaling.
