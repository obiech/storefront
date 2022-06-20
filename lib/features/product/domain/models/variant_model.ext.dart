import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';
import 'package:dropezy_proto/v1/product/product.pbenum.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

extension VariantListX on List<Variant> {
  /// Convert list of [Variant]s to [VariantModel]s
  List<VariantModel> toModels(String productId) =>
      map((variant) => VariantModel.fromPb(variant, productId)).toList();

  /// Total Stock from all variants
  int get overallStock => fold(
        0,
        (previousStock, currentVariant) => previousStock + currentVariant.stock,
      );

  /// Get default variant
  VariantModel defaultVariant(String productId) => VariantModel.fromPb(
        firstWhere(
          (variant) =>
              variant.variantStatus == VariantStatus.VARIANT_STATUS_DEFAULT,
          orElse: () => first,
        ),
        productId,
      );
}

extension VariantModelX on Variant {
  /// Convert list of [Variant.imageUrls]s to
  /// list of image URL string
  List<String> get toImageUrls =>
      imagesUrls.map((url) => url.toImageUrl).toList();

  /// Concatenate [Variant.variantValue] & [Variant.variantQuantifier]
  /// to user understandable unit
  String get toUnit => '$variantValue $variantQuantifier';
}

extension VariantModelListX on List<VariantModel> {
  List<VariantModel> sortOutOfStock() {
    final newList = List<VariantModel>.from(this);
    newList.sort(
      (a, b) => a.isOutOfStock.toInt().compareTo(b.isOutOfStock.toInt()),
    );
    return newList;
  }
}
