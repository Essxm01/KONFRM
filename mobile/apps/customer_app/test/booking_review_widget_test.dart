import 'dart:convert';

import 'package:customer_app/features/booking_review/application/booking_review_controller.dart';
import 'package:customer_app/features/booking_review/data/booking_review_models.dart';
import 'package:customer_app/features/booking_review/data/booking_review_repository.dart';
import 'package:customer_app/features/booking_review/presentation/booking_review_view.dart';
import 'package:customer_app/features/booking_review/presentation/widgets/konfrm_price_text.dart';
import 'package:customer_app/features/property_details/application/property_details_controller.dart';
import 'package:customer_app/features/property_details/data/property_details_repository.dart';
import 'package:customer_app/features/property_details/presentation/property_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

BookingQuote _createTestQuote({
  String propertyId = 'prop-test-1',
  String checkIn = '2026-10-15',
  String checkOut = '2026-10-18',
  int nights = 3,
  int guests = 2,
  double pricePerNight = 4500.0,
  double totalStay = 13500.0,
  double depositAmount = 4500.0,
  double remainingAmount = 9000.0,
  String quoteFingerprint = 'fp-test-quote-001',
}) {
  return BookingQuote(
    propertyId: propertyId,
    checkIn: DateTime.parse(checkIn),
    checkOut: DateTime.parse(checkOut),
    nights: nights,
    guests: guests,
    pricePerNight: pricePerNight,
    totalStay: totalStay,
    depositAmount: depositAmount,
    remainingAmount: remainingAmount,
    currency: 'EGP',
    quoteFingerprint: quoteFingerprint,
  );
}

BookingReviewContext _createTestContext({
  BookingQuote? quote,
  int nights = 3,
  int guests = 2,
}) {
  final q = quote ?? _createTestQuote(nights: nights, guests: guests);
  return BookingReviewContext(
    propertyId: 'prop-test-1',
    propertyTitle: 'شاليه شاطئي فاخر برأس الحكمة',
    propertyLocation: 'رأس الحكمة، الساحل الشمالي',
    propertyImage: 'https://cdn.example.com/images/1.jpg',
    checkIn: q.checkIn,
    checkOut: q.checkOut,
    guests: guests,
    initialQuote: q,
  );
}

