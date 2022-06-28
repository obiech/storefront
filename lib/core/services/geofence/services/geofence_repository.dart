import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/core/services/geofence/models/darkstore_metadata.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';

import '../models/dropezy_latlng.dart';
import '../models/dropezy_polygon.dart';
import '../repository/i_geofence_repository.dart';

@LazySingleton(as: IGeofenceRepository)
class GeofenceRepository implements IGeofenceRepository {
  final DiscoveryServiceClient _discoveryServiceClient;
  final IGeofenceLocalPersistence localPersistence;

  GeofenceRepository(this._discoveryServiceClient, this.localPersistence);
  // The polygon is always considered closed, regardless of whether the last
  //  point equals the first or not.
  @override
  @visibleForTesting
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

  @override
  bool scanMultiplePolygon({
    required DropezyLatLng point,
    required Set<DropezyPolygon> polys,
  }) {
    return polys
        .any((polygon) => containsLocation(point: point, polygon: polygon));
  }
  
  // It is used to fetch geofence from backend.
  // Instead of calling this method directly, we should call
  // the getUpatedGeofences() 
  @protected
  @visibleForTesting
  RepoResult<List<DropezyPolygon>> getGeofences() async {
    try {
      final response =
          await _discoveryServiceClient.getGeofences(GetGeofencesRequest());
      final res =
          response.geofences.map((e) => DropezyPolygon.fromPb(e)).toList();
      await localPersistence.updateGeofencePolygon(res);
      return Right(res);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
  
  // It is used to get DarkStoreMetadata from the backend.
  // GetUpdatedGeofences() should be called instead of this method.
  @protected
  @visibleForTesting
  RepoResult<DarkStoresMetadata> getMetaData() async {
    try {
      final response =
          await _discoveryServiceClient.getMetadata(GetMetadataRequest());
      final res = DarkStoresMetadata.fromPb(response.metadata);
      return Right(res);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  RepoResult<Set<DropezyPolygon>> getUpdatedGeofences() async {
    try {
      final metaData = await getMetaData();
      if (metaData.isLeft()) {
        return Left(metaData.getLeft());
      }

      final bool shouldRefresh =
          await localPersistence.shouldRefresh(metaData.getRight());
      if (!shouldRefresh) {
        return Right(localPersistence.getGeofencePolygons());
      }
      final res = await getGeofences();
      if (res.isLeft()) {
        return Left(res.getLeft());
      }
      return Right(res.getRight().toSet());
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
