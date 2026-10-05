# Phase 4F Navigation & Overlay System Evaluation

> [!NOTE]
> **DATA CLASSIFICATION: LAB_SCENARIO_DATA**
> All data displayed in this pilot (names, booking IDs, property records, queues, pricing, and dates) is synthetic scenario data for layout and presentation testing only.
> `LAB_SCENARIO_DATA ≠ production evidence`.

**Status:** `SYSTEM_EVALUATED_SYNTHESIS`
**Phase:** `PHASE_4F_NAVIGATION_OVERLAY_SYSTEM`
**Pilot Directory:** `DESIGN_SYSTEM/PILOTS/navigation-overlay-pilot-01/`
**Governing Architecture:** `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` (DF2 v1.4)

---

## 1. Executive Summary

Phase 4F evaluated and established the navigation, hierarchy, return-path, overlay (bottom sheet / dialog), sticky action, and safe-area geometry across KONFRM mobile applications.

The evaluation rigorously tested three candidate hypotheses:
1. **Candidate A (Persistence-First):** Failed Hard Gates due to dual bottom chrome collision on nested screens and attempting Owner bottom navigation contrary to canonical architecture.
2. **Candidate B (Immersive-Hierarchical):** Architectural hypothesis eliminated before full visual pilot by Canonical Route Presentation Architecture (`B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`). Forcing full-screen takeovers for transient filtering tasks violates mobile architecture §8 where contextual windows are specified as sheets.
3. **Candidate C (Role-Aware Contextual):** Strongly recommended by Design Court v1 (`CASE_ID: DC-4F-001`, `STRONG_CONSENSUS`, `HIGH`). Perfectly balances persistent top-level discovery on Customer, action-first operational hub on Owner, contextual overlay grammar, and zero dual chrome collisions.

---

## 2. Key Architectural Decisions & Evidence Verification

