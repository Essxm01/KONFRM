# KONFRM Customer Screen 14 V3 Corrective Review Evidence Index
## Independent Bridge Review Resolutions & Verified Physical Hardware Evidence

## Task Details
- **TASK_ID:** `CUSTOMER_SCREEN14_V3_FOCUSED_VISUAL_RESTORATION`
- **REVISION:** `V3-CORRECTIVE`
- **TARGET_STATUS:** `SCREEN14_V3_CORRECTIVE_REVIEW_COMPLETE` (`READY_FOR_FOUNDER_FINAL_REVIEW`)
- **REVIEW_HARDWARE:** Samsung Galaxy A56 5G (Android 16, API 36) — Physical Hardware
- **RESOLUTION:** 1080 x 2340 (Physical Framebuffer)
- **BRANCH:** `evidence/customer-screen14-design-review`
- **DIRECTORY:** `review-evidence/customer-screen14/v3-corrective/`
- **PRIVACY_RULE:** Strict adherence to Issue #145 (Zero hardware serial numbers).
- **RETENTION_POLICY:** Strict adherence to Issue #155 (Historical V1, V2, and V3 evidence files retained 100% byte-for-byte untouched).

---

## Core Documents
- [Comprehensive Technical, Design & Safety Report (`REPORT.md`)](./REPORT.md)
- [Visual Bridge Manifest & Base64 Companions (`VISUAL_BRIDGE_README.md`)](./VISUAL_BRIDGE_README.md)
- [Reproducibility & Source-Linked Test Guide (`review-source/README.md`)](./review-source/README.md)
- [Complete Standalone Flutter Preview Runner (`review-source/screen14_preview_runner_v3_corrective.dart`)](./review-source/screen14_preview_runner_v3_corrective.dart)
- [Source-Linked Controller & UI Tests (`review-source/screen14_v3_source_linked_tests.dart`)](./review-source/screen14_v3_source_linked_tests.dart)

---

## All 26 Captured Physical Hardware Scenarios

