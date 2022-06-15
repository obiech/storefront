import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';

import 'payment_method.dart';
import 'payment_method.ext.dart';

/// [PaymentChannel] extension
extension PaymentChannelX on PaymentChannel {
  /// converts [PaymentChannel] into [PaymentMethodDetails]
  PaymentMethodDetails get paymentInfo => paymentMethod.paymentInfo;
}

/// [PaymentChannel] List extension
extension PaymentChannelsX on List<PaymentChannel> {
  /// Convert [PaymentChannel]s to [PaymentMethodDetails]
  List<PaymentMethodDetails> toPaymentDetails() {
    return map((channel) => channel.paymentInfo).toList();
  }
}

/// Comparator for active [PaymentChannel]
bool channelIsActive(PaymentChannel paymentChannel) =>
    paymentChannel.status == PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE;
