# KONFRM Design Court v1 — Deliberation & Verdict Report

> [!NOTE]
> **DATA CLASSIFICATION: LAB_SCENARIO_DATA**
> All data displayed in this pilot (names, booking IDs, property records, queues, pricing, and dates) is synthetic scenario data for layout and presentation testing only.
> `LAB_SCENARIO_DATA ≠ production evidence`.

**CASE_ID:** `DC-4F-001`
**DATE:** 2026-10-05
**PHASE:** Phase 4F — Navigation & Overlay System
**PILOT:** `navigation-overlay-pilot-01`
**MODE:** `FULL_COURT`
**DELIBERATION_TOPOLOGY:** `SINGLE_AGENT_STRUCTURED_PANEL`
*(Deliberation executed sequentially with sealed role briefs by a structured single-agent panel; consensus reflects structured role alignment, not independent autonomous agents).*

---

## 1. Case Docket & Presiding Question

### Presiding Question
*"What navigation and overlay grammar should govern KONFRM mobile Customer and Owner experiences while respecting the canonical Customer four-tab model, Owner no-bottom-nav architecture, Arabic RTL hierarchy, and role-specific UX?"*

### Evaluating Candidates
- **`CANDIDATE_A` (Persistence-First):** Persistent 4-tab bottom navigation kept visible across nested detail screens (causing dual bottom chrome with sticky CTA); persistent bottom dock attempted for Owner.
- **`CANDIDATE_B` (Immersive-Hierarchical):** Architectural hypothesis: aggressive hiding of all navigation chrome upon scroll or nested entry; full-screen modal takeovers for transient filters; minimal header branding. Eliminated before full visual pilot under Canonical Route Presentation Architecture (`B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`).
- **`CANDIDATE_C` (Role-Aware Contextual):** Customer 4-tab bottom nav persistent strictly on top-level root destinations (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`); nested screens hide bottom nav and expose contextual app bar + sticky decision bar; Owner uses Action-First Home hub with discoverable domain entries and clear back-to-hub hierarchy; sheets for short contextual refine, dialogs for high consequence.

---

## 2. Hard Gates Evaluation (Round 6)

Before open deliberation, the Evidence Clerk subjected all three candidate systems to Court Hard Gates:

| Hard Gate | Governing Authority | Candidate A | Candidate B | Candidate C |
|---|---|---|---|---|
| **GATE 1: CANONICAL_MOBILE_ARCHITECTURE** | `KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md` §2, §3 & §8 | **FAIL** (Eliminated: attempts Owner bottom navigation contrary to canonical architecture) | **FAIL** (Eliminated: full-screen takeovers for transient filters violate §8 where contextual mobile windows/filters are specified as sheets; `ELIMINATED_BY_CANONICAL_ROUTE_ARCHITECTURE`; `B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`) | **PASS** (Customer 4 tabs on top-level; Owner dashboard-style nested routing without bottom nav; contextual sheets for filters) |
| **GATE 2: CUSTOMER_FOUR_DESTINATIONS** | `MOBILE_DESIGN_FOUNDATION.md`, `CustomerBottomNav.tsx` | **PASS** | **PASS** | **PASS** (Strictly preserves Explore, Favorites, Bookings, Account) |
| **GATE 3: AUTH_V2_FULL_SCREEN** | Auth V2 Specification (`08 → 09 → 10`) | **PASS** | **PASS** | **PASS** (Strictly sequential full-screen route flow) |
| **GATE 4: PRODUCT_TRUTH** | `docs/BUSINESS_RULES.md` | **PASS** | **PASS** (Architectural hypothesis eliminated before full visual pilot; not evaluated as Product Truth failure) | **PASS** (Truthful states, Request CTA prior to approval, explicit dialog consequence: *"سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون"*) |
| **GATE 5: ACCESSIBILITY_REQUIREMENTS** | WCAG 2.2 AA / Platform Guidance Category | **WARN** (Dual bottom chrome crowds viewport, competing persistent bottom action regions, interaction ambiguity, reduced usable viewport) | **PASS** | **PASS** (Zero collision, unclipped under 200% text scale, visible action hit regions preserved; native touch target acceptance ~44pt iOS / ~48dp Android `DEFERRED_TO_4I`) |
| **GATE 6: RTL_CORRECTNESS** | `MOBILE_DESIGN_FOUNDATION.md` §11–§12 | **PASS** | **PASS** | **PASS** (Semantic start/end, RTL Back arrow points right [➔], Close X is direction-neutral) |
| **GATE 7: SAFE_AREA_NON_OVERLAP** | DF2 §14 & Phase 4F Directive §18 | **FAIL** (Eliminated: dual bottom chrome collision on nested screens; sticky CTA stacked over bottom nav; content clearance failure) | **PASS** | **PASS** (Mutual exclusivity: bottom nav hidden on nested screens with sticky CTA; guaranteed bottom clearance) |
| **GATE 8: ARCHITECTURE_BOUNDARY** | `KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md` | **FAIL** (Eliminated: violates Owner no-bottom-nav architecture lock) | **PASS** | **PASS** (Isolates mobile grammar from Admin desktop table workspace) |
| **GATE 9: CONTEXT_PRESERVATION** | DF2 §16 & Phase 4F Directive §40 | **PASS** | **PASS** | **PASS** (Context restoration contract defined: Explore state restored after sheet/detail return; auth origin context / continuation intent preserved; static pilot runtime verification `DEFERRED_TO_4I`) |

**Gate Result:**
- **Candidate A is `ELIMINATED_BY_HARD_GATE`** (Failed Gate 1 Canonical Mobile Architecture and Gate 7 Safe-Area / Non-Overlap via dual bottom chrome collision). Classified as `REJECTED_COMPARATOR`.
- **Candidate B is `ELIMINATED_BY_CANONICAL_ROUTE_ARCHITECTURE`** (Architectural hypothesis eliminated before full visual pilot; failed Gate 1 Canonical Mobile Architecture / Route Presentation Architecture; `B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`). Classified as `REJECTED_COMPARATOR`.
- **Candidate C is the sole surviving candidate** satisfying all Hard Gates. Deliberation proceeds on Candidate C.

---

## 3. Specialist Consultation & Attribution Ledger

```
SKILL:                konfrm-product-ux
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-product-ux/SKILL.md
SOURCE_ANCHOR:        §1 Role-Specific UX Mandates
APPLIED_PRINCIPLE:    Customer booking request clarity (never instant booking; review and approval strictly precedes deposit payment; transparent pricing); Owner operational certainty (clear visibility into property status, booking requests awaiting review); Admin operational governance & audit clarity without decorative fluff.
POSITION:             CANDIDATE_C (Role-Aware Contextual)
EVIDENCE:             Candidate C provides clear contextual distinction: Customer explores without distraction, while Owner Home immediately surfaces actionable pending requests without bottom-nav clutter.
CONFIDENCE:           HIGH
LIMITATION:           Evaluated against prototype state; live booking conversion metrics pending production launch.
```

```
SKILL:                konfrm-mobile-design
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-mobile-design/SKILL.md
SOURCE_ANCHORS:       §1 Brand Identity & Visual Language & §3 Subordinating External Numeric Heuristics & Decision Status Bands
APPLIED_PRINCIPLE:    Monochrome-first brand identity (Black/White logo, `#000000` Primary Black); restrained blue interaction-accent role (candidate `#276EF1`); light-first dominant intent; decision status classification separates published provisional candidates (6px button, 8px field, 12px structural container) while overlay geometry remains open; native touch target acceptance (~44pt iOS / ~48dp Android) is DEFERRED_TO_4I.
POSITION:             CANDIDATE_C (Supports Role-Aware Contextual navigation; 16px bottom sheet top radius evaluated as balanced mobile candidate).
EVIDENCE:             Visual inspection of customer_sheet_390.png and sheet_radius_16_390.png confirms harmonious curvature against 12px structural cards and 8px input fields.
CONFIDENCE:           HIGH
LIMITATION:           Native Flutter rendering and touch acceptance deferred to Phase 4I.
```

```
SKILL:                konfrm-accessibility
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-accessibility/SKILL.md
SOURCE_ANCHORS:       §1 Contrast Ratios & Legibility Framework & §2 Touch Targets & Platform Guidance Categories
APPLIED_PRINCIPLE:    Visual bounds and hit regions are distinct; content insets and vertical rhythm must accommodate 200% text scaling without clipping; platform guidance (~44pt iOS / ~48dp Android) is distinct from raw web pixels; exact mobile target dimensions remain subject to empirical device and component validation.
POSITION:             CANDIDATE_C (Eliminates dual bottom chrome collision; ensures scrollable content never terminates behind sticky actions).
EVIDENCE:             Controlled Web pilot artifacts stress_true_200_customer_detail_390.png and stress_true_200_sheet_390.png prove zero text clipping or overlapping controls under 200% text scaling.
CONFIDENCE:           HIGH (controlled Web evidence)
LIMITATION:           Evaluated on controlled Web pilot; physical screen reader and native touch-target acceptance deferred to native Flutter Phase 4I.
```

```
SKILL:                konfrm-rtl-arabic
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-rtl-arabic/SKILL.md
SOURCE_ANCHORS:       §1 Core Foundations: Arabic-First & RTL-Native & §2 Directional Semantics & Exceptions (No Blind Mirroring)
APPLIED_PRINCIPLE:    Natural reading flow progresses from top-right to bottom-left; Back buttons point right (➔) to return to previous screens in RTL; Close (X) is direction-neutral; no blind mirroring of media scrubbers, progress spinners, or phone numbers.
POSITION:             CANDIDATE_C (Strict RTL semantic hierarchy).
EVIDENCE:             stress_long_arabic_owner_queue_390.png proves multi-line Arabic titles and reference IDs (`#KN-2026-9948271`) wrap cleanly without truncating headers or misaligning action badges.
CONFIDENCE:           HIGH
LIMITATION:           Font metrics tested with Cairo Profile B in controlled Web pilot; native text engine shaping deferred to Phase 4I.
```

```
SKILL:                konfrm-visual-qa
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-visual-qa/SKILL.md
SOURCE_ANCHORS:       CORE TENET: CI GREEN != VISUAL QA PASSED & §1 Initial QA Reference Matrix
APPLIED_PRINCIPLE:    Visual inspection across realistic viewport candidate coverage set (360px, 390px, 430px) is mandatory; layout success requires inspecting rendered pixels.
POSITION:             CANDIDATE_C verified across 27 visual artifacts.
EVIDENCE:             Inspected artifacts confirm Candidate C avoids dual bottom chrome collision, preserves responsive reflow across 360/390/430 viewports, isolates Admin desktop table layout, and provides bounded radius comparisons.
CONFIDENCE:           HIGH
LIMITATION:           Headless Chrome capture; physical mobile device validation deferred to Phase 4I.
```

```
SKILL:                konfrm-design-reasoning
STATUS:               CONSULTED
CONSULTATION_SOURCE:  docs/ai/skills/konfrm-design-reasoning/SKILL.md
SOURCE_ANCHOR:        §1 The 12-Step Decision Loop & §2 Structured Dialectic (Hypotheses A/B/C)
APPLIED_PRINCIPLE:    Use structured dialectic to compare competing hypotheses, argue for/against each across structured dimensions, test them against evidence and role constraints, and publish confidence and decision status.
POSITION:             CANDIDATE_C (Optimal resolution of conflicting structural and operational requirements).
EVIDENCE:             Candidate C eliminates competing action surfaces while keeping primary operational tasks accessible within 1 tap of Home for Owner and 1 tap of Bottom Nav for Customer.
CONFIDENCE:           HIGH
LIMITATION:           Design reasoning synthesis; physical user testing deferred to post-pilot validation.
```

---

## 4. Resolution of the 12 Governed Court Questions

1. **Customer Bottom Nav Visibility:**
   **RESOLVED:** Visible **strictly on the four top-level root destinations** (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`). Hidden on all nested entity screens (e.g. Property Detail, Booking Detail), transactional flows, and full-screen auth routes.
