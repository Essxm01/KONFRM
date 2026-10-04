# Phase 4D — Form & Selection Primitives System Evaluation

**Document Status:** ACTIVE PILOT EVALUATION REPORT  
**Phase:** Phase 4D — Form & Selection Primitives  
**Repository Branch:** `design/form-selection-pilot-01`  
**Base Main Checkpoint:** `3520ca0dd28c013a52a2b0cc15670eab1b974442`  
**Interactive Pilot:** `DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/index.html`  
**Evidence Artifacts:** `DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/evidence/` (12 artifacts)  

---

## Executive Summary

Phase 4D establishes the foundation for form inputs and selection primitives in the KONFRM design system, bridging upstream typography (Cairo Profile B) and action semantics (Contextual / Hierarchy Hybrid, provisional `#000000` Primary, 6px Primary button radius) into daily interactive data entry across Customer, Owner, and Admin workflows.

Based on real product inspection across `customer-app/` and `owner-app/`, controlled empirical rendering across three candidate visual families, three radius options, two focus modalities, three viewports (360px, 390px, 430px), and three text scaling levels (100%, 150%, 200%), this evaluation delivers a decisive system recommendation:

1. **Overall Field Visual Strategy:** **Candidate C (Hybrid / Contextual)** is recommended. It uses crisp 1px neutral outlines (`#E4E4E7` pilot) on pure white backgrounds as the universal baseline, while introducing modular container grouping for tightly paired fields (e.g., date ranges, steppers, price/currency pairs) to eliminate "box soup" in dense Owner flows without introducing "surface soup".
2. **Input Radius:** **8px** is recommended as a `SYSTEM-VALIDATED PROVISIONAL CANDIDATE`. It provides optimal mobile ergonomics and visual comfort for taller 48px input containers while harmonizing with 6px Primary Buttons without copying button geometry blindly. 6px is retained as an alternative for Founder aesthetic preference.
3. **Focus Treatment:** **Restrained Interaction Accent (`#276EF1` candidate with 2px soft halo)** is recommended. Pure black (`#000000`) focus borders were empirically proven to compete visually with the solid black Primary Action CTA. Exact native focus token remains `OPEN`.
4. **Label / Helper / Error Hierarchy:** Explicit top labels (Cairo Profile B 12/600/1.35), user-consequence helper text (12/400/1.40), and text-associated error messages (12/600/1.35 with semantic alert icon and `role="alert"`). Floating labels are rejected due to Arabic script truncation risks.
5. **Strict Boundary Preservation:** Phase 4E (Structural System) and Phase 4F (Navigation & Overlay System) boundaries are strictly maintained. Picker overlays are explicitly designated `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.

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

### B. Preserved Open Variables
- **Input Radius:** `OPEN` (evaluated empirically in this report).
- **Exact Neutrals:** `OPEN` (pilot rendering values only).
- **Exact Blue:** `OPEN` (`#276EF1` is implementation candidate only).
- **Exact Focus Treatment:** `OPEN`.
- **Exact Destructive/Error Red:** `OPEN` (`#DC2626` is pilot rendering value only).
- **Global Shape System:** `OPEN`.
- **Native Acceptance:** `DEFERRED TO 4I`.

