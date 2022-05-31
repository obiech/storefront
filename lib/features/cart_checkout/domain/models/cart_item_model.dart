part of 'cart_model.dart';

/// Representation of an item inside a
/// customer's shopping cart
class CartItemModel extends Equatable {
  const CartItemModel({
    required this.variant,
    required this.quantity,
  });

  /// The product variant information
  final VariantModel variant;

  /// The quantity of [variant] inside this cart
  final int quantity;

  factory CartItemModel.fromPb(Item item) {
    return CartItemModel(
      variant: VariantModel.fromPb(item.variant),
      quantity: item.quantity,
    );
  }

  @override
  List<Object?> get props => [variant, quantity];
}
