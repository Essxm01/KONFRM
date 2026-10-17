// =============================================================================
// KONFRM Customer Screen 22 — Booking-Scoped Chat («محادثة الحجز»)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Physical Device: [REDACTED_A56_ID]
// Design Authority: Cairo Typography, RTL First, Pure Monochrome & Neutrals
// Navigation Context: Nested Customer Destination (Canonical NESTED_CUSTOMER)
// Bottom Navigation: HIDDEN (Per canonical DESIGN_SYSTEM/COMPONENTS/navigation.md §3.3)
// Origin Screen: Screen 13 (Booking Details / Stay Hub)
// Return Route: Returns to originating booking via physical RIGHT-pointing Back arrow [➔]
// Governing Issues:
//   - Issue #191 (Screen 22 Booking Chat Founder Execution Contract & Review Correction)
//   - Issue #192 (Complete 22-Screen Design Audit & Universal Back-Arrow Rule)
//   - Issue #190 (Deferred Chat Realtime, WebSockets, Push, ACL & Prelive Gate)
//   - Issue #185 (Screen 21 Approval & Freeze Baseline)
//   - Issue #183 (Mandatory Design Skills Activation, Design Court & Platform Gate)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository-Wide Audit)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
//
// Scope: Founder Layout Correction V1:
//   1. Physical RIGHT Back button with arrowhead visibly pointing RIGHT [➔].
//   2. Calm single-line header with title «محادثة الحجز», collapsible disclosure chevron,
//      and far-LEFT tappable booking reference link «رقم الحجز 183223» to Screen 13.
//   3. Role Grammar: Customer WHITE bubble physically LEFT with avatar on LEFT;
//      Owner PURE BLACK #000000 bubble physically RIGHT with avatar on RIGHT.
//   4. Purged header clutter: no permanent subtitle, villa/date strip, or scope notice.
//   5. Truthful content: short Arabic rental coordination fixtures, no fake check-in/parking.
//   6. Restrained neutral offline/error states: zero amber banners, no false auto-send promises.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen22PreviewApp());
}

// =============================================================================
// Domain Models & State
// =============================================================================

/// Participant role inside a booking-scoped conversation.
enum ChatParticipantRole {
  customer, // The authenticated guest (Me)
  owner,    // The authorized property host
}

/// Truthful visual delivery status for customer messages.
/// Zero fake delivery claims: read receipts, double blue ticks, and typing status
/// are strictly prohibited per Issue #191 and deferred to PRELIVE Issue #190.
enum MessageDeliveryStatus {
  sending,        // Local optimistic draft in transit (spinner)
  sent,           // Server acknowledged receipt (single check mark)
  unknownTimeout, // Network timeout / uncertain delivery state
  failed,         // Network failure with retry affordance
}

/// Immutable chat message entity.
class ChatMessage {
  final String id;
  final ChatParticipantRole senderRole;
  final String contentArabic;
  final String timestampArabic;
  final MessageDeliveryStatus status;

  const ChatMessage({
    required this.id,
    required this.senderRole,
    required this.contentArabic,
    required this.timestampArabic,
    this.status = MessageDeliveryStatus.sent,
  });

  ChatMessage copyWith({
    String? id,
    ChatParticipantRole? senderRole,
    String? contentArabic,
    String? timestampArabic,
    MessageDeliveryStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderRole: senderRole ?? this.senderRole,
      contentArabic: contentArabic ?? this.contentArabic,
      timestampArabic: timestampArabic ?? this.timestampArabic,
      status: status ?? this.status,
    );
  }
}

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen22Scenario {
  authorizedThreadTop,       // 01 Authorized Thread (Top Fold, collapsed booking details)
  bookingDisclosureExpanded, // 02 Booking Details Disclosure Expanded
  threadScrolledLong,        // 03 Scrolled Long Conversation
  composerDraftActive,       // 04 Composer Active Draft with Send CTA
  messageSendingPending,     // 05 Message Pending Send (Local Optimistic)
  submissionTimeoutUncertain,// 06 Submission Timeout / Uncertain State (Neutral Notice)
  messageDeliveryFailed,     // 07 Confirmed Delivery Failure with Safe Retry
  offlineState,              // 08 Device Offline Neutral Status (No Amber Banner)
  unauthorizedGuestBarrier,  // 09 Unauthenticated Guest Access Barrier
  unavailableThread,         // 10 Unavailable / Ineligible Chat Thread
  accessibility200Thread,    // 11 200% Font Scale Reflow (Conversation Bubbles)
  accessibility200Composer,  // 12 200% Font Scale Reflow (Composer & Multiline Headroom)
}

