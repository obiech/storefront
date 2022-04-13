import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../domains.dart';

/// Repository for fetching order from storefront-backend
/// using gRPC connection.
@LazySingleton(as: IOrderRepository)
class OrderRepository extends IOrderRepository {
  OrderRepository(this.orderServiceClient);

  final OrderServiceClient orderServiceClient;

  @override
  Future<Either<Failure, List<OrderModel>>> getUserOrders() async {
    try {
      final response =
          await orderServiceClient.getOrderHistory(GetOrderHistoryRequest());

      return right(response.orders.map(OrderModel.fromPb).toList());
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
