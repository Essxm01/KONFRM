# Phase 4D — Form & Selection Primitives System Evaluation

**Document Status:** ACTIVE PILOT EVALUATION REPORT  
**Phase:** Phase 4D — Form & Selection Primitives  
**Repository Branch:** `design/form-selection-pilot-01`  
**Base Main Checkpoint:** `3520ca0dd28c013a52a2b0cc15670eab1b974442`  
**Interactive Pilot:** `DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/index.html`  
**Evidence Artifacts:** `DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/evidence/` (12 artifacts)  
**Simulation Framing:** Controlled Web frame-width simulations (iPhone-like and compact Android-like width references; native mobile acceptance deferred to Phase 4I)  

---

## Executive Summary

Phase 4D evaluates form inputs and selection primitive semantics for the KONFRM mobile design foundation, connecting upstream typography (Cairo Profile B) and action semantics (Contextual / Hierarchy Hybrid, provisional `#000000` Primary, 6px Primary button radius) into interactive data entry across Customer and Owner mobile workflows (Admin remains Web operational).

Based on real product inspection across `customer-app/` and `owner-app/`, controlled empirical rendering across candidate visual families, three radius options, two focus modalities, three controlled Web frame widths (360px, 390px, 430px), and three text scaling levels (100%, 150%, 200%), this evaluation delivers a decisive system recommendation:

1. **Recommended Field Visual Strategy:** **Outline-Led Field Baseline (Crisp 1px Neutral Outline on Pure White)**. Standalone fields utilize a crisp 1px neutral outline (`#8E8E93` pilot reference, achieving 3.26:1 contrast against pure white `#FFFFFF` under Web component-boundary baseline) on a pure white background (`#FFFFFF`), ensuring clear figure-ground separation on light-first surfaces and avoiding low-contrast "surface soup" when embedded inside cards. Any multi-field grouped containers or module dividers demonstrated in the pilot are strictly **PILOT COMPOSITION ONLY / PHASE 4E STRUCTURAL AUTHORITY DEFERRED**.
2. **Input Radius Founder Decision:** **8px Mobile Field Radius** (`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`). The Founder explicitly approved the system recommendation: 8px applies strictly to mobile field-shaped Form & Selection primitives (text input, phone container, email container, numeric container, search container, multiline textarea, select/picker trigger). Primary Button retains 6px (`PRIMARY_ONLY`), establishing deliberate semantic differentiation between Action (6px) and Data Entry (8px). 6px is recorded as an evaluated alternative, NOT selected for fields; 10px is recorded as an evaluated alternative, NOT selected. Radius is evaluated strictly on visual aesthetics and not conflated with accessible touch-target bounds.
3. **Focus Treatment:** **Semantic Restrained Interaction-Accent Emphasis**. Restrained interaction-accent focus is empirically superior to pure black focus because pure black competes visually with the provisional `#000000` Primary action button. The specific rendering reference used in the pilot (candidate `#276EF1`, 1px accent field border + 3px outer halo) is **Web pilot rendering reference only**; exact native focus treatment remains `OPEN / Phase 4I validation`.
4. **Label / Helper / Error Hierarchy:** Explicit top labels (Cairo Profile B 12/600/1.35), contextual helper text (12/400/1.40), and text-associated error indicators (explicit copy and semantic alert icon). Floating labels are rejected due to Arabic descender clipping and translation expansion risks. Pilot error styling (`#DC2626`, alert icon) is a rendering reference, not final universal Canon.
5. **Selection Controls:** Checkbox is evidenced in Owner notification settings. Toggle has zero current product evidence and is classified as deferred future capability; no switch migration is manufactured.
6. **Strict Boundary Preservation:** Phase 4E (Structural System) and Phase 4F (Navigation & Overlay System) boundaries are strictly maintained. Picker overlays are designated `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.

---

## 1. Upstream Authority & Governing Boundaries

### A. Inherited Foundations (Preserved Without Re-Litigation)
- **Typography:** Cairo Profile B (`SYSTEM-VALIDATED PROVISIONAL`).
  - `label`: `12 / 600 / 1.35`
  - `supporting` (helper/error): `12 / 400 / 1.40`
  - `body`: `14 / 500 / 1.50`
  - `bodyStrong`: `14 / 700 / 1.50`
  - `button`: `15 / 700 / 1.20`
  - `numeric`: `16 / 700 / 1.30`
- **Action System:** Contextual / Hierarchy-Based Hybrid (`CLOSED / MERGED` in PR #90).
- **Primary Button Black:** `#000000` provisional (`#18181B` fallback comparator only).
- **Primary Button Radius:** `6px` (`PRIMARY_ONLY` provisional).
  - *Governing Boundary:* Primary Button radius does **NOT** define input radius.
