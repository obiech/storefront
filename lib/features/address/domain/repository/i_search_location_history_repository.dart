import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

abstract class ISearchLocationHistoryRepository {
  RepoResult<List<PlaceModel>> getSearchHistory();
  Future<void> addSearchQuery(PlaceModel place);
  Future<void> removeSearchQuery(PlaceModel place);
  Future<void> clearSearchQueries();
}
