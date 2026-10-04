# KONFRM Action System Contract Draft — Phase 4C Stage 3A

**Document Status:** `SYSTEM-VALIDATED PROVISIONAL CONTRACT DRAFT`  
**Governing Phase:** Phase 4C — Action System  
**Stage:** Stage 3A (Action Contract Formalization & Governance Reconciliation Draft)  
**Evidence Baseline:** Stage 2 Independently Verified PASS (Commit `f33674c902a4d2c63fcb5fd0fa6414851be5e7d2`)  
**Native Mobile Status:** `Native Component & Accessibility Acceptance: DEFERRED TO PHASE 4I`  
**Shared Authority Boundary:** This document is a pilot-stage contract draft. It does **not** modify shared authoritative Design System files, does not promote values to Canon, and does not alter production applications.

---

## 1. Authority, Scope, and Status

### 1.1 Purpose
This Action Contract formalizes the semantic, structural, and behavioral rules of the KONFRM Action System, derived from the independently validated visual and operational findings of Phase 4C Stage 2. It defines the grammar for actionable controls across Customer and Owner surfaces (with Admin compatibility noted).

### 1.2 Upstream Authority & Source Precedence
This contract is subordinated to the KONFRM source-of-truth hierarchy (`docs/codex/KONFRM_MASTER_RULES.md` and `DESIGN_SYSTEM/GOVERNANCE.md`):
1. Latest explicit Founder decisions (Stable Black `#000000`, 6px Primary Radius, Cairo Profile B, Contextual Hierarchy Hybrid Strategy).
2. Canonical Product & Financial Truth (`BUSINESS_RULES.md`; server-authoritative state; zero invented cancellation/refund policies).
3. Mobile Design Foundation (DF2 v1.1 monochrome-first identity; high useful density).
4. Platform conventions and human-factors guidance (Apple HIG / Android Material 3).
5. Controlled Web evidence (Stage 2 active evidence suite).

### 1.3 Governance Classification
- **Contract Level:** `SYSTEM-VALIDATED PROVISIONAL CONTRACT DRAFT`
- **Component Scope:** Buttons, Action Pairings, Action Groups, Sticky Action Bars, Icon Actions, and Confirmation Workflows.
- **Production Scope:** Zero production code modification in this stage. Native Flutter implementation and acceptance remain strictly deferred to Phase 4I.

---

## 2. Semantic Action Role Model

The KONFRM Action System defines distinct semantic action roles. Visual presentation is determined primarily by **Action Semantics and Hierarchy**, not by arbitrary container types.

| Action Role | Semantic Purpose | Provisional Treatment | Key Geometry & Typography | Hierarchy Rank |
| :--- | :--- | :--- | :--- | :--- |
| **1. Decision Primary** | The single essential, valid next step for an active decision unit. | **Stable Black (`#000000`)** with high-contrast text | Radius: `6px` (`PRIMARY_ONLY`)<br>Cairo `15 / 700 / 1.20` | Highest (Rank 1) |
| **2. Standard Primary** | Important completion action within a local task/section not competing with a Decision Primary. | **Stable Black (`#000000`)** | Radius: `6px` (`PRIMARY_ONLY`)<br>Cairo `15 / 700 / 1.20` | Local Dominant (Rank 2) |
| **3. Neutral Secondary** | Subordinate non-destructive alternative or supporting action. | **Subtle Fill** (Default Provisional) | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Subordinate (Rank 3) |
| **4. Destructive Secondary** | Subordinate rejection or destructive action paired with a non-destructive Primary. | **Destructive Outline** | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Subordinate Danger (Rank 3D) |
| **5. Destructive Primary** | Confirmation of an intentional destructive action within an explicit destructive confirmation context. | **Destructive Solid Fill** | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Confirmation Dominant (Rank 1D) |
| **6. Tertiary / Ghost** | Low-weight, auxiliary, detail-expansion, or edit-return navigation action. | **Ghost / Text-like** (Transparent fill, zero border) | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Auxiliary (Rank 4) |
| **7. Conditional Neutral Outline** | Neutral secondary requiring stronger perimeter when Subtle Fill lacks sufficient boundary separation. | **Neutral Outline** (perimeter border, transparent fill) | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Conditional Subordinate (Rank 3-Outline) |

---