extension Screen22ScenarioMetadata on Screen22Scenario {
  String get title {
    switch (this) {
      case Screen22Scenario.authorizedThreadTop:
        return '01 Authorized Thread (Top Fold - Collapsed)';
      case Screen22Scenario.bookingDisclosureExpanded:
        return '02 Booking Details Disclosure Expanded';
      case Screen22Scenario.threadScrolledLong:
        return '03 Scrolled Long Conversation';
      case Screen22Scenario.composerDraftActive:
        return '04 Composer Active Draft with Send CTA';
      case Screen22Scenario.messageSendingPending:
        return '05 Message Pending Send (Local Optimistic)';
      case Screen22Scenario.submissionTimeoutUncertain:
        return '06 Submission Timeout / Uncertain State';
      case Screen22Scenario.messageDeliveryFailed:
        return '07 Message Delivery Failure with Safe Retry';
      case Screen22Scenario.offlineState:
        return '08 Offline Neutral Status (Draft Preserved)';
      case Screen22Scenario.unauthorizedGuestBarrier:
        return '09 Unauthenticated Guest Barrier';
      case Screen22Scenario.unavailableThread:
        return '10 Unavailable / Ineligible Chat Thread';
      case Screen22Scenario.accessibility200Thread:
        return '11 Accessibility 200% (Conversation)';
      case Screen22Scenario.accessibility200Composer:
        return '12 Accessibility 200% (Composer Reflow)';
    }
  }
}

// =============================================================================
// Sourced Conversation Fixtures (Natural, Short Rental Coordination)
// =============================================================================

/// Base conversation grounded in approved booking facts (#183223).
/// Zero unverified operational claims: no arrival guarantees, key handover rules,
/// or parking capacity counts.
final List<ChatMessage> kBaseConversationMessages = [
  const ChatMessage(
    id: 'msg_01',
    senderRole: ChatParticipantRole.owner,
    contentArabic: 'مرحباً بك، يسعدنا استقبالك في الفيلا. هل لديك أي استفسار بخصوص تفاصيل الوصول؟',
    timestampArabic: '10:14 ص',
    status: MessageDeliveryStatus.sent,
  ),
  const ChatMessage(
    id: 'msg_02',
    senderRole: ChatParticipantRole.customer,
    contentArabic: 'أهلاً بك، أردت فقط الاستفسار عن أقرب مسار وصول عند البوابة الرئيسية.',
    timestampArabic: '10:18 ص',
    status: MessageDeliveryStatus.sent,
  ),
  const ChatMessage(
    id: 'msg_03',
    senderRole: ChatParticipantRole.owner,
    contentArabic: 'المسار مباشر وسهل، وجميع اللوحات الإرشادية واضحة بمجرد الدخول من البوابة.',
    timestampArabic: '10:22 ص',
    status: MessageDeliveryStatus.sent,
  ),
];

// =============================================================================
// Controller Architecture
// =============================================================================

class CustomerBookingChatController extends ChangeNotifier {
  Screen22Scenario _scenario = Screen22Scenario.authorizedThreadTop;

  // Booking Context Fixtures (Sanitized numeric digits only, no raw BK- prefix)
  final String bookingNumber = '183223';
  final String propertyTitle = 'فيلا لؤلؤة البحر — مراسي';
  final String bookingDates = '14 – 18 يوليو 2026 (4 ليالٍ)';
  final String ownerDisplayName = 'المالك';

  // Dynamic State
  List<ChatMessage> _messages = List.from(kBaseConversationMessages);
  String _draftText = '';
  bool _isGuest = false;
  bool _isThreadAvailable = true;
  bool _isOffline = false;
  bool _isTimeoutUncertain = false;
  bool _isDeliveryFailed = false;
  bool _isBookingDetailsExpanded = false;
  String _lastNavigationIntent = '';

