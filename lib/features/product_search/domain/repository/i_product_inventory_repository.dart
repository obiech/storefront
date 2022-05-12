import '../../../../core/core.dart';
import '../../../product/index.dart';

abstract class IProductInventoryRepository {
  //Get list of Product categories
  RepoResult<List<ProductModel>> getProductByCategory(String categoryId);
}
