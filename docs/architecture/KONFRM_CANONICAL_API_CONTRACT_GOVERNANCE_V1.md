# KONFRM Canonical API Contract Governance Decision — v1

**Status:** APPROVED DECISION
**Scope:** Canonical API Contract Governance & Specification Standard
**Authority:** Founder Approved
**Related Decisions:**
- [`docs/architecture/KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`](./KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md)
- [`docs/architecture/KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md`](./KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md)
**Purpose:** تحديد واعتماد استراتيجية حوكمة عقود الـ API المعتمدة (Canonical API Contract) لربط الـ Backend وتطبيقات الموبايل المستقبلية بنموذج قياسي قابل للقراءة آلياً، ومنع تباين البيانات (Contract Drift)، دون إجراء إعادة كتابة غير ضرورية للـ Backend.

---

## 1. Context & Problem Statement

أكد الفحص المعماري الشامل (Forensic Architecture Audit) أن عقود البيانات والـ DTOs في KONFRM مكتوبة يدوياً ومكررة في عدة أماكن غير مترابطة:
- في الـ Backend داخل `backend/server/src/contracts/`
- في تطبيق المستأجر للويب داخل `customer-app/src/types/` وملفات الـ utils
- في تطبيق المالك للويب داخل `owner-app/src/services/contracts/` و `types/`

ومع التوجه لبناء تطبيقي موبايل بتقنية Flutter + Dart (Customer و Owner) داخل نفس المستودع، فإن الاستمرار في كتابة النماذج يدوياً في Dart سيضاعف فجوة التباين (Contract Drift) ويؤدي إلى أخطاء غير مرئية أثناء التشغيل على أجهزة الموبايل.

لذا، كان لزاماً حسم استراتيجية حوكمة عقد الـ API قبل البدء في كتابة كود الشبكات أو نماذج البيانات في Flutter.

---

## 2. Approved Decision

اعتمد المؤسس رسمياً الاستراتيجية التالية:

# `PROGRESSIVELY GOVERNED OPENAPI CONTRACT`

باستخدام معيار:

**OpenAPI 3.x**

كعقد خارجي كنسي وموحد وقابل للقراءة آلياً لكافة واجهات الـ API المتبادلة بين الخادم وتطبيقات الموبايل والعملاء.

### عدم تجميد الإصدار الفرعي حالياً:
الإصدار الفرعي الدقيق (سواء 3.0.x أو 3.1.x أو 3.2.x) **لم يُعتمد بعد**، وسيتم اختياره لاحقاً أثناء مرحلة التجهيز الفني بناءً على:
- توافق حزمة أدوات منظومة Dart و Flutter
- قدرات الـ Schema المطلوبة
- توافق أدوات الفحص اللغوي (Linting)
- أدوات التحقق من صحة الاستجابات (Validation tooling)
- استقرار خط أنابيب التحقق الآلي (CI stability)

---

## 3. Why Progressive Governance Was Selected

تم اختيار استراتيجية الحوكمة التدريجية للأسباب الهندسية المثبتة التالية:

1. **الحفاظ على استقرار الـ Backend الحالي وتجنب كلفة إعادة الهيكلة الباهظة**:
   موجّه الـ Backend الحالي في `backend/server/src/app.ts` مصمم كـ Procedural Request Dispatcher (أكثر من 5,300 سطر) يعمل بكفاءة على Node.js و Cloudflare Workers، ولا يكشف حالياً بيانات تعريفية تصريحية (Declarative route/schema metadata) تسمح بتوليد كنسي مباشر لـ OpenAPI وفق منهجية Code-First دون كلفة تعديل باهظة (High Migration Cost) وإعادة هيكلة جوهرية للمسارات أو بناء طبقة بيانات وصفية إضافية. وفي حين لا تثبت أدلة المستودع أن الانتقال لأطر عمل أخرى (مثل NestJS أو Hono أو Fastify) هو أمر حتمي تقنياً، فإن كلفة التعديل غير المبررة وغير الضرورية اليوم تجعل هذا الخيار مرفوضاً، مع تأكيد التزام KONFRM الصارم بعدم إعادة كتابة أو استبدال إطار عمل الخادم لمجرد توليد مواصفة OpenAPI (كما هو مثبت في البند 11).
