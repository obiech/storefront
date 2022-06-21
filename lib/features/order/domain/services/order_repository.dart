import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../../core/core.dart';
import '../domains.dart';

/// Repository for fetching order from storefront-backend
/// using gRPC connection.
@LazySingleton(as: IOrderRepository, env: DiEnvironment.grpcEnvs)
class OrderRepository extends IOrderRepository {
  OrderRepository(this.orderServiceClient);

  @visibleForTesting
  final OrderServiceClient orderServiceClient;

  @visibleForTesting
  List<OrderModel> orders = [];

  @override
  RepoResult<List<OrderModel>> getUserOrders() async {
    try {
      final response =
          await orderServiceClient.getOrderHistory(GetOrderHistoryRequest());

      orders.addAll(response.ordersData.map(OrderModel.fromPb).toList());

      return right(orders);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<OrderModel> getOrderById(String id) async {
    try {
      final index = orders.indexById(id);

      // Return model from in-memory cache if found
      if (index > -1) {
        return right(orders[index]);
      }

      final req = GetRequest(orderId: id);
      final response = await orderServiceClient.get(req);

      return right(OrderModel.fromPb(response.orderData));
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  void addOrder(OrderModel order) {
    final index = orders.indexById(order.id);

    if (index > -1) {
      orders[index] = order;
    } else {
      orders.add(order);
    }
  }
}
