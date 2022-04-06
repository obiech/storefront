part of 'payment_method_cubit.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object> get props => [];
}

/// Default Payment methods state
class InitialPaymentMethodState extends PaymentMethodState {}

/// When [PaymentMethodDetails]s are being loaded
/// from cache or backend
class LoadingPaymentMethods extends PaymentMethodState {}

/// When [PaymentMethodDetails]s have been
/// successfully loaded
class LoadedPaymentMethods extends PaymentMethodState {
  /// Currently active payment method
  final PaymentMethodDetails activePaymentMethod;

  /// All supported payment methods
  final List<PaymentMethodDetails> methods;

  const LoadedPaymentMethods(this.methods, this.activePaymentMethod);

  @override
  List<Object> get props => [methods, activePaymentMethod];
}

/// When an error has occurred while loading [PaymentMethodDetails]s
class ErrorLoadingPaymentMethods extends PaymentMethodState {
  final String message;

  const ErrorLoadingPaymentMethods(this.message);

  @override
  List<Object> get props => [message];
}
