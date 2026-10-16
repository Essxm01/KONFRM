// =============================================================================
// KONFRM Customer Screen 18 — Profile / Edit Profile («تعديل الملف الشخصي»)
//
// Target Hardware: Samsung Galaxy A56 5G (1080 x 2340, Android 16 API 36)
// Design Authority: Cairo Typography, RTL First, Pure Monochrome & Neutrals
// Navigation Context: Account Child (CustomerBottomNavigation Tab 3 active)
// Governing Issues:
//   - Issue #176 (Screen 18 Profile / Edit Profile Founder Execution Contract)
//   - Issue #175 (Mandatory Pure-Black #000000 Rule & Repository Audit)
//   - Issue #172 (Identity, Avatar, QR & Connected Profiles Boundaries)
//   - Issue #171 (Deferred Technical/QA Backlog for Screen 17 - Prelive Gate)
//   - Issue #166 (Founder Design-First Priorities - Native UI/UX & Cairo RTL)
//   - Issue #155 (Historical Evidence Directory Immutability & Preservation)
//   - Issue #145 (Physical Device Serial Redaction Protocol)
//
// Scope: Isolated visual preview with synthetic scenarios. Zero production mutations.
// =============================================================================

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';
import 'screen17_demo_portrait_bytes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Screen18PreviewApp());
}

// =============================================================================
// Domain Models & Synthetic Helpers
// =============================================================================

enum CustomerGender {
  male,
  female,
  preferNotToDisclose,
}

extension CustomerGenderMetadata on CustomerGender {
  String get labelArabic {
    switch (this) {
      case CustomerGender.male:
        return 'ذكر';
      case CustomerGender.female:
        return 'أنثى';
      case CustomerGender.preferNotToDisclose:
        return 'أفضل عدم الإفصاح';
    }
  }
}

class CustomerProfileEditDraft {
  final String fullName;
  final String? proposedUsername;
  final DateTime? birthDate;
  final CustomerGender? gender;
  final Uint8List? portraitBytes;
  final double cropScale;
  final Offset cropOffset;
  final String verifiedPhone;
  final String verifiedEmail;

  const CustomerProfileEditDraft({
    required this.fullName,
    this.proposedUsername,
    this.birthDate,
    this.gender,
    this.portraitBytes,
    this.cropScale = 1.0,
    this.cropOffset = Offset.zero,
    required this.verifiedPhone,
    required this.verifiedEmail,
  });

  bool get hasPortrait => portraitBytes != null && portraitBytes!.isNotEmpty;

  String get initials {
    final clean = fullName.trim();
    if (clean.isEmpty) return 'م';
    final parts = clean.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'م';
    if (parts.length == 1) {
      return parts[0].length >= 2 ? parts[0].substring(0, 2) : parts[0];
    }
    return '${parts[0][0]}.${parts[1][0]}';
  }

  int? get derivedAgeYears {
    if (birthDate == null) return null;
    final now = DateTime(2026, 10, 16);
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age >= 0 ? age : null;
  }

  CustomerProfileEditDraft copyWith({
    String? fullName,
    String? proposedUsername,
    DateTime? birthDate,
    bool clearBirthDate = false,
    CustomerGender? gender,
    Uint8List? portraitBytes,
    bool clearPortrait = false,
    double? cropScale,
    Offset? cropOffset,
    String? verifiedPhone,
    String? verifiedEmail,
  }) {
    return CustomerProfileEditDraft(
      fullName: fullName ?? this.fullName,
      proposedUsername: proposedUsername ?? this.proposedUsername,
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      gender: gender ?? this.gender,
      portraitBytes: clearPortrait ? null : (portraitBytes ?? this.portraitBytes),
      cropScale: cropScale ?? (clearPortrait ? 1.0 : this.cropScale),
      cropOffset: cropOffset ?? (clearPortrait ? Offset.zero : this.cropOffset),
      verifiedPhone: verifiedPhone ?? this.verifiedPhone,
      verifiedEmail: verifiedEmail ?? this.verifiedEmail,
    );
  }
}

// Egyptian standard phone display
String formatDisplayPhone(String phone) {
  final clean = phone.trim().replaceAll(RegExp(r'\s+'), '');
  final egMatch = RegExp(r'^\+20(1[0125])(\d{4})(\d{4})$').firstMatch(clean);
  if (egMatch != null) {
    return '+20 ${egMatch.group(1)} ${egMatch.group(2)} ${egMatch.group(3)}';
  }
  return phone;
}

// Arabic Date Formatter
String formatArabicDate(DateTime date) {
  const arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
}

// =============================================================================
// Preview Scenarios
// =============================================================================

