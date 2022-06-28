import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/core/services/geofence/models/darkstore_metadata.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_latlng.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_polygon.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';
import 'package:storefront_app/core/services/geofence/services/geofence_local_storage.dart';


class MockGeofenceBox extends Mock implements Box<DropezyPolygon> {}

class MockDarkStorePrefBox extends Mock implements Box {}

class MockIPrefsRepository extends Mock implements IPrefsRepository {}

void main() {
  late Box<DropezyPolygon> _prefBox;
  late IGeofenceLocalPersistence repo;
  late IPrefsRepository prefsRepository;

  final polygonModel = DropezyPolygon(
    id: 'id',
    points: [const DropezyLatLng(1.0, 0.0)],
    name: 'MockName',
    storeId: 'MockStoreId',
  );

  setUp(() {
    _prefBox = MockGeofenceBox();
    prefsRepository = MockIPrefsRepository();
    repo = GeofencelocalPersistence(_prefBox, prefsRepository);
  });

  setUpAll(() {
    registerFallbackValue(DarkStoresMetadata(DateTime.now()));
  });

  test(
      'Should return Dropezy Polygons '
      'when getGeofencePolygons() is called', () async {
    when(() => _prefBox.values).thenReturn([polygonModel]);

    final result = repo.getGeofencePolygons();
    expect(result, {polygonModel});
    verify(() => _prefBox.values).called(1);
  });

  test(
      'Should return empty set '
      'when getGeofencePolygons is called '
      'But error is throw', () async {
    when(() => _prefBox.values).thenThrow(Exception('Error'));

    final result = repo.getGeofencePolygons();
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

  test('should return true '
        'when the stored DarkStoreMetadata is different from '
        'the metadata from backend', () async {
    final metaData = DarkStoresMetadata(DateTime.now());
    final otherMetaData = DarkStoresMetadata(DateTime(2026));
    when(() => prefsRepository.getMetaData()).thenReturn(metaData);
    
    when(() => prefsRepository.deleteMetaData())
        .thenAnswer((invocation) => Future.value());
    when(() => prefsRepository.setMetaData(metaData))
        .thenAnswer((invocation) => Future.value());

    final res = await repo.shouldRefresh(otherMetaData);
    expect(res, true);
    verify(() => prefsRepository.getMetaData()).called(1);
    verify(() => prefsRepository.setMetaData(otherMetaData)).called(1);
    verify(() => prefsRepository.deleteMetaData()).called(1);
    
  });

  test('should return false '
        'when the stored DarkStoreMetadata is the same with '
        'the metadata from backend', () async {
    final metaData = DarkStoresMetadata(DateTime.now());
    when(() => prefsRepository.getMetaData()).thenReturn(metaData);
    
    when(() => prefsRepository.deleteMetaData())
        .thenAnswer((invocation) => Future.value());
    when(() => prefsRepository.setMetaData(metaData))
        .thenAnswer((invocation) => Future.value());

    final res = await repo.shouldRefresh(metaData);
    expect(res, false);
    verify(() => prefsRepository.getMetaData()).called(1);
    
  });

   test('should return true '
        'when there is no locally stored DarkstoreMetaData ', () async {
    final metaData = DarkStoresMetadata(DateTime.now());
    when(() => prefsRepository.getMetaData()).thenReturn(null);
    
    when(() => prefsRepository.setMetaData(metaData))
        .thenAnswer((invocation) => Future.value());

    final res = await repo.shouldRefresh(metaData);
    expect(res, true);
    verify(() => prefsRepository.getMetaData()).called(1);
    verify(() => prefsRepository.setMetaData(metaData)).called(1);
    verifyNever(() => prefsRepository.deleteMetaData());
    
  });

  test('should return true '
        'when an Error occurs fetching DarkstoreMetadata ', () async {
    final metaData = DarkStoresMetadata(DateTime.now());
    when(() => prefsRepository.getMetaData()).thenThrow(Exception());

    final res = await repo.shouldRefresh(metaData);
    expect(res, true);
    verify(() => prefsRepository.getMetaData()).called(1);
    verifyNever(() => prefsRepository.setMetaData(metaData));
    verifyNever(() => prefsRepository.deleteMetaData());
    
  });
}
