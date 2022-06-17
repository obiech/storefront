import 'package:storefront_app/features/address/index.dart';

/// Class to store all unique hive type ids for the models
class HiveTypeIds {
  static const searchLocationHistoryQuery = 1;
  static const placeModel = 2;
}

/// Unique [SearchLocationHistoryQuery] hive fields ids
class SearchHistoryQueryModelHiveFieldIds {
  static const placeModel = 1;
  static const createdAt = 2;
}

/// Unique [PlaceModel] hive fields ids
class PlaceModelHiveFieldIds {
  static const placeId = 1;
  static const mainText = 2;
  static const description = 3;
  static const secondaryText = 4;
}
