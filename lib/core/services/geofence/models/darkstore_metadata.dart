import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core.dart';

@HiveType(typeId: HiveTypeIds.darkStoresMetadata)
class DarkStoresMetadata extends Equatable {

  /// This is used to record the last time the [DropezyPolygon] were updated.
  ///
  /// It is used to know if the locally stored [DropezyPolygon] data is
  /// the current.
  @HiveField(DarkStoresMetadataFields.lastUpdated)
  final DateTime lastUpdated;

  const DarkStoresMetadata(this.lastUpdated);

  factory DarkStoresMetadata.fromPb(Metadata metaData) {
    return DarkStoresMetadata(metaData.lastUpdated.toDateTime());
  }
  

  @override
  List<Object?> get props => [lastUpdated];

  /// Returns true if [this] occurs at the same moment as [other]. 
  bool isTheSameWith(DarkStoresMetadata other) =>
      lastUpdated.isAtSameMomentAs(other.lastUpdated);
}
