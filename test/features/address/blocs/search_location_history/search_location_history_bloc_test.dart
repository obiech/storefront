import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/blocs/search_location_history/search_location_history_bloc.dart';
import 'package:storefront_app/features/address/domain/repository/i_search_location_history_repository.dart';

import '../../mocks.dart';

void main() {
  late ISearchLocationHistoryRepository repository;
  late SearchLocationHistoryBloc bloc;

  const searchHistories = [
    'search1',
    'search2',
    'search3',
  ];

  setUp(() {
    repository = MockSearchLocationHistoryRepository();
    bloc = SearchLocationHistoryBloc(repository);
  });

  blocTest<SearchLocationHistoryBloc, SearchLocationHistoryState>(
    'should emit SearchLocationHistoryLoaded '
    'when LoadSearchHistory event is added '
    'and repository returns list',
    setUp: () {
      when(() => repository.getSearchHistory())
          .thenAnswer((_) async => right(searchHistories));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadSearchLocationHistory()),
    expect: () => [
      const SearchLocationHistoryLoading(),
      const SearchLocationHistoryLoaded(searchHistories),
    ],
    verify: (_) {
      verify(() => repository.getSearchHistory()).called(1);
    },
  );

  blocTest<SearchLocationHistoryBloc, SearchLocationHistoryState>(
    'should emit SearchLocationHistoryLoadedEmpty '
    'when LoadSearchHistory event is added '
    'and repository returns empty list',
    setUp: () {
      when(() => repository.getSearchHistory())
          .thenAnswer((_) async => right([]));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadSearchLocationHistory()),
    expect: () => [
      const SearchLocationHistoryLoading(),
      const SearchLocationHistoryLoadedEmpty(),
    ],
    verify: (_) {
      verify(() => repository.getSearchHistory()).called(1);
    },
  );

  blocTest<SearchLocationHistoryBloc, SearchLocationHistoryState>(
    'should emit SearchLocationHistoryError '
    'when LoadSearchHistory event is added '
    'and repository returns failure',
    setUp: () {
      when(() => repository.getSearchHistory())
          .thenAnswer((_) async => left(Failure('Error!')));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadSearchLocationHistory()),
    expect: () => [
      const SearchLocationHistoryLoading(),
      const SearchLocationHistoryError('Error!'),
    ],
    verify: (_) {
      verify(() => repository.getSearchHistory()).called(1);
    },
  );
}
