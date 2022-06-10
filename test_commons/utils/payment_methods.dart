import 'package:dropezy_proto/v1/order/order.pb.dart';

/// Loads sample payment methods for tests
///
/// From fixtures
List<PaymentChannel> get samplePaymentMethods => [
      PaymentChannel(
        paymentMethod: PaymentMethod.PAYMENT_METHOD_GOPAY,
        paymentType: PaymentMethodType.PAYMENT_METHOD_TYPE_DEEPLINK,
        status: PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE,
      ),
      PaymentChannel(
        paymentMethod: PaymentMethod.PAYMENT_METHOD_VA_BCA,
        paymentType: PaymentMethodType.PAYMENT_METHOD_TYPE_BANK_TRANSFER,
        status: PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE,
      )
    ];
