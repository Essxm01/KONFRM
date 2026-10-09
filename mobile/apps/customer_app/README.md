# KONFRM | GUEST — Native Customer Flutter Application

**Role:** Customer Discovery, Favorites, Bookings, and Account Shell  
**Architecture:** Arabic-first RTL, Cairo Typography, Material 3, Governed Design System Package  
**Package:** `com.konfrm.customer_app`  
**Location:** `mobile/apps/customer_app`

---

## 1. Overview & Architecture

`customer_app` is the native Flutter mobile client foundation for **KONFRM | GUEST**, built to consume the governed Design System package (`mobile/packages/konfrm_design_system`).

### Architectural Layout:
- `lib/main.dart`: Native entry point executing `KonfrmCustomerApp`.
- `lib/app/app.dart`: Application setup with primary locale `Locale('ar')`, RTL text direction, and `konfrmLightTheme()` consuming Cairo typography.
- `lib/app/shell/customer_app_shell.dart`: Stateful root navigation host implementing the 4-root Customer destination model.
- `lib/features/`: Feature modules adhering to clean role and domain boundaries:
  - `discovery/`: Public property search, allowlisted response model, request state controller, and non-interactive listing cards.
  - `favorites/`: Guest favorites with truthful session state.
  - `bookings/`: Customer bookings with truthful session state and recovery routing.
  - `account/`: Guest profile hub and settings overview.

---

## 2. Governed Features Implemented

1. **4 Root Destinations:**
   - Index 0: `استكشف` (Explore)
   - Index 1: `المفضلة` (Favorites)
   - Index 2: `حجوزاتي` (My Bookings)
   - Index 3: `الحساب` (Account)
2. **Android Back-Button Protocol (`PopScope`):**
   - Pressing back from tabs 1, 2, or 3 cleanly navigates back to tab 0 (`استكشف`).
   - Only pressing back on tab 0 permits application exit (`canPop: true`).
3. **Truthful Guest Sessions (`UNAUTHORIZED != EMPTY`):**
   - Favorites and Bookings screens render `StateKind.unauthorized` when no authenticated session is loaded.
   - Never claims zero records or empty lists when an account has not been loaded.
   - Recovery actions on Favorites ("استكشف العقارات") and Bookings ("استكشف الآن") cleanly navigate to Explore.
4. **Public Property Discovery:**
   - Explore calls `GET /api/v1/customer/properties/search` without authentication.
   - Search supports destination, unit type, guest count, and maximum nightly price.
   - The client only models the public property response allowlist and displays EGP nightly prices.
   - Image URLs must be HTTPS; an invalid/non-HTTPS URL fails the response contract. An empty image list or a failed HTTPS image fetch uses the neutral placeholder.
   - Empty, loading, configuration, network, timeout, server, rejected-request, and malformed-response states remain distinct.
   - No fallback listings, detail navigation, booking actions, or persisted favorites are introduced.
5. **Zero Fabricated Data (Master Rules MR-09 & MR-14):**
   - No mock listings, fake prices, synthetic booking IDs, or fake user profiles.
6. **Responsive Layout & Text Scaling:**
   - Regression tests cover 100%, 150%, and 200% text scaling at 360dp, 390dp, and 430dp, including 360dp at 200%.
   - PR #111 remediation verification: customer-app tests passed at the reviewed candidate tree, including the stated scaling and width combinations; this is automated Flutter test evidence, not native device validation.

---

## 3. Deliberately Deferred Features (Non-Goals for Mission 02)

- Property detail route and booking journey.
- Native Authentication (Supabase / Phone OTP login flows).
- Booking creation, payment, and favorites persistence.
- Offline persistence and local storage.
- Production signing, store submission assets, and app icon finalization.

Set the API origin explicitly when launching the app; there is no baked-in production or localhost fallback:

```powershell
flutter run --dart-define=KONFRM_API_BASE_URL=https://your-api-origin
```

---

## 4. Verification & Testing

Run all commands from `mobile/apps/customer_app`:

```powershell
# Code formatting check
dart format --output=none --set-exit-if-changed .

# Static code analysis
flutter analyze

# Widget and public-search contract tests
flutter test

# Android Debug APK compilation
flutter build apk --debug
```

### Shared Package Regression:
```powershell
# From mobile/packages/konfrm_design_system:
flutter test
```

---

## 5. Platform Limitations
- **Android build:** Debug and release APK compilation passed for PR #111 as compile-only checks. The merged debug and release manifests both include `android.permission.INTERNET`. Physical Android runtime validation remains separate and depends on authorized hardware.
- **iOS Reality Gate:** `IOS_REALITY_GATE_PENDING` preserved.
