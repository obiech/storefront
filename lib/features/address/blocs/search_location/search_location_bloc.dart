import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

part 'search_location_event.dart';
part 'search_location_state.dart';

@injectable
class SearchLocationBloc
    extends Bloc<SearchLocationEvent, SearchLocationState> {
  final ISearchLocationRepository _searchRepository;
  final DropezyGeolocator _geolocator;

  SearchLocationBloc(
    this._searchRepository,
    this._geolocator,
  ) : super(const SearchLocationInitial()) {
    on<QueryChanged>(
      (event, emit) => _onQueryChanged(emit, event),
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<QueryDeleted>((event, emit) => _onQueryDeleted(emit));
    on<LocationSelected>((event, emit) => _onLocationSelected(emit, event));
    on<RequestLocationPermission>(
      (event, emit) => _onRequestLocationPermission(emit, event),
    );
    on<UseCurrentLocation>((event, emit) => _onUseCurrentLocation(emit));
    on<ViewMap>((event, emit) => _onViewMap(emit));
  }

  void _onRequestLocationPermission(
    Emitter<SearchLocationState> emit,
    RequestLocationPermission event,
  ) {
    emit(const SearchLocationLoading());
    emit(OnRequestPermission(event.action));
    emit(const SearchLocationInitial());
  }

  Future<void> _onLocationSelected(
    Emitter<SearchLocationState> emit,
    LocationSelected event,
  ) async {
    emit(const SearchLocationLoading());

    final addressOrFailure =
        await _searchRepository.getLocationDetail(event.placeId);

    addressOrFailure.fold(
      (failure) {
        emit(LocationSelectError(failure.message));
      },
      (address) {
        emit(LocationSelectSuccess(address));
      },
    );
  }

  Future<void> _onQueryChanged(
    Emitter<SearchLocationState> emit,
    QueryChanged event,
  ) async {
    emit(const SearchLocationLoading());

    final result = await _searchRepository.searchLocation(event.query);

    result.fold(
      (failure) {
        emit(SearchLocationError(failure.message));
      },
      (searchResult) {
        if (searchResult.isEmpty) {
          emit(const SearchLocationLoadedEmpty());
        } else {
          emit(SearchLocationLoaded(searchResult));
        }
      },
    );
  }

  void _onQueryDeleted(Emitter<SearchLocationState> emit) {
    emit(const SearchLocationInitial());
  }

  Future<void> _onUseCurrentLocation(Emitter<SearchLocationState> emit) async {
    emit(const SearchLocationLoading());

    final serviceEnabled = await _geolocator.isLocationServiceEnabled();

    await serviceEnabled.fold(
      (failure) {
        emit(LocationSelectError(failure.message));
        emit(const SearchLocationInitial());
      },
      (_) async {
        final position = await _geolocator.getCurrentPosition();
        final result = await _searchRepository.getCurrentLocation(
          LatLng(
            position.latitude,
            position.longitude,
          ),
        );

        result.fold(
          (failure) {
            emit(LocationSelectError(failure.message));
            emit(const SearchLocationInitial());
          },
          (address) {
            emit(LocationSelectSuccess(address));
          },
        );
      },
    );
  }

  Future<void> _onViewMap(Emitter<SearchLocationState> emit) async {
    emit(const SearchLocationLoading());

    final serviceEnabled = await _geolocator.isLocationServiceEnabled();

    await serviceEnabled.fold(
      (failure) {
        emit(LocationSelectError(failure.message));
        emit(const SearchLocationInitial());
      },
      (_) async {
        final position = await _geolocator.getCurrentPosition();
        emit(
          OnViewMap(
            LatLng(
              position.latitude,
              position.longitude,
            ),
          ),
        );
        emit(const SearchLocationInitial());
      },
    );
  }
}
