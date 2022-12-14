import 'package:dropezy_proto/google/protobuf/timestamp.pb.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

import '../order/order_models.dart';

final mockGoPayPaymentResults = orderAwaitingPayment.copyWith(
  paymentInformation: const PaymentInformationModel(deeplink: 'gogek://app'),
  paymentMethod: PaymentMethod.PAYMENT_METHOD_GOPAY,
);

final mockBcaPaymentResults = orderAwaitingPayment.copyWith(
  paymentInformation: const PaymentInformationModel(
    vaNumber: 'ABCDEFGH',
    bankName: 'bca',
  ),
  paymentMethod: PaymentMethod.PAYMENT_METHOD_VA_BCA,
);

final mockGoPayPaymentInformation = PaymentInformation(
  paymentMethod: PaymentMethod.PAYMENT_METHOD_GOPAY,
  paymentExpiryTime: Timestamp.fromDateTime(DateTime.now()),
  gopayPaymentInfo: GopayPaymentInfo(
    deeplink: 'dropezy://storefront/order/finish',
  ),
);

final mockVAPaymentInformation = PaymentInformation(
  paymentMethod: PaymentMethod.PAYMENT_METHOD_VA_BCA,
  paymentExpiryTime: Timestamp.fromDateTime(DateTime.now()),
  vaPaymentInfo: VAPaymentInfo(
    vaNumber: 'abcdefgh',
    bankName: 'bca',
  ),
);