| ID | Scenario Name & Scope | Status / Details | PNG Capture (1080x2340) | Base64 Companion |
|---|---|---|---|---|
| `01` | 01. جاهز للدفع — الطي الأول (مبلغ العربون 2,700 ج.م والزر الأسود 56dp) | Physical A56 Framebuffer | [`01_screen14_a56_ready_customer_top.png`](./01_screen14_a56_ready_customer_top.png) | [`01_visual_bridge.jpg.b64.txt`](./01_visual_bridge.jpg.b64.txt) |
| `02` | 02. جاهز للدفع — بعد التمرير (تفاصيل الإقامة والمالية الموحدة وتذييل الأمان) | Physical A56 Framebuffer | [`02_screen14_a56_ready_customer_scrolled.png`](./02_screen14_a56_ready_customer_scrolled.png) | [`02_visual_bridge.jpg.b64.txt`](./02_visual_bridge.jpg.b64.txt) |
| `03` | 03. جاهز للدفع — عنوان عقار طويل فاخر (حجز مستقل 3,500 ج.م) | Physical A56 Framebuffer | [`03_screen14_a56_ready_long_title_fixture.png`](./03_screen14_a56_ready_long_title_fixture.png) | [`03_visual_bridge.jpg.b64.txt`](./03_visual_bridge.jpg.b64.txt) |
| `04` | 04. جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | Physical A56 Framebuffer | [`04_screen14_a56_initiating_state.png`](./04_screen14_a56_initiating_state.png) | [`04_visual_bridge.jpg.b64.txt`](./04_visual_bridge.jpg.b64.txt) |
| `05` | 05. الدفع قيد المعالجة (استعلام الحالة دون تكرار الخصم) | Physical A56 Framebuffer | [`05_screen14_a56_payment_pending.png`](./05_screen14_a56_payment_pending.png) | [`05_visual_bridge.jpg.b64.txt`](./05_visual_bridge.jpg.b64.txt) |
| `06` | 06. جارٍ التحقق من الخادم — واجهة العميل النظيفة (مؤشر دون نجاح تلقائي) | Physical A56 Framebuffer | [`06_screen14_a56_checking_status_customer.png`](./06_screen14_a56_checking_status_customer.png) | [`06_visual_bridge.jpg.b64.txt`](./06_visual_bridge.jpg.b64.txt) |
| `07` | 07. انقطاع الاتصال (مراجعة آمنة دون وعود استقطاع بنكي غير مثبتة) | Physical A56 Framebuffer | [`07_screen14_a56_network_reconciliation_required.png`](./07_screen14_a56_network_reconciliation_required.png) | [`07_visual_bridge.jpg.b64.txt`](./07_visual_bridge.jpg.b64.txt) |
| `08` | 08. تعذر إتمام الدفع (محاولة جديدة بعد التحقق دون ادعاءات بنكية) | Physical A56 Framebuffer | [`08_screen14_a56_failed_attempt.png`](./08_screen14_a56_failed_attempt.png) | [`08_visual_bridge.jpg.b64.txt`](./08_visual_bridge.jpg.b64.txt) |
| `09` | 09. انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا دون وعود بقاء غير محققة) | Physical A56 Framebuffer | [`09_screen14_a56_transaction_expired.png`](./09_screen14_a56_transaction_expired.png) | [`09_visual_bridge.jpg.b64.txt`](./09_visual_bridge.jpg.b64.txt) |
| `10` | 10. تغيّر مبلغ العربون (رصد الاختلاف وزر طلب التحقق المعتمد) | Physical A56 Framebuffer | [`10_screen14_a56_amount_changed_conflict.png`](./10_screen14_a56_amount_changed_conflict.png) | [`10_visual_bridge.jpg.b64.txt`](./10_visual_bridge.jpg.b64.txt) |
| `10B` | 10ب. جارٍ التحقق المعتمد من السعر الجديد (تعطيل الدفع ومنع البدء) | Physical A56 Framebuffer | [`10b_screen14_a56_amount_revalidating.png`](./10b_screen14_a56_amount_revalidating.png) | [`10b_visual_bridge.jpg.b64.txt`](./10b_visual_bridge.jpg.b64.txt) |
| `10C` | 10ج. تم اعتماد السعر الجديد (3,000 ج.م) — طلب الموافقة الصريحة للمتابعة | Physical A56 Framebuffer | [`10c_screen14_a56_amount_revalidated_consent.png`](./10c_screen14_a56_amount_revalidated_consent.png) | [`10c_visual_bridge.jpg.b64.txt`](./10c_visual_bridge.jpg.b64.txt) |
| `11` | 11. بوابة الدفع غير متاحة (حدود نزيهة وزر عودة آمن لتفاصيل الحجز) | Physical A56 Framebuffer | [`11_screen14_a56_provider_unavailable.png`](./11_screen14_a56_provider_unavailable.png) | [`11_visual_bridge.jpg.b64.txt`](./11_visual_bridge.jpg.b64.txt) |
| `12` | 12. تأكيد الدفع الصريح (محاكاة خادم صادقة بعد رد CONFIRMED المعتمد) | Physical A56 Framebuffer | [`12_screen14_a56_mock_confirmed_success.png`](./12_screen14_a56_mock_confirmed_success.png) | [`12_visual_bridge.jpg.b64.txt`](./12_visual_bridge.jpg.b64.txt) |
| `13` | 13. الحجز مؤكد مسبقًا (لا عربون مطلوب) | Physical A56 Framebuffer | [`13_screen14_a56_already_confirmed.png`](./13_screen14_a56_already_confirmed.png) | [`13_visual_bridge.jpg.b64.txt`](./13_visual_bridge.jpg.b64.txt) |
| `14` | 14. تغيرت حالة الحجز (الدفع غير متاح / ملغى) | Physical A56 Framebuffer | [`14_screen14_a56_state_changed_ineligible.png`](./14_screen14_a56_state_changed_ineligible.png) | [`14_visual_bridge.jpg.b64.txt`](./14_visual_bridge.jpg.b64.txt) |
| `15` | 15. انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة ومنع التراجع) | Physical A56 Framebuffer | [`15_screen14_a56_unauthorized_401.png`](./15_screen14_a56_unauthorized_401.png) | [`15_visual_bridge.jpg.b64.txt`](./15_visual_bridge.jpg.b64.txt) |
| `16` | 16. غير مصرح بالوصول 403 (حساب مستأجر مختلف) | Physical A56 Framebuffer | [`16_screen14_a56_forbidden_403.png`](./16_screen14_a56_forbidden_403.png) | [`16_visual_bridge.jpg.b64.txt`](./16_visual_bridge.jpg.b64.txt) |
| `17` | 17. الحجز غير موجود 404 (معرف غير صالح) | Physical A56 Framebuffer | [`17_screen14_a56_notFound_404.png`](./17_screen14_a56_notFound_404.png) | [`17_visual_bridge.jpg.b64.txt`](./17_visual_bridge.jpg.b64.txt) |
| `18` | 18. جارٍ التحقق الأولي (هيكل تحميل دون تسريب بيانات) | Physical A56 Framebuffer | [`18_screen14_a56_initial_loading.png`](./18_screen14_a56_initial_loading.png) | [`18_visual_bridge.jpg.b64.txt`](./18_visual_bridge.jpg.b64.txt) |
| `19` | 19. خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | Physical A56 Framebuffer | [`19_screen14_a56_first_load_error.png`](./19_screen14_a56_first_load_error.png) | [`19_visual_bridge.jpg.b64.txt`](./19_visual_bridge.jpg.b64.txt) |
| `20` | 20. إمكانية الوصول 200% — الطي الأول (نفس الحجز والزر الأسود 56dp دون تجاوز) | Physical A56 Framebuffer | [`20_screen14_a56_accessibility_200_top.png`](./20_screen14_a56_accessibility_200_top.png) | [`20_visual_bridge.jpg.b64.txt`](./20_visual_bridge.jpg.b64.txt) |
| `21` | 21. إمكانية الوصول 200% — بعد التمرير عبر سحب لمسي حقيقي (`adb shell input swipe`) | Physical A56 Framebuffer | [`21_screen14_a56_accessibility_200_scrolled.png`](./21_screen14_a56_accessibility_200_scrolled.png) | [`21_visual_bridge.jpg.b64.txt`](./21_visual_bridge.jpg.b64.txt) |
| `21B` | 21ب. إمكانية الوصول 200% — قبل الضغط على الزر (الزر نشط وحالة جاهز) | Physical A56 Framebuffer | [`21b_screen14_a56_accessibility_200_pre_tap_cta.png`](./21b_screen14_a56_accessibility_200_pre_tap_cta.png) | [`21b_visual_bridge.jpg.b64.txt`](./21b_visual_bridge.jpg.b64.txt) |
| `21C` | 21ج. إمكانية الوصول 200% — بعد الضغط اللمسي الفعلي (تسجيل الحدث والانتقال للتهيئة) | Physical A56 Framebuffer | [`21c_screen14_a56_accessibility_200_post_tap_registered.png`](./21c_screen14_a56_accessibility_200_post_tap_registered.png) | [`21c_visual_bridge.jpg.b64.txt`](./21c_visual_bridge.jpg.b64.txt) |
| `22` | 22. لوحة المطورين المعزولة (Dev Audit Overlay مع معالجة التجاوز 0 بكسل) | Physical A56 Framebuffer | [`22_screen14_a56_qa_audit_dev_tools.png`](./22_screen14_a56_qa_audit_dev_tools.png) | [`22_visual_bridge.jpg.b64.txt`](./22_visual_bridge.jpg.b64.txt) |

---

## Retention Policy
In strict compliance with Issue #155 and Founder directives:
- All V1 evidence in `../v1/` is preserved 100% byte-for-byte untouched.
- All V2 evidence in `../v2/` is preserved 100% byte-for-byte untouched.
- All V3 evidence in `../v3/` is preserved 100% byte-for-byte untouched.
- This `v3-corrective/` directory houses the additive, verified resolutions addressing Bridge's review.
