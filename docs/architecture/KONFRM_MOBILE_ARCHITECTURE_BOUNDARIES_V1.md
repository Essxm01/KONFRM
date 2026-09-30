# KONFRM Mobile Architecture Boundaries Specification — v1

**Status:** CANONICAL SPECIFICATION (Gate 3B)
**Scope:** Future `mobile/customer_app`, `mobile/owner_app`, and `mobile/packages` architecture boundaries
**Authority:** Founder-authorized Gate 3B synthesis of the Gate 3A advisory investigation
**Upstream decisions (do not reopen):**

- [`KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md`](./KONFRM_MOBILE_ARCHITECTURE_FOUNDATION_V1.md) — Flutter + Dart, Customer/Owner separation, Admin stays Web, platform-adaptive design direction
- [`KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md`](./KONFRM_MOBILE_REPOSITORY_TOPOLOGY_V1.md) — single canonical repository, `mobile/` boundary only (no Flutter workspace initialization in Gate 3)
- [`KONFRM_CANONICAL_API_CONTRACT_GOVERNANCE_V1.md`](./KONFRM_CANONICAL_API_CONTRACT_GOVERNANCE_V1.md) — progressive OpenAPI adoption (`docs/api/openapi.yaml`, OpenAPI 3.0.4)

**Purpose:** تحديد الحدود المعمارية الكنونية للتطبيقات المحمولة المستقبلية وحزمها المشتركة قبل تهيئة أي كود Flutter، بحيث تُبنى التطبيقات لاحقًا ضمن حدود واضحة دون إعادة فتح قرارات معتمدة ودون تحويل مرشحات التنفيذ إلى حقائق منتج.

---

## 1. Architecture Principles

1. **Feature-first, thin layers.** كل ميزة كبيرة تحتوي `presentation/` و`application/` و`data/`. لا تُفرض طبقة `domain/` إلزامية؛ قد توجد نماذج موجهة للتطبيق حيث تقدم قيمة حقيقية، لكن يُمنع احتفال Clean Architecture الكامل (Use Case لكل endpoint، repository interfaces للمجردة فقط).
2. **Backend is the domain authority.** تطبيقات الموبايل عملاء عرض فوق HTTP canonical؛ لا تُكرر قواعد العمل كمنطق محلي موثوق. أي تحقق محلي (طول الاسم، صيغة الهاتف) هو تحقق مرآتي لتحسين UX فقط وليس مصدر حقيقة.
3. **Widgets own no product/business logic.** منطق المنتج يعيش في state containers قابلة للاختبار؛ الـwidgets تعرض وتستدعي intentions.
4. **Repositories/adapters own remote data.** كل تفاعل بيانات بعيدة يمر عبر adapter داخل `data/` الميزة أو عبر `konfrm_api` — لا استدعاء HTTP من الـwidgets.
5. **Explicit truthful states.** كل سطح قانوني يعرض حالات صريحة (loading/empty/content/error/session-expired) ولا يخترع نجاحًا أو بيانات بديلة. فشل persistence يُعلن بصدق.
6. **Smallest architecture that survives growth.** لا حزمة ولا طبقة ولا واجهة قبل ظهور حاجتها الفعلية (قاعدة الاستخراج المؤجل).
7. **Server-derived identity and authorization boundaries** تُحفظ كما هي: الموبايل لا يقرر ملكية أو دورًا بنفسه؛ يقدم الرموز ويحترم الردود.

---

## 2. Customer App Structure (`mobile/customer_app`)

```text
lib/
├── main.dart                    # composition root: env, session restore, router, theme
├── app/
│   ├── router/                  # go_router configuration + auth-gate redirects
│   ├── bootstrap/               # cold-start, session restoration, fail-closed startup
│   └── theme/                   # composition of konfrm_design_system
└── features/
    ├── auth/                    # Auth V2: challenge entry, OTP, account creation,
    │   ├── presentation/        #   session-expired recovery. App-specific: MUST NOT
    │   ├── application/         #   leak into Owner or shared packages.
    │   └── data/                #   clients for /api/v2/auth/* + /api/v1/auth/*
    ├── discovery/               # Explore: coastal search, refine, results, property detail
    ├── favorites/               # server-authoritative favorites (undo/delete race safety)
    ├── bookings/                # bookings list, stay hub, deposit-payment presentation
    └── account/                 # account hub, personal data, notifications, payments view
```

قواعد خاصة بالعميل:

- **Auth V2 كامل داخل `features/auth`:** التدفقات (challenges/verify/resend/cancel، registration/complete، continuation → Screen-10 full-name) عميل-خاصة ولا تُستخرج لحزمة مشتركة.
- **الحجوزات والدفع حالة عرض:** تطبيق الموبايل يعرض الحالات القانونية؛ لا سلطة مالية محلية ولا مزود دفع يُقرر في Gate 3.
- **المفضلة والحجوزات:** أنماط الويب المثبتة تُهاجر كعقود سلوك (server-authoritative reads، منع إحياء المحذوف قبل تأكيد الخادم، fail-closed 401/403 يمسح الحالة الخاصة فقط) — لا ككود منسوخ من App.tsx.

## 3. Owner App Structure (`mobile/owner_app`)

```text
lib/
├── main.dart
├── app/                         # router (dashboard-style, بدون bottom-nav عميل)
└── features/
    ├── auth_boundary/           # دخول Owner عبر نقاط v1 القائمة كما هي
    ├── dashboard/               # action-first home (pending requests, upcoming stays)
    ├── properties/              # wizard, media, out-of-order-safe revalidation
    ├── availability/            # calendar toggle-block
    ├── bookings/                # approve/reject + presentation of financial summary
    └── payouts/                 # wallet + ledger read-only presentation
```

قواعد خاصة بالمالك:

- **auth_boundary فقط:** أي إعادة تصميم مصادقة Owner (بما فيها "Owner Auth V2") **مؤجلة رسميًا** ولا يجوز لهذه المواصفة أن تفترضها أو تبني لها.
- **revalidation lifecycle:** نمط الويب المثبت (property-scoped revalidation عند focus/visibility مع حماية out-of-order) هو العقد السلوكي لشاشات الملكية.
- **Payouts/wallet:** قراءة وعرض فقط؛ لا حسابات عمولات أو صافي مالك محلي (القواعد المالية server-authoritative).

## 4. Shared Package Boundaries (`mobile/packages`)

أربع حدود منطقية معتمدة. **لا تُنشأ في Gate 3** — تُنشأ عند تهيئة الـworkspace لاحقًا وفق هذه المسؤوليات بالضبط:

### 4.1 `konfrm_core`

- **يملك:** تجريدات البيئة/config (base URL لكل بيئة، أعلام قراءة فقط مثل بوابة `CUSTOMER_EMAIL_LINKING_ENABLED`)، أنواع الفشل/الخطأ الأساسية، عقود تسجيل مُنقَّح (redacted logging — ممنوع تسجيل الرموز أو بيانات التعريف الحساسة إطلاقًا)، أنواع مساعدة صغيرة (Result).
- **قيود:** Dart خالص بلا Flutter UI ولا مكتبة نقل شبكي (النقل في konfrm_api)؛ لا يعتمد أي حزمة KONFRM أخرى.

### 4.2 `konfrm_api`

- **يملك:** تجريد النقل HTTP (تنفيذ أولي خلف `package:http` — انظر §7)، تحليل مغلف الاستجابة القانوني (`success/data/timestamp`)، حدود wire DTO، adapters نقاط النهاية، تصنيف الأخطاء الشبكية إلى أنواع konfrm_core، حماية الاستجابات المتأخرة (out-of-order guard).
- **قيود:** لا يعرف مفاهيم Customer/Owner (مجرد نقاط نهاية وتغليف)؛ ممنوع الاعتماد على konfrm_session مباشرة — عبر واجهة TokenProvider تُحقن في الـcomposition root.

### 4.3 `konfrm_session`

- **يملك:** حدود persistence آمنة لاعتمادات الجلسة، تنسيق refresh أحادي الطيران، revoke/logout، حالة جلسة قابلة للمراقبة (explicit states)، فضاءات اعتماد معزولة لكل دور.
- **قيود:** يقدم واجهة TokenProvider لـkonfrm_api؛ ممنوع عليه معرفة تدفقات Auth V2 (تدفقات العميل في `customer_app/features/auth`) أو أي User interface — رموز وأدوار مجهولة الهوية.

### 4.4 `konfrm_design_system` (reserved boundary ONLY)

- **الحد المعماري فقط في Gate 3:** ستكون الحزمة نقطة تركيب الثيم والـwidgets المشتركة والـRTL/Cairo والـl10n infra.
- **غير محسوم هنا، ويُحسم في Design Foundation workstream:** الرموز النهائية، الألوان، نصف الأقطار، سلّم الطباعة، كتالوج الـcomponents، قرارات Base المشتقة، وقواعد RTL التفصيلية، وKONFRM AI Design Skills.
- **ليس قرارًا في Gate 3:** `DESIGN_SYSTEM/TOKENS/*.json` الحالية (الويب) ليست تلقائيًا رموز Flutter الكنونية؛ إعادة الاستخدام قرار لاحق في Design Foundation.

