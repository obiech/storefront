import 'package:flutter_test/flutter_test.dart';

import 'package:storefront_app/core/services/geofence/geofence_repository.dart';
import 'package:storefront_app/core/services/geofence/i_geofence_repository.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_latlng.dart';
import 'package:storefront_app/core/services/geofence/models/dropezy_polygon.dart';

void main() {
  late IGeofenceRepository repo;

  setUp(() {
    repo = GeofenceRepository();
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
  );

  final DropezyPolygon emptyPolygon = DropezyPolygon(
    id: 'empty polygon',
    points: [],
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
  return DropezyPolygon(id: 'Dummy Polygon', points: makeList(coords));
}

typedef MakeListArg = List<DropezyLatLng> Function(List<num> coords);
