# KONFRM Customer Screen 14 V3 Final — Preview Runner & Source-Linked Tests
## Final Targeted Evidence & Safety Repair — Reproducibility & Architecture Disclosure

## 1. Environment & Target Hardware
- **TEST_DEVICE:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16, API 36) — Physical Hardware
- **PHYSICAL_SCREEN_GEOMETRY:** 1080 x 2340 pixels, 390dp logical width, 405 DPI
- **TEXT_DIRECTION:** Arabic-First True RTL (`TextDirection.rtl`)
- **TYPOGRAPHY:** Cairo Font Family (`KonfrmTypography.fontFamily`) with Western Arabic numerals (0–9)
- **EXECUTION_MODE:** Offline Isolated Preview Runner (`screen14_preview_runner_v3_final.dart`)
- **TEST_SUITE:** Direct Source-Linked Test Suite (`screen14_v3_final_source_linked_tests.dart`)
- **PRIVACY_COMPLIANCE:** Strict adherence to Issue #145 (Zero ADB hardware serial numbers or private device identifiers published).
- **RETENTION_HOLD:** Strict adherence to Issue #155 (All historical V1, V2, V3, and V3-Corrective evidence files retained 100% byte-for-byte untouched).

---

## 2. Source Code Architecture & File Disclosures

### 2.1 Two-Copy Disclosure (Honest Architectural Accounting)
In accordance with Bridge review requirements, we explicitly disclose the two runner and test file locations committed in Git:
1. **Active Developer / CI Location:**
   - `mobile/apps/customer_app/tool/screen14_preview_runner_v3_final.dart`
   - `mobile/apps/customer_app/test/screen14_v3_final_source_linked_tests.dart`
   *Purpose:* Allows the active Flutter engineering workflow to run `flutter run` and `flutter test` directly from within the package root without path remapping.
2. **Self-Contained Review Evidence Location:**
   - `review-evidence/customer-screen14/v3-final/review-source/screen14_preview_runner_v3_final.dart`
   - `review-evidence/customer-screen14/v3-final/review-source/screen14_v3_final_source_linked_tests.dart`
   *Purpose:* Provides an immutable, isolated, self-contained snapshot for external reviewers and visual audits without requiring access to the broader Flutter repository tree.

### 2.2 Key Safety Invariants Implemented in `screen14_preview_runner_v3_final.dart`
1. **P0 Mock Payment Authority Identity:**
   - In `Screen14StateController.initiatePayment()`, an active synthetic transaction ID is generated:
     `activeTransactionId = 'TXN-${booking!.id}-$initiationAttempts-${DateTime.now().millisecondsSinceEpoch}';`
   - `handleMockResponse()` strictly requires non-empty, matching `bookingId` AND `transactionId`. Missing, empty, or mismatched identifiers are rejected fail-closed (`return false`), preventing any false confirmation.
2. **P0 Decoupled Amount Revalidation & Runtime Guards:**
   - Customer initiation via `startAmountRevalidation()` transitions to `revalidatingAmount` and generates an `activeRevalidationToken`.
   - The customer stays in the waiting state indefinitely; zero automated timers or hardcoded auto-transitions exist.
   - Validation response can only be injected explicitly via developer tools or testing APIs (`completeAuthoritativeAmountValidation()`).
   - Replaced all Dart `assert` statements with fail-closed runtime guards (`if (...) return false;`) verifying booking identity, token validity, auth epoch, positive amounts, MR-13 deposit equality, total stay multiplication, and remainder subtraction.
   - Explicit customer consent (`consentToRevalidatedAmount()`) is strictly required before returning to `ready`.
3. **P1 Financial Copy Purge:**
   - The unapproved MR-15 statement `يُسدد لاحقاً وفق سياسة الوحدة` has been completely purged.
   - The remainder is rendered strictly numerically: `المتبقي بعد العربون: 10,800 ج.م`.

---

## 3. How to Execute Tests

```bash
# In mobile/apps/customer_app
flutter test test/screen14_v3_final_source_linked_tests.dart
```

Expected Output:
```text
00:00 +18: All tests passed!
```

