# StatusBadge Contract

> [!NOTE]
> **Component Maturity & Scope Disclaimer:** This specification defines shared component contracts across KONFRM's three roles (Customer, Owner, Admin). Web implementations (React 19 / TypeScript) serve as the current running baseline (`CONTROLLED_WEB_PILOT_REFERENCE`). Native mobile specifications establish contract boundaries for the future Flutter target (`PHASE_4I_TARGET`). Exact native mobile layout parameters and styling details are explicitly governed in Phase 4I.

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Structural Invariants:**
  - Semantic Presentation of Canonical Truth: Identifies server status; never substitutes for required explanatory copy or recovery actions (`STATE_EXPLANATION_AND_RECOVERY_CONTRACT`).
  - No Marketing Trust Badges: Customer Auth V2 phone/email verification does not authorize synthetic trust badges ("إقامة موثقة" / "حساب موثق").
  - Actor Causality Invariant: `CANCELLED_BY_OWNER` and `CANCELLED_BY_GUEST` must preserve actor causality.
  - Verification Truth vs Lifecycle Enum: Property rejection is `properties.verification_status = 'REJECTED'`, returning lifecycle to `DRAFT`.
  - Normal Process != Warning: `PENDING` states are healthy progress; never map to amber/yellow warnings (`MR-17`).
  - Text Contrast Target: Normal-size text within status badges targets a contrast ratio of `>= 4.5:1` against the badge background. (A `3:1` threshold applies strictly to large text or non-text boundary indicators / icons).
- **Open Parameters:** Exact badge border/background token hexes (`OPEN / DEFERRED_TO_4I`).

A `StatusBadge` is a semantic presentation of a canonical status, not an independently styled screen chip. It uses the corresponding semantic background, text and border token; an icon or dot is optional and cannot be the only signal.

A status badge **identifies** canonical state; it does **not** substitute for required explanatory copy or recovery actions (`STATE_EXPLANATION_AND_RECOVERY_CONTRACT`).

---

## 2. Canonical Domain Status Mapping

| Domain Family | Canonical Source & Classification | Status → Arabic Label Guidance | Semantic Category |
|---|---|---|---|
| **Property Lifecycle** | `properties.status`<br>`[SERVER_ENUM]` | `DRAFT` → مسودة<br>`PENDING_REVIEW` → قيد المراجعة<br>`PUBLISHED` → منشورة<br>`PAUSED` → موقوفة<br>`ARCHIVED` → مؤرشفة | `neutral_process`<br>`neutral_process`<br>`success`<br>`neutral_muted`<br>`neutral_muted` |
| **Property Verification** | `properties.verification_status`<br>`[VERIFICATION_STATE / SERVER_ENUM]` | `UNVERIFIED` → غير موثق<br>`PENDING_VERIFICATION` → قيد الفحص<br>`VERIFIED` → موثق<br>`REJECTED` → مرفوض | `neutral_muted`<br>`neutral_process`<br>`success`<br>`danger` |
| **Booking Lifecycle** | `bookings.status`<br>`[SERVER_ENUM]` | `PENDING_OWNER_APPROVAL` → بانتظار موافقة المالك<br>`APPROVED_PENDING_PAYMENT` → تمت الموافقة — العربون مطلوب<br>`CONFIRMED` → الحجز مؤكد<br>`REJECTED` → مرفوض من المالك<br>`EXPIRED` → انتهت صلاحية الطلب<br>`CANCELLED_BY_OWNER` → Customer: ألغى المالك الحجز / Owner: تم الإلغاء من جانبك / Admin: ملغى بواسطة المالك<br>`CANCELLED_BY_GUEST` → Customer: تم الإلغاء من جانبك / Owner: ألغى الضيف الحجز / Admin: ملغى بواسطة الضيف<br>`COMPLETED` → اكتملت الإقامة | `neutral_process`<br>`informational_process`<br>`success`<br>`danger`<br>`neutral_muted`<br>`neutral_muted`<br>`neutral_muted`<br>`success` |
| **Payment Transactions** | `payment_transactions.status`<br>`[SERVER_ENUM]` | `INITIATED` → بدأ الدفع<br>`PENDING` → قيد المعالجة<br>`SUCCEEDED` → تم الدفع بنجاح<br>`FAILED` → فشل الدفع<br>`EXPIRED` → منتهية الصلاحية<br>`CANCELLED` → ملغاة<br>`REFUNDED` → مسترد بالكامل<br>`PARTIALLY_REFUNDED` → مسترد جزئياً<br>*(Adapter Alias: `NO_PAYMENT_INITIATED` [CLIENT_PRESENTATION_ALIAS] → لم يبدأ الدفع بعد)* | `informational_process`<br>`neutral_process`<br>`success`<br>`danger`<br>`neutral_muted`<br>`neutral_muted`<br>`informational_process`<br>`informational_process`<br>`neutral_muted` |
| **Wallet Balance Buckets** | `owner_wallets` columns<br>`[BALANCE_BUCKET]` | `AVAILABLE` (`available_balance`) → متاح للسحب (الحد الأدنى 500 ج.م)<br>`PENDING` (`pending_balance`) → معلق (يتاح بعد 24 ساعة من تسجيل الوصول)<br>`HELD` (`held_balance`) → محتجز مؤقتاً<br>`RESERVED_FOR_PAYOUT` (`reserved_for_payout_balance`) → محجوز لطلب سحب | `success`<br>`neutral_process`<br>`neutral_attention`<br>`informational_process` |
| **Payout Request Lifecycle** | `payout_requests.status`<br>`[SERVER_ENUM]` | `PENDING_ADMIN_PROCESSING` *(Legacy alias: `PENDING` [CLIENT_PRESENTATION_ALIAS])* → قيد المراجعة<br>`PROCESSING` → قيد التحويل<br>`COMPLETED` → تم التحويل بنجاح<br>`UNKNOWN` → Owner: قيد التحقق من حالة التحويل / Admin: حالة التحويل غير محسومة — تحتاج تحقق<br>`FAILED` → فشل التحويل<br>`REJECTED` → مرفوض<br>`CANCELLED_BY_OWNER` *(Legacy alias: `CANCELLED` [CLIENT_PRESENTATION_ALIAS])* → ملغى من المالك | `neutral_process`<br>`informational_process`<br>`success`<br>`neutral_process`<br>`danger`<br>`danger`<br>`neutral_muted` |
| **Owner KYC Identity** | `owners.verification_status`<br>`[VERIFICATION_STATE / SERVER_ENUM]` | `UNVERIFIED` → غير موثق<br>`PENDING_VERIFICATION` → قيد المراجعة<br>`VERIFIED` → موثق<br>`REJECTED` → تعذر التوثيق | `neutral_muted`<br>`neutral_process`<br>`success`<br>`danger` |
| **Owner Verification Document** | `owner_verification_documents.status`<br>`[DOCUMENT_VERIFICATION_STATE / SERVER_ENUM]` | `PENDING` → قيد الفحص<br>`VERIFIED` → مستند معتمد<br>`REJECTED` → مستند مرفوض | `neutral_process`<br>`success`<br>`danger` |

