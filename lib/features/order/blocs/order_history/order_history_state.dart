part of 'order_history_cubit.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}

/// Default Order History State
class OrderHistoryInitial extends OrderHistoryState {}

/// When [OrderModel]s are being loaded from local / remote data source
class OrderHistoryLoading extends OrderHistoryState {}

/// Default Order History State
class OrderHistoryLoaded extends OrderHistoryState {
  const OrderHistoryLoaded(this.orders);

  /// List of user's order models
  final List<OrderModel> orders;
}

/// When an error occured while loading [OrderModel]
class OrderHistoryLoadingError extends OrderHistoryState {
  const OrderHistoryLoadingError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
