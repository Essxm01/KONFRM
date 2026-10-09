# Active Task — PHASE_5_MISSION_01_CUSTOMER_FLUTTER_APP_SHELL

TASK_ID: PHASE_5_MISSION_01_CUSTOMER_FLUTTER_APP_SHELL
TASK_CLASS: NATIVE_CUSTOMER_APPLICATION_FOUNDATION
STATUS: CANDIDATE_IMPLEMENTED / VERIFIED / DRAFT_PR_PENDING
PR: DRAFT (feat/customer-flutter-app-shell)
EXECUTION_STARTED: YES
BASE_MAIN_SHA: cfc7576c73f7d9d00a3e21296a251cda1b8d13b4
BRANCH: feat/customer-flutter-app-shell
SCOPE: Phase 5 / Mission 01 — Native Customer Flutter Application foundation (`mobile/apps/customer_app`). Implements runnable Flutter entry point, Arabic-first RTL, Cairo typography via `konfrmLightTheme()`, reuse of `mobile/packages/konfrm_design_system`, 4-root Customer navigation (`استكشف`, `المفضلة`, `حجوزاتي`, `الحساب`), Android Back handling (`PopScope` returns to tab 0 before exit), SafeArea, responsive text scaling, and unauthenticated guest baseline with truthful empty states.

## Boundaries & Invariants
- Strictly READ-ONLY regarding backend business logic, database migrations, Cloudflare Workers, and production web applications (`customer-app/`, `owner-app/`, `admin-app/`).
- Zero fabricated properties, mock listings, fake booking records, fake confirmation codes, or fake authentication credentials.
- Reuses `mobile/packages/konfrm_design_system` without component duplication or out-of-band token changes.
- Unauthenticated guest session honesty: unauthenticated state clearly stated across Favorites, Bookings, and Account.
- Cross-platform limitation: Android debug APK build verified; physical Android runtime gate reported honestly.

## Verification Summary
- Flutter format: 0 changed (`dart format --output=none --set-exit-if-changed .` PASS)
- Flutter analyze: No issues found! (`flutter analyze` PASS)
- Widget test suite: 8/8 PASS (`test/customer_app_shell_test.dart` PASS across 100%, 150%, 200% text scale)
- Design system regression suite: 20/20 PASS (`mobile/packages/konfrm_design_system` PASS)
- Android debug APK build: `build/app/outputs/flutter-apk/app-debug.apk` built successfully (152 MB).
