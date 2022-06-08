import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';

abstract class ISearchLocationRepository {
  RepoResult<List<PlacesAutoCompleteResult>> searchLocation(String query);
}
