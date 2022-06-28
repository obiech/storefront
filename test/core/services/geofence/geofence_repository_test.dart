import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/core/services/geofence/models/darkstore_metadata.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_latlng.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_polygon.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';
import 'package:storefront_app/core/services/geofence/services/geofence_repository.dart';

import '../../../src/mock_response_future.dart';

class MockDiscoveryServiceClient extends Mock
    implements DiscoveryServiceClient {}

class MockIGeofenceLocalPersistence extends Mock
    implements IGeofenceLocalPersistence {}

void main() {
  late GeofenceRepository repo;
  late DiscoveryServiceClient discoveryServiceClient;
  late IGeofenceLocalPersistence localPersistence;

  setUp(() {
    discoveryServiceClient = MockDiscoveryServiceClient();
    localPersistence = MockIGeofenceLocalPersistence();
    repo = GeofenceRepository(
      discoveryServiceClient,
      localPersistence,
    );
  });

  setUpAll(() {
    registerFallbackValue(DarkStoresMetadata(DateTime.now()));
  });

  void containsCase(
    DropezyPolygon poly,
    List<DropezyLatLng> yes,
    List<DropezyLatLng> no,
  ) {
    for (final point in yes) {
      expect(
        repo.containsLocation(
          point: point,
          polygon: poly,
        ),
        equals(true),
      );
      expect(
        repo.containsLocation(point: point, polygon: poly, geodesic: false),
        equals(true),
      );
    }
    for (final point in no) {
      expect(
        repo.containsLocation(
          point: point,
          polygon: poly,
        ),
        equals(false),
      );
      expect(
        repo.containsLocation(point: point, polygon: poly, geodesic: false),
        equals(false),
      );
    }
  }

  final DropezyPolygon polygon = DropezyPolygon(
    id: 'Dummy Polygon',
    points: [
      const DropezyLatLng(10, 10),
      const DropezyLatLng(10, 20),
      const DropezyLatLng(20, 20),
      const DropezyLatLng(20, 10),
      const DropezyLatLng(10, 10)
    ],
    name: 'Dummy Name',
    storeId: 'Dummy StoreId',
  );

  final DropezyPolygon emptyPolygon = DropezyPolygon(
    id: 'empty polygon',
    points: [],
    name: '',
    storeId: '',
  );

  test('contains Location for empty polygon', () {
    expect(
      repo.containsLocation(
        point: const DropezyLatLng(1, 1),
        polygon: emptyPolygon,
        geodesic: false,
      ),
      equals(false),
    );
  });

  test('contains Location for multiple polygons', () {
    expect(
      repo.scanMultiplePolygon(
        point: DropezyLatLng(
          polygon.points.first.latitude,
          polygon.points.first.longitude,
        ),
        polys: {emptyPolygon, polygon},
      ),
      equals(true),
    );
  });
  test('does not contain Location for multiple polygons', () {
    expect(
      repo.scanMultiplePolygon(
        point: const DropezyLatLng(0, 0),
        polys: {emptyPolygon, polygon},
      ),
      equals(false),
    );
  });

  test('contains Location with point', () {
    expect(
      repo.containsLocation(
        point: const DropezyLatLng(10, 10),
        polygon: polygon,
      ),
      equals(true),
    );

    expect(
      repo.containsLocation(
        point: const DropezyLatLng(15, 15),
        polygon: polygon,
      ),
      equals(true),
    );
  });

  group(
      'Should determine correctly if the points are inside the polygon '
      'when the polygon ', () {
    test('is empty', () {
      containsCase(
        makePolygon(makeList, []),
        makeList([]),
        makeList([0, 0]),
      );
    });
    test('contains one point', () {
      containsCase(
        makePolygon(makeList, [1, 2]),
        makeList([1, 2]),
        makeList([0, 0]),
      );
    });
    test('contains two points', () {
      containsCase(
        makePolygon(makeList, [1, 2, 3, 5]),
        makeList([1, 2, 3, 5]),
        makeList([0, 0, 40, 4]),
      );
    });
    test('is an arbitrary triangle.', () {
      containsCase(
        makePolygon(
          makeList,
          [0.0, 0.0, 10.0, 12.0, 20.0, 5.0],
        ),
        makeList([10.0, 12.0, 10, 11, 19, 5]),
        makeList([0, 1, 11, 12, 30, 5, 0, -180, 0, 90]),
      );
    });
    test('is Around North Pole.', () {
      containsCase(
        makePolygon(
          makeList,
          [89, 0, 89, 120, 89, -120],
        ),
        makeList([90, 0, 90, 180, 90, -90]),
        makeList([-90, 0, 0, 0]),
      );
    });
    test('is Around South Pole.', () {
      containsCase(
        makePolygon(
          makeList,
          [-89, 0, -89, 120, -89, -120],
        ),
        makeList([90, 0, 90, 180, 90, -90, 0, 0]),
        makeList([-90, 0, -90, 90]),
      );
    });
    test('is over/under segment on meridian and equator.', () {
      containsCase(
        makePolygon(
          makeList,
          [5, 10, 10, 10, 0, 20, 0, -10],
        ),
        makeList([2.5, 10, 1, 0]),
        makeList([15, 10, 0, -15, 0, 25, -1, 0]),
      );
    });
  });

  group('[getGeofences()', () {
    test('should return [List<DropezyPolygon] '
    'when getGeofences() is called', () async {
      when(() => discoveryServiceClient.getGeofences(GetGeofencesRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetGeofencesResponse()),
      );
      when(() => localPersistence.updateGeofencePolygon(any()))
          .thenAnswer((invocation) => Future.value());

      final res = await repo.getGeofences();
      expect(res.isRight(), true);
      expect(res.getRight(), isA<List<DropezyPolygon>>());
    });

    test('should return an error '
    'when an Exception is thrown calling getGeofences()', () async {
      when(() => discoveryServiceClient.getGeofences(GetGeofencesRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetGeofencesResponse()),
      );
      when(() => localPersistence.updateGeofencePolygon(any()))
          .thenAnswer((invocation) => Future.error(Exception('Mock Error')));

      final res = await repo.getGeofences();

      verify(() => localPersistence.updateGeofencePolygon(any())).called(1);
      verify(() => discoveryServiceClient.getGeofences(GetGeofencesRequest()))
          .called(1);

      expect(res.isLeft(), true);
      expect(res.getLeft(), isA<Failure>());
    });
  });

  group('[getMetaData()]', () {
    test('should return the DarkStoreMetaData '
    'when getMetadata() is called', () async {
      when(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetMetadataResponse()),
      );

      final res = await repo.getMetaData();
      verify(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .called(1);

      expect(res.isRight(), true);
      expect(res.getRight(), isA<DarkStoresMetadata>());
    });

    test('should return an error '
    'when an Exception is thrown calling getMetadata()', () async {
      when(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.error(Exception('')),
      );

      final res = await repo.getMetaData();
      verify(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .called(1);

      expect(res.getLeft(), isA<Failure>());
      expect(res.isLeft(), true);
    });
  });

  group('[getUpdatedGeofences()]', () {
    final polygons = {
      DropezyPolygon(id: 'Mock', storeId: 'MockStore id', name: ''),
    };
    test('should return [Set<DropezyPolygon>] '
    'and fetch a Geofence data '
    'when getUpdatedGeofences() is called '
    'and shouldRefresh() returns true', () async {
      
      when(() => localPersistence.shouldRefresh(any()))
          .thenAnswer((invocation) => MockResponseFuture.value(true));
      when(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetMetadataResponse()),
      );
      when(() => localPersistence.updateGeofencePolygon(any()))
          .thenAnswer((invocation) => Future.value());
      when(() => discoveryServiceClient.getGeofences(GetGeofencesRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetGeofencesResponse()),
      );
      

      final res = await repo.getUpdatedGeofences();
      expect(res.getRight(), isA<Set<DropezyPolygon>>());

      verify(() => localPersistence.shouldRefresh(any())).called(1);
      verifyNever(() => localPersistence.getGeofencePolygons());
    });

    test('should return an Error '
    'when getUpdatedGeofences() is called '
    'but an Exception is thrown', () async {
      
       when(() => localPersistence.shouldRefresh(any()))
          .thenAnswer((invocation) => MockResponseFuture.value(true));
      when(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetMetadataResponse()),
      );
      
      when(() => discoveryServiceClient.getGeofences(GetGeofencesRequest()))
          .thenAnswer(
        (invocation) =>  MockResponseFuture.error(Exception()),
      );

      final res = await repo.getUpdatedGeofences();
      expect(res.getLeft(), isA<Failure>());

      verify(() => localPersistence.shouldRefresh(any())).called(1);
      verifyNever(() => localPersistence.getGeofencePolygons());
    });

    test('should return [Set<DropezyPolygon>] '
    'and fetch a Geofence data from local storage '
    'when getUpdatedGeofences() is called '
    'and shouldRefresh() returns false', () async {
      
 when(() => localPersistence.shouldRefresh(any()))
          .thenAnswer((invocation) => MockResponseFuture.value(false));
      when(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.value(GetMetadataResponse()),
      );
      
      when(() => localPersistence.getGeofencePolygons()).thenReturn(polygons);

      final res = await repo.getUpdatedGeofences();
      expect(res.getRight(), isA<Set<DropezyPolygon>>());

      verify(() => localPersistence.shouldRefresh(any())).called(1);
      verify(() => localPersistence.getGeofencePolygons()).called(1);
    });

    test('should return a Failure '
    'when getUpdatedGeofences() is called '
    'and but an error is thrown while fetching DarkStoreMetaData', () async {
      
      when(() => discoveryServiceClient.getMetadata(GetMetadataRequest()))
          .thenAnswer(
        (invocation) => MockResponseFuture.error(Exception()),
      );
      
      final res = await repo.getUpdatedGeofences();
      expect(res.getLeft(), isA<Failure>());

      verifyNever(() => localPersistence.shouldRefresh(any()));
      verifyNever(() => localPersistence.getGeofencePolygons());
    });
  });
}

List<DropezyLatLng> makeList(List<num> coords) {
  final size = coords.length ~/ 2;

  final list = <DropezyLatLng>[];
  for (var i = 0; i < size; ++i) {
    list.add(
      DropezyLatLng(
        coords[i + i].toDouble(),
        coords[i + i + 1].toDouble(),
      ),
    );
  }
  return list;
}

DropezyPolygon makePolygon(
  MakeListArg makeList,
  List<num> coords,
) {
  return DropezyPolygon(
      id: 'Dummy Polygon',
      points: makeList(coords),
      name: 'Dummy Name',
      storeId: 'Dummy Store Id',);
}

typedef MakeListArg = List<DropezyLatLng> Function(List<num> coords);
