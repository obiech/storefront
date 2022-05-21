import '../../../../core/core.dart';
import '../../../product/index.dart';

abstract class IProductInventoryRepository {
  /// Get list of Product categories
  /// from categoryId and StoreId
  RepoResult<List<ProductModel>> getProductByCategory(
    String storeId,
    String categoryId,
  );
}
