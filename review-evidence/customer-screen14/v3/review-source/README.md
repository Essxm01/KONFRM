# KONFRM Customer Screen 14 V3 — Preview Runner & Reproducibility Guide
## Focused Visual Restoration & Safe Behavioral Verification

## 1. Environment & Target Hardware
- **TEST_DEVICE:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16, API 36) — Physical Hardware
- **PHYSICAL_SCREEN_GEOMETRY:** 1080 x 2340 pixels, 390dp logical width, 405 DPI
- **TEXT_DIRECTION:** Arabic-First True RTL (`TextDirection.rtl`)
- **TYPOGRAPHY:** Cairo Font Family (`KonfrmTypography.fontFamily`) with Western Arabic numerals (0–9)
- **EXECUTION_MODE:** Offline Isolated Preview Runner (`screen14_preview_runner_v3.dart`)
- **PRIVACY_COMPLIANCE:** Strict adherence to Issue #145 (Zero ADB hardware serial numbers or private device identifiers published).
- **RETENTION_HOLD:** Strict adherence to Issue #155 (All historical V1 and V2 evidence files retained 100% byte-for-byte untouched).

---

## 2. Source Code Manifest
- `screen14_preview_runner_v3.dart`: Complete standalone Flutter preview runner implementing all 22 scenarios, in-memory state controller, detached dev-only audit overlay, responsive 200% text layout, white deposit hero, true black `#000000` primary CTA, and unified editorial hierarchy.
- `screen14_v3_behavioral_tests.dart`: Standalone pure Dart behavioral test suite (12/12 PASS) verifying financial math invariants, single-initiation lock, monotonic epoch invalidation, mock injection routing, 401 session purge, civil Arabic date formatting, and HTTP error mappings.

---

## 3. Key Architectural & Visual Improvements in V3

### A. Customer Presentation Mode (Default)
In V2, the preview runner rendered `_buildIsolatedPreviewBanner()` and `_buildScenarioControlBar()` permanently above the `AppBar`, polluting every screenshot with developer disclaimers and dropdown selectors.
In V3:
- Starts with a pure white native `AppBar` (`دفع العربون`), RTL right-pointing Back navigation arrow (`→`), immediately below the physical Android status bar.
- ZERO top banners, ZERO dropdown selectors, ZERO debug overlays in customer screenshots.
- Root app occupies the native viewport with zero dead space above the `AppBar`.

### B. Detached Dev-Only Audit Overlay (Separation of Concerns)
- The test harness is completely decoupled from the customer UI.
- Toggled explicitly via **Key Q** (or hidden tester gesture).
- Provides scenario switching (Scenarios 01–21) and mock response injection buttons (`CONFIRMED`, `PENDING`, `FAILED`, `TIMEOUT`, `401 Purge`).
- Optical proof of this overlay is captured in Scenario 22 (`22_screen14_a56_qa_audit_dev_tools.png`).

### C. White Deposit Panel & True Black `#000000` Primary CTA
- **Deposit Panel:** Replaced the heavy charcoal `#111827` slab with a pure `#FFFFFF` background, subtle `#E5E7EB` border, and crisp typography (`2,700 ج.م` first fold).
- **Primary CTA:** Dedicated solid true black `Color(0xFF000000)` button with comfortable touch target (56dp height), white Cairo text, and left-pointing RTL progression arrow (`←`).

### D. Anti-"Card Soup" Unified Editorial Hierarchy
- Replaced 7+ disjointed rounded boxes with a clean, calm 5-element sequence:
  1. Calm status line (`وافق المالك على طلبك. يتطلب تأكيد الحجز سداد العربون.`).
  2. Property identity row.
  3. White deposit panel (`2,700 ج.م`).
  4. True black primary CTA (`دفع العربون`).
  5. Unified stay & finance breakdown card with soft-fill Arabic date boxes.

### E. Financial & Date Coherence
- Matches the Founder-approved Screen 13 V2 fixture:
  - Check-in: `الثلاثاء، 20 أكتوبر 2026`
  - Check-out: `الأحد، 25 أكتوبر 2026`
  - 5 nights, 4 guests, 2,700 EGP/night, 13,500 EGP total, 2,700 EGP deposit, 10,800 EGP remainder.

### F. Complete Accessibility Responsiveness (200% Font Scale)
- Dynamically responds to `isA11yScale` (textScaler >= 1.5) by switching horizontal key-value rows to vertical stacks.
- 100% elimination of Flutter render overflow stripes.

---

## 4. How to Reproduce Physical Hardware Execution

### Step 1: Copy Runner to Customer App Tooling
```bash
# In repository root
mkdir -p mobile/apps/customer_app/tool
cp review-evidence/customer-screen14/v3/review-source/screen14_preview_runner_v3.dart mobile/apps/customer_app/tool/screen14_preview_runner_v3.dart
```

### Step 2: Launch on Samsung Galaxy A56 5G
```bash
cd mobile/apps/customer_app
flutter run -d "SM A566B" -t tool/screen14_preview_runner_v3.dart
```

### Step 3: Keyevent Scenario Navigation via ADB
The preview runner listens to keyevents for zero-friction physical capture:

