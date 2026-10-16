# KONFRM Customer Screen 19 V1 — Truth & Clarity Correction Evidence Manifest
**Screen:** Customer Screen 19 — Settings («الإعدادات») [V1 Bounded Truth & UX Correction]  
**Status:** `SCREEN19_V1_TRUTH_CLARITY_CORRECTION__AWAITING_BRIDGE_REVIEW_AND_FOUNDER_DECISION`  
**Target Device:** Samsung Galaxy A56 5G (`SM_A566B`)  
**Device Identifier:** `[REDACTED_A56_ID]` (Compliant with Issue #145)  
**Resolution:** 1080 x 2340 px (Physical Hardware)  
**OS Version:** Android 16 (API 36)  
**Typography:** Cairo Arabic Font Family  
**Direction:** RTL (Right-to-Left Arabic First)  
**Active Git Branch:** `evidence/customer-screen19-design-review`  
**Baseline Commit:** `cf0af01456ca7ee6c30ba8de5bda3c5772ffd7a2`  
**Governing Issues:** [GitHub Issue #177](https://github.com/Essxm01/KONFRM/issues/177) (Screen 19 Settings Contract & Independent Bridge Review), [GitHub Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Mandatory Pure Black `#000000`), [GitHub Issue #174](https://github.com/Essxm01/KONFRM/issues/174) (Notifications Navigation Routing), [GitHub Issue #172](https://github.com/Essxm01/KONFRM/issues/172) (Identity, Avatar & Connected Profiles Boundaries), [GitHub Issue #171](https://github.com/Essxm01/KONFRM/issues/171) (Deferred Screen 17 Prelive Gate), [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Design First & Cairo RTL), [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Historical Evidence Directory Immutability), [GitHub Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Device Serial Redaction)

---

## 1. Physical Device Captures & Cryptographic Hash Manifest

All 8 screenshots were captured directly from a physical Samsung Galaxy A56 5G running the isolated native Flutter preview runner (`mobile/apps/customer_app/tool/screen19_preview_runner.dart`). No emulators, simulated browsers, or mock frameworks were used. Hardware serials are redacted as `[REDACTED_A56_ID]` in compliance with Issue #145.

> [!NOTE]
> Accessibility 200% captures (`07` and `08`) verify layout reflow and font scaling using runner-level `MediaQuery(textScaler: TextScaler.linear(2.0))` QA override executed directly on the physical Samsung Galaxy A56 5G hardware, rather than independently modified Android OS system settings.

| # | Scenario Identifier | File Name | Size (Bytes) | PNG SHA-256 | Base64 Companion SHA-256 |
|---|---------------------|-----------|--------------|-------------|---------------------------|
| 01 | `mainSettingsTop` | `01_screen19_settings_clean_top_100.png` | 187,112 | `ce927a1a97ee3e784a8317c3166a855c3781f5e86f5545510c9428b5f3735e78` | `5932a3af13b2d49ccd2a70a91dd5602e5959c6b56709ee6d2e4961064b129bc4` |
| 02 | `mainSettingsScrolled` | `02_screen19_settings_clean_scrolled_100.png` | 196,810 | `26ea7760995d49c5ce8e70b0a26220808b86f81ab8ce863e7260907bd4285a91` | `2083557a2acbfd0432018d8b4c04eb24e88451a251c4739feb9c8815f4d388a5` |
| 03 | `notificationsPermissionDenied` | `03_screen19_settings_permission_denied_sheet.png` | 187,467 | `57019c4cac0d79fb6159f32a6628e0c012b2da0003902f7f19ec62a81354b9fb` | `be3d3fceef27438caf630959258a6936cae8b8be14f40b743bb39834f522a485` |
| 04 | `signOutConfirmationDialog` | `04_screen19_settings_sign_out_dialog.png` | 178,033 | `6530f13ab697102b9abfccc4bf20c06c8c8e64b3abd0f5257dd1e4aa093a0ca6` | `653a3e377e22ba133d99627570ff1d1f11e4b8a7b722a2247354f0399984c1d4` |
| 05 | `unauthenticatedGuestState` | `05_screen19_settings_unauthenticated_guest.png` | 167,034 | `65eb82860e56fb2172d4dd7ccd7e5e196497bfe6b39e107047828ff027b27f8b` | `ee86fa6a8770285cc51a74403d2d50b9e6ddca78859d63419dd31d0dc0cd0b1c` |
| 06 | `accountDeletionInfoSheet` | `06_screen19_settings_account_deletion_sheet.png` | 187,808 | `ba8a2840318fbec7bd8206a1986017c95494d54fed9bab5fb894d7c60ac9a906` | `f4df74a3080353f348c5046a3a7f66e60871d0ec1e93af78bd5d7af23787c41d` |
| 07 | `accessibility200Top` | `07_screen19_settings_a11y_200_top.png` | 154,753 | `f1bba1419f6c651a828c146a3944cf606af08b44f507b337520247d94df1b83a` | `3010d7ef5840137f86bcb0151e325a74764ca3281a3a7b22487f707ccea19522` |
| 08 | `accessibility200Scrolled` | `08_screen19_settings_a11y_200_scrolled.png` | 161,372 | `4768cd62de639006ded7563287b6de8c344d1f90fd045476b4eb4f88e79b35fa` | `a2ae122da753e6b1e67918599247c7378b5fa66a256f3da8baeabc3177f13826` |

---

## 2. Source-Linked Evidence Verification

- **Preview Runner Source:** `review-source/screen19_preview_runner.dart`  
  SHA-256: `1862ebb6904380d10466b5a98aca13513c2d6a0bd6c45037038191f8b4e643f5`
- **Behavioral Test Suite:** `review-source/screen19_source_linked_tests.dart`  
  SHA-256: `cf1268bfd3e30dace0beb5bddc83dd172c104deb1e898d87b4006abcdc47395d`
- **Test Suite Result:** 19/19 passed (100% pass rate).
- **Static Analysis Result:** `flutter analyze` passed with 0 issues.

---

## 3. Targeted Bridge Review Corrections Applied

Following the independent Bridge visual review on [GitHub Issue #177](https://github.com/Essxm01/KONFRM/issues/177#issuecomment-6222145977), three bounded corrections were executed:

### Correction 1: Synthetic Identity & OS Permission Truth
1. **Verified Identifier Badges:** Updated from «مؤكّد» to «مؤكّد (بيانات تجريبية)» for both primary phone and primary email rows.
2. **Card Footnote:** Updated to clearly state: «هذه المعرّفات معروضة كبيانات تجريبية في هذه المعاينة؛ تغيير وسائل الدخول الفعلية يتطلب التحقق من الهوية.»
3. **OS Notification Permission Pill:** Updated to «مفعّل (حالة توضيحية)» (or «متوقف (حالة توضيحية)»).
4. **OS Notification Subtitle:** Updated to «حالة توضيحية — المعاينة لا تقرأ إذن النظام الفعلي بالجهاز» (or «محاكاة لحالة إيقاف الإذن من النظام — المعاينة لا تقرأ إذن النظام الفعلي»).
5. **Section Disclaimer Banner:** Updated to «ملاحظة: حالة الإذن المعروضة توضيحية، والتبديل أدناه محاكاة تجريبية محلية فقط لا تؤثر على إشعارات الجهاز الفعلية.»
6. **Permission Denied Sheet:** Title updated to «إذن الإشعارات في النظام (حالة توضيحية)» and body updated to «توضح هذه الشاشة الإرشادات التي ستظهر للمستخدم في حال إيقاف إذن الإشعارات من إعدادات نظام الجهاز، حيث تتطلب متابعة الحجوزات الفورية تفعيل الإذن من إعدادات النظام.»
7. **Customer Microcopy Cleansing:** Removed internal GitHub issue references (e.g. `(Issue #172)`) from `_buildPlannedFeatureSheet`.

### Correction 2: Guest Notification Controls
1. **State Initialization:** When entering `unauthenticatedGuestState`, `bookingUpdatesEnabled` and `hostMessagesEnabled` are explicitly set to `false`.
2. **Controller Enforcement:** `toggleBookingUpdates` and `toggleHostMessages` reject mutation when `!state.isAuthenticated` and emit feedback notice «يتطلب تفعيل هذا الخيار تسجيل الدخول إلى حسابك».
3. **Guest UI Presentation:**
   - Subtle amber informational banner displayed: «تنبيهات الحجوزات والرسائل تتطلب تسجيل الدخول بحساب مستخدم».
   - Booking and host message switches rendered disabled (`isEnabled: false`, OFF).
   - Dynamic subtitles display «يتطلب تسجيل الدخول لربط تنبيهات الحجز بحسابك» and «يتطلب تسجيل الدخول لاستلام رسائل المضيفين».

### Correction 3: Unapproved Legal & Wallet Claims
1. **Sign-Out Dialog Copy:** Removed references to «محفظتك» from body text. Now reads truthfully: «هل أنت متأكد من رغبتك في تسجيل الخروج من هذا الجهاز؟ ستحتاج إلى إعادة تسجيل الدخول للوصول إلى بيانات حسابك وحجوزاتك.»
2. **Account Deletion & Data Portability Sheet:** Removed unapproved claims of established «سياسة حوكمة الحسابات» and mandatory absence of «مبالغ معلقة في المحفظة». Replaced with honest regulatory notice: «إجراءات تصدير البيانات أو حذف الحساب غير متاحة حالياً وهي قيد الإعداد القانوني والتنظيمي. هذه المعاينة توضيحية فقط ولا تقوم بتقديم أي طلب فعلي. ستخضع هذه الإجراءات لسياسات الخصوصية وشروط الاستخدام المعتمدة فور إطلاقها رسمياً.»
3. **Notice Card:** Updated to: «هذه الخدمة قيد الإعداد والدراسة القانونية، ولن يتم تنفيذ أي إجراء حذف أو تصدير من خلال هذه المعاينة.»