Applications map internal enum values centrally and never expose them as raw technical strings. Exact role-aware Arabic wording may be refined centrally without changing business status semantics.

---

## 3. Architectural & Semantic Rules

### 3.1 Property Rejection is Verification Truth, Not Lifecycle Enum
`properties.status` has no `REJECTED` value (`DRAFT`, `PENDING_REVIEW`, `PUBLISHED`, `PAUSED`, `ARCHIVED`). Under canonical Admin review behavior, property rejection returns the lifecycle status to `DRAFT` and sets `properties.verification_status = 'REJECTED'`. UI may display an operational badge such as "مرفوضة" or "بحاجة إلى تعديل", but documentation and code must never treat `REJECTED` as a `properties.status` enum.

### 3.2 Booking Cancellation Causal Discipline
The canonical `bookings.status` model preserves explicit actor causality: `CANCELLED_BY_OWNER` is strictly distinct from `CANCELLED_BY_GUEST`, and both are distinct from `REJECTED` (Owner decline prior to payment) and `EXPIRED` (passive timeout). Presentation must never collapse these into a generic `CANCELLED`. `COMPLETED` represents verified stay completion truth.

### 3.3 Payout UNKNOWN Handling
The canonical `payout_requests.status` includes `UNKNOWN` for indeterminate provider/network states requiring reconciliation. It must be presented as `neutral_process` / `informational_process` ("قيد التحقق من حالة التحويل" for Owner; "حالة التحويل غير محسومة — تحتاج تحقق" for Admin). It must **NEVER** be presented as `COMPLETED`, `FAILED`, `REJECTED`, or `AVAILABLE`, and financial funds must remain reserved until authoritative reconciliation is finalized.

### 3.4 Normal Process Statuses are Not Warnings
Ordinary operational milestones (`PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, `Wallet PENDING`, `PENDING_VERIFICATION`, `Payout UNKNOWN`) represent healthy in-flight progress and **must NOT** map to warning/amber styling. They map to `neutral_process` or `informational_process`.

Warning/attention semantics are reserved for genuine caution, consequential risk, or action requiring elevated attention when supported by canonical context.

Exact semantic tokens and hex colors remain **OPEN / token-gated**.

### 3.5 Status Badge is Not a Marketing Trust Badge
This contract maps canonical status to human presentation. It does **not** authorize customer-facing claims such as “إقامة موثقة من كونفرم”, “مضمونة” or similar marketing trust language.

Specifically:
- Customer Auth V2 phone/email verification does **not** authorize a generic "Verified Customer" or "حساب موثق" trust badge (`CUSTOMER_IDENTITY_TRUST_BADGE: NOT_AUTHORIZED`).
- Any customer-facing trust claim requires an explicit Product specification describing what was verified and what the claim means.
