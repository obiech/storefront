import 'package:google_maps_webservice/places.dart';
import 'package:injectable/injectable.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

/// [PlacesService] with initialized Maps Api Key
@lazySingleton
class DropezyPlacesService extends PlacesService {
  late GoogleMapsPlaces _places;

  DropezyPlacesService() : super() {
    initialize(apiKey: MapsConfig.mapsApiKey);
    _places = GoogleMapsPlaces(apiKey: MapsConfig.mapsApiKey);
  }

  /// Method to get [PlaceDetailsModel] from Places API
  ///
  /// Please use this instead of incomplete [getPlaceDetails] method
  /// PS: Open to name suggestion to distinct between these two
  Future<PlaceDetailsModel> getPlaceDetailsModel(String placeId) async {
    try {
      final response = await _places.getDetailsByPlaceId(placeId);

      final details = response.result;

      return PlaceDetailsModel(
        name: response.result.name,
        addressDetails: AddressDetailsModel(
          street: _getLongNameFromComponent(details, 'route'),
          subDistrict:
              _getLongNameFromComponent(details, 'administrative_area_level_4'),
          district:
              _getLongNameFromComponent(details, 'administrative_area_level_3'),
          municipality:
              _getLongNameFromComponent(details, 'administrative_area_level_2'),
          zipCode: _getShortNameFromComponent(details, 'postal_code'),
          province:
              _getLongNameFromComponent(details, 'administrative_area_level_1'),
          country: _getLongNameFromComponent(details, 'country'),
        ),
        lat: response.result.geometry!.location.lat,
        lng: response.result.geometry!.location.lng,
      );
    } catch (exception) {
      const errorMessage = 'A problem occurred making the places request.';
      throw PlacesApiException(message: errorMessage, exception: exception);
    }
  }

  String? _getLongNameFromComponent(PlaceDetails details, String type) {
    try {
      return details.addressComponents
          .firstWhere((component) => component.types.contains(type))
          .longName;
    } catch (_) {
      return null;
    }
  }

  String? _getShortNameFromComponent(PlaceDetails details, String type) {
    try {
      return details.addressComponents
          .firstWhere((component) => component.types.contains(type))
          .shortName;
    } catch (_) {
      return null;
    }
  }
}
