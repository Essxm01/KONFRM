# Phase 4F Navigation & Overlay System Evaluation

**Status:** `SYSTEM_EVALUATED_SYNTHESIS`  
**Phase:** `PHASE_4F_NAVIGATION_OVERLAY_SYSTEM`  
**Pilot Directory:** `DESIGN_SYSTEM/PILOTS/navigation-overlay-pilot-01/`  
**Governing Architecture:** `docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md`, `DESIGN_SYSTEM/MOBILE_DESIGN_FOUNDATION.md` (DF2 v1.4)  

---

## 1. Executive Summary

Phase 4F evaluated and established the navigation, hierarchy, return-path, overlay (bottom sheet / dialog), sticky action, and safe-area geometry across KONFRM mobile applications.

The evaluation rigorously tested three candidate hypotheses:
1. **Candidate A (Persistence-First):** Failed Hard Gates due to dual bottom chrome collision on nested screens and attempting Owner bottom navigation contrary to canonical architecture.
2. **Candidate B (Immersive-Hierarchical):** Failed Hard Gates / Role Grammar by forcing full-screen takeovers for transient filtering tasks.
3. **Candidate C (Role-Aware Contextual):** Unanimously recommended by Design Court v1 (`CASE_ID: DC-4F-001`). Perfectly balances persistent top-level discovery on Customer, action-first operational hub on Owner, contextual overlay grammar, and zero dual chrome collisions.

---

## 2. Key Architectural Decisions & Evidence Verification

### 2.1 Customer Top-Level & Nested Navigation
- **Top-Level Root:** Exactly four persistent destinations (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`). Explore header combines standalone brand mark (`konfrm-symbol-black.svg`) with single account affordance; zero notification bell clutter.
- **Nested Screens:** On Property Detail and deep workflows, top-level bottom navigation is conditionally **HIDDEN**. This completely eliminates the dual bottom chrome defect demonstrated in Candidate A (`candidate_a_customer_detail_390.png` vs `candidate_c_customer_detail_390.png`).
- **Return Path:** Contextual app bar features an explicit RTL Back button pointing right (➔). Returning to Explore preserves active scroll position and search filter parameters.

### 2.2 Owner Mobile Navigation (No Bottom Navigation)
- **Canonical Architecture Compliance:** Mobile Owner application operates as an **Action-First Operational Hub** with dashboard-style nested routing **WITHOUT** Customer-style bottom navigation.
- **Discoverability:** High-priority operational triage (pending booking requests, upcoming check-ins) is directly prominent on Home. High-frequency domains (Bookings, Properties, Wallet) are accessible via a high-contrast 3-column domain grid.
- **Deep Views:** Bookings Queue and Property Operations feature structured stack routing with an RTL Back button returning directly to Home.

### 2.3 Auth V2 Full-Screen Lock
- Tapping protected actions (e.g. Favorite or Book as guest) initiates a sequential full-screen route flow (`08 → 09 → 10`), **NOT** a modal or sheet.
- Continuation intent is preserved; cancelling returns cleanly to the prior unauthenticated screen with draft inputs intact.

### 2.4 Overlays: BottomSheet & Dialog Grammar
- **BottomSheet:** Anchored to bottom, capped at <85% height, dismissible via visible Close (X) or drag handle. Reserved for short contextual tasks (e.g. Search filters).
  - Evaluated Top Radii: 16px is recommended as balanced mobile sheet curvature (`sheet_radius_16_390.png`); 12px is a valid container-aligned alternative; 20px rejected as overly round.
- **Dialog:** Centered modal overlay, 12px radius, reserved for high-stakes consequential decisions (e.g. Owner reject booking, Customer cancel booking). Explicitly articulates consequences in plain Arabic text.

### 2.5 Safe-Area & Content Clearance Discipline
- Bottom navigation, sticky action surfaces, and bottom sheets pad platform safe areas (`env(safe-area-inset-bottom)`).
- Scroll containers reserve matching bottom clearance padding (`padding-bottom: calc(var(--sticky-action-height) + var(--safe-area-bottom) + 16px)`) ensuring zero content terminates obscured behind persistent controls.
- Keyboard adaptation verified in `customer_sheet_keyboard_390.png`.

### 2.6 Admin Boundary Isolation
- Admin desktop workspace (1440px) remains strictly preserved as a table/queue review console without mobile navigation or sheet contamination (`admin_review_queue_1440.png`).

---

## 3. Status Bands & Deferred Variables

- **Decision Status:** `SYSTEM_EVALUATED_CANDIDATE` (Candidate C).
- **Exact Blue:** `OPEN` (Restrained interaction-accent role governed; `#276EF1` is pilot comparator only).
- **Exact Neutrals:** `OPEN` (Palette tokens remain implementation references).
- **Native Touch Target Acceptance:** `DEFERRED_TO_4I` (iOS ~44pt / Android ~48dp guidance preserved; Web px evidence does not establish native acceptance).
- **Founder Decision Required:** `NO` (Sole valid surviving candidate; Hard Gates eliminated competitors; reversible geometry closed via bounded evidence check).
