# KONFRM Customer Screen 14 V2 Review Evidence Index

## Task Details
- **TASK_ID:** `CUSTOMER_SCREEN14_DEPOSIT_PAYMENT_FOCUSED_V2`
- **TARGET_STATUS:** `SCREEN14_V2_AWAITING_FOUNDER_VISUAL_REVIEW`
- **REVIEW_HARDWARE:** Samsung Galaxy A56 5G (Android 16, API 36)
- **RESOLUTION:** 1080 x 2340 (Physical Framebuffer)
- **BRANCH:** `evidence/customer-screen14-design-review`
- **DIRECTORY:** `review-evidence/customer-screen14/v2/`

---

## Core Documents
- [Comprehensive Technical & Financial Report (`REPORT.md`)](./REPORT.md)
- [Visual Bridge Manifest & Base64 Companions (`VISUAL_BRIDGE_README.md`)](./VISUAL_BRIDGE_README.md)
- [Reproducibility & Test Execution Guide (`review-source/README.md`)](./review-source/README.md)
- [Complete Standalone Flutter Preview Runner (`review-source/screen14_preview_runner_v2.dart`)](./review-source/screen14_preview_runner_v2.dart)
- [Comprehensive Behavioral Unit Test Suite (`review-source/screen14_v2_behavioral_tests.dart`)](./review-source/screen14_v2_behavioral_tests.dart)

---

## All 21 Captured Scenarios

