# KONFRM Customer Screen 15 — Review Source Manifest

This directory contains standalone, frozen copies of the Flutter preview runner and behavioral test suite used to generate the visual evidence for Customer Screen 15 (Favorites / المفضلة).

## Files Included

1. `screen15_preview_runner.dart`
   - Canonical implementation of Screen 15 Favorites native Flutter design.
   - Includes full 14 scenarios (`Screen15Scenario`), domain models (`CustomerFavoritesAuthState`, `CustomerFavoritesLoadState`, `FavoritePropertyItem`), state controller (`Screen15FavoritesController`), custom vector illustrations (`ArchitecturalPropertyThumbnail`), directionally isolated price rendering (`DirectionalPriceText`), floating undo notification (`_buildFloatingUndoToast`), and active 4-destination bottom navigation bar (`_buildCustomerBottomNav`).
   - Zero external mock dependencies or network calls; fully offline-safe.

2. `screen15_source_linked_tests.dart`
   - 13 direct, source-linked widget and unit tests covering:
     - Mathematical and capacity invariants in sample fixtures.
     - Directionally isolated Arabic pricing text.
     - State controller lifecycle (removal, undo, 401 cache purge, stale banner refresh).
     - Full UI tests verifying RTL header, active favorites tab, >= 48dp heart button hit target, 56dp empty state button, guest disclaimers, 401 prompt without data leaks, unavailable item badges, and 200% text scale layout without overflow.

## Execution Commands

### Run Behavioral Test Suite
```bash
flutter test test/screen15_source_linked_tests.dart
```

### Static Analysis
```bash
flutter analyze tool/screen15_preview_runner.dart test/screen15_source_linked_tests.dart
```

### Launch on Connected Physical Device (Samsung Galaxy A56 5G)
```bash
flutter run -d "SM A566B" -t tool/screen15_preview_runner.dart
```
