/// Search history handlers
///
/// For product search query history management
abstract class ISearchHistoryRepository {
  /// Get all previous user searches
  Future<List<String>> getSearchQueries();

  /// Add a query to search list
  Future<List<String>> addSearchQuery(String query);

  /// Remove a query from search list
  Future<List<String>> removeSearchQuery(String query);

  /// Clear search history
  Future<List<String>> clearSearchQueries();
}
