import '../../../../core/core.dart';
import '../../../product/index.dart';

abstract class IProductInventoryRepository {
  /// Get list of Product categories
  /// from categoryId
  RepoResult<List<ProductModel>> getProductByCategory(
    String categoryId,
  );
}
