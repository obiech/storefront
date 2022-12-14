import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/domain/domains.dart';

import '../address/delivery_address_models.dart';
import '../checkout/payment_results.dart';
import '../product/product_models.dart';

final paymentInfo =
    PaymentInformationModel.fromPaymentInfo(mockGoPayPaymentInformation);
final paymentMethod = mockGoPayPaymentInformation.paymentMethod;

final orderAwaitingPayment = OrderModel(
  id: 'order-awaiting-payment',
  status: OrderStatus.awaitingPayment,
  orderDate: DateTime.now(),
  deliveryFee: '15000',
  discount: '10000',
  subTotal: '98500',
  total: '103500',
  productsBought: [
    OrderProductModel(
      productId: productSeladaRomaine.id,
      productName: productSeladaRomaine.name,
      thumbnailUrl: productSeladaRomaine.thumbnailUrl,
      price: productSeladaRomaine.price,
      finalPrice: productSeladaRomaine.price,
      quantity: 3,
      grandTotal: '45000',
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: '70000',
    ),
  ],
  paymentExpiryTime: DateTime.now().add(
    const Duration(
      hours: 1,
      minutes: 23,
      seconds: 15,
    ),
  ),
  recipientAddress: sampleDeliveryAddressList[0],
  paymentInformation: paymentInfo,
  paymentMethod: paymentMethod,
);

final orderPaid = OrderModel(
  id: '2',
  status: OrderStatus.paid,
  orderDate: DateTime.now(),
  deliveryFee: '1500000',
  discount: '1000000',
  subTotal: '15000000',
  total: '16500000',
  productsBought: [
    OrderProductModel(
      productId: productBellPepperYellow.id,
      productName: productBellPepperYellow.name,
      thumbnailUrl: productBellPepperYellow.thumbnailUrl,
      price: productBellPepperYellow.price,
      finalPrice: productBellPepperYellow.price,
      quantity: 3,
      grandTotal: (int.parse(productBellPepperYellow.price) * 3).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: (int.parse(productCookingOilSania.price) * 1).toString(),
    ),
    OrderProductModel(
      productId: productSeladaRomaine.id,
      productName: productSeladaRomaine.name,
      thumbnailUrl: productSeladaRomaine.thumbnailUrl,
      price: productSeladaRomaine.price,
      finalPrice: productSeladaRomaine.price,
      quantity: 3,
      grandTotal: (int.parse(productSeladaRomaine.price) * 3).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 4,
      grandTotal: (int.parse(productCookingOilSania.price) * 4).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 5,
      grandTotal: (int.parse(productCookingOilSania.price) * 5).toString(),
    ),
  ],
  estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 22)),
  paymentExpiryTime: DateTime.now().add(const Duration(minutes: 10)),
  recipientAddress: sampleDeliveryAddressList[0],
  paymentInformation: paymentInfo,
  paymentMethod: paymentMethod,
);

final orderInDelivery = OrderModel(
  id: '3',
  status: OrderStatus.inDelivery,
  orderDate: DateTime.now(),
  deliveryFee: '1500000',
  discount: '0',
  subTotal: '15000000',
  total: '16500000',
  productsBought: [
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: (int.parse(productCookingOilSania.price) * 1).toString(),
    ),
    OrderProductModel(
      productId: productSeladaRomaine.id,
      productName: productSeladaRomaine.name,
      thumbnailUrl: productSeladaRomaine.thumbnailUrl,
      price: productSeladaRomaine.price,
      finalPrice: productSeladaRomaine.price,
      quantity: 3,
      grandTotal: (int.parse(productSeladaRomaine.price) * 3).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: (int.parse(productCookingOilSania.price) * 1).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: (int.parse(productCookingOilSania.price) * 1).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: (int.parse(productCookingOilSania.price) * 1).toString(),
    ),
  ],
  estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 10)),
  paymentExpiryTime: DateTime.now().add(const Duration(minutes: 5)),
  driver: OrderDriverModel(
    fullName: 'Andi Hardiawan',
    vehicleLicenseNumber: 'B 1234 EZY',
    whatsappNumber: '+628123123123',
    imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
  ),
  recipientAddress: sampleDeliveryAddressList[0],
  paymentInformation: paymentInfo,
  paymentMethod: paymentMethod,
);

final orderArrived = OrderModel(
  id: '4',
  status: OrderStatus.arrived,
  orderDate: DateTime.now(),
  deliveryFee: '1500000',
  discount: '1000000',
  subTotal: '10500000',
  total: '11000000',
  productsBought: [
    OrderProductModel(
      productId: productSeladaRomaine.id,
      productName: productSeladaRomaine.name,
      thumbnailUrl: productSeladaRomaine.thumbnailUrl,
      price: productSeladaRomaine.price,
      finalPrice: productSeladaRomaine.price,
      quantity: 3,
      grandTotal: (int.parse(productSeladaRomaine.price) * 3).toString(),
    ),
    OrderProductModel(
      productId: productCookingOilSania.id,
      productName: productCookingOilSania.name,
      thumbnailUrl: productCookingOilSania.thumbnailUrl,
      price: productCookingOilSania.price,
      finalPrice: productCookingOilSania.price,
      quantity: 1,
      grandTotal: (int.parse(productCookingOilSania.price) * 1).toString(),
    ),
  ],
  orderCompletionTime: DateTime.now().subtract(
    const Duration(
      days: 1,
      hours: 2,
    ),
  ),
  paymentExpiryTime: DateTime.now().subtract(
    const Duration(days: 1),
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
  recipientAddress: sampleDeliveryAddressList[0],
  paymentInformation: paymentInfo,
  paymentMethod: paymentMethod,
);

final refreshOrderList = [orderPaid, orderAwaitingPayment, orderInDelivery];

final notRefreshOrderList = [
  orderArrived,
  orderArrived.copyWith(status: OrderStatus.failed),
  orderArrived.copyWith(status: OrderStatus.unspecified)
];
