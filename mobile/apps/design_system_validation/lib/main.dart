import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import 'scenarios/inputs_bidi.dart';
import 'scenarios/states.dart';
import 'scenarios/structure_navigation.dart';
import 'scenarios/typography_actions.dart';

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
  final searchController = TextEditingController();

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
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const _LabDisclosure(),
            Wrap(
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
            _ScaleControls(
              scale: scale,
              onChanged: (v) => setState(() => scale = v),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
      bottomNavigationBar: section == 6
          ? CustomerBottomNavigation(
              selectedIndex: selectedDestination,
              onSelected: (i) => setState(() => selectedDestination = i),
            )
          : section == 7
          ? const StickyActionSurface(
              child: PrimaryButton(
                label: 'متابعة إلى الخطوة التالية مع تكبير النص',
                onPressed: _noop,
              ),
            )
          : null,
    ),
  );

  Widget _scenarioContent() => switch (section) {
    0 => const TypographyScenario(),
    1 => const ActionsScenario(),
    2 => InputsScenario(controller: searchController),
    3 => const BidiScenario(),
    4 => const StatesScenario(),
    5 => const OwnerGroupingScenario(),
    6 => const NavigationScenario(),
    _ => const StickyScenario(),
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

void _noop() {}
