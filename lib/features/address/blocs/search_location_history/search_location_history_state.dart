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
  final List<PlaceModel> placeList;

  const SearchLocationHistoryLoaded(this.placeList);

  @override
  List<Object?> get props => [placeList];
}

class SearchLocationHistoryError extends SearchLocationHistoryState {
  final String message;

  const SearchLocationHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
