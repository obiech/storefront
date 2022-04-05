part of 'payment_method_cubit.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object> get props => [];
}

/// Default Payment methods state
class InitialPaymentMethodState extends PaymentMethodState {}

/// When [PaymentMethod]s are being loaded
/// from cache or backend
class LoadingPaymentMethods extends PaymentMethodState {}

/// When [PaymentMethod]s have been
/// successfully loaded
class LoadedPaymentMethods extends PaymentMethodState {
  /// Currently active payment method
  final PaymentMethod activePaymentMethod;

  /// All supported payment methods
  final List<PaymentMethod> methods;

  const LoadedPaymentMethods(this.methods, this.activePaymentMethod);

  @override
  List<Object> get props => [methods, activePaymentMethod];
}

/// When an error has occurred while loading [PaymentMethod]s
class ErrorLoadingPaymentMethods extends PaymentMethodState {
  final String message;

  const ErrorLoadingPaymentMethods(this.message);

  @override
  List<Object> get props => [message];
}