### C. Downstream Boundaries
- **Phase 4E (Structural System):** Spacing scale, content insets, sections, cards/rows, structural dividers, surface hierarchy, and elevation belong to 4E.
- **Phase 4F (Navigation & Overlay System):** Bottom navigation, app bars, dialogs, bottom sheets, and global overlay grammar belong to 4F. Picker triggers belong to 4D; picker overlay presentation shown in pilot is `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.

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
    - Search query text input with icon and clear action.
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
  - Region: dropdown select (`select` element with Egyptian coastal regions).
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
| **Text Input** | Customer Auth 10 (Full Name), Owner Wizard (Title, Address) | Single-line UTF-8 string | Native RTL text-align right | CANONICAL PRIMITIVE |
| **Phone Input** | Customer Auth 08, Owner Login / Registration | Egyptian mobile (11 digits, `01XXXXXXXXX`) | LTR-isolated numeric run with `+20` prefix | CANONICAL PRIMITIVE |
| **Email Input** | Customer Auth 08, Owner Profile | Standard email format (`name@domain.com`) | LTR-isolated text-align left | CANONICAL PRIMITIVE |
| **Search Input** | Customer Search Refine 04, Explore | Query string | RTL text with leading search icon & trailing clear | CANONICAL PRIMITIVE |
| **Numeric / Currency Input** | Owner Wizard (Price per night, Area), Search Price | Digits 0–9, optional thousand separator | Western Arabic numerals (0–9), unit suffix `ج.م` | CANONICAL PRIMITIVE |
| **Multiline Input (Textarea)**| Owner Wizard (Description), Disputes, Messages | Multi-line text (3–5 lines) | RTL text, vertical expansion, fixed label | CANONICAL PRIMITIVE |
| **Select / Picker Trigger** | Customer Destinations, Dates; Owner Region | Key-value choice or range selection | RTL trigger with trailing chevron / icon | CANONICAL PRIMITIVE (Overlay 4F Deferred) |
| **Stepper Control** | Customer Search 04 (Guests), Owner Wizard | Integer counters (min 0/1, max 20/50) | LTR button cluster (`-` / `+`) with RTL labels | CANONICAL PRIMITIVE |
| **Checkbox** | Owner Profile (`ProfileView.tsx` notification settings) | Boolean preference | RTL label with trailing/leading check box | EVIDENCED IN OWNER SETTINGS / FUTURE GENERAL CONTRACT |
| **Toggle / Switch** | None (checkbox used currently in React) | Boolean preference with instant effect | RTL label with trailing toggle switch | CANDIDATE INTERACTION PRIMITIVE / NO SEPARATE CAPABILITY INVENTED |

---

## 3. The 12-Step Design Reasoning Loop

### Step 1: OBSERVE
- **Context:** Mobile form data entry across Customer (hospitality, discovery, high trust) and Owner (dense operations, repeated listing inputs, rapid verification).
- **Core Problem:** Previous web implementations suffered from inconsistent styling, arbitrary border radii (varying between 12px, 16px, and 24px), ad-hoc focus rings, and potential visual competition with Phase 4C black Primary buttons.
- **Key Questions:**
  1. What is the optimal field visual strategy (Outline vs Fill vs Hybrid)?
  2. What input radius balances mobile ergonomics without blindly copying 6px button radius?
  3. What focus treatment ensures WCAG compliance without competing with `#000000` Primary CTAs?
  4. How should RTL Bidi isolation be standardized for Egyptian phone numbers, emails, and currency?

### Step 2: HYPOTHESIZE (Three Candidate Visual Families)
- **Hypothesis A (Outline-Led):** Universal 1px neutral outline (`#E4E4E7`) on pure white background for all fields. High architectural precision, crisp figure/ground contrast.
- **Hypothesis B (Subtle-Surface / Fill-Led):** Tinted neutral background (`#F4F4F5`) with borderless or hairline default state. Transitions to white on focus. Softer, low initial contrast.
- **Hypothesis C (Hybrid / Contextual - Recommended):** Crisp 1px neutral outline on pure white for standalone inputs; structured container grouping with internal dividers for related multi-field modules (dates, price/currency, steppers). Eliminates both "box soup" and "surface soup".

### Step 3: ARGUE FOR
- **For Hypothesis A:**
  - Maximum clarity on light-first surfaces.
  - Completely eliminates ambiguity regarding clickable/tappable boundaries.
  - Matches the geometric, architectural identity of KONFRM.
  - Works consistently whether fields are placed directly on page backgrounds or inside cards.
- **For Hypothesis B:**
  - Reduces perceived visual noise on complex screens by eliminating bounding lines.
  - Follows popular consumer mobile patterns (iOS grouped forms, Material 3 filled inputs).
  - Creates a distinct visual "bedding" for inputs that distinguishes them from flat text.
