import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';

import 'payment_method.dart';

/// [PaymentChannel] extension
extension PaymentChannelX on PaymentChannel {
  /// converts [PaymentChannel] into [PaymentMethodDetails]
  PaymentMethodDetails paymentInfo() {
    switch (paymentMethod) {
      case PaymentMethod.PAYMENT_METHOD_GOPAY:
        return PaymentMethodDetails(
          title: 'Go Pay',
          image: 'assets/icons/providers/go_pay.png',
          method: paymentMethod,
        );
      default:
        return PaymentMethodDetails(
          title: 'Unspecified',

          /// TODO - Image for unspecified payment methods
          image: 'assets/icons/providers/go_pay.png',
          method: paymentMethod,
        );
    }
  }
}

/// [PaymentChannel] List extension
extension PaymentChannelsX on List<PaymentChannel> {
  /// Convert [PaymentChannel]s to [PaymentMethodDetails]
  List<PaymentMethodDetails> toPaymentDetails() {
    return map((channel) => channel.paymentInfo()).toList();
  }
}
