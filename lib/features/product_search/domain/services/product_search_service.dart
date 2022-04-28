import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../product/index.dart';
import '../../index.dart';

@LazySingleton(as: IProductSearchRepository, env: DiEnvironment.grpcEnvs)
class ProductSearchService implements IProductSearchRepository {
  final SearchServiceClient searchService;

  ProductSearchService(this.searchService);

  @override
  Future<List<String>> getSearchSuggestions(
    String query, {
    int limit = 3,
  }) async {
    final _result = await searchService.suggestInventory(
      SuggestInventoryRequest(query: query, size: limit),
    );

    return _result.suggestions;
  }

  @override
  Future<List<ProductModel>> searchInventoryForItems(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    final _result = await searchService.searchInventory(
      SearchInventoryRequest(
        query: query,
        // TODO(obella465) - Get store once geo-spatial setup is done
        storeId: 'store_11',
        pageCurrent: page,
        pageSize: limit,
      ),
    );

    return _result.results.toModel;
  }
}