enum Screen18Scenario {
  mainEditTop,
  mainEditScrolled,
  photoActionSheet,
  photoCropModal,
  appliedCropAvatar,
  noPhotoInitials,
  discardConfirmationDialog,
  validationErrorEmptyName,
  accessibility200Top,
  accessibility200Scrolled,
}

extension Screen18ScenarioMetadata on Screen18Scenario {
  String get title {
    switch (this) {
      case Screen18Scenario.mainEditTop:
        return '01 Main Edit Profile (Top Fold)';
      case Screen18Scenario.mainEditScrolled:
        return '02 Main Edit Profile (Scrolled)';
      case Screen18Scenario.photoActionSheet:
        return '03 Photo Action Sheet';
      case Screen18Scenario.photoCropModal:
        return '04 1:1 Circular Crop Modal';
      case Screen18Scenario.appliedCropAvatar:
        return '05 Avatar Visibly Reflecting Applied Crop';
      case Screen18Scenario.noPhotoInitials:
        return '06 Avatar Initials (No Photo State)';
      case Screen18Scenario.discardConfirmationDialog:
        return '07 Discard Changes Dialog';
      case Screen18Scenario.validationErrorEmptyName:
        return '08 Validation Error (Empty Name)';
      case Screen18Scenario.accessibility200Top:
        return '09 Accessibility 200% (Top Fold)';
      case Screen18Scenario.accessibility200Scrolled:
        return '10 Accessibility 200% (Scrolled)';
    }
  }

  double get scrollOffset {
    switch (this) {
      case Screen18Scenario.mainEditScrolled:
        return 480.0;
      case Screen18Scenario.accessibility200Scrolled:
        return 650.0;
      default:
        return 0.0;
    }
  }

  double? get textScaleOverride {
    switch (this) {
      case Screen18Scenario.accessibility200Top:
      case Screen18Scenario.accessibility200Scrolled:
        return 2.0;
      default:
        return null;
    }
  }

  double get textScale => textScaleOverride ?? 1.0;
}

// =============================================================================
// State Controller
// =============================================================================

class Screen18EditProfileController extends ChangeNotifier {
  late CustomerProfileEditDraft _initialProfile;
  late CustomerProfileEditDraft _draft;

  bool _isSaving = false;
  String? _inlineNameError;
  bool _showDiscardDialog = false;
  bool _showPhotoSheet = false;
  bool _showCropModal = false;
  String? _snackBarNotice;
  double _cropZoom = 1.0;
  Offset _cropOffset = Offset.zero;

  CustomerProfileEditDraft get initialProfile => _initialProfile;
  CustomerProfileEditDraft get draft => _draft;
  bool get isSaving => _isSaving;
  String? get inlineNameError => _inlineNameError;
  bool get showDiscardDialog => _showDiscardDialog;
  bool get showPhotoSheet => _showPhotoSheet;
  bool get showCropModal => _showCropModal;
  String? get snackBarNotice => _snackBarNotice;
  double get cropZoom => _cropZoom;
  Offset get cropOffset => _cropOffset;

  Screen18EditProfileController() {
    _initialProfile = CustomerProfileEditDraft(
      fullName: 'أحمد مصطفى',
      proposedUsername: 'ahmed_mostafa',
      birthDate: DateTime(1998, 3, 15),
      gender: CustomerGender.male,
      portraitBytes: kScreen17DemoPortraitBytes,
      cropScale: 1.0,
      cropOffset: Offset.zero,
      verifiedPhone: '+201012345678',
      verifiedEmail: 'ahmed.mostafa@example.com',
    );
    _draft = _initialProfile;
  }

  bool get isDirty {
    return _draft.fullName.trim() != _initialProfile.fullName.trim() ||
        _draft.proposedUsername?.trim() != _initialProfile.proposedUsername?.trim() ||
        _draft.birthDate != _initialProfile.birthDate ||
        _draft.gender != _initialProfile.gender ||
        _draft.portraitBytes != _initialProfile.portraitBytes ||
        _draft.cropScale != _initialProfile.cropScale ||
        _draft.cropOffset != _initialProfile.cropOffset;
  }

  bool get isValid {
    return _draft.fullName.trim().length >= 2;
  }

  bool get isSaveEnabled {
    return isDirty && isValid && !_isSaving;
  }

  void updateFullName(String name) {
    _draft = _draft.copyWith(fullName: name);
    if (name.trim().isEmpty) {
      _inlineNameError = 'يرجى إدخال اسمك الكامل.';
    } else if (name.trim().length < 2) {
      _inlineNameError = 'الاسم يجب أن يتكون من حرفين على الأقل.';
    } else {
      _inlineNameError = null;
    }
    notifyListeners();
  }

