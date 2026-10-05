# Field Primitives & Selection Controls Contract

> [!NOTE]
> **Component Maturity & Scope Disclaimer:** This specification defines shared component contracts across KONFRM's three roles (Customer, Owner, Admin). Web implementations (React 19 / TypeScript) serve as the current running baseline (`CONTROLLED_WEB_PILOT_REFERENCE`). Native mobile specifications establish contract boundaries for the future Flutter target (`PHASE_4I_TARGET`). Exact native mobile layout parameters and styling details are explicitly governed in Phase 4I.

- **Governance Status:** `CANONICAL COMPONENT CONTRACT — PHASE 4H`
- **Phase Integration:** Phase 4H Component Contract & Reference Catalog
- **Authority Boundary:** `inputs.md` governs **individual field controls** (`InputField`, `PhoneField`, `NumericField`, `SearchField`, `Textarea`, `SelectTrigger`, `Checkbox`). Multi-field composition, submission mutex, and layout spacing are governed by `forms.md`.
- **Native Mobile Status:** `Native Component & Accessibility Acceptance: DEFERRED TO PHASE 4I`

---

## 1. Component Family Scope

This contract governs 7 distinct data-entry and selection primitives:
1. `InputField`: Standard single-line textual entry.
2. `PhoneField`: Localized phone input with country prefix and strict LTR number isolation.
3. `NumericField`: Monetary and count input with tabular formatting and Western Arabic digits (`0–9`).
4. `SearchField`: Discoverability field with leading search icon and trailing clear affordance.
5. `Textarea`: Multiline expanding text input for descriptions and notes.
6. `SelectTrigger`: Field-shaped trigger opening a governed BottomSheet picker.
7. `Checkbox`: Binary selection primitive evidenced in Owner preferences.
*(Toggle / Switch is explicitly `DEFERRED_TO_LATER_PRODUCT_PHASE` due to zero current canonical product evidence).*

---

## 2. Shared Visual Strategy & Geometry

- **Visual Baseline:** **Outline-Led Field Baseline** (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). White field surface with a thin neutral perimeter outline (`#8E8E93` Web rendering reference).
- **Mobile Field Radius:** **`8px`** (`FOUNDER-SELECTED PROVISIONAL FIELD_ONLY`). Applies strictly to mobile field-shaped controls. Does NOT apply to Primary Button (6px), cards, sheets, or dialogs.
- **Field Height Baseline:**
  - `WEB_FIELD_GEOMETRY_REFERENCE`: 48px controlled pilot reference.
  - `NATIVE_FIELD_HEIGHT`: `OPEN / DEFERRED_TO_4I` (evaluated against platform typography and hit bounds; no invented numeric range).
- **Top Label Hierarchy:** Explicit, persistent top label positioned above the field. **Floating labels are strictly PROHIBITED** to prevent Arabic font descender clipping and lost context.
- **Helper & Error Hierarchy:** Positioned adjacent to and beneath the field. Helper copy clarifies business context; error copy explains the exact failure reason in plain Arabic. Errors are never color-only.

---

## 3. Typography & Role Inheritance (Cairo Profile B)

Fields inherit Cairo Profile B roles without inventing new tokens:
- **Field Label:** `label` role (`12 / 600 / 1.35`).
- **Input Value:** `body` role (`14 / 500 / 1.50`).
- **Active / Strong Value:** `bodyStrong` role (`14 / 700 / 1.50`).
- **Helper & Error Copy:** `supporting` role (`12 / 400 / 1.40`).
- **Numeric / Currency Value:** `numeric` role (`16 / 700 / 1.30`).

---

## 4. Interaction States

> [!IMPORTANT]
> **State Semantic Separation:** Form fields evaluate interaction states (`UNFILLED / NO_VALUE`, `FILLED`, `FOCUSED`, `ERROR`, `DISABLED`, `READ_ONLY`). They do **not** use the Phase 4G view-level `EMPTY` state. In Phase 4G, `EMPTY` applies strictly to data collections and views (e.g. zero search results, empty queue); an unpopulated field is simply `UNFILLED / NO_VALUE`.

