# `konfrm-quality` — Multi-Tier Testing Strategy

```yaml
MODULE: testing_strategy.md
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. TEST TAXONOMY (WITHOUT MANDATORY DOMAIN LAYER)

KONFRM tests are structured according to architectural boundaries rather than redundant Clean Architecture layers:

```text
+----------------------------------------------------------------------------------------------------+
| 1. PURE DART & UTILITY TESTS (Fast, In-Memory)                                                     |
| Scope: Date formatting, currency formatters (ج.م), string validators, mathematical helpers.       |
| Speed: Milliseconds. Zero Flutter framework dependencies.                                          |
+----------------------------------------------------------------------------------------------------+
                                                  │
+-------------------------------------------------▼--------------------------------------------------+
| 2. DATA ADAPTER & DTO CONTRACT TESTS                                                               |
| Scope: fromMap / toMap manual serialization, null-safety boundary fallbacks, HTTP error parsing.  |
| Tooling: Pure Dart tests with MockClient or jsonDecode fixtures.                                   |
+----------------------------------------------------------------------------------------------------+
                                                  │
+-------------------------------------------------▼--------------------------------------------------+
| 3. APPLICATION & RIVERPOD CONTROLLER TESTS                                                         |
| Scope: State transition sequences, intention handling, AsyncValue error states.                    |
| Tooling: ProviderContainer tests with repository overrides. Zero widget rendering required.        |
+----------------------------------------------------------------------------------------------------+
                                                  │
+-------------------------------------------------▼--------------------------------------------------+
| 4. WIDGET & ACCESSIBILITY TESTS                                                                    |
| Scope: UI state rendering (Loading, Empty, Error, Content), tap callbacks, semantics tree labels.  |
| Tooling: testWidgets, ProviderScope overrides, tester.pumpAndSettle(), tester.getSemantics().       |
+----------------------------------------------------------------------------------------------------+
                                                  │
+-------------------------------------------------▼--------------------------------------------------+
| 5. INTEGRATION & PHYSICAL DEVICE TESTS                                                             |
| Scope: Complete user journeys, native shell insets, screen reader verification, platform channels. |
| Tooling: flutter test integration_test, physical Android/iOS hardware execution.                  |
+----------------------------------------------------------------------------------------------------+
```

---

## 2. WIDGET TESTING BEST PRACTICES

1. **Deterministic Dependency Overrides:**
   - Always wrap the tested widget in a `ProviderScope` with explicit overrides for network and storage dependencies:
     ```dart
     await tester.pumpWidget(
       ProviderScope(
         overrides: [
           bookingRepositoryProvider.overrideWithValue(mockRepository),
         ],
         child: const MaterialApp(
           home: BookingConfirmationScreen(),
         ),
       ),
     );
     ```
2. **Pump Discipline:**
   - Use `tester.pumpAndSettle()` for static views where animations have finished.
   - For infinite animations or recurring timers, avoid `pumpAndSettle()` (which will time out); use bounded pumps: `tester.pump(const Duration(milliseconds: 100))`.
3. **Verifying Accessibility Semantics:**
   - Assert that interactive widgets emit correct semantics without false selection states:
     ```dart
     final semantics = tester.getSemantics(find.byKey(const Key('search_clear_button')));
     expect(semantics.isButton, isTrue);
     expect(semantics.isSelected, isFalse); // Ordinary action button must not be selected!
     expect(semantics.label, equals('مسح نص البحث'));
     ```

---

## 3. ON-DEMAND GOLDEN TESTING

1. **Classification:**
   - Golden tests are classified as **`ON_DEMAND_VISUAL_REGRESSION_TOOL`**.
   - They provide value for deterministic, pixel-level snapshot verification of complex custom painters or charts.
2. **Operational Boundaries:**
   - Golden tests are NOT a substitute for physical device visual QA.
   - Golden tests do NOT verify font rendering across different real Android device versions (such as Samsung One UI vs Stock Android font engines).
   - Use golden tests deliberately for high-risk visual components, not as a blanket mandate on every simple screen.