- **Brand Direction:** Light-first surfaces, monochrome-first identity, restrained interaction accent candidate `#276EF1`, zero yellow/amber boxed UI by default.
- **Application Scope:** Customer and Owner mobile products. Admin remains Web operational.

### B. Preserved Open Variables
- **Input Radius:** `OPEN` (empirically evaluated in this report).
- **Exact Neutrals:** `OPEN` (pilot rendering values only).
- **Exact Blue:** `OPEN` (`#276EF1` is implementation candidate only).
- **Exact Focus Treatment:** `OPEN` (native treatment deferred).
- **Exact Destructive/Error Red:** `OPEN` (`#DC2626` is pilot rendering value only).
- **Global Shape System:** `OPEN`.
- **Native Acceptance:** `DEFERRED TO 4I`.

### C. Downstream Boundaries
- **Phase 4E (Structural System):** Spacing scale, content insets, sections, cards/rows, structural dividers, surface hierarchy, and elevation belong to 4E. Multi-field grouped containers in the pilot are composition references only.
- **Phase 4F (Navigation & Overlay System):** Bottom navigation, app bars, dialogs, bottom sheets, and global overlay grammar belong to 4F. Picker triggers belong to 4D; picker overlay presentations shown in the pilot are `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.

---

## 2. Product Reality Inspection & Control Inventory

### A. Customer App Inspection
- **Authentication (Screen 08 & Screen 10):**
  - Phone input with country code (`+20`), LTR-isolated numeric input, `01XXXXXXXXX` placeholder.
  - Email input with LTR isolation, `name@example.com` placeholder.
  - OTP 6-digit challenge code (Screen 09).
  - Full Name text input (`الاسم الكامل`, `أحمد محمد` placeholder) with helper text and validation states.
- **Search & Refinement (Screen 03 & Screen 04):**
  - Screen 03 Coastal Search Bar: full-width trigger surface opening search sheet.
  - Screen 04 Search & Refine:
    - Search query text input with leading icon and clear action.
    - Destination multi-picker trigger with count badge.
    - Date range triggers (Check-in / Check-out).
    - Guest and bedroom steppers (`-` / `+`).
    - Price ceiling range slider and display.
    - Property type selectable chips.
- **Checkbox / Toggle Status in Customer App:**
  - **Zero** `<input type="checkbox">` or toggle controls exist in `customer-app/src`.
  - Customer booking flow relies on direct confirmation actions without terms-checkbox bureaucracy.

### B. Owner App Inspection
- **Authentication & KYC:**
  - Full name text input.
  - Phone input (`PhoneInput` in `owner-app/src/components/ui/Input.tsx` with 🇪🇬 `+20` prefix and LTR isolation).
  - File upload triggers for National ID front/back and face photo.
- **Property Creation Wizard (`AddPropertyWizard.tsx`):**
  - Property Title: text input (`اسم الوحدة *`).
  - Property Type: 2x2 grid of selectable card buttons with icons and check indicators.
  - Description: multiline textarea (`وصف الوحدة (اختياري)`, 3–4 rows).
  - Region: dropdown select trigger for coastal regions.
  - Resort name & Address: text inputs.
  - Steppers: Bedrooms, Bathrooms, Maximum Guests.
  - Price per night: numeric input with Western Arabic numerals (0–9) and currency suffix `ج.م`.
  - Amenities: multi-select chip buttons with CheckCircle2.
- **Owner Operational Flows & Settings:**
  - Rejection / cancellation reason: multiline textarea.
  - Dispute explanation: multiline textarea.
  - Profile settings (`ProfileView.tsx`): exactly 3 `<input type="checkbox">` elements used for notification preferences (`bookingNotifs`, `messageAlerts`, `soundEffects`).

### C. Evidence-Backed Control Inventory

| Primitive Type | Real Product Evidence | Data / Format Constraints | RTL / Bidi Requirement | Status / Classification |
|---|---|---|---|---|
| **Text Input** | Customer Auth 10 (Full Name), Owner Wizard (Title, Address) | Single-line UTF-8 string | Native RTL text-align right | EVIDENCED REQUIRED PRIMITIVE |
| **Phone Input** | Customer Auth 08, Owner Login / Registration | Egyptian mobile (11 digits, `01XXXXXXXXX`) | LTR-isolated numeric run with `+20` prefix | EVIDENCED REQUIRED PRIMITIVE |
| **Email Input** | Customer Auth 08, Owner Profile | Standard email format (`name@domain.com`) | LTR-isolated text-align left | EVIDENCED REQUIRED PRIMITIVE |
| **Search Input** | Customer Search Refine 04, Explore | Query string | RTL text with leading search icon & trailing clear | SYSTEM CANDIDATE |
| **Numeric / Currency Input** | Owner Wizard (Price per night, Area), Search Price | Digits 0–9, optional thousand separator | Western Arabic numerals (0–9), unit suffix `ج.م` | EVIDENCED REQUIRED PRIMITIVE |
| **Multiline Input (Textarea)**| Owner Wizard (Description), Disputes, Messages | Multi-line text (3–5 lines) | RTL text, vertical expansion, fixed label | EVIDENCED REQUIRED PRIMITIVE |
| **Select / Picker Trigger** | Customer Destinations, Dates; Owner Region | Key-value choice or range selection | RTL trigger with trailing chevron / icon | SYSTEM CANDIDATE (Overlay 4F Deferred) |
| **Stepper Control** | Customer Search 04 (Guests), Owner Wizard | Integer counters (min 0/1, max 20/50) | LTR button cluster (`-` / `+`) with RTL labels | SYSTEM CANDIDATE |
| **Checkbox** | Owner Profile (`ProfileView.tsx` notification settings) | Boolean preference | RTL label with trailing/leading check box | PRODUCT-EVIDENCED CONTROL (Owner Settings) |
| **Toggle / Switch** | None (checkbox used currently in React) | Boolean preference with instant effect | RTL label with trailing toggle switch | DEFERRED / NO CURRENT PRODUCT EVIDENCE |

---

## 3. The 12-Step Design Reasoning Loop

### Step 1: OBSERVE
- **Context:** Mobile form data entry across Customer (hospitality, discovery, high trust) and Owner (dense operations, repeated listing inputs, rapid verification).
- **Core Problem:** Previous web implementations had inconsistent styling, arbitrary border radii, ad-hoc focus rings, and potential visual competition with Phase 4C black Primary buttons.
- **Key Questions:**
  1. What is the optimal field visual strategy (Outline-Led vs Fill-Led)?
  2. What input radius balances visual softness and architectural precision without copying button radius blindly?
  3. What focus treatment ensures clear visibility without competing with `#000000` Primary CTAs?
  4. How should RTL Bidi isolation be standardized for Egyptian phone numbers, emails, and currency?

