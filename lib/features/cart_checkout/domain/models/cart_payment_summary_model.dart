part of 'cart_model.dart';

/// Representation of payment summary for each cart
class CartPaymentSummaryModel extends Equatable {
  const CartPaymentSummaryModel({
    required this.deliveryFee,
    required this.discount,
    required this.subTotal,
    required this.total,
    this.isFreeDelivery = false,
  });

  factory CartPaymentSummaryModel.fromPB(final PaymentSummary summary) {
    return CartPaymentSummaryModel(
      deliveryFee: summary.deliveryFee.num,
      discount: summary.discount.num,
      subTotal: summary.subtotal.num,
      total: summary.total.num,
    );
  }

  /// Total delivery fee for current cart
  final String deliveryFee;

  /// Total discount for current cart
  final String discount;

  /// Amount before [discount] and [deliveryFee]
  final String subTotal;

  /// [subTotal] minus [discount] and [deliveryFee]
  final String total;

  /// Whether or not delivery fee is free for current cart
  final bool isFreeDelivery;

  @override
  List<Object?> get props {
    return [total, subTotal, discount, deliveryFee, isFreeDelivery];
  }
}
