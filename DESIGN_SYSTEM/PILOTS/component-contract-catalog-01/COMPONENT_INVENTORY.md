# KONFRM Phase 4H — Component Inventory & Classification

**Document Status:** CANONICAL DISCOVERY ARTIFACT — PHASE 4H  
**Branch:** `design/component-contract-catalog-01`  
**Base Checkpoint:** `bb4534fc9edbb3b44ab6431c259f115220e7fbf9`  
**Purpose:** Comprehensive inventory of all active, legacy, and required component families across KONFRM's three roles (Customer, Owner, Admin) and dual surface reality (Current Web vs Future Mobile Flutter Target).

---

## 1. Governance & Classification Criteria

Every component family is audited against the following authoritative dimensions:

1. **COMPONENT_FAMILY & COMPONENT_NAME:** Distinct UI primitive or compound composition pattern.
2. **SOURCE_AUTHORITY:** Canonical source document governing this component.
3. **PHASE_OWNER:** Upstream Phase establishing foundational decisions (Phase 4A through 4G).
4. **ROLE_SCOPE:** `CUSTOMER` | `OWNER` | `ADMIN` | `SHARED`.
5. **PLATFORM_SCOPE:** `WEB` | `FUTURE_MOBILE` | `BOTH`.
6. **STATUS:**
   - `READY_TO_CONTRACT`: Governed by completed Phase 4 decisions; mature enough for a complete design contract.
   - `NEEDS_RECONCILIATION`: Exists across multiple documents with minor terminology, boundary, or legacy duplication requiring unification.
   - `LEGACY_WEB_ONLY`: Valid for existing React SPAs only; prohibited or not applicable for future mobile.
   - `DEFERRED_TO_4I`: Runtime gesture, touch target, haptic, text-scale, or platform-specific acceptance deferred to native Flutter phase.
   - `DEFERRED_TO_LATER_PRODUCT_PHASE`: Product business policy unresolved (e.g. customer cancellation, chat eligibility).
   - `NOT_A_COMPONENT`: Conceptual architectural pattern, composition rule, or state grammar rather than an individual widget.
7. **PRODUCT_TRUTH_DEPENDENCIES:** Server-authoritative entities or enums required.
8. **DESIGN_DEPENDENCIES:** Tokens, radii, spacing, typography, or overlay models required.
9. **NATIVE_VALIDATION_REQUIRED:** Specific native capabilities requiring Phase 4I runtime verification.

---

## 2. Component Inventory Master Table

