import 'package:equatable/equatable.dart';

import '../../../product/domain/models/product_model.dart';

/// contains product information as represented by [ProductModel]
/// and the quantity purchased for this particular product
class OrderProductModel extends Equatable {
  const OrderProductModel({
    required this.product,
    required this.quantity,
    required this.total,
  });

  /// basic information of a product
  final ProductModel product;

  /// amount purchased for [product]
  final int quantity;

  /// total price of [product.price] * [quantity]
  final String total;

  @override
  List<Object?> get props => [product, quantity];
}