### 2.1 The Destructive Consequence Dimension
Destructive is not a separate ad-hoc visual style, but a **semantic consequence dimension** applied to an eligible hierarchy role:
- **Destructive Primary (Rank 1D):** Affirmative confirmation inside an explicit destructive confirmation context.
- **Destructive Secondary (Rank 3D):** Destructive Outline when paired with a non-destructive Primary or alternative.
- **Destructive Tertiary / Ghost (Rank 4D):** Low-weight utility discard/removal, permitted **only** where Product semantics, low consequence, and discoverability clearly warrant a minimal text-only presentation.

---

### 2.2 Detailed Role Specifications

#### Role 1: Decision Primary
- **Semantic Definition:** The one action that advances the user's primary business or lifecycle intent for an active decision unit (e.g., Customer "Review Booking Request", Owner "Accept Booking Request").
- **Visual Expression:** Solid Pitch Black (`#000000`) fill, pure white text, provisional `6px` border radius, Cairo Profile B (`15px`, bold 700, line-height 1.20).
- **Invariants:**
  1. *Uniqueness Scope:* Exactly **one Decision Primary per active decision unit / decision point**.
  2. *Independent Objects in Viewport:* Multiple Decision Primaries may coexist in the same viewport **only** when they belong to distinct, independently actionable objects or decision units (e.g., consecutive Owner booking request cards in an operational list, as validated in Stage 2). Each Primary must be visually and semantically bound to its own object card.
  3. *No Hierarchy Competition:* Two Primaries must **never** compete for the same decision hierarchy. In a single screen-level decision area, exactly one screen-level Decision Primary is permitted.
  4. *Lifecycle Validity:* A Decision Primary must represent an actionable, server-valid transition. It must **never** visually imply a lifecycle transition that canonical backend state does not permit (`UX-ACTION-01`).
  5. *State-Aware Recovery:* When a prerequisite fails (e.g., availability quote failure), the primary slot may temporarily host a Recovery Action (e.g., "Retry Availability") to communicate the next valid step rather than a generic dead-end disabled CTA.
  6. *Anti-Pattern:* Never treat every generic submit button or card button as a Decision Primary.

#### Role 2: Standard Primary
- **Semantic Definition:** An action that completes a self-contained local task (e.g., "Apply Filters", "Save Dates") where no screen-level Decision Primary is present or where the modal context isolates the task.
- **Hierarchy Boundary:** If a screen has both a sticky Decision Primary and local sections, local sections must use Secondary or Tertiary actions to avoid visual competition. Two solid black primaries must never compete for visual dominance in the same decision hierarchy.

#### Role 3: Neutral Secondary
- **Semantic Definition:** The primary alternative to a Primary action for non-destructive operations (e.g., "Edit Dates", "Change Unit Price", "Dismiss Modal").
- **Provisional Treatment:** **Subtle Fill** (light neutral background, dark neutral text, zero harsh border). On the standard light surface, Subtle Fill remains the **default provisional treatment**.
- **Policy Protection:** "Cancel in-flight edit" is local UI navigation and state reversion. It carries **zero** implication regarding booking cancellation or deposit refund policies (`CANCELLATION_REFUND_POLICY: OPEN / UNDECIDED`).
- **Open Boundaries:** The exact neutral token for Subtle Fill remains `OPEN` (pilot `#F1F5F9` is a non-canonical rendering value). Border radius is `OPEN` (does not automatically inherit Primary 6px).

#### Role 4: Destructive Secondary
- **Semantic Definition:** A negative, rejection, or discard action presented alongside an affirmative Primary action (e.g., Owner "Reject Request" paired with "Accept Request").
- **Provisional Treatment:** **Destructive Outline** (subtle red perimeter, transparent background, red text).
- **Hierarchy Function:** Signals consequence and danger without seizing visual dominance from the Primary action. The user's eye lands on the Primary first, but clearly distinguishes the danger perimeter of the secondary action.
- **Product Truth Protection:** A Destructive Secondary cannot invent product capability. Rejection or cancellation controls may be rendered only where server-side lifecycle rules allow that transition. Exact destructive color remains `OPEN` (pilot `#DC2626` is a candidate rendering value).

