import 'package:dropezy_proto/v1/order/order.pb.dart' as pb;
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

  /// Maps a [pb.Item] into [OrderProductModel]
  ///
  /// If you do not need the quantity purchased,
  /// see [ProductModel.fromPb]
  factory OrderProductModel.fromPb(pb.Item item) {
    return OrderProductModel(
      product: ProductModel.fromPb(item.product),
      quantity: item.quantity,
      // TODO (leovinsen): total should come from backend
      total: (item.quantity * int.parse(item.product.price.num)).toString(),
    );
  }

  /// basic information of a product
  final ProductModel product;

  /// amount purchased for [product]
  final int quantity;

  /// total price of [product.price] * [quantity]
  final String total;

  @override
  List<Object?> get props => [product, quantity];
}
