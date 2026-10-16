// =============================================================================
// KONFRM Customer Screen 21 — Help & Support («المساعدة والدعم»)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Physical Device: [REDACTED_A56_ID]
// Design Authority: Cairo Typography, RTL First, Pure Monochrome & Neutrals
// Navigation Context: Nested Customer Destination (Canonical NESTED_CUSTOMER)
// Bottom Navigation: HIDDEN (Per canonical DESIGN_SYSTEM/COMPONENTS/navigation.md §3.3)
// Governing Issues:
//   - Issue #185 (Screen 21 Help & Support Founder Execution Contract)
//   - Issue #186 (Deferred Support Channel, Case API, Privacy & SLA Prelive Gate)
//   - Issue #183 (Mandatory Design Skills Activation, Design Court & Platform Gate)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository-Wide Audit)
//   - Issue #174 (Notifications Navigation Routing Proposal vs Architecture)
//   - Issue #173 (Financial Model Meaning & Booking Lifecycle Boundaries)
//   - Issue #172 (Identity, Avatar, QR & Connected Profiles Boundaries)
//   - Issue #171 (Deferred Technical/QA Backlog for Screen 17 - Prelive Gate)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
//
// Scope: Production-Fidelity UI/UX Design V1 with Cairo Arabic RTL,
//        Source-Backed FAQ Fixtures, Contextual Contact Intake with Opt-In
//        Booking Consent, and Genuine 200% Accessibility Scaling.
// =============================================================================

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen21PreviewApp());
}

// =============================================================================
// Domain Models & State
// =============================================================================

/// Canonical FAQ Category classification based on confirmed platform domains.
enum HelpCategory {
  all,
  bookings,
  paymentsAndDeposit,
  account,
}

extension HelpCategoryExtension on HelpCategory {
  String get labelArabic {
    switch (this) {
      case HelpCategory.all:
        return 'الكل';
      case HelpCategory.bookings:
        return 'الحجوزات';
      case HelpCategory.paymentsAndDeposit:
        return 'الدفع والعربون';
      case HelpCategory.account:
        return 'الحساب';
    }
  }

  IconData get iconData {
    switch (this) {
      case HelpCategory.all:
        return Icons.auto_awesome_outlined;
      case HelpCategory.bookings:
        return Icons.calendar_month_outlined;
      case HelpCategory.paymentsAndDeposit:
        return Icons.account_balance_wallet_outlined;
      case HelpCategory.account:
        return Icons.person_outline_rounded;
    }
  }
}

/// Sourced FAQ item grounded strictly in confirmed Master Rules & Canon.
class HelpFaqItem {
  final String id;
  final String questionArabic;
  final String answerArabic;
  final HelpCategory category;
  final String canonicalRuleAnchor;

  const HelpFaqItem({
    required this.id,
    required this.questionArabic,
    required this.answerArabic,
    required this.category,
    required this.canonicalRuleAnchor,
  });
}

