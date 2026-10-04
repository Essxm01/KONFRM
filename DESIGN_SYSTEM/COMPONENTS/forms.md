# Form composition

## Current Web Authority

Forms use `controlGap` between label/control/helper/error and `sectionGap` between meaningful groups. Required information is never conveyed only by placeholder text.

Submit controls remain disabled only for an explicit reason and expose that reason where useful. A submission has loading, success and retryable-error feedback. Screen-level errors are Alerts; field-specific errors stay adjacent to their field.

## Mobile Phase 4D Field Relationship Semantics

Phase 4D defines the internal semantic relationships of data-entry units for mobile surfaces without preempting Phase 4E structural layout authority:

- **Semantic Field Unit Relationships:**
  - *Label:* Explicit persistent top label positioned above the field container (`label` role).
  - *Control:* Interactive field container (text, phone, numeric, textarea, or picker trigger).
  - *Helper:* Separate supporting copy positioned adjacent to the control (`supporting` role), clarifying format or business consequences.
  - *Error:* Field-specific validation message positioned adjacent to the control, text-associated (never color-only), announced to assistive technology. Screen-level errors are Alerts; field-specific errors stay adjacent to their field.
- **Submission State Semantics:**
  - Submit controls remain disabled only for an explicit reason and communicate that reason where useful.
  - Prevent accidental repeated submissions during in-flight network requests.
  - Submit actions reflect in-flight loading, success, and retryable error feedback.
  - Canonical success is confirmed only after the server confirms it.
- **Phase 4E Structural Boundary:**
  - Phase 4D governs only individual field unit semantics and internal hierarchy.
  - Exact mobile `controlGap`, `sectionGap`, screen padding, card grouping, multi-field module containers, dividers, and layout spacing scales are **strictly Phase 4E (Structural System) scope**.