2. **عقد قياسي فوري لتطبيقات الموبايل**:
   توفر مواصفة OpenAPI 3.x معياراً صناعياً عالمياً يمكن لأدوات الموبايل قراءته مباشرة وتوليد نماذج Dart أو التحقق منها بدقة متناهية.
3. **اعتماد تدريجي منضبط**:
   تسمح الاستراتيجية بتوثيق وحوكمة النطاقات تباعاً (Domain-by-Domain) دون الحاجة لتجميد المشروع في عملية Big-Bang طويلة.
4. **تقليل الانحراف البرمجي (Contract Drift)**:
   الربط بين مواصفة موحدة وفحوصات الـ CI يقلل بشكل ملموس من احتمالات عدم تطابق الـ DTOs بين المنصات.

---

## 4. Authority Model (نموذج المرجعية ومصدر الحقيقة)

تعتمد الاستراتيجية نموذجاً دقيقاً يفصل بين مرحلتين زمنيتين:

### أ. مرحلة التجهيز والتأسيس (Bootstrap Phase)
أثناء البناء الأولي لعقد أي نطاق API:
- **مصدر الحقيقة المعتمد هو**:
  - سلوك الـ Backend الفعلي المثبت
  - دوال تحويل الـ DTOs في الـ Backend
  - قواعد التحقق من المدخلات (Request validation)
  - هياكل الاستجابات الفعلية
  - اختبارات التكامل الآلية (Automated backend tests)
  - قواعد العمل والمنتج المعتمدة رسمياً من المؤسس
- **القاعدة الحاكمة**: يجب أن تصف وثيقة OpenAPI السلوك الفعلي المحقق. **يُمنع منعاً باتاً اختراع سلوك جديد، أو إعادة تصميم الواجهات سراً، أو تغيير كود الـ Backend فقط لجعل المواصفة تبدو أكثر تناسقاً.**

### ب. مرحلة ما بعد الاعتماد (Post-Adoption Phase)
بعد الانتهاء من توثيق النطاق واعتماده واختباره:
- يصبح عقد الـ OpenAPI الكنسي هو **العقد الخارجي المعتمد والملزم (Authoritative External Wire Contract)** لهذا النطاق.
- وثيقة العقد ليست توثيقاً خاملاً (Passive documentation)، بل مرجع حي ملزم لكافة الأطراف.
- تخضع أي تعديلات مستقبلية لقاعدة التغيير الذري.

---

## 5. Atomic API Change Rule (قاعدة التغيير الذري)

في مرحلة ما بعد الاعتماد، يُمنع تعديل واجهات الـ API الخارجية بشكل مجزأ. أي تغيير مستقبلي يمس الواجهات الخارجية يجب أن يُحدث بالتزامن في نفس التغيير / الـ PR:

```text
┌──────────────────────────────────────────────┐
│            ATOMIC CHANGE RULE                │
│                                              │
│       Canonical OpenAPI Contract             │
│                   +                          │
│         Backend Implementation               │
│                   +                          │
│          Relevant Automated Tests            │
└──────────────────────────────────────────────┘
```

ويتحقق خط الـ CI لاحقاً من مطابقة استجابات الخادم للعقد المعتمد لرفض أي انحراف (Drift) قبل الدمج.

---

## 6. What OpenAPI Governs vs What It Does NOT Govern

### ما يحكمه عقد الـ OpenAPI صراحة:
- مسارات الـ Endpoints (Paths) وطرق الـ HTTP (Methods)
- معاملات الاستعلام والمسار (Query & Path Parameters)
- هياكل حمولة الطلب (Request Payloads)
- هياكل حمولة الاستجابة (Response Payloads)
- قابلية القيم لأن تكون فارغة (Nullability)
- الحقول الإلزامية والاختيارية (Required vs Optional properties)
- القيم المحددة المكشوفة على الشبكة (Enums on the wire)
- رموز حالات الـ HTTP (Status codes)
- أغلفة وهياكل الأخطاء المحققة فعلياً (Verified error envelopes & codes)
- متطلبات المصادقة والصلاحيات (Authentication requirements)
- بيانات التوافق والإلغاء التدريجي (Deprecation metadata) عند الحاجة

