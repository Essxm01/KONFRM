# BottomSheet Contract

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Geometric Invariants:**
  - `radius.bottom_sheet_top`: **16px** (`SYSTEM_EVALUATED_PROVISIONAL_BOTTOM_SHEET_TOP_RADIUS`).
  - Close Control: **REQUIRED** (explicit visible Close X or Cancel button).
  - Single Layer Discipline: Exactly one temporary overlay layer at a time.
  - Contextual Task Boundary: Reserved strictly for contained tasks, filter refinement, pickers, and transient confirmations.
- **Open Parameters:** Exact shadow elevation (`OPEN / DEFERRED_TO_4I`), scrim opacity and backdrop blur (`OPEN / DEFERRED_TO_4I`), exact native height detents and spring dynamics (`DEFERRED_TO_4I`). 85% max-height in Web pilot is a controlled geometry reference only.
- **Anti-Patterns:** BottomSheet is **NEVER** a full-screen navigation substitute. It must not be used for Auth V2 (`08 → 09 → 10`), Property Detail, Booking Request Review (Screen 07), multi-step wizards, or full entity evaluations.

---

## 2. Anatomy & Props Contract

| Element | Description | Governance & Constraints |
|---|---|---|
| `Scrim` | Dimmed backdrop behind sheet | Blocks interaction with underlying page; conditional tap-dismiss. |
| `SheetSurface` | Elevated container (`surface.elevated`) | 16px top border radius; flat bottom edges anchored to viewport base. |
| `DragHandle` | Visual affordance for swiping | **OPTIONAL**. Governed only when the sheet is physically draggable and supported by platform conventions. Not universal Canon. |
| `Header` | Title + explicit close affordance | Contains clear Arabic title (`17px font-bold`) and explicit Close X button (`>=48px` touch target). |
| `Body` | Contained task content | Scrollable area with internal padding (`16px`). Keyboard-aware insets. |
| `Footer` (Optional) | Action surface for confirmation | Sticky bottom action pair (e.g. "تطبيق الفلاتر" / "إعادة ضبط"). Follows `StickyActionSurface` rules. |

---

## 3. Dismiss Grammar

- **Explicit Dismiss Control:** **`REQUIRED`**. Every BottomSheet must include a visible, accessible Close affordance (X icon button in the header or explicit Cancel text button).
- **Drag Handle:** **`OPTIONAL`**. Governed only when the sheet is physically draggable and supported by platform conventions. Not universal Canon.
- **Swipe-to-Dismiss:** **`CONDITIONAL`**. Supported when gesture does not conflict with scrollable content.
- **Backdrop Tap Dismiss:** **`CONDITIONAL_LOW_RISK`**. Permitted on low-stakes search/refine filters where dismissal loses no meaningful user work. Prohibited on unsaved inputs or consequential flows where dismissal could cause accidental data loss.

---

## 4. State Matrix

| State | Visual Behavior | Interactive Behavior |
|---|---|---|
| `OPENING` | Sheet translates up from bottom edge (200–300ms transition curve). Scrim fades in. | Interaction blocked until fully anchored. |
| `PRESENTED / IDLE` | Stationary anchored at bottom; header fixed; body scrollable. | Full interaction with form controls and pickers. |
| `INTERACTING / DRAGGING` | Follows finger drag gesture if draggable; opacity remains stable. | Scroll gestures disambiguated from dismiss drags. |
| `SUBMITTING` | Footer action enters `SUBMITTING` state (spinner + disabled). | Sheet cannot be dismissed via backdrop or swipe during mutation. |
| `DISMISSING` | Translates down below bottom edge. Scrim fades out. | Focus returned to trigger element on parent surface. |
| `CLOSED` | Unmounted or hidden from accessibility tree (`aria-hidden="true"`). | Parent screen becomes fully interactive. |

---

## 5. Role Differences

- **Customer:** Used for search filters (`filter_dialog_390.png`), date range pickers, guest counters, and quick amenity preview.
- **Owner:** Used for quick operational triage actions, price adjustment sheets, and calendar block date pickers.
- **Admin:** Admin is desktop-first; BottomSheets are **not used** on 1440px Admin workspaces. Admin uses side-sheet inspector panels or centered DesktopModals (`admin_review_queue_1440.png`).

---

## 6. RTL & Bidirectional Layout Rules

- **Header Alignment:** Sheet title is start-aligned (Right).
- **Close Button:** Positioned at logical end (Left) in RTL header, or top-left corner with minimum 48px touch area.
- **Animation Direction:** Translates strictly along the vertical Y-axis (bottom to top); no directional X-axis movement to avoid RTL conflict.
- **Content Flow:** All nested controls (radios, checkboxes, sliders, inputs) follow standard Arabic RTL flow.

---

## 7. Accessibility & Focus Management

- **Modal Trap:** When open, focus is trapped within the BottomSheet (`role="dialog"` or `role="region"`, `aria-modal="true"`).
- **Initial Focus:** Initial focus moves to sheet title or the first interactive element (e.g. search input).
- **Keyboard Dismiss:** Pressing `Escape` triggers dismiss sequence (subject to unsaved-changes confirmation if dirty).
- **Screen Reader Announcements:** Sheet title announced on mount (`aria-labelledby="sheet-title"`).
- **Safe Area Insets:** Sheet footer respects device home indicator / bottom navigation bar safe area padding (`env(safe-area-inset-bottom)`).

---

## 8. Composition Invariants & Layer Discipline

1. **Single Layer Discipline:** Exactly one temporary layer at a time. Cascading sheets over sheets is strictly prohibited.
2. **Context Preservation:** Dismissing a filter sheet without applying leaves previous search criteria intact. Applying commits criteria and refreshes the underlying feed.
3. **No Dual Bottom Chrome:** If parent screen displays a bottom navigation bar, the bottom nav is covered by scrim while sheet is open. Sticky footer inside the sheet is the only active bottom chrome.
