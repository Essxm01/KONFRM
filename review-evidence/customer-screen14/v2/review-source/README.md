# KONFRM Customer Screen 14 V2 — Preview Runner & Reproducibility Guide

## 1. Environment & Target Hardware
- **TEST_DEVICE:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16, API 36) — Physical Hardware
- **PHYSICAL_SCREEN_GEOMETRY:** 1080 x 2340 pixels, 390dp logical width, 405 DPI
- **TEXT_DIRECTION:** Arabic-First True RTL (`TextDirection.rtl`)
- **TYPOGRAPHY:** Cairo Font Family (`KonfrmTypography.fontFamily`)
- **EXECUTION_MODE:** Offline Isolated Preview Runner (`screen14_preview_runner_v2.dart`)
- **PRIVACY_COMPLIANCE:** Strict adherence to Issue #145 (Zero ADB hardware serial numbers or private device identifiers published).

---

## 2. Source Code Manifest
- `screen14_preview_runner_v2.dart`: Complete standalone Flutter preview runner implementing all 21 scenarios, in-memory state controller, monotonic epoch guard, and truthful financial copy.
- `screen14_v2_behavioral_tests.dart`: Standalone pure Dart behavioral test suite verifying financial math, single-initiation lock, monotonic epoch invalidation, HTTP error state mapping, and status check reconciliation.

---

## 3. How to Reproduce Physical Hardware Execution

### Step 1: Copy Runner to Customer App Tooling
```bash
# In repository root
mkdir -p mobile/apps/customer_app/tool
cp review-evidence/customer-screen14/v2/review-source/screen14_preview_runner_v2.dart mobile/apps/customer_app/tool/screen14_preview_runner_v2.dart
```

### Step 2: Launch on Samsung Galaxy A56 5G
```bash
cd mobile/apps/customer_app
flutter run -d "SM A566B" -t tool/screen14_preview_runner_v2.dart
```

### Step 3: Automated Keyevent Navigation via ADB
The preview runner listens to numerical and alpha keyevents for zero-friction scenario capture:

| Scenario ID | Name / Description | Keycode | Key Label |
|---|---|---|---|
| `01` | جاهز للدفع — الطي الأول (مبلغ العربون 2,700 والزر) | 8 | `1` |
| `02` | جاهز للدفع — بعد التمرير (نفس الحجز 2,700 والتفاصيل) | 9 | `2` |
| `03` | جاهز للدفع — عنوان عقار طويل (حجز مستقل 3,500) | 10 | `3` |
| `04` | جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | 11 | `4` |
| `05` | الدفع قيد المعالجة (استعلام الحالة دون تكرار) | 12 | `5` |
| `06` | جارٍ التحقق من الخادم (دون نجاح تلقائي + محاكي الرد) | 13 | `6` |
| `07` | انقطاع الاتصال (مراجعة آمنة دون خصم مكرر) | 14 | `7` |
| `08` | تعذر إتمام الدفع (محاولة جديدة بعد التحقق) | 15 | `8` |
| `09` | انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا) | 16 | `9` |
| `10` | تغيّر مبلغ العربون (مراجعة المبلغ والموافقة) | 29 | `A` |
| `11` | بوابة الدفع غير متاحة (حدود نزيهة دون تزييف) | 30 | `B` |
| `12` | تأكيد الدفع الصريح (محاكاة خادم صادقة بعد رد CONFIRMED) | 31 | `C` |
| `13` | الحجز مؤكد مسبقًا (لا عربون مطلوب) | 32 | `D` |
| `14` | تغيرت حالة الحجز (الدفع غير متاح / ملغى) | 33 | `E` |
| `15` | انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة) | 34 | `F` |
| `16` | غير مصرح بالوصول 403 (حساب مختلف) | 35 | `G` |
| `17` | الحجز غير موجود 404 (معرف غير صالح) | 36 | `H` |
| `18` | جارٍ التحقق الأولي (هيكل تحميل دون تسريب) | 37 | `I` |
| `19` | خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | 38 | `J` |
| `20` | إمكانية الوصول 200% — الطي الأول | 39 | `K` |
| `21` | إمكانية الوصول 200% — بعد التمرير والزر | 40 | `L` |

Example dispatch:
```bash
adb shell input keyevent 8   # Switch to Scenario 01
adb shell input keyevent 9   # Switch to Scenario 02
adb shell input keyevent 13  # Switch to Scenario 06
```

---

## 4. How to Run Behavioral Unit Tests
```bash
dart run review-evidence/customer-screen14/v2/review-source/screen14_v2_behavioral_tests.dart
```
Expected output:
```text
======================================================================
Running KONFRM Screen 14 Focused V2 Comprehensive Behavioral Tests
======================================================================
  ✓ PASS: Financial integrity: nights * nightlyPrice == totalStay, deposit == nightlyPrice
  ✓ PASS: P0 Correction A: tapCheckStatus transitions to checkingStatus, NEVER to success
  ✓ PASS: P0 Correction A: Explicit authoritative responses route accurately
  ✓ PASS: Single initiation guard: rapid taps result in exactly ONE attempt count
  ✓ PASS: Monotonic epoch guard: 401 clears in-memory booking and discards stale callbacks
  ✓ PASS: Network reconciliation allows only checkStatus, forbids fresh initiate
  ✓ PASS: Amount changed evaluation detects mismatch and freezes initiation
  ✓ PASS: HTTP status resolution maps accurately to fail-closed error states
  ✓ PASS: Terminal & ineligible states have no payable CTA

----------------------------------------------------------------------
Behavioral Tests Result: 9 passed, 0 failed
======================================================================
```
