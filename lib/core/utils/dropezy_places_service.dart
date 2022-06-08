import 'package:injectable/injectable.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';

/// [PlacesService] with initialized Maps Api Key
@lazySingleton
class DropezyPlacesService extends PlacesService {
  DropezyPlacesService() : super() {
    initialize(apiKey: MapsConfig.mapsApiKey);
  }
}
