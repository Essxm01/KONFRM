# StatusBadge contract

A `StatusBadge` is a semantic presentation of a canonical status, not an independently styled screen chip. It uses the corresponding semantic background, text and border token; an icon or dot is optional and cannot be the only signal.

A status badge **identifies** canonical state; it does **not** substitute for required explanatory copy or recovery actions (`STATE_EXPLANATION_AND_RECOVERY_CONTRACT`).

| Domain | Status → Arabic label guidance | Semantic category |
|---|---|---|
| Property | DRAFT → مسودة; PENDING_REVIEW → قيد المراجعة; PUBLISHED → منشورة; REJECTED → مرفوضة; PAUSED → موقوفة | neutral_process, neutral_process, success, danger, neutral_muted |
| Booking | PENDING_OWNER_APPROVAL → بانتظار موافقة المالك; APPROVED_PENDING_PAYMENT → تمت الموافقة — العربون مطلوب; CONFIRMED → الحجز مؤكد; REJECTED → مرفوض; CANCELLED → ملغى; EXPIRED → انتهت صلاحية الطلب | neutral_process, informational_process, success, danger, neutral_muted, neutral_muted |
| Payment | INITIATED → بدأ الدفع; PENDING → قيد المعالجة; SUCCEEDED → تم الدفع; FAILED → فشل الدفع | informational_process, neutral_process, success, danger |
| Wallet Balance Buckets (`owner_wallets`) | AVAILABLE → متاح للسحب; PENDING → معلق (يتاح بعد 24 ساعة من تسجيل الوصول); HELD → محتجز; RESERVED_FOR_PAYOUT → محجوز لطلب سحب | success, neutral_process, neutral_attention, informational_process |
| Payout Request Lifecycle (`payout_requests`) | PENDING_ADMIN_PROCESSING (PENDING) → قيد المراجعة; PROCESSING → قيد التحويل; COMPLETED → تم التحويل; FAILED → فشل التحويل; REJECTED → مرفوض; CANCELLED_BY_OWNER (CANCELLED) → ملغى من المالك | neutral_process, informational_process, success, danger, danger, neutral_muted |
| Identity & Owner KYC | UNVERIFIED → غير موثق; PENDING_VERIFICATION → قيد المراجعة; VERIFIED → موثق; REJECTED → مرفوض | neutral_muted, neutral_process, success, danger |

Applications map internal enum values centrally and never expose them as user-facing English text. Exact wording may be refined centrally without changing business status semantics.

## Normal process statuses are not warnings

Ordinary operational milestones (`PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, `Wallet PENDING`, `PENDING_VERIFICATION`) represent healthy in-flight progress and **must NOT** map to warning/amber styling. They map to `neutral_process` or `informational_process`.

Warning/attention semantics are reserved for genuine caution, consequential risk, or action requiring elevated attention when supported by canonical context.

Exact semantic tokens and hex colors remain **OPEN / token-gated**.

## Status badge is not a marketing trust badge

This contract maps canonical status to human presentation. It does **not** authorize customer-facing claims such as “إقامة موثقة من كونفرم”, “مضمونة” or similar marketing trust language.

Specifically:
- Customer Auth V2 phone/email verification does **not** authorize a generic "Verified Customer" or "حساب موثق" trust badge (`CUSTOMER_IDENTITY_TRUST_BADGE: NOT_AUTHORIZED`).
- Any customer-facing trust claim requires an explicit Product specification describing what was verified and what the claim means.
