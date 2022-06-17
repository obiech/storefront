import 'checkout_utils.dart';

class LaunchGoPay {
  const LaunchGoPay();

  Future<void> call(String deepLink) =>
      CheckoutUtils.launchGoPayCheckoutLink(deepLink);
}
