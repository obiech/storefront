import '../../config.dart';

class SearchHistoryEvent {
  final String query;
  final DateTime createdAt;

  SearchHistoryEvent(this.query, this.createdAt);
}

/// Extension class for search history events
extension SearchHistoryEventX on List<SearchHistoryEvent> {
  /// Get latest search queries
  List<String> get getLatest {
    sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return take(maxSearchHistory).map((e) => e.query).toList();
  }

  /// Get excess
  Iterable<SearchHistoryEvent> get getExcess {
    sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return skip(maxSearchHistory);
  }
}
