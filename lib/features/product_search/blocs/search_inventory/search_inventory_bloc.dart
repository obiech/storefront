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

@lazySingleton
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

  final int _pageSize = 10;
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

    final _failureOrResult = await repository.searchInventoryForItems(
      _query,
      event.storeId,
      limit: _pageSize,
    );

    _failureOrResult.fold((failure) {
      emit(ErrorOccurredSearchingForItem(failure as SearchFailure));
    }, (inventory) {
      _inventory.clear();
      _inventory.addAll(inventory);
      emit(
        InventoryItemResults(
          List.of(_inventory),
          event.storeId,
          isAtEnd: inventory.length < _pageSize,
        ),
      );
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
      // Show loading more cards
      final currentState = state as InventoryItemResults;
      emit(
        InventoryItemResults(
          currentState.results,
          currentState.storeId,
          isLoadingMore: true,
        ),
      );

      final _resultOrFailure = await repository.searchInventoryForItems(
        _query,
        currentState.storeId,
        page: _page + 1,
        limit: _pageSize,
      );

      _resultOrFailure.fold((failure) {
        if (failure is NoInventoryResults) {
          emit(
            InventoryItemResults(
              List.of(_inventory),
              currentState.storeId,
              isAtEnd: true,
            ),
          );
        } else {
          emit(
            InventoryItemResults(
              List.of(_inventory),
              currentState.storeId,
            ),
          );
        }
      }, (inventory) {
        _page++;
        _inventory.addAll(inventory);
        emit(
          InventoryItemResults(
            List.of(_inventory),
            currentState.storeId,
            isAtEnd: inventory.length < _pageSize,
          ),
        );
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
