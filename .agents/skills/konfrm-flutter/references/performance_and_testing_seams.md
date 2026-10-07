# `konfrm-flutter` — Performance, Testing Seams & Release Hardening

```yaml
MODULE: performance_and_testing_seams.md
GOVERNING_SPEC: docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. MEASUREMENT-DRIVEN RENDER PERFORMANCE

1. **Measurement-First Optimization Cycle:**
   - Follow the strict engineering cycle:
     `MEASURE → IDENTIFY BOTTLENECK → APPLY RELEVANT OPTIMIZATION → RE-MEASURE`.
   - Never apply premature or speculative optimizations based on generic advice. Modern target devices run at variable refresh rates (60Hz, 90Hz, 120Hz); evaluate frame rendering metrics and timeline traces using Flutter DevTools profiler on release/profile modes.
2. **Targeted Performance Tools:**
   - **`const` Constructors:** Apply `const` where widget subtrees are semantically immutable to assist Flutter's element reuse.
   - **Provider `.select`:** Use `ref.watch(provider.select(...))` when profiling reveals that a widget is rebuilding unnecessarily for unobserved state changes.
   - **`RepaintBoundary`:** Introduce `RepaintBoundary` only around complex, frequently animating, or heavy custom painter subtrees where profiling proves paint invalidation is leaking into parent layers. Do not sprinkle `RepaintBoundary` blindly across static layouts.
   - **Scroll Optimizations:** Use `ListView.builder` / `SliverList` for virtualized item rendering. Apply `itemExtent` or `prototypeItem` only when item dimensions are strictly uniform and profiling indicates layout measurement overhead during fast fling scrolling.
   - **Build Method Hygiene:** Never perform asynchronous network calls, JSON decoding, or heavy algorithmic sorting inside a `build()` method.

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
