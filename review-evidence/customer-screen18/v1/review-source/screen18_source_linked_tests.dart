// =============================================================================
// KONFRM Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي»)
// Source-Linked Unit and Behavioral Widget Tests
//
// Governing Issues:
//   - Issue #176 (Screen 18 Profile / Edit Profile Founder Execution Contract)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository Audit)
//   - Issue #172 (Identity, Avatar, QR & Connected Profiles Boundaries)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import '../tool/screen18_preview_runner.dart';
import '../tool/screen17_demo_portrait_bytes.dart';

void main() {
  group('Screen 18 — Domain Models & Invariants', () {
    test('formatDisplayPhone formats Egyptian mobile numbers correctly', () {
      expect(formatDisplayPhone('+201012345678'), equals('+20 10 1234 5678'));
      expect(formatDisplayPhone('+201198765432'), equals('+20 11 9876 5432'));
      expect(formatDisplayPhone('+201200001111'), equals('+20 12 0000 1111'));
      expect(formatDisplayPhone('+201555554444'), equals('+20 15 5555 4444'));
      expect(formatDisplayPhone('01012345678'), equals('01012345678')); // Non-E.164 passthrough
    });

    test('formatArabicDate formats DateTime into Arabic month strings', () {
      final date1 = DateTime(1998, 3, 15);
      expect(formatArabicDate(date1), equals('15 مارس 1998'));

      final date2 = DateTime(2000, 10, 25);
      expect(formatArabicDate(date2), equals('25 أكتوبر 2000'));
    });

    test('CustomerProfileEditDraft derives correct initials for Arabic full names', () {
      const draftMulti = CustomerProfileEditDraft(
        fullName: 'أحمد مصطفى',
        verifiedPhone: '+201012345678',
        verifiedEmail: 'ahmed@example.com',
      );
      expect(draftMulti.initials, equals('أ.م'));

      const draftSingle = CustomerProfileEditDraft(
        fullName: 'سارة',
        verifiedPhone: '+201012345678',
        verifiedEmail: 'sara@example.com',
      );
      expect(draftSingle.initials, equals('سا'));

      const draftEmpty = CustomerProfileEditDraft(
        fullName: '   ',
        verifiedPhone: '+201012345678',
        verifiedEmail: 'test@example.com',
      );
      expect(draftEmpty.initials, equals('م'));
    });

    test('CustomerProfileEditDraft derives age accurately with calendar boundaries', () {
      // Benchmark date in runner is 2026-10-16
      final draftBornMarch = CustomerProfileEditDraft(
        fullName: 'أحمد مصطفى',
        birthDate: DateTime(1998, 3, 15),
        verifiedPhone: '+201012345678',
        verifiedEmail: 'ahmed@example.com',
      );
      expect(draftBornMarch.derivedAgeYears, equals(28));

      // Birthday has not occurred yet in 2026 (e.g., November 20)
      final draftBornNov = CustomerProfileEditDraft(
        fullName: 'أحمد مصطفى',
        birthDate: DateTime(1998, 11, 20),
        verifiedPhone: '+201012345678',
        verifiedEmail: 'ahmed@example.com',
      );
      expect(draftBornNov.derivedAgeYears, equals(27));

      const draftNoDob = CustomerProfileEditDraft(
        fullName: 'أحمد مصطفى',
        birthDate: null,
        verifiedPhone: '+201012345678',
        verifiedEmail: 'ahmed@example.com',
      );
      expect(draftNoDob.derivedAgeYears, isNull);
    });

    test('CustomerGender provides Arabic localized labels', () {
      expect(CustomerGender.male.labelArabic, equals('ذكر'));
      expect(CustomerGender.female.labelArabic, equals('أنثى'));
      expect(CustomerGender.preferNotToDisclose.labelArabic, equals('أفضل عدم الإفصاح'));
    });

    test('CustomerProfileEditDraft copyWith and clear flags behave predictably', () {
      final initial = CustomerProfileEditDraft(
        fullName: 'أحمد مصطفى',
        proposedUsername: 'ahmed_m',
        birthDate: DateTime(1998, 3, 15),
        gender: CustomerGender.male,
        portraitBytes: kScreen17DemoPortraitBytes,
        verifiedPhone: '+201012345678',
        verifiedEmail: 'ahmed@example.com',
      );

      final clearedPortrait = initial.copyWith(clearPortrait: true);
      expect(clearedPortrait.hasPortrait, isFalse);
      expect(clearedPortrait.portraitBytes, isNull);

      final clearedDob = initial.copyWith(clearBirthDate: true);
      expect(clearedDob.birthDate, isNull);
      expect(clearedDob.derivedAgeYears, isNull);
    });
  });

  group('Screen 18 — State Controller Lifecycle & Form Rules', () {
    late Screen18EditProfileController controller;

    setUp(() {
      controller = Screen18EditProfileController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is pristine, valid, and save is disabled', () {
      expect(controller.isDirty, isFalse);
      expect(controller.isValid, isTrue);
      expect(controller.isSaveEnabled, isFalse);
      expect(controller.inlineNameError, isNull);
      expect(controller.draft.fullName, equals('أحمد مصطفى'));
      expect(controller.draft.proposedUsername, equals('ahmed_mostafa'));
      expect(controller.draft.hasPortrait, isTrue);
    });

    test('modifying full name updates draft and dirty status', () {
      controller.updateFullName('أحمد مصطفى كمال');
      expect(controller.isDirty, isTrue);
      expect(controller.isValid, isTrue);
      expect(controller.isSaveEnabled, isTrue);
      expect(controller.inlineNameError, isNull);

      // Reverting back to original name resets dirty status
      controller.updateFullName('أحمد مصطفى');
      expect(controller.isDirty, isFalse);
      expect(controller.isSaveEnabled, isFalse);
    });

    test('invalid full name (< 2 chars or empty) triggers inline error and disables save', () {
      controller.updateFullName('');
      expect(controller.isDirty, isTrue);
      expect(controller.isValid, isFalse);
      expect(controller.isSaveEnabled, isFalse);
      expect(controller.inlineNameError, equals('يرجى إدخال اسمك الكامل.'));

      controller.updateFullName('أ');
      expect(controller.isValid, isFalse);
      expect(controller.isSaveEnabled, isFalse);
      expect(controller.inlineNameError, equals('الاسم يجب أن يتكون من حرفين على الأقل.'));
    });

    test('updating proposed username strips @ symbol and marks dirty', () {
      controller.updateUsername('@ahmed_new');
      expect(controller.draft.proposedUsername, equals('ahmed_new'));
      expect(controller.isDirty, isTrue);
    });

    test('photo sheet and crop modal transitions', () {
      expect(controller.showPhotoSheet, isFalse);
      expect(controller.showCropModal, isFalse);

      controller.openPhotoSheet();
      expect(controller.showPhotoSheet, isTrue);

      controller.openCropModal();
      expect(controller.showPhotoSheet, isFalse);
      expect(controller.showCropModal, isTrue);
      expect(controller.cropZoom, equals(1.0));

      controller.setCropZoom(2.2);
      expect(controller.cropZoom, equals(2.2));

      // Test clamp boundary
      controller.setCropZoom(4.5);
      expect(controller.cropZoom, equals(3.0));

      controller.closeCropModal();
      expect(controller.showCropModal, isFalse);
    });

    test('discard confirmation flow protects unsaved changes', () {
      // 1. When pristine, requestBack does not show dialog
      controller.requestBack();
      expect(controller.showDiscardDialog, isFalse);
      expect(controller.snackBarNotice, contains('رجوع إلى صفحة الحساب'));

      // 2. When dirty, requestBack opens discard confirmation dialog
      controller.updateFullName('اسم جديد');
      controller.requestBack();
      expect(controller.showDiscardDialog, isTrue);

      // 3. Canceling discard keeps modifications
      controller.cancelDiscard();
      expect(controller.showDiscardDialog, isFalse);
      expect(controller.draft.fullName, equals('اسم جديد'));

      // 4. Confirming discard resets draft to initialProfile
      controller.requestBack();
      controller.confirmDiscard();
      expect(controller.showDiscardDialog, isFalse);
      expect(controller.draft.fullName, equals('أحمد مصطفى'));
      expect(controller.isDirty, isFalse);
    });

    test('saving profile simulates progress and updates initial baseline', () async {
      controller.updateFullName('أحمد مصطفى المعتمد');
      expect(controller.isSaveEnabled, isTrue);

      final saveFuture = controller.saveProfile();
      expect(controller.isSaving, isTrue);

      await saveFuture;
      expect(controller.isSaving, isFalse);
      expect(controller.isDirty, isFalse); // draft now synced to initialProfile
      expect(controller.snackBarNotice, contains('معاينة فقط'));
    });

    test('setting scenarios configures appropriate view and overlay state', () {
      controller.setScenario(Screen18Scenario.photoActionSheet);
      expect(controller.showPhotoSheet, isTrue);

      controller.setScenario(Screen18Scenario.photoCropModal);
      expect(controller.showCropModal, isTrue);
      expect(controller.cropZoom, equals(1.25));

      controller.setScenario(Screen18Scenario.discardConfirmationDialog);
      expect(controller.showDiscardDialog, isTrue);

      controller.setScenario(Screen18Scenario.validationErrorEmptyName);
      expect(controller.draft.fullName, equals(''));
      expect(controller.inlineNameError, isNotNull);
    });
  });

  group('Screen 18 — Behavioral Widget Tests', () {
    testWidgets('renders top bar with physical RIGHT return arrow, title, and cancel button', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      // Top bar title
      expect(find.text('تعديل الملف الشخصي'), findsOneWidget);

      // Cancel button
      expect(find.byKey(const Key('app_bar_cancel_action')), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);

      // Back button with arrow pointing physically RIGHT in RTL
      final backBtn = find.byKey(const Key('app_bar_back_button'));
      expect(backBtn, findsOneWidget);
      expect(
        find.descendant(of: backBtn, matching: find.byIcon(Icons.arrow_forward_ios_rounded)),
        findsOneWidget,
      );
    });

    testWidgets('renders portrait hero with black camera on white circular badge (>=48dp touch target)', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      // Avatar container
      expect(find.byKey(const Key('avatar_edit_target')), findsOneWidget);

      // Camera badge button
      final badgeFinder = find.byKey(const Key('camera_badge_button'));
      expect(badgeFinder, findsOneWidget);

      // Verify touch target dimension >= 48dp
      final badgeSize = tester.getSize(badgeFinder);
      expect(badgeSize.width, greaterThanOrEqualTo(48.0));
      expect(badgeSize.height, greaterThanOrEqualTo(48.0));

      // Verify camera icon is black
      final iconFinder = find.descendant(of: badgeFinder, matching: find.byIcon(Icons.camera_alt_outlined));
      expect(iconFinder, findsOneWidget);
      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, equals(const Color(0xFF000000)));

      // Caption
      expect(find.text('تغيير الصورة الشخصية'), findsOneWidget);
    });

    testWidgets('renders personal identity form fields and live validation', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      // Full Name field
      final nameField = find.byKey(const Key('field_full_name'));
      expect(nameField, findsOneWidget);
      expect(find.text('الاسم الكامل'), findsOneWidget);

      // Unified username field with @ prefix
      final usernameField = find.byKey(const Key('field_proposed_username'));
      expect(usernameField, findsOneWidget);
      expect(find.text('اسم المستخدم الموحّد'), findsOneWidget);
      expect(find.text('مقترح #172'), findsOneWidget);

      // Birth date field and derived age badge
      expect(find.byKey(const Key('field_birth_date_picker')), findsOneWidget);
      expect(find.text('تاريخ الميلاد'), findsOneWidget);
      expect(find.text('28 سنة (محسوب تلقائياً)'), findsOneWidget);

      // Gender chips
      expect(find.text('الجنس'), findsOneWidget);
      expect(find.byKey(const Key('gender_option_male')), findsOneWidget);
      expect(find.byKey(const Key('gender_option_female')), findsOneWidget);
      expect(find.byKey(const Key('gender_option_preferNotToDisclose')), findsOneWidget);
    });

    testWidgets('renders read-only verified account identifiers with green badges and Screen 19 footnote', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('معرّفات الحساب الموثّقة'), findsOneWidget);
      expect(find.text('رقم الهاتف الأساسي'), findsOneWidget);
      expect(find.text('+20 10 1234 5678'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('ahmed.mostafa@example.com'), findsOneWidget);

      // Two verified green badges
      expect(find.text('موثّق'), findsNWidgets(2));

      // Screen 19 boundary explanation footnote
      expect(
        find.textContaining('انتقل إلى شاشة إدارة الأمان (شاشة 19)'),
        findsOneWidget,
      );
    });

    testWidgets('renders canonical CustomerBottomNavigation with Account tab active (index 3)', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      final navFinder = find.byType(CustomerBottomNavigation);
      expect(navFinder, findsOneWidget);
      final navWidget = tester.widget<CustomerBottomNavigation>(navFinder);
      expect(navWidget.selectedIndex, equals(3));
    });

    testWidgets('tapping camera badge displays photo action sheet with required actions', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      // Tap camera badge
      await tester.tap(find.byKey(const Key('camera_badge_button')));
      await tester.pumpAndSettle();

      // Verify sheet items
      expect(find.text('صورة الملف الشخصي'), findsOneWidget);
      expect(find.byKey(const Key('photo_action_camera')), findsOneWidget);
      expect(find.byKey(const Key('photo_action_gallery')), findsOneWidget);
      expect(find.byKey(const Key('photo_action_crop')), findsOneWidget);
      expect(find.byKey(const Key('photo_action_remove')), findsOneWidget);
      expect(find.byKey(const Key('photo_action_cancel')), findsOneWidget);

      // Cancel closes sheet
      await tester.tap(find.byKey(const Key('photo_action_cancel')));
      await tester.pumpAndSettle();
      expect(find.text('صورة الملف الشخصي'), findsNothing);
    });

    testWidgets('crop modal displays 1:1 circular crop ring, zoom slider, and honest disclaimer', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      // Open sheet then crop modal
      await tester.tap(find.byKey(const Key('camera_badge_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('photo_action_crop')));
      await tester.pumpAndSettle();

      expect(find.text('اقتصاص الصورة الشخصية'), findsOneWidget);
      expect(find.textContaining('معاينة تعديل واقتصاص محلية'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byKey(const Key('crop_modal_apply')), findsOneWidget);
      expect(find.byKey(const Key('crop_modal_reset')), findsOneWidget);
      expect(find.byKey(const Key('crop_modal_cancel')), findsOneWidget);

      // Close modal
      await tester.tap(find.byKey(const Key('crop_modal_cancel')));
      await tester.pumpAndSettle();
      expect(find.text('اقتصاص الصورة الشخصية'), findsNothing);
    });

    testWidgets('discard confirmation dialog renders warning and allows cancel or confirm', (tester) async {
      await tester.pumpWidget(const Screen18PreviewApp());
      await tester.pumpAndSettle();

      // Modify name to make form dirty
      await tester.enterText(find.byKey(const Key('field_full_name')), 'اسم معدل');
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byKey(const Key('app_bar_back_button')));
      await tester.pumpAndSettle();

      // Verify dialog
      expect(find.text('تجاهل التعديلات غير المحفوظة؟'), findsOneWidget);
      expect(find.byKey(const Key('dialog_keep_editing_button')), findsOneWidget);
      expect(find.byKey(const Key('dialog_confirm_discard_button')), findsOneWidget);

      // Tap keep editing
      await tester.tap(find.byKey(const Key('dialog_keep_editing_button')));
      await tester.pumpAndSettle();
      expect(find.text('تجاهل التعديلات غير المحفوظة؟'), findsNothing);
      expect(find.text('اسم معدل'), findsOneWidget);

      // Tap cancel in app bar
      await tester.tap(find.byKey(const Key('app_bar_cancel_action')));
      await tester.pumpAndSettle();
      expect(find.text('تجاهل التعديلات غير المحفوظة؟'), findsOneWidget);

      // Tap confirm discard
      await tester.tap(find.byKey(const Key('dialog_confirm_discard_button')));
      await tester.pumpAndSettle();
      expect(find.text('تجاهل التعديلات غير المحفوظة؟'), findsNothing);
      expect(find.text('أحمد مصطفى'), findsOneWidget);
    });

    testWidgets('renders cleanly under 200% text scale without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.625; // Samsung A56 5G scale factor
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: Screen18PreviewApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar and hero render without overflow
      expect(find.text('تعديل الملف الشخصي'), findsOneWidget);
      expect(find.text('البيانات الأساسية'), findsOneWidget);
      expect(find.text('معرّفات الحساب الموثّقة'), findsOneWidget);
      expect(find.text('حفظ التعديلات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
