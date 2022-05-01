import 'package:dartz/dartz.dart';
import 'package:storefront_app/features/home/domain/models/category_model.dart';

import '../../../../core/core.dart';

abstract class IParentCategoriesRepository {
  //Get list of C1 categories
  Future<Either<Failure, List<ParentCategoryModel>>> getParentCategories();
}
