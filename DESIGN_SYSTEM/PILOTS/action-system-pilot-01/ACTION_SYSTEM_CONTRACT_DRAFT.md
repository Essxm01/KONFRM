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
This Action Contract formalizes the semantic, structural, and behavioral rules of the KONFRM Action System, derived from the independently validated visual and operational findings of Phase 4C Stage 2. It defines the grammar for all actionable controls across Customer and Owner surfaces (with Admin compatibility noted).

### 1.2 Upstream Authority & Source Precedence
This contract is subordinated to the KONFRM source-of-truth hierarchy (`docs/codex/KONFRM_MASTER_RULES.md` and `DESIGN_SYSTEM/GOVERNANCE.md`):
1. Latest explicit Founder decisions (Stable Black `#000000`, 6px Primary Radius, Cairo Profile B, Contextual Hierarchy Hybrid Strategy).
2. Canonical Product & Financial Truth (`BUSINESS_RULES.md`; server-authoritative state; zero invented cancellation/refund policies).
3. Mobile Design Foundation (DF2 v1.1 monochrome-first identity; high useful density).
4. Platform conventions (Apple HIG / Android Material 3).
5. Controlled Web evidence (Stage 2 active evidence suite).

### 1.3 Governance Classification
- **Contract Level:** `SYSTEM-VALIDATED PROVISIONAL CONTRACT DRAFT`
- **Component Scope:** Buttons, Action Pairings, Action Groups, Sticky Action Bars, Icon Actions, and Confirmation Workflows.
- **Production Scope:** Zero production code modification in this stage. Native Flutter implementation and acceptance remain strictly deferred to Phase 4I.

---

## 2. Semantic Action Role Model

The KONFRM Action System defines seven distinct semantic action roles. Visual presentation is determined primarily by **Action Semantics and Hierarchy**, not by arbitrary container types.

| Action Role | Semantic Purpose | Provisional Treatment | Key Geometry & Typography | Hierarchy Rank |
| :--- | :--- | :--- | :--- | :--- |
| **1. Decision Primary** | The single essential, valid next step in the current lifecycle decision area. | **Stable Black (`#000000`)** with high-contrast white text | Radius: `6px` (`PRIMARY_ONLY`)<br>Cairo `15 / 700 / 1.20` | Highest (Rank 1) |
| **2. Standard Primary** | Important completion action within a local task/section not competing with a Decision Primary. | **Stable Black (`#000000`)** | Radius: `6px` (`PRIMARY_ONLY`)<br>Cairo `15 / 700 / 1.20` | Local Dominant (Rank 2) |
| **3. Neutral Secondary** | Subordinate non-destructive alternative or supporting action. | **Subtle Fill** (Default Provisional) | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Subordinate (Rank 3) |
| **4. Destructive Secondary** | Subordinate rejection or destructive action paired with a non-destructive Primary. | **Destructive Outline** | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Subordinate Danger (Rank 3D) |
| **5. Destructive Primary** | Confirmation of an intentional destructive action within an explicit confirmation context. | **Destructive Solid Fill** | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Confirmation Dominant (Rank 1D) |
| **6. Tertiary / Ghost** | Low-weight, auxiliary, detail-expansion, or edit-return navigation action. | **Ghost / Text-like** (Transparent fill, zero border) | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` (or `13–14px` contextual) | Auxiliary (Rank 4) |
| **7. Conditional Neutral Outline** | Neutral secondary requiring stronger perimeter when Subtle Fill loses boundary contrast against surrounding surface. | **Neutral Outline** (1.5px border, transparent fill) | Radius: `OPEN`<br>Cairo `15 / 700 / 1.20` | Conditional Subordinate (Rank 3-Outline) |

---

### Detailed Role Specifications

#### Role 1: Decision Primary
- **Semantic Definition:** The one action that advances the user's primary business or lifecycle intent on the current screen (e.g., Customer "Review Booking Request", Owner "Accept Booking Request").
- **Visual Expression:** Solid Pitch Black (`#000000`) fill, pure white text, provisional `6px` border radius, Cairo Profile B (`15px`, bold 700, line-height 1.20).
- **Invariants:**
  1. *Uniqueness:* Exactly **one** Decision Primary may exist within a single decision point or viewport.
  2. *Lifecycle Validity:* A Decision Primary must represent an actionable, server-valid transition. It must **never** visually imply a lifecycle transition that canonical backend state does not permit.
  3. *State-Aware Recovery:* When a prerequisite fails (e.g., availability quote failure), the primary slot may temporarily host a Recovery Action (e.g., "Retry Availability") to communicate the next valid step rather than a generic dead-end disabled CTA.
  4. *Anti-Pattern:* Never treat every generic submit button or card button as a Decision Primary.

