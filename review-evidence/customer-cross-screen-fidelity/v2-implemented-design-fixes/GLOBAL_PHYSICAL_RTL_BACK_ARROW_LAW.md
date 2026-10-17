# KONFRM Global Physical RTL Back-Arrow Law (القانون الكنسي لسهم الرجوع في واجهات RTL)

**Authority:** KONFRM Design System Canon & Founder Directives  
**Governing Issues:** [Issue #192](https://github.com/Essxm01/KONFRM/issues/192), [Issue #191](https://github.com/Essxm01/KONFRM/issues/191#issuecomment-6227072272), [Issue #175](https://github.com/Essxm01/KONFRM/issues/175), [Issue #166](https://github.com/Essxm01/KONFRM/issues/166)  
**Applicability:** Customer Application, Owner Application, Admin Web, and all shared design components.

---

## 1. The Core Principle: Physical Trajectory in RTL

In a Right-to-Left (RTL) reading and interaction environment (Arabic-first), screen navigation flows from **Right to Left**:
- New screens push into the viewport from the left, or emerge forward.
- The entry edge (origin of the screen hierarchy) is on the **physical RIGHT**.
- Therefore, the act of "returning" or "going back" to the parent screen requires moving backwards towards the right edge.

> [!IMPORTANT]
> **The Universal Invariant:**
> In all Arabic RTL nested screens across KONFRM, the Back button MUST:
> 1. Be anchored on the **physical RIGHT edge** of the app bar (leading position in RTL).
> 2. Have an arrowhead that visibly points **RIGHT `[➔]`** towards the physical bezel.

An arrowhead pointing LEFT `[←]` on the right edge points *inward* toward the screen content, which visually indicates "forward / advance" rather than "backward / retreat". This contradicts natural spatial intuition and creates user disorientation.

---

## 2. Technical Analysis: Flutter's Auto-Mirroring Defect

### The Root Cause
In Flutter, standard Material navigational icons (`Icons.arrow_back`, `Icons.arrow_forward`, `Icons.arrow_back_rounded`, `Icons.arrow_forward_rounded`) are constructed with:
```dart
const IconData(..., matchTextDirection: true)
```

When an icon with `matchTextDirection: true` is placed inside a widget tree governed by `Directionality(textDirection: TextDirection.rtl)`:
1. If the developer writes `Icon(Icons.arrow_back_rounded)`:
   - In LTR, this icon points Left `[←]`.
   - In RTL, Flutter's engine automatically mirrors the icon along its vertical axis, causing it to point **RIGHT `[➔]`**.
2. If the developer instinctively writes `Icon(Icons.arrow_forward_rounded)` (assuming "forward" means right):
   - In LTR, this icon points Right `[➔]`.
   - In RTL, Flutter's engine automatically mirrors it, causing it to point **LEFT `[←]`**!
3. If the developer uses platform-specific or non-mirrored icons (e.g. `Icons.arrow_back_ios`), Flutter does NOT mirror them, leaving them pointing LEFT `[←]` regardless of directionality.

Because of this subtle and unintuitive framework behavior, screens developed across different phases accidentally used `Icons.arrow_forward_rounded` or non-mirrored glyphs, resulting in an arrowhead pointing LEFT `[←]` on hardware screens.

---

## 3. The Authoritative Canonical Implementation

To eliminate any ambiguity and guarantee absolute deterministic orientation regardless of parent widget trees, OS locale overrides, or framework version updates, KONFRM adopts the **Forced LTR Directionality Enclosure**:

```dart
/// The Canonical KONFRM Physical RTL Back Button
class KonfrmPhysicalBackArrow extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  const KonfrmPhysicalBackArrow({
    super.key,
    this.onPressed,
    this.color = const Color(0xFF000000), // Pure Black #000000 per Issue #175
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'الرجوع',
      button: true,
      child: Directionality(
        // Force LTR on this specific icon glyph to guarantee it physically points RIGHT [➔]
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: color,
              size: size,
            ),
            splashRadius: 24,
            tooltip: 'الرجوع',
            onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}
```

### Why `Icons.arrow_forward_rounded` Wrapped in `TextDirection.ltr`?
1. Under `TextDirection.ltr`, Flutter renders `Icons.arrow_forward_rounded` in its native un-mirrored orientation: pointing **RIGHT `[➔]`**.
2. Because it is explicitly isolated in an LTR block, the surrounding RTL app bar directionality cannot invert it.
3. The rounded terminals (`_rounded`) match KONFRM's soft, refined architectural aesthetic.
4. Wrapping it in an explicit `SizedBox(width: 48, height: 48)` guarantees compliance with WCAG 2.1 AA and Google Play touch target guidelines (≥ 48×48dp).
5. The `Semantics` wrapper ensures that screen readers announce «الرجوع» rather than reading the raw icon name.

---

## 4. Platform-Wide Application Audit

| Application Category | Screen Scope | Back Arrow Requirement | Icon Orientation Rule |
|---|---|---|---|
| **Top-Level Tabs** | Screens 01, 03, 12, 15, 17 | **FORBIDDEN** | Must never show a Back arrow. User switches via bottom navigation bar. |
| **Modal Sheets** | Screen 02 (OTP / Login) | Dismiss `[✕]` | Close `[✕]` icon placed on physical LEFT or swipe-down indicator. |
| **Nested Customer Screens** | Screens 04, 05, 06, 07, 08, 09, 10, 13, 14, 16, 18, 19, 20, 21, 22 | **MANDATORY** | Placed on physical **RIGHT**, pointing **RIGHT `[➔]`**. |
| **Terminal Hubs** | Screen 11 (Success Hub) | Primary CTA | Primary bottom CTA (e.g. «الانتقال إلى حجوزاتي») returns to navigation root. |

> [!NOTE]
> **Scope of the Law:**
> This law strictly governs the **navigation Back button orientation and placement**. It does NOT dictate a universal single-line header compression across unrelated screen archetypes. Header layouts must naturally serve each screen's specific content model (e.g. search input on Screen 04, hero media overlay on Screen 06, multi-step progress indicators on Screens 08–10, and card breakdowns on Screens 07 & 14).

---

## 5. Migration Strategy for Screens 03–19

During the approved execution phase for the global customer polish:
1. Export `KonfrmPhysicalBackArrow` into `packages/konfrm_design_system/lib/src/components/navigation/`.
2. Systematically replace ad-hoc `IconButton(icon: Icon(Icons.arrow_back...))` across Screens 04 through 19 with the unified widget.
3. Re-run automated tests with the exact widget inspector assertion:
   ```dart
   expect(find.byType(KonfrmPhysicalBackArrow), findsOneWidget);
   ```
4. Verify on genuine Samsung Galaxy A56 5G hardware that the arrowhead visibly points RIGHT `[➔]`.
