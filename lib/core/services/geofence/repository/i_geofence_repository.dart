import '../models/dropezy_latlng.dart';
import '../models/dropezy_polygon.dart';

abstract class IGeofenceRepository {
  /// Computes whether the given point lies inside the specified polygon.
  ///
  /// The polygon is formed of circle segments if geodesic
  /// is true, and of rhumb segments otherwise.
  bool containsLocation({
    required DropezyLatLng point,
    required DropezyPolygon polygon,
    bool geodesic,
  });
}
