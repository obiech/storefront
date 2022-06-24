part of 'address_pinpoint_bloc.dart';

abstract class AddressPinpointState extends Equatable {
  const AddressPinpointState();

  @override
  List<Object?> get props => [];
}

/// When loading for address information.
class AddressPinpointLoading extends AddressPinpointState {
  const AddressPinpointLoading();
}

/// When address information is successfully retrieved.
class AddressPinpointSuccess extends AddressPinpointState {
  const AddressPinpointSuccess({
    required this.placeModel,
    required this.latLng,
    this.panToNewCoordinates = false,
  });

  final PlaceDetailsModel placeModel;
  final LatLng latLng;
  final bool panToNewCoordinates;

  @override
  List<Object?> get props => [placeModel, latLng, panToNewCoordinates];
}

/// When failed to retrieve address information.
class AddressPinpointError extends AddressPinpointState {
  const AddressPinpointError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

/// When [DropezyGeolocator] indicates that location services is
/// not enabled.
class LocationServicesNotEnabled extends AddressPinpointState {
  const LocationServicesNotEnabled();
}
