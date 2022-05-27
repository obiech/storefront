import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../di/di_environment.dart';
import '../../../address/index.dart';
import '../../../product/domain/domain.dart';
import '../domains.dart';

/// Dummy [IOrderRepository].
///
/// Returns data for development purposes, hardcoded in class definition.
/// WARNING: DO NOT use in production!
@LazySingleton(as: IOrderRepository, env: [DiEnvironment.dummy])
class DummyOrderRepository extends IOrderRepository {
  /// Dummy Products
  static const productSeladaRomaine = ProductModel(
    productId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '1500000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://d1d8o7q9jg8pjk.cloudfront.net/p/md_5d29587da3a66.jpg',
    imagesUrls: [
      'https://d1d8o7q9jg8pjk.cloudfront.net/p/md_5d29587da3a66.jpg'
    ],
  );

  static const productCookingOilSania = ProductModel(
    productId: 'cooking-oil-sania-id',
    sku: 'cooking-oil-sania-sku',
    name: 'Minyak Goreng Sania 2L',
    price: '7000000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://dn56y54v4g6fs.cloudfront.net/product/22_03_2021_02_11_19_sania_2_liter.jpg',
    imagesUrls: [
      'https://dn56y54v4g6fs.cloudfront.net/product/22_03_2021_02_11_19_sania_2_liter.jpg'
    ],
  );

  static const productBellPepperYellow = ProductModel(
    productId: 'paprika-kuning-id',
    sku: 'paprika-kuning-sku',
    name: 'Paprika Kuning',
    price: '1000000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://qph.fs.quoracdn.net/main-qimg-1324af1d727feb089eabfb9b3e74e8ca-lq',
    imagesUrls: [
      'https://qph.fs.quoracdn.net/main-qimg-1324af1d727feb089eabfb9b3e74e8ca-lq'
    ],
  );

  // Dummy Address
  final deliveryAddress = DeliveryAddressModel(
    id: 'delivery-address-1',
    title: 'Rumah',
    notes: 'Pagar Silver, paket taruh di depan pintu',
    isPrimaryAddress: true,
    lat: -6.175392,
    lng: 106.827153,
    recipientName: 'Susi Susanti',
    recipientPhoneNumber: '08123123123',
    dateCreated: DateTime(2022, 1, 20),
    details: const AddressDetailsModel(
      street: 'Jl. Monas',
      district: 'Gambir',
      subDistrict: 'Gambir',
      municipality: 'Jakarta Pusat',
      province: 'DKI Jakarta',
      country: 'Indonesia',
    ),
  );

  DummyOrderRepository() {
    orders = [
      OrderModel(
        id: '1',
        status: OrderStatus.awaitingPayment,
        orderDate: DateTime.now(),
        deliveryFee: '1500000',
        discount: '1000000',
        subTotal: '11500000',
        total: '10500000',
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
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
        ],
        paymentExpiryTime: DateTime.now().add(const Duration(hours: 1)),
        recipientAddress: deliveryAddress,
      ),
      OrderModel(
        id: '2',
        status: OrderStatus.paid,
        orderDate: DateTime.now(),
        paymentCompletedTime: DateTime.now().add(const Duration(minutes: 5)),
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
            grandTotal:
                (int.parse(productBellPepperYellow.price) * 3).toString(),
          ),
          OrderProductModel(
            productId: productCookingOilSania.id,
            productName: productCookingOilSania.name,
            thumbnailUrl: productCookingOilSania.thumbnailUrl,
            price: productCookingOilSania.price,
            finalPrice: productCookingOilSania.price,
            quantity: 1,
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
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
            grandTotal:
                (int.parse(productCookingOilSania.price) * 4).toString(),
          ),
          OrderProductModel(
            productId: productCookingOilSania.id,
            productName: productCookingOilSania.name,
            thumbnailUrl: productCookingOilSania.thumbnailUrl,
            price: productCookingOilSania.price,
            finalPrice: productCookingOilSania.price,
            quantity: 5,
            grandTotal:
                (int.parse(productCookingOilSania.price) * 5).toString(),
          ),
        ],
        estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 22)),
        recipientAddress: deliveryAddress,
      ),
      OrderModel(
        id: '3',
        status: OrderStatus.inDelivery,
        orderDate: DateTime.now(),
        paymentCompletedTime: DateTime.now().add(const Duration(minutes: 5)),
        pickupTime: DateTime.now().add(const Duration(minutes: 10)),
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
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
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
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
          OrderProductModel(
            productId: productCookingOilSania.id,
            productName: productCookingOilSania.name,
            thumbnailUrl: productCookingOilSania.thumbnailUrl,
            price: productCookingOilSania.price,
            finalPrice: productCookingOilSania.price,
            quantity: 1,
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
          OrderProductModel(
            productId: productCookingOilSania.id,
            productName: productCookingOilSania.name,
            thumbnailUrl: productCookingOilSania.thumbnailUrl,
            price: productCookingOilSania.price,
            finalPrice: productCookingOilSania.price,
            quantity: 1,
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
        ],
        estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 10)),
        driver: OrderDriverModel(
          fullName: 'Andi Hardiawan',
          vehicleLicenseNumber: 'B 1234 EZY',
          whatsappNumber: '+628123123123',
          imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        ),
        recipientAddress: deliveryAddress,
      ),
      OrderModel(
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
            grandTotal:
                (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
        ],
        paymentCompletedTime: DateTime.now().add(const Duration(minutes: 5)),
        pickupTime: DateTime.now().add(const Duration(minutes: 10)),
        orderCompletionTime: DateTime.now().subtract(
          const Duration(
            days: 1,
            hours: 2,
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
        recipientAddress: deliveryAddress,
      ),
    ];
  }

  late List<OrderModel> orders;

  @override
  RepoResult<List<OrderModel>> getUserOrders() async {
    return right(orders);
  }

  @override
  RepoResult<OrderModel> getOrderById(String id) async {
    final index = orders.indexWhere((o) => o.id == id);

    if (index > -1) {
      return right(orders[index]);
    }

    return left(ResourceNotFoundFailure('Order not found.'));
  }
}
