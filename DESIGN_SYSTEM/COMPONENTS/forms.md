# Form Composition Contract

**Governance Status:** `CANONICAL COMPONENT CONTRACT — PHASE 4H`
**Phase Integration:** Phase 4H Component Contract & Reference Catalog
**Authority Boundary:** `forms.md` governs **multi-field composition, section grouping, form-level validation, submission state synchronization, and keyboard avoidance**. Individual field controls (`InputField`, `PhoneField`, `NumericField`, `SearchField`, `Textarea`, `SelectTrigger`, `Checkbox`) are governed strictly by `inputs.md`.
**Native Mobile Status:** `Native Component & Accessibility Acceptance: DEFERRED TO PHASE 4I`

---

## 1. Purpose & Scope

`FormComposition` governs the orchestration of multiple data-entry primitives into a coherent task flow. It ensures:
1. Clear structural grouping of related fields using Phase 4E relational spacing.
2. Synchronized form validation where field-specific errors remain adjacent to fields and screen-level blockers invoke persistent `SectionAlert` components.
3. Strict submission state lifecycle management with in-flight mutex protection against duplicate network mutations.
4. Seamless mobile keyboard avoidance ensuring active inputs and action CTAs remain visible.

---

## 2. Use When / Do Not Use When

- **USE WHEN:**
  - Composing two or more data-entry fields into a unified submission task (e.g. Auth V2 profile setup, Owner unit editing, payout account configuration).
  - Multi-field validation dependencies exist (e.g. password confirmation, date range check-in < check-out).
- **DO NOT USE WHEN:**
  - Single standalone input (e.g. Search field on Explore) — consume `SearchField` from `inputs.md` directly.
  - Multi-step transactional reviews that require dedicated full-page nested routing (e.g. Screen 07 Booking Request Review) — consume `TransactionalCustomer` routing.

---

## 3. Role Applicability & Differences

| Role | Form Context | Spacing & Container Grammar | Submission Feedback |
|---|---|---|---|
| **Customer** | Minimal auth entry (Phone, OTP, Profile setup). | `OPEN_EDITORIAL_DEFAULT`: Unboxed field sequences, natural whitespace, generous spacing. | Full-screen transition upon server confirmation. |
| **Owner** | Unit onboarding, pricing setup, bank account details. | `OPEN_GROUPED_CONTENT`: Fields grouped within 12px structural containers or open sections. | Sticky or section-pinned submission button with in-flight spinner. |
| **Admin** | Review decision notes, rejection reason logging, property edits. | Desktop compact form layout: tighter vertical rhythm, inline validation notes. | Modal or drawer submission with immediate table revalidation. |

---

## 4. Anatomy & Structural Hierarchy

A governed form consists of:
1. **Form Header (Optional):** Section title (`sectionTitle`) and supporting purpose statement (`supporting`).
2. **Form Sections (`FormSection`):** Logically grouped field units separated by `sectionGap` (24px provisional).
3. **Field Units (`FieldUnit`):** Individual controls separated by `controlGap` (12px / 16px provisional). Each field unit contains:
   - Persistent Top Label (`label` role).
   - Control Container (8px radius outline-led).
   - Helper Copy (`supporting` role) or Error Copy (text-associated, never color-only).
4. **Form Submission Bar (`FormSubmissionBar`):** Pinned or inline action area containing Primary Action Button (`Button` 6px Stable Black) and optional secondary dismiss action.

---

## 5. Submission Lifecycle & Mutex Contract

Form submission follows a strict 4-state lifecycle:

```
[IDLE] ──(User Submits)──► [SUBMITTING] ──┬──(Server Succeeded)──► [SUCCEEDED]
                                         │
                                         └──(Server Rejected)───► [FAILED] (Returns to IDLE)
```

1. **`IDLE`:** Form is ready for user input. Submit button is interactive or disabled with an explicit reason.
2. **`SUBMITTING`:** Mutation in flight:
   - **In-flight Mutex:** Submit control is immediately disabled against duplicate taps.
   - **Visual State:** Button displays in-flight label (e.g. *"جارٍ الحفظ..."*) and loading spinner.
   - **Form Fields:** Interactive fields become read-only during submission to prevent mid-flight tampering.
   - **Prohibition:** Zero fake optimistic success transitions before server confirmation.
3. **`SUCCEEDED`:** Server confirmed completion:
   - Low-risk transient updates invoke a `Toast` (*"تم حفظ التغييرات"*).
   - Contractual or navigation milestones trigger immediate route progression (e.g. Auth Screen 08 → 09).
4. **`FAILED`:** Server rejected submission:
   - Submit control returns to interactive `IDLE` state.
   - Form fields unlock.
   - Field-specific errors populate adjacent to the offending fields.
   - General or network errors populate as a persistent `SectionAlert` at the top of the form.

---

## 6. RTL / Bidi & Accessibility Contract

- **RTL Alignment:** Form layout flows top-to-bottom, right-to-left. Labels, helper text, and validation copy align right.
- **LTR Isolation:** Phone numbers, IBANs, and numeric inputs maintain isolated `dir="ltr"` containers within the RTL form.
- **Error Announcement:** When validation fails, focus moves automatically to the first invalid field or screen alert, and the error copy is announced via accessibility semantics.
- **200% Reflow:** Forms reflow vertically without horizontal scroll. Action buttons at the bottom stack vertically if text expands.
- **Keyboard Avoidance:** The active input automatically scrolls above the virtual keyboard with a minimum 16px clearance buffer.

---

## 7. Governed, Provisional & Open Values

- **Governed Invariants:** Single decision primary per form; in-flight submission mutex; errors never color-only.
- **System-Evaluated Provisional Values:** `controlGap` (12px / 16px), `sectionGap` (24px), Primary Button 6px, Field Radius 8px.
- **Open Values:** Exact keyboard scroll animation curve, exact error focus ring styling (`DEFERRED_TO_4I`).
