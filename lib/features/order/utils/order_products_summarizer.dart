import '../domain/domains.dart';

/// Returns a summary of [OrderProductModel] bought in an order:
///
/// - for 1 product, returns the product's name.
/// - for 2 products, returns both products' name separated by comma.
/// - for 3 products, returns first 2 products' name and number of remaining
/// products, separated by comma.
String summarizeOrderProducts(
  List<OrderProductModel> orderProducts,
  String remainingProductsLabel,
) {
  if (orderProducts.isEmpty) return '';

  String summary = orderProducts[0].productName;

  if (orderProducts.length >= 2) {
    summary += ', ${orderProducts[1].productName}';
  }

  if (orderProducts.length >= 3) {
    summary += ', +${orderProducts.length - 2} $remainingProductsLabel';
  }

  return summary;
}
