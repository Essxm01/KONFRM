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
   - Primary surfaces use high-contrast black, white, and zinc tonal scales.
   - Accent colors are reserved strictly for semantic states (Success, Warning, Error) or restrained interaction feedback.
3. **Applicable Truthful States:**
   - Implement only the states that actually exist in the component's product contract:
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
   - Use the Cairo font family for Arabic and multilingual text.
   - Ensure proper line height metrics (`height: 1.25` to `1.4`) to prevent Arabic ascenders and descenders from clipping.
3. **Numeric Display Standards:**
   - Prices use Western Arabic numerals (0-9) followed by the Egyptian Pound currency mark:
     `1,600 ج.م`
   - Use tabular figures or monospaced number styling for tabular price columns to prevent layout jitter.

---

## 3. ACCESSIBILITY IMPLEMENTATION MECHANICS

1. **Minimum Touch Target Geometry:**
   - Adhere to platform-appropriate touch target minimums:
     - Android: Minimum ~48dp x ~48dp tap targets.
     - iOS: Minimum ~44pt x ~44pt tap targets.
   - Use `BoxConstraints(minWidth: 48, minHeight: 48)` or wrap smaller visual icons in an outer interactive boundary.
2. **Explicit Semantics Annotation:**
   - Custom interactive components must declare their semantic role using the `Semantics` widget:
     ```dart
     Semantics(
       button: true,
       label: 'إغلاق نافذة البحث',
       hint: 'اضغط مرتين للإغلاق',
       child: IconActionButton(...),
     )
     ```
3. **Phase 4I Distilled Invariants:**
   - **No False Selection Semantics:** Ordinary action buttons (such as navigation icons, search clear icons, or back buttons) must NEVER declare `selected: true` or `selected: false`. Selection semantics are reserved exclusively for genuine stateful toggles (such as filter chips or checkboxes). Declaring selection on standard buttons causes Android TalkBack to announce "Not selected, Button", creating user confusion.
   - **No Duplicate Semantic Wrappers:** Do not wrap an `IconButton` (which already provides button semantics) in an outer `Semantics(button: true)` with the same label. Redundant wrapping causes screen readers to announce the label twice.
   - **Exclude Decorative Icons:** Decorative icons must be excluded from the accessibility tree using `ExcludeSemantics`:
     ```dart
     ExcludeSemantics(
       child: Icon(Icons.arrow_forward_ios),
     )
     ```
