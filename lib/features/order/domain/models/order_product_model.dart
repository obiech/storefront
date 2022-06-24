import 'package:dropezy_proto/v1/order/order.pb.dart' as pb;
import 'package:equatable/equatable.dart';
import 'package:storefront_app/core/core.dart';

import '../../../product/domain/models/product_model.dart';

/// Representation of a Product Variant that has been purchased by a customer
/// in one of their transactions.
///
/// Similar to [ProductModel] but the key differences are:
/// - having [quantity] instead of stock
/// - no information such as best seller, flash sale
///
/// For representation of a product available in Search Results,
/// see [ProductModel].
class OrderProductModel extends Equatable {
  const OrderProductModel({
    required this.productId,
    required this.productName,
    required this.thumbnailUrl,
    required this.price,
    this.discount,
    required this.finalPrice,
    required this.quantity,
    required this.grandTotal,
  });

  /// Maps a [pb.Item] into [OrderProductModel]
  factory OrderProductModel.fromPb(pb.Item item) {
    return OrderProductModel(
      productId: item.product.variantId,
      productName: item.product.name,
      thumbnailUrl: item.product.imagesUrls.isEmpty
          ? ''
          : item.product.imagesUrls[0].toImageUrl,
      quantity: item.quantity,
      price: item.product.price.num,
      discount: '000',
      // TODO (Jonathan): change the discount, final, and total
      finalPrice: item.subTotal,
      grandTotal: item.grandTotal,
    );
  }

  /// ID of the Product Variant in Dropezy database.
  final String productId;

  /// name of the Product Variant in Dropezy database.
  final String productName;

  /// URL to product's thumbnail
  final String thumbnailUrl;

  /// price of the Product Variant in Dropezy database.
  final String price;

  /// discount applied during time of purchase
  final String? discount;

  /// price after [discount] is applied
  final String finalPrice;

  /// amount purchased
  final int quantity;

  /// result of [finalPrice] * [quantity]
  final String grandTotal;

  @override
  List<Object?> get props => [productId, quantity, grandTotal];
}

extension OrderProductModelX on pb.Item {
  String get subTotal {
    // TODO (Jonathan) : Subtract with discount when its available

    return (int.tryParse(product.price.num) ?? 0).toString();
  }

  String get grandTotal {
    return (quantity * (int.tryParse(subTotal) ?? 0)).toString();
  }
}
