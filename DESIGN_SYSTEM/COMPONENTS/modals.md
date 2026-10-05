# Modals & Confirmation Dialogs

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Geometric Invariants:**
  - `radius.dialog`: **12px** (`SYSTEM_EVALUATED_PROVISIONAL_DIALOG_RADIUS`).
  - Action Pair Discipline: Exactly one safe dismiss action + one explicit consequential action.
  - Plain Arabic Consequence: Verbal consequence must be fully articulated; never relies on color alone.
- **Open Parameters:** Exact scrim opacity/blur and modal elevation shadow (`OPEN / DEFERRED_TO_4I`). Pilot reference `0 12px 36px rgba(15,23,42,0.16)`.
- **Anti-Patterns:** Dialog is **NEVER** a general navigation surface, long form container, entity viewer, or multi-step wizard.

---

## 2. Terminology & Platform Reconciliation

KONFRM formally distinguishes between desktop web modal dialogs and mobile confirmation dialogs:

| Contract | Target Platform | Primary Role | Presentation Grammar |
|---|---|---|---|
| `ConfirmationDialog` | Native Mobile (iOS/Android) | Consequential confirmation & destructive decisions | Centered elevated modal surface (12px radius), high-contrast consequence text, safe/destructive action pair. |
| `DesktopModal` | Admin Desktop Web | Operational audit & dense inspection | Centered 12px modal or wide overlay panel with desktop close controls and dense record tabs (`admin_review_queue_1440.png`). |

---

## 3. ConfirmationDialog Grammar & Props

`ConfirmationDialog` is reserved strictly for short, consequential confirmation, high-stakes acknowledgement, and destructive irreversible decisions (e.g. Owner reject booking request).

| Prop / Element | Type / Role | Description & Requirements |
|---|---|---|
| `title` | Heading string | Clear, unambiguous Arabic title (e.g. "رفض طلب الحجز"). |
| `consequenceText` | Explanatory string | Truthfully articulates the concrete consequence in plain Arabic. Example: *"سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون."* Strictly prohibits unapproved product claims (reopening availability, response SLAs, countdowns, ranking penalties). |
| `confirmAction` | Action button | Explicit consequential action (e.g. "تأكيد رفض الطلب"). Uses danger or primary styling. Enters `SUBMITTING` spinner during API call. |
| `cancelAction` | Action button | Safe dismiss action (e.g. "تراجع"). Safe dismiss leaves all state unchanged. |

Customer cancellation dialog copy and financial penalty warnings are explicitly deferred pending cancellation product policy (`DEFERRED_PRODUCT_POLICY`).

---

## 4. State Matrix

| State | Visual Behavior | Interactive Behavior |
|---|---|---|
| `PRESENTED / IDLE` | Modal surface centered over dark scrim. Text clearly legible. Both action buttons active. | User can choose to confirm or dismiss. Backdrop click disabled if dirty/destructive. |
| `SUBMITTING` | Confirm button shows spinner (`SUBMITTING`); cancel button disabled. Scrim remains locked. | All dismiss actions (Escape, backdrop click) temporarily blocked. |
| `DISMISSING` | Modal fades/scales down smoothly. Scrim fades out. | Focus returned to triggering button on underlying page. |
| `CLOSED` | Unmounted from DOM / accessibility tree. | Parent surface returns to interactive state. |
| `ERROR` | In-modal scoped alert displayed above action buttons explaining failure. Confirm button re-enabled. | User can retry confirmation or safely dismiss dialog. |

---

## 5. Role Differences

- **Customer:** Consequential actions are rare; high-stakes decisions (e.g. cancellation) require explicit product policy before implementation (`DEFERRED_PRODUCT_POLICY`). General customer browsing uses nested pages or BottomSheets.
- **Owner:** Owner uses `ConfirmationDialog` for rejecting booking requests (`dialog_radius_12_owner_390.png`), deleting draft listings, or blocking dates with irreversible impact.
- **Admin:** Admin uses `DesktopModal` for approving/rejecting KYC documents, banning accounts, or releasing disputed payouts (`admin_review_queue_1440.png`).

---

## 6. RTL & Bidirectional Layout Rules

- **Text Alignment:** Dialog title and consequence explanation align strictly to the right (`text-align: right`).
- **Action Button Pair:**
  - In horizontal layout: Primary/Consequential action on the right (logical start); Safe Dismiss action on the left (logical end).
  - In vertical stacked layout: Primary/Consequential action on top; Safe Dismiss action below.
- **Directional Isolation:** If entity codes, IDs, or numbers appear in the consequence copy, they are isolated using `<bdi>` tags to prevent punctuation flip.

---

## 7. Accessibility & Focus Management

- **ARIA Role:** `role="alertdialog"` for destructive confirmations; `role="dialog"` for standard acknowledgements. `aria-modal="true"`.
- **Labeling:** `aria-labelledby` points to dialog title; `aria-describedby` points to consequence text.
- **Focus Trap:** Focus is strictly trapped within the dialog. Tab cycles between confirm and cancel buttons.
- **Escape Key:** Pressing `Escape` triggers safe dismiss (`cancelAction`).

---

## 8. Composition Invariants & Anti-Patterns

1. **Single Layer Discipline:** Exactly one modal or dialog can be open at any time. Cascading dialogs over dialogs is prohibited.
2. **Never for General Tasks:** Never use a dialog for form entry, address search, or multi-step wizardry. Use full-screen nested pages.
3. **No Unapproved Product Promises:** Consequence text must state only verified technical truth. Do not invent marketing, legal, or SLA claims.
