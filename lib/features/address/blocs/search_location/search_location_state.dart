part of 'search_location_bloc.dart';

abstract class SearchLocationState extends Equatable {
  const SearchLocationState();
}

class SearchLocationInitial extends SearchLocationState {
  const SearchLocationInitial();

  @override
  List<Object> get props => [];
}

class SearchLocationLoading extends SearchLocationState {
  const SearchLocationLoading();

  @override
  List<Object?> get props => [];
}

class SearchLocationLoaded extends SearchLocationState {
  final List<PlacesAutoCompleteResult> results;

  const SearchLocationLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class SearchLocationLoadedEmpty extends SearchLocationState {
  const SearchLocationLoadedEmpty();

  @override
  List<Object?> get props => [];
}

class SearchLocationError extends SearchLocationState {
  final String message;

  const SearchLocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationSelectSuccess extends SearchLocationState {
  final PlaceDetailsModel addressDetails;

  const LocationSelectSuccess(this.addressDetails);

  @override
  List<Object?> get props => [addressDetails];
}

class LocationSelectError extends SearchLocationState {
  final String message;

  const LocationSelectError(this.message);

  @override
  List<Object?> get props => [message];
}

/// state to request permission and [action] that triggers it
class OnRequestPermission extends SearchLocationState {
  final SearchLocationAction action;

  const OnRequestPermission(this.action);

  @override
  List<Object?> get props => [action];
}

/// state to getting user location & passed to Map view
class OnViewMap extends SearchLocationState {
  final LatLng latLng;

  const OnViewMap(this.latLng);

  @override
  List<Object?> get props => [latLng];
}