/// Sourced FAQ Fixtures derived from Master Rules MR-12, MR-13, and Booking Canon.
/// Strictly excludes unapproved check-in times, key exchanges, or cancellation deadlines.
final List<HelpFaqItem> kSourceBackedHelpFaqs = [
  const HelpFaqItem(
    id: 'faq_deposit_meaning',
    questionArabic: 'كيف يعمل عربون الليلة الأولى؟',
    answerArabic:
        'يمثل عربون الليلة الأولى دفعة تأكيدية لحجز الوحدة، ويتم تحصيله إلكترونياً فقط بعد موافقة المالك على طلب الحجز. لا يُعد العربون كامل تكلفة الإقامة بل يُخصم من إجمالي القيمة.',
    category: HelpCategory.paymentsAndDeposit,
    canonicalRuleAnchor: 'Master Rule MR-13: First-night deposit semantics',
  ),
  const HelpFaqItem(
    id: 'faq_stay_duration',
    questionArabic: 'ما هي مدة الإقامة المتاحة للحجز؟',
    answerArabic:
        'تبدأ مدة الإقامة المتاحة عبر المنصة من ليلتين كحد أدنى وحتى 30 ليلة كحد أقصى لكل حجز وفقاً لقواعد الإشغال المعتمدة.',
    category: HelpCategory.bookings,
    canonicalRuleAnchor: 'Master Rule MR-12: Booking duration boundaries (2-30 nights)',
  ),
  const HelpFaqItem(
    id: 'faq_booking_confirmation',
    questionArabic: 'متى يتم تأكيد الحجز بشكل نهائي؟',
    answerArabic:
        'يمر الحجز بمرحلتين أساسيتين: أولاً موافقة المالك على تفاصيل الطلب، ثم سداد عربون الليلة الأولى بنجاح لتأكيد حجز التواريخ بشكل نهائي.',
    category: HelpCategory.bookings,
    canonicalRuleAnchor: 'Master Rule MR-12 & MR-13: Approval-then-payment invariant',
  ),
  const HelpFaqItem(
    id: 'faq_account_profile',
    questionArabic: 'كيف يمكنني تحديث بيانات حسابي؟',
    answerArabic:
        'يمكنك تعديل بياناتك الشخصية وتفضيلات الإشعارات من خلال شاشة الحساب ثم الانتقال إلى قسم الإعدادات.',
    category: HelpCategory.account,
    canonicalRuleAnchor: 'Screen 17 & 19 Account and Settings Contract',
  ),
  const HelpFaqItem(
    id: 'faq_cancel_pending_request',
    questionArabic: 'هل يمكنني إلغاء طلب حجز قيد الانتظار؟',
    answerArabic:
        'نعم، يمكنك إلغاء طلب الحجز مجاناً طالما كان في حالة قيد الانتظار وقبل صدور موافقة المالك.',
    category: HelpCategory.bookings,
    canonicalRuleAnchor: 'Booking Lifecycle Canon: Free cancellation before owner approval',
  ),
];

/// Contact Support Inquiry Topics.
enum SupportInquiryTopic {
  generalAccount,
  bookingAssistance,
  depositAndPayment,
  other,
}

extension SupportInquiryTopicExtension on SupportInquiryTopic {
  String get labelArabic {
    switch (this) {
      case SupportInquiryTopic.generalAccount:
        return 'استفسار عام عن الحساب';
      case SupportInquiryTopic.bookingAssistance:
        return 'استفسار عن حجز حالي أو سابق';
      case SupportInquiryTopic.depositAndPayment:
        return 'استفسار عن الدفع والعربون';
      case SupportInquiryTopic.other:
        return 'موضوع آخر';
    }
  }
}

/// Form submission status representing truthful visual states.
enum SupportFormStatus {
  idle,
  validating,
  validationError,
  sending,
  timeoutUncertain,
  networkError,
  serverConfirmedMock,
}

/// Origin context when navigating to Help & Support.
enum SupportEntryContext {
  accountOrigin,
  bookingOrigin,
}

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen21Scenario {
  helpCenterTop,
  faqTopicExpanded,
  searchFiltered,
  searchEmptyState,
  contactFormGeneral,
  contactFormBookingDefaultOff,
  contactFormBookingConsentOn,
  formValidationError,
  submissionTimeoutUncertain,
  guestPublicHelp,
  accessibility200Top,
  accessibility200Form,
}

