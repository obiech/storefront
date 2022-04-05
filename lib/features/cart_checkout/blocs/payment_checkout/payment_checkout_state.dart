part of 'payment_checkout_cubit.dart';

abstract class PaymentCheckoutState extends Equatable {
  const PaymentCheckoutState();

  @override
  List<Object> get props => [];
}

/// Default Payment checkout state
class InitialPaymentCheckoutState extends PaymentCheckoutState {}

/// When [PaymentCheckout] end-point is being queried
class LoadingPaymentCheckout extends PaymentCheckoutState {}

/// When [PaymentCheckout] link has been returned
class LoadedPaymentCheckout extends PaymentCheckoutState {
  /// Checkout link to open in browser or deeplink
  ///TODO: Handle other payment non-deeplink options in the future
  final String checkoutLink;

  const LoadedPaymentCheckout(this.checkoutLink);

  @override
  List<Object> get props => [checkoutLink];
}

/// When an error has occurred when making [PaymentCheckout]
class ErrorLoadingPaymentCheckout extends PaymentCheckoutState {
  final String message;

  const ErrorLoadingPaymentCheckout(this.message);

  @override
  List<Object> get props => [message];
}
