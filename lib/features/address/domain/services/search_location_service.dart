import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

@LazySingleton(as: ISearchLocationRepository)
class SearchLocationService implements ISearchLocationRepository {
  final DropezyPlacesService _placesService;

  SearchLocationService(this._placesService);

  @override
  RepoResult<List<PlacesAutoCompleteResult>> searchLocation(
    String query,
  ) async {
    try {
      final searchResult = await _placesService.getAutoComplete(query);

      return right(searchResult);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  /// Gets a [PlaceDetailsModel] from a given Google Place ID [id]
  @override
  RepoResult<PlaceDetailsModel> getLocationDetail(String id) async {
    try {
      final addressDetail = await _placesService.getPlaceDetailsModel(id);

      return right(addressDetail);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  /// Gets a [PlaceDetailsModel] from a given coordinates [latLng]
  @override
  RepoResult<PlaceDetailsModel> getCurrentLocation(LatLng latLng) async {
    try {
      final placeDetails =
          await _placesService.getPlaceDetailsFromLocation(latLng);

      return right(placeDetails);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
