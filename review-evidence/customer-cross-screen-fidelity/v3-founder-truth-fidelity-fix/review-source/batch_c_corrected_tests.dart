// =============================================================================
// KONFRM Customer Application — Batch C Corrected Automated Verification Suite
//
// Target Hardware Profile: Samsung Galaxy A56 5G (Android 16 API 36)
// Scope: Behavioral and layout verification for Screens 18, 19
// Directives:
//   - Physical RTL Back Arrow Law: Must point physically to RIGHT [➔]
//   - Pure-Black (#000000) Theme Invariant
//   - Purge Visible Development Strings: No «بيانات تجريبية» or mock labels
//   - Zero-Tolerance 200% Accessibility Font Scale Reflow
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/batch_c_corrected_runner.dart';

void main() {
  group('Batch C — Physical Right Back Arrow Tests', () {
    testWidgets('Screen 18 has physical right back button pointing right [➔]', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen18View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen18_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      expect(find.byKey(const Key('screen18_save_button')), findsOneWidget);

      // Verify email is unverified without green tick or (مؤكد)
      expect(find.text('البريد الإلكتروني (مؤكد)'), findsNothing);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('رقم الهاتف المحمول (مؤكد)'), findsOneWidget);
    });

    testWidgets('Screen 19 has physical right back button pointing right [➔] and purged test copy', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen19View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byKey(const Key('screen19_back_button'));
      expect(backButtonFinder, findsOneWidget);

      final iconFinder = find.descendant(
        of: backButtonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, Icons.arrow_forward_rounded);
      expect(iconWidget.color, const Color(0xFF000000));

      // Verify purged development copy
      expect(find.textContaining('بيانات تجريبية'), findsNothing);
      expect(find.textContaining('تجريبي'), findsNothing);

      // Verify interactive toggle row state change
      final toggleFinder = find.byKey(const Key('toggle_booking_updates'));
      expect(toggleFinder, findsOneWidget);
      final switchFinder = find.descendant(of: toggleFinder, matching: find.byType(Switch));
      expect(switchFinder, findsOneWidget);
      Switch switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isTrue);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isFalse);

      // Verify logout button shows confirmation dialog
      final logoutBtnFinder = find.byKey(const Key('screen19_logout_button'));
      expect(logoutBtnFinder, findsOneWidget);
      await tester.tap(logoutBtnFinder);
      await tester.pumpAndSettle();

      expect(find.text('هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟'), findsOneWidget);
      await tester.tap(find.text('إلغاء'));
      await tester.pumpAndSettle();
      expect(find.text('هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟'), findsNothing);
    });

    testWidgets('Screen 19 preserves full fidelity account security, planned sheets, and account deletion', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: CorrectedScreen19View(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Account & Security section presence
      expect(find.text('الأمان وطرق الدخول'), findsOneWidget);
      expect(find.text('رقم الهاتف الأساسي'), findsOneWidget);
      expect(find.text('البريد الإلكتروني الأساسي'), findsOneWidget);
      expect(find.text('إضافة رقم هاتف بديل'), findsOneWidget);
      expect(find.text('ربط حساب Apple'), findsOneWidget);
      expect(find.text('ربط حساب Google'), findsOneWidget);

      // Tap planned action -> opens planned sheet
      final appleFinder = find.byKey(const Key('row_link_apple'));
      expect(appleFinder, findsOneWidget);
      await tester.tap(appleFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('planned_sheet_dismiss')), findsOneWidget);
      expect(find.textContaining('قيد الإعداد ضمن خطة ترقية الأمان'), findsOneWidget);
      await tester.tap(find.byKey(const Key('planned_sheet_dismiss')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('planned_sheet_dismiss')), findsNothing);

      // Scroll down to Account Deletion
      final deleteRowFinder = find.byKey(const Key('screen19_delete_account_button'));
      await tester.scrollUntilVisible(deleteRowFinder, 200);
      await tester.pumpAndSettle();
      expect(deleteRowFinder, findsOneWidget);

      // Tap Account Deletion -> opens Account Deletion Sheet (Issue #189)
      await tester.tap(deleteRowFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('account_deletion_sheet_dismiss')), findsOneWidget);
      expect(find.textContaining('إجراءات تصدير البيانات أو حذف الحساب غير متاحة حالياً'), findsOneWidget);
      await tester.tap(find.byKey(const Key('account_deletion_sheet_dismiss')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('account_deletion_sheet_dismiss')), findsNothing);
    });

    testWidgets('Batch C screens render without overflow under 200% accessibility scaling', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 2340));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final screenWidget in const [
        CorrectedScreen18View(),
        CorrectedScreen19View(),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2.0),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: child!,
                ),
              );
            },
            home: Scaffold(
              body: screenWidget,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Screen $screenWidget should not throw any overflow under 200% scaling');
      }
    });
  });
}
