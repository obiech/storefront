// [PaymentMethod] extension
import 'package:dropezy_proto/v1/order/order.pb.dart';

import '../../index.dart';

extension PaymentMethodX on PaymentMethod {
  /// converts [PaymentMethod] into [PaymentMethodDetails]

  PaymentMethodDetails get paymentInfo {
    switch (this) {
      case PaymentMethod.PAYMENT_METHOD_GOPAY:
        return PaymentMethodDetails(
          title: 'Go Pay',
          image: 'assets/icons/providers/go_pay.svg',
          method: this,
        );
      case PaymentMethod.PAYMENT_METHOD_VA_BCA:
        return PaymentMethodDetails(
          title: 'Bank BCA',
          image: 'assets/icons/providers/bca.svg',
          method: this,
        );
      default:
        return PaymentMethodDetails(
          title: 'Unspecified',

          /// TODO - Image for unspecified payment methods
          image: 'assets/icons/providers/go_pay.png',
          method: this,
        );
    }
  }
}