2. **Customer Nested Hierarchy Grammar:**
   **RESOLVED:** Dedicated full page with contextual App Bar featuring an explicit RTL Back button (arrow pointing right [➔]). Top-level bottom nav is hidden and replaced contextually by the Sticky Decision Surface when forward action is required.
3. **Owner Dashboard / Nested Navigation Model (No Bottom Nav):**
   **RESOLVED:** Action-First Home hub as operational command center. Direct, high-visibility domain entry cards on Home for Bookings, Properties, and Wallet. Nested screens use clear stack routing with an RTL Back button returning to Home or parent queue. Zero bottom navigation bar.
4. **Owner Frequent Destination Discoverability (No Hamburger Dumping Ground):**
   **RESOLVED:** Operational triage (pending booking requests, upcoming stays) is directly prominent on Home. High-frequency domains (Bookings, Properties, Wallet) are accessible via a dedicated 3-column domain grid on Home. Contextual access paths are governed for other recognized destinations: Calendar/Availability via Property operations/Detail; Messages via eligible booking context when product policy allows (eligibility OPEN); Profile/Notifications via account/header affordances; Disputes via contextual support entry (presentation deferred). Zero hidden hamburger menu.
5. **BottomSheet vs Full Page & Dismiss Grammar:**
   **RESOLVED:** BottomSheet is reserved strictly for short contextual tasks, search/refine filters, pickers, and transient confirmations (preserving underlying context). Full Page is mandatory for meaningful destinations, full entity evaluation (Property Detail), dedicated transactional review (Booking Request Review Screen 07), multi-step wizards, and Auth V2 (`08 → 09 → 10`). BottomSheet is never a full-screen navigation substitute.
   - **Dismiss Grammar:** Explicit dismiss control (Close X icon or Cancel text) is **REQUIRED**. Drag handle is **OPTIONAL** (governed only when the sheet is draggable and supported by platform). Backdrop tap dismiss is **CONDITIONAL** on low-risk tasks (never on unsaved consequential inputs). Swipe-to-dismiss is **CONDITIONAL**.
   - **Height Geometry:** Controlled Web pilot max-height (~85%) is a reference only; exact native height/detent behavior is `DEFERRED_TO_4I`.