#### Role 5: Destructive Primary
- **Semantic Definition:** The affirmative confirmation of an intentional destructive operation.
- **Strict Context-Gated Rules (Not Container-Gated):**
  1. *Explicit Confirmation Context:* Allowed **only** within an explicit destructive confirmation context where:
     - The destructive consequence is clearly stated;
     - The destructive action is the action being consciously confirmed (e.g., "Confirm Property Removal");
     - A safe exit/cancel path is clear and accessible;
     - Product Canon actually permits that action.
  2. *Presentation Form:* The presentation may be a dialog, sheet, modal, full-screen confirmation, or other platform-appropriate confirmation surface, according to context.
  3. *Forbidden on Top-Level Surfaces:* Never use Destructive Primary on top-level browsing, dashboard cards, or list items merely because a destructive action exists there. Never invent cancellation/refund rules.

#### Role 6: Tertiary / Ghost / Text-Like
- **Semantic Definition:** Low-emphasis, auxiliary, or repetitive actions (e.g., "View Breakdown", "Show Terms", "Back").
- **Visual Expression:** Zero border, transparent fill, text label with an interactive touch target.
- **Typography Invariant:** Button-shaped / tappable Button components use Cairo Profile B (`15 / 700 / 1.20`). Typography is **never** silently reduced to 13–14px merely because the hierarchy is tertiary. (True inline text-links/actions are governed separately by applicable text roles).
- **Eligibility & Restrictions:**
  - *Eligible:* Where an action is supporting, informational, or occurs repeatedly in a list without warranting container chrome.
  - *Forbidden:* Never use Ghost for decision-critical actions, where action discoverability would be compromised, or where a user cannot perceptually identify the tappable area.

#### Role 7: Conditional Neutral Outline
- **Problem Solved:** Stage 2 validated that a rigid "Subtle Fill only" secondary rule fails when a container background is already tinted neutral/gray, causing Subtle Fill buttons to dissolve into the surface.
- **Evidence-Bounded Semantic / Perceptual Eligibility Rule:**
  Neutral Outline may replace the default Subtle Fill **if and only if all of the following conditions are true**:
  1. *Boundary Insufficiency:* The current approved Subtle Fill treatment does not provide sufficiently clear component boundary/separation against the surrounding surface in the actual component context.
  2. *Affordance Requirement:* Ghost/Text-like treatment would provide insufficient visible affordance for the action's importance.
  3. *Non-Destructive Semantics:* The action is strictly non-destructive and subordinate to Primary.
  4. *Visual Hierarchy Balance:* Adding an outline perimeter does not create border clutter or compete with Primary.
  5. *Layout Solution Insufficiency:* The need cannot be solved more cleanly through grouping, spacing, surface hierarchy, or layout.
- **Strict Prohibitions:**
  - *Default Preservation:* On the standard light surface, Subtle Fill remains the **default**.
  - *No Container-Based Dogma:* Forbid rules like "always Outline in modals" or "always Subtle Fill on cards". Eligibility is perceptual and contrast-driven.
  - *No Raw Hex or Unvalidated Threshold Rules:* Eligibility is not governed by hardcoded raw hexes or unvalidated contrast numbers.

---

## 3. Action Selection Decision Tree

To ensure deterministic decision-making across all features and agents, apply this exact sequential logic:

```
[Evaluate Action]
       │
       ▼
Is this the single essential, valid next step for this active decision unit?
       ├─► YES ──► Is it inside an explicit destructive confirmation context?
       │                 ├─► YES ──► DESTRUCTIVE PRIMARY (Confirmation Context Only)
       │                 └─► NO  ──► DECISION PRIMARY (Stable Black #000000, 6px Radius)
       │
       └─► NO (Supporting / Alternative / Auxiliary Action)
             │
             ▼
       Is the action destructive or consequence-heavy (reject, remove, discard)?
             ├─► YES ──► Paired with Primary or prominent alternative?
             │                 ├─► YES ──► DESTRUCTIVE SECONDARY (Destructive Outline)
             │                 └─► NO (Low-weight utility) ──► DESTRUCTIVE TERTIARY / GHOST
             │
             └─► NO (Neutral / Affirmative Alternative)
                   │
                   ▼
             Is the action low-weight, auxiliary, detail-viewing, or navigation return?
                   ├─► YES ──► TERTIARY / GHOST (15 / 700 / 1.20)
                   │
                   └─► NO (Substantive Supporting Action)
                         │
                         ▼
                   Does Subtle Fill lack sufficient boundary separation against
                   the surrounding container surface in this actual context?
                         ├─► YES ──► CONDITIONAL NEUTRAL OUTLINE
                         └─► NO  ──► NEUTRAL SECONDARY (Subtle Fill Default)
```

---

## 4. Provisional Action Group Contract

### 4.1 Validated Provisional Action Group Patterns

