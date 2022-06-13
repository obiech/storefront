part of 'address_detail_page.dart';

class AddressDetailPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const AddressDetailPageWrapper({
    Key? key,
    this.placeDetails,
  }) : super(key: key);

  final PlaceDetailsModel? placeDetails;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddressDetailBloc>()
        ..add(
          LoadAddressDetail(placeDetailsModel: placeDetails),
        ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AddressDetailPage();
  }
}
