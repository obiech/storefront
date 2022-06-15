import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../../test_commons/utils/sample_order_models.dart';
import '../../../../../src/mock_navigator.dart';
import '../mock.dart';

void main() {
  late StackRouter stackRouter;
  late OrderDetailsCubit cubit;

  setUp(() {
    cubit = MockOrderDetailsCubit();
    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((invocation) async => null);
  });
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());

    setUpLocaleInjection();
  });
  group(
    'OrderDetailsPage',
    () {
      final finderStatusHeader = find.byType(
        OrderStatusHeader,
        skipOffstage: false,
      );
      final finderDetailsSection = find.byType(
        OrderDetailsSection,
        skipOffstage: false,
      );
      final finderPaymentSummary = find.byType(
        OrderPaymentSummary,
        skipOffstage: false,
      );
      final finderDriverAndRecipientSection = find.byType(
        DriverAndRecipientSection,
        skipOffstage: false,
      );
      final finderContactSupportButton = find.byType(
        ContactSupportButton,
        skipOffstage: false,
      );
      final finderDeliveryAddressDetail = find.byType(
        DeliveryAddressDetail,
        skipOffstage: false,
      );

      testWidgets(
        'for [OrderStatus.paid] should show order status header, '
        'list of purchased products, transaction summary, '
        'and a button to contact support',
        (tester) async {
          when(() => cubit.state).thenReturn(LoadedOrderDetails(orderPaid));
          await tester.pumpOrderDetailsView(order: orderPaid, cubit: cubit);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderDeliveryAddressDetail, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsNothing);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.inDelivery] should show order status header, '
        'list of purchased products, transaction summary, driver information '
        'and a button to contact support',
        (tester) async {
          when(() => cubit.state)
              .thenReturn(LoadedOrderDetails(orderInDelivery));

          await tester.pumpOrderDetailsView(
            order: orderInDelivery,
            cubit: cubit,
          );

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderDeliveryAddressDetail, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsOneWidget);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );

      testWidgets(
        'for [OrderStatus.arrived] should show order status header, '
        'list of purchased products, transaction summary, driver and '
        'recipient information, and a button to contact support',
        (tester) async {
          when(() => cubit.state).thenReturn(LoadedOrderDetails(orderArrived));

          await tester.pumpOrderDetailsView(order: orderArrived, cubit: cubit);

          expect(finderStatusHeader, findsOneWidget);
          expect(finderDetailsSection, findsOneWidget);
          expect(finderDeliveryAddressDetail, findsOneWidget);
          expect(finderPaymentSummary, findsOneWidget);
          expect(finderDriverAndRecipientSection, findsOneWidget);
          expect(finderContactSupportButton, findsOneWidget);
        },
      );
      testWidgets(
        'should navigate to Help Page '
        'when Support Button is tapped',
        (tester) async {
          when(() => cubit.state).thenReturn(LoadedOrderDetails(orderArrived));

          await tester.pumpOrderDetailsView(
            order: orderArrived,
            stackRouter: stackRouter,
            cubit: cubit,
          );
          await tester.tap(finderContactSupportButton);
          await tester.pumpAndSettle();

          final capturedRoutes =
              verify(() => stackRouter.push(captureAny())).captured;

          // there should only be one route that's being pushed
          expect(capturedRoutes.length, 1);

          final routeInfo = capturedRoutes.first as PageRouteInfo;

          // expecting the right route being pushed
          expect(routeInfo, isA<HelpRoute>());
        },
      );

      testWidgets(
        'should not shown Pay Now Button '
        'when Order status is not awaiting payment',
        (tester) async {
          final orders = fakeOrderModels;
          for (int i = 0; i < orders.length; i++) {
            when(() => cubit.state).thenReturn(LoadedOrderDetails(orders[i]));

            await tester.pumpOrderDetailsView(order: orders[i], cubit: cubit);

            expect(find.byType(PayNowButton), findsNothing);
          }
        },
      );
    },
  );
}

extension WidgetX on WidgetTester {
  Future<BuildContext> pumpOrderDetailsView({
    required OrderModel order,
    StackRouter? stackRouter,
    required OrderDetailsCubit cubit,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: BlocProvider<OrderDetailsCubit>(
                create: (_) => cubit,
                child: OrderDetailsPageWrapper(
                  id: order.id,
                ),
              ).withRouterScope(stackRouter),
            );
          },
        ),
      ),
    );
    return ctx;
  }
}
