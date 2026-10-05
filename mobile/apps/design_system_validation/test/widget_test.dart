import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_validation/main.dart';

void main() {
  testWidgets('renders Phase 4I validation harness with Arabic RTL direction', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KonfrmValidationApp());
    await tester.pumpAndSettle();

    // Verify app bar title
    expect(find.text('كونفرم / KONFRM'), findsOneWidget);

    // Verify Phase 4I header card
    expect(find.text('بيئة الفحص الأصيل (Phase 4I)'), findsOneWidget);

    // Verify LAB_SCENARIO_DATA notice
    expect(find.textContaining('LAB_SCENARIO_DATA'), findsOneWidget);

    // Verify Directionality is RTL
    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
