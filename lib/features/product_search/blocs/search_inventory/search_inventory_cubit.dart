import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../product/domain/domain.dart';
import '../../index.dart';

part 'search_inventory_state.dart';

@injectable
class SearchInventoryCubit extends Cubit<SearchInventoryState> {
  final IProductSearchRepository repository;

  SearchInventoryCubit(this.repository) : super(SearchInventoryInitial());

  int _page = 0;
  String _query = '';
  final List<ProductModel> _inventory = [];

  /// Initial inventory search
  Future<void> searchInventory(String query) async {
    _page = 0;
    _query = query;
    try {
      emit(SearchingForItemInInventory());

      final _result = await repository.searchInventoryForItems(query);

      if (_result.isNotEmpty) {
        _inventory.clear();
        _inventory.addAll(_result);
        emit(InventoryItemResults(List.of(_inventory)));
      } else {
        emit(const ErrorOccurredSearchingForItem('No Results'));
      }
    } catch (e) {
      emit(const ErrorOccurredSearchingForItem('Error loading results'));
    }
  }

  /// Load more items
  Future<void> loadMoreItems() async {
    if (state is InventoryItemResults &&
        !(state as InventoryItemResults).isAtEnd) {
      try {
        final _result = await repository.searchInventoryForItems(
          _query,
          page: _page + 1,
        );

        if (_result.isNotEmpty) {
          _page++;
          _inventory.addAll(_result);
          emit(InventoryItemResults(List.of(_inventory)));
        } else {
          emit(InventoryItemResults(List.of(_inventory), isAtEnd: true));
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
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
