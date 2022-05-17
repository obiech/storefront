part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

/// When user adds a product variant into the cart
/// by tapping on 'Add To Cart' button.
class AddCartItem extends CartEvent {
  const AddCartItem(this.variant);

  /// Product variant being added to cart
  final VariantModel variant;

  @override
  List<Object?> get props => [variant];
}
