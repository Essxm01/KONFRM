# Modal and ConfirmationDialog

Modals and Dialogs represent temporary elevated layers for focused interaction or consequential decision-making when inline or progressive disclosure is unsuitable.

---

## Platform Scope & Presentation

- **Admin Desktop (Desktop Modal):** Desktop operational review uses centered modals or side-sheet panels (`surface.elevated`, desktop close controls, focus management) for audit inspections (`admin_review_queue_1440.png`).
- **Mobile Applications (Dialog vs Sheet):**
  - Mobile tasks are cleanly separated: contextual refinement, pickers, and transient interactions use **BottomSheet**.
  - High-stakes consequential confirmation and destructive decisions use **Dialog**.
  - A Dialog must **never** be used for general navigation, long forms, entity viewing, or multi-step flows.

---

## ConfirmationDialog Grammar

`ConfirmationDialog` is reserved strictly for short, consequential confirmation, high-stakes acknowledgement, and destructive irreversible decisions (e.g. Owner reject booking request).

- **Truthful Verbal Consequence:**
  - The dialog must explicitly articulate the consequence in plain, unambiguous Arabic text.
  - Consequence must **NEVER** rely on color alone.
  - *Governed Owner Reject Example:*
    > "سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون."
  - Strictly prohibits unapproved product claims (e.g. availability reopening, response SLAs, countdowns, reputation/ranking penalties).
  - Customer cancellation dialog is deferred pending cancellation product policy (`DEFERRED_PRODUCT_POLICY`).
- **Action Pair Discipline:**
  - Includes a safe dismiss action ("تراجع" / Cancel) and an explicit consequential action ("تأكيد رفض الطلب").
  - Dismissing the dialog safely cancels the action without mutating server state.
- **Surface Geometry:**
  - **Surface Radius:** **12px** (`SYSTEM-EVALUATED PROVISIONAL DIALOG_RADIUS`).
  - *Evidence:* Bounded visual comparison across 10px, 12px, and 16px (`dialog_radius_10_owner_390.png`, `dialog_radius_12_owner_390.png`, `dialog_radius_16_owner_390.png`) confirms 12px provides structural harmony with Phase 4E 12px containers, avoiding the sharp corners of 10px and the excess softness of 16px.
  - *Scope:* Applies strictly to mobile Dialog modal surfaces.
- **Elevation & Scrim:**
  - Clear modal layer separation over dimmed scrim.
  - Exact shadow parameters (pilot reference `0 12px 36px rgba(15,23,42,0.16)`) and scrim opacity/blur values are **`OPEN / CONTROLLED_WEB_PILOT_RENDERING_REFERENCE`**.
  - Physical mobile acceptance is **`DEFERRED_TO_4I`**.
