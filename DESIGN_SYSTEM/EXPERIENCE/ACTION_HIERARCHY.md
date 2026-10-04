# Action and Control Hierarchy

**Governance Status:** `SHARED SEMANTIC SPECIFICATION`  
**Phase Integration:** Phase 4C Stage 3B (Targeted Shared Governance Synchronization)  
**Authority Boundary:** Defines shared semantic action levels across KONFRM applications without conflating Web runtime tokens with Mobile provisional results.

---

## 1. Action Levels and Semantic Grammar

Action presentation is governed primarily by **Action Semantics, Consequence, and Hierarchy**:

| Level | Semantic Role | Shared Intent | Platform Presentation Mapping |
| :--- | :--- | :--- | :--- |
| **Decision-Primary** | Essential valid next step for an active decision point | Clear dominant placement; guides user to next valid transition. | **Web:** `brand.primary` button.<br>**Mobile (Phase 4C Provisional):** Stable Black `#000000`, 6px Primary-only radius, Cairo Profile B `15 / 700 / 1.20`. *(Native acceptance deferred to Phase 4I)*. |
| **Standard Primary** | Page-level or section completion not competing with a Decision Primary | Completes a self-contained local task. | **Web:** Existing Web Primary component/token authority (`brand.primary`).<br>**Mobile (Phase 4C Provisional):** Stable Black `#000000`, 6px `PRIMARY_ONLY` provisional radius, Cairo Profile B `15 / 700 / 1.20` where implemented as a button-shaped control. Must remain isolated to local task and must never compete with Decision Primary for the same decision hierarchy. |
| **Secondary** | Reversible supporting action or subordinate alternative | Accessible alternative without stealing visual focus. | **Web:** `surface.secondary` or Outline.<br>**Mobile (Phase 4C Provisional):** Subtle Fill as default provisional; Conditional Neutral Outline when needed for boundary separation. |
| **Tertiary / Inline** | Auxiliary, detail inspection, or low-friction navigation | Recedes visually to preserve focus on primary tasks. | **Web:** Ghost / text-like treatment according to current Web component/token authority (`typography.button` / existing Web typography remains unchanged).<br>**Mobile (Phase 4C Provisional):** Ghost / text-like treatment. If implemented as a button-shaped/tappable Button component: Cairo Profile B `15 / 700 / 1.20`; true inline text actions use applicable governed mobile text role. Must remain discoverable. |
| **Contextual** | Object-attached or task-attached action | Attached to the object/task it affects (row, card, item). | **Attachment relationship**, not an arbitrary visual style. Treatment follows hierarchy (Primary, Secondary, Tertiary, or Destructive) within that object. |
| **Icon-Only** | Compact auxiliary action | Familiar symbol with mandatory accessible label. | Existing icon family consistently used; hit bounds satisfy platform guidance. No emoji icons. |
| **Destructive** | Negative, removal, discard, or consequence-bearing action | Consequence-aware presentation; prevents accidental execution. | **Consequence Dimension:** Destructive Outline for subordinate pairing; Destructive Primary inside explicit confirmation context; Destructive Ghost strictly for low-consequence utilities. |

---

## 2. Core Hierarchy Principles

### 2.1 Decision Primary Uniqueness & Coexistence
- **Uniqueness Scope:** Exactly **one Decision Primary per active decision point / decision unit**.
- **Multi-Object Coexistence:** Multiple Decision Primaries may coexist in the same viewport **only** when they belong to distinct, independently actionable objects or cards (e.g., consecutive Owner booking request cards in an operational list). They must never compete for visual dominance within the same decision hierarchy.
- **Prerequisite Failure & Recovery:** When a prerequisite fails (e.g., availability quote failure), the primary slot may temporarily host a Recovery Action (e.g., "Retry Availability") to communicate the next valid step rather than displaying a dead-end disabled CTA.

