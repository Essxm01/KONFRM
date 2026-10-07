# Component States, Semantic Actions & Interaction Grammar

```yaml
MODULE: states_interactions.md
BRAIN: konfrm-design
AUTHORITY: DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md §15–§17 + docs/BUSINESS_RULES.md
```

This reference defines the truthful state grammar, action hierarchy, form input ergonomics, and motion principles governing interactive elements across KONFRM surfaces.

---

## 1. Applicable Truthful States Discipline

In DF2 §16, universal state dogma is rejected. Components must never be forced into meaningless states (e.g. an Empty state on a button, or Hover on a mobile touchscreen). Instead, components declare **APPLICABLE TRUTHFUL STATES**:

```text
+-----------------------+-------------------------------------------------------------+
| COMPONENT FAMILY      | APPLICABLE TRUTHFUL STATES                                  |
+-----------------------+-------------------------------------------------------------+
| Action Controls       | Default, Pressed/Active, Focused (keyboard), Disabled,      |
| (Buttons, Links)      | Loading (in-flight submission)                              |
+-----------------------+-------------------------------------------------------------+
| Form Inputs           | Default, Active/Focused, Filled, Error (with validation     |
| (Text fields, selects)| message), Disabled                                          |
+-----------------------+-------------------------------------------------------------+
| Data / Queue Surfaces | Loading (skeletons), Empty (localized guidance), Error      |
| (Lists, Tables, Grids)| (with retry CTA), Stale (syncing in background), Populated |
+-----------------------+-------------------------------------------------------------+
| Platform Modality     | Hover state applies STRICTLY to Desktop Web (Admin);        |
|                       | Hover DOES NOT EXIST on native mobile touchscreens          |
+-----------------------+-------------------------------------------------------------+
```

---

## 2. Truthful State Grammar (Anti-Deception Rules)

1. **Error is Never Empty:**
   - A failed backend read or network timeout must show a clear, localized error state with an explicit retry action (`إعادة المحاولة`).
   - It is strictly forbidden to display an empty list, zero metric, or zero balance when a fetch fails. An empty state is honest ONLY when confirmed by a successful server response.
2. **No Phantom Progress:**
   - Never show simulated 0%→100% progress bars or fake incrementing counters during API operations. Use honest indeterminate spinners or skeleton loaders.
3. **Explicit Actionable Empty States:**
   - Every empty surface must explain in polite Arabic *why* it is empty and *what next step* the user can take (e.g. "لا توجد طلبات حجز جديدة حالياً").
4. **Optimistic UI Boundaries:**
   - Permitted ONLY for non-financial, easily reversible user actions (e.g. bookmarking a favorite property).
   - Strictly PROHIBITED for financial or transactional commitments (booking request submission, deposit payment authorization, payout approvals). These must await server confirmation before transitioning UI state.

---

## 3. Semantic Action Hierarchy

Every screen must declare an unambiguous action hierarchy:

- **Primary Action (CTA):**
  - The single dominant forward step on the screen (e.g. "طلب حجز" on property details; "موافقة" on booking request review).
  - Mobile Primary Black (`#000000`) with `6px` radius.
- **Secondary Action:**
  - Important supporting or alternative actions (e.g. "رفض الطلب", "تعديل الفلاتر").
  - Outline or neutral surface treatment to prevent visual competition with the primary CTA.
- **Tertiary Action:**
  - Subtle text links or low-prominence auxiliary functions (e.g. "عرض الشروط والأحكام").
- **Contextual Actions:**
  - Scoped actions embedded within cards or list items (e.g. card overflow menu, thumbnail share trigger).
- **Destructive Actions:**
  - Critical irreversible operations (e.g. canceling a confirmed reservation). Requires distinct visual caution (semantic red indicator) and mandatory confirmation dialog.

---

## 4. Purposeful Motion & Tactile Feedback Intent

- **Transaction-First Motion:**
  - Motion exists to clarify spatial orientation, screen transitions, and state feedback.
  - Motion must NEVER obstruct, delay, or slow down transactional workflows.
  - Upstream duration and easing heuristics (e.g. from Emil Kowalski or third-party libraries) are non-canonical reference candidates; product responsiveness and WCAG reduced-motion constraints always govern.
- **Tactile Haptic Feedback (Mobile):**
  - Subtle, purposeful haptic feedback on key state milestones (e.g. successful booking request submission, destructive action confirmation).
  - Exact haptic patterns require empirical testing on real iOS and Android hardware.
