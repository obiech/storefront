part of 'search_location_history_bloc.dart';

abstract class SearchLocationHistoryEvent extends Equatable {
  const SearchLocationHistoryEvent();
}

class LoadSearchLocationHistory extends SearchLocationHistoryEvent {
  const LoadSearchLocationHistory();

  @override
  List<Object?> get props => [];
}
