import 'package:dropezy_proto/v1/product/product.pb.dart' as pb;
import 'package:equatable/equatable.dart';
import 'package:storefront_app/features/product/domain/models/market_status.dart';

/// Representation of a product sold in Dropezy.
///
/// TODO: add other information such as category
class ProductModel extends Equatable {
  const ProductModel({
    required this.productId,
    required this.sku,
    required this.name,
    required this.price,
    required this.thumbnailUrl,
    this.discount,
    required this.stock,
    this.marketStatus,

    /// Defaulting to active TODO(obella465) - Fix once product structure affirmed
    this.status = ProductStatus.ACTIVE,
  });

  /// Maps a [pb.Product] object into [ProductModel]
  factory ProductModel.fromPb(pb.Product product) {
    return ProductModel(
      productId: product.productId,
      sku: product.sku,
      name: product.name,
      price: product.price.num,
      thumbnailUrl: product.imagesUrls[0],
      // TODO (leovinsen): add mapping for Stock once it's available
      stock: 0,
    );
  }

  /// A unique identifier of a Product
  /// Stands for Stock Keeping Unit
  final String sku;

  final String productId;

  final String name;

  final int stock;
  final String price;
  final String? discount;

  final MarketStatus? marketStatus;

  final ProductStatus status;

  /// URL for product thumbnail image
  final String thumbnailUrl;

  @override
  List<Object?> get props => [sku, price];
}

/// https://dropezy.slack.com/archives/C038EPQGJLR/p1650423774792949?thread_ts=1650422527.075119&cid=C038EPQGJLR
enum ProductStatus {
  /// Product is currently available for purchase
  ACTIVE,

  /// Product is depleted but will be restocked soon
  OUT_OF_STOCK,

  /// Product is no-longer available for purchase
  DEACTIVATED
}
