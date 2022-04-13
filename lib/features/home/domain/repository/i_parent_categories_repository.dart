import 'package:storefront_app/features/home/domain/models/category_model.dart';

abstract class IParentCategoriesRepository {
  //Get list of C1 categories
  Future<List<ParentCategoryModel>> getParentCategories();
}