| # | Component Family | Component Name | Source Authority | Phase Owner | Role Scope | Platform Scope | Status | Product Truth Dependencies | Design Dependencies | Native Validation Required |
|---|---|---|---|---|---|---|---|---|---|---|
| 01 | **Button** | `Button` (Primary, Secondary, Ghost, Destructive) | `DESIGN_SYSTEM/COMPONENTS/buttons.md`, DF2 §12 | Phase 4C | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Valid server-side lifecycle transitions only (`UX-ACTION-01`) | Primary 6px radius (`PRIMARY_ONLY`), Stable Black `#000000`, Cairo Profile B `15/700/1.20` | iOS 44pt / Android 48dp touch targets, haptic feedback, pressed state |
| 02 | **Button** | `IconButton` | `buttons.md`, DF2 §12 | Phase 4C | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Valid contextual action | Cairo Profile B, 44pt/48dp touch bounds, Lucide icon family | Touch bounds, screen-reader accessible name |
| 03 | **Field Primitives** | `InputField`, `PhoneField`, `NumericField`, `SearchField`, `Textarea` | `DESIGN_SYSTEM/COMPONENTS/inputs.md`, DF2 §17 | Phase 4D | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Field-specific validation errors, formatted values | Outline-Led field baseline, 8px mobile field radius, explicit top label, Profile B | Virtual keyboard types, focus halo rendering, RTL digit typing |
| 04 | **Field Primitives** | `SelectTrigger` | `inputs.md`, `bottom-sheets.md` | Phase 4D / 4F | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Picklist options from server/domain truth | 8px field radius, chevron indicator, Profile B | BottomSheet presentation binding |
| 05 | **Form Composition** | `FormGroup`, `FormSection`, `FormSubmissionBar` | `DESIGN_SYSTEM/COMPONENTS/forms.md` | Phase 4D / 4E | `SHARED` | `BOTH` | `NEEDS_RECONCILIATION` | Form-level validation, submission in-flight mutex | Phase 4E relational spacing (`4/8/12/16/24/32`), `controlGap`, `sectionGap` | Keyboard avoidance, duplicate submission debounce |
| 06 | **Selection Controls** | `Checkbox` | `inputs.md`, DF2 §17 | Phase 4D | `OWNER` (Primary) | `BOTH` | `READY_TO_CONTRACT` | Owner notification preferences / settings | Monochrome check indicator, 44pt/48dp touch target | Native accessibility state (`checked`/`unchecked`) |
| 07 | **Selection Controls** | `Toggle` / `Switch` | `inputs.md`, DF2 §17 | Phase 4D | `SHARED` | `FUTURE_MOBILE` | `DEFERRED_TO_LATER_PRODUCT_PHASE` | None (no current product evidence) | Unresolved token mapping | Native switch gesture & state |
| 08 | **Status Presentation** | `StatusBadge` | `DESIGN_SYSTEM/COMPONENTS/badges.md` | Phase 4G | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | 8 canonical domain families (`properties`, `bookings`, `payments`, `payouts`, `wallets`, `owners`, `owner_docs`) | Semantic token categories (`neutral_process`, `informational_process`, `success`, `danger`, `neutral_muted`, `neutral_attention`) | Contrast verification under dynamic font scaling |
| 09 | **Feedback** | `SectionAlert` / `InlineBanner` | `DESIGN_SYSTEM/COMPONENTS/alerts.md`, DF2 §13 | Phase 4G | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Persistent recovery/error state | Layer 3 Recover/Block; NO yellow/amber boxes (MR-17); 12px container radius | Accessible announcement, RTL icon/action layout |
| 10 | **Feedback** | `Toast` | `alerts.md`, DF2 §13 | Phase 4G | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Completed low-risk transaction confirmation | Layer 4 Transient Confirm; transient display; exact duration OPEN | Native timer lifecycle, accessibility alert event |
| 11 | **State Presentation** | `StateView` (`ScreenState`, `SectionState`, `InlineState`) | `DESIGN_SYSTEM/COMPONENTS/states.md`, `SCREEN_STATES.md` | Phase 4G | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | View lifecycle (`LOADING`, `EMPTY`, `ERROR`, `OFFLINE`, `UNAUTHORIZED`, `PARTIAL`, `STALE`, `CONFLICT`) | Role-Aware Layered State System (Candidate C); plain Arabic copy; retry CTA | Reflow under 200% text scale, offline event listener |
| 12 | **Loading Primitives** | `SkeletonLoader`, `ProgressSpinner` | `states.md` | Phase 4G | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | In-flight read operations | Predictable layout wireframe; flat neutral background | Smooth shimmer animation, reduced-motion bypass |
| 13 | **Structural Containers** | `StructuralContainer` (`Card`) | `DESIGN_SYSTEM/COMPONENTS/cards.md`, DF2 §11 | Phase 4E | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Coherent independent decision unit | 12px structural radius, flat elevation default, subtle neutral border | Clean corner anti-aliasing on high-DPI screens |
| 14 | **Structural Containers** | `OpenGroupedContainer` | `cards.md`, DF2 §11 | Phase 4E | `OWNER` | `FUTURE_MOBILE` | `READY_TO_CONTRACT` | Operational list / homogeneous collection | Single 12px outer container, subtle internal hairline dividers | Divider rendering without sub-pixel snapping artifacts |
| 15 | **List Controls** | `ListRow` / `SettingsRow` | `cards.md` | Phase 4E | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Item metadata, navigation link, or preference | Predictable height, leading/trailing slots, subtle divider | RTL chevron direction (pointing left [←]), touch bounds |
| 16 | **Editorial Discovery** | `CustomerPropertyCard` | `cards.md`, `CUSTOMER_PHASE5_MASTER_UX.md` | Phase 4E / Phase 5 | `CUSTOMER` | `BOTH` | `READY_TO_CONTRACT` | Canonical property read (`id`, `title`, `location`, `price`, `images`) | 1.4:1 media ratio, floating heart favorite action, clean unboxed surface | Image caching/aspect fit, touch feedback |
| 17 | **Decision Units** | `BookingCard` (Customer & Owner variants) | `cards.md`, `CUSTOMER_PHASE5_MASTER_UX.md`, `OWNER_EXPERIENCE.md` | Phase 4E / 4G | `SHARED` (Role-Specific) | `BOTH` | `READY_TO_CONTRACT` | Canonical booking status, dates, financial summary | Role-Aware: Customer = stay recognition + next step; Owner = request priority + decision truth | Dynamic text reflow without date/status truncation |
| 18 | **Summary & KPI** | `MetricCard` / `DomainSummaryUnit` | `cards.md`, `OWNER_EXPERIENCE.md` | Phase 4E / 4F | `OWNER` / `ADMIN` | `BOTH` | `READY_TO_CONTRACT` | Owner Home domain grid (`الطلبات`, `الوحدات`, `المحفظة`); Admin queue counts | Compact label + prominent figure + status context; NO dark KPI slabs | Tabular numerals, RTL numeral formatting |
| 19 | **Navigation Shell** | `BottomNavigation` (Customer) | `DESIGN_SYSTEM/COMPONENTS/navigation.md`, DF2 §14 | Phase 4F | `CUSTOMER` | `FUTURE_MOBILE` | `READY_TO_CONTRACT` | 4 root destinations (Explore, Favorites, Bookings, Account) + Screen 16 exception | 4 tabs, active restrained blue accent, inactive slate, NO dual bottom chrome | Safe-area insets, root state persistence |
| 20 | **Navigation Shell** | `OwnerNavigationModel` (Action-First Hub) | `navigation.md`, DF2 §14 | Phase 4F | `OWNER` | `FUTURE_MOBILE` | `NOT_A_COMPONENT` (Architecture Model) | Action-first nested routing; Customer-style bottom nav PROHIBITED | 3-column domain grid on Home, nested stack with Back (➔) | Native navigation stack transitions |
| 21 | **App Bar Family** | `AppBar` (`TopLevelCustomer`, `NestedCustomer`, `TransactionalCustomer`, `AuthFullScreen`, `TopLevelOwner`, `NestedOwner`, `TemporaryLayerHeader`) | `navigation.md`, DF2 §14 | Phase 4F | `SHARED` (Role Families) | `BOTH` | `READY_TO_CONTRACT` | Active route identity, navigation hierarchy return | Light surface, Cairo title, RTL Back arrow (➔), Close (X) | Status-bar integration, safe-area top inset |
| 22 | **Overlays** | `BottomSheet` | `DESIGN_SYSTEM/COMPONENTS/bottom-sheets.md`, DF2 §14 | Phase 4F | `CUSTOMER` / `OWNER` | `FUTURE_MOBILE` | `READY_TO_CONTRACT` | Contextual task, filters, pickers (NOT full-screen navigation) | 16px provisional top radius, explicit close required, dimmed scrim | Native dragging physics, detent snap, keyboard avoidance |
| 23 | **Overlays** | `ConfirmationDialog` | `DESIGN_SYSTEM/COMPONENTS/modals.md`, DF2 §14 | Phase 4F | `SHARED` | `BOTH` | `READY_TO_CONTRACT` | Irreversible consequential decision (Owner reject, destructive actions) | 12px provisional surface radius, truthful plain Arabic copy, action pair | Native modal alert presentation, focus containment |
| 24 | **Action Surfaces** | `StickyActionSurface` | `navigation.md`, DF2 §14 | Phase 4F | `CUSTOMER` / `OWNER` | `BOTH` | `READY_TO_CONTRACT` | Booking Request Review (Screen 07), Deposit Payment, Property Detail | Pinned bottom surface, reserved content clearance, safe bottom padding | Keyboard dismiss clearance, viewport resize |

---

## 3. Classification Summary Statistics

- **Total Component Families Discovered:** 24
- **Ready to Contract:** 20
- **Needs Reconciliation (Forms vs Inputs):** 1 (`FormGroup` / `FormSection`)
- **Deferred to Later Product Phase:** 1 (`Toggle` / `Switch`)
- **Not a Component (Architecture Model):** 1 (`OwnerNavigationModel`)
- **Legacy Web Only Elements:** 1 (Legacy Owner Web Bottom Nav - preserved as `WEB_BEHAVIORAL_EVIDENCE_ONLY`)
- **Deferred to Phase 4I:** Native runtime acceptance across all 20 component contracts.
