part of 'search_location_bloc.dart';

abstract class SearchLocationEvent extends Equatable {
  const SearchLocationEvent();
}

class QueryChanged extends SearchLocationEvent {
  final String query;

  const QueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class QueryDeleted extends SearchLocationEvent {
  const QueryDeleted();

  @override
  List<Object?> get props => [];
}

class LocationSelected extends SearchLocationEvent {
  final String placeId;

  const LocationSelected(this.placeId);

  @override
  List<Object?> get props => [placeId];
}
