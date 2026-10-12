import 'dart:convert';

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
      home: PropertyDetailsView(propertyId: propertyId),
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
              depositAmount: (nights * 3000.0) * 0.25,
              remainingAmount: (nights * 3000.0) * 0.75,
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