### 4.5 ممنوع صراحة في Gate 3

- حزمة shared-models عامة (`konfrm_models`) — DTOs تعيش داخل `data/` الميزات، والمشترك = مغلف الاستجابة وأنواع konfrm_core فقط.
- حزمة `konfrm_testing` مستقلة — أدوات الاختبار تبقى محلية حتى يثبت التكرار المستقر حاجة الاستخراج.

## 5. Dependency-Direction Rules

```text
customer_app ──┐
               ├──► konfrm_api ──► konfrm_core ◄── konfrm_session
owner_app ─────┘        │                             ▲
                        └──(TokenProvider interface)──┘
apps ──► konfrm_design_system ──► konfrm_core
```

1. الرسم لا دوري (acyclic)؛ `konfrm_core` جذر لا يعتمد على أحد.
2. ممنوع: package → app، package → package خارج الواجهات المصرح بها (§4)، app → app.
3. `konfrm_api` لا يستورد `konfrm_session`؛ الربط عبر واجهة TokenProvider تُكتب في konfrm_api وتُنفذ في konfrm_session وتُحقن عند bootstrap.
4. الميزات لا تستورد بعضها مباشرة؛ التقاطع عبر navigation routes فقط.
5. لا UI في core/session/api.

## 6. State Architecture

**معتمد:**

- **Riverpod** هو حل الحالة/التركيب على مستوى التطبيق.
- **بدون codegen** في البداية (`riverpod_generator` مؤجل).
- `setState`/`ValueNotifier` للحالة العابرة المحلية genuinely-local.
- حالة Auth/Session بـ**explicit, testable states** (sealed classes / immutable states): session = authenticated/expired/anonymous كما حددتها konfrm_session؛ آلة Auth V2 صريحة (draft → challenge issued → verifying → continuation → registering → session) بأكواد أخطاء العقد.
- حالة كل تبويب طويلة العمر تنجو من التنقل (متطلب تنقل §8).
- revalidation واعية بالـlifecycle مع حماية out-of-order لكل قراءة قانونية.

**ممنوع:** BLoC/Cubit، Redux، event buses، GetIt، أو أي إطار DI/حالة ثانٍ إلى جانب Riverpod.

## 7. Network Transport

- **`package:http`** هو مرشح التنفيذ الأولي، **خلف واجهة نقل يملكها KONFRM** (`konfrm_api`).
- ممنوع على أي كود feature/UI الاعتماد مباشرة على أنواع `http`.
- **Dio مؤجل:** لا يُدخل إلا إذا أثبت مطلب لاحق ملموس حاجة متقدمة (إلغاء دقيق، progress، interceptors معقدة) تبرر الاعتماد الإضافي.
- **لا أرقام timeouts كنسية في Gate 3** — تُحدد وتُختبر لاحقًا ضمن ميزانية الشبكة الفعلية لكل بيئة.

## 8. Routing Architecture

**معتمد: `go_router`.**

- **Customer:** متطلبات التنقل الموثقة (bottom nav بأربعة وجهات: استكشف/المفضلة/حجوزاتي/الحساب، مع بقاء حالة كل مسار مستقلًا) **تقتضي حزم تنقل مستقلة محفوظة** — أي أن `StatefulShellRoute` هو النمط المطلوب هنا، مفروضًا من المتطلب لا من التفضيل.
- **Owner:** nested routing dashboard-style بدون bottom nav.
- يدعم: auth gates (redirect مربوط بحالة konfrm_session)، تدفقات متداخلة، تدفقات modal/full-screen (تدفقات Auth V2 كـfull-screen routes؛ الفلاتر/النوافذ السفلية كـsheets)، restoration.
- **Deep links خارجية:** البنية محفوظة، لكن لا rollout خارجي في هذه المرحلة (DEFERRED) ولا hardcode لتفاصيلها.

## 9. API / OpenAPI Boundary

