# Content and microcopy

KONFRM is Arabic-first, using natural Egyptian and Modern Standard Arabic suitable for the role and moment.

## Core Microcopy Principles

1. **Specific Scope, Consequence, and Next Action:** Every error, notification, or state message must explicitly communicate:
   - What happened (scope)
   - What it means for the user (consequence)
   - What the user can do next (recovery action)
2. **Avoid Vague Error Copy:** Never use *"حدث خطأ"* or *"حدث خطأ ما"* as the complete explanation. State the concrete situation plainly (e.g. *"تعذر تحميل الإقامات بسبب انقطاع الاتصال"*).
3. **Zero Technical Language Leakage:** Forbidden terms on Customer and Owner surfaces:
   - `HTTP 500`, `404`, `401`, `403`
   - `Supabase`, `PostgreSQL`, `SQL`, `database`
   - `RPC`, `REST`, `fetch failed`, `NetworkError`
   - `exception`, `null reference`, `undefined`
4. **No Invented Commitments or SLAs:**
   - Never invent response deadlines for Owners (no "خلال 24 ساعة" unless canonically backed by database).
   - Never invent payment deadlines for Customers on approved bookings.
   - Never promise instantaneous bank delivery for Owner payouts.
   - Never fabricate marketing trust claims (no "حساب موثق", "إقامة مضمونة").
5. **Formatting Standards:**
   - **Numerals:** Western Arabic numerals (`0-9`) exclusively (e.g. `1,600`, `2`, `14`).
   - **Currency:** Canonical Egyptian Pound format: `1,600 ج.م`.
   - **Bidirectional Isolation:** Technical IDs (`BK-183223`), phone numbers (`+201049892908`), and money values wrapped with proper LTR/RTL semantic tags (`dir="ltr"` or Unicode bidi markers).

---

## Role-Aware Tone

| Dimension | Customer | Owner | Admin |
|---|---|---|---|
| **Primary Job** | Reassuring, simple, decision-oriented, trust-sensitive | Clear, operational, action-priority, financial certainty | Precise, structured, audit truth, queue integrity |
| **Tone** | Warm, respectful, clear, reassuring | Professional, direct, action-focused | Neutral, concise, audit-focused |
| **Error Example** | *"تعذر إتمام العملية. تحقق من اتصالك وحاول مرة أخرى."* | *"تعذر تسجيل القرار على الطلب. يرجى إعادة المحاولة."* | *"فشل تحديث سجل المراجعة (خطوة غير مكتملة). تحقق من الصلاحيات وأعد المحاولة."* |
| **Empty Example** | *"قائمة المفضلة فارغة. استكشف الإقامات واحفظ ما يعجبك."* | *"لا توجد طلبات جديدة تحتاج قرارك اليوم."* | *"قائمة مراجعة الوحدات مكتملة بالكامل."* |
| **Financial Boundaries** | Sees total, deposit, and remaining balance. Never sees platform commissions or 80/20 splits. | Sees distinct Available and Pending balances with 24-hour check-in rule. | Full audit visibility into gross, fees, taxes, and net distributions. |
