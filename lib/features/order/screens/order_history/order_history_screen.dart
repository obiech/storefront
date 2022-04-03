import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/_exporter.dart';
import '../../../../core/utils/build_context.ext.dart';
import '../../blocs/blocs.dart';
import '../../widgets/order_history/list.dart';

part 'keys.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  static const routeName = 'order-history';

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.myOrders,
      childPadding: context.res.dimens.spacingMedium,
      child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        builder: _mapStateToWidget,
      ),
    );
  }

  Widget _mapStateToWidget(BuildContext context, OrderHistoryState state) {
    if (state is OrderHistoryLoading) {
      // TODO (leovinsen): Implement skeleton loader
      return const Center(
        key: ValueKey(OrderHistoryKeys.loadingWidget),
        child: CircularProgressIndicator(),
      );
    } else if (state is OrderHistoryLoaded) {
      return state.orders.isNotEmpty
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
      return Center(
        key: const ValueKey(OrderHistoryKeys.errorWidget),
        child: Text(
          state.message,
          style: context.res.styles.caption1,
        ),
      );
    }

    return Container();
  }
}
