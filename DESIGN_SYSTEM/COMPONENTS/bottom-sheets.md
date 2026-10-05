# BottomSheet

BottomSheet is the mobile contextual overlay surface for contained tasks, filter/search refinement, pickers, and transient confirmations. It preserves the underlying viewport context while allowing focused interaction.

BottomSheet is **NEVER** a full-screen navigation substitute. It must not be used for Auth V2 (`08 → 09 → 10`), Property Detail, Booking Request Review (Screen 07), multi-step wizards, or full entity evaluations.

---

## Geometry & Radii

- **Top Radius:** **16px** (`SYSTEM-EVALUATED PROVISIONAL BOTTOM_SHEET_TOP_RADIUS`).
  - *Evidence:* Controlled comparison across 12px (`sheet_radius_12_390.png`), 16px (`sheet_radius_16_390.png`), and 20px (`sheet_radius_20_390.png`) confirms 16px provides balanced curvature against 12px structural cards and 8px inputs without the generic-roundness risk of 20px. 12px remains a valid close container-aligned alternative.
  - *Scope:* Applies strictly to mobile BottomSheet top curvature; distinct from button (6px), input (8px), container (12px), and dialog (12px) radii.
- **Height Discipline:**
  - Web pilot max-height (~85%) is a **`CONTROLLED_WEB_PILOT_GEOMETRY_REFERENCE_ONLY`**.
  - No rigid percentage is canonized.
  - *Semantic Rule:* The sheet remains contextual, preserving underlying context. If a task becomes entity-like, long, or multi-step, it must be promoted to a full nested page.
  - Exact native height and detent behaviors are **`DEFERRED_TO_4I`**.

---

## Dismiss Grammar

- **Explicit Dismiss Control:** **`REQUIRED`**. Every BottomSheet must include a visible, accessible Close affordance (X icon button in the header or explicit Cancel text button).
- **Drag Handle:** **`OPTIONAL`**. Governed only when the sheet is physically draggable and supported by platform conventions. Not universal Canon.
- **Swipe-to-Dismiss:** **`CONDITIONAL`**. Supported when gesture does not conflict with scrollable content.
- **Backdrop Tap Dismiss:** **`CONDITIONAL_LOW_RISK`**. Permitted on low-stakes search/refine filters where dismissal loses no meaningful user work. Prohibited on unsaved inputs or consequential flows where dismissal could cause accidental data loss.

---

## Elevation & Scrim

- Separated from underlying content via minimum necessary elevation over a dimmed scrim.
- Exact shadow parameters (pilot reference `0 -4px 24px rgba(15,23,42,0.10)`) and scrim opacity/blur values are **`OPEN / CONTROLLED_WEB_PILOT_RENDERING_REFERENCE`**.
- Physical mobile rendering acceptance is **`DEFERRED_TO_4I`**.

---

## Layer Discipline & Context Preservation

- **Single Layer Discipline:** Exactly one temporary layer at a time. Cascading sheets over sheets is prohibited.
- **Context Preservation:** Dismissing a filter sheet without applying leaves previous search criteria intact. Applying commits criteria and refreshes the underlying feed.
