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
  - `discovery/`: Exploration hub and search affordance.
  - `favorites/`: Guest favorites with truthful session state.
  - `bookings/`: Customer bookings with truthful session state and recovery routing.
  - `account/`: Guest profile hub and settings overview.

---

## 2. Governed Features Implemented (Phase 5 / Mission 01)

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
4. **Zero Dead Interactive Controls:**
   - Deferred search and authentication features present truthful non-interactive affordances and alerts rather than enabled buttons wired to empty callbacks.
5. **Zero Fabricated Data (Master Rules MR-09 & MR-14):**
   - No mock listings, fake prices, synthetic booking IDs, or fake user profiles.
6. **Responsive Layout & Text Scaling:**
   - Reflow verified across 100%, 150%, and 200% text scaling and narrow viewports (360dp, 390dp, 430dp).

---

## 3. Deliberately Deferred Features (Non-Goals for Mission 01)

- Public Property Search API integration (deferred to Mission 02).
- Native Authentication (Supabase / Phone OTP login flows).
- Booking creation and payment flows.
- Offline persistence and local storage.
- Production signing, store submission assets, and app icon finalization.

---

## 4. Verification & Testing

Run all commands from `mobile/apps/customer_app`:

```powershell
# Code formatting check
dart format --output=none --set-exit-if-changed .

# Static code analysis
flutter analyze

# Widget test suite (11/11 tests)
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
- **Android Runtime:** Debug APK builds cleanly (`build/app/outputs/flutter-apk/app-debug.apk`). Physical Android validation depends on physical hardware connection.
- **iOS Reality Gate:** `IOS_REALITY_GATE_PENDING` preserved.
