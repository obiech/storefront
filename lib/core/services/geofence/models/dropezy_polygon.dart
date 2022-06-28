import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:hive/hive.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

import '../../../core.dart';
import 'dropezy_latlng.dart';

part 'dropezy_polygon.g.dart';

@HiveType(typeId: HiveTypeIds.dropezyPolygon)
class DropezyPolygon {
  /// The [DropezyPolygon] id.
  @HiveField(DropezyPolygonHiveFieldIds.id)
  final String id;

  /// The vertices of this [DropezyPolygon].
  @HiveField(DropezyPolygonHiveFieldIds.points)
  List<DropezyLatLng> points;

  /// The [DropezyPolygon] name.
  @HiveField(DropezyPolygonHiveFieldIds.name)
  String? name;

  /// The id of the store attached to this [DropezyPolygon]
  @HiveField(DropezyPolygonHiveFieldIds.storeId)
  String? storeId;

  DropezyPolygon({
    required this.id,
    this.points = const [],
    required this.name,
    required this.storeId,
  });
  
  factory DropezyPolygon.fromPb(Geofence geofence) {
    return DropezyPolygon(
        id: geofence.geofenceId,
        name: geofence.name,
        storeId: geofence.storeId,
        points: geofence.vertices
            .map((e) => DropezyLatLng(e.latitude, e.longitude))
            .toList(),
        );
  }

  List<maps_toolkit.LatLng> get listLatLngMapsToolKit =>
      [...points.map((e) => maps_toolkit.LatLng(e.latitude, e.longitude))];

}
