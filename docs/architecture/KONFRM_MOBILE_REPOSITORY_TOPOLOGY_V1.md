# KONFRM Mobile Repository Topology Decision — v1

**Status:** APPROVED DECISION
**Scope:** Mobile repository topology and boundary definition
**Authority:** Founder Approved
**Related Foundation:** [`docs/architecture/KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`](./KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md)
**Purpose:** تحديد تبولوجيا المستودع والحدود التنظيمية لتطبيقات الموبايل المستقبلية داخل المستودع الكنسي الموحد، مع الحفاظ الكامل على الهيكل الحالي ومنع أي إعادة هيكلة عشوائية.

---

## 1. Context & Background

بناءً على وثيقة الأساس المعماري المعتمدة ([`KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`](./KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md)) ونتائج الفحص المعماري الشامل (Forensic Architecture Audit)، كان من الضروري حسم قرار هيكلية المستودع (Monorepo vs Separate Repositories) كشرط مسبق إلزامي يسبق أي عمل مستقبلي لتهيئة بيئة العمل.

وقد استقر القرار النهائي المعتمد من المؤسس على **الإبقاء على KONFRM كمستودع كنسي موحد (Single Canonical Repository)** مع عزل تطبيقات الموبايل داخل مسار مخصص واضح.

---

## 2. Approved Decision

1. يظل مشروع KONFRM في مستودع كنسي موحد واحد (`Essxm01/KONFRM`).
2. يتم وضع تطبيقات الموبايل المستقبلية (Flutter + Dart) داخل المستودع الحالي تحت مسار مخصص هو:
   `mobile/`
3. يُعتمد هيكل التبولوجيا المستهدف التالي:

```text
KONFRM/
├── customer-app/          # Existing Customer Web — unchanged
├── owner-app/             # Existing Owner Web — unchanged
├── admin-app/             # Existing Admin Web — unchanged
├── backend/               # Existing Backend — unchanged
├── DESIGN_SYSTEM/         # Existing design knowledge — unchanged
├── docs/                  # Canonical documentation & architectural decisions
└── mobile/
    ├── customer_app/      # Future Flutter Customer application
    ├── owner_app/         # Future Flutter Owner application
    └── packages/          # Future shared Flutter packages
```

> ⚠️ **تنبيه حاسم:** هذا القرار يحدد **الحدود التنظيمية للمستودع فقط (Repository Boundary Only)**. ولا يمنح هذا القرار أي إذن أو تفويض لإنشاء مجلد `mobile/` أو تهيئة مشاريع Flutter في هذه المرحلة.

---

## 3. Why This Decision Exists

يحقق نموذج المستودع الموحد مزايا حاسمة لاستقرار وتطوير منتج KONFRM:

1. **رؤية مباشرة للـ Backend**: ارتباط مباشر بين واجهات الـ API وتطبيقات الموبايل بدون تأخير أو فجوات مزامنة.
2. **حوكمة عقود البيانات (API Contracts)**: إمكانية فحص ومزامنة عقود البيانات وتعديل الـ DTOs بسهولة داخل تاريخ Git موحد.
3. **مركزية قواعد العمل والمنتج (Business Rules)**: بقاء وثائق القواعد ومنطق العمل المالي وحالات الحجز في نفس السياق المشترك.
4. **مشاركة المعرفة التصميمية (Design Knowledge)**: وصول مباشر لرموز التصميم المشتركة (Tokens JSON) ودلائل الهوية البصرية.
5. **تنسيق إطلاق Customer و Owner**: سهولة مواءمة التحديثات المتقاطعة بين تطبيقي المستأجر والمالك.
6. **تتبع الـ CI/CD وتاريخ Git موحد**: خط أنابيب تحقق موحد وسجل تغييرات كامل وتاريخ ارتكاز غير مشتت عبر عدة مستودعات.
7. **كفاءة سياق وكلاء الذكاء الاصطناعي (AI Context)**: توفير سياق هندسي ومعماري شامل ومباشر لـ Agents بدون الحاجة للتنقل بين عدة مستودعات أو مواجهة مشاكل Submodules.

---

## 4. Architectural Rules & Invariants

تلتزم جميع عمليات التطوير المستقبلية بالقواعد الحاكمة التالية:

1. **تطبيقات منفصلة للمستخدم النهائي**:
   يظل تطبيق المستأجر (`customer_app`) وتطبيق المالك (`owner_app`) تطبيقين منفصلين ومستقلين تماماً في الواجهات وتجربة المستخدم.
