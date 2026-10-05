import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() => runApp(const KonfrmValidationApp());

class KonfrmValidationApp extends StatelessWidget {
  const KonfrmValidationApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'KONFRM — مختبر النظام التصميمي',
    debugShowCheckedModeBanner: false,
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: konfrmLightTheme(),
    home: const ValidationCatalog(),
  );
}

const scenarioSections = [
  'النص',
  'الإجراءات',
  'الحقول',
  'RTL وBidi',
  'الحالات',
  'التجميع',
  'تنقل العميل',
  'الإجراء الثابت',
];

class ValidationCatalog extends StatefulWidget {
  const ValidationCatalog({super.key});
  @override
  State<ValidationCatalog> createState() => _ValidationCatalogState();
}

class _ValidationCatalogState extends State<ValidationCatalog> {
  int section = 0;
  int selectedDestination = 0;
  double scale = 1;
  final searchController = TextEditingController(text: '');
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: Scaffold(
      appBar: AppBar(title: const Text('مختبر KONFRM'), centerTitle: false),
      body: SafeArea(
        child: Column(
          children: [
            const _LabDisclosure(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var i = 0; i < scenarioSections.length; i++)
                    ChoiceChip(
                      label: Text(scenarioSections[i]),
                      selected: section == i,
                      onSelected: (_) => setState(() => section = i),
                    ),
                ],
              ),
            ),
            if (section == 0)
              _ScaleControls(
                scale: scale,
                onChanged: (value) => setState(() => scale = value),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    scenarioSections[section],
                    style: KonfrmTypography.pageTitle,
                  ),
                  const SizedBox(height: 16),
                  _scenarioContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation is shown only in its dedicated scenario. The sticky
      // action scenario is a separate selected section and never coexists.
      bottomNavigationBar: section == 6
          ? CustomerBottomNavigation(
              selectedIndex: selectedDestination,
              onSelected: (i) => setState(() => selectedDestination = i),
            )
          : section == 7
          ? const StickyActionSurface(
              child: PrimaryButton(label: 'متابعة الإجراء', onPressed: _noop),
            )
          : null,
    ),
  );

  Widget _scenarioContent() => switch (section) {
    0 => const _TypographyScenario(),
    1 => const _ActionScenario(),
    2 => _InputScenario(controller: searchController),
    3 => const _BidiScenario(),
    4 => const _StatesScenario(),
    5 => const OwnerActionScenario(),
    6 => const _NavigationScenario(),
    _ => const _StickyScenario(),
  };
}

class _LabDisclosure extends StatelessWidget {
  const _LabDisclosure();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Text(
      'بيانات مختبر فقط — LAB_SCENARIO_DATA. لا تمثل بيانات أو نتائج إنتاجية.',
      style: KonfrmTypography.supporting,
    ),
  );
}

class _ScaleControls extends StatelessWidget {
  const _ScaleControls({required this.scale, required this.onChanged});
  final double scale;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Wrap(
      spacing: 8,
      children: [
        for (final value in [1.0, 1.25, 1.5, 2.0])
          ChoiceChip(
            label: Text('${(value * 100).round()}%'),
            selected: scale == value,
            onSelected: (_) => onChanged(value),
          ),
      ],
    ),
  );
}

class _TypographyScenario extends StatelessWidget {
  const _TypographyScenario();
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'العربية الواضحة تبدأ من التسلسل الهرمي',
        style: KonfrmTypography.display,
      ),
      SizedBox(height: 12),
      Text('عنوان الصفحة', style: KonfrmTypography.pageTitle),
      SizedBox(height: 8),
      Text('عنوان القسم', style: KonfrmTypography.sectionTitle),
      SizedBox(height: 8),
      Text('عنوان مجموعة', style: KonfrmTypography.cardTitle),
      SizedBox(height: 8),
      Text(
        'نص توضيحي لاختبار قراءة العربية والتفاف المحتوى عند التكبير.',
        style: KonfrmTypography.body,
      ),
      SizedBox(height: 8),
      Text(
        '1,600 ج.م — أرقام المثال هنا ليست بيانات فعلية',
        style: KonfrmTypography.numeric,
      ),
    ],
  );
}

class _ActionScenario extends StatelessWidget {
  const _ActionScenario();
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PrimaryButton(label: 'متابعة', onPressed: _noop),
      SizedBox(height: 12),
      SecondaryButton(label: 'إلغاء', onPressed: _noop),
      SizedBox(height: 12),
      PrimaryButton(
        label: 'جارٍ الإرسال',
        onPressed: _noop,
        phase: ActionPhase.submitting,
      ),
      SizedBox(height: 12),
      PrimaryButton(label: 'غير متاح', onPressed: null),
      SizedBox(height: 12),
      IconActionButton(
        icon: Icons.arrow_back,
        semanticLabel: 'رجوع',
        onPressed: _noop,
        directional: true,
      ),
      SizedBox(height: 12),
      IconActionButton(
        icon: Icons.close,
        semanticLabel: 'إغلاق',
        onPressed: _noop,
      ),
    ],
  );
}

void _noop() {}

