import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  SearchLocationBloc(this._searchRepository)
      : super(const SearchLocationInitial()) {
    on<QueryChanged>(
      (event, emit) => _onQueryChanged(emit, event),
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<QueryDeleted>((event, emit) => _onQueryDeleted(emit));
    on<LocationSelected>((event, emit) => _onLocationSelected(emit, event));
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
}