  // Getters
  Screen22Scenario get scenario => _scenario;
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  String get draftText => _draftText;
  bool get isGuest => _isGuest;
  bool get isThreadAvailable => _isThreadAvailable;
  bool get isOffline => _isOffline;
  bool get isTimeoutUncertain => _isTimeoutUncertain;
  bool get isDeliveryFailed => _isDeliveryFailed;
  bool get isBookingDetailsExpanded => _isBookingDetailsExpanded;
  String get lastNavigationIntent => _lastNavigationIntent;

  void toggleBookingDetails() {
    _isBookingDetailsExpanded = !_isBookingDetailsExpanded;
    notifyListeners();
  }

  void setBookingDetailsExpanded(bool expanded) {
    _isBookingDetailsExpanded = expanded;
    notifyListeners();
  }

  void recordNavigationIntent(String destination) {
    _lastNavigationIntent = destination;
    notifyListeners();
  }

  void setScenario(Screen22Scenario newScenario) {
    _scenario = newScenario;
    _isGuest = false;
    _isThreadAvailable = true;
    _isOffline = false;
    _isTimeoutUncertain = false;
    _isDeliveryFailed = false;
    _isBookingDetailsExpanded = (newScenario == Screen22Scenario.bookingDisclosureExpanded);

    switch (newScenario) {
      case Screen22Scenario.authorizedThreadTop:
        _messages = List.from(kBaseConversationMessages);
        _draftText = '';
        break;

      case Screen22Scenario.bookingDisclosureExpanded:
        _messages = List.from(kBaseConversationMessages);
        _draftText = '';
        break;

      case Screen22Scenario.threadScrolledLong:
        _messages = [
          ...kBaseConversationMessages,
          const ChatMessage(
            id: 'msg_04',
            senderRole: ChatParticipantRole.customer,
            contentArabic: 'شكراً جزيلاً لتعاونك، سأوافيك بتوقيت وصولنا فور انطلاقنا.',
            timestampArabic: '10:26 ص',
            status: MessageDeliveryStatus.sent,
          ),
          const ChatMessage(
            id: 'msg_05',
            senderRole: ChatParticipantRole.owner,
            contentArabic: 'على الرحب والسعة دائماً، نتمنى لكم إقامة ممتعة ومريحة.',
            timestampArabic: '10:30 ص',
            status: MessageDeliveryStatus.sent,
          ),
        ];
        _draftText = '';
        break;

      case Screen22Scenario.composerDraftActive:
        _messages = List.from(kBaseConversationMessages);
        _draftText = 'شكراً جزيلاً لتعاونك، سأوافيك بتوقيت وصولنا فور انطلاقنا.';
        break;

      case Screen22Scenario.messageSendingPending:
        _messages = [
          ...kBaseConversationMessages,
          const ChatMessage(
            id: 'msg_pending_01',
            senderRole: ChatParticipantRole.customer,
            contentArabic: 'شكراً لك، سأؤكد لك وقت تحركنا بإذن الله.',
            timestampArabic: '10:32 ص',
            status: MessageDeliveryStatus.sending,
          ),
        ];
        _draftText = '';
        break;

      case Screen22Scenario.submissionTimeoutUncertain:
        _messages = [
          ...kBaseConversationMessages,
          const ChatMessage(
            id: 'msg_timeout_01',
            senderRole: ChatParticipantRole.customer,
            contentArabic: 'أود التأكد من وجود مصعد كهربائي يعمل في مبنى الفيلا.',
            timestampArabic: '10:34 ص',
            status: MessageDeliveryStatus.unknownTimeout,
          ),
        ];
        _draftText = 'أود التأكد من وجود مصعد كهربائي يعمل في مبنى الفيلا.';
        _isTimeoutUncertain = true;
        break;

      case Screen22Scenario.messageDeliveryFailed:
        _messages = [
          ...kBaseConversationMessages,
          const ChatMessage(
            id: 'msg_failed_01',
            senderRole: ChatParticipantRole.customer,
            contentArabic: 'هل تتوفر عربة نقل الأمتعة عند المدخل؟',
            timestampArabic: '10:36 ص',
            status: MessageDeliveryStatus.failed,
          ),
        ];
        _draftText = 'هل تتوفر عربة نقل الأمتعة عند المدخل؟';
        _isDeliveryFailed = true;
        break;

      case Screen22Scenario.offlineState:
        _messages = List.from(kBaseConversationMessages);
        _draftText = 'مسودة رسالة أثناء انقطاع الاتصال...';
        _isOffline = true;
        break;

      case Screen22Scenario.unauthorizedGuestBarrier:
        _messages = [];
        _draftText = '';
        _isGuest = true;
        _isBookingDetailsExpanded = false;
        break;

      case Screen22Scenario.unavailableThread:
        _messages = [];
        _draftText = '';
        _isThreadAvailable = false;
        _isBookingDetailsExpanded = false;
        break;

      case Screen22Scenario.accessibility200Thread:
        _messages = List.from(kBaseConversationMessages);
        _draftText = '';
        break;

      case Screen22Scenario.accessibility200Composer:
        _messages = List.from(kBaseConversationMessages);
        _draftText = 'أود الاستفسار عن تفاصيل إضافية بخصوص إمكانية التنسيق المسبق قبل موعد الحضور.';
        break;
    }

    notifyListeners();
  }