- **For Hypothesis C:**
  - Solves the primary weakness of Hypothesis A (too many repetitive bordered boxes in dense Owner forms) without introducing the weakness of Hypothesis B (muddy gray rectangles inside white cards).
  - Unifies paired data (arrival + departure, phone code + number, price + currency) into single visual units.
  - Adapts naturally to role psychology: clean and spacious for Customers, dense and structured for Owners.

### Step 4: ARGUE AGAINST
- **Against Hypothesis A:**
  - In screens with many consecutive fields (Owner Property Wizard), a sea of independent rectangular borders creates "box soup" and visual fatigue.
- **Against Hypothesis B:**
  - Fails when nested inside cards or sheets: white card + gray input fill + light gray background produces low-contrast "surface soup".
  - When an error occurs, adding a red border to a filled gray box creates an awkward hybrid appearance that looks like an afterthought.
  - Carries a generic, consumer-SaaS aesthetic that dilutes KONFRM's premium real-estate identity.
- **Against Hypothesis C:**
  - Requires clear component composition guidelines to ensure developers do not arbitrarily mix grouped and standalone styles.

### Step 5: RESEARCH & CLAIM HYGIENE
- **Empirical Claim Hygiene Evaluation:**
  - *Study Reference:* Biederman (1987) recognition-by-components and Gestalt boundary research (Wertheimer, 1923; Palmer, 1999).
  - *What the source directly found:* Continuous closed contours accelerate object identification and figure-ground segmentation compared to texture-only or low-contrast boundaries.
  - *Stimulus/Population:* Laboratory visual discrimination tasks using abstract 2D geometric shapes.
  - *Inference for KONFRM:* Closed 1px neutral outlines provide faster recognition of interactive touch boundaries on mobile screens than borderless low-contrast fills.
  - *Limitations / Transfer Risk:* Generic visual shape identification does not directly prove that outlined fields improve data completion rates in bilingual Arabic rental apps.
  - *Validation Requirement:* Empirical prototype rendering across Customer Auth and Owner Wizard to confirm readability, cognitive clarity, and touch confidence.

### Step 6: ROLE LENS ANALYSIS
- **Customer Role Lens:**
  - *Psychological Need:* Calmness, hospitality, trust, zero friction during booking and login.
  - *Evaluation:* Customer forms are concise (Phone/Email auth, Search filters). Outline-led standalone fields on white cards feel airy, modern, and uncluttered. High clarity during error correction reduces drop-off.
- **Owner Role Lens:**
  - *Psychological Need:* Operational speed, high scanability, high data confidence, efficient repeated data entry.
  - *Evaluation:* Owner property wizards contain 10+ data points per step. Grouped field containers (Hybrid family) keep the screen visually calm while packing essential listing data into scannable modules.

### Step 7: BRAND CONGRUENCE
- **Alignment with KONFRM Core Brand:**
  - KONFRM is monochrome-first, structured, architectural, and precise.
  - Cairo Profile B (`15/700/1.20` button, `12/600/1.35` label) requires crisp geometric grounding.
  - Candidate C (Hybrid) reinforces the architectural grid of KONFRM without introducing decorative gradients, glassmorphism, or muddy gray backgrounds.
  - Preserves the strict rule: zero yellow/amber boxed UI by default.

### Step 8: PLATFORM & ACCESSIBILITY CHECK
- **WCAG 2.2 AA Conformance:**
  - *Contrast:* Label text (`#09090B`) on white exceeds 13:1 (passes AAA). Helper text (`#71717A`) exceeds 4.5:1 (passes AA). Default border (`#E4E4E7`) provides 1.3:1 non-text boundary against white, supplemented by input text and label. Focus ring (`#276EF1`) provides 4.8:1 contrast against white background.
  - *Error Association:* Error state couples red border (`#DC2626`) with an alert circle icon, dedicated error copy, `aria-invalid="true"`, and `role="alert"` / `aria-describedby`. Zero color-only error conveyance.
  - *Touch Targets:* iOS 44pt and Android 48dp guidelines are met. Input containers have 48px minimum height. Stepper buttons have 34px visible frame with generous 44pt touch padding.
