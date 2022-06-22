import 'package:injectable/injectable.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

import '../models/dropezy_latlng.dart';
import '../models/dropezy_polygon.dart';
import '../repository/i_geofence_repository.dart';

@LazySingleton(as: IGeofenceRepository)
class GeofenceRepository implements IGeofenceRepository {
  // The polygon is always considered closed, regardless of whether the last
  //  point equals the first or not.
  @override
  bool containsLocation({
    required DropezyLatLng point,
    required DropezyPolygon polygon,
    bool geodesic = true,
  }) {
    return PolygonUtil.containsLocation(
      point.latLngMapsToolKit,
      polygon.listLatLngMapsToolKit,
      geodesic,
    );
  }
}
