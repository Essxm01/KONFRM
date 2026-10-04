# Input, Textarea, Select and Search

## Current Web Authority

Web controls use `surface.primary`, `border.default`, `radius.control`, Cairo `label/body` roles and a 44px minimum touch target.

- **Input:** label, value, helper text and field-associated error are separate semantic elements.
- **Textarea:** same contract; grows vertically without removing the label or error association.
- **Select:** exposes current choice and keyboard focus; no custom visual variant per screen.
- **Search:** is an Input with a labelled search affordance and clear action when content exists.

States are default, hover where appropriate, focus, filled, disabled, read-only, validation error and loading. Error uses text/icon plus semantic color; colour alone is insufficient. Direction-sensitive phone, ID and numeric input follows the RTL guideline.

## Mobile Phase 4D Provisional Direction

Governed by Phase 4D discovery and controlled visual evaluation across Customer and Owner mobile products (Admin remains Web operational):

- **Field Visual Strategy:** **Outline-Led Field Baseline** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). Standalone fields utilize a white field surface with a thin neutral outline, providing clear edge definition on light surfaces without relying on floating labels. Exact neutral palette hex values and native stroke widths remain `OPEN / IMPLEMENTATION CANDIDATE` (the Web pilot `1px` rendering reference does not constitute a final native stroke token).
- **Mobile Field Radius:** **8px** (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`). Applies strictly to mobile field-shaped Form & Selection primitives: text input, phone field container, email field container, numeric/currency field container, search field container, multiline textarea, and select/picker trigger when rendered as a field-shaped control.
  - *Boundary:* Does **not** apply to Primary Button (which retains 6px `PRIMARY_ONLY` provisional radius), secondary buttons, icon buttons, checkboxes, toggles, chips, segmented controls, steppers, cards, rows, sheets, dialogs, overlays, or global container shapes.
  - *Semantic Differentiation:* Action / Primary Button = 6px; Data Entry / Field-Shaped Control = 8px. This is deliberate semantic differentiation.
- **Typography Role Inheritance:** Fields inherit Cairo Profile B (`SYSTEM-VALIDATED PROVISIONAL`):
  - Field label: `label` role (`12 / 600 / 1.35`).
  - Helper & error copy: `supporting` role (`12 / 400 / 1.40`).
  - Field input value: `body` role (`14 / 500 / 1.50`).
  - Strong input value / active state: `bodyStrong` role (`14 / 700 / 1.50`).
  - Numeric / monetary value: `numeric` role (`16 / 700 / 1.30`).
  - No new typography tokens are invented.
- **Label / Helper / Error Semantic Contract:**
  - *Label:* Explicit, persistent top label positioned above the field container. Floating labels are **not selected** for this mobile direction due to Arabic descender clipping, translation expansion risks, and the requirement for persistent context.
  - *Helper:* Separate supporting copy positioned adjacent to the control, explaining user-relevant context or consequence.
  - *Error:* Field-associated textual error (adjacent to the field container, text-associated, announced to assistive technology, never color-only).
- **RTL / Bidi Contract:**
  - Arabic UI is RTL with semantic start/end alignment.
  - Phone numbers and email addresses are LTR-isolated runs within RTL context.
  - Numeric/financial inputs use Western Arabic digits (`0–9`).
  - Customer-facing monetary display retains canonical `1,600 ج.م` format with tabular numeral intent.
  - Search: search affordance at visual start (RTL right) and clear action (`×`) at visual end (RTL left) when content exists.
- **Focus Semantic Direction:** **Semantic Restrained Interaction-Accent Emphasis** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). Obvious focus feedback without competing visually with the Stable Black Primary action button. Web pilot values (`#276EF1`, 2px ring, 2px halo) are rendering references only; exact native focus treatment remains `OPEN / DEFERRED TO PHASE 4I`.
- **Select / Picker Primitive Boundary:**
  - Phase 4D owns: field label, placeholder / empty value, selected value presentation, trigger affordance, disabled/error state, field semantics, and RTL alignment.
  - Phase 4D does **not** define: bottom-sheet containers, dialog containers, overlay architecture, or container navigation (Phase 4F scope). Pilot overlays are `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.
- **Selection Controls:**
  - *Checkbox:* `OWNER PRODUCT-EVIDENCED CONTROL` (grounded in Owner notification/preference settings). Customer flows have zero terms-checkbox bureaucracy.
  - *Toggle / Switch:* `DEFERRED / FUTURE BOUNDED CONTROL` (zero current canonical product evidence; no switch migration is manufactured).
- **Touch Target & Platform Boundary:**
  - Platform-appropriate accessible target sizing: iOS guidance is **44pt**, Android guidance is **48dp**.
  - Visible field geometry is decoupled from interactive touch target bounds. No universal raw pixel dimension (e.g. 44px or 48px) is canonized as a native mobile rule.
  - Controlled Web frame-width evidence (360px, 390px, 430px) represents Web simulation reference only. Native Flutter component and accessibility acceptance is strictly `DEFERRED TO PHASE 4I`.
