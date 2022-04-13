import 'package:injectable/injectable.dart';

import '../../../product/domain/models/product_model.dart';
import '../models/order_model.dart';
import '../models/order_product_model.dart';
import '../repository/i_order_repository.dart';

/// Dummy [IOrderRepository].
///
/// Returns data for development purposes, hardcoded in class definition.
/// WARNING: DO NOT use in production!
@LazySingleton(as: IOrderRepository)
class DummyOrderRepository extends IOrderRepository {
  /// Dummy Products
  static const productSeladaRomaine = ProductModel(
    productId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '15000',
    stock: 2,
    thumbnailUrl:
        'https://d1d8o7q9jg8pjk.cloudfront.net/p/md_5d29587da3a66.jpg',
  );

  static const productCookingOilSania = ProductModel(
    productId: 'cooking-oil-sania-id',
    sku: 'cooking-oil-sania-sku',
    name: 'Minyak Goreng Sania 2L',
    price: '70000',
    stock: 2,
    thumbnailUrl:
        'https://dn56y54v4g6fs.cloudfront.net/product/22_03_2021_02_11_19_sania_2_liter.jpg',
  );

  static const productBellPepperYellow = ProductModel(
    productId: 'paprika-kuning-id',
    sku: 'paprika-kuning-sku',
    name: 'Paprika Kuning',
    price: '10000',
    stock: 2,
    thumbnailUrl:
        'https://qph.fs.quoracdn.net/main-qimg-1324af1d727feb089eabfb9b3e74e8ca-lq',
  );

  @override
  Future<List<OrderModel>> getUserOrders() async {
    return [
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
            product: productSeladaRomaine,
            quantity: 3,
            total: (int.parse(productSeladaRomaine.price) * 3).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
        ],
        paymentExpiryTime: DateTime.now().add(const Duration(hours: 1)),
      ),
      OrderModel(
        id: '2',
        status: OrderStatus.paid,
        orderDate: DateTime.now(),
        deliveryFee: '1500000',
        discount: '1000000',
        subTotal: '15000000',
        total: '16500000',
        productsBought: [
          OrderProductModel(
            product: productBellPepperYellow,
            quantity: 3,
            total: (int.parse(productBellPepperYellow.price) * 3).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
          OrderProductModel(
            product: productSeladaRomaine,
            quantity: 3,
            total: (int.parse(productSeladaRomaine.price) * 3).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 4,
            total: (int.parse(productCookingOilSania.price) * 4).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 5,
            total: (int.parse(productCookingOilSania.price) * 5).toString(),
          ),
        ],
        estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 22)),
      ),
      OrderModel(
        id: '3',
        status: OrderStatus.inDelivery,
        orderDate: DateTime.now(),
        deliveryFee: '1500000',
        discount: '0',
        subTotal: '15000000',
        total: '16500000',
        productsBought: [
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
          OrderProductModel(
            product: productSeladaRomaine,
            quantity: 3,
            total: (int.parse(productSeladaRomaine.price) * 3).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
        ],
        estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 10)),
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
            product: productSeladaRomaine,
            quantity: 3,
            total: (int.parse(productSeladaRomaine.price) * 3).toString(),
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 1,
            total: (int.parse(productCookingOilSania.price) * 1).toString(),
          ),
        ],
        orderCompletionTime: DateTime.now().subtract(
          const Duration(
            days: 1,
            hours: 2,
          ),
        ),
      ),
    ];
  }
}