| Pattern Scenario | Primary Role | Secondary / Auxiliary Role | Structural Hierarchy Rule |
| :--- | :--- | :--- | :--- |
| **Primary + Neutral Secondary** | Decision Primary (Black) | Subtle Fill (Neutral) | Primary clearly dominates; Subtle Fill provides quiet alternative. |
| **Primary + Destructive Secondary** | Decision Primary (Black) | Destructive Outline (Red) | Primary holds positive focus; Destructive Outline signals danger without competing. |
| **Primary + Tertiary / Auxiliary** | Decision Primary (Black) | Ghost / Text-like | Absolute dominance for Primary; zero chrome competition from Ghost. |
| **Destructive Confirmation** | Destructive Primary (Red) | Neutral Secondary / Ghost | Destructive action is prominent confirmation; safe exit path clearly accessible. |
| **Multiple Supporting Actions** | Standard Primary (Black) | Subtle Fill + Ghost | Controlled boxed-control density; auxiliary actions recede to Ghost. |

> [!NOTE]
> **Stage 2 Pilot Composition Reference — Not Normative Tokens:**  
> In the Stage 2 Web pilot, pairings utilized an inline gap of `8–10px`, width distributions such as `50/50` or `1.2:1`, and an outline width of `1.5px`. These specific dimensions are **empirical reference examples**, not normative cross-platform tokens. Exact layout spacing, width distributions, and maximum boxed-control limits remain classified as: **`OPEN / IMPLEMENTATION VALIDATION REQUIRED`**.

### 4.2 Group Composition Invariants
1. **Dominance Protection:** Never pair two solid high-contrast buttons side-by-side (e.g., solid black paired with solid red is strictly forbidden).
2. **Target Separation:** Paired controls must maintain sufficient separation between interactive target bounds to prevent accidental mis-taps.
3. **Density Governance:** Avoid excessive boxed-control noise. Role-appropriate density must guide clustering.

---

## 5. RTL Action Order Contract

KONFRM is Arabic-first. Action ordering must be **semantic, not blind mirroring**.

### 5.1 Semantic Slot Model
Action ordering is governed by **semantic slots**, rather than premature universal physical Left/Right mandates:
- `PRIMARY_ACTION_SLOT`: The position reserved for the dominant affirmative decision.
- `SECONDARY_ACTION_SLOT`: The position reserved for the alternative or subordinate action.
- `SAFE_EXIT_SLOT`: The position reserved for dismissal, cancellation, or safe return.
- `CONTEXT_INFORMATION_SLOT`: The position reserved for accompanying data (e.g., price cluster).

### 5.2 Directional & Semantic Rules
1. **Semantic Slot Authority:** Action hierarchy and semantic slot assignments are authoritative. Physical arrangement is resolved by the relevant component family and platform-adaptive presentation.
2. **Consistency by Screen Family:** Within an equivalent component or screen family (e.g., sticky action bars, dialog footers, list cards), slot placement must remain strictly consistent.
3. **Composition-Specific Pattern — Sticky Action Bar:**
   - In the Customer sticky bottom bar pattern evaluated in Stage 2, `CONTEXT_INFORMATION_SLOT` sits at the logical start (Right in RTL), and `PRIMARY_ACTION_SLOT` sits at the logical end (Left in RTL). This reflects the evaluation scan: Context (Right) → Confirmation (Left). This is a **composition-specific pattern**, not a universal global ordering rule for all controls.
4. **Leading Icons in RTL:**
   - Icons accompanying labels are positioned on the **RTL-leading side (Right)** of the text label (document order first).
   - Trailing affordance icons (e.g., chevron) point toward logical forward (Left in RTL).
5. **Directional Icon Semantics:**
   - "Back" arrows point toward logical previous (Right in RTL).
   - "Forward" / "Continue" arrows point toward logical forward (Left in RTL).
   - Non-directional icons (e.g., search, calendar, check, heart) are **never** mirrored.
6. **Bidirectional Sub-run Isolation:**
   - Numbers, prices, phone numbers, and codes inside button labels must use directional isolation (`unicode-bidi: isolate`) to prevent Latin/Arabic punctuation inversion.

---

## 6. Action Group Reflow Contract