  void updateUsername(String username) {
    final clean = username.trim().replaceAll('@', '');
    _draft = _draft.copyWith(proposedUsername: clean);
    notifyListeners();
  }

  void updateBirthDate(DateTime date) {
    _draft = _draft.copyWith(birthDate: date);
    notifyListeners();
  }

  void updateGender(CustomerGender gender) {
    _draft = _draft.copyWith(gender: gender);
    notifyListeners();
  }

  void updatePortrait(Uint8List? bytes) {
    if (bytes == null) {
      _draft = _draft.copyWith(clearPortrait: true, cropScale: 1.0, cropOffset: Offset.zero);
    } else {
      _draft = _draft.copyWith(portraitBytes: bytes, cropScale: 1.0, cropOffset: Offset.zero);
    }
    notifyListeners();
  }

  void openPhotoSheet() {
    _showPhotoSheet = true;
    notifyListeners();
  }

  void closePhotoSheet() {
    _showPhotoSheet = false;
    notifyListeners();
  }

  static const double cropViewportDimension = 260.0;

  static double maxPanForZoom(double zoom) {
    if (zoom <= 1.0) return 0.0;
    return (cropViewportDimension * (zoom - 1.0) / 2.0);
  }

  void _clampCropOffset() {
    final maxPan = maxPanForZoom(_cropZoom);
    if (maxPan <= 0.0) {
      _cropOffset = Offset.zero;
    } else {
      _cropOffset = Offset(
        _cropOffset.dx.clamp(-maxPan, maxPan),
        _cropOffset.dy.clamp(-maxPan, maxPan),
      );
    }
  }

  void openCropModal() {
    if (!_draft.hasPortrait) {
      _showPhotoSheet = false;
      showNotice('لا توجد صورة شخصية لاقتصاصها');
      notifyListeners();
      return;
    }
    _showPhotoSheet = false;
    _showCropModal = true;
    _cropZoom = _draft.cropScale.clamp(1.0, 2.5);
    _cropOffset = _draft.cropOffset;
    _clampCropOffset();
    notifyListeners();
  }

  void closeCropModal() {
    _showCropModal = false;
    _cropZoom = _draft.cropScale.clamp(1.0, 2.5);
    _cropOffset = _draft.cropOffset;
    _clampCropOffset();
    notifyListeners();
  }

  void setCropZoom(double zoom) {
    _cropZoom = zoom.clamp(1.0, 2.5);
    _clampCropOffset();
    notifyListeners();
  }

  void updateCropOffset(Offset delta) {
    final maxPan = maxPanForZoom(_cropZoom);
    if (maxPan <= 0.0) {
      _cropOffset = Offset.zero;
    } else {
      final newOffset = _cropOffset + delta;
      _cropOffset = Offset(
        newOffset.dx.clamp(-maxPan, maxPan),
        newOffset.dy.clamp(-maxPan, maxPan),
      );
    }
    notifyListeners();
  }

  void resetCrop() {
    _cropZoom = 1.0;
    _cropOffset = Offset.zero;
    notifyListeners();
  }

  void applyCrop() {
    _clampCropOffset();
    _draft = _draft.copyWith(
      cropScale: _cropZoom,
      cropOffset: _cropOffset,
    );
    _showCropModal = false;
    showNotice('تم اعتماد اقتصاص الصورة وتحديث المعاينة');
    notifyListeners();
  }

  void requestBack() {
    if (isDirty) {
      _showDiscardDialog = true;
    } else {
      showNotice('رجوع إلى صفحة الحساب');
    }
    notifyListeners();
  }

  void cancelDiscard() {
    _showDiscardDialog = false;
    notifyListeners();
  }

  void confirmDiscard() {
    _showDiscardDialog = false;
    _draft = _initialProfile;
    _inlineNameError = null;
    _cropZoom = _initialProfile.cropScale;
    _cropOffset = _initialProfile.cropOffset;
    showNotice('تم تجاهل التعديلات والرجوع إلى الحساب');
    notifyListeners();
  }

  void showNotice(String msg) {
    _snackBarNotice = msg;
    notifyListeners();
  }

  void clearNotice() {
    _snackBarNotice = null;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    if (!isSaveEnabled) return;
    _isSaving = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _isSaving = false;
    _initialProfile = _draft; // sync pristine state in prototype
    showNotice('معاينة محلية — تم حفظ التعديلات تجريبياً على هذا الجهاز');
    notifyListeners();
  }

