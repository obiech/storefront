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
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '15000',
    thumbnailUrl:
        'https://d1d8o7q9jg8pjk.cloudfront.net/p/md_5d29587da3a66.jpg',
  );

  static const productCookingOilSania = ProductModel(
    sku: 'cooking-oil-sania-sku',
    name: 'Minyak Goreng Sania 2L',
    price: '70000',
    thumbnailUrl:
        'https://dn56y54v4g6fs.cloudfront.net/product/22_03_2021_02_11_19_sania_2_liter.jpg',
  );

  static const productBellPepperYellow = ProductModel(
    sku: 'paprika-kuning-sku',
    name: 'Paprika Kuning',
    price: '10000',
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
        paymentExpiryTime: DateTime.now().add(const Duration(hours: 1)),
      ),
      OrderModel(
        id: '2',
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
            product: productCookingOilSania,
            quantity: 4,
          ),
          OrderProductModel(
            product: productCookingOilSania,
            quantity: 5,
          ),
        ],
        estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 22)),
      ),
      OrderModel(
        id: '3',
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
        estimatedArrivalTime: DateTime.now().add(const Duration(minutes: 10)),
      ),
      OrderModel(
        id: '4',
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