#### Role 2: Standard Primary
- **Semantic Definition:** An action that completes a self-contained local task (e.g., "Apply Filters", "Save Dates") where no screen-level Decision Primary is present or where the modal context isolates the task.
- **Hierarchy Boundary:** If a screen has both a sticky Decision Primary and local sections, local sections must use Secondary or Tertiary actions to avoid visual competition. Two solid black primaries must never compete for visual dominance in the same viewport.

#### Role 3: Neutral Secondary
- **Semantic Definition:** The primary alternative to a Primary action for non-destructive operations (e.g., "Edit Dates", "Change Unit Price", "Dismiss Modal").
- **Provisional Treatment:** **Subtle Fill** (light neutral background, dark neutral text, zero harsh border).
- **Policy Protection:** "Cancel in-flight edit" is local UI navigation and state reversion. It carries **zero** implication regarding booking cancellation or deposit refund policies (`CANCELLATION_REFUND_POLICY: OPEN / UNDECIDED`).
- **Open Boundaries:** The exact hex for Subtle Fill remains `OPEN` (pilot `#F1F5F9` is a non-canonical rendering value). Border radius is `OPEN` (does not automatically inherit Primary 6px).

#### Role 4: Destructive Secondary
- **Semantic Definition:** A negative, rejection, or discard action presented alongside an affirmative Primary action (e.g., Owner "Reject Request" paired with "Accept Request").
- **Provisional Treatment:** **Destructive Outline** (subtle red perimeter, transparent background, red text).
- **Hierarchy Function:** Signals consequence and danger without seizing visual dominance from the Primary action. The user's eye lands on the Primary first, but clearly distinguishes the danger perimeter of the secondary action.
- **Product Truth Protection:** A Destructive Secondary cannot invent product capability. Rejection or cancellation controls may be rendered only where server-side lifecycle rules allow that transition.

#### Role 5: Destructive Primary
- **Semantic Definition:** The affirmative confirmation of an irreversible or high-consequence destructive operation.
- **Strict Gating Rules:**
  1. *Confirmation Context Gated:* Must be rendered **exclusively** within an explicit confirmation sheet, dialog, or modal.
  2. *Forbidden on Top-Level Surfaces:* Never use Destructive Primary on top-level browsing, dashboard cards, or list items.
  3. *Dominance Alignment:* Within the confirmation dialog, the destructive action is the decision being affirmed (e.g., "Confirm Property Removal"), paired with a Neutral Secondary or Ghost safe exit ("Keep Property").

#### Role 6: Tertiary / Ghost / Text-Like
- **Semantic Definition:** Low-emphasis, auxiliary, or repetitive actions (e.g., "View Breakdown", "Show Terms", "Back").
- **Visual Expression:** Zero border, transparent fill, text label with an interactive touch target.
- **Eligibility & Restrictions:**
  - *Eligible:* Where an action is supporting, informational, or occurs repeatedly in a list without warranting container chrome.
  - *Forbidden:* Never use Ghost for decision-critical actions, where action discoverability would be compromised, or where a user cannot perceptually identify the tappable area.

#### Role 7: Conditional Neutral Outline (Stage 3 Formalization)
- **Problem Solved:** Stage 2 validated that a rigid "Subtle Fill only" secondary rule fails when a card or sheet background is already tinted neutral/gray, causing Subtle Fill buttons to dissolve into the surface.
- **Deterministic Eligibility Rule:**
  A non-destructive secondary action **MUST** use Neutral Outline **if and only if** all of the following conditions are met:
  1. *Surface Contrast Insufficiency:* The underlying container surface has a non-white fill (e.g., `#F8FAFC`, `#F1F5F9`, or elevated dark-neutral surface) such that a Subtle Fill button fails to maintain a clear perceptual boundary (contrast delta < 1.15:1 against container).
  2. *Affordance Requirement:* The action requires stronger visible perimeter affordance than a Ghost/Text-like button can deliver.
  3. *Non-Destructive Semantics:* The action is strictly neutral/non-destructive.
  4. *Visual Hierarchy Balance:* The 1.5px neutral outline does not compete with or overpower the solid Primary Black button.
