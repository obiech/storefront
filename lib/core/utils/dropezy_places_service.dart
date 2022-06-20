import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:injectable/injectable.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';
import 'package:uuid/uuid.dart';

/// [PlacesService] with initialized Maps Api Key
@lazySingleton
class DropezyPlacesService extends PlacesService {
  late GoogleMapsPlaces _places;
  final _uuid = const Uuid();

  String? _sessionToken;
  bool _resetSessionTokenForNextAutoComplete = false;

  static const _radius = 50;

  /// Returns the session token last used to get auto-complete results from the
  /// Places API
  @override
  String? get sessionToken => _sessionToken;

  DropezyPlacesService() : super() {
    initialize(apiKey: MapsConfig.mapsApiKey);
    _places = GoogleMapsPlaces(apiKey: MapsConfig.mapsApiKey);
  }

  /// Gets auto complete results from the GoogleMapsApi
  ///
  /// Returns List of [PlacesAutoCompleteResult] or a [String] for a friendly error message
  @override
  Future<List<PlacesAutoCompleteResult>> getAutoComplete(
    String input, {
    String country = 'id',
  }) async {
    if (_sessionToken == null || _resetSessionTokenForNextAutoComplete) {
      // Set reset back to false. We only want a new session when the user has selected`
      // a place. Which for us means getPlaceDetails has been called.
      _resetSessionTokenForNextAutoComplete = false;

      // Generate a new session token
      _sessionToken = _uuid.v4();
    }

    try {
      final response = await _places.autocomplete(
        input,
        components: [
          Component('country', country),
        ],
        sessionToken: _sessionToken,
      );

      if (response.isOkay) {
        final results = response.predictions.where((prediction) {
          final address =
              prediction.structuredFormatting?.mainText.split(' ').first;
          return address != null;
        }).map((prediction) {
          return PlacesAutoCompleteResult(
            placeId: prediction.placeId,
            description: prediction.description,
            mainText: prediction.structuredFormatting?.mainText,
            secondaryText: prediction.structuredFormatting?.secondaryText,
          );
        });

        return results.toList();
      } else {
        throw PlacesApiException(
          message: 'Could not get places from Google Maps',
        );
      }
    } catch (exception) {
      const errorMessage = 'A problem occurred making the places request.';
      throw PlacesApiException(message: errorMessage, exception: exception);
    }
  }

  /// Method to get [PlaceDetailsModel] from Places API
  ///
  /// Please use this instead of incomplete [getPlaceDetails] method
  /// PS: Open to name suggestion to distinct between these two
  Future<PlaceDetailsModel> getPlaceDetailsModel(String placeId) async {
    try {
      final response = await _places.getDetailsByPlaceId(placeId);

      if (response.isOkay) {
        final details = response.result;

        // Indicate token reset on next auto complete request
        _resetSessionTokenForNextAutoComplete = true;

        return PlaceDetailsModel(
          name: response.result.name,
          addressDetails: AddressDetailsModel(
            street: _getLongNameFromComponent(details, 'route'),
            subDistrict: _getLongNameFromComponent(
              details,
              'administrative_area_level_4',
            ),
            district: _getLongNameFromComponent(
              details,
              'administrative_area_level_3',
            ),
            municipality: _getLongNameFromComponent(
              details,
              'administrative_area_level_2',
            ),
            zipCode: _getShortNameFromComponent(details, 'postal_code'),
            province: _getLongNameFromComponent(
              details,
              'administrative_area_level_1',
            ),
            country: _getLongNameFromComponent(details, 'country'),
          ),
          lat: response.result.geometry!.location.lat,
          lng: response.result.geometry!.location.lng,
        );
      } else {
        throw PlacesApiException(
          message: 'Could not get places from Google Maps',
        );
      }
    } catch (exception) {
      const errorMessage = 'A problem occurred making the places request.';
      throw PlacesApiException(message: errorMessage, exception: exception);
    }
  }

  Future<PlaceDetailsModel> getPlaceDetailsFromLocation(LatLng latLng) async {
    try {
      final response = await _places.searchNearbyWithRadius(
        Location(lat: latLng.latitude, lng: latLng.longitude),
        _radius,
      );

      if (response.isOkay) {
        final placeIds =
            response.results.map((result) => result.placeId).toList();

        // Return the first nearby place
        return getPlaceDetailsModel(placeIds.first);
      } else {
        throw PlacesApiException(
          message: 'Could not get places from Google Maps',
        );
      }
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
