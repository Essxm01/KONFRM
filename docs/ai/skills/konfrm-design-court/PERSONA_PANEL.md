# Design Court — Synthetic Persona Panel

> [!IMPORTANT]
> **SYNTHETIC PERSONA OPINION != USER RESEARCH EVIDENCE.**
> Every persona is labelled `SYNTHETIC_ROLE_LENS`. Synthetic personas are NOT user research and never prove user behavior.

---

## 1. Available Lenses

| Role | Lens | Focus |
|------|------|-------|
| Customer | `TRUST_SENSITIVE_FIRST_TIME_CUSTOMER` | Trust, clarity, hospitality, low ambiguity on first contact |
| Customer | `FAST_RETURNING_CUSTOMER` | Speed, recognition, minimal re-explanation |
| Owner | `FIRST_TIME_OWNER` | Onboarding comprehension, confidence in consequences |
| Owner | `OPERATIONAL_OWNER` | Scanability, operational speed, state confidence, useful density |
| Admin | `QUEUE_OPERATOR` | Throughput, truth, consistent queue states |
| Admin | `EXCEPTION_AUDIT_OPERATOR` | Exception handling, auditability, evidence traceability |

Select only lenses relevant to the actual case. Do NOT summon every persona automatically. `FAST_PANEL` typically uses 1–2.

## 2. Prohibited Invention

Do NOT invent age, income, occupation, location, family status, preferences, or psychological traits unless supported by actual Product research evidence (which must then be cited separately as `PRODUCT_EVIDENCE`).

## 3. Hearing Questions (each selected lens, ~100 words)

1. `WHAT_DO_I_UNDERSTAND_IMMEDIATELY?`
2. `WHAT_COULD_CONFUSE_ME?`
3. `WHAT_INCREASES_CONFIDENCE?`
4. `WHAT_SLOWS_ME_DOWN?`
5. `WHERE_COULD_I_MAKE_A_MISTAKE?`

Role emphasis: Customer → trust + clarity + hospitality + low ambiguity. Owner → scanability + operational speed + state confidence + useful density. Admin → truth + throughput + exception handling + auditability.

Personas evaluate task comprehension; they do not give arbitrary designer opinions.

## 4. Truth Guard Language

- ❌ Forbidden: "users prefer X", "personas prove X", "customers will choose X" (when based only on simulation).
- ✅ Allowed: "The Customer synthetic role lens predicts …", "The `OPERATIONAL_OWNER` lens flags a possible scan delay …".

Real user evidence, when it exists, is reported separately and classified `PRODUCT_EVIDENCE`.