- **Strict Prohibitions:**
  - *Forbidden on Pure White Surfaces:* On standard `#FFFFFF` surfaces, Neutral Secondary **must** use Subtle Fill.
  - *No Container-Based Dogma:* Forbid rules like "always Outline in modals" or "always Subtle Fill on cards". Eligibility is perceptual and contrast-driven.
  - *Anti-Clutter Rule:* Forbid Neutral Outline where adjacent inputs or borders already create visual border clutter ("box soup").

---

## 3. Action Selection Decision Tree

To ensure deterministic decision-making across all features and agents, apply this exact sequential logic:

```
[Evaluate Action]
       │
       ▼
Is this the single essential, valid next step in the current decision area?
       ├─► YES ──► Is it an irreversible confirmation inside a confirmation modal?
       │                 ├─► YES ──► DESTRUCTIVE PRIMARY (Solid Red, Confirmation Only)
       │                 └─► NO  ──► DECISION PRIMARY (Stable Black #000000, 6px Radius)
       │
       └─► NO (Supporting / Alternative / Auxiliary Action)
             │
             ▼
       Is the action destructive or consequence-heavy (reject, remove, discard)?
             ├─► YES ──► Paired with Primary or standard alternative?
             │                 ├─► YES ──► DESTRUCTIVE SECONDARY (Destructive Outline)
             │                 └─► NO (Low-weight utility) ──► DESTRUCTIVE GHOST
             │
             └─► NO (Neutral / Affirmative Alternative)
                   │
                   ▼
             Is the action low-weight, auxiliary, detail-viewing, or navigation return?
                   ├─► YES ──► TERTIARY / GHOST / TEXT-LIKE
                   │
                   └─► NO (Substantive Supporting Action)
                         │
                         ▼
                   Does the button sit on a non-white / tinted container surface
                   where Subtle Fill lacks sufficient perimeter contrast?
                         ├─► YES ──► CONDITIONAL NEUTRAL OUTLINE (1.5px Neutral Border)
                         └─► NO  ──► NEUTRAL SECONDARY (Subtle Fill Default)
```

---

## 4. Action Group Contract

### 4.1 Canonical Action Pairings

| Pairing Scenario | Primary Control | Secondary Control | Layout & Spacing | Visual Hierarchy Rule |
| :--- | :--- | :--- | :--- | :--- |
| **Primary + Neutral Secondary** | Decision Primary (Black) | Subtle Fill (Neutral) | Horizontal (50/50 or 1.2:1) or Stacked; 8–10px gap | Black CTA clearly dominates; Subtle Fill provides quiet alternative. |
| **Primary + Destructive Secondary** | Decision Primary (Black) | Destructive Outline (Red) | Horizontal (1.2:1 preferred) or Stacked; 8–10px gap | Primary Black holds positive focus; Destructive Outline provides clear danger cue without competing. |
| **Primary + Tertiary / Auxiliary** | Decision Primary (Black) | Ghost / Text-like | Primary full-width; Ghost inline or stacked below; 8px gap | Absolute dominance for Primary; zero chrome competition from Ghost. |
| **Destructive Confirmation** | Destructive Primary (Red) | Neutral Secondary / Ghost | Stacked or 50/50; 8–10px gap | Destructive action is prominent confirmation; safe exit ("Keep/Cancel") clearly accessible. |
| **Multiple Supporting Actions** | Standard Primary (Black) | 1x Subtle Fill + 1x Ghost | Maximum 2 boxed buttons; 3rd action must be Ghost / Text | Never place 3 boxed buttons side-by-side. |

### 4.2 Group Composition Invariants
1. **Dominance Protection:** Never pair two solid high-contrast buttons side-by-side (e.g., solid black paired with solid red or solid blue is strictly forbidden).
2. **Spacing Semantics:** Inline gap between paired controls must be minimum `8px`, standard `10–12px`.
3. **Touch Separation:** Paired controls must maintain distinct interactive target bounds to prevent erroneous taps.

---

## 5. RTL Action Order Contract

KONFRM is Arabic-first. Action ordering must be **semantic, not blind mirroring**.

### 5.1 Directional & Semantic Flow
1. **Reading Order vs Action Dominance:**
   - In standard Arabic RTL reading flow (right-to-left), the user's scan begins at the **logical start (Right)** and concludes at the **logical end (Left)**.
   - For **inline or dialog pairs** (Side-by-Side):
     - Decision Primary sits at the **logical end (Left)** as the terminal conclusion of the evaluation scan, OR at the **logical start (Right)** when leading the affirmative path.
     - *Rule:* Within any screen family, maintain strict semantic consistency. The affirmative Primary must consistently occupy the primary action slot.