### Step 2: HYPOTHESIZE (Candidate Visual Families)
- **Hypothesis A (Outline-Led Baseline):** Universal 1px neutral outline (`#8E8E93` pilot reference, achieving 3.26:1 contrast against pure white `#FFFFFF`) on pure white background for all fields. High architectural precision, crisp figure/ground contrast without visual box soup.
- **Hypothesis B (Subtle-Surface / Fill-Led):** Tinted neutral background (`#F4F4F5` pilot reference) with borderless default state. Transitions to white on focus. Softer initial appearance.
- **Hypothesis C (Compositional Hybrid in Pilot):** Uses the Outline-Led baseline for individual fields, but groups related fields inside container boxes with internal dividers in the pilot. (Note: Grouped container boxes are evaluated as composition evidence; structural container rules belong to Phase 4E).

### Step 3: ARGUE FOR
- **For Hypothesis A (Outline-Led Baseline):**
  - Maximum edge clarity on light-first surfaces.
  - Eliminates ambiguity regarding interactive boundaries.
  - Matches the geometric, architectural identity of KONFRM.
  - Works consistently whether fields are placed directly on page backgrounds or inside cards, avoiding "surface soup".
- **For Hypothesis B (Fill-Led):**
  - Softens the page by eliminating bounding lines on an empty canvas.
  - Follows consumer mobile patterns where inputs sit on plain white canvas backgrounds.