- **Arabic RTL & Bidi Integrity:**
  - Explicit `dir="ltr"` on phone container and input isolates Egyptian numeric string (`010 4989 2908`) from the RTL flow, preventing cursor jumping and misplaced country code pills.
  - Explicit `dir="ltr"` on email input keeps domain syntax (`@example.com`) left-aligned without punctuation disruption.
  - Currency format uses Western Arabic numerals (`2,800`) with trailing currency unit (`ج.م`).

### Step 9: ALTERNATIVES EVALUATION (Radius & Focus)
- **Input Radius Alternatives:**
  - *6px:* Matches Phase 4C Primary Button radius. Highly architectural and disciplined, but feels slightly sharp on 48px tall containers compared to 40px buttons.
  - *8px (Recommended):* The perceptual sweet spot. Softens the larger touch container slightly while maintaining geometric harmony with 6px buttons.
  - *10px:* Begins to look like a generic consumer pill, clashing with the disciplined 6px button.
- **Focus Ring Alternatives:**
  - *Restrained Accent Blue (`#276EF1` + 2px halo - Recommended):* Provides immediate, unambiguous feedback indicating active text focus. Does not compete with black buttons.
  - *Pure Black (`#000000` 2px ring):* Strong contrast, but visually competes directly with the `#000000` Primary CTA, creating cognitive confusion about which element is the primary page trigger.

### Step 10: PROTOTYPE & VISUAL TEST
- Controlled visual evidence captured across 12 artifacts (`DESIGN_SYSTEM/PILOTS/form-selection-pilot-01/evidence/`):
  - Customer Auth verified in `customer_auth_hybrid_390.png`.
  - Customer Search & Refine verified in `customer_search_hybrid_390.png`.
  - Owner Wizard verified in `owner_property_hybrid_390.png`.
  - Complete state matrix verified in `state_matrix_hybrid_390.png`.
  - Narrow-width 360px reflow verified in `stress_reflow_360_width.png` with zero horizontal overflow.
  - High text scaling (200%) verified in `stress_text_scale_200.png` with clean multi-line wrapping and robust Bidi preservation.

### Step 11: DECISION
- Adopt **Candidate C (Hybrid / Contextual)** as the system-recommended field visual strategy.
- Adopt **8px** as the provisional input radius candidate (`SYSTEM-VALIDATED PROVISIONAL CANDIDATE`), offering 6px as a Founder aesthetic alternative.
- Adopt **Restrained Interaction Accent (`#276EF1` candidate + halo)** as the focus model; preserve exact native focus token as `OPEN`.
- Adopt top-aligned explicit labels (Cairo 12/600/1.35) and text-associated error indicators.
- Classify Select/Picker overlay grammar as `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.
- Classify Checkbox as `OWNER PREFERENCE SETTINGS EVIDENCED / FUTURE GENERAL CONTRACT`.

### Step 12: CONFIDENCE & STATUS
- **Overall Confidence:** **HIGH**
- **Recommended Field Strategy Status:** `SYSTEM_RECOMMENDATION`
- **Input Radius Status:** `SYSTEM-VALIDATED PROVISIONAL CANDIDATE` (Founder visual preference between 8px and 6px may be selected).
- **Focus Treatment Status:** `SYSTEM_RECOMMENDATION` (semantic model; exact native token remains `OPEN`).

---

## 4. Expected High-Value Decision Pack

### Question 1: Recommended Overall Field Visual Strategy
- **Recommendation:** **Candidate C (Hybrid / Contextual)**
- **Rationale:** It establishes a clean 1px neutral outline (`#E4E4E7`) on pure white as the universal baseline for standalone fields (preventing muddy gray boxes inside cards), while permitting structured container grouping for paired inputs (dates, price/currency, steppers) in dense Owner workflows to prevent "box soup".
- **Status:** `SYSTEM_RECOMMENDATION`

