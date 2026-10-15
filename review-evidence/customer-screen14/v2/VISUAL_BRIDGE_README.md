# KONFRM Visual Bridge — Customer Screen 14 V2 (Deposit Payment / دفع العربون)

This document provides the definitive 1-to-1 manifest pairing between uncompressed 1080x2340 physical Samsung Galaxy A56 5G framebuffer PNG captures and RFC 4648 Base64 UTF-8 ASCII text companions.

## Executive Hardware & Execution Metadata
- **DEVICE:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16, API 36)
- **DISPLAY_GEOMETRY:** 1080 x 2340 pixels (Physical Native Framebuffer)
- **TOTAL_CAPTURES:** 21 Distinct Physical Frame Scenarios
- **TOTAL_COMPANIONS:** 21 Single-Line RFC 4648 Base64 ASCII Files
- **BASE64_QUALITY:** JPEG Quality 80 (Decodes 1:1 to original 1080x2340 viewport)
- **BRANCH:** `evidence/customer-screen14-design-review`
- **DIRECTORY:** `review-evidence/customer-screen14/v2/`
- **PRIVACY_RULE:** Strict compliance with Issue #145 (Zero hardware serial numbers).

---

## 1-to-1 Visual Manifest & Cryptographic SHA-256 Hashes

| ID | Scenario Name | PNG File (1080x2340) | PNG Size | PNG SHA-256 | Base64 Companion (.b64.txt) | B64 Size | B64 SHA-256 |
|---|---|---|---|---|---|---|---|
| `01` | 01. جاهز للدفع — الطي الأول (مبلغ العربون 2,700 والزر) | [`01_screen14_a56_ready_top_fold.png`](./01_screen14_a56_ready_top_fold.png) | 179,712 B | `57e5c5015831...` | [`01_visual_bridge.jpg.b64.txt`](./01_visual_bridge.jpg.b64.txt) | 209,148 B | `6bb4258c10ee...` |
| `02` | 02. جاهز للدفع — بعد التمرير (نفس الحجز 2,700 والتفاصيل) | [`02_screen14_a56_ready_scrolled_same_booking.png`](./02_screen14_a56_ready_scrolled_same_booking.png) | 182,526 B | `6f93530a8f5c...` | [`02_visual_bridge.jpg.b64.txt`](./02_visual_bridge.jpg.b64.txt) | 210,540 B | `668002aae088...` |
| `03` | 03. جاهز للدفع — عنوان عقار طويل (حجز مستقل 3,500) | [`03_screen14_a56_ready_long_title_fixture.png`](./03_screen14_a56_ready_long_title_fixture.png) | 183,901 B | `73a311fbefdc...` | [`03_visual_bridge.jpg.b64.txt`](./03_visual_bridge.jpg.b64.txt) | 215,760 B | `b184ed112fc6...` |
| `04` | 04. جارٍ تجهيز الدفع (تعطيل الزر ومنع التكرار) | [`04_screen14_a56_initiating_state.png`](./04_screen14_a56_initiating_state.png) | 172,686 B | `e7efb317a5da...` | [`04_visual_bridge.jpg.b64.txt`](./04_visual_bridge.jpg.b64.txt) | 213,036 B | `af627de0b77c...` |
| `05` | 05. الدفع قيد المعالجة (استعلام الحالة دون تكرار) | [`05_screen14_a56_payment_pending.png`](./05_screen14_a56_payment_pending.png) | 172,896 B | `7c7b1f197be2...` | [`05_visual_bridge.jpg.b64.txt`](./05_visual_bridge.jpg.b64.txt) | 205,524 B | `6e8da49f77ec...` |
| `06` | 06. جارٍ التحقق من الخادم (دون نجاح تلقائي + محاكي الرد) | [`06_screen14_a56_checking_status.png`](./06_screen14_a56_checking_status.png) | 189,351 B | `93911f811409...` | [`06_visual_bridge.jpg.b64.txt`](./06_visual_bridge.jpg.b64.txt) | 228,616 B | `18832b76cb53...` |
| `07` | 07. انقطاع الاتصال (مراجعة آمنة دون خصم مكرر) | [`07_screen14_a56_network_reconciliation_required.png`](./07_screen14_a56_network_reconciliation_required.png) | 172,632 B | `4c818be552e5...` | [`07_visual_bridge.jpg.b64.txt`](./07_visual_bridge.jpg.b64.txt) | 205,332 B | `1fd255443ddd...` |
| `08` | 08. تعذر إتمام الدفع (محاولة جديدة بعد التحقق) | [`08_screen14_a56_failed_attempt.png`](./08_screen14_a56_failed_attempt.png) | 174,682 B | `087b7442dc91...` | [`08_visual_bridge.jpg.b64.txt`](./08_visual_bridge.jpg.b64.txt) | 209,652 B | `2f135f30ba0f...` |
| `09` | 09. انتهاء جلسة الدفع فقط (الحجز ما زال معتمدًا) | [`09_screen14_a56_transaction_expired.png`](./09_screen14_a56_transaction_expired.png) | 176,939 B | `ca7c7e30de7a...` | [`09_visual_bridge.jpg.b64.txt`](./09_visual_bridge.jpg.b64.txt) | 208,140 B | `f2a8a0361a83...` |
| `10` | 10. تغيّر مبلغ العربون (مراجعة المبلغ والموافقة) | [`10_screen14_a56_amount_changed_conflict.png`](./10_screen14_a56_amount_changed_conflict.png) | 181,112 B | `8217e16ec974...` | [`10_visual_bridge.jpg.b64.txt`](./10_visual_bridge.jpg.b64.txt) | 225,892 B | `fd118c931fd8...` |
| `11` | 11. بوابة الدفع غير متاحة (حدود نزيهة دون تزييف) | [`11_screen14_a56_provider_unavailable.png`](./11_screen14_a56_provider_unavailable.png) | 172,977 B | `b868a5b92640...` | [`11_visual_bridge.jpg.b64.txt`](./11_visual_bridge.jpg.b64.txt) | 204,444 B | `b4a515d4ab2d...` |
| `12` | 12. تأكيد الدفع الصريح (محاكاة خادم صادقة بعد رد CONFIRMED) | [`12_screen14_a56_mock_confirmed_success.png`](./12_screen14_a56_mock_confirmed_success.png) | 125,899 B | `0bcb60c6e88d...` | [`12_visual_bridge.jpg.b64.txt`](./12_visual_bridge.jpg.b64.txt) | 155,932 B | `99f5c520c7bb...` |
| `13` | 13. الحجز مؤكد مسبقًا (لا عربون مطلوب) | [`13_screen14_a56_already_confirmed.png`](./13_screen14_a56_already_confirmed.png) | 91,558 B | `73c7fb6a6df6...` | [`13_visual_bridge.jpg.b64.txt`](./13_visual_bridge.jpg.b64.txt) | 110,436 B | `d302f9442add...` |
| `14` | 14. تغيرت حالة الحجز (الدفع غير متاح / ملغى) | [`14_screen14_a56_state_changed_ineligible.png`](./14_screen14_a56_state_changed_ineligible.png) | 93,259 B | `67b34de6bdef...` | [`14_visual_bridge.jpg.b64.txt`](./14_visual_bridge.jpg.b64.txt) | 113,228 B | `7c3676558abd...` |
| `15` | 15. انتهت الجلسة 401 (تفريغ وحجب البيانات من الذاكرة) | [`15_screen14_a56_unauthorized_401.png`](./15_screen14_a56_unauthorized_401.png) | 94,035 B | `448a8fe4080d...` | [`15_visual_bridge.jpg.b64.txt`](./15_visual_bridge.jpg.b64.txt) | 116,136 B | `b7832ca02b72...` |
| `16` | 16. غير مصرح بالوصول 403 (حساب مختلف) | [`16_screen14_a56_forbidden_403.png`](./16_screen14_a56_forbidden_403.png) | 94,766 B | `858da1a82a2d...` | [`16_visual_bridge.jpg.b64.txt`](./16_visual_bridge.jpg.b64.txt) | 113,168 B | `2c528a55be62...` |
| `17` | 17. الحجز غير موجود 404 (معرف غير صالح) | [`17_screen14_a56_notFound_404.png`](./17_screen14_a56_notFound_404.png) | 90,678 B | `05b604e6bc76...` | [`17_visual_bridge.jpg.b64.txt`](./17_visual_bridge.jpg.b64.txt) | 108,420 B | `9526ce1a107d...` |
| `18` | 18. جارٍ التحقق الأولي (هيكل تحميل دون تسريب) | [`18_screen14_a56_initial_loading.png`](./18_screen14_a56_initial_loading.png) | 61,971 B | `73146626f0ee...` | [`18_visual_bridge.jpg.b64.txt`](./18_visual_bridge.jpg.b64.txt) | 82,760 B | `f0d7286d54ae...` |
| `19` | 19. خطأ تحميل أولي (إعادة المحاولة دون تصفير العربون) | [`19_screen14_a56_first_load_error.png`](./19_screen14_a56_first_load_error.png) | 89,988 B | `4cfa6657c453...` | [`19_visual_bridge.jpg.b64.txt`](./19_visual_bridge.jpg.b64.txt) | 110,468 B | `9a8ffc29933c...` |
| `20` | 20. إمكانية الوصول 200% — الطي الأول | [`20_screen14_a56_accessibility_200_top.png`](./20_screen14_a56_accessibility_200_top.png) | 155,389 B | `9bf3dfe78e45...` | [`20_visual_bridge.jpg.b64.txt`](./20_visual_bridge.jpg.b64.txt) | 200,668 B | `51ad33569aa6...` |
| `21` | 21. إمكانية الوصول 200% — بعد التمرير والزر | [`21_screen14_a56_accessibility_200_scrolled.png`](./21_screen14_a56_accessibility_200_scrolled.png) | 200,282 B | `a17aa0596dd3...` | [`21_visual_bridge.jpg.b64.txt`](./21_visual_bridge.jpg.b64.txt) | 239,108 B | `c2e4a4ebdf1d...` |

---

## How Bridge or Reviewers Can Decode Base64 Companions Offline

Every `.b64.txt` companion is a single-line standard RFC 4648 Base64 string that decodes directly to a 1080x2340 JPEG image without requiring binary git tools:

```bash
# Linux / macOS
base64 -d 01_visual_bridge.jpg.b64.txt > 01_decoded.jpg

# Windows PowerShell
[IO.File]::WriteAllBytes("01_decoded.jpg", [Convert]::FromBase64String((Get-Content 01_visual_bridge.jpg.b64.txt -Raw).Trim()))
```

---

## Verification Proof
All 21 Base64 companion text files have been validated for roundtrip decoding to authentic 1080x2340 pixel JPEG images matching the physical captures.
