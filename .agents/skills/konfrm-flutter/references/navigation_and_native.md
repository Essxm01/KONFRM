# `konfrm-flutter` — Navigation, Deep-Links & Native Shell Integration

```yaml
MODULE: navigation_and_native.md
GOVERNING_SPEC: docs/architecture/KONFRM_MOBILE_ARCHITECTURE_BOUNDARIES_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. DECLARATIVE ROUTING VIA GO_ROUTER

1. **Type-Safe Route Definitions:**
   - All mobile routes are defined using `go_router`.
   - Maintain route path constants and strongly-typed parameter extraction:
     ```dart
     GoRoute(
       path: '/property/:id',
       name: 'property-detail',
       builder: (context, state) {
         final propertyId = state.pathParameters['id'] ?? '';
         return PropertyDetailScreen(propertyId: propertyId);
       },
     ),
     ```
2. **Route Guards & Role Redirects:**
   - Centralize authentication and role checks inside the top-level `redirect` callback of `GoRouter`.
   - Protect Owner screens from unauthenticated or Customer sessions, and vice-versa.
3. **Deep-Link Seams:**
   - The navigation architecture supports deep-link URL parsing.
   - **Important:** The concrete URL scheme (e.g. custom URI scheme vs Universal Links / App Links) remains deferred until canonically approved. Route configurations must handle standard relative path structures (`/property/:id`, `/booking/:id`) that can bind to any outer scheme seamlessly.

---

## 2. ANDROID NATIVE SHELL INTEGRATION

1. **Edge-to-Edge & System Window Insets:**
   - On Android 15+ (API 35+), edge-to-edge window layout is enforced by the operating system.
   - Flutter layouts must handle system status and navigation bar insets cleanly:
     - Consume `MediaQuery.of(context).viewPadding` or `SafeArea`.
     - Never allow interactive controls (floating buttons, bottom action bars) to be obscured by the system navigation bar or gesture pill.
2. **Predictive Back Gesture:**
   - Handle Android system back navigation using `PopScope`:
     ```dart
     PopScope(
       canPop: canExitSafely,
       onPopInvokedWithResult: (didPop, result) {
         if (!didPop) {
           showExitConfirmationDialog(context);
         }
       },
       child: ScreenBody(),
     )
     ```
3. **Native Shell Security & Permissions:**
   - `android/app/src/main/AndroidManifest.xml` must adhere to least privilege.
   - Do NOT declare broad storage permissions (`READ_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`) if media selection uses the Android Photo Picker (`MediaStore.ACTION_PICK_IMAGES`), which requires zero runtime storage permissions.

---

## 3. IOS NATIVE SHELL INTEGRATION

1. **Safe Area & Dynamic Island Considerations:**
   - iOS devices require respectful handling of top notch / Dynamic Island and bottom home indicator insets via `SafeArea`.
2. **Native iOS Configuration:**
   - Configured cleanly inside `ios/Runner/AppDelegate.swift` and `Info.plist`.
   - Ensure orientations, status bar styles, and localized permission strings are declared accurately.

---

## 4. PLATFORM CHANNELS & NATIVE BRIDGES

1. **Method Channel Seams:**
   - When communicating with native platform code (e.g., native sensors or device tokens), isolate method channel invocations inside dedicated infrastructure adapters in `data/`:
     ```dart
     class NativeDeviceBridge {
       static const _channel = MethodChannel('com.konfrm.mobile/device');

       Future<String?> getDeviceModel() async {
         try {
           return await _channel.invokeMethod<String>('getDeviceModel');
         } on PlatformException catch (e) {
           // Handle platform error gracefully without crashing
           return null;
         }
       }
     }
     ```
2. **Bounded Native Scope:**
   - Avoid creating sprawling native plugins when standard Flutter platform packages suffice.
   - If a future bounded native Android surface genuinely requires native UI, that requires an explicit architecture decision; Jetpack Compose is not an implementation authority for Flutter code.