### 2.1 Customer Top-Level & Nested Navigation
- **Top-Level Root:** Exactly four persistent destinations (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`). Explore header combines standalone brand mark (`konfrm-symbol-black.svg`) with single account affordance; zero notification bell clutter.
- **Nested Screens:** On Property Detail, dedicated transactional review (Booking Request Review Screen 07), and deep workflows, top-level bottom navigation is hidden by default. This completely eliminates the dual bottom chrome defect demonstrated in Candidate A (`candidate_a_customer_detail_390.png` vs `candidate_c_customer_detail_390.png`). Screen 16 (Notification Center) is the governed `ACCOUNT_SHELL_CHILD_EXCEPTION` (Master Rule MR-17) where Bottom Navigation remains visible with the Account tab active (`customer_notifications_390.png`).
- **Return Path:** Contextual app bar features an explicit RTL Back button pointing right (➔).
- **Context Restoration Contract:** Defined (`CUSTOMER_CONTEXT_RESTORATION: CONTRACT_DEFINED_RUNTIME_DEFERRED`). Returning to Explore preserves active scroll position and search filter parameters; runtime state restoration is deferred to native Flutter Phase 4I.

### 2.2 Owner Mobile Navigation (No Bottom Navigation)
- **Canonical Architecture Compliance:** Mobile Owner application operates as an **Action-First Operational Hub** with dashboard-style nested routing **WITHOUT** Customer-style bottom navigation.
- **Discoverability:** High-priority operational triage (pending booking requests, upcoming check-ins) is directly prominent on Home without deadline invention (`owner_home_390.png`). High-frequency domains (Bookings, Properties, Wallet) are accessible via a high-contrast 3-column domain grid.
- **Contextual Destination Access:** Other recognized destinations have governed access paths without creating a hidden hamburger dumping ground:
  - *Calendar / Availability:* Contextual access from Property operations / Property Detail.
  - *Messages:* Booking-contextual access from eligible booking states when product policy allows (`CHAT_CONTEXT: BOOKING_CONTEXTUAL`, `CHAT_ELIGIBILITY: OPEN / DEFERRED_TO_PHASE_12_PRODUCT_POLICY`).
  - *Disputes:* Contextual support/operational destination (`NAVIGATION_ALLOCATION: NO_PERSISTENT_TOP_LEVEL_SLOT`, presentation deferred to Phase 13).
  - *Profile / Notifications:* Operational identity and notification affordances in header/account context.
- **Deep Views:** Bookings Queue and Property Operations feature structured stack routing with an RTL Back button returning directly to Home.

### 2.3 Auth V2 Full-Screen Lock
- Tapping protected actions (e.g. Favorite or Book as guest) initiates a sequential full-screen route flow (`08 → 09 → 10`), **NOT** a modal or sheet.
- Continuation intent and auth origin context are preserved (`AUTH_CONTINUATION: INTENT_CONTEXT_CONTRACT_DEFINED`); cancelling returns cleanly to the prior unauthenticated screen with draft inputs intact.

### 2.4 Overlays: BottomSheet & Dialog Grammar
- **BottomSheet:** Anchored to bottom, preserving underlying contextual view.
  - *Dismiss Grammar:* Explicit dismiss control (Close X icon or Cancel text) is **REQUIRED**. Drag handle is **OPTIONAL** (governed only when draggable and supported by platform). Backdrop tap dismissal is **CONDITIONAL** on low-risk tasks (never on unsaved consequential inputs).
  - *Height Geometry:* Controlled Web pilot max-height (~85%) is a reference only; exact native height/detent behavior is `DEFERRED_TO_4I`.
  - *Scope Exclusion:* BottomSheet is never for Auth V2, Property Detail, Booking Request Review (Screen 07), or multi-step wizards.
  - *Evaluated Top Radii:* 16px is closed as system-evaluated provisional candidate (`sheet_radius_16_390.png`); 12px is a valid close container-aligned alternative; 20px rejected as overly round.
- **Dialog:** Centered modal overlay, reserved strictly for short consequential confirmation, high-stakes acknowledgement, and destructive irreversible decisions (e.g. Owner reject booking request).
  - *Truthful Consequence Copy:* Explicit plain Arabic consequence without invented SLA or policy claims: *"سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون"*.
  - *Customer Cancellation:* Removed / reclassified as `DEFERRED_PRODUCT_POLICY`.
  - *Bounded Dialog Radius:* Evaluated across 10px, 12px, and 16px (`dialog_radius_10_owner_390.png`, `dialog_radius_12_owner_390.png`, `dialog_radius_16_owner_390.png`). 12px is closed as `12PX SYSTEM-EVALUATED PROVISIONAL DIALOG_RADIUS` (aligned with 4E structural container radius 12px; 10px is a valid sharper alternative; 16px introduces excess softness).
- **Overlay Elevation & Scrim:** Minimum necessary elevation. Exact shadow parameters (`0 -4px 24px...`, `0 12px 36px...`) and scrim opacity/blur values are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE / OPEN`; native acceptance deferred to Phase 4I.

### 2.5 Safe-Area & Content Clearance Discipline
- Semantic distinction: Page insets (16px) != platform safe-area insets != persistent control clearance (`SAFE_AREA_CONTRACT: DEFINED`).
- Bottom navigation, sticky action surfaces, and bottom sheets pad platform safe areas.
- Scroll containers reserve matching bottom clearance padding ensuring zero content terminates obscured behind persistent controls.
- Web formulas (`env(safe-area-inset-bottom)`, `padding-bottom: calc(...)`) are controlled Web geometry references; native safe-area acceptance is `DEFERRED_TO_4I`.
- Keyboard adaptation verified in `customer_sheet_keyboard_390.png`.

### 2.6 Admin Boundary Isolation
- Admin desktop workspace (1440px) remains strictly preserved as a table/queue review console without mobile navigation or sheet contamination (`admin_review_queue_1440.png`).

---

## 3. Status Bands & Deferred Variables

- **Decision Status:** `SYSTEM_EVALUATED_CANDIDATE` (Candidate C).
- **Consensus Class:** `STRONG_CONSENSUS`
- **Confidence:** `HIGH`
- **Exact Blue:** `OPEN` (Restrained interaction-accent role governed; `#276EF1` is pilot comparator only).
- **Exact Neutrals:** `OPEN` (Palette tokens remain implementation references).
- **Exact Overlay Shadow Parameters:** `OPEN_OR_WEB_REFERENCE_ONLY`
- **Exact Scrim Values:** `OPEN_OR_WEB_REFERENCE_ONLY`
- **Native Touch Target Acceptance:** `DEFERRED_TO_4I` (iOS ~44pt / Android ~48dp guidance preserved; Web px evidence does not establish native acceptance).
- **Founder Decision Required:** `NO` (Sole valid surviving candidate; Hard Gates eliminated competitors; reversible geometry closed via bounded evidence check).