| Scenario ID | Name / Description | Keycode | Key | Customer Mode View |
|---|---|---|---|---|
| `01` | جاهز للدفع — الطي الأول (مبلغ العربون 2,700 والزر) | 8 | `1` | Clean Customer UI |
| `02` | جاهز للدفع — بعد التمرير (نفس الحجز 2,700 والتفاصيل) | 9 | `2` | Clean Customer UI |
| `03` | جاهز للدفع — عنوان عقار طويل (حجز مستقل 3,500) | 10 | `3` | Clean Customer UI |
| `04` | جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | 11 | `4` | Clean Customer UI |
| `05` | الدفع قيد المعالجة (استعلام الحالة دون تكرار) | 12 | `5` | Clean Customer UI |
| `06` | جارٍ التحقق من الخادم (دون نجاح تلقائي) | 13 | `6` | Clean Customer UI (Spinner only) |
| `07` | انقطاع الاتصال (مراجعة آمنة دون خصم مكرر) | 14 | `7` | Clean Customer UI |
| `08` | تعذر إتمام الدفع (محاولة جديدة بعد التحقق) | 15 | `8` | Clean Customer UI |
| `09` | انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا) | 16 | `9` | Clean Customer UI |
| `10` | تغيّر مبلغ العربون (مراجعة المبلغ والموافقة) | 29 | `A` | Clean Customer UI |
| `11` | بوابة الدفع غير متاحة (حدود نزيهة دون تزييف) | 30 | `B` | Clean Customer UI |
| `12` | تأكيد الدفع الصريح (محاكاة خادم بعد رد مؤكد) | 31 | `C` | Clean Customer UI |
| `13` | الحجز مؤكد مسبقًا (لا عربون مطلوب) | 32 | `D` | Clean Customer UI |
| `14` | تغيرت حالة الحجز (الدفع غير متاح / ملغى) | 33 | `E` | Clean Customer UI |
| `15` | انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة) | 34 | `F` | Clean Customer UI |
| `16` | غير مصرح بالوصول 403 (حساب مختلف) | 35 | `G` | Clean Customer UI |
| `17` | الحجز غير موجود 404 (معرف غير صالح) | 36 | `H` | Clean Customer UI |
| `18` | جارٍ التحقق الأولي (هيكل تحميل دون تسريب) | 37 | `I` | Clean Customer UI |
| `19` | خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | 38 | `J` | Clean Customer UI |
| `20` | إمكانية الوصول 200% — الطي الأول | 39 | `K` | Clean Customer UI (No Overflows) |
| `21` | إمكانية الوصول 200% — بعد التمرير والزر | 40 | `L` | Clean Customer UI (No Overflows) |
| `22` | لوحة أدوات المطورين المعزولة (Dev Audit Overlay) | 45 | `Q` | Dev Tools Overlay |

### Dev Mock Response Injections (Keyevents):
- `KeyQ` (Keycode 45): Toggle Dev Overlay on/off
- `KeyM` (Keycode 41): Inject mock authoritative `CONFIRMED`
- `KeyP` (Keycode 44): Inject mock authoritative `STILL PENDING`
- `KeyO` (Keycode 43): Inject mock authoritative `FAILED`
- `KeyT` (Keycode 48): Inject mock authoritative `TIMEOUT`
- `KeyU` (Keycode 49): Trigger 401 Session Purge & Epoch Increment

---

## 5. How to Run Behavioral Unit Tests
```bash
dart run review-evidence/customer-screen14/v3/review-source/screen14_v3_behavioral_tests.dart
```

Expected output:
```text
======================================================================
Running KONFRM Screen 14 V3 Comprehensive Behavioral Test Suite
======================================================================
  ✓ PASS: Fixture integrity: nights, civil date difference, deposit == nightlyPrice, remainder == total - deposit
  ✓ PASS: Civil Arabic date formatting uses Arabic weekdays, months, and Western digits 0-9
  ✓ PASS: Guarded initiation: ready allows initiation; subsequent attempts strictly rejected
  ✓ PASS: Status check invariant: checkStatus strictly enters checkingStatus, NEVER automatic success
  ✓ PASS: Mock response injection: confirmed transitions to confirmed; pending remains pending
  ✓ PASS: Mock response injection: failed transitions to failedAttempt; timeout to networkReconciliationRequired
  ✓ PASS: Monotonic epoch guard: 401 session purge clears in-memory booking and rejects late callbacks
  ✓ PASS: Ineligible state guards: already confirmed, ineligible, and expired reject payment initiation
  ✓ PASS: Amount changed conflict prevents initiation until re-validated
  ✓ PASS: HTTP error resolution maps 401, 403, 404 cleanly without data leakage
  ✓ PASS: Text scaler accessibility invariant: standard is 1.0, a11y scenarios are 2.0
  ✓ PASS: Screen 13 V2 continuity match: dates Oct 20-25 2026, 5 nights, 2,700 EGP nightly/deposit

----------------------------------------------------------------------
Behavioral Tests Result: 12 passed, 0 failed (100.0%)
======================================================================
```
