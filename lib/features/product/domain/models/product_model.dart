import 'package:dropezy_proto/v1/inventory/inventory.pbgrpc.dart';

import 'base_product.dart';
import 'market_status.dart';
import 'variant_model.dart';
import 'variant_model.ext.dart';

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
class ProductModel extends BaseProduct {
  const ProductModel({
    required String productId,
    required String name,
    required this.variants,
    required String sku,
    required int stock,
    required String price,
    required String unit,
    required String thumbnailUrl,
    required List<String> imagesUrls,
    required this.description,

    // TODO(obella465): Fix once fields below are confirmed
    String? discount,
    this.marketStatus,
    required this.defaultProduct,

    /// Defaulting to active TODO(obella465) - Fix once product structure affirmed
    this.status = ProductModelStatus.ACTIVE,
    int? maxQty,
  }) : super(
          productId,
          name,
          sku,
          stock,
          price,
          discount,
          thumbnailUrl,
          unit,
          imagesUrls,
          maxQty,
        );

  /// Creates a [ProductModel] from gRPC [Product]
  factory ProductModel.fromPb(Product inventoryProduct) {
    final baseVariant = inventoryProduct.variants.defaultVariant;

    return ProductModel(
      productId: inventoryProduct.productId,
      name: inventoryProduct.name,
      variants: inventoryProduct.variants
          .map(
            (variant) => VariantModel.fromPb(variant),
          )
          .toList(),
      defaultProduct: baseVariant.id,
      stock: inventoryProduct.totalStock,
      sku: baseVariant.sku,
      price: baseVariant.price,
      unit: baseVariant.unit,
      description: inventoryProduct.description,

      /// Add empty image to display logo if no images are available
      imagesUrls:
          baseVariant.imagesUrls.isEmpty ? [''] : baseVariant.imagesUrls,
      thumbnailUrl:
          baseVariant.imagesUrls.isEmpty ? '' : baseVariant.imagesUrls.first,
      status: inventoryProduct.totalStock < 1
          ? ProductModelStatus.OUT_OF_STOCK
          : ProductModelStatus.ACTIVE,
      maxQty: baseVariant.maxQty,
    );
  }

  /// Creates an empty [ProductModel] with
  /// loading status
  factory ProductModel.loading() {
    return const ProductModel(
      productId: '',
      name: '',
      variants: [],
      defaultProduct: '',
      stock: 0,
      sku: '',
      unit: '',
      price: '',
      description: '',
      thumbnailUrl: '',
      status: ProductModelStatus.LOADING,
      imagesUrls: [],
    );
  }

  final MarketStatus? marketStatus;

  final ProductModelStatus status;

  // Default product variant Id
  final String defaultProduct;

  /// Detailed description about the product
  final String description;

  /// List of product variants.
  ///
  /// variants can be derived from units or flavours
  /// of a product e.g Chocolate, Vanilla flavored milk
  final List<VariantModel> variants;

  @override
  List<Object?> get props => [
        ...super.props,
        variants,
        defaultProduct,
        status,
        marketStatus,
      ];

  /// Create copy of object
  ProductModel copyWith({
    String? id,
    String? name,
    List<VariantModel>? variants,
    String? sku,
    int? stock,
    int? maxQty,
    String? price,
    String? unit,
    String? thumbnailUrl,
    List<String>? imagesUrls,
    String? discount,
    ProductModelStatus? status,
    String? defaultProduct,
    MarketStatus? marketStatus,
    String? description,
  }) =>
      ProductModel(
        productId: id ?? this.id,
        name: name ?? this.name,
        variants: variants ?? this.variants,
        defaultProduct: defaultProduct ?? this.defaultProduct,
        stock: stock ?? this.stock,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        unit: unit ?? this.unit,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        imagesUrls: imagesUrls ?? this.imagesUrls,
        status: status ?? this.status,
        marketStatus: marketStatus ?? this.marketStatus,
        discount: discount ?? this.discount,
        description: description ?? this.description,
        maxQty: maxQty ?? this.maxQty,
      );
}

/// https://dropezy.slack.com/archives/C038EPQGJLR/p1650423774792949?thread_ts=1650422527.075119&cid=C038EPQGJLR
enum ProductModelStatus {
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
        (variant) => variant.id == defaultProduct,
        orElse: () => variants.first,
      );

  /// Check if product has more than one variant
  bool get hasMultipleVariants => variants.length > 1;
}

/// gRPC [Product] extension methods
extension GRPCProduct on Product {
  /// Overall stock from all variants
  int get totalStock => variants.fold(
        0,
        (currentStock, productVariant) => productVariant.stock + currentStock,
      );
}

const dummyDescription =
    'Mengandung Omega 9 yang memiliki asam lemak tak jenuh tunggal atau Mono Unsaturated Fatty Acid (MUFA) yang menurut para ahli internasional berkhasiat menurunkan kolesterol LDL dan menaikkan kolesterol HDL';
