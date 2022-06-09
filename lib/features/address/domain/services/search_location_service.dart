import 'package:dartz/dartz.dart';
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
}
