import 'package:dartz/dartz.dart';

import '../../../product/index.dart';
import 'failures.dart';

/// Product search management
abstract class IProductSearchRepository {
  /// Get query autocomplete
  Future<Either<SearchFailure, List<String>>> getSearchSuggestions(
    String query, {
    int limit = 5,
  });

  /// Get Product Inventory Search Results
  Future<Either<SearchFailure, List<ProductModel>>> searchInventoryForItems(
    String query, {
    int page = 0,
    int limit = 10,
  });
}
