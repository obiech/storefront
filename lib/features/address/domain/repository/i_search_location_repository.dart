import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

abstract class ISearchLocationRepository {
  RepoResult<List<PlacesAutoCompleteResult>> searchLocation(String query);
  RepoResult<PlaceDetailsModel> getLocationDetail(String id);
  RepoResult<PlaceDetailsModel> getCurrentLocation(LatLng latLng);
}
