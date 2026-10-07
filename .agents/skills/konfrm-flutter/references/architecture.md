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
3. **Fail-Closed Async UI Pattern:**
   - Asynchronous feature state is represented via `AsyncValue<T>`.
   - Render all states truthfully:
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
2. **Strict Nullability & Type Guards:**
   - Never use force unwrapping (`!`) on API response fields.
   - Handle missing or malformed fields gracefully with safe fallbacks or honest parse exceptions:
     ```dart
     factory BookingDto.fromMap(Map<String, dynamic> map) {
       return BookingDto(
         id: map['id'] as String? ?? '',
         status: map['status'] as String? ?? 'UNKNOWN',
         totalPrice: (map['total_price'] as num?)?.toDouble() ?? 0.0,
         createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
       );
     }
     ```

---

## 4. SECURE CREDENTIAL STORAGE & ISOLATION

1. **Secure Storage Abstraction:**
   - Never store authentication tokens, refresh tokens, or personal identifiers in unencrypted storage (such as raw `SharedPreferences` or `NSUserDefaults`).
   - Store sensitive session tokens using the KONFRM secure-storage abstraction, which delegates to platform-protected storage:
     - Android: Android KeyStore (EncryptedSharedPreferences).
     - iOS: iOS Keychain Services.
2. **Credential Isolation Between Roles:**
   - Customer and Owner authentication flows must use distinct storage keys and sessions:
     - `konfrm_customer_token`
     - `konfrm_owner_token`
   - Switching roles or sessions must cleanly flush the active in-memory Riverpod container state to prevent state leaking between roles.

---

## 5. CLIENT TRANSACTIONAL BOUNDARIES

1. **No Local Financial Authority:**
   - The mobile client never calculates nightly totals, service fees, taxes, or cancellation refund amounts.
   - All monetary values are server-derived. The client formats numbers for display only using canonical currency rules (`1,600 ج.م`).
2. **No Generic Offline Mutation Replay:**
   - Offline mutation queues that replay bookings or financial transactions when connectivity returns are strictly forbidden.
   - Transactions require live server confirmation. If network connectivity fails during a booking or payment request, fail closed and prompt the user to check connection status.