### Question 2: Recommended Input Radius
- **Recommendation:** **8px**
- **Alternative:** **6px** (exact match with Primary Button)
- **Rationale:** 8px provides the most comfortable, balanced visual curve for 48px mobile touch targets without drifting into bubbly consumer SaaS territory. It harmonizes naturally with 6px Primary buttons.
- **Status:** `SYSTEM-VALIDATED PROVISIONAL CANDIDATE` / `FOUNDER_VISUAL_SELECTION_REQUIRED` (if Founder prefers exact 6px geometric alignment).

### Question 3: Recommended Focus Treatment
- **Recommendation:** **Restrained Interaction Accent Blue (`#276EF1` candidate 2px ring + 2px soft halo `rgba(39, 110, 241, 0.15)`)**
- **Rationale:** A pure black focus ring competes visually with the `#000000` Primary CTA button. The restrained blue accent provides crisp focus feedback without adding decorative noise.
- **Status:** `SYSTEM_RECOMMENDATION` (Semantic direction; exact native token remains `OPEN`).

### Question 4: Recommended Label / Helper / Error Hierarchy
- **Label:** Cairo Profile B `12 / 600 / 1.35` in `#09090B`, placed strictly above the input. Floating labels are rejected due to Arabic descender clipping and translation expansion risks.
- **Helper Text:** Cairo Profile B `12 / 400 / 1.40` in `#71717A`. Explains user context or format examples.
- **Error Feedback:** Cairo Profile B `12 / 600 / 1.35` in `#DC2626` (pilot red) + alert icon (`<circle cx="12" cy="12" r="10"/>...`) + `role="alert"` + `aria-describedby`. Error border applied to field container.

### Question 5: Recommended Search Field Treatment
- Leading search icon (visual start / right side in RTL layout).
- Clear action button (`×`) appearing dynamically at visual end (left side in RTL) when text is populated.
- Trailing action / submit remains separate.
- Bidi isolation ensures mixed Arabic and English searches do not scramble query text.

### Question 6: Recommended Select / Picker Field Treatment
- 4D defines the field trigger contract: explicit label, 1px border container, selected value display (or placeholder), and trailing disclosure chevron (`ChevronDown`).
- Any selection sheet, modal, or dropdown list demonstrated in the pilot is explicitly marked:
  `PILOT COMPOSITION ONLY / PHASE 4F AUTHORITY DEFERRED`.

### Question 7: Checkbox and Toggle Status
- **Checkbox:** Canonical product evidence exists solely in `owner-app/src/components/profile/ProfileView.tsx` (notification settings). Zero evidence exists in `customer-app`. Classified as: `OWNER PREFERENCE SETTINGS EVIDENCED / FUTURE GENERAL CONTRACT`.
- **Toggle / Switch:** Zero product evidence in current code (raw checkboxes used). Evaluated as a candidate alternative for immediate-effect preference switches, but no fake settings or consent flows are manufactured.

### Question 8: Customer vs. Owner Composition Differences
- **Customer Role:** Emphasizes hospitality, spacious breathing room, lower density, and immediate trust. Uses standalone outlined fields with generous vertical rhythm.
- **Owner Role:** Emphasizes operational density, high scanability, and rapid repeated entry. Uses grouped modules, compact steppers, and currency-suffixed numeric fields.

### Question 9: What Remains OPEN (Preserved Boundaries)
- Exact Neutrals (`OPEN`).
- Exact Blue Token (`OPEN`, candidate `#276EF1`).
- Exact Destructive / Error Red Token (`OPEN`, pilot `#DC2626`).
- Exact Native Focus Token (`OPEN`).
- Global Shape System (`OPEN`).
- Structural Spacing & Elevation (`PHASE 4E`).
- Overlay Container & Bottom Sheet Grammar (`PHASE 4F`).
- Native Mobile Flutter Acceptance (`PHASE 4I`).

### Question 10: Founder Decisions Budget
- **Total Founder Decisions Requested:** **1** (or **0** if Founder approves the system recommendation directly).
- **Decision:**
  - *Option 1 (System Recommended):* Confirm **8px** input radius as provisional mobile candidate.
  - *Option 2:* Confirm **6px** input radius to match Primary Button radius exactly.
