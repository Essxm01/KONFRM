# Phase 4D Form & Selection Primitives — Evidence Manifest

**Repository Location:** `DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/evidence/`  
**Execution Context:** Phase 4D Kickoff + Discovery + Visual Evidence + System Evaluation  
**Pilot Base SHA:** `3520ca0dd28c013a52a2b0cc15670eab1b974442`  
**Branch:** `design/form-selection-pilot-01`  
**Capture Platform:** Headless Chromium / Edge Engine, Cairo Profile B Typography, RTL-first Arabic layout  

---

## Controlled Visual Evidence Inventory (12 Artifacts)

| File Name | Test Subject & Conditions | Viewport & Scale | Key Findings & Evaluation Focus |
|---|---|---|---|
| `customer_auth_hybrid_390.png` | **Customer Auth Composition (Screen 08/10)**<br>Hybrid / Contextual family, 8px radius, accent focus. | 390px (iOS)<br>100% text scale | Verified LTR-isolated phone input (`+20` prefix), clean email field with text-associated error, Cairo Profile B labels and helper text, paired with 6px black primary action. Zero visual competition between field and CTA. |
| `customer_search_hybrid_390.png` | **Customer Search & Refine Composition (Screen 04)**<br>Search input with icon & clear button, destination picker trigger, date range, guest stepper, price ceiling. | 390px (iOS)<br>100% text scale | Search input provides immediate query affordance; picker trigger exposes selected value with chevron; guest steppers maintain 44pt+ touch targets; clear separation between 4D input contract and deferred 4F overlay grammar. |
| `owner_property_hybrid_390.png` | **Owner Property Wizard Composition**<br>Title input, property type chips, multiline description, region selector, price per night (`ج.م` suffix). | 390px (iOS)<br>100% text scale | High operational density without visual clutter; structured data entry; crisp currency alignment (Western Arabic numerals 0–9); textarea scales vertically without label distortion; harmonious button pairing (secondary subtle + primary black). |
| `state_matrix_hybrid_390.png` | **Complete State Matrix (7 Interactive States)**<br>Default, Focused Active, Filled, Validation Error, Disabled with explanation, Checkbox, Toggle. | 390px (iOS)<br>100% text scale | Full coverage of primitive states; error state couples `#DC2626` border with explicit icon and copy (non-color-only); disabled state preserves readability while communicating non-editable status; checkbox/toggle comparison. |
| `candidate_family_outline_390.png` | **Candidate A: Outline-Led Family**<br>Customer Auth composition with 1px neutral borders on pure white. | 390px (iOS)<br>100% text scale | Architectural, crisp, high precision. High figure-ground contrast. Minor risk: in deeply nested multi-field groups, repeated borders can feel slightly rigid if unmitigated. |
| `candidate_family_fill_390.png` | **Candidate B: Subtle-Surface / Fill-Led Family**<br>Customer Auth composition with tinted neutral fill (`#F4F4F5`). | 390px (iOS)<br>100% text scale | Softer aesthetic on blank page, but exhibits lower edge clarity, muddies visual hierarchy when nested inside cards, and risks looking like generic mobile consumer SaaS. |
| `input_radius_6px_owner.png` | **Radius Candidate: 6px (Exact Button Match)**<br>Owner Property Wizard with 6px control radius. | 390px (iOS)<br>100% text scale | Extremely crisp and architectural; exact alignment with Primary Button 6px. Highly disciplined, though slightly sharper for larger mobile touch surfaces. |
| `input_radius_8px_owner.png` | **Radius Candidate: 8px (System Recommended)**<br>Owner Property Wizard with 8px control radius. | 390px (iOS)<br>100% text scale | Optimal modern mobile ergonomic balance; visually cohesive with 6px buttons without copying button geometry blindly. Preserves high dignity and comfort. |
| `input_radius_10px_owner.png` | **Radius Candidate: 10px (Soft Mobile Baseline)**<br>Owner Property Wizard with 10px control radius. | 390px (iOS)<br>100% text scale | Softer appearance, but begins drifting toward generic consumer roundedness and creates perceptible tension with the sharp 6px Primary Button geometry. |
| `focus_treatment_black_state_matrix.png` | **Focus Treatment: Pure Black (#000000)**<br>State Matrix with 2px high-contrast black focus ring. | 390px (iOS)<br>100% text scale | Highly visible and accessible, but visually competes with the `#000000` Primary action button on screen, creating cognitive confusion about what is primary on the page. |
| `stress_reflow_360_width.png` | **Narrow Viewport Reflow (360px Compact Android)**<br>Customer Search & Refine rendered at 360px width. | 360px (Android)<br>100% text scale | Zero horizontal clipping; date pickers and stepper controls remain comfortably positioned; labels wrap naturally without colliding with clear/stepper actions. |
| `stress_text_scale_200.png` | **Extreme Text Scaling Reflow (200% Scale)**<br>Stress Test view with long Arabic labels, Bidi runs, and multi-line validation errors. | 390px (iOS)<br>200% text scale | Text reflows cleanly without truncation; container heights expand dynamically; Bidi runs (`Chalet #402 قرية Stella Di Mare`) remain structurally isolated; error box wraps without overlapping input. |

---

## Summary of Empirical Findings

1. **Strategy Winner:** **Candidate C (Hybrid / Contextual)** provides the cleanest solution across both roles. It utilizes crisp 1px neutral outlines for standalone fields (avoiding muddy fill-gray in cards) while offering modular grouping for paired fields (dates, price/currency, steppers) to eliminate "box soup".
2. **Radius Sweet Spot:** **8px** provides the most balanced, comfortable form aesthetic. It complements 6px Primary buttons without forcing an artificial 6px mandate onto taller 48px input containers. 6px remains a strong alternative if the Founder prefers exact geometric alignment.
3. **Focus Separation:** Restrained interaction accent (**Candidate `#276EF1`**) with a subtle 2px halo is markedly superior to `#000000` focus borders because pure black focus borders compete directly with the provisional `#000000` Primary CTA button.
4. **Bidi & Accessibility:** Explicit `dir="ltr"` wrappers on phone and email fields prevent cursor jumping and reverse-hyphen distortion in Arabic context. Text-associated icons ensure errors meet WCAG 2.2 AA without relying solely on red color.
