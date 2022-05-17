import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';

import 'base_product.dart';

/// Representation of a product variant sold in Dropezy.
///
class VariantModel extends BaseProduct {
  // product variant's image urls.
  final List<String> imagesUrls;

  // product variant unit.
  final String unit;

  const VariantModel({
    required String variantId,
    required String name,
    required this.imagesUrls,
    required String defaultImageUrl,
    required String price,
    String? discount,
    required String sku,
    required int stock,
    required this.unit,
  }) : super(variantId, name, sku, stock, price, discount, defaultImageUrl);

  /// Creates a [VariantModel] from gRPC [Variant]
  factory VariantModel.fromPb(Variant productVariant) {
    return VariantModel(
      variantId: productVariant.variantId,
      name: productVariant.name,
      imagesUrls: productVariant.imagesUrls,
      defaultImageUrl: productVariant.imagesUrls.first,
      price: productVariant.price.num,
      sku: productVariant.sku,
      stock: productVariant.stock,

      // TODO(obella465) - Restore to required when added to proto
      unit: '500g',
    );
  }

  /// Create copy of object
  VariantModel copyWith({
    String? id,
    String? name,
    List<String>? imagesUrls,
    String? thumbnailUrl,
    String? price,
    String? discount,
    String? sku,
    int? stock,
    String? unit,
  }) =>
      VariantModel(
        variantId: id ?? this.id,
        name: name ?? this.name,
        imagesUrls: imagesUrls ?? this.imagesUrls,
        defaultImageUrl: thumbnailUrl ?? this.thumbnailUrl,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        sku: sku ?? this.sku,
        stock: stock ?? this.stock,
        unit: unit ?? this.unit,
      );

  @override
  List<Object?> get props => [...super.props, unit, imagesUrls];
}
