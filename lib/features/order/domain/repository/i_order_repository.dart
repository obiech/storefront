import 'package:storefront_app/features/order/domain/models/order_model.dart';

// TODO: Implement pagination
abstract class IOrderRepository {
  /// Gets a list of user's orders
  Future<List<OrderModel>> getUserOrders();
}
