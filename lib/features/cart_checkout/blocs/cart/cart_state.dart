part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state when [CartBloc] is first
/// instantiated.
class CartInitial extends CartState {
  const CartInitial();
}

/// When loading Cart data is from local or remote
/// data source for the first time.
class CartLoading extends CartState {
  const CartLoading();
}

/// When a failure occured during [CartLoading].
///
/// In such case, ask customer to retry the loading process.
class CartFailedToLoad extends CartState {
  const CartFailedToLoad();
}

/// The only state that will be used throughout the session,
/// once initial load is successful.
///
/// No discrete state for Failure, because ideally the cart
/// contents will be available even during a failure.
class CartLoaded extends CartState {
  const CartLoaded({
    required this.cart,
    required this.isCalculatingSummary,
    required this.errorMessage,
  });

  /// Represents state after a [CartEvent] is
  /// successfully processed.
  factory CartLoaded.success(CartModel cart) {
    return CartLoaded(
      cart: cart,
      isCalculatingSummary: false,
      errorMessage: null,
    );
  }

  /// Represents state when waiting for
  /// a [CartEvent] to be processed.
  factory CartLoaded.loading(CartModel cart) {
    return CartLoaded(
      cart: cart,
      isCalculatingSummary: true,
      errorMessage: null,
    );
  }

  /// Represents state after a [CartEvent]
  /// failed to process.
  factory CartLoaded.error(CartModel cart, String errorMessage) {
    return CartLoaded(
      cart: cart,
      isCalculatingSummary: false,
      errorMessage: errorMessage,
    );
  }

  final CartModel cart;

  /// [isCalculatingSummary] will be true during the following:
  ///
  /// - User is updating contents of the [cart] and is currently
  /// in buffer period before request is made to the backend.
  ///
  /// - Request is made to backend and now we are waiting for
  /// backend to respond with new cart summary.
  ///
  /// When true, widget that displays cart summary
  /// should display a loading effect.
  final bool isCalculatingSummary;

  /// Error message returned by backend in scenarios such as:
  ///
  /// - Purchased quantity exceeds stock available.
  /// - Purchased quantity exceeds maximum purchase per customer.
  /// - Product added to cart is out of stock.
  /// - Product added already exists in cart.
  /// - And other server errors
  ///
  /// Always set [errorMessage] to null whenever a new
  /// Event is added.
  final String? errorMessage;

  @override
  List<Object?> get props => [
        cart,
        isCalculatingSummary,
        errorMessage,
      ];
}
