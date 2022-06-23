part of '../english_errors.dart';

class EnglishCartCheckoutErrors implements CartCheckoutErrors {
  @override
  String get noDeliveryAddressSelected => 'No delivery address selected';

  @override
  String get noStoreNearby => 'No Store nearby';

  @override
  String get noPaymentMethods => 'No payment methods';

  @override
  String paymentMethodNotSupported(String method) => '$method is not supported';

  @override
  String get errorCheckingOut => 'Error checking out';
}
