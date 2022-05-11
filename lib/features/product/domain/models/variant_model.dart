import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';
import 'package:equatable/equatable.dart';

/// Representation of a product variant sold in Dropezy.
///
/// TODO: add other information such as unit
class VariantModel extends Equatable {
  // product variant's unique identifier.
  final String variantId;

  // name of the product variant.
  final String name;

  // product variant's image urls.
  final List<String> imagesUrls;

  // product variant price.
  final String price;

  // sku of product variant.
  final String sku;

  // available stock for this product.
  final int stock;

  const VariantModel({
    required this.variantId,
    required this.name,
    required this.imagesUrls,
    required this.price,
    required this.sku,
    required this.stock,
  });

  /// Creates a [VariantModel] from gRPC [Variant]
  factory VariantModel.fromPb(Variant productVariant) {
    return VariantModel(
      variantId: productVariant.variantId,
      name: productVariant.name,
      imagesUrls: productVariant.imagesUrls,
      price: productVariant.price.num,
      sku: productVariant.sku,
      stock: productVariant.stock,
    );
  }

  @override
  List<Object?> get props => [variantId, name, imagesUrls, price, sku, stock];
}
