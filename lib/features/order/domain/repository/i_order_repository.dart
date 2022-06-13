import 'package:storefront_app/core/core.dart';

import '../models/order_model.dart';

// TODO: Implement pagination
abstract class IOrderRepository {
  /// Gets a list of user's orders
  RepoResult<List<OrderModel>> getUserOrders();

  /// Gets an order by its ID
  RepoResult<OrderModel> getOrderById(String id);

  /// Add order from payment response
  void addOrder(OrderModel order);
}
