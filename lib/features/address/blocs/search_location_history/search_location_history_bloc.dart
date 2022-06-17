import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

part 'search_location_history_event.dart';
part 'search_location_history_state.dart';

@Injectable()
class SearchLocationHistoryBloc
    extends Bloc<SearchLocationHistoryEvent, SearchLocationHistoryState> {
  final ISearchLocationHistoryRepository _repository;

  SearchLocationHistoryBloc(this._repository)
      : super(const SearchLocationHistoryLoading()) {
    on<LoadSearchLocationHistory>(
      (event, emit) => _onLoadSearchLocationHistory(emit),
    );
    on<AddNewSearchQuery>(
      (event, emit) => _onAddNewSearchQuery(event),
    );
  }

  Future<void> _onAddNewSearchQuery(AddNewSearchQuery event) async {
    await _repository.addSearchQuery(event.place);
  }

  Future<void> _onLoadSearchLocationHistory(
    Emitter<SearchLocationHistoryState> emit,
  ) async {
    emit(const SearchLocationHistoryLoading());

    final results = await _repository.getSearchHistory();

    results.fold(
      (failure) {
        emit(SearchLocationHistoryError(failure.message));
      },
      (histories) {
        emit(SearchLocationHistoryLoaded(histories));
      },
    );
  }
}