6. **Dialog vs Sheet:**
   **RESOLVED:** Dialog is reserved strictly for short consequential confirmation, high-stakes acknowledgement, and destructive irreversible decisions (e.g. Owner Reject booking request). Truthful consequence copy: *"سيتم رفض طلب الحجز ولن ينتقل هذا الطلب إلى خطوة دفع العربون."* Centered modal overlay, explicit verbal explanation of consequence, safe/destructive button pair; never relies on color alone. Customer cancellation dialog is removed / reclassified as `DEFERRED_PRODUCT_POLICY`. Sheet is for multi-input contextual tasks and filters.
7. **Back vs Close:**
   **RESOLVED:** Back (Arrow pointing right [➔] in RTL) represents hierarchical return up a navigation stack. Never use an X to navigate backward. Close (X icon or Cancel text) represents dismissing a temporary overlay layer (Sheet or Dialog) without mutating the underlying navigation hierarchy. Never use a Back arrow merely to close a temporary sheet.
8. **App Bar Families Required:**
   **RESOLVED:** Exactly six governed screen families:
   - `TOP_LEVEL_CUSTOMER`: Standalone brand mark + account affordance on Explore; semantic title on other tabs; no Bell icon.
   - `NESTED_CUSTOMER`: RTL Back + Page title + optional contextual actions.
   - `NESTED_TRANSACTIONAL_CUSTOMER`: RTL Back + Transactional review title (Screen 07 Booking Request Review).
   - `TOP_LEVEL_OWNER`: Owner identity + verification pill + operational alert affordance.
   - `NESTED_OWNER`: RTL Back + Operational queue/entity title + status badge.
   - `TEMPORARY_LAYER_HEADER`: Sheet title + Close X; Dialog title.
   - `AUTH_FULL_SCREEN_HEADER`: Brand mark / step indicator + Back / Cancel.
