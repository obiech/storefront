import 'checkout_utils.dart';

class LaunchGoPay {
  Future<void> call(String deepLink) =>
      CheckoutUtils.launchGoPayCheckoutLink(deepLink);
}
