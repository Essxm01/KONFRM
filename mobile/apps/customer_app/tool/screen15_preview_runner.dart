import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final fixtures = Screen15SampleFixtures.getAllFixtures();
  Screen15SampleFixtures.assertFixtureIntegrity(fixtures);

  const scenarioId = String.fromEnvironment('SCENARIO', defaultValue: '');
  final initialScenario = Screen15Scenario.values.cast<Screen15Scenario?>().firstWhere(
    (s) => s?.id == scenarioId,
    orElse: () => null,
  );

  runApp(Screen15PreviewApp(initialScenario: initialScenario));
}

// =============================================================================
// Canonical Customer Favorites Domain Types & State Machine for Screen 15
// =============================================================================

enum CustomerFavoritesAuthState {
  authenticated,
  guest,
  sessionExpired,
}

enum CustomerFavoritesLoadState {
  loaded,
  empty,
  initialLoading,
  networkError,
  staleError,
}

class FavoritePropertyItem {
  const FavoritePropertyItem({
    required this.id,
    required this.title,
    required this.unitType,
    required this.address,
    required this.region,
    required this.resortName,
    required this.bedrooms,
    required this.bathrooms,
    required this.maxGuests,
    required this.basePricePerNight,
    required this.currency,
    required this.isAvailable,
    required this.isFavorite,
    required this.themeColor,
  });

  final String id;
  final String title;
  final String unitType;
  final String address;
  final String region;
  final String resortName;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final double basePricePerNight;
  final String currency;
  final bool isAvailable;
  final bool isFavorite;
  final Color themeColor;