extension Screen21ScenarioMetadata on Screen21Scenario {
  String get title {
    switch (this) {
      case Screen21Scenario.helpCenterTop:
        return '01 Help Center (Top Fold)';
      case Screen21Scenario.faqTopicExpanded:
        return '02 FAQ Topic Expanded & Scrolled';
      case Screen21Scenario.searchFiltered:
        return '03 Search Active (Filtered Results)';
      case Screen21Scenario.searchEmptyState:
        return '04 Search Zero-Results Empty State';
      case Screen21Scenario.contactFormGeneral:
        return '05 Contact Request Form (Account General)';
      case Screen21Scenario.contactFormBookingDefaultOff:
        return '06 Contact Form Booking Context (Consent Default OFF)';
      case Screen21Scenario.contactFormBookingConsentOn:
        return '07 Contact Form Booking Context (Consent ON)';
      case Screen21Scenario.formValidationError:
        return '08 Inline Validation Error (Draft Preserved)';
      case Screen21Scenario.submissionTimeoutUncertain:
        return '09 Submission Timeout / Uncertain State';
      case Screen21Scenario.guestPublicHelp:
        return '10 Unauthenticated Guest (Login Guarded)';
      case Screen21Scenario.accessibility200Top:
        return '11 Accessibility 200% Font Scale (Help Center)';
      case Screen21Scenario.accessibility200Form:
        return '12 Accessibility 200% Font Scale (Contact Form)';
    }
  }

  bool get isA11y200 {
    return this == Screen21Scenario.accessibility200Top ||
        this == Screen21Scenario.accessibility200Form;
  }
}

// =============================================================================
// State Controller (ChangeNotifier)
// =============================================================================

class CustomerHelpSupportController extends ChangeNotifier {
  Screen21Scenario _scenario = Screen21Scenario.helpCenterTop;
  HelpCategory _selectedCategory = HelpCategory.all;
  String _searchQuery = '';
  String? _expandedFaqId;
  SupportEntryContext _entryContext = SupportEntryContext.accountOrigin;
  SupportInquiryTopic _inquiryTopic = SupportInquiryTopic.generalAccount;
  String _descriptionText = '';
  bool _bookingConsentAttached = false; // Default OFF per Bridge review
  SupportFormStatus _formStatus = SupportFormStatus.idle;
  String? _formValidationError;
  bool _isGuest = false;
  bool _showContactFormInline = false;

  // Booking Context Data (Pre-seeded fixture for booking context scenario)
  final String contextBookingNumber = '183223'; // Digits only, no raw BK-
  final String contextPropertyTitle = 'فيلا لؤلؤة البحر — مراسي';

  // Getters
  Screen21Scenario get scenario => _scenario;
  HelpCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String? get expandedFaqId => _expandedFaqId;
  SupportEntryContext get entryContext => _entryContext;
  SupportInquiryTopic get inquiryTopic => _inquiryTopic;
  String get descriptionText => _descriptionText;
  bool get bookingConsentAttached => _bookingConsentAttached;
  SupportFormStatus get formStatus => _formStatus;
  String? get formValidationError => _formValidationError;
  bool get isGuest => _isGuest;
  bool get showContactFormInline => _showContactFormInline;

  /// Filtered FAQ list derived from active search query and category.
  List<HelpFaqItem> get filteredFaqs {
    final query = _searchQuery.trim().toLowerCase();
    return kSourceBackedHelpFaqs.where((faq) {
      final matchesCategory = _selectedCategory == HelpCategory.all ||
          faq.category == _selectedCategory;
      if (!matchesCategory) return false;

      if (query.isEmpty) return true;
      final inQuestion = faq.questionArabic.toLowerCase().contains(query);
      final inAnswer = faq.answerArabic.toLowerCase().contains(query);
      return inQuestion || inAnswer;
    }).toList();
  }