| ID | Scenario | Status / Details | PNG Capture | Base64 Companion |
|---|---|---|---|---|
| `01` | 01. جاهز للدفع — الطي الأول (مبلغ العربون 2,700 والزر) | Physical A56 Framebuffer | [`01_screen14_a56_ready_top_fold.png`](./01_screen14_a56_ready_top_fold.png) | [`01_visual_bridge.jpg.b64.txt`](./01_visual_bridge.jpg.b64.txt) |
| `02` | 02. جاهز للدفع — بعد التمرير (نفس الحجز 2,700 والتفاصيل) | Physical A56 Framebuffer | [`02_screen14_a56_ready_scrolled_same_booking.png`](./02_screen14_a56_ready_scrolled_same_booking.png) | [`02_visual_bridge.jpg.b64.txt`](./02_visual_bridge.jpg.b64.txt) |
| `03` | 03. جاهز للدفع — عنوان عقار طويل (حجز مستقل 3,500) | Physical A56 Framebuffer | [`03_screen14_a56_ready_long_title_fixture.png`](./03_screen14_a56_ready_long_title_fixture.png) | [`03_visual_bridge.jpg.b64.txt`](./03_visual_bridge.jpg.b64.txt) |
| `04` | 04. جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | Physical A56 Framebuffer | [`04_screen14_a56_initiating_state.png`](./04_screen14_a56_initiating_state.png) | [`04_visual_bridge.jpg.b64.txt`](./04_visual_bridge.jpg.b64.txt) |
| `05` | 05. الدفع قيد المعالجة (استعلام الحالة دون تكرار) | Physical A56 Framebuffer | [`05_screen14_a56_payment_pending.png`](./05_screen14_a56_payment_pending.png) | [`05_visual_bridge.jpg.b64.txt`](./05_visual_bridge.jpg.b64.txt) |
| `06` | 06. جارٍ التحقق من الخادم (دون نجاح تلقائي + محاكي الرد) | Physical A56 Framebuffer | [`06_screen14_a56_checking_status.png`](./06_screen14_a56_checking_status.png) | [`06_visual_bridge.jpg.b64.txt`](./06_visual_bridge.jpg.b64.txt) |
| `07` | 07. انقطاع الاتصال (مراجعة آمنة دون خصم مكرر) | Physical A56 Framebuffer | [`07_screen14_a56_network_reconciliation_required.png`](./07_screen14_a56_network_reconciliation_required.png) | [`07_visual_bridge.jpg.b64.txt`](./07_visual_bridge.jpg.b64.txt) |
| `08` | 08. تعذر إتمام الدفع (محاولة جديدة بعد التحقق) | Physical A56 Framebuffer | [`08_screen14_a56_failed_attempt.png`](./08_screen14_a56_failed_attempt.png) | [`08_visual_bridge.jpg.b64.txt`](./08_visual_bridge.jpg.b64.txt) |
| `09` | 09. انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا) | Physical A56 Framebuffer | [`09_screen14_a56_transaction_expired.png`](./09_screen14_a56_transaction_expired.png) | [`09_visual_bridge.jpg.b64.txt`](./09_visual_bridge.jpg.b64.txt) |
| `10` | 10. تغيّر مبلغ العربون (مراجعة المبلغ والموافقة) | Physical A56 Framebuffer | [`10_screen14_a56_amount_changed_conflict.png`](./10_screen14_a56_amount_changed_conflict.png) | [`10_visual_bridge.jpg.b64.txt`](./10_visual_bridge.jpg.b64.txt) |
| `11` | 11. بوابة الدفع غير متاحة (حدود نزيهة دون تزييف) | Physical A56 Framebuffer | [`11_screen14_a56_provider_unavailable.png`](./11_screen14_a56_provider_unavailable.png) | [`11_visual_bridge.jpg.b64.txt`](./11_visual_bridge.jpg.b64.txt) |
| `12` | 12. تأكيد الدفع الصريح (محاكاة خادم صادقة بعد رد CONFIRMED) | Physical A56 Framebuffer | [`12_screen14_a56_mock_confirmed_success.png`](./12_screen14_a56_mock_confirmed_success.png) | [`12_visual_bridge.jpg.b64.txt`](./12_visual_bridge.jpg.b64.txt) |
| `13` | 13. الحجز مؤكد مسبقًا (لا عربون مطلوب) | Physical A56 Framebuffer | [`13_screen14_a56_already_confirmed.png`](./13_screen14_a56_already_confirmed.png) | [`13_visual_bridge.jpg.b64.txt`](./13_visual_bridge.jpg.b64.txt) |
| `14` | 14. تغيرت حالة الحجز (الدفع غير متاح / ملغى) | Physical A56 Framebuffer | [`14_screen14_a56_state_changed_ineligible.png`](./14_screen14_a56_state_changed_ineligible.png) | [`14_visual_bridge.jpg.b64.txt`](./14_visual_bridge.jpg.b64.txt) |
| `15` | 15. انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة) | Physical A56 Framebuffer | [`15_screen14_a56_unauthorized_401.png`](./15_screen14_a56_unauthorized_401.png) | [`15_visual_bridge.jpg.b64.txt`](./15_visual_bridge.jpg.b64.txt) |
| `16` | 16. غير مصرح بالوصول 403 (حساب مختلف) | Physical A56 Framebuffer | [`16_screen14_a56_forbidden_403.png`](./16_screen14_a56_forbidden_403.png) | [`16_visual_bridge.jpg.b64.txt`](./16_visual_bridge.jpg.b64.txt) |
| `17` | 17. الحجز غير موجود 404 (معرف غير صالح) | Physical A56 Framebuffer | [`17_screen14_a56_notFound_404.png`](./17_screen14_a56_notFound_404.png) | [`17_visual_bridge.jpg.b64.txt`](./17_visual_bridge.jpg.b64.txt) |
| `18` | 18. جارٍ التحقق الأولي (هيكل تحميل دون تسريب) | Physical A56 Framebuffer | [`18_screen14_a56_initial_loading.png`](./18_screen14_a56_initial_loading.png) | [`18_visual_bridge.jpg.b64.txt`](./18_visual_bridge.jpg.b64.txt) |
| `19` | 19. خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | Physical A56 Framebuffer | [`19_screen14_a56_first_load_error.png`](./19_screen14_a56_first_load_error.png) | [`19_visual_bridge.jpg.b64.txt`](./19_visual_bridge.jpg.b64.txt) |
| `20` | 20. إمكانية الوصول 200% — الطي الأول | Physical A56 Framebuffer | [`20_screen14_a56_accessibility_200_top.png`](./20_screen14_a56_accessibility_200_top.png) | [`20_visual_bridge.jpg.b64.txt`](./20_visual_bridge.jpg.b64.txt) |
| `21` | 21. إمكانية الوصول 200% — بعد التمرير والزر | Physical A56 Framebuffer | [`21_screen14_a56_accessibility_200_scrolled.png`](./21_screen14_a56_accessibility_200_scrolled.png) | [`21_visual_bridge.jpg.b64.txt`](./21_visual_bridge.jpg.b64.txt) |

---

## Retention Policy
In strict compliance with Issue #155 and Founder directives, all V1 evidence in `../v1/` and all V2 evidence in this directory are permanently retained.
