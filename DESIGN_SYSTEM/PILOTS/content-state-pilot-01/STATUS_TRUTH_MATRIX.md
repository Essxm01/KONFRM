# Phase 4G — Domain Status Truth Matrix

**Document Version:** 1.1.0
**Phase:** Phase 4G — Content & State Presentation System
**Status:** `PILOT_TRUTH_MATRIX_HARMONIZED`
**Purpose:** Server-authoritative domain statuses mapped across Customer, Owner, and Admin roles with role-specific microcopy, decoupled visual alarm levels, and component delivery semantics.

---

## 1. Core Principles of Status Presentation

1. **Server Authority Governs Truth:** Design presents statuses; it never invents, renames, or bypasses server-authoritative state transitions.
2. **Decouple Business Process from Visual Alarm:** Normal procedural states (e.g. `PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, `Wallet PENDING`) are normal business progression, **NOT** warnings or alarms. They use soft neutral or informational styling.
3. **Founder Rule MR-17 Compliance:** Zero yellow/amber/orange boxed UI. Amber is never used as a container fill for routine process states.
4. **Role-Specific Vocabulary:** One internal enum receives distinct, tailored Arabic presentation depending on the user's role and decision context. Internal technical enums are never exposed directly.
5. **Anti-Status-Soup:** Statuses are expressed through concise badges, inline text, or card context. Badges identify state; they do not replace necessary operational explanations.
6. **Separation of Contracts from Example Copy:** Semantic state contracts define truth and lifecycle boundaries; example Arabic copy illustrates governed presentation without over-canonizing cause-specific wording where canonical backend reasons are not yet exposed.

---

## 2. Comprehensive Status Presentation Matrix

### 2.1 Property Lifecycle Statuses

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`DRAFT`** | *Hidden (Never exposed)* | **مسودة**<br>*"أكمل بيانات الوحدة لإرسالها للمراجعة"* | **مسودة**<br>*"غير مقدمة للمراجعة"* | `MUTED` | Subtle Neutral Badge | Invisible to renters until published and verified. |
| **`PENDING_REVIEW`** | *Hidden (Never exposed)* | **قيد المراجعة**<br>*"الوحدة قيد تدقيق فريق كونفرم"* | **بانتظار المراجعة**<br>*"تتطلب قرار اعتماد أو رفض"* | `NEUTRAL_PROCESS` (Soft Blue / Neutral) | Info Badge (No amber box) | In Admin review queue. Owner cannot directly publish, reject, or self-resubmit. |
| **`PUBLISHED`** | **متاحة للحجز**<br>*(Shown implicitly via card presence)* | **منشورة ومتاحة**<br>*"تظهر للضيوف ويمكن استقبال طلبات عليها"* | **معتمدة ومنشورة**<br>*"متاحة في نتائج البحث العامة"* | `SUCCESS` | Muted Success Badge | Verified + Published required for public listing visibility. |
| **`REJECTED`** | *Hidden (Never exposed)* | **بحاجة إلى تعديل**<br>*"راجع ملاحظات المراجعة وعدّل الوحدة"* | **مرفوضة**<br>*"تم الرفض مع تدوين السبب"* | `DANGER` (Destructive/Rose) | Danger Badge + Inline Reason | Accompanied by plain Arabic rejection feedback. |
| **`PAUSED`** | *Hidden from active search* | **موقوفة مؤقتاً**<br>*"الوحدة مخفية عن العرض العام"* | **موقوفة**<br>*"موقوفة من جانب المالك أو الإدارة"* | `MUTED` | Neutral Outline Badge | **SUPPORTED TRUTH:** Unit is paused/hidden from public listing. Booking request consequences remain governed by Product/availability authority. |

---

### 2.2 Booking Lifecycle Statuses

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`PENDING_OWNER_APPROVAL`** | **طلبك وصل للمالك**<br>*"بانتظار مراجعة وقرار المالك"* | **طلب حجز جديد**<br>*"يحتاج قرارك (قبول أو رفض)"* | **بانتظار موافقة المالك**<br>*"طلب معلق لدى المالك"* | `NEUTRAL_PROCESS` (Soft Blue / Neutral) | Info Badge / Inline Text | **REQUEST-BASED CANON:** Does NOT block dates. No payment collected. No Owner response SLA exists or is stated. Never an alarm or failure. |
| **`APPROVED_PENDING_PAYMENT`** | **تمت الموافقة — سداد العربون مطلوب**<br>*"سدّد العربون لتأكيد الحجز."* | **تمت الموافقة من جانبك**<br>*"بانتظار سداد الضيف للعربون لتأكيد الحجز"* | **موافقة معلقة بالسداد**<br>*"بانتظار إتمام الدفع"* | `ACTION_REQUIRED` (Restrained Accent / Slate) | High-Contrast Badge + Action CTA | **BLOCKS DATES:** Deposit payment is the next governed step. Bottom nav attention dot active. **NO INVENTED PAYMENT DEADLINE.** |
| **`CONFIRMED`** | **حجز مؤكد**<br>*"تم سداد العربون وتأكيد الإقامة بنجاح"* | **حجز مؤكد**<br>*"تم سداد العربون وتثبيت الموعد بالتقويم"* | **حجز مؤكد**<br>*"عربون مسدد والعملية مكتملة"* | `SUCCESS` | Muted Green Badge | **BLOCKS DATES:** Deposit finalized. Full booking confirmation established. |
| **`REJECTED`** | **لم يتم قبول الطلب**<br>*"اعتذر المالك عن قبول هذا الطلب"* | **تم رفض الطلب**<br>*"تم رفض الطلب من جانبك"* | **مرفوض من المالك**<br>*"تم الرفض بواسطة المالك"* | `MUTED_DANGER` | Neutral/Destructive Badge | Strictly distinct from Guest Cancellation. |
| **`CANCELLED`** | **تم الإلغاء**<br>*"ملغي من جانبك"* (or *"بسبب المالك"*) | **طلب ملغي**<br>*"أُلغي من قبل الضيف أو النظام"* | **ملغي**<br>*"مسجل كملغي مع بيان الطرف"* | `MUTED` | Neutral Gray Badge | **NEVER label cancellation as "مرفوض"**. Identifies causal party truthfully. |
| **`EXPIRED`** | **انتهت صلاحية الطلب** | **انتهت صلاحية الطلب** | **طلب منتهي الصلاحية** | `MUTED` | Neutral Gray Badge | **CAUSE-NEUTRAL TRUTH:** Request is no longer active. Expiry cause is not universally inferred (no assumed Owner delay or payment SLA). Dates are non-blocked. |

---

### 2.3 Payment Lifecycle Statuses (Prototype Mode)

| Canonical Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Preferred Component | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`INITIATED`** | **جارٍ بدء عملية الدفع...** | *Hidden (Internal)* | **عملية دفع مبدوءة** | `NEUTRAL_PROCESS` | In-Place Spinner | Prototype payment flow initiated. |
| **`PENDING`** | **قيد التحقق من السداد...** | *Hidden (Internal)* | **معاملة قيد المعالجة** | `NEUTRAL_PROCESS` | Info Badge | Awaiting webhook / verification. |
| **`SUCCEEDED`** | **تم سداد العربون بنجاح** | **تم سداد العربون** | **عملية دفع ناجحة** | `SUCCESS` | Success Badge / Dedicated Screen | Triggers booking status transition to `CONFIRMED`. |
| **`FAILED`** | **تعذر إتمام عملية السداد**<br>*"تعذر إتمام العملية. يرجى إعادة المحاولة."* | *Hidden (Internal)* | **فشل عملية الدفع** | `DANGER` | Scoped Alert + Retry CTA | Fails closed; retryable. **NO UNIVERSAL NO-CHARGE PROMISE:** Does not guarantee zero charge or instant refund unless proved by transaction truth. |

---

### 2.4 Owner Wallet Balance Buckets & Payout Lifecycle

These are two structurally distinct domain concepts: (A) balance buckets on the wallet entity, and (B) lifecycle statuses of individual payout requests.

#### 2.4A Owner Wallet Balance Buckets (`owner_wallets`)

| Balance Bucket Column | Owner Presentation | Admin Presentation | Visual Alarm Level | Semantic Role | Invariant / Boundary |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`available_balance` (`AVAILABLE`)** | **رصيد متاح للسحب**<br>*"متاح لطلب السحب (الحد الأدنى 500 ج.م)"* | **رصيد متاح**<br>*"جاهز لطلب الصرف"* | `SUCCESS` / `PRIMARY` | Primary Metric Panel | May contribute to payout eligibility. Threshold: >= 500 EGP. Provider fee Owner-borne. **NO IMMEDIATE TRANSFER PROMISE.** |
| **`pending_balance` (`PENDING`)** | **رصيد معلق**<br>*"يتحول إلى متاح بعد 24 ساعة من موعد تسجيل الدخول"* | **أرصدة معلقة**<br>*"مستحقات حجز قبل مرور 24 ساعة على الدخول"* | `NEUTRAL_PROCESS` (Slate / Soft Neutral) | Info Metric Panel | **NOT PAYOUT ELIGIBLE:** Electronic deposit net. Moves to `available_balance` strictly 24 hours after check-in. |
| **`held_balance` (`HELD`)** | **رصيد محتجز مؤقتاً** | **محتجز لنزاع/تدقيق** | `ATTENTION` (Neutral with icon) | Scoped Alert Panel | Separately held balance. Reason is stated only when canonical backend data explicitly supplies it. |
| **`reserved_for_payout_balance` (`RESERVED_FOR_PAYOUT`)** | **رصيد محجوز للسحب**<br>*"مرتبط بطلب سحب قيد الإجراء"* | **رصيد محجوز للصرف** | `MUTED` | Neutral Panel | Balance reserved for an active payout request operation. Deducted from available balance upon submission. |

#### 2.4B Payout Request Lifecycle (`payout_requests`)

*Server Source Authority: Database migration `008_flow_adm_08_payout_execution.sql` (`payout_requests_status_check` constraint).*
*Owner UI Type Authority: `owner-app/src/types/index.ts` (`PayoutStatus`).*

| Database Server Enum (Migration 008) | Owner Client Presentation Mapping | Admin Queue Presentation | Visual Alarm Level | Preferred Component | Lifecycle Truth & Invariant |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`PENDING_ADMIN_PROCESSING`** | **طلب سحب قيد المراجعة**<br>*"بانتظار مراجعة الإدارة"* | **طلب صرف جديد**<br>*"بانتظار المراجعة والاعتماد"* | `NEUTRAL_PROCESS` | Info Badge | Initial submitted state. Balance remains in `RESERVED_FOR_PAYOUT`. |
| **`PROCESSING`** | **طلب سحب قيد التنفيذ**<br>*"جارٍ تنفيذ التحويل عبر مزود الخدمة"* | **قيد التحويل**<br>*"عملية جارية لدى المزود"* | `NEUTRAL_PROCESS` | Info Badge | Batch payout in execution. |
| **`COMPLETED`** | **تم تحويل المبلغ بنجاح**<br>*"اكتمل تحويل الأرباح إلى حسابك"* | **صرف مكتمل وموثق** | `SUCCESS` | Success Badge | Payout finalized. Balance removed from `RESERVED_FOR_PAYOUT`. |
| **`FAILED`** | **فشل عملية التحويل**<br>*"تعذر التحويل من المزود. يجري التدقيق."* | **فشل مزود الصرف** | `DANGER` | Scoped Alert | Technical failure at payout provider level. Retryable by system/admin. |
| **`REJECTED`** | **طلب سحب مرفوض**<br>*"أُعيد المبلغ المحجوز إلى رصيدك المتاح"* | **طلب صرف مرفوض** | `DANGER` | Danger Alert + Reason | Rejected by Admin or Provider. Idempotent release: `RESERVED_FOR_PAYOUT` -> `AVAILABLE`. |
| **`CANCELLED_BY_OWNER`** | **طلب سحب ملغي من جانبك**<br>*"تم إلغاء الطلب واستعادة الرصيد"* | **ملغي بواسطة المالك** | `MUTED` | Neutral Gray Badge | Owner cancelled prior to processing. `RESERVED_FOR_PAYOUT` -> `AVAILABLE`. |
| **`UNKNOWN`** | **قيد التحقق من التحويل**<br>*"يجري التأكد من حالة العملية"* | **حالة معلقة غير محددة** | `NEUTRAL_PROCESS` | Info Badge | Indeterminate provider status pending administrative verification. |

---

### 2.5 Identity & Verification Statuses

*Discipline: Separate Customer authentication attributes from Owner KYC verification.*

| Entity & Scope | Status Enum | Customer Presentation | Owner Presentation | Admin Presentation | Visual Alarm Level | Boundary & Canon Rule |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Customer Identifier Verification** (Auth V2) | Phone/Email verified | Explicit inline label (e.g. *"رقم الهاتف مؤكد"*) where required | *Hidden* | Verified contact | `MUTED` | **NO MARKETING TRUST BADGE:** Customer Auth V2 phone/email verification does NOT authorize a generic "Verified Customer" or "حساب موثق" trust status. |
| **Owner KYC Identity** | **`UNVERIFIED`** | *Hidden* | **الهوية غير موثقة**<br>*"ارفع بطاقة الرقم القومي وصورة الوجه لبدء النشر"* | **غير موثق** | `MUTED` | Owner cannot submit properties for review until KYC submitted and approved. |
| **Owner KYC Identity** | **`PENDING_VERIFICATION`** | *Hidden* | **المستندات قيد المراجعة**<br>*"يجري فحص البطاقة وصورة الوجه من قبل الإدارة"* | **طلب توثيق معلق**<br>*"مستندات KYC بانتظار الفحص"* | `NEUTRAL_PROCESS` | Admin KYC queue item. |
| **Owner KYC Identity** | **`VERIFIED`** | *Hidden* | **الهوية موثقة** | **هوية معتمدة** | `SUCCESS` | Subtle Success Pill on Owner profile. Authorizes property review submission. |
| **Owner KYC Identity** | **`REJECTED`** | *Hidden* | **تعذر توثيق الهوية**<br>*"يرجى إعادة رفع صور أوضح للهوية"* | **طلب توثيق مرفوض** | `DANGER` | Scoped Alert + Retry Upload. Plain Arabic reason provided. |

---

## 3. Financial Visibility Boundaries by Role

| Financial Field | Customer Visibility | Owner Visibility | Admin Visibility | Presentation Directive & Canon Truth |
| :--- | :--- | :--- | :--- | :--- |
| **Total Stay Amount** | **VISIBLE** | **VISIBLE** | **VISIBLE** | Full contractual total in EGP. |
| **First-Night Deposit** | **VISIBLE** | **VISIBLE** | **VISIBLE** | Payable by renter; required for booking confirmation. |
| **Remaining Balance** | **VISIBLE** | **VISIBLE** | **VISIBLE** | **`remaining_balance = total_amount - deposit`**. Platform commission on remaining balance is strictly **0%**. **REMAINING_BALANCE_COLLECTION_METHOD: OPEN / NOT YET GOVERNED.** Customer sees total, deposit, and remaining amount; collection method (arrival, cash, digital) is never stated. |
| **Platform Commission (20%)** | **HIDDEN** | **VISIBLE** (in breakdown) | **VISIBLE** | **CUSTOMER LEAKAGE PROHIBITED:** Customer never sees platform split. Applies only to first-night deposit. |
| **Owner Net Entitlement (80%)** | **HIDDEN** | **VISIBLE** | **VISIBLE** | Owner sees exact net credit from deposit. |
| **Wallet Ledgers / Payout Fees** | **HIDDEN** | **VISIBLE** | **VISIBLE** | Payout provider fee is Owner-borne. Minimum payout is 500 EGP. |
