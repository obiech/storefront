import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

import '../../../index.dart';

part 'address_pinpoint_event.dart';
part 'address_pinpoint_state.dart';

/// By default applies a 300ms debounce on events to prevent unnecessary
/// or spamming of requests, as the underlying operations are expensive
/// in both computing and financial resources.
@injectable
class AddressPinpointBloc
    extends Bloc<AddressPinpointEvent, AddressPinpointState> {
  AddressPinpointBloc(this._searchLocationRepository)
      : super(const AddressPinpointLoading()) {
    on<GetLocationFromCoordinates>(
      _onGetLocationFromCoordinates,
      transformer: debounce(const Duration(milliseconds: debounceDuration)),
    );
  }

  final ISearchLocationRepository _searchLocationRepository;

  static const debounceDuration = 300;

  Future<void> _onGetLocationFromCoordinates(
    GetLocationFromCoordinates event,
    Emitter<AddressPinpointState> emit,
  ) async {
    emit(const AddressPinpointLoading());
    await _coordinatesToAddress(emit, event.coordinates, false);
  }

  /// Performs reverse geocoding on [coordinates] into
  /// real world address.
  Future<void> _coordinatesToAddress(
    Emitter<AddressPinpointState> emit,
    LatLng coordinates,
    bool panToNewCoordinates,
  ) async {
    final res = await _searchLocationRepository.getCurrentLocation(coordinates);

    res.fold(
      (failure) => emit(AddressPinpointError(failure.message)),
      (placeModel) => emit(
        AddressPinpointSuccess(
          placeModel: placeModel,
          latLng: coordinates,
          panToNewCoordinates: panToNewCoordinates,
        ),
      ),
    );
  }
}
