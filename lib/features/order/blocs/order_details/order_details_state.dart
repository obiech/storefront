part of 'order_details_cubit.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

/// Default Order Details State
class InitialOrderDetails extends OrderDetailsState {}

/// When [OrderModel] is being loaded from local / remote data source
class LoadingOrderDetails extends OrderDetailsState {}

/// Loaded Order Details State
class LoadedOrderDetails extends OrderDetailsState {
  const LoadedOrderDetails(this.order);

  /// Selected order model
  final OrderModel order;

  @override
  List<Object> get props => [order];
}

/// When an error occured while loading [OrderModel]
class LoadingErrorOrderDetails extends OrderDetailsState {
  const LoadingErrorOrderDetails(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
