import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/_exporter.dart';
import '../../../../core/utils/build_context.ext.dart';
import '../../../../di/injection.dart';
import '../../../cart_checkout/widgets/cart_summary/cart_summary.dart';
import '../../blocs/blocs.dart';
import '../../widgets/order_history/list.dart';

part 'keys.dart';
part 'wrapper.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.myOrders,
      floatingActionButton: const CartSummary(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        builder: _mapStateToWidget,
      ),
    );
  }

  // TODO (leovinsen): Rewrite into non-function widget
  Widget _mapStateToWidget(BuildContext context, OrderHistoryState state) {
    late Widget child;

    if (state is OrderHistoryLoading) {
      // TODO (leovinsen): Implement skeleton loader
      child = const Center(
        key: ValueKey(OrderHistoryKeys.loadingWidget),
        child: CircularProgressIndicator(),
      );
    } else if (state is OrderHistoryLoaded) {
      child = state.orders.isNotEmpty
          // TODO (leovinsen): Improve UI for 'No Orders' state
          ? OrderHistoryList(
              key: const ValueKey(OrderHistoryKeys.orderListWidget),
              orders: state.orders,
            )
          : Center(
              key: const ValueKey(OrderHistoryKeys.noOrdersWidget),
              child: Text(
                'No Orders',
                style: context.res.styles.caption1,
              ),
            );
    } else if (state is OrderHistoryLoadingError) {
      //TODO (leovinsen): Improve UI for displaying error
      child = Center(
        key: const ValueKey(OrderHistoryKeys.errorWidget),
        child: DropezyEmptyState(
          message: state.message,
          showRetry: true,
          onRetry: () async => _onRefresh(context, state),
        ),
      );
    } else {
      child = const SizedBox.shrink();
    }

    return RefreshIndicator(
      child: child,
      onRefresh: () async => _onRefresh(context, state),
    );
  }

  void _onRefresh(BuildContext context, OrderHistoryState state) {
    if (state is! OrderHistoryLoading) {
      context.read<OrderHistoryCubit>().fetchUserOrderHistory();
    }
  }
}
