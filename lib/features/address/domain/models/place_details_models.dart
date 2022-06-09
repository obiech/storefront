import 'package:equatable/equatable.dart';
import 'package:storefront_app/features/address/index.dart';

/// [AddressDetailsModel] with longitude & latitude
class PlaceDetailsModel extends Equatable {
  final String name;
  final AddressDetailsModel addressDetails;
  final double lat;
  final double lng;

  const PlaceDetailsModel({
    required this.name,
    required this.addressDetails,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [
        name,
        addressDetails,
        lat,
        lng,
      ];
}
