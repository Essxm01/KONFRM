# KONFRM Mobile Architecture Foundation Decision — v1

**Status:** APPROVED FOUNDATION  
**Scope:** Mobile architecture and design direction  
**Purpose:** تحويل KONFRM من Web Prototype-first إلى Production Mobile Product مع الحفاظ على العمل الصحيح الموجود وعدم تنفيذ Migration عشوائية.

## 1. Product Direction

KONFRM سيُبنى كمنتج Production حقيقي، وليس مجرد Prototype لتسليمه لاحقًا إلى شركة برمجية.

المؤسس هو صاحب القرار النهائي في:
- Product
- Business Rules
- Finance
- Brand
- UX direction
- Major architecture decisions

ولا يجوز لأي Agent تغيير هذه القواعد من نفسه.

---

## 2. Mobile Technology

التقنية الأساسية لتطبيقات الموبايل:

**Flutter + Dart**

وسيتم استهداف:

- iOS
- Android

من بنية مشتركة قدر الإمكان، مع السماح بالاختلافات الخاصة بكل منصة عندما تكون مطلوبة لتقديم تجربة طبيعية وصحيحة.

الهدف هو تجنب بناء تطبيق iOS ثم إعادة بناء Android من الصفر لاحقًا.

---

## 3. Mobile Applications

سيظل هناك فصل Product واضح بين:

### KONFRM Customer
تطبيق المستأجر.

### KONFRM Owner
تطبيق المالك.

هما تجربتان مختلفتان للمستخدم النهائي، ولا يتم دمجهما لمجرد استخدام نفس التقنية.

يمكنهما مشاركة البنية التقنية والمكونات المناسبة مثل:

- Design tokens
- Core utilities
- API client
- Authentication infrastructure
- Networking
- Localization
- Common validation
- Shared design primitives المناسبة

لكن UX وNavigation وBusiness flows لكل Role تظل مستقلة.

---

## 4. Admin

تطبيق الإدارة ليس Flutter Mobile ضمن القرار الحالي.

سيظل:

**Web Application**

والدومين/الـsubdomain النهائي سيتم حسمه لاحقًا.

لا يتم تنفيذ Admin redesign أو domain migration ضمن هذه المرحلة.

---

## 5. KONFRM Mobile Design System

لن يعتمد تطبيق الموبايل على BaseWeb/BaseUI كمكتبة تنفيذ.

سيتم إنشاء:

**KONFRM Mobile Design System**

ويحتوي على طبقتين أساسيتين:

### Shared KONFRM Layer

تمثل هوية ومنطق KONFRM المشترك، ومنها:

- Brand identity
- Brand colors
- Arabic-first typography
- Content hierarchy
- Spacing principles
- Product-specific components
- Trust patterns
- Booking UX
- Verification UX
- Shared states
- Accessibility principles
- RTL principles

### Platform Adaptive Layer

#### iOS
المرجع الأساسي:

**Apple Human Interface Guidelines + Cupertino/iOS platform conventions**

#### Android
المرجع الأساسي:

**Material Design 3 + Android platform conventions**

---

## 6. Platform Adaptation Principle

لا يعني استخدام Flutter أن نسختي iOS وAndroid يجب أن تكونا متطابقتين حرفيًا.

المشترك:

- Product
- Brand
- Information architecture
- Content
- Business logic
- Core interaction intent

أما العناصر التي للمستخدم توقعات Platform-specific واضحة بشأنها فيمكن أن تختلف، مثل:

- Navigation behavior
- Back behavior
- Sheets
- Dialogs
- Pickers
- Switches
- System controls
- Permissions
- Haptics
- Some transitions
- Some native interactions

الهدف:

**KONFRM واحد بهوية واحدة، لكنه يشعر بأنه طبيعي على كل منصة.**

---

## 7. Base Design System

Base لم يعد Design Authority أو Implementation Dependency لتطبيقات الموبايل.

لا يتم إدخال:

- baseui
- Styletron

إلى Flutter.

يمكن الرجوع إلى Base مستقبلًا فقط كمرجع إلهامي اختياري عند وجود مشكلة تصميم محددة تستفيد منه.

لا يجب على Agents الاعتماد عليه لبناء واجهات KONFRM.

---

## 8. Existing React/Tailwind Customer App

الـCustomer Web App الحالي:

- لا يُحذف.
- لا يُهدم.
- لا يتم تحويله بصورة عشوائية إلى Flutter.
- لا يتم اعتباره Waste.

يصبح مصدرًا مهمًا لـ:

- Product knowledge
- Existing flows
- Backend integration behavior
- Auth behavior
- Screen requirements
- UX lessons
- Existing edge cases
- Future Web capabilities where appropriate

لكن React/Tailwind implementation نفسه ليس الـMobile Production UI الجديد.

---

## 9. Existing Screens 01–18

Screens 01–18 لا يتم نسخها ميكانيكيًا إلى Flutter.

ولا يتم إعادة تصميمها جميعًا دفعة واحدة.

سيتم التعامل معها لاحقًا باعتبارها:

**Product/UX reference + behavioral specification**

ويتم نقلها تدريجيًا بعد تأسيس الـMobile Design System ونجاح Pilot.

---

