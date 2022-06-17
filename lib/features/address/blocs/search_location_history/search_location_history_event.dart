part of 'search_location_history_bloc.dart';

abstract class SearchLocationHistoryEvent extends Equatable {
  const SearchLocationHistoryEvent();
}

class LoadSearchLocationHistory extends SearchLocationHistoryEvent {
  const LoadSearchLocationHistory();

  @override
  List<Object?> get props => [];
}

class AddNewSearchQuery extends SearchLocationHistoryEvent {
  final PlaceModel place;

  const AddNewSearchQuery(this.place);

  @override
  List<Object?> get props => [place];
}