### 6.1 Core Architectural Invariant
Action groups must reflow from a horizontal arrangement to a vertical/stacked arrangement **when and only when** the horizontal composition cannot preserve:
1. *Readable complete labels* (zero truncation of decision-critical text).
2. *Valid target geometry* (sufficient target dimensions per platform guidance).
3. *Acceptable spacing* (no crowding between buttons).
4. *Arabic word integrity* (zero mid-word fragmentation or awkward multi-line word wrapping).
5. *Zero clipping and zero overlap*.
6. *Clear visual hierarchy*.

### 6.2 Evidence Grounding & Anti-Overconstraint
- **Validated Web Evidence:** At `360px` viewport under `200%` text scaling (`30px` button text), horizontal side-by-side buttons experience severe layout breakdown: text splinters into cramped vertical lines and button height balloons awkwardly. Vertical stacking (`100% width`) cleanly accommodates `30px` text with complete Arabic words and clear hierarchy (`hybrid_action_360_stress_reflow.png`).
- **Governance Boundary (No Universal Numeric Breakpoints):**
  - There is **no universal `150%` or `200%` scaling breakpoint token**.
  - There is **no universal `360px` hardcoded media query**.
  - The Reflow Contract defines the **required behavior**, not a rigid numeric trigger. Platform-adaptive layout (Flutter layout builders, web container queries) will evaluate label length, density, and scaling dynamically.

---

## 7. Action State Contract

Every button implementation must provide comprehensive state coverage. States must be visually distinct and technically robust.

| State | Behavioral & Perceptual Requirement | Accessibility & Guard Contract | Platform Scope |
| :--- | :--- | :--- | :--- |
| **Default (Resting)** | Clearly interactive and role-correct visual styling. | Base state; interactive; exposed to accessibility tree. | Universal. |
| **Pressed / Active** | Immediate perceivable activation feedback upon touch/click. Zero perceptible delay. | Visual and/or haptic feedback per platform conventions. | Universal. |
| **Focus / Accessible Focus** | Clearly visible focus indicator where applicable; must never be suppressed without replacement. | Meets applicable accessibility criteria; native platform focus indicator on TV/keyboard environments. | Exact native focus treatment: **OPEN**. |
| **Loading** | Progress/busy feedback; visually distinct from ordinary Disabled; retains active feel. | **Multi-Input Activation Suppression:**<br>1. Activation guard across all relevant input paths (touch, mouse, keyboard Space/Enter).<br>2. Accessible busy state (`aria-busy` on Web / platform equivalent).<br>3. Duplicate submission protection. | Universal requirement; native implementation mechanism platform-specific. |
| **Disabled** | Clearly unavailable; not interactive. | Communicates unavailability. If recoverable, replace with recovery action. Disabled primary must communicate *why* where understanding requires it. | Universal. |
| **Hover** | Subtle interactive feedback. | Pointer-capable environments only. | **No mandatory mobile hover** (touch devices have no hover). |
| **Selected** | Clearly distinguishable active state. | Used exclusively where an action carries toggle or selection semantics. | Where semantically applicable. |

> [!NOTE]
> **Stage 2 Web Pilot Reference Treatments — Not Native Contract Tokens:**  
> In the Web pilot, states were demonstrated using specific CSS values: Pressed (`scale(0.98)`, `brightness(0.90)`), Focus (`0 0 0 2px #fff, 0 0 0 4px [color]`), Loading (`opacity: 0.85`, native `disabled`), Disabled (`opacity: 0.45`). These values are **Web pilot reference treatments**, not cross-platform contract tokens. Exact native focus treatments, loading animations, and feedback curves remain: **`OPEN / DEFERRED TO PHASE 4I`**.

---

## 8. Touch Target & Visible Geometry Contract

### 8.1 Separation of Concerns
1. **Visible Component Geometry:** The rendered visual boundary of the button (background, border, padding).
2. **Interactive Touch Target Bounds:** The invisible tappable/clickable hit area evaluated by the operating system touch dispatcher.

### 8.2 Platform Touch Target Guidance
- **iOS Platform Guidance:** Minimum **`44pt × 44pt`** interactive area (per Apple Human Interface Guidelines).
- **Android Platform Guidance:** Minimum **`48dp × 48dp`** interactive area (per Android Material / Accessibility Guidance).
- **Web Prototype Baseline:** `48px` min-height is a web pilot rendering convenience, **not** a cross-platform authority.
- **Rule:** For compact or inline controls (e.g. `IconButton` with a 24px glyph), the invisible touch target container expands to satisfy platform guidance without artificially inflating visual component padding.

---

## 9. Icon Action Contract

