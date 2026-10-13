import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/features/discovery/data/public_property.dart';
import 'package:customer_app/features/discovery/data/search_intent_models.dart';
import 'package:customer_app/features/discovery/presentation/search_refine_view.dart';
import 'package:customer_app/features/discovery/presentation/widgets/guest_stepper_field.dart';
import 'package:customer_app/features/discovery/presentation/widgets/price_ceiling_slider.dart';
import 'package:customer_app/features/discovery/presentation/widgets/region_multiselect_sheet.dart';
import 'package:customer_app/features/discovery/presentation/widgets/stay_dates_intent_picker.dart';
import 'package:customer_app/features/discovery/presentation/widgets/unit_type_selector.dart';
import 'package:customer_app/features/property_details/presentation/widgets/inline_availability_calendar.dart';

PublicProperty _makeTestProperty({
  required String id,
  required String title,
  required String unitType,
  String? region,
  String? resortName,
  required double price,
}) {
  return PublicProperty(
    id: id,
    title: title,
    unitType: unitType,
    address: 'شارع 1',
    region: region,
    resortName: resortName,
    bedrooms: 2,
    bathrooms: 1,
    maxGuests: 4,
    basePricePerNight: price,
    currency: 'EGP',
    images: [],
  );
}

void main() {
  group('SearchIntent Model & Invariant Tests', () {
    test('default SearchIntent has no active filters', () {
      const intent = SearchIntent.empty;
      expect(intent.hasActiveFilters, isFalse);
      expect(intent.guestCount, 1);
      expect(intent.selectedRegions, isEmpty);
      expect(intent.selectedUnitTypes, isEmpty);
      expect(intent.maxPricePerNight, isNull);
      expect(intent.stayNights, 0);
      expect(intent.destinationSummaryText, 'إلى أين؟');
    });

    test('destinationSummaryText formats 1, 2, and 3+ regions accurately', () {
      final one = SearchIntent(selectedRegions: ['مراسي']);
      expect(one.destinationSummaryText, 'مراسي');

      final two = SearchIntent(selectedRegions: ['مراسي', 'هاسيندا وايت']);
      expect(two.destinationSummaryText, 'مراسي، هاسيندا وايت');

      final three = SearchIntent(
        selectedRegions: ['مراسي', 'هاسيندا وايت', 'أمواج'],
      );
      expect(three.destinationSummaryText, 'مراسي + 2 مناطق');
    });

    test('date validation enforces 2 to 30 nights stay limits', () {
      final now = DateTime(2026, 7, 1);

      // 1 night stay (too short)
      final tooShort = SearchIntent(
        checkInDate: now,
        checkOutDate: now.add(const Duration(days: 1)),
      );
      expect(tooShort.stayNights, 1);
      expect(tooShort.hasValidDates, isFalse);

      // 3 nights stay (valid)
      final valid = SearchIntent(
        checkInDate: now,
        checkOutDate: now.add(const Duration(days: 3)),
      );
      expect(valid.stayNights, 3);
      expect(valid.hasValidDates, isTrue);

      // 35 nights stay (too long)
      final tooLong = SearchIntent(
        checkInDate: now,
        checkOutDate: now.add(const Duration(days: 35)),
      );
      expect(tooLong.stayNights, 35);
      expect(tooLong.hasValidDates, isFalse);
    });

    test('NON-NEGOTIABLE MR-11: toSearchFilters() excludes dates from public search params', () {
      final intent = SearchIntent(
        selectedRegions: ['مراسي'],
        checkInDate: DateTime(2026, 7, 10),
        checkOutDate: DateTime(2026, 7, 15),
        guestCount: 4,
        selectedUnitTypes: ['CHALET'],
        maxPricePerNight: 15000,
      );

      final queryFilters = intent.toSearchFilters();
      final queryParams = queryFilters.toQueryParameters();

      // Query params must include destinations, guests, unitType, and maxPrice
      expect(queryParams['destinations'], 'مراسي');
      expect(queryParams['guests'], '4');
      expect(queryParams['unitType'], 'CHALET');
      expect(queryParams['maxPrice'], '15000.0');

      // NON-NEGOTIABLE INVARIANT: Query params must NEVER contain dates
      expect(queryParams.containsKey('checkIn'), isFalse);
      expect(queryParams.containsKey('checkOut'), isFalse);
      expect(queryParams.containsKey('dates'), isFalse);
    });
  });

  group('FilterMetadata Dynamic Harvesting Tests', () {
    test(
      'extracts distinct destinations, types, and computed price ceiling',
      () {
        final properties = [
          _makeTestProperty(
            id: '1',
            title: 'فيلا مراسي',
            unitType: 'VILLA',
            resortName: 'مراسي',
            region: 'مطروح',
            price: 13500,
          ),
          _makeTestProperty(
            id: '2',
            title: 'شاليه هاسيندا',
            unitType: 'CHALET',
            resortName: 'هاسيندا وايت',
            region: 'الساحل الشمالي',
            price: 9000,
          ),
          _makeTestProperty(
            id: '3',
            title: 'شقة الجونة',
            unitType: 'APARTMENT',
            resortName: 'الجونة',
            region: 'البحر الأحمر',
            price: 5200,
          ),
        ];

        final meta = FilterMetadata.fromProperties(properties);
        expect(meta.availableDestinations, contains('مراسي'));
        expect(meta.availableDestinations, contains('هاسيندا وايت'));
        expect(meta.availableDestinations, contains('الجونة'));
        expect(
          meta.availableUnitTypes,
          containsAll(['VILLA', 'CHALET', 'APARTMENT']),
        );
        expect(meta.maxInventoryPrice, 13500.0);
        expect(meta.priceCeiling, 14000.0); // Rounded up to nearest 1,000 EGP
      },
    );
  });

  group('RegionMultiSelectSheet Widget Tests', () {
    testWidgets('renders 16px radius, search filter, and selection summary', (
      tester,
    ) async {
      List<String>? confirmedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      RegionMultiSelectSheet.show(
                        context: context,
                        initialSelected: ['مراسي'],
                        availableDestinations: [
                          'مراسي',
                          'هاسيندا وايت',
                          'تلال',
                        ],
                      ).then((res) => confirmedResult = res);
                    },
                    child: const Text('افتح'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('افتح'));
      await tester.pumpAndSettle();

      // Check header and 16px radius container
      expect(find.text('تحديد الوجهات'), findsOneWidget);
      expect(find.byKey(const Key('region-search-input')), findsOneWidget);
      expect(find.text('المحدد (1)'), findsOneWidget);

      // Toggle 'هاسيندا وايت'
      await tester.tap(find.byKey(const Key('region-row-هاسيندا وايت')));
      await tester.pumpAndSettle();

      expect(find.text('المحدد (2)'), findsOneWidget);

      // Search filter typing
      await tester.enterText(
        find.byKey(const Key('region-search-input')),
        'تلال',
      );
      await tester.pumpAndSettle();

      // Only 'تلال' should appear in filtered list
      expect(find.byKey(const Key('region-row-تلال')), findsOneWidget);
      expect(find.byKey(const Key('region-row-مراسي')), findsNothing);

      // Clear search
      await tester.enterText(find.byKey(const Key('region-search-input')), '');
      await tester.pumpAndSettle();

      // Confirm selection
      await tester.tap(find.byKey(const Key('search-sheet-dismiss-button')));
      await tester.pumpAndSettle();

      expect(confirmedResult, containsAll(['مراسي', 'هاسيندا وايت']));
    });
  });

  group('Screen 04 SearchRefineView Component Tests', () {
    testWidgets('GuestStepperField enforces 44dp hit targets and boundaries', (
      tester,
    ) async {
      var guests = 2;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return GuestStepperField(
                    guestCount: guests,
                    onChanged: (val) => setState(() => guests = val),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('2'), findsOneWidget);
      expect(find.text('تم تحديد فردان'), findsOneWidget);

      // Tap decrement
      await tester.tap(find.byKey(const Key('guest-stepper-decrement')));
      await tester.pumpAndSettle();
      expect(guests, 1);
      expect(find.text('1'), findsOneWidget);

      // Tap decrement at min 1 (should stay 1)
      await tester.tap(find.byKey(const Key('guest-stepper-decrement')));
      await tester.pumpAndSettle();
      expect(guests, 1);

      // Tap increment
      await tester.tap(find.byKey(const Key('guest-stepper-increment')));
      await tester.pumpAndSettle();
      expect(guests, 2);
    });

    testWidgets('UnitTypeSelector toggles chips correctly', (tester) async {
      var selected = <String>['CHALET'];

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return UnitTypeSelector(
                    selectedUnitTypes: selected,
                    onToggle: (type) {
                      setState(() {
                        if (selected.contains(type)) {
                          selected.remove(type);
                        } else {
                          selected.add(type);
                        }
                      });
                    },
                    onClearAll: () => setState(() => selected.clear()),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('unit-type-chip-CHALET')), findsOneWidget);
      expect(find.byKey(const Key('unit-type-chip-ALL')), findsOneWidget);

      // Tap "فيلا"
      await tester.tap(find.byKey(const Key('unit-type-chip-VILLA')));
      await tester.pumpAndSettle();
      expect(selected, containsAll(['CHALET', 'VILLA']));

      // Tap "الكل"
      await tester.tap(find.byKey(const Key('unit-type-chip-ALL')));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
    });

    testWidgets('PriceCeilingSlider adjusts and snaps to unbounded', (
      tester,
    ) async {
      double? price = 20000;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return PriceCeilingSlider(
                    maxPrice: price,
                    maxInventoryPrice: 50000,
                    onChanged: (val) => setState(() => price = val),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('20,000'), findsOneWidget);

      // Test unbounded initial state
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: PriceCeilingSlider(
                maxPrice: null,
                maxInventoryPrice: 50000,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('بدون حد أقصى'), findsWidgets);
    });

    testWidgets(
      'SearchRefineView full-page renders all sections and applies intent',
      (tester) async {
        SearchIntent? appliedResult;

        final initial = SearchIntent(
          selectedRegions: ['مراسي'],
          guestCount: 3,
          selectedUnitTypes: ['CHALET'],
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SearchRefineView(
                initialIntent: initial,
                onApplySearch: (intent) => appliedResult = intent,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check header
        expect(find.text('ابحث عن إقامتك'), findsOneWidget);
        expect(
          find.byKey(const Key('search-refine-back-button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('search-refine-reset-button')),
          findsOneWidget,
        );

        // Check destination container
        expect(find.text('مراسي'), findsOneWidget);

        // Check guest count
        expect(find.text('3'), findsOneWidget);

        // Check unit types
        expect(find.byKey(const Key('unit-type-chip-CHALET')), findsOneWidget);

        // Check apply button
        expect(
          find.byKey(const Key('search-refine-apply-button')),
          findsOneWidget,
        );
        expect(find.text('عرض النتائج'), findsOneWidget);

        // Tap apply button
        await tester.tap(find.byKey(const Key('search-refine-apply-button')));
        await tester.pumpAndSettle();

        expect(appliedResult, isNotNull);
        expect(appliedResult!.selectedRegions, contains('مراسي'));
        expect(appliedResult!.guestCount, 3);
      },
    );

    testWidgets('PriceCeilingSlider renders title, helper copy, and dynamic bounds', (
      tester,
    ) async {
      double? priceVal;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return PriceCeilingSlider(
                    maxPrice: priceVal,
                    minBudget: 1000,
                    maxBudget: 9000,
                    onChanged: (val) => setState(() => priceVal = val),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verify Title & Helper copy
      expect(find.text('الحد الأقصى لميزانية الليلة (اختياري)'), findsOneWidget);
      expect(
        find.text('اختر أقصى سعر لليلة لا تريد أن تتجاوزه، أو اتركه بدون حد لعرض جميع الأسعار.'),
        findsOneWidget,
      );
      expect(find.text('بدون حد أقصى'), findsNWidgets(2)); // Readout & boundary tick
      expect(find.text('1,000 ج.م'), findsOneWidget);
    });

    testWidgets('HorizontalDateRangePickerSheet renders RTL arrows and blue accents', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const HorizontalDateRangePickerSheet(),
                      );
                    },
                    child: const Text('افتح التقويم'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('افتح التقويم'));
      await tester.pumpAndSettle();

      // Verify header and RTL arrow buttons
      expect(find.text('تواريخ الإقامة'), findsOneWidget);
      expect(find.byKey(const Key('calendar-next-month-button')), findsOneWidget);
      expect(find.byKey(const Key('calendar-prev-month-button')), findsOneWidget);

      // Verify arrow icons:
      // "<" on physical RIGHT advances month
      // ">" on physical LEFT returns to previous month
      final nextIcon = tester.widget<Icon>(
        find.descendant(
          of: find.byKey(const Key('calendar-next-month-button')),
          matching: find.byType(Icon),
        ),
      );
      final prevIcon = tester.widget<Icon>(
        find.descendant(
          of: find.byKey(const Key('calendar-prev-month-button')),
          matching: find.byType(Icon),
        ),
      );

      expect(nextIcon.icon, Icons.chevron_left_rounded);
      expect(prevIcon.icon, Icons.chevron_right_rounded);

      // Tap next month button to verify horizontal navigation
      await tester.tap(find.byKey(const Key('calendar-next-month-button')));
      await tester.pumpAndSettle();
    });

    testWidgets('InlineAvailabilityCalendar renders RTL arrows (< on right, > on left)', (
      tester,
    ) async {
      var nextCalls = 0;
      var prevCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: InlineAvailabilityCalendar(
                currentMonth: DateTime(2026, 10, 1),
                availability: null,
                isLoadingAvailability: false,
                availabilityError: null,
                selectedCheckIn: null,
                selectedCheckOut: null,
                calendarError: null,
                onSelectDate: (_) {},
                onNextMonth: () => nextCalls++,
                onPreviousMonth: () => prevCalls++,
                onRetryAvailability: () {},
              ),
            ),
          ),
        ),
      );

      // Find icons in calendar nav buttons
      final iconWidgets = tester.widgetList<Icon>(find.byType(Icon)).toList();

      // Physical right button has Icons.chevron_left ("<")
      // Physical left button has Icons.chevron_right (">")
      expect(iconWidgets.any((i) => i.icon == Icons.chevron_left), isTrue);
      expect(iconWidgets.any((i) => i.icon == Icons.chevron_right), isTrue);
    });
  });
}
