import 'package:storefront_app/features/home/domain/models/categories_one.dart';

abstract class ICategoriesOneRepository {
  Future<List<CategoryOneModel>> getCategoryOnes();
}
