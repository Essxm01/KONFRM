# KONFRM Phase 4H — Reference Catalog Index

**Document Status:** CANONICAL REFERENCE INDEX — PHASE 4H  
**Branch:** `design/component-contract-catalog-01`  
**Reference Surface:** `DESIGN_SYSTEM/PILOTS/component-contract-catalog-01/index.html`  
**Purpose:** Structural map and navigation index for the Phase 4H visual reference catalog, mapping each visual group back to its governing contract, maturity label, and evidence requirements.

---

## 1. Catalog Architecture

The Phase 4H Reference Catalog (`index.html`) is structured into dedicated role and functional inspection views:

```
Reference Catalog (index.html)
│
├── 1. Overview & Governance Banner (Maturity legend, Master Invariants, DF2 v1.6 links)
├── 2. Customer View (Mobile 390px Viewport)
│   ├── Navigation Shell (4-Tab Bottom Nav, Screen 16 Shell Exception)
│   ├── App Bar Families (TopLevelCustomer, NestedCustomer, TransactionalCustomer)
│   ├── Discovery Primitives (CustomerPropertyCard, SearchField, FilterTrigger)
│   ├── Decision Units (Customer Stay Card, Quote Breakdown, Sticky Action Surface)
│   └── Form Primitives (Phone Auth Field, Verification Code, Inputs)
│
├── 3. Owner View (Mobile 390px Viewport)
│   ├── Action-First Navigation (3-Column Domain Grid: الطلبات, الوحدات, المحفظة; NO Bottom Nav)
│   ├── App Bar Families (TopLevelOwner with KYC Pill, NestedOwner with Queue Badge)
│   ├── Operational Grouping (OpenGroupedContainer with hairline internal dividers)
│   ├── Triage Decision Units (Owner Booking Request Card with Accept/Decline action pair)
│   ├── Operational Forms (Pricing input, check-in policy, Checkbox notification preferences)
│   └── Metric & Wallet Units (Available vs 24h Pending bucket separation, 500 EGP minimum)
│
├── 4. Admin View (Desktop 1440px Viewport)
│   ├── Desktop Header & Sidebar Navigation
│   ├── Operational Data Table & FIFO Review Queue (StatusBadges, Audit Flags)
│   └── Desktop Inspection Modal Panel
│
├── 5. States & Feedback View (Mobile 390px Viewport)
│   ├── Four-Tier State Delivery (StatusBadge, Inline Text, SectionAlert, Toast)
│   ├── View Lifecycle States (Loading Skeleton, True Empty, Error with retry, Offline, Unauthorized)
│   ├── Truth Invariants (Stale with [تحديث] CTA, Booking Conflict with delta acceptance)
│   └── Domain Status Badge Showcase (8 Canonical Domain Families)
│
├── 6. Overlays & Contextual Surfaces
│   ├── BottomSheet (16px provisional top radius, explicit Close X, Filter content)
│   ├── ConfirmationDialog (12px provisional radius, plain Arabic consequence, action pair)
│   └── StickyActionSurface (Bottom-pinned commitment bar with reserved clearance)
│
└── 7. Controlled 200% Text Scaling Stress View (390px Mobile & 1440px Admin)
    ├── Customer Booking Request Review at 200%
    ├── Owner Wallet & Triage Card at 200%
    └── Reflow Proof (Zero horizontal clipping, natural multiline wrapping, CTA preserved)
```

---

## 2. Visual Group to Contract Mapping

Every section of the reference catalog maps to a governed component contract and carries a specific maturity classification:

