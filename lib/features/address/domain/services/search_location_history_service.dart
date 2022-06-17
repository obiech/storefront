import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

@LazySingleton(as: ISearchLocationHistoryRepository)
class SearchLocationHistoryService extends ISearchLocationHistoryRepository {
  final Box<SearchLocationHistoryQuery> searchHistoryQueryBox;

  final DateTimeProvider _dateTimeProvider;

  SearchLocationHistoryService(
    this.searchHistoryQueryBox,
    this._dateTimeProvider,
  );

  @override
  RepoResult<List<PlaceModel>> getSearchHistory() {
    try {
      final placeList = searchHistoryQueryBox.values
          .map((searchHistory) => searchHistory.placeModel)
          .toList();

      return Future.value(right(placeList));
    } on Exception catch (e) {
      return Future.value(left(e.toFailure));
    }
  }

  @override
  Future<void> addSearchQuery(PlaceModel place) async {
    final searchHistoryQuery = SearchLocationHistoryQuery(
      placeModel: place,
      createdAt: _dateTimeProvider.now,
    );

    await searchHistoryQueryBox.put(place.placeId, searchHistoryQuery);
  }

  @override
  Future<void> removeSearchQuery(PlaceModel place) async {
    await searchHistoryQueryBox.delete(place);
  }

  @override
  Future<void> clearSearchQueries() async {
    await searchHistoryQueryBox.clear();
  }
}