  FavoritePropertyItem copyWith({
    String? id,
    String? title,
    String? unitType,
    String? address,
    String? region,
    String? resortName,
    int? bedrooms,
    int? bathrooms,
    int? maxGuests,
    double? basePricePerNight,
    String? currency,
    bool? isAvailable,
    bool? isFavorite,
    Color? themeColor,
  }) {
    return FavoritePropertyItem(
      id: id ?? this.id,
      title: title ?? this.title,
      unitType: unitType ?? this.unitType,
      address: address ?? this.address,
      region: region ?? this.region,
      resortName: resortName ?? this.resortName,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      maxGuests: maxGuests ?? this.maxGuests,
      basePricePerNight: basePricePerNight ?? this.basePricePerNight,
      currency: currency ?? this.currency,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}

class FavoriteRemovalNotice {
  const FavoriteRemovalNotice({
    required this.propertyId,
    required this.propertyTitle,
    required this.message,
    required this.removedIndex,
    required this.removedItem,
  });

  final String propertyId;
  final String propertyTitle;
  final String message;
  final int removedIndex;
  final FavoritePropertyItem removedItem;
}

// =============================================================================
// Sample Fixtures with Strict Invariants
// =============================================================================

class Screen15SampleFixtures {
  static List<FavoritePropertyItem> getAllFixtures() {
    return [
      const FavoritePropertyItem(
        id: 'prop-marassi-01',
        title: 'شاليه فاخر بإطلالة مباشرة على لاجون مراسي',
        unitType: 'CHALET',
        address: 'الكيلو 129، طريق الإسكندرية - مطروح الصحراوي، سيدي عبد الرحمن',
        region: 'الساحل الشمالي',
        resortName: 'مراسي - مراسي باي',
        bedrooms: 3,
        bathrooms: 2,
        maxGuests: 6,
        basePricePerNight: 4500.0,
        currency: 'EGP',
        isAvailable: true,
        isFavorite: true,
        themeColor: Color(0xFF1E3A8A),
      ),
      const FavoritePropertyItem(
        id: 'prop-gouna-02',
        title: 'فيلا مستقلة مع مسبح خاص وحديقة واسعة',
        unitType: 'VILLA',
        address: 'حي الفنار، الجونة، الغردقة',
        region: 'البحر الأحمر',
        resortName: 'الجونة - الفنار',
        bedrooms: 4,
        bathrooms: 4,
        maxGuests: 8,
        basePricePerNight: 9200.0,
        currency: 'EGP',
        isAvailable: true,
        isFavorite: true,
        themeColor: Color(0xFF0F766E),
      ),
      const FavoritePropertyItem(
        id: 'prop-cairo-03',
        title: 'شقة عصرية راقية بالقرب من مجمع ووترواي',
        unitType: 'APARTMENT',
        address: 'شارع التسعين الشمالي، القاهرة الجديدة',
        region: 'القاهرة الجديدة',
        resortName: 'التجمع الخامس',
        bedrooms: 2,
        bathrooms: 2,
        maxGuests: 4,
        basePricePerNight: 2800.0,
        currency: 'EGP',
        isAvailable: true,
        isFavorite: true,
        themeColor: Color(0xFF334155),
      ),
      const FavoritePropertyItem(
        id: 'prop-marina-04',
        title: 'بنتهاوس على البحر مع تراس بانورامي في مارينا 5',
        unitType: 'CHALET',
        address: 'مارينا 5، العلمين، الساحل الشمالي',
        region: 'الساحل الشمالي',
        resortName: 'مارينا العلمين',
        bedrooms: 3,
        bathrooms: 2,
        maxGuests: 6,
        basePricePerNight: 3800.0,
        currency: 'EGP',
        isAvailable: false, // Inactive / unlisted by owner
        isFavorite: true,
        themeColor: Color(0xFF57534E),
      ),
    ];
  }

  static void assertFixtureIntegrity(List<FavoritePropertyItem> items) {
    if (items.isEmpty) {
      throw StateError('Screen 15 fixtures cannot be empty.');
    }
    for (final item in items) {
      if (item.id.trim().isEmpty) {
        throw StateError('Fixture id cannot be empty.');
      }
      if (item.title.trim().isEmpty) {
        throw StateError('Fixture title cannot be empty.');
      }
      if (item.basePricePerNight <= 0 || !item.basePricePerNight.isFinite) {
        throw StateError('Fixture price must be a positive finite number.');
      }
      if (item.bedrooms < 0 || item.bathrooms < 0 || item.maxGuests < 1) {
        throw StateError('Fixture capacity metrics are invalid.');
      }
      if (item.currency != 'EGP') {
        throw StateError('Fixture currency must strictly be EGP.');
      }
    }
  }
}

// =============================================================================
// 14 Comprehensive Preview Scenarios
// =============================================================================

enum Screen15Scenario {
  readyListTop(
    id: '01',
    label: '01. قائمة المفضلة — الطي الأول (3 وحدات موثقة وأسعار واضحة)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
  ),
  readyListScrolled(
    id: '02',
    label: '02. قائمة المفضلة — بعد التمرير (الوحدات اللاحقة وشريط التبويب)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
    autoScrollToEnd: true,
  ),
  emptyNoFavorites(
    id: '03',
    label: '03. المفضلة فارغة (توجيه واضح إلى استكشاف الإقامات)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.empty,
    textScale: 1.0,
  ),
  guestUnauthorized(
    id: '04',
    label: '04. جلسة زائر غير مسجل (توضيح أن المفضلة مربوطة بالحساب)',
    authState: CustomerFavoritesAuthState.guest,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
  ),
  sessionExpired401(
    id: '05',
    label: '05. انتهاء الجلسة 401 (تطهير البيانات وحماية الخصوصية)',
    authState: CustomerFavoritesAuthState.sessionExpired,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
  ),
  initialLoading(
    id: '06',
    label: '06. جارٍ التحميل الأولي (هيكل تحميل أنيق بدون وميض)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.initialLoading,
    textScale: 1.0,
  ),
  networkErrorInitial(
    id: '07',
    label: '07. خطأ في الاتصال الأولي (إعادة المحاولة بوضوح)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.networkError,
    textScale: 1.0,
  ),
  staleDataRefreshError(
    id: '08',
    label: '08. فشل التحديث مع بيانات محفوظة (تنبيه محايد أعلى القائمة)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.staleError,
    textScale: 1.0,
  ),
  removedUndoToast(
    id: '09',
    label: '09. إزالة مع خيار التراجع (Toast عائم مع زر تراجع)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
    simulateUndoNotice: true,
  ),
  unavailableItem(
    id: '10',
    label: '10. وحدة غير متوفرة حالياً (شارة محايدة وخيار إزالة هادئ)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
    includeUnavailable: true,
    autoScrollToEnd: true,
  ),
  singleCardFocus(
    id: '11',
    label: '11. معاينة مركزة لبطاقة مفضلة (فحص المعايير وزر القلب 48dp)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
    singleCardOnly: true,
  ),
  accessibility200Top(
    id: '12',
    label: '12. إمكانية الوصول 200% — الطي الأول (التفاف النصوص دون طفح)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 2.0,
  ),
  accessibility200Scrolled(
    id: '13',
    label: '13. إمكانية الوصول 200% — بعد التمرير (سلامة المسافات والبطاقات)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 2.0,
    autoScrollToEnd: true,
  ),
  qaAuditDevOverlay(
    id: '14',
    label: '14. لوحة التدقيق وأدوات المطورين (فحص الحالات وقياس الأزرار)',
    authState: CustomerFavoritesAuthState.authenticated,
    loadState: CustomerFavoritesLoadState.loaded,
    textScale: 1.0,
    showDevOverlay: true,
  );

  const Screen15Scenario({
    required this.id,
    required this.label,
    required this.authState,
    required this.loadState,
    required this.textScale,
    this.autoScrollToEnd = false,
    this.simulateUndoNotice = false,
    this.includeUnavailable = false,
    this.singleCardOnly = false,
    this.showDevOverlay = false,
  });

  final String id;
  final String label;
  final CustomerFavoritesAuthState authState;
  final CustomerFavoritesLoadState loadState;
  final double textScale;
  final bool autoScrollToEnd;
  final bool simulateUndoNotice;
  final bool includeUnavailable;
  final bool singleCardOnly;
  final bool showDevOverlay;
}

// =============================================================================
// State Controller for Screen 15
// =============================================================================

class Screen15FavoritesController extends ChangeNotifier {
  Screen15FavoritesController({
    required CustomerFavoritesAuthState initialAuth,
    required CustomerFavoritesLoadState initialLoad,
    required List<FavoritePropertyItem> initialItems,
    FavoriteRemovalNotice? initialUndo,
  })  : _authState = initialAuth,
        _loadState = initialLoad,
        _items = List.of(initialItems),
        _undoNotice = initialUndo;

  CustomerFavoritesAuthState _authState;
  CustomerFavoritesLoadState _loadState;
  List<FavoritePropertyItem> _items;
  FavoriteRemovalNotice? _undoNotice;
  final Set<String> _removingIds = {};
  String? _bannerMessage;

  CustomerFavoritesAuthState get authState => _authState;
  CustomerFavoritesLoadState get loadState => _loadState;
  List<FavoritePropertyItem> get items => List.unmodifiable(_items);
  FavoriteRemovalNotice? get undoNotice => _undoNotice;
  Set<String> get removingIds => Set.unmodifiable(_removingIds);
  String? get bannerMessage => _bannerMessage;

  void applyScenario(Screen15Scenario scenario) {
    _authState = scenario.authState;
    _loadState = scenario.loadState;
    _removingIds.clear();

    if (_authState != CustomerFavoritesAuthState.authenticated) {
      _items = [];
      _undoNotice = null;
      _bannerMessage = null;
      notifyListeners();
      return;
    }

    if (_loadState == CustomerFavoritesLoadState.empty) {
      _items = [];
      _undoNotice = null;
      _bannerMessage = null;
      notifyListeners();
      return;
    }

    final all = Screen15SampleFixtures.getAllFixtures();
    if (scenario.singleCardOnly) {
      _items = [all.first];
    } else if (scenario.includeUnavailable) {
      _items = List.of(all);
    } else {
      _items = all.where((p) => p.isAvailable).toList();
    }

    if (scenario.simulateUndoNotice && _items.isNotEmpty) {
      final removed = _items.first;
      _items = _items.sublist(1);
      _undoNotice = FavoriteRemovalNotice(
        propertyId: removed.id,
        propertyTitle: removed.title,
        message: 'تمت الإزالة من المفضلة',
        removedIndex: 0,
        removedItem: removed,
      );
    } else {
      _undoNotice = null;
    }

    if (_loadState == CustomerFavoritesLoadState.staleError) {
      _bannerMessage = 'تعذر تحديث المفضلة. آخر قائمة تم تحميلها ما زالت ظاهرة.';
    } else {
      _bannerMessage = null;
    }

    notifyListeners();
  }

  void toggleFavorite(String propertyId) {
    final index = _items.indexWhere((p) => p.id == propertyId);
    if (index == -1) return;

    final removed = _items[index];
    _items.removeAt(index);
    _undoNotice = FavoriteRemovalNotice(
      propertyId: removed.id,
      propertyTitle: removed.title,
      message: 'تمت الإزالة من المفضلة',
      removedIndex: index,
      removedItem: removed,
    );
    notifyListeners();
  }

  void undoRemoval() {
    if (_undoNotice == null) return;
    final notice = _undoNotice!;
    final insertIndex = notice.removedIndex.clamp(0, _items.length);
    _items.insert(insertIndex, notice.removedItem);
    _undoNotice = null;
    notifyListeners();
  }

  void dismissUndoNotice() {
    _undoNotice = null;
    notifyListeners();
  }

  void retryRefresh() {
    _bannerMessage = null;
    _loadState = CustomerFavoritesLoadState.loaded;
    notifyListeners();
  }
}

// =============================================================================
// Directionality-Isolated Arabic Price Component
// =============================================================================

class DirectionalPriceText extends StatelessWidget {
  const DirectionalPriceText({
    super.key,
    required this.amount,
    this.perNight = true,
    this.style,
  });

  final double amount;
  final bool perNight;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat('#,##0.##', 'en').format(amount);
    final text = perNight ? '$formattedAmount ج.م / ليلة' : '$formattedAmount ج.م';

    return Text(
      text,
      textDirection: ui.TextDirection.rtl,
      style: style ??
          KonfrmTypography.sectionTitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF09090B),
          ),
    );
  }
}

