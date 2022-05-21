import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/category/category.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../../core/core.dart';
import '../domain.dart';

/// Repository for fetching C1 category from storefront-backend
/// using gRPC connection.
@LazySingleton(as: IParentCategoriesRepository, env: DiEnvironment.grpcEnvs)
class ParentCategoriesRepository extends IParentCategoriesRepository {
  ParentCategoriesRepository(this._categoryServiceClient);

  final CategoryServiceClient _categoryServiceClient;

  @override
  RepoResult<List<ParentCategoryModel>> getParentCategories() async {
    try {
      final List<ParentCategoryModel> _parentCategoryModels = [];

      final response = await _categoryServiceClient.get(GetRequest());

      _parentCategoryModels
          .addAll(response.categories.map(ParentCategoryModel.fromPb).toList());

      return right(_parentCategoryModels);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
