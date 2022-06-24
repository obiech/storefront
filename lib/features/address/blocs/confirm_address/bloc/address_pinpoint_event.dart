part of 'address_pinpoint_bloc.dart';

abstract class AddressPinpointEvent extends Equatable {
  const AddressPinpointEvent();

  @override
  List<Object> get props => [];
}

/// When user selects a coordinates from the Maps widget i.e.
/// by dragging around on the map.
class GetLocationFromCoordinates extends AddressPinpointEvent {
  const GetLocationFromCoordinates(this.coordinates);

  final LatLng coordinates;

  @override
  List<Object> get props => [coordinates];
}
