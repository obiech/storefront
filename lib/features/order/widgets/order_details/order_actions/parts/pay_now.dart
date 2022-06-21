part of '../order_actions.dart';

/// Pay now
class PayNow {
  PayNow({
    required this.order,
    required this.context,
    this.launchGoPay = const LaunchGoPay(),
  }) : super() {
    switch (order.paymentMethod) {
      case PaymentMethod.PAYMENT_METHOD_GOPAY:
        launchGoPay(order.paymentInformation.deeplink ?? '');
        break;
      case PaymentMethod.PAYMENT_METHOD_VA_BCA:
        context.pushRoute(
          PaymentInstructionsRoute(order: order),
        );
        break;
      default:
        // TODO(obella): Message for unspecified payment method
        break;
    }
  }

  final OrderModel order;

  final BuildContext context;

  // Gojek link launcher
  final LaunchGoPay launchGoPay;
}
