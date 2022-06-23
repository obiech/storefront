import 'package:storefront_app/core/core.dart';

import '../models/order_model.dart';

// TODO: Implement pagination
abstract class IOrderRepository {
  /// Gets a list of user's orders
  RepoResult<List<OrderModel>> getUserOrders();

  /// Gets an order by its ID
  /// [refresh] skips loading of cached order
  RepoResult<OrderModel> getOrderById(String id, {bool refresh = false});

  /// Add order from payment response
  void addOrder(OrderModel order);
}