  void setDraftText(String text) {
    _draftText = text;
    notifyListeners();
  }

  /// Sends a local message without creating phantom server delivery claims.
  void sendMessage() {
    final trimmed = _draftText.trim();
    if (trimmed.isEmpty || _isGuest || !_isThreadAvailable) return;

    final newMessage = ChatMessage(
      id: 'msg_local_${DateTime.now().millisecondsSinceEpoch}',
      senderRole: ChatParticipantRole.customer,
      contentArabic: trimmed,
      timestampArabic: 'الآن',
      status: MessageDeliveryStatus.sending,
    );

    _messages = [..._messages, newMessage];
    _draftText = '';
    notifyListeners();
  }

  /// Safe recovery from timeout/uncertain state returning user to draft review.
  void restoreDraftFromUncertain() {
    _isTimeoutUncertain = false;
    notifyListeners();
  }

  /// Safe retry for a failed message without creating duplicates.
  void retryFailedMessage() {
    _isDeliveryFailed = false;
    _messages = _messages.map((m) {
      if (m.id == 'msg_failed_01') {
        return m.copyWith(status: MessageDeliveryStatus.sending);
      }
      return m;
    }).toList();
    notifyListeners();
  }
}

// =============================================================================
// App Root
// =============================================================================

class Screen22PreviewApp extends StatefulWidget {
  const Screen22PreviewApp({super.key});

  @override
  State<Screen22PreviewApp> createState() => _Screen22PreviewAppState();
}

class _Screen22PreviewAppState extends State<Screen22PreviewApp> {
  final CustomerBookingChatController _controller = CustomerBookingChatController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Screen 22 — محادثة الحجز',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: KonfrmTypography.fontFamily,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF000000), // Pure Black #000000
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF000000),
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Canonical Arabic RTL First
          child: child!,
        );
      },
      home: Screen22PreviewView(controller: _controller),
    );
  }
}

// =============================================================================
// Primary Screen View
// =============================================================================

class Screen22PreviewView extends StatefulWidget {
  final CustomerBookingChatController controller;

  const Screen22PreviewView({
    super.key,
    required this.controller,
  });

  @override
  State<Screen22PreviewView> createState() => _Screen22PreviewViewState();
}

class _Screen22PreviewViewState extends State<Screen22PreviewView> {
  final TextEditingController _draftController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showDevTools = false;