// =============================================================================
// Canonical Neutral Property Fallback Thumbnail (Screen 03/06 Consistent)
// =============================================================================

class ArchitecturalPropertyThumbnail extends StatelessWidget {
  const ArchitecturalPropertyThumbnail({
    super.key,
    required this.themeColor,
    required this.unitType,
    required this.region,
    required this.isAvailable,
  });

  final Color themeColor;
  final String unitType;
  final String region;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xFFF1F5F9) : const Color(0xFFE2E8F0),
        border: Border.all(
          color: isAvailable ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1),
          width: 1.0,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              Icons.home_work_outlined,
              size: 44,
              color: isAvailable ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          PositionedDirectional(
            bottom: 10,
            start: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                region,
                style: const TextStyle(
                  fontFamily: 'Cairo',
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
}

// =============================================================================
// Main Preview Application Harness
// =============================================================================

class Screen15PreviewApp extends StatelessWidget {
  const Screen15PreviewApp({super.key, this.initialScenario});

  final Screen15Scenario? initialScenario;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KONFRM Screen 15 Preview',
      theme: konfrmLightTheme(),
      builder: (context, child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Screen15HarnessPage(initialScenario: initialScenario),
    );
  }
}

class Screen15HarnessPage extends StatefulWidget {
  const Screen15HarnessPage({super.key, this.initialScenario});

