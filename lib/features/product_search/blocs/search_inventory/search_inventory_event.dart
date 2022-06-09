part of 'search_inventory_bloc.dart';

abstract class SearchInventoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Search product with [query] from inventory
/// of Dark Store identified by [storeId]
class SearchInventory extends SearchInventoryEvent {
  final String query;
  final String storeId;

  SearchInventory(this.query, this.storeId);

  @override
  List<Object?> get props => [query, storeId];
}

/// Load more products from inventory
class LoadMoreItems extends SearchInventoryEvent {}

/// Search product with previous query from inventory
/// but with [storeId] as the new Dark Store for reference.
///
/// Use when store serving the user has changed.
class ChangeInventoryStore extends SearchInventoryEvent {
  final String storeId;

  ChangeInventoryStore(this.storeId);

  @override
  List<Object?> get props => [storeId];
}
