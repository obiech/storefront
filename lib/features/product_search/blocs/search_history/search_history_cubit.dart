import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

part 'search_history_state.dart';

@injectable
class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  final ISearchHistoryRepository _searchHistoryRepo;

  late final StreamSubscription _subscription;

  SearchHistoryCubit(this._searchHistoryRepo) : super(SearchHistoryInitial()) {
    _subscription = _searchHistoryRepo.observeHistoryStream.listen((event) {
      emit(LoadedSearchQueries(List.of(event)));
    });
  }

  /// Add search query
  Future<void> addSearchQuery(String query) async =>
      _searchHistoryRepo.addSearchQuery(query);

  /// Remove search query
  Future<void> removeSearchQuery(String query) async =>
      _searchHistoryRepo.removeSearchQuery(query);

  /// Clear Search Query
  Future<void> clearSearchQueries() async =>
      _searchHistoryRepo.clearSearchQueries();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
