# KONFRM Phase 4H — Open & Governed Values Register

**Document Status:** CANONICAL VALUES REGISTER — PHASE 4H  
**Branch:** `design/component-contract-catalog-01`  
**Purpose:** Precise registry of all component design values, geometric parameters, color tokens, and platform metrics, classified by exact governance and maturity status.

---

## 1. Maturity Classification Hierarchy

Values in this register are strictly classified into one of the following authoritative levels:

1. **`CANONICAL_PRODUCT_TRUTH` / `GOVERNED`:** Non-negotiable architectural invariant, Master Rule, or database schema truth.
2. **`FOUNDER-SELECTED_PROVISIONAL`:** Explicitly chosen by Founder during Phase 4A–4E gates as the provisional foundation candidate.
3. **`SYSTEM-EVALUATED_PROVISIONAL`:** Empirically evaluated and validated through multi-role visual pilots and Design Court consensus, pending native Phase 4I runtime verification.
4. **`WEB_REFERENCE_ONLY`:** Observed in React SPAs or Web pilot simulations; informs behavior but is NOT native mobile authority.
5. **`OPEN`:** Unresolved token or parameter; no arbitrary value has been canonized.
6. **`DEFERRED_TO_4I`:** Requires native Flutter / iOS / Android runtime platform execution, gesture physics, text scaling, or screen reader verification.
7. **`DEFERRED_TO_LATER_PRODUCT_PHASE`:** Blocked on future Product / Business / Legal policy resolution (e.g. cancellation policy, chat eligibility, tax/VAT).

---

## 2. Component Design Values Register

