import 'package:storefront_app/features/address/index.dart';

/// Class to store all unique hive type ids for the models
class HiveTypeIds {
  static const searchLocationHistoryQuery = 1;
  static const placeModel = 2;
  static const dropezyPolygon = 3;
  static const dropezyLatLng = 4;
  static const darkStoresMetadata = 5;
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

/// Unique [DropezyPolygon] hive fields ids
class DropezyPolygonHiveFieldIds {
  static const id = 1;
  static const points = 2;
  static const name = 3;
  static const storeId = 4;
}

/// Unique [DropezyLatLng] hive fields ids
class DropezyLatLngHiveFieldIds {
  static const latitude = 1;
  static const longitude = 2;
}

class DarkStoresMetadataFields {
  static const lastUpdated = 1;
}
