import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import 'package:customer_app/features/discovery/application/public_discovery_controller.dart';
import 'package:customer_app/features/discovery/application/search_intent_controller.dart';
import 'package:customer_app/features/discovery/data/public_property.dart';
import 'package:customer_app/features/discovery/data/public_property_search_repository.dart';
import 'package:customer_app/features/discovery/data/search_intent_models.dart';
import 'package:customer_app/features/discovery/presentation/explore_view.dart';
import 'package:customer_app/features/discovery/presentation/search_refine_view.dart';
import 'package:customer_app/features/discovery/presentation/search_results_view.dart';
import 'package:customer_app/features/discovery/presentation/widgets/property_card_skeleton.dart';

class _FakePublicPropertySearchRepository
    extends PublicPropertySearchRepository {
  _FakePublicPropertySearchRepository({
    this.results = const [],
    this.failureKind,
    this.completer,
  }) : super(baseUrl: 'https://test.example.com', client: http.Client());

  List<PublicProperty> results;
  PublicSearchFailureKind? failureKind;
  Completer<List<PublicProperty>>? completer;
  int searchCallCount = 0;
  PublicPropertySearchFilters? lastFilters;

  @override
  Future<List<PublicProperty>> search(
    PublicPropertySearchFilters filters,
  ) async {
    searchCallCount++;
    lastFilters = filters;
    if (failureKind != null) {
      throw PublicSearchException(failureKind!);
    }
    if (completer != null) {
      return completer!.future;
    }
    return results;
  }
}

PublicProperty _testProperty({
  String id = 'prop-1',
  String title = 'شاليه مميز بإطلالة مباشرة على البحر',
  String resortName = 'الزمردة',
  String region = 'الساحل الشمالي',
  double basePricePerNight = 3500.0,
  int bedrooms = 3,
  int bathrooms = 2,
  int maxGuests = 6,
  String unitType = 'CHALET',
}) {
  return PublicProperty(
    id: id,
    title: title,
    basePricePerNight: basePricePerNight,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    maxGuests: maxGuests,
    unitType: unitType,
    region: region,
    resortName: resortName,
    address: 'الكيلو 120',
    propertyType: 'CHALET',
    currency: 'EGP',
    images: const [],
  );
}

