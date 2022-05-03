import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

import '../../../product/index.dart';
import '../../index.dart';

part 'search_inventory_event.dart';
part 'search_inventory_state.dart';

@injectable
class SearchInventoryBloc
    extends Bloc<SearchInventoryEvent, SearchInventoryState> {
  final IProductSearchRepository repository;
  final ISearchHistoryRepository searchHistoryRepository;

  SearchInventoryBloc(this.repository, this.searchHistoryRepository)
      : super(SearchInventoryInitial()) {
    on<SearchInventory>(
      _searchInventory,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<LoadMoreItems>(
      _loadMoreItems,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  int _page = 0;
  String _query = '';
  final List<ProductModel> _inventory = [];

  /// Initial inventory search
  FutureOr<void> _searchInventory(
    SearchInventory event,
    Emitter<SearchInventoryState> emit,
  ) async {
    _page = 0;
    _query = event.query;

    emit(SearchingForItemInInventory());

    final _failureOrResult = await repository.searchInventoryForItems(_query);

    _failureOrResult.fold((failure) {
      emit(ErrorOccurredSearchingForItem(failure));
    }, (inventory) {
      _inventory.clear();
      _inventory.addAll(inventory);
      emit(InventoryItemResults(List.of(_inventory)));
    });

    // Add query to search history
    searchHistoryRepository.addSearchQuery(_query);
  }

  /// Load more items
  FutureOr<void> _loadMoreItems(
    LoadMoreItems event,
    Emitter<SearchInventoryState> emit,
  ) async {
    if (state is InventoryItemResults &&
        !(state as InventoryItemResults).isAtEnd) {
      final _resultOrFailure = await repository.searchInventoryForItems(
        _query,
        page: _page + 1,
      );

      _resultOrFailure.fold((failure) {
        if (failure is NoInventoryResults) {
          emit(InventoryItemResults(List.of(_inventory), isAtEnd: true));
        }
      }, (inventory) {
        _page++;
        _inventory.addAll(inventory);
        emit(InventoryItemResults(List.of(_inventory)));
        // TODO(obella465): If results are less than limit, end of page reached
      });
    }
  }

  /// For tests
  @visibleForTesting
  int get page => _page;

  @visibleForTesting
  String get query => _query;

  @visibleForTesting
  List<ProductModel> get inventory => _inventory;
}