  void setScenario(Screen21Scenario newScenario) {
    _scenario = newScenario;
    _formValidationError = null;
    _formStatus = SupportFormStatus.idle;

    switch (newScenario) {
      case Screen21Scenario.helpCenterTop:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.accountOrigin;
        _isGuest = false;
        _showContactFormInline = false;
        break;

      case Screen21Scenario.faqTopicExpanded:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = 'faq_deposit_meaning';
        _entryContext = SupportEntryContext.accountOrigin;
        _isGuest = false;
        _showContactFormInline = false;
        break;

      case Screen21Scenario.searchFiltered:
        _selectedCategory = HelpCategory.all;
        _searchQuery = 'عربون';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.accountOrigin;
        _isGuest = false;
        _showContactFormInline = false;
        break;

      case Screen21Scenario.searchEmptyState:
        _selectedCategory = HelpCategory.all;
        _searchQuery = 'سيارة خاصة';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.accountOrigin;
        _isGuest = false;
        _showContactFormInline = false;
        break;

      case Screen21Scenario.contactFormGeneral:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.accountOrigin;
        _inquiryTopic = SupportInquiryTopic.generalAccount;
        _descriptionText = 'أحتاج للاستفسار عن كيفية تحديث رقم الهاتف المرتبط بحسابي.';
        _bookingConsentAttached = false;
        _isGuest = false;
        _showContactFormInline = true;
        break;

      case Screen21Scenario.contactFormBookingDefaultOff:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.bookingOrigin;
        _inquiryTopic = SupportInquiryTopic.bookingAssistance;
        _descriptionText = 'أود الاستفسار عن تأكيد استلام العربون لهذا الحجز.';
        _bookingConsentAttached = false; // Default OFF per Amendment 3
        _isGuest = false;
        _showContactFormInline = true;
        break;

      case Screen21Scenario.contactFormBookingConsentOn:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.bookingOrigin;
        _inquiryTopic = SupportInquiryTopic.bookingAssistance;
        _descriptionText = 'أود الاستفسار عن تفاصيل الحجز بعد سداد العربون بنجاح.';
        _bookingConsentAttached = true; // Opted in by customer
        _isGuest = false;
        _showContactFormInline = true;
        break;

      case Screen21Scenario.formValidationError:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.accountOrigin;
        _inquiryTopic = SupportInquiryTopic.generalAccount;
        _descriptionText = 'مرحبا'; // Under 10 characters
        _bookingConsentAttached = false;
        _formStatus = SupportFormStatus.validationError;
        _formValidationError = 'يرجى كتابة 10 أحرف على الأقل لشرح استفسارك';
        _isGuest = false;
        _showContactFormInline = true;
        break;

      case Screen21Scenario.submissionTimeoutUncertain:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.bookingOrigin;
        _inquiryTopic = SupportInquiryTopic.bookingAssistance;
        _descriptionText = 'استفسار بخصوص موعد تأكيد الحجز بعد سداد دفعة العربون.';
        _bookingConsentAttached = true;
        _formStatus = SupportFormStatus.timeoutUncertain;
        _isGuest = false;
        _showContactFormInline = true;
        break;

      case Screen21Scenario.guestPublicHelp:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.accountOrigin;
        _isGuest = true;
        _showContactFormInline = false;
        break;

      case Screen21Scenario.accessibility200Top:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = 'faq_stay_duration';
        _entryContext = SupportEntryContext.accountOrigin;
        _isGuest = false;
        _showContactFormInline = false;
        break;

      case Screen21Scenario.accessibility200Form:
        _selectedCategory = HelpCategory.all;
        _searchQuery = '';
        _expandedFaqId = null;
        _entryContext = SupportEntryContext.bookingOrigin;
        _inquiryTopic = SupportInquiryTopic.bookingAssistance;
        _descriptionText = 'استفسار تجريبي لمراجعة تدفق النصوص وعناصر التحكم بحجم 200%.';
        _bookingConsentAttached = true;
        _isGuest = false;
        _showContactFormInline = true;
        break;
    }

    notifyListeners();
  }