### Step 4: ARGUE AGAINST
- **Against Hypothesis A:**
  - Multiple consecutive bordered boxes on a dense page can feel repetitive if not spaced thoughtfully.
- **Against Hypothesis B:**
  - Fails when nested inside cards or sheets: white card + gray input fill + light page background creates low-contrast, muddy layering ("surface soup").
  - When an error occurs, adding a red border to a filled gray box creates an awkward hybrid look.
  - Carries a generic consumer-SaaS aesthetic that dilutes KONFRM's architectural brand identity.
- **Against Treating "Hybrid" as a 4D Primitive:**
  - The "hybrid" aspect observed in the pilot relies on multi-field container grouping and internal dividers, which are structural layout concerns belonging to Phase 4E. At the 4D primitive field level, the actual field treatment is an Outline-Led baseline.

### Step 5: RESEARCH & CLAIM HYGIENE
- **Empirical Claim Hygiene Evaluation:**
  - *Study Reference:* Biederman (1987) recognition-by-components and Gestalt boundary research (Wertheimer, 1923; Palmer, 1999).
  - *What the source directly found:* Continuous closed contours accelerate object identification and figure-ground segmentation compared to texture-only or low-contrast boundaries.
  - *Stimulus/Population:* Laboratory visual discrimination tasks using abstract 2D geometric shapes.
  - *Inference for KONFRM:* Closed 1px neutral outlines provide faster recognition of interactive touch boundaries on mobile screens than borderless low-contrast fills.
  - *Limitations / Transfer Risk:* Generic visual shape identification does not directly prove that outlined fields improve data completion rates in bilingual Arabic rental apps.
  - *Validation Requirement:* Empirical prototype rendering across Customer Auth and Owner Wizard to confirm readability, cognitive clarity, and visual comfort.

### Step 6: ROLE LENS ANALYSIS
- **Customer Role Lens:**
  - *Psychological Need:* Calmness, hospitality, trust, zero friction during booking and login.
  - *Evaluation:* Customer forms are concise (Phone/Email auth, Search filters). Outline-led standalone fields on white cards feel airy, modern, and uncluttered. High clarity during error correction reduces drop-off.
- **Owner Role Lens:**
  - *Psychological Need:* Operational speed, high scanability, high data confidence, efficient repeated data entry.
  - *Evaluation:* Owner property wizards contain multiple data points. Crisp outline fields provide unambiguous structure, supporting rapid scanning and verification.

### Step 7: BRAND CONGRUENCE
- **Alignment with KONFRM Core Brand:**
  - KONFRM is monochrome-first, structured, architectural, and precise.
  - Cairo Profile B (`15/700/1.20` button, `12/600/1.35` label) requires crisp geometric grounding.
  - Outline-led fields reinforce the architectural grid of KONFRM without introducing decorative gradients, glassmorphism, or muddy gray backgrounds.
  - Preserves the strict rule: zero yellow/amber boxed UI by default.

