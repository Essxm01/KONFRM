// =============================================================================
// KONFRM Customer Screen 21 — Source-Linked Behavioral & Verification Tests
//
// Governing Issues:
//   - Issue #185 (Screen 21 Help & Support Founder Execution Contract)
//   - Issue #186 (Deferred Support Channel, Case API, Privacy & SLA Prelive Gate)
//   - Issue #183 (Mandatory Design Skills Activation, Design Court & Platform Gate)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository-Wide Audit)
//   - Issue #173 (Financial Model Meaning & Booking Lifecycle Boundaries)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
// =============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/screen21_preview_runner.dart';

void main() {
  group('Screen 21 — Domain Models & Sourced FAQ State', () {
    test('CustomerHelpSupportController default values are secure and empty', () {
      final controller = CustomerHelpSupportController();
      expect(controller.scenario, equals(Screen21Scenario.helpCenterTop));
      expect(controller.selectedCategory, equals(HelpCategory.all));
      expect(controller.searchQuery, isEmpty);
      expect(controller.expandedFaqId, isNull);
      expect(controller.entryContext, equals(SupportEntryContext.accountOrigin));
      expect(controller.bookingConsentAttached, isFalse); // Amendment 3: Default OFF
      expect(controller.formStatus, equals(SupportFormStatus.idle));
      expect(controller.formValidationError, isNull);
      expect(controller.isGuest, isFalse);
      expect(controller.showContactFormInline, isFalse);
    });

    test('Sourced FAQ fixtures contain only confirmed Master Rules and Canon', () {
      expect(kSourceBackedHelpFaqs.length, equals(5));

      final depositFaq = kSourceBackedHelpFaqs.firstWhere((f) => f.id == 'faq_deposit_meaning');
      expect(depositFaq.questionArabic, contains('عربون الليلة الأولى'));
      expect(depositFaq.answerArabic, contains('دفعة تأكيدية'));
      expect(depositFaq.canonicalRuleAnchor, contains('MR-13'));

      final durationFaq = kSourceBackedHelpFaqs.firstWhere((f) => f.id == 'faq_stay_duration');
      expect(durationFaq.questionArabic, contains('مدة الإقامة'));
      expect(durationFaq.answerArabic, contains('ليلتين كحد أدنى وحتى 30 ليلة'));
      expect(durationFaq.canonicalRuleAnchor, contains('MR-12'));

      final pendingFaq = kSourceBackedHelpFaqs.firstWhere((f) => f.id == 'faq_pending_status_meaning');
      expect(pendingFaq.questionArabic, contains('قيد الانتظار'));
      expect(pendingFaq.answerArabic, contains('مراجعة وقبول المالك'));
      expect(pendingFaq.canonicalRuleAnchor, contains('MR-12'));
      expect(pendingFaq.canonicalRuleAnchor, contains('MR-13'));

      // Invariant: zero unconfirmed cancellation claims in FAQs
      for (final faq in kSourceBackedHelpFaqs) {
        expect(faq.id, isNot(equals('faq_cancel_pending_request')));
        expect(faq.answerArabic.contains('مجاناً دون رسوم إلغاء'), isFalse);
      }
    });

    test('filteredFaqs filters correctly by category', () {
      final controller = CustomerHelpSupportController();

      controller.setCategory(HelpCategory.all);
      expect(controller.filteredFaqs.length, equals(5));

      controller.setCategory(HelpCategory.paymentsAndDeposit);
      expect(controller.filteredFaqs.length, equals(1));
      expect(controller.filteredFaqs.first.id, equals('faq_deposit_meaning'));

      controller.setCategory(HelpCategory.bookings);
      expect(controller.filteredFaqs.length, equals(3));

      controller.setCategory(HelpCategory.account);
      expect(controller.filteredFaqs.length, equals(1));
      expect(controller.filteredFaqs.first.id, equals('faq_account_profile'));
    });

    test('filteredFaqs filters accurately by search query on loaded fixtures', () {
      final controller = CustomerHelpSupportController();

      controller.setSearchQuery('عربون');
      expect(controller.filteredFaqs.length, greaterThanOrEqualTo(1));
      for (final faq in controller.filteredFaqs) {
        final matches = faq.questionArabic.contains('عربون') || faq.answerArabic.contains('عربون');
        expect(matches, isTrue);
      }

      controller.setSearchQuery('سيارة خاصة');
      expect(controller.filteredFaqs, isEmpty);
    });

    test('toggleFaq expands and collapses accordion items', () {
      final controller = CustomerHelpSupportController();
      expect(controller.expandedFaqId, isNull);

      controller.toggleFaq('faq_deposit_meaning');
      expect(controller.expandedFaqId, equals('faq_deposit_meaning'));

      controller.toggleFaq('faq_deposit_meaning');
      expect(controller.expandedFaqId, isNull);
    });
  });

  group('Screen 21 — Booking Context & Opt-in Consent (Amendment 3)', () {
    test('Booking context displays numeric digits only without raw BK- prefix', () {
      final controller = CustomerHelpSupportController();
      expect(controller.contextBookingNumber, equals('183223'));
      expect(controller.contextBookingNumber.startsWith('BK-'), isFalse);
    });

    test('Booking consent is default OFF and can be toggled by user', () {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.contactFormBookingDefaultOff);

      expect(controller.entryContext, equals(SupportEntryContext.bookingOrigin));
      expect(controller.bookingConsentAttached, isFalse); // Default OFF

      controller.setBookingConsent(true);
      expect(controller.bookingConsentAttached, isTrue);

      controller.setBookingConsent(false);
      expect(controller.bookingConsentAttached, isFalse);
    });

    test('Scenario transitions deterministically configure booking consent', () {
      final controller = CustomerHelpSupportController();

      controller.setScenario(Screen21Scenario.contactFormBookingDefaultOff);
      expect(controller.bookingConsentAttached, isFalse);

      controller.setScenario(Screen21Scenario.contactFormBookingConsentOn);
      expect(controller.bookingConsentAttached, isTrue);
    });
  });

  group('Screen 21 — Form Validation & Draft Preservation', () {
    test('Validation enforces minimum 10 characters and preserves draft', () {
      final controller = CustomerHelpSupportController();
      controller.openContactForm();

      controller.setDescription('مرحبا'); // 5 characters
      controller.submitContactForm();

      expect(controller.formStatus, equals(SupportFormStatus.validationError));
      expect(controller.formValidationError, contains('10 أحرف على الأقل'));
      expect(controller.descriptionText, equals('مرحبا')); // Draft preserved!

      controller.setDescription('مرحبا، أحتاج مساعدة في تفاصيل الحجز.');
      expect(controller.formValidationError, isNull);
    });

    test('Submission does NOT create phantom server confirmed success', () {
      final controller = CustomerHelpSupportController();
      controller.openContactForm();
      controller.setDescription('استفسار مشروع حول تفاصيل موعد الحجز.');

      controller.submitContactForm();

      // Honors Amendment 2: Tapping submit does NOT invent fake confirmed success
      expect(controller.formStatus, isNot(equals(SupportFormStatus.serverConfirmedMock)));
    });

    test('Submission timeout / uncertain state preserves draft and enables review without re-sending', () {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.submissionTimeoutUncertain);

      expect(controller.formStatus, equals(SupportFormStatus.timeoutUncertain));
      expect(controller.descriptionText, isNotEmpty); // Draft preserved

      controller.reviewDraftAfterUncertain();
      expect(controller.formStatus, equals(SupportFormStatus.idle));
      expect(controller.descriptionText, isNotEmpty); // Draft still preserved
    });
  });

  group('Screen 21 — Zero Visible Development Copy Protocol', () {
    test('Runner source contains ZERO occurrences of forbidden test strings', () {
      final file = File('tool/screen21_preview_runner.dart');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();

      // Prohibited dev wording in user-facing UI
      expect(content.contains("'بيانات تجريبية'"), isFalse);
      expect(content.contains('"بيانات تجريبية"'), isFalse);
      expect(content.contains("'معاينة'"), isFalse);
      expect(content.contains('"معاينة"') && !content.contains('سيناريوهات المعاينة والتحقق'), isFalse);
      expect(content.contains("'MR-12'"), isFalse);
      expect(content.contains("'MR-13'"), isFalse);
      expect(content.contains("'BK-"), isFalse);
      expect(content.contains('"BK-'), isFalse);
      expect(content.contains("'PRELIVE #186'"), isFalse);
      expect(content.contains('"PRELIVE #186"'), isFalse);
      expect(content.contains('استفسار تجريبي لمراجعة'), isFalse);
    });

    test('Runner source contains ZERO unapproved contact channels (fake phone/WhatsApp/email)', () {
      final file = File('tool/screen21_preview_runner.dart');
      final content = file.readAsStringSync();

      expect(content.contains('+20'), isFalse);
      expect(content.contains('whatsapp'), isFalse);
      expect(content.contains('واتساب'), isFalse);
      expect(content.contains('support@konfrm.com'), isFalse);
      expect(content.contains('24/7'), isFalse);
    });
  });

  group('Screen 21 — Issue #175 Pure-Black & Design Compliance', () {
    test('Runner source contains ZERO forbidden charcoal or navy color values', () {
      final file = File('tool/screen21_preview_runner.dart');
      final content = file.readAsStringSync();

      expect(content.contains('0xFF111827'), isFalse);
      expect(content.contains('0xFF1F2937'), isFalse);
      expect(content.contains('0xFF0F172A'), isFalse);
    });
  });

  group('Screen 21 — Widget & Visual Presentation Tests', () {
    testWidgets('Renders canonical NESTED_CUSTOMER app bar without bottom nav', (tester) async {
      await tester.pumpWidget(const Screen21PreviewApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('screen21_app_bar_title')), findsOneWidget);
      expect(find.text('المساعدة والدعم'), findsOneWidget);
      expect(find.byKey(const Key('screen21_back_button')), findsOneWidget);

      // Verify NO bottom navigation bar exists
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(BottomNavigationBar), findsNothing);
    });

    testWidgets('Renders search input and category filter chips', (tester) async {
      await tester.pumpWidget(const Screen21PreviewApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('help_search_field')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_all')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_bookings')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_paymentsAndDeposit')), findsOneWidget);
      expect(find.byKey(const Key('category_chip_account')), findsOneWidget);
    });

    testWidgets('Tapping category chip filters displayed FAQ items', (tester) async {
      await tester.pumpWidget(const Screen21PreviewApp());
      await tester.pumpAndSettle();

      // All category shows 5 items
      expect(find.byKey(const Key('faq_item_faq_deposit_meaning')), findsOneWidget);
      expect(find.byKey(const Key('faq_item_faq_stay_duration')), findsOneWidget);

      // Tap payments category chip
      await tester.tap(find.byKey(const Key('category_chip_paymentsAndDeposit')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('faq_item_faq_deposit_meaning')), findsOneWidget);
      expect(find.byKey(const Key('faq_item_faq_stay_duration')), findsNothing);
    });

    testWidgets('Tapping FAQ item expands and shows answer', (tester) async {
      await tester.pumpWidget(const Screen21PreviewApp());
      await tester.pumpAndSettle();

      expect(find.text('يمثل عربون الليلة الأولى دفعة تأكيدية لحجز الوحدة، ويتم تحصيله إلكترونياً فقط بعد موافقة المالك على طلب الحجز. لا يُعد العربون كامل تكلفة الإقامة بل يُخصم من إجمالي القيمة.'), findsNothing);

      await tester.tap(find.byKey(const Key('faq_header_faq_deposit_meaning')));
      await tester.pumpAndSettle();

      expect(find.text('يمثل عربون الليلة الأولى دفعة تأكيدية لحجز الوحدة، ويتم تحصيله إلكترونياً فقط بعد موافقة المالك على طلب الحجز. لا يُعد العربون كامل تكلفة الإقامة بل يُخصم من إجمالي القيمة.'), findsOneWidget);
    });

    testWidgets('Typing unmatched query displays empty search state', (tester) async {
      await tester.pumpWidget(const Screen21PreviewApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('help_search_field')), 'سيارة خاصة');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('help_search_empty_state')), findsOneWidget);
      expect(find.text('لا توجد نتائج مطابقة لـ "سيارة خاصة"'), findsOneWidget);
      expect(find.byKey(const Key('reset_search_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('reset_search_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('help_search_empty_state')), findsNothing);
    });

    testWidgets('Opening contact form displays topic selector, description, and submit CTA', (tester) async {
      await tester.pumpWidget(const Screen21PreviewApp());
      await tester.pumpAndSettle();

      final openBtn = find.byKey(const Key('open_contact_form_button'));
      await tester.ensureVisible(openBtn);
      expect(openBtn, findsOneWidget);

      await tester.tap(openBtn);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('contact_form_card')), findsOneWidget);
      expect(find.byKey(const Key('topic_dropdown_selector')), findsOneWidget);
      expect(find.byKey(const Key('inquiry_description_field')), findsOneWidget);
      expect(find.byKey(const Key('submit_inquiry_button')), findsOneWidget);
    });

    testWidgets('Booking context displays booking reference and default OFF consent checkbox', (tester) async {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.contactFormBookingDefaultOff);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen21PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final contextContainer = find.byKey(const Key('booking_context_container'));
      await tester.ensureVisible(contextContainer);
      expect(contextContainer, findsOneWidget);
      expect(find.text('رقم الحجز: 183223'), findsOneWidget);

      // Verify consent checkbox is default unchecked (Amendment 3)
      final checkboxFinder = find.byKey(const Key('booking_consent_checkbox'));
      expect(checkboxFinder, findsOneWidget);
      final Checkbox checkboxWidget = tester.widget(checkboxFinder);
      expect(checkboxWidget.value, isFalse);

      // Tap consent checkbox row
      final checkboxRow = find.byKey(const Key('booking_consent_checkbox_row'));
      await tester.ensureVisible(checkboxRow);
      await tester.tap(checkboxRow);
      await tester.pumpAndSettle();

      final Checkbox updatedCheckbox = tester.widget(find.byKey(const Key('booking_consent_checkbox')));
      expect(updatedCheckbox.value, isTrue);
    });

    testWidgets('Validation error is displayed when description is under 10 chars', (tester) async {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.contactFormGeneral);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen21PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final descField = find.byKey(const Key('inquiry_description_field'));
      await tester.ensureVisible(descField);
      await tester.enterText(descField, 'مرحبا');

      final submitBtn = find.byKey(const Key('submit_inquiry_button'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('form_validation_error_text')), findsOneWidget);
      expect(find.text('يرجى كتابة 10 أحرف على الأقل لشرح استفسارك'), findsOneWidget);
    });

    testWidgets('Timeout uncertain notice renders review draft button, hides submit CTA, and preserves draft', (tester) async {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.submissionTimeoutUncertain);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen21PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final notice = find.byKey(const Key('timeout_uncertain_notice'));
      await tester.ensureVisible(notice);
      expect(notice, findsOneWidget);
      expect(find.text('تعذر تأكيد استلام الطلب حالياً'), findsOneWidget);

      // Verify submit CTA is hidden to prevent accidental duplicate submission
      expect(find.byKey(const Key('submit_inquiry_button')), findsNothing);

      // Verify sole action is review draft
      final reviewBtn = find.byKey(const Key('review_inquiry_button'));
      await tester.ensureVisible(reviewBtn);
      expect(reviewBtn, findsOneWidget);
      expect(find.text('مراجعة الاستفسار'), findsOneWidget);

      await tester.tap(reviewBtn);
      await tester.pumpAndSettle();

      // After review, notice disappears and submit button returns
      expect(find.byKey(const Key('timeout_uncertain_notice')), findsNothing);
      expect(find.byKey(const Key('submit_inquiry_button')), findsOneWidget);
      expect(controller.descriptionText, isNotEmpty);
    });

    testWidgets('Unauthenticated guest state shields contact form with login barrier', (tester) async {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.guestPublicHelp);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen21PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Public FAQs are visible
      expect(find.byKey(const Key('faq_item_faq_deposit_meaning')), findsOneWidget);

      // Contact form is replaced with login requirement card
      expect(find.byKey(const Key('guest_login_shield_card')), findsOneWidget);
      expect(find.text('تسجيل الدخول مطلوب للتواصل'), findsOneWidget);
      expect(find.byKey(const Key('guest_login_button')), findsOneWidget);
      expect(find.byKey(const Key('contact_form_card')), findsNothing);
    });

    testWidgets('Accessibility 200% font scale reflows without overflow exceptions and topic selector is readable', (tester) async {
      final controller = CustomerHelpSupportController();
      controller.setScenario(Screen21Scenario.accessibility200Form);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Screen21PreviewView(controller: controller),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('contact_form_card')), findsOneWidget);
      expect(find.byKey(const Key('submit_inquiry_button')), findsOneWidget);

      // Verify topic selector is present, has minHeight constraint, and displays selected topic without clipping
      final selectorFinder = find.byKey(const Key('topic_dropdown_selector'));
      await tester.ensureVisible(selectorFinder);
      expect(selectorFinder, findsOneWidget);

      final labelFinder = find.byKey(const Key('selected_topic_label'));
      expect(labelFinder, findsOneWidget);
      expect(find.text('استفسار عن حجز حالي أو سابق'), findsOneWidget);

      // Tap topic selector to open bottom sheet modal at 200% text scale
      await tester.tap(selectorFinder);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('اختيار موضوع الاستفسار'), findsOneWidget);
      expect(find.text('استفسار عام عن الحساب'), findsOneWidget);

      // Scroll to and tap on an option to select and close
      final optionFinder = find.text('استفسار عام عن الحساب');
      await tester.ensureVisible(optionFinder);
      await tester.tap(optionFinder, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('استفسار عام عن الحساب'), findsOneWidget);
    });
  });
}
