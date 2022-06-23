import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

part 'order_details_state.dart';

/// [Cubit] responsible for fetching [OrderModel] and emitting them to UI via
/// [OrderDetailsState].
///
@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this.orderRepository) : super(InitialOrderDetails());

  final IOrderRepository orderRepository;
  Timer? _timer;

  Future<void> getUserOrderDetails(String id) async {
    emit(LoadingOrderDetails());

    final result = await orderRepository.getOrderById(id, refresh: true);

    final state = result.fold(
      (failure) => LoadingErrorOrderDetails(failure.message),
      (order) {
        checkOrderStatus(order);
        return LoadedOrderDetails(order);
      },
    );

    emit(state);
  }

  void checkOrderStatus(OrderModel order) {
    if (order.status != OrderStatus.unspecified &&
        order.status != OrderStatus.arrived &&
        order.status != OrderStatus.failed) {
      startRefreshTimer(order.id);
    }
  }

  /// Function for starting refresh in periodic time
  /// whenever the status is not :
  /// - Arrived
  /// - Failed
  /// - Unspecified
  void startRefreshTimer(String id) {
    int start = 15;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (start == 0) {
          timer.cancel();
          await getUserOrderDetails(id);
        } else {
          start--;
        }
      },
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
