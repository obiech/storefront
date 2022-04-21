import '../../../product/index.dart';

/// Product search management
abstract class IProductSearchRepository {
  /// Get query autocomplete
  Future<List<String>> getSearchSuggestions(
    String query, {
    int limit = 5,
  });

  /// Get Product Inventory Search Results
  Future<List<ProductModel>> searchInventoryForItems(
    String query, {
    int page = 0,
    int limit = 10,
  });
}