  void setScenario(Screen18Scenario scenario) {
    _showDiscardDialog = false;
    _showPhotoSheet = false;
    _showCropModal = false;
    _inlineNameError = null;
    _snackBarNotice = null;

    switch (scenario) {
      case Screen18Scenario.mainEditTop:
      case Screen18Scenario.mainEditScrolled:
      case Screen18Scenario.accessibility200Top:
      case Screen18Scenario.accessibility200Scrolled:
        _draft = _initialProfile;
        _cropZoom = _draft.cropScale;
        _cropOffset = _draft.cropOffset;
        break;
      case Screen18Scenario.photoActionSheet:
        _draft = _initialProfile;
        _showPhotoSheet = true;
        break;
      case Screen18Scenario.photoCropModal:
        _draft = _initialProfile;
        _showCropModal = true;
        _cropZoom = 1.35;
        _cropOffset = const Offset(15, -10);
        _clampCropOffset();
        break;
      case Screen18Scenario.appliedCropAvatar:
        _draft = _initialProfile.copyWith(
          cropScale: 1.85,
          cropOffset: const Offset(20, -15),
        );
        _cropZoom = 1.85;
        _cropOffset = const Offset(20, -15);
        _clampCropOffset();
        break;
      case Screen18Scenario.noPhotoInitials:
        _draft = _initialProfile.copyWith(clearPortrait: true);
        _cropZoom = 1.0;
        _cropOffset = Offset.zero;
        break;
      case Screen18Scenario.discardConfirmationDialog:
        _draft = _draft.copyWith(fullName: 'أحمد مصطفى المعدل');
        _showDiscardDialog = true;
        break;
      case Screen18Scenario.validationErrorEmptyName:
        _draft = _draft.copyWith(fullName: '');
        _inlineNameError = 'يرجى إدخال اسمك الكامل.';
        break;
    }
    notifyListeners();
  }
}

// =============================================================================
// App Root Widget
// =============================================================================

class Screen18PreviewApp extends StatelessWidget {
  const Screen18PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Screen 18 — Edit Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: KonfrmTypography.fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF000000),
          primary: const Color(0xFF000000),
          surface: Colors.white,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFF3F4F6),
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontFamily: KonfrmTypography.fontFamily,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF000000) : const Color(0xFF6B7280),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 24,
              color: isSelected ? const Color(0xFF000000) : const Color(0xFF6B7280),
            );
          }),
        ),
      ),
      home: const Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Screen18PreviewView(),
      ),
    );
  }
}

// =============================================================================
// Main Preview View
// =============================================================================

class Screen18PreviewView extends StatefulWidget {
  const Screen18PreviewView({super.key});

  @override
  State<Screen18PreviewView> createState() => Screen18PreviewViewState();
}

class Screen18PreviewViewState extends State<Screen18PreviewView> {
  late final Screen18EditProfileController _controller;
  late final ScrollController _scrollController;
  late final FocusNode _keyboardFocusNode;
  late final TextEditingController _nameTextController;
  late final TextEditingController _usernameTextController;

  Screen18Scenario _scenario = Screen18Scenario.mainEditTop;
  bool _showDevTools = false;

  @override
  void initState() {
    super.initState();
    _controller = Screen18EditProfileController();
    _scrollController = ScrollController();
    _keyboardFocusNode = FocusNode();
    _nameTextController = TextEditingController(text: _controller.draft.fullName);
    _usernameTextController = TextEditingController(text: _controller.draft.proposedUsername ?? '');

    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    _keyboardFocusNode.dispose();
    _nameTextController.dispose();
    _usernameTextController.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    if (_nameTextController.text != _controller.draft.fullName) {
      _nameTextController.text = _controller.draft.fullName;
    }
    if (_usernameTextController.text != (_controller.draft.proposedUsername ?? '')) {
      _usernameTextController.text = _controller.draft.proposedUsername ?? '';
    }
    setState(() {});
  }

