import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../product/index.dart';
import '../../index.dart';

@LazySingleton(as: IProductSearchRepository, env: [DiEnvironment.dummy])
class DummyProductSearchService implements IProductSearchRepository {
  DummyProductSearchService();

  @override
  RepoResult<List<String>> getSearchSuggestions(
    String query, {
    int limit = 3,
  }) async {
    // Simulate network wait
    await Future.delayed(const Duration(seconds: 1));

    return right(
      ['Beanos', 'Red Beans', 'White Beans', 'Green Beans', 'Coffee Beans']
          .take(limit)
          .toList(),
    );
  }

  @override
  RepoResult<List<ProductModel>> searchInventoryForItems(
    String query,
    String storeId, {
    int page = 0,
    int limit = 10,
  }) async {
    // Simulate network wait
    await Future.delayed(const Duration(seconds: 1));

    return right(
      dummyProducts.skip(page * limit).take(limit).toList(),
    );
  }
}