  CustomerBookingChatController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerChanged);
    _draftController.text = controller.draftText;
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    _draftController.dispose();
    _scrollController.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.digit1) {
      controller.setScenario(Screen22Scenario.authorizedThreadTop);
      return true;
    } else if (key == LogicalKeyboardKey.digit2) {
      controller.setScenario(Screen22Scenario.bookingDisclosureExpanded);
      return true;
    } else if (key == LogicalKeyboardKey.digit3) {
      controller.setScenario(Screen22Scenario.threadScrolledLong);
      return true;
    } else if (key == LogicalKeyboardKey.digit4) {
      controller.setScenario(Screen22Scenario.composerDraftActive);
      return true;
    } else if (key == LogicalKeyboardKey.digit5) {
      controller.setScenario(Screen22Scenario.messageSendingPending);
      return true;
    } else if (key == LogicalKeyboardKey.digit6) {
      controller.setScenario(Screen22Scenario.submissionTimeoutUncertain);
      return true;
    } else if (key == LogicalKeyboardKey.digit7) {
      controller.setScenario(Screen22Scenario.messageDeliveryFailed);
      return true;
    } else if (key == LogicalKeyboardKey.digit8) {
      controller.setScenario(Screen22Scenario.offlineState);
      return true;
    } else if (key == LogicalKeyboardKey.digit9) {
      controller.setScenario(Screen22Scenario.unauthorizedGuestBarrier);
      return true;
    } else if (key == LogicalKeyboardKey.digit0) {
      controller.setScenario(Screen22Scenario.unavailableThread);
      return true;
    } else if (key == LogicalKeyboardKey.keyA) {
      controller.setScenario(Screen22Scenario.accessibility200Thread);
      return true;
    } else if (key == LogicalKeyboardKey.keyB) {
      controller.setScenario(Screen22Scenario.accessibility200Composer);
      return true;
    } else if (key == LogicalKeyboardKey.keyD) {
      setState(() {
        _showDevTools = !_showDevTools;
      });
      return true;
    }
    return false;
  }

  void _onControllerChanged() {
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_draftController.text != controller.draftText) {
        _draftController.text = controller.draftText;
      }
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          if (controller.scenario == Screen22Scenario.threadScrolledLong ||
              controller.scenario == Screen22Scenario.submissionTimeoutUncertain ||
              controller.scenario == Screen22Scenario.messageDeliveryFailed ||
              controller.scenario == Screen22Scenario.messageSendingPending) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          } else {
            _scrollController.jumpTo(0);
          }
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant Screen22PreviewView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
    if (_draftController.text != controller.draftText) {
      _draftController.text = controller.draftText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isA11y200 = controller.scenario == Screen22Scenario.accessibility200Thread ||
        controller.scenario == Screen22Scenario.accessibility200Composer;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: isA11y200 ? const TextScaler.linear(2.0) : const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        key: const Key('screen22_scaffold'),
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: _buildCanonicalAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                // Expandable Booking Details Panel (Starts Collapsed)
                _buildExpandableBookingPanel(),

                // Primary Message Stream or Barrier State
                Expanded(
                  child: _buildChatBody(),
                ),

                // Neutral Offline Status Indicator (Directly above composer)
                if (controller.isOffline) _buildOfflineIndicator(),

                // Bottom Message Composer (Only visible if thread is accessible)
                if (!controller.isGuest && controller.isThreadAvailable)
                  _buildMessageComposer(),
              ],
            ),

            // DevTools Scenario Selector Sheet Overlay
            if (_showDevTools) _buildDevToolsOverlay(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Canonical Minimal Calm App Bar
  // ===========================================================================

  PreferredSizeWidget _buildCanonicalAppBar() {
    return AppBar(
      key: const Key('screen22_app_bar'),
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(color: Color(0xFFE5E7EB), height: 1),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 1. Physical RIGHT Back Arrow: Arrowhead visibly points RIGHT [➔]
            InkWell(
              key: const Key('screen22_back_button'),
              onTap: () {
                controller.recordNavigationIntent('SCREEN_13_BOOKING_DETAILS');
              },
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  textDirection: TextDirection.ltr, // Prevents RTL mirroring; points RIGHT [➔]
                  color: Color(0xFF000000), // Pure Black #000000
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 2. Title «محادثة الحجز» + Disclosure Chevron
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'محادثة الحجز',
                  key: Key('screen22_app_bar_title'),
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000), // Pure Black #000000
                    height: 1.25,
                  ),
                ),
                if (!controller.isGuest && controller.isThreadAvailable) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    key: const Key('screen22_booking_disclosure_button'),
                    onTap: () {
                      controller.toggleBookingDetails();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        controller.isBookingDetailsExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.chevron_left_rounded, // Left chevron indicates expandable in RTL
                        textDirection: TextDirection.ltr,
                        color: const Color(0xFF4B5563),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const Spacer(),

            // 3. Physical FAR LEFT: Clickable Booking Number Link to Screen 13
            if (!controller.isGuest && controller.isThreadAvailable)
              Semantics(
                label: 'رقم الحجز ${controller.bookingNumber}',
                button: true,
                child: InkWell(
                  key: const Key('screen22_booking_reference_link'),
                  onTap: () {
                    controller.recordNavigationIntent('SCREEN_13_BOOKING_DETAILS');
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Text(
                      'رقم الحجز ${controller.bookingNumber}',
                      style: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Expandable Booking Details Panel (Clean, Source-Backed, Collapsed by Default)
  // ===========================================================================

  Widget _buildExpandableBookingPanel() {
    if (!controller.isBookingDetailsExpanded ||
        controller.isGuest ||
        !controller.isThreadAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      key: const Key('screen22_booking_expanded_panel'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.apartment_rounded,
            size: 20,
            color: Color(0xFF000000),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.propertyTitle,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.bookingDates,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'مؤكد',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Neutral Offline Status Indicator
  // ===========================================================================

  Widget _buildOfflineIndicator() {
    return Container(
      key: const Key('screen22_offline_indicator'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 14, color: Color(0xFF6B7280)),
          SizedBox(width: 6),
          Text(
            'لا يوجد اتصال بالإنترنت — وضع تحرير المسودة نشط',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Chat Body & State Dispatcher
  // ===========================================================================

  Widget _buildChatBody() {
    if (controller.isGuest) {
      return _buildGuestBarrierState();
    }

    if (!controller.isThreadAvailable) {
      return _buildUnavailableThreadState();
    }

    return ListView(
      key: const Key('chat_message_list'),
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Date Separator (Clean & minimal)
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'اليوم',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ),

        // Message Bubbles Stream
        ...controller.messages.map((message) {
          return _buildMessageBubble(message);
        }),

        // Submission Timeout / Uncertain Notice Recovery Card
        if (controller.isTimeoutUncertain) ...[
          const SizedBox(height: 12),
          _buildTimeoutUncertainRecoveryCard(),
        ],

        // Message Delivery Failed Recovery Card
        if (controller.isDeliveryFailed) ...[
          const SizedBox(height: 12),
          _buildDeliveryFailedRecoveryCard(),
        ],
      ],
    );
  }

  // ===========================================================================
  // Message Bubble Component (Founder Role Grammar)
  // ===========================================================================

  Widget _buildMessageBubble(ChatMessage message) {
    final isCustomer = message.senderRole == ChatParticipantRole.customer;

    if (isCustomer) {
      // Customer: WHITE Bubble on Physical LEFT with Customer Avatar on Physical LEFT
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Directionality(
          textDirection: TextDirection.ltr, // LTR row places children from physical LEFT to RIGHT
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Anchored to physical LEFT
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Customer Avatar on physical LEFT
              _buildCustomerAvatar(message.id),
              const SizedBox(width: 8),

              // Customer White Speech Bubble
              Directionality(
                textDirection: TextDirection.rtl, // Content inside bubble is Arabic RTL
                child: Container(
                  key: Key('message_bubble_${message.id}'),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white, // Customer is WHITE
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                      bottomLeft: Radius.circular(4),
                    ),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.contentArabic,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827), // Readable Dark Gray/Black
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.timestampArabic,
                            style: const TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildDeliveryStatusIcon(message.status),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Owner: PURE BLACK #000000 Bubble on Physical RIGHT with Owner Avatar on Physical RIGHT
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Directionality(
          textDirection: TextDirection.ltr, // LTR row places children from physical LEFT to RIGHT
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Anchored to physical RIGHT
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Owner Black Speech Bubble
              Directionality(
                textDirection: TextDirection.rtl, // Content inside bubble is Arabic RTL
                child: Container(
                  key: Key('message_bubble_${message.id}'),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF000000), // Owner is PURE BLACK #000000
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.contentArabic,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white, // White text on black
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message.timestampArabic,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Owner Avatar on physical RIGHT
              _buildOwnerAvatar(message.id),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCustomerAvatar(String messageId) {
    return Container(
      key: Key('customer_avatar_$messageId'),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: const Center(
        child: Text(
          'أ', // Grounded Customer initial (Ahmed)
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerAvatar(String messageId) {
    return Container(
      key: Key('owner_avatar_$messageId'),
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'م', // Grounded Owner initial (Host / المالك)
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryStatusIcon(MessageDeliveryStatus status) {
    switch (status) {
      case MessageDeliveryStatus.sending:
        return const SizedBox(
          width: 11,
          height: 11,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Color(0xFF9CA3AF),
          ),
        );
      case MessageDeliveryStatus.sent:
        return const Icon(
          Icons.check_rounded, // Single discreet checkmark (truthful server acknowledgement)
          size: 13,
          color: Color(0xFF6B7280),
        );
      case MessageDeliveryStatus.unknownTimeout:
        return const Icon(
          Icons.schedule_rounded,
          size: 13,
          color: Color(0xFFD97706),
        );
      case MessageDeliveryStatus.failed:
        return const Icon(
          Icons.error_outline_rounded,
          size: 13,
          color: Color(0xFFDC2626),
        );
    }
  }

  // ===========================================================================
  // Recovery Cards (Timeout Uncertain & Failed Delivery)
  // ===========================================================================

  Widget _buildTimeoutUncertainRecoveryCard() {
    return Container(
      key: const Key('screen22_timeout_uncertain_notice'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule_rounded, size: 16, color: Color(0xFF4B5563)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'تعذر تأكيد تسليم الرسالة من الخادم',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'تم حفظ المسودة في هذا الجهاز لتجنب إرسال رسائل مكررة.',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            key: const Key('screen22_review_draft_button'),
            onTap: () {
              controller.restoreDraftFromUncertain();
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF000000), // Pure Black #000000
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'مراجعة المسودة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryFailedRecoveryCard() {
    return Container(
      key: const Key('screen22_delivery_failed_notice'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECACA), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 16, color: Color(0xFFDC2626)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'تعذر إرسال الرسالة — تحقق من الاتصال',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF991B1B),
              ),
            ),
          ),
          InkWell(
            key: const Key('screen22_retry_send_button'),
            onTap: () {
              controller.retryFailedMessage();
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Barrier States (Unauthenticated Guest & Unavailable Thread)
  // ===========================================================================

  Widget _buildGuestBarrierState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          key: const Key('chat_guest_barrier_card'),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF000000),
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تسجيل الدخول مطلوب لعرض المحادثة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'محادثات الحجز تتطلب التحقق من هويتك كطرف مصرح له في هذا الحجز لحماية خصوصية المشاركين.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('chat_guest_login_button'),
                  onPressed: () {
                    controller.recordNavigationIntent('AUTH_PHONE_ENTRY');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnavailableThreadState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          key: const Key('chat_unavailable_card'),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF6B7280),
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'المحادثة غير متاحة حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'تتاح محادثة الحجز فقط للحجوزات النشطة المصرح بها بين الضيف والمالك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  key: const Key('return_to_booking_button'),
                  onPressed: () {
                    controller.recordNavigationIntent('SCREEN_12_MY_BOOKINGS');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF000000), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'العودة لتفاصيل الحجز',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Message Composer (Keyboard Safe & Accessible)
  // ===========================================================================

  Widget _buildMessageComposer() {
    final hasDraft = controller.draftText.trim().isNotEmpty;
    final isA11y = controller.scenario == Screen22Scenario.accessibility200Thread ||
        controller.scenario == Screen22Scenario.accessibility200Composer;

    return Container(
      key: const Key('chat_message_composer'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Expanding Text Input Field
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 44, maxHeight: isA11y ? 180 : 120),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: TextField(
                  key: const Key('chat_input_text_field'),
                  controller: _draftController,
                  maxLines: 4,
                  minLines: 1,
                  onChanged: (val) {
                    controller.setDraftText(val);
                  },
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                    height: 1.45,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك للمالك...',
                    hintStyle: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send CTA Button (48dp Touch Target)
            SizedBox(
              width: 48,
              height: 48,
              child: Material(
                color: hasDraft ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('chat_send_button'),
                  onTap: hasDraft ? () => controller.sendMessage() : null,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: Transform.rotate(
                      angle: 3.14159, // Mirrored for RTL arrow direction
                      child: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: hasDraft ? Colors.white : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DevTools Scenario Selector Overlay
  // ===========================================================================

  Widget _buildDevToolsOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showDevTools = false;
          });
        },
        child: Container(
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              constraints: const BoxConstraints(maxHeight: 520),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'سيناريوهات المعاينة والتحقق',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          setState(() {
                            _showDevTools = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: Screen22Scenario.values.length,
                      itemBuilder: (context, index) {
                        final sc = Screen22Scenario.values[index];
                        final isSelected = controller.scenario == sc;
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            sc.title,
                            style: TextStyle(
                              fontFamily: KonfrmTypography.fontFamily,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF000000) : const Color(0xFF4B5563),
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, size: 16, color: Color(0xFF000000))
                              : null,
                          onTap: () {
                            controller.setScenario(sc);
                            setState(() {
                              _showDevTools = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
