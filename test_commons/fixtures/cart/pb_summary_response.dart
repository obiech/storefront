import 'package:dropezy_proto/meta/meta.pb.dart';
import 'package:dropezy_proto/v1/cart/cart.pb.dart';
import 'package:dropezy_proto/v1/payment/payment.pb.dart';

final mockSummary = SummaryResponse(
  cart: Cart(
    id: 'cart-id-1',
    state: CartState.CART_STATE_OPEN,
    items: [],
    storeId: 'store-id-1',
  ),
  paymentSummary: PaymentSummary(
    subtotal: Amount(
      num: '10000000',
      cur: Currency.CURRENCY_IDR,
    ),
    total: Amount(
      num: '11500000',
      cur: Currency.CURRENCY_IDR,
    ),
    deliveryFee: Amount(
      num: '1500000',
      cur: Currency.CURRENCY_IDR,
    ),
  ),
);