| Catalog Section | Governing Component Contract | Role Focus | Maturity Classification | Source Phase | Governed Values Observed | Open / Deferred Items |
|---|---|---|---|---|---|---|
| **Buttons & CTAs** | `buttons.md` | Customer / Owner | `SYSTEM-VALIDATED PROVISIONAL` | Phase 4C | Primary 6px radius (`PRIMARY_ONLY`), Stable Black `#000000`, Cairo Profile B `15/700/1.20` | Secondary radius, exact neutral fill, exact destructive red, native touch targets (`4I`). |
| **Field Primitives** | `inputs.md` | Shared | `SYSTEM-VALIDATED PROVISIONAL` | Phase 4D | Outline-Led baseline, 8px mobile field radius, explicit top label | Exact neutral border, exact focus halo, native keyboard (`4I`). |
| **StatusBadges** | `badges.md` | Shared (8 Families) | `CANONICAL DOMAIN ENUMS / PROVISIONAL STYLING` | Phase 4G | 8 canonical domain enums, no warning on normal pending | Exact semantic hex colors. |
| **Feedback Alerts** | `alerts.md` | Shared | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4G | 4-tier state delivery, NO yellow/amber boxes (MR-17), 12px radius | Exact toast duration, exact semantic background colors. |
| **State Presentation** | `states.md` | Shared | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4G | Invariants: `ERROR!=EMPTY`, `FAILED!=FAKE_ZERO`, `PARTIAL!=ERROR`, plain Arabic copy | Exact illustration assets. |
| **Structural Containers** | `cards.md` | Customer & Owner | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4E | 12px container radius, 16px page insets, Role-Aware Hybrid model | Exact divider stroke width, exact border hex. |
| **PropertyCard** | `cards.md` | Customer | `PROVISIONAL MOBILE REFERENCE` | Phase 4E / Phase 5 | 1.4:1 ratio, floating heart, clean unboxed surface, EGP `/ ليلة` | Image caching, hero animation (`4I`). |
| **BookingCard** | `cards.md` | Customer & Owner | `ROLE-SPECIFIC ASSEMBLY PROVISIONAL` | Phase 4E / 4G | Customer stay recognition vs Owner triage priority | Date picker binding. |
| **Bottom Navigation** | `navigation.md` | Customer | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4F | 4 root destinations, Screen 16 exception, no dual bottom chrome | Safe bottom insets, active accent blue (`#276EF1` candidate). |
| **Owner Nav Model** | `navigation.md` | Owner | `ARCHITECTURE MODEL PROVISIONAL` | Phase 4F | Action-First Hub, 3-column domain grid, NO bottom nav | Native stack routing (`4I`). |
| **AppBars (7 Configs)** | `navigation.md` | Shared | `COMPOSITION PATTERN PROVISIONAL` | Phase 4F | RTL Back arrow (➔), Close (X), light surfaces, Cairo titles | Status-bar integration (`4I`). |
| **BottomSheet** | `bottom-sheets.md` | Shared | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4F | 16px top radius, explicit Close X required, contextual only | Native detents, drag gesture physics (`4I`). |
| **ConfirmationDialog**| `modals.md` | Shared | `SYSTEM-EVALUATED PROVISIONAL` | Phase 4F | 12px surface radius, plain Arabic consequence, action pair | Native focus trap, native alertdialog (`4I`). |
| **StickyActionSurface**| `navigation.md` | Shared | `COMPOSITION PATTERN PROVISIONAL` | Phase 4F | Pinned CTA, reserved content clearance, safe bottom respect | Dynamic keyboard resize (`4I`). |
| **Admin Workspace** | `cards.md`, `admin-app/` | Admin | `CURRENT WEB AUTHORITY` | Phase 3 / Phase 4E | Desktop tabular layout, FIFO queue, audit density | Desktop browser reflow. |
| **200% Reflow Proof** | All contracts | Shared | `CONTROLLED WEB REFERENCE` | Phase 4G / 4H | Multiline wrapping, container expansion, zero horizontal clipping | Native Dynamic Type / Accessibility text scaling (`4I`). |

---

## 3. Evidence Capture Plan

The following 6 bounded screenshots are captured from the catalog using Puppeteer / Chrome:

1. `component_catalog_customer_390.png`: Customer mobile shell, Explore feed, PropertyCard, 4-tab Bottom Nav, Sticky Action Surface.
2. `component_catalog_owner_390.png`: Owner mobile hub, 3-column domain grid, OpenGroupedContainer with internal dividers, Triage Booking Request Card, Checkbox preferences.
3. `component_catalog_admin_1440.png`: Admin desktop workspace, StatusBadges, operational queue table, audit modal inspector.
4. `component_catalog_states_390.png`: Loading skeleton, True Empty vs Error comparison, Stale price update notice, Conflict delta card.
5. `component_catalog_overlays_390.png`: BottomSheet (16px radius) and ConfirmationDialog (12px radius with plain Arabic consequence).
6. `component_catalog_200_customer_390.png`: Controlled 200% scaling reflow showing zero clipping and multiline wrapping.