2. **إمكانية مشاركة حزم تقنية لاحقاً**:
   يُسمح للتطبيقين بمشاركة حزم تقنية مشتركة داخل `mobile/packages/` متى ما كان ذلك مناسباً، بعد اعتماد هيكليتها رسمياً.
3. **عدم اعتماد هيكل الحزم المشتركة حتى الآن**:
   الهيكل الداخلي الدقيق للحزم المشتركة **لم يُعتمد بعد**. يُمنع منعاً باتاً إنشاء أو افتراض حزم محددة مثل:
   - `konfrm_core`
   - `konfrm_api`
   - `konfrm_auth`
   - `konfrm_design_system`
   - `konfrm_localization`
   هذه الأسماء مجرد أمثلة توضيحية وتتطلب قراراً وتصميماً معمارياً مستقلاً قبل إنشائها.
4. **منع نقل أو إعادة تسمية المجلدات الحالية**:
   ممنوع منعاً باتاً نقل أو تغيير مسار أي مجلد موجود حالياً في المستودع لمجرد محاولة الوصول إلى شكل ظاهري مثالي (Cosmetic perfection). تظل المجلدات التالية في أماكنها دون مساس:
   - `customer-app/`
   - `owner-app/`
   - `admin-app/`
   - `backend/`
   - `DESIGN_SYSTEM/`
5. **منع ترحيل `/apps` الجذري**:
   يُمنع نقل المجلدات إلى مجلد عام جديد مثل `/apps` أو إجراء Big-Bang monorepo restructuring.
6. **بقاء تطبيقات الويب كأصول قائمة ومعتمدة**:
   تظل تطبيقات الويب الحالية أصولاً برمجية عاملة ومصدراً أصيلاً لتوثيق تجربة المستخدم وقواعد الأعمال، ويظل تطبيق `admin-app` تطبيق ويب ديسكتوب بالكامل.
7. **الحدود الصريحة لـ `mobile/`**:
   سيشكل مجلد `mobile/` الحدود المعتمدة للتطوير الميداني لـ Flutter Production Mobile بمجرد صدور التفويض الرسمي.

---

## 5. Explicitly Prohibited Actions (Non-Authorized Scope)

هذه الوثيقة وثيقة قرار معماري فقط، ويُحظر تماماً تحت مظلتها القيام بأي مما يلي:

- ❌ إنشاء مجلد `mobile/` أو أي مجلدات فرعية له.
- ❌ إنشاء أو تهيئة مشاريع Flutter أو Dart.
- ❌ تثبيت Flutter أو Dart أو إضافة حزم dependencies.
- ❌ تعديل أي ملف في الكود الإنتاجي (Production code).
- ❌ تعديل الـ Backend أو قواعد البيانات أو ملفات الإعداد (Wrangler/Supabase/CI).
- ❌ اتخاذ قرارات تقنية مبكرة حول مكتبات إدارة الحالة (State Management) أو التوجيه (Routing) أو الشبكات (Networking) أو الأيقونات.

---

## 6. Future Gates & Execution Ordering

الترتيب المعتمد للخطوات القادمة وفق وثيقة الأساس المعماري:

1. **Gate 1 (تم الإنجاز بالكامل)**: اعتماد الأساس المعماري وتبولوجيا المستودع (`KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md`).
2. **Gate 2 (المهمة المعمارية القادمة فوراً)**: تقييم واعتماد استراتيجية حوكمة Canonical API Contract (لتحديد كيفية إنشاء وحوكمة عقد API موحد وقابل للقراءة آلياً بين الخادم وتطبيقات الموبايل).
3. **Gate 3 (لاحقاً)**: تصميم معمارية تطبيقات الموبايل وهيكلية الحزم المشتركة (`Mobile Architecture & Package Specification`).
4. **Gate 4 (لاحقاً)**: اعتماد المؤسس لنطاق التجربة الأولية المنضبطة (Founder approval of the controlled Pilot scope) بعد إنجاز معمارية الموبايل وأسس التصميم.
5. **Gate 5**: تهيئة مسار `mobile/` وبدء التطبيق العملي بعد صدور موافقة المؤسس الصريحة.

---

## 7. Relationship to Foundation Decision

تُعتبر هذه الوثيقة امتداداً وتطبيقاً مباشراً للبندين 4 و 19 من:
[`docs/architecture/KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`](./KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md)
وتلزم جميع الوكلاء (Agents) والمطورين بالعمل وفق هذه الحدود دون اجتهاد فردي.