class _InputScenario extends StatelessWidget {
  const _InputScenario({required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const InputField(label: 'الاسم', helper: 'اكتب الاسم كما يظهر لك'),
      const SizedBox(height: 16),
      PhoneField(label: 'رقم الهاتف'),
      const SizedBox(height: 16),
      const InputField(
        label: 'بريد إلكتروني',
        keyboardType: TextInputType.emailAddress,
        textDirection: TextDirection.ltr,
        error: 'مثال رسالة خطأ مرتبطة بالحقل',
      ),
      const SizedBox(height: 16),
      SearchField(
        label: 'البحث',
        placeholder: 'ابحث عن إقامة',
        controller: controller,
      ),
    ],
  );
}

class _BidiScenario extends StatelessWidget {
  const _BidiScenario();
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'اتصل على +20 100 123 4567 لتجربة عزل اتجاه رقم الهاتف.',
        style: KonfrmTypography.body,
      ),
      SizedBox(height: 12),
      Text(
        'البريد التجريبي user@example.test يظهر داخل جملة عربية.',
        style: KonfrmTypography.body,
      ),
      SizedBox(height: 12),
      Text(
        'معرّف الحجز BK-183223 والعقار PR-0091 أمثلة مختبرية.',
        style: KonfrmTypography.body,
      ),
      SizedBox(height: 12),
      Text(
        'القيمة المعروضة 1,600 ج.م — مثال تنسيق فقط.',
        style: KonfrmTypography.body,
      ),
      SizedBox(height: 12),
      Text('KONFRM system / واجهة عربية أولاً', style: KonfrmTypography.body),
    ],
  );
}

class _StatesScenario extends StatelessWidget {
  const _StatesScenario();
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'عينات توضيحية غير مرتبطة بحالة خادم',
        style: KonfrmTypography.label,
      ),
      SizedBox(height: 8),
      StatusBadge(label: 'قيد المراجعة', family: StatusFamily.booking),
      SizedBox(height: 8),
      StatusBadge(
        label: 'حالة العقار — مثال مختبر',
        family: StatusFamily.property,
      ),
      SizedBox(height: 8),
      StatusBadge(
        label: 'مراجعة العقار — مثال مختبر',
        family: StatusFamily.propertyReview,
      ),
      SizedBox(height: 8),
      StatusBadge(label: 'دفعة — مثال مختبر', family: StatusFamily.payment),
      SizedBox(height: 8),
      StatusBadge(
        label: 'رصيد — مثال مختبر',
        family: StatusFamily.walletBucket,
      ),
      SizedBox(height: 8),
      StatusBadge(label: 'طلب سحب — مثال مختبر', family: StatusFamily.payout),
      SizedBox(height: 8),
      StatusBadge(
        label: 'هوية المالك — مثال مختبر',
        family: StatusFamily.ownerIdentity,
      ),
      SizedBox(height: 8),
      StatusBadge(
        label: 'مستند تحقق — مثال مختبر',
        family: StatusFamily.verificationDocument,
      ),
      SizedBox(height: 12),
      StateView(
        kind: StateKind.loading,
        heading: 'جارٍ التحميل',
        explanation: 'هذه معاينة حالة تحميل فقط.',
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.error,
        heading: 'تعذر تحميل المحتوى',
        explanation: 'لم نتمكن من جلب البيانات.',
        recoveryLabel: 'إعادة المحاولة',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.empty,
        heading: 'لا توجد عناصر',
        explanation: 'حالة فراغ مستقلة بعد نجاح القراءة.',
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.offline,
        heading: 'الاتصال غير متاح',
        explanation:
            'تعذر تحديث هذه المعاينة. تحقق من الاتصال ثم أعد المحاولة.',
        recoveryLabel: 'إعادة المحاولة',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.unauthorized,
        heading: 'يلزم وصول مخول',
        explanation: 'معاينة حالة وصول تتطلب التحقق من صلاحية المستخدم.',
        recoveryLabel: 'متابعة تسجيل الدخول',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.partial,
        heading: 'بعض المحتوى غير متاح',
        explanation: 'هذه معاينة لعرض جزء متاح مع توضيح الجزء غير المتاح.',
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.stale,
        heading: 'المعلومات قديمة',
        explanation: 'لم يكتمل تحديث المعاينة؛ لا تعرضها كبيانات حالية.',
        recoveryLabel: 'تحديث',
        onRecovery: _noop,
      ),
      SizedBox(height: 16),
      StateView(
        kind: StateKind.conflict,
        heading: 'توجد معلومات متعارضة',
        explanation: 'تتطلب هذه المعاينة مراجعة قبل متابعة التغيير.',
      ),
      SizedBox(height: 16),
      SectionAlert(
        message: 'تعذر الاتصال. تحقق من الشبكة ثم أعد المحاولة.',
        recoveryLabel: 'إعادة المحاولة',
        onRecovery: _noop,
        isError: true,
      ),
    ],
  );
}

class _NavigationScenario extends StatelessWidget {
  const _NavigationScenario();
  @override
  Widget build(BuildContext context) => const StructuralContainer(
    child: Text(
      'معاينة التنقل السفلي ذات الوجهات الأربع تظهر أسفل الشاشة.',
      style: KonfrmTypography.body,
    ),
  );
}

class _StickyScenario extends StatelessWidget {
  const _StickyScenario();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'معاينة منفصلة لسطح إجراء ثابت؛ شريط تنقل العميل غير موجود في هذه الحالة.',
        style: KonfrmTypography.body,
      ),
    ],
  );
}
