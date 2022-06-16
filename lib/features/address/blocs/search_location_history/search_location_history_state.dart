part of 'search_location_history_bloc.dart';

abstract class SearchLocationHistoryState extends Equatable {
  const SearchLocationHistoryState();
}

class SearchLocationHistoryLoading extends SearchLocationHistoryState {
  const SearchLocationHistoryLoading();

  @override
  List<Object> get props => [];
}

class SearchLocationHistoryLoaded extends SearchLocationHistoryState {
  final List<String> queries;

  const SearchLocationHistoryLoaded(this.queries);

  @override
  List<Object?> get props => [queries];
}

class SearchLocationHistoryLoadedEmpty extends SearchLocationHistoryState {
  const SearchLocationHistoryLoadedEmpty();

  @override
  List<Object?> get props => [];
}

class SearchLocationHistoryError extends SearchLocationHistoryState {
  final String message;

  const SearchLocationHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