- التبني **تدريجي**: الشريحة القانونية الحالية هي Customer Authentication & Session Lifecycle فقط؛ باقي الدومينات تبقى بخاصية verified handwritten adapters حتى تصبح عقودها canonical.
- **ممنوع توليد كود Dart في Gate 3.** التكامل الأولي handwritten wire DTOs/adapters.
- لاحقًا (بعد تهيئة الـworkspace): **bounded generator spike** لتقييم توليد DTO فقط مقابل الدومينات المتبناة. إن دخل التوليد: تبقى أنواعه **حصرًا داخل حد API/wire**، وممنوع على UI/application state الاعتماد المباشر على أنواع wire مولدة (تُحوَّل إلى نماذج عرض داخل data/).
- سكربتات lint/عقد OpenAPI الحالية (redocly + authSessionOpenapiContract) تبقى مرجع الامتثال عند تبني شرائح جديدة.

## 10. Session Lifecycle

**حقيقة الباكند الحالية (مدخلات ثابتة للتصميم):**

- Access token عمره **900 ثانية**؛ refresh token موقّع بعمر **7 أيام**.
- `/api/v1/auth/refresh` يتحقق من refresh token القائم ويعيد **access token جديد فقط** — **لا يدير (rotate) الـrefresh token**.

**القواعد الكنونية:**

1. **Refresh coordinator أحادي الطيران (single-flight):** طلب refresh واحد قيد التنفيذ كحد أقصى؛ المتزامنون ينتظرون نفس النتيجة — منع سباقات refresh المتوازية وانتقالات جلسة غير متسقة.
2. **لا يُدّعى أي revoke/rotate تلقائي للـrefresh token** عند التزامن — الباكند لا يفعل ذلك اليوم.
3. **لا إعادة تشغيل (replay) عامة لكل طلب بعد refresh.** إعادة المحاولة التلقائية مسموحة **فقط** عندما تجعل دلالات العملية ذلك آمنًا (قراءات وعمليات idempotent). **ممنوع منعًا باتًا** الـreplay العام لـ: إنشاء challenge، تحقق OTP، إنشاء حجز، بدء دفع، موافقة/رفض، أو أي mutation غير idempotent.
4. **Logout يمسح الاعتمادات المحلية حتى لو فشل الـrevoke البعيد** (يُسجل الفشل، لا يُحتجز الخروج عليه).
5. **اعتمادات التحديث الحساسة تُخزن فقط عبر تجريد secure-storage محمي بنظام التشغيل.** الـaccess token يجوز أن يبقى في الذاكرة ويُعاد إنشاؤه عبر refresh عند الإقلاع البارد.
6. **فضاءات اعتماد معزولة:** مخازن مفاتيح/namespace منفصل تمامًا بين Customer وOwner.
7. **secure storage:** `flutter_secure_storage` مرشح التنفيذ الرائد — **ليس ضمانة منصة نهائية لـGate 3**. تُحدد المتطلبات (تشفير على مستوى نظام التشغيل، عدم التسرب في backups غير مشفرة، إبطال عند إلغاء تثبيت التطبيق حسب المنصة) بدل أعلام Keychain/Keystore سابقة لأوانها؛ تُتحقق الإعدادات الأصلية النهائية في بوابات الجهاز الحقيقية (Android/iOS) لاحقًا.
8. **ممنوع إدخال أسرار خادم** (service-role، مفاتيح توقيع JWT، أسرار دفع) في أي من التطبيقين.

## 11. Error / Retry / Offline

- **يُحفظ `error.code` من الباكند** كمعرف مستقر.
- تصنيف إلزامي للفشل: transport/offline، timeout، canonical server error، auth/session error، parsing/schema error — أنواع مختلفة لأنواع konfrm_core.
- **نصوص رسائل الباكند الخام ليست copy واجهة معتمدًا.** طبقات feature تُجاز الرموز الكانونية المستقرة إلى copy عربي محلي، مع fallback آمن لغير المتوقع.
- **لا قائمة انتظار mutations للعمل offline. لا سلطة مالية محلية.**
- القراءات فقط يجوز أن تدعم retries محدودة endpoint-specific لحالات عابرة.

## 12. Environment / Secrets Boundary

- konfrm_core يملك قراءة config لكل بيئة (dev/QA/production base URLs)؛ الأعلام ميزة قراءة فقط على الموبايل.
- الأسرار تنتمي للباكند/CI (Cloudflare Workers env) — الموبايل يحمل إعدادات عميل عامة فقط (base URLs).
- Logging مُنقَّح: عقود redaction في konfrm_core إلزامية منذ أول سطر تسجيل (لا رموز، لا OTP، لا بيانات تعريف كاملة).

## 13. Design / RTL / Accessibility Hook

**تحفظ المعمارية الدعم لـ** (بدون تثبيت التفاصيل هنا — Workstream Design Foundation):

