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

  /// Creates an empty [ProductModel] with
  /// loading status
  factory ProductModel.loading() {
    return const ProductModel(
      productId: '',
      sku: '',
      name: '',
      price: '',
      thumbnailUrl: '',
      stock: 0,
      status: ProductStatus.LOADING,
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
  List<Object?> get props => [sku, price, status];
}

/// https://dropezy.slack.com/archives/C038EPQGJLR/p1650423774792949?thread_ts=1650422527.075119&cid=C038EPQGJLR
enum ProductStatus {
  /// Product is currently available for purchase
  ACTIVE,

  /// Product is depleted but will be restocked soon
  OUT_OF_STOCK,

  /// Product is no-longer available for purchase
  DEACTIVATED,

  /// Placeholder status for loading
  LOADING
}

/// Product Extension methods
extension ProductX on ProductModel {
  bool get isOutOfStock => status == ProductStatus.OUT_OF_STOCK;

  /// Show stock left warning
  bool get isAlmostDepleted => !isOutOfStock && stock <= 3;
}
