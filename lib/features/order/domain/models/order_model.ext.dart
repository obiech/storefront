import 'package:storefront_app/features/order/domain/domains.dart';

import '../../../address/index.dart';

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
    );
  }
}