  void setCategory(HelpCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFaq(String faqId) {
    if (_expandedFaqId == faqId) {
      _expandedFaqId = null;
    } else {
      _expandedFaqId = faqId;
    }
    notifyListeners();
  }

  void setInquiryTopic(SupportInquiryTopic topic) {
    _inquiryTopic = topic;
    notifyListeners();
  }

  void setDescription(String text) {
    _descriptionText = text;
    if (_formValidationError != null && text.trim().length >= 10) {
      _formValidationError = null;
    }
    notifyListeners();
  }

  void setBookingConsent(bool value) {
    _bookingConsentAttached = value;
    notifyListeners();
  }

  void openContactForm() {
    _showContactFormInline = true;
    notifyListeners();
  }

  void closeContactForm() {
    _showContactFormInline = false;
    _formValidationError = null;
    _formStatus = SupportFormStatus.idle;
    notifyListeners();
  }

  /// Validates and handles contact form submission attempt.
  /// Honors Bridge Amendment 2: NEVER produces a fake server success toast.
  void submitContactForm() {
    if (_isGuest) {
      return;
    }

    final trimmed = _descriptionText.trim();
    if (trimmed.length < 10) {
      _formStatus = SupportFormStatus.validationError;
      _formValidationError = 'يرجى كتابة 10 أحرف على الأقل لشرح استفسارك';
      notifyListeners();
      return;
    }

    // Save draft and demonstrate proposed UX without false success claims
    _formValidationError = null;
    _formStatus = SupportFormStatus.idle;
    notifyListeners();
  }

  void retrySubmission() {
    _formStatus = SupportFormStatus.idle;
    _formValidationError = null;
    notifyListeners();
  }
}

// =============================================================================
// App Widget
// =============================================================================

class Screen21PreviewApp extends StatefulWidget {
  const Screen21PreviewApp({super.key});

  @override
  State<Screen21PreviewApp> createState() => _Screen21PreviewAppState();
}

class _Screen21PreviewAppState extends State<Screen21PreviewApp> {
  final CustomerHelpSupportController _controller = CustomerHelpSupportController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final textScaler = _controller.scenario.isA11y200
            ? const TextScaler.linear(2.0)
            : const TextScaler.linear(1.0);

        return MaterialApp(
          title: 'Customer Screen 21 — Help & Support',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: KonfrmTypography.fontFamily,
            scaffoldBackgroundColor: const Color(0xFFF9FAFB),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF000000), // Pure Black #000000
              primary: const Color(0xFF000000),
              surface: Colors.white,
            ),
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            );
          },
          home: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Screen21PreviewView(controller: _controller),
          ),
        );
      },
    );
  }
}

// =============================================================================
// Main Preview View
// =============================================================================

class Screen21PreviewView extends StatefulWidget {
  final CustomerHelpSupportController controller;

  const Screen21PreviewView({super.key, required this.controller});

  @override
  State<Screen21PreviewView> createState() => _Screen21PreviewViewState();
}

