import 'dart:async';
import 'dart:convert';

import 'package:customer_app/features/discovery/data/public_property.dart';
import 'package:customer_app/features/property_details/application/property_details_controller.dart';
import 'package:customer_app/features/property_details/data/property_details_models.dart';
import 'package:customer_app/features/property_details/data/property_details_repository.dart';
import 'package:customer_app/features/property_details/presentation/property_details_view.dart';
import 'package:customer_app/features/property_details/presentation/widgets/amenities_bottom_sheet.dart';
import 'package:customer_app/features/property_details/presentation/widgets/guest_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> _propertyJson({
  String id = 'prop-test-1',
  String title = 'شاليه مطل على البحر',
  int maxGuests = 6,
  int bedrooms = 2,
  int bathrooms = 2,
  double price = 3000.0,
}) =>
    {
      'id': id,
      'title': title,
      'unitType': 'CHALET',
      'propertyType': 'CHALET',
      'address': 'طريق الساحل الكيلو 120',
      'region': 'الساحل الشمالي',
      'resortName': 'مراسي',
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'maxGuests': maxGuests,
      'basePricePerNight': price,
      'currency': 'EGP',
      'images': [
        'https://cdn.example.com/images/1.jpg',
        'https://cdn.example.com/images/2.jpg',
        'https://cdn.example.com/images/3.jpg',
      ],
      'bedsCount': 3,
      'areaSqM': 120.0,
      'description': 'شاليه مميز بإطلالة بحرية مباشرة وتشطيب فاخر.',
      'amenities': [
        'WIFI',
        'POOL',
        'AIR_CONDITIONING',
        'KITCHEN',
        'PARKING',
      ],
      'houseRules': {'petsAllowed': false},
    };

Map<String, dynamic> _availabilityJson({String propertyId = 'prop-test-1'}) => {
      'propertyId': propertyId,
      'unavailableRanges': [
        {
          'checkIn': '2026-11-10',
          'checkOut': '2026-11-14',
        },
      ],
      'minStay': 2,
      'maxStay': 30,
    };

Map<String, dynamic> _quoteJson({
  String propertyId = 'prop-test-1',
  String checkIn = '2026-11-20',
  String checkOut = '2026-11-24',
  int nights = 4,
  int guests = 2,
  double totalStay = 12000.0,
  double depositAmount = 3000.0,
  double remainingAmount = 9000.0,
}) =>
    {
      'propertyId': propertyId,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'nights': nights,
      'guests': guests,
      'pricePerNight': 3000.0,
      'totalStay': totalStay,
      'depositAmount': depositAmount,
      'remainingAmount': remainingAmount,
      'currency': 'EGP',
      'quoteFingerprint': 'fp-quote-verified-12345',
    };

