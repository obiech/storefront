import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/widgets/order_widgets.dart';

import '../../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../../test_commons/utils/sample_order_models.dart';
import '../../../../../src/mock_navigator.dart';

/// Helper functions specific to this test

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpListItem({
    required OrderModel order,
    StackRouter? stackRouter,
    DateTime? currentTime,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      stackRouter != null
          ? StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: MaterialApp(
                home: Builder(
                  builder: (context) {
                    ctx = context;
                    return OrderHistoryListItem(
                      order: order,
                      currentTime: currentTime,
                    );
                  },
                ),
              ),
            )
          : MaterialApp(
              home: Builder(
                builder: (context) {
                  ctx = context;
                  return OrderHistoryListItem(
                    order: order,
                    currentTime: currentTime,
                  );
                },
              ),
            ),
    );

    return ctx;
  }
}

void main() {
  late StackRouter stackRouter;

  setUp(() {
    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((invocation) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());

    setUpLocaleInjection();
  });

  testWidgets(
    '[OrderHistoryListItem] should display a summary section, order thumbnail, '
    'and current order status regardless of order status',
    (tester) async {
      for (final o in sampleOrderModels) {
        await tester.pumpListItem(
          order: o,
        );
        expect(find.byType(OrderSummarySection), findsOneWidget);
        expect(find.byType(OrderStatusChip), findsOneWidget);

        final orderThumbnail = tester
            .firstWidget(find.byType(CachedNetworkImage)) as CachedNetworkImage;

        expect(
          orderThumbnail.imageUrl,
          o.productsBought[0].thumbnailUrl,
        );
      }
    },
  );

  testWidgets(
    '[OrderHistoryListItem] should also display time remaining '
    'before payment expiry and a button to continue payment '
    'if status is awaiting for payment ',
    (tester) async {
      // arrange
      final order = sampleOrderModels
          .firstWhere((el) => el.status == OrderStatus.awaitingPayment);

      final mockCurrentTime =
          order.paymentExpiryTime!.subtract(const Duration(seconds: 900));

      // act
      final context = await tester.pumpListItem(
        currentTime: mockCurrentTime,
        order: order,
      );

      // assert

      expect(find.byType(DropezyButton), findsOneWidget);

      final btn = tester.widget<DropezyButton>(find.byType(DropezyButton));
      expect(btn.label, context.res.strings.continuePayment);

      // should find countdown widget
      expect(find.byType(CountdownBuilder), findsOneWidget);
      expect(find.byType(TimingText), findsOneWidget);

      final timingText =
          tester.firstWidget(find.byType(TimingText)) as TimingText;

      final remainingTime =
          order.paymentExpiryTime!.difference(mockCurrentTime);

      // should show time icon and
      // remaining time before payment expiry (hh:mm:ss)
      expect(timingText.iconData, DropezyIcons.time);
      expect(timingText.timeLabel, remainingTime.toHhMmSs());

      for (int i = 1; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));

        final Duration newDuration =
            Duration(seconds: remainingTime.inSeconds - i);

        expect(find.text(newDuration.toHhMmSs()), findsOneWidget);
      }
    },
  );

  group(
    '[OrderHistoryListItem] should also display '
    'estimated delivery time remaining if status is',
    () {
      /// Test case for both statuses paid and in delivery
      Future<void> testFn({
        required WidgetTester tester,
        required DateTime mockCurrentTime,
        required OrderModel order,
      }) async {
        // act
        await tester.pumpListItem(
          currentTime: mockCurrentTime,
          order: order,
        );

        // assert

        // should find countdown widget
        expect(find.byType(CountdownBuilder), findsOneWidget);
        expect(find.byType(TimingText), findsOneWidget);

        final timingText =
            tester.firstWidget(find.byType(TimingText)) as TimingText;

        final remainingTime =
            order.estimatedArrivalTime!.difference(mockCurrentTime);

        // should show Pin icon and
        // remaining estimated delivery time (mm:ss)
        expect(timingText.iconData, DropezyIcons.pin);
        expect(timingText.timeLabel, remainingTime.toMmSs());

        for (int i = 1; i < 10; i++) {
          await tester.pump(const Duration(seconds: 1));

          final Duration newDuration =
              Duration(seconds: remainingTime.inSeconds - i);

          expect(find.text(newDuration.toMmSs()), findsOneWidget);
        }
      }

      testWidgets(
        'paid',
        (tester) async {
          // arrange

          final order = orderPaid;

          final mockCurrentTime = order.estimatedArrivalTime!
              .subtract(const Duration(seconds: 900));

          await testFn(
            tester: tester,
            mockCurrentTime: mockCurrentTime,
            order: order,
          );
        },
      );

      testWidgets(
        'in delivery',
        (tester) async {
          // arrange

          final order = orderInDelivery;

          final mockCurrentTime = order.estimatedArrivalTime!
              .subtract(const Duration(seconds: 900));

          await testFn(
            tester: tester,
            mockCurrentTime: mockCurrentTime,
            order: order,
          );
        },
      );
    },
  );

  testWidgets(
    '[OrderHistoryListItem] should display order completion date '
    'when status is arrived ',
    (tester) async {
      // arrange
      final order = orderArrived;

      // act
      await tester.pumpListItem(
        order: order,
      );

      // assert
      // should show TimingText, but not wrapped in CountdownBuilder
      expect(find.byType(CountdownBuilder), findsNothing);
      expect(find.byType(TimingText), findsOneWidget);

      final timingText =
          tester.firstWidget(find.byType(TimingText)) as TimingText;

      // should not have an icon
      expect(timingText.iconData, null);

      // and should display order completion date & time
      final df = DateFormat('d MMM y • HH:mm');
      expect(timingText.timeLabel, df.format(order.orderCompletionTime!));
    },
  );

  testWidgets(
    'should move to [PaymentInstructionsPage] '
    'when continue payment is press',
    (tester) async {
      final order = orderAwaitingPayment;

      await tester.pumpListItem(
        order: order,
        stackRouter: stackRouter,
      );

      await tester.tap(find.byType(DropezyButton));
      await tester.pumpAndSettle();

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      // there should only be one route that's being pushed
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<PaymentInstructionsRoute>());
    },
  );
}
