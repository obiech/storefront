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
      total: '45000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
      total: '70000',
    ),
  ],
  paymentExpiryTime: DateTime.now().add(
    const Duration(
      hours: 1,
      minutes: 23,
      seconds: 15,
    ),
  ),
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
      total: '30000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
      total: '70000',
    ),
    OrderProductModel(
      product: productSeladaRomaine,
      quantity: 3,
      total: '45000',
    ),
    OrderProductModel(
      product: productBellPepperYellow,
      quantity: 4,
      total: '40000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 5,
      total: '350000',
    ),
  ],
  estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 22)),
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
      total: '70000',
    ),
    OrderProductModel(
      product: productSeladaRomaine,
      quantity: 3,
      total: '45000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
      total: '70000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
      total: '70000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
      total: '70000',
    ),
  ],
  estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 10)),
  driver: OrderDriverModel(
    fullName: 'Andi Hardiawan',
    vehicleLicenseNumber: 'B 1234 EZY',
    whatsappNumber: '+628123123123',
    imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
  ),
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
      total: '45000',
    ),
    OrderProductModel(
      product: productCookingOilSania,
      quantity: 1,
      total: '70000',
    ),
  ],
  orderCompletionTime: DateTime.now().subtract(
    const Duration(
      days: 1,
      hours: 1,
      minutes: 10,
    ),
  ),
  driver: OrderDriverModel(
    fullName: 'Indra',
    vehicleLicenseNumber: 'B 9999 EZY',
    whatsappNumber: '+628123123123',
    imageUrl: 'https://randomuser.me/api/portraits/men/29.jpg',
  ),
  recipient: OrderRecipientModel(
    fullName: 'Indah Kartika',
    relationToCustomer: 'Customer',
    imageUrl: 'https://randomuser.me/api/portraits/women/51.jpg',
  ),
);
