import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/core/services/geofence/models/darkstore_metadata.dart';

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

  /// helper method to simplify calling [containsLocation] for
  /// multiple polygons.
  bool scanMultiplePolygon({
    required DropezyLatLng point,
    required Set<DropezyPolygon> polys,
  });
  
  /// It Is Used to get the most recent Geofence data from backend
  /// 
  /// It fetches new geofence only if the exisitng DarkStoreMetadata
  /// is different from the DarkStoreMetadata gotten from the backend.
  /// Hence it is save to call this method multiple times. 
  RepoResult<Set<DropezyPolygon>> getUpdatedGeofences();
}