- Arabic-first RTL، خط Cairo، direction-aware layout primitives.
- أسس Material 3 + سلوك iOS أصبي مناسب (رجوع، sheets، حركات).
- text scaling، VoiceOver/TalkBack semantics، أهداف لمس ≥44px منطقية.
- بنية تحتية للـvisual-regression مستقبلًا.
- KONFRM AI Design Skills مستقبلًا (نقطة تركيب في konfrm_design_system).
- **ممنوع في هذا PR:** تثبيت رموز/ألوان/أنصاف أقطار/components/خرائط Base؛ وإعلان `DESIGN_SYSTEM/TOKENS` الويب كنونية Flutter تلقائيًا.

## 14. Platform Validation Boundary

**تحقق Windows/Android لا يساوي قبول iOS.** يوثق كمتطلب لاحق إلزامي:

- macOS/Xcode build validation، iOS Simulator، وأجهزة حقيقية للتحقق من: plugins الأصلية، Keychain/session persistence عبر الأقفال والإقلاع، lifecycle (background/foreground)، إمكانية الوصول، text scaling، safe areas، وسلوك التنقل.
- بوابات الجهاز الحقيقية (Android + iOS) هي موقع التحقق النهائي لإعدادات secure-storage الأصلية (§10.7).

## 15. Test Strategy

1. **وحدات state:** كل controller/state machine يُختبر بمعزل (Riverpod overrides) — حالات صريحة ونهايات fail-closed.
2. **عقد طبقة API:** adapters ضد أخطاء/نجاحات مُحاكية بالتغليف القانوني + تطبيع JSON (omitted ≠ null كما في اختبار عقد الباكند).
3. **session:** single-flight refresh (تزامن)، انتهاء 900s، فشل revoke عند logout، عزل الفضاءات.
4. **widgets:** اختبارات ذهبية أساسية للحالات القانونية الصريحة (لا مطاردة pixel).
5. **لا شبكة حقيقية في اختبارات الوحدة**؛ mock transport خلف واجهة konfrm_api.
6. الأدوات محلية لكل حزمة/تطبيق حتى يثبت استحقاق استخراج konfrm_testing (§4.5).

## 16. Forbidden Patterns

