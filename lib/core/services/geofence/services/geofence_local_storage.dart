import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';

import '../../../core.dart';
import '../models/dropezy_polygon.dart';

class GeofencelocalPersistence implements IGeofenceLocalPersistence {
  final Box<DropezyPolygon> _prefBox;

  GeofencelocalPersistence(@Named(GEOFENCE_PREF_BOX) this._prefBox);

  @override
  Future<Set<DropezyPolygon>> getGeofencePolygons() async {
    try {
      return _prefBox.values.toSet();
    } catch (e) {
      return <DropezyPolygon>{};
    }
  }

  @override
  Future<void> updateGeofencePolygon(List<DropezyPolygon> polys) async {
    await _prefBox.clear();
    await _prefBox.putAll(polys.asMap());
  }

  @override
  Future<void> deleteGeofencePolygons() async {
    await _prefBox.clear();
  }
}