Widget _buildTestApp({
  required Widget child,
  _FakePublicPropertySearchRepository? repository,
  SearchIntent? initialIntent,
  double textScaleFactor = 1.0,
  Size viewportSize = const Size(384, 854),
}) {
  final repo = repository ?? _FakePublicPropertySearchRepository();
  return ProviderScope(
    overrides: [
      publicPropertySearchRepositoryProvider.overrideWithValue(repo),
      if (initialIntent != null) ...[
        searchIntentControllerProvider.overrideWith(
          (ref) => SearchIntentController(initialIntent),
        ),
        publicDiscoveryControllerProvider.overrideWith(
          (ref) =>
              PublicDiscoveryController(repo)
                ..load(initialIntent.toSearchFilters()),
        ),
      ],
    ],
    child: MaterialApp(
      locale: const Locale('ar'),
      builder: (context, materialChild) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: viewportSize,
              textScaler: TextScaler.linear(textScaleFactor),
            ),
            child: materialChild!,
          ),
        );
      },
      home: child,
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  group('Screen 05 SearchResultsView Component & Layout Tests', () {
    testWidgets(
      'renders compact header with Arabic title and RTL back navigation',
      (tester) async {
        await tester.pumpWidget(
          _buildTestApp(
            child: const SearchResultsView(initialIntent: SearchIntent.empty),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('نتائج البحث'), findsOneWidget);
        final backButtonFinder = find.byKey(
          const Key('search-results-back-button'),
        );
        expect(backButtonFinder, findsOneWidget);

        final icon = tester.widget<Icon>(
          find.descendant(of: backButtonFinder, matching: find.byType(Icon)),
        );
        expect(icon.icon, Icons.arrow_forward_rounded);

        // Verify physical RTL coordinate: Back button is near the right edge in RTL
        final backPos = tester.getTopRight(backButtonFinder);
        expect(backPos.dx, greaterThan(300.0));
      },
    );

    testWidgets(
      'renders SearchResultsSummaryBar with ~52dp height and opens refine view',
      (tester) async {
        const intent = SearchIntent(
          selectedRegions: ['الزمردة', 'مارينا'],
          guestCount: 4,
        );

        await tester.pumpWidget(
          _buildTestApp(
            initialIntent: intent,
            child: const SearchResultsView(initialIntent: intent),
          ),
        );
        await tester.pumpAndSettle();

        final summaryFinder = find.byKey(
          const Key('search-results-summary-bar'),
        );
        expect(summaryFinder, findsOneWidget);
        final size = tester.getSize(summaryFinder);
        expect(size.height, closeTo(52.0, 4.0));

        expect(
          find.descendant(
            of: summaryFinder,
            matching: find.text('الزمردة، مارينا'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(of: summaryFinder, matching: find.text('4 ضيوف')),
          findsOneWidget,
        );

        // Tapping summary bar opens SearchRefineView
        await tester.tap(summaryFinder);
        await tester.pumpAndSettle();

        expect(find.text('ابحث عن إقامتك'), findsOneWidget);
        expect(find.byType(SearchRefineView), findsOneWidget);
      },
    );

    testWidgets(
      'ActiveFilterChipsRow renders chips with dual-zone tap semantics',
      (tester) async {
        final inDate = DateTime(2026, 7, 10);
        final outDate = DateTime(2026, 7, 15);
        final intent = SearchIntent(
          selectedRegions: const ['الزمردة', 'مارينا'],
          checkInDate: inDate,
          checkOutDate: outDate,
          guestCount: 3,
          selectedUnitTypes: const ['CHALET', 'VILLA'],
          maxPricePerNight: 5000.0,
        );

        await tester.pumpWidget(
          _buildTestApp(
            initialIntent: intent,
            child: SearchResultsView(initialIntent: intent),
          ),
        );
        await tester.pumpAndSettle();

        // Check destination chips
        expect(
          find.byKey(const Key('active-filter-region-الزمردة')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('active-filter-region-مارينا')),
          findsOneWidget,
        );

        // Check date chip
        expect(find.byKey(const Key('active-filter-dates')), findsOneWidget);

        // Check guests chip
        expect(find.byKey(const Key('active-filter-guests')), findsOneWidget);

        // Check unit type chips
        expect(
          find.byKey(const Key('active-filter-unit-type-CHALET')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('active-filter-unit-type-VILLA')),
          findsOneWidget,
        );

        // Check price ceiling chip
        expect(find.byKey(const Key('active-filter-price')), findsOneWidget);
      },
    );

    testWidgets(
      'removing exactly one destination removes only that destination',
      (tester) async {
        final repo = _FakePublicPropertySearchRepository(
          results: [_testProperty()],
        );
        const intent = SearchIntent(
          selectedRegions: ['الزمردة', 'مارينا'],
          guestCount: 2,
          maxPricePerNight: 4000.0,
        );

        await tester.pumpWidget(
          _buildTestApp(
            repository: repo,
            initialIntent: intent,
            child: const SearchResultsView(initialIntent: intent),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('active-filter-region-الزمردة')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('active-filter-region-مارينا')),
          findsOneWidget,
        );

        // Tap explicit remove [×] on الزمردة
        await tester.tap(
          find.byKey(const Key('active-filter-remove-region-الزمردة')),
        );
        await tester.pumpAndSettle();

        // الزمردة is removed, but مارينا remains!
        expect(
          find.byKey(const Key('active-filter-region-الزمردة')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('active-filter-region-مارينا')),
          findsOneWidget,
        );

        // Other filters (guests, price) remain untouched!
        expect(find.byKey(const Key('active-filter-guests')), findsOneWidget);
        expect(find.byKey(const Key('active-filter-price')), findsOneWidget);

        // Verify the new search was invoked with updated regions
        expect(repo.lastFilters?.destinations, equals(['مارينا']));
      },
    );

    testWidgets('removing date range clears check-in and check-out together', (
      tester,
    ) async {
      final repo = _FakePublicPropertySearchRepository(
        results: [_testProperty()],
      );
      final inDate = DateTime(2026, 7, 10);
      final outDate = DateTime(2026, 7, 15);
      final intent = SearchIntent(
        selectedRegions: const ['الزمردة'],
        checkInDate: inDate,
        checkOutDate: outDate,
      );

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          initialIntent: intent,
          child: SearchResultsView(initialIntent: intent),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active-filter-dates')), findsOneWidget);

      // Tap remove [×] on dates chip
      await tester.tap(find.byKey(const Key('active-filter-remove-dates')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active-filter-dates')), findsNothing);
      expect(
        find.byKey(const Key('active-filter-region-الزمردة')),
        findsOneWidget,
      );
    });

    testWidgets('removing unit type removes only that unit type', (
      tester,
    ) async {
      final repo = _FakePublicPropertySearchRepository(
        results: [_testProperty()],
      );
      const intent = SearchIntent(selectedUnitTypes: ['CHALET', 'VILLA']);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          initialIntent: intent,
          child: const SearchResultsView(initialIntent: intent),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('active-filter-unit-type-CHALET')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('active-filter-unit-type-VILLA')),
        findsOneWidget,
      );

      // Tap remove on CHALET
      await tester.tap(
        find.byKey(const Key('active-filter-remove-unit-CHALET')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('active-filter-unit-type-CHALET')),
        findsNothing,
      );
      expect(
        find.byKey(const Key('active-filter-unit-type-VILLA')),
        findsOneWidget,
      );
      expect(repo.lastFilters?.unitTypes, equals(['VILLA']));
    });

    testWidgets('removing guest count resets to default 1', (tester) async {
      final repo = _FakePublicPropertySearchRepository(
        results: [_testProperty()],
      );
      const intent = SearchIntent(guestCount: 4);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          initialIntent: intent,
          child: const SearchResultsView(initialIntent: intent),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active-filter-guests')), findsOneWidget);

      await tester.tap(find.byKey(const Key('active-filter-remove-guests')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active-filter-guests')), findsNothing);
      expect(repo.lastFilters?.guests, isNull);
    });

    testWidgets('removing price ceiling resets to unbounded null', (
      tester,
    ) async {
      final repo = _FakePublicPropertySearchRepository(
        results: [_testProperty()],
      );
      const intent = SearchIntent(maxPricePerNight: 3500.0);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          initialIntent: intent,
          child: const SearchResultsView(initialIntent: intent),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active-filter-price')), findsOneWidget);

      await tester.tap(find.byKey(const Key('active-filter-remove-price')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active-filter-price')), findsNothing);
      expect(repo.lastFilters?.maxPrice, isNull);
    });

    testWidgets('renders PropertyCardSkeleton during loading state', (
      tester,
    ) async {
      final completer = Completer<List<PublicProperty>>();
      final repo = _FakePublicPropertySearchRepository(completer: completer);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          child: const SearchResultsView(initialIntent: SearchIntent.empty),
        ),
      );
      // Pump without settle to catch loading state
      await tester.pump();

      expect(find.byType(PropertyCardSkeleton), findsWidgets);

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets(
      'renders truthful empty state with refine button when no properties match',
      (tester) async {
        final repo = _FakePublicPropertySearchRepository(results: const []);

        await tester.pumpWidget(
          _buildTestApp(
            repository: repo,
            child: const SearchResultsView(initialIntent: SearchIntent.empty),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('لا توجد نتائج مطابقة'), findsOneWidget);
        expect(
          find.text(
            'جرّب تعديل معايير البحث أو إزالة بعض الفلاتر لعرض خيارات أكثر.',
          ),
          findsOneWidget,
        );
        final refineBtn = find.byKey(
          const Key('search-results-empty-refine-button'),
        );
        expect(refineBtn, findsOneWidget);

        await tester.tap(refineBtn);
        await tester.pumpAndSettle();

        expect(find.byType(SearchRefineView), findsOneWidget);
      },
    );

    testWidgets('renders network error state with functional retry', (
      tester,
    ) async {
      final repo = _FakePublicPropertySearchRepository(
        failureKind: PublicSearchFailureKind.network,
      );

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          child: const SearchResultsView(initialIntent: SearchIntent.empty),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تعذر الاتصال بخدمة البحث'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);

      // Resolve error and retry
      repo.failureKind = null;
      repo.results = [_testProperty()];

      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pumpAndSettle();

      expect(find.text('شاليه مميز بإطلالة مباشرة على البحر'), findsOneWidget);
    });

    testWidgets('preserves results when editing filters is cancelled', (
      tester,
    ) async {
      final repo = _FakePublicPropertySearchRepository(
        results: [_testProperty(title: 'فيلا الساحل الأصلية')],
      );
      const intent = SearchIntent(selectedRegions: ['الزمردة']);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          initialIntent: intent,
          child: const SearchResultsView(initialIntent: intent),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('فيلا الساحل الأصلية'), findsOneWidget);

      // Open refine view from summary bar
      await tester.tap(find.byKey(const Key('search-results-summary-bar')));
      await tester.pumpAndSettle();

      expect(find.byType(SearchRefineView), findsOneWidget);

      // Cancel by tapping back arrow on SearchRefineView
      await tester.tap(find.byKey(const Key('search-refine-back-button')));
      await tester.pumpAndSettle();

      // Return to SearchResultsView: results and filters are completely preserved!
      expect(find.byType(SearchResultsView), findsOneWidget);
      expect(find.text('فيلا الساحل الأصلية'), findsOneWidget);
      expect(
        find.byKey(const Key('active-filter-region-الزمردة')),
        findsOneWidget,
      );
    });

    testWidgets(
      'accessibility & text scale up to 200% reflows without overflow',
      (tester) async {
        final repo = _FakePublicPropertySearchRepository(
          results: [_testProperty()],
        );
        const intent = SearchIntent(
          selectedRegions: ['الزمردة'],
          guestCount: 2,
          maxPricePerNight: 3000.0,
        );

        // 360dp width at 200% font scale
        await tester.pumpWidget(
          _buildTestApp(
            repository: repo,
            initialIntent: intent,
            viewportSize: const Size(360, 800),
            textScaleFactor: 2.0,
            child: const SearchResultsView(),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(SearchResultsView), findsOneWidget);
      },
    );

    testWidgets(
      'full journey: Screen 03 -> Screen 04 -> Screen 05 navigation',
      (tester) async {
        final repo = _FakePublicPropertySearchRepository(
          results: [_testProperty(title: 'فيلا الرحاب الفاخرة')],
        );

        await tester.pumpWidget(
          _buildTestApp(repository: repo, child: const ExploreView()),
        );
        await tester.pumpAndSettle();

        // 1. On Screen 03 (Explore), tap tune button on search trigger
        final tuneBtn = find.descendant(
          of: find.byKey(const Key('explore-search-trigger')),
          matching: find.byType(InkWell).last,
        );
        await tester.tap(tuneBtn);
        await tester.pumpAndSettle();

        // 2. Screen 04 (SearchRefineView) is opened
        expect(find.byType(SearchRefineView), findsOneWidget);

        // Tap apply button «عرض النتائج»
        final applyBtn = find.byKey(const Key('search-refine-apply-button'));
        await tester.tap(applyBtn);
        await tester.pumpAndSettle();

        // 3. Screen 05 (SearchResultsView) is displayed
        expect(find.byType(SearchResultsView), findsOneWidget);
        expect(find.text('نتائج البحث'), findsOneWidget);
        expect(find.text('فيلا الرحاب الفاخرة'), findsOneWidget);

        // 4. Back button returns to Screen 03
        await tester.tap(find.byKey(const Key('search-results-back-button')));
        await tester.pumpAndSettle();

        expect(find.byType(ExploreView), findsOneWidget);
      },
    );
  });
}
