part of 'order_history_page.dart';

class OrderHistoryPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const OrderHistoryPageWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderHistoryCubit>()..fetchUserOrderHistory(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const OrderHistoryPage();
  }
}
