part of 'cart_model.dart';

/// Representation of an item inside a
/// customer's shopping cart
class CartItemModel extends Equatable {
  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  /// The product variant information
  final ProductModel product;

  /// The quantity of [product] inside this cart
  final int quantity;

  @override
  List<Object?> get props => [product, quantity];
}