9. **Sticky Actions Interaction with Navigation Chrome & Context Preservation:**
   **RESOLVED:** Dual bottom chrome is prohibited. A screen must never display both a persistent bottom nav and a persistent sticky action bar simultaneously. Sticky actions replace bottom nav on nested transactional screens, respecting bottom safe-area insets with reserved content clearance.
   - **Context Restoration:** Contract defined (`CUSTOMER_CONTEXT_RESTORATION: CONTRACT_DEFINED_RUNTIME_DEFERRED`). Returning to Explore from Detail or Sheet preserves results and filter criteria. Protected action continuation intent / auth origin context is preserved. Static pilot runtime verification is `DEFERRED_TO_4I`.
10. **Overlay Shape & Elevation Family:**
    **RESOLVED:**
    - BottomSheet Top Radius: `16px` system-evaluated provisional candidate (balanced mobile curvature; 12px valid close container-aligned alternative; 20px rejected as overly round).
    - Dialog Radius: Bounded visual comparison (10px, 12px, 16px in `dialog_radius_10_owner_390.png`, `dialog_radius_12_owner_390.png`, `dialog_radius_16_owner_390.png`) confirms `12px` system-evaluated provisional candidate (aligned with 4E structural container radius `12px`; 10px valid sharper alternative, 16px introduces excess softness).
    - Elevation & Scrim: Minimum necessary elevation. Exact shadow parameters (`0 -4px 24px...`, `0 12px 36px...`) and scrim opacity/blur values are `CONTROLLED_WEB_PILOT_RENDERING_REFERENCE / OPEN`; native acceptance deferred to Phase 4I.