### Step 8: PLATFORM & ACCESSIBILITY CHECK
- **Accessibility Inspection in Controlled Pilot:**
  - *Contrast Check:* Label text (`#09090B`) and helper text (`#71717A`) provide clear contrast against white surfaces in pilot rendering. Default border candidate (`#8E8E93`) achieves 3.26:1 contrast against white (`#FFFFFF`) and 3.12:1 against canvas (`#F8FAFC`), satisfying the Web component-boundary non-text contrast baseline (>= 3.0:1) while remaining visually calm and refined. Focus state provides distinct 1px accent border + 3px outer halo highlight.
  - *Error Association:* Error state couples red border (`#DC2626` pilot reference) with an alert icon, dedicated error copy, `aria-invalid="true"`, and `role="alert"` / `aria-describedby`. Zero color-only error conveyance.
  - *Touch Target Guidance:* Platform guidance is differentiated: iOS guidance is 44pt; Android guidance is 48dp. Controlled Web pixel values (e.g. 48px field height, 34px stepper buttons) represent visible geometry only. Target bounds must be governed per platform guidelines; visible geometry is not identical to interactive hit bounds.
- **Arabic RTL & Bidi Integrity:**
  - Explicit `dir="ltr"` on phone container and input isolates Egyptian numeric string (`010 4989 2908`) from the RTL flow, preventing cursor jumping and misplaced country code pills.
  - Explicit `dir="ltr"` on email input keeps domain syntax (`@example.com`) left-aligned without punctuation disruption.
  - Currency format uses Western Arabic numerals (`2,800`) with trailing currency unit (`ج.م`).

### Step 9: ALTERNATIVES EVALUATION (Radius & Focus)
- **Input Radius Comparative Visual Review (6px vs 8px vs 10px):**
  - *Explicit Visual Inspection:* All three radius candidates were inspected on the Owner Property Wizard (`input_radius_6px_owner.png`, `input_radius_8px_owner.png`, `input_radius_10px_owner.png`).
  - *6px (Exact Button Match):* Extremely crisp and architectural. Matches the 6px Primary Button below with exact geometric continuity. In dense operational forms, 6px feels disciplined and serious, but on larger fields and textareas it may feel slightly severe or austere.
  - *8px (System Recommended — 8PX_RECOMMENDATION_RETAINED):* Introduces a gentle softening curve that relieves the slight austerity of 6px on large containers while remaining disciplined. Visually, 8px harmonizes naturally with the 6px Primary Button without copying it blindly, balancing Customer hospitality warmth with Owner operational rigor. Does not claim touch ergonomics.
  - *10px:* Corners visually detach from the 6px button. The roundness becomes noticeable as a distinct consumer-style curve, clashing with the disciplined button geometry.
- **Focus Ring Alternatives:**
  - *Restrained Interaction Accent (Pilot `#276EF1` 1px accent field border + 3px outer halo - Recommended):* Provides immediate, unambiguous feedback indicating active text focus. Does not compete with black buttons.
  - *Pure Black (`#000000` 1px field border + 3px halo):* Visually competes directly with the `#000000` Primary CTA button, creating cognitive confusion about what is primary on the page.

### Step 10: PROTOTYPE & VISUAL TEST
- Controlled visual evidence captured across 12 artifacts (`DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/evidence/`):
  - Customer Auth verified in `customer_auth_hybrid_390.png`.
  - Customer Search & Refine verified in `customer_search_hybrid_390.png`.
  - Owner Wizard verified in `owner_property_hybrid_390.png`.
  - Complete state matrix verified in `state_matrix_hybrid_390.png`.
  - Narrow-width reflow verified in `stress_reflow_360_width.png` (360px controlled Web frame reference) with zero horizontal overflow.
  - High text scaling (true 200%, `zoom: 2.0`) verified in `stress_text_scale_200.png` with clean multi-line wrapping, dynamic container expansion, product-neutral error text wrapping, and robust Bidi preservation without clipping.

