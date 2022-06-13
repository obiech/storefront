import 'package:auto_route/auto_route.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

/// This [AutoRouteGuard] receives the deeplink
/// return from Gojek App and does the following :-
///
/// * Strips the deeplink query for the order Id.
///
/// * Query's the order from the [IOrderRepository]
///
/// * Then finally navigates to the [OrderDetailsRoute]
/// with the order.
///
/// TODO(obella): There are still a few cases to handle which include :-
///
/// * When there is no order id in deeplink.
///
/// * When order querying fails.
///
class CheckOrderStatus extends AutoRouteGuard {
  final IOrderRepository orderRepository;

  CheckOrderStatus(this.orderRepository);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final orderId = resolver.route.queryParams.get('order_id');
    // final status = resolver.route.queryParams.get('result');
    if (orderId != null) {
      final order = await orderRepository.getOrderById(orderId);
      // TODO(obella): Handle left
      router.push(
        OrderRouter(children: [OrderDetailsRoute(order: order.getRight())]),
      );
    }
    // TODO(obella): Handle all failure
  }
}