class _Screen21PreviewViewState extends State<Screen21PreviewView> {
  CustomerHelpSupportController get controller => widget.controller;
  late final TextEditingController _searchController;
  late final TextEditingController _descriptionController;
  final ScrollController _scrollController = ScrollController();
  bool _showDevTools = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: controller.searchQuery);
    _descriptionController = TextEditingController(text: controller.descriptionText);
    controller.addListener(_onControllerChanged);
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.digit1) {
      controller.setScenario(Screen21Scenario.helpCenterTop);
      return true;
    } else if (key == LogicalKeyboardKey.digit2) {
      controller.setScenario(Screen21Scenario.faqTopicExpanded);
      return true;
    } else if (key == LogicalKeyboardKey.digit3) {
      controller.setScenario(Screen21Scenario.searchFiltered);
      return true;
    } else if (key == LogicalKeyboardKey.digit4) {
      controller.setScenario(Screen21Scenario.searchEmptyState);
      return true;
    } else if (key == LogicalKeyboardKey.digit5) {
      controller.setScenario(Screen21Scenario.contactFormGeneral);
      return true;
    } else if (key == LogicalKeyboardKey.digit6) {
      controller.setScenario(Screen21Scenario.contactFormBookingDefaultOff);
      return true;
    } else if (key == LogicalKeyboardKey.digit7) {
      controller.setScenario(Screen21Scenario.contactFormBookingConsentOn);
      return true;
    } else if (key == LogicalKeyboardKey.digit8) {
      controller.setScenario(Screen21Scenario.formValidationError);
      return true;
    } else if (key == LogicalKeyboardKey.digit9) {
      controller.setScenario(Screen21Scenario.submissionTimeoutUncertain);
      return true;
    } else if (key == LogicalKeyboardKey.digit0) {
      controller.setScenario(Screen21Scenario.guestPublicHelp);
      return true;
    } else if (key == LogicalKeyboardKey.keyA) {
      controller.setScenario(Screen21Scenario.accessibility200Top);
      return true;
    } else if (key == LogicalKeyboardKey.keyB) {
      controller.setScenario(Screen21Scenario.accessibility200Form);
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
      if (_searchController.text != controller.searchQuery) {
        _searchController.text = controller.searchQuery;
      }
      if (_descriptionController.text != controller.descriptionText) {
        _descriptionController.text = controller.descriptionText;
      }
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          if (controller.showContactFormInline) {
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
  void didUpdateWidget(covariant Screen21PreviewView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
    if (_searchController.text != controller.searchQuery) {
      _searchController.text = controller.searchQuery;
    }
    if (_descriptionController.text != controller.descriptionText) {
      _descriptionController.text = controller.descriptionText;
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    controller.removeListener(_onControllerChanged);
    _searchController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildCanonicalAppBar(),
      body: Stack(
        children: [
          // Main Scrollable Help Content
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Search Input
                _buildSearchInput(),
                const SizedBox(height: 16),

                // Category Filter Chips
                _buildCategoryFilterChips(),
                const SizedBox(height: 20),

                // FAQ Section Title & List
                _buildFaqSection(),
                const SizedBox(height: 24),

                // Contact Support Intake Section
                _buildContactSupportSection(),

                // Bottom safe space
                const SizedBox(height: 60),
              ],
            ),
          ),

          // DevTools Scenario Selector Overlay
          if (_showDevTools) _buildDevToolsOverlay(),
        ],
      ),
    );
  }

  // ===========================================================================
  // App Bar (Canonical NESTED_CUSTOMER Contract)
  // ===========================================================================

  PreferredSizeWidget _buildCanonicalAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        key: const Key('screen21_back_button'),
        icon: const Icon(
          Icons.arrow_forward_rounded, // Physical right in RTL [➔]
          color: Color(0xFF000000),
          size: 24,
        ),
        onPressed: () {
          // Canonical back navigation returning to origin
          if (controller.showContactFormInline) {
            controller.closeContactForm();
          }
        },
      ),
      title: GestureDetector(
        key: const Key('screen21_header_title_tap_area'),
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          setState(() {
            _showDevTools = !_showDevTools;
          });
        },
        child: const Text(
          'المساعدة والدعم',
          key: Key('screen21_app_bar_title'),
          style: TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000), // Pure Black #000000
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: const Color(0xFFE5E7EB),
          height: 1,
        ),
      ),
    );
  }

  // ===========================================================================
  // Search Input Component
  // ===========================================================================

  Widget _buildSearchInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Governed 8px field radius
        border: Border.all(
          color: controller.searchQuery.isNotEmpty
              ? const Color(0xFF000000)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: TextField(
        key: const Key('help_search_field'),
        controller: _searchController,
        onChanged: (val) {
          controller.setSearchQuery(val);
        },
        style: const TextStyle(
          fontFamily: KonfrmTypography.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
        decoration: InputDecoration(
          hintText: 'ابحث في موضوعات المساعدة...',
          hintStyle: const TextStyle(
            fontFamily: KonfrmTypography.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9CA3AF),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6B7280),
            size: 20,
          ),
          suffixIcon: controller.searchQuery.isNotEmpty
              ? IconButton(
                  key: const Key('clear_search_button'),
                  icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF6B7280)),
                  onPressed: () {
                    _searchController.clear();
                    controller.setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  // ===========================================================================
  // Category Filter Chips
  // ===========================================================================

  Widget _buildCategoryFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: HelpCategory.values.map((category) {
          final isSelected = controller.selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: InkWell(
              key: Key('category_chip_${category.name}'),
              onTap: () {
                controller.setCategory(category);
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF000000) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.iconData,
                      size: 16,
                      color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.labelArabic,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================================
  // FAQ Accordion List & Empty Search State
  // ===========================================================================

  Widget _buildFaqSection() {
    final faqs = controller.filteredFaqs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأسئلة الشائعة',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000), // Pure Black #000000
              ),
            ),
            Text(
              '${faqs.length} موضوع',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Zero-Results Empty State
        if (faqs.isEmpty)
          _buildSearchEmptyState()
        else
          // Accordion List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final faq = faqs[index];
              final isExpanded = controller.expandedFaqId == faq.id;
              return _buildFaqAccordionCard(faq, isExpanded);
            },
          ),
      ],
    );
  }

  Widget _buildSearchEmptyState() {
    return Container(
      key: const Key('help_search_empty_state'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
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
              Icons.search_off_rounded,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'لا توجد نتائج مطابقة لـ "${controller.searchQuery}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'جرب البحث بكلمات أخرى أو تصفح الأقسام الشائعة أدناه.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            key: const Key('reset_search_button'),
            onPressed: () {
              _searchController.clear();
              controller.setSearchQuery('');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF000000),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'عرض جميع الموضوعات',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqAccordionCard(HelpFaqItem faq, bool isExpanded) {
    return Container(
      key: Key('faq_item_${faq.id}'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Governed 12px container
        border: Border.all(
          color: isExpanded ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header / Tap Area
          InkWell(
            key: Key('faq_header_${faq.id}'),
            onTap: () {
              controller.toggleFaq(faq.id);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.questionArabic,
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w600,
                        color: const Color(0xFF000000),
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF000000),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Answer Body
          if (isExpanded) ...[
            const Divider(color: Color(0xFFF3F4F6), height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                faq.answerArabic,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                  height: 1.55,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // Contact Support Intake Section
  // ===========================================================================

  Widget _buildContactSupportSection() {
    if (controller.isGuest) {
      return _buildGuestLoginShieldCard();
    }

    if (controller.showContactFormInline) {
      return _buildContactFormCard();
    }

    return _buildContactPromptCard();
  }

  Widget _buildContactPromptCard() {
    return Container(
      key: const Key('contact_prompt_card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Color(0xFF000000),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لم تجد ما تبحث عنه؟',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'يمكنك إرسال استفسار وسيتولى فريق الدعم مراجعته.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('open_contact_form_button'),
              onPressed: () {
                controller.openContactForm();
              },
              icon: const Icon(Icons.edit_note_rounded, size: 18),
              label: const Text(
                'إرسال استفسار جديد',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000), // Pure Black #000000
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Governed 6px radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestLoginShieldCard() {
    return Container(
      key: const Key('guest_login_shield_card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF000000),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تسجيل الدخول مطلوب للتواصل',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'يرجى تسجيل الدخول لتتمكن من إرسال طلب دعم ومتابعة استفسارك بأمان.',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('guest_login_button'),
              onPressed: () {},
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
    );
  }

  Widget _buildContactFormCard() {
    return Container(
      key: const Key('contact_form_card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF000000), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إرسال استفسار للدعم',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              IconButton(
                key: const Key('close_contact_form_button'),
                icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF6B7280)),
                onPressed: () {
                  controller.closeContactForm();
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Booking Context Box (If originating from booking)
          if (controller.entryContext == SupportEntryContext.bookingOrigin)
            _buildBookingContextContainer(),

          // Inquiry Topic Selector
          const Text(
            'موضوع الاستفسار',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          _buildTopicSelector(),
          const SizedBox(height: 16),

          // Inquiry Description Input
          const Text(
            'تفاصيل الاستفسار',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          _buildDescriptionInput(),

          // Validation Error Notice (If active)
          if (controller.formValidationError != null) ...[
            const SizedBox(height: 6),
            Text(
              controller.formValidationError!,
              key: const Key('form_validation_error_text'),
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626), // Error Red
              ),
            ),
          ],

          // Submission Timeout / Uncertain State Recovery Notice
          if (controller.formStatus == SupportFormStatus.timeoutUncertain) ...[
            const SizedBox(height: 14),
            _buildTimeoutUncertainNotice(),
          ],

          const SizedBox(height: 18),

          // Submit Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('submit_inquiry_button'),
              onPressed: () {
                controller.submitContactForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000), // Pure Black #000000
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Governed 6px radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text(
                'إرسال الاستفسار',
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
    );
  }

  // ===========================================================================
  // Booking Context Box with Explicit Consent (Amendment 3)
  // ===========================================================================

  Widget _buildBookingContextContainer() {
    return Container(
      key: const Key('booking_context_container'),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.apartment_rounded, size: 16, color: Color(0xFF000000)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  controller.contextPropertyTitle,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'رقم الحجز: ${controller.contextBookingNumber}', // Digits only, no raw BK-
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 8),

          // Explicit Consent Checkbox (Default OFF per Amendment 3)
          InkWell(
            key: const Key('booking_consent_checkbox_row'),
            onTap: () {
              controller.setBookingConsent(!controller.bookingConsentAttached);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    key: const Key('booking_consent_checkbox'),
                    value: controller.bookingConsentAttached,
                    onChanged: (val) {
                      controller.setBookingConsent(val ?? false);
                    },
                    activeColor: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'إرفاق بيانات هذا الحجز بطلب الدعم لمساعدة فريق المراجعة (اختياري)',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Topic Selector Component
  // ===========================================================================

  Widget _buildTopicSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SupportInquiryTopic>(
          key: const Key('topic_dropdown_selector'),
          value: controller.inquiryTopic,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_drop_down, color: Color(0xFF000000)),
          ),
          items: SupportInquiryTopic.values.map((topic) {
            return DropdownMenuItem<SupportInquiryTopic>(
              value: topic,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  topic.labelArabic,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) controller.setInquiryTopic(val);
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // Description Multiline Input
  // ===========================================================================

  Widget _buildDescriptionInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: controller.formValidationError != null
              ? const Color(0xFFDC2626)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            key: const Key('inquiry_description_field'),
            controller: _descriptionController,
            maxLines: 4,
            minLines: 3,
            onChanged: (val) {
              controller.setDescription(val);
            },
            style: const TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
              height: 1.5,
            ),
            decoration: const InputDecoration(
              hintText: 'اشرح استفسارك بإيجاز لمساعدتك بشكل أفضل...',
              hintStyle: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9CA3AF),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Text(
              '${controller.descriptionText.length} / 500 حرف',
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Timeout Uncertain Notice (Truthful State, No Fake Success)
  // ===========================================================================

  Widget _buildTimeoutUncertainNotice() {
    return Container(
      key: const Key('timeout_uncertain_notice'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF374151)),
              SizedBox(width: 6),
              Text(
                'تعذر تأكيد استلام الطلب حالياً',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000), // Pure Black #000000
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'تم حفظ مسودتك لمنع فقدان البيانات. يرجى التحقق من اتصالك وإعادة المحاولة دون إرسال مكرر.',
            style: TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            key: const Key('retry_inquiry_button'),
            onPressed: () {
              controller.retrySubmission();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: const Color(0xFF000000),
            ),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
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
            onTap: () {}, // Prevent backdrop tap from dismissing sheet
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'سيناريوهات المعاينة والتحقق',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF000000),
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
                      itemCount: Screen21Scenario.values.length,
                      itemBuilder: (context, index) {
                        final sc = Screen21Scenario.values[index];
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
