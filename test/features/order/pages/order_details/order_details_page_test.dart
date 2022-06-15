import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../test_commons/utils/sample_order_models.dart';
import '../../../../src/mock_navigator.dart';
import 'mock.dart';

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
      testWidgets(
        'should show [OrderDetailsView] '
        'when order status is not Awaiting Payment',
        (tester) async {
          final orders = sampleOrderModels;
          for (int i = 0; i < orders.length; i++) {
            when(() => cubit.state).thenReturn(LoadedOrderDetails(orders[i]));
            await tester.pumpOrderDetailsPage(order: orders[i], cubit: cubit);

            expect(find.byType(OrderDetailsView), findsOneWidget);
          }
        },
      );
    },
  );
}

extension WidgetX on WidgetTester {
  Future<BuildContext> pumpOrderDetailsPage({
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
