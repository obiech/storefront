import 'package:equatable/equatable.dart';

/// Representation of a product sold in Dropezy.
///
/// TODO: add other information such as category
class ProductModel extends Equatable {
  const ProductModel({
    required this.sku,
    required this.name,
    required this.price,
    required this.thumbnailUrl,
  });

  /// A unique identifier of a Product
  /// Stands for Stock Keeping Unit
  final String sku;

  final String name;

  final String price;

  /// URL for product thumbnail image
  final String thumbnailUrl;

  @override
  List<Object?> get props => [sku, price];
}
