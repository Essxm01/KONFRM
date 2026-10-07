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
| (Lists, Tables, Grids)| (with retry CTA), Stale (freshness not guaranteed), Populated|
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
3. **Contextual Empty States:**
   - An empty surface should explain context and provide recovery guidance when meaningful (e.g. "لا توجد طلبات حجز جديدة حالياً").
   - Not every empty surface requires an action CTA; clear, informative communication is sufficient where no immediate user action is possible or desired.
4. **Stale State Precision:**
   - A stale value indicates that current freshness cannot be guaranteed. Presentation depends on the governing product/data contract; UI must never invent background synchronization behavior.
5. **Optimistic UI Boundaries:**
   - The interface must not falsely represent an unconfirmed consequential mutation as completed.
   - Exact mutation authority is governed by Product and Architecture Canon. Implementation strategy belongs to Flutter/Admin; Quality verifies state truthfulness.

---

## 3. Semantic Action Hierarchy

Every screen must declare an unambiguous action hierarchy:

- **Primary Action (CTA):**
  - The single dominant forward step on the screen (e.g. "طلب حجز" on property details; "موافقة" on booking request review).
  - Mobile Primary Black (`#000000`) with `6px` radius (preserves provisional candidate status).
- **Secondary Action:**
  - Important supporting or alternative actions (e.g. "رفض الطلب", "تعديل الفلاتر").
  - Outline or neutral surface treatment to prevent visual competition with the primary CTA.
- **Tertiary Action:**
  - Subtle text links or low-prominence auxiliary functions (e.g. "عرض الشروط والأحكام").
- **Contextual Actions:**
  - Scoped actions embedded within cards or list items (e.g. card overflow menu, thumbnail share trigger).
- **Destructive & Consequential Actions:**
  - Critical irreversible or high-risk operations require distinct visual caution (semantic red indicator).
  - Consequential actions may require explicit confirmation dialogs, while reversible low-risk actions may use inline undo or alternative approved patterns. Where consequential confirmation is required, Phase 4F ConfirmationDialog remains the governed pattern.

---

## 4. Purposeful Motion & Tactile Feedback Intent

- **Transaction-First Motion:**
  - Motion exists to clarify spatial orientation, screen transitions, and state feedback.
  - Motion must NEVER obstruct, delay, or slow down transactional workflows.
  - Upstream duration and easing heuristics (e.g. from Emil Kowalski or third-party libraries) are non-canonical reference candidates; product responsiveness and WCAG reduced-motion constraints always govern.
- **Tactile Haptic Feedback (Optional Platform-Specific Interaction Candidate):**
  - Subtle, purposeful haptic feedback may be evaluated as an interaction candidate on key state milestones.
  - Haptics are NOT mandatory universal Canon. Use only if appropriate to platform, non-redundant, supported by product interaction intent, and validated on physical hardware.
