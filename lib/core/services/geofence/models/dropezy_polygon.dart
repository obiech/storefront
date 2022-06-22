import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

import '../../../core.dart';
import 'dropezy_latlng.dart';

part 'dropezy_polygon.g.dart';

@HiveType(typeId: HiveTypeIds.dropezyPolygon)
class DropezyPolygon {
  @HiveField(DropezyPolygonHiveFieldIds.id)
  final String id;
  @HiveField(DropezyPolygonHiveFieldIds.points)
  List<DropezyLatLng> points;

  DropezyPolygon({
    required this.id,
    this.points = const [],
  });

  factory DropezyPolygon.fromMap(final Map map) {
    return DropezyPolygon(
      id: map['id'],
      points: (map['points'] as List)
          .cast<Map>()
          .map(DropezyLatLng.fromMap)
          .toList()
          .cast(),
    );
  }

  Map toMap() {
    return {
      'id': id,
      'points': points.map((e) => e.toMap()).toList(),
    };
  }

  Polygon get polygon {
    return Polygon(
      polygonId: PolygonId(id),
      points: points.map((e) => e.latLangGoogleMap).toList(),
      strokeWidth: 2,
    );
  }

  List<maps_toolkit.LatLng> get listLatLngMapsToolKit =>
      [...points.map((e) => maps_toolkit.LatLng(e.latitude, e.longitude))];

  void addPoint(DropezyLatLng latLng) {
    points.add(latLng);
  }
}