### ما لا يحكمه ولا يغيره العقد إطلاقاً:
- **العقد لا يحدد ولا يعدل قواعد المنتج أو الأعمال (Product Truth)**.
- قواعد العمل تظل خاضعة حصرياً لمصادرها الأصلية المعتمدة من المؤسس، ولا يجوز لأي مواصفة أو Schema أن تصبح وسيلة لتمرير تغييرات في منطق المنتج.

---

## 7. Product Truth Safety Boundary (حدود حماية قواعد المنتج)

يلتزم العقد بترميز السلوك المعتمد فقط، ويُمنع منعاً باتاً المساس بالقواعد التالية أو إعادة تعريفها دون قرار صريح ومستقل من المؤسس:

1. **مدة الإقامة (Stay Duration)**: الحد الأدنى = **ليلتان (2 nights)**، والحد الأقصى = **30 ليلة (30 nights)**.
2. **حجز التقويم (Calendar Blocking)**:
   - حالة `PENDING_OWNER_APPROVAL` لا تحجز التواريخ.
   - حالتا `APPROVED_PENDING_PAYMENT` و `CONFIRMED` تحجزان التواريخ فعلياً.
   - فحص الإتاحة يفشل مغلقاً (Fails closed).
3. **المنظومة المالية للحجز (Financial Arithmetic)**:
   - العربون (Deposit) = **سعر الليلة الأولى الفعلي**.
   - عمولة KONFRM = **20% من مبلغ العربون فقط** (بحساب Banker's rounding HALF_EVEN في السنتات).
   - صافي العربون للمالك = **80% من مبلغ العربون**.
   - المبلغ المتبقي (Remaining balance) = **إجمالي قيمة الحجز ناقصاً العربون**.
   - العمولة على المبلغ المتبقي = **0%**.
   - طريقة تحصيل المبلغ المتبقي **قرار منتج مفتوح (OPEN Product Decision)** لم يُحسم بعد، ولا يجوز افتراضها في العقد كدفع عند الوصول أو كدفع إلكتروني.
   - المستأجر (Customer) **لا يرى إطلاقاً التقسيم المالي الداخلي أو عمولة المنصة**.
   - **لا يُسمح بأي دفع قبل موافقة المالك**.
4. **بنية الهوية (Identity Model)**:
   - مستأجر واحد = إنسان واحد بهويات محققة كنسياً (الهاتف والبريد الإلكتروني).
   - يُمنع دمج الحسابات سراً (No silent identity merges).

---

## 8. Legacy / Versioned API Coexistence (التعايش بين مسارات الـ API)

- تحافظ المنظومة على التمييز الصارم بين واجهات المصادقة المنفصلة:
  - **منظومة Auth V2 الكنسية للمستأجر (Customer)**: ومساراتها `/api/v2/auth/*`.
  - **مسارات المصادقة السابقة المستخدمة حالياً في تطبيق المالك (Owner Web)**: مثل `/api/v1/auth/request-otp` و `/api/v1/auth/verify-otp`.
- تمثل هذه المسارات أسطح مصادقة منفصلة وإصدارات مستقلة (Separate / Versioned Authentication Surfaces)، وليست انحرافاً برمجياً مباشراً في عقد نفس النقطة النهائية (Not direct wire-contract drift of the same endpoint).
- **حسم المعاملة المستقبلية لمصادقة المالك مؤجل صراحة**:
  `DEFERRED TO OWNER MOBILE / AUTH ARCHITECTURE DECISION`
  (مؤجل إلى قرار معمارية مصادقة / تطبيق المالك على الموبايل).
- لا تتضمن بوابة Gate 2 الحالية أي إعادة تصميم أو ترحيل أو دمج أو إيقاف لمصادقة المالك، ولا تفترض ما إذا كان تطبيق المالك للموبايل سيتبنى Auth V2 أو يحتفظ بـ v1 أو يدمج المنظومتين أو يعتمد إصداراً جديداً، كما لا تعدل إطلاقاً عقد Auth V2 الكنسي للمستأجر.

---

## 9. Progressive Adoption Principle (مبدأ التدرج)

- لن يتم توثيق كافة واجهات المنصة دفعة واحدة (No Big-Bang).
- سيتم ترتيب النطاقات واعتمادها تدريجياً في مراحل لاحقة بناءً على:
  - الاعتمادية التقنية (Dependencies)
  - المخاطر الأمنية (Security risk)
  - الأهمية المشتركة بين التطبيقات (Cross-client importance)
  - مخاطر تباين البيانات الحالية (Contract drift risk)
  - الاحتياج الفعلي لبناء تطبيقات الموبايل
- هذا القرار لا يحدد ولا يقفل الترتيب النهائي للنطاقات؛ هذا الترتيب يتبع تخطيط المرحلة القادمة (Gate 2B).

---

## 10. Reality of Code Generation & Drift

توضح هذه الوثيقة بمهنية هندسية منضبطة:
- اعتماد مواصفة كنسية مع حوكمة واختبارات CI يساعد في **تقليل تباين العقود بشكل ملموس (Materially reduce contract drift)**، ولكنه لا يلغي التباين حسابياً وتلقائياً.
- النماذج المولدة برمجياً (Generated models) تكون موثوقة فقط عندما:
  1. تكون المواصفة دقيقة وتصف الواقع الفعلي.
  2. تكون عملية التوليد قابلة للتكرار (Reproducible).
  3. تتم مزامنة المخرجات وتحديثها بانتظام.
  4. يتم التحقق الآلي المستمر من مطابقة الـ Backend للمواصفة.

---

## 11. Explicitly Rejected & Deferred Decisions

### قرارات مرفوضة صراحة في هذه المرحلة:
- ❌ **إعادة كتابة الـ Backend**: يُرفض رفضاً قاطعاً نقل الـ Backend إلى NestJS أو Hono أو Fastify أو tRPC أو أي إطار عمل آخر لمجرد توليد عقود الـ API كودياً.

### تفاصيل تقنية مؤجلة لمراحل التنفيذ الفني اللاحقة:
- الإصدار الفرعي الدقيق لمواصفة OpenAPI (3.0.x vs 3.1.x)
- الاسم المحدد ومسار ملف المواصفة
- اختيار حزم الفحص والتحقق (مثل Spectral أو AJV أو غيرها)
- اختيار أدوات توليد Dart (مثل openapi-generator أو swagger_parser)
- تحديد ما إذا كانت مكتبات الشبكات في Flutter ستكون يدوية أو مولدة
- حزم التحقق أثناء التشغيل (Runtime validation middleware)
- توحيد رموز الأخطاء (Error codes normalization)؛ حيث سيتم في البداية توثيق الأخطاء المحققة فعلياً كما هي.

---

## 12. Canonical Gate Ordering (ترتيب البوابات المعتمد)

يؤكد هذا القرار الترتيب المعتمد لخارطة طريق التحول للموبايل:

- **Gate 1 (مكتمل بالكامل)**: اعتماد الأساس المعماري وتبولوجيا المستودع (`KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md`).
- **Gate 2 (مكتمل بصدور هذه الوثيقة)**: اعتماد استراتيجية حوكمة عقود الـ API (`KONFRM_CANONICAL_API_CONTRACT_GOVERNANCE_V1.md`).
- **Gate 2B (المهمة القادمة)**: التخطيط التأسيسي لمواصفة الـ API وبدء التوثيق الكنسي المنضبط للنطاق الأولي.
- **Gate 3 (لاحقاً)**: مواصفة معمارية تطبيقات الموبايل وهيكلية الحزم المشتركة (`Mobile Architecture & Package Specification`).
- **Gate 4 (لاحقاً)**: اعتماد المؤسس لنطاق التجربة الأولية المنضبطة (Founder Approval of Controlled Pilot Scope).
- **Gate 5 (لاحقاً)**: تهيئة مسار الموبايل `mobile/` وبدء التطبيق الفعلي بعد موافقة المؤسس الصريحة.

---

## 13. Relationship to Canonical Authorities

تستند هذه الوثيقة وتتكامل مع:
- [`docs/architecture/KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`](./KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md)
- [`docs/architecture/KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md`](./KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md)
- [`docs/codex/KONFRM_MASTER_RULES.md`](../codex/KONFRM_MASTER_RULES.md)
- [`KONFRM_MASTER_PROJECT_CONTEXT.md`](../../KONFRM_MASTER_PROJECT_CONTEXT.md)

وهي ملزمة لجميع المطورين والوكلاء (Agents) وتمنع أي اجتهاد فردي يخالف هذه الضوابط.