11. **Safe-Area & Content Clearance Relationships:**
    **RESOLVED:** Page insets (16px) are distinct from platform safe-area insets and persistent control clearance (`SAFE_AREA_CONTRACT: DEFINED`). Bottom controls pad safe bottom. Scrollable content bodies must include bottom padding reserving sticky bar height + safe area. Web formulas (`env(safe-area-inset-bottom)`, `padding-bottom: calc(...)`) are controlled Web geometry references; native safe-area acceptance is `DEFERRED_TO_4I`.
12. **Stale Web Navigation Rules Superseded:**
    **RESOLVED:**
    - Owner bottom navigation in `DESIGN_SYSTEM/EXPERIENCE/NAVIGATION.md` is superseded by canonical mobile architecture (`WEB_BEHAVIORAL_EVIDENCE_ONLY`).
    - `#0059FF` active blue in `DESIGN_SYSTEM/COMPONENTS/navigation.md` is superseded by `EXACT_BLUE: OPEN` (restrained interaction accent role).
    - Raw 48px touch targets superseded by iOS ~44pt / Android ~48dp guidance (`DEFERRED_TO_4I`).
    - Web modal auth in `CustomerAuthModal` is superseded by Auth V2 full-screen route flow (`08 → 09 → 10`).
    - Web modal property detail is superseded by full-page nested flow.

---

## 5. Adversarial Red Team Deliberation

The Visual QA Prosecutor attacked the leading system (Candidate C) across 17 risk dimensions:

