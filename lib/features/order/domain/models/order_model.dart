import 'package:dropezy_proto/v1/order/order.pb.dart' as pb;
import 'package:equatable/equatable.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';

import '../../../address/index.dart';
import 'order_model.ext.dart';
import 'order_product_model.dart';

part 'order_driver_model.dart';
part 'order_recipient_model.dart';
part 'order_status.dart';

/// Representation of an order that contains transaction information such as
/// items bought, amount paid, and order status.
class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.status,
    required this.orderDate,
    required this.paymentExpiryTime,
    this.estimatedArrivalTime,
    this.paymentCompletedTime,
    this.pickupTime,
    this.orderCompletionTime,
    required this.deliveryFee,
    required this.discount,
    required this.subTotal,
    required this.total,
    required this.productsBought,
    this.driver,
    this.recipient,
    required this.recipientAddress,
    required this.paymentInformation,
    required this.paymentMethod,
  });

  factory OrderModel.fromPb(pb.OrderData orderData) {
    // TODO (widy): Add new properties related to order timestamp
    return OrderModel.fromOrderAndPaymentInfo(
      orderData.order,
      orderData.paymentInformation,
    );
  }

  factory OrderModel.fromOrderAndPaymentInfo(
    pb.Order order,
    pb.PaymentInformation paymentInformation,
  ) {
    // TODO (widy): Add new properties related to order timestamp
    return OrderModel(
      id: order.orderId,
      deliveryFee: order.paymentSummary.deliveryFee.num,
      discount: order.paymentSummary.discount.num,
      subTotal: order.paymentSummary.subtotal.num,
      total: order.paymentSummary.total.num,
      status: order.state.toStatus,
      orderDate: order.orderDate.toDateTime(),
      productsBought: order.items.map(OrderProductModel.fromPb).toList(),
      paymentExpiryTime: order.paymentExpiryTime.toDateTime(),
      estimatedArrivalTime: order.estimatedDeliveryTime.toDateTime(),
      orderCompletionTime: order.orderCompletedTime.toDateTime(),
      recipientAddress:
          DeliveryAddressModel.fromPb(order.deliveryInfo.addressInfo),
      driver: OrderDriverModel.fromPb(order.deliveryInfo.driverInfo),
      recipient: OrderRecipientModel.fromPb(order.deliveryInfo.recipientInfo),
      paymentInformation:
          PaymentInformationModel.fromPaymentInfo(paymentInformation),
      paymentMethod: paymentInformation.paymentMethod,
    );
  }

  /// A unique identifier of an Order
  final String id;

  /// Current order status
  final OrderStatus status;

  /// Date & Time when order was first created
  final DateTime orderDate;

  /// Time limit before order expires
  /// because no payment is received
  final DateTime paymentExpiryTime;

  /// Estimated arrival time at which
  /// items are delivered to customer's address
  ///
  /// Will be null if status is not
  /// [OrderStatus.paid] or [OrderStatus.inDelivery]
  final DateTime? estimatedArrivalTime;

  /// Date & Time at which payment is completed
  ///
  /// Will not be null if status is  [OrderStatus.paid] or after
  final DateTime? paymentCompletedTime;

  /// Date & Time at which item is being delivered
  ///
  /// Will not be null if status is  [OrderStatus.inDelivery] or after
  final DateTime? pickupTime;

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

  /// Driver responsible for delivering the customer's order
  final OrderDriverModel? driver;

  /// Person that received the order from the driver
  final OrderRecipientModel? recipient;

  final DeliveryAddressModel recipientAddress;

  /// Payment Information
  final PaymentInformationModel paymentInformation;

  final pb.PaymentMethod paymentMethod;

  @override
  List<Object?> get props => [id];
}
