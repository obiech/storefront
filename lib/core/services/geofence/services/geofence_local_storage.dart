import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:storefront_app/core/services/geofence/models/darkstore_metadata.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';

import '../../../core.dart';
import '../models/dropezy_polygon.dart';

@LazySingleton(as: IGeofenceLocalPersistence)
class GeofencelocalPersistence implements IGeofenceLocalPersistence {
  final Box<DropezyPolygon> _prefBox;
  final IPrefsRepository localStorage;

  GeofencelocalPersistence(
    @Named(GEOFENCE_PREF_BOX) this._prefBox,
    this.localStorage,
  );

  final _controller = BehaviorSubject<Set<DropezyPolygon>>.seeded(const {});

  @visibleForTesting
  @override
  Set<DropezyPolygon> getGeofencePolygons() {
    try {
      final polys = _prefBox.values.toSet();
      addToStream(polys);
      return polys;
    } catch (e) {
      addToStream(const {});
      return <DropezyPolygon>{};
    }
  }

  @override
  Future<void> updateGeofencePolygon(List<DropezyPolygon> polys) async {
    await _prefBox.clear();
    await _prefBox.putAll(polys.asMap());
    getGeofencePolygons();
  }

  @visibleForTesting
  @override
  Future<void> deleteGeofencePolygons() async {
    await _prefBox.clear();
    _controller.drain();
  }

  @override
  Stream<Set<DropezyPolygon>> get polygons =>
      _controller.stream.asBroadcastStream();

  @override
  void addToStream(Set<DropezyPolygon> polys) => _controller.sink.add(polys);

  @override
  Future<bool> shouldRefresh(
    DarkStoresMetadata metadata,
  ) async {
    try {
      final res = localStorage.getMetaData();
      if (res == null) {
       await localStorage.setMetaData(metadata);
        return true;
      }
      if (res.isTheSameWith(metadata)) return false;

      await localStorage.deleteMetaData();
      await localStorage.setMetaData(metadata);
      return true;
    } catch (e) {
      return true;
    }
  }
}
