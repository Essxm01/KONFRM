# KONFRM Customer Screen 14 V3 Corrective — Preview Runner & Source-Linked Tests
## Independent Bridge Review Resolution & Reproducibility Guide

## 1. Environment & Target Hardware
- **TEST_DEVICE:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16, API 36) — Physical Hardware
- **PHYSICAL_SCREEN_GEOMETRY:** 1080 x 2340 pixels, 390dp logical width, 405 DPI
- **TEXT_DIRECTION:** Arabic-First True RTL (`TextDirection.rtl`)
- **TYPOGRAPHY:** Cairo Font Family (`KonfrmTypography.fontFamily`) with Western Arabic numerals (0–9)
- **EXECUTION_MODE:** Offline Isolated Preview Runner (`screen14_preview_runner_v3_corrective.dart`)
- **TEST_SUITE:** Direct Source-Linked Test Suite (`screen14_v3_source_linked_tests.dart`)
- **PRIVACY_COMPLIANCE:** Strict adherence to Issue #145 (Zero ADB hardware serial numbers or private device identifiers published).
- **RETENTION_HOLD:** Strict adherence to Issue #155 (All historical V1, V2, and V3 evidence files retained 100% byte-for-byte untouched).

---

## 2. Source Code Manifest

1. **`screen14_preview_runner_v3_corrective.dart`:**
   - Complete standalone Flutter preview runner implementing all 26 scenarios.
   - P0 Amount Changed 3-stage revalidation state machine (`amountChanged` → `revalidatingAmount` → `amountRevalidated` → explicit customer consent → `ready`).
   - Payment initiation strictly returns `false` during revalidation.
   - Detached Dev-Only Audit Overlay with zero overflow pixels (wrapped in `Expanded` with `TextOverflow.ellipsis`).
   - Reconciled 56dp height on all buttons.
   - Truthful copy purged of unverified promises.
   - Secondary navigation documented as demo-only SnackBar feedback.

2. **`screen14_v3_source_linked_tests.dart`:**
   - Real source-linked tests directly importing the runner code (`tool/screen14_preview_runner_v3_corrective.dart`).
   - 14 comprehensive tests (100% PASS) covering fixture integrity, date formatting, P0 amount-changed blocking/revalidation/consent, P0 status-check negative paths, P0 mock response routing with booking/transaction identity, P0 monotonic epoch & 401 memory wipe with stale callback drops, single initiation lock, ineligible states, fresh attempt guards, clean customer mode gate, button height 56dp verification, and truthful copy verification.

---

## 3. How to Execute Tests

```bash
# In mobile/apps/customer_app
flutter test test/screen14_v3_source_linked_tests.dart
```

Expected Output:
```text
00:00 +14: All tests passed!
```

---

## 4. How to Reproduce Physical Hardware Execution

### Step 1: Copy Runner to Customer App Tooling
```bash
cp review-evidence/customer-screen14/v3-corrective/review-source/screen14_preview_runner_v3_corrective.dart mobile/apps/customer_app/tool/screen14_preview_runner_v3_corrective.dart
```

### Step 2: Launch on Samsung Galaxy A56 5G
```bash
cd mobile/apps/customer_app
flutter run -d "SM A566B" -t tool/screen14_preview_runner_v3_corrective.dart
```

### Step 3: Keyevent Scenario Navigation via ADB

| Scenario ID | Name / Description | Keycode | Key | Customer Mode View |
|---|---|---|---|---|
| `01` | جاهز للدفع — الطي الأول (مبلغ العربون 2,700 والزر 56dp) | 8 | `1` | Clean Customer UI |
| `02` | جاهز للدفع — بعد التمرير (تفاصيل الإقامة والمالية الموحدة) | 9 | `2` | Clean Customer UI |
| `03` | جاهز للدفع — عنوان عقار طويل فاخر (حجز مستقل 3,500) | 10 | `3` | Clean Customer UI |
| `04` | جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | 11 | `4` | Clean Customer UI |
| `05` | الدفع قيد المعالجة (استعلام الحالة دون تكرار) | 12 | `5` | Clean Customer UI |
| `06` | جارٍ التحقق من الخادم (دون نجاح تلقائي) | 13 | `6` | Clean Customer UI (Spinner only) |
| `07` | انقطاع الاتصال (مراجعة آمنة دون وعود غير مثبتة) | 14 | `7` | Clean Customer UI |
| `08` | تعذر إتمام الدفع (محاولة جديدة بعد التحقق) | 15 | `8` | Clean Customer UI |
| `09` | انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا) | 16 | `9` | Clean Customer UI |
| `10` | تغيّر مبلغ العربون (رصد الاختلاف وزر طلب التحقق) | 29 | `A` | Clean Customer UI |
| `10B` | جارٍ التحقق المعتمد من السعر الجديد (تعطيل الدفع) | 46 | `R` | Clean Customer UI |
| `10C` | تم اعتماد السعر الجديد — طلب الموافقة الصريحة | 47 | `S` | Clean Customer UI |
| `11` | بوابة الدفع غير متاحة (حدود نزيهة وزر عودة آمن) | 30 | `B` | Clean Customer UI |
| `12` | تأكيد الدفع الصريح (محاكاة خادم بعد رد CONFIRMED) | 31 | `C` | Clean Customer UI |
| `13` | الحجز مؤكد مسبقًا (لا عربون مطلوب) | 32 | `D` | Clean Customer UI |
| `14` | تغيرت حالة الحجز (الدفع غير متاح / ملغى) | 33 | `E` | Clean Customer UI |
| `15` | انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة) | 34 | `F` | Clean Customer UI |
| `16` | غير مصرح بالوصول 403 (حساب مستأجر مختلف) | 35 | `G` | Clean Customer UI |
| `17` | الحجز غير موجود 404 (معرف غير صالح) | 36 | `H` | Clean Customer UI |
| `18` | جارٍ التحقق الأولي (هيكل تحميل دون تسريب) | 37 | `I` | Clean Customer UI |
| `19` | خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | 38 | `J` | Clean Customer UI |
| `20` | إمكانية الوصول 200% — الطي الأول | 39 | `K` | Clean Customer UI |
| `21` | إمكانية الوصول 200% — بعد التمرير عبر سحب لمسي حقيقي | 39 + swipe | `K` + swipe | Clean Customer UI |
| `21B` | إمكانية الوصول 200% — قبل الضغط على الزر | 39 | `K` | Clean Customer UI |
| `21C` | إمكانية الوصول 200% — بعد الضغط اللمسي الفعلي على الزر | 39 + tap | `K` + tap | Clean Customer UI |
| `22` | لوحة المطورين المعزولة (Dev Audit Overlay المنفصلة) | 45 | `Q` | Detached QA Overlay (0px overflow) |
