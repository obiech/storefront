import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/res/strings/base_strings.dart';

/// Base for cart checkout errors
class CheckoutFailure extends Failure {
  CheckoutFailure(String message) : super(message);
}

// When available payment methods response is empty
class NoPaymentMethods extends CheckoutFailure {
  NoPaymentMethods(BaseStrings strings)
      : super(strings.errors.cartCheckout.noPaymentMethods);
}

// When checkout payment method isn't configured for the app
class PaymentMethodNotSupported extends CheckoutFailure {
  PaymentMethodNotSupported(BaseStrings strings, PaymentMethod method)
      : super(
          strings.errors.cartCheckout.paymentMethodNotSupported(method.name),
        );
}

// When no store id is found
class NoStore extends CheckoutFailure {
  NoStore(BaseStrings strings)
      : super(strings.errors.cartCheckout.noStoreNearby);
}

// When no address id is found
class NoAddressFound extends CheckoutFailure {
  NoAddressFound(BaseStrings strings)
      : super(strings.errors.cartCheckout.noDeliveryAddressSelected);
}

// When backend cart has thrown exception
class CartExceptionOccurred extends CheckoutFailure {
  final String cartError;

  CartExceptionOccurred(this.cartError) : super(cartError);
}
