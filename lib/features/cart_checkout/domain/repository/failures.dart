import 'package:dropezy_proto/v1/order/order.pbenum.dart';
import 'package:storefront_app/core/core.dart';

/// Base for cart checkout errors
class CheckoutFailure extends Failure {
  CheckoutFailure(String message) : super(message);
}

// When available payment methods response is empty
class NoPaymentMethods extends CheckoutFailure {
  NoPaymentMethods() : super('No payment method found');
}

// When checkout payment method isn't configured for the app
class PaymentMethodNotSupported extends CheckoutFailure {
  // The unsupported payment method
  final PaymentMethod paymentMethod;

  PaymentMethodNotSupported(this.paymentMethod)
      : super('${paymentMethod.name} is not supported');
}
