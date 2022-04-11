import 'package:auto_route/auto_route.dart';
import 'package:storefront_app/core/app_router.gr.dart';

class CheckOrderStatus extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final orderId = resolver.route.queryParams.get('order_id');
    final status = resolver.route.queryParams.get('result');
    if (orderId != null) {
      if (status == 'success') {
        router.push(OrderSuccessfulRoute(orderId: orderId));
      } else {
        router.push(OrderFailureRoute(orderId: orderId));
      }
    }
    // TODO: Handle all failure
  }
}
