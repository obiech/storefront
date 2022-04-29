part of 'search_inventory_bloc.dart';

abstract class SearchInventoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Search product from inventory
class SearchInventory extends SearchInventoryEvent {
  final String query;

  SearchInventory(this.query);
}

/// Load more products from inventory
class LoadMoreItems extends SearchInventoryEvent {}