1. **IconButton Definition:** An icon-only control with no visible text label.
   - *Mandatory Accessible Name:* Every `IconButton` must declare an accessible label (`aria-label` on Web, `Semantics(label: ...)` on Flutter, tooltip).
   - *Hit Area Guidance:* Visual size may be compact, but interactive hit area satisfies platform guidance (`iOS: 44pt`, `Android: 48dp`).
   - *Emoji Prohibition:* An `IconButton` may **never** use an emoji as its action icon.
2. **Icon + Label Button:**
   - *Placement:* Icon sits on the RTL-leading side (Right).
   - *Visual Balance:* Icon glyph must not overpower button typography.
   - *Spacing:* Balanced inline separation between icon and label.
3. **Icon Family Governance:** Existing web applications use Lucide React. This contract does **not** authorize a project-wide icon library migration. Mobile icon family selection is deferred to Phase 4I.

---

## 10. Role-Specific Composition Lenses

KONFRM is a three-role platform. The Action Contract provides a shared semantic foundation, but composition density and layout reflect distinct user mental models.

### 10.1 Customer Lens (Hospitality & Clarity)
- **Primary Goal:** Booking request confidence, travel choice reassurance, low cognitive friction.
- **Composition Grammar:**
  - One prominent sticky Decision Primary ("Review Request", "Confirm Booking").
  - Generous comfortable touch heights for sticky primary.
  - Clear visual calm: secondary actions remain quiet (Subtle Fill or Ghost).
  - Financial transparency: Price summary cluster always accompanies the sticky CTA.

### 10.2 Owner Lens (Operational Efficiency & Density)
- **Primary Goal:** Operational scanability, clear action priority, rapid decision-making, zero accidental execution.
- **Composition Grammar:**
  - High useful density: tight list cards with distinct action pairings ("Accept" Black vs "Reject" Outline).
  - Clear differentiation between affirmative approval and destructive rejection.
  - Detail inspection ("عرض تفاصيل الحجز") recedes to Ghost to preserve operational focus.
  - Accidental click protection: Destructive actions require explicit touch confirmation or separated placement.

### 10.3 Invariant: "Owner is NOT a Recolored Customer"
The visual identity (Black `#000000`, neutral surfaces) is shared across roles. However, Owner UI prioritizes operational throughput and compact card density, while Customer UI prioritizes experiential calm and sequential flow.

---

## 11. Open Token Register

The following tokens remain strictly **provisional or open**. No implementer may promote these values to final Canon without separate governance approval.

| Variable / Token | Current Working Value | Governance Status | Scope & Boundary |
| :--- | :--- | :--- | :--- |
| **Primary Black** | `#000000` | **SYSTEM-VALIDATED PROVISIONAL** | Locked provisional for Mobile Action System. Evaluated in Stage 2. |
| **Fallback Black** | `#18181B` | **FALLBACK COMPARATOR ONLY** | Validated fallback comparator; not currently needed. |
| **Primary Button Radius** | `6px` | **PROVISIONAL (PRIMARY_ONLY)** | Applies strictly to Primary Black buttons. Does not govern secondary or global shapes. |
| **Secondary Button Radius** | Unspecified | **OPEN** | Secondary radius is unconstrained. Must be formally governed in Phase 4I. |
| **Exact Neutral Palette** | Unspecified | **OPEN** | Pilot rendering values are non-canonical. Neutral token family remains open. |
| **Exact Interaction Blue** | `#276EF1` (candidate) | **OPEN (PILOT CANDIDATE)** | Candidate for links, focus rings, active selection. Forbidden on Primary button backgrounds. |
| **Exact Destructive Color** | Unspecified | **OPEN** | Pilot rendering value is non-canonical. Final semantic danger token remains open. |
| **Exact Native Focus Treatment** | Unspecified | **OPEN** | Web double-ring is reference only; native platform focus indicator deferred to Phase 4I. |
| **Global Shape System** | `radius.json` (Web) | **OPEN** | Global radii across cards, modals, and sheets remain to be harmonized. |
| **Cancellation & Refund Policy**| None | **OPEN / UNDECIDED** | Governed strictly by Product and Financial Canon. Zero design system authority. |
| **Native Component Acceptance**| Web Pilot CSS | **DEFERRED TO PHASE 4I** | Web pilot code does not constitute native Flutter acceptance. |

---

*End of Action System Contract Draft (Phase 4C Stage 3A)*