2. **Sticky Bottom Action Bars:**
   - Price / Context Cluster sits at **logical start (Right)**.
   - Decision Primary CTA sits at **logical end (Left)**.
   - Visual flow: Information scan (Right) → Decision confirmation (Left).
3. **Leading Icons in RTL:**
   - Icons accompanying labels must be positioned on the **RTL-leading side (Right)** of the text label (document order first).
   - Trailing affordance arrows (e.g., Chevron) point toward logical next/forward (Left in RTL).
4. **Directional Icon Semantics:**
   - "Back" arrows point toward logical previous (Right in RTL).
   - "Forward" / "Continue" arrows point toward logical forward (Left in RTL).
   - Non-directional icons (e.g., search, calendar, check, heart) are **never** mirrored.
5. **Bidirectional Sub-run Isolation:**
   - Numbers, prices, phone numbers, and codes inside button labels must use directional isolation (`unicode-bidi: isolate`) to prevent Latin/Arabic punctuation inversion.

---

## 6. Action Group Reflow Contract

### 6.1 Core Architectural Invariant
Action groups must reflow from a horizontal arrangement to a vertical/stacked arrangement **when and only when** the horizontal composition cannot preserve:
1. *Readable complete labels* (zero truncation of decision-critical text).
2. *Valid target geometry* (sufficient width and height per platform guidelines).
3. *Acceptable spacing* (no crowding between buttons).
4. *Arabic word integrity* (zero mid-word fragmentation or awkward multi-line word wrapping).
5. *Zero clipping and zero overlap*.
6. *Clear visual hierarchy*.

### 6.2 Evidence-Based Grounding
- **Validated Web Evidence:** At `360px` viewport under `200%` text scaling (`30px` button text), horizontal side-by-side buttons experience severe layout breakdown: text splinters into 3 cramped vertical lines and button height balloons awkwardly. Vertical stacking (`100% width`) cleanly accommodates `30px` text with complete Arabic words and perfect hierarchy (`hybrid_action_360_stress_reflow.png`).
- **Governance Boundary (Anti-Overconstraint):**
  - There is **no universal `150%` or `200%` scaling breakpoint token**.
  - There is **no universal `360px` hardcoded media query**.
  - The Reflow Contract defines the **required behavior**, not a rigid numeric trigger. Platform adaptive layout (Flutter layout builders, web flex-wrap/container queries) will evaluate label length, density, and scaling dynamically.

---

## 7. Action State Contract

Every button implementation must provide comprehensive state coverage. States must be visually distinct and technically robust.

| State | Visual Treatment | Technical / Accessibility Contract | Platform Note |
| :--- | :--- | :--- | :--- |
| **Default (Resting)** | Standard role styling (Solid Black, Subtle Fill, Outline, Ghost). | Base state; interactive; exposed to accessibility tree. | Fully responsive. |
| **Pressed / Active** | `transform: scale(0.98)` + brightness shift (`0.90` on black, subtle tint on secondary). | Immediate haptic/visual touch feedback. Zero delay. | Essential on mobile touch. |
| **Focus-Visible** | **Double-ring high contrast offset:**<br>Inner: 2px white gap (`#FFFFFF`)<br>Outer: 2px prominent ring (Black `#000000` or Danger `#DC2626`). | Must appear on keyboard / switch / screen-reader focus. Must never be suppressed (`outline: none` forbidden without replacement). | Meets WCAG 2.2 AA in web; platform native focus indicator on TV/keyboard mobile. |
| **Loading** | Opacity `0.85` (maintains high contrast); active spinner replaces or precedes text label. | **Multi-Input Activation Suppression:**<br>1. Native `disabled` attribute / interactive suppression.<br>2. `aria-busy="true"` on Web / platform busy state.<br>3. Suppresses mouse, touch, Space, and Enter keys.<br>4. Visually distinct from ordinary Disabled (`0.85` vs `0.45`). | Prevents duplicate booking or payment submissions. |
| **Disabled** | Opacity `0.45`; zero pointer events; neutral grayed appearance. | Not interactive; communicates unavailability. Disabled primary must communicate *why* where user understanding requires it. | If recoverable, replace with recovery action. |
| **Hover** | Subtle background tint / brightness shift. | Pointer-capable environments only. | **No mandatory mobile hover** (touch devices have no hover). |
| **Selected** | Low-emphasis brand accent surface (`#EAF1FF` candidate) or active border. | Used exclusively where an action carries toggle or selection semantics. | Not applicable to standard push buttons. |