Widget _buildTestBookingReviewApp({
  required BookingReviewContext context,
  required VoidCallback onEditDetails,
  BookingReviewRepository? repository,
  String? authToken,
  bool startRevalidating = false,
  double textScale = 1.0,
  Size screenSize = const Size(390, 844),
}) {
  return ProviderScope(
    overrides: [
      if (repository != null)
        bookingReviewRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: const Locale('ar'),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(
          size: screenSize,
          textScaler: TextScaler.linear(textScale),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        ),
      ),
      home: BookingRequestReviewView(
        reviewContext: context,
        onEditDetails: onEditDetails,
        authToken: authToken,
        startRevalidating: startRevalidating,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KonfrmPriceText — Directionality & Monetary Order Truth', () {
    testWidgets('renders number before currency under RTL parent context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: KonfrmPriceText(
                  amount: 13500,
                  currency: 'ج.م',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KonfrmPriceText), findsOneWidget);
      expect(find.text('13,500'), findsOneWidget);
      expect(find.text('ج.م'), findsOneWidget);

      // Verify that Directionality.rtl is enclosing the Row
      final dirFinder = find.descendant(
        of: find.byType(KonfrmPriceText),
        matching: find.byWidgetPredicate(
          (w) => w is Directionality && w.textDirection == TextDirection.rtl,
        ),
      );
      expect(dirFinder, findsOneWidget);

      // Verify visual horizontal position: amount '13,500' appears physically to the RIGHT of currency 'ج.م'
      final numPos = tester.getTopLeft(find.text('13,500'));
      final currPos = tester.getTopLeft(find.text('ج.م'));
      expect(numPos.dx, greaterThan(currPos.dx));
    });

    test('formatString returns isolated RTL string', () {
      final formatted = KonfrmPriceText.formatString(4500);
      expect(formatted, contains('4,500'));
      expect(formatted, contains('ج.م'));
    });
  });

  group('Screen 07 Booking Request Review — Visual Hierarchy & Layout', () {
    testWidgets('renders AppBar, property card, stay details, price breakdown, disclosure, and sticky CTA', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 1200 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool editTapped = false;
      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () => editTapped = true,
      ));
      await tester.pumpAndSettle();

      // 1. App Bar
      expect(find.text('مراجعة طلب الحجز'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

      // 2. Compact Property Summary Card
      expect(find.text('شاليه شاطئي فاخر برأس الحكمة'), findsOneWidget);
      expect(find.text('رأس الحكمة، الساحل الشمالي'), findsOneWidget);

      // 3. Stay Details
      expect(find.text('تفاصيل الإقامة'), findsOneWidget);
      expect(find.text('التواريخ (3 ليالٍ):'), findsOneWidget);
      expect(find.text('ضيفان'), findsOneWidget);
      expect(find.text('تعديل'), findsOneWidget);

      // Tap 'تعديل'
      await tester.tap(find.text('تعديل'));
      await tester.pump();
      expect(editTapped, isTrue);

      // 4. Authoritative Price Breakdown
      expect(find.text('تفاصيل السعر'), findsOneWidget);
      expect(find.textContaining('إجمالي الإقامة'), findsOneWidget);
      expect(find.text('العربون بعد موافقة المالك:'), findsOneWidget);
      expect(find.textContaining('المبلغ المتبقي'), findsOneWidget);

      // 5. Concise Financial Disclosure
      expect(
        find.text('لا يتم الدفع عند إرسال الطلب؛ العربون بعد موافقة المالك.'),
        findsOneWidget,
      );

      // 6. Sticky Action Button
      expect(find.text('إرسال طلب الحجز للمالك'), findsOneWidget);
      final ctaFinder = find.byType(ElevatedButton);
      expect(ctaFinder, findsOneWidget);
      final btn = tester.widget<ElevatedButton>(ctaFinder);
      expect(btn.style?.backgroundColor?.resolve({}), const Color(0xFF000000));
    });
  });

  group('Screen 07 State Machine UI Coverage', () {
    testWidgets('unauthenticated submission triggers authRequired gate without fake tokens', (tester) async {
      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
        authToken: null, // Unauthenticated customer
      ));
      await tester.pumpAndSettle();

      expect(find.text('إرسال طلب الحجز للمالك'), findsOneWidget);
      await tester.tap(find.text('إرسال طلب الحجز للمالك'));
      await tester.pumpAndSettle();

      // State transitions to authRequired
      expect(find.text('تسجيل الدخول مطلوب لإرسال الطلب'), findsOneWidget);
      expect(find.text('تسجيل الدخول (قيد التجهيز)'), findsOneWidget);

      // Tapping it shows truthful SnackBar reporting native auth blocker
      await tester.tap(find.text('تسجيل الدخول (قيد التجهيز)'));
      await tester.pumpAndSettle();

      expect(
        find.text('تسجيل الدخول غير متاح حالياً في هذه النسخة التجريبية. يلزم حساب عميل لإرسال طلب الحجز.'),
        findsOneWidget,
      );
    });

    testWidgets('network error displays customer-friendly card and allows retry', (tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': false,
            'error': {'code': 'GATEWAY_TIMEOUT', 'message': 'Gateway timed out'},
          }),
          504,
          headers: {'content-type': 'application/json'},
        );
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
        repository: repository,
        authToken: 'test_token_123',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('إرسال طلب الحجز للمالك'));
      await tester.pumpAndSettle();

      // Verify network error state
      expect(find.text('تعذر إتمام العملية'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    testWidgets('date overlap/conflict displays warning and directs to change dates', (tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': false,
            'error': {'code': 'DATE_CONFLICT', 'message': 'Dates are no longer available'},
          }),
          409,
          headers: {'content-type': 'application/json'},
        );
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      bool editDatesTriggered = false;
      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () => editDatesTriggered = true,
        repository: repository,
        authToken: 'test_token_123',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('إرسال طلب الحجز للمالك'));
      await tester.pumpAndSettle();

      // Verify date conflict state
      expect(find.text('التواريخ لم تعد متاحة'), findsOneWidget);
      expect(find.text('اختيار تواريخ جديدة'), findsOneWidget);

      await tester.tap(find.text('اختيار تواريخ جديدة'));
      await tester.pump();
      expect(editDatesTriggered, isTrue);
    });

    testWidgets('successful submission displays requestSent confirmation screen', (tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'id': 'book_live_999',
              'bookingNumber': 'BK-78901',
              'status': 'PENDING_OWNER_APPROVAL',
              'propertyId': 'prop-test-1',
              'checkIn': '2026-10-15',
              'checkOut': '2026-10-18',
              'createdAt': '2026-10-12T18:00:00Z',
            },
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
        repository: repository,
        authToken: 'test_token_123',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('إرسال طلب الحجز للمالك'));
      await tester.pumpAndSettle();

      // Verify confirmation screen
      expect(find.text('تم إرسال طلبك للمالك'), findsOneWidget);
      expect(find.text('رقم الطلب: BK-78901'), findsOneWidget);
      expect(find.textContaining('طلبك قيد مراجعة المالك حالياً'), findsOneWidget);
      expect(find.text('العودة للاستكشاف'), findsOneWidget);
    });
  });

  group('Screen 06 to Screen 07 Flow & Preserved Context', () {
    late MockClient detailsMockClient;
    late PropertyDetailsRepository detailsRepository;

    setUp(() {
      detailsMockClient = MockClient((request) async {
        final path = request.url.path;

        if (request.method == 'GET' && path == '/api/v1/customer/properties/prop-test-1') {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'id': 'prop-test-1',
                'title': 'شاليه شاطئي فاخر برأس الحكمة',
                'unitType': 'CHALET',
                'propertyType': 'CHALET',
                'address': 'طريق الساحل الكيلو 120',
                'region': 'الساحل الشمالي',
                'resortName': 'رأس الحكمة',
                'bedrooms': 2,
                'bathrooms': 2,
                'maxGuests': 6,
                'basePricePerNight': 3000.0,
                'currency': 'EGP',
                'images': ['https://cdn.example.com/images/1.jpg'],
                'bedsCount': 3,
                'areaSqM': 120.0,
                'description': 'شاليه مميز بإطلالة بحرية.',
                'amenities': ['WIFI', 'POOL'],
                'houseRules': {'petsAllowed': false},
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (request.method == 'GET' && path == '/api/v1/customer/properties/prop-test-1/availability') {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'propertyId': 'prop-test-1',
                'unavailableRanges': [],
                'minStay': 2,
                'maxStay': 30,
              },
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

          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'propertyId': 'prop-test-1',
                'checkIn': body['checkIn'],
                'checkOut': body['checkOut'],
                'nights': nights,
                'guests': body['guests'],
                'pricePerNight': 3000.0,
                'totalStay': nights * 3000.0,
                'depositAmount': 3000.0,
                'remainingAmount': (nights * 3000.0) - 3000.0,
                'currency': 'EGP',
                'quoteFingerprint': 'fp-quote-verified-12345',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response('{}', 404);
      });

      detailsRepository = PropertyDetailsRepository(
        baseUrl: 'https://api.example.test',
        client: detailsMockClient,
      );
    });

    testWidgets('tapping review CTA on Screen 06 navigates to Screen 07; tapping تعديل returns cleanly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            propertyDetailsRepositoryProvider.overrideWithValue(detailsRepository),
          ],
          child: const MaterialApp(
            locale: Locale('ar'),
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: PropertyDetailsView(propertyId: 'prop-test-1'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select two dates on calendar via Riverpod controller
      final element = tester.element(find.byType(PropertyDetailsView));
      final container = ProviderScope.containerOf(element);
      final controller = container.read(propertyDetailsControllerProvider('prop-test-1').notifier);

      controller.selectDate(DateTime.utc(2026, 10, 14));
      controller.selectDate(DateTime.utc(2026, 10, 17));
      await tester.pumpAndSettle();

      // CTA should now say 'مراجعة طلب الحجز'
      expect(find.text('مراجعة طلب الحجز'), findsOneWidget);

      // Tap 'مراجعة طلب الحجز' -> pushes Screen 07
      await tester.tap(find.text('مراجعة طلب الحجز'));
      await tester.pumpAndSettle();

      // We are now on Screen 07!
      expect(find.text('تفاصيل الإقامة'), findsOneWidget);
      expect(find.text('تعديل'), findsOneWidget);

      // Tap 'تعديل' on Screen 07 -> pops back to Screen 06
      await tester.tap(find.text('تعديل'));
      await tester.pumpAndSettle();

      // Back on Screen 06 with quote and dates still present
      expect(find.text('مراجعة طلب الحجز'), findsOneWidget);
      expect(find.text('شاليه شاطئي فاخر برأس الحكمة'), findsOneWidget);
    });
  });

  group('Screen 07 Multi-Viewport & Accessibility Integrity', () {
    for (final width in [360.0, 390.0, 430.0]) {
      testWidgets('fits viewport width $width dp without overflow', (tester) async {
        tester.view.physicalSize = Size(width * 3.0, 800.0 * 3.0);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final reviewContext = _createTestContext();

        await tester.pumpWidget(_buildTestBookingReviewApp(
          context: reviewContext,
          onEditDetails: () {},
        ));
        await tester.pumpAndSettle();

        expect(find.text('مراجعة طلب الحجز'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('renders cleanly at 200% text scale without overflow', (tester) async {
      tester.view.physicalSize = const Size(390.0 * 3.0, 844.0 * 3.0);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
        textScale: 2.0,
      ));
      await tester.pumpAndSettle();

      expect(find.text('مراجعة طلب الحجز'), findsOneWidget);
      for (final ro in tester.allRenderObjects) {
        if (ro is RenderFlex && ro.toString().contains('OVERFLOWING')) {
          // ignore: avoid_print
          print('FOUND 238PX OVERFLOWING RENDERFLEX: ${ro.toStringDeep()}');
        }
      }
      expect(tester.takeException(), isNull);
    });
  });

  group('Bridge 11 State-Machine & Lifecycle Regression Suite', () {
    test('zero protected POST requests dispatched from every invalid state', () async {
      int postCallCount = 0;
      final mockClient = MockClient((request) async {
        if (request.method == 'POST' && request.url.path == '/api/v1/customer/bookings') {
          postCallCount++;
        }
        return http.Response('{}', 200);
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      final reviewContext = _createTestContext();

      // Test each non-reviewReady state
      for (final invalidState in [
        BookingReviewUiState.priceChanged,
        BookingReviewUiState.dateConflict,
        BookingReviewUiState.networkError,
        BookingReviewUiState.authRequired,
        BookingReviewUiState.revalidating,
        BookingReviewUiState.submitting,
        BookingReviewUiState.requestSent,
      ]) {
        final controller = BookingReviewController(
          initialContext: reviewContext,
          repository: repository,
          authToken: 'test_valid_token',
        );

        // Force into invalid state
        controller.state = controller.state.copyWith(uiState: invalidState);

        // Attempt submission
        await controller.submitBookingRequest();

        expect(
          postCallCount,
          0,
          reason: 'Expected 0 POST calls when submitting from $invalidState',
        );
      }
    });

    testWidgets('separate price acceptance from submission; no silent submission', (tester) async {
      int submitCount = 0;
      final mockClient = MockClient((request) async {
        if (request.method == 'POST' && request.url.path == '/api/v1/customer/bookings') {
          submitCount++;
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'id': 'book-accepted-1',
                'bookingNumber': 'BK-ACCEPTED',
                'status': 'PENDING_OWNER_APPROVAL',
                'propertyId': 'prop-test-1',
                'checkIn': '2026-10-15',
                'checkOut': '2026-10-18',
                'createdAt': '2026-10-12T18:00:00Z',
              },
            }),
            201,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('{}', 404);
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      final initialQuote = _createTestQuote(totalStay: 13500);
      final newQuote = _createTestQuote(totalStay: 15000, quoteFingerprint: 'fp-higher-price');
      final reviewContext = _createTestContext(quote: initialQuote).copyWith(
        authToken: 'test_token_123',
      );

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
        repository: repository,
        authToken: 'test_token_123',
      ));
      await tester.pumpAndSettle();

      // Trigger priceChanged on controller
      final element = tester.element(find.byType(BookingRequestReviewView));
      final container = ProviderScope.containerOf(element);
      final controller = container.read(bookingReviewControllerProvider(reviewContext).notifier);

      controller.state = controller.state.copyWith(
        uiState: BookingReviewUiState.priceChanged,
        previousQuote: initialQuote,
        currentQuote: newQuote,
      );
      await tester.pumpAndSettle();

      // 1. Verify separate acceptance button is displayed
      expect(find.text('قبول السعر الجديد ومتابعة المراجعة'), findsOneWidget);
      expect(find.text('إرسال طلب الحجز للمالك'), findsNothing);

      // 2. Tap acceptance button: must transition to reviewReady WITHOUT submitting
      await tester.tap(find.text('قبول السعر الجديد ومتابعة المراجعة'));
      await tester.pumpAndSettle();

      expect(submitCount, 0, reason: 'acceptNewPrice must not dispatch submission');
      expect(controller.state.uiState, BookingReviewUiState.reviewReady);
      expect(controller.state.currentQuote.totalStay, 15000);

      // 3. Now the distinct submission action is available
      expect(find.text('إرسال طلب الحجز للمالك'), findsOneWidget);

      // 4. Tap submission button: now submission is dispatched
      await tester.tap(find.text('إرسال طلب الحجز للمالك'));
      await tester.pumpAndSettle();

      expect(submitCount, 1);
      expect(find.text('تم إرسال طلبك للمالك'), findsOneWidget);
    });

    testWidgets('fingerprint-only shift does not claim monetary price increase/decrease', (tester) async {
      final initialQuote = _createTestQuote(totalStay: 13500, quoteFingerprint: 'fp-001');
      final fpOnlyQuote = _createTestQuote(totalStay: 13500, quoteFingerprint: 'fp-002');
      final reviewContext = _createTestContext(quote: initialQuote);

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
      ));
      await tester.pumpAndSettle();

      final element = tester.element(find.byType(BookingRequestReviewView));
      final container = ProviderScope.containerOf(element);
      final controller = container.read(bookingReviewControllerProvider(reviewContext).notifier);

      controller.state = controller.state.copyWith(
        uiState: BookingReviewUiState.priceChanged,
        previousQuote: initialQuote,
        currentQuote: fpOnlyQuote,
      );
      await tester.pumpAndSettle();

      // Truthful banner: details refreshed without monetary price shift
      expect(find.text('تم تحديث تفاصيل الحجز'), findsOneWidget);
      expect(find.textContaining('دون تغيير في السعر الإجمالي'), findsOneWidget);
      expect(find.text('السعر السابق'), findsNothing);
    });

    testWidgets('startRevalidating input triggers calculateQuote lifecycle in controller', (tester) async {
      int calcCallCount = 0;
      final mockClient = MockClient((request) async {
        if (request.method == 'POST' && request.url.path == '/api/v1/customer/bookings/calculate') {
          calcCallCount++;
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'propertyId': 'prop-test-1',
                'checkIn': '2026-10-15',
                'checkOut': '2026-10-18',
                'nights': 3,
                'guests': 2,
                'pricePerNight': 4500.0,
                'totalStay': 13500.0,
                'depositAmount': 4500.0,
                'remainingAmount': 9000.0,
                'currency': 'EGP',
                'quoteFingerprint': 'fp-fresh-001',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('{}', 404);
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      final reviewContext = _createTestContext();

      await tester.pumpWidget(_buildTestBookingReviewApp(
        context: reviewContext,
        onEditDetails: () {},
        repository: repository,
        startRevalidating: true,
      ));
      await tester.pumpAndSettle();

      expect(calcCallCount, greaterThan(0), reason: 'startRevalidating: true must trigger calculateQuote');
      expect(find.text('مراجعة طلب الحجز'), findsOneWidget);
    });

    test('retry differentiates quote revalidation failure from submission failure', () async {
      int calcCount = 0;
      int submitCount = 0;

      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/v1/customer/bookings/calculate') {
          calcCount++;
          return http.Response('{}', 504);
        }
        if (request.url.path == '/api/v1/customer/bookings') {
          submitCount++;
          return http.Response('{}', 504);
        }
        return http.Response('{}', 404);
      });

      final repository = BookingReviewRepository(
        baseUrl: 'https://api.example.test',
        client: mockClient,
      );

      final reviewContext = _createTestContext();
      final controller = BookingReviewController(
        initialContext: reviewContext,
        repository: repository,
        authToken: 'test_token_123',
      );

      // 1. Revalidation failure
      await controller.revalidateQuote();
      expect(controller.state.uiState, BookingReviewUiState.networkError);
      expect(controller.state.lastFailedOperation, BookingReviewOperation.quoteRevalidation);

      // Calling retry() should invoke revalidateQuote, NOT submitBookingRequest
      await controller.retry();
      expect(calcCount, 2);
      expect(submitCount, 0);

      // 2. Submission failure
      controller.state = controller.state.copyWith(
        uiState: BookingReviewUiState.reviewReady,
      );
      await controller.submitBookingRequest();
      expect(controller.state.uiState, BookingReviewUiState.networkError);
      expect(controller.state.lastFailedOperation, BookingReviewOperation.bookingSubmission);
      expect(submitCount, 1);

      // Calling retry() should now invoke submitBookingRequest preserving the exact same requestId
      await controller.retry();
      expect(submitCount, 2);
      expect(calcCount, 2);
    });
  });
}

