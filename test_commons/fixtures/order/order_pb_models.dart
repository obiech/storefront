import 'package:dropezy_proto/google/protobuf/timestamp.pb.dart';
import 'package:dropezy_proto/meta/meta.pb.dart' hide Timestamp;
import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:dropezy_proto/v1/payment/payment.pb.dart';

final orderCreated = Order(
  orderId: 'order-id-1',
  storeId: 'store-id-1',
  state: OrderState.ORDER_STATE_CREATED,
  orderDate: Timestamp.fromDateTime(DateTime.now()),
  paymentSummary: PaymentSummary(
    subtotal: Amount(
      num: '12000000',
      cur: Currency.CURRENCY_IDR,
    ),
    deliveryFee: Amount(
      num: '1500000',
      cur: Currency.CURRENCY_IDR,
    ),
    discount: Amount(
      num: '1000000',
      cur: Currency.CURRENCY_IDR,
    ),
    total: Amount(
      num: '12500000',
      cur: Currency.CURRENCY_IDR,
    ),
  ),
  paymentExpiryTime: Timestamp.fromDateTime(
    DateTime.now().add(const Duration(minutes: 15)),
  ),
);

final orderPaid = Order(
  orderId: 'order-id-2',
  storeId: 'store-id-2',
  state: OrderState.ORDER_STATE_PAID,
  orderDate: Timestamp.fromDateTime(DateTime.now()),
  paymentSummary: PaymentSummary(
    subtotal: Amount(
      num: '12000000',
      cur: Currency.CURRENCY_IDR,
    ),
    deliveryFee: Amount(
      num: '1500000',
      cur: Currency.CURRENCY_IDR,
    ),
    discount: Amount(
      num: '1000000',
      cur: Currency.CURRENCY_IDR,
    ),
    total: Amount(
      num: '12500000',
      cur: Currency.CURRENCY_IDR,
    ),
  ),
  estimatedDeliveryTime: Timestamp.fromDateTime(
    DateTime.now().add(const Duration(minutes: 15)),
  ),
);

final orderDone = Order(
  orderId: 'order-id-3',
  storeId: 'store-id-3',
  state: OrderState.ORDER_STATE_DONE,
  orderDate: Timestamp.fromDateTime(DateTime.now()),
  paymentSummary: PaymentSummary(
    subtotal: Amount(
      num: '12000000',
      cur: Currency.CURRENCY_IDR,
    ),
    deliveryFee: Amount(
      num: '1500000',
      cur: Currency.CURRENCY_IDR,
    ),
    discount: Amount(
      num: '1000000',
      cur: Currency.CURRENCY_IDR,
    ),
    total: Amount(
      num: '12500000',
      cur: Currency.CURRENCY_IDR,
    ),
  ),
);
