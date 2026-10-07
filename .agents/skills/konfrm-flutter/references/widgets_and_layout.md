# `konfrm-flutter` — Widgets, Layout, RTL & Accessibility Implementation

```yaml
MODULE: widgets_and_layout.md
GOVERNING_SPEC: DESIGN_SYSTEM/
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. CONSUMING DESIGN CANON (DF2)

1. **Design Tokens, Not Ad-Hoc Styling:**
   - Flutter widgets consume centralized design tokens (colors, borders, radiuses, elevations) established in `DESIGN_SYSTEM/`.
   - Never hardcode raw hex values, arbitrary padding integers, or ad-hoc border radiuses in feature widgets.
2. **Monochrome-First Visual Hierarchy:**
   - Consume current Design System tokens from `DESIGN_SYSTEM/`. Exact neutrals are `OPEN` in repository governance; monochrome-first does NOT authorize invented neutral values or zinc tonal scales.
   - Accent colors are reserved strictly for semantic states (Success, Warning, Error) or restrained interaction feedback.
3. **Applicable Truthful States:**
   - Implement only the states that actually exist in the component's product contract (`APPLICABLE_TRUTHFUL_STATES`):
     - `Content`: Data is loaded and valid.
     - `Loading`: Progress indicator or skeleton layout while awaiting data.
     - `Empty`: Truthful, actionable empty messaging when no records exist.
     - `Error`: Truthful error feedback with retry action.
   - Do NOT manufacture states that do not exist in the product definition.

---

## 2. ARABIC-FIRST & RTL LAYOUT MECHANICS

1. **Directional Layout Primitives:**
   - Always use directional layout classes to ensure proper mirroring between LTR and RTL:
     - Use `EdgeInsetsDirectional.fromSTEB(...)` or `EdgeInsetsDirectional.only(start: ..., end: ...)` instead of `EdgeInsets.only(left: ..., right: ...)`.
     - Use `AlignmentDirectional.centerStart` or `AlignmentDirectional.centerEnd` instead of `Alignment.centerLeft` / `Alignment.centerRight`.
     - Use `BorderRadiusDirectional` when rounding specific horizontal corners.
2. **Cairo Typography Integration:**
   - Use the Cairo font family for Arabic and multilingual text per Design Canon.
   - Consume the typography role/token contract directly. Published typography roles define their own line-height contracts; do NOT invent a single cross-role line-height range (`1.25 to 1.4`).
3. **Numeric Display Standards:**
   - Prices use Western Arabic numerals (0-9) followed by the Egyptian Pound currency mark:
     `1,600 ج.م`
   - Consume the current numeric typography role/token. If tabular figures are explicitly supported/required by the active Design System component contract, use them; do NOT mandate monospaced number styling as general Canon.

---

## 3. ACCESSIBILITY IMPLEMENTATION MECHANICS

1. **Platform-Aware Touch Target Boundaries:**
   - Interactive elements must satisfy platform touch target criteria (minimum ~48dp on Android, ~44pt on iOS).
   - Consume governed component sizing tokens or design system button wrappers rather than inventing cross-platform geometry.
2. **Semantics Application Mechanics:**
   - **Prefer Built-In Semantics:** PREFER THE SEMANTICS ALREADY PROVIDED BY THE INTERACTIVE WIDGET (e.g., `IconButton`, `ElevatedButton`, `TextField`).
   - Add/merge explicit `Semantics(...)` only when the underlying custom widget does not expose the required label, role, value/state, or action.
   - Never blindly wrap an existing semantic button in another `Semantics(button: true)` wrapper; redundant wrapping creates duplicate screen reader announcements.
3. **Phase 4I Distilled Invariants:**
   - **Absence of Selected-State Capability:**
     - **Ordinary Action Buttons:** Selected-state capability must be completely ABSENT (`hasSelectedState = false`). Never declare `selected: true` or `selected: false` on an ordinary action button (e.g., back button, navigation action, search clear button).
     - **Real Toggle / Selectable:** Selected-state capability is PRESENT (`hasSelectedState = true`, `isSelected = true | false`) ONLY for genuine stateful toggles (e.g., filter chips, selectable tabs, checkboxes).
     - Passing `selected: false` to an `IconButton` tells Android TalkBack the button is a toggle currently unselected, announcing "Not selected, Button", creating user confusion.
   - **No Duplicate Semantic Wrappers:** Do not wrap an `IconButton` (which already provides button semantics) in an outer `Semantics(button: true)` with the same label. Redundant wrapping causes screen readers to announce the label twice.
   - **Exclude Decorative Icons:** Decorative icons must be excluded from the accessibility tree using `ExcludeSemantics`:
     ```dart
     ExcludeSemantics(
       child: Icon(Icons.arrow_forward_ios),
     )
     ```