### Step 11: DECISION & FOUNDER SELECTION
- **Field Strategy:** Adopt **Outline-Led Field Baseline (Crisp 1px Neutral Outline on Pure White)** as the provisional field visual strategy (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`). Any multi-field grouping shown in the pilot is `PILOT COMPOSITION ONLY / PHASE 4E STRUCTURAL AUTHORITY DEFERRED`.
- **Founder Decision (Mobile Field Radius):**
  - **FOUNDER_DECISION:** **8PX MOBILE FIELD RADIUS**
  - **STATUS:** **`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`**
  - **Evaluated Alternatives:**
    - `6px`: evaluated alternative, NOT selected for fields (retained as `PRIMARY_ONLY` for Primary buttons).
    - `10px`: evaluated alternative, NOT selected.
  - **Scope:** Mobile field-shaped controls only (text inputs, phone, email, numeric, search, textarea, select trigger). Not applied to buttons, checkboxes, toggles, cards, sheets, or global shape.
- **Focus Model:** Adopt **Semantic Restrained Interaction-Accent Emphasis** as the focus model (`SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`); exact native focus tokens remain `OPEN / DEFERRED TO PHASE 4I`.
- **Label / Helper / Error:** Adopt top-aligned explicit labels (Cairo 12/600/1.35), contextual helper text (12/400/1.40), and text-associated error indicators. Floating labels are not selected.
- **Select / Picker Boundary:** Trigger semantics belong to 4D; overlay grammar is `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.
- **Checkbox:** Classified as `OWNER PRODUCT-EVIDENCED CONTROL (Owner Settings)`.
- **Toggle:** Classified as `DEFERRED / NO CURRENT PRODUCT EVIDENCE`.

### Step 12: CONFIDENCE & STATUS
- **Overall Confidence:** **HIGH**
- **Recommended Field Strategy Status:** `SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`
- **Input Radius Status:** `FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`
- **Focus Treatment Status:** `SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION` (Semantic model; exact native token remains `OPEN`).

---

## 4. Expected High-Value Decision Pack

### Question 1: Recommended Overall Field Visual Strategy
- **Recommendation:** **Outline-Led Field Baseline (Crisp 1px Neutral Outline on Pure White Background)**
- **Rationale:** It establishes a crisp 1px neutral outline (`#8E8E93` pilot reference, achieving 3.26:1 contrast against pure white `#FFFFFF` under Web component-boundary baseline) on pure white as the universal baseline for standalone fields, ensuring clear edge definition on light surfaces and preventing muddy gray fills inside cards. Any multi-field grouped containers or module dividers demonstrated in the pilot are strictly **PILOT COMPOSITION ONLY / PHASE 4E STRUCTURAL AUTHORITY DEFERRED**.
- **Status:** `SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION`

### Question 2: Input Radius Founder Decision
- **FOUNDER_DECISION:** **8PX MOBILE FIELD RADIUS**
- **STATUS:** **`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`**
- **Selected Value:** **8px**
- **Evaluated Alternatives (Not Selected for Fields):**
  - **6px:** Evaluated alternative, NOT selected for fields (retained as `PRIMARY_ONLY` provisional for Primary buttons; establishes deliberate 6px action vs 8px field data-entry semantic differentiation).
  - **10px:** Evaluated alternative, NOT selected.
- **Rationale:** 8px provides the most visually balanced curve for taller 48px input containers without drifting into consumer roundness (10px). It pairs harmoniously with 6px Primary buttons while avoiding rigid geometry copying. Radius is justified solely by visual and architectural balance, not touch target ergonomics.
- **Scope:** Applies strictly to mobile field-shaped Form & Selection controls.

### Question 3: Recommended Focus Treatment
- **Recommendation:** **Semantic Restrained Interaction-Accent Emphasis**
- **Pilot Reference:** 1px accent field border + 3px outer halo in candidate blue (`#276EF1`) is a **Web pilot rendering reference only**.
- **Rationale:** Pure black focus rings visually compete with the provisional `#000000` Primary CTA button. The restrained accent provides clear focus feedback without creating action confusion.
- **Status:** `SYSTEM-VALIDATED PROVISIONAL SEMANTIC DIRECTION` (Semantic direction; exact native token remains `OPEN`).

### Question 4: Recommended Label / Helper / Error Hierarchy
- **Label:** Cairo Profile B `12 / 600 / 1.35` in `#09090B`, placed strictly above the input. Floating labels are rejected due to Arabic descender clipping and translation expansion risks.
- **Helper Text:** Cairo Profile B `12 / 400 / 1.40` in `#71717A`. Explains user context or format examples.
- **Error Feedback:** Explicit text message + semantic alert icon + `role="alert"` + `aria-describedby`. Error border applied to field container. Pilot styling (`#DC2626`, alert icon, 12/600 typography) is a **Web pilot rendering reference only**, not final Canon.

### Question 5: Recommended Search Field Treatment
- Leading search icon at visual start (right side in RTL layout).
- Clear action button (`×`) appearing dynamically at visual end (left side in RTL) when text is populated.
- Trailing action / submit remains separate.
- Bidi isolation ensures mixed Arabic and English searches do not scramble query text. Full search IA deferred to screen workflows.

### Question 6: Recommended Select / Picker Field Treatment
- Phase 4D defines the field trigger contract: explicit label, 1px border container, selected value display (or placeholder), and trailing disclosure chevron (`ChevronDown`).
- Any selection sheet, modal, or dropdown list demonstrated in the pilot is explicitly marked:
  `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.

### Question 7: Checkbox and Toggle Status
- **Checkbox:** Product-evidenced solely in `owner-app/src/components/profile/ProfileView.tsx` (notification settings). Zero evidence exists in `customer-app`. Classified as: `PRODUCT-EVIDENCED CONTROL (Owner Settings) / FUTURE GENERAL CONTRACT`.
- **Toggle / Switch:** Zero product evidence in current code (raw checkboxes used). Classified as: `DEFERRED / FUTURE BOUNDED CONTROL / NO CURRENT CANONICAL PRODUCT EVIDENCE`. It does not influence current system adoption; no switch migration is manufactured.

### Question 8: Customer vs. Owner Composition Differences
- **Customer Role:** Emphasizes hospitality, spacious breathing room, lower density, and immediate trust. Uses standalone outlined fields with generous vertical rhythm.
- **Owner Role:** Emphasizes operational density, high scanability, and rapid repeated entry. Uses compact steppers, currency-suffixed numeric fields, and structured data entry.

### Question 9: What Remains OPEN (Preserved Boundaries)
- Exact Neutrals (`OPEN`).
- Exact Blue Token (`OPEN`, candidate `#276EF1`).
- Exact Destructive / Error Red Token (`OPEN`, pilot rendering `#DC2626`).
- Exact Native Focus Token (`OPEN`).
- Global Shape System (`OPEN`).
- Structural Spacing & Elevation (`PHASE 4E`).
- Overlay Container & Bottom Sheet Grammar (`PHASE 4F`).
- Native Mobile Flutter Acceptance (`PHASE 4I`).

### Question 10: Founder Decisions Budget & Resolution
- **Decision Status:** **RECORDED & RESOLVED**
- **FOUNDER_DECISION:** **8PX MOBILE FIELD RADIUS**
- **STATUS:** **`FOUNDER-SELECTED SYSTEM-EVALUATED PROVISIONAL PHASE 4D CANDIDATE`**
- **Resolution:** The Founder explicitly approved the system recommendation of 8px mobile field radius. 6px is recorded as an evaluated alternative, NOT selected for fields (retained as `PRIMARY_ONLY` for Primary buttons). 10px is recorded as an evaluated alternative, NOT selected. Zero further visual decisions required for Phase 4D.
