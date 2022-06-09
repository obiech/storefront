import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../mocks.dart';

void main() {
  late ISearchLocationRepository searchRepository;
  late SearchLocationBloc searchLocationBloc;

  const query = 'Lebak Bulus';
  const placeId = 'placeId';

  setUp(() {
    searchRepository = MockSearchLocationRespository();
    searchLocationBloc = SearchLocationBloc(searchRepository);
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
}
