# `konfrm-flutter` — Performance, Testing Seams & Release Hardening

```yaml
MODULE: performance_and_testing_seams.md
GOVERNING_SPEC: docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. FLUTTER RENDER PERFORMANCE MECHANICS

1. **Measurement-Driven Performance:**
   - Performance optimization must be driven by profiling measurements, not generic guesswork.
   - Modern target devices run at variable refresh rates (60Hz, 90Hz, 120Hz). Evaluate frame rendering budgets using Flutter DevTools performance profiler.
2. **Const Constructor Discipline:**
   - Always apply `const` to immutable widget subtrees to allow the Flutter framework to reuse elements across build passes without reallocation.
3. **Isolating Rebuild Boundaries:**
   - Keep widget trees fine-grained. Use Riverpod's `Consumer` or `ref.watch(provider.select(...))` to limit widget rebuilds to the exact property that changed.
   - Never perform asynchronous calls, JSON parsing, or heavy transformations inside a `build()` method.
4. **Scrolling List Performance:**
   - For long scrollable lists, use `ListView.builder` or `CustomScrollView` with `SliverList`.
   - Provide `itemExtent` or `prototypeItem` where list item heights are fixed to eliminate layout calculation passes during fast scrolling.
   - Wrap complex or animated subtrees in `RepaintBoundary` to prevent full-screen paint invalidation.

---

## 2. IMPLEMENTATION-SIDE TESTING SEAMS

1. **Deterministic Widget Keys:**
   - Provide deterministic `Key` identifiers on critical interactive elements (buttons, inputs, status cards) to allow reliable widget test finder lookups:
     ```dart
     CustomButton(
       key: const Key('booking_confirm_action_button'),
       label: 'تأكيد الحجز',
       onPressed: () => ref.read(controllerProvider.notifier).confirm(),
     )
     ```
2. **Riverpod Test Dependency Seams:**
   - Structure controllers and repositories so that dependency providers can be cleanly overridden in test suites without mutating global singletons:
     ```dart
     final container = ProviderContainer(
       overrides: [
         bookingRepositoryProvider.overrideWithValue(mockRepository),
       ],
     );
     ```
3. **Network Mocking Seam:**
   - Repositories accept an injectable `http.Client` to enable contract and unit tests using `package:http/testing.dart` (`MockClient`).

---

## 3. RELEASE HARDENING & BUILD TOOLING DISTINCTIONS

When preparing release builds or debugging release failures, maintain technical precision regarding build tools:

```
+----------------------------------------------------------------------------------------------------+
| TOOL / MECHANISM     | TECHNICAL REALITY & SCOPE                                                   |
+----------------------+-----------------------------------------------------------------------------+
| ProGuard / R8        | - Operates on Android Java/Kotlin bytecode and native shell Dex.            |
|                      | - Shrinks, optimizes, and obfuscates Android native shell code.             |
|                      | - DOES NOT shrink, parse, or obfuscate Dart code.                           |
|                      | - Requires ProGuard keep rules if native reflection is used by plugins.     |
+----------------------+-----------------------------------------------------------------------------+
| Dart Obfuscation     | - Separate, optional Flutter release-hardening mechanism.                   |
|                      | - Invoked via --obfuscate --split-debug-info=<symbols-dir>.                |
|                      | - If evaluated, requires weighing crash symbolication, support workflows,   |
|                      |   and build operations. It is not an unexamined mandatory control.         |
+----------------------+-----------------------------------------------------------------------------+
| Native .so Libraries | - Compiled C/C++ binaries (libflutter.so, libapp.so, native plugins).       |
|                      | - Must be verified independently for 16 KB memory page size ELF alignment   |
|                      |   (llvm-objdump). Neither R8 nor Dart compiler manages .so alignment.       |
+----------------------------------------------------------------------------------------------------+
```
