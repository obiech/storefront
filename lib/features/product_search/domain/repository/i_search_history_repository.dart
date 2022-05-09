/// Search history handlers
///
/// For product search query history management
abstract class ISearchHistoryRepository {
  /// Observe search history queries
  Stream<List<String>> get observeHistoryStream;

  /// Add a query to search list
  Future<void> addSearchQuery(String query);

  /// Remove a query from search list
  Future<void> removeSearchQuery(String query);

  /// Clear search history
  Future<void> clearSearchQueries();

  /// Dispose any subscriptions
  void dispose();
}
