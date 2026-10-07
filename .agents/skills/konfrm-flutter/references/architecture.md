# `konfrm-flutter` — Architecture & Layer Guidelines

```yaml
MODULE: architecture.md
GOVERNING_SPEC: docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. FEATURE-FIRST DIRECTORY STRUCTURE

Mobile features are organized by business feature rather than technical type. Every non-trivial feature contains up to three thin layers:

```text
lib/features/<feature_name>/
├── presentation/         # Widgets, screens, view-models, state presenters
│   ├── screens/
│   └── widgets/
├── application/          # State controllers, Riverpod notifiers, user intentions
│   └── <feature>_controller.dart
└── data/                 # Remote API adapters, DTOs, local storage adapters
    ├── dtos/
    └── <feature>_repository.dart
```

### Invariant: No Mandatory Domain Layer
- Do NOT introduce an obligatory `domain/` directory or ceremonial Clean Architecture abstractions (such as single-endpoint Use Case classes or abstract repository interfaces created solely for one implementation).
- The backend API is the domain authority. The client consumes structured HTTP endpoints and parses server responses.
- Application models exist where they provide genuine convenience over raw DTOs; otherwise, models are kept lean and direct.

---

## 2. STATE MANAGEMENT VIA RIVERPOD

1. **State Containers Own Intentions:**
   - Widgets are pure presentation components that display state and trigger intentions on Riverpod controllers.
   - Widgets must NEVER invoke HTTP clients or database operations directly.
2. **Provider Scope & Architecture:**
   - Use Riverpod state containers (such as `NotifierProvider`, `AsyncNotifierProvider`) to model screen and feature state.
   - Architecture does not over-canonize a single provider class where not required; select the provider class that fits the state lifecycle (synchronous vs asynchronous).
3. **Fail-Closed Async State Patterns:**
   - `AsyncValue<T>` is a preferred/available Riverpod pattern where it fits, while preserving truthful states, fail-closed error handling, and avoiding swallowed failures. Do not mandate that every asynchronous feature state must use `AsyncValue<T>` if project architecture specifies an alternate state container.
   - Render all applicable truthful states faithfully:
     ```dart
     state.when(
       data: (data) => ContentWidget(data),
       loading: () => const LoadingIndicator(),
       error: (err, stack) => ErrorDisplay(
         message: parseUserFacingErrorMessage(err),
         onRetry: () => ref.read(controllerProvider.notifier).refresh(),
       ),
     );
     ```
   - Never swallow errors or display partial, corrupted data as a successful state.

---

## 3. DATA TRANSFER OBJECTS (DTOs) & MANUAL SERIALIZATION

1. **Manual Serialization Baseline:**
   - Initially, DTOs implement explicit, manual `fromMap`/`toMap` (or `fromJson`/`toJson`) serialization methods.
   - Avoid uninspected runtime reflection and avoid introducing code generation tooling (`build_runner`, `freezed`) unless explicitly mandated by project architecture.
2. **Strict Fail-Closed Nullability & Contract Guards:**
   - Never use force unwrapping (`!`) on API response fields.
   - **Required Contract Fields:** If a required field is missing, null, or of an unexpected type, fail closed immediately by throwing an explicit contract error (e.g., `FormatException`). NEVER invent plausible business values (such as empty string `''`, `'UNKNOWN'` status, `0.0` price, or `DateTime.now()`) that hide malformed server payloads.
   - **Optional Contract Fields:** Fallback defaults are permitted ONLY when the backend API contract explicitly marks the field optional and fallback semantics are explicitly defined.
   - Example fail-closed manual parser:
     ```dart
     factory BookingDto.fromMap(Map<String, dynamic> map) {
       final id = map['id'];
       if (id is! String || id.isEmpty) {
         throw const FormatException('Missing or invalid required field: id');
       }
       final status = map['status'];
       if (status is! String || status.isEmpty) {
         throw const FormatException('Missing or invalid required field: status');
       }
       final totalPrice = map['total_price'];
       if (totalPrice is! num) {
         throw const FormatException('Missing or invalid required field: total_price');
       }
       final rawCreatedAt = map['created_at'];
       if (rawCreatedAt is! String) {
         throw const FormatException('Missing or invalid required field: created_at');
       }
       final createdAt = DateTime.tryParse(rawCreatedAt);
       if (createdAt == null) {
         throw FormatException('Invalid ISO-8601 date format for created_at: $rawCreatedAt');
       }
       // Optional field with explicit nullable fallback:
       final specialInstructions = map['special_instructions'] as String?;

       return BookingDto(
         id: id,
         status: status,
         totalPrice: totalPrice.toDouble(),
         createdAt: createdAt,
         specialInstructions: specialInstructions,
       );
     }
     ```

---

## 4. SECURE CREDENTIAL STORAGE & ROLE ISOLATION

1. **Secure Storage Abstraction:**
   - Authentication tokens, refresh tokens, and session secrets MUST be stored using the KONFRM secure-storage abstraction backed by platform-protected storage:
     - Android: Android KeyStore (EncryptedSharedPreferences).
     - iOS: iOS Keychain Services.
   - Other personal data handling depends on sensitivity, data minimization, platform/privacy architecture, and actual need; avoid overgeneralized security rules that treat every data field identically.
2. **Credential Isolation Between Roles & Sessions:**
   - Customer and Owner credentials remain strictly isolated across storage namespaces determined by the secure-storage abstraction.
   - Do not describe role switching as a normal same-app lifecycle when Customer and Owner are separate applications.
   - State invalidation and session cleanup (such as logout or credential expiration) must cleanly flush the active in-memory Riverpod container state at the application and session boundary.

---

## 5. CLIENT TRANSACTIONAL BOUNDARIES

1. **No Local Financial Authority:**
   - The mobile client never calculates nightly totals, service fees, taxes, or cancellation refund amounts.
   - All monetary values are server-derived. The client formats numbers for display only using canonical currency rules (`1,600 ج.م`).
2. **No Generic Offline Mutation Replay:**
   - Offline mutation queues that replay bookings or financial transactions when connectivity returns are strictly forbidden.
   - Transactions require live server confirmation. If network connectivity fails during a booking or payment request, fail closed and prompt the user to check connection status.
