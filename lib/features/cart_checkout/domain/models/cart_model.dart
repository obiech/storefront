import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:dropezy_proto/v1/payment/payment.pb.dart';
import 'package:equatable/equatable.dart';

import '../../../product/domain/domain.dart';

part 'cart_item_model.dart';
part 'cart_model.g.dart';
part 'cart_payment_summary_model.dart';

/// Representation of a customer's shopping cart.
@CopyWith()
class CartModel extends Equatable {
  const CartModel({
    required this.id,
    required this.items,
    required this.paymentSummary,
  });

  /// Use when cart is empty.
  ///
  /// Possible scenarios:
  /// - Cart object is not found. For example, first-time users
  /// and switching between stores.
  /// - Cart is empty after deleting all products.
  factory CartModel.empty() {
    return CartModel(
      id: '',
      items: const [],
      paymentSummary: CartPaymentSummaryModel.empty(),
    );
  }

  factory CartModel.fromPb(SummaryResponse summaryResponse) {
    return CartModel(
      id: summaryResponse.cart.id,
      items: summaryResponse.cart.items.map(CartItemModel.fromPb).toList(),
      paymentSummary: CartPaymentSummaryModel.fromPB(
        summaryResponse.paymentSummary,
      ),
    );
  }

  /// The Cart ID retrieved from storefront-backend.
  final String id;

  /// Products that have been added into the cart
  /// by the customer.
  final List<CartItemModel> items;

  /// Payment summary of this cart. Contains information
  /// such as amount paid, discount, and delivery fee.
  final CartPaymentSummaryModel paymentSummary;

  @override
  List<Object?> get props => [id, items, paymentSummary];

  /// Check if current cart has any discount
  bool get hasDiscount => (int.tryParse(paymentSummary.discount) ?? 0) > 0;
}

extension CartModelX on CartModel {
  /// Returns the index of the first cart item in [items]
  /// that contains product with id of [productId].
  ///
  /// Returns -1 if a [CartItemModel] with [productId] is not found.
  int indexOfProduct(String productId) =>
      items.indexWhere((item) => item.variant.id == productId);

  /// Returns items in this cart that are in stock
  List<CartItemModel> get inStockItems =>
      items.where((item) => !item.variant.isOutOfStock).toList();

  /// Returns items in this cart that are out of stock
  List<CartItemModel> get outOfStockItems =>
      items.where((item) => item.variant.isOutOfStock).toList();

  /// Total product items in cart
  int productStockInCart(String productId) =>
      items.where((item) => item.variant.productId == productId).fold(
            0,
            (prev, cartItem) => prev + cartItem.quantity,
          );

  /// Returns [true] if cart is empty
  bool get isEmpty => items.isEmpty;
}