---

## 8. Touch Target & Visible Geometry Contract

### 8.1 Separation of Concerns
1. **Visible Component Geometry:** The rendered visual boundary of the button (background, border, padding).
2. **Interactive Touch Target Bounds:** The invisible tappable/clickable hit area evaluated by the operating system touch dispatcher.

### 8.2 Platform-Appropriate Targets
- **iOS Platform Target:** Minimum **`44pt × 44pt`** interactive area (per Apple HIG).
- **Android Platform Target:** Minimum **`48dp × 48dp`** interactive area (per Material 3 / Google Play).
- **Web Prototype Baseline:** `48px` min-height is a web pilot rendering convenience, **not** a cross-platform authority.
- **Rule:** For compact or inline controls (e.g. `IconButton` with a 24px glyph), expand the invisible touch target container to satisfy platform minimums without artificially inflating visual component padding.

---

## 9. Icon Action Contract

1. **IconButton Definition:** An icon-only control with no visible text label.
   - *Mandatory Accessible Name:* Every `IconButton` must declare an accessible label (`aria-label` on Web, `Semantics(label: ...)` on Flutter, tooltip).
   - *Hit Area:* Visual size may be compact (`32–40px`), but interactive hit area must satisfy platform targets (`iOS: 44pt`, `Android: 48dp`).
   - *Emoji Prohibition:* An `IconButton` may **never** use an emoji as its action icon.
2. **Icon + Label Button:**
   - *Placement:* Icon sits on the RTL-leading side (Right).
   - *Visual Balance:* Icon size must not overpower button typography (recommended glyph size: `18–20px` paired with `15px` Cairo text).
   - *Spacing:* Inline gap of `8px` between icon and label.
3. **Icon Family Governance:** Existing web applications use Lucide React. This contract does **not** authorize a project-wide icon library migration. Mobile icon family selection is deferred to Phase 4I.

---

## 10. Role-Specific Composition Lenses

KONFRM is a three-role platform. The Action Contract provides a shared semantic foundation, but composition density and layout reflect distinct user mental models.

### 10.1 Customer Lens (Hospitality & Clarity)
- **Primary Goal:** Booking request confidence, travel choice reassurance, low cognitive friction.
- **Composition Grammar:**
  - One prominent sticky Decision Primary ("Review Request", "Confirm Booking").
  - Generous comfortable touch heights (`52–56px` for sticky primary).
  - Clear visual calm: secondary actions remain quiet (Subtle Fill or Ghost).
  - Financial transparency: Price summary cluster always accompanies the sticky CTA.

### 10.2 Owner Lens (Operational Efficiency & Density)
- **Primary Goal:** Operational scanability, clear action priority, rapid decision-making, zero accidental execution.
- **Composition Grammar:**
  - High useful density: tight list cards with distinct action pairings ("Accept" Black 1.2:1 vs "Reject" Outline 1:1).
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
| **Secondary Button Radius** | `6px` (in pilot) | **OPEN** | Pilot value is for fair visual comparison only. Must be formally governed in Phase 4I. |
| **Exact Neutral Palette** | `#F1F5F9`, `#CBD5E1`, etc. | **OPEN** | Pilot rendering values only. Neutral token family remains open. |
| **Exact Interaction Blue** | `#276EF1` | **OPEN (PILOT CANDIDATE)** | Candidate for links, focus rings, active selection. Forbidden on Primary button backgrounds. |
| **Exact Destructive Red** | `#DC2626` | **OPEN** | Pilot rendering value. Final semantic danger token remains open. |
| **Global Shape System** | `radius.json` | **OPEN** | Global radii across cards, modals, and sheets remain to be harmonized. |
| **Cancellation & Refund Policy**| None (Placeholder text neutralized) | **OPEN / UNDECIDED** | Governed strictly by Product and Financial Canon. Zero design system authority. |
| **Native Component Acceptance**| Web Pilot CSS | **DEFERRED TO PHASE 4I** | Web pilot code does not constitute native Flutter acceptance. |

---

*End of Action System Contract Draft (Phase 4C Stage 3A)*