  final Screen15Scenario? initialScenario;

  @override
  State<Screen15HarnessPage> createState() => Screen15HarnessPageState();
}

class Screen15HarnessPageState extends State<Screen15HarnessPage> {
  late Screen15Scenario _scenario;
  late final Screen15FavoritesController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showDevTools = false;
  int _bottomNavIndex = 1; // Tab 1: Favorites (Active)

  @override
  void initState() {
    super.initState();
    _scenario = widget.initialScenario ?? Screen15Scenario.readyListTop;
    final fixtures = Screen15SampleFixtures.getAllFixtures();
    _controller = Screen15FavoritesController(
      initialAuth: _scenario.authState,
      initialLoad: _scenario.loadState,
      initialItems: fixtures.where((p) => p.isAvailable).toList(),
    );
    applyScenario(_scenario);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _keyboardFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void applyScenario(Screen15Scenario scenario) {
    setState(() {
      _scenario = scenario;
      _showDevTools = scenario.showDevOverlay;
      _controller.applyScenario(scenario);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (scenario.autoScrollToEnd) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(0.0);
      }
    });
  }

  void _onNextScenario() {
    final values = Screen15Scenario.values;
    final nextIndex = (_scenario.index + 1) % values.length;
    applyScenario(values[nextIndex]);
  }

