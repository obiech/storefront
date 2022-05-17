import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';

import 'base_product.dart';

/// Representation of a product variant sold in Dropezy.
///
/// TODO: add other information such as unit
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

  @override
  List<Object?> get props => [...super.props, unit, imagesUrls];
}
