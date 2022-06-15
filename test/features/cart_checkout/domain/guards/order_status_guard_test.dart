import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/domain/domains.dart';

import '../../../../commons.dart';
import '../../../../src/mock_navigator.dart';
import '../../../order/mocks.dart';

void main() {
  late IOrderRepository orderRepository;
  late CheckOrderStatus checkOrderStatusGuard;
  late NavigationResolver navigationResolver;
  late StackRouter stackRouter;

  const orderId = 'abcdefg';
  final order = OrderModel.fromOrderAndPaymentInfo(
    orderCreated,
    mockGoPayPaymentInformation,
  ).copyWith(id: orderId);

  setUp(() {
    orderRepository = MockOrderRepository();
    checkOrderStatusGuard = CheckOrderStatus(orderRepository);

    // Navigation
    navigationResolver = MockNavigationResolver();
    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);

    when(() => navigationResolver.route).thenAnswer(
      (invocation) => RouteHelpers.routeWithParams({
        'order_id': orderId,
      }),
    );

    when(() => orderRepository.getOrderById(orderId))
        .thenAnswer((invocation) async => right(order));
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  test('should go to [OrderDetails] page when navigating', () async {
    await checkOrderStatusGuard.onNavigation(navigationResolver, stackRouter);

    final capturedRoutes =
        verify(() => stackRouter.push(captureAny())).captured;

    expect(capturedRoutes.length, 1);

    final routeInfo = capturedRoutes.first as PageRouteInfo;

    expect(routeInfo, isA<OrderRouter>());

    final orderRouter = routeInfo as OrderRouter;
    expect(orderRouter.hasChildren, true);
    expect(orderRouter.initialChildren!.length, 1);

    final orderDetailsRoute = orderRouter.initialChildren!.first;
    expect(orderDetailsRoute, isA<OrderDetailsRoute>());

    final args = orderDetailsRoute.args as OrderDetailsRouteArgs;
    expect(args.id, order.id);
  });
}
