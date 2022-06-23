abstract class CartCheckoutErrors {
  /// Checkout
  String get noStoreNearby;

  String get noDeliveryAddressSelected;

  String get errorCheckingOut;

  /// Payment methods
  String get noPaymentMethods;

  String paymentMethodNotSupported(String method);
}
