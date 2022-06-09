import 'package:places_service/places_service.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

import 'delivery_address_models.dart';

final placesResultList = [
  PlacesAutoCompleteResult(
    placeId: '1',
    mainText: 'Jalan Kebon Jeruk I',
    description:
        'Jl. Rawa Belong, Palmerah, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta, Indonesia',
  ),
  PlacesAutoCompleteResult(
    placeId: '2',
    mainText: 'Kompleks Kebon Jeruk blok V',
    description:
        'Jl. Palmerah Raya IV, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta, Indonesia',
  ),
  PlacesAutoCompleteResult(
    placeId: '3',
    mainText: 'Kebon Jeruk Raya',
    description:
        'Jl. Palmerah Raya IV, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta, Indonesia',
  ),
];

final placeDetails = PlaceDetailsModel(
  name: sampleDeliveryAddressList[0].title,
  addressDetails: sampleDeliveryAddressList[0].details!,
  lat: sampleDeliveryAddressList[0].lat,
  lng: sampleDeliveryAddressList[0].lng,
);
