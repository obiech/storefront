part of 'order_history_screen.dart';

class OrderHistoryScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const OrderHistoryScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderHistoryCubit>()..fetchUserOrderHistory(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const OrderHistoryScreen();
  }
}
