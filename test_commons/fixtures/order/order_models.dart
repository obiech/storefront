import 'package:storefront_app/features/order/domain/domains.dart';

import '../product/product_models.dart';

final orderAwaitingPayment = OrderModel(
  id: 'order-awaiting-payment',
  status: OrderStatus.awaitingPayment,
  orderDate: DateTime.now(),
  deliveryFee: '15000',
  discount: '10000',
  subTotal: '98500',
  total: '103500',
  productsBought: const [
    OrderProductModel(
      product: productSeladaRomaine,
      quantity: 3,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
  ],
);

final orderPaid = OrderModel(
  id: 'order-paid',
  status: OrderStatus.paid,
  orderDate: DateTime.now(),
  deliveryFee: '15000',
  discount: '0',
  subTotal: '150000',
  total: '165000',
  productsBought: const [
    OrderProductModel(
      product: productBellPepperYellow,
      quantity: 3,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
    OrderProductModel(
      product: productSeladaRomaine,
      quantity: 3,
    ),
    OrderProductModel(
      product: productBellPepperYellow,
      quantity: 4,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 5,
    ),
  ],
);

final orderInDelivery = OrderModel(
  id: 'order-in-delivery',
  status: OrderStatus.inDelivery,
  orderDate: DateTime.now(),
  deliveryFee: '15000',
  discount: '0',
  subTotal: '150000',
  total: '165000',
  productsBought: const [
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
    OrderProductModel(
      product: productSeladaRomaine,
      quantity: 3,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
  ],
);

final orderArrived = OrderModel(
  id: 'order-arrived',
  status: OrderStatus.arrived,
  orderDate: DateTime.now(),
  deliveryFee: '15000',
  discount: '10000',
  subTotal: '105000',
  total: '110000',
  productsBought: const [
    OrderProductModel(
      product: productSeladaRomaine,
      quantity: 3,
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
    ),
  ],
);
