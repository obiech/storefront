import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/order_model.dart';
import '../../domain/repository/i_order_repository.dart';

part 'order_history_state.dart';

/// [Cubit] responsible for fetching [OrderModel] and emitting them to UI via
/// [OrderHistoryState].
///
/// TODO (leovinsen): add filter by status
/// TODO (leovinsen): add pagination / infinite scrolling
@injectable
class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit(this.orderRepository) : super(OrderHistoryInitial());

  final IOrderRepository orderRepository;

  /// Fetches [OrderModel]s from local or remote data source
  Future<void> fetchUserOrderHistory() async {
    emit(OrderHistoryLoading());

    final result = await orderRepository.getUserOrders();

    final state = result.fold(
      (l) => OrderHistoryLoadingError(l.message),
      (r) => OrderHistoryLoaded(r),
    );

    emit(state);
  }
}
