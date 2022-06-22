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

class RequestLocationPermission extends SearchLocationEvent {
  final SearchLocationAction action;

  const RequestLocationPermission(this.action);

  @override
  List<Object?> get props => [action];
}

class UseCurrentLocation extends SearchLocationEvent {
  const UseCurrentLocation();

  @override
  List<Object?> get props => [];
}

class ViewMap extends SearchLocationEvent {
  const ViewMap();

  @override
  List<Object?> get props => [];
}
