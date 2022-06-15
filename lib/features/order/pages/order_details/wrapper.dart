part of 'order_details_page.dart';

class OrderDetailsPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const OrderDetailsPageWrapper({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderDetailsCubit>()..getUserOrderDetails(id),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const OrderDetailsPage();
  }
}
