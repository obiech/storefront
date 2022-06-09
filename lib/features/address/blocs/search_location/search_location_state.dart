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
