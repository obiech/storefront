import 'package:dartz/dartz.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';

import '../../../../core/core.dart';

// TODO: Implement pagination
abstract class IOrderRepository {
  /// Gets a list of user's orders
  Future<Either<Failure, List<OrderModel>>> getUserOrders();
}