| Parameter / Token | Candidate / Observed Value | Maturity Classification | Governing Phase & Authority | Boundary & Scope Rules |
|---|---|---|---|---|
| **Primary Brand Black** | `#000000` | `SYSTEM-VALIDATED PROVISIONAL` | Phase 4A / Phase 4C (buttons.md) | Stable Black for primary action surfaces and core brand marks; `#18181B` fallback comparator only; not promoted to final native Canon. |
| **Primary Button Radius** | `6px` | `FOUNDER-SELECTED PROVISIONAL` | Phase 4A / Phase 4C (buttons.md) | **PRIMARY BUTTON ONLY.** Does NOT apply to secondary buttons, inputs, cards, sheets, or dialogs. |
| **Mobile Field Radius** | `8px` | `FOUNDER-SELECTED PROVISIONAL` | Phase 4D (inputs.md) | **FIELD-SHAPED CONTROLS ONLY.** Applies to text input, phone field, search container, textarea, and select trigger. Does NOT alter 6px Primary Button. |
| **Structural Container Radius** | `12px` | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4E (cards.md) | Applies to mobile cards, grouped operational containers (`OPEN_GROUPED_CONTENT`), and section wrappers. |
| **Dialog Surface Radius** | `12px` | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4F (modals.md) | Applies strictly to centered mobile `ConfirmationDialog` modal surfaces. Provides structural harmony with 12px containers. |
| **BottomSheet Top Radius** | `16px` | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4F (bottom-sheets.md) | Applies strictly to top-left and top-right curvature of mobile bottom sheets. 12px is valid close alternative; 20px rejected as overly round. |
| **Mobile Page Horizontal Inset** | `16px` | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4E (cards.md) | Base horizontal gutter for mobile screens. Distinct from platform safe-area insets. |
| **Relational Spacing Scale** | `4 / 8 / 12 / 16 / 24 / 32 px` | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4E (cards.md) | Strict relational scale: Tier 1 (4/8px) < Tier 2 (12/16px) < Tier 3 (24px) < Tier 4 (32px). 40/48px sizing clearances are NOT formal spacing tokens. |
| **Typography Family** | `Cairo` (Profile B) | `SYSTEM-VALIDATED PROVISIONAL` | Phase 4B (DF2 §10) | Profile B mobile balanced scale: display 24/700, pageTitle 20/700, sectionTitle 17/700, cardTitle 15/700, body 14/500, bodyStrong 14/700, label 12/600, supporting 12/400, numeric 16/700, button 15/700. Native font scaling DEFERRED TO 4I. |
| **Interaction Accent Blue** | `#276EF1` (Candidate) | `OPEN` (Candidate only) | Phase 4C / 4D / 4F (DF2 §9) | Retained as restrained interaction-accent role (focus halos, active tab, active links). Exact blue hex is **OPEN**. |
| **Neutral Palette Hexes** | `#FFFFFF`, `#F8FAFC`, `#F1F5F9`, `#E2E8F0`, `#8E8E93`, `#0F172A` | `OPEN` (Web Pilot Reference) | Phase 4C / 4D / 4E | Web pilot hex values are rendering references only. Exact native neutral tokens remain **OPEN**. |
| **Semantic Status Colors** | Success, Process, Attention, Danger | `OPEN` | Phase 4G (badges.md, alerts.md) | Semantic categories are governed; exact hex values and dark-mode adaptations remain **OPEN / token-gated**. |
| **Overlay Shadow & Elevation** | `0 12px 36px rgba(15,23,42,0.16)` (Dialog); `0 -4px 24px rgba(15,23,42,0.10)` (Sheet) | `OPEN / WEB_REFERENCE_ONLY` | Phase 4F (bottom-sheets.md, modals.md) | Flat structural content by default; elevation reserved exclusively for overlays. Exact shadow blur/spread tokens remain **OPEN**. |
| **Backdrop Scrim Parameters** | `rgba(15, 23, 42, 0.45)` + `backdrop-filter: blur(2px)` | `OPEN / WEB_REFERENCE_ONLY` | Phase 4F | Controlled Web reference. Platform native scrim opacity and blur behavior remain **OPEN / DEFERRED_TO_4I**. |
| **Toast Display Duration** | `3000ms – 4000ms` (Reference) | `OPEN` | Phase 4G (alerts.md) | Must be transient, non-blocking, and long enough to read; exact millisecond duration remains **OPEN / DEFERRED_TO_4I**. |
| **Native Focus Indicator Treatment** | 1px accent border + 3px halo (Web reference) | `OPEN / DEFERRED_TO_4I` | Phase 4D (inputs.md) | Native focus indicator rendering, keyboard focus rings, and TV/hardware navigation remain **OPEN / DEFERRED_TO_4I**. |
| **Native Field Height** | `48px – 52px` (Reference) | `OPEN / DEFERRED_TO_4I` | Phase 4D (inputs.md) | Touch bounds must satisfy iOS 44pt / Android 48dp; exact native container height remains **OPEN / DEFERRED_TO_4I**. |
| **Native Touch Target Acceptance** | iOS 44pt / Android 48dp | `DEFERRED_TO_4I` | Phase 4C / 4D / 4F | Physical touch testing and interactive hit testing deferred to native Flutter execution. |
| **Secondary Button Radius** | `6px` / `8px` / `12px` | `OPEN` | Phase 4C (buttons.md) | Primary radius is locked at 6px (`PRIMARY_ONLY`); secondary button curvature remains **OPEN**. |
| **Native Detents & Sheet Gestures** | Half / Full / Draggable | `DEFERRED_TO_4I` | Phase 4F (bottom-sheets.md) | Sheet height snaps, drag-to-dismiss gesture thresholds, and spring physics deferred to Phase 4I. |
| **Customer Cancellation Policy** | Undecided | `DEFERRED_TO_LATER_PRODUCT_PHASE` | Master Rules (MR-13) | Zero cancellation fees or refund timelines may be invented. |
| **Remaining Balance Collection** | Undecided (Arrival, Cash, Electronic) | `DEFERRED_TO_LATER_PRODUCT_PHASE` | Phase 4G (STATUS_TRUTH_MATRIX.md) | Customer sees remaining balance (`total - deposit`); collection method is strictly **OPEN / NOT YET GOVERNED**. |
| **Tax / VAT / E-Invoicing Model** | Undecided | `DEFERRED_TO_LATER_PRODUCT_PHASE` | Phase 4G (STATUS_TRUTH_MATRIX.md) | General tax schema absent; system must not fabricate tax amounts or invent VAT calculations. |
| **Toggle / Switch Primitive** | Undecided | `DEFERRED_TO_LATER_PRODUCT_PHASE` | Phase 4D (inputs.md) | Zero current product evidence; no toggle contract manufactured. |
| **Owner Booking Chat Eligibility** | Undecided | `DEFERRED_TO_LATER_PRODUCT_PHASE` | Phase 4F (navigation.md) | Chat route exists; operational eligibility gating deferred to Phase 6. |

---

## 3. Preservation Invariants

Under no circumstances should Phase 4H:
1. Promote any `SYSTEM-EVALUATED PROVISIONAL` value to `CANONICAL NOW` final native tokens.
2. Arbitrarily resolve any `OPEN` color token to fill a table.
3. Invent Product, tax, cancellation, or remaining-balance rules.
4. Generalize the 6px Primary Button radius to secondary buttons, inputs, or cards.
5. Apply the 8px Field radius to buttons or containers.
