import 'package:equatable/equatable.dart';

/// Base structure with related fields for
/// [ProductModel] & [VariantModel] that way
/// widgets/methods that can be used by both
/// can simply use [BaseProduct]
abstract class BaseProduct extends Equatable {
  /// Product/Variant unique identifier
  final String id;

  /// name of the Product/Variant
  final String name;

  /// sku of product variant.
  ///
  /// For the case of the product,
  /// it holds the default variant's sku
  final String sku;

  /// stock of product/variant.
  ///
  /// For the case of the product,
  /// it holds the overall stock of all variants.
  final int stock;

  /// price of product variant.
  ///
  /// For the case of the product,
  /// it holds the default variant's price
  final String price;

  /// discount of product variant.
  ///
  /// For the case of the product,
  /// it holds the default variant's discount
  final String? discount;

  /// Image URL of product/variant.
  ///
  /// For the case of the product,
  /// it holds the default variant's image URL
  final String thumbnailUrl;

  const BaseProduct(
    this.id,
    this.name,
    this.sku,
    this.stock,
    this.price,
    this.discount,
    this.thumbnailUrl,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        stock,
        price,
        discount,
        thumbnailUrl,
      ];
}

/// BaseProduct extensions
extension BaseProductX on BaseProduct {
  /// Product is out of stock if all variants are out of stock
  bool get isOutOfStock => stock <= 0;

  /// Show stock left warning
  /// TODO(obella465): Affirm implementation with @Iyo for variants
  bool get isAlmostDepleted => !isOutOfStock && stock <= 3;
}
