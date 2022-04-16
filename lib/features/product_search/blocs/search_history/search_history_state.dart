part of 'search_history_cubit.dart';

abstract class SearchHistoryState extends Equatable {
  const SearchHistoryState();

  @override
  List<Object> get props => [];
}

/// Initial Search Page state
class SearchHistoryInitial extends SearchHistoryState {}

/// When SearchQueries are being loaded
/// from prefs
class LoadingSearchQueries extends SearchHistoryState {}

/// When Search Queries have been successfully loaded
class LoadedSearchQueries extends SearchHistoryState {
  /// All search queries
  final List<String> queries;

  const LoadedSearchQueries(this.queries);

  @override
  List<Object> get props => [queries];
}

/// When an error has occurred while loading Search Queries
class ErrorLoadingSearchQueries extends SearchHistoryState {
  final String message;

  const ErrorLoadingSearchQueries(this.message);

  @override
  List<Object> get props => [message];
}
