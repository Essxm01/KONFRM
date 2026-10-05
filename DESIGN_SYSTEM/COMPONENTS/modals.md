# Modals & Confirmation Dialogs

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Maturity & Scoping Disclaimer:** This document governs modal and confirmation dialog architecture. Scrim opacity/blur values, elevation shadows, and platform accessibility implementations preserve their distinct maturity (`SYSTEM_EVALUATED_PROVISIONAL`, `CURRENT_WEB_REFERENCE`, `OPEN`, `DEFERRED_TO_4I`).
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Geometric Invariants:**
  - `radius.dialog`: **12px** (`SYSTEM_EVALUATED_PROVISIONAL_DIALOG_RADIUS`).
  - Action Pair Discipline: Exactly one safe dismiss action + one explicit consequential action.
  - Plain Arabic Consequence: Verbal consequence must be fully articulated; never relies on color alone.
- **Open Parameters:** Exact scrim opacity/blur and modal elevation shadow (`OPEN / DEFERRED_TO_4I`). Pilot reference `0 12px 36px rgba(15,23,42,0.16)` is `CURRENT_WEB_REFERENCE_ONLY`.
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
| `CLOSED` | Layer dismissed and removed from accessibility tree. | Parent surface returns to interactive state. |
| `ERROR` | In-modal scoped alert displayed above action buttons explaining failure. Confirm button re-enabled. | User can retry confirmation or safely dismiss dialog. |

---

## 5. Role Differences

- **Customer:** Consequential actions are rare; high-stakes decisions (e.g. cancellation) require explicit product policy before implementation (`DEFERRED_PRODUCT_POLICY`). General customer browsing uses nested pages or BottomSheets.
- **Owner:** Owner uses `ConfirmationDialog` for rejecting booking requests (`dialog_radius_12_owner_390.png`). Future operational actions (e.g. deleting draft listings, blocking dates irreversibly) are `DEFERRED_TO_OWNING_PRODUCT_PHASE`.
- **Admin:** Admin uses `DesktopModal` for operational review (KYC documents, property review) on desktop web (`admin_review_queue_1440.png`). Future admin capabilities (e.g. account sanctions, releasing disputed payouts) are `DEFERRED_TO_OWNING_PRODUCT_PHASE`.

---

## 6. RTL & Bidirectional Layout Rules

- **Text Alignment:** Dialog title and consequence explanation align strictly to the right (`text-align: right`).
- **Action Button Pair:**
  - In horizontal layout: Primary/Consequential action on the right (logical start); Safe Dismiss action on the left (logical end).
  - In vertical stacked layout: Primary/Consequential action on top; Safe Dismiss action below.
- **Directional Isolation:** If entity codes, IDs, or numbers appear in the consequence copy, they are directionally isolated to prevent punctuation flip.

---

## 7. Accessibility Contract (Web vs Native Scoping)

### A. Platform-Agnostic Accessibility Intent
- Modal announcement: Opening the dialog is announced immediately with its role, title, and consequence text.
- Focus containment: Focus is strictly trapped within the dialog while active; keyboard and touch cannot reach underlying obscured content.
- Safe dismissal: A discoverable, safe cancel option is provided that mutates zero server state.
- Focus restoration: Dismissing the dialog returns focus reliably to the originating trigger element.
- Non-reliance on color: Destructive consequences are fully explained in plain text, never relying solely on red/rose color cues.

### B. Current Web Mapping (`CURRENT_WEB_MAPPING`)
- Uses `role="alertdialog"` for destructive confirmations; `role="dialog"` for standard acknowledgements, with `aria-modal="true"`.
- Linked via `aria-labelledby` (title) and `aria-describedby` (consequence text).
- Keyboard focus trap cycles Tab between confirm and cancel buttons.
- Escape key triggers safe dismiss action (`cancelAction`).
- DOM unmount or `aria-hidden="true"` on background root.

### C. Future Native Acceptance (`DEFERRED_TO_4I`)
- Flutter `showDialog` / `AlertDialog` modal barriers (`barrierDismissible = false`).
- Screen reader accessibility tree trapping via VoiceOver and TalkBack.
- Native Android back button / hardware key dismiss handling.
- Native focus restoration via Flutter `FocusNode`.

---

## 8. Composition Invariants & Anti-Patterns

1. **Single Layer Discipline:** Exactly one modal or dialog can be open at any time. Cascading dialogs over dialogs is prohibited.
2. **Never for General Tasks:** Never use a dialog for form entry, address search, or multi-step wizardry. Use full-screen nested pages.
3. **No Unapproved Product Promises:** Consequence text must state only verified technical truth. Do not invent marketing, legal, or SLA claims.
