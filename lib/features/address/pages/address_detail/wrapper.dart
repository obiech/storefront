part of 'address_detail_page.dart';

class AddressDetailPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const AddressDetailPageWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddressDetailBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AddressDetailPage();
  }
}