  void applyScenario(Screen18Scenario scenario) {
    setState(() {
      _scenario = scenario;
    });
    _controller.setScenario(scenario);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final offset = scenario.scrollOffset;
        if (offset > 0) {
          _scrollController.animateTo(
            offset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        } else {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.digit1) {
        applyScenario(Screen18Scenario.mainEditTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen18Scenario.mainEditScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen18Scenario.photoActionSheet);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen18Scenario.photoCropModal);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen18Scenario.appliedCropAvatar);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen18Scenario.noPhotoInitials);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen18Scenario.discardConfirmationDialog);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen18Scenario.validationErrorEmptyName);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        applyScenario(Screen18Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit0) {
        applyScenario(Screen18Scenario.accessibility200Scrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyO) {
        setState(() {
          _showDevTools = !_showDevTools;
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ambientMediaQuery = MediaQuery.of(context);
    final textScaleOverride = _scenario.textScaleOverride;
    final effectiveMediaQuery = textScaleOverride != null
        ? ambientMediaQuery.copyWith(
            textScaler: TextScaler.linear(textScaleOverride),
          )
        : ambientMediaQuery;

    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MediaQuery(
        data: effectiveMediaQuery,
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          bottomNavigationBar: _controller.showCropModal
              ? null
              : CustomerBottomNavigation(
                  selectedIndex: 3, // Account tab active!
                  onSelected: (index) {
                    final customerDestinations = ['استكشف', 'المفضلة', 'حجوزاتي', 'الحساب'];
                    if (index == 3) {
                      applyScenario(Screen18Scenario.mainEditTop);
                    } else {
                      _controller.showNotice('معاينة: الانتقال إلى الوجهة (${customerDestinations[index]})');
                    }
                  },
                ),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top App Bar with Physical RIGHT Return Arrow
                    _buildAppBar(),

                    // Scrollable Edit Form Body
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Portrait Hero with Black-on-White Camera Badge
                            _buildPortraitHero(),
                            const SizedBox(height: 20),

                            // 2. Personal Identity Section (Editable Fields)
                            _buildPersonalIdentityCard(),
                            const SizedBox(height: 16),

                            // 3. Verified Account Identifiers (Read-Only Security Section)
                            _buildVerifiedIdentifiersCard(),
                            const SizedBox(height: 20),

                            // 4. Primary Save CTA Button
                            _buildSaveButton(),
                            const SizedBox(height: 12),

                            // 5. Prototype Disclaimer Banner
                            _buildPrototypeNoticeBanner(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Photo Action Bottom Sheet Overlay
                if (_controller.showPhotoSheet) _buildPhotoActionSheet(),

                // 1:1 Circular Crop Preview Modal Overlay
                if (_controller.showCropModal) _buildCropModal(),

                // Discard Changes Confirmation Dialog Overlay
                if (_controller.showDiscardDialog) _buildDiscardDialog(),

                // Dev QA Overlay Panel
                if (_showDevTools) _buildDevToolsPanel(),

                // SnackBar Feedback Banner Overlay
                if (_controller.snackBarNotice != null) _buildNoticeSnackbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Top App Bar
  // ===========================================================================

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Return to Account Button (Physical RIGHT Arrow in RTL)
          Semantics(
            button: true,
            label: 'الرجوع إلى حسابي',
            child: GestureDetector(
              key: const Key('app_bar_back_button'),
              onTap: _controller.requestBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Center(
                  // In RTL Arabic, hierarchically returning to parent points physically RIGHT
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: GestureDetector(
              key: const Key('header_title_tap_area'),
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () {
                setState(() {
                  _showDevTools = !_showDevTools;
                });
              },
              child: const Text(
                'تعديل الملف الشخصي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Discard / Clear Action
          GestureDetector(
            key: const Key('app_bar_cancel_action'),
            onTap: _controller.requestBack,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _controller.isDirty ? const Color(0xFFB42318) : const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. Portrait Hero & Edit Affordance
  // ===========================================================================

  Widget _buildPortraitHero() {
    final draft = _controller.draft;

    return Center(
      child: Column(
        children: [
          // Circular Avatar (104x104) with Black-on-White Camera Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                key: const Key('avatar_edit_target'),
                onTap: _controller.openPhotoSheet,
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: draft.hasPortrait
                        ? Transform.translate(
                            offset: draft.cropOffset * (104.0 / 260.0),
                            child: Transform.scale(
                              scale: draft.cropScale,
                              child: Image.memory(
                                draft.portraitBytes!,
                                width: 104,
                                height: 104,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF000000),
                            child: Center(
                              child: Text(
                                draft.initials,
                                style: const TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              // Camera Edit Badge (Lower Edge, 48dp Touch Target)
              // Strict Founder Rule: Black icon (#000000) inside WHITE circular container with #E5E7EB border
              Positioned(
                bottom: -2,
                left: -2,
                child: GestureDetector(
                  key: const Key('camera_badge_button'),
                  onTap: _controller.openPhotoSheet,
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tap to change caption
          GestureDetector(
            onTap: _controller.openPhotoSheet,
            child: const Text(
              'تغيير الصورة الشخصية',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. Personal Identity Section (Editable Fields)
  // ===========================================================================

  Widget _buildPersonalIdentityCard() {
    final draft = _controller.draft;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Banner Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF9FAFB),
            child: const Row(
              children: [
                Icon(Icons.badge_outlined, size: 16, color: Color(0xFF000000)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'البيانات الأساسية',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Field 1: Full Name (الاسم الكامل)
                _buildFieldLabel(
                  label: 'الاسم الكامل',
                  isRequired: true,
                ),
                const SizedBox(height: 6),
                TextField(
                  key: const Key('field_full_name'),
                  controller: _nameTextController,
                  onChanged: _controller.updateFullName,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                  decoration: InputDecoration(
                    hintText: 'مثال: أحمد مصطفى',
                    hintStyle: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _controller.inlineNameError != null
                            ? const Color(0xFFB42318)
                            : const Color(0xFFE5E7EB),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _controller.inlineNameError != null
                            ? const Color(0xFFB42318)
                            : const Color(0xFF000000),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                if (_controller.inlineNameError != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.error_outline, size: 14, color: Color(0xFFB42318)),
                      const SizedBox(width: 4),
                      Text(
                        _controller.inlineNameError!,
                        style: const TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB42318),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // Field 2: Proposed Unified Username (@username)
                _buildFieldLabel(
                  label: 'اسم المستخدم الموحّد',
                  badge: 'اسم مقترح',
                ),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: TextField(
                    key: const Key('field_proposed_username'),
                    controller: _usernameTextController,
                    onChanged: _controller.updateUsername,
                    style: const TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                    decoration: InputDecoration(
                      prefixText: '@ ',
                      prefixStyle: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                      hintText: 'ahmed_mostafa',
                      hintStyle: const TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF000000), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'معرّف موحّد لحسابك ورابطك الشخصي. يخضع للتحقق من التوفر عند الاعتماد.',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Field 3: Private Birth Date (تاريخ الميلاد) + Derived Age
                _buildFieldLabel(
                  label: 'تاريخ الميلاد',
                  badge: '🔒 خاص — لا يظهر للعامة',
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  key: const Key('field_birth_date_picker'),
                  onTap: _showDatePickerSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cake_outlined, size: 18, color: Color(0xFF000000)),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                draft.birthDate != null
                                    ? formatArabicDate(draft.birthDate!)
                                    : 'حدد تاريخ ميلادك',
                                style: TextStyle(
                                  fontFamily: KonfrmTypography.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: draft.birthDate != null
                                      ? const Color(0xFF000000)
                                      : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (draft.derivedAgeYears != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Text(
                              '${draft.derivedAgeYears} سنة (محسوب تلقائياً)',
                              style: const TextStyle(
                                fontFamily: KonfrmTypography.fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Field 4: Private Gender (الجنس — اختياري)
                _buildFieldLabel(
                  label: 'الجنس',
                  badge: '🔒 خاص — لا يظهر للعامة',
                ),
                const SizedBox(height: 8),
                _buildGenderSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    final draft = _controller.draft;
    final effectiveScale = _scenario.textScaleOverride ?? MediaQuery.textScalerOf(context).scale(1.0);
    final isLargeText = effectiveScale >= 1.3;

    if (isLargeText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: CustomerGender.values.map((gender) {
          final isSelected = draft.gender == gender;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: gender.labelArabic,
              child: GestureDetector(
                key: Key('gender_option_${gender.name}'),
                onTap: () => _controller.updateGender(gender),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF000000) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          gender.labelArabic,
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF000000),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, size: 18, color: Colors.white)
                      else
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Row(
      children: CustomerGender.values.map((gender) {
        final isSelected = draft.gender == gender;
        return Expanded(
          child: Semantics(
            button: true,
            selected: isSelected,
            label: gender.labelArabic,
            child: GestureDetector(
              key: Key('gender_option_${gender.name}'),
              onTap: () => _controller.updateGender(gender),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF000000) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    gender.labelArabic,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFieldLabel({
    required String label,
    bool isRequired = false,
    String? badge,
  }) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFB42318),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
          ],
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
      ],
    );
  }

  // ===========================================================================
  // 3. Verified Account Identifiers (Read-Only Identity Section)
  // ===========================================================================

  Widget _buildVerifiedIdentifiersCard() {
    final draft = _controller.draft;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Banner Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF9FAFB),
            child: const Row(
              children: [
                Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF000000)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'معرّفات الحساب الموثّقة',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Verified Phone Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Center(
                    child: Icon(Icons.phone_outlined, size: 18, color: Color(0xFF000000)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رقم الهاتف الأساسي',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          formatDisplayPhone(draft.verifiedPhone),
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
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        'موثّق',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Verified Email Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Center(
                    child: Icon(Icons.mail_outline_rounded, size: 18, color: Color(0xFF000000)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'البريد الإلكتروني',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Text(
                          draft.verifiedEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        'موثّق',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

          // Explanatory footnote regarding security settings boundary
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFF9FAFB),
            child: const Text(
              'لحماية أمان حسابك، لا يمكن تعديل رقم الهاتف أو البريد الإلكتروني أو ربط وسائل تسجيل الدخول مباشرة من هذه الصفحة. لإدارة بيانات الأمان، يرجى الانتقال إلى إعدادات الأمان والحساب.',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. Primary Save CTA Button
  // ===========================================================================

  Widget _buildSaveButton() {
    final isEnabled = _controller.isSaveEnabled;
    final isSaving = _controller.isSaving;

    return Semantics(
      button: true,
      label: 'حفظ التعديلات',
      child: GestureDetector(
        key: const Key('save_profile_button'),
        onTap: isEnabled ? _controller.saveProfile : null,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isEnabled ? const Color(0xFF000000) : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(6),
            boxShadow: isEnabled
                ? const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'حفظ التعديلات',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 5. Prototype Notice Banner
  // ===========================================================================

  Widget _buildPrototypeNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF4B5563)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'معاينة تجريبية: يتم حفظ وتعديل البيانات محلياً فقط على هذا الجهاز. لن يتم إرسال أي تعديلات إلى خوادم الإنتاج.',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Photo Action Bottom Sheet Modal
  // ===========================================================================

  Widget _buildPhotoActionSheet() {
    return Container(
      color: const Color(0x80000000),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sheet Title
            const Text(
              'صورة الملف الشخصي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 16),

            // Action 1: Camera
            _buildPhotoActionItem(
              key: const Key('photo_action_camera'),
              icon: Icons.camera_alt_outlined,
              label: 'التقاط صورة بالكاميرا',
              onTap: () {
                _controller.closePhotoSheet();
                _controller.showNotice('معاينة: فتح الكاميرا (محلي)');
              },
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            // Action 2: Gallery
            _buildPhotoActionItem(
              key: const Key('photo_action_gallery'),
              icon: Icons.photo_library_outlined,
              label: 'اختيار من معرض الصور',
              onTap: () {
                _controller.closePhotoSheet();
                _controller.showNotice('معاينة: اختيار من المعرض (محلي)');
              },
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            // Action 3: Preview & Crop
            if (_controller.draft.hasPortrait) ...[
              _buildPhotoActionItem(
                key: const Key('photo_action_crop'),
                icon: Icons.crop_rotate_rounded,
                label: 'معاينة واقتصاص الصورة (1:1)',
                onTap: () {
                  _controller.openCropModal();
                },
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
            ],

            // Action 4: Remove Photo (if present)
            if (_controller.draft.hasPortrait) ...[
              _buildPhotoActionItem(
                key: const Key('photo_action_remove'),
                icon: Icons.delete_outline_rounded,
                label: 'إزالة الصورة الحالية',
                isDestructive: true,
                onTap: () {
                  _controller.updatePortrait(null);
                  _controller.closePhotoSheet();
                  _controller.showNotice('تمت إزالة الصورة الشخصية والعودة للأحرف الأولى');
                },
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
            ],
            const SizedBox(height: 8),

            // Cancel Button
            GestureDetector(
              key: const Key('photo_action_cancel'),
              onTap: _controller.closePhotoSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Center(
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
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

  Widget _buildPhotoActionItem({
    required Key key,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? const Color(0xFFB42318) : const Color(0xFF000000),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDestructive ? const Color(0xFFB42318) : const Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 1:1 Circular Crop Preview Modal Overlay
  // ===========================================================================

  Widget _buildCropModal() {
    final portraitBytes = _controller.draft.portraitBytes;

    return Container(
      color: const Color(0xFF000000),
      child: SafeArea(
        child: Column(
          children: [
            // Modal Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    key: const Key('crop_modal_cancel'),
                    onTap: _controller.closeCropModal,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0x33FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: Colors.white),
                    ),
                  ),
                  const Text(
                    'اقتصاص الصورة الشخصية',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    key: const Key('crop_modal_reset'),
                    onTap: _controller.resetCrop,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'إعادة ضبط',
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Honest disclaimer badge
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x4DFFFFFF)),
              ),
              child: const Text(
                'معاينة محلية لتعديل واقتصاص الصورة — لا يتم رفع الصور إلى الخادم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: KonfrmTypography.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            // Circular Crop Viewport Simulation with Pan & Zoom
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Underneath Image scaled by cropZoom and translated by cropOffset
                      ClipOval(
                        child: GestureDetector(
                          key: const Key('crop_viewport_gesture'),
                          onPanUpdate: (details) {
                            _controller.updateCropOffset(details.delta);
                          },
                          child: Container(
                            width: 260,
                            height: 260,
                            color: const Color(0xFF000000), // Pure Black #000000 per Founder mandate
                            child: portraitBytes != null
                                ? Transform.translate(
                                    offset: _controller.cropOffset,
                                    child: Transform.scale(
                                      scale: _controller.cropZoom,
                                      child: Image.memory(
                                        portraitBytes,
                                        width: 260,
                                        height: 260,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.person, size: 80, color: Colors.white54),
                                  ),
                          ),
                        ),
                      ),

                      // Circular Crop Overlay Ring
                      IgnorePointer(
                        child: Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Grid lines overlay
                      IgnorePointer(
                        child: CustomPaint(
                          size: const Size(260, 260),
                          painter: _CropGridPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Zoom Control Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: const Color(0x33000000),
              child: Row(
                children: [
                  const Icon(Icons.zoom_out, size: 20, color: Colors.white),
                  Expanded(
                    child: Slider(
                      value: _controller.cropZoom,
                      min: 1.0,
                      max: 2.5,
                      activeColor: Colors.white,
                      inactiveColor: const Color(0x66FFFFFF),
                      onChanged: _controller.setCropZoom,
                    ),
                  ),
                  const Icon(Icons.zoom_in, size: 20, color: Colors.white),
                ],
              ),
            ),

            // Bottom Confirm Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                key: const Key('crop_modal_apply'),
                onTap: _controller.applyCrop,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'اعتماد الصورة',
                      style: TextStyle(
                        fontFamily: KonfrmTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
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
  // Discard Changes Confirmation Dialog Overlay
  // ===========================================================================

  Widget _buildDiscardDialog() {
    return Container(
      color: const Color(0x80000000),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 22, color: Color(0xFFB42318)),
                SizedBox(width: 8),
                Text(
                  'تجاهل التعديلات غير المحفوظة؟',
                  style: TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'لديك تعديلات لم يتم حفظها في ملفك الشخصي. هل أنت متأكد من رغبتك في الرجوع وإلغاء هذه التعديلات؟',
              style: TextStyle(
                fontFamily: KonfrmTypography.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Keep editing (black)
                Expanded(
                  child: GestureDetector(
                    key: const Key('dialog_keep_editing_button'),
                    onTap: _controller.cancelDiscard,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'متابعة التعديل',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Discard (red text outline)
                Expanded(
                  child: GestureDetector(
                    key: const Key('dialog_confirm_discard_button'),
                    onTap: _controller.confirmDiscard,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: const Center(
                        child: Text(
                          'تجاهل التعديلات',
                          style: TextStyle(
                            fontFamily: KonfrmTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB42318),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Date Picker Sheet Helper
  // ===========================================================================

  void _showDatePickerSheet() {
    showDatePicker(
      context: context,
      initialDate: _controller.draft.birthDate ?? DateTime(1998, 3, 15),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'EG'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF000000),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF000000),
            ),
          ),
          child: child!,
        );
      },
    ).then((picked) {
      if (picked != null) {
        _controller.updateBirthDate(picked);
      }
    });
  }

  // ===========================================================================
  // SnackBar Feedback Banner Overlay
  // ===========================================================================

  Widget _buildNoticeSnackbar() {
    return Positioned(
      bottom: 80,
      left: 16,
      right: 16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _controller.snackBarNotice!,
                  style: const TextStyle(
                    fontFamily: KonfrmTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _controller.clearNotice,
                child: const Icon(Icons.close, size: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Dev QA Overlay Panel
  // ===========================================================================

  Widget _buildDevToolsPanel() {
    return Positioned(
      top: 60,
      left: 12,
      right: 12,
      child: Material(
        elevation: 16,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'سيناريوهات شاشة 18 — تعديل الملف',
                    style: TextStyle(
                      fontFamily: KonfrmTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() => _showDevTools = false),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),
              SizedBox(
                height: 320,
                child: ListView(
                  children: Screen18Scenario.values.map((s) {
                    final isCurrent = _scenario == s;
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        s.title,
                        style: TextStyle(
                          fontFamily: KonfrmTypography.fontFamily,
                          fontSize: 12,
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                          color: isCurrent ? const Color(0xFF000000) : const Color(0xFF4B5563),
                        ),
                      ),
                      trailing: isCurrent
                          ? const Icon(Icons.check, size: 16, color: Color(0xFF000000))
                          : null,
                      onTap: () {
                        applyScenario(s);
                        setState(() => _showDevTools = false);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for 1:1 Crop Grid lines
class _CropGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x4DFFFFFF)
      ..strokeWidth = 1.0;

    // 3x3 Grid lines inside circle
    final step = size.width / 3;
    canvas.drawLine(Offset(step, 0), Offset(step, size.height), paint);
    canvas.drawLine(Offset(step * 2, 0), Offset(step * 2, size.height), paint);
    canvas.drawLine(Offset(0, step), Offset(size.width, step), paint);
    canvas.drawLine(Offset(0, step * 2), Offset(size.width, step * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
