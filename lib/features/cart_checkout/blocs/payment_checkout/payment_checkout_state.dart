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
  /// Payment Results with order & payment info
  final PaymentResultsModel paymentResults;

  const LoadedPaymentCheckout(this.paymentResults);

  @override
  List<Object> get props => [paymentResults];
}

/// When an error has occurred when making [PaymentCheckout]
class ErrorLoadingPaymentCheckout extends PaymentCheckoutState {
  final String message;

  const ErrorLoadingPaymentCheckout(this.message);

  @override
  List<Object> get props => [message];
}
