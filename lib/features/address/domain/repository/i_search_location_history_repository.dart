import 'package:storefront_app/core/core.dart';

abstract class ISearchLocationHistoryRepository {
  RepoResult<List<String>> getSearchHistory();
  Future<void> addSearchQuery(String query);
  Future<void> removeSearchQuery(String query);
  Future<void> clearSearchQueries();
}
