part of 'address_detail_page.dart';

class AddressDetailPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const AddressDetailPageWrapper({
    Key? key,
    this.placeDetails,
    this.deliveryAddress,
  }) : super(key: key);

  /// When not empty indicating page
  /// to handle create address
  final PlaceDetailsModel? placeDetails;

  /// When not empty indicating page
  /// to handle edit address
  ///
  /// P.S: Prioritize over [placeDetails]
  /// if both values are provided
  final DeliveryAddressModel? deliveryAddress;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddressDetailBloc>()
        ..add(
          deliveryAddress != null
              ? LoadDeliveryAddress(deliveryAddressModel: deliveryAddress!)
              : LoadPlaceDetail(placeDetailsModel: placeDetails),
        ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AddressDetailPage();
  }
}