Widget _testApp({
  required String propertyId,
  required PropertyDetailsRepository repository,
  PublicProperty? initialProperty,
  double textScale = 1.0,
}) {
  return ProviderScope(
    overrides: [
      propertyDetailsRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: const Locale('ar'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        ),
      ),
      home: PropertyDetailsView(
        propertyId: propertyId,
        initialProperty: initialProperty,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClient mockClient;
  late PropertyDetailsRepository repository;

  setUp(() {
    mockClient = MockClient((request) async {
      final path = request.url.path;

      if (request.method == 'GET' && path == '/api/v1/customer/properties/prop-test-1') {
        return http.Response(
          jsonEncode({
            'success': true,
            'timestamp': '2026-10-12T00:00:00Z',
            'data': _propertyJson(),
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      if (request.method == 'GET' &&
          path == '/api/v1/customer/properties/prop-test-1/availability') {
        return http.Response(
          jsonEncode({
            'success': true,
            'timestamp': '2026-10-12T00:00:00Z',
            'data': _availabilityJson(),
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      if (request.method == 'POST' && path == '/api/v1/customer/bookings/calculate') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final inDate = DateTime.parse(body['checkIn'] as String);
        final outDate = DateTime.parse(body['checkOut'] as String);
        final nights = outDate.difference(inDate).inDays;
        final guests = body['guests'] as int;

        return http.Response(
          jsonEncode({
            'success': true,
            'timestamp': '2026-10-12T00:00:00Z',
            'data': _quoteJson(
              checkIn: body['checkIn'] as String,
              checkOut: body['checkOut'] as String,
              nights: nights,
              guests: guests,
              totalStay: nights * 3000.0,
              depositAmount: 3000.0, // Canonical deposit is strictly 1st night
              remainingAmount: (nights * 3000.0) - 3000.0,
            ),
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      return http.Response(
        jsonEncode({'success': false, 'error': {'message': 'Not found'}}),
        404,
        headers: {'content-type': 'application/json'},
      );
    });

    repository = PropertyDetailsRepository(
      baseUrl: 'https://api.example.test',
      client: mockClient,
    );
  });

  group('Screen 06 Property Details View — Component & Data Tests', () {
    testWidgets('renders property header, facts, price, and description', (tester) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      expect(find.text('شاليه مطل على البحر'), findsOneWidget);
      expect(find.textContaining('مراسي · الساحل الشمالي'), findsOneWidget);
      expect(find.textContaining('3,000 ج.م'), findsWidgets);
      expect(find.text('لليلة'), findsWidgets);

      // Facts bar
      expect(find.text('6 ضيوف'), findsOneWidget);
      expect(find.text('2 غرف نوم'), findsOneWidget);
      expect(find.text('2 حمامات'), findsOneWidget);

      // Description
      expect(find.text('عن الإقامة'), findsOneWidget);
      expect(
        find.text('شاليه مميز بإطلالة بحرية مباشرة وتشطيب فاخر.'),
        findsOneWidget,
      );
    });

    testWidgets('gallery shows image counter and updates on swipe', (tester) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      // Initial counter pill
      expect(find.text('1 / 3 صور'), findsOneWidget);

      // Next page in gallery
      final pageView = tester.widget<PageView>(find.byType(PageView));
      pageView.controller!.jumpToPage(1);
      await tester.pumpAndSettle();

      expect(find.text('2 / 3 صور'), findsOneWidget);
    });

    testWidgets('amenities preview displays items and opens bottom sheet', (tester) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      expect(find.text('أبرز المرافق'), findsOneWidget);
      expect(find.text('واي فاي'), findsOneWidget);
      expect(find.text('مسبح'), findsOneWidget);

      final openAllButton = find.text('عرض جميع المرافق');
      expect(openAllButton, findsOneWidget);

      await tester.ensureVisible(openAllButton);
      await tester.pumpAndSettle();

      await tester.tap(openAllButton);
      await tester.pumpAndSettle();

      // Bottom sheet open
      expect(find.descendant(of: find.byType(AmenitiesBottomSheet), matching: find.text('جميع المرافق')), findsWidgets);
      expect(find.descendant(of: find.byType(AmenitiesBottomSheet), matching: find.text('موقف سيارات')), findsOneWidget);
      expect(find.descendant(of: find.byType(AmenitiesBottomSheet), matching: find.text('مطبخ مجهز')), findsOneWidget);

      // Close bottom sheet
      final closeButton = find.text('إغلاق');
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.text('إغلاق'), findsNothing);
    });

    testWidgets('guest stepper clamps between 1 and maxGuests', (tester) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(GuestStepper));
      await tester.pumpAndSettle();

      final addGuestBtn = find.text('+');
      final removeGuestBtn = find.text('−');

      // Initial guest count is 1
      expect(find.text('1'), findsWidgets);

      // Increment
      await tester.tap(addGuestBtn);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsWidgets);

      // Increment up to maxGuests (6)
      for (var i = 0; i < 4; i++) {
        await tester.tap(addGuestBtn);
        await tester.pumpAndSettle();
      }
      expect(find.text('6'), findsWidgets);

      // Attempt to increment past 6 (button disabled, count remains 6)
      await tester.tap(addGuestBtn);
      await tester.pumpAndSettle();
      expect(find.text('6'), findsWidgets);

      // Decrement back down to 1
      for (var i = 0; i < 5; i++) {
        await tester.tap(removeGuestBtn);
        await tester.pumpAndSettle();
      }
      expect(find.text('1'), findsWidgets);

      // Decrement below 1 (button disabled, count remains 1)
      await tester.tap(removeGuestBtn);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('quote calculation and Founder truthful disclosure verification', (
      tester,
    ) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      final disclosureFinder = find.text('لا يتم الدفع عند إرسال الطلب؛ العربون بعد موافقة المالك.');
      await tester.ensureVisible(disclosureFinder);
      await tester.pumpAndSettle();

      // Verify BEFORE date selection
      expect(find.text('حدد التواريخ لعرض إجمالي الإقامة.'), findsOneWidget);
      expect(find.text('اختيار التواريخ'), findsOneWidget);

      // CRITICAL FOUNDER OVERRIDE VERIFICATION:
      // Must NOT contain the step-by-step "كيف يتم الحجز" explainer
      expect(find.textContaining('كيف يتم الحجز'), findsNothing);
      expect(find.textContaining('خطوات الحجز'), findsNothing);

      // Must CONTAIN the concise truthful disclosure
      expect(
        disclosureFinder,
        findsOneWidget,
      );
    });

    testWidgets('sticky bar transitions and triggers truthful handoff', (tester) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      final ctaButton = find.text('اختيار التواريخ');
      expect(ctaButton, findsOneWidget);

      // Tapping when no dates selected scrolls/focuses calendar
      await tester.tap(ctaButton);
      await tester.pumpAndSettle();
      expect(find.text('اختار إقامتك'), findsOneWidget);
    });

    testWidgets('recovers honestly from server error when property query fails', (
      tester,
    ) async {
      final failClient = MockClient((_) async {
        return http.Response(
          jsonEncode({'success': false, 'error': {'message': 'Internal Server Error'}}),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      final failRepo = PropertyDetailsRepository(
        baseUrl: 'https://api.example.test',
        client: failClient,
      );

      await tester.pumpWidget(_testApp(propertyId: 'prop-fail', repository: failRepo));
      await tester.pumpAndSettle();

      expect(find.text('تعذر تحميل بيانات الإقامة'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    testWidgets('initialProperty preview fails closed when GET details returns error', (
      tester,
    ) async {
      final failClient = MockClient((_) async {
        return http.Response(
          jsonEncode({'success': false, 'error': {'message': 'Forbidden / Unpublished'}}),
          403,
          headers: {'content-type': 'application/json'},
        );
      });

      final failRepo = PropertyDetailsRepository(
        baseUrl: 'https://api.example.test',
        client: failClient,
      );

      final preview = PublicProperty.fromJson(_propertyJson());

      await tester.pumpWidget(_testApp(
        propertyId: 'prop-preview-fail',
        repository: failRepo,
        initialProperty: preview,
      ));
      await tester.pumpAndSettle();

      // Must fail closed: honest error screen, blocking booking flow
      expect(find.text('تعذر تحميل بيانات الإقامة'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
      expect(find.text('اختار إقامتك'), findsNothing);
      expect(find.text('اختيار التواريخ'), findsNothing);
    });

    testWidgets('loading failure -> retry -> success transitions cleanly', (
      tester,
    ) async {
      var attempt = 0;
      final retryClient = MockClient((request) async {
        if (request.url.path.contains('/availability')) {
          return http.Response(
            jsonEncode({'success': true, 'data': _availabilityJson()}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        attempt++;
        if (attempt == 1) {
          return http.Response(
            jsonEncode({'success': false, 'error': {'message': 'Temporary Server Outage'}}),
            500,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({'success': true, 'data': _propertyJson()}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final retryRepo = PropertyDetailsRepository(
        baseUrl: 'https://api.example.test',
        client: retryClient,
      );

      await tester.pumpWidget(_testApp(propertyId: 'prop-retry', repository: retryRepo));
      await tester.pumpAndSettle();

      // Attempt 1: Error screen
      expect(find.text('تعذر تحميل بيانات الإقامة'), findsOneWidget);
      final retryBtn = find.text('إعادة المحاولة');
      expect(retryBtn, findsOneWidget);

      // Tap retry
      await tester.tap(retryBtn);
      await tester.pumpAndSettle();

      // Attempt 2: Success
      expect(find.text('تعذر تحميل بيانات الإقامة'), findsNothing);
      expect(find.text('شاليه مطل على البحر'), findsOneWidget);
    });

    testWidgets('favorite button displays unauthenticated SnackBar and remains unselected', (
      tester,
    ) async {
      await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
      await tester.pumpAndSettle();

      // Initially unselected outline heart
      final favoriteBtn = find.byIcon(Icons.favorite_border);
      expect(favoriteBtn, findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Tap favorite
      await tester.tap(favoriteBtn);
      await tester.pumpAndSettle();

      // Truthful disclosure toast
      expect(find.text('تسجيل الدخول مطلوب لحفظ العقار في المفضلة.'), findsOneWidget);

      // Stays unselected (not faking a saved state)
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    test('controller discards stale out-of-order quote responses', () async {
      final completer1 = Completer<BookingQuote>();
      final completer2 = Completer<BookingQuote>();
      var callCount = 0;

      final testRepo = _ControllableQuoteRepo(
        onQuote: (checkIn, checkOut, guests) {
          callCount++;
          if (callCount == 1) return completer1.future;
          return completer2.future;
        },
      );

      final controller = PropertyDetailsController(
        propertyId: 'prop-race-test',
        repository: testRepo,
      );

      controller.state = controller.state.copyWith(
        property: PublicPropertyDetail.fromJson(_propertyJson(id: 'prop-race-test')),
        availability: PropertyAvailability.fromJson(_availabilityJson(propertyId: 'prop-race-test')),
      );

      // 1. User selects dates A: Nov 20 to Nov 24 (4 nights)
      controller.selectDate(DateTime.utc(2026, 11, 20));
      controller.selectDate(DateTime.utc(2026, 11, 24));
      expect(controller.state.isCalculatingQuote, isTrue);

      // 2. User immediately changes dates to B: Nov 24 to Nov 29 (5 nights)
      controller.selectDate(DateTime.utc(2026, 11, 24));
      controller.selectDate(DateTime.utc(2026, 11, 29));
      expect(controller.state.isCalculatingQuote, isTrue);

      final quoteB = BookingQuote.fromJson(_quoteJson(
        propertyId: 'prop-race-test',
        checkIn: '2026-11-24',
        checkOut: '2026-11-29',
        nights: 5,
        guests: 1,
        totalStay: 15000.0,
        depositAmount: 3000.0,
        remainingAmount: 12000.0,
      ));

      final quoteA = BookingQuote.fromJson(_quoteJson(
        propertyId: 'prop-race-test',
        checkIn: '2026-11-20',
        checkOut: '2026-11-24',
        nights: 4,
        guests: 1,
        totalStay: 12000.0,
        depositAmount: 3000.0,
        remainingAmount: 9000.0,
      ));

      // 3. Second request resolves first
      completer2.complete(quoteB);
      await Future<void>.delayed(Duration.zero);
      expect(controller.state.quote, isNotNull);
      expect(controller.state.quote!.nights, 5);
      expect(controller.state.quote!.totalStay, 15000.0);

      // 4. Stale first request resolves later
      completer1.complete(quoteA);
      await Future<void>.delayed(Duration.zero);

      // Controller state MUST retain Quote B, never regressing to stale Quote A!
      expect(controller.state.quote!.nights, 5);
      expect(controller.state.quote!.totalStay, 15000.0);
    });
  });

  group('Screen 06 Property Details View — Multi-Viewport Layout Integrity', () {
    for (final width in [360.0, 390.0, 430.0]) {
      testWidgets('fits viewport width ${width}dp without horizontal overflow', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width * 3.0, 800.0 * 3.0);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(_testApp(propertyId: 'prop-test-1', repository: repository));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('شاليه مطل على البحر'), findsOneWidget);
      });
    }

    testWidgets('fits 360dp viewport with 200% text scale without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360.0 * 3.0, 800.0 * 3.0);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _testApp(
          propertyId: 'prop-test-1',
          repository: repository,
          textScale: 2.0,
        ),
      );
      await tester.pumpAndSettle();

      final ex = tester.takeException();
      expect(ex, isNull);
      expect(find.text('شاليه مطل على البحر'), findsOneWidget);
    });
  });
}

class _ControllableQuoteRepo extends PropertyDetailsRepository {
  _ControllableQuoteRepo({required this.onQuote})
      : super(
          baseUrl: 'https://api.example.test',
          client: MockClient((_) async => http.Response('{}', 200)),
        );

  final Future<BookingQuote> Function(String checkIn, String checkOut, int guests) onQuote;

  @override
  Future<BookingQuote> calculateQuote({
    required String propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
  }) {
    return onQuote(checkIn, checkOut, guests);
  }
}
