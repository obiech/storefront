import 'package:storefront_app/features/cart_checkout/domain/models/cart_model.dart';

import '../product/product_models.dart';

const mockCartModel = CartModel(
  id: 'cart-1',
  storeId: 'store-1',
  items: [
    CartItemModel(product: productSeladaRomaine, quantity: 1),
  ],
  paymentSummary: CartPaymentSummaryModel(
    deliveryFee: '1500000',
    discount: '0',
    subTotal: '1500000',
    total: '1500000',
  ),
);