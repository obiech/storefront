import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/product_search/domain/repository/i_search_history_repository.dart';

part 'search_history_state.dart';

@injectable
class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  final ISearchHistoryRepository _prefs;

  SearchHistoryCubit(this._prefs) : super(SearchHistoryInitial());

  final List<String> _searchQueries = [];

  /// Load Search Queries
  Future<void> getSearchQueries() async {
    if (_searchQueries.isEmpty) {
      _searchQueries.addAll(await _prefs.getSearchQueries());
    }
    emit(LoadedSearchQueries(List.of(_searchQueries)));
  }

  /// Add search query
  Future<void> addSearchQuery(String query) async {
    _searchQueries.clear();
    _searchQueries.addAll(await _prefs.addSearchQuery(query));

    emit(LoadedSearchQueries(List.of(_searchQueries)));
  }

  /// Remove search query
  Future<void> removeSearchQuery(String query) async {
    _searchQueries.clear();
    _searchQueries.addAll(await _prefs.removeSearchQuery(query));

    emit(LoadedSearchQueries(List.of(_searchQueries)));
  }

  /// Clear Search Query
  Future<void> clearSearchQueries() async {
    _searchQueries.clear();
    _searchQueries.addAll(await _prefs.clearSearchQueries());

    emit(LoadedSearchQueries(List.of(_searchQueries)));
  }
}
