import 'package:dropezy_proto/google/protobuf/timestamp.pb.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

import '../order/order_pb_models.dart';

final mockGoPayPaymentResults = PaymentResultsModel(
  order: OrderModel.fromPb(orderCreated),
  paymentInformation: const PaymentInformationModel(deeplink: 'gogek://app'),
  paymentMethod: PaymentMethod.PAYMENT_METHOD_GOPAY,
  expiryTime: DateTime.now(),
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
