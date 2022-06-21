import 'package:dropezy_proto/v1/order/order.pbenum.dart' as pb;
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';

import '../../../address/index.dart';
import 'order_model.dart';
import 'order_product_model.dart';

extension OrderModelListX on List<OrderModel> {
  /// Get order index in list
  int indexById(String id) => indexWhere((o) => o.id == id);
}

extension OrderModelX on OrderModel {
  /// Copy With
  OrderModel copyWith({
    String? id,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? paymentExpiryTime,
    DateTime? estimatedArrivalTime,
    DateTime? paymentCompletedTime,
    DateTime? pickupTime,
    DateTime? orderCompletionTime,
    String? deliveryFee,
    String? discount,
    String? subTotal,
    String? total,
    List<OrderProductModel>? productsBought,
    OrderDriverModel? driver,
    OrderRecipientModel? recipient,
    DeliveryAddressModel? recipientAddress,
    PaymentInformationModel? paymentInformation,
    pb.PaymentMethod? paymentMethod,
  }) {
    return OrderModel(
      id: id ?? this.id,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      subTotal: subTotal ?? this.subTotal,
      total: total ?? this.total,
      productsBought: productsBought ?? this.productsBought,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      paymentInformation: paymentInformation ?? this.paymentInformation,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

/// Order State extension
extension OrderStateX on pb.OrderState {
  OrderStatus get toStatus {
    switch (this) {
      case pb.OrderState.ORDER_STATE_CANCELLED:
        return OrderStatus.cancelled;
      case pb.OrderState.ORDER_STATE_CREATED:
      case pb.OrderState.ORDER_STATE_WAITING_FOR_PAYMENT:
        return OrderStatus.awaitingPayment;
      case pb.OrderState.ORDER_STATE_PAID:
      case pb.OrderState.ORDER_STATE_CONFIRMED:
      case pb.OrderState.ORDER_STATE_IN_PROCESS:
        return OrderStatus.paid;
      case pb.OrderState.ORDER_STATE_IN_DELIVERY:
        return OrderStatus.inDelivery;
      case pb.OrderState.ORDER_STATE_DONE:
      case pb.OrderState.ORDER_STATE_IN_COMPLETED:
        return OrderStatus.arrived;
      case pb.OrderState.ORDER_STATE_FAILED:
        return OrderStatus.failed;
      default:
        return OrderStatus.unspecified;
    }
  }
}