| Field State | Visual Presentation | Accessible Announcement |
|---|---|---|
| **Unfilled / No Value** | White surface, neutral outline, placeholder text. | Field role + accessible label announced. |
| **Focused** | Restrained interaction-accent emphasis (candidate `#276EF1` border + subtle halo). | Active editing mode exposed. |
| **Filled** | Text displayed in `body` or `numeric` role; clear action visible if applicable. | Current value exposed to screen reader. |
| **Error** | Red perimeter border (`#DC2626` reference) + adjacent Arabic error text. | `aria-invalid="true"` / `Semantics(hasError)`; error message read aloud. |
| **Disabled** | Muted surface (`#F1F5F9`), muted border, non-interactive cursor. | `aria-disabled="true"`; explanation copy provided where useful. |
| **Read-Only** | Natural surface, clean border, text selectable but uneditable. | `aria-readonly="true"`. |

---

## 5. Primitive-Specific Contracts

### 5.1 PhoneField (Auth V2 & Contact)
- Direction: Container is RTL; phone number run is strictly **LTR-isolated** (`dir="ltr"`, `unicode-bidi: isolate`).
- Formatting: Egyptian format `+20 100 123 4567` or `010 0123 4567`.
- Validation: Exactly 11 digits for Egyptian mobile numbers.

### 5.2 NumericField (Pricing & Guest Counts)
- Digits: Strictly Western Arabic numerals (`0–9`).
- Currency Suffix: Accompanied by canonical Egyptian currency unit (`ج.م`).
- Thousand Separator: Comma separator (e.g. `1,600 ج.م`).

### 5.3 SearchField (Explore & Queues)
- Leading Slot (Visual Right): Non-directional search icon (`Search`).
- Trailing Slot (Visual Left): Clear action (`X` icon button, minimum platform target) appears when query is non-empty.
- Live Behavior: Debounced search query; submit on keyboard search action. Composes with view-level `EMPTY` state when zero search results are returned.

### 5.4 Checkbox (Owner Preferences)
- Target Bounds: Minimum 44pt (iOS) / 48dp (Android) interactive tap bounding box; Web pilot min 48px CSS.
- Geometry & Styling: 20×20px box, 4px corner radius, monochrome-first black fill when checked (`WEB_REFERENCE_ONLY / OPEN / DEFERRED_TO_4I`).
- Invariant: `SELECTED != SUCCESS` (Checking a box indicates preference selection, not transaction success).

---

## 6. Accessibility & Touch Discipline

### 6.1 Platform-Agnostic Intent
- **Visible Labeling:** Every field must provide a persistent visual label linked to the input control.
- **Non-Color Error Communication:** Errors must include unambiguous written Arabic explanation copy; red outlines alone are insufficient.
- **Target Bounds Separation:** Visual box size is decoupled from interactive tap hit testing to satisfy platform accessibility minimums without inflating visual field density.

### 6.2 Current Web Mapping (`CONTROLLED_WEB_PILOT_REFERENCE`)
- Explicit `<label for="...">` association.
- Error association via `aria-describedby` pointing to error message container.
- Invalid state indicated via `aria-invalid="true"`.
- Keyboard accessible via sequential Tab order; Enter submits single-line inputs or activates Search.

### 6.3 Future Native Mobile Acceptance (`DEFERRED_TO_PHASE_4I`)
- Native input semantics (`Semantics(textField: true, label: ...)`).
- Platform-native virtual keyboard invocation with appropriate input types (`TextInputType.phone`, `TextInputType.number`).
- Traversal order verified under iOS VoiceOver and Android TalkBack.

---

## 7. Values Classification

- **Founder-Selected Provisional:** Mobile Field Radius `8px` (`FIELD_ONLY`).
- **System-Validated Provisional:** Outline-Led strategy, Cairo Profile B typography, Restrained interaction-accent focus emphasis.
- **Open Values:** Exact neutral outline hex (`#8E8E93` reference), exact focus halo geometry, native field height (`DEFERRED_TO_4I`), exact Checkbox geometry and stroke width (`DEFERRED_TO_4I`).
- **Deferred to Later Phase:** Toggle / Switch primitive (`DEFERRED_TO_LATER_PRODUCT_PHASE`).
