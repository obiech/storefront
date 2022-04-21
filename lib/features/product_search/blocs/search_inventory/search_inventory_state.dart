part of 'search_inventory_cubit.dart';

abstract class SearchInventoryState extends Equatable {
  const SearchInventoryState();

  @override
  List<Object> get props => [];
}

/// Initial state for inventory search
class SearchInventoryInitial extends SearchInventoryState {}

/// When the search request is sent and we are waiting
/// for network response, this state will be activated
class SearchingForItemInInventory extends SearchInventoryState {}

/// When an error occurs during the inventory search
/// this state will be activated with
/// a meaningful message to the user
class ErrorOccurredSearchingForItem extends SearchInventoryState {
  final String message;

  const ErrorOccurredSearchingForItem(this.message);

  @override
  List<Object> get props => [message];
}

/// When inventory items are returned from the network request,
/// this state will be activated with a full list of items
class InventoryItemResults extends SearchInventoryState {
  /// Search Results
  final List<ProductModel> results;

  /// If inventory has reached last page
  final bool isAtEnd;

  const InventoryItemResults(
    this.results, {
    this.isAtEnd = false,
  });

  @override
  List<Object> get props => [results];
}
