part of 'address_detail_page.dart';

// TODO: rename to AddressDetailPageWrapper
class AddressDetailScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const AddressDetailScreenWrapper({Key? key}) : super(key: key);

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
