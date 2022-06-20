import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';

import '../domain.dart';

/// Representation of a product variant sold in Dropezy.
///
class VariantModel extends BaseProduct {
  const VariantModel({
    required this.productId,
    required String variantId,
    required String name,
    required List<String> imagesUrls,
    required String defaultImageUrl,
    required String price,
    String? discount,
    required String sku,
    required int stock,
    required String unit,
    int? maxQty,
  }) : super(
          variantId,
          name,
          sku,
          stock,
          price,
          discount,
          defaultImageUrl,
          unit,
          imagesUrls,
          maxQty,
        );

  /// Product to which the variant belongs
  final String productId;

  /// Creates a [VariantModel] from gRPC [Variant]
  ///
  /// The [productId] simplifies variant backtracking to product
  ///
  /// PS: [productVariant.name] from backend is empty from backend
  /// for inventory search, however for Cart [Item], the name
  /// is provided fine.
  factory VariantModel.fromPb(Variant productVariant, String productId) {
    final imageUrls = productVariant.toImageUrls;
    return VariantModel(
      productId: productId,
      variantId: productVariant.variantId,
      name: productVariant.name,
      imagesUrls: imageUrls,
      defaultImageUrl: imageUrls.isEmpty ? '' : imageUrls.first,
      price: productVariant.price.num,
      sku: productVariant.sku,
      stock: productVariant.stock,
      unit: productVariant.toUnit,
      maxQty: productVariant.maximumOrder,
    );
  }

  /// Create copy of object
  VariantModel copyWith({
    String? productId,
    String? id,
    String? name,
    List<String>? imagesUrls,
    String? thumbnailUrl,
    String? price,
    String? discount,
    String? sku,
    int? stock,
    int? maxQty,
    String? unit,
  }) =>
      VariantModel(
        productId: productId ?? this.productId,
        variantId: id ?? this.id,
        name: name ?? this.name,
        imagesUrls: imagesUrls ?? this.imagesUrls,
        defaultImageUrl: thumbnailUrl ?? this.thumbnailUrl,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        sku: sku ?? this.sku,
        stock: stock ?? this.stock,
        unit: unit ?? this.unit,
        maxQty: maxQty ?? this.maxQty,
      );

  // Check if has discount (i.e null or zero)
  bool get hasDiscount =>
      discount != null && (double.tryParse(discount!) ?? 0) > 0;
}
