import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/features/address/domain/repository/i_search_location_history_repository.dart';

part 'search_location_history_event.dart';
part 'search_location_history_state.dart';

class SearchLocationHistoryBloc
    extends Bloc<SearchLocationHistoryEvent, SearchLocationHistoryState> {
  final ISearchLocationHistoryRepository _repository;

  SearchLocationHistoryBloc(this._repository)
      : super(const SearchLocationHistoryLoading()) {
    on<LoadSearchLocationHistory>((event, emit) async {
      emit(const SearchLocationHistoryLoading());

      final results = await _repository.getSearchHistory();

      results.fold(
        (failure) {
          emit(SearchLocationHistoryError(failure.message));
        },
        (histories) {
          if (histories.isEmpty) {
            emit(const SearchLocationHistoryLoadedEmpty());
          } else {
            emit(SearchLocationHistoryLoaded(histories));
          }
        },
      );
    });
  }
}