| Attack Vector | Red Team Finding / Vulnerability | Evidence / Mitigation | Disposition |
|---|---|---|---|
| **Dual Bottom Chrome Collision** | Potential collision between bottom nav and sticky booking bar | Verified eliminated: bottom nav is conditionally unmounted/hidden on nested screens (`customer_detail_390.png`). | **RESOLVED** |
| **Owner Destination Invisibility** | Without bottom nav, Owners might struggle to find Properties or Wallet | Home hub features high-contrast 3-column domain grid + operational activity cards (`owner_home_390.png`). | **RESOLVED** |
| **Dead-End Nested Screens** | Deep nesting could trap Owners | Every nested view includes a standardized, high-contrast RTL Back button returning directly to parent hub. | **RESOLVED** |
| **Sheet-as-Navigation Abuse** | Complex workflows crammed into bottom sheets | Hard rule enforced: multi-step wizards and entity evaluation are strictly full pages; sheets reserved for contextual tasks. | **RESOLVED** |
| **Modal Stack Abuse** | Cascading sheets over sheets | Layer discipline: exactly one temporary layer at a time; dialogs close sheet or mount cleanly. | **RESOLVED** |
| **Auth Turned into Overlay** | Accidentally reviving web auth modal | Verified full-screen sequential route flow (`customer_auth_v2_390.png`). | **RESOLVED** |
| **Long Arabic Title Collisions** | Arabic ascenders/descenders clipping headers | Tested in `stress_long_arabic_owner_queue_390.png`: multi-line titles wrap cleanly with zero truncation. | **RESOLVED** |
| **True 200% Text Scale Reflow** | Giant labels breaking app bars or bottom nav | Tested in `stress_true_200_customer_detail_390.png`: Cairo Profile B wraps, buttons expand vertically. | **RESOLVED** |
| **Keyboard-Hidden CTA** | On-screen keyboard covering sheet apply action | Tested in `customer_sheet_keyboard_390.png`: sheet footer anchors above keyboard mock. | **RESOLVED** |
| **Wrong RTL Back Semantics** | Chevrons pointing left in RTL | Tested across all app bars: Back arrow points right (➔) conforming to Arabic RTL return direction. | **RESOLVED** |
| **Exact-Blue Overpromotion** | Promoting `#0059FF` or `#276EF1` into Canon | Guarded: exact blue remains explicitly `OPEN`; active tab uses restrained accent role. | **RESOLVED** |
| **Invented SLA Copy** | Owner Home copy communicating false 4-hour deadline | Verified eliminated: action banner uses truthful priority copy without deadline invention (`owner_home_390.png`). | **RESOLVED** |
| **Invented Policy Consequence** | Dialog claiming reputation protection or availability reopening | Verified eliminated: Owner reject dialog articulates truthful non-advancement consequence only (`owner_dialog_390.png`). | **RESOLVED** |
| **Customer Cancel Policy Prematurity** | Showing Customer cancellation dialog before policy approval | Verified eliminated: Customer cancellation dialog removed / reclassified as `DEFERRED_PRODUCT_POLICY`. | **RESOLVED** |
| **Dialog Radius Evidence Void** | Closing 12px dialog radius without visual comparison | Verified eliminated: bounded comparison across 10px, 12px, 16px demonstrates 12px container alignment (`dialog_radius_12_owner_390.png`). | **RESOLVED** |

---

## 6. Verdict & Founder Gate Recommendation

- **Outcome:** **`VERDICT_REACHED`**
- **Consensus Class:** **`STRONG_CONSENSUS`**
- **Confidence:** **`HIGH`**
- **Decision Status:** **`SYSTEM_EVALUATED_CANDIDATE`** (Candidate C — Role-Aware Contextual Navigation & Overlay System).
- **Founder Decision Required:** **`NO`**
  - **Rationale:** Candidate A was eliminated by objective Hard Gates (canonical mobile architecture violation and dual bottom chrome collision). Candidate B was eliminated prior to full visual pilot by Canonical Route Presentation Architecture (`B_VISUAL_IMPLEMENTATION: NOT_REQUIRED_AFTER_HARD_GATE_ELIMINATION`). Candidate C is the sole valid surviving candidate and is completely coherent with upstream decisions (4A–4E), canonical mobile architecture, and product truth. Reversible overlay geometry (16px bottom sheet radius, 12px dialog radius) is closed as system-evaluated provisional candidates without requiring Founder escalation.
