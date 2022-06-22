import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../mocks.dart';

void main() {
  late ISearchLocationRepository searchRepository;
  late DropezyGeolocator geolocator;
  late SearchLocationBloc searchLocationBloc;

  const query = 'Lebak Bulus';
  const placeId = 'placeId';
  const latLng = LatLng(-6.1754463, 106.8377065);
  final position = Position(
    longitude: latLng.longitude,
    latitude: latLng.latitude,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  setUp(() {
    searchRepository = MockSearchLocationRespository();
    geolocator = MockDropezyGeolocator();
    searchLocationBloc = SearchLocationBloc(searchRepository, geolocator);

    when(() => geolocator.isLocationServiceEnabled())
        .thenAnswer((_) async => right(true));
  });

  test('initial state should be SearchLocationInitial', () {
    expect(searchLocationBloc.state, const SearchLocationInitial());
  });

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit SearchLocationInitial '
    'when QueryDeleted event is added',
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const QueryDeleted()),
    expect: () => [
      const SearchLocationInitial(),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit SearchLocationLoadedEmpty '
    'when QueryChanged event is added '
    'and repository return empty results',
    setUp: () {
      when(() => searchRepository.searchLocation('query'))
          .thenAnswer((_) async => right([]));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const QueryChanged('query')),
    expect: () => [
      const SearchLocationLoading(),
      const SearchLocationLoadedEmpty(),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit SearchLocationLoaded '
    'when QueryChanged event is added '
    'and repository return search results',
    setUp: () {
      when(() => searchRepository.searchLocation(query))
          .thenAnswer((_) async => right(placesResultList));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const QueryChanged(query)),
    expect: () => [
      const SearchLocationLoading(),
      SearchLocationLoaded(placesResultList),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit SearchLocationError '
    'when QueryChanged event is added '
    'and repository return failure',
    setUp: () {
      when(() => searchRepository.searchLocation(query))
          .thenAnswer((_) async => left(Failure('Error!')));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const QueryChanged(query)),
    expect: () => [
      const SearchLocationLoading(),
      const SearchLocationError('Error!'),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit LocationSelectSuccess '
    'when LocationSelected event is added '
    'and repository return address details',
    setUp: () {
      when(() => searchRepository.getLocationDetail(placeId))
          .thenAnswer((_) async => right(placeDetails));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const LocationSelected(placeId)),
    expect: () => [
      const SearchLocationLoading(),
      LocationSelectSuccess(placeDetails),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit LocationSelectError '
    'when LocationSelected event is added '
    'and repository return failure',
    setUp: () {
      when(() => searchRepository.getLocationDetail(placeId))
          .thenAnswer((_) async => left(Failure('Error!')));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const LocationSelected(placeId)),
    expect: () => [
      const SearchLocationLoading(),
      const LocationSelectError('Error!'),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit LocationSelectSuccess '
    'when UseCurrentLocation event is added '
    'and repository return address details',
    setUp: () {
      when(() => geolocator.getCurrentPosition())
          .thenAnswer((_) async => position);
      when(() => searchRepository.getCurrentLocation(latLng))
          .thenAnswer((_) async => right(placeDetails));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const UseCurrentLocation()),
    expect: () => [
      const SearchLocationLoading(),
      LocationSelectSuccess(placeDetails),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit LocationSelectError '
    'when LocationSelected event is added '
    'and repository return failure',
    setUp: () {
      when(() => geolocator.getCurrentPosition())
          .thenAnswer((_) async => position);
      when(() => searchRepository.getCurrentLocation(latLng))
          .thenAnswer((_) async => left(Failure('Error!')));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const UseCurrentLocation()),
    expect: () => [
      const SearchLocationLoading(),
      const LocationSelectError('Error!'),
      const SearchLocationInitial(),
    ],
  );

  const locationErrorMessage = 'Location services are disabled.';

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit LocationSelectError '
    'when LocationSelected event is added '
    'and location service is disabled',
    setUp: () {
      when(() => geolocator.isLocationServiceEnabled())
          .thenAnswer((_) async => left(Failure(locationErrorMessage)));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const UseCurrentLocation()),
    expect: () => [
      const SearchLocationLoading(),
      const LocationSelectError(locationErrorMessage),
      const SearchLocationInitial(),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit LocationSelectError '
    'when ViewMap event is added '
    'and location service is disabled',
    setUp: () {
      when(() => geolocator.isLocationServiceEnabled())
          .thenAnswer((_) async => left(Failure(locationErrorMessage)));
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const ViewMap()),
    expect: () => [
      const SearchLocationLoading(),
      const LocationSelectError(locationErrorMessage),
      const SearchLocationInitial(),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit OnViewMap with latlng '
    'when ViewMap event is added '
    'and location service is enabled',
    setUp: () {
      when(() => geolocator.getCurrentPosition())
          .thenAnswer((_) async => position);
    },
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(const ViewMap()),
    expect: () => [
      const SearchLocationLoading(),
      const OnViewMap(latLng),
      const SearchLocationInitial(),
    ],
  );

  blocTest<SearchLocationBloc, SearchLocationState>(
    'should emit OnRequestPermission '
    'when RequestPermission event is added ',
    build: () => searchLocationBloc,
    act: (bloc) => bloc.add(
      const RequestLocationPermission(SearchLocationAction.useCurrentLocation),
    ),
    expect: () => [
      const SearchLocationLoading(),
      const OnRequestPermission(SearchLocationAction.useCurrentLocation),
      const SearchLocationInitial(),
    ],
  );
}