### 2.2 Consequence-Aware Destructive Actions
- **Consequence Dimension:** Destructive is not an ad-hoc visual style, but a semantic consequence dimension.
- **Subordinate Placement:** Outside an explicit destructive confirmation context, consequential actions remain visibly separated and subordinate (typically Destructive Outline).
- **Confirmation Context (Destructive Primary):** In an explicit destructive confirmation context (dialog, sheet, modal, full-screen confirmation, or other platform-appropriate confirmation surface), the consciously confirmed destructive action may be styled as a dominant Destructive Primary, provided a clear safe-exit path is accessible and Product Canon permits the action.
- **Consequence-Aware, Not Universal:** Confirmation is required when consequence severity or irreversibility warrants it per Product/UX authority. Routine or low-consequence destructive actions do not require two-step confirmation modals.
- **Low-Consequence Gate for Ghost:** High-consequence or material destructive actions must **never** be styled as Ghost merely because they are unpaired. Ghost treatment is permitted only for genuinely low-consequence, reversible, non-critical utilities where discoverability remains intact and Product Canon permits the capability.

---

## 3. Role-Specific Examples and Lifecycle Correctness

The Action System defines hierarchy and treatment; it does **not** redefine or compress business lifecycle transitions (`UX-ACTION-01`):

### 3.1 Customer Examples (Hospitality & Lifecycle Truth)
- **Booking Flow Decision Primary:** A Customer's valid action prior to owner approval is to submit or review their request (e.g., "Review Booking Request" or "Submit Booking Request").
- **Lifecycle Safety:** Never use labels like "Confirm Booking", "Booking Confirmed", or "Finalize Booking" that imply the customer directly creates a confirmed booking state before owner acceptance. Request ≠ Confirmed.
- **Payment Authorization:** Payment may become a Decision Primary **only** when canonical booking state advances to a state permitting payment authorization.
- **Auxiliary Actions:** Customer auxiliary actions such as share, favorite, or property detail access remain subordinate to the active Decision Primary and use the appropriate Contextual, Icon-only, Secondary, or Tertiary role according to actual affordance, placement, and semantics.

### 3.2 Owner Examples (Operational Density & Speed)
- **Pending Booking Request Card:** "Accept Request" (or "Approve") is Decision Primary (Stable Black). "Reject Request" is Destructive Secondary (Destructive Outline).
- **Detail Inspection:** "عرض تفاصيل الحجز" (View Details) recedes to Tertiary / Ghost to preserve operational scanability.
- **Confirmation Rules:** Rejection or cancellation controls require confirmation when consequence warrants it per Product/UX rules; confirmation is not blindly forced on every routine operational action.

### 3.3 Admin Review Examples
- Admin review decision actions that are already permitted by canonical Product state (e.g., approve listing in an authorized review workflow) are prominent only within the active review context. Outside that context, they remain subordinate. Zero unapproved workflows or capabilities (such as dispute, revision-request, or account suspension flows) may be inferred or invented from design examples.

---

## 4. Control Sizing and Touch Target Guidance

| Size / Surface | Use Case | Interactive Touch Target Guidance |
| :--- | :--- | :--- |
| **Comfortable (Mobile)** | Mobile primary decisions, sticky action bars, high-frequency fields | **iOS:** Minimum `44pt × 44pt`<br>**Android:** Minimum `48dp × 48dp` |
| **Standard (Mobile)** | Default forms, list card actions, subordinate controls | **iOS:** Minimum `44pt × 44pt`<br>**Android:** Minimum `48dp × 48dp` |
| **Compact-Desktop / Admin** | Admin filters, tables, desktop web tools | Governed by Web accessibility (WCAG) and pointer/keyboard criteria. |

### Separation of Bounds vs Geometry
- **Visible Component Geometry:** Visual padding, height, and border. Exact mobile component height is `OPEN / IMPLEMENTATION VALIDATION REQUIRED`.
- **Interactive Target Bounds:** The tappable hit area. Compact or inline controls expand their hit target containers to satisfy platform guidance (iOS 44pt / Android 48dp) without distorting visible component padding.

---

## 5. State-Aware Decision Actions

A decision CTA must communicate the **next valid action**, not merely remain disabled with generic wording:
1. **Canonical Progression:** A Customer property decision moves through canonical steps: choose dates → choose checkout → loading availability → retry availability (if error) → calculating quote → retry quote (if error) → review booking request.
2. **Recovery Actions:** Recovery actions may temporarily become decision-primary when a canonical prerequisite fails.
3. **Product Truth Preservation:** A booking or payment CTA must **never** visually imply a lifecycle transition that canonical backend state does not currently permit.
