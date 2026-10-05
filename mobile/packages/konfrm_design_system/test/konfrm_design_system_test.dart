import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import 'package:konfrm_design_system/src/theme/konfrm_theme.dart'
    show ValidationReferenceOnly;

Widget host(
  Widget child, {
  TextDirection direction = TextDirection.rtl,
  double scale = 1,
  bool disableAnimations = false,
  TargetPlatform platform = TargetPlatform.android,
}) => MaterialApp(
  theme: konfrmLightTheme().copyWith(platform: platform),
  home: MediaQuery(
    data: MediaQueryData(
      textScaler: TextScaler.linear(scale),
      disableAnimations: disableAnimations,
    ),
    child: Directionality(
      textDirection: direction,
      child: Theme(
        data: konfrmLightTheme().copyWith(platform: platform),
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  ),
);

void main() {
  test('exports package metadata and all Profile B typography roles', () {
    expect(kKonfrmDesignSystemPackageName, 'konfrm_design_system');
    expect(kKonfrmDesignSystemFoundation, 'DF2 v1.7');
    const expected = <String, (double, FontWeight, double)>{
      'display': (24, FontWeight.w700, 1.30),
      'pageTitle': (20, FontWeight.w700, 1.35),
      'sectionTitle': (17, FontWeight.w700, 1.40),
      'cardTitle': (15, FontWeight.w700, 1.40),
      'body': (14, FontWeight.w500, 1.50),
      'bodyStrong': (14, FontWeight.w700, 1.50),
      'label': (12, FontWeight.w600, 1.35),
      'supporting': (12, FontWeight.w400, 1.40),
      'numeric': (16, FontWeight.w700, 1.30),
      'button': (15, FontWeight.w700, 1.20),
    };
    expect(KonfrmTypography.roles.keys, expected.keys);
    for (final entry in expected.entries) {
      final style = KonfrmTypography.roles[entry.key]!;
      expect(
        (style.fontSize, style.fontWeight, style.height),
        entry.value,
        reason: entry.key,
      );
      expect(style.fontFamily, KonfrmTypography.fontFamily, reason: entry.key);
    }
  });

  testWidgets('LTR inline isolates stay directional inside Arabic layout', (
    tester,
  ) async {
    await tester.pumpWidget(host(ltrText('BK-183223')));
    expect(
      Directionality.of(tester.element(find.text('BK-183223'))),
      TextDirection.ltr,
    );
    await tester.pumpWidget(host(isolateLtr(const Text('user@example.test'))));
    expect(
      Directionality.of(tester.element(find.text('user@example.test'))),
      TextDirection.ltr,
    );
  });

  testWidgets(
    'package-owned Cairo binary is addressable through package assets',
    (tester) async {
      final bytes = await rootBundle.load(
        'packages/konfrm_design_system/assets/fonts/Cairo-VariableFont.ttf',
      );
      expect(bytes.lengthInBytes, greaterThan(100000));
    },
  );

  testWidgets(
    'primary contract has governed radius, flexible height, disabled and busy semantics',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        host(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(label: 'متابعة', onPressed: () => calls++),
              const PrimaryButton(
                label: 'جارٍ الإرسال',
                onPressed: null,
                phase: ActionPhase.submitting,
              ),
              const PrimaryButton(label: 'غير متاح', onPressed: null),
            ],
          ),
        ),
      );
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(PrimaryButton).first,
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.borderRadius, BorderRadius.circular(6));
      expect(
        tester.getSize(find.byType(PrimaryButton).first).height,
        greaterThanOrEqualTo(48),
      );
      await tester.tap(find.text('متابعة'));
      expect(calls, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(PrimaryButton).at(1)),
        matchesSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          label: 'جارٍ الإرسال',
          value: 'جارٍ التنفيذ',
        ),
      );
    },
  );

  testWidgets(
    'loading affordances become static when reduced motion is requested',
    (tester) async {
      await tester.pumpWidget(
        host(
          const StateView(
            kind: StateKind.loading,
            heading: 'جارٍ التحميل',
            explanation: 'معاينة',
          ),
          disableAnimations: true,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    },
  );

  testWidgets(
    'secondary geometry remains explicitly lab scoped and icon action has target and label',
    (tester) async {
      await tester.pumpWidget(
        host(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SecondaryButton(label: 'رجوع', onPressed: null),
              IconActionButton(
                icon: Icons.arrow_back,
                semanticLabel: 'رجوع',
                onPressed: null,
                directional: true,
              ),
            ],
          ),
        ),
      );
      expect(ValidationReferenceOnly.secondaryRadius, 8);
      expect(tester.getSize(find.byType(IconActionButton)).width, 48);
      expect(
        tester.getSemantics(find.byType(IconActionButton)),
        matchesSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasSelectedState: true,
          isSelected: false,
          label: 'رجوع',
        ),
      );
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(IconActionButton),
          matching: find.byType(Icon),
        ),
      );
      expect(icon.icon, Icons.arrow_back);
      expect(icon.textDirection, TextDirection.rtl);
    },
  );

  testWidgets(
    'touch-target mapping distinguishes Android and preview-only iOS sizing',
    (tester) async {
      await tester.pumpWidget(
        host(
          const IconActionButton(
            icon: Icons.close,
            semanticLabel: 'إغلاق',
            onPressed: _noop,
          ),
          platform: TargetPlatform.android,
        ),
      );
      final androidTargetBox = find.byKey(
        const Key('konfrm-icon-action-target'),
      );
      expect(tester.getSize(androidTargetBox), const Size(48, 48));
      await tester.pumpWidget(
        host(
          const IconActionButton(
            icon: Icons.close,
            semanticLabel: 'إغلاق',
            onPressed: _noop,
          ),
          platform: TargetPlatform.iOS,
        ),
      );
      expect(
        Theme.of(tester.element(find.byType(IconActionButton))).platform,
        TargetPlatform.iOS,
      );
      final iosTargetBox = find.byKey(const Key('konfrm-icon-action-target'));
      expect(tester.getSize(iosTargetBox), const Size(44, 44));
    },
  );

  testWidgets('directional and media-neutral icon direction contracts', (
    tester,
  ) async {
    const back = IconActionButton(
      icon: Icons.arrow_back,
      semanticLabel: 'رجوع',
      onPressed: _noop,
      directional: true,
    );
    await tester.pumpWidget(host(back, direction: TextDirection.ltr));
    var icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, Icons.arrow_back);
    expect(icon.textDirection, TextDirection.ltr);

    await tester.pumpWidget(host(back, direction: TextDirection.rtl));
    icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, Icons.arrow_back, reason: 'same logical Back icon');
    expect(icon.textDirection, TextDirection.rtl);

    await tester.pumpWidget(
      host(
        const IconActionButton(
          icon: Icons.close,
          semanticLabel: 'إغلاق',
          onPressed: _noop,
        ),
        direction: TextDirection.ltr,
      ),
    );
    final closeLtr = tester.widget<Icon>(find.byType(Icon));
    await tester.pumpWidget(
      host(
        const IconActionButton(
          icon: Icons.close,
          semanticLabel: 'إغلاق',
          onPressed: _noop,
        ),
        direction: TextDirection.rtl,
      ),
    );
    final closeRtl = tester.widget<Icon>(find.byType(Icon));
    expect(closeLtr.icon, Icons.close);
    expect(closeRtl.icon, Icons.close);
    expect(closeLtr.textDirection, closeRtl.textDirection);

    await tester.pumpWidget(
      host(
        const IconActionButton(
          icon: Icons.arrow_back,
          semanticLabel: 'رمز ثابت',
          onPressed: _noop,
        ),
        direction: TextDirection.rtl,
      ),
    );
    final neutral = tester.widget<Icon>(find.byType(Icon));
    expect(neutral.icon, Icons.arrow_back);
    expect(neutral.textDirection, TextDirection.ltr);
  });

  testWidgets(
    'fields expose labels, helper/error, disabled/read-only and field-only radius',
    (tester) async {
      await tester.pumpWidget(
        host(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputField(label: 'الاسم', helper: 'معلومة مساعدة'),
              InputField(label: 'البريد', error: 'قيمة غير صالحة'),
              InputField(label: 'للقراءة فقط', readOnly: true),
              InputField(label: 'معطل', enabled: false),
            ],
          ),
        ),
      );
      expect(find.text('الاسم'), findsOneWidget);
      expect(find.text('معلومة مساعدة'), findsOneWidget);
      expect(find.text('قيمة غير صالحة'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.decoration?.border, isA<OutlineInputBorder>());
      expect(
        (field.decoration!.border as OutlineInputBorder).borderRadius,
        BorderRadius.circular(8),
      );
      await tester.showKeyboard(find.byType(TextField).first);
      await tester.pump();
      final focusedField = tester.widget<TextField>(
        find.byType(TextField).first,
      );
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).first)
            .focusNode
            .hasFocus,
        isTrue,
      );
      expect(focusedField.decoration?.focusedBorder, isA<OutlineInputBorder>());
      expect(
        tester.widget<TextField>(find.byType(TextField).last).enabled,
        false,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).readOnly,
        true,
      );
      final fieldSemantics = tester.getSemantics(find.byType(TextField).first);
      expect(fieldSemantics.label, contains('الاسم'));
      expect(fieldSemantics.hint, 'معلومة مساعدة');
    },
  );

  testWidgets('phone is LTR inside RTL and search clear/loading are distinct', (
    tester,
  ) async {
    final phone = TextEditingController(text: '+20 100 123 4567');
    final search = TextEditingController(text: 'نص');
    await tester.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhoneField(label: 'الهاتف', controller: phone),
            SearchField(
              label: 'البحث',
              placeholder: 'ابحث',
              controller: search,
            ),
          ],
        ),
      ),
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).first).textDirection,
      TextDirection.ltr,
    );
    expect(find.byTooltip('مسح البحث'), findsOneWidget);
    await tester.tap(find.byTooltip('مسح البحث'));
    await tester.pump();
    expect(search.text, isEmpty);
    phone.dispose();
    search.dispose();
  });

  testWidgets(
    'badge text, eight lifecycle distinctions, recovery and alert are exposed semantically',
    (tester) async {
      expect(StateKind.values.length, 8);
      await tester.pumpWidget(
        host(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusBadge(label: 'قيد المراجعة'),
              StateView(
                kind: StateKind.error,
                heading: 'تعذر التحميل',
                explanation: 'حدث خطأ',
                recoveryLabel: 'إعادة المحاولة',
                onRecovery: _noop,
              ),
              SectionAlert(
                message: 'تعذر الاتصال',
                recoveryLabel: 'إعادة المحاولة',
                onRecovery: _noop,
                isError: true,
              ),
            ],
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(StatusBadge)),
        matchesSemantics(label: 'قيد المراجعة'),
      );
      expect(find.text('تعذر التحميل'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsNWidgets(2));
      expect(find.text('تعذر الاتصال'), findsOneWidget);
      for (final kind in StateKind.values) {
        await tester.pumpWidget(
          host(
            StateView(
              kind: kind,
              heading: kind.name,
              explanation: 'معنى الحالة',
            ),
          ),
        );
        expect(find.text(kind.name), findsOneWidget);
      }
    },
  );

  testWidgets('StatusBadge wraps a long Arabic label at 200 percent', (
    tester,
  ) async {
    const compactLabel = 'قيد المراجعة';
    const label = 'تمت الموافقة — العربون مطلوب';
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      host(
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: StatusBadge(label: compactLabel),
          ),
        ),
      ),
    );
    final normalSize = tester.getSize(find.byType(StatusBadge));
    expect(normalSize.width, lessThan(360));
    expect(normalSize.height, lessThan(50));
    expect(find.text(compactLabel), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      host(
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: const StatusBadge(label: label),
          ),
        ),
        scale: 2,
      ),
    );
    await tester.pump();

    final badgeSize = tester.getSize(find.byType(StatusBadge));
    expect(badgeSize.width, lessThanOrEqualTo(220));
    expect(badgeSize.height, greaterThan(50));
    expect(find.text(label), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text(label))),
      TextDirection.rtl,
    );
    expect(
      tester.getSemantics(find.byType(StatusBadge)),
      matchesSemantics(label: label),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'structural container uses provisional 12 radius without elevation',
    (tester) async {
      await tester.pumpWidget(
        host(const StructuralContainer(child: Text('مجموعة'))),
      );
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('مجموعة'), matching: find.byType(Container))
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
      expect(container.constraints?.maxHeight, isNull);
    },
  );

  testWidgets(
    'customer navigation has exactly four destinations and selected index',
    (tester) async {
      await tester.pumpWidget(
        host(
          const CustomerBottomNavigation(
            selectedIndex: 2,
            onSelected: _noopIndex,
          ),
        ),
      );
      expect(customerDestinations, ['استكشف', 'المفضلة', 'حجوزاتي', 'الحساب']);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );
      expect(
        tester
            .getSemantics(find.text('حجوزاتي'))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      for (var i = 0; i < customerDestinations.length; i++) {
        final size = tester.getSize(find.byKey(Key('customer-destination-$i')));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
    },
  );

  testWidgets('state recovery and sticky long action reflow at 200 percent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      host(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StateView(
              kind: StateKind.error,
              heading: 'تعذر استكمال المعاينة',
              explanation: 'يمكن إعادة المحاولة بعد التحقق من الاتصال.',
              recoveryLabel: 'إعادة المحاولة الآن',
              onRecovery: _noop,
            ),
            StickyActionSurface(
              child: PrimaryButton(
                label: 'متابعة إلى الخطوة التالية مع تكبير النص',
                onPressed: _noop,
              ),
            ),
          ],
        ),
        scale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.text('إعادة المحاولة الآن')).height,
      greaterThan(0),
    );
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Arabic content reflows at 200 percent without render overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      host(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: 'متابعة إلى الخطوة التالية عند تكبير النص',
              onPressed: _noop,
            ),
            InputField(label: 'عنوان طويل يظل مقروءاً عند تكبير النص'),
            Text(
              'تجربة العربية مع الامتدادات والنقاط والحروف المختلطة ABC-123',
              style: KonfrmTypography.body,
            ),
          ],
        ),
        scale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(PrimaryButton)).height, greaterThan(48));
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void _noop() {}
void _noopIndex(int _) {}
