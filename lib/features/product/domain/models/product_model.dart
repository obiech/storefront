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
  });

  /// A unique identifier of a Product
  /// Stands for Stock Keeping Unit
  final String sku;

  final String productId;

  final String name;

  final int stock;
  final String price;
  final String? discount;

  final MarketStatus? marketStatus;

  /// URL for product thumbnail image
  final String thumbnailUrl;

  @override
  List<Object?> get props => [sku, price];
}
