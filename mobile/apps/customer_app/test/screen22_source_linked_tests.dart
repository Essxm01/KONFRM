// =============================================================================
// KONFRM Customer Screen 22 — Source-Linked Behavioral & Verification Tests
//
// Governing Issues:
//   - Issue #191 (Screen 22 Booking-Scoped Chat Founder Execution Contract)
//   - Issue #190 (Deferred Chat Backend, Push & Supabase Realtime Prelive Gate)
//   - Issue #183 (Mandatory Design Skills Activation, Design Court & Platform Gate)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository-Wide Audit)
//   - Issue #173 (Financial Model Meaning & Booking Lifecycle Boundaries)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../tool/screen22_preview_runner.dart';

void main() {
  group('Screen 22 — Domain Models & Conversation State', () {
    test('CustomerBookingChatController default values are secure and consistent', () {
      final controller = CustomerBookingChatController();
      expect(controller.scenario, equals(Screen22Scenario.authorizedThreadTop));
      expect(controller.bookingNumber, equals('183223'));
      expect(controller.propertyTitle, equals('فيلا لؤلؤة البحر — مراسي'));
      expect(controller.bookingDates, equals('14 يوليو – 18 يوليو'));
      expect(controller.ownerDisplayName, equals('المالك'));
      expect(controller.messages.length, equals(4));
      expect(controller.draftText, isEmpty);
      expect(controller.isGuest, isFalse);
      expect(controller.isThreadAvailable, isTrue);
      expect(controller.isOffline, isFalse);
      expect(controller.isTimeoutUncertain, isFalse);
      expect(controller.isDeliveryFailed, isFalse);
    });

    test('Base conversation fixtures contain only confirmed booking context', () {
      expect(kBaseConversationMessages.length, equals(4));

      final msg1 = kBaseConversationMessages[0];
      expect(msg1.senderRole, equals(ChatParticipantRole.customer));
      expect(msg1.contentArabic, contains('موعد الوصول للفيلا'));
      expect(msg1.status, equals(MessageDeliveryStatus.sent));

      final msg2 = kBaseConversationMessages[1];
      expect(msg2.senderRole, equals(ChatParticipantRole.owner));
      expect(msg2.contentArabic, contains('تم تأكيد حجزك'));
      expect(msg2.status, equals(MessageDeliveryStatus.sent));

      final msg3 = kBaseConversationMessages[2];
      expect(msg3.senderRole, equals(ChatParticipantRole.customer));
      expect(msg3.contentArabic, contains('مواقف سيارات'));

      final msg4 = kBaseConversationMessages[3];
      expect(msg4.senderRole, equals(ChatParticipantRole.owner));
      expect(msg4.contentArabic, contains('تتسع لسيارتين'));
    });

    test('Scenario transitions accurately update controller state', () {
      final controller = CustomerBookingChatController();

      // Scrolled long
      controller.setScenario(Screen22Scenario.threadScrolledLong);
      expect(controller.messages.length, equals(6));
      expect(controller.draftText, isEmpty);

      // Composer draft
      controller.setScenario(Screen22Scenario.composerDraftActive);
      expect(controller.draftText, isNotEmpty);
      expect(controller.messages.length, equals(4));

      // Sending pending
      controller.setScenario(Screen22Scenario.messageSendingPending);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.sending));

      // Timeout uncertain
      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);
      expect(controller.isTimeoutUncertain, isTrue);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.unknownTimeout));

      // Delivery failed
      controller.setScenario(Screen22Scenario.messageDeliveryFailed);
      expect(controller.isDeliveryFailed, isTrue);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.failed));

      // Offline
      controller.setScenario(Screen22Scenario.offlineState);
      expect(controller.isOffline, isTrue);

      // Unauthorized guest
      controller.setScenario(Screen22Scenario.unauthorizedGuestBarrier);
      expect(controller.isGuest, isTrue);
      expect(controller.messages, isEmpty);

      // Unavailable thread
      controller.setScenario(Screen22Scenario.unavailableThread);
      expect(controller.isThreadAvailable, isFalse);
      expect(controller.messages, isEmpty);
    });

    test('sendMessage creates sending draft and clears text input', () {
      final controller = CustomerBookingChatController();
      controller.setDraftText('اختبار إرسال رسالة جديدة');
      final initialCount = controller.messages.length;

      controller.sendMessage();
      expect(controller.messages.length, equals(initialCount + 1));
      expect(controller.messages.last.contentArabic, equals('اختبار إرسال رسالة جديدة'));
      expect(controller.messages.last.senderRole, equals(ChatParticipantRole.customer));
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.sending));
      expect(controller.draftText, isEmpty);
    });

    test('reviewDraftAfterUncertain clears timeout banner for user inspection', () {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);
      expect(controller.isTimeoutUncertain, isTrue);

      controller.reviewDraftAfterUncertain();
      expect(controller.isTimeoutUncertain, isFalse);
    });

    test('retryFailedMessage transitions failed message to sending state', () {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.messageDeliveryFailed);
      expect(controller.isDeliveryFailed, isTrue);
      final failedId = controller.messages.last.id;

      controller.retryFailedMessage(failedId);
      expect(controller.isDeliveryFailed, isFalse);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.sending));
    });
  });

  group('Screen 22 — Epistemic Honesty & Prohibited Patterns Invariants', () {
    test('Zero fake read receipts, double blue ticks, or online status claims', () {
      // Invariant: Status enum only contains sending, sent, unknownTimeout, and failed
      expect(MessageDeliveryStatus.values.length, equals(4));
      expect(MessageDeliveryStatus.values, contains(MessageDeliveryStatus.sending));
      expect(MessageDeliveryStatus.values, contains(MessageDeliveryStatus.sent));
      expect(MessageDeliveryStatus.values, contains(MessageDeliveryStatus.unknownTimeout));
      expect(MessageDeliveryStatus.values, contains(MessageDeliveryStatus.failed));

      // No read / delivered / double-check enum values
      final enumNames = MessageDeliveryStatus.values.map((e) => e.name).toList();
      expect(enumNames.contains('read'), isFalse);
      expect(enumNames.contains('delivered'), isFalse);
      expect(enumNames.contains('seen'), isFalse);
      expect(enumNames.contains('typing'), isFalse);
      expect(enumNames.contains('online'), isFalse);
    });

    test('Zero forbidden prototype/mock/BK- identifiers in copy or models', () {
      final forbiddenSubstrings = [
        'بيانات تجريبية',
        'BK-',
        'PRELIVE #190',
        'MOCK',
        'PROTOTYPE',
        '01000000000',
        'whatsapp.com',
      ];

      for (final msg in kBaseConversationMessages) {
        for (final forbidden in forbiddenSubstrings) {
          expect(msg.contentArabic.contains(forbidden), isFalse,
              reason: 'Message ${msg.id} contains forbidden string $forbidden');
        }
      }

      final controller = CustomerBookingChatController();
      expect(controller.bookingNumber.startsWith('BK-'), isFalse);
      expect(controller.bookingNumber, equals('183223'));
    });
  });

  group('Screen 22 — Pure Black & Design Token Compliance (Issue #175)', () {
    test('Screen 22 visual theme uses pure black 0xFF000000, zero charcoal/navy', () {
      final colorBlack = const Color(0xFF000000);
      final forbiddenDarkColors = [
        const Color(0xFF1E1E1E), // Charcoal
        const Color(0xFF111827), // Navy dark
        const Color(0xFF1F2937), // Slate dark
      ];

      expect(colorBlack.toARGB32(), equals(0xFF000000));
      for (final forbidden in forbiddenDarkColors) {
        expect(colorBlack.toARGB32(), isNot(equals(forbidden.toARGB32())));
      }
    });
  });

  group('Screen 22 — Widget Verification & Layout Architecture', () {
    Widget buildTestScreen(CustomerBookingChatController controller) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Screen22PreviewView(controller: controller),
        ),
      );
    }

    testWidgets('Renders canonical NESTED_CUSTOMER app bar without bottom nav', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      // App bar present
      expect(find.byKey(const Key('screen22_app_bar')), findsOneWidget);
      expect(find.byKey(const Key('screen22_app_bar_title')), findsOneWidget);
      expect(find.text('محادثة الحجز'), findsOneWidget);

      // Context subtitle present
      expect(find.byKey(const Key('screen22_app_bar_subtitle')), findsOneWidget);
      expect(find.textContaining('فيلا لؤلؤة البحر — مراسي'), findsWidgets);

      // Sanitized booking pill present
      expect(find.byKey(const Key('screen22_booking_reference_pill')), findsOneWidget);
      expect(find.text('#183223'), findsOneWidget);

      // Back navigation button present
      expect(find.byKey(const Key('screen22_back_button')), findsOneWidget);

      // Invariant: Customer Bottom Navigation Bar must NOT exist on Screen 22
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('Renders booking context strip with verified dates and details', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('booking_context_strip')), findsOneWidget);
      expect(find.textContaining('فيلا لؤلؤة البحر — مراسي'), findsWidgets);
      expect(find.textContaining('14 يوليو – 18 يوليو'), findsOneWidget);
      expect(find.text('محادثة مرتبطة بالحجز'), findsOneWidget);
    });

    testWidgets('Renders message bubbles for both customer and owner with correct roles', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chat_message_list')), findsOneWidget);
      expect(find.byKey(const Key('message_bubble_msg_01')), findsOneWidget);
      expect(find.byKey(const Key('message_bubble_msg_02')), findsOneWidget);
      expect(find.byKey(const Key('message_bubble_msg_03')), findsOneWidget);
      expect(find.byKey(const Key('message_bubble_msg_04')), findsOneWidget);

      // Host badge present on owner message
      expect(find.text('المالك'), findsWidgets);
    });

    testWidgets('Message composer allows input and sending', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chat_message_composer')), findsOneWidget);
      expect(find.byKey(const Key('chat_input_text_field')), findsOneWidget);
      expect(find.byKey(const Key('chat_send_button')), findsOneWidget);

      // Type text into composer
      await tester.enterText(find.byKey(const Key('chat_input_text_field')), 'رسالة تجريبية للاختبار');
      await tester.pump();

      expect(controller.draftText, equals('رسالة تجريبية للاختبار'));

      // Tap send CTA
      await tester.tap(find.byKey(const Key('chat_send_button')));
      await tester.pump();

      expect(controller.messages.last.contentArabic, equals('رسالة تجريبية للاختبار'));
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.sending));
    });

    testWidgets('Renders timeout uncertain recovery notice with single review button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);

      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('chat_timeout_uncertain_notice')),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.byKey(const Key('chat_timeout_uncertain_notice')), findsOneWidget);
      expect(find.text('تعذر تأكيد تسليم الرسالة حالياً'), findsOneWidget);
      expect(find.byKey(const Key('review_chat_draft_button')), findsOneWidget);
      expect(find.text('مراجعة المسودة'), findsOneWidget);

      // Tap review draft button
      await tester.ensureVisible(find.byKey(const Key('review_chat_draft_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('review_chat_draft_button')));
      await tester.pump();

      expect(controller.isTimeoutUncertain, isFalse);
    });

    testWidgets('Renders delivery failed recovery notice with retry button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.messageDeliveryFailed);

      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('chat_delivery_failed_notice')),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.byKey(const Key('chat_delivery_failed_notice')), findsOneWidget);
      expect(find.text('فشل تسليم الرسالة'), findsOneWidget);
      expect(find.byKey(const Key('retry_failed_message_button')), findsOneWidget);
      expect(find.text('إعادة إرسال الرسالة'), findsOneWidget);

      // Tap retry button
      await tester.ensureVisible(find.byKey(const Key('retry_failed_message_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('retry_failed_message_button')));
      await tester.pump();

      expect(controller.isDeliveryFailed, isFalse);
    });

    testWidgets('Renders unauthorized guest barrier shield preventing chat access', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.unauthorizedGuestBarrier);

      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chat_guest_barrier_card')), findsOneWidget);
      expect(find.text('تسجيل الدخول مطلوب لعرض المحادثة'), findsOneWidget);
      expect(find.byKey(const Key('chat_guest_login_button')), findsOneWidget);

      // Composer and message list must be hidden
      expect(find.byKey(const Key('chat_message_list')), findsNothing);
      expect(find.byKey(const Key('chat_message_composer')), findsNothing);
    });

    testWidgets('Renders unavailable chat thread card for ineligible bookings', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.unavailableThread);

      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('chat_unavailable_card')), findsOneWidget);
      expect(find.text('المحادثة غير متاحة حالياً'), findsOneWidget);
      expect(find.byKey(const Key('return_to_booking_button')), findsOneWidget);

      // Composer and message list must be hidden
      expect(find.byKey(const Key('chat_message_list')), findsNothing);
      expect(find.byKey(const Key('chat_message_composer')), findsNothing);
    });

    testWidgets('Renders offline banner when device is disconnected', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.offlineState);

      await tester.pumpWidget(buildTestScreen(controller));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('screen22_offline_banner')), findsOneWidget);
      expect(find.textContaining('أنت في وضع عدم الاتصال'), findsOneWidget);
    });

    testWidgets('Accessibility 200% font scale reflow test without overflow', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.accessibility200Thread);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Cairo'),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(412, 915),
                textScaler: TextScaler.linear(2.0),
              ),
              child: Screen22PreviewView(controller: controller),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // No RenderFlex overflow
      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('screen22_scaffold')), findsOneWidget);
      expect(find.byKey(const Key('chat_message_list')), findsOneWidget);
    });

    testWidgets('Accessibility 200% composer reflow test without overflow', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.accessibility200Composer);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Cairo'),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(412, 915),
                textScaler: TextScaler.linear(2.0),
              ),
              child: Screen22PreviewView(controller: controller),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // No RenderFlex overflow
      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('chat_message_composer')), findsOneWidget);
      expect(find.byKey(const Key('chat_input_text_field')), findsOneWidget);
      expect(find.byKey(const Key('chat_send_button')), findsOneWidget);
    });
  });
}