  void _onPrevScenario() {
    final values = Screen15Scenario.values;
    final prevIndex = (_scenario.index - 1 + values.length) % values.length;
    applyScenario(values[prevIndex]);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.digit1) {
        applyScenario(Screen15Scenario.readyListTop);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2) {
        applyScenario(Screen15Scenario.readyListScrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3) {
        applyScenario(Screen15Scenario.emptyNoFavorites);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4) {
        applyScenario(Screen15Scenario.guestUnauthorized);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5) {
        applyScenario(Screen15Scenario.sessionExpired401);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6) {
        applyScenario(Screen15Scenario.initialLoading);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7) {
        applyScenario(Screen15Scenario.networkErrorInitial);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8) {
        applyScenario(Screen15Scenario.staleDataRefreshError);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9) {
        applyScenario(Screen15Scenario.removedUndoToast);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyA) {
        applyScenario(Screen15Scenario.unavailableItem);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyB) {
        applyScenario(Screen15Scenario.singleCardFocus);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyC) {
        applyScenario(Screen15Scenario.accessibility200Top);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyD) {
        applyScenario(Screen15Scenario.accessibility200Scrolled);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyE) {
        applyScenario(Screen15Scenario.qaAuditDevOverlay);
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyN) {
        _onNextScenario();
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyP) {
        _onPrevScenario();
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyO) {
        setState(() {
          _showDevTools = !_showDevTools;
        });
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.keyU) {
        _controller.undoRemoval();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _applyScenario(Screen15Scenario scenario) => applyScenario(scenario);

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_scenario.textScale),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Main Screen Body
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top App Header
                    _buildTopHeader(),

                    // Content Area
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return _buildContent();
                        },
                      ),
                    ),
                  ],
                ),

                // Floating Undo SnackBar / Toast
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    if (_controller.undoNotice == null) {
                      return const SizedBox.shrink();
                    }
                    return _buildFloatingUndoToast(_controller.undoNotice!);
                  },
                ),

                // QA Dev Tools Overlay
                if (_showDevTools) _buildQaDevOverlay(),

                // Invisible QA Trigger (Long press top-right corner)
                PositionedDirectional(
                  top: 0,
                  end: 0,
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onLongPress: () {
                      setState(() {
                        _showDevTools = !_showDevTools;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildCustomerBottomNav(),
        ),
      ),
    );
  }

  // ===========================================================================
  // Top Header (RTL, Cairo Bold, Monochrome First)
  // ===========================================================================

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المفضلة',
            style: KonfrmTypography.pageTitle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF09090B),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'الوحدات التي حفظتها للرجوع إليها بسهولة.',
            style: KonfrmTypography.supporting.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF71717A),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Content Switcher
  // ===========================================================================

  Widget _buildContent() {
    // 1. Guest Unauthorized State
    if (_controller.authState == CustomerFavoritesAuthState.guest) {
      return _buildGuestState();
    }

    // 2. Session Expired (401) State
    if (_controller.authState == CustomerFavoritesAuthState.sessionExpired) {
      return _buildSessionExpiredState();
    }

    // 3. Initial Loading State (Shimmer Skeleton)
    if (_controller.loadState == CustomerFavoritesLoadState.initialLoading) {
      return _buildLoadingSkeleton();
    }

    // 4. Initial Network Error
    if (_controller.loadState == CustomerFavoritesLoadState.networkError) {
      return _buildNetworkErrorState();
    }

    // 5. Empty Favorites List
    if (_controller.loadState == CustomerFavoritesLoadState.empty ||
        _controller.items.isEmpty) {
      return _buildEmptyState();
    }

    // 6. Loaded List (with optional Stale Data banner)
    return _buildFavoritesList();
  }

  // ===========================================================================
  // Favorites List View (Cards + Offline Banner)
  // ===========================================================================

  Widget _buildFavoritesList() {
    final items = _controller.items;

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Stale Data Warning Banner (Neutral, Zero-Blue)
        if (_controller.bannerMessage != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  size: 20,
                  color: Color(0xFF475569),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _controller.bannerMessage!,
                    style: KonfrmTypography.supporting.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _controller.retryRefresh,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'تحديث',
                      style: KonfrmTypography.supporting.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF09090B),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Property Cards
        ...items.map((property) {
          return _buildFavoritePropertyCard(property);
        }),

        // Safe spacing above Bottom Navigation Bar
        const SizedBox(height: 24),
      ],
    );
  }

  // ===========================================================================
  // Favorite Property Card Component (12px Radius, 1.4:1 Aspect Ratio)
  // ===========================================================================

  Widget _buildFavoritePropertyCard(FavoritePropertyItem property) {
    final isUnavailable = !property.isAvailable;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnavailable ? const Color(0xFFE2E8F0) : const Color(0xFFE5E7EB),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isUnavailable
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('معاينة: فتح تفاصيل الوحدة (${property.title})'),
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cover Image Container (1.4:1 responsive aspect ratio)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.4,
                      child: ArchitecturalPropertyThumbnail(
                        themeColor: property.themeColor,
                        unitType: property.unitType,
                        region: property.region,
                        isAvailable: property.isAvailable,
                      ),
                    ),
                  ),

                  // Favorite Heart Action Button (>= 48dp Touch Target, Physical Left / RTL Top-Start)
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: Semantics(
                      button: true,
                      label: 'إزالة من المفضلة',
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _controller.toggleFavorite(property.id);
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Center(
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x20000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  size: 21,
                                  color: Color(0xFF09090B), // True black filled heart
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Status Badge for Unavailable / Unlisted Property
                  if (isUnavailable)
                    PositionedDirectional(
                      top: 14,
                      end: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181B).withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'غير متوفرة حالياً',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Card Body Details
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Property Title
                    Text(
                      property.title,
                      style: KonfrmTypography.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isUnavailable
                            ? const Color(0xFF71717A)
                            : const Color(0xFF09090B),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Location String (Resort, Region, Address)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Color(0xFF71717A),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${property.resortName}، ${property.region}',
                            style: KonfrmTypography.supporting.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF71717A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Specs Row (Bedrooms, Bathrooms, Guests)
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _buildSpecPill(
                          Icons.bed_outlined,
                          '${property.bedrooms} غرف نوم',
                        ),
                        _buildSpecPill(
                          Icons.bathtub_outlined,
                          '${property.bathrooms} حمامات',
                        ),
                        _buildSpecPill(
                          Icons.people_outline,
                          '${property.maxGuests} ضيوف',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),

                    // Bottom Row: Price & Action Cue
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price / Status explanation
                        if (isUnavailable)
                          Text(
                            'غير متاحة للحجز حالياً',
                            style: KonfrmTypography.supporting.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8),
                            ),
                          )
                        else
                          DirectionalPriceText(
                            amount: property.basePricePerNight,
                            perNight: true,
                          ),

                        // Removal CTA for unavailable or small detail affordance
                        if (isUnavailable)
                          TextButton(
                            onPressed: () {
                              _controller.toggleFavorite(property.id);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF09090B),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: const Size(48, 36),
                            ),
                            child: const Text(
                              'إزالة',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xFFA1A1AA),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecPill(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF71717A)),
        const SizedBox(width: 4),
        Text(
          text,
          style: KonfrmTypography.supporting.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF52525B),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Empty State (Zero Favorites)
  // ===========================================================================

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Subtle Heart Badge Container
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E4E7), width: 1.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_border,
                  size: 34,
                  color: Color(0xFF18181B),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'لم تحفظ أي إقامة بعد',
              style: KonfrmTypography.sectionTitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF09090B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                'اضغط على القلب في أي إقامة تعجبك لتظهر هنا في قائمتك الخاصة وتصل إليها بسرعة.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF71717A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            // Primary Explore CTA (56dp height, #000000, 6px radius)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _bottomNavIndex = 0; // Switch to Explore
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الانتقال إلى شاشة استكشف'),
                      duration: Duration(milliseconds: 900),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'استكشف الإقامات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
  // Guest / Unauthorized State
  // ===========================================================================

  Widget _buildGuestState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E4E7), width: 1.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_outline,
                  size: 34,
                  color: Color(0xFF18181B),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'سجّل الدخول لعرض المفضلة',
              style: KonfrmTypography.sectionTitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF09090B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                'احفظ الإقامات التي تعجبك وارجع إليها بسهولة من هنا. حفظ الإقامات لا يمثل حجزاً ولا يضمن توفرها في المستقبل.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF71717A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            // Primary Auth CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('محاكاة الانتقال إلى شاشة الدخول (Screen 08)'),
                      duration: Duration(milliseconds: 900),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'تسجيل الدخول أو إنشاء حساب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Secondary Explore Action
            TextButton(
              onPressed: () {
                setState(() {
                  _bottomNavIndex = 0;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF09090B),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                minimumSize: const Size(48, 48),
              ),
              child: const Text(
                'استكشف الإقامات كزائر',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Session Expired State (401)
  // ===========================================================================

  Widget _buildSessionExpiredState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFECDD3), width: 1.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.lock_clock_outlined,
                  size: 34,
                  color: Color(0xFF991B1B),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'انتهت جلسة تسجيل الدخول',
              style: KonfrmTypography.sectionTitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF09090B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                'لحماية بياناتك، يلزم تسجيل الدخول مرة أخرى لاستعراض قائمتك المفضلة وتأكيد حسابك.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF71717A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            // Primary Re-auth CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _applyScenario(Screen15Scenario.readyListTop);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'تسجيل الدخول مجددًا',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
  // Loading Skeleton State
  // ===========================================================================

  Widget _buildLoadingSkeleton() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        _buildSkeletonCard(),
        const SizedBox(height: 16),
        _buildSkeletonCard(),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: Container(
              color: const Color(0xFFF1F5F9),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 36,
                  color: Color(0xFFCBD5E1),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 220,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 180,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
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
  // Network Error State
  // ===========================================================================

  Widget _buildNetworkErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.cloud_off_outlined,
                  size: 34,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'تعذر تحميل المفضلة',
              style: KonfrmTypography.sectionTitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF09090B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                'تحقق من اتصالك بالإنترنت ثم حاول مرة أخرى لتحميل قائمتك المحفوظة.',
                style: KonfrmTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF71717A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _applyScenario(Screen15Scenario.readyListTop);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
  // Floating Undo Toast Component (Positioned Above Bottom Navigation)
  // ===========================================================================

  Widget _buildFloatingUndoToast(FavoriteRemovalNotice notice) {
    return PositionedDirectional(
      bottom: 72, // Clears the 60dp bottom nav + margin
      start: 16,
      end: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF09090B),
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
              const Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  notice.message,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  _controller.undoRemoval();
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'تراجع',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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
  // Customer Bottom Navigation Bar (4 Destinations, Tab 1 Active)
  // ===========================================================================

  Widget _buildCustomerBottomNav() {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(0, Icons.explore_outlined, Icons.explore, 'استكشف'),
              _buildNavItem(1, Icons.favorite_border, Icons.favorite, 'المفضلة'),
              _buildNavItem(2, Icons.confirmation_number_outlined, Icons.confirmation_number, 'حجوزاتي'),
              _buildNavItem(3, Icons.person_outline, Icons.person, 'الحساب'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
  ) {
    final isActive = _bottomNavIndex == index;
    final color = isActive ? const Color(0xFF000000) : const Color(0xFF71717A);

    return Expanded(
      child: Semantics(
        selected: isActive,
        button: true,
        label: label,
        child: InkWell(
          onTap: () {
            setState(() {
              _bottomNavIndex = index;
            });
            if (index == 1) {
              _applyScenario(Screen15Scenario.readyListTop);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('التبويب المحدد: $label'),
                  duration: const Duration(milliseconds: 600),
                ),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? filledIcon : outlineIcon,
                size: 23,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  height: 1.2,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // QA Dev Tools Overlay
  // ===========================================================================

  Widget _buildQaDevOverlay() {
    return Positioned(
      bottom: 64,
      left: 12,
      right: 12,
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF18181B),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'KONFRM Screen 15 QA Overlay',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showDevTools = false;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF3F3F46), height: 14),

              // Scenario Dropdown
              DropdownButton<Screen15Scenario>(
                value: _scenario,
                isExpanded: true,
                dropdownColor: const Color(0xFF27272A),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Colors.white,
                ),
                underline: Container(height: 1, color: const Color(0xFF71717A)),
                onChanged: (newScenario) {
                  if (newScenario != null) {
                    _applyScenario(newScenario);
                  }
                },
                items: Screen15Scenario.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s.label),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الحالة: ${_controller.authState.name} / ${_controller.loadState.name}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFA1A1AA),
                    ),
                  ),
                  Text(
                    'العناصر: ${_controller.items.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFA1A1AA),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
