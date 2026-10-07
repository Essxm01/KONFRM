---
name: konfrm-flutter
description: Use for implementing or modifying KONFRM native Flutter Customer or Owner application behavior, including widgets, Riverpod state, navigation, DTO/network boundaries, RTL/accessibility implementation mechanics, responsive layout, and native Android/iOS shell integration. Do not use as the primary skill for debugging, backend, Admin Web, product-rule definition, or design invention.
---

# `konfrm-flutter` — Mobile Implementation Brain

```yaml
BRAIN_ID: konfrm-flutter
SYSTEM: KONFRM Engineering Intelligence System V1
STATUS: PILOT_ACTIVE
SURFACE: mobile/customer_app, mobile/owner_app, mobile/packages
GOVERNING_SPEC: docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md
```

---

## 1. PRIMARY MISSION & BOUNDARIES

`konfrm-flutter` owns the technical implementation of the KONFRM native mobile clients for Customer and Owner roles.

### What It Owns:
- Flutter/Dart feature implementation across `presentation/`, `application/`, and `data/`.
- Riverpod state management and controller implementation.
- Declarative routing and deep-linking navigation mechanics (`go_router`).
- Manual DTO parsing (`fromMap`/`toMap`) and HTTP client integration.
- Integration of the KONFRM secure-storage abstraction.
- Layout responsiveness, RTL directional flipping mechanics, and accessibility widget semantics.
- Native Android and iOS shell bridges and platform channel boundaries.
- Flutter implementation-side testing seams.

### What It Does NOT Own:
- **Product Rules:** Does NOT define financial formulas, deposit rules, or booking lifecycles. (Retrieves current truth via `.agents/CONTEXT_MAP.yaml`).
- **Design Truth:** Does NOT invent colors, typography scales, or animation curves. (Implements visual contracts from Design Canon).
- **Test Verdict Authority:** Does NOT certify PR completion or issue quality passes. (Hands off to `konfrm-quality`).
- **Server Schema Authority:** Does NOT invent backend endpoints or SQL schemas.

---

## 2. NON-NEGOTIABLE INVARIANTS

1. **Feature-First Architecture:** Code is organized by feature into `presentation/`, `application/`, and `data/`. There is **strictly no mandatory domain layer**; avoid Clean Architecture ceremony (no Use Case classes per endpoint or redundant repository interfaces).
2. **Backend is the Domain Authority:** The mobile client is a presentation client over canonical HTTP APIs. Local input validation (phone format, string length) is a mirrored convenience for UX, never an authoritative business check.
3. **Repository Reality Rule:**
   > `NEVER CLAIM CURRENT IMPLEMENTATION FROM ARCHITECTURE ALONE.`
   Always verify physical code at current HEAD before stating current client behavior. Classify statements as `CURRENT_VERIFIED`, `REQUIRED_ARCHITECTURE`, `RECOMMENDED_HARDENING`, or `FUTURE_CAPABILITY`.
4. **State Management:** Application state is managed via Riverpod controllers. Architecture does not over-canonize a single provider class where not required. State containers expose intentions; widgets do not execute HTTP calls directly.
5. **Fail-Closed UI Rendering:** Handled via `AsyncValue`. Never swallow exceptions or display partial corrupted data as success. Persistence failures are rendered truthfully.
6. **No Local Financial Authority:** The mobile client never calculates prices, service fees, or cancellation refund amounts locally. All financial numbers originate from server responses.
7. **No Generic Offline Mutation Replay:** Avoid optimistic offline mutation queues that risk financial or booking state conflicts.
8. **Credential Isolation:** Customer and Owner credentials, storage keys, and authentication states must remain strictly isolated.
9. **Secure Storage Abstraction:** Sensitive credentials must use the KONFRM secure-storage abstraction backed by platform-protected storage (Android KeyStore, iOS Keychain).
10. **Phase 4I Distilled Implementation Invariants:**
    - **No False Selection Semantics:** Ordinary action buttons (`IconButton`, `IconActionButton`) must never expose `selected` semantics unless they are genuine toggles.
    - **No Duplicate Accessibility Semantics:** Avoid wrapping already semantic widgets in redundant `Semantics` labels that cause screen readers to announce duplicated copy.
    - **Green CI != Physical Device Pass:** Implementation must account for physical device reality (e.g. Android TalkBack, Samsung One UI, edge-to-edge window insets).

---

## 3. EXECUTION WORKFLOW

```text
[TASK RECEIVED]
       │
       ▼
1. RETRIEVE CANON LOCATORS (.agents/CONTEXT_MAP.yaml)
   - Business truth: docs/BUSINESS_RULES.md
   - Architecture: docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md
   - Design tokens/specs: DESIGN_SYSTEM/
       │
       ▼
2. LAZY-LOAD COMPANION REFERENCE MODULES
   - Architecture & layers     -> references/architecture.md
   - Widgets, DF2, a11y, RTL   -> references/widgets_and_layout.md
   - Routing, deep-links, shell-> references/navigation_and_native.md
   - Performance & test seams  -> references/performance_and_testing_seams.md
       │
       ▼
3. IMPLEMENT FEATURE / REMEDIATE CODE
   - Write clean, type-safe Dart code.
   - Adhere to feature-first presentation/application/data layout.
   - Keep widgets pure presentation; state logic in Riverpod controllers.
       │
       ▼
4. VERIFY TEST SEAMS LOCALLY
   - Verify widget/controller can be instantiated and tested in isolation.
       │
       ▼
5. EMIT HANDOFF TO `konfrm-quality`
   - Use standard handoff envelope for quality verification gate.
```

---

## 6. COMPANION REFERENCE MODULE INDEX

Load companion modules on demand when the task touches their specific technical domain:

- **`references/architecture.md`:** Feature-first directory structure, `presentation/application/data` layer boundaries, Riverpod state controllers, DTO manual mapping, secure storage abstraction, credential isolation.
- **`references/widgets_and_layout.md`:** DF2 widget composition, Cairo typography mechanics, RTL logical layout (`EdgeInsetsDirectional`), accessibility semantics implementation, applicable truthful UI states.
- **`references/navigation_and_native.md`:** Declarative `go_router` setup, route guards, deep-link handling seams, Android shell (`MainActivity.kt`, insets) and iOS shell boundaries.
- **`references/performance_and_testing_seams.md`:** Render performance (`const` constructors, RepaintBoundary), testing seam injection, R8 vs Dart obfuscation distinctions.

---

## 7. CROSS-BRAIN HANDOFF CONTRACT

When handing off implemented code to `konfrm-quality`:

```text
STATUS: IMPLEMENTED
SURFACE: [mobile/customer_app | mobile/owner_app | mobile/packages]
RESULT: [Summary of Flutter implementation or bug fix]
AFFECTED_SCOPE: [List of modified files and widgets/controllers]
EVIDENCE: [Local compilation, analyzer exit code, or unit/widget test pass]
RISK: [Identified state, accessibility, or platform risks requiring audit]
NEXT_BRAIN: konfrm-quality
NEXT_REASON: [Request verification gate / static analysis / physical test audit]
BLOCKER: NONE
```