## 10. Screen 19

لا يبدأ Screen 19 حاليًا.

الأولوية هي:

**Architecture + Design Foundation + Tooling + Pilot**

قبل التوسع في Screens جديدة.

---

## 11. Backend and Database

التحول إلى Flutter لا يعني إعادة بناء Backend.

الحالة الحالية للـBackend وSupabase والـAPI وAuth V2 والـBusiness Rules يجب الحفاظ عليها ما لم يكشف Audit مستقل عن ضرورة تغيير محددة.

أي تغيير Backend لاحق يجب أن يكون:

- deliberate
- scoped
- backward-impact reviewed
- security reviewed
- tested

لا يجوز تغيير الـBusiness Logic لمجرد تسهيل Flutter implementation.

---

## 12. Windows-First Development

المؤسس لا يملك Mac حاليًا.

لذلك يجب تصميم Workflow التطوير ليعمل أساسًا من:

**Windows**

بدون اشتراط شراء Mac أثناء التطوير اليومي.

سيستخدم Windows في:

- Flutter/Dart development
- Android development
- Hot Reload
- Component development
- Responsive previews
- Automated tests
- Visual QA
- Golden tests

---

## 13. iOS Development Constraint

أي iOS Production Build حقيقي يحتاج في مرحلة ما إلى macOS/Xcode.

لكن Xcode لن يكون أداة مراجعة UI اليومية.

Workflow المشروع يجب أن يقلل الاعتماد على macOS المدفوع قدر الإمكان.

يتم استخدام macOS/iPhone الحقيقي عند:

- iOS-specific integration verification
- Native plugin verification
- Signing/build verification
- Important milestone QA
- TestFlight
- App Store release

وليس لكل تعديل بصري صغير.

---

## 14. iOS Visual QA on Windows

لا يتم الادعاء بأن Android Emulator هو iPhone Simulator.

بدلًا من ذلك، سيتم لاحقًا إنشاء:

**Controlled iOS Device Preview Profiles**

بأبعاد Logical Viewports وSafe Areas محددة.

يجب اختبار الواجهات على Device Matrix وليس جهازًا واحدًا فقط.

ثم يبقى iPhone الحقيقي Reality Gate إلزاميًا قبل اعتماد Releases المهمة.

---

## 15. Android QA

Android سيستخدم:

- Android Emulator
- Material 3
- Android platform behavior

مع الاختبار لاحقًا على أجهزة Android حقيقية قبل Production release.

---

## 16. Visual Quality Principle

Build ناجح لا يعني أن UI ناجح.

أي Mobile UI مهم سيخضع مستقبلًا إلى workflow من نوع:

REFERENCE  
→ COMPONENT MAPPING  
→ STATE MATRIX  
→ RTL PLAN  
→ RESPONSIVE PLAN  
→ ACCESSIBILITY PLAN  
→ IMPLEMENTATION  
→ SCREENSHOT QA  
→ FIX  
→ REAL DEVICE CHECK عند الحاجة  
→ FOUNDER GATE

---

## 17. AI Agents

لا يبدأ الآن تثبيت Skills عشوائية.

يتم اختيار Skills بعد تثبيت:

- Architecture
- Design system requirements
- QA requirements
- Flutter toolchain

الـSkills المستقبلية يجب أن تخدم احتياجات حقيقية مثل:

- Flutter/Dart
- Apple HIG
- Material 3
- Mobile UX
- Arabic/RTL
- Accessibility
- Visual QA
- Testing
- KONFRM Product Rules
- Release discipline

ويُفضّل أن تكون مصادر الحقيقة الأساسية Repository-local لتجنب اختلاف القواعد بين Agents.

---

## 18. Cost Principle

الهدف أثناء مرحلة التطوير:

**New mandatory tooling cost ≈ $0 قدر الإمكان.**

لا يتم شراء أداة أو Subscription إلا عندما:

1. توجد مشكلة محددة.
2. البديل المجاني غير كافٍ.
3. نعرف الفائدة المباشرة.
4. المؤسس يوافق على التكلفة.

---

## 19. Migration Strategy

ممنوع تنفيذ Big-Bang Rewrite.

الترتيب المعتمد:

1. Foundation decision
2. Read-only repository audit
3. Mobile architecture design
4. Design foundation
5. Canonical Flutter primitives
6. Agent rules/skills/tooling
7. One controlled pilot
8. Founder evaluation
9. Progressive migration
10. Resume feature expansion

---

## 20. Immediate Next Gate

بعد اعتماد هذه الوثيقة، الخطوة التالية ليست كتابة Flutter code.

الخطوة التالية:

**KONFRM MOBILE MIGRATION FORENSIC AUDIT — READ ONLY**

والهدف منه تحديد:

- ما الذي نحتفظ به كما هو؟
- ما الذي يمكن مشاركته؟
- ما الذي هو Web-specific؟
- ما الذي يحتاج إعادة تنفيذ في Flutter؟
- أين توجد dependencies خطرة؟
- ما تأثير التحول على Customer وOwner وBackend؟
- ما الذي يجب ألا نلمسه؟

لا يسمح للـAgent في هذه المهمة بتعديل أي ملف أو إنشاء Migration أو بدء Flutter project.
