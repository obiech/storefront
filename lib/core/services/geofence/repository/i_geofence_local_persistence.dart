import 'package:flutter/foundation.dart';

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

  /// Exposes a [Stream] of the most recent [DropezyPolygon]s.
  ///
  /// Other [Bloc]s can subscribe to this [Stream] inorder to get
  /// updated when [DropezyPolygon]s are updated.
  Stream<Set<DropezyPolygon>> get polygons;

  @protected
  void addToStream(Set<DropezyPolygon> items);
}
