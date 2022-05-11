import 'package:dropezy_proto/v1/inventory/inventory.pbgrpc.dart';
import 'package:equatable/equatable.dart';

import 'market_status.dart';
import 'variant_model.dart';

/// Representation of a product sold in Dropezy.
///
/// [ProductModel]s contain [VariantModel] that are
/// a smaller subset of the mail product.
///
/// Case in point is UHT Milk with variants as UHT Chocolate
/// flavored milk & UHT vanilla flavored milk, whose prices
/// may vary.
///
/// Variants can also be derived from varying units of the same product
/// e.g Olive oil with variants of 3 litre bottle & 5 litre bottle.
class ProductModel extends Equatable {
  const ProductModel({
    required this.productId,
    required this.name,
    required this.categoryOneId,
    required this.categoryTwoId,
    required this.variants,
    required this.sku,
    required this.stock,
    required this.price,
    required this.thumbnailUrl,

    // TODO(obella465): Fix once fields below are confirmed
    this.discount,
    this.marketStatus,
    required this.defaultProduct,

    /// Defaulting to active TODO(obella465) - Fix once product structure affirmed
    this.status = ProductStatus.ACTIVE,
  });

  /// Creates a [ProductModel] from gRPC [Product]
  factory ProductModel.fromPb(Product inventoryProduct) {
    final baseVariant = inventoryProduct.defaultVariant;

    return ProductModel(
      productId: inventoryProduct.productId,
      name: inventoryProduct.name,
      categoryOneId: inventoryProduct.category1Id,
      categoryTwoId: inventoryProduct.category2Id,
      variants: inventoryProduct.variants.map(VariantModel.fromPb).toList(),
      // TODO(obella465): Request backend to include default product that will
      // provide imageUrl, price & discount
      defaultProduct: baseVariant.variantId,
      stock: inventoryProduct.totalStock,
      sku: baseVariant.sku,
      price: baseVariant.price.num,
      thumbnailUrl: baseVariant.imagesUrls.first,
      status: inventoryProduct.totalStock < 1
          ? ProductStatus.OUT_OF_STOCK
          : ProductStatus.ACTIVE,
    );
  }

  /// Creates an empty [ProductModel] with
  /// loading status
  factory ProductModel.loading() {
    return const ProductModel(
      productId: '',
      name: '',
      categoryOneId: '',
      categoryTwoId: '',
      variants: [],
      defaultProduct: '',
      stock: 0,
      sku: '',
      price: '',
      thumbnailUrl: '',
      status: ProductStatus.LOADING,
    );
  }

  // Unique identifier of the product
  final String productId;

  // Derived fields from default variant
  final String sku;
  final int stock;
  final String price;
  final String? discount;

  final MarketStatus? marketStatus;

  final ProductStatus status;

  // Id of product's category 1
  final String categoryOneId;

  // Id of the product's category 2
  final String categoryTwoId;

  /// TODO(obella465): Retire once default flow confirmed
  /// @Iyo
  /// Hey Isaac, for the images it should be stored under variant I believe,
  /// and then there we have a default flag to determine which variant is
  /// a default variant that will be shown on the product cards.
  /// What about product status? I think its missing on your code snippet

  // Default product variant Id
  final String defaultProduct;

  // name is the name of the product.
  final String name;

  /// URL for product thumbnail image
  final String thumbnailUrl;

  /// List of product variants.
  ///
  /// variants can be derived from units or flavours
  /// of a product e.g Chocolate, Vanilla flavored milk
  final List<VariantModel> variants;

  @override
  List<Object?> get props => [
        productId,
        name,
        categoryOneId,
        categoryTwoId,
        variants,
        defaultProduct,
        discount,
        status,
        marketStatus,
      ];

  /// Create copy of object
  ProductModel copyWith({
    String? productId,
    String? name,
    String? categoryOneId,
    String? categoryTwoId,
    List<VariantModel>? variants,
    String? sku,
    int? stock,
    String? price,
    String? thumbnailUrl,
    String? discount,
    ProductStatus? status,
    String? defaultProduct,
    MarketStatus? marketStatus,
  }) =>
      ProductModel(
        productId: productId ?? this.productId,
        name: name ?? this.name,
        categoryOneId: categoryOneId ?? this.categoryOneId,
        categoryTwoId: categoryTwoId ?? this.categoryTwoId,
        variants: variants ?? this.variants,
        defaultProduct: defaultProduct ?? this.defaultProduct,
        stock: stock ?? this.stock,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        status: status ?? this.status,
        marketStatus: marketStatus ?? this.marketStatus,
      );
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
  /// Default variant will be used for product image, price & discount
  VariantModel get defaultVariant => variants.firstWhere(
        (variant) => variant.variantId == defaultProduct,
        orElse: () => variants.first,
      );

  /// Product is out of stock if all variants are out of stock
  bool get isOutOfStock => status == ProductStatus.OUT_OF_STOCK;

  /// Show stock left warning
  /// TODO(obella465): Affirm implementation with @Iyo for variants
  bool get isAlmostDepleted => !isOutOfStock && stock <= 3;
}

/// gRPC [Product] extension methods
extension GRPCProduct on Product {
  /// Overall stock from all variants
  int get totalStock => variants
      .map((productVariant) => productVariant.stock)
      .reduce((stock1, stock2) => stock1 + stock2);

  /// Default variant will be used for product image, price & discount
  /// TODO(obella465): Refactor to use default product variant Id once proto
  /// confirmed.
  ///
  /// ```dart
  /// variants.firstWhere(
  ///         (variant) => variant.variantId == defaultVariantId,
  ///     orElse: () => variants.first,
  ///   )
  ///```
  Variant get defaultVariant => variants.first;
}