1. طبقة domain/use-cases احتفالية، أو repository interface لكل endpoint بلا مستهلكين متعددين.
2. منطق عمل/منتج داخل widgets.
3. اعتماد feature/UI مباشر على أنواع `http` أو Dio.
4. إطار حالة/DI ثانٍ (BLoC/Redux/GetIt/event bus) إلى جانب Riverpod.
5. كود توليد OpenAPI داخل Gate 3، أو تسرب أنواع wire مولدة إلى UI.
6. replay عام لـmutations غير idempotent (حجز/دفع/auth) بعد refresh أو فشل شبكة.
7. offline mutation queue أو سلطة مالية محلية.
8. تسجيل غير منقَّح (رموز/OTP/PII) في أي log.
9. أسرار خادم داخل الموبايل؛ تخزين refresh token خارج تجريد secure-storage.
10. خلط فضاءات اعتماد Customer/Owner.
11. إعادة فتح: منفصلية المستودع، apps/*، حذف تطبيقات الويب، Admin Flutter.
12. إنشاء `mobile/` أو أي كود Flutter ضمن Gate 3.

## 17. Deferred Decisions (غير محسومة هنا)

Owner Auth V2/إعادة تصميم دخول Owner؛ مزود الدفع وموبايل checkout وPaymob كاستراتيجية؛ تحصيل الرصيد المتبقي؛ سياسة الإلغاء/الاسترداد؛ نطاق Pilot؛ مزود push notifications؛ مزود crash reporting؛ rollout الروابط العميقة الخارجية؛ الرموز النهائية وسلّم الطباعة وكتالوج components وخرائط Base (Design Foundation)؛ الأرقام النهائية للشبكة (timeouts)؛ توليد DTO (spike لاحق)؛ konfrm_testing كحزمة.

---

## 18. Decision Classification

### CANONICAL NOW (ملزم لكل عمل مستقبلي)

1. feature-first مع presentation/application/data داخل كل ميزة؛ لا domain layer إلزامية.
2. Riverpod (بلا codegen مبدئيًا) + explicit testable auth/session states؛ حظر أطر الحالة الموازية.
3. go_router للتوجيه؛ Customer bottom-nav باستقلال حزم محفوظ (StatefulShellRoute مفروض بالمطلب)؛ auth gates على حالة الجلسة.
4. الحدود الأربع: konfrm_core / konfrm_api / konfrm_session / konfrm_design_system (reserved) بمسؤوليات §4 حرفيًا.
5. قواعد اتجاه الاعتماد (§5) اللا دورية، بما فيها فصل api/session عبر TokenProvider.
6. `package:http` خلف واجهة نقل يملكها KONFRM؛ حظر تبعية feature المباشرة.
7. قواعد الجلسة §10 بالكامل (single-flight، لا rotate ادعاءً، replay الآمن فقط، logout ينجح محليًا دائمًا، secure-storage abstraction، عزل الفضاءات).
8. أرشيتكتورة الأخطاء (حفظ code، فصل أنواع الفشل، copy محلي بالتجاز) وقواعد retry/offline §11.
9. حد API/OpenAPI (handwritten أولاً، التوليد spike مؤجل داخل حد wire).
10. حدود التصميم (§13): الحجز المعماري فقط — التفاصيل لـDesign Foundation.
11. حد التحقق Windows/Android ≠ iOS (§14) كمتطلب لاحق إلزامي.
12. الأنماط المحظورة (§16).

### IMPLEMENTATION CANDIDATE (مرشح تنفيذ — ليس حقائق منتج)

1. `flutter_secure_storage` كتنفيذ أول لحد secure-storage (يُثبت في بوابات الجهاز).
2. `package:http` كتنفيذ الواجهة (قابل للاستبدال خلفها).
3. melos/Dart workspace لإدارة الحزم عند التهيئة.
4. توليد DTO بعد spike محدود ضد الدومينات المتبناة.
5. استخراج konfrm_testing إذا ثبت تكرار مستقر.

### DEFERRED (قرارات مؤجلة لمصدرها الصحيح)

1. Owner Auth V2 / إعادة تصميم مصادقة Owner.
2. مزود الدفع، موبايل checkout، Paymob، remaining-balance، الإلغاء/الاسترداد.
3. نطاق Pilot.
4. مزود push notifications ومزود crash reporting.
5. Deep links خارجية.
6. الرموز النهائية/typography/components/خرائط Base (Design Foundation workstream).
7. أرقام timeouts النهائية.

---

## 19. Dependency Diagram

```text
                    ┌────────────────────────────┐
                    │  mobile/customer_app       │
                    │  features(auth,discovery,  │
                    │  favorites,bookings,       │
                    │  account) + app/router     │
                    └──────┬──────────┬──────────┘
                           │          │
              ┌────────────▼──┐   ┌───▼──────────────────────┐
              │ konfrm_api    │   │ konfrm_design_system     │
              │ transport(envelope,          │ (reserved: theme/widgets │
              │ DTO boundary, adapters)      │  Cairo/RTL/l10n — Design │
              └──┬─────────┬──┘   │  Foundation decides)     │
   TokenProvider │         │      └────────┬─────────────────┘
   (interface)   │         │               │
        ┌────────▼───┐ ┌───▼────────┐      │
        │konfrm_sess.│ │ konfrm_core │◄────┘
        │single-flight│ │ env|errors │
        │refresh,revok│ │redacted log│
        └────────────┘ └────────────┘
                    ┌────────────────────────────┐
                    │  mobile/owner_app          │
                    │  auth_boundary(v1 as-is),  │
                    │  dashboard, properties,    │
                    │  availability, bookings,   │
                    │  payouts                   │
                    └──────┬──────────┬──────────┘
                           │          │
                    (نفس حواف api/design_system/core)

قواعد الرسم: أسهم apps→packages وpackages→core فقط؛
api ──✗──► session مباشرة (عبر TokenProvider interface)؛
لا دورات؛ لا حزمة ترى ميزة؛ لا ميزة ترى ميزة (عبر routes فقط).
```

---

## 20. Relationship to Existing Documents

- لا يلغي ولا يعيد تفسير FOUNDATION_V1 أو TOPOLOGY_V1؛ يبني عليهما مباشرة (Flutter/Dart، التبولوجيا، فصل الأدوار، اتجاه التصميم platform-adaptive).
- يحدّث عمليًا توصية Gate 3A الاستشارية حيث خالفها هذا التوليف المعتمد: أربع حزم (لا خمس — لا konfrm_testing)، تسمية `konfrm_api`، Riverpod بلا codegen مبدئيًا، و`package:http` خلف واجهة. في التعارض، هذه المواصفة (Gate 3B) هي الكنونية.
