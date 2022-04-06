import 'package:equatable/equatable.dart';

import 'order_product_model.dart';

part 'order_status.dart';

/// Representation of an order that contains transaction information such as
/// items bought, amount paid, and order status.
class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.status,
    required this.orderDate,
    this.paymentExpiryTime,
    this.estimatedArrivalTime,
    this.orderCompletionTime,
    required this.deliveryFee,
    required this.discount,
    required this.subTotal,
    required this.total,
    required this.productsBought,
  });

  /// A unique identifier of an Order
  final String id;

  /// Current order status
  final OrderStatus status;

  /// Date & Time when order was first created
  final DateTime orderDate;

  /// Time limit before order expires
  /// because no payment is received
  ///
  /// Will be null if status is not [OrderStatus.awaitingPayment]
  final DateTime? paymentExpiryTime;

  /// Estimated arrival time at which
  /// items are delivered to customer's address
  ///
  /// Will be null if status is not
  /// [OrderStatus.paid] or [OrderStatus.inDelivery]
  final DateTime? estimatedArrivalTime;

  /// Date & Time at which items are successfully
  /// delivered to customer's address
  ///
  /// Will be null if status is not [OrderStatus.arrived]
  final DateTime? orderCompletionTime;

  /// Total delivery fee for current order
  final String deliveryFee;

  /// Total discount for current order
  final String discount;

  /// Amount before [discount] and [deliveryFee]
  final String subTotal;

  /// [subTotal] minus [discount] and [deliveryFee]
  final String total;

  /// List of all products bought in this transaction
  final List<OrderProductModel> productsBought;

  @override
  List<Object?> get props => [id];
}
