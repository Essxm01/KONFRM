# Phase 4G — Domain Status Truth Matrix

**Document Version:** 1.0.0  
**Phase:** Phase 4G — Content & State Presentation System  
**Status:** `PILOT_TRUTH_MATRIX_DRAFT`  
**Purpose:** Server-authoritative domain statuses mapped across Customer, Owner, and Admin roles with role-specific microcopy, decoupled visual alarm levels, and component delivery semantics.

---

## 1. Core Principles of Status Presentation

1. **Server Authority Governs Truth:** Design presents statuses; it never invents, renames, or bypasses server-authoritative state transitions.
2. **Decouple Business Process from Visual Alarm:** Normal procedural states (e.g. `PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, `Wallet PENDING`) are normal business progression, **NOT** warnings or alarms. They use soft neutral or informational styling.
3. **Founder Rule MR-17 Compliance:** Zero yellow/amber/orange boxed UI. Amber is never used as a container fill for routine process states.
4. **Role-Specific Vocabulary:** One internal enum receives distinct, tailored Arabic presentation depending on the user's role and decision context. Internal technical enums (e.g. `APPROVED_PENDING_PAYMENT`) are never exposed directly.
5. **Anti-Status-Soup:** Statuses are expressed through concise badges, inline text, or card context. Badges identify state; they do not replace necessary operational explanations.

---

## 2. Comprehensive Status Presentation Matrix

### 2.1 Property Lifecycle Statuses

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`DRAFT`** | *Hidden (Never exposed)* | **مسودة**<br>*"أكمل بيانات الوحدة لإرسالها للمراجعة"* | **مسودة**<br>*"غير مقدمة للمراجعة"* | `MUTED` | Subtle Neutral Badge | Invisible to renters until published and verified. |
| **`PENDING_REVIEW`** | *Hidden (Never exposed)* | **قيد المراجعة**<br>*"الوحدة قيد تدقيق فريق كونفرم"* | **بانتظار المراجعة**<br>*"تتطلب قرار اعتماد أو رفض"* | `NEUTRAL_PROCESS` (Soft Blue / Neutral) | Info Badge (No amber box) | In review queue. Owner cannot edit critical fields during review. |
| **`PUBLISHED`** | **متاحة للحجز**<br>*(Shown implicitly via card presence)* | **منشورة ومتاحة**<br>*"تظهر للضيوف ويمكن استقبال طلبات عليها"* | **معتمدة ومنشورة**<br>*"متاحة في نتائج البحث العامة"* | `SUCCESS` | Muted Success Badge | Verified + Published required for public listing visibility. |
| **`REJECTED`** | *Hidden (Never exposed)* | **بحاجة إلى تعديل**<br>*"راجع ملاحظات المراجعة وعدّل الوحدة"* | **مرفوضة**<br>*"تم الرفض مع تدوين السبب"* | `DANGER` (Destructive/Rose) | Danger Badge + Inline Reason | Accompanied by plain Arabic rejection feedback. |
| **`PAUSED`** | *Hidden from active search* | **موقوفة مؤقتاً**<br>*"الوحدة مخفية عن نتائج البحث"* | **موقوفة**<br>*"موقوفة من جانب المالك أو الإدارة"* | `MUTED` | Neutral Outline Badge | Retains existing bookings; blocks new requests. |

---

### 2.2 Booking Lifecycle Statuses

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`PENDING_OWNER_APPROVAL`** | **طلبك وصل للمالك**<br>*"بانتظار مراجعة وقرار المالك"* | **طلب حجز جديد**<br>*"يحتاج قرارك (قبول أو رفض)"* | **بانتظار موافقة المالك**<br>*"طلب معلق لدى المالك"* | `NEUTRAL_PROCESS` (Soft Blue / Neutral) | Info Badge / Inline Text | **REQUEST-BASED CANON:** Does NOT block dates. No payment collected. Never an alarm or failure. |
| **`APPROVED_PENDING_PAYMENT`** | **تمت الموافقة — سداد العربون مطلوب**<br>*"سدّد العربون خلال المهلة لتأكيد الحجز"* | **تمت الموافقة من جانبك**<br>*"بانتظار سداد الضيف للعربون"* | **موافقة معلقة بالسداد**<br>*"بانتظار إتمام الدفع"* | `ACTION_REQUIRED` (Restrained Accent / Slate) | High-Contrast Badge + Action CTA | **BLOCKS DATES:** Deposit payment is the next governed step. Bottom nav attention dot active. |
| **`CONFIRMED`** | **حجز مؤكد**<br>*"تم سداد العربون وتأكيد الإقامة بنجاح"* | **حجز مؤكد**<br>*"تم سداد العربون وتثبيت الموعد بالتقويم"* | **حجز مؤكد**<br>*"عربون مسدد والعملية مكتملة"* | `SUCCESS` | Muted Green Badge | **BLOCKS DATES:** Deposit finalized. Full booking confirmation established. |
| **`REJECTED`** | **لم يتم قبول الطلب**<br>*"اعتذر المالك عن قبول هذا الطلب"* | **تم رفض الطلب**<br>*"تم رفض الطلب من جانبك"* | **مرفوض من المالك**<br>*"تم الرفض بواسطة المالك"* | `MUTED_DANGER` | Neutral/Destructive Badge | Strictly distinct from Guest Cancellation. |
| **`CANCELLED`** | **تم الإلغاء**<br>*"ملغي من جانبك"* (or *"بسبب المالك"*) | **طلب ملغي**<br>*"أُلغي من قبل الضيف أو النظام"* | **ملغي**<br>*"مسجل كملغي مع بيان الطرف"* | `MUTED` | Neutral Gray Badge | **NEVER label cancellation as "مرفوض"**. Identifies causal party truthfully. |
| **`EXPIRED`** | **انتهت المهلة**<br>*"لم يتم الرد أو السداد خلال المهلة المحددة"* | **انتهت المهلة**<br>*"انتهت مهلة الرد على الطلب"* | **منتهي الصلاحية**<br>*"تجاوز المهلة الزمنية النظامية"* | `MUTED` | Neutral Gray Badge | Automatic timeout; dates unblocked immediately. |

---

### 2.3 Payment Lifecycle Statuses (Prototype Mode)

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`INITIATED`** | **جارٍ بدء عملية الدفع...** | *Hidden (Internal)* | **عملية دفع مبدوءة** | `NEUTRAL_PROCESS` | In-Place Spinner | Prototype payment flow initiated. |
| **`PENDING`** | **قيد التحقق من السداد...** | *Hidden (Internal)* | **معاملة قيد المعالجة** | `NEUTRAL_PROCESS` | Info Badge | Awaiting webhook / verification. |
| **`SUCCEEDED`** | **تم سداد العربون بنجاح** | **تم سداد العربون** | **عملية دفع ناجحة** | `SUCCESS` | Success Badge / Dedicated Screen | Triggers booking status transition to `CONFIRMED`. |
| **`FAILED`** | **تعذر إتمام عملية السداد**<br>*"لم يتم خصم أي مبالغ. حاول مرة أخرى."* | *Hidden (Internal)* | **فشل عملية الدفع** | `DANGER` | Scoped Alert + Retry CTA | Fails closed; retryable. |

---

### 2.4 Owner Wallet & Payout Statuses

| Canonical Enum | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`PENDING`** | **رصيد معلق**<br>*"يتحول إلى متاح للسحب بعد 24 ساعة من موعد تسجيل الدخول"* | **أرصدة معلقة**<br>*"مستحقات حجز قبل مرور 24 ساعة على الدخول"* | `NEUTRAL_PROCESS` (Slate / Soft Neutral) | Info Metric Panel | **NOT PAYOUT ELIGIBLE:** Must never look like available cash. |
| **`AVAILABLE`** | **رصيد متاح للسحب**<br>*"مؤهل للتحويل لحسابك البنكي"* | **رصيد متاح**<br>*"جاهز لطلب الصرف"* | `SUCCESS` / `PRIMARY` | Primary Metric Panel | Minimum payout threshold: 500 EGP. Provider fees Owner-borne. |
| **`RESERVED`** | **رصيد محجوز**<br>*"مرتبط بطلب سحب قيد المراجعة"* | **رصيد محجوز للصرف** | `MUTED` | Neutral Panel | Temporarily held during payout processing. |
| **`HELD`** | **رصيد محتجز مؤقتاً**<br>*"بسبب نزاع قائم أو مراجعة إدارية"* | **محتجز لنزاع/تدقيق** | `ATTENTION` (Neutral with icon) | Scoped Alert Panel | Disputed funds held until resolution. |
| **`PROCESSING`** | **طلب سحب قيد التحويل**<br>*"جارٍ إرسال المبلغ عبر مزود التحويل"* | **قيد التحويل البنكي** | `NEUTRAL_PROCESS` | Info Badge | Payout batch in execution. |
| **`COMPLETED`** | **تم تحويل المبلغ بنجاح** | **صرف مكتمل وموثق** | `SUCCESS` | Success Badge | Payout archived in history. |
| **`REJECTED`** | **تعذر صرف المبلغ**<br>*"تم رفض طلب السحب وأُعيد الرصيد للمحفظة"* | **طلب صرف مرفوض** | `DANGER` | Danger Alert + Reason | Funds returned to `AVAILABLE`. |

---

### 2.5 Identity & KYC Statuses

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`UNVERIFIED`** | *Account active (standard)* | **الهوية غير موثقة**<br>*"ارفع بطاقة الرقم القومي وصورة الوجه لبدء النشر"* | **غير موثق** | `MUTED` | Neutral Action Banner | Owner cannot submit properties for review until verified. |
| **`PENDING_VERIFICATION`** | *Hidden* | **المستندات قيد المراجعة**<br>*"يجري فحص البطاقة وصورة الوجه من قبل الإدارة"* | **طلب توثيق معلق**<br>*"مستندات KYC بانتظار الفحص"* | `NEUTRAL_PROCESS` | Info Badge (No amber box) | Admin KYC queue item. |
| **`VERIFIED`** | **حساب موثق** | **الهوية موثقة** | **هوية معتمدة** | `SUCCESS` | Subtle Success Pill | **NO MARKETING TRUST CLAIMS:** Does not authorize customer "verified stay" marketing badges. |
| **`REJECTED`** | *Hidden* | **تعذر توثيق الهوية**<br>*"يرجى إعادة رفع صور أوضح للهوية"* | **طلب توثيق مرفوض** | `DANGER` | Scoped Alert + Retry Upload | Re-upload required. |

---

## 3. Financial Visibility Boundaries by Role (Section 10)

| Financial Field | Customer Visibility | Owner Visibility | Admin Visibility | Presentation Directive |
| :--- | :--- | :--- | :--- | :--- |
| **Total Stay Amount** | **VISIBLE** | **VISIBLE** | **VISIBLE** | Full contractual total in EGP. |
| **First-Night Deposit** | **VISIBLE** | **VISIBLE** | **VISIBLE** | Payable by renter; required for booking confirmation. |
| **Remaining Balance** | **VISIBLE** | **VISIBLE** | **VISIBLE** | Due directly upon arrival per product policy. |
| **Platform Commission (20%)** | **HIDDEN** | **VISIBLE** (in breakdown) | **VISIBLE** | **CUSTOMER LEAKAGE PROHIBITED:** Customer never sees platform split. |
| **Owner Net Entitlement (80%)** | **HIDDEN** | **VISIBLE** | **VISIBLE** | Owner sees exact net credit. |
| **Wallet Ledgers / Payout Fees** | **HIDDEN** | **VISIBLE** | **VISIBLE** | Provider transfer fee borne by Owner. |
