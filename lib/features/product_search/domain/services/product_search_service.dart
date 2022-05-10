import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../product/index.dart';
import '../../index.dart';

@LazySingleton(as: IProductSearchRepository, env: DiEnvironment.grpcEnvs)
class ProductSearchService implements IProductSearchRepository {
  final SearchServiceClient searchService;

  ProductSearchService(this.searchService);

  @override
  RepoResult<List<String>> getSearchSuggestions(
    String query, {
    int limit = 3,
  }) async {
    try {
      final _result = await searchService.suggestInventory(
        SuggestInventoryRequest(query: query, size: limit),
      );

      if (_result.suggestions.isEmpty) {
        return left(NoSuggestionResults());
      }

      return right(_result.suggestions);
    } on Exception catch (e) {
      return left(NetworkError(e.toFailure));
    }
  }

  @override
  RepoResult<List<ProductModel>> searchInventoryForItems(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final _result = await searchService.searchInventory(
        SearchInventoryRequest(
          query: query,
          // TODO(obella465) - Get store once geo-spatial setup is done
          storeId: 'store_11',
          pageCurrent: page,
          pageSize: limit,
        ),
      );

      if (_result.results.isEmpty) {
        return left(NoInventoryResults());
      }

      return right(_result.results.toModel);
    } on Exception catch (e) {
      return left(NetworkError(e.toFailure));
    }
  }
}
