// =============================================================================
// KONFRM Customer Screen 22 — Source-Linked Behavioral & Verification Tests
//
// Governing Issues:
//   - Issue #191 (Screen 22 Booking-Scoped Chat Founder Execution Contract)
//   - Issue #192 (Complete 22-Screen Design Audit & Universal Back-Arrow Rule)
//   - Issue #190 (Deferred Chat Backend, Push & Supabase Realtime Prelive Gate)
//   - Issue #183 (Mandatory Design Skills Activation, Design Court & Platform Gate)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository-Wide Audit)
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
      expect(controller.bookingDates, contains('14 – 18 يوليو 2026'));
      expect(controller.ownerDisplayName, equals('المالك'));
      expect(controller.messages.length, equals(3));
      expect(controller.draftText, isEmpty);
      expect(controller.isGuest, isFalse);
      expect(controller.isThreadAvailable, isTrue);
      expect(controller.isOffline, isFalse);
      expect(controller.isTimeoutUncertain, isFalse);
      expect(controller.isDeliveryFailed, isFalse);
      expect(controller.isBookingDetailsExpanded, isFalse);
      expect(controller.lastNavigationIntent, isEmpty);
    });

    test('Base conversation fixtures contain only approved rental coordination facts', () {
      expect(kBaseConversationMessages.length, equals(3));

      final msg1 = kBaseConversationMessages[0];
      expect(msg1.senderRole, equals(ChatParticipantRole.owner));
      expect(msg1.contentArabic, contains('يسعدنا استقبالك في الفيلا'));
      expect(msg1.contentArabic, isNot(contains('تم تأكيد حجزك')));
      expect(msg1.status, equals(MessageDeliveryStatus.sent));

      final msg2 = kBaseConversationMessages[1];
      expect(msg2.senderRole, equals(ChatParticipantRole.customer));
      expect(msg2.contentArabic, contains('مسار وصول'));
      expect(msg2.status, equals(MessageDeliveryStatus.sent));

      final msg3 = kBaseConversationMessages[2];
      expect(msg3.senderRole, equals(ChatParticipantRole.owner));
      expect(msg3.contentArabic, contains('تم استلام استفسارك'));
      expect(msg3.contentArabic, isNot(contains('المسار مباشر وسهل')));
      expect(msg3.contentArabic, isNot(contains('تتسع لسيارتين')));
      expect(msg3.status, equals(MessageDeliveryStatus.sent));
    });

    test('Scenario transitions accurately update controller state and fixtures', () {
      final controller = CustomerBookingChatController();

      // 02 Expanded disclosure
      controller.setScenario(Screen22Scenario.bookingDisclosureExpanded);
      expect(controller.isBookingDetailsExpanded, isTrue);

      // 03 Scrolled long
      controller.setScenario(Screen22Scenario.threadScrolledLong);
      expect(controller.messages.length, equals(5));
      expect(controller.draftText, isEmpty);

      // 04 Composer draft
      controller.setScenario(Screen22Scenario.composerDraftActive);
      expect(controller.draftText, isNotEmpty);
      expect(controller.messages.length, equals(3));

      // 05 Sending pending
      controller.setScenario(Screen22Scenario.messageSendingPending);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.sending));

      // 06 Timeout uncertain
      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);
      expect(controller.isTimeoutUncertain, isTrue);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.unknownTimeout));

      // 07 Delivery failed
      controller.setScenario(Screen22Scenario.messageDeliveryFailed);
      expect(controller.isDeliveryFailed, isTrue);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.failed));

      // 08 Offline
      controller.setScenario(Screen22Scenario.offlineState);
      expect(controller.isOffline, isTrue);

      // 09 Unauthorized guest
      controller.setScenario(Screen22Scenario.unauthorizedGuestBarrier);
      expect(controller.isGuest, isTrue);
      expect(controller.messages, isEmpty);
      expect(controller.isBookingDetailsExpanded, isFalse);

      // 10 Unavailable thread
      controller.setScenario(Screen22Scenario.unavailableThread);
      expect(controller.isThreadAvailable, isFalse);
      expect(controller.messages, isEmpty);
      expect(controller.isBookingDetailsExpanded, isFalse);
    });

    test('Uncertain draft restoration and retry operations update state correctly', () {
      final controller = CustomerBookingChatController();

      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);
      expect(controller.isTimeoutUncertain, isTrue);
      expect(controller.hasUnresolvedUncertainMessage, isTrue);
      controller.restoreDraftFromUncertain();
      expect(controller.isReviewingUncertainDraft, isTrue);
      expect(controller.hasUnresolvedUncertainMessage, isTrue);

      controller.setScenario(Screen22Scenario.messageDeliveryFailed);
      expect(controller.isDeliveryFailed, isTrue);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.failed));
      controller.retryFailedMessage();
      expect(controller.isDeliveryFailed, isFalse);
      expect(controller.messages.last.status, equals(MessageDeliveryStatus.sending));
    });

    test('Local message send creates optimistic draft without phantom server claims', () {
      final controller = CustomerBookingChatController();
      controller.setDraftText('استفسار محلي جديد');
      controller.sendMessage();

      expect(controller.messages.length, equals(4));
      final sent = controller.messages.last;
      expect(sent.senderRole, equals(ChatParticipantRole.customer));
      expect(sent.contentArabic, equals('استفسار محلي جديد'));
      expect(sent.status, equals(MessageDeliveryStatus.sending));
      expect(controller.draftText, isEmpty);
    });
  });

  group('Screen 22 — Widget Hierarchy & Founder Navigation Contract', () {
    testWidgets('App Bar renders canonical Back button, title, chevron, and far-left booking link', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      // Back button exists on physical right
      expect(find.byKey(const Key('screen22_back_button')), findsOneWidget);

      // Title «محادثة الحجز» exists
      expect(find.byKey(const Key('screen22_app_bar_title')), findsOneWidget);
      expect(find.text('محادثة الحجز'), findsOneWidget);

      // Disclosure chevron exists next to title
      expect(find.byKey(const Key('screen22_booking_disclosure_button')), findsOneWidget);

      // Far-left booking number link exists
      expect(find.byKey(const Key('screen22_booking_reference_link')), findsOneWidget);
      expect(find.text('رقم الحجز 183223'), findsOneWidget);

      // Verify purged clutter: no persistent subtitle, strip, or scope notice
      expect(find.byKey(const Key('screen22_app_bar_subtitle')), findsNothing);
      expect(find.byKey(const Key('booking_context_strip')), findsNothing);
      expect(find.text('هذه المحادثة مخصصة لترتيبات هذا الحجز بينك وبين المالك فقط'), findsNothing);
    });

    testWidgets('Back button tapping records navigation intent to Screen 13', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('screen22_back_button')));
      await tester.pump();

      expect(controller.lastNavigationIntent, equals('SCREEN_13_BOOKING_DETAILS'));
    });

    testWidgets('Far-left booking reference link records navigation intent to Screen 13', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('screen22_booking_reference_link')));
      await tester.pump();

      expect(controller.lastNavigationIntent, equals('SCREEN_13_BOOKING_DETAILS'));
    });

    testWidgets('Tapping disclosure chevron toggles booking details panel expansion', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      // Initially collapsed
      expect(find.byKey(const Key('screen22_booking_expanded_panel')), findsNothing);
      expect(controller.isBookingDetailsExpanded, isFalse);

      // Tap to expand
      await tester.tap(find.byKey(const Key('screen22_booking_disclosure_button')));
      await tester.pump();

      expect(controller.isBookingDetailsExpanded, isTrue);
      expect(find.byKey(const Key('screen22_booking_expanded_panel')), findsOneWidget);
      expect(find.text('فيلا لؤلؤة البحر — مراسي'), findsOneWidget);
      expect(find.text('مؤكد'), findsOneWidget);

      // Tap again to collapse
      await tester.tap(find.byKey(const Key('screen22_booking_disclosure_button')));
      await tester.pump();

      expect(controller.isBookingDetailsExpanded, isFalse);
      expect(find.byKey(const Key('screen22_booking_expanded_panel')), findsNothing);
    });

    testWidgets('Guest and unavailable states hide booking reference, chevron, and thread metadata', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.unauthorizedGuestBarrier);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('screen22_booking_disclosure_button')), findsNothing);
      expect(find.byKey(const Key('screen22_booking_reference_link')), findsNothing);
      expect(find.byKey(const Key('chat_guest_barrier_card')), findsOneWidget);
      expect(find.byKey(const Key('chat_message_list')), findsNothing);
      expect(find.byKey(const Key('chat_message_composer')), findsNothing);
    });
  });

  group('Screen 22 — Role Grammar & Physical Geometry Verification', () {
    testWidgets('Customer bubble is WHITE on physical LEFT; Owner bubble is BLACK on physical RIGHT', (tester) async {
      final controller = CustomerBookingChatController();
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;

      // msg_01 is Owner
      final ownerBubbleFinder = find.byKey(const Key('message_bubble_msg_01'));
      expect(ownerBubbleFinder, findsOneWidget);
      final ownerRect = tester.getRect(ownerBubbleFinder);

      // Owner bubble must be physically on the RIGHT side of the screen
      expect(ownerRect.right, greaterThan(screenWidth * 0.70));

      // Owner avatar must be physically to the RIGHT of the Owner bubble
      final ownerAvatarFinder = find.byKey(const Key('owner_avatar_msg_01'));
      expect(ownerAvatarFinder, findsOneWidget);
      final ownerAvatarRect = tester.getRect(ownerAvatarFinder);
      expect(ownerAvatarRect.left, greaterThanOrEqualTo(ownerRect.right));

      // msg_02 is Customer
      final customerBubbleFinder = find.byKey(const Key('message_bubble_msg_02'));
      expect(customerBubbleFinder, findsOneWidget);
      final customerRect = tester.getRect(customerBubbleFinder);

      // Customer bubble must be physically on the LEFT side of the screen
      expect(customerRect.left, lessThan(screenWidth * 0.30));

      // Customer avatar must be physically to the LEFT of the Customer bubble
      final customerAvatarFinder = find.byKey(const Key('customer_avatar_msg_02'));
      expect(customerAvatarFinder, findsOneWidget);
      final customerAvatarRect = tester.getRect(customerAvatarFinder);
      expect(customerAvatarRect.right, lessThanOrEqualTo(customerRect.left));

      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Owner bubble has PURE BLACK background; Customer bubble has WHITE background', (tester) async {
      final controller = CustomerBookingChatController();
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      // Check Owner Container decoration
      final ownerBubbleContainer = tester.widget<Container>(
        find.byKey(const Key('message_bubble_msg_01')),
      );
      final ownerDeco = ownerBubbleContainer.decoration as BoxDecoration;
      expect(ownerDeco.color, equals(const Color(0xFF000000)));

      // Check Customer Container decoration
      final customerBubbleContainer = tester.widget<Container>(
        find.byKey(const Key('message_bubble_msg_02')),
      );
      final customerDeco = customerBubbleContainer.decoration as BoxDecoration;
      expect(customerDeco.color, equals(Colors.white));
      expect(customerDeco.border, isNotNull);
    });

    testWidgets('Back button is physically on the RIGHT side of the app bar', (tester) async {
      final controller = CustomerBookingChatController();
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
      final backButtonRect = tester.getRect(find.byKey(const Key('screen22_back_button')));

      // In RTL, the physical RIGHT side is near screenWidth
      expect(backButtonRect.right, greaterThan(screenWidth * 0.85));

      // Booking link is on the physical FAR LEFT
      final linkRect = tester.getRect(find.byKey(const Key('screen22_booking_reference_link')));
      expect(linkRect.left, lessThan(screenWidth * 0.35));

      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });

  group('Screen 22 — Offline, Uncertainty & Failure States', () {
    testWidgets('Offline scenario displays neutral status indicator without amber banner or auto-send promises', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.offlineState);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('screen22_offline_indicator')), findsOneWidget);
      expect(find.text('لا يوجد اتصال بالإنترنت — وضع تحرير المسودة نشط'), findsOneWidget);

      // Verify purged amber banner:
      expect(find.byKey(const Key('screen22_offline_banner')), findsNothing);
      expect(find.textContaining('سيتم إرسالها فور استعادة الاتصال'), findsNothing);
    });

    testWidgets('Submission timeout uncertain notice provides single review draft button and locks duplicate send', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('screen22_timeout_uncertain_notice')), findsOneWidget);
      expect(find.text('تعذر تأكيد تسليم الرسالة من الخادم'), findsOneWidget);
      expect(find.text('نص رسالتك ما زال هنا للمراجعة.'), findsOneWidget);
      expect(find.byKey(const Key('screen22_review_draft_button')), findsOneWidget);

      // Verify send button is disabled during timeout uncertainty
      final sendMaterialBefore = tester.widget<Material>(find.byKey(const Key('chat_send_material')));
      expect(sendMaterialBefore.color, const Color(0xFFE5E7EB));

      // Attempting to tap send does not dispatch a new message
      final countBefore = controller.messages.length;
      await tester.tap(find.byKey(const Key('chat_send_button')));
      await tester.pump();
      expect(controller.messages.length, countBefore);

      // Tap "Review Draft" button
      await tester.tap(find.byKey(const Key('screen22_review_draft_button')));
      await tester.pump();

      // State transitions to review mode, BUT uncertainty is NOT cleared and Send remains strictly LOCKED
      expect(controller.isReviewingUncertainDraft, isTrue);
      expect(controller.hasUnresolvedUncertainMessage, isTrue);
      expect(controller.isTimeoutUncertain, isTrue);

      // Notice updates to truthful frozen-send copy
      expect(find.text('المسودة معروضة للمراجعة (الإرسال مجمّد)'), findsOneWidget);
      expect(find.textContaining('تم تجميد زر الإرسال لتجنب تكرار الرسالة'), findsOneWidget);
      expect(find.text('المسودة قيد المراجعة'), findsOneWidget);

      // Verify Send button is STILL disabled (neutral gray #E5E7EB) after tapping review draft
      final sendMaterialAfter = tester.widget<Material>(find.byKey(const Key('chat_send_material')));
      expect(sendMaterialAfter.color, const Color(0xFFE5E7EB));

      // Attempting to send while reviewing uncertain draft does NOT dispatch a new message
      await tester.tap(find.byKey(const Key('chat_send_button')));
      await tester.pump();
      expect(controller.messages.length, countBefore);
      controller.sendMessage();
      expect(controller.messages.length, countBefore);

      // Repeat interactions: tapping review button again remains safe and keeps send locked
      await tester.tap(find.byKey(const Key('screen22_review_draft_button')));
      await tester.pump();
      expect(controller.isReviewingUncertainDraft, isTrue);
      expect(controller.hasUnresolvedUncertainMessage, isTrue);
      final sendMaterialRepeat = tester.widget<Material>(find.byKey(const Key('chat_send_material')));
      expect(sendMaterialRepeat.color, const Color(0xFFE5E7EB));

      // Editing draft text also keeps send button locked
      controller.setDraftText('تعديل تجريبي على المسودة للتأكد من استمرار تجميد الإرسال');
      await tester.pump();
      final sendMaterialEdited = tester.widget<Material>(find.byKey(const Key('chat_send_material')));
      expect(sendMaterialEdited.color, const Color(0xFFE5E7EB));
      controller.sendMessage();
      expect(controller.messages.length, countBefore);
    });

    testWidgets('Offline state disables send button and blocks message dispatch', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.offlineState);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(controller.isOffline, isTrue);

      // Verify send button is disabled in offline state
      final sendMaterial = tester.widget<Material>(find.byKey(const Key('chat_send_material')));
      expect(sendMaterial.color, const Color(0xFFE5E7EB));

      // Attempting to send while offline does not append a message
      final countBefore = controller.messages.length;
      controller.sendMessage();
      expect(controller.messages.length, countBefore);
    });

    testWidgets('Delivery failed notice provides retry button without fake duplicate-safe claims', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.messageDeliveryFailed);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('screen22_delivery_failed_notice')), findsOneWidget);
      expect(find.text('تعذر إرسال الرسالة'), findsOneWidget);
      expect(find.textContaining('بأمان دون تكرار'), findsNothing);
      expect(find.byKey(const Key('screen22_retry_send_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('screen22_retry_send_button')));
      await tester.pump();

      expect(controller.isDeliveryFailed, isFalse);
    });
  });

  group('Screen 22 — Accessibility 200% Font Scale Reflow', () {
    testWidgets('200% font scale reflows conversation and composer without RenderFlex overflow', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.accessibility200Composer);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('chat_message_composer')), findsOneWidget);
      expect(find.byKey(const Key('chat_send_button')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Expanded booking details under 200% font scale renders without overflow', (tester) async {
      final controller = CustomerBookingChatController();
      controller.setScenario(Screen22Scenario.accessibility200Thread);
      controller.setBookingDetailsExpanded(true);

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Screen22PreviewView(controller: controller),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('screen22_booking_expanded_panel')), findsOneWidget);
      expect(find.text('فيلا لؤلؤة البحر — مراسي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
