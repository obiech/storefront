part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Loads user's cart at Dark Store identified [storeId].
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

/// When user changes an item's quantity.
class EditCartItem extends CartEvent {
  const EditCartItem(
    this.variant,
    this.quantity,
  );

  /// Product variant whose quantity is being edited
  final VariantModel variant;

  /// The new quantity
  final int quantity;

  @override
  List<Object?> get props => [variant, quantity];
}

/// When user removes an item from the cart
/// i.e. by tapping on 'Delete' button in Cart page
class RemoveCartItem extends CartEvent {
  const RemoveCartItem(this.variant);

  /// Product variant being deleted
  final VariantModel variant;

  @override
  List<Object?> get props => [variant];
}