---

## 4. How to Reproduce Physical Hardware Execution on Samsung Galaxy A56

```bash
cd mobile/apps/customer_app
flutter run -d "SM A566B" -t tool/screen14_preview_runner_v3_final.dart
```

### Scenario Key Mappings via ADB

| Scenario ID | Name / Description | Keycode | Key | Customer Mode View |
|---|---|---|---|---|
| `01` | جاهز للدفع — الطي الأول (مبلغ العربون 2,700 والزر 56dp دون نصوص سياسة) | 8 | `1` | Clean Customer UI |
| `02` | جاهز للدفع — بعد التمرير (تفاصيل الإقامة والمالية الموحدة وتذييل الأمان) | 9 | `2` | Clean Customer UI |
| `03` | جاهز للدفع — عنوان عقار طويل فاخر (حجز مستقل 3,500) | 10 | `3` | Clean Customer UI |
| `04` | جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | 11 | `4` | Clean Customer UI |
| `05` | الدفع قيد المعالجة (استعلام الحالة دون تكرار) | 12 | `5` | Clean Customer UI |
| `06` | جارٍ التحقق من الخادم (مؤشر دوران دون نجاح تلقائي) | 13 | `6` | Clean Customer UI |
| `07` | انقطاع الاتصال (مراجعة آمنة دون وعود استقطاع غير مثبتة) | 14 | `7` | Clean Customer UI |
| `08` | تعذر إتمام الدفع (محاولة جديدة بعد التحقق دون ادعاءات بنكية) | 15 | `8` | Clean Customer UI |
| `09` | انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا دون وعود بقاء) | 16 | `9` | Clean Customer UI |
| `10` | تغيّر مبلغ العربون (رصد الاختلاف وزر طلب التحقق المعتمد) | 29 | `A` | Clean Customer UI |
| `10B` | جارٍ التحقق المعتمد من السعر الجديد (حالة انتظار واقعية دون مؤقت تلقائي) | 46 | `R` | Clean Customer UI |
| `10C` | تم اعتماد السعر الجديد (3,000 ج.م) — طلب الموافقة الصريحة للمتابعة | 47 | `S` | Clean Customer UI |
| `11` | بوابة الدفع غير متاحة (حدود نزيهة وزر عودة آمن) | 30 | `B` | Clean Customer UI |
| `12` | تأكيد الدفع الصريح (محاكاة خادم بعد رد CONFIRMED المعتمد بمطابقة الهوية والمعاملة) | 31 | `C` | Clean Customer UI |
| `13` | الحجز مؤكد مسبقًا (لا عربون مطلوب) | 32 | `D` | Clean Customer UI |
| `14` | تغيرت حالة الحجز (الدفع غير متاح / ملغى) | 33 | `E` | Clean Customer UI |
| `15` | انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة ومنع التراجع) | 34 | `F` | Clean Customer UI |
| `16` | غير مصرح بالوصول 403 (حساب مستأجر مختلف) | 35 | `G` | Clean Customer UI |
| `17` | الحجز غير موجود 404 (معرف غير صالح) | 36 | `H` | Clean Customer UI |
| `18` | جارٍ التحقق الأولي (هيكل تحميل دون تسريب) | 37 | `I` | Clean Customer UI |
| `19` | خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | 38 | `J` | Clean Customer UI |
| `20` | إمكانية الوصول 200% — الطي الأول | 39 | `K` | Clean Customer UI |
| `21` | إمكانية الوصول 200% — بعد التمرير | 40 | `L` | Clean Customer UI |
| `21B` | إمكانية الوصول 200% — قبل الضغط على الزر (الزر نشط وحالة جاهز) | 39 | `K` | Clean Customer UI |
| `21C` | إمكانية الوصول 200% — بعد الضغط اللمسي الفعلي على الزر | 39 + tap | `K` + tap | Clean Customer UI |
| `22` | لوحة المطورين المعزولة (Dev Audit Overlay مع معالجة التجاوز 0 بكسل) | 45 | `Q` | Detached QA Overlay |
