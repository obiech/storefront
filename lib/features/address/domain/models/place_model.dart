import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';

part 'place_model.g.dart';

/// Model that refers to [PlacesAutoCompleteResult] from [PlacesService] package
///
/// TODO (widy): in the future lets use this model in all of our code
@HiveType(typeId: HiveTypeIds.placeModel)
class PlaceModel extends Equatable {
  @HiveField(PlaceModelHiveFieldIds.placeId)
  final String placeId;
  @HiveField(PlaceModelHiveFieldIds.mainText)
  final String mainText;
  @HiveField(PlaceModelHiveFieldIds.description)
  final String description;
  @HiveField(PlaceModelHiveFieldIds.secondaryText)
  final String secondaryText;

  const PlaceModel({
    required this.placeId,
    required this.mainText,
    required this.description,
    required this.secondaryText,
  });

  factory PlaceModel.fromPlacesService(PlacesAutoCompleteResult place) {
    return PlaceModel(
      placeId: place.placeId ?? '',
      mainText: place.mainText ?? '',
      description: place.description ?? '',
      secondaryText: place.secondaryText ?? '',
    );
  }

  PlacesAutoCompleteResult toPlacesService() {
    return PlacesAutoCompleteResult(
      placeId: placeId,
      mainText: mainText,
      description: description,
      secondaryText: secondaryText,
    );
  }

  @override
  List<Object?> get props => [
        placeId,
        mainText,
        description,
        secondaryText,
      ];
}
