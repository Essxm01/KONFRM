# KONFRM Phase 4H — Component Contract Gap Analysis & Reconciliation

**Document Status:** CANONICAL DISCOVERY ARTIFACT — PHASE 4H  
**Branch:** `design/component-contract-catalog-01`  
**Purpose:** Audit existing shared component documents (`DESIGN_SYSTEM/COMPONENTS/*.md`), identify architectural overlaps, terminology ambiguities, and missing contracts, and define exact reconciliation actions.

---

## 1. Existing Shared Authority Audit

The 10 pre-existing files in `DESIGN_SYSTEM/COMPONENTS/` were audited against validated Phase 4A–4G decisions:

| Existing Contract File | Last Phase Update | Audit Findings & Gaps | Target Resolution Action |
|---|---|---|---|
| `alerts.md` | Phase 4G | Fully synchronized with Phase 4G four-layer state delivery model and MR-17 no-yellow-boxes rule. Lacks formal contract schema (anatomy, accessibility intent, 200% reflow). | **EXTEND EXISTING CONTRACT** with Phase 4H standard contract schema. |
| `badges.md` | Phase 4G (PR #97 KYC fix) | Completely accurate canonical enum mapping across 8 domain families. Lacks formal contract schema slots and negative use-case boundary. | **EXTEND EXISTING CONTRACT** with Phase 4H standard contract schema. |
| `bottom-sheets.md` | Phase 4F | Governs 16px provisional top radius, dismiss grammar, single-layer discipline. Needs formal contract schema and explicit prohibited use cases. | **EXTEND EXISTING CONTRACT** with Phase 4H standard contract schema. |
| `buttons.md` | Phase 4C | Highly mature Phase 4C action grammar (Stable Black, 6px Primary, Subtle Fill, Outline, Ghost, Destructive). Lacks Phase 4H contract schema consistency and explicit 200% wrapping rules. | **EXTEND EXISTING CONTRACT** with Phase 4H standard contract schema. |
| `cards.md` | Phase 4E | Contains Phase 4E structural models (`OPEN_EDITORIAL_DEFAULT`, `OPEN_GROUPED_CONTENT`) and Screen 03 PropertyCard anatomy. Blends multiple distinct component families (Generic Card, PropertyCard, BookingCard, MetricCard, ListRow) into one loose document. | **EXTEND EXISTING CONTRACT** & formalize subcontracts for `PropertyCard`, `BookingCard`, `ListRow`, and `MetricCard`. |
| `forms.md` | Phase 4D | Overlaps with `inputs.md` on label/helper/error definitions. Has no distinct ownership boundary. | **MERGE DUPLICATE AUTHORITY / RECONCILE OWNERSHIP**: Establish clear split (`forms.md` = composition & submission mutex; `inputs.md` = field primitives). |
| `inputs.md` | Phase 4D | Governs Outline-Led field baseline, 8px field radius, Profile B typography, and RTL bidi rules. Missing standalone SelectTrigger and SearchField specifications. | **EXTEND EXISTING CONTRACT** to own all field primitives. |
| `modals.md` | Phase 4F | Uses generic "Modal" heading while body correctly specifies ConfirmationDialog with 12px provisional radius. Creates confusion between desktop web modals and mobile dialogs. | **RECONCILE TERMINOLOGY**: Re-anchor as `modals.md` / `dialogs.md` preserving desktop Web modal for Admin, strictly specifying `ConfirmationDialog` for mobile. |
| `navigation.md` | Phase 4F | Governs Customer 4-tab roots, Screen 16 exception, Owner Action-First Hub (no bottom nav), and Header families. Lacks formal contract schema for individual AppBars and StickyActionSurface. | **EXTEND EXISTING CONTRACT** & formalize subcontracts for `AppBar` family and `StickyActionSurface`. |
| `states.md` | Phase 4G | Defines universal 4-part state model, 9 view lifecycle states, 6 action states, and core truth invariants. Missing explicit contract schema for `StateView` and `SkeletonLoader`. | **EXTEND EXISTING CONTRACT** with formal `StateView` and `Skeleton` subcontracts. |

---

## 2. Key Architectural Reconciliations

### 2.1 Forms vs. Inputs Ownership Split (Addressing Prompt §40)

- **The Problem:** Both `forms.md` and `inputs.md` previously defined label, helper, and error text relationships, creating ambiguity regarding which document an engineer should reference for field behavior versus multi-field form behavior.
- **The Reconciliation Split:**
  - **`inputs.md` (Field Primitive Authority):** Owns individual control contracts: `InputField`, `PhoneField`, `NumericField`, `SearchField`, `Textarea`, `SelectTrigger`. Defines geometry (8px radius, outline-led, white surface), field-level interaction states (`default`, `focused`, `filled`, `error`, `disabled`), field-level typography (Profile B `label`, `supporting`, `body`, `numeric`), field-level RTL/Bidi isolation, and field-level accessible labels.
  - **`forms.md` (Form Composition & Submission Authority):** Owns the multi-field relationship: `FormGroup`, `FormSection`, spacing between controls (`controlGap`) and sections (`sectionGap`) per Phase 4E relational scale, multi-field validation orchestration, submit button state synchronization (`IDLE` → `SUBMITTING` → `SUCCEEDED` / `FAILED`), duplicate submission prevention (in-flight network mutex), and keyboard-avoidance scrolling behavior.

### 2.2 Modals vs. Dialogs Terminology Boundary (Addressing Prompt §41)

- **The Problem:** The term "Modal" historically triggered arbitrary centered popups for login, property details, and multi-step forms on mobile devices, violating DF2 mobile principles.
- **The Reconciliation Boundary:**
  - **`ConfirmationDialog` (Mobile Authority):** Dedicated to short, high-consequence, irreversible decision confirmation (e.g. Owner reject booking request). Features 12px provisional surface radius, centered overlay over dimmed scrim, explicit plain Arabic consequence statement, safe dismiss action ("تراجع"), and affirmative consequential action.
  - **`DesktopModal` (Admin Web Authority):** Centered dialog or side-sheet inspection panel for desktop Admin operational queue audits. Not applicable to mobile.
  - **Strict Mobile Prohibition:** Full-screen flows (Auth V2 `08 → 09 → 10`, Property Details, Booking Request Review Screen 07) must **NEVER** use a centered Dialog or Modal. Contextual tasks, pickers, and filters must use **BottomSheet**, never a Dialog.

### 2.3 Component Composition Model (Addressing Prompt §33)

To prevent prop explosion and premature architectural rigidity, component families are categorized by their implementation pattern:

1. **PRIMITIVE (Universal self-contained widgets):**
   - `Button`, `IconButton`, `InputField`, `PhoneField`, `NumericField`, `Checkbox`, `StatusBadge`, `SkeletonLoader`, `Toast`.
   - Simple prop contracts: variant, state, value, onChange, label, accessibilityLabel.
2. **COMPOUND COMPONENT (Slot-based bounded containers):**
   - `SectionAlert` (slots: icon, title, description, retryAction).
   - `BottomSheet` (slots: header/close, scrollable body, pinned footer CTA).
   - `ConfirmationDialog` (slots: title, consequenceBody, safeAction, confirmAction).
   - `StateView` (slots: illustration/icon, title, message, primaryAction, secondaryAction).
3. **COMPOSITION PATTERN (Structural layout contracts, not rigid monolithic classes):**
   - `AppBar Family`: Set of 7 role-specific header configurations (`TopLevelCustomer`, `NestedCustomer`, `TransactionalCustomer`, `AuthFullScreen`, `TopLevelOwner`, `NestedOwner`, `TemporaryLayerHeader`) sharing baseline safe-area, title, and slot mechanics rather than one monolithic 30-boolean widget.
   - `StickyActionSurface`: Layout composition pattern pinning action bars to bottom viewport with reserved scroll clearance and safe-area insets.
   - `OpenGroupedContainer`: Structural container pattern with outer 12px border and inner hairline dividers.
4. **SCREEN-SPECIFIC ASSEMBLY (Role-driven contextual assemblies):**
   - `BookingCard`: Customer booking card (stay recognition + payment/access next-step) vs. Owner booking request card (action triage + decision consequence) are distinct role-driven assemblies consuming shared primitives (`Button`, `StatusBadge`), not a bloated single widget with role flags.
   - `CustomerPropertyCard`: Specialized discovery assembly consuming media, typography, and favorite `IconButton`.

---

## 3. Component Gap Audit & Action Plan

| Identified Gap Area | Current State | Required Phase 4H Action | Contract Location |
|---|---|---|---|
| **Checkbox** | Evidenced in Owner notification settings; documented in `inputs.md` | Formally contract as a selection primitive in `inputs.md` and catalog | `inputs.md` |
| **Toggle / Switch** | Mentioned in `inputs.md` as deferred; zero product evidence | Mark explicitly as `DEFERRED_TO_LATER_PRODUCT_PHASE`; DO NOT manufacture unevidenced switch contract | `inputs.md`, `OPEN_VALUES_REGISTER.md` |
| **Skeleton & Progress** | Conceptual mention in `states.md` | Formalize `SkeletonLoader` and `ProgressIndicator` subcontracts under `states.md` | `states.md` |
| **StickyActionSurface** | Governed in `navigation.md` (no dual chrome, reserved clearance) | Formalize as a composition pattern contract | `navigation.md` / `sticky-action-surface.md` |
| **AppBar Families** | Governed in `navigation.md` §38–63 | Formalize 7 distinct role-aware app-bar configurations with clear slots | `navigation.md` |
| **ListRow / SettingsRow** | Brief row in `cards.md` table | Formalize explicit ListRow anatomy, slots, divider grammar, and RTL chevron behavior | `cards.md` |
| **Metric / Summary Unit** | Mentioned in `cards.md`; evidenced on Owner Home 3-column grid | Formalize compact operational summary unit contract | `cards.md` |
| **Customer PropertyCard** | Documented in `cards.md` §19–28 | Elevate to full contract with strict anti-marketing/fake-data invariants | `cards.md` |
| **BookingCard** | Documented in `cards.md` §17 | Separate into role-specific contracts: Customer Stay Unit vs Owner Decision Unit | `cards.md` |
