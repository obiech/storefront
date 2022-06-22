import '../models/dropezy_polygon.dart';

abstract class IGeofenceLocalPersistence {
  /// Get Geofence Polygons.
  ///
  /// It returns an empty [Set] if no polygon is found.
  Future<Set<DropezyPolygon>> getGeofencePolygons();

  /// Updates [GeofencePolygons].
  ///
  /// It deletes any previously stored [DropezyPolygon]'s
  /// before storing this data. It is safe to call even when there's
  /// previous data.
  Future<void> updateGeofencePolygon(List<DropezyPolygon> polys);

  Future<void> deleteGeofencePolygons();
}
