import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

part 'search_history_query.g.dart';

@HiveType(typeId: HiveTypeIds.searchLocationHistoryQuery)
class SearchLocationHistoryQuery extends Equatable {
  @HiveField(SearchHistoryQueryModelHiveFieldIds.placeModel)
  final PlaceModel placeModel;
  @HiveField(SearchHistoryQueryModelHiveFieldIds.createdAt)
  final DateTime createdAt;

  const SearchLocationHistoryQuery({
    required this.placeModel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [placeModel, createdAt];
}
