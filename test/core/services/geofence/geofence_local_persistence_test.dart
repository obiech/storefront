import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_latlng.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_polygon.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';
import 'package:storefront_app/core/services/geofence/services/geofence_local_storage.dart';

class MockGeofenceBox extends Mock implements Box<DropezyPolygon> {}

void main() {
  late Box<DropezyPolygon> _prefBox;
  late IGeofenceLocalPersistence repo;

  final polygonModel = DropezyPolygon(
    id: 'id',
    points: [const DropezyLatLng(1.0, 0.0)],
  );

  setUp(() {
    _prefBox = MockGeofenceBox();
    repo = GeofencelocalPersistence(_prefBox);
  });

  test(
      'Should return Dropezy Polygons '
      'when getGeofencePolygons() is called', () async {
    when(() => _prefBox.values).thenReturn([polygonModel]);

    final result = await repo.getGeofencePolygons();
    expect(result, {polygonModel});
    verify(() => _prefBox.values).called(1);
  });

  test(
      'Should return empty set '
      'when getGeofencePolygons is called '
      'But error is throw', () async {
    when(() => _prefBox.values).thenThrow(Exception('Error'));

    final result = await repo.getGeofencePolygons();
    expect(result, <DropezyPolygon>{});
    verify(() => _prefBox.values).called(1);
  });

  test(
      'Should delete previous stored Polygons '
      'and store the new polygons '
      'when updateGeofencePolygons is called', () async {
    when(() => _prefBox.putAll([polygonModel].asMap()))
        .thenAnswer((invocation) async => Future.value());
    when(() => _prefBox.clear()).thenAnswer((invocation) => Future.value(1));

    await repo.updateGeofencePolygon([polygonModel]);
    verify(() => _prefBox.clear()).called(1);

    verify(() => _prefBox.putAll([polygonModel].asMap())).called(1);
  });

  test(
      'Should delete polygons from storage '
      'when deleteGeofencePolygons is called', () async {
    when(() => _prefBox.clear()).thenAnswer((invocation) => Future.value(1));

    await repo.deleteGeofencePolygons();

    verify(() => _prefBox.clear()).called(1);
  });
}
